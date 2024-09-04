//
//  libpq-bp.c
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "libpq-bp.h"
#include "connect.h"
#include "parser.h"

#pragma mark **** private constants ****
size_t bufferSize = maxBufferSize;

#pragma mark **** private functions ****

void PSDBegin(const char* database) {
    PSDConnectToDB(database);
}

void PSDBeginWithDefaultDB(void) {
    PSDConnectToMainDB();
}

void PSDEnd(void) {
    PSDCloseConnectionToDB();
}

void PSDCreateDB(const char *database) {
    size_t maxLength = bufferSize - 1;
    char command[bufferSize];
    const char *fmt = "CREATE DATABASE %s;";
    int charNumber = snprintf(command, maxLength, fmt, database);
    
    if (charNumber < 1) {
        PSDHandleFatalError();
    } else {
        PSDExecute(command);
    }
}

void PSDCreateDatabase(const char *database,
                       const char *table,
                       const char *columns) {
    if (table != NULL && columns != NULL) {
        PSDCreateDB(database);
        PSDCreateTable(table, columns);
    } else {
        fprintf(stderr, "%s", "Either the name of the table or columns was NULL.");
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
