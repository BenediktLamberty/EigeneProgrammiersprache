import lexer
from environment import Env
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple

EXPR_EVAL_LEFT = "$s0"
EXPR_EVAL_RIGHT = "$s1"

class NullException(Exception):
    pass

class ASTError(Exception):
    pass


@dataclass
class Stmt(ABC):
    def generate_code():
        pass

@dataclass
class Program(Stmt):
    body: List[Stmt]
    def generate_code(self, env: Env) -> str:
        code = """
# Program:
        .text
        """
        for stmt in self.body:
            code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        code += env.generate_data()
        return code

@dataclass
class Expr(Stmt, ABC):
    def generate_code():
        pass

@dataclass
class VarDecl(Stmt):
    const: bool
    identifier: str
    value: Expr
    def generate_code(self, env: Env) -> str:
        if isinstance(self.value, NullLiteral):
            env.deklGlobalVar(self.identifier, None)
            return f"""
        # Var {self.identifier} decl in .data
            """
        elif isinstance(self.value, NumericLiteral):
            env.deklGlobalVar(self.identifier, self.value.value)
            return f"""
        # Var {self.identifier} decl in .data with value {self.value.value}
            """
        else:
            env.deklGlobalVar(self.identifier, None)
            code = self.value.generate_code(env)
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # init variable {self.identifier}
        sw {EXPR_EVAL_LEFT}, {self.identifier}
            """
            return code


@dataclass
class FunctionDeclaration(Stmt):
    name: str
    parameters: List[str]
    body: List[Stmt]

@dataclass
class Return(Stmt):
    return_value: Expr

@dataclass
class If(Stmt):
    condition: Expr
    body: List[Stmt]
    def generate_code(self, env: Env, goto_exit: int) -> str:
        goto = env.getGoto()
        code = self.condition.generate_code(env)
        code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq {EXPR_EVAL_LEFT}, $zero, ifBlockSkip{goto}
        """
        for stmt in self.body:
            code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        code += f"""
        b exitIf{goto_exit}  # goto if end
ifBlockSkip{goto}:
        """
        return code
        

@dataclass
class IfElifElse(Stmt):
    cases: List[If]
    def generate_code(self, env: Env) -> str:
        goto = env.getGoto()
        code = """
# If Elif Else block
        """
        for case in self.cases:
            code += case.generate_code(env, goto)
        code += f"""
exitIf{goto}:
        """
        return code
            

@dataclass
class While(Stmt):
    condition: Expr
    has_do: bool
    body: List[Stmt]
    def generate_code(self, env: Env) -> str:
        code = ""
        goto = env.getGoto()
        condition_code = self.condition.generate_code(env)
        body_code = """
        # Body of While Loop
        """
        for stmt in self.body:
            body_code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                body_code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        if self.has_do:
            code += f"""
startDoWhile{goto}:
            """
            code += body_code + condition_code
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        bne {EXPR_EVAL_LEFT}, $zero, startDoWhile{goto}
            """
        else:
            code += f"""
whileCondition{goto}:
            """
            code += condition_code
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq {EXPR_EVAL_LEFT}, $zero, exitWhile{goto}
            """
            code += body_code
            code += f"""
        b whileCondition{goto}  # looping while
exitWhile{goto}:
            """
        return code
        

@dataclass
class Break(Stmt):
    pass

@dataclass
class BinaryExpr(Expr):
    left: Expr
    right: Expr
    operator: str
    def generate_code(self, env: Env) -> str:
        code = self.left.generate_code(env)
        code += self.right.generate_code(env)

        code += f"""
        lw {EXPR_EVAL_RIGHT}, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw {EXPR_EVAL_LEFT}, ($sp)
            """
        if self.operator == "+":
            code += f"""
        add {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # + operation
                """
        elif self.operator == "-":
            code += f"""
        sub {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # - operation
            """
        elif self.operator == "*":
            code += f"""
        mul {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # * operation
            """
        elif self.operator == "/":
            code += f"""
        div {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # int / operation !!!!!!!!!!!!!!!!!!!!
            """
        elif self.operator == "&&":
            goto = env.getGoto()
            code += f"""
        mul {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # && logic operation
        beq {EXPR_EVAL_LEFT}, $zero, exitLogic{goto}
        li {EXPR_EVAL_LEFT}, 1
exitLogic{goto}:
            """
        elif self.operator == "||":
            goto = env.getGoto()
            code += f"""
        bne {EXPR_EVAL_LEFT}, $zero, doOr{goto}
        bne {EXPR_EVAL_RIGHT}, $zero, doOr{goto}
        li {EXPR_EVAL_LEFT}, 0
        b exitLogic{goto}
doOr{goto}:
        li {EXPR_EVAL_LEFT}, 1
exitLogic{goto}:
            """
        elif self.operator == "mod":
            code += f"""
        div {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}  # mod operation
        mfhi {EXPR_EVAL_LEFT}
            """
        else:
            raise ASTError("BinaryExpr has invalid operator")
        
        code += f"""
        sw {EXPR_EVAL_LEFT}, ($sp)
            """
        
        return code
    
@dataclass
class UnaryExpr(Expr):
    arg: Expr
    operator: str
    def generate_code(self, env: Env) -> str:
        code = self.arg.generate_code(env)
        if self.operator == "-":
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # Unary - operation
        neg {EXPR_EVAL_LEFT}, {EXPR_EVAL_LEFT}
        sw {EXPR_EVAL_LEFT}, ($sp)
            """
        elif self.operator in ["!", "~"]:
            goto = env.getGoto()
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # Unary ! operation
        beq $zero, {EXPR_EVAL_LEFT}, negate{goto}
        li {EXPR_EVAL_LEFT}, 0
        b exitNegate{goto}
negate{goto}:
        li {EXPR_EVAL_LEFT}, 1
exitNegate{goto}:
            """
        else:
            raise ASTError("UnaryExpr has invalid operator")
        return code

@dataclass
class Identifier(Expr):
    symbol: str
    def generate_code(self, env: Env) -> str:
        env.useGlobalVar(self.symbol)
        return f"""
        lw {EXPR_EVAL_LEFT}, {self.symbol}  # Identifier {self.symbol} to stack
        addi $sp, $sp, -4
        sw {EXPR_EVAL_LEFT}, ($sp)
        """

@dataclass
class NumericLiteral(Expr):
    value: float
    def generate_code(self, env: Env) -> str:
        return f"""
        li {EXPR_EVAL_LEFT}, {self.value}  # Num {self.value} to stack
        addi $sp, $sp, -4
        sw {EXPR_EVAL_LEFT}, ($sp)
        """

@dataclass
class String(Expr):
    value: str

@dataclass
class NullLiteral(Expr):
    def generate_code(self, env: Env):
        raise NullException("Null Literal can not be evaluated")

@dataclass
class AssignmentExpr(Expr):
    assigne: Expr
    value: Expr
    def generate_code(self, env: Env) -> str:
        code = self.value.generate_code(env)
        if isinstance(self.assigne, Identifier):
            env.useGlobalVar(self.assigne.symbol)
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # assign value to var {self.assigne.symbol}
        sw {EXPR_EVAL_LEFT}, {self.assigne.symbol}
            """
        else:
            raise ASTError("Unsupported expr as assigne")
        return code

@dataclass
class Property(Expr):
    arg: str
    value: Expr

@dataclass
class ObjectLiteral(Expr):
    properties: List[Property]

@dataclass
class CallExpr(Expr):
    args: List[Expr]
    caller: Expr

@dataclass
class MemberExpr(Expr):
    obj: Expr
    property: Expr
    computed: bool

@dataclass
class Comparator(Expr):
    left: Expr
    right: Expr
    operator: str
    def generate_code(self, env: Env) -> str:
        code = self.left.generate_code(env)
        code += self.right.generate_code(env)
        goto = env.getGoto()
        code += f"""
        lw {EXPR_EVAL_RIGHT}, ($sp)  # comparison
        addi $sp, $sp, 4
        lw {EXPR_EVAL_LEFT}, ($sp)
            """
        if self.operator == "<":
            code += f"""
        blt {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator <
            """
        elif self.operator == ">":
             code += f"""
        bgt {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator >
            """
        elif self.operator == "<=":
             code += f"""
        ble {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator <=
            """
        elif self.operator == ">=":
             code += f"""
        bge {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator >=
            """
        elif self.operator == "==":
             code += f"""
        beq {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator ==
            """
        elif self.operator == "!=":
             code += f"""
        bne {EXPR_EVAL_LEFT}, {EXPR_EVAL_RIGHT}, conTrue{goto}  # comparator !=
            """
        else:
            raise ASTError("invalid comparator")
        code += f"""
        li {EXPR_EVAL_LEFT}, 0  # comparator descision
        b conExit{goto}
conTrue{goto}:
        li {EXPR_EVAL_LEFT}, 1
conExit{goto}:
        sw {EXPR_EVAL_LEFT}, ($sp)
            """
        return code

@dataclass
class For(Stmt):
    start: NumericLiteral
    end: NumericLiteral
    step: NumericLiteral
    body: List[Stmt]

@dataclass
class Output(Stmt):
    out: Expr
    def generate_code(self, env: Env):
        code = self.out.generate_code(env)
        code += """
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        """
        return code