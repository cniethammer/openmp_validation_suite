#include <stdio.h>
#include "compile_info.h"

int main(void) {
  char info_str[120];
  get_compiler_info(info_str);
  printf("%s", info_str);
  return 0; 
}
