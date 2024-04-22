import ply.lex as lex

# Todo: Add all the tokens here
tokens = [
    'PLUS', 'MINUS', 'TIMES', 'DIVIDE', 'ASSIGN', 'EQ', 'LT',
    'LPAREN', 'RPAREN', 'LBRACE', 'RBRACE', 'SEMI',
    'INT', 'FLOAT', 'IF', 'ELSE', 'FOR', 'ID', 'NUMBER'
]

# Todo: Add all the required regular expression rules here
t_PLUS = r'\+'
t_MINUS = r'-'
t_TIMES = r'\*'
t_DIVIDE = r'/'
t_ASSIGN = r'='
t_EQ = r'=='
t_LT = r'<'
t_LPAREN = r'\('
t_RPAREN = r'\)'
t_LBRACE = r'{'
t_RBRACE = r'}'
t_SEMI = r';'

# Todo: Write all the required regular expression rules with action code
def t_INT(t):
    r'int'
    return t

def t_FLOAT(t):
    r'float'
    return t

def t_IF(t):
    r'if'
    return t

def t_ELSE(t):
    r'else'
    return t

def t_FOR(t):
    r'for'
    return t

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    return t

def t_NUMBER(t):
    r'\d+(\.\d+)?'
    t.value = float(t.value) if '.' in t.value else int(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

t_ignore = ' \t'

# Todo: Fix the error function
def t_error(t):
    print(f"Illegal character '{t.value[0]}'")
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()