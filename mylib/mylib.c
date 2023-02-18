#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mylib.h"

char* make_greeting(char* name) {
  int name_length = strlen(name);
  int buffer_size = name_length + 1000; // 9 = strlen("Hello !")
  char* buff = malloc(buffer_size);

  snprintf(buff, buffer_size, "Hello %s!", name);
  return buff;
}

void free_greeting(char* greeting) {
  free(greeting);
}
