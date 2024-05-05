;**********************************************************************;
;*                           X M S C A . A S M                        *;
;*--------------------------------------------------------------------*;
;*    Aufgabe        : Assemblerroutine zur Einbindung in das C-      *;
;*                     Programm XMSC.C. Stellt eine Routine zum Auf-  *;
;*                     ruf des XMS-Treibers zur VerfÅgung.            *;
;*                     Implementierung hier fÅr das Speichermodell    *;
;*                     SMALL.                                         *;
;*--------------------------------------------------------------------*;
;*    Autor          : MICHAEL TISCHER                                *;
;*    entwickelt am  : 27.07.1990                                     *;
;*    letztes Update : 27.07.1990                                     *;
;*--------------------------------------------------------------------*;
;*    assemblieren   : MASM XMSCA;   oder   TASM XMSCA;               *;
;*                     ... dann mit dem compilierten C-Programm       *;
;*                         XMSC.C verbinden                           *;
;**********************************************************************;

;== Segmentdeklarationen fÅr das C-Programm ============================



extrn _XMSPtr : dword            ;Referenz auf den XMS-Zeiger


;== Programm ===========================================================


	.MODEL COMPACT, C

	.CODE

public     XMSCall

;-----------------------------------------------------------------------
;-- XMSCall : Allgmeine Routine zum Aufruf einer XMS-Funktion
;-- Aufruf von C: void XMSCall( BYTE FktNr, XMSRegs *Xr )    mit
;--             typedef struct { WORD AX, BX, DX, SI, Segment } XMSRegs;
;-- Return-Wert : keiner
;-- Info    : - Es mÅssen vor dem Aufruf dieser Prozedur immer nur die
;--             Register geladen werden, die fÅr den Aufruf der angege-
;--             benen Funktion tatsÑchlich benîtigt werden.
;--           - Nach dem XMS-Funktionsaufruf werden die Inhalte der ver-
;--             schiedenen Prozessorregister in die korrespondierenden
;--             Komponenten der Åbergebenen Struktur kopiert.
;--           - Vor dem ersten Aufruf dieser Prozedur mu· die Prozedur
;--             XMSInit erfolgreich aufgerufen worden sein.

XMSCall	proc C far  fktnr:WORD, xrptr:DATAPTR

	   push   si                ;SI und DI sichern
	   push   di
	   mov	  cx,ds                     ;und auf dem Stack sichern

	   mov    ah, byte ptr fktnr
	   lds	  di, xrptr

	   mov    bx,ds:[di+2]               ;Register aus den Komponenten
	   mov    dx,ds:[di+4]               ;der Struktur laden
	   mov    si,ds:[di+6]
	   mov    ds,ds:[di+8]

	   mov	  es, cx
	   call   es:[_XMSPtr]            ;XMS-Handler aufrufen

	   lds	  di, xrptr
	   mov    ds:[di],ax                 ;Register in die zugehîrigen
	   mov    ds:[di+02],bx              ;Komponenten der Struktur
	   mov    ds:[di+04],dx              ;eintragen
	   mov    ds:[di+06],si
	   mov    ds:[di+08],cx

	   mov    ds,cx
	   pop    di              ;SI und DI zurÅckholen
	   pop    si

	   ret                    ;zurÅck zum C-Programm

XMSCall   endp

;-------------------------------------------------------------------------
                                                                        
	   end                    ;Ende des Programms
