%baseclass-preinclude <iostream>

%lsp-needed

%token T_PROGRAM
%token T_BEGIN
%token T_END
%token T_INTEGER 
%token T_BOOLEAN
%token T_TIME_TYPE
%token T_SKIP
%token T_IF
%token T_ELSE
%token T_WHILE
%token T_READ
%token T_WRITE
%token T_HOUR
%token T_MINUTE
%token T_SEMICOLON
%token T_ASSIGN
%token T_OPEN
%token T_CLOSE
%token T_NUM
%token T_TRUE
%token T_FALSE
%token T_ID
%token T_TIME
%token T_BO;
%token T_BC;
%token T_BOO;
%token T_BCC;
%token T_ARRAY;
%token T_COMMA;

%left T_OR T_AND
%left T_EQ
%left T_LESS T_GR
%left T_ADD T_SUB
%left T_MUL T_DIV T_MOD
%nonassoc T_NOT

%start program

%%

program:
    T_PROGRAM T_ID declarations T_BEGIN statements T_END
    {
        std::cout << "start -> T_PROGRAM T_ID declarations T_BEGIN statements T_END" << std::endl;
    }
;

declarations:
    // empty
    {
        std::cout << "declarations -> epsilon" << std::endl;
    }
|
    declaration declarations
    {
        std::cout << "declarations -> declaration declarations" << std::endl;
    }
;

declaration:
    T_INTEGER T_ID T_SEMICOLON
    {
        std::cout << "declaration -> T_INTEGER T_ID T_SEMICOLON" << std::endl;
    }
|
    T_BOOLEAN T_ID T_SEMICOLON
    {
        std::cout << "declaration -> T_BOOLEAN T_ID T_SEMICOLON" << std::endl;
    }
|
    T_TIME_TYPE T_ID T_SEMICOLON
    {
        std::cout << "declaration -> T_BOOLEAN T_ID T_SEMICOLON" << std::endl;
    }
|
    T_INTEGER T_ARRAY T_ID T_BOO expression T_BCC T_SEMICOLON
    {
        std::cout << "declaration -> T_INTEGER T_ARRAY T_ID T_BOO expression T_BCC" << std::endl;
    }
;

statements:
    statement
    {
        std::cout << "statements -> statement" << std::endl;
    }
|
    statement statements
    {
        std::cout << "statements -> statement statements" << std::endl;
    }
;

statement:
    T_SKIP T_SEMICOLON
    {
        std::cout << "statement -> T_SKIP T_SEMICOLON" << std::endl;
    }
|
    assignment
    {
        std::cout << "statement -> assignment" << std::endl;
    }
|
    read
    {
        std::cout << "statement -> read" << std::endl;
    }
|
    write
    {
        std::cout << "statement -> write" << std::endl;
    }
|
    branch
    {
        std::cout << "statement -> branch" << std::endl;
    }
|
    loop
    {
        std::cout << "statement -> loop" << std::endl;
    }
;

num_sem:
    expression T_COMMA num_sem
    {
        std::cout << "num_sem -> expression T_COMMA" << std::endl;
    }
|
    expression
    {
        std::cout << "num_sem -> expression" << std::endl;
    }
;

assignment:
    T_ID T_ASSIGN expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_ASSIGN expression T_SEMICOLON" << std::endl;
    }
|
    T_ID T_BOO T_BCC T_EQ T_BO num_sem T_BC T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_BOO T_BCC T_ASSIGN T_EQ T_BO num_sem T_BC T_SEMICOLON" << std::endl;
    }
|
    T_ID T_BOO expression T_BCC T_ASSIGN expression T_SEMICOLON
    {
        std::cout << "assignment -> T_ID T_BOO T_BCC T_ASSIGN expression T_SEMICOLON" << std::endl;
    }
;

read:
    T_READ T_OPEN T_ID T_CLOSE T_SEMICOLON
    {
        std::cout << "read -> T_READ T_OPEN T_ID T_CLOSE T_SEMICOLON" << std::endl;
    }
|
    T_READ T_OPEN T_ID T_BOO expression T_BCC T_CLOSE T_SEMICOLON
    {
        std::cout << "read -> T_READ T_OPEN T_ID T_BOO expression T_CLOSE T_SEMICOLON" << std::endl;
    }
;

write:
    T_WRITE T_OPEN expression T_CLOSE T_SEMICOLON
    {
        std::cout << "write -> T_WRITE T_OPEN expression T_CLOSE T_SEMICOLON" << std::endl;
    }
;

branch:
    T_IF expression T_BEGIN statements T_END
    {
        std::cout << "branch -> T_IF expression T_THEN statements T_ENDIF" << std::endl;
    }
|
    T_IF expression T_BEGIN statements T_END T_ELSE T_BEGIN statements T_END
    {
        std::cout << "branch -> T_IF expression T_THEN statements T_ELSE statements T_ENDIF" << std::endl;
    }
;

loop:
    T_WHILE expression T_BEGIN statements T_END
    {
        std::cout << "loop -> T_WHILE expression T_DO statements T_DONE" << std::endl;
    }
;

expression:
    T_NUM
    {
        std::cout << "expression -> T_NUM" << std::endl;
    }
|
    T_TRUE
    {
        std::cout << "expression -> T_TRUE" << std::endl;
    }
|
    T_FALSE
    {
        std::cout << "expression -> T_FALSE" << std::endl;
    }
|
    T_TIME
    {
        std::cout << "expression -> T_TIME" << std::endl;
    }
|
    T_ID
    {
        std::cout << "expression -> T_ID" << std::endl;
    }
|
    expression T_ADD expression
    {
        std::cout << "expression -> expression T_ADD expression" << std::endl;
    }
|
    expression T_SUB expression
    {
        std::cout << "expression -> expression T_SUB expression" << std::endl;
    }
|
    expression T_MUL expression
    {
        std::cout << "expression -> expression T_MUL expression" << std::endl;
    }
|
    expression T_DIV expression
    {
        std::cout << "expression -> expression T_DIV expression" << std::endl;
    }
|
    expression T_MOD expression
    {
        std::cout << "expression -> expression T_MOD expression" << std::endl;
    }
|
    expression T_LESS expression
    {
        std::cout << "expression -> expression T_LESS expression" << std::endl;
    }
|
    expression T_GR expression
    {
        std::cout << "expression -> expression T_GR expression" << std::endl;
    }
|
    expression T_EQ expression
    {
        std::cout << "expression -> expression T_EQ expression" << std::endl;
    }
|
    expression T_AND expression
    {
        std::cout << "expression -> expression T_AND expression" << std::endl;
    }
|
    expression T_OR expression
    {
        std::cout << "expression -> expression T_OR expression" << std::endl;
    }
|
    T_NOT expression
    {
        std::cout << "expression -> T_NOT expression" << std::endl;
    }
|
    T_OPEN expression T_CLOSE
    {
        std::cout << "expression -> T_OPEN expression T_CLOSE" << std::endl;
    }
|
    T_HOUR T_OPEN T_ID T_CLOSE
    {
        std::cout << "expression -> T_HOUR T_OPEN expression T_CLOSE" << std::endl;
    }
|
    T_MINUTE T_OPEN T_ID T_CLOSE
    {
        std::cout << "expression -> T_HOUR T_OPEN expression T_CLOSE" << std::endl;
    }
|
    T_ID T_BOO expression T_BCC
    {
        std::cout << "expression -> T_ID T_BOO expression T_BCC" << std::endl;
    }
;
