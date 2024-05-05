
/*== Include-Dateien einbinden =======================================*/
                                                                        
#include <dos.h>
#include <conio.h>
#include <stdio.h>

/*== Typedefs ========================================================*/
                                                                        
typedef unsigned char BYTE;           /* so bastelt man sich ein BYTE */
                                                                        
/*== Konstanten ======================================================*/
                                                                        
#define RTCAdrPort  0x70                   /* Adress-Register der RTC */
#define RTCDtaPort  0x71                    /* Daten-Register der RTC */
                                                                        
#define SEKUNDE      0x00 /* Adressen einiger Speicherstellen der RTC */
#define MINUTE       0x02
#define STUNDE       0x04
#define TAGDERWOCHE  0x06
#define TAG          0x07
#define MONAT        0x08
#define JAHR         0x09
#define STATUSA      0x0A
#define STATUSB      0x0B
#define STATUSC      0x0C
#define STATUSD      0x0D
#define DIAGNOSE     0x0E
#define JAHRHUNDERT  0x32
                                                                        
/**********************************************************************/
/* RTCREAD: den Inhalt einer der Speicherstellen der RTC auslesen     */
/* Eingabe : ADRESSE = die Adresse der Speicherstelle in der RTC      */
/* Ausgabe : der Inhalt dieser Speicherstelle                         */
/**********************************************************************/
                                                                        
BYTE RTCRead(BYTE Adresse)
{
 outp(RTCAdrPort, Adresse);         /* Adresse an die RTC bermitteln */
 return(inp(RTCDtaPort));   /* Inhalt auslesen und Aufrufer bergeben */
}
                                                                        
/**********************************************************************/
/* RTCDT: liest eine der Speicherstellen des Datums oder der Zeit aus */
/*        und setzt das Ergebnis in einen Bin„r-Wert um, falls die    */
/*        Uhr mit dem BCD-Format arbeitet                             */
/* Eingabe : ADRESSE = die Adresse der Speicherstelle in der RTC      */
/* Ausgabe : der Inhalt dieser Speicherstelle als Bin„r-Wert          */
/* Info    : liegt die Adresse auáerhalb des erlaubten Bereichs       */
/*           (0 bis 63) wird der Wert -1 zurckgeliefert              */
/**********************************************************************/
                                                                        
BYTE RTCDt(BYTE Adresse)
                                                                        
{
 if (RTCRead(STATUSB) & 2)                  /* BCD- oder Bin„r-Modus? */
  return((RTCRead(Adresse) >> 4) * 10 + (RTCRead(Adresse) & 15));
 else return(RTCRead(Adresse));                    /* ist Bin„r-Modus */
}


void restore_clock (void)
                                                                        
{
 if (!(RTCRead(DIAGNOSE) & 128))            /* ist die Batterie o.k.? */
  {                                          /* die Batterie ist o.k. */
   unsigned char hour ;
   unsigned char min ;
   unsigned char sec ;
   unsigned char day ;
   unsigned char month ;
   unsigned char year ;

   hour = RTCDt (STUNDE) ;
   min = RTCDt (MINUTE) ;
   sec = RTCDt (SEKUNDE) ;

   _AH = 0x2d ;
   _CH = hour ;
   _CL = min ;
   _DH = sec ;
   _DL = 0 ;
   asm int 21h ;
  }
}
