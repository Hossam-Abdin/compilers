// Generated by Bisonc++ V5.02.00 on Sun, 18 Oct 2020 15:09:33 +0200

#ifndef ParserBase_h_included
#define ParserBase_h_included

#include <exception>
#include <vector>
#include <iostream>
// $insert preincludes
#include <iostream>

namespace // anonymous
{
    struct PI__;
}



class ParserBase
{
    public:
        enum DebugMode__
        {
            OFF           = 0,
            ON            = 1 << 0,
            ACTIONCASES   = 1 << 1
        };

// $insert tokens

    // Symbolic tokens:
    enum Tokens__
    {
        T_PROGRAM = 257,
        T_BEGIN,
        T_END,
        T_FUNCTION,
        T_RETURN,
        T_INTEGER,
        T_BOOLEAN,
        T_SKIP,
        T_IF,
        T_THEN,
        T_ELSE,
        T_ENDIF,
        T_WHILE,
        T_DO,
        T_DONE,
        T_READ,
        T_WRITE,
        T_SEMICOLON,
        T_ASSIGN,
        T_OPEN,
        T_CLOSE,
        T_NUM,
        T_TRUE,
        T_FALSE,
        T_ID,
        T_OR,
        T_AND,
        T_EQ,
        T_LESS,
        T_GR,
        T_ADD,
        T_SUB,
        T_MUL,
        T_DIV,
        T_MOD,
        T_NOT,
    };

// $insert LTYPE
    struct LTYPE__
    {
        int timestamp;
        int first_line;
        int first_column;
        int last_line;
        int last_column;
        char *text;
    };
    
// $insert STYPE
typedef int STYPE__;

    private:
        int d_stackIdx__ = -1;
        std::vector<size_t>   d_stateStack__;
        std::vector<STYPE__>  d_valueStack__;
// $insert LTYPEstack
        std::vector<LTYPE__>      d_locationStack__;

    protected:
        enum Return__
        {
            PARSE_ACCEPT__ = 0,   // values used as parse()'s return values
            PARSE_ABORT__  = 1
        };
        enum ErrorRecovery__
        {
            DEFAULT_RECOVERY_MODE__,
            UNEXPECTED_TOKEN__,
        };
        bool        d_actionCases__ = false;
        bool        d_debug__ = true;
        size_t      d_nErrors__ = 0;
        size_t      d_requiredTokens__;
        size_t      d_acceptedTokens__;
        int         d_token__;
        int         d_nextToken__;
        size_t      d_state__;
        STYPE__    *d_vsp__;
        STYPE__     d_val__;
        STYPE__     d_nextVal__;
// $insert LTYPEdata
        LTYPE__   d_loc__;
        LTYPE__  *d_lsp__;

        ParserBase();

        void ABORT() const;
        void ACCEPT() const;
        void ERROR() const;
        void clearin();
        bool actionCases() const;
        bool debug() const;
        void pop__(size_t count = 1);
        void push__(size_t nextState);
        void popToken__();
        void pushToken__(int token);
        void reduce__(PI__ const &productionInfo);
        void errorVerbose__();
        size_t top__() const;

    public:
        void setDebug(bool mode);
        void setDebug(DebugMode__ mode);
}; 

inline ParserBase::DebugMode__ operator|(ParserBase::DebugMode__ lhs, 
                                     ParserBase::DebugMode__ rhs)
{
    return static_cast<ParserBase::DebugMode__>(static_cast<int>(lhs) | rhs);
};

inline bool ParserBase::debug() const
{
    return d_debug__;
}

inline bool ParserBase::actionCases() const
{
    return d_actionCases__;
}

inline void ParserBase::ABORT() const
{
    throw PARSE_ABORT__;
}

inline void ParserBase::ACCEPT() const
{
    throw PARSE_ACCEPT__;
}

inline void ParserBase::ERROR() const
{
    throw UNEXPECTED_TOKEN__;
}

inline ParserBase::DebugMode__ operator&(ParserBase::DebugMode__ lhs,
                                     ParserBase::DebugMode__ rhs)
{
    return static_cast<ParserBase::DebugMode__>(
            static_cast<int>(lhs) & rhs);
}

// For convenience, when including ParserBase.h its symbols are available as
// symbols in the class Parser, too.
#define Parser ParserBase


#endif


