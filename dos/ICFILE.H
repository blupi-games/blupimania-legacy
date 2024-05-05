
#define ICFILEMAGIC 0x2345c987
#define MAXSUBICFILES 10

struct icfiledir
{
  long magic ;
  int nbfiles ;
  long offset[MAXSUBICFILES] ;
} ;
