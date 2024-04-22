import argparse
import ply.yacc as yacc

# Importing tokens map from part1Lexer
from part1Lexer import lexer, tokens

# Todo: Define all the required grammar and actions
def p_program(p):
    'program : statement_list'

def p_statement_list(p):
    '''statement_list : statement statement_list
                      | '''

def p_statement(p):
    '''statement : variables'''

def p_variables(p):
    '''variables : ID ID SEMI'''

def p_error(p):
    if p:
        print(f"Syntax error at {p.value}")
    else:
        print("Syntax error at EOF")

def test_parser(input_string):
    result = parser.parse(input_string, lexer=lexer)
    if result is None:
        print("Input matches the grammar.")
    else:
        print("Input does not match the grammar.")

# Build the parser
ply_parser = yacc.yacc(debug=True)

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
        if result is None:
            print("Input matches the grammar.")
        else:
            print("Input does not match the grammar.")
    except Exception as e:
        print(f"Error during parsing: {e}")
