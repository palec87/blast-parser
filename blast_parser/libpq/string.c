//
//  string.c
//  blast_parser
//
//  Created by João Varela on 01/09/2024.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "string.h"

char* concat(const char *header, const char **words, size_t num_words)
{
    size_t message_len = strlen(header) + 1; /* + 1 for terminating NULL */
    char *message = (char*)malloc(message_len);
    strncat(message, header, message_len);

    for(int i = 0; i < num_words; ++i) {
       message_len += 1 + strlen(words[i]); /* 1 + for separator ';' */
       message = (char*)realloc(message, message_len);
       strncat(strncat(message, " ", message_len), words[i], message_len);
    }

    return(message);
}
