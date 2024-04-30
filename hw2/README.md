[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/ewglx3qi)
# HW2-sp24

## Part 1

#### How did you encode the programming language description as a context-free grammar?

I encode the programming language description as a context-free grammar by using production rules in `part1Parser.py`. I defined each production rule with the prefix `p_`, followed by the non-terminal symbol. I defined the right-hand side of the production rule by using a string that specifies the sequence of terminals and no -terminals.

#### How did you make your grammar unambiguous?

I made my grammar unambiguous by using [C’s](https://en.cppreference.com/w/c/language/operator_precedence) hierarchical structure of precedence and associativity. I used production rules in a specific order and correctly used recursive rules.

#### Did you have to change any of your tokens from homework 1?

No, I did not have to change any of my tokens from homework 1 because I did not refer to my tokens from homework 1 when doing this assignment.

#### What parts of the C language are you missing? Would they be difficult to add?

I am missing arrays, pointers, function declarations, function calls, structs, unions, switch statements, while loops, do-while loops, increment operator, decrement operator, logical operators, bitwise operators, type casting, and preprocessor directives. The difficulty of adding these features depends on the complexity of extending grammar rules, adding new tokens, or updating actions in the parser. Some features, like arrays and pointers would be difficult to add because the grammar and how expressions are handled would need major changes. Other features, like while loops or logical operators, would be easier to add by creating new production rules and updating existing ones.

#### (Gradescope) 1.1 Explain how you wrote production rules, enforced precedence, associativity, and non-ambiguity.

I wrote production rules by defining them as methods with names starting with p_, followed by the name of the non-terminal they represent. Each production rule is defined using a docstring that specifies the grammar rule in the Backus-Naur format. The right-hand side of the production rule is separated by colons (:) and represents the sequence of terminals and non-terminals that the non-terminal can derive. For example, my production rule for the program non-terminal is defined as `'program : statement_list'`, which means that `program` consists of `statement_list`. Each of my production rules is associated with an action that is executed when the rule is matched during parsing. The actions are written within the corresponding method for each production rule. For example, in my `p_declaration_statement` rule, the action `p[0] = ('declaration', p[1], p[2])` creates a tuple that is a declaration statement with the type and identifier.

I enforced precedence in the production rules structure and order in which they’re defined. My expression rules (`p_expression`, `p_equality_expression`, `p_relational_expression`, `p_additive_expression`, `p_multiplicative_expression`, `p_unary_expression`) are ordered with precedence and associativity of the operators. My rules are organized hierarchically, with higher precedence rules appearing before lower precedence rules. For example, my `p_multiplicative_expression` rule appears before the `p_additive_expression` rule because multiplication and division have higher precedence than addition and subtraction. 

I enforced associativity by using the recursive nature of the rules. Left-associative operators have the recursive part on the right side of the production rule, while right-associative operators have the recursive part on the left side.

I enforced non-ambiguity by writing the production rules to avoid ambiguous grammar constructs. I made sure each input string of my production rules has a unique parse tree. For example, my `if_else_statement` rule is defined as `'if_else_statement : IF LPAREN expression RPAREN statement ELSE statement'`, which specifies the structure of an if-else statement and avoids ambiguity.
My expression rules are written using a hierarchical structure that eliminates ambiguity by giving precedence to some operators over others.

## Part 2

#### How many of your production rules did you have to change to remove left recursion?

I only have to change 2 production rules to remove left recursion, which are `p_additive_expression` and `p_multiplicative_expression`. I modified the `p_additive_expression` and `p_multiplicative_expression` production rules by changing the order of the alternatives and updating the recursive part to be right recursive. 

#### Do you have more or less total non-terminals and production rules than in your grammar for part 1?

I have the same amount of non-terminals and production rules in my grammar for part 1 because I did not have to introduce any new non-terminals or production rules to eliminate left recursion.

#### Do you think it made your grammar easier for a human to read or more difficult?

I think removing left recursion made my grammar more difficult for a human to read because the rewritten rules do not follow the natural left-to-right flow of the English language as the recursive parts are now on the right side of the production rules.

#### Could removing left recursion like you did be done automatically?

Yes, removing left recursion could be done automatically by using a left recursion removal algorithm during the parser generation. The algorithm systematically finds left recursive rules in the grammar and rewrites them to eliminate left recursion, but it also creates new non-terminals and transforms the production rules.

#### (Gradescope) 2.1 Explain how you used the grammar from part 1 and removed the left recursion.

I’ve reordered the grammar rules for my `additive_expression` and `multiplicative_expression` to eliminate left recursion.

Original rule:
```
additive_expression : multiplicative_expression
                    | additive_expression PLUS multiplicative_expression
                    | additive_expression MINUS multiplicative_expression
```

Modified rule:
```
additive_expression : multiplicative_expression
                    | multiplicative_expression PLUS additive_expression
                    | multiplicative_expression MINUS additive_expression
```

In my original `additive_expression` rule, the `additive_expression` non-terminal symbol is on the left side of the production rules, which causes left recursion. I’ve rewritten the rule to have the recursive part (`additive_expression`) on the right side of the production rules. The modified rule lets `additive_expression` to be derived from a `multiplicative_expression` optionally followed by a `PLUS` or `MINUS` operator and another `additive_expression`.

Original rule:
```
multiplicative_expression : unary_expression
                          | multiplicative_expression TIMES unary_expression
                          | multiplicative_expression DIVIDE unary_expression
```

Modified rule:
```
multiplicative_expression : unary_expression
                          | unary_expression TIMES multiplicative_expression
                          | unary_expression DIVIDE multiplicative_expression
```

Similarly to my `additive_expression` rule, my original `multiplicative_expression` rule had left recursion, with the non-terminal symbol on the left side of the production rules. My modified rule eliminates left recursion by placing the recursive part (`multiplicative_expression`) on the right side of the production rules. My modified rule lets `multiplicative_expression` to be derived from `unary_expression` optionally followed by a `TIMES` or `DIVIDE` operator and another `multiplicative_expression`.

## Part 3

#### Is your grammar predictive? Explain how you can know that.

Yes, my grammar is predictive because for each non-terminal, the First sets of the production rules are disjoint with no common symbols between the First sets of different production rules for the same non-terminal. For example, the First sets for the production rules of my `statement` non-terminal (`Rule 4` to `Rule 9`) are distinct and do not overlap. If a non-terminal has a production rule that can derive an empty string, the Follow set of that non-terminal shouldn’t intersect with the First sets of its other production rules.

#### How would you automate finding these sets?
I would automate finding First and Follow sets by using an algorithm to compute these sets based on the grammar rules. 

For First sets, I would initialize an empty First set for each non-terminal, and then, for each production rule, if the first symbol is a terminal, then add it to the First set of the non-terminal. If the first symbol is a non-terminal, then recursively compute its First set and add it to the First set of the current non-terminal. If a production rule can derive an empty string, add the empty string to the First set of the non-terminal.

For Follow sets, I would initialize an empty Follow set for each non-terminal and add an end-of-input marker (`$`) to the Follow set of the start symbol. For each production rule, if a non-terminal is on the right-hand side, add the First set of the symbol following it to the Follow set of the non-terminal. If a non-terminal is at the end of a production rule or is followed by a null non-terminal, then add the Follow set of the left-hand-side non-terminal to the Follow set of the current non-terminal.

#### (Gradescope) 3.1 Explain the approach that you used to find the first sets.

I found the First sets by initializing an empty First set for each non-terminal. For each production rule, if the right-hand side starts with a terminal symbol, then add it to the first set of the left-hand side non-terminal. If the RHS starts with a non-terminal symbol, recursively find the first-set of that non-terminal and add it to the First set of the LHS non-terminal. If the RHS can derive an empty string, then add the empty string to the First set of the LHS non-terminal. 

#### (Gradescope) 3.2 Explain the approach that you used to find the follow-up sets.

I found the Follow-up sets by initializing an empty Follow-up set for each non-terminal symbol and adding an end-of-input marker (`$`) to the Follow-up set of the start symbol. For each production rule, if a non-terminal symbol on the right-hand side is followed by a terminal symbol, then add that terminal symbol to the Follow-up set. If the non-terminal symbol on the RHS is followed by a non-terminal symbol, then recursively find the First set of the non-terminal symbol and add it to the Follow-up set of the non-terminal symbol. If the First set of the non-terminal symbol contains an empty string, then add the Follow-up set of the LHS non-terminal to the follow-up set of the non-terminal. 

## PLY (Python Lex-Yacc)

#### Did it help you design your grammar?

PLY helped me designed and test my grammar by letting me create lever and parser rules separately and test the grammar against input strings without worrying about the low-level implementation of designing a lever and parser from scratch.

#### Was it useful to be able to test?

Yes, PLY was useful in being able to test and verify if my grammar is working as expected because it helped me catch issues or ambiguities in my grammar.

#### Did you find its interface intuitive or difficult?

I find PLY’s interface intuitive because the naming conventions for tokens and production rules are straightforward, and the actions associated with each rule are defined as familiar Python code within the functions.
