
#include <bios.h>
#include <conio.h>
#include <string.h>
#include "..\blang\_lang.h"
#include "bm.h"

#define MARGE  3
#define MARGEINT 2


#define BACKGROUND BLUE
#define TEXT YELLOW
#define TEXTEVID LIGHTCYAN


// #define TESTEUR

static int textcol = TEXT ;



static int mystrlen (char *s)
{
  int retval = 0 ;
  char *p = s ;
  unsigned char c ;

  while (c = *p++)
    if (c > 10)
      retval++ ;

  return retval ;
}

static void ccprintf (char *line)
{
  int evid = 0 ;
  char tmp[100] ;
  char *q = tmp, *p = line, c ;

  while (c = *p++)
  {
    if (c == 1)
    {
      *q = 0 ;
      cprintf (tmp) ;
      q = tmp ;

      if (evid)
      {
	evid = 0 ;
	textcolor (textcol) ;
      }
      else
      {
	evid = 1 ;
	textcolor (TEXTEVID) ;
      }
    }
    else
      *q++ = c ;
  }
  *q = 0 ;
  cprintf (tmp) ;
}


void pline (char *line)
{
  int reste, i ;

  textcolor (textcol) ;
  textbackground (BLACK) ;
  ccprintf ("   ") ;
  textbackground (BACKGROUND) ;
  for (i = 0; i < MARGEINT ; i++)
	ccprintf (" ") ;

  ccprintf (line) ;

  reste = 80 - MARGEINT * 2 - MARGE * 2 - mystrlen (line) ;
  if (reste > 0)
    for (i = 0 ; i < reste ; i++)
	  ccprintf (" ") ;

  textbackground (BLACK) ;
  ccprintf ("\r\n") ;

}



void mpline (char car)
{
  char l[80 - MARGE * 2 - MARGEINT * 2 + 1] ;
  int i ;

  for (i = 0 ; i < 80 - MARGE * 2 - MARGEINT * 3 ; i++)
  {
    l[i] = car ;
  }
  l[i] = 0 ;

  pline (l) ;
}



void firstline (char car)
{
  char l[80 - MARGE * 2 + 1] ;
  int i ;

  for (i = 0 ; i < 80 - MARGE * 2 - MARGEINT ; i++)
  {
    l[i] = car ;
  }
  l[i] = 0 ;

  textbackground (BLACK) ;
  cprintf ("   ") ;

  textcolor (BACKGROUND) ;
  textbackground (BLACK) ;
  cprintf (l) ;
  cprintf ("\n\r") ;


}




void publicite (int demo)
{
  textbackground (BLACK) ;
  textcolor (LIGHTGRAY) ;
  clrscr () ;
  firstline (220) ;

#if FRENCH
  pline ("\001BLUPIMANIA\001:  Un jeu de logique palpitant et implacable !") ;
#endif

#if GERMAN
  pline ("\001BLUPIMANIA\001:  Ein aufregendes und unerbittliches Logikspiel !") ;
#endif

#if ENGLISH
  pline ("\001BLUPIMANIA\001: A compelling game of brain-twisting logic !") ;
#endif

  mpline (0xc4) ;
  if (demo)                                
  {
  textcol = WHITE ;

#if FRENCH
  pline ("Cette version d'‚valuation ne contient que quelques ‚nigmes.") ;
  pline ("Le jeu complet est compos‚ de plus de 150 ‚nigmes vari‚es et") ;
  pline ("tu peux contruire autant d'enigmes que tu veux.") ;
  pline ("La version complŠte de ce jeu peut ˆtre command‚e auprŠs") ;
  pline ("d'Epsitec SA au moyen du bulletin de commande ORDER.TXT.") ;
  pline (" ") ;
#endif

#if GERMAN
  pline ("Diese Demoversion enth„lt nur wenige R„tsel. Die Vollversion") ;
  pline ("dieses Spiels enth„lt ber 150 R„tsel und du kannst soviele") ;
  pline ("neue R„tsel konstruieren wie Du willst.") ;
  pline ("Du kannst die Vollversion bei Epsitec SA mit dem Bestellschein") ;
  pline ("ORDER.TXT bestellen.") ;
  pline (" ") ;
  textcol = TEXT ;
#endif

#if ENGLISH
  pline ("You just played with a limited shareware version of BLUPIMANIA.") ;
  pline ("The complete version of this game, contains over 150 puzzles") ;
  pline ("and you can construct as many new puzzles as you want.") ;
  pline ("Please send your order to EPSITEC. Use the order form ORDER.TXT.") ;
#endif

  textcol = YELLOW ;

  }

  pline (" ") ;
  pline ("              EPSITEC SA") ;
  pline ("              Ch. de la Mouette") ;
  pline ("              CH-1092 Belmont") ;
#if FRENCH
  pline ("              Suisse") ;
  pline ("              T‚l: ++41 21 728 44 83") ;
#endif
#if GERMAN
  pline ("              Schweiz") ;
  pline ("              Tel: ++41 21 728 44 83") ;
#endif

#if ENGLISH
  pline ("              Switzerland") ;
  pline ("              Tel: ++41 21 728 44 83") ;
#endif

  pline (" ") ;
  pline ("              WWW:    http://www.epsitec.ch") ;
  pline ("              Email:  epsitec@epsitec.ch") ;

  firstline (223) ;

  if (demo)
  {
    clrfifo () ;
    bioskey (0) ;
  }
}
