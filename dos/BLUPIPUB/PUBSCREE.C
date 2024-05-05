
#include <bios.h>
#include <conio.h>
#include <string.h>
#include "lang.h"
#include "te.h"

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
  cprintf ("   ") ;
  textbackground (BACKGROUND) ;
  for (i = 0; i < MARGEINT ; i++)
    cprintf (" ") ;

  ccprintf (line) ;

  reste = 80 - MARGEINT * 2 - MARGE * 2 - mystrlen (line) ;
  if (reste > 0)
    for (i = 0 ; i < reste ; i++)
      cprintf (" ") ;
  cprintf ("\r\n") ;
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

  clrscr () ;
  firstline (220) ;

#ifdef FRENCH
  pline ("\001BLUPI EXPLORATEUR\001: un jeu pour enfants de 9 … 99 par EPSITEC SA") ;
#endif
#ifdef GERMAN
  pline ("\001BLUPI IM SCHLOSS\001: ein Spiel fr Kinder von 9 bis 99") ;
#endif

  mpline (0xc4) ;
  if (demo)                                
  {
  textcol = WHITE ;

#ifdef FRENCH
  pline ("Vous venez de jouer avec une version de d‚monstration.") ;
  pline ("Si la version complŠte de ce jeu ‚ducatif vous interesse, vous") ;
  pline ("pouvez le commander chez EPSITEC SA.") ;
  pline (" ") ;
#endif


#ifdef GERMAN
  pline ("Dies ist eine Demoversion. Wenn Sie an einer kompletten Version") ;
  pline ("dieses Spiels fr Kinder oder an anderen BLUPI Programmen") ;
  pline ("interessiert sind, dann wenden Sie sich bitte an EPSITEC SA.") ;
  pline (" ") ;
  textcol = TEXT ;
#endif

  textcol = YELLOW ;

  }

#ifdef FRENCH

#ifdef TESTEUR

  pline (" ") ;
  pline ("    Cette VERSION DE TEST du logiciel \"Blupi explorateur\"") ;
  pline ("    a ‚t‚ remis personellement …:") ;
  pline (" ") ;
  textcol = WHITE ;
  pline ("    Pascal Monnier, Gd. Rue 18a, CH-2036 CormondrŠche") ;
  textcol = YELLOW ;
  pline (" ") ;
  pline ("    qui lui seul … le droit de l'installer sur ses");
  pline ("    ordinateurs personnels.") ;
  pline (" ") ;
  pline (" ") ;
  pline ("              EPSITEC SA") ;
  pline ("              Ch. de la Mouette") ;
  pline ("              CH-1092 Belmont") ;
  pline ("              T‚l: ++41 21 728 44 83") ;

#else
  pline ("D'autres jeux EPSITEC:") ;
    pline (" ") ;

  pline ("  \001BLUPI S'AMUSE\001 pour enfants de 6 … 12. Un jeu ‚ducatif permettant") ;
  pline ("  d'exercer le calcul, la lecture, la m‚moire et le raisonnement") ;
  pline ("  grƒce … huit activit‚s diff‚rentes.") ;
  pline (" ") ;

  pline ("  \001BLUPI A LA MAISON\001 pour enfants de 3 … 8. Un jeu ‚ducatif, dans") ;
  pline ("  lequel Blupi vit toutes sortes d'aventures … l'int‚rieur d'une") ;
  pline ("  maison selon les touches press‚es.") ;

  pline (" ") ;
  pline ("              EPSITEC SA") ;
  pline ("              Ch. de la Mouette") ;
  pline ("              CH-1092 Belmont") ;
  pline ("              T‚l: ++41 21 728 44 83") ;

#endif
#endif

#ifdef GERMAN

#ifdef TESTEUR

  textcol = WHITE ;
  pline (" ") ;
  pline ("  Diese Testversion darf nur mit ausdrcklicher Erlaubnis von Epsitec") ;
  pline ("  an dritte weitergegeben werden.") ;
  pline (" ") ;
  textcol = YELLOW ;
#endif

  pline ("Andere Spiele von EPSITEC:") ;
    pline (" ") ;


  pline ("  \001SPASS MIT BLUPI\001 fr Kinder von 6 bis 12. Ein Lernspiel das acht") ;
  pline ("  verschiedene Aktivit„ten beinhaltet: Kopfrechnen, Puzzles,") ;
  pline ("  Irrg„rten, Worteraten usw.") ;
  pline (" ") ;

  pline ("  \001BLUPI ZU HAUSE\001 fr Kinder von 3 bis 8. Indem eine Taste bet„tigt") ;
  pline ("  wird, erlebt Blupi verschiedene Abenteuer in einem Haus.") ;

  pline (" ") ;
  pline ("              EPSITEC SA") ;
  pline ("              Ch. de la Mouette") ;
  pline ("              CH-1092 Belmont") ;
  pline ("              Tel: ++41 21 728 44 83") ;

#endif

  firstline (223) ;

  if (demo)
  {
    clrfifo () ;
    bioskey (0) ;
  }
}
