#include "xms.h"
#include <stdio.h>
#include <string.h>


/*--------------------------------------------------------------------*/
/*-- Test- und Demoprozeduren                                       --*/
/*--------------------------------------------------------------------*/


/***********************************************************************
* EMBTest : Testet den extended Memory und demonstriert den Aufruf     *
*           verschiedener XMS-Funktionen                               *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
***********************************************************************/

void EMBTest( void )

{
 long Adr;
 BYTE * barp;                               /* Zeiger auf 1 KB-Puffer */
 int  i, j,                                        /* Schleifenz�hler */
      err,                       /* Anzahl der Fehler bei HMA-Zugriff */
      Handle,                           /* Handle zum Zugriff auf EMB */
      GesFrei,           /* Gr��e des gesamten freien extended-Memory */
      MaxBl;                                  /* gr��ter freier Block */

 printf( "EMB-Test  -  Bet�tigen Sie bitte eine Taste, um den Test " \
         "zu starten..." );
 getch();
 printf( "\n" );

 XMSQueryFree( &GesFrei, &MaxBl );   /* Gr��e des ext. Mem. ermitteln */
 printf( "Gesamtgr��e des freien extended Memory (inkl. HMA): %d KB\n",
         GesFrei );
 printf( "                        davon gr��ter freier Block: %d KB\n",
         MaxBl );

 GesFrei -= 64;                   /* tats�chliche Gr��e ohne HMA ber. */
 if ( MaxBl >= GesFrei )                    /* kann der Wert stimmen? */
  MaxBl -= 64;                                                /* Nein */

 if ( MaxBl > 0 )                     /* noch gen�gend Speicher frei? */
  {                                                             /* Ja */
   Handle = XMSGetMem( MaxBl );
   printf( "%d KB allokiert.\n", MaxBl );
   printf( "Handle       = %d\n", Handle );
   Adr = XMSLock( Handle );                      /* Adresse ermitteln */
   XMSUnlock( Handle );                       /* Lock wieder aufheben */
   printf( "Startadresse = %ld (%d KB)\n", Adr, Adr >> 10 );

   barp = malloc( 1024 );              /* Puffer auf Heap allokierten */
   err = 0;                           /* bis jetzt noch keinen Fehler */

   /*-- den allokierten EMB KB f�r KB durchlaufen und testen ---------*/

   for  ( i = 0; i < MaxBl; ++i )
    {
     printf( "\rKB-Test: %d", i+1 );
     memset( barp, i % 255, 1024 );
     XMSCopy( 0, (long) ((void far *) barp),
              Handle, (long) i*1024, 512 );
     memset( barp, 255, 1024 );
     XMSCopy( Handle, (long) i*1024, 0,
              (long) ((void far *) barp), 512 );

     /*-- zur�ckkopierten Puffer mit erwartetem Resultat vergl. ------*/

     for ( j = 0; j < 1024; ++j )
      if ( *(barp+j) != i % 255 )
       {                                                   /* Fehler! */
        printf( " FEHLER!\n" );
        ++err;
        break;
       }
    }

   printf( "\n" );
   if ( err == 0 )                    /* Resultat des Tests auswerten */
    printf( "EMB ok, keiner der getesten 1 KB-Bl�cke war " \
            "fehlerhaft.\n");
   else
    printf( "ACHTUNG! %d fehlerhafte 1 KB-Bl�cke im EMB entdeckt\n",
            err );

   free( barp );                           /* Puffer wieder freigeben */
   XMSFreeMem( Handle );                      /* EMB wieder freigeben */
  }
}




void mwtest (void)
{
  int handle ;
  char text[] = "Mon texte" ;
  char dest[] = "*******************" ;


  handle = XMSGetMem (1) ;
  printf( "Handle       = %d\n", handle );

  if (handle == 0)
  {
    printf ("non more XMS\n") ;
    exit (1) ;
  }

  XMSCopy (0, (long)(void far *)text, handle, 0, strlen (text)) ;

  XMSCopy (handle, 0, 0, (long)(void far *)dest, strlen (text)) ;

  printf (dest) ;

  XMSFreeMem (handle) ;
}


/***********************************************************************
* HMATest : Testet die Verf�gbarkeit der HMA und demonstriert den Um-  *
*           gang mit ihr.                                              *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
***********************************************************************/

void HMATest( void)

{
 BOOL A20;                   /* aktuelle Status der Adressleitung A20 */
 BYTE far * hmap;                               /* Zeiger auf die HMA */
 WORD i,                                           /* Schleifenz�hler */
      err;                       /* Anzahl der Fehler bei HMA-Zugriff */

 printf( "HMA-Test  -  Bet�tigen Sie bitte eine Taste, um den Test " \
         "zu starten..." );
 getch();
 printf ("\n\n" );

 /*-- HMA allokieren und jede Speicherstelle testen ------------------*/

 if ( XMSGetHMA(0xFFFF) )                  /* HMA in Besitz gebracht? */
  {                                                             /* Ja */
   if ( ( A20 = XMSIsA20On() ) == FALSE ) /* Leitungsstatus ermitteln */
    XMSA20OnGlobal();                           /* jetzt freischalten */

   hmap = MK_FP( 0xFFFF, 0x0010 );                  /* Zeiger auf HMA */
   err = 0;                           /* bis jetzt noch keinen Fehler */
   for ( i = 1; i < 65520; ++i, ++hmap )
    {                           /* jede Speicherstelle einzeln testen */
     printf( "\rSpeicherstelle: %u", i );
     *hmap = i % 256;                   /* Speicherstelle beschreiben */
     if ( *hmap != i % 256 )                   /* und wieder auslesen */
      {                                                    /* Fehler! */
       printf( " FEHLER!\n" );
       ++err;
      }
    }

   XMSReleaseHMA();                       /* die HMA wieder freigeben */
   if ( A20 == FALSE )                   /* war die Leitung A20 frei? */
    XMSA20OffGlobal();               /* Nein, jetzt wieder abschalten */

   printf( "\n" );
   if ( err == 0 )                    /* Resultat des Tests auswerten */
    printf( "HMA ok, keine Speicherstelle fehlerhaft.\n" );
   else
    printf( "ACHTUNG! %d fehlerhafte Speicherstellen in der HMA " \
            "entdeckt!\n", err );
  }
 else
  printf( "ACHTUNG! Kein Zugriff auf die HMA m�glich.\n" );
}


/***********************************************************************
*                        H A U P T P R O G R A M M                     *
***********************************************************************/

void main( void )
{
 int VerNr,                                         /* Versionsnummer */
     RevNr,                                       /* Revisions-Nummer */
     i;                                            /* Schleifenz�hler */


 printf("XMSC  -  XMS-Demoprogramm von MICHAEL TISCHER\n\n" );
 if ( XMSInit() )
  {
   if ( XMSQueryVer( &VerNr, &RevNr ) )
    printf( "Zugriff auf HMA m�glich.\n" );
   else
    printf( "Kein Zugriff auf HMA.\n" );
   printf( "XMS-Versionsnummer: %d.%d\n", VerNr / 100, VerNr % 100 );
   printf( "Revisionsnummer   : %d.%d\n\n", RevNr / 100, RevNr % 100 );
   printf( "\n" );
   EMBTest();                               /* extended Memory testen */
//   mwtest () ;
   if (XMSGetHMA (2000))
   {
     printf ("HMA ok\n") ;
     XMSReleaseHMA() ;
   } ;

//   HMATest () ;
  }
 else
  printf( "Kein XMS-Treiber installiert!\n" );
}

