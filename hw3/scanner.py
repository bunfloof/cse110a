from enum import Enum
from typing import Callable, List, Tuple, Optional
import re

class ScannerException(Exception):
    # this time, the scanner exception takes a line number
    def __init__(self, lineno: int) -> None:
        message = "Scanner error on line: " + str(lineno)
        super().__init__(message)

class Token(Enum):
    ID = "ID"
    NUM = "NUM"
    HNUM = "HNUM"
    INCR = "INCR"
    PLUS = "PLUS"
    MINUS = "MINUS"
    MULT = "MULT"
    DIV = "DIV"
    EQ = "EQ"
    LT = "LT"
    SEMI = "SEMI"
    LPAR = "LPAR"
    RPAR = "RPAR"
    LBRACE = "LBRACE"
    RBRACE = "RBRACE"
    ASSIGN = "ASSIGN"
    IGNORE = "IGNORE"
    IF = "IF"
    ELSE = "ELSE"
    WHILE = "WHILE"
    FOR = "FOR"
    INT = "INT"
    FLOAT = "FLOAT"

class Lexeme:
    def __init__(self, token: Token, value: str) -> None:
        self.token = token
        self.value = value

    def __str__(self) -> str:
        return "(" + str(self.token) + "," + "\"" + self.value + "\"" + ")"

class Scanner:
    def __init__(self, tokens: List[Tuple[Token, str, Callable[[Lexeme], Lexeme]]]) -> None:
        self.tokens = tokens
        self.lineno = 1 # was 1 in the original sacnner.py template

    def input_string(self, input_string: str) -> None:
        self.istring = input_string

    # Get the scanner line number, needed for the parser exception
    def get_lineno(self) -> int:
        return self.lineno

    # Implement me with one of your scanner implementations for part
    # 2. I suggest the SOS implementation. If you are not comfortable
    # using one of your own scanner implementations, you can use the
    def token(self) -> Optional[Lexeme]:
        while True:
            if len(self.istring) == 0:
                return None

            for token_type, regex, action in self.tokens:
                match = re.match(regex, self.istring)
                if match:
                    value = match.group(0)
                    self.istring = self.istring[len(value):]
                    lexeme = Lexeme(token_type, value)
                    result = action(lexeme, self) # passijg scanner instanc to the action function
                    if result.token != Token.IGNORE:
                        return result
                    break
            else:
                raise ScannerException(self.lineno)

def idy(l: Lexeme, scanner: Scanner) -> Lexeme:
    return l

def update_line_number(l: Lexeme, scanner: Scanner) -> Lexeme:
    scanner.lineno += l.value.count('\n')
    return l

# Finish providing tokens (including token actions) for the C-simple
# language
tokens = [
    (Token.IF, "if", idy),
    (Token.ELSE, "else", idy),
    (Token.WHILE, "while", idy),
    (Token.FOR, "for", idy),
    (Token.INT, "int", idy),
    (Token.FLOAT, "float", idy),
    (Token.HNUM, "0x[0-9a-fA-F]+", idy),
    (Token.ID, "[a-zA-Z][a-zA-Z0-9]*", idy),
    (Token.NUM, "(\.[0-9]+)|([0-9]+(\.[0-9]*)?)", idy),
    (Token.INCR, "\+\+", idy),
    (Token.PLUS, "\+", idy),
    (Token.MINUS, "-", idy),
    (Token.MULT, "\*", idy),
    (Token.DIV, "/", idy),
    (Token.EQ, "==", idy),
    (Token.LT, "<", idy),
    (Token.SEMI, ";", idy),
    (Token.LPAR, "\(", idy),
    (Token.RPAR, "\)", idy),
    (Token.LBRACE, "{", idy),
    (Token.RBRACE, "}", idy),
    (Token.ASSIGN, "=", idy),
    (Token.IGNORE, "[ \n\t]+", update_line_number)
]
