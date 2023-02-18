#include <stdio.h>
#include <stdlib.h>
#include <mylib.h>

int main(int argc, char* argv[]) {
  if (argc != 2) {
    printf("Usage: %s <outpath>\n", argv[0]);
    exit(1);
  }

  char* greeting = make_greeting("generator");
  FILE* out = fopen(argv[1], "w");
  if (out == NULL) {
    perror("Opening File failed");
    exit(1);
  }

  fprintf(out, 
    "#include <stdio.h>\n\
void generated() {\n\
  puts(\"%s\");\n\
}\n\
", greeting);


  fclose(out);
  free_greeting(greeting);
  return 0;
}
