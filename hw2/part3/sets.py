def main():
    #{Number of production rule: ({first sets}, {Follow up sets})
    sets = {
        0: ({'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID'}, {'$end'}),
        1: ({'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID'}, {'$end'}),
        2: ({'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID'}, {'RBRACE', '$end'}),
        3: ({''}, {'RBRACE', '$end'}),
        4: ({'INT', 'FLOAT'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        5: ({'ID'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        6: ({'IF'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        7: ({'FOR'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        8: ({'LBRACE'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        9: ({'ID'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        10: ({'INT', 'FLOAT'}, {'ID'}),
        11: ({'INT'}, {'ID'}),
        12: ({'FLOAT'}, {'ID'}),
        13: ({'ID'}, {'SEMI'}),
        14: ({'ID'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        15: ({'IF'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        16: ({'FOR'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        17: ({'LBRACE'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        18: ({'ID'}, {'INT', 'FLOAT', 'IF', 'FOR', 'LBRACE', 'ID', 'RBRACE', '$end'}),
        19: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        20: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN'}),
        21: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT'}),
        22: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ'}),
        23: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT'}),
        24: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS'}),
        25: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'MINUS'}),
        26: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS'}),
        27: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        28: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'DIVIDE'}),
        29: ({'ID', 'NUMBER', 'LPAREN', 'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES'}),
        30: ({'ID', 'NUMBER', 'LPAREN'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        31: ({'MINUS'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        32: ({'ID'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        33: ({'NUMBER'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'}),
        34: ({'LPAREN'}, {'SEMI', 'RPAREN', 'EQ', 'LT', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE'})
    }

    print("Rule Number | FIRST Sets    | FOLLOW Sets")
    print("-" * 50)

    for rule_number, (first_set, follow_set) in sets.items():
        first_formatted = ', '.join(sorted(s for s in first_set if s))
        follow_formatted = ', '.join(sorted(s for s in follow_set if s))
        print(f"{rule_number:12} | {first_formatted:15} | {follow_formatted}")

if __name__ == "__main__":
    main()

