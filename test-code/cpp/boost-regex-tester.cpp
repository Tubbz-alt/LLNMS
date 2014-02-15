#include <iostream>
#include <string>
#include <boost/regex.hpp>  // Boost.Regex lib

using namespace std;

/**
 * Main Function
*/
int main( int argc, char* argv[]  ) {

    cout << "String    : " << argv[1] << endl;
    cout << "Expression: " << argv[2] << endl;
    std::string s, sre;
    boost::regex re;

    s = argv[1];
    re = argv[2];

    if (boost::regex_match(s, re)){
        cout << re << " matches " << s << endl;
    }else{
        cout << re << " does not match " << s << endl;
    }

    return 0;

}
