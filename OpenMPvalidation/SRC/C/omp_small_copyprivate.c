#include <omp.h>

float x=0.0;
#pragma omp threadprivate(x)

void init ()
{
  #pragma omp single copyprivate(x)
  {
    x=1.0;
  }
}

int main (int argc, char * argv[])
{
#pragma omp parallel
  {
    init ();
  }
  return 0;
}
