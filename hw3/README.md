[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/rRXaHrq-)
# HW3-sp24

Please submit parser.py, scanner.py and grammar.txt

## Part1: A recursive descent parser for C-simple

#### (Gradescope) 1.1 Contents of “grammar.txt” where you write down the grammar (and first+ sets) of the grammar you used in your parser.

`grammar.txt`:
```
Tokens
      MUL     *
      PLUS    +
      MINUS   -
      DIV     /
      EQ      ==
      LT      <
      LBRACE  {
      RBRACE  }
      LPAR    (
      RPAR    )
      SEMI    ;
      ID      // like in HW 1
      NUM     // like in HW 1
      ASSIGN  =
      FOR
      IF
      ELSE
      INT
      FLOAT
      
solution grammar with first+ sets in {}

statement_list := statement statement_list {INT, FLOAT, ID, IF, LBRACE, FOR}  
               |  ""   {RBRACE, None}

statement := declaration_statement  {INT, FLOAT}
          |  assignment_statement   {ID}
          |  if_else_statement      {IF}
          |  block_statement        {LBRACE}
          |  for_loop_statement     {FOR}
          |  single_statement       {INT, FLOAT, ID, IF, FOR}

declaration_statement  := INT ID SEMI   {INT} 
                       |  FLOAT ID SEMI {FLOAT} 

assignment_statement := assignment_statement_base SEMI {ID}

assignment_statement_base := ID ASSIGN expr {ID}

if_else_statement := IF LPAR expr RPAR single_statement ELSE single_statement {IF}

single_statement := block_statement     {LBRACE}
                  | declaration_statement {INT, FLOAT}
                  | assignment_statement  {ID}
                  | if_else_statement     {IF}
                  | for_loop_statement    {FOR}

block_statement := LBRACE statement_list RBRACE {LBRACE}

for_loop_statement := FOR LPAR assignment_statement expr SEMI assignment_statement_base RPAR single_statement {FOR}

expr := comp expr2        {NUM, ID, LPAR}
expr2 := EQ comp expr2    {EQ}
      | ""                {SEMI, RPAR}

comp := factor comp2      {NUM, ID, LPAR} 
comp2 := LT factor expr2  {LT} 
      | ""                {SEMI, RPAR, EQ, PLUS, MINUS}

factor := term factor2         {NUM, ID, LPAR} 
factor2 := PLUS term factor2   {PLUS}
        | MINUS  term factor2  {MINUS}
        | ""                   {SEMI, RPAR, EQ, LT}

term := unit term2        {NUM, ID, LPAR} 
term2 := DIV unit term2   {DIV}
      | MUL  unit term2   {MUL}
      | ""                {SEMI, RPAR, EQ, LT, PLUS, MINUS}

unit := NUM {NUM}
     |  ID  {ID} 
     |  LPAR expr RPAR {LPAR}
```

#### (Gradescope) 1.2 Tests and contents of “outcomes.txt”. Mention the tests you added for testing. Also, for each test, please write the expected outcome: that is, if it should pass or fail, and on what line number it should fail.
`test01.txt`:
```
int x;
int y;
x = 1;
y = x;
y = y + x + 1.1 - 5 * 1;

if (x == 1) {
    x = x + y;
} else {
    x = x - 1;
}

for (x = 0; x < 1; x = x + 1) {
    y = y + 1;
}

```

`test02.txt`:
```
int x;
x = 0;
if (x < 0) {
    x = = x + 1;
} else {
    x = x - 1;
}

```

`test03.txt`:
```
int x;
x = 0;
if (x < 0)
    x = x + 1;
else {
    x = x - 1;
}

```

`test04.txt`:
```
int x
x = 0;
for (x = 0; x < 10; x = x + 1) {
    y = y + 1;
}

```

`outcomes.txt`:
```
# describe the outcomes of your test cases here

Part 1: 

test01.txt: pass

test02.txt: fail: ParserException: Parser error on line: 4
3 | if (x < 0) {
4 |     x = = x + 1;
  |         ^ Expected one of [<Token.NUM: 'NUM'>, <Token.ID: 'ID'>, <Token.LPAR: 'LPAR'>] but got (Token.ASSIGN,"=")

test03.txt: pass

test04.txt: fail: ParserException: Parser error on line 1
  |
1 | int x
  |     ^ Expected one of [<Token.SEMI: 'SEMI'>] but got (Token.ID,"x")

... 
```
## Part2: Adding a symbol table to your parser

#### (Gradescope) 2.1 Tests and contents of “outcomes.txt”. Mention the tests you added for testing. Also, for each test, please write the expected outcome: that is, if it should pass or fail, and on what line number it should fail.

`test05.txt`:
```
int x;
float y;
x = 1;
y = 2.5;

if (x < y) {
    x = x + 1;
} else {
    y = y - 1;
}

```

`test06.txt`:
```
int x;
x = 1;

if (x < y) {
    x = x + 1;
} else {
    y = y - 1;
}

```

`test07.txt`:
```
int x;
x = 1;

{
    int x;
    x = 2;
    {
        int y;
        y = x + 1;
    }
    x = x + 1;
}

x = x + 1;

```

`test08.txt`:
```
int x;
x = 1;

{
    int x;
    x = 2;
    {
        int y;
        y = x + 1;
    
    x = x + 1;

}

x = x + 1;

```

`outcomes.txt` (cont.):
```
...
Part 2:

test05.txt: pass

test06.txt: fail: SymbolTableException: Symbol table error on line 4
  |
4 | if (x < y) {
  |         ^ Undeclared ID of y

test07.txt: pass

test08.txt: fail: ParserException: Parser error on line: 15
   |
15 | x = x + 1;
   |           ^ Expected one of [<Token.RBRACE: 'RBRACE'>] but got None

```