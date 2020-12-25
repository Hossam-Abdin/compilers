#include <iostream>
#include <fstream>
#include <sstream>
#include "Parser.h"
#include <cstdlib>

using namespace std;

void input_handler( ifstream& in, int argc, char* argv[] );

int main( int argc, char* argv[] )
{
    ifstream in;
    input_handler( in, argc, argv );
    Parser pars( in );
    pars.parse();
    return 0;
}

void input_handler( ifstream& in, int argc, char* argv[] )
{
    if( argc < 2 )
    {
        cerr << "One command line argument expected." << endl;
        exit(1);
    }
    in.open( argv[1] );
    if( !in )
    {
        cerr << "Cannot open file: " << argv[1] << endl;
        exit(1);
    }
}
