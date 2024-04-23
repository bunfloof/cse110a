import argparse
import ply.yacc as yacc

# Importing tokens map from part1Lexer
from part1Lexer import lexer, tokens

# Todo: Define all the required grammar and actions
# Program rule
# Example: int main() { ... }
# def p_program(p):
#     'program : statement_list'
#     p[0] = p[1]

# “The parser returns whatever the top-level production returns. In this case because it is empty, it returns none.” 
def p_program(p):
    'program : statement_list'
    p[0] = None

# Statement list rules
# Example: { int x; x = 5; }
# def p_statement_list(p):
#     '''statement_list : statement
#                       | statement statement_list'''
#     if len(p) == 2:
#         p[0] = [p[1]]
#     else:
#         p[0] = [p[1]] + p[2]

# “The parser returns whatever the top-level production returns. In this case because it is empty, it returns none.”
def p_statement_list(p):
    '''statement_list : statement statement_list
                      | '''
    pass

# Statement rules
# Example: int x;
#          x = 5;
#          if (x > 0) { ... } else { ... }
#          for (int i = 0; i < 10; i++) { ... }
def p_statement(p):
    '''statement : declaration_statement
                 | assignment_statement
                 | if_else_statement
                 | for_statement
                 | block_statement
                 | variables'''
    p[0] = p[1]

# Declaration statement rule
# Example: int x;
def p_declaration_statement(p):
    'declaration_statement : type ID SEMI'
    p[0] = ('declaration', p[1], p[2])

# Type rule
# Example: int, float
def p_type(p):
    '''type : INT
            | FLOAT'''
    p[0] = p[1]

# Assignment rules
# Example: x = 5;
def p_assignment(p):
    'assignment : ID ASSIGN expression'
    assignment = ('assignment', p[1], p[3])
    p[0] = assignment

def p_assignment_statement(p):
    'assignment_statement : assignment SEMI'
    assignment_statement = p[1]
    p[0] = assignment_statement

# If-else statement rule
# Example: if (x > 0) { ... } else { ... }
def p_if_else_statement(p):
    'if_else_statement : IF LPAREN expression RPAREN statement ELSE statement'
    p[0] = ('if_else', p[3], p[5], p[7])

# For statement rule
# Example: for (int i = 0; i < 10; i++) { ... }
def p_for_statement(p):
    'for_statement : FOR LPAREN assignment SEMI expression SEMI assignment RPAREN statement'
    for_statement = ('for', p[3], p[5], p[7], p[9])
    p[0] = for_statement

# Block statement rule
# Example: { int x; x = 5; }
def p_block_statement(p):
    'block_statement : LBRACE statement_list RBRACE'
    p[0] = ('block', p[2])

# Variables rule
# Example: int x;
def p_variables(p):
    'variables : ID ID SEMI'
    p[0] = ('variables', p[1], p[2])

# Expression rules
# Example: x == 5
#          x < 5
#          x + 5
#          x * 5
def p_expression(p):
    '''expression : equality_expression
                  | equality_expression EQ equality_expression'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('binary_op', p[2], p[1], p[3])

def p_equality_expression(p):
    '''equality_expression : relational_expression
                           | relational_expression LT relational_expression'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('binary_op', p[2], p[1], p[3])

def p_relational_expression(p):
    '''relational_expression : additive_expression'''
    p[0] = p[1]

def p_additive_expression(p):
    '''additive_expression : multiplicative_expression
                           | multiplicative_expression PLUS additive_expression
                           | multiplicative_expression MINUS additive_expression'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('binary_op', p[2], p[1], p[3])

def p_multiplicative_expression(p):
    '''multiplicative_expression : unary_expression
                                 | unary_expression TIMES multiplicative_expression
                                 | unary_expression DIVIDE multiplicative_expression'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('binary_op', p[2], p[1], p[3])

def p_unary_expression(p):
    '''unary_expression : primary_expression
                        | MINUS unary_expression'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('unary_op', p[1], p[2])

def p_primary_expression(p):
    '''primary_expression : ID
                          | NUMBER
                          | LPAREN expression RPAREN'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = p[2]

# Error handling rule
def p_error(p):
    if p:
        print(f"Syntax error at {p.value}")
    else:
        print("Syntax error at EOF")

# Build the parser
ply_parser = yacc.yacc(debug=True)

def test_parser(input_string):
    result = ply_parser.parse(input_string, lexer=lexer)
    if result is None:
        print("Input matches the grammar.")
    else:
        print("Input does not match the grammar")

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('file_name', type=str, help="Input file containing the text to parse.")
    args = arg_parser.parse_args()
    try:
        with open(args.file_name, 'r') as file:
            f_contents = file.read()
            #print("File contents read successfully:")
            #print(f_contents)
    except FileNotFoundError:
        print(f"Error: File '{args.file_name}' not found.")
        exit()

    try:
        result = ply_parser.parse(f_contents, lexer=lexer)
        #print("Parsing result:", result)
        if result is None:
            print("Input matches the grammar.")
        else:
            print("Input does not match the grammar")
    except Exception as e:
        print(f"Error during parsing: {e}")
