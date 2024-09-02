//
//  libpq-bp.h
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

#ifndef libpq_h
#define libpq_h

#include <stdbool.h>

#pragma mark **** private constants ****
#define maxBufferSize 1001
#define mainDB "postgres"

// table can be NULL
void PSDCreateDatabase(const char *database,
                       const char *table,
                       const char *columns);

void PSDDeleteDatabase(const char *database);

void PSDCreateTable(const char *table,
                    const char *columns);

bool PSDDoesExist(const char *database);

#endif /* libpq_h */
