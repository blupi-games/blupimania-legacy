
#define USE_BLASTER		// utilise la carte SoundBlaster
#undef FIXIMBUF			// buffer d'images fixe

#include "..\blang\_cdinst.h"
#define NOPROTECTION

#ifdef NOPROTECTION
#define TESTVERSION
#endif


//#define SHAREWARE



/* ============== */
/* toto_x_smaky.c */
/* ============== */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <alloc.h>
#include <io.h>
#include <errno.h>
#include <conio.h>
#include <fcntl.h>

#include <dos.h>
#include <fcntl.h>
#include "bm.h"
#include "xms.h"
#include "icfile.h"
#include "keys_pc.h"
#include "muspl.h"

/* ---------------------------- */
/* Constantes globales internes */
/* ---------------------------- */

#define MAXCOLLENGTH 55000L

#define MEMBW			820000		/* m‚moire n‚cessaire pour noir-blanc */
#define MEMCOLOR		2048000		/* m‚moire n‚cessaire pour couleur */
#define MEMRUNBW		273000		/* m‚moire n‚cessaire pour variables */
#define MEMRUNCOLOR		385000		/* m‚moire n‚cessaire pour variables */
#define MEMAUDIO		200000		/* m‚moire n‚cessaire pour audio */
#define MEMBRUIT		390000		/* m‚moire n‚cessaire pour BLUPIX01.AUDIO */
#define MEMMUSIC		290000		/* m‚moire n‚cessaire pour BLUPIX02.AUDIO */

#define KSHIFT		(1<<5)			/* valeur … ajouter si SHIFT */


typedef unsigned char u_char ;
typedef unsigned long u_long ;


/* ------------ */
/* Image header */
/* ------------ */

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


/* ----------------------------- */
/* Structure d'une image charg‚e */
/* ----------------------------- */

typedef struct
{
  Image		*head;			/* pointe l'en-tˆte */
  char		*clut;			/* pointe la clut */
  char		*data;			/* pointe l'image cod‚e */
}
ImagePC;


#define mouse(x)  {_AX = x;geninterrupt(0x33);}

struct bitmap {
  int left;
  int top;
  int right;
  int bot;
  int bytes;
  char huge *pntr;
};



struct xmsicon
{
  int dx ;
  int dy ;
  int offset ;
} ;


#include "blpinfo.h"

struct blpinfo blpinfo = {0,0,0,0} ;




struct xmsicon xmsicons[8] ;

struct xmsicon icons ;

static int xmshandle ;



/* --------------------------- */
/* Variables globales internes */
/* --------------------------- */

static Pt			origine;					/* coin sup/gauche de l'origine */
static long			atime = 0;					/* temps de d‚but */

static u_long		nextrand[10];	     /* valeurs al‚atoires suivantes */

static short		colormode = 0;	     /* 1 = couleur possible */
static u_short		visumouse = 1;	     /* 1 = souris visible */
static Pt		lastmouse = {0,0};   /* derniŠre position de la souris */
static KeyStatus	keystatus;	     /* ‚tat des flŠches du clavier */
static char		demo = 0;	     /* 1 = mode d‚mo */


static int havemouse ;	/* 1 => on a une souris, 0 => pas de souris */
static int lxwdo, lywdo ;  /* dimensions des fenˆtres */


static ImagePC  imPC;
static ImagePC  *pim=&imPC;
static u_short  lastimage = -1;


#define NBBUFFERS 3
static char *buffer ;

static int have_sbcard ;


/* Prototypes des fonctions de bas niveau */ 
static void PCFatalError (const char *text) ;
extern	void CloseMachine() ;
extern        void tcol_loadclut (void *ptable);
extern	void decode_image(void *sourcedata,void *destdata,int bits);
extern	void select_plane(int plane);
extern	int  graphic_mode(void);
extern	void text_mode(void);
extern	long gettimems(void);
extern	int vfy_mouse(void) ;
extern	void save_video_mode (void) ;
extern	void screen (int on, int border) ;
extern	void trap_interrupts (void) ;
extern	void release_interrupts (void) ;
extern	void restore_video_mode (void);
extern	void blit (struct bitmap *b1, struct bitmap *b2, ShowMode mode) ;
//extern	void wait_r (void) ;
extern	void farmemset (char *ptr, int val, long lgt) ;
//extern	void save_palet (void) ;
//extern	void restore_palet (void) ;
//extern	u_long  mouse_type (void) ;
//extern	void error_handler (int on) ;
//extern	void mouse_disable_mode (int mode) ;
extern	void querry_video (short *monitor, short *mode) ;
////extern  void disable_mouse (void) ;
////extern  void enable_mouse (void) ;
extern void zap_screen (void) ;
extern int ifcolor(void) ;

int initmouse (void) ;

void _drawline (Pixmap *pmap, Pt p1, Pt dim, ShowMode mode,int color) ;


/* ========= */
/* GetRandom */
/* ========= */

/*
	Retourne une valeur al‚atoire comprise entre min et max-1.
	min <= h < max
 */

short GetRandom (short g, short min, short max)
{
	nextrand[g] = nextrand[g] * 1103515245 + 12345;
	return (short)min + (nextrand[g]/65536)%(max-min);
}


/* ============ */
/* InitRandomEx */
/* ============ */

/*
	Initialise un tirage exclusif.
 */

void InitRandomEx (short g, short min, short max, char *pex)
{
  short	i;

  for( i=0 ; i<(max-min) ; i++ )
  {
    pex[i] = 0;			/* met tout le tableau … z‚ro */
  }
}



/* =========== */
/* GetRandomEx */
/* =========== */

/*
	Retourne une valeur al‚atoire exclusive.
 */

short GetRandomEx (short g, short min, short max, char *pex)
{
  short		i, val;

  val = GetRandom(g, 0, max-min);		/* cherche une valeur quelconque */

  for( i=0 ; i<(max-min) ; i++ )
  {
    if ( pex[val] == 0 )			/* valeur d‚j… sortie ? */
    {
      pex[val] = 1;				/* indique valeur utilis‚e */
      return min+val;
    }
    else
    {
      val ++;
      if ( val == max-min )  val = 0;
    }
  }
	
  InitRandomEx(g, min, max, pex);		/* recommence */
  val = GetRandom(g, 0, max-min);		/* cherche une valeur quelconque */
  pex[val] = 1;						/* indique valeur utilis‚e */
  return min+val;
}


/* =========== */
/* StartRandom */
/* =========== */

/*
	Coup de sac du g‚n‚rateur al‚atoire.
		mode = 0	->	toujours la mˆme chose
		mode = 1	->	al‚atoire 100%
 */

#include <time.h>

void StartRandom (short g, short mode)
{
  time_t tm ;
  if ( mode == 0 )
  {
    nextrand[g] = 33554393;		/* grand nombre premier */
  }
  else
  {
	nextrand[g] = time (&tm) ;
  }
}





/* ----------- */
/* ifhidemouse */
/* ----------- */

/*
  Cache la souris si elle est dans un rectangle.
 */

void ifhidemousex (struct bitmap *r)
{
#if 0
  Pt    mouse;

  mouse = getmousepos();    /* lit la position de la souris */
  if ( mouse.x-10 > r->right )  return;
  if ( mouse.x+20 < r->left )  return;
  if ( mouse.y-10 > r->bot )  return;
  if ( mouse.y+20 < r->top )  return;
  HideMouse();        /* cache la souris */
#endif
}






/* ============= */
/* PlayStartStop */
/* ============= */

/*
	Enclenche ou d‚clenche les bruitages.
 */


extern char sound_onoff ;
extern int filsson ;

void PlayStartStop (short mode)
{
  sound_onoff = mode ;
}


/* =========== */
/* IfPlayReady */
/* =========== */

/*
	Test s'il est possible de donner un nouveau son … entendre.
	Si oui, retourne 1 (true).
 */

short IfPlayReady (void)
{
  return 1 ;
}



/* ============= */
/* PlaySoundLoop */
/* ============= */

/*
	Met en boucle (r‚p‚tition) les bruits donn‚s avec PlaySound.
	Si mode =  0  ->  normal (single)
	Si mode >  0  ->  nb de r‚p‚titions
	Si mode = -1  ->  r‚p‚tition infinie (loop)
 */

void PlaySoundLoop (short mode)
{
}


/* ========= */
/* PlaySound */
/* ========= */

/*
	Fait entendre un bruit quelconque.
 */

void PlaySound (short sound)
{
#ifdef USE_BLASTER

  int i, snd ;

  if (sound > 41 && sound != 101 && sound != 109 && sound != 105)
    return ;

  if (have_sbcard)
  {
	if (sound_onoff)
	{
	  if (sound == 105)
	  {
		static int tab[] = {105,107,111} ;
		static int i ;
		sound = tab[i++] ;
		if (i == 3)
		  i = 0 ;
	  }
	  playsoundblast (sound) ;
	}
  }
  else
  {
	if (sound <= 39)
	filsson = sound ;
  }

#else

  if (sound > 39)
    return ;
  filsson = sound;      /* donne le numero au processus fils */
#endif
}


int sbsound (void)
{
  return have_sbcard ;
}






/* ======== */
/* OpenTime */
/* ======== */

/*
	Indique le d‚but d'une op‚ration plus ou moins longue
	(ne fait rien, enregistre simplement le temps absolu).
 */

static long mtime ;

void OpenTime ()
{
  mtime = gettimems () ;
}


/* ========= */
/* CloseTime */
/* ========= */

/*
	Indique la fin d'une op‚ration plus on moins longue,
	avec attente si la dur‚e ‚tait plus petite que le temps total souhait‚.
 */


void CloseTime (short d)
{
  short del = d + 1 ;
  while (gettimems () - mtime < del) ;
}




#define mouse(x)  {_AX = x;geninterrupt(0x33);}


static int mouse_on ;

static void mouseon (void)
{
  mouse_on++ ;
  mouse (1) ;
}


static void mouseoff (void)
{
  mouse_on-- ;
  mouse (2) ;
}




/* ----------- */
/* getmousepos */
/* ----------- */

/*
	Donne la position de la souris, aprŠs avoir re‡u
	un KEYCLIC depuis GetEvent par exemple.
 */

static int mousebuttons ;
static Pt getmousepos (void)
{
  Pt ret;

  mouse (3);
  ret.x = _CX;
  ret.y = _DX;
  mousebuttons = _BX ;
  return ret;
}

/* ======== */
/* PosMouse */
/* ======== */

/*
	D‚place la souris.
 */

void PosMouse (Pt pos)
{
  _CX = pos.x ;
  _DX = pos.y ;
  mouse(4) ;
}



/* ======= */
/* IfMouse */
/* ======= */

/*
	Indique si la souris existe sur cette machine.
	Ceci est utile pour le PC qui n'a pas toujours une souris !
	Si oui, retourne != 0.
 */

short IfMouse (void)
{
  return 1 ; // @@
}



static int hiddenmouse = 0 ;


/* ========= */
/* HideMouse */
/* ========= */

/*
	EnlŠve la souris.
 */

void HideMouse(void)
{
  if (!hiddenmouse)
  {
    mouseoff () ;
    hiddenmouse = 1 ;
  }
}


/* ========= */
/* ShowMouse */
/* ========= */

/*
	Remet la souris.
 */

void ShowMouse(void)
{
  if (hiddenmouse)
  {
    mouseon () ;
    hiddenmouse = 0 ;
  }
}



/* ============ */
/* HideMouseInt */
/* ============ */

/*
	EnlŠve la souris.
 */


void HideMouseInt(void)
{
    mouseoff () ;
}


/* ============ */
/* ShowMouseInt */
/* ============ */

/*
	Remet la souris.
 */

void ShowMouseInt(void)
{
//  if (!hiddenmouse)
    mouseon () ;
}


#if 0
/* ----------- */
/* IfHideMousex */
/* ----------- */

/*
	Cache la souris si elle est dans un rectangle.
 */

static void IfHideMousex (Rectangle r)
{
}
#endif



/* ========= */
/* initmouse */
/* ========= */

/*
  Indique si la souris existe sur cette machine.
  Si oui, retourne != 0.
*/

int initmouse ()
{
  if (vfy_mouse() != -1)
  {
    mouse(1);           /* display mouse */
    visumouse=1;
    return 1;
  }
  else return 0;
}



/*  rend des codes sp‚ciaux si les boutons de la
 *  souris ont ‚t‚ press‚s ou relƒch‚s
 */

  static int buttons ;
  static int pushr ;
  static int relr ;
  static int pushl ;
  static int rell ;

static void clrmouse (void)
{
  pushr = 0 ;
  relr = 0 ;
  pushl = 0 ;
  rell = 0 ;
  buttons = 0 ;
}


static int mousecode (void)
{

	  _BX = 0 ;
	  mouse(6) ;
	  rell = _BX ;

      if (rell > 0)
      {
	pushl = 0 ;
	rell = 0 ;
	return 11 ;
      }

      _BX = 0 ;
      mouse(5) ;
      pushl = _BX ;
      if (pushl > 0)
	return 1 ;



    if (pushr == 0)
    {
      _BX = 1 ;
      mouse(5) ;
      pushr = _BX ;
      if (pushr > 0)
	return 2 ;
    }
    else
    {
      _BX = 1 ;
      mouse(6) ;
      relr = _BX ;

      if (relr > 0)
      {
	pushr = 0 ;
	relr = 0 ;
	return 12 ;
      }
    }
  return 0 ;
}


void clrfifo (void)
{
  disable () ;
  *(int far *)MK_FP (0x40, 0x1a) =
  *(int far *)MK_FP (0x40, 0x1c) ;
  enable () ;
}




/* ========= */
/* ClrEvents */
/* ========= */

/*
  Vide la queue des evenements
 */

void ClrEvents ()
{
  clrfifo () ;
  clrmouse () ;
}



/* ======== */
/* GetEvent */
/* ======== */

/*
	Lecture d'un ‚v‚nement du clavier, sans attendre.
	Retourne la touche press‚e si != 0.
 */

extern char state_left ;
extern char state_right ;
extern char state_up ;
extern char state_down ;

short
GetEvent (Pt * ppos)
{
  long key, maj;
  long accent ;
  int mkey ;

  static int leftbutton, leftclic ;

  *ppos = lastmouse;		/* rend la dernire position de la souris */

  lastmouse = getmousepos ();	/* lit la position de la souris */

  keystatus = 0 ;
  if (state_left)
    keystatus = STLEFT;
  if (state_right)
    keystatus = STRIGHT;
  if (state_up)
    keystatus = STUP;
  if (state_down)
    keystatus = STDOWN;


#if 1
  if (leftbutton && (mousebuttons & 0x1) == 0)
  {
    leftclic++ ;
    if (leftclic == 5)
    {
      leftclic = 0 ; leftbutton = 0 ;
      return KEYCLICREL ;
    }
  }
#endif

  mkey = mousecode () ;
  if (mkey != 0)
  {
    switch (mkey)
    {
      case 1 :
	  leftbutton = 1 ;
	  return KEYCLIC ;
      case 2 :
	return KEYCLICR ;
    }
    leftbutton = 0 ;
    return KEYCLICREL ;
  }

  if (!bioskey (1))
  {
    return 0 ;			/* no key available */
  }

  key = bioskey (0);	/* get the pressed key */
  clrfifo () ;

  maj = key & 0xFF;
  if (maj >= 'a' && maj <= 'z')
    maj -= 'a' - 'A';

//  if (typetext == 0)
    {
      if (key == KEY_Left || key == KEY_4_NUM)
	return KEYLEFT ;
      if (key == KEY_Right || key == KEY_6_NUM)
	return KEYRIGHT ;
      if (key == KEY_Up || key == KEY_8_NUM)
	return KEYUP ;
      if (key == KEY_Down || key == KEY_2_NUM)
	return KEYDOWN ;
    }

  key &= 0xFFFF;

  if (key == KEY_Esc)
    return KEYQUIT;
  if (key == KEY_F1)
    return KEYF1;
  if (key == KEY_F2)
    return KEYF2;
  if (key == KEY_F3)
    return KEYF3;
  if (key == KEY_F4)
    return KEYF4;
  if (key == KEY_F5)
    return KEYF5;
  if (key == KEY_F6)
    return KEYF6;
  if (key == KEY_F7)
    return KEYF7;
  if (key == KEY_F8)
    return KEYF8;
  if (key == KEY_F9)
    return KEYF9;
  if (key == KEY_F10)
    return KEYF10;

  if (key == KEY_Alt_F2)
    return KEYSAVE ;
  if (key == KEY_Alt_F3)
    return KEYLOAD ;

  if (key == KEY_Shift_period)
    return KEYPAUSE ;

#if 0
  if (key == KEY_F11)
    return KEYF11;
  if (key == KEY_F12)
    return KEYF12;
  if (key == F13)
    return KEYSAVE;
  if (key == F14)
    return KEYLOAD;
  if (key == F15)
    return KEYPAUSE;
#endif

  if (key == KEY_Home)
    return KEYHOME;
//  if (key == DEFINE)
//    return KEYDEF;
//  if (key == UNDO)
//    return KEYUNDO;
  if (key == KEY_BkSp)
    return KEYDEL ;
  if (key == KEY_Del)
    return KEYDEL;
  if (key == KEY_Cr)
    return KEYRETURN;
//  if (key == KEY_Enter)
//    return KEYENTER;
//  if (key == POINT)
//    return KEYCENTER;

  if (typetext == 1)
  {
    accent = key & 0xff ;

    if (accent == 0x85)
      return KEYAGRAVE;
    if (accent == 0x83)
      return KEYACIRCON;
    if (accent == 0x84)
      return KEYATREMA;
    if (accent == 0xa0)
      return KEYAAIGU;

    if (accent == 0x87)
      return KEYCCEDILLE;

    if (accent == 0x82)
      return KEYEAIGU;
    if (accent == 0x89)
      return KEYETREMA;
    if (accent == 0x8a)
      return KEYEGRAVE;
    if (accent == 0x88)
      return KEYECIRCON;

    if (accent == 0x97)
      return KEYUGRAVE;
    if (accent == 0x81)
      return KEYUTREMA;
    if (accent == 0x96)
      return KEYUCIRCON;
    if (accent == 0xa3)
      return KEYUAIGU;


    if (accent == 0x94)
      return KEYOTREMA;
    if (accent == 0x93)
      return KEYOCIRCON;
    if (accent == 0xa2)
      return KEYOAIGU;
    if (accent == 0x95)
      return KEYOGRAVE;

    if (accent == 0x8B)
      return KEYITREMA;
    if (accent == 0x8C)
      return KEYICIRCON;
    if (accent == 0xA1)
      return KEYIAIGU;
    if (accent == 0x8D)
      return KEYIGRAVE;


  }

  return (short) (0xff & key);
}



/* ============ */
/* GetKeyStatus */
/* ============ */

/*
	Retourne l'‚tat du clavier, c'est-…-dire l'enfoncement
	‚ventuel des touches flŠches.
 */

KeyStatus GetKeyStatus (void)
{
  return keystatus ;
}


/* ========= */
/* DuplPixel */
/* ========= */

/*
	Duplique entirement un pixmap dans un autre.
 */

void 
DuplPixel (Pixmap * ppms, Pixmap * ppmd)
{
  Pt p;

  CopyPixel
    (
      ppms, (p.y = 0, p.x = 0, p),
      ppmd, (p.y = 0, p.x = 0, p),
      (p.y = ppmd->dy, p.x = ppmd->dx, p), MODELOAD
    );
}




/* =========== */
/* ScrollPixel */
/* =========== */

/*
	D‚cale un pixmap dans l'une des quatre directions.
		*ppm		*pixmap source et destination
		shift.x		d‚calage horizontal (<0 vers la droite, >0 vers la gauche)
		shift.y		d‚calage vertical (<0 vers le bas, >0 vers le haut)
		color		couleur assign‚e … la nouvelle zone (0..15)
		*pzone		retourne la zone … redessiner aprŠs ScrollPixel
 */

static void shiftx (Pixmap *ppm, short shift)
{
  long dxb = ppm->dxb ;
  char huge *baseptr = ppm->data ;
  register char *p ;
  short height = ppm->dy * ppm->nbp ;
  short length, i ;

  shift /= 8 ;

  if (shift > 0)
  {
    length = dxb - shift ;
    for (i = 0 ; i < height ; i++)
    {
      p = baseptr ;
      memmove (p, p + shift, length) ;
      baseptr += dxb ;
    }
  }
  else
  {
    shift = - shift ;
    length = dxb - shift ;
    for (i = 0 ; i < height ; i++)
    {
      p = baseptr ;
      memmove (p + shift, p, length) ;
      baseptr += dxb ;
    }
  }
}


static void shifty (Pixmap *ppm, short shift)
{
  long dxb = ppm->dxb ;
  char huge *baseptr = ppm->data ;
  register char *p ;
  short height = ppm->dy * ppm->nbp ;
  short length, i ;

  if (shift > 0)
  {
    length = (ppm->dy - shift) * dxb ;
    shift *= dxb ;
    for (i = 0 ; i < 4 ; i++)
    {
      p = baseptr ;
      memmove (p, p + shift, length) ;
      baseptr += dxb * ppm->dy;
    }
  }
  else
  {
    shift = -shift ;
    length = (ppm->dy - shift) * dxb ;
    shift *= dxb ;
    for (i = 0 ; i < 4 ; i++)
    {
      p = baseptr ;
      memmove (p + shift, p, length) ;
      baseptr += dxb * ppm->dy;
    }
  }
}


void ScrollPixel (Pixmap *ppm, Pt shift, char color, Rectangle *pzone)
{
  Pt p ;
  (*pzone).p1.x = 0;
  (*pzone).p1.y = 0;
  (*pzone).p2.x = ppm->dx;
  (*pzone).p2.y = ppm->dy;

  if (shift.x == 0 && shift.y == 0)
    goto fill;
  if (shift.x != 0 && shift.y != 0)
    goto fill;

  if (shift.x < 0 && shift.x > -ppm->dx)
  {
	  shiftx (ppm, shift.x) ;
	  (*pzone).p2.x = -shift.x;
	}
  if (shift.x > 0 && shift.x < ppm->dx)
    {
	  shiftx (ppm, shift.x) ;
      (*pzone).p1.x = ppm->dx - shift.x;
    }
  if (shift.y < 0 && shift.y > -ppm->dy)
    {
	  shifty (ppm, shift.y) ;
      (*pzone).p2.y = -shift.y;
    }
  if (shift.y > 0 && shift.y < ppm->dy)
    {
	  shifty (ppm, shift.y) ;
      (*pzone).p1.y = ppm->dy - shift.y;
    }
fill:
  DrawFillRect (ppm, *pzone, MODELOAD, color);	/* init la zone  mettre  jour */

}




/* =============== */
/* ScrollPixelRect */
/* =============== */

/*
	D‚cale un pixmap dans l'une des quatre directions.
		*ppm		*pixmap source et destination
		pos			position du rectangle
		dim			dimensions du rectangle
		shift.x		d‚calage horizontal (<0 vers la droite, >0 vers la gauche)
		shift.y		d‚calage vertical (<0 vers le bas, >0 vers le haut)
		color		couleur assign‚e … la nouvelle zone (0..15)
		*pzone		retourne la zone … redessiner aprŠs ScrollPixel
 */


spmemmove (int dest, int src, int length)
{
  int i ;

//  memmove (destptr, srcptr, length) ;

#if 0
  asm push ds ;
  asm push es ;
  asm push si ;
  asm push di ;
  asm push cx ;
  asm mov ax,0xa000 ;
  asm mov es, ax ;
  asm mov ds, ax ;

  asm mov si,src ;
  asm mov di,dest ;
  asm mov cx,length ;

  if (src > dest)
	goto _plus ;

  asm std ;
  asm mov si,src ;
  asm mov di,dest ;
  asm add si,cx ;
  asm add di,cx ;
  asm sub si,2 ;
  asm sub di,2 ;

	goto _move ;


_plus:
  asm cld ;

_move:
  asm shr cx,1
  asm rep movsw ;

  asm cld ;

  asm pop cx ;
  asm pop di ;
  asm pop si ;
  asm pop es ;
  asm pop ds ;
#else

//  memmove (destptr, srcptr, length) ;

#endif
}

static void shiftxpart (Pixmap *ppm, Pt pos, Pt dim, short shift)
{
  long dxb = ppm->dxb ;
  int p, baseofs ;
  short height = dim.y ;
  short length, i ;
  int pl ;


  HideMouseInt () ;
  shift /= 8 ;

  if (ppm == 0)
  {
	dxb = 80 ;
	baseofs = pos.x / 8 + dxb * pos.y ;
  }

  &p ;

#define STEPMOVE 4

  if (shift > 0)
  {
	length = dim.x / 8 - shift ;
	for (i = 0 ; i < height / STEPMOVE; i++)
	{
	  for (pl = 0 ; pl < 4 ; pl++)
	  {
		p = baseofs ;
		select_plane (pl) ;
		spmemmove (p, p + shift, length) ;
		p += dxb ;
		spmemmove (p, p + shift, length) ;
		p += dxb ;
		spmemmove (p, p + shift, length) ;
		p += dxb ;
		spmemmove (p, p + shift, length) ;

	  }
	  baseofs += 4*dxb ;
	}
  }
  else
  {
    shift = - shift ;
	length = dim.x /8 - shift ;
	for (i = 0 ; i < height / 4; i++)
	{
	  for (pl = 0 ; pl < 4 ; pl++)
	  {
		p = baseofs ;
		select_plane (pl) ;
		spmemmove (p + shift, p, length) ;
		p += dxb ;
		spmemmove (p + shift, p, length) ;
		p += dxb ;
		spmemmove (p + shift, p, length) ;
		p += dxb ;
		spmemmove (p + shift, p, length) ;

	  }
	  baseofs += 4 * dxb ;
	}
  }
  ShowMouseInt () ;
}



static void shiftypart (Pixmap *ppm, Pt pos, Pt dim, short shift)
{
  long dxb = ppm->dxb ;
  char *baseptr = ppm->data ;
  register char *p ;
  short height = dim.y ;
  short length, i ;
  short y ;

  if (ppm == 0)
  {
	dxb = 80 ;
	baseptr = (char*)MK_FP (0xa000,0) + pos.x / 8 + dxb * pos.y ;
  }

  length = (dim.y - shift) * dxb ;

  if (shift > 0)
  {
	shift *= dxb ;
	for (i = 0 ; i < 4 ; i++)
	{
	  p = baseptr ;
	  memmove (p, p + shift, length) ;
	  baseptr += dxb * ppm->dy;
    }
  }
  else
  {
	shift = -shift ;
    shift *= dxb ;
    for (i = 0 ; i < 4 ; i++)
    {
      p = baseptr ;
      memmove (p + shift, p, length) ;
      baseptr += dxb * ppm->dy;
    }
  }
}


void ScrollPixelRect (Pixmap *ppm, Pt pos, Pt dim, Pt shift, char color, Rectangle *pzone)
{
	Pt		p;
	
	(*pzone).p1.x = pos.x;
	(*pzone).p1.y = pos.y;
	(*pzone).p2.x = pos.x+dim.x;
	(*pzone).p2.y = pos.y+dim.y;

	if ( shift.x == 0 && shift.y == 0 )  goto fill;
	if ( shift.x != 0 && shift.y != 0 )  goto fill;
	
	if ( shift.x < 0 && shift.x > -dim.x )
	{
		shiftxpart (ppm, pos, dim, shift.x) ;
		(*pzone).p2.x = pos.x - shift.x;
	}
	if ( shift.x > 0 && shift.x < dim.x )
	{
		shiftxpart (ppm, pos, dim, shift.x) ;
		(*pzone).p1.x = pos.x + dim.x - shift.x;
	}
	if ( shift.y < 0 && shift.y > -dim.y )
	{
		shiftypart (ppm, pos, dim, shift.x) ;
		(*pzone).p2.y = pos.y - shift.y;
	}
	if ( shift.y > 0 && shift.y < dim.y )
	{
		shiftypart (ppm, pos, dim, shift.x) ;
		(*pzone).p1.y = pos.y + dim.y - shift.y;
	}
	
	fill:
	if ( color == -1 )  return;
	DrawFillRect(ppm, *pzone, MODELOAD, color);		/* init la zone a mettre a jour */
}





/* ======= */
/* chgmode */
/* ======= */

int chgmode(int mode,int clr,int set)
{
  if (set & 1)
    if (clr & 1)
      if (! mode)
        return 0xC;
      else
        return 1;
    else
      return mode;
  else
    if (clr & 1)
      if (! mode)
        return 4;
      else
        return mode^7;
    else
      if (! mode)
        return 8;
      else
        return 6;
}


/* ========= */
/* CopyPixel */
/* ========= */

/*
	Copie un rectangle de pixel dans un autre (raster-op).
	Cette proc‚dure est la seule qui dessine dans l'‚cran !
		*ppms	*pixmap source (si == 0 -> ‚cran)
		os		origine source (coin sup/gauche)
		*ppmd	*pixmap destination (si == 0 -> ‚cran)
		od		origine destination (coin sup/gauche)
		dim		dimensions du rectangle
		mode	mode de transfert (MODELOAD/MODEOR/MODEAND)
	Retourne 1 si rien n'a ‚t‚ dessin‚.
 */

short CopyPixel(Pixmap *ppms, Pt os, Pixmap *ppmd, Pt od, Pt dim, ShowMode mode)
{
  struct bitmap src,dest;
  int plane;
  long plusptr = (long) (ppms->dy*ppms->dxb) ;
  long plusptrdst = (long) (ppms->dy*ppmd->dxb) ;

   if (ppmd != 0)
     {
       if (od.x < 0)		/* dpasse  gauche ? */
	 {
	   dim.x += od.x;
	   if (dim.x <= 0)
	     return 1;
	   os.x -= od.x;
	   od.x = 0;
	 }
       if (od.x + dim.x > ppmd->dx)	/* dpasse  droite ? */
	 {
	   dim.x -= od.x + dim.x - ppmd->dx;
	   if (dim.x <= 0)
	     return 1;
	 }

       if (od.y < 0)		/* dpasse en haut ? */
	 {
	   dim.y += od.y;
	   if (dim.y <= 0)
	     return 1;
	   os.y -= od.y;
	   od.y = 0;
	 }
       if (od.y + dim.y > ppmd->dy)	/* dpasse en bas ? */
	 {
	   dim.y -= od.y + dim.y - ppmd->dy;
	   if (dim.y <= 0)
	     return 1;
	 }
     }

  src.left=os.x;
  src.top=os.y;
  src.right=os.x+dim.x;
  src.bot=os.y+dim.y;
  src.bytes=ppms->dxb;
  dest.left=od.x;
  dest.top=od.y;
  dest.right=od.x+dim.x;
  dest.bot=od.y+dim.y;
  dest.bytes=ppmd->dxb;


  {
    src.pntr= ppms->data;
    dest.pntr= ppmd->data;

    if ( ppms == 0 )      /* source dans l'ecran ? */
    {
      ifhidemousex(&src);  /* cache la souris */
      src.bytes=640/8;
      src.pntr= MK_FP (0xa000,0);
      HideMouseInt () ;
      for (plane=0;plane<4;plane++)
      {
		select_plane(plane);
		blit (&src,&dest,mode);
		dest.pntr+= (long) (ppmd->dy*dest.bytes);
	  }
	  ShowMouseInt();
	  return 0;
	}

    if ( ppmd == 0 )      /* destination dans l'ecran ? */
    {
      ifhidemousex(&dest); /* cache la souris */
      dest.bytes=640/8;
      dest.pntr= MK_FP (0xa000,0);
      if (ppms->nbp == 4)
      {
	HideMouseInt () ;
	if (dim.x > 180 && dim.y > 70)
	{
#define STEPY 2
	  int y ;
	  char huge *oldptr = src.pntr ;
	  src.bot = src.top + STEPY ;
	  dest.bot = dest.top + STEPY ;

	  for (y = 0 ; y < dim.y ; y += STEPY)
	  {
		if (dim.y == y + 1)
		{
		  src.bot-- ;
		  dest.bot-- ;
		}

	    for (plane=0;plane<4;plane++)
	    {
		  select_plane(plane);
		  blit (&src,&dest,mode);
		  src.pntr+= plusptr ; // (long) (ppms->dy*src.bytes);
		}
		src.pntr = oldptr ;
		src.top += STEPY ;
		src.bot += STEPY ;
		dest.top += STEPY ;
		dest.bot += STEPY ;
	  }

	  if (dim.y == 340 && dim.x == 640)
	  {
		ClrEvents () ;
	  }
	}
	else
	for (plane=0;plane<4;plane++)
        {
          select_plane(plane);
          blit (&src,&dest,mode);
		  src.pntr+= plusptr ; // ;(long) (ppms->dy*src.bytes);
		}
	ShowMouseInt();
	return 0;
      }
      else
      {
	HideMouseInt () ;
	for (plane=0;plane<4;plane++)
	{
	  select_plane(plane);
	  blit (&src,&dest,\
		chgmode(mode,ppms->ccolor>>plane,ppms->scolor>>plane));
	}
	ShowMouseInt () ;
	return 0;
      }
    }

    if (ppms->nbp == 4)
    {
      for (plane=0;plane<4;plane++)
      {
        blit (&src,&dest,mode);
		src.pntr+= plusptr ; //(long) (ppms->dy*src.bytes);
		dest.pntr+= (long) (ppmd->dy*dest.bytes);
	  }
//      ShowMouseInt();
      return 0;
    }
    else
    {
      if (ppmd->nbp == 4)
      {
	for (plane=0;plane<4;plane++)
	{
          int chm = chgmode(mode,ppms->ccolor>>plane,ppms->scolor>>plane) ; 
	  blit (&src, &dest, chm);
	  dest.pntr+= (long) (ppmd->dy*dest.bytes);
	}
//	ShowMouseInt();
	return 0;
      }
      else
      {
	blit (&src,&dest, mode) ;
      }
    }
  }
  return 0 ;
}


/* ----------- */
/* OpenGraDesc */
/* ----------- */

/*
	Pr‚pare le descripteur de fenˆtre pgradesc pour pouvoir dessiner
	dans un pixmap en m‚moire.
 */

void OpenGraDesc (Pixmap *ppm)
{

}


/* ------------ */
/* CloseGraDesc */
/* ------------ */

/*
	Restitue le descripteur de fenˆtre pgradesc pour pouvoir dessiner
	comme avant.
 */

void CloseGraDesc (Pixmap *ppm)
{
}


/* ======== */
/* DrawLine */
/* ======== */

/*
	Dessine un segment de droite d'un pixel d'‚paisseur.
		*ppm		->	pixmap o— dessiner (0 = ‚cran)
		p1			->	d‚part
		p2			->	arriv‚e
		mode		->	mode de dessin
		color		->	0 = blanc .. 15 = noir
 */

void DrawLine (Pixmap *ppm, Pt p1, Pt p2, ShowMode mode, char color)
{
  p2.x = p2.x - p1.x ;
  p2.y = p2.y - p1.y ;
  _drawline (ppm, p1, p2, mode, color) ;
}


/* ======== */
/* DrawRect */
/* ======== */

/*
	Dessine un rectangle d'un pixel d'‚paisseur.
		*ppm		->	pixmap o— dessiner (0 = ‚cran)
		rect.p1		->	coin sup/gauche
		rect.p2		->	coin inf/droite
		mode		->	mode de dessin
		color		->	0 = blanc .. 15 = noir
 */

void DrawRect (Pixmap *ppm, Rectangle rect, ShowMode mode, char color)
{
  Pt p1 ;
  Pt dim ;
  char col = 15 - color ;

  p1 = rect.p1 ;
  dim.x = rect.p2.x - rect.p1.x + 1;
  dim.y = 0 ;
  _drawline (ppm, p1, dim, mode, col) ;

  p1.y =rect.p2.y ;
  _drawline (ppm, p1, dim, mode, col) ;

  p1.y = rect.p1.y + 1 ;
  dim.x = 0 ;
  dim.y = rect.p2.y - rect.p1.y - 1;
  _drawline (ppm, p1, dim, mode, col) ;

  p1.x = rect.p2.x ;
  _drawline (ppm, p1, dim, mode, col) ;

}


/* ============ */
/* DrawFillRect */
/* ============ */

/*
	Dessine une surface rectangulaire remplie avec une couleur donn‚e
	dans un pixmap.
		*ppm		->	pixmap o— dessiner (0 = ‚cran)
		rect.p1		->	coin sup/gauche
		rect.p2		->	coin inf/droite
		mode		->	mode de dessin
		color		->	0 = blanc .. 15 = noir
 */

void DrawFillRect (Pixmap *ppm, Rectangle rect, ShowMode mode, char color)
{
  void _clrrect (Pixmap *pmap, Pt p1, Pt dim, int color) ;

  Pt p1,p2 ;

  if (mode != MODELOAD)
    return ;

  p1 = rect.p1 ;
  p2.x = rect.p2.x-rect.p1.x ;
  p2.y = rect.p2.y-rect.p1.y ;

  _clrrect (ppm, p1, p2, 15 - color) ;

}





/* ======== */
/* GetPixel */
/* ======== */

/*
	Retourne la couleur d'un pixel contenu dans un pixmap.
		0  = blanc
		15 = noir
		-1 = en dehors du pixmap
 */

char 
GetPixel (Pixmap * ppm, Pt pos)
{
  char *pt;

  if (pos.x < 0 || pos.x >= ppm->dx ||
      pos.y < 0 || pos.y >= ppm->dy)
    return -1;

  pt = ppm->data;
  if (ppm->nbp == 1)
    {
      pt += ppm->dxb * pos.y;
      pt += pos.x / 8;
      if (~(*pt) & (1 << (7 - pos.x % 8)))
	return 15;
      return 0;
    }
  else
    {
      return -1;		/* faire ! */
    }
}


/* ========= */
/* TestHLine */
/* ========= */

/*
	Teste si une ligne horizontale est entierement vide.
	Ne fonctionne que dans un pixmap d'icone noir/blanc !
	Si oui, retourne 1 (true).
 */

short 
TestHLine (Pixmap * ppm, short y)
{
  char *pt;
  short i;

  pt = ppm->data + ppm->dxb * y;
  for (i = 0; i < LXICO / 8; i++)
    {
      if (*pt++ != (char)0xff) //@@ voir pour nb invers‚
	return 0;
    }
  return 1;
}


/* ========= */
/* TestVLine */
/* ========= */

/*
	Teste si une ligne verticale est entirement vide.
	Ne fonctionne que dans un pixmap d'icne noir/blanc !
	Si oui, retourne 1 (true).
 */

short 
TestVLine (Pixmap * ppm, short x)
{
  char *pt;
  short i;
  short mask;

  pt = ppm->data + x / 8;
  mask = 1 << (7 - x % 8);
  for (i = 0; i < LYICO; i++)
    {
      if (~(*pt) & mask)  // @@ voir pour nb inver‚
	return 0;
      pt += ppm->dxb;
    }
  return 1;
}



/* -------- */
/* LoadCLUT */
/* -------- */

/*
	Modifie la clut en fonction de la table d'une image.
 */

static void LoadCLUT (void *ptable)
{
  tcol_loadclut (ptable) ;
}


/* -------- */
/* ClearMem */
/* -------- */

/*
	Met une zone m‚moire … z‚ro (blanc) ou … un (noir).
 */

static void ClearMem (char *pt, long lg, int fill)
{
  if ( fill != 0 )
    fill = -1;
  farmemset(pt, fill, lg);
}


/* --------- */
/* LoadImage */
/* --------- */

/*
	Charge un fichier image cod‚, si n‚cessaire.
 */

static int LoadImage(int numero)
{
  FILE    *channel;       /* descripteur du fichier */
  char    name[13];       /* nom de l'image BLUPInn.IMA */


  if (numero == lastimage)
  {

//    if (pim->clut != 0)
//      tcol_loadclut(pim->clut); /* change la clut */

    return 0;           /* retour ok si image deja chargee */
  }

  sprintf(name, "BLUPIX%02d.COL", numero);

  if ((channel=fopen(name,"rb")) == NULL)
  {
    text_mode();
	PCFatalError ("Cannot open file ");
  }

  (void) fread( pim->head, 1, sizeof(Image), channel );   /* lit l'en-tete */

  fread( pim->clut, 1, pim->head->imlgc, channel );	/* lit la clut */

  (void) fread( pim->data, sizeof(char), (u_short) pim->head->imnbb, channel );


  if ( pim->head->imbip > 1 )
      tcol_loadclut(pim->clut);         /* change la clut */

  fclose(channel);                      /* ferme le fichier */
  lastimage = -1 ; // @@ on charge chaque fois l'image // numero;

  return 0;


}




/* ========= */
/* GetPixmap */
/* ========= */

/*
    Ouvre un pixmap quelconque, tout blanc ou tout noir.
	fill:	0 -> pixmap tout blanc
		1 -> pixmap tout noir
	color:	0 -> monochrome (1 bit/pixel)
		1 -> couleur (si possible)
		2 -> couleur (toujours)
 */

short GetPixmap(Pixmap *ppm, Pt dim, short fill, short color)
{
  int nbp = 1;

  if (fill == 0)
    fill = 255 ;
  else
    fill = 0 ;

  if ( color >= 1 )
    nbp = 4 ;

  if ( ppm->data != 0 )			/* pixmap existe d‚j… ? */
  {
    if ( ppm->dx == dim.x && ppm->dy == dim.y )
    {
      ClearMem(ppm->data, ((u_long)ppm->dxb * ppm->dy * nbp), fill);
      return 0;				/* pixmap existe d‚j… avec la bonne taille */
    }
    else
    {
      free(ppm->data);			/* libŠre le pixmap pr‚c‚dent */
      ppm->data = 0;
    }
  }

  ppm->dx     = dim.x;
  ppm->dy     = dim.y;
  ppm->nbp    = nbp;			/* nb de bits/pixel selon noir-blanc/couleur */
  ppm->dxb    = ((dim.x+15)/16) * 2 ;
  ppm->ccolor = COLORBLANC;
  ppm->scolor = COLORNOIR;

  ppm->data = farmalloc ((long) (ppm->dxb)*(ppm->nbp)*(ppm->dy));
  if (ppm->data == NULL)
  {
	PCFatalError ("GetPixmap: out of memory") ;
    ppm->data =0;
    return 1;
  }
  else
  {
    ClearMem( ppm->data, ((u_long)ppm->dxb* ppm->dy * ppm->nbp), fill);
  }
  return 0;
}



/* ========== */
/* GivePixmap */
/* ========== */

/*
	LibŠre un pixmap quelconque, obtenu avec GetPixmap ou GetImage,
	mais pas avec GetIcon (give pas n‚cessaire).
 */

short GivePixmap(Pixmap *ppm)
{
  if ( ppm->data != 0 )
  {
    farfree(ppm->data);			/* libŠre le pixmap */
    ppm->data = 0;
  }
  return 0;
}



/* ======== */
/* getimage */
/* ======== */

/*
  Ouvre une image en la lisant si necessaire, puis en la decodant
  dans un pixel-map.
 */

short GetImage(Pixmap *ppm, short numero)
{

  int     err;
  u_char  imcod;      /* type de codage */
  u_long  imnbb;      /* taille du bitmap */
  u_char  imbip;      /* nb de bits/pixel */
  u_short imdlx;      /* largeur en pixels */

#ifndef FIXIMBUF
  pim->head = farmalloc ((long) sizeof (Image));
  pim->clut = farmalloc (0x30L);    /* clut size */
  pim->data = farmalloc (MAXCOLLENGTH);   /* maxim dimension for a loaded image */
  if (pim->data == NULL)
  {
	PCFatalError ("GetImage") ;
  }
#endif

  err = LoadImage(numero);    /* charge l'image si necessaire */
  if (err != 0)
  {
    GivePixmap(ppm);    /* libere le pixel map */
    return err;     /* erreur si chargement impossible */
  }

  if ( ppm->data == 0              ||
       ppm->dx != pim->head->imdlx ||
       ppm->dy != pim->head->imdly )
  {
    GivePixmap(ppm);    /* libere l'ancien pixel map si necessaire */
    ppm->dx     = pim->head->imdlx;
    ppm->dy     = pim->head->imdly;
    ppm->nbp    = pim->head->imbip; /* nb de bits/pixel */
    ppm->dxb    = ((pim->head->imdlx+15)/16)*2;
    ppm->ccolor = COLORBLANC;
    ppm->scolor = COLORNOIR;

    ppm->data = farmalloc ((long) (ppm->dxb)*(ppm->nbp)*(ppm->dy));
    if (ppm->data == NULL)
    {
      ppm->data = 0;
	  PCFatalError ("GetImage: out of memory") ;
      return 1;     /* retour, pas assez de memoire */
    }
  }

  /* decode une image - b&w or color */
  if (pim->head->imcod == 0x17) /* decode only this type of coding */
    decode_image( pim->data, ppm->data, (int) pim->head->imbip );


fin:
#ifndef FIXIMBUF
  farfree (pim->head) ;
  farfree (pim->clut) ;
  farfree (pim->data) ;
#endif

  return 0;       /* retour ok */
}



/* ========= */
/* CacheIcon */
/* ========= */

/*
	Cache en m‚moire une ic“ne en vue d'une utilisation prochaine.
	Ceci est utile pour le PC qui n'a pas assez de m‚moire pour
	conserver toutes les ic“nes !
 */

void CacheIcon(short numero)
{
	return;
}




/* copie un quart d'icone monochrome dans le coin
   sup‚rieur gauche */

static void copyquarter (Pixmap *ppm, short quarter)
{
  register char *s ;
  register char *d ;
  register int x,y ;
  int i ;

  if (quarter == 0)
    return ;

  d = ppm->data ;
  ppm->dx /= 2L;
  ppm->dy /= 2L;

  d = ppm->data ;

  for (i = 0 ; i < ppm->nbp; i++)
  {

    switch (quarter)
    {
      case UL :
	s = ppm->data ;
	break ;
      case UR :
	s = ppm->data + 5 ;
	break ;
      case DL :
	s = ppm->data + 400 ;
	break ;
      case DR :
	s = ppm->data + 405 ;
	break ;
    }

    s += i * 800 ;

    for (y = 0 ; y < 40 ; y++)
    {
      for (x = 0 ; x < 5 ; x++)
	*d++ = *s++ ;

      s+= 5 ;
      d+= 5 ;
    }

  }
}


/* ======= */
/* GetIcon */
/* ======= */

/*
	Conversion d'une ic“ne en pixmap noir/blanc.
	Le pointeur au data (ppm->data) est directement initialis‚ dans
	l'une des grandes images contenant toutes les ic“nes (IMAICON
	ou IMAICON+IMAMASK).
	Puisque la m‚moire pour le data n'est pas allou‚e par cette
	proc‚dure, il ne faut donc pas faire de GivePixmap !
	Si le mode vaut z‚ro, le data n'est pas rendu, mais seulement
	les dimensions, pour gagner du temps.
 */


#define OFFSET_MASKS 1638400L
#define ICONMASKSIZE 800L
#define ICONSIZE 3200L

short GetIcon(Pixmap *ppm, short numero, short mode)
{
  long offset ;
  int no = numero & ICONMASK ;
  static int numbuf ;
  char *pbuf ;

  pbuf = buffer + 3200 * numbuf ;

  if (++numbuf == NBBUFFERS)
    numbuf = 0 ;

  if ((numero & ICONMASK) < ICOMOFF )
    ppm->nbp = 4;		/* 4 bit/pixel car couleur */
  else
    ppm->nbp = 1;				      /* 1 bit/pixel car noir-blanc */

  ppm->dxb    = 10 ;
  ppm->scolor = COLORNOIR;			/* initialise la couleur chair */
  ppm->ccolor = COLORBLANC;			/* initialise la couleur fond */

  if (no < ICOMOFF)
  {
    offset = xmsicons[0].offset + (long)no * ICONSIZE ;
    XMSCopy (xmshandle, offset, 0, (long)(void *)pbuf, ICONSIZE) ;
    ppm->nbp = 4;		/* 4 bit/pixel car couleur */
  }
  else
  {
    long oo,i;
    offset = xmsicons[0].offset + OFFSET_MASKS ;
    oo = (long)(no - 512) * ICONMASKSIZE;

    offset += oo ;
    XMSCopy (xmshandle, offset, 0, (long)(void *)pbuf, ICONMASKSIZE) ;
    ppm->nbp = 1;		/* 4 bit/pixel car couleur */
  }

  ppm->dx     = LXICO;
  ppm->dy     = LYICO;
  ppm->dxb    = 10 ;
  ppm->scolor = COLORNOIR;			/* initialise la couleur chair */
  ppm->ccolor = COLORBLANC;			/* initialise la couleur fond */
  ppm->data  = pbuf ;

    copyquarter (ppm,numero&(~ICONMASK)) ;

  return 0;				/* retour toujours ok */
}



short _GetIcon(Pixmap *ppm, short numero, short mode)
{
  long offset ;
  int i ;

  offset = xmsicons[0].offset + (long)numero * 80 * 80 / 2 ;

  XMSCopy (xmshandle, offset, 0, (long)(void *)buffer, 3200) ;

  ppm->dx     = LXICO;
  ppm->dy     = LYICO;
  ppm->nbp = 4;		/* 4 bit/pixel car couleur */
  ppm->dxb    = 10 ;
  ppm->scolor = COLORNOIR;			/* initialise la couleur chair */
  ppm->ccolor = COLORBLANC;			/* initialise la couleur fond */
  ppm->data  = buffer ;
  return 0 ;
}





typedef struct
{
  u_char	imtyp;			/* type d'image */
  u_char	imcod;			/* type de codage */
  u_char	imbip;			/* bits/pixel */
  u_char	imdir;			/* direction de digitalisation */
  u_short	imdlx;			/* largeur en pixels */
  u_short	imdly;			/* hauteur en pixels */
  u_long	imnbb;			/* taille du bitmap */
  u_short	imsiz;			/* nb de bit d'un pixel dans chaque octet (#4) */
  u_short	imcnt;			/* nb d'octets pour former un pixel pixel (#1) */
  u_long	imlgc;			/* taille de la CLUT (Color LookUp Table) */
  u_char	imfill[12] ;		/* rserve */
}
Color;




#define _64K 32000L


int xmsload (const char *name, struct xmsicon *xmsicon)
{
  int in = -1 ;
  long length, offset = 0 ;
  char *data = NULL;
  struct icfiledir filedir ;
  int i ;


  data = farmalloc (_64K) ;

  if (data == NULL)
  {
	printf ("Error with farmalloc in xmaload().\n") ;
	return 1 ;
  }
  printf ("Initializing Blupimania.\n") ;

  in = open ("blupiman.bma", O_RDONLY + O_BINARY) ;
  if (in == -1)
  {
    printf ("File BLUPIMAN.BMA not found.\n") ;
    return 1 ;
  }
  read (in, &filedir, sizeof (struct icfiledir)) ;

  for (i = 0 ; i < filedir.nbfiles; i++)
  {
    xmsicons[i].offset = filedir.offset[i] ;
  }

  length = filelength (in) ;

  xmshandle = XMSGetMem ((length + 1024) / 1024) ;

  if (XMSErr == 0)
  {
    int count = 0 ;
    printf ("%ld bytes of XMS memory allocated.\n", length) ;
    printf ("Loading icons - [") ;
    do
    {
      int bytesread ;

      bytesread = read (in, data, _64K) ;
      if (count++ & 1)
	printf (".") ;

      if (bytesread == 0)
	break ;

      XMSCopy (0, (long)(void *)data, xmshandle, offset, bytesread) ;
//      XMSCopy (xmshandle, offset, 0, (long)(void *)buffer, 3200) ;

      offset += _64K;

    } while (1) ;
  }
  else
  {
    if (XMSErr == 0xa0)
	  printf ("Not enough XMS memory.\n") ;
	else
	  printf ("XMS error no %x.\n", XMSErr) ;

    return 1 ;
  }

fin:
  if (in != -1)
    close (in) ;

  printf ("]\n") ;

  if (data != NULL)
    farfree (data) ;

  return 0 ;
}



/* -------- */
/* LoadIcon */
/* -------- */

/*
	Chargement de l'image des ic“nes.
 */


#define LGICONFILE

static int LoadIcon(void)
{
  int r;


  if (!XMSInit ())
  {
	printf ("No XMS manager found.\n") ;
	return 1 ;
  } ;

  printf ("XMS memory manager found.\n") ;

  r = xmsload ("b1.ic", &icons) ;
  if (r != 0)
  {
	return 1 ;
  }
  buffer = farmalloc (3200*NBBUFFERS) ;
  return 0;
}


static void UnloadIcon (void)
{
  XMSFreeMem (xmshandle) ;
}




/* ------ */
/* AfMenu */
/* ------ */

/*
	Affiche les soft-keys.
 */

static void AfMenu (void)
{

}



/* =========== */
/* BlackScreen */
/* =========== */

/*
	Efface tout l'‚cran (noir), pendant le changement de la clut.
 */

void BlackScreen (void)
{
			/* remet la souris */
  HideMouseInt () ;
  zap_screen () ;
  ShowMouseInt () ;
}


#if 0
/* ======== */
/* FileRead */
/* ======== */

/*
		Lit nb bytes dans un fichier de donn‚es … la position pos.
	Retourne 0 si la lecture est ok.
 */

short FileRead (void *pdata, long pos, short nb, char file)
{
	FILE		*channel;
	char		filename[] = "BLUPIXA.DAT";
	short		err;

	filename[6] = file;
	channel = fopen(filename, "rb");	/* ouvre le fichier */
	if ( channel == NULL )  return errno;
	
	if ( fseek(channel, pos, SEEK_SET) != 0 )
	{
		err = errno;
		goto close;
	}
	
	if ( fread(pdata, nb, 1, channel) != 1 )
	{
		err = errno;
		goto close;
	}
	
	close:
	fclose(channel);					/* ferme le fichier */
	return 0;
}


/* ========= */
/* FileWrite */
/* ========= */

/*
	Ecrit nb bytes dans un fichier de donn‚es … la position pos.
	Retourne 0 si l'‚criture est ok.
 */

short FileWrite (void *pdata, long pos, short nb, char file)
{
	FILE		*channel;
	char		filename[] = "BLUPIXA.DAT";
	short		err;

	filename[6] = file;
	channel = fopen(filename, "ab+");	/* ouvre le fichier */
	if ( channel == NULL )  return errno;
	
	if ( fseek(channel, pos, SEEK_SET) != 0 )
	{
		err = errno;
		goto close;
	}

	{
	  long test = ftell (channel) ;
	}
	
	if ( fwrite(pdata, nb, 1, channel) != 1 )
	{
		err = errno;
		goto close;
	}
	
	close:
	fclose(channel);					/* ferme le fichier */
	return 0;
}


#else
/* ======== */
/* FileRead */
/* ======== */

/*
		Lit nb bytes dans un fichier de donn‚es … la position pos.
	Retourne 0 si la lecture est ok.
 */

short FileRead (void *pdata, long pos, short nb, char file)
{
  int r ;
  int channel;
  char filename[] = "BLUPIXA.DAT";
  short	err;

  filename[6] = file;
  restore_clock () ;
  channel = _open(filename, O_RDONLY | O_BINARY);	/* ouvre le fichier */
  if ( channel == -1)  return errno;

  if ( lseek(channel, pos, SEEK_SET) == -1)
  {
	err = errno;
	goto close;
  }

  if ( (r = _read(channel, pdata, nb)) == -1 )
  {
	err = errno;
	goto close;
  }

  close:
  restore_clock () ;
  _close(channel);					/* ferme le fichier */
  return 0;
}


/* ========= */
/* FileWrite */
/* ========= */

/*
	Ecrit nb bytes dans un fichier de donn‚es … la position pos.
	Retourne 0 si l'‚criture est ok.
 */

short FileWrite (void *pdata, long pos, short nb, char file)
{
  int r ;
	int		channel;
	char		filename[] = "BLUPIXA.DAT";
	short		err;

	filename[6] = file;
	restore_clock () ;
	channel = _open(filename, O_WRONLY | O_BINARY);	/* ouvre le fichier */
	if ( channel == -1 )
	{
	  channel =_creat (filename, 0) ;
	  if (channel == -1)
	    return errno;
	}

	if ( lseek(channel, pos, SEEK_SET) == -1 )
	{
		err = errno;
		goto close;
	}

	{
	  long test = tell (channel) ;
	}
	
	if ( (r = _write(channel, pdata, nb)) == -1 )
	{
		err = errno;
		goto close;
	}
	
	close:
	restore_clock () ;
	_close(channel);      /* ferme le fichier */
	return 0;
}

#endif
/* ============= */
/* FileGetLength */
/* ============= */

/*
	Retourne la longueur d'un fichier.
	En cas d'erreur, retourne 0 (longueur nulle).
 */

long FileGetLength (char file)
{
	FILE		*channel;
	char		filename[] = "BLUPIXA.DAT";
	long		lg;

	filename[6] = file;
	channel = fopen(filename, "r");		/* ouvre le fichier */
	if ( channel == NULL )  return 0;
	
	fseek(channel, 0, SEEK_END);
	lg = ftell(channel);
	
	fclose(channel);					/* ferme le fichier */
	return lg;
}


/* ========== */
/* FileDelete */
/* ========== */

/*
	D‚truit un fichier.
	Retourne 0 si la destruction est ok.
 */

short FileDelete (char file)
{
	char		filename[] = "BLUPIXA.DAT";

	filename[6] = file;
	return remove(filename);
}


/* ========== */
/* FileRename */
/* ========== */

/*
	Renomme un fichier.
	Retourne 0 si le changement est ok.
 */

short FileRename (char oldfile, char newfile)
{
  static char		oldfilename[] = "BLUPIXA.DAT";
  static char		newfilename[] = "BLUPIXA.DAT";

  oldfilename[6] = oldfile;
  newfilename[6] = newfile;
  return rename (oldfilename, newfilename) ;
}



/* ============ */
/* PCFatalError */
/* ============ */

/*
	Affiche une erreur fatale, puis quitte le jeu.
 */

static const char *fatalerrptr = NULL ;

static void PCFatalError (const char *text)
{
  fatalerrptr = text ;
  CloseMachine () ;
  exit (0) ;
}


/* ========== */
/* FatalError */
/* ========== */

/*
	Affiche une erreur fatale, puis quitte le jeu.
 */


void FatalError (short err)
{
  char text[30] ;
  sprintf (text, "Fatal error: %d\n") ;
  fatalerrptr = text ;
  CloseMachine () ;
  exit (0) ;
}


/* ----------- */
/* IfFileExist */
/* ----------- */

/*
	Teste si un fichier existe.
	Si oui, retourne 1 (true).
 */

short IfFileExist (char *pfilename)
{
	FILE		*channel;

	channel = fopen(pfilename, "r");		/* ouvre le fichier */
	if ( channel == NULL )  return 0;		/* fichier n'existe pas */
	
	fclose(channel);						/* ferme le fichier */
	return 1;								/* fichier existe */
}


/* -------- */
/* CheckMem */
/* -------- */

/*
	V‚rifie s'il reste assez de m‚moire en fonction des options
	choisies. Si oui, retourne 1 (true).
 */

short CheckMem (u_long flags)
{
  return 1 ; // @@
}



#define KEYDBOX		0x7E00

/* ======= */
/* DboxMem */
/* ======= */

/*
	Demande quelles ressources utiliser.
	Retourne une erreur != 0 en cas d'erreur (quitter).
 */

short DboxMem (void)
{
  return 1 ; // @@
}


/* --------- */
/* FatalLoad */
/* --------- */

/*
	Gestion des erreurs fatales de chargement … l'initialisation.
 */

static void FatalLoad(char *name, int err)
{
  char*	errorname;

  errorname = strerror(err);
  if ( (int)errorname == 0 )
  {
    fprintf(stderr, "Erreur fatale num‚ro %d avec %s ", err, name);
  }
  else
  {
    fprintf(stderr, "Erreur fatale %s avec %s ", errorname, name);
  }
  getchar();

  CloseMachine();
  exit(0) ;
}








/* =========== */
/* OpenMachine */
/* =========== */

/*
	Ouverture g‚n‚rale, chargement des librairies, gencar, etc.
 */

void lineegal (void)
{
  printf ("=========================================================\n") ;
}
void OpenMachine(void)
{
  int     err;        /* erreur rendue */
  long    pid;        /* identificateur du processus cree */
  u_short pino;       /* numero du processus cree */
  long    datebcd;
  int     i;
  FILE *  initscreen;
  KeyStatus st ;
  char *filename ;
  short monitor_type=0, available_vmodes=0;
  u_long mtype ;

  clrscr () ;
  gotoxy (1,1) ;
  textcolor (YELLOW) ;
  textbackground (RED) ;

  cprintf ("                          B L U P I M A N I A   1 . 5                           \n") ;

  querry_video(&monitor_type,&available_vmodes);

#if 0
  mtype = farcoreleft () ;
  printf ("%ld\n", mtype) ;
  getch () ;
#endif

#if 1
  if (farcoreleft() < 307000L)
  {
    void errmem (long, long) ;
	errmem (174816 - 752, 480000) ;
  }
#endif


  if (vfy_mouse() == -1)
  {
    printf ("No mouse driver\n") ;
    exit(0) ;
  }
  printf ("Mouse driver found.\n") ;

#if 1
  if (GetDemo())
  {
	lineegal () ;
	printf ("                    D E M O\n") ;
	lineegal () ;
  }
#endif


  err = LoadIcon();					/* charge l'image des ic“nes */
  if ( err )
  {
	printf ("Fatal error during icon load.\n") ;
	getch() ;
    exit (0) ;
  }


  {
	int f ;
	restore_clock () ;
	f = _open (CONFIG_NAME, O_RDONLY | O_BINARY) ;
	if (f != -1)
	{
	  _read (f, &blpinfo, sizeof (struct blpinfo)) ;
      _close (f) ;
    }
  }

  printf ("Checking for soundboard.\n") ;

#ifdef USE_BLASTER
  have_sbcard = ! init_sound () ;
#endif

  origine.x = 0 ;
  origine.y = 0 ;

  StartRandom(0, 0);					/* coup de sac du g‚n‚rateur al‚atoire toto */
  StartRandom(1, 1);					/* coup de sac du g‚n‚rateur al‚atoire d‚cor */

  keystatus = 0;

  AfMenu();							/* affiche les soft-keys */



#ifdef USE_BLASTER
//  have_sbcard = ! init_sound () ;
#endif

  trap_interrupts();

  FMMusicInit () ;

  OpenTime () ;
  CloseTime (40) ;

  save_video_mode();
  err=graphic_mode();
  if (err != 0) {
	fprintf(stderr,"\nUnsupported graphic mode");
	CloseMachine () ;
	exit(1);          /* retour dans MAIN */
  }
  havemouse = initmouse(); /* initmouse after a video mode change */

  lxwdo = 640;        /* init largeur fenetre */
  lywdo = LYIMAGE;    /* init hauteur fenetre */

#ifdef FIXIMBUF
  pim->head = farmalloc ((long) sizeof (Image));
  pim->clut = farmalloc (0x30L);    /* clut size */
  pim->data = farmalloc (MAXCOLLENGTH);   /* maxim dimension for a loaded image */
#endif

  ShowMouseInt () ;

}



/* ============ */
/* CloseMachine */
/* ============ */

/*
	Fermeture g‚n‚rale.
 */

void CloseMachine(void)
{
  playsoundloop(0);     /* plus de repetition */

  FMMusicDeinit () ;
  end_sound () ;
  uninit_sound () ;

  release_interrupts();
  toneoff () ;
  restore_video_mode();
  restore_clock () ;

  if (fatalerrptr != NULL)
    {
      printf (fatalerrptr) ;
      getch () ;
    }

  UnloadIcon () ;

  if (GetDemo () == 1)
  {
	remove ("blupixe.dat") ;
  }
  publicite (GetDemo () == 1) ;
}




/* =============== */
/* MachinePartieLg */
/* =============== */

/*
	Retourne la longueur n‚cessaire pour sauver les variables de la partie en cours.
 */

long MachinePartieLg (void)
{
	return sizeof(u_long)*10;
}

/* ================== */
/* MachinePartieWrite */
/* ================== */

/*
	Sauve les variables de la partie en cours.
 */

short MachinePartieWrite (long pos, char file)
{
	short		err;
	
	err = FileWrite(&nextrand, pos, sizeof(u_long)*10, file);
	return err;
}

/* ================= */
/* MachinePartieRead */
/* ================= */

/*
	Lit les variables de la partie en cours.
 */

short MachinePartieRead (long pos, char file)
{
	short		err;
	
	err = FileRead(&nextrand, pos, sizeof(u_long)*10, file);
	return err;
}



/* ======= */
/* SetDemo */
/* ======= */

/*
	Modifie le mode "demo".
 */

void SetDemo (char bDemo)
{
	demo = bDemo;
}

/* ======= */
/* GetDemo */
/* ======= */

/*
	Retourne le mode "demo".
	0 -> normal
	1 -> demo
 */

char GetDemo (void)
{
#if 0
#ifndef TESTVERSION
	return test_new_protection () ;
#else
	return 0 ;
#endif
#else
#ifdef SHAREWARE
	return 1 ;
#else
	return 0 ;
#endif
#endif
}






#define Bit32   unsigned long
#define Bit16   unsigned short
#define Bit8    unsigned char
#define sBit32  long
#define sBit16  short
#define sBit8   char
#define boolean int

/* Various useful constants for the VGA card */

#define BITMAP 0xa0000000L

#define FRAMEX_BITS    640
#define FRAMEY_BITS    350
#define FRAMEX_BYTES   (FRAMEX_BITS / 8)

#define NOTVALID -1

void _BDrawLine (Bit8 huge *bmap,int offset,int x0,int y0,int x,int y,ShowMode mode) ;
void SetPixel (Bit8 huge *bmap, int offset, int x0, int y0, ShowMode mode) ;


void _clrrect (Pixmap *pmap, Pt p1, Pt dim, int color)
{
  struct bitmap dest;
  int plane;

  if ( pmap != 0 )
  {
    if ( p1.x < 0 )
    {
      dim.x += p1.x;
      p1.x = 0;
    }
    if ( p1.x + dim.x > pmap->dx )
      dim.x = pmap->dx - p1.x;
    if ( dim.x <= 0 )
      return;
    if ( p1.y < 0 )
    {
      dim.y += p1.y;
      p1.y = 0;
    }
    if ( p1.y + dim.y > pmap->dy )
      dim.y = pmap->dy - p1.y;
    if ( dim.y <= 0 )
      return;
  }

  dest.left=p1.x;
  dest.top=p1.y;
  dest.right=p1.x+dim.x;
  dest.bot=p1.y+dim.y;

  if ( pmap == 0 )                /* destination dans l'ecran ? */
  {
    ifhidemousex(&dest);           /* cache la souris */
    dest.bytes = FRAMEX_BYTES;
    dest.pntr  = (Bit8 *) BITMAP; /* MK_FP (0xa000,0); */
    if (ifcolor() == 0)           /* b&w screen */
      blit (&dest,&dest,8 | (color != COLORNOIR)<<2);
    else                          /* color screen */
    {
      HideMouseInt () ;
      for (plane=0;plane<4;plane++)
      {
        select_plane(plane);
        blit (&dest,&dest,8 | (1 & (color>>plane))<<2);
      }
      ShowMouseInt () ;
    }
    return;
  }
  else                            /* destination dans Pixmap */
  {
    dest.bytes = pmap->dxb;
    dest.pntr  = pmap->data;
    if (pmap->nbp == 4)           /* color Pixmap */
      for (plane=0;plane<4;plane++)
      {
        blit (&dest,&dest,8 | (1 & (color>>plane))<<2);
        dest.pntr+= (long) (pmap->dy*dest.bytes);
      }
    else                          /* b&w Pixmap */
      blit (&dest,&dest,8 | (color != COLORNOIR)<<2);
    return;
  }
}

/* DRAWLINE */

ShowMode procmode (ShowMode mode, int on_off)
{
  if (on_off)
    switch (mode)
    {
      case MODELOAD:
      case MODEOR:
        return MODEOR;
      case MODEXOR:
        return MODEXOR;
      case MODEAND:
      default:
        return NOTVALID;
    }
  else
    switch (mode)
    {
      case MODELOAD:
      case MODEAND:
        return MODEAND;
      case MODEOR:
      case MODEXOR:
      default:
        return NOTVALID;
    }
}

void _drawline (Pixmap *pmap, Pt p1, Pt dim, ShowMode mode,int color)
{
  int plane;
  Bit8 huge *bmap;
  int offset;

  if (mode == NOTVALID)
    return;
  if ( pmap != 0 )
  {
    if ( p1.x < 0 )
    {
      dim.x += p1.x;
      p1.x = 0;
    }
    if ( p1.x + dim.x > pmap->dx )
      dim.x = pmap->dx - p1.x;

    if ( p1.y < 0 )
    {
      dim.y += p1.y;
      p1.y = 0;
    }
    if ( p1.y + dim.y > pmap->dy )
      dim.y = pmap->dy - p1.y;
  }

  if ( pmap == 0 )                /* destination dans l'ecran ? */
  {
    HideMouseInt ();                  /* cache la souris */
    offset = FRAMEX_BYTES;
    bmap = (Bit8 *) BITMAP;       /* MK_FP (0xa000,0); */
    if (ifcolor() == 0)           /* b&w screen */
      _BDrawLine(bmap,offset,p1.x,p1.y,dim.x,dim.y,
                procmode(mode,(color != COLORNOIR)));
    else                          /* color screen */
      for (plane=0;plane<4;plane++)
      {
        select_plane(plane);
	_BDrawLine(bmap,offset,p1.x,p1.y,dim.x,dim.y,
                  procmode(mode,1 & (color>>plane)));
      }
    ShowMouseInt ();
    return;
  }
  else                            /* destination dans Pixmap */
  {
    offset = pmap->dxb;
    bmap = pmap->data;
    if (pmap->nbp == 4)           /* color Pixmap */
      for (plane=0;plane<4;plane++)
      {
	_BDrawLine(bmap,offset,p1.x,p1.y,dim.x,dim.y,
                  procmode(mode,1 & (color>>plane)));
        bmap += (pmap->dy * offset);
      }
    else                          /* b&w Pixmap */
      _BDrawLine(bmap,offset,p1.x,p1.y,dim.x,dim.y,
                procmode(mode,(color != COLORNOIR)));
    return;
  }
}

void _drawrect (Pixmap *pmap, Pt p1, Pt dim,ShowMode mode,int color)
{
  Pt ptemp,dtemp;

  ptemp = p1; dtemp = dim; dtemp.y = 0;
  _drawline (pmap, ptemp, dtemp, mode, color);
  ptemp.y += dim.y;
  _drawline (pmap, ptemp, dtemp, mode, color);
  ptemp = p1; dtemp = dim; dtemp.x = 0;
  _drawline (pmap, ptemp, dtemp, mode, color);
  ptemp.x += dim.x;
  _drawline (pmap, ptemp, dtemp, mode, color);
}


void _setpixel (Pixmap *pmap, Pt st, ShowMode mode,int color)
{
  int plane;
  Bit8 huge *bmap;
  int offset;

  if (mode == NOTVALID)
    return;
  if ( st.x < 0 || st.y < 0)
    return;
  if ( pmap != 0 )
  {
    if (st.x >= pmap->dx || st.y >= pmap->dy )
      return;
  }
  else
  {
    if (st.x >= FRAMEX_BITS || st.y >= FRAMEY_BITS)
      return;
  }

  if ( pmap == 0 )                /* destination dans l'ecran ? */
  {
    HideMouseInt ();                  /* cache la souris */
    offset = FRAMEX_BYTES;
    bmap = (Bit8 *) BITMAP;       /* MK_FP (0xa000,0); */
    if (ifcolor() == 0)           /* b&w screen */
      SetPixel(bmap,offset,st.x,st.y,procmode(mode,(color != COLORNOIR)));
    else                          /* color screen */
      for (plane=0;plane<4;plane++)
      {
        select_plane(plane);
        SetPixel(bmap,offset,st.x,st.y,procmode(mode,1 & (color>>plane)));
      }
    ShowMouseInt ();
    return;
  }
  else                            /* destination dans Pixmap */
  {
    offset = pmap->dxb;
    bmap = pmap->data;
    if (pmap->nbp == 4)           /* color Pixmap */
      for (plane=0;plane<4;plane++)
      {
        SetPixel(bmap,offset,st.x,st.y,procmode(mode,1 & (color>>plane)));
        bmap += (pmap->dy * offset);
      }
    else                          /* b&w Pixmap */
      SetPixel(bmap,offset,st.x,st.y,procmode(mode,(color != COLORNOIR)));
    return;
  }
}

void SetPixel (Bit8 huge *bmap, int offset, int x0, int y0, ShowMode mode)
{
  int mask;

  bmap += (y0 * offset) + (x0 >> 3);
  mask = 0x80 >> (x0 & 7);
  switch (mode)
  {
    case MODEAND:
      *bmap &= (Bit8) ~mask;
      break;
    case MODEOR:
      *bmap |= (Bit8) mask;
      break;
    case MODEXOR:
      *bmap ^= (Bit8) mask;
      break;
  }
}

void _BDrawLine (Bit8 huge *bmap,int offset,int x0,int y0,int x,int y,ShowMode mode)
/*
   Bresenham algorithm line drawing routine.  Line starts at x0, y0 and
   goes to RELATIVE position x, y.  NO clipping is done, so the two
   end-points must lie within the raster.
*/
{
  int ratio, i;
  int mask;

  if( x < 0 )
  {
    x0 += x;
    y0 += y;
    x = -x;
    y = -y;
  }
  bmap += (y0 * offset) + (x0 >> 3);
  mask = 0x80 >> (x0 & 7);
  if( y < 0 )
  {
    y = -y;
    offset = -offset;
  }
  if( x < y )  /* if |x|<|y| */
  {
    ratio = -(y >> 1);
    for( i = y ; --i >= 0; )
    {
      switch (mode)
      {
        case MODEAND:
          *bmap &= (Bit8) ~mask;
          break;
        case MODEOR:
          *bmap |= (Bit8) mask;
          break;
        case MODEXOR:
          *bmap ^= (Bit8) mask;
          break;
      }
      bmap += offset;
      if ( (ratio += x) > 0 )
      {
        ratio -= y;
        if( !(mask >>= 1) )
        {
          mask = 0x80;
          bmap++;
        }
      }
    }
  }
  else  /* if |x|>=|y| */
  {
    ratio = -(x >> 1);
    for( i = x ; --i >= 0; )
    {
      switch (mode)
      {
        case MODEAND:
          *bmap &= (Bit8) ~mask;
          break;
        case MODEOR:
          *bmap |= (Bit8) mask;
          break;
        case MODEXOR:
          *bmap ^= (Bit8) mask;
          break;
      }
      if( !(mask >>= 1) )
      {
        mask = 0x80;
        bmap++;
      }
      if( (ratio += y) > 0 )
      {
        ratio -= x;
        bmap += offset;
      }
    }
  }
}


#define MAXMUSIC 11

void MusicStart (short song)
{
  char filename[20] ;
  time_t tm ;

  if (song == 1 || song == 2)
  {
	PlaySound (39 + song) ;
	return ;
  }

  if (song >= 4)
  {
	song = 4 + (song-4) % (MAXMUSIC + 1 - 4) ;

  }

  FMStopMusic () ;
  sprintf (filename, "bmx%03d.mus", song) ;
  FMLoadSong (filename) ;
  FMStartMusic () ;
}

void MusicStop (void)
{
  FMStopMusic () ;
}

void PlayNoiseVolume (short volume)
{
  if (volume == 0)
  {
	sound_onoff = 0 ;
	toneoff () ;
  }
  else
	sound_onoff = 1 ;
  setdacvolume (volume * 10) ;
}

static short oldvolume ;
static short currentvolume = -1 ;

void PlayMusicVolume (short volume)
{
  static int musicnull ;

  if (currentvolume != -1)
	oldvolume = currentvolume ;
  else
	oldvolume = volume ;

  currentvolume = volume ;
  FMSetVolume (volume * 10) ;

  if (volume == 0)
  {
	FMStopMusic () ;
	musicnull = 1 ;
  }
  else
  {
	if (musicnull)
	  FMStartMusic () ;
  }
}


void restore_volume ()
{
  PlayMusicVolume (oldvolume) ;
}

void errmem (long supp, long min)
{
#if FRENCH
   printf("Vous n'avez pas assez de m‚moire conventionnelle pour d‚marrer\n"
	   "ce programme. Vous avez actuellement %ld octets de m‚moire\n"
	   "conventionnelle de libre, et vous avez besoin d'au moins %ld octets\n"
	   "de m‚moire conventionnelle libre.\n", supp + farcoreleft (), min) ;
#endif

#if GERMAN
   printf ("Sie haben nicht genug Speicherplatz, um dieses Program zu starten.\n"
	   "Zur Zeit stehen Ihnen %ld Bytes freier konventioneller Speicher zur\n"
	   "Verfgung. Sie ben”tigen aber mindestens %ld Bytes freien\n"
	   "konventionellen Speicher\n", supp + farcoreleft (), min) ;
#endif

#if ENGLISH
   printf("Youn don't have enough free conventional memory for this program.\n"
	  "You have %ld bytes of free conventional memory and you need at\n"
	  "least %ld bytes of free conventional memory.", supp + farcoreleft (), min) ;
#endif


    exit(3);
}


static int savepixmaphandle ;
static Pixmap savepixmap ;


#define PIXMAPLEN ((long)LXIMAGE * LYIMAGE / 2)
#define SAVEPORTIONS 5

static int pixmapplen = (PIXMAPLEN / 5) ;


short SavePixmap (Pixmap *ppm)
{
  char huge *data = ppm->data ;
  int i ;
  long offset = 0 ;
  savepixmap = *ppm ;

  savepixmaphandle = XMSGetMem ((long)(PIXMAPLEN + 1024) / 1024);

  for (i = 0 ; i < SAVEPORTIONS ; i++)
  {
	XMSCopy (0, (long)(void *)data, savepixmaphandle, offset, pixmapplen) ;
	offset += pixmapplen ;
	data += pixmapplen ;
  }
  return 0 ;
}


short RestorePixmap (Pixmap *ppm)
{

  char huge *data ;
  int i ;
  long offset = 0 ;

  *ppm = savepixmap ;
  data = ppm->data ;

  for (i = 0 ; i < SAVEPORTIONS ; i++)
  {
	XMSCopy (savepixmaphandle, offset, 0, (long)(void *)data, pixmapplen) ;
	offset += pixmapplen ;
	data += pixmapplen ;
  }
  *ppm = savepixmap ;
  XMSFreeMem (savepixmaphandle) ;
}
