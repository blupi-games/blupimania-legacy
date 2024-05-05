#include "blpinfo.h"



struct blpinfo blpinfo = {220, 1,7,2} ;


void fatalerror(char *s)
{
  printf (s) ;
  exit (0) ;
}

main ()
{
  init_sound () ;
  playsoundblast (5) ;
}

