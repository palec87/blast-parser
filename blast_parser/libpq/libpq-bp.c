//
//  libpq-bp.c
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

#include <stdio.h>
#include <string.h>

#include "libpq-bp.h"
#include "connect.h"
#include "parser.h"

#pragma mark **** private constants ****
size_t bufferSize = maxBufferSize;

#pragma mark **** private functions ****

void PSDCreateDatabase(const char *database,
                       const char *table,
                       const char *columns) {
    PSDConnectToDB(database);
    if (table != NULL && columns != NULL) {
        PSDCreateTable(table, columns);
    }
}

void PSDDeleteDatabase(const char *database) {
    if (strcmp(database, mainDB) != 0) {
        size_t maxLength = bufferSize - 1;
        char command[bufferSize];
        const char *fmt = "DROP DATABASE %s;";
        int charNumber = snprintf(command, maxLength, fmt, database);
        
        if (charNumber < 1) {
            PSDHandleFatalError();
        } else {
            PSDConnectToMainDB();
            PSDExecute(command);
        }
    } else {
        fprintf(stderr, "You cannot delete the default database.");
        PSDHandleFatalError();
    }
}

void PSDCreateTable(const char *table,
                    const char *columns) {
    size_t maxLength = bufferSize - 1;
    char command[bufferSize];
    const char *fmt = "CREATE TABLE %s {%s};";
    int charNumber = snprintf(command, maxLength, fmt, table, columns);
    
    if (charNumber < 1) {
        PSDHandleFatalError();
    } else {
        PSDExecute(command);
    }
}

bool PSDDoesExist(const char *database) {
    const char *fmt = "select exists("
                          "SELECT datname "
                          "FROM pg_catalog.pg_database "
                          "WHERE datname = '%s');";
    size_t maxLength = bufferSize - 1;
    char command[bufferSize];
    int charNumber = snprintf(command, maxLength, fmt, database);
    if (charNumber < 1) {
        PSDHandleFatalError();
    }
    PGresult *result = PSDExecuteWithResult(command);
    return PSDParseBool(result);
}
