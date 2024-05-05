
#include <dos.h>
#include <stdio.h>


#define mouse(x)  {_AX = x;geninterrupt(0x33);}

static int mousebut = 0;	/* state of mouse but */


/*  rend des codes sp‚ciaux si les boutons de la
 *  souris ont ‚t‚ press‚s ou relƒch‚s
 */

static int mousecode ()
{
  static int buttons ;
  static int pushr ;
  static int relr ;
  static int pushl ;
  static int rell ;

    if (pushl == 0)
    {
      _BX = 0 ;
      mouse(5) ;
      pushl = _BX ;
      if (pushl > 0)
	return 1 ;
    }
    else
    {
      _BX = 0 ;
      mouse(6) ;
      rell = _BX ;

      if (rell > 0)
      {
	pushl = 0 ;
	rell = 0 ;
	return 11 ;
      }
    }

    if (pushr == 0)
    {
      _BX = 1 ;
      mouse(5) ;
      pushr = _BX ;
      if (pushr > 0)
	return 2 ;
    }
    else
    {
      _BX = 1 ;
      mouse(6) ;
      relr = _BX ;

      if (relr > 0)
      {
	pushr = 0 ;
	relr = 0 ;
	return 12 ;
      }
    }
  return 0 ;
}



main ()
{
  static int c = 0 ;

  while (1)
  {
    int m ;
    printf ("*\n") ;
    delay (200) ;
    m = mousecode () ;
    if (m)
      printf ("%d\n", m) ;
  }
}