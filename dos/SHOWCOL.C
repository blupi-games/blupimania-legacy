
#include "shcolpc.h"

#include <stdlib.h>
#include <stdio.h>

#include <dir.h>
#include <alloc.h>



void fatal_error (int err)
{
  fprintf (stderr, "Erreur fatale %d\n", err) ;
  exit (1) ;
}

PixelMap pm ;


show_color (char *name)
{

  int err ;
  Pt os, od, dim ;


  err = getimage (&pm, name) ;

  loadclut () ;

  if (err != 0)
    fatal_error (err) ;

  os.x = 0 ;
  os.y = 0 ;

  od.x = 0 ;
  od.y = 0 ;

  dim.x = pm.dx ;
  dim.y = pm.dy ;


  copypixel(&pm, os, NULL, od, dim, MODELOAD) ;

  screen(1,0);          /* black screen */

  gotoxy (1,1) ;
  printf ("%s  %ld", name, farcoreleft ()) ;

}






int main (int argc, char **argv)
{
   struct ffblk ffblk;
   int done;
   int nbfiles = -1 ;
   int idx ;
   char c ;

   char **pfiles ;


   openmachine () ;

   if (argc == 2)
   {
     show_color (argv[1]) ;
     getch () ;
     closemachine () ;
     exit (0) ;
   }

   done = findfirst("*.col",&ffblk,0);
   while (!done)
   {
      done = findnext(&ffblk);
      nbfiles++ ;
   }

   pfiles = (char**)malloc (nbfiles * sizeof (char*)) ;

   done = findfirst("*.col",&ffblk,0);
   idx = 0 ;
   while (!done)
   {
      done = findnext(&ffblk);
      if (done == 0)
      {
	pfiles[idx] = (char*)malloc (strlen (ffblk.ff_name) + 1) ;
	strcpy (pfiles[idx],ffblk.ff_name) ;
	idx++ ;
      }
   }


   done = 0 ;
   idx = 0 ;

   do
   {
      show_color (pfiles[idx]) ;

      c = getch () ;

      switch (c)
      {
	case 'A' :
	  done = 1 ;
	  break ;

	case '.' :
	  if (idx < nbfiles)
	    idx++ ;
	  break ;
	case ',' :
	  if (idx > 0)
	    idx-- ;
	  break ;
      }
   }
   while (!done) ;

   closemachine () ;
   return 0;
}
