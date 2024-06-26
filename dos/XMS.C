/***********************************************************************
*                              X M S C . C                             *
**--------------------------------------------------------------------**
*  Aufgabe        : Demonstriert den Zugriff auf extended Memory und   *
*                   High-Memory-Area mit Hilfe der XMS-Funktionen, wie *
*                   sie z.B. durch den Ger�tetreiber HIMEM.SYS imple-  *
*                   mentiert werden.                                   *
**--------------------------------------------------------------------**
*  Autor          : MICHAEL TISCHER                                    *
*  entwickelt am  : 27.07.1990                                         *
*  letztes Update : 29.07.1990                                         *
**--------------------------------------------------------------------**
*  (MICROSOFT C)                                                       *
*  Erstellung     : CL /AS /Zp xmsc.c xmsca                            *
*  Aufruf         : xmsc                                               *
**--------------------------------------------------------------------**
*  (BORLAND TURBO C)                                                   *
*  Erstellung     : �ber eine Projekt-Datei mit folgendem Inhalt:      *
*                     xmsc.c                                           *
*                     xmsca.obj                                        *
***********************************************************************/

/*-- Include-Dateien einbinden ---------------------------------------*/


#include "xms.h"



typedef struct                        /* Informationen f�r XMS-Aufruf */
         {
          WORD AX,              /* nur die Register AX, BX, DX und SI */
               BX,              /* werden je nach aufgerufener Funk-  */
               DX,              /* tion ben�tigt, dazu noch eine Seg- */
               SI,              /* mentadresse                        */
               Segment;
         } XMSRegs;

typedef struct                  /* eine extended-Memory-Move-Struktur */
         {
          long LenB;                       /* Anzahl zu versch. Bytes */
          int  SHandle;                              /* Source-Handle */
          long SOffset;                              /* Source-Offset */
          int  DHandle;                         /* Destination-Handle */
          long DOffset;                         /* Destination-Offset */
         } EMMS;

/*-- extern Deklarationen --------------------------------------------*/

extern void XMSCall( BYTE FktNr, XMSRegs *Xr );

/*-- globale Variablen -----------------------------------------------*/

void far * XMSPtr;    /* Zeiger auf den Extended-Memory-Manager (XMM) */
BYTE XMSErr;                      /* Fehlercode der letzten Operation */

/***********************************************************************
* XMSInit : Initialisiert die Routinen zum Aufruf der XMS-Funktionen   *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Ausgabe : TRUE, wenn ein XMS-Treiber entdeckt wurde, sonst FALSE     *
* Info    : - Der Aufruf dieser Funktion mu� dem Aufruf aller anderen  *
*             Prozeduren und Funktionen aus diesem Programm voraus-    *
*             gehen.                                                   *
***********************************************************************/

BOOL XMSInit( void )
{
 union REGS Regs;            /* Prozessorregister f�r Interruptaufruf */
 struct SREGS SRegs;                               /* Segmentregister */
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Regs.x.ax = 0x4300;    /* Verf�gbarkeit des XMS-Managers feststellen */
 int86( 0x2F, &Regs, &Regs );              /* DOS-Dispatcher aufrufen */

 if ( Regs.h.al == 0x80 )                 /* XMS-Manager angetroffen? */
  {                                                             /* Ja */
   Regs.x.ax = 0x4310;           /* Einsprungspunkt des XMM ermitteln */
   int86x( 0x2F, &Regs, &Regs, &SRegs );
   XMSPtr = MK_FP( SRegs.es, Regs.x.bx );  /*Adresse in glob. Var. sp.*/
   XMSErr = ERR_NOERR;                /* noch kein Fehler aufgetreten */
   return TRUE;           /* Handler angetroffen, Modul initialisiert */
  }
 else                                 /* kein XMS-Handler installiert */
  return FALSE;
}

/***********************************************************************
* XMSQueryVer: liefert die XMS-Versionsnummer und andere Statusinfor-  *
*              mationen                                                *
**--------------------------------------------------------------------**
* Eingabe : VerNr = nimmt die Versionsnummer nach dem Funktionsaufruf  *
*                   auf (Format: 235 == 2.35)                          *
*           RevNr = nimmt die Revisionsnummer nach dem Funktionsaufruf *
*                   auf                                                *
* Ausgabe : TRUE, wenn eine HMA zur Verf�gung steht, sonst FALSE       *
***********************************************************************/

BOOL XMSQueryVer( int * VerNr, int * RevNr)
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 0, &Xr );                       /* XMS-Funktion #0 aufrufen */
 *VerNr = Hi(Xr.AX)*100 + ( Lo(Xr.AX) >> 4 ) * 10 +
           ( Lo(Xr.AX) & 15 );
 *RevNr = Hi(Xr.BX)*100 + ( Lo(Xr.BX) >> 4 ) * 10 +
          ( Lo(Xr.BX) & 15 );
 return ( Xr.DX == 1 );
}

/***********************************************************************
* XMSGetHMA : Liefert dem Aufrufer das Zugriffsrecht auf die HMA.      *
**--------------------------------------------------------------------**
* Eingabe : LenB = Anzahl der zu allokierenden Bytes                   *
* Info    : TSR-Programme sollten immer nur genau die tats�chlich be-  *
*           n�tigte Speichergr��e anfordern, Applikationen hingegen    *
*           den Wert 0xFFFF angeben.                                   *
* Ausgabe : TRUE, wenn die HMA zur Verf�gung gestellt werden konnte,   *
*           sonst FALSE;                                               *
***********************************************************************/

BOOL XMSGetHMA( WORD LenB )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = LenB;                      /* L�nge im Register DX �bergeben */
 XMSCall( 1, &Xr );                       /* XMS-Funktion #1 aufrufen */
 return XMSErr == ERR_NOERR;
}

/***********************************************************************
* XMSReleaseHMA : Gibt die HMA wieder frei und erm�glicht dadurch ihre *
*                 Weitergabe an andere Programme.                      *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Info    : - Vor der Beendigung eines Programms sollte diese Prozedur *
*             aufgerufen werden, sofern die HMA zuvor �ber einen Aufruf*
*             von XMSGetHMA allokiert wurde, weil sie sonst nicht an   *
*             nachfolgend aufgerufene Programme vergeben werden kann.  *
*           - Die in der HAM gespeicherten Daten gehen durch den Auf-  *
*             ruf dieser Prozedur verloren.                            *
***********************************************************************/

void XMSReleaseHMA( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 2, &Xr );                       /* XMS-Funktion #2 aufrufen */
}

/***********************************************************************
* XMSA20OnGlobal: Schaltet die Adressleitung A20 frei, soda� ein di-   *
*                 rekter Zugriff auf die HMA m�glich wird.             *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Info    : - Die Freischaltung der Adressleitung A20 ist bei vielen   *
*             Rechnern ein relativ zeitaufwendiger Vorgagn. Rufen Sie  *
*             dieser Prozedur deshalb nicht unn�tig oft auf.           *
***********************************************************************/

void XMSA20OnGlobal( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 3, &Xr );                       /* XMS-Funktion #3 aufrufen */
}

/***********************************************************************
* XMSA20OffGlobal: Als Gegenst�ck zu der Prozedur XMSA20OnGlobal       *
*                  schaltet diese Prozedur die Adressleitung A20 wie-  *
*                  der ab, so da� kein direkter Zugriff auf die HMA    *
*                  mehr m�glich ist.                                   *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Info    : - Diese Prozedur sollte vor der Beendigung eines Programms *
*             immer aufgerufen werden, falls zuvor die Leitung A20     *
*             mittels eines Aufrufs von XMSA20OnGlobal freigeschaltet  *
*             wurde.                                                   *
***********************************************************************/

void XMSA20OffGlobal( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 4, &Xr );                       /* XMS-Funktion #4 aufrufen */
}

/***********************************************************************
* XMSA20OnLocal: Siehe XMSA20OnGlobal                                  *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Info    : - Von der gleichartigen globalen Prozedur unterscheidet    *
*             sich diese lokale Prozedur dadurch, da� die Freischal-   *
*             tung nur dann erfolgt, wenn dies nicht bereits durch ei- *
*             nen vorhergehenden Aufruf erfolgt ist.                   *
***********************************************************************/

void XMSA20OnLocal( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 5, &Xr );                       /* XMS-Funktion #5 aufrufen */
}

/***********************************************************************
* XMSA20OffLocal : Siehe XMSA29OffGlobal                               *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Info    : - Von der gleichartigen globalen Prozedur unterscheidet    *
*             sich diese lokale Prozedur dadurch, da� die Abschaltung  *
*             nur dann erfolgt, wenn dies nicht bereits durch einen    *
*             vorhergehenden Aufruf erfolgt ist.                       *
***********************************************************************/

void XMSA20OffLocal( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 6, &Xr );                       /* XMS-Funktion #6 aufrufen */
}

/***********************************************************************
* XMSIsA20On : Liefert den Status der Adressleitung A20                *
**--------------------------------------------------------------------**
* Eingabe : keine                                                      *
* Ausgabe : TRUE, wenn die Leitungs A20 freigeschaltet ist, sonst      *
*           FALSE.                                                     *
***********************************************************************/

BOOL XMSIsA20On( void )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 7, &Xr );                       /* XMS-Funktion #7 aufrufen */
 return ( Xr.AX == 1 );              /* AX == 1 ---> Leitung ist frei */
}

/***********************************************************************
* XMSQueryFree : Liefert die Gr��e des freien extended Memory und die  *
*                des gr��ten freien Blocks                             *
**--------------------------------------------------------------------**
* Eingabe : GesFrei: Nimmt die Gesamtgr��e des freien EM auf.          *
*           MaxBl  : Nimmt die Gr��e des gr��ten freien Blocks auf.    *
* Info    : - Beide Angabe in KB                                       *
*           - Die Gr��e der HMA wird nicht mitgez�hlt, auch wenn sie   *
*             noch nicht an ein Programm vergeben wurde.               *
***********************************************************************/

void XMSQueryFree( int * GesFrei, int * MaxBl )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 XMSCall( 8, &Xr );                       /* XMS-Funktion #8 aufrufen */
 *GesFrei = Xr.AX;                         /* Gesamtgr��e steht in AX */
 *MaxBl   = Xr.DX;                     /* freier Speicher steht in DX */
}

/***********************************************************************
* XMSGetMem : Allokiert einen extended-Memory-Block (EMB)              *
**--------------------------------------------------------------------**
* Eingabe : LenKB : Gr��e des angeforderten Blocks in KB               *
* Ausgabe : Handle zum weiteren Zugriff auf dne Block oder 0, wenn     *
*           kein Block allokiert werden konnte. Dann steht auch in der *
*           globalen Variable XMSErr ein entsprechender Fehlercode.    *
***********************************************************************/

int XMSGetMem( int LenKb )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = LenKb;                /* L�nge wird im DX-Register �bergeben */
 XMSCall( 9, &Xr );                       /* XMS-Funktion #9 aufrufen */

 if (Xr.AX == 0)
   XMSErr = Xr.BX & 0xff ;

 return Xr.DX;                                /* Handle zur�ckliefern */
}

/***********************************************************************
* XMSFreeMem : Gibt einen zuvor allokierten extended-Memory-Block      *
*              (EMB) wieder frei.                                      *
**--------------------------------------------------------------------**
* Eingabe : Handle : Das Handle zum Zugriff auf den Block, das beim    *
*                    Aufruf von XMSGetMem zur�ckgeliefert wurde.       *
* Info    : - Der Inhalt des EMB geht durch diesen Aufruf unwider-     *
*             bringlich verloren und auch das Handle wird ung�ltig.    *
*           - Vor der Beendigung eines Programms sollten alle allo-    *
*             kierten Bereich mit Hilfe dieser Prozedur wieder frei-   *
*             gegeben werden, damit sie an nachfolgend aufgerufene     *
*             Programm wieder vergeben werden k�nnen.                  *
***********************************************************************/

void XMSFreeMem( int Handle )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Handle;              /* Handle wird im DX-Register �bergeben */
 XMSCall( 10, &Xr );                     /* XMS-Funktion #10 aufrufen */
}

/***********************************************************************
* XMSCopy : Kopiert Speicherbereiche zwischen dem extended Memory und  *
*           dem konventionellen Speicher bzw. innerhalb der beiden     *
*           Speichergruppen.                                           *
**--------------------------------------------------------------------**
* Eingabe : VonHandle  : Handle des Speicherbereichs, der verschoben   *
*                        werden soll.                                  *
*           VonOffset  : Offset in diesen Block ab dem verschoben wird.*
*           NachHandle : Handle des Speicherbereichs, der das Ziel der *
*                        Verschiebung darstellt.                       *
*           NachOffset : Offset in den Ziel-Block.                     *
*           LenW       : Anzahl der zu verschiebenden Worte            *
* Info    : - Um normalen Speicher in die Operation einzubeziehen,     *
*             mu� als Handle der Wert 0 und f�r den Offset die Seg-    *
*             ment und Offsetadresse in der gewohnte Form (Offset vor  *
*             Segment) angegeben werden.                               *
***********************************************************************/

void XMSCopy( int VonHandle, long VonOffset, int NachHandle,
              long NachOffset, int LenW )

{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */
 EMMS Mi;                                           /* nimmt EEMS auf */
 void far * MiPtr;

 Mi.LenB = LenW;                 /* zun�chst den EMMS aufbereiten */
 Mi.SHandle = VonHandle;
 Mi.SOffset = VonOffset;
 Mi.DHandle = NachHandle;
 Mi.DOffset = NachOffset;

 MiPtr = &Mi;                          /* Far-Zeiger auf die Struktur */
 Xr.SI = FP_OFF( MiPtr );                   /* Offsetadresse des EMMS */
 Xr.Segment = FP_SEG( MiPtr );             /* Segmentadresse des EMMS */
 XMSCall( 11, &Xr );                     /* XMS-Funktion #11 aufrufen */
}

/***********************************************************************
* XMSLock : Sperrt einen extended-Memory-Block gegen sein Verschiebung *
*           durch den XMM und liefert gleichzeitig seine absolute      *
*           Adresse zur�ck.                                            *
**--------------------------------------------------------------------**
* Eingabe : Handle : Handle des Speicherbereichs, das bei einem vor-   *
*                    hergehenden Aufruf von XMSGetMem zur�ckgeliefert  *
*                    wurde.                                            *
* Ausgabe : Die lineare Adresse des zugeh�rigen Speicherblocks.        *
***********************************************************************/

long XMSLock( int Handle )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Handle;                                    /* Handle des EMB */
 XMSCall( 12, &Xr );                     /* XMS-Funktion #12 aufrufen */
 return ((long) Xr.DX << 16) + Xr.BX;        /* 32-Bit-Adr. berechnen */
}

/***********************************************************************
* XMSUnlock : Gibt einen gesperrten extended-Memory-Block wieder f�r   *
*             die Verschiebung frei.                                   *
**--------------------------------------------------------------------**
* Eingabe : Handle : Handle des Speicherbereichs, das bei einem vor-   *
*                    hergehenden Aufruf von XMSGetMem zur�ckgeliefert  *
*                    wurde.                                            *
***********************************************************************/

void XMSUnlock( int Handle )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Handle;                                    /* Handle des EMB */
 XMSCall( 13, &Xr );                     /* XMS-Funktion #13 aufrufen */
}

/***********************************************************************
* XMSQueryInfo : Liefert verschiedene Informationen �ber einen bereits *
*                allokierten extended-Memory-Block                     *
**--------------------------------------------------------------------**
* Eingabe : Handle : Handle des Speicherbereichs                       *
*           Lock   : Variable, in die der Lock-Z�hler eingetragen wird *
*           LenKB  : Variable, in die die L�nge des Blocks in KB ein-  *
*                    getragen wird                                     *
*           FreeH  : Variable, ind die die Anzahl der noch freien      *
*                    Handles eingetragen wird                          *
* Info    : Die Startadresse eines Blocks k�nnen Sie mit Hilfe dieser  *
*           Prozedur nicht ermitteln, verwenden Sie daf�r die Funktion *
*           XMSLock.                                                   *
***********************************************************************/

void XMSQueryInfo( int Handle, int * Lock, int * LenKB, int * FreeH )

{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Handle;                                    /* Handle des EMB */
 XMSCall( 14, &Xr );                     /* XMS-Funktion #14 aufrufen */
 *Lock  = Hi( Xr.BX );                          /* Register auswerten */
 *FreeH = Lo( Xr.BX );
 *LenKB = Xr.DX;
}

/***********************************************************************
* XMSRealloc : Verg��ert oder verkleinert einen zuvor �ber XMSGetMem   *
*              allokierten extended-Memory-Block                       *
**--------------------------------------------------------------------**
* Eingabe : Handle   : Handle des Speicherbereichs                     *
*           NeuLenKB : Neue L�nge des Speicherbereichs in KB           *
* Ausgabe : TRUE, wenn der Block in seiner Gr��e ver�ndert werden      *
*           konnte, sonst FALSE                                        *
* Info    : Der angegebene Block darf nicht gesperrt sein!             *
***********************************************************************/

BOOL XMSRealloc( int Handle, int NeuLenKB)
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Handle;                                    /* Handle des EMB */
 Xr.BX = NeuLenKB;               /* die neue L�nge in das BX-Register */
 XMSCall( 15, &Xr );                     /* XMS-Funktion #15 aufrufen */
 return ( XMSErr == ERR_NOERR );
}

/***********************************************************************
* XMSGetUMB : Allokiert einen upper-Memory-Block (UMB).                *
**--------------------------------------------------------------------**
* Eingabe : LenPara : Gr��e des zu allokierenden Bereichs in Para-     *
*                     graphen (jeweils 16 Byte)                        *
*           Seg     : Variable, die die Segmentadresse des allo-       *
*                     kierten UMB im Erfolgsfall aufnimmt              *
*           MaxPara : Variable, die die L�nge des gr��ten verf�gbaren  *
*                     UMB im Fehlerfall angibt                         *
* Ausgabe : TRUE, wenn ein UMB allokierte werden konnte, sonst FALSE   *
* Info    : Achtung! Diese Funktion wird nicht bei allen XMS-Treibern  *
*                    unterst�tzt und ist extrem Hardware-abh�ngig.     *
***********************************************************************/

BOOL XMSGetUMB( int LenPara, WORD * Seg, WORD * MaxPara )
{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = LenPara;                         /* gew�nschte L�nge nach DX */
 XMSCall( 16, &Xr );                     /* XMS-Funktion #16 aufrufen */
 *Seg = Xr.BX;                        /* Segmentadresse zur�ckliefern */
 *MaxPara = Xr.DX;                           /* L�nge des gr��ten UMB */
 return ( XMSErr == ERR_NOERR );
}

/***********************************************************************
* XMSFreeUMB : Gibt einen zuvor �ber XMSGetUMB allokierten UMB wieder  *
*              frei.                                                   *
**--------------------------------------------------------------------**
* Eingabe : Seg : Segmentadresse des freizugebenden UMB                *
* Info    : Achtung! Diese Funktion wird nicht bei allen XMS-Treibern  *
*                    unterst�tzt und ist extrem Hardware-abh�ngig.     *
***********************************************************************/

void XMSFreeUMB( WORD Seg )

{
 XMSRegs Xr;                               /* Register f�r XMS-Aufruf */

 Xr.DX = Seg;                       /* Segmentadresse des UMB nach DX */
 XMSCall( 17, &Xr );                     /* XMS-Funktion #17 aufrufen */
}

