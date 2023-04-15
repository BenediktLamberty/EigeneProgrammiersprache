import lexer
from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple



@dataclass
class Stmt(ABC):
    pass

@dataclass
class Program(Stmt):
    body: List[Stmt]

@dataclass
class Expr(Stmt, ABC):
    pass

@dataclass
class VarDecl(Stmt):
    const: bool
    identifier: str
    value: Expr

@dataclass
class BinaryExpr(Expr):
    left: Expr
    right: Expr
    operator: str

@dataclass
class Identifier(Expr):
    symbol: str

@dataclass
class NumericLiteral(Expr):
    value: float

@dataclass
class NullLiteral(Expr):
    pass

@dataclass
class AssignmentExpr(Expr):
    assigne: Expr
    value: Expr

@dataclass
class Property(Expr):
    arg: Expr
    value: Expr

@dataclass
class Map(Expr):
    properties: List[Property]

@dataclass
class CallExpr(Expr):
    args = List[Expr]
    caller = Expr

@dataclass
class MemberExpr(Expr):
    obj: Expr
    property: Expr