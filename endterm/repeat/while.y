%baseclass-preinclude "semantics.h"

%lsp-needed

%union
{
  std::string *name;
  std::string *code;
  expression_descriptor *expr_desc;
}

%type <expr_desc> expression
%type <code> statement statements assignment read write branch loop


%token T_PROGRAM
%token T_BEGIN
%token T_END
%token T_INTEGER 
%token T_BOOLEAN
%token T_SKIP
%token T_IF
%token T_THEN
%token T_ELSE
%token T_ENDIF
%token T_WHILE
%token T_DO
%token T_DONE
%token T_READ
%token T_WRITE
%token T_SEMICOLON
%token T_ASSIGN
%token T_OPEN
%token T_CLOSE
%token <name> T_NUM
%token T_TRUE
%token T_FALSE
%token <name> T_ID
%token T_REPEAT
%token T_UNTIL

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
        std::cout << "global main" << std::endl;
        std::cout << "extern read_unsigned, write_unsigned" << std::endl;
        std::cout << "extern read_boolean, write_boolean" << std::endl;
        std::cout << "segment .bss" << std::endl;
        for(std::pair<std::string,var_data> v : symbol_table)
        {
            if(v.second.decl_type == integer)
                std::cout << v.second.label << ": resd 1" << std::endl;
            if(v.second.decl_type == boolean)
                std::cout << v.second.label << ": resb 1" << std::endl;
        }
        std::cout << std::endl;
        std::cout << "segment .text" << std::endl;
        std::cout << "main:" << std::endl;
        std::cout << *$5 << std::endl;
        std::cout << "ret" << std::endl;
        delete $2;
        delete $5;
    }
;

declarations:
    // empty
    {
    }
|
    declaration declarations
    {
    }
;

declaration:
    T_INTEGER T_ID T_SEMICOLON
    {
        if( symbol_table.count(*$2) > 0 )
        {
            std::stringstream ss;
            ss << "Re-declared variable: " << *$2 << ".\n"
            << "Line of previous declaration: " << symbol_table[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        symbol_table[*$2] = var_data( d_loc__.first_line, integer, new_label() );
        delete $2;
    }
|
    T_BOOLEAN T_ID T_SEMICOLON
    {
        if( symbol_table.count(*$2) > 0 )
        {
            std::stringstream ss;
            ss << "Re-declared variable: " << *$2 << ".\n"
            << "Line of previous declaration: " << symbol_table[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        symbol_table[*$2] = var_data( d_loc__.first_line, boolean, new_label() );
        delete $2;
    }
;

statements:
    statement
    {
        $$ = $1;
    }
|
    statement statements
    {
        $$ = new std::string(*$1 + *$2);
        delete $1;
        delete $2;
    }
;

statement:
    T_SKIP T_SEMICOLON
    {
        $$ = new std::string("nop");
    }
|
    assignment
    {
        $$ = $1;
    }
|
    read
    {
        $$ = $1;
    }
|
    write
    {
        $$ = $1;
    }
|
    branch
    {
        $$ = $1;
    }
|
    loop
    {
        $$ = $1;
    }
;

assignment:
    T_ID T_ASSIGN expression T_SEMICOLON
    {
        if( symbol_table.count(*$1) == 0 )
        {
            std::stringstream ss;
            ss << "Undeclared variable: " << *$1 << std::endl;
            error( ss.str().c_str() );
        }
        if(symbol_table[*$1].decl_type != $3->expr_type)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        if($3->expr_type == integer)
            $$ = new std::string("" +
                    $3->expr_code +
                    "mov [" + symbol_table[*$1].label + "], eax\n");
        if($3->expr_type == boolean)
            $$ = new std::string("" +
                    $3->expr_code +
                    "mov [" + symbol_table[*$1].label + "], al\n");
        delete $1;
        delete $3;
    }
;

read:
    T_READ T_OPEN T_ID T_CLOSE T_SEMICOLON
    {
        if( symbol_table.count(*$3) == 0 )
        {
            std::stringstream ss;
            ss << "Undeclared variable: " << *$3 << std::endl;
            error( ss.str().c_str() );
        }
        if(symbol_table[*$3].decl_type == integer)
        {
            $$ = new std::string("call read_unsigned\nmov [" + symbol_table[*$3].label + "], eax\n");
        }
        if(symbol_table[*$3].decl_type == boolean)
        {
            $$ = new std::string("call read_boolean\nmov [" + symbol_table[*$3].label + "], al\n");
        }
        delete $3;
    }
;

write:
    T_WRITE T_OPEN expression T_CLOSE T_SEMICOLON
    {
        if($3->expr_type == integer)
        {
            $$ = new std::string("" +
                    $3->expr_code +
                    "push eax\n" +
                    "call write_unsigned\n" +
                    "add esp,4\n");
        }
        if($3->expr_type == boolean)
        {
            $$ = new std::string(
                    "xor eax, eax\n" +
                    $3->expr_code +
                    "push eax\n" +
                    "call write_boolean\n" +
                    "add esp,4\n");
        }
        delete $3;
    }
;

branch:
    T_IF expression T_THEN statements T_ENDIF
    {
        if($2->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        std::string end = new_label();
        $$ = new std::string("" +
                $2->expr_code +
                "cmp al, 1\n" +
                "jne near " + end + "\n" +
                *$4 +
                end + ":\n");
        delete $2;
        delete $4;
    }
|
    T_IF expression T_THEN statements T_ELSE statements T_ENDIF
    {
        if($2->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        std::string elsel = new_label();
        std::string end = new_label();
        $$ = new std::string("" +
                $2->expr_code +
                "cmp al, 1\n" +
                "jne near " + elsel + "\n" +
                *$4 +
                "jmp " + end + "\n" +
                elsel + ":\n" +
                *$6 +
                end + ":\n");
        delete $2;
        delete $4;
        delete $6;
    }
;

loop:
    T_WHILE expression T_DO statements T_DONE
    {
        if($2->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        std::string start = new_label();
        std::string end = new_label();
        $$ = new std::string("" +
                start + ":\n" +
                $2->expr_code +
                "cmp al, 1\n" +
                "jne near " + end + "\n" +
                *$4 +
                "jmp " + start + "\n" +
                end + ":\n");
        delete $2;
        delete $4;
    }
|
    T_REPEAT statements T_UNTIL expression T_DONE T_SEMICOLON
    {
        if($4->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        std::string start = new_label();
        std::string end = new_label();
        $$ = new std::string("" +
                start + ":\n" +
                *$2 +
                $4->expr_code +
                "cmp al, 1\n" +
                "je near " + end + "\n" +
                "jmp " + start + "\n" +
                end + ":\n");
        delete $4;        
    }
;

expression:
    T_NUM
    {
        $$ = new expression_descriptor(integer, "mov eax, " + *$1 + "\n");
    }
|
    T_TRUE
    {
        $$ = new expression_descriptor(boolean, "mov al, 1\n");
    }
|
    T_FALSE
    {
        $$ = new expression_descriptor(boolean, "mov al, 0\n");
    }
|
    T_ID
    {
        if( symbol_table.count(*$1) == 0 )
        {
            std::stringstream ss;
            ss << "Undeclared variable: " << *$1 << std::endl;
            error( ss.str().c_str() );
        }
        if(symbol_table[*$1].decl_type == integer)
        {
            $$ = new expression_descriptor(symbol_table[*$1].decl_type,
                    "mov eax, [" + symbol_table[*$1].label + "]\n");
        }
        if(symbol_table[*$1].decl_type == boolean)
        {
            $$ = new expression_descriptor(symbol_table[*$1].decl_type,
                    "mov al, [" + symbol_table[*$1].label + "]\n");
        }
        delete $1;
    }
|
    expression T_ADD expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(integer, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "add eax, ebx\n");
        delete $1;
        delete $3;
    }
|
    expression T_SUB expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(integer, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "sub eax, ebx\n");
        delete $1;
        delete $3;
    }
|
    expression T_MUL expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(integer, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "mul ebx\n");
        delete $1;
        delete $3;
    }
|
    expression T_DIV expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(integer, std::string("") +
                "xor edx, edx\n" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "div ebx\n");
        delete $1;
        delete $3;
    }
|
    expression T_MOD expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(integer, std::string("") +
                "xor edx, edx\n" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "div ebx\n" +
                "mov eax, edx\n");
        delete $1;
        delete $3;
    }
|
    expression T_LESS expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "cmp eax, ebx\n" +
                "setl al\n");
        delete $1;
        delete $3;
    }
|
    expression T_GR expression
    {
        if($1->expr_type != integer || $3->expr_type != integer)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "cmp eax, ebx\n" +
                "setg al\n");
        delete $1;
        delete $3;
    }
|
    expression T_EQ expression
    {
        if($1->expr_type != $3->expr_type)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $3->expr_code +
                "push eax\n" +
                $1->expr_code +
                "pop ebx\n" +
                "cmp eax, ebx\n" +
                "sete al\n");
        delete $1;
        delete $3;
    }
|
    expression T_AND expression
    {
        if($1->expr_type != boolean || $3->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $3->expr_code +
                "push ax\n" +
                $1->expr_code +
                "pop bx\n" +
                "and al, bl\n");
        delete $1;
        delete $3;
    }
|
    expression T_OR expression
    {
        if($1->expr_type != boolean || $3->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $3->expr_code +
                "push ax\n" +
                $1->expr_code +
                "pop bx\n" +
                "or al, bl\n");
        delete $1;
        delete $3;
    }
|
    T_NOT expression
    {
        if($2->expr_type != boolean)
        {
           std::stringstream ss;
           ss << d_loc__.first_line << ": Type error." << std::endl;
           error( ss.str().c_str() );
        }
        $$ = new expression_descriptor(boolean, "" +
                $2->expr_code +
                "xor al, 1\n");
        delete $2;
    }
|
    T_OPEN expression T_CLOSE
    {
        $$ = new expression_descriptor($2->expr_type, "" + $2->expr_code);
        delete $2;
    }
;
