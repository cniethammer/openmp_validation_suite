#include <omp.h>

float x=0.0;
int y=0;
#pragma omp threadprivate(x,y)

void init ()
{
  #pragma omp single copyprivate(x,y)
  {
    x=1.0;
    y=1;
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
