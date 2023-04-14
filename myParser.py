from abstractSyntaxTree import Stmt, Program, Expr, BinaryExpr, NumericLiteral, Identifier#, NodeType
from lexer import tokenize, Token, TokenType, TokenError
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple


class Parser:
    tokens: List[Token] = []

    def eat(self) -> Token:
        return self.tokens.pop(0)
    
    def expect(self, type: TokenType, err) -> Token:
        prev = self.tokens.pop(0)
        if prev ==  None or prev.type != type :
            raise TokenError(f"Error at >{prev}< \n{err}\n Expecting: {type}")
        return prev


    def produce_AST(self, sourceCode: str) -> Program:
        self.tokens = tokenize(sourceCode) 

        program = Program([]) # ???

        while self.tokens[0].type != TokenType.EOF:
            program.body.append(self.parse_stmt())

        return program
    
    def parse_stmt(self) -> Stmt:
        return self.parse_expr()

    def parse_expr(self) -> Expr:
        return self.parse_additive_expr()
    
    def parse_additive_expr(self) -> Expr:
        left = self.parse_multiplicative_expr()
        while self.tokens[0].value in ["+", "-"]:
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
        elif tk == TokenType.NUMBER:
            return NumericLiteral(float(self.eat().value)) # ???
        elif tk == TokenType.OPEN_PAREN:
            self.eat()
            value = self.parse_expr()
            self.eat()
            return value
        else:
            raise TokenError(f"Token Error found at >{self.tokens[0]}< during parsing")