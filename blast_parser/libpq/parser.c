//
//  parser.c
//  blast_parser
//
//  Created by João Varela on 02/09/2024.
//

#include <stdbool.h>
#include <string.h>
#include "libpq-fe.h"
#include "parser.h"

bool PSDParseBool(PGresult *result) {
    int nFields = 0, nTuples = 0;
    char *nameStr = NULL, *boolStr = NULL;
    
    /* first, print out the attribute names */
    nFields = PQnfields(result);
    nTuples = PQntuples(result);
    if (nFields == 1 && nTuples == 1) {
        nameStr = PQfname(result, 0);
        boolStr = PQgetvalue(result, 0, 0);
    }

    PQclear(result);
    
    if (boolStr != NULL ) {
        if (strcmp(boolStr, "t") == 0) {
            return true;
        }
    }
    
    return false;
}


