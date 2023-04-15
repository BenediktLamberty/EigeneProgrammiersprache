from abstractSyntaxTree import Stmt, Program, Expr, BinaryExpr, NumericLiteral, Identifier, \
    NullLiteral, VarDecl, AssignmentExpr, Property, Map
from lexer import tokenize, Token, TokenType, TokenError
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple


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
        else:
            return self.parse_expr()

    def parse_expr(self) -> Expr:
        return self.parse_assignment_expr()
    
    def parse_assignment_expr(self) -> Expr:
        left = self.parse_map_expr()
        if self.tokens[0].type == TokenType.EQUALS:
            self.eat()
            value = self.parse_assignment_expr()
            return AssignmentExpr(left, value)
        return left
    
    def parse_map_expr(self) -> Expr:
        if self.tokens[0].type != TokenType.OPEN_BRACE:
            return self.parse_additive_expr()
        self.eat()
        properties = []
        while self.tokens[0].type not in [TokenType.EOF, TokenType.CLOSE_BRACE]:
            argument = self.parse_expr()
            # {arg, }
            if self.tokens[0].type == TokenType.COMMA:
                self.eat()
                properties.append(argument, NullLiteral())
            # {arg}
            if self.tokens[0].type == TokenType.CLOSE_BRACE:
                properties.append(argument, NullLiteral())
            # {arg -> val}
            self.expect(TokenType.TO, "Missing >->< following argument in Map")
            value = self.parse_expr()
            properties.append(Property(argument, value))
            if self.tokens[0].type != TokenType.CLOSE_BRACE:
                self.expect(TokenType.COMMA, "Missing comma or closing bracket following a property")
        self.expect(TokenType.CLOSE_BRACE, "Map missing closing brace")
        return Map(properties)

    def parse_additive_expr(self) -> Expr:
        left = self.parse_multiplicative_expr()
        while self.tokens[0].value in ["+", "-"] and self.tokens[1].type != TokenType.GREATER:
            operator = self.eat().value
            right = self.parse_multiplicative_expr()
            left = BinaryExpr(left, right, operator)
        return left
    
    def parse_multiplicative_expr(self) -> Expr:
        left = self.parse_primary_expr()
        while self.tokens[0].value in ["*", "/", "mod"]:
            operator = self.eat().value
            right = self.parse_primary_expr()
            left = BinaryExpr(left, right, operator)
        return left
        
    def parse_primary_expr(self) -> Expr:
        tk = self.tokens[0].type

        if tk == TokenType.IDENTIFYER:
            return Identifier(self.eat().value) # ???
        elif tk == TokenType.NULL:
            self.eat()
            return NullLiteral()
        elif tk == TokenType.NUMBER:
            return NumericLiteral(float(self.eat().value)) # ???
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




