
#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <string.h>
#include <mem.h>
#include <bios.h>
#include <dos.h>
#include <conio.h>
#include "muspl.h"


void interrupt (*oldHandler) () = NULL;
int timerDivisor = 1 ;
int interruptCount ;



static void interrupt
FMISR (__CPPARGS)
{
  if (++interruptCount >= timerDivisor / 4)
    {
      interruptCount = 0;
	timer_int () ;
    }
  enable () ;
}




static void
FMInstallISR (int td)
{
  unsigned int timerSpeed;
  timerDivisor = td;
  if (td != 1)
    {                           /* tell the timer to speed up the ticks */
      timerSpeed = 0x10000L / td;
      disable ();
      outp (0x43, 0x36);
      outp (0x40, timerSpeed & 0xff);
      outp (0x40, timerSpeed >> 8);
      enable ();
    }

  oldHandler = getvect (0x1c);
  setvect (0x1c, FMISR);
}



static void
FMRemoveISR (void)
{
  if (oldHandler)
    {
      setvect (0x1c, oldHandler);
      if (timerDivisor != 1)
	{                       /* return the ticks to normal speed */
	  disable ();
	  outp (0x43, 0x36);
	  outp (0x40, 0);
	  outp (0x40, 0);
	  enable ();
	}
    }
}




int FMMusicInit (void)
{


/*  La ISR du timer est install‚ de toute fa‡on
    pour la raison suivante:

    La ISR du timer pour BLUPI est acc‚ler‚ d'un facteur
    4 par rapport … la fr‚quence par d‚faut.

    La ISR FM doit ˆtre acc‚l‚r‚ d'un facteur 8 par
    rapport … la normale.

    Donc: on installa d'abord la ISR BLUPI.
	  Ensuite on installe la ISR FM tout en acc‚l‚rant
	  le timer d'un facteur 8. Cette ISR appellera la
	  ISR timer BLUPI une fois sur deux, et la routine
	  ISR timer BLUPI appellera la routine par d‚faut une
	  fois sur 4.

	  La fonction trap_interrupts du module TE_TIM.ASM
	  ne modifie donc plus la vitesse du timer.

	  FMMusicInit doit ˆtre appel‚e aprŠs trap_interrupts !!
*/


    FMInstallISR (8) ;


    return 0 ;
}



void FMMusicDeinit (void)
{
  FMRemoveISR () ;
}

