import lexer
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple

# class NodeType(Enum):
#     PROGRAM = "Program"
#     NUMERIC_LITERAL = "NumericLiteral"
#     IDENTIFIER = "Identifier"
#     BINARY_EXPR = "BinaryExpr"

@dataclass
class Stmt(ABC):
    #kind: NodeType
    pass

@dataclass
class Program(Stmt):
    #kind: NodeType.PROGRAM
    body: List[Stmt]

@dataclass
class Expr(Stmt, ABC):
    pass

@dataclass
class BinaryExpr(Expr):
    #kind: NodeType.BINARY_EXPR
    left: Expr
    right: Expr
    operator: str

@dataclass
class Identifier(Expr):
    #kind: NodeType.IDENTIFIER
    symbol: str

@dataclass
class NumericLiteral(Expr):
    #kind: NodeType.NUMERIC_LITERAL
    value: float
