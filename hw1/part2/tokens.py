from enum import Enum

class Token(Enum):
    ID = "ID"
    NUM = "NUM"
    HNUM = "HNUM"
    INCR = "INCR"
    PLUS = "PLUS"
    MULT = "MULT"
    SEMI = "SEMI"
    LPAREN = "LPAREN"
    RPAREN = "RPAREN"
    LBRACE = "LBRACE"
    RBRACE = "RBRACE"
    ASSIGN = "ASSIGN"
    IGNORE = "IGNORE"
    IF = "IF"
    ELSE = "ELSE"
    WHILE = "WHILE"
    INT = "INT"
    FLOAT = "FLOAT"

class Lexeme:
    def __init__(self, token:Token, value:str) -> None:
        self.token = token
        self.value = value

    def __str__(self):
        return "(" + str(self.token) + "," + "\"" + self.value + "\"" + ")"    

def idy(l:Lexeme) -> Lexeme:
    return l

tokens = [
    (Token.IF, "if", idy),
    (Token.ELSE, "else", idy),
    (Token.WHILE, "while", idy),
    (Token.INT, "int", idy),
    (Token.FLOAT, "float", idy),
    (Token.HNUM, "0x[0-9a-fA-F]+", idy),
    (Token.ID, "[a-zA-Z][a-zA-Z0-9]*", idy),
    (Token.NUM, "(\.[0-9]+)|([0-9]+(\.[0-9]*)?)", idy),
    (Token.INCR, "\+\+", idy),
    (Token.PLUS, "\+", idy),
    (Token.MULT, "\*", idy),
    (Token.SEMI, ";", idy),
    (Token.LPAREN, "\(", idy),
    (Token.RPAREN, "\)", idy),
    (Token.LBRACE, "{", idy),
    (Token.RBRACE, "}", idy),
    (Token.ASSIGN, "=", idy),
    (Token.IGNORE, "[ \n\t]+", idy)
]
