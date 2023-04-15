from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Tuple


class TokenError(Exception):
    pass

class TokenType(Enum):
    # literal
    NUMBER = auto()
    IDENTIFYER = auto()
    NULL = auto()
    # sonderzeichen
    EQUALS = auto()  # =
    TO = auto()  # ->
    SEMICOLON = auto()  # ;
    COLON = auto()  # :
    COMMA = auto()  # ,
    DOT = auto()  # .
    DASH = auto()  # -
    OPEN_PAREN = auto()  # (
    CLOSE_PAREN = auto()  # )
    OPEN_BRACE = auto()  # {
    CLOSE_BRACE = auto()  # }
    OPEN_BRACKET = auto()  # [
    CLOSE_BRACKET = auto()  # ]
    LESS = auto()  # <
    GREATER = auto()  # >
    BINARY_OPERATOR = auto()
    # keywords
    LET = auto()
    CONST = auto()
    # end of file
    EOF = auto()

KEYWORDS = {
    "let": TokenType.LET,
    "const": TokenType.CONST,

    "mod": TokenType.BINARY_OPERATOR,
    "Null": TokenType.NULL
}



@dataclass
class Token:
    value: str  
    type: TokenType


def tokenize(sourceCode: str) -> List[Token]:

    def is_skippable(src: str) -> bool:
        return src in [" ", "\n", "\t", "\r"]

    tokens = []
    src = list(sourceCode)

    # Alle Tokens fürs ganze File erstellen
    while len(src) > 0:
        if src[0] == "(":
            tokens.append(Token(src.pop(0), TokenType.OPEN_PAREN))
        elif src[0] == ")":
            tokens.append(Token(src.pop(0), TokenType.CLOSE_PAREN))
        elif src[0] == "{":
            tokens.append(Token(src.pop(0), TokenType.OPEN_BRACE))
        elif src[0] == "}":
            tokens.append(Token(src.pop(0), TokenType.CLOSE_BRACE))
        elif src[0] == "[":
            tokens.append(Token(src.pop(0), TokenType.OPEN_BRACKET))
        elif src[0] == "]":
            tokens.append(Token(src.pop(0), TokenType.CLOSE_BRACKET))
        elif src[0] == "-" and src[1] == ">":
            tokens.append(Token(src.pop(0) + src.pop(0), TokenType.TO))
        elif src[0] in ["+", "-", "*", "/"]:
            tokens.append(Token(src.pop(0), TokenType.BINARY_OPERATOR))
        elif src[0] == "=":
            tokens.append(Token(src.pop(0), TokenType.EQUALS))
        elif src[0] == ";":
            tokens.append(Token(src.pop(0), TokenType.SEMICOLON))
        elif src[0] == ":":
            tokens.append(Token(src.pop(0), TokenType.COLON))
        elif src[0] == ",":
            tokens.append(Token(src.pop(0), TokenType.COMMA))
        elif src[0] == ".":
            tokens.append(Token(src.pop(0), TokenType.DOT))
        elif src[0] == "<":
            tokens.append(Token(src.pop(0), TokenType.LESS))
        elif src[0] == ">":
            tokens.append(Token(src.pop(0), TokenType.GREATER))
        else: # Multichar token
            # Num Token
            if src[0].isdigit():
                num = ""
                while len(src) > 0 and src[0].isdigit():
                    num += src.pop(0)
                tokens.append(Token(num, TokenType.NUMBER))
            # ident token
            elif src[0].isalpha():
                ident = ""
                while len(src) > 0 and src[0].isalpha():
                    ident += src.pop(0)
                try:
                    tokens.append(Token(ident, KEYWORDS[ident]))
                except KeyError:
                    tokens.append(Token(ident, TokenType.IDENTIFYER))
            # skip spaces etc
            elif is_skippable(src[0]):
                src.pop(0)
            else:
                raise TokenError(f"Token Error found at >{src[0]}< during lexing")

    tokens.append(Token("EndOfFile", TokenType.EOF))
    return tokens




def main():
    src = "let x = 5 + (7*10)"
    print(tokenize(src))


if __name__ == "__main__":
    main()
