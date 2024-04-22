import ply.lex as lex

# Todo: Add all the tokens here
tokens = [
    'PLUS', 'ID', 'SEMI' 
]

# Todo: Add all the requied regular expression rules here
t_SEMI = r';'
t_PLUS = r'\+'

# Todo: Write all the required regular expression rule with action code
def t_ID(t):
    r'[a-z]+'
    return t


# Todo: Fix the error function 
def t_error(t):
    print(f"Illegal character")

# Build the lexer
lexer = lex.lex()
