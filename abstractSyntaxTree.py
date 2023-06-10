import lexer
from environment import Env
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple
import random as rnd
import string

EXPR_EVAL_LEFT = "$s0"
EXPR_EVAL_RIGHT = "$s1"
TEMP_PTR = "$t2"
SAVE_PTR = "$s2"
NOT_SAVE = "$s3"
FUNC_PTR = "$s4"

TEMP = "$t0"
TEMP_ITER = "$t1"

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
        # setting up first $fp
        move $fp, $sp
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
        if env.in_func != None:
        #in func
            env.deklLocalVar(self.identifier, self.const)
            code = """
        # Decl local Var
            """
            if not isinstance(self.value, NullLiteral):
                code += self.value.generate_code(env)
                code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # init variable {self.identifier}
        addi $sp, $sp, 4
        sw {EXPR_EVAL_LEFT}, {env.getOffsetOfLocalVar(self.identifier)}($fp)
            """
            return code

        # outside func
        if isinstance(self.value, NullLiteral):
            env.deklGlobalVar(self.identifier, None, self.const)
            return f"""
        # Var {self.identifier} decl in .data
            """
        elif isinstance(self.value, NumericLiteral):
            env.deklGlobalVar(self.identifier, self.value.value, self.const)
            return f"""
        # Var {self.identifier} decl in .data with value {self.value.value}
            """
        else:
            env.deklGlobalVar(self.identifier, None, self.const)
            code = self.value.generate_code(env)
            code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # init variable {self.identifier}
        addi $sp, $sp, 4
        sw {EXPR_EVAL_LEFT}, {self.identifier}
            """
            return code


@dataclass
class FunctionDeclaration(Expr):
    name: str
    parameters: List[str]
    body: List[Stmt]
    def generate_code(self, env: Env) -> str:
        self.name = "".join(rnd.choice(string.ascii_letters) for _ in range(10))
        env.startFunc(self.name, self.parameters)
        # body
        body_code = f"""
# Function Body of {self.name}:
        """
        for stmt in self.body:
            body_code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                body_code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        # pre
        pre_code = f"""
        b {self.name}End
{self.name}:
# Function Preamble of {self.name}:
        # data allocation {env.max_offset} vars:
        addi $sp, $sp, -{env.max_offset * 4}
        # save $ra
        addi $sp, $sp, -4
        sw $ra, ($sp)
        # save $ss
        """
        for i in range(8):
            pre_code += f"""
        addi $sp, $sp, -4
        sw $s{7-i}, ($sp)
            """
        pre_code += f"""
        # $fp = $sp
        move $fp, $sp
        """
        # post
        code = pre_code + body_code
        code += f"""
        # End of func {self.name}
{self.name}Return:
        # $ss restore
        """
        for i in range(8):
            code += f"""
        lw $s{i}, {i * 4}($fp)
            """
        code += f"""
        # $ra restore
        lw $ra, 32($fp)
        # $sp return
        addi $sp, $sp, {8*4 + 4 + env.max_offset*4 + len(self.parameters)*4}
        # restore $fp
        lw $fp, ($sp)
        # accord for func ptr
        addi $sp, $sp, 4
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
{self.name}End:
        """
        # Args ersetzen
        for i in range(len(self.parameters)):
            code = code.replace(f"?{self.parameters[i]}", f"{8*4 + 4 + env.max_offset*4 + i*4}($fp)")
        code += f"""
        # push func pointer
        la {TEMP}, {self.name}
        addi $sp, $sp, -4
        sw {TEMP}, ($sp)
        """
        env.endFunc()
        return code

        

@dataclass
class Return(Stmt):
    return_value: Expr
    def generate_code(self, env: Env) -> str:
        return self.return_value.generate_code(env) + f"""
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b {env.in_func}Return
        """
    
@dataclass
class Do(Stmt):
    body: List[Stmt]
    def generate_code(self, env: Env) -> str:
        env.increase_depth()
        code = """
# block of code
        """
        for stmt in self.body:
            code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        env.decrease_depth()
        return code

@dataclass
class If(Stmt):
    condition: Expr
    body: List[Stmt]
    def generate_code(self, env: Env, goto_exit: int) -> str:
        env.increase_depth()
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
        env.decrease_depth()
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
        env.increase_depth()
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
            env.decrease_depth()
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
        elif self.operator == "push":
            goto = env.getGoto()
            code += f"""
        # malloc
        li $a0, 8
	    li $v0, 9 
	    syscall
        # save new elem
        sw {EXPR_EVAL_RIGHT}, ($v0)
        sw $zero, 4($v0)
        # push to list
        # traverce list
        beq {EXPR_EVAL_LEFT}, $zero, skip{goto}
        move {SAVE_PTR}, {EXPR_EVAL_LEFT}
travStart{goto}:
        lw {TEMP_PTR}, 4({SAVE_PTR})
        beq {TEMP_PTR}, $zero, travEnd{goto}
        move {SAVE_PTR}, {TEMP_PTR}
        b travStart{goto}
travEnd{goto}:
        # link
        sw $v0, 4({SAVE_PTR})
        b skipSkip{goto}
skip{goto}:
        addi $sp, $sp, -4
        sw $v0, ($sp)
        """
            code += AssignmentExpr(assigne=self.left, value=Nothing()).generate_code(env)
            code += f"""
        move {EXPR_EVAL_LEFT}, $v0 
        addi $sp, $sp, 4
skipSkip{goto}:
            """
        elif self.operator == "add":
            goto = env.getGoto()
            code += f"""
        # adding two lists
        # case left is empty
        bne {EXPR_EVAL_LEFT}, $zero, normalTrav{goto}
            """
            # case: First list is empty => Nullpointer!
            code += AssignmentExpr(assigne=self.left, value=UnaryExpr(arg=self.right, operator="copy")).generate_code(env)
            # case: First list with elems
            code += f"""
        b addEnd{goto}
normalTrav{goto}:
        move {NOT_SAVE}, {EXPR_EVAL_LEFT}
        """
            code += UnaryExpr(arg=self.right, operator="copy").generate_code(env)
            code += f"""
        # travList
        move {EXPR_EVAL_LEFT}, {NOT_SAVE}
        move {SAVE_PTR}, {EXPR_EVAL_LEFT}
travStart{goto}:
        lw {TEMP_PTR}, 4({SAVE_PTR})
        beq {TEMP_PTR}, $zero, travEnd{goto}
        move {SAVE_PTR}, {TEMP_PTR}
        b travStart{goto}
travEnd{goto}:
        # link two lists
        lw {TEMP}, ($sp)
        addi $sp, $sp, 4
        sw {TEMP}, 4({SAVE_PTR})
addEnd{goto}:
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
        elif self.operator == "copy":
            goto = env.getGoto()
            org_list_ptr = EXPR_EVAL_RIGHT
            temp_org_ptr = TEMP_PTR
            new_list_ptr = SAVE_PTR
            temp_value = TEMP
            code += f"""
        # load org list pointer
        lw {org_list_ptr}, ($sp)
        addi $sp, $sp, 4
        # end if nullpointer
        bne {org_list_ptr}, $zero, skipPushNull{goto}
        addi $sp, $sp, -4
        sw $zero, ($sp)
        b endCopy{goto}
skipPushNull{goto}:
        # first malloc
        li $a0, 8
	    li $v0, 9 
	    syscall
        # saving new list ptr and pushing on stack
        move {new_list_ptr}, $v0
        addi $sp, $sp, -4
        sw $v0, ($sp)
        # trav org list and copy to new
travStart{goto}:
        # check if at end
        lw {temp_org_ptr}, 4({org_list_ptr})
        beq {temp_org_ptr}, $zero, travEnd{goto}
        # copy value
        lw {temp_value}, ({org_list_ptr})
        sw {temp_value}, ({new_list_ptr})
        # advance org ptr
        move {org_list_ptr}, {temp_org_ptr}
        # malloc
        li $a0, 8
	    li $v0, 9 
	    syscall
        # save new pointer in memory and reg
        sw $v0, 4({new_list_ptr})
        move {new_list_ptr}, $v0
        b travStart{goto}

travEnd{goto}:
        # final elem copy
        lw {temp_value}, ({org_list_ptr})
        sw {temp_value}, ({new_list_ptr})
        sw $zero, 4({new_list_ptr})

endCopy{goto}:
            """
        elif self.operator == "len":
            goto = env.getGoto()
            code += f"""
        move {TEMP}, $zero
        lw {SAVE_PTR}, ($sp)
        addi $sp, $sp, 4
        beq {SAVE_PTR}, $zero, travEnd{goto}
travStart{goto}:
        addi {TEMP}, {TEMP}, 1
        lw {TEMP_PTR}, 4({SAVE_PTR})
        beq {TEMP_PTR}, $zero, travEnd{goto}
        move {SAVE_PTR}, {TEMP_PTR}
        b travStart{goto}
travEnd{goto}:
        addi $sp, $sp, -4
        sw {TEMP} ($sp)
            """
        elif self.operator == "pop":
            goto = env.getGoto()
            list_ptr = EXPR_EVAL_RIGHT
            last_ptr = SAVE_PTR
            temp_ptr = TEMP_PTR
            pop_value = TEMP
            code += f"""
        lw {list_ptr}, ($sp)
        addi $sp, $sp, 4
        # travList
travStart{goto}:
        lw {temp_ptr}, 4({list_ptr})
        beq {temp_ptr}, $zero, travEnd{goto}
        move {last_ptr}, {list_ptr}
        move {list_ptr}, {temp_ptr}
        b travStart{goto}
travEnd{goto}:
        # poped value on stack
        lw {pop_value}, ({list_ptr})
        addi $sp, $sp, -4
        sw {pop_value}, ($sp)
        # unlink list
        sw $zero, 4({last_ptr})
            """
        else:
            raise ASTError("UnaryExpr has invalid operator")
        return code

@dataclass
class Identifier(Expr):
    symbol: str
    def generate_code(self, env: Env) -> str:
        code = ""
        var = env.useVar(self.symbol)
        if var == None:
            env.useGlobalVar(self.symbol)
            code += f"""
        lw {EXPR_EVAL_LEFT}, {self.symbol}  # Identifier {self.symbol} to stack
            """
        else:
            code += f"""
        lw {EXPR_EVAL_LEFT}, {var}  # Identifier {self.symbol} to stack
            """
        return code + f"""
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
            env.checkConst(self.assigne.symbol)
            var = env.useVar(self.assigne.symbol)
            if var == None:
                env.useGlobalVar(self.assigne.symbol)
                code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # assign value to var {self.assigne.symbol}
        sw {EXPR_EVAL_LEFT}, {self.assigne.symbol}
                """
            else:
                code += f"""
        lw {EXPR_EVAL_LEFT}, ($sp)  # assign value to var {self.assigne.symbol}
        sw {EXPR_EVAL_LEFT}, {var}
                """
        elif isinstance(self.assigne, MemberExpr) and isinstance(self.assigne.obj, Identifier):
            env.checkConst(self.assigne.obj.symbol)
            var = env.useVar(self.assigne.obj.symbol)
            code += self.assigne.generate_code(env, is_left=True)
            code += f"""
        # store value at ptr
        lw {TEMP_PTR}, ($sp)
        addi $sp, $sp, 4
        lw {TEMP}, ($sp)
        sw {TEMP}, ({TEMP_PTR})
                """
        else:
            #raise ASTError("Unsupported expr as assigne")
            pass
        return code

@dataclass
class Property(Expr):
    arg: str
    value: Expr

@dataclass
class ObjectLiteral(Expr):
    properties: List[Property]

@dataclass
class LinkedList(Expr):
    elements: List[Expr]
    def generate_code(self, env: Env) -> str:
        if len(self.elements) == 0:
            return f"""
# list decl
        # zero pointer to stack
        addi $sp, $sp, -4
        sw $zero, ($sp)
            """
        else:
            goto = env.getGoto()
            code = """
# list decl and init
            """
            for elem in reversed(self.elements):
                code += elem.generate_code(env)
            code += f"""
        # first malloc
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # list pointer to reg
        move {TEMP_PTR}, $v0
        move {SAVE_PTR}, $v0
        
        # fill list
        li {TEMP_ITER}, {len(self.elements)-1}
startFill{goto}:
        ble {TEMP_ITER}, $zero, endFill{goto}
        addi {TEMP_ITER}, {TEMP_ITER}, -1
        # save elem
        lw {TEMP}, ($sp)
        addi $sp, $sp, 4
        sw {TEMP}, ({TEMP_PTR})
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link list
        sw $v0, 4({TEMP_PTR})
        move {TEMP_PTR}, $v0
        b startFill{goto}
endFill{goto}:  
        # save elem
        lw {TEMP}, ($sp)
        addi $sp, $sp, 4
        sw {TEMP}, ({TEMP_PTR})
        # null pointer
        sw $zero, 4({TEMP_PTR}) 
        # list ptr to stack
        addi $sp, $sp, -4
        sw {SAVE_PTR}, ($sp)
            """
            return code

        

@dataclass
class CallExpr(Expr):
    args: List[Expr]
    caller: Expr
    def generate_code(self, env: Env) -> str:
        code = self.caller.generate_code(env)
        code += f"""
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        """
        for i in range(len(self.args)):
            code += f"""
        # push arg {len(self.args) - i}
            """
            code += self.args[len(self.args) - 1 - i].generate_code(env)
        code += f"""
        # final call
        lw {FUNC_PTR}, {len(self.args)*4 + 4}($sp)
        jalr {FUNC_PTR}
        """
        return code
                



@dataclass
class MemberExpr(Expr):
    obj: Expr
    property: Expr
    computed: bool
    def generate_code(self, env: Env, is_left=False) -> str:
        if self.computed:
            goto = env.getGoto()
            code = """
        #list member expr
            """
            code += self.obj.generate_code(env)
            code += self.property.generate_code(env)
            code += f"""
        lw {TEMP_ITER}, ($sp)
        addi $sp, $sp, 4
        lw {TEMP_PTR}, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav{goto}:
        ble {TEMP_ITER}, $zero, endTrav{goto}
        addi {TEMP_ITER}, {TEMP_ITER}, -1
        lw {TEMP_PTR}, 4({TEMP_PTR})
        b startTrav{goto}
endTrav{goto}:
            """
            if is_left:
                code += f"""
        # push pointer to stack
        addi $sp, $sp, -4
        sw {TEMP_PTR}, ($sp)
                """
            else:
                code += f"""
        # push value to stack
        lw {TEMP}, ({TEMP_PTR})
        addi $sp, $sp, -4
        sw {TEMP}, ($sp)
                """
            return code
        else:
            raise Exception("Not implemented yet")

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
        elif self.operator == "in":
            code += f"""
        # comp in
        beq {EXPR_EVAL_RIGHT}, $zero, conFalse{goto}
        move {SAVE_PTR}, {EXPR_EVAL_RIGHT}
travStart{goto}:
        lw  {TEMP}, ({SAVE_PTR})
        beq {EXPR_EVAL_LEFT}, {TEMP}, conTrue{goto}
        lw {TEMP_PTR}, 4({SAVE_PTR})
        beq {TEMP_PTR}, $zero, travEnd{goto}
        move {SAVE_PTR}, {TEMP_PTR}
        b travStart{goto}
travEnd{goto}:
            """
        elif self.operator == "equals":
            ptr_left = EXPR_EVAL_LEFT
            ptr_right = EXPR_EVAL_RIGHT
            temp_ptr_left = SAVE_PTR
            temp_ptr_right = TEMP_PTR
            value_left = TEMP
            value_right = NOT_SAVE
            code += f"""
        # comp equals
        beq {ptr_left}, {ptr_right}, conTrue{goto}
        beq {ptr_left}, $zero, conFalse{goto}
        beq {ptr_right}, $zero, conFalse{goto}
travStart{goto}:
        # compare elems
        lw {value_left}, ({ptr_left})
        lw {value_right}, ({ptr_right})
        bne {value_left}, {value_right}, conFalse{goto}
        lw {temp_ptr_left}, 4({ptr_left})
        lw {temp_ptr_right}, 4({ptr_right})
        beq {temp_ptr_left}, $zero, travCompare{goto}
        beq {temp_ptr_right}, $zero, travCompare{goto}
        b skipCompare{goto}
travCompare{goto}:
        beq {temp_ptr_left}, {temp_ptr_right}, conTrue{goto}
        b conFalse{goto}
skipCompare{goto}:
        move {ptr_left}, {temp_ptr_left}
        move {ptr_right}, {temp_ptr_right}
        b travStart{goto}
            """
        else:
            raise ASTError("invalid comparator")
        code += f"""
conFalse{goto}:
        li {EXPR_EVAL_LEFT}, 0  # comparator descision
        b conExit{goto}
conTrue{goto}:
        li {EXPR_EVAL_LEFT}, 1
conExit{goto}:
        sw {EXPR_EVAL_LEFT}, ($sp)
            """
        return code

class ForEach(Stmt):
    pass
    

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
    
@dataclass
class Nothing(Expr):
    def generate_code(self, env: Env) -> str:
        return ""
    
@dataclass
class ForEach(Stmt):
    list_ptr: Expr
    ptr_var: Identifier
    idx_var: Identifier
    value_var: Identifier
    body: List[Stmt]
    def generate_code(self, env: Env) -> str:
        env.increase_depth()
        goto = env.getGoto()
        code = f"""
# for each loop
        # set ptr var:
{AssignmentExpr(assigne=self.ptr_var, value=self.list_ptr).generate_code(env)}
        addi $sp, $sp, 4
        # check for Null ptr
{self.ptr_var.generate_code(env)}
        lw {TEMP_PTR}, ($sp)
        addi $sp, $sp, 4
        beq {TEMP_PTR}, $zero, endForEach{goto}
forLoop{goto}:
{self.ptr_var.generate_code(env)}
        lw {TEMP}, ($sp)
        lw {TEMP}, ({TEMP})
        sw {TEMP}, ($sp)
{AssignmentExpr(assigne=self.value_var, value=Nothing()).generate_code(env)}
        addi $sp, $sp, 4    
        """
        for stmt in self.body:
            code += stmt.generate_code(env)
            if isinstance(stmt, Expr):
                code += """
        addi $sp, $sp, 4  # raising sp after expression
                """
        code += f"""
{self.ptr_var.generate_code(env)}
        lw {SAVE_PTR}, ($sp)
        addi $sp, $sp, 4
        lw {TEMP_PTR}, 4({SAVE_PTR})
        beq {TEMP_PTR}, $zero, endForEach{goto}
        addi $sp, $sp, -4
        sw {TEMP_PTR}, ($sp)
{AssignmentExpr(assigne=self.ptr_var, value=Nothing()).generate_code(env)}
        addi $sp, $sp, 4
{AssignmentExpr(assigne=self.idx_var, value=BinaryExpr(self.idx_var, NumericLiteral(1), "+")).generate_code(env)}
        addi $sp, $sp, 4
        b forLoop{goto}
endForEach{goto}:
        """
        env.decrease_depth()
        return code



