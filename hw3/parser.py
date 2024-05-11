from scanner import Lexeme, Token, Scanner
from typing import Callable, List, Tuple, Optional

# Symbol Table exception, requires a line number and ID
class SymbolTableException(Exception):
    def __init__(self, lineno: int, ID: str) -> None:
        message = "Symbol table error on line: " + str(lineno) + "\nUndeclared ID: " + ID
        super().__init__(message)

# Implement all members of this class for Part 2
class SymbolTable:
    def __init__(self) -> None:
        self.scopes = [{}]

    def insert(self, ID: str, info) -> None:
        self.scopes[-1][ID] = info

    def lookup(self, ID: str):
        for scope in reversed(self.scopes):
            if ID in scope:
                return scope[ID]
        return None

    def push_scope(self) -> None:
        self.scopes.append({})

    def pop_scope(self) -> None:
        self.scopes.pop()

class ParserException(Exception):
    def __init__(self, lineno: int, lexeme: Lexeme, tokens: List[Token]) -> None:
        message = "Parser error on line: " + str(lineno) + "\nExpected one of: " + str(tokens) + "\nGot: " + str(lexeme)
        super().__init__(message)

class Parser:
    def __init__(self, scanner: Scanner, use_symbol_table: bool) -> None:
        self.scanner = scanner
        self.current_token = None
        self.use_symbol_table = use_symbol_table
        self.symbol_table = SymbolTable() if use_symbol_table else None

    # Implement one function in this class for every non-terminal in
    # your grammar using the recursive descent recipe from the book
    # and the lectures for part 2

    # Implement me:
    # s is the string to parse
    def parse(self, s: str):
        self.scanner.input_string(s)
        self.current_token = self.scanner.token()
        self.statement_list()

    def statement_list(self):
        if self.check_first(["INT", "FLOAT", "ID", "IF", "LBRACE", "FOR"]):
            self.statement()
            self.statement_list()
        elif self.check_follow(["RBRACE", None]):
            pass
        else:
            self.error(["INT", "FLOAT", "ID", "IF", "LBRACE", "FOR", "RBRACE"])

    def statement(self):
        if self.check_first(["INT", "FLOAT"]):
            self.declaration_statement()
        elif self.check_first(["ID"]):
            self.assignment_statement()
        elif self.check_first(["IF"]):
            self.if_else_statement()
        elif self.check_first(["LBRACE"]):
            self.block_statement()
        elif self.check_first(["FOR"]):
            self.for_loop_statement()
        else:
            self.error(["INT", "FLOAT", "ID", "IF", "LBRACE", "FOR"])

    def declaration_statement(self):
        if self.check_first(["INT"]):
            self.match("INT")
            id_token = self.current_token
            self.match("ID")
            self.match("SEMI")
            if self.use_symbol_table:
                self.symbol_table.insert(id_token.value, "INT")
        elif self.check_first(["FLOAT"]):
            self.match("FLOAT")
            id_token = self.current_token
            self.match("ID")
            self.match("SEMI")
            if self.use_symbol_table:
                self.symbol_table.insert(id_token.value, "FLOAT")
        else:
            self.error(["INT", "FLOAT"])

    def assignment_statement(self):
        self.assignment_statement_base()
        self.match("SEMI")

    def assignment_statement_base(self):
        id_token = self.current_token
        self.match("ID")
        self.match("ASSIGN")
        if self.use_symbol_table:
            if self.symbol_table.lookup(id_token.value) is None:
                raise SymbolTableException(self.scanner.get_lineno(), id_token.value)
        self.expr()

    def if_else_statement(self):
        if self.check_first(["INT", "FLOAT"]):
            self.declaration_statement()
        self.match("IF")
        self.match("LPAR")
        self.expr()
        self.match("RPAR")
        if self.check_first(["LBRACE"]):
            self.block_statement()
        else:
            self.statement()
        self.match("ELSE")
        if self.check_first(["LBRACE"]):
            self.block_statement()
        else:
            self.statement()

    def block_statement(self):
        self.match("LBRACE")
        self.statement_list()
        self.match("RBRACE")

    def for_loop_statement(self):
        self.match("FOR")
        self.match("LPAR")
        self.assignment_statement()
        self.expr()
        self.match("SEMI")
        self.assignment_statement_base()
        self.match("RPAR")
        self.statement()

    def expr(self):
        self.comp()
        self.expr2()

    def expr2(self):
        if self.check_first(["EQ"]):
            self.match("EQ")
            self.comp()
            self.expr2()
        elif self.check_follow(["SEMI", "RPAR"]):
            pass
        else:
            self.error(["EQ", "SEMI", "RPAR"])

    def comp(self):
        self.factor()
        self.comp2()

    def comp2(self):
        if self.check_first(["LT"]):
            self.match("LT")
            self.factor()
            self.expr2()
        elif self.check_follow(["SEMI", "RPAR", "EQ", "PLUS", "MINUS"]):
            pass
        else:
            self.error(["LT", "SEMI", "RPAR", "EQ", "PLUS", "MINUS"])

    def factor(self):
        self.term()
        self.factor2()

    def factor2(self):
        if self.check_first(["PLUS"]):
            self.match("PLUS")
            self.term()
            self.factor2()
        elif self.check_first(["MINUS"]):
            self.match("MINUS")
            self.term()
            self.factor2()
        elif self.check_follow(["SEMI", "RPAR", "EQ", "LT"]):
            pass
        else:
            self.error(["PLUS", "MINUS", "SEMI", "RPAR", "EQ", "LT"])

    def term(self):
        self.unit()
        self.term2()

    def term2(self):
        if self.check_first(["DIV"]):
            self.match("DIV")
            self.unit()
            self.term2()
        elif self.check_first(["MULT"]):
            self.match("MULT")
            self.unit()
            self.term2()
        elif self.check_follow(["SEMI", "RPAR", "EQ", "LT", "PLUS", "MINUS"]):
            pass
        else:
            self.error(["DIV", "MULT", "SEMI", "RPAR", "EQ", "LT", "PLUS", "MINUS"])

    def unit(self):
        if self.check_first(["NUM"]):
            self.match("NUM")
        elif self.check_first(["ID"]):
            id_token = self.current_token
            self.match("ID")
            if self.use_symbol_table:
                if self.symbol_table.lookup(id_token.value) is None:
                    raise SymbolTableException(self.scanner.get_lineno(), id_token.value)
        elif self.check_first(["LPAR"]):
            self.match("LPAR")
            self.expr()
            self.match("RPAR")
        else:
            self.error(["NUM", "ID", "LPAR"])

    def error(self, expected_tokens: List[str]):
        raise ParserException(self.scanner.get_lineno(), self.current_token, [Token[token] for token in expected_tokens])

    def check_first(self, tokens: List[str]) -> bool:
        return self.current_token is not None and self.current_token.token.name in tokens

    def check_follow(self, tokens: List[str]) -> bool:
        return self.current_token is None or self.current_token.token.name in tokens

    def match(self, token: str):
        if self.check_first([token]):
            self.current_token = self.scanner.token()
        else:
            self.error([token])
