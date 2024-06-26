
/* ==== */
/* bm.h */
/* ==== */


#include <stdio.h>


#ifdef __MSDOS__
typedef unsigned short u_short ;
#endif




/* ---------- */
/* Constantes */
/* ---------- */

#define MAJREV          1                       /* revision */
#define MINREV          0                       /* version */

#ifdef __MSDOS__
#include "..\blang\_lang.h"

#ifdef FRENCH
# define FRENCH          1                       /* francais */
# define ENGLISH         0                       /* anglais */
# define GERMAN          0
#else

# ifdef GERMAN
#  define FRENCH          0                       /* francais */
#  define ENGLISH         0                       /* anglais */
#  define GERMAN          1
# else

#  ifdef ENGLISH
#   define FRENCH          0                       /* francais */
#   define ENGLISH         1                       /* anglais */
#   define GERMAN          0
#  endif
# endif
#endif


#else
#define FRENCH          0                       /* francais */
#define ENGLISH         0                       /* anglais */
#define GERMAN          1                       /* allemand */
#endif

#define LXIMAGE         640                     /* largeur d'une image */
#define LYIMAGE         340                     /* hauteur d'une image */

#define POSXPALETTE     8                       /* coin sup/gauche de la palette d'icones */
#define POSYPALETTE     8                       /* coin sup/gauche de la palette d'icones */
#define DIMXPALETTE     52                      /* largeur de la palette d'icones */
#define DIMYPALETTE     324                     /* hauteur de la palette d'icones */

#define POSXDRAW        72                      /* coin sup/gauche de la fenetre de jeu */
#define POSYDRAW        8                       /* coin sup/gauche de la fenetre de jeu */
#define DIMXDRAW        560                     /* largeur de la fenetre de jeu */
#define DIMYDRAW        324                     /* hauteur de la fenetre de jeu */

#define DELSLOW         8                       /* delai entre deux images (lent) */
#define DELNORM         5                       /* delai entre deux images (normal) */
#define DELQUICK        2                       /* delai entre deux images (maximum) */

#define IMABASE         1                       /* image de base */
#define IMAICON         1                       /* image des icones */
#define IMAMASK         10                      /* offset pour image de masque */

#define MAXIMAGE        (20*2)          /* nb max d'images */
#define MAXSOUND        10                      /* nb max de sons */

#define KEYQUIT         (-1)            /* touche quitte */
#define KEYHOME         (-2)            /* touche retourne a la maison */
#define KEYDEF          (-3)            /* touche definitions */
#define KEYINFO         (-4)            /* touche informations */
#define KEYUNDO         (-5)            /* touche annule */
#define KEYDEL          (-6)            /* touche detruit a gauche */
#define KEYRETURN       (-7)            /* touche retour principale */
#define KEYENTER        (-8)            /* touche d'entree (pave numerique) */
#define KEYPAUSE        (-9)            /* touche pause */
#define KEYF1           (-10)           /* touche F1 */
#define KEYF2           (-11)           /* touche F2 */
#define KEYF3           (-12)           /* touche F3 */
#define KEYF4           (-13)           /* touche F4 */
#define KEYSAVE         (-14)           /* touche sauve partie */
#define KEYLOAD         (-15)           /* touche reprend partie */
#define KEYIO           (-16)           /* touche sauve/reprend partie */
#define KEYCLIC         (-20)           /* bouton souris presse (gauche) */
#define KEYCLICR        (-21)           /* bouton souris presse (droite) */
#define KEYCLICREL      (-22)           /* bouton souris relache */
#define KEYLEFT         (-30)           /* touche gauche */
#define KEYRIGHT        (-31)           /* touche droite */
#define KEYUP           (-32)           /* touche haut */
#define KEYDOWN         (-33)           /* touche bas */
#define KEYSLEFT        (-34)           /* touche shift gauche */
#define KEYSRIGHT       (-35)           /* touche shift droite */
#define KEYSUP          (-36)           /* touche shift haut */
#define KEYSDOWN        (-37)           /* touche shift bas */
#define KEYCENTER       (-40)           /* touche centre */
#define KEYGOFRONT      (-50)           /* touche en avant */
#define KEYGOBACK       (-51)           /* touche en arriere */
#define KEYGOLEFT       (-52)           /* touche tourne a gauche */
#define KEYGORIGHT      (-53)           /* touche tourne a droite */
#define KEYAIGU         (-60)           /* touche accent aigu */
#define KEYGRAVE        (-61)           /* touche accent grave */
#define KEYCIRCON       (-62)           /* touche accent circonflexe */
#define KEYTREMA        (-63)           /* touche accent trema */
#define KEYAAIGU        (-70)           /* touche "a" aigu*/
#define KEYAGRAVE       (-71)           /* touche "a" grave */
#define KEYACIRCON      (-72)           /* touche "a" circonflexe*/
#define KEYATREMA       (-73)           /* touche "a" trema */
#define KEYEAIGU        (-74)           /* touche "e" aigu*/
#define KEYEGRAVE       (-75)           /* touche "e" grave */
#define KEYECIRCON      (-76)           /* touche "e" circonflexe*/
#define KEYETREMA       (-77)           /* touche "e" trema */
#define KEYIAIGU        (-78)           /* touche "i" aigu*/
#define KEYIGRAVE       (-79)           /* touche "i" grave */
#define KEYICIRCON      (-80)           /* touche "i" circonflexe*/
#define KEYITREMA       (-81)           /* touche "i" trema */
#define KEYOAIGU        (-82)           /* touche "o" aigu*/
#define KEYOGRAVE       (-83)           /* touche "o" grave */
#define KEYOCIRCON      (-84)           /* touche "o" circonflexe*/
#define KEYOTREMA       (-85)           /* touche "o" trema */
#define KEYUAIGU        (-86)           /* touche "u" aigu*/
#define KEYUGRAVE       (-87)           /* touche "u" grave */
#define KEYUCIRCON      (-88)           /* touche "u" circonflexe*/
#define KEYUTREMA       (-89)           /* touche "u" trema */
#define KEYCCEDILLE     (-90)           /* touche "c" cedille */
#define KEYcCEDILLE     (-91)           /* touche "C" cedille */
#define KEYF5           (-100)          /* touche F5 */
#define KEYF6           (-101)          /* touche F6 */
#define KEYF7           (-102)          /* touche F7 */
#define KEYF8           (-103)          /* touche F8 */
#define KEYF9           (-104)          /* touche F9 */
#define KEYF10          (-105)          /* touche F10 */
#define KEYF11          (-106)          /* touche F11 */
#define KEYF12          (-107)          /* touche F12 */

#define MAXCELX         20                      /* nb max de cellules en x */
#define MAXCELY         20                      /* nb max de cellules en y */

#define MAXTOTO         (10+2)          /* nb max de toto animes simultanes */




/* --------- */
/* KeyStatus */
/* --------- */

typedef enum
{
  STLEFT        =       1<<0,                   /* va a gauche */
  STRIGHT       =       1<<1,                   /* va a droite */
  STUP          =       1<<2,                   /* va en haut */
  STDOWN        =       1<<3                    /* va en bas */
}
KeyStatus;



/* -------------------- */
/* Structure d'un monde */
/* -------------------- */

#define MAXPALETTE      100
#define MAXTEXT         500

typedef struct
{
	short   tmonde[MAXCELY][MAXCELX];               /* cellules du monde */
	short   palette[MAXPALETTE];                    /* palette d'icones */
	char    text[MAXTEXT];                                  /* texte de description */
	short   freq;                                                   /* frequence de sortie */
	short   color;                                                  /* palette de couleurs */
	short   reserve[100];                                   /* reserve */
}
Monde;



/* --------------- */
/* Modes de dessin */
/* --------------- */

#ifdef __MSDOS__
typedef enum
{
  MODELOAD =    0,                      /* mode load */
  MODEOR   =    2,                      /* mode or   */
  MODEAND  =    5,                      /* mode and  */
  MODEXOR  =    7                       /* mode xor  */
}
ShowMode;

#else

typedef enum
{
  MODELOAD =    0,                      /* mode load */
  MODEOR   =    1,                      /* mode or   */
  MODEAND  =    2,                      /* mode and  */
  MODEXOR  =    3                       /* mode xor  */
}
ShowMode;

#endif


/* ----- */
/* Icone */
/* ----- */

#define UL              (1<<14)                 /* quart sup/gauche */
#define UR              (1<<13)                 /* quart sup/droite */
#define DL              (1<<12)                 /* quart inf/gauche */
#define DR              (1<<11)                 /* quart inf/droite */

#define ICOMOFF         512                     /* offset pour icones de masque */
#define ICONMASK        0x07FF          /* masque pour ne conserver que l'icone */

#define LXICO           80                      /* largeur d'une icone */
#define LYICO           80                      /* hauteur d'une icone */
#define PLXICO          44                      /* pas gauche en x */
#define PLYICO          11                      /* pas gauche en y */
#define PRXICO          36                      /* pas droite en x */
#define PRYICO          18                      /* pas droite en y */
#define PZICO           51                      /* pas vertical en z */

#define ICOVIDE         0                       /* icone vide (pour effacer) */





/* ----- */
/* Point */
/* ----- */

typedef struct
{
  short         y;                      /* coordonnee signee y */
  short         x;                      /* coordonnee signee x */
}
Pt;



/* --------- */
/* Rectangle */
/* --------- */

typedef struct
{
  Pt            p1;                     /* coin sup/gauche */
  Pt            p2;                     /* coin inf/droite */
}
Rectangle;



/* ------ */
/* Region */
/* ------ */

typedef struct
{
  Rectangle     r;                      /* rectangle de la region */
}
Reg;



/* --------- */
/* Pixel map */
/* --------- */

typedef struct
{
  short         dy;                             /* hauteur */
  short         dx;                             /* largeur */
  short         dxb;                    /* largeur en bytes */
  u_short       nbp;                    /* nb de bits/pixel */
  short         ccolor;                 /* couleur pour effacer  */
  short         scolor;                 /* couleur pour dessiner */
  char          *data;                  /* pointeur aux donnees */
}
Pixmap;



/* -------- */
/* Couleurs */
/* -------- */

#define COLORBLANC              0               /* blanc */
#define COLORJAUNE              1               /* jaune */
#define COLORORANGE             2               /* orange */
#define COLORROUGE              3               /* rouge */
#define COLORGRISC              4               /* gris clair */
#define COLORGRISF              5               /* gris fonce */
#define COLORCYAN               6               /* cyan */
#define COLORBLEU               7               /* bleu */
#define COLORVERTC              8               /* vert clair */
#define COLORVERTF              9               /* vert fonce */
#define COLORVIOLET             10              /* violet */
#define COLORMAGENTA    11              /* magenta */
#define COLORBRUNC              12              /* brun clair */
#define COLORBRUNF              13              /* brun fonce */
#define COLORBLEUM              14              /* bleu moyen */
#define COLORNOIR               15              /* noir */



/* ------------------ */
/* Variables globales */
/* ------------------ */

extern  short   langue;                         /* numero de la langue */
extern  short   monde;                          /* monde actuel (0..n) */
extern  short   updatescreen;                                   /* 1 -> ecran a mettre a jour */
extern  short   typejeu;                        /* type de jeu (0..1) */
extern  short   typeedit;                       /* 1 -> edition d'un monde */
extern  short   typetext;                       /* 1 -> edition d'un texte */
extern  short   modetelecom;            /* 1 -> mode telecommande gauche/droite */
extern  short   pause;                          /* 1 -> pause */
extern  short   passdaniel;                     /* 1 -> toujours construction */
extern  short   passpower;                      /* 1 -> force infinie */
extern  short   passnice;                       /* 1 -> toujours gentil */
extern  short   passhole;                       /* 1 -> ne tombe pas dans trou */





/* --------------------- */
/* Declarations externes */
/* --------------------- */


/* bm_pal.c */
/* -------- */

extern  void    PaletteUseObj   (short icon);
extern  short   PaletteStatus   (short rang);
extern  short   PaletteGetPress (void);
extern  short   PaletteEvent    (short event, Pt pos);
extern  void    PaletteNew              (short *pdesc, short type);

extern  void    PaletteEditOpen (short palette[]);
extern  short   PaletteEditEvent (short palette[], short event, Pt pos);
extern  void    PaletteEditClose (short palette[]);

extern  void    InfoDraw                (short status, short force, short vision,
								 short mechant, short magic, short cles);

extern  long    PalPartieLg             (void);
extern  short   PalPartieWrite  (long pos, char file);
extern  short   PalPartieRead   (long pos, char file);


/* bm_move.c */
/* --------- */

extern  void    MoveModifCel    (Pt cel);
extern  short   MoveGetCel              (Pt cel);
extern  void    MoveBack                (Pt cel);
extern  short   MoveNext                (char event, Pt pos);
extern  void    MoveRedraw              (void);
extern  short   MoveBuild               (short outil);
extern  void    MoveScroll              (short quick);
extern  void    MoveNewMonde    (short freq);
extern  short   MoveOpen                (void);
extern  void    MoveClose               (void);

extern  long    MovePartieLg    (void);
extern  short   MovePartieWrite (long pos, char file);
extern  short   MovePartieRead  (long pos, char file);


/* bm_decor.c */
/* ---------- */

extern  Pt              GraToCel                (Pt gra);
extern  Pt              CelToGra                (Pt cel);
extern  short   DecorGetInitCel (Pt cel);
extern  void    DecorPutInitCel (Pt cel, short icon);
extern  short   DecorGetCel             (Pt cel);
extern  void    DecorPutCel             (Pt cel, short icon);
extern  void    DecorIconMask   (Pixmap *ppm, Pt pos, short posz, Pt cel);
extern  Pt              DecorDetCel             (Pt pmouse);
extern  void    DecorSuperCel   (Pt pmouse);
extern  short   DecorEvent              (Pt pos, short poscel, short icon);
extern  void    DecorModif              (Pt cel, short icon);
extern  Pixmap* DecorGetPixmap  (void);
extern  Pt              DecorGetOrigine (void);
extern  void    DecorSetOrigine (Pt origine, short quick);
extern  void    DecorMake               (short);
extern  short   DecorNewMonde   (Monde *pmonde);
extern  short   DecorOpen               (void);
extern  void    DecorClose              (void);

extern  long    DecorPartieLg   (void);
extern  short   DecorPartieWrite (long pos, char file);
extern  short   DecorPartieRead (long pos, char file);


/* bm_icone.c */
/* ---------- */

extern  short   IfNilRegion             (Reg rg);
extern  short   IfSectRegion    (Reg r1, Reg r2);
extern  Reg             OrRegion                (Reg r1, Reg r2);
extern  Reg             AndRegion               (Reg r1, Reg r2);
extern  void    IconDrawAll             (void);
extern  void    IconDrawFlush   (void);
extern  void    IconDrawOpen    (void);
extern  short   IconDrawPut             (short ico, short btransp, Pt pos, short posz, Pt cel, Reg clip);
extern  void    IconDrawUpdate  (Reg rg);
extern  void    IconDrawClose   (short);
extern  short   IconOpen                (void);
extern  void    IconClose               (void);
extern  void    IconInit                (void);


/* bm_text.c */
/* --------- */

#define TEXTSIZELIT             10              /* petite taille */
#define TEXTSIZEMID             21              /* taille moyenne */

extern  Pt              DrawText                (Pixmap *ppm, Pt pos, char *pstring, short size, ShowMode mode);
extern  Rectangle GetRectText   (Pt pos, char *pstring, short size);
extern  void    DrawParagraph   (Pixmap *ppm, Rectangle rect, char *pstring,
								 short size, ShowMode mode);

extern  short   EditEvent               (short key, Pt pos);
extern  short   EditOpen                (char *p, short max, Rectangle rect);
extern  short   EditClose               (void);


/* bm_smaky.c */
/* ---------- */

extern  void    InitRandomEx    (short g, short min, short max, char *pex);
extern  short   GetRandomEx             (short g, short min, short max, char *pex);
extern  short   GetRandom               (short g, short min, short max);
extern  void    StartRandom             (short g, short mode);

extern  short   PrintScreen             (Pt p1, Pt p2);

extern  void    MusicStart              (short song);
extern  void    MusicStop               (void);
extern  void    PlayNoiseVolume (short volume);
extern  void    PlayMusicVolume (short volume);
extern  short   IfPlayReady             (void);
extern  void    PlaySoundLoop   (short mode);
extern  void    PlaySound               (short sound);

extern  void    OpenTime                (void);
extern  void    CloseTime               (short t);

extern  void    PosMouse                (Pt pos);
extern  short   IfMouse                 (void);
extern  void    ShowMouse               (void);
extern  void    HideMouse               (void);

extern  short   GetEvent                (Pt *ppos);
extern  void    ClrEvent                                () ;
extern  KeyStatus GetKeyStatus  (void);
extern  short   IfColor                 (void);
extern  void    ModColor                (short color, short red, short green, short blue);
extern  void    GetColor                (short color, short *pred, short *pgreen, short *pblue);
extern  void    CacheIcon               (short numero);
extern  short   GetIcon                 (Pixmap *ppm, short numero, short mode);
extern  short   GetPixmap               (Pixmap *ppm, Pt dim, short fill, short colormode);
extern  short   TestHLine               (Pixmap *ppm, short y);
extern  short   TestVLine               (Pixmap *ppm, short x);
extern  short   GetImage                (Pixmap *ppm, short numero);
extern  short   GivePixmap              (Pixmap *ppm);
extern  void    DuplPixel               (Pixmap *ppms, Pixmap *ppmd);
extern  void    ScrollPixel             (Pixmap *ppm, Pt shift, char color, Rectangle *pzone);
extern  void    ScrollPixelRect         (Pixmap *ppm, Pt od, Pt dim, Pt shift, char color, Rectangle *pzone);
extern  short   CopyPixel               (Pixmap *ppms, Pt os,
								 Pixmap *ppmd, Pt od,
								 Pt dim, ShowMode mode);
extern  void    DrawLine                (Pixmap *ppm, Pt p1, Pt p2, ShowMode mode, char color);
extern  void    DrawRect                (Pixmap *ppm, Rectangle rect, ShowMode mode, char color);
extern  void    DrawFillRect    (Pixmap *ppm, Rectangle rect, ShowMode mode, char color);
extern  char    GetPixel                (Pixmap *ppm, Pt pos);
extern  void    BlackScreen             (void);
extern	short	SavePixmap		(Pixmap *ppm);
extern	short	RestorePixmap	(Pixmap *ppm);


extern  short   FileRead                (void *pdata, long pos, short nb, char file);
extern  short   FileWrite               (void *pdata, long pos, short nb, char file);
extern  long    FileGetLength   (char file);
extern  short   FileDelete              (char file);
extern  short   FileRename              (char oldfile, char newfile);

extern  void    FatalError              (short err);
extern  void    OpenMachine             (void);
extern  void    CloseMachine    (void);

extern  long    MachinePartieLg         (void);
extern  short   MachinePartieWrite      (long pos, char file);
extern  short   MachinePartieRead       (long pos, char file);

extern  void    SetDemo                 (char bDemo);
extern  char    GetDemo                 (void);

extern Pixmap* IconGetPixmap (void) ;