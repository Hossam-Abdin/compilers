// Generated by Bisonc++ V4.04.01 on Fri, 05 Sep 2014 17:25:54 +0200

#ifndef Parser_h_included
#define Parser_h_included

// $insert baseclass
#include "Parserbase.h"
#include <FlexLexer.h>

#undef Parser
class Parser: public ParserBase
{
        
    public:
        Parser(std::istream& inFile) : lexer( &inFile, &std::cerr ), label_index(0) {}
        int parse();

    private:
        yyFlexLexer lexer;

        std::map<std::string,var_data> symbol_table;
        std::map<std::string,var_data> label_table;
        std::string new_label();
        long long label_index;

        void error(char const *msg);    // called on (syntax) errors
        int lex();                      // returns the next token from the
                                        // lexical scanner. 
        void print();                   // use, e.g., d_token, d_loc

    // support functions for parse():
        void executeAction(int ruleNr);
        void errorRecovery();
        int lookup(bool recovery);
        void nextToken();
        void print__();
        void exceptionHandler__(std::exception const &exc);
};


#endif