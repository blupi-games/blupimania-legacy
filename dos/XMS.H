/***********************************************************************
*                              X M S C . C                             *
**--------------------------------------------------------------------**
*  Aufgabe        : Demonstriert den Zugriff auf extended Memory und   *
*                   High-Memory-Area mit Hilfe der XMS-Funktionen, wie *
*                   sie z.B. durch den GerÑtetreiber HIMEM.SYS imple-  *
*                   mentiert werden.                                   *
**--------------------------------------------------------------------**
*  Autor          : MICHAEL TISCHER                                    *
*  entwickelt am  : 27.07.1990                                         *
*  letztes Update : 29.07.1990                                         *
***********************************************************************/

/*-- Include-Dateien einbinden ---------------------------------------*/

#include <dos.h>                              /* fÅr Interruptaufrufe */

#ifdef __TURBOC__
  #include <alloc.h>
#else
  #include <malloc.h>
#endif

/*-- Typdeklarationen ------------------------------------------------*/

typedef unsigned char BYTE;
typedef BYTE BOOL;
typedef unsigned WORD;


/*-- Konstanten ------------------------------------------------------*/

#define ERR_NOERR          0x00                        /* kein Fehler */
#define ERR_NOTIMPLEMENTED 0x80  /* angegebene Funktion nicht bekannt */
#define ERR_VDISKFOUND     0x81             /* VDISK-RAMDISK entdeckt */
#define ERR_A20            0x82       /* Fehler auf Adressleitung A20 */
#define ERR_GENERAL        0x8E          /* allgemeiner Treiberfehler */
#define ERR_UNRECOVERABLE  0x8F            /* nicht-behebbarer Fehler */
#define ERR_HMANOTEXIST    0x90                /* keine HMA vorhanden */
#define ERR_HMAINUSE       0x91               /* HMA bereits vergeben */
#define ERR_HMAMINSIZE     0x92              /* zu wenig Platz in HMA */
#define ERR_HMANOTALLOCED  0x93                /* HMA nicht allokiert */
#define ERR_A20STILLON     0x94          /* Adressleitung A20 noch an */
#define ERR_OUTOMEMORY     0xA0     /* kein extended Memory mehr frei */
#define ERR_OUTOHANDLES    0xA1            /* alle XMS-Handles belegt */
#define ERR_INVALIDHANDLE  0xA2                  /* ungÅltiges Handle */
#define ERR_SHINVALID      0xA3             /* Source-Handle ungÅltig */
#define ERR_SOINVALID      0xA4             /* Source-Offset ungÅltig */
#define ERR_DHINVALID      0xA5        /* Destination-Handle ungÅltig */
#define ERR_DOINVALID      0xA6        /* Destination-Offset ungÅltig */
#define ERR_LENINVALID     0xA7 /* ungÅltige LÑnge fÅr Move- Funktion */
#define ERR_OVERLAP        0xA8              /* verbotene öberlappung */
#define ERR_PARITY         0xA9                    /* ParÑtits-Fehler */
#define ERR_EMBUNLOCKED    0xAA             /* UMB ist nicht gesperrt */
#define ERR_EMBLOCKED      0xAB              /* UMB ist noch gesperrt */
#define ERR_LOCKOVERFLOW   0xAC      /* öberlauf des UMB-SperrzÑhlers */
#define ERR_LOCKFAIL       0xAD     /* UMB kann nicht gesperrt werden */
#define ERR_UMBSIZETOOBIG  0xB0            /* kleinerer UMB verfÅgbar */
#define ERR_NOUMBS         0xB1            /* kein UMB mehr verfÅgbar */
#define ERR_INVALIDUMB     0xB2    /* UMB-Segmentadresse ist ungÅltig */

#define TRUE  ( 0 == 0 )
#define FALSE ( 0 == 1 )

/*-- Makros ----------------------------------------------------------*/

#ifndef MK_FP
  #define MK_FP(seg,ofs) \
         ((void far *) (((unsigned long)(seg) << 16) | (unsigned)(ofs)))
#endif

#define Hi(x) (*((BYTE *) &x+1))                /* Hi-Byte eines ints */
#define Lo(x) (*((BYTE *) &x))                  /* Lo-Byte eines ints */


/*-- extern Deklarationen --------------------------------------------*/

//extern void XMSCall( BYTE FktNr, XMSRegs *Xr );

/*-- globale Variablen -----------------------------------------------*/


//extern void far * XMSPtr;    /* Zeiger auf den Extended-Memory-Manager (XMM) */
extern BYTE XMSErr;                      /* Fehlercode der letzten Operation */


BOOL XMSInit( void );

BOOL XMSQueryVer( int * VerNr, int * RevNr);

BOOL XMSGetHMA( WORD LenB );

void XMSReleaseHMA( void );

void XMSA20OnGlobal( void );

void XMSA20OffGlobal( void );

void XMSA20OnLocal( void );

void XMSA20OffLocal( void );

BOOL XMSIsA20On( void );

void XMSQueryFree( int * GesFrei, int * MaxBl );

int XMSGetMem( int LenKb );

void XMSFreeMem( int Handle ) ;

void XMSCopy( int VonHandle, long VonOffset, int NachHandle,
	      long NachOffset, int LenW ) ;


long XMSLock( int Handle ) ;

void XMSUnlock( int Handle ) ;

void XMSQueryInfo( int Handle, int * Lock, int * LenKB, int * FreeH ) ;


BOOL XMSRealloc( int Handle, int NeuLenKB) ;

BOOL XMSGetUMB( int LenPara, WORD * Seg, WORD * MaxPara ) ;

void XMSFreeUMB( WORD Seg ) ;


