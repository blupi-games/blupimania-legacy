
/*
 *  merge BLUPIMAN .IC files
 *
 *  mw 23.8.95
 *
 *  Syntaxe:
 *    mergeic output file1.ic file2.ic ...
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "icfile.h"


/* ------------ */
/* Image header */
/* ------------ */

typedef unsigned char u_char ;
typedef unsigned short u_short ;
typedef unsigned long u_long ;

typedef struct
{
  u_char	  imtyp ;	/* Type d'image */
  u_char	  imcod ;	/* Type de codage */
  u_char	  imbip ;	/* Bits/pixel */
  u_char	  imdir ;	/* Direction de digitalisation */
  u_short	  imdlx ;	/* Largeur en pixels */
  u_short	  imdly ;	/* Hauteur en pixels */
  u_long	  imnbb ;	/* Taille du bitmap */
  u_short	  imsiz ;	/* taille d'un pixel (4) | 0 b&w */
  u_short	  imcnt ;	/* nb de pixels (1)  | 0 b&w */
  u_long	  imlgc ;	/* longueur de la CLUT	 | 0 b&w */
  u_char	  imfill[12] ;	/* Reserve */
} Image ;

FILE *output ;
FILE *input ;

int filenumber ;

struct icfiledir filedir ;

#define BUFSIZE 32000

char buffer[BUFSIZE] ;


void usage ()
{
  printf ("usage: mergeic output file1.ic file2.ic ...\n") ;
  exit (1) ;
}


void copy (FILE *input, FILE *output)
{
  int n ;

  do
  {
    n = fread (buffer, 1, BUFSIZE, input) ;
    fwrite (buffer, 1, n, output) ;
    printf (".") ;
  }
  while (n == BUFSIZE) ;

}


void copyic (FILE *input, FILE *output)
{
  Image header ;

  fread (&header, sizeof (Image), 1, input) ;
  if (header.imtyp != 0x81 && header.imtyp != 0x82)
  {
    printf ("illegal file contents\n") ;
    exit (1) ;
  }
  fseek (input, header.imlgc, SEEK_CUR) ;

//  fwrite (&header, sizeof (Image), 1, output) ;

  {
    long l = ftell (output) ;
    printf (" %ld %ld\n", l, ftell (output) - sizeof (struct icfiledir)) ;
  }
  filedir.offset[filenumber++] = ftell (output) - sizeof (struct icfiledir) ;

  copy (input, output) ;
}



main (int argc, char *argv[])
{
  int i ;

  if (argc < 4)
    usage () ;

  output = fopen (argv[1], "wb") ;
  if (output == NULL)
  {
    printf ("Could not open %s\n", argv[1]) ;
    exit (1) ;
  }

  fwrite (&filedir, sizeof (struct icfiledir) , 1, output) ;

  filenumber = 0 ;
  for (i = 2 ; i < argc ; i++)
  {
    input = fopen (argv[i], "rb") ;
    if (input == NULL)
    {
      printf ("Could not open %s\n", argv[i]) ;
      exit (1) ;
    }
    printf ("Reading %s: ",argv[i]) ;
    copyic (input, output) ;
    printf ("\n") ;
    fclose (input) ;
  }

  fseek (output, 0, SEEK_SET) ;
  filedir.magic = ICFILEMAGIC ;
  filedir.nbfiles = filenumber ;
  fwrite (&filedir, sizeof (struct icfiledir) , 1, output) ;
  fclose (output) ;
  printf ("Header size = %d\n", sizeof (struct icfiledir)) ;
}