#include <stdio.h>
#include <mylib.h>
#include "generated.h"

int main(int argc, char* argv[]) {
  puts("Hello");
  char* greeting = make_greeting("Lib");
  puts(greeting);
  free_greeting(greeting);
  generated();
  return 0;
}
