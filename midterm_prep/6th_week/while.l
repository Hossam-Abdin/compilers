%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
#include "Parserbase.h"
%}

DIGIT  		[0-9]
WS          [ \t\n\r]
LETTER      [a-zA-Z]

%%

program     return Parser::T_PROGRAM;
begin       return Parser::T_BEGIN;
end         return Parser::T_END;
integer     return Parser::T_INTEGER; 
boolean     return Parser::T_BOOLEAN;
time        return Parser::T_TIME_TYPE;
skip        return Parser::T_SKIP;
if          return Parser::T_IF;
else        return Parser::T_ELSE;
while       return Parser::T_WHILE;
read        return Parser::T_READ;
write       return Parser::T_WRITE;
hour        return Parser::T_HOUR;
minute      return Parser::T_MINUTE;
";"         return Parser::T_SEMICOLON;
":="        return Parser::T_ASSIGN;
"="         return Parser::T_EQ;
"<"         return Parser::T_LESS;
">"         return Parser::T_GR;
"+"         return Parser::T_ADD;
"-"         return Parser::T_SUB;
"*"         return Parser::T_MUL;
and         return Parser::T_AND;
or          return Parser::T_OR;
not         return Parser::T_NOT;
div         return Parser::T_DIV; 
mod         return Parser::T_MOD;
"("         return Parser::T_OPEN;
")"         return Parser::T_CLOSE;
"{"         return Parser::T_BO;
"}"         return Parser::T_BC;
"["         return Parser::T_BOO;
"]"         return Parser::T_BCC;
","         return Parser::T_COMMA;
array       return Parser::T_ARRAY;

{DIGIT}+	return Parser::T_NUM;
true        return Parser::T_TRUE;
false       return Parser::T_FALSE;

"#".*\n    // nothing to do

{LETTER}({LETTER}|{DIGIT}|_)*    return Parser::T_ID;
([0-1][0-9]|2[1-3]):([0-5][0-9]) return Parser::T_TIME;

{WS}+   // nothing to do

. {
    std::cerr << "Line " << lineno() << ": Lexical error." << std::endl;
    exit(1);
}

%%
