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

@dataclass
class IfElifElse(Stmt):
    cases: List[If]

@dataclass
class While(Stmt):
    condition: Expr
    has_do: bool
    body: List[Stmt]

@dataclass
class Break(Stmt):
    pass

@dataclass
class BinaryExpr(Expr):
    left: Expr
    right: Expr
    operator: str

@dataclass
class UnaryExpr(Expr):
    arg: Expr
    operator: str

@dataclass
class Identifier(Expr):
    symbol: str

@dataclass
class NumericLiteral(Expr):
    value: float

@dataclass
class String(Expr):
    value: str

@dataclass
class NullLiteral(Expr):
    pass

@dataclass
class AssignmentExpr(Expr):
    assigne: Expr
    value: Expr

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

@dataclass
class For(Stmt):
    start: NumericLiteral
    end: NumericLiteral
    step: NumericLiteral
    body: List[Stmt]