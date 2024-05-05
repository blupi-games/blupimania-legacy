
#include "bm_x.h"
#include "te_pc.h"
#include <bios.h>
#include <dos.h>


void clrfifo (void) ;



#define INTR 0X1C    /* The clock tick interrupt */


void interrupt ( *oldhandler)(void);

int count=0;

void interrupt handler(void)
{
/* increase the global counter */
   count++;

   timer_int () ;

/* call the old routine */
   oldhandler();
}

main ()
{
  int i, k ;

  char s[1000] ;

  int far *p, far *nextp, far *last;

  openmachine () ;


/* save the old interrupt vector */
   oldhandler = getvect(INTR);

/* install the new interrupt handler */
   setvect(INTR, handler);


    {				/* tell the timer to speed up the ticks */
      long timerSpeed = 0x10000L / 4;
      disable ();
      outp (0x43, 0x36);
      outp (0x40, timerSpeed & 0xff);
      outp (0x40, timerSpeed >> 8);
      enable ();
    }

  text_mode () ;

#if 0
  nextp = MK_FP (0x40, 0x1a) ;
  p = MK_FP (0x40, *nextp) ;

  printf ("%p %x %p\n", nextp, *nextp, p) ;

  *p++ = 65*256 + 30 ;

  *nextp += 2 ;

  k = bioskey (0) ;
  printf ("%x", k) ;

#endif

#if 0
  for (i = 0 ; i < 200 ; i++)
  {
    k = bioskey (0) ;
    printf ("%x\n", k) ;
  }

  goto end ;

  printf ("delay") ;
  delay (3000) ;
  printf ("end delay") ;
  clrfifo ();
  scanf ("%s", &s) ;
#endif

#if 0
  if (1)
  while (1)  // for (i = 0 ; i < 2000 ; )
  {
    if ((k = bioskey (1)) != 0)
      k = bioskey (0) ;
    clrfifo () ;
    printf ("xxxx %4x %4x\n", k, Key_Code) ;
    if (Key_Code == 1)
      break ;
  }

#endif

#if 1


  for (;;)
  {
    int son ;
    scanf ("%d", &son) ;
    playsound (son) ;
    if (son == 0)
      break ;
  }


#endif

end:
  closemachine () ;

  /* reset the old interrupt handler */
   setvect(INTR, oldhandler);


}