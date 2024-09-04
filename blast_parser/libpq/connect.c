//
//  connect.c
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "connect.h"

#pragma mark **** private vars ****
static PGconn *sConn = NULL;


#pragma mark **** Connection to the database ****
void PSDConnectToMainDB(void) {
    PSDConnectToDB("postgres");
}

// NOTE: It must be paired with a PSDCloseConnection()
void PSDConnectToDB(const char *database) {
    const size_t bufferSize = 80;
    char conninfo[bufferSize];
    int charNumber = snprintf(conninfo, bufferSize - 1, "dbname = %s", database);
    if (sConn == NULL && charNumber > 9) {
        /* Make a connection to the database */
        sConn = PQconnectdb(conninfo);

        /* Check to see that the backend connection was successfully made */
        if (PQstatus(sConn) != CONNECTION_OK) {
            fprintf(stderr, "%s", PQerrorMessage(sConn));
            PSDHandleFatalError();
        }
        
        /* Set always-secure search path, so malicious users can't take control. */
        PSDExecute("SELECT pg_catalog.set_config('search_path', '', false)");
    }
}

// NOTE: It must be paired with a PSDConnectToDB()
void PSDCloseConnectionToDB(void) {
    if (sConn != NULL) {
        PQfinish(sConn);
        sConn = NULL;
    }
}

#pragma mark **** Execution ****
void PSDExecute(const char *command) {
    assert(sConn != NULL);
    PGresult *result = PQexec(sConn, command);
    ExecStatusType status = PQresultStatus(result);
    
    if (status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK) {
        fprintf(stderr, "SET failed: %s", PQerrorMessage(sConn));
        PQclear(result);
        PSDHandleFatalError();
    }
    
    // Avoid memory leaks
    PQclear(result);
}

PGresult* PSDExecuteWithResult(const char *command) {
    assert(sConn != NULL);
    PGresult *result = PQexec(sConn, command);
    ExecStatusType status = PQresultStatus(result);
    
    if (status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK) {
        fprintf(stderr, "SET failed: %s", PQerrorMessage(sConn));
        PQclear(result);
        PSDHandleFatalError();
    }
   
    return(result);
}

void PSDHandleFatalError(void) {
    if (sConn != NULL) {
        PQfinish(sConn);
        sConn = NULL;
    }
    
    exit(1);
}

