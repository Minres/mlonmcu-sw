#include "ml_interface.h"
// #include "printf.h" // this fix one issue of ara llvm, there are still other issues.
#include <stdio.h>

void init_target();
void deinit_target();

int main() {
  printf("Program start.\n");
  init_target();
  mlif_run();
  deinit_target();
  printf("Program finish.\n");
  return 0;
}
