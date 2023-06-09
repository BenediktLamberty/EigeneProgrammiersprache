from abstractSyntaxTree import * #Cleaned up the imports by setting it to input everything
from lexer import tokenize, Token, TokenType, TokenError
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple
import random as rnd
import string


class Parser:
    tokens: List[Token] = []

    def eat(self) -> Token:
        return self.tokens.pop(0)
    
    def expect(self, type: TokenType, err: str) -> Token:
        prev = self.tokens.pop(0)
        if prev ==  None or prev.type != type :
            raise TokenError(f"Error at >{prev}< \n{err}\nExpecting: {type}")
        return prev
    
    def expect_multiple(self, types: List[TokenType], err: str) -> List[Token]:
        prevs = []
        for i in range(len(types)):
            prevs.append(self.expect(types[i], err))
        return prevs
    
    def expect_options(self, types: List[List[TokenType]], err: str) -> List[Token]:
        for option in types:
            if option ==  [i.type for i in self.tokens[0:len(option)]]:
                preves = []
                for i in range(len(option)):
                    preves.append(self.eat())
                return preves
        raise TokenError(f"Error at >{preves}< \n{err}\nExpecting: {types}")
    
    def optional(self, type: TokenType):
        if self.tokens[0].type == type:
            self.eat()
        
    def produce_AST(self, sourceCode: str) -> Program:
        self.tokens = tokenize(sourceCode) 

        program = Program([]) # ???

        while self.tokens[0].type != TokenType.EOF:
            program.body.append(self.parse_stmt())

        return program
    
    def parse_stmt(self) -> Stmt:
        if self.tokens[0].type in [TokenType.LET, TokenType.CONST]:
            return self.parse_var_decl()
        elif ([token.type for token in self.tokens[0:3]] 
            == [TokenType.IDENTIFYER, TokenType.COLON, TokenType.EQUALS]):
            return self.parse_var_decl(has_let=False)
        elif self.tokens[0].type == TokenType.FUNC:
            return self.parse_func_declaration()
        elif self.tokens[0].type == TokenType.IF:
            return self.parse_ifElifElse_block()
        elif self.tokens[0].type in [TokenType.WHILE, TokenType.DO]:
            return self.parse_while_loop()
        elif self.tokens[0].type == TokenType.FOR:
            return self.parse_for_loop()
        elif self.tokens[0].type == TokenType.RETURN:
            return self.parse_return()
        elif self.tokens[0].type == TokenType.BREAK:
            return self.parse_break()
        elif self.tokens[0].type == TokenType.OUT:
            return self.parse_output()
        else:
            return self.parse_expr()
        
    def parse_output(self) -> Stmt:
        self.expect(TokenType.OUT, "output misses out")
        self.optional(TokenType.OPEN_PAREN)
        out = self.parse_expr()
        self.optional(TokenType.CLOSE_PAREN)
        return Output(out)

        
    def parse_return(self) -> Stmt:
        self.expect(TokenType.RETURN, "Return missing return")
        return Return(self.parse_expr())
    
    def parse_break(self) -> Stmt:
        self.expect(TokenType.BREAK, "Break missing break")
        return Break()
        
    def parse_ifElifElse_block(self) -> Stmt:
        cases = []
        self.expect(TokenType.IF, "If Expected")
        if_condition = self.parse_expr()
        self.expect(TokenType.OPEN_BRACE, "Open Brace expected afer If")
        if_body = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
            if_body.append(self.parse_stmt())
        self.expect(TokenType.CLOSE_BRACE, "Closing brace expected at end of if body")
        cases.append(If(if_condition, if_body))
        while self.tokens[0].type == TokenType.ELIF:
            self.eat()
            elif_condition = self.parse_expr()
            self.expect(TokenType.OPEN_BRACE, "Open Brace expected after elif")
            elif_body = []
            while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
                elif_body.append(self.parse_stmt())
            self.expect(TokenType.CLOSE_BRACE, "Closing brace expected at end of elif body")
            cases.append(If(elif_condition, elif_body))
        if self.tokens[0].type == TokenType.ELSE:
            self.eat()
            else_condition = NumericLiteral(1)
            self.expect(TokenType.OPEN_BRACE, "Open Brace expected after else")
            else_body = []
            while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
                else_body.append(self.parse_stmt())
            self.expect(TokenType.CLOSE_BRACE, "Closing brace expected at end of else body")
            cases.append(If(else_condition, else_body))
        return IfElifElse(cases)
    
    def parse_while_loop(self) -> Stmt:
        has_do = False
        if self.tokens[0].type == TokenType.DO:
            self.expect_multiple([TokenType.DO, TokenType.COMMA, TokenType.THEN], "Do then expected in while loop")
            has_do = True
        self.expect(TokenType.WHILE, "While loop missing while")
        condition = self.parse_expr()
        self.expect(TokenType.OPEN_BRACE, "Expected open Brace afer While")
        body = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
            body.append(self.parse_stmt())
        self.expect(TokenType.CLOSE_BRACE, "Expected close brace at end of while loop")
        return While(condition, has_do, body)
    
    def parse_for_loop(self) -> Stmt:
        self.expect(TokenType.FOR, "For missing from For loop")
        # for each
        if self.tokens[0].type == TokenType.EACH:
            iterateable: Expr
            ptr_var: Identifier = Identifier(symbol="".join(rnd.choice(string.ascii_letters) for _ in range(10)))
            idx_var: Identifier = Identifier(symbol="".join(rnd.choice(string.ascii_letters) for _ in range(10)))
            value_var: Identifier
            body: List[Stmt] = []
            self.eat()
            value_var = Identifier(self.expect(TokenType.IDENTIFYER, "For Each needs ident").value)
            while self.tokens[0].type != TokenType.OPEN_BRACE:
                if self.tokens[0].type == TokenType.INDEX:
                    self.eat()
                    idx_var = Identifier(self.expect(TokenType.IDENTIFYER, "For Each needs ident").value)
                elif self.tokens[0].value == "in":
                    self.eat()
                    iterateable = self.parse_expr()
            self.expect(TokenType.OPEN_BRACE, "Expected open Brace in for")
            while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
                body.append(self.parse_stmt())
            self.expect(TokenType.CLOSE_BRACE, "Expected close brace at end of while loop")
            return Do(
                body=[
                    VarDecl(const=False, identifier=ptr_var.symbol, value=NumericLiteral(0)),
                    VarDecl(const=False, identifier=idx_var.symbol, value=NumericLiteral(0)),
                    VarDecl(const=False, identifier=value_var.symbol, value=NumericLiteral(0)),
                    ForEach(iterateable, ptr_var, idx_var, value_var, body)
                ]
            )
        # for
        else:
            # without variable
            ident: str = "".join(rnd.choice(string.ascii_letters) for _ in range(10))
            start_value: Expr = NumericLiteral(value=0)
            condition: Expr
            for_body: List[Stmt] = []
            iterator: Expr = AssignmentExpr(
                assigne=Identifier(symbol=ident), 
                value=BinaryExpr(left=Identifier(symbol=ident), right=NumericLiteral(value=1), operator="+")
                )
            end_reached = False
            # ---
            # first expression
            first_expr = self.parse_expr()
            if isinstance(first_expr, Identifier):
                ident = first_expr.symbol
                iterator = AssignmentExpr(
                    assigne=Identifier(symbol=ident), 
                    value=BinaryExpr(left=Identifier(symbol=ident), right=NumericLiteral(value=1), operator="+")
                )
            elif isinstance(first_expr, AssignmentExpr):
                if not isinstance(first_expr.assigne, Identifier):
                    raise TokenError("Iterator in for must be Identifier")
                ident = first_expr.assigne.symbol
                iterator = AssignmentExpr(
                    assigne=Identifier(symbol=ident), 
                    value=BinaryExpr(left=Identifier(symbol=ident), right=NumericLiteral(value=1), operator="+")
                )
                start_value = first_expr.value                
            else:
                condition = Comparator(left=Identifier(symbol=ident), right=first_expr, operator="<")
                end_reached = True
            while not end_reached and self.tokens[0].type != TokenType.OPEN_BRACE:
                if self.tokens[0].type == TokenType.FROM:
                    self.eat()
                    start_value = self.parse_expr()
                elif self.tokens[0].type == TokenType.TO:
                    self.eat()
                    condition = Comparator(left=Identifier(symbol=ident), right=self.parse_expr(), operator="<")
                elif self.tokens[0].type == TokenType.WHILE:
                    self.eat()
                    condition = self.parse_expr()
                elif self.tokens[0].type == TokenType.THEN:
                    self.eat()
                    iterator = self.parse_expr()
                else:
                    raise TokenError(f"Unexpected Token >{self.eat()}< in for loop")
            self.expect(TokenType.OPEN_BRACE, "Expected open Brace in for")
            while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
                for_body.append(self.parse_stmt())
            self.expect(TokenType.CLOSE_BRACE, "Expected close brace at end of while loop")
            # ---
            for_body.append(iterator)
            return Do(
                body=[
                    VarDecl(
                        const=False,
                        identifier=ident,
                        value=start_value
                    ),
                    While(
                        condition=condition,
                        has_do=False,
                        body=for_body
                    )
                ]
            )

  
    def parse_func_declaration(self) -> Stmt:
        self.eat()
        name = self.expect(TokenType.IDENTIFYER, "Expected Function name following keywords").value
        with_colon = self.tokens[0].type == TokenType.COLON
        if with_colon:
            self.eat()
        args = self.parse_args()
        params = []
        for arg in args:
            if not isinstance(arg, Identifier):
                raise TokenError("Iside func decl expected to be a str")
            params.append(arg.symbol)
        if with_colon:
            self.expect(TokenType.TO, "Mapping arrow expexted")
        else:
            self.expect_multiple([TokenType.COLON, TokenType.EQUALS], "Equation defenition expected using >:=<")
        self.expect(TokenType.OPEN_BRACE, "func body expected")
        body = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
            body.append(self.parse_stmt())
        self.expect(TokenType.CLOSE_BRACE, "Closing brace expected at end of func body")
        func = FunctionDeclaration(name, params, body)
        return func

    def parse_expr(self) -> Expr:
        return self.parse_or_expr()
    
    def parse_or_expr(self) -> Expr:
        left = self.parse_and_expr()
        while self.tokens[0].value in ["||"] and self.tokens[0].type == TokenType.BINARY_LOGIC_OP:
            operator = self.eat().value
            right = self.parse_and_expr()
            left = BinaryExpr(left, right, operator)
        return left
    
    def parse_and_expr(self) -> Expr:
        left = self.parse_comparative_expr()
        while self.tokens[0].value in ["&&"] and self.tokens[0].type == TokenType.BINARY_LOGIC_OP:
            operator = self.eat().value
            right = self.parse_comparative_expr()
            left = BinaryExpr(left, right, operator)
        return left
        
    def parse_comparative_expr(self) -> Expr:
        left = self.parse_assignment_expr()
        while self.tokens[0].type == TokenType.BINARY_COMPARATOR:
            operator = self.eat().value
            right = self.parse_assignment_expr()
            left = Comparator(left, right, operator)
        return left
    
    def parse_assignment_expr(self) -> Expr:
        left = self.parse_object_expr()
        if self.tokens[0].type == TokenType.EQUALS:
            self.eat()
            value = self.parse_assignment_expr()
            return AssignmentExpr(left, value)
        return left
    
    def parse_object_expr(self) -> Expr:
        if self.tokens[0].type != TokenType.OPEN_BRACE:
            return self.parse_list_expr() # -------------------------!!!!!!!!!!!!!!!
        self.eat()
        properties = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
            argument = self.expect(TokenType.IDENTIFYER, "Obj literal key expected").value
            # {arg, }
            if self.tokens[0].type == TokenType.COMMA:
                self.eat()
                properties.append(Property(argument, NullLiteral()))
            # {arg}
            if self.tokens[0].type == TokenType.CLOSE_BRACE:
                properties.append(Property(argument, NullLiteral()))
                break
            # {key : val}
            self.expect(TokenType.COLON, "Missing >:< following argument in Obj")
            value = self.parse_expr()
            properties.append(Property(argument, value))
            if self.tokens[0].type != TokenType.CLOSE_BRACE:
                self.expect(TokenType.COMMA, "Missing comma or closing bracket following a property")
        self.expect(TokenType.CLOSE_BRACE, "Obj missing closing brace")
        return ObjectLiteral(properties)
    
    def parse_list_expr(self) -> Expr:
        if self.tokens[0].type != TokenType.OPEN_BRACKET:
            return self.parse_push_expr()
        self.eat()
        elements = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACKET]:
            elements.append(self.parse_expr())
            if self.tokens[0].type != TokenType.CLOSE_BRACKET:
                self.expect(TokenType.COMMA, "Missing comma or closing bracket following an element")
        self.expect(TokenType.CLOSE_BRACKET, "List missing closing bracket")
        return LinkedList(elements)
    
    def parse_push_expr(self) -> Expr:
        left = self.parse_additive_expr()
        while self.tokens[0].value in ["add", "push"] and self.tokens[0].type == TokenType.BINARY_OPERATOR:
            operator = self.eat().value
            right = self.parse_expr()
            left = BinaryExpr(left, right, operator)
        return left

    def parse_additive_expr(self) -> Expr:
        left = self.parse_multiplicative_expr()
        while self.tokens[0].value in ["+", "-"] and self.tokens[0].type == TokenType.BINARY_OPERATOR:
            operator = self.eat().value
            right = self.parse_multiplicative_expr()
            left = BinaryExpr(left, right, operator)
        return left
    
    def parse_multiplicative_expr(self) -> Expr:
        left = self.parse_call_member_expr() # !!!!!
        while self.tokens[0].value in ["*", "/", "mod"] and self.tokens[0].type == TokenType.BINARY_OPERATOR:
            operator = self.eat().value
            right = self.parse_call_member_expr() # !!!!
            left = BinaryExpr(left, right, operator)
        return left
    
    def parse_call_member_expr(self) -> Expr:
        member = self.parse_member_expr()
        if self.tokens[0].type == TokenType.OPEN_PAREN:
            return self.parse_call_expr(member)
        return member

    #obj.func()()
    def parse_call_expr(self, caller: Expr) -> Expr:
        call_expr = CallExpr(self.parse_args(), caller)
        if self.tokens[0].type == TokenType.OPEN_PAREN:
            call_expr = self.parse_call_expr(call_expr)
        return call_expr

    def parse_args(self) -> List[Expr]:
        if self.tokens[0].type != TokenType.OPEN_PAREN:
            return [self.parse_expr()]
        self.expect(TokenType.OPEN_PAREN, "Expected open parenthesis")
        args = None
        if self.tokens[0].type == TokenType.CLOSE_PAREN:
            args = []
        else:
            args = self.parse_arguments_list()
        self.expect(TokenType.CLOSE_PAREN, "Missing closing paren in args list")
        return args

    def parse_arguments_list(self) -> List[Expr]:
        args = [self.parse_expr()]
        while self.tokens[0].type == TokenType.COMMA and self.eat():
            args.append(self.parse_assignment_expr())
        return args 

    def parse_member_expr(self) -> Expr:
        object = self.parse_unary_expr()
        while self.tokens[0].type in [TokenType.DOT, TokenType.OPEN_BRACKET]:
            operator = self.eat()
            property: Expr
            computed: bool
            if operator.type == TokenType.DOT:
                computed = False
                property = self.parse_unary_expr()
                if not isinstance(property, Identifier):
                    raise TokenError("Cannot use dot operator without right side being identifier")
            else:
                computed = True
                property = self.parse_expr()
                self.expect(TokenType.CLOSE_BRACKET, "Missing computed value")
            object = MemberExpr(object, property, computed)
        return object
    
    def parse_unary_expr(self) -> Expr:
        if self.tokens[0].type == TokenType.BINARY_OPERATOR and self.tokens[0].value in ["-", "!", "pop", "copy", "len"]:
            operator = self.eat().value
            arg = self.parse_expr()
            return UnaryExpr(arg, operator)
        else:
            return self.parse_primary_expr()


    def parse_primary_expr(self) -> Expr:
        tk = self.tokens[0].type

        if tk == TokenType.IDENTIFYER:
            return Identifier(self.eat().value) # ???
        elif tk == TokenType.STR:
            return String(self.eat().value)
        elif tk == TokenType.BOOL:
            boolean = self.eat().value
            if boolean == "True":
                return NumericLiteral(1)
            else: 
                return NumericLiteral(0)
        elif tk == TokenType.NULL:
            self.eat()
            return NullLiteral()
        elif tk == TokenType.NUMBER:
            if self.tokens[0].value.isdigit():
                return NumericLiteral(int(self.eat().value)) # ???
            else:
                return NumericLiteral(float(self.eat().value)) 
        elif tk == TokenType.OPEN_PAREN:
            self.eat()
            value = self.parse_expr()
            self.eat()
            return value
        else:
            raise TokenError(f"Token Error found at >{self.tokens[0]}< during parsing")

    def parse_var_decl(self, has_let=True) -> Stmt:
        is_const = False
        if has_let:
            is_const = self.eat().type == TokenType.CONST
        ident = self.expect(TokenType.IDENTIFYER, "Expected identifier name following >let< or >const<").value
        if ((has_let and self.tokens[0].type not in [TokenType.EQUALS, TokenType.COLON]) 
            or (not has_let and self.tokens[0].type != TokenType.COLON)): # ???
            # self.eat()
            if is_const:
                raise TokenError("Must assign value to const")
            return VarDecl(False, ident, NullLiteral())
        if not has_let:
            self.expect_multiple([TokenType.COLON, TokenType.EQUALS], "Expected >:=< token following identifier in var declaration.")
        else:
            self.expect_options([[TokenType.COLON, TokenType.EQUALS], [TokenType.EQUALS]], "Expected >=< token following identifier in var declaration.")
        return VarDecl(is_const, ident, self.parse_expr())