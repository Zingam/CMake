#include <mkvparser.hpp>
#include <mkvreader.hpp>

#include <stdio.h>

int main (int argc, char* argv []) 
{
    FILE* webmFile = nullptr;
    mkvparser::MkvReader mkvReader { webmFile };
    auto result = mkvReader.Open ("Vid1.webm");
    if (!result)
    {
        printf ("Unable to open Vid1.webm");

        return -1;
    }
}
