/**********************************************************************/
/*                               E M M C                              */
/*--------------------------------------------------------------------*/
/*    Aufgabe        : stellt einige Funktionen zum Zugriff auf den   */
/*                     EMS-Speicher (Expanded Memory) zur VerfÅgung.  */
/*--------------------------------------------------------------------*/
/*    Autor          : MICHAEL TISCHER                                */
/*    entwickelt am  : 30.08.1988                                     */
/*    letztes Update : 19.02.1992                                     */
/*--------------------------------------------------------------------*/
/*    Speichermodell : eines mit FAR-Zeiger auf die Daten, also       */
/*                     Compact, Large oder Huge                       */
/**********************************************************************/
                                                              


/*== Typedefs ========================================================*/

#include "byte.h"
                                                         

typedef BYTE BOOL;                           /* wie BOOLEAN in Pascal */

/*-- MK_FP erstellt aus einer Segment- und Offsetadresse einen -------*/
/*-- FAR-Pointer auf ein Objekt                                -------*/
                                                              
#ifdef MK_FP                        /* wurde MK_FP bereits definiert? */
 #undef MK_FP
#endif
#define MK_FP(seg, ofs) ((void far *) ((unsigned long) (seg)<<16|(ofs)))


/*-- PAGE_ADR liefert einen Pointer auf die physikalische Seite X ----*/
/*-- innheralb des Page-Frame des EMS-Speichers                   ----*/
                                                              
#define PAGE_ADR(x) ((void *) MK_FP(ems_frame_seg() + ((x) << 10), 0))
                                                              
/*== Konstanten ======================================================*/
                                                              
#define TRUE  1                     /* Konstanten zur Arbeit mit BOOL */
#define FALSE 0
                                                              
#define EMS_INT 0x67          /* Interruptnr. zum Zugriff auf den EMM */
#define EMS_ERR -1           /* wird bei einem Fehler zurÅckgeliefert */
                                                              

/***********************************************************************
*  Funktion         : E M S _ I N S T                                  *
**--------------------------------------------------------------------**
*  Aufgabe          : Stellt fest, ob EMS-Speicher und ein zugehîriger *
*                     EMS-Treiber (EMM) installiert sind.              *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : TRUE, wenn EMS-Speicher installiert ist, sonst   *
*                     FALSE.                                           *
***********************************************************************/
                                                              
BOOL ems_inst(void) ;

/***********************************************************************
*  Funktion         : E M S _ N U M _ P A G E                          *
**--------------------------------------------------------------------**
*  Aufgabe          : Ermittelt die Gesamtanzahl der EMS-Pages.        *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : EMS_ERR bei einem Fehler, sonst die Anzahl der   *
*                     EMS-Pages.                                       *
***********************************************************************/
                                                              
int ems_num_page(void) ;

                                                              
/***********************************************************************
*  Funktion         : E M S _ F R E E _ P A G E                        *
**--------------------------------------------------------------------**
*  Aufgabe          : Ermittelt die Anzahl der noch freien EMS-Pages.  *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : EMS_ERR bei einem Fehler, sonst die Anzahl der   *
*                     freien EMS-Pages.                                *
***********************************************************************/
                                                              
int ems_free_page(void) ;

                                                              
/***********************************************************************
*  Funktion         : E M S _ F R A M E _ S E G                        *
**--------------------------------------------------------------------**
*  Aufgabe          : Ermittelt die Segmentadresse des EMS-Page-Frames *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : EMS_ERR bei einem Fehler, sonst die Segment-     *
*                     adresse des Page-Frames.                         *
***********************************************************************/
                                                              
WORD ems_frame_seg(void) ;


/***********************************************************************
*  Funktion         : E M S _ A L L O C                                *
**--------------------------------------------------------------------**
*  Aufgabe          : Allokiert die angegebene Zahl von Pages und      *
*                     liefert ein Handle zum Zugriff auf diese Pages   *
*                     zurÅck.                                          *
*  Eingabe-Parameter: PAGES : die Anzahl der zu allokierenden Pages    *
*                             (jeweils 16 KByte)                       *
*  Return-Wert      : EMS_ERR bei einem Fehler, sonst das EMS-Handle.  *
***********************************************************************/
                                                              
int ems_alloc(int pages) ;


/***********************************************************************
*  Funktion         : E M S _ M A P                                    *
**--------------------------------------------------------------------**
*  Aufgabe          : Bildet eine der unter dem angegebenen Handle     *
*                     allokierten Seiten auf eine physikalische Seite  *
*                     im Page-Frame ab.                                *
*  Eingabe-Parameter: HANDLE: das bei EMS_ALLOC zurÅckgel. Handle.     *
*                     LOGP  : die logische Page (0 bis n-1)            *
*                     PHYSP : die physikalische Page (0 bis 3)         *
*  Return-Wert      : FALSE bei einem Fehler, sonst TRUE.              *
***********************************************************************/
                                                              
BOOL ems_map(int handle, int logp, BYTE physp) ;

                                                              
/***********************************************************************
*  Funktion         : E M S _ F R E E                                  *
**--------------------------------------------------------------------**
*  Aufgabe          : Gibt den unter einem Handle allokierten Speicher *
*                     wieder frei.                                     *
*  Eingabe-Parameter: HANDLE: das bei EMS_ALLOC zurÅckgel. Handle.     *
*  Return-Wert      : FALSE bei einem Fehler, sonst TRUE.              *
***********************************************************************/
                                                              
BOOL ems_free(int handle) ;


                                                              
/***********************************************************************
*  Funktion         : E M S _ V E R S I O N                            *
**--------------------------------------------------------------------**
*  Aufgabe          : Ermittelt die EMM-Versionsnummer.                *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : EMS_ERR bei einem Fehler, sonst die EMM-         *
*                     Versionsnummer.                                  *
*  Info             : Bei der Versionsnr. steht 10 fÅr 1.0, 11 fÅr     *
*                     1.1, 34 fÅr 3.4 etc.                             *
***********************************************************************/
                                                              
BYTE ems_version(void) ;


                                                              
/***********************************************************************
*  Funktion         : E M S _ S A V E _ M A P                          *
**--------------------------------------------------------------------**
*  Aufgabe          : Speichert die Abbildung (Mapping) zwischen lo-   *
*                     gischen und physikalischen Pages.                *
*  Eingabe-Parameter: HANDLE: das bei EMS_ALLOC zurÅckgel. Handle.     *
*  Return-Wert      : FALSE bei einem Fehler, sonst TRUE.              *
***********************************************************************/
                                                              
BOOL ems_save_map(int handle) ;

                                                              
/***********************************************************************
*  Funktion         : E M S _ R E S T O R E _ M A P                    *
**--------------------------------------------------------------------**
*  Aufgabe          : Holt eine zuvor Åber EMS_SAVE_MAP gespeicherte   *
*                     Abbildung zischen logischen und physikalischen   *
*                     Pages wieder zurÅck.                             *
*  Eingabe-Parameter: HANDLE: das bei EMS_ALLOC zurÅckgel. Handle.     *
*  Return-Wert      : FALSE bei einem Fehler, sonst TRUE.              *
***********************************************************************/
                                                              
BOOL ems_restore_map(int handle) ;


                                                              
/***********************************************************************
*  Funktion         : P R I N T _ E R R                                *
**--------------------------------------------------------------------**
*  Aufgabe          : Gibt eine EMS-Fehlermeldung auf dem Bildschirm   *
*                     aus und beendet das Programm.                    *
*  Eingabe-Parameter: keine                                            *
*  Return-Wert      : keiner                                           *
*  Info             : Diese Funktion darf nur aufgerufen werden, wenn  *
*                     bei einem vorhergehenden Aufruf einer Funktion   *
*                     des EMM ein Fehler aufgetreten ist.              *
***********************************************************************/
                                                              
void print_err(void) ;

                                                              
