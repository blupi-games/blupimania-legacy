
/* ======== */
/* toto_x.c */
/* ======== */

/*
	Version	Date		Modifications
	-------------------------------------------------------------------------------
	1.0	24.08.94	d‚but des travaux ...
 */

#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <alloc.h>

#include "bm_x.h"
#include "bmicon.h"
#include "actions.h"


#include "bmplay.c"



void test_draw ()
{
  int i ;
  Pt np = {0,0} ;
  Pt p1 = {100,100} ;
  Pt p2 = {129,129} ;
  Pt p ;
  static Pixmap ppm ;

  for (i = 0 ; i <= 15 ; i++)
  {
    Rectangle r ;
    r.p1 = p1 ;
    r.p2 = p2 ;
    DrawFillRect (NULL, r, MODELOAD, i) ;
    r.p1.y +=30 ;
    r.p2.y +=30 ;
    DrawRect (NULL, r, MODELOAD, i) ;

    p1.x += 30 ;
    p2.x += 30 ;
  }

  p1.x = 200 ;
  p1.y = 200 ;
  p2.x = 400 ;
  p2.y = 300 ;
  DrawLine (NULL, p1, p2, MODELOAD, 15) ;

  GetPixmap (&ppm, (p.x = 300, p.y = 200 ,p), 0, 1) ;

  p1.x = 100 ; p1.y = 100 ;
  CopyPixel (0, p1, &ppm, np, p, MODELOAD) ;
  CopyPixel (&ppm, np, 0, np, p, MODELOAD) ;

  getch () ;
}

void test_geticone (void)
{
  Pixmap ppm ;
  int no ;
  Pt os, od, dim ;
  short y ;
  
  os.x = 0 ;
  os.y = 0 ;
  od.x = 0 ;
  od.y = 0 ;
  
  dim.x = 80 ;
  dim.y = 80 ;
  
  do
  {
    gotoxy (1,10) ;
    printf ("no. d'icone (0 = termine): ") ;
    scanf ("%d", &no) ;  
    GetIcon (&ppm, (short)no, 0);  
    
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODEXOR);
    
    for (y = 0 ; y < 80 ; y++)
    {
      if (!TestHLine (&ppm, y))
        break ;
    }
    printf ("Last nonzero y %d\n", (int)y) ;

    
    for (y = 79 ; y >= 0 ; y--)
    {
      if (!TestHLine (&ppm, y))
        break ;
    }
    printf ("Last nonzero y %d\n", (int)y) ;
    
    for (y = 0 ; y < 80 ; y++)
    {
      if (!TestVLine (&ppm, y))
        break ;
    }
    printf ("First nonzero x %d\n", (int)y) ;
    
    for (y = 79 ; y >= 0 ; y--)
    {
      if (!TestVLine (&ppm, y))
        break ;
    }
    printf ("Last nonzero x %d\n", (int)y) ;

  }
  while (no != 0) ;
}





void test_geticone1 (void)
{
  Pixmap ppm ;
  int no ;
  Pt os, od, dim ;
  short y ;
  
  os.x = 0 ;
  os.y = 0 ;
  od.x = 0 ;
  od.y = 0 ;
  
  dim.x = 80 ;
  dim.y = 80 ;
  
  do
  {
    od.x = 0 ;
    gotoxy (1,10) ;
    printf ("no. d'icone (0 = termine): ") ;
    scanf ("%d", &no) ;

    GetIcon (&ppm, (short)no|UL, 0);
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);
    od.x += 80 ;

    GetIcon (&ppm, (short)no|UR, 0);
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);    
    od.x += 80 ;

    GetIcon (&ppm, (short)no|DL, 0);
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);
    od.x += 80 ;

    GetIcon (&ppm, (short)no|DR, 0);
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);    

  }
  while (no != 0) ;
}





void test_getimage (void)
{
  Pixmap ppm = {0,0,0,0,0,0,0} ;
  int no ;
  Pt os, od, dim ;
  Rectangle rect ;
  
  os.x = 0 ;
  os.y = 0 ;
  od.x = 0 ;
  od.y = 0 ;
  
  dim.x = 80 ;
  dim.y = 80 ;
  
  do
  {
    printf ("no. d'image ") ;
    scanf ("%d", &no) ;

    if (no == 0)
      return ;

    GetImage (&ppm, (short)no) ;
    dim.x = ppm.dx ;
    dim.y = ppm.dy ;
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);
    CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);

//    GivePixmap (&ppm) ;

#if 0
    getch () ;
    dim.x = 20 ;
    dim.y = 0 ;
    ScrollPixel	(&ppm, dim, 1, &rect); CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);

    getch () ;
    dim.x = -20 ;
    dim.y = 0 ;
    ScrollPixel	(&ppm, dim, 1, &rect);CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);

    getch () ;
    dim.x = 0 ;
    dim.y = 20 ;
    ScrollPixel	(&ppm, dim, 1, &rect);CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);
    
    getch () ;
    dim.x = 0 ;
    dim.y = -20;
    ScrollPixel	(&ppm, dim, 1, &rect);CopyPixel (&ppm, os, NULL, od, dim, MODELOAD);

#endif
    GivePixmap (&ppm) ;

    gotoxy (1,1) ;
    printf ("Free mem: %ld\n", farcoreleft ()) ;
  }
  while (no != 0) ;
}



test_getevent (void)
{
  Pt pos ;
  short e ;
  KeyStatus ks ;
  int c=0 ;

  pos.x = 340 ;
  pos.y = 170 ;
  PosMouse (pos) ;

  do
  {
    e = GetEvent (&pos) ;
    ks = GetKeyStatus () ;

    if (e != 0 || ks != 0)
    {
      printf ("%x %x (%d,%d)\n", (int)e, ks, pos.x, pos.y) ;
    }

  }
  while ((e & 0xff) != 'A') ;
}

/* =================== */
/* Programme principal */
/* =================== */

void _display (const char *name) ;
int main (int argc, char *argv[])
{
  int	err;						/* condition de sortie */
  short	key;						/* touche press‚e  */
  Pt	pos;						/* position de la souris */
  int  quitte = 0 ;
	
	
  OpenMachine();
  
  printf ("****** test ********") ;
  BlackScreen () ;
  
  while (!quitte)
  {
    printf ("\n1) test des geticone\n") ;
    printf ("2) test getimage\n") ;
    printf ("3) test getevent\n") ;
	
    printf ("\n9) quitte\n") ;

    if (0)
    {
      _display ("b1.ic") ;
      quitte = 1 ;
    }
    else
    switch (getch ())
    {
      case '1':
	test_geticone () ;
        break ;
      case '2':
        test_getimage () ;
        break ;
      case '3':
        test_getevent () ;
	break ;
      case '4':
	test_draw () ;
	break ;
      case '9':
        quitte = 1 ;
        break ;
    }
  }

  CloseMachine() ;
  return 0;
}
