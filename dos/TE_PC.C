

#define LEAVEOPEN 1



/* ==================== */
/* PC specific routines */
/* ==================== */

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <alloc.h>
#include <errno.h>
#include <bios.h>
#include <conio.h>
#include <dos.h>
#include <stdlib.h>
#include <time.h>

#include "..\blang\demovers.h"
#ifdef DEMOVERS
extern int cntime ;
#endif

#include "te.h"
#include "te_pc.h"
#include "keys_pc.h"



#define ICOMOFF 128

#define mouse(x)  {_AX = x;geninterrupt(0x33);}

struct bitmap {
  int left;
  int top;
  int right;
  int bot;
  int bytes;
  char huge *pntr;
};

/* ------- */
/* En-tete */
/* ------- */

u_long  _stksize  = 8000L;    /* longueur du tas et de la pile  */
u_long  _SMASOVER = 0L;     /* 0: pas d'entree overlay, 1: ou */
u_char  _SMAPRIO  = 11;     /* priorite                       */
u_char  _SMAREV   = MAJREV;   /* revision                       */
u_char  _SMAVER   = MINREV;   /* version                        */
u_long  _SMAUNIT  = 0xF;      /* unites                         */
u_short _SMADIS[] = {640,2000,340,2000};  /* largeur+hauteur (min+max)      */
u_short _SMASYN   = 2;        /* niveau du haut-parleur         */
u_char  _SMAGC[]  = GCTEXT;   /* fonte                          */
char  _SMAIDE[] = "(C)  Daniel ROUX et EPSITEC-system sa";





/* ---------------------------- */
/* Constantes globales internes */
/* ---------------------------- */


#define RESMEM    200000    /* reserve de memoire */
#define KEYDBOX   0x7E00    /* "touche" tres speciale ! */

#define DBIONCLE  (1<<27)   /* mode pour dbox */

#define COLORBLANC  15   /* 0 blanc */
#define COLORJAUNE  14   /* 1 jaune */
#define COLORORANGE 13   /* orange */
#define COLORROUGE  12   /* rouge */
#define COLORBRUN   11   /* brun */
#define COLORGRISF  10   /* gris fonce */
#define COLORGRISC  9    /* gris clair */
#define COLORVERT   8    /* vert */
#define COLORNOIR   0    /* noir */


/* #define SHIFT   (1<<5) valeur a ajouter si SHIFT */

#define ICONCACHE 40  /* nr of icons that can be hold in the cache */




/* --------------------------- */
/* Variables globales externes */
/* --------------------------- */

short			lxwdo;			/* largeur de la fenetre */
short			lywdo;			/* hauteur de la fenetre */



/* --------------------------- */
/* Variables globales internes */
/* --------------------------- */

static char *fatalerrptr = NULL ;

static u_long   chres;        /* canal des ressources */
static PixelMap   pmicon1 = {0,0};    /* pixel-map des icones1 (chair) */
static PixelMap   pmicon2 = {0,0};    /* pixel-map des icones2 (masque) */
static Pt   origine;      /* coin sup/gauche de l'origine */
static long   atime = 0;      /* temps de debut */
static int    nokey;        /* numero du clavier */
static char   eventmouse = 0;     /* 1 = evenement de la souris */
static int  langue = 0;
static PlayPhase  lastphase = PPNEW;    /* derniere phase du jeu */

static const short coloricon[128*2] = {
        COLORNOIR,COLORBLANC, /* 0 */
        COLORNOIR,COLORBLANC, /* ascenseur 1 */
        COLORNOIR,COLORBLANC, /* ascenseur 2 */
        COLORNOIR,COLORBLANC, /* ascenseur 3 */
        COLORNOIR,COLORBLANC, /* ascenseur 4 */
        COLORNOIR,COLORBLANC, /* mur (pour fiole) */
        COLORNOIR,COLORBLANC, /* porte fermee .. */
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC, /* .. porte ouverrt */
        COLORNOIR,COLORGRISC, /* saut, cle, pont, fiole */
        COLORNOIR,COLORORANGE,  /* tresor */
        COLORNOIR,COLORGRISF, /* roue, pied, escabot */
	COLORNOIR,COLORJAUNE, /* toto */
//	  COLORNOIR, COLORBLANC,
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC,

        COLORNOIR,COLORJAUNE, /* 16 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,

        COLORNOIR,COLORJAUNE, /* 32 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE, /* robot */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,

        COLORNOIR,COLORJAUNE, /* 48 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORROUGE,COLORJAUNE,  /* explosion */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORROUGE,COLORBLANC,  /* chiffres */
        COLORROUGE,COLORBLANC,
        COLORROUGE,COLORBLANC,

        COLORNOIR,COLORORANGE,  /* robot2 */
        COLORNOIR,COLORORANGE,
        COLORNOIR,COLORORANGE,
        COLORNOIR,COLORJAUNE, /* robot3 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORORANGE,  /* robot4 */
        COLORNOIR,COLORORANGE,
        COLORNOIR,COLORORANGE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE, /* robot5 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,

        COLORNOIR,COLORBLANC, /* pont-levis */
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORBLANC,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,

        COLORNOIR,COLORJAUNE, /* 96 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,

        COLORNOIR,COLORJAUNE, /* 112 */
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        COLORNOIR,COLORJAUNE,
        };


static char far *pmicon; /* icones (chair & masks) */
static ImagePC  imPC;
static ImagePC  *pim=&imPC;
static u_short  lastimage = -1;

static u_short  havemouse = 0;     /* is there a mouse ? */
static u_short  visumouse = 0;  /* 1 = souris visible */
static int      mousebut = 0;   /* state of mouse but */

static int      hiticon[ICONCACHE];
/* first row contains the icons & masks that are already loaded */
/* second row contains number of icons & masks acceses */


#ifdef LEAVEOPEN
static FILE *channel10 ;
static FILE *channel20 ;
#endif



#ifdef USE_BLASTER
static int have_sbcard ;
#endif

/* ======= */
/* addlock */
/* ======= */

/*
  Ajoute un mot de passe dans un nom de fichier.
 */

void addlock (char *plock, char *pnom, char *pclef)
{
  strcpy(plock, pnom);      /* plock <-- pnom */
  pclef = pclef;
}

/* ========= */
/* getrandom */
/* ========= */

/*
  Retourne une valeur aleatoire comprise entre min et max-1.
  min <= h < max
*/

int getrandom (int min, int max)
{
  return (int) min + rand()%(max-min);
}


/* ============ */
/* initrandomex */
/* ============ */

/*
  Initialise un tirage exclusif.
 */

void initrandomex (int min, int max, char *pex)
{
  int   i;

  for( i=0 ; i<(max-min) ; i++ )
    {
      pex[i] = 0;     /* met tout le tableau a zero */
    };
}


/* =========== */
/* getrandomex */
/* =========== */

/*
  Retourne une valeur aleatoire exclusive.
*/

int getrandomex (int min, int max, char *pex)
{
  int   i, val;

  val = getrandom(0, max-min);    /* cherche une valeur quelconque */

  for( i=0 ; i<(max-min) ; i++ )
    {
      if ( pex[val] == 0 )    /* valeur deja sortie ? */
  {
    pex[val] = 1;     /* indique valeur utilisee */
    return min+val;
  }
      else
  {
    val ++;
    if ( val == max-min )  val = 0;
  };
    };

  initrandomex(min, max, pex);    /* recommence */
  val = getrandom(0, max-min);    /* cherche une valeur quelconque */
  pex[val] = 1;       /* indique valeur utilisee */
  return min+val;
}



/* ============= */
/* playsoundloop */
/* ============= */

/*
  Met en boucle (repetition) les bruits donnes avec "playsound".
  Si mode =  0  ->  normal (single)
  Si mode >  0  ->  nb de repetitions
  Si mode = -1  ->  repetition infinie (loop)
*/

void playsoundloop (int mode)
{
  filsrep = mode;     /* donne le mode au processus fils */
}


/* ========= */
/* playsound */
/* ========= */

/*
  Fait entendre un bruit quelconque.
*/

/*
  Liste des bruits utilises :

  1 ?
  2 saut par dessus le muret
  3 porte qui s'ouvre
  4 non
  5 ?
  6 bonus trouv‚
  7 Blupi r‚cussite
  8 tr‚sor trouv‚
  9 Blupi qui tombe dans la cage d'ascenseur
  10 objet utile trouv‚
  11 saut
  12 ?
  13 ?
  14 Robot ‚cras‚
  15 Blupi qui raptisse
  16 Trappe qui ferme
  17 Blupi monte sur le char d'assaut
  18 Blupi descend du char d'assaut
  19 deplacement du curseur Blupi dans les menus
  20 Fin du jeu (juste avant de quitter)
  21 choix d'un menu
 */

void playsound (int sound)
{
#ifdef USE_BLASTER
  static int have_samples[] =
  {2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,-1} ;

  int i, snd ;

  for (i = 0 ; (snd = have_samples[i]) != -1; i++)
  {
    if (sound == snd)
      break ;
  }

  if (have_sbcard && snd != -1)
  {
    if (sound_onoff)
      playsoundblast (snd) ;
  }
  else
    filsson = sound ;

#else
  filsson = sound;      /* donne le numero au processus fils */
#endif
}



void soundon (int sound)
{
  sound_onoff = sound ;
}


void keyon (void)
{
   keyison = 1 ;
}


void keyoff (void)
{
   keyison = 0 ;
}


int keystatus (void)
{
  return keyison ;
}


static int __keyusebios ;

void keyusebios (int usebios)
{
  __keyusebios = usebios ;
}



/* ======= */
/* ifmouse */
/* ======= */

/*
  Indique si la souris existe sur cette machine.
  Si oui, retourne != 0.
*/

int ifmouse ()
{
  return havemouse;
}


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



/* ----------- */
/* getposmouse */
/* ----------- */

/*
  Donne la position de la souris, apres avoir recu
  un KEYCLIC depuis getevent par exemple.
 */

Pt getposmouse ()
{
  Pt    ret;

  mouse(3);
  ret.x = _CX;
  ret.y = _DX;
  return ret;
}



void clrfifo (void)
{
  disable () ;
  *(int far *)MK_FP (0x40, 0x1a) =
  *(int far *)MK_FP (0x40, 0x1c) ;
  enable () ;
}

/* ======== */
/* getevent */
/* ======== */

/*
  Lecture d'un evenement du clavier, sans attendre.
  Retourne la touche pressee si != 0.
 */


/* cheat codes */

#define MAXCHEAT 1

static char *cheatcodes[] =
{
  "EPOBJ",
  "EPSMA",
  ""
} ;


static Event cheatevents[] =
{
  EVENTUSEX, EVENTCHEAT
} ;


#ifdef DEMOVERS

static int timeoutcount ;


int gametimeout (void)
{
  if (cntime - timeoutcount > 60 * 40)
    return 1 ;
  else
    return 0 ;
}


static int clr_gametimeout (void)
{
  timeoutcount = cntime ;
}


#endif


Event 
getevent (KeyStatus * ps)
{
#ifdef DEMOVERS
  int isactive = 0 ;
#endif
  int nocheat ;
  int i ;
  int key;
  Pt pt;
  static int cheatidx ;
  static int cheatno ;

  if (state_left)
  {
#ifdef DEMOVERS
    isactive = 1 ;
#endif
    *ps |= STLEFT;
    *ps &= ~STRIGHT;
  }
  else
  {
    *ps &= ~STLEFT ;
  }

  if (state_right)
  {
#ifdef DEMOVERS
    isactive = 1 ;
#endif
    *ps |= STRIGHT;
    *ps &= ~STLEFT;
  }
  else
  {
    *ps &= ~STRIGHT ;
  }

  if (state_left & state_right)
  {
#ifdef DEMOVERS
    isactive = 1 ;
#endif
    *ps &= ~STRIGHT ;
    *ps &= ~STLEFT ;
  }


  if (state_space)
  {
#ifdef DEMOVERS
    isactive = 1 ;
#endif
    *ps |= STUP ;
  }
  else
    *ps &= ~STUP ;

  if (!bioskey (1))
  {
#ifdef DEMOVERS
    if (isactive)
    {
      clr_gametimeout () ;
    }
#endif
    return EVENTTIMOUT;		/* no key available */
  }
  else
    {
      key = bioskey (0);	/* get the pressed key */
      clrfifo () ;

#ifdef DEMOVERS

      clr_gametimeout () ;
#endif
      if (__keyusebios)
      {
      switch (key)
	{
	case KEY_Esc:
	  return EVENTMENU;

	case KEY_Left:
	case KEY_Up:
	  return EVENTPREV;
	case KEY_Down:
	case KEY_Right:
	  return EVENTNEXT;
	case KEY_F1:
	  return EVENTHELP;

	case KEY_1:
//      case KEY_1_NUM:
	  return EVENTUSE0;
	case KEY_2:
//	case KEY_2_NUM:
	  return EVENTUSE1;
	case KEY_3:
//	case KEY_3_NUM:
	  return EVENTUSE2;
	case KEY_4:
//	case KEY_4_NUM:
	  return EVENTUSE3;
	case KEY_5:
//	case KEY_5_NUM:
	  return EVENTUSE4;
	case KEY_6:
//	case KEY_6_NUM:
	  return EVENTUSE5;
	case KEY_7:
//	case KEY_7_NUM:
	  return EVENTUSE6;
	case KEY_8:
//	case KEY_8_NUM:
	  return EVENTUSE7;
	case KEY_9:
//	case KEY_9_NUM:
	  return EVENTUSE8;
	case KEY_0:
//	case KEY_0_NUM:
	  return EVENTUSE9;

	case KEY_Cr:
	  return EVENTUSEJ;

	case KEY_F3:
	  sound_onoff ^= 1;	/* sound on/off */
	  return -1;
	case KEY_F4:
	  music_onoff ^= 1;	/* music on/off */
	  if (music_onoff)
	    toneon ();
	  else
	    toneoff ();
	  return -1;
	case KEY_F5:
	  speed_onoff ^= 1;	/* speed high/low */
	  return -1;
	}
      }
      else
      {
      switch (Key_Code)
      {
	case 1:
	  return EVENTMENU;

	case 0x4b:
	case 0x48:
	  return EVENTPREV;
	case 0x50:
	case 0x4d:
	  return EVENTNEXT;
	case 0x3b:
	  return EVENTHELP;
	case 2:
	  return EVENTUSE0;
	case 3:
	  return EVENTUSE1;
	case 4:
	  return EVENTUSE2;
	case 5:
	  return EVENTUSE3;
	case 6:
	  return EVENTUSE4;
	case 7:
	  return EVENTUSE5;
	case 8:
	  return EVENTUSE6;
	case 9:
	  return EVENTUSE7;
	case 10:
	  return EVENTUSE8;
	case 11:
	  return EVENTUSE9;

	case 0x1c:
	  return EVENTUSEJ;
      }

      key &= 0x7f ;

      nocheat = 1 ;
	for (i = 0 ; i <= MAXCHEAT ; i++)
	  {
	    char c = cheatcodes[i][cheatidx] ;

	    if (c == key)
	    {
              nocheat = 0 ;
	      cheatidx++ ;
	      cheatno = i ;
	      if (cheatcodes[i][cheatidx] == 0)
	      {
		cheatidx = 0 ;
		return cheatevents[cheatno] ;
	      }

	      break ;
	    }
	    else
	      continue ;
	  }

	  if (nocheat)
	  {
	      cheatidx = 0 ;
	      cheatno = 0 ;
	  }

	  clrfifo () ;
	  return EVENTKEY ;	/* not a valid key */
	}
    }
}




/* ========= */
/* hidemouse */
/* ========= */

/*
  Enleve la souris.
*/

void hidemouse()
{
  if ( visumouse == 1 )
  {
    mouse(2);
    visumouse = 0;
  }
}


/* ========= */
/* showmouse */
/* ========= */

/*
  Remet la souris.
 */

void showmouse()
{
  if ( visumouse == 0 )
  {
//    mouse(1);
//    visumouse = 1;
  }
}

/* =========== */
/* setposmouse */
/* =========== */

/*
  Deplace la souris.
*/

void setposmouse (Pt pos)
{
  _CX=pos.x;
  _DX=pos.y;
  mouse(4);
}



/* ----------- */
/* getmousepos */
/* ----------- */

/*
	Donne la position de la souris, apres avoir recu
	un KEYCLIC depuis getevent par exemple.
 */

static Pt
getmousepos (void)
{
  Pt ret;

  mouse (3);
  ret.x = _CX;
  ret.y = _DX;
  return ret;
}

/* ----------- */
/* ifhidemousex */
/* ----------- */

/*
  Cache la souris si elle est dans un rectangle.
 */

static void ifhidemousex (struct bitmap *r)
{
  Pt    mouse;

  mouse = getmousepos();    /* lit la position de la souris */
  if ( mouse.x-10 > r->right )  return;
  if ( mouse.x+20 < r->left )  return;
  if ( mouse.y-10 > r->bot )  return;
  if ( mouse.y+20 < r->top )  return;
  hidemouse();        /* cache la souris */
}




void clearmem (void *ptr, u_long lgt)
{
  farmemset (ptr, 0, lgt) ;
}




/* --------- */
/* loadimage */
/* --------- */

/*
  Charge un fichier image code, si necessaire.
 */

static int loadimage(int numero)
{
  FILE    *channel;       /* descripteur du fichier */
  char    name[13];       /* nom de l'image BLUPInn.IMA */


/* don't read image only if is icon type */
  if (numero == IMAICON1 || numero == IMAICON2)
    return 0;

  if (numero == lastimage)
  {
    if (pim->clut != 0) tcol_loadclut(pim->clut); /* change la clut */
    return 0;           /* retour ok si image deja chargee */
  }

  if (ifcolor() && numero != IMAICON1 && numero != IMAICON2 && \
      numero < IMAMASK)
    {
    (void) sprintf(name, "TE%03d.COL", numero);
    }
  else
    {
    (void) sprintf(name, "TE%03d.IMA", numero);
    };

  if ((channel=fopen(name,"rb")) == NULL)  {
    text_mode();
    fatalerror (errtext (errno), name);
    }
  (void) fread( pim->head, 1, sizeof(Image), channel );   /* lit l'en-tete */

  if ( pim->head->imlgc != 0 )
    (void) fread( pim->clut, sizeof(char), pim->head->imlgc, channel );  /* lit la clut */

  (void) fread( pim->data, sizeof(char), (u_short) pim->head->imnbb, channel );

  if ( pim->head->imbip > 1 )
      tcol_loadclut(pim->clut);         /* change la clut */
  fclose(channel);                      /* ferme le fichier */
  lastimage = numero;

  return 0;
}


/* =========== */
/* getpixelmap */
/* =========== */

/*
  Ouvre un pixel map quelconque, rempli de zero (blanc).
 */

int getpixelmap(PixelMap *ppm, Pt dim, int bw)
{
  int   nbp = 4;

  if (bw)
    nbp = 1 ;

  if ( ppm->data != 0 )       /* pixel map existe deja ? */
  {
    if ( ppm->dx == dim.x && ppm->dy == dim.y )
    {
      clearmem ( ppm->data, (u_long) (ppm->dxb) * ppm->dy * nbp);
      return 0;       /* pixel map existe deja avec la bonne taille */
    }
    else
    {
      farfree(ppm->data); /* libere le pixel-map precedent */
      ppm->data = 0;
    }
  }

  ppm->dx     = dim.x;
  ppm->dy     = dim.y;
  ppm->nbp    = nbp;        /* nb de bits/pixel selon noir-blanc/couleur */
  ppm->dxb    = ((dim.x+15)/16)*2;
  ppm->ccolor = COLORNOIR;
  ppm->scolor = COLORBLANC;
  ppm->data   = farmalloc( (u_long) (ppm->dxb) * ppm->dy * ppm->nbp );
  if (ppm->data == NULL)
    {
      ppm->data =0;
      fatalerror ("out of memory in getpixelmap") ;
      return 1;
    }
  else
    {
      clearmem( ppm->data, (u_long) (ppm->dxb) * ppm->dy * ppm->nbp );
    };
  return 0;
}



/* ============ */
/* givepixelmap */
/* ============ */

/*
  Libere un pixel map quelconque, obtenu avec "getpixelmap" ou "getimage",
  mais pas avec "geticon" (give pas necessaire).
*/

int givepixelmap(PixelMap *ppm)
{
  if (ppm->data != 0)
  {
    farfree(ppm->data);      /* libere le pixel-map */
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

int getimage(PixelMap *ppm, int numero)
{

  int     err;
  u_char  imcod;      /* type de codage */
  u_long  imnbb;      /* taille du bitmap */
  u_char  imbip;      /* nb de bits/pixel */
  u_short imdlx;      /* largeur en pixels */

  err = loadimage(numero);    /* charge l'image si necessaire */
  if (err != 0)
  {
    givepixelmap(ppm);    /* libere le pixel map */
    return err;     /* erreur si chargement impossible */
  }

  if ( ppm->data == 0              ||
       ppm->dx != pim->head->imdlx ||
       ppm->dy != pim->head->imdly )
  {
    givepixelmap(ppm);    /* libere l'ancien pixel map si necessaire */
    ppm->dx     = pim->head->imdlx;
    ppm->dy     = pim->head->imdly;
    ppm->nbp    = pim->head->imbip; /* nb de bits/pixel */
    ppm->dxb    = ((pim->head->imdlx+15)/16)*2;
    ppm->ccolor = COLORBLANC;
    ppm->scolor = COLORNOIR;
    if (numero != IMAICON1 && numero != IMAICON2)
      ppm->data = farmalloc ((long) (ppm->dxb)*(ppm->nbp)*(ppm->dy));
    if (ppm->data == NULL)
    {
      ppm->data = 0;
      fatalerror ("out of memory in getimage (%d)", numero) ;
      return 1;     /* retour, pas assez de memoire */
    }
  }


  /* decode une image - b&w or color */
  if (pim->head->imcod == 0x17) /* decode only this type of coding */
    decode_image( pim->data, ppm->data, (int) pim->head->imbip );


  return 0;       /* retour ok */
}

/* ============ */
/*  cache_icon  */
/* ============ */

/*
  Cache en memoire une icone en vue d'une utilisation prochaine.
  Ceci est utile pour le PC qui n'a pas assez de memoire pour
  conserver toutes les icones !
 */

char *cache_icon (Icon numero)
{
  int i = 0;
  static int icon = 0;
  FILE *channel;
  char huge *p;

  keyoff () ;

  p = pmicon;
  numero &= ICONMASK;

  while (i<ICONCACHE)
  {
    if (hiticon[i] == numero)
      break;
    i++;
  }

  if (i != ICONCACHE)
  {
    p += (long) (LXICO/8*LYICO*i);
    keyon () ;
    return (char *)p;
  }


#ifdef LEAVEOPEN
  if ( numero < ICOMOFF )
    channel=channel10 ;
  else
    channel=channel20 ;
#else
  if ( numero < ICOMOFF )
    channel=fopen("te010.IMA","rb");
  else
    channel=fopen("te020.IMA","rb");
#endif

  if (channel == NULL)
  {
    fatalerror ("load error while cacheing icons");
  }

  fseek (channel,(long) sizeof(Image) + \
        (numero&~ICOMOFF) * LXICO/8L * LYICO,SEEK_SET);

  p += (long) (LXICO/8*LYICO*icon);
  fread ((char *)p,sizeof (char),LXICO/8*LYICO,channel);

#ifndef LEAVEOPEN
  fclose(channel);                      /* close file */
#endif
  hiticon[icon]=numero;
  if (icon < ICONCACHE) icon++;
    else icon = 0;

  keyon () ;

  return (char *)p;
}



/* ======= */
/* geticon */
/* ======= */

/*
  Conversion d'une icone en pixel map noir/blanc.
  Le pointeur au data (ppm->data) est directement initialise
  sur une de deux cache  (IMAICON  ou IMAICON+IMAMASK).
  Si le mode vaut zero, le data n'est pas rendu, mais seulement
  les dimensions, pour gagner du temps.
 */

int geticon (PixelMap *ppm, Icon numero)
{
  int   n,icon;

  ppm->dx     = LXICO;
  ppm->dy     = LYICO;
  ppm->dxb    = LXICO/8;  /* all icons are continues */
  ppm->nbp    = 1;      /* 1 bit/pixel car noir-blanc */

  n = numero&ICONMASK;
  if ( n >= ICOMOFF )  n -= ICOMOFF;  /* le masque utilise les memes couleurs que l'icone */

  ppm->scolor = coloricon[n * 2] ;      /* initialise la couleur chair */
  ppm->ccolor = coloricon[n * 2 + 1] ;  /* initialise la couleur fond */

  ppm->data  = cache_icon(numero);

  if ( numero&MULTI )
  {
    ppm->data += (long) (((numero>>8)&0x0003)*(LXICO/5/8));
    ppm->data += (long) (((numero>>10)&0x0003)*(LYICO/5*LXICO/8));
    if ( (numero&ICONMMASK) < 0x0C00L )
    {
      ppm->dx = 7;
      ppm->dy = 11;     /* petit chiffre pour le score */
    }
      else
    {
      ppm->dx = 16;
      ppm->dy = 7;      /* croix pour la situation */
    }
  }

  switch ( numero&(~ICONMASK) )
    {
    case UL:
      ppm->dx /= 2;
      ppm->dy /= 2;
      break;

    case UR:
      ppm->data += (long) (LXICO/8/2);
      ppm->dx /= 2;
      ppm->dy /= 2;
      break;

    case DL:
      ppm->data += (long) (LXICO/8L*LYICO/2);
      ppm->dx /= 2;
      ppm->dy /= 2;
      break;

    case DR:
      ppm->data += (long) (LXICO/8L*LYICO/2 + LXICO/8L/2);
      ppm->dx /= 2;
      ppm->dy /= 2;
      break;
    };

  return 0;       /* retour toujours ok */
}




/* =========== */
/* openmachine */
/* =========== */

/*
  Ouverture generale, chargement des librairies, gencar, etc.
 */

void openmachine()
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


  querry_video(&monitor_type,&available_vmodes);

#if 0
  mtype = farcoreleft () ;
  printf ("%ld\n", mtype) ;
  getch () ;
#endif

  if (farcoreleft() < 402000L)
  {
    void errmem (long, long) ;
    errmem (121008L, 525000L) ;
  }

#ifdef USE_BLASTER
  have_sbcard = ! init_sound () ;
#endif


  randomize();        /* initialise random nr generator */
  save_video_mode();
  err=graphic_mode();
  if (err != 0) {
    fprintf(stderr,"\nUnsupported graphic mode");
    exit(1);          /* retour dans MAIN */
  }
  havemouse = initmouse(); /* initmouse after a video mode change */
  hidemouse () ;

  screen(0,0);          /* black screen */

  lxwdo = 640;        /* init largeur fenetre */
  lywdo = LYIMAGE;    /* init hauteur fenetre */

//  (void) ioread();    /* lit les definitions sur disque */

  for (i=0;i<ICONCACHE;i++)
    hiticon[i] = -1;  /* cache is empty */
  pim->head = farmalloc ((long) sizeof (Image));
  pim->clut = farmalloc (0x30L);    /* clut size */
  pim->data = farmalloc (64000L);   /* maxim dimension for a loaded image */

/* reserve place for icon cache */
  pmicon = farmalloc ((long) LXICO/8*LYICO*(ICONCACHE+1));

  if (ifcolor())
    initscreen=fopen("te.col","rb");
  else
    initscreen=fopen("te.ima","rb");
  if (initscreen != NULL)
  {
    (void) fread( pim->head, 1, sizeof(Image), initscreen );
    /* lit l'en-tete */
    if ( pim->head->imlgc != 0 )
      (void) fread( pim->clut, sizeof(char), pim->head->imlgc, initscreen );
      /* lit la clut */
    (void) fread( pim->data, sizeof(char), (u_short) pim->head->imnbb, initscreen );
    decode_screen( pim->data, pim->head->imbip);
    if ( pim->head->imbip > 1 )
        tcol_loadclut(pim->clut);         /* change la clut */
    fclose(initscreen);                   /* ferme le fichier */
    screen(1,0);
  }


#ifdef LEAVEOPEN

    filename = "TE010.IMA" ;
    channel10 = fopen (filename,"rb");
    if (channel10 != NULL)
    {
      filename = "TE020.IMA" ;
      channel20 = fopen (filename,"rb");
    }


    if (channel10 == NULL || channel20 == NULL)
      fatalerror (errtext (errno), filename);
#endif

  trap_interrupts();

}


/* ============ */
/* closemachine */
/* ============ */

/*
  Fermeture generale.
 */

void closemachine()
{
#ifdef USE_BLASTER
  end_sound () ;
  FMMusicDeinit () ;
#endif
  playsoundloop(0);     /* plus de repetition */
  toneoff();
  release_interrupts();
  farfree (pmicon);
  farfree (pim->data);
  farfree (pim->clut);
  farfree (pim->head);
  restore_video_mode();

  if (fatalerrptr != NULL)
    {
      printf (fatalerrptr) ;
      getch () ;
    }
#if 0
  printf ("\n\n"
	  "    Cette VERSION DE TEST du logiciel \"Blupi explorateur\"\n"
	  "    a ‚t‚ remis personellement …:\n\n"
	  "    Pascal Monnier, Gd. Rue 18a, CH-2036 CormondrŠche\n\n"
	  "    qui lui seul … le droit de l'installer sur ses ordinateurs\n"
	  "    personnels.\n\n") ;

  getch () ;
#endif
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
/* copypixel */
/* ========= */

/*
  Copie un rectangle de pixel dans un autre (raster-op).
  Cette procedure est la seule qui dessine dans l'ecran !
    *ppms *pixel-map source (si == 0 -> ecran)
    os  origine source (coin sup/gauche)
    *ppmd *pixel-map destination (si == 0 -> ecran)
    od  origine destination (coin sup/gauche)
    dim dimensions du rectangle
    mode  mode de transfert (MODELOAD/MODEOR/MODEAND)
 */

void copypixel(PixelMap *ppms, Pt os, PixelMap *ppmd, Pt od, Pt dim, ShowMode mode)
{
  struct bitmap src,dest;
  int plane;

  if ( ppmd != 0 )
  {
    if ( od.x < 0 )
    {
      dim.x += od.x;
      od.x = 0;
    }
    if ( od.x + dim.x > ppmd->dx )
      dim.x = ppmd->dx - od.x;
    if ( dim.x <= 0 )  return;
    if ( od.y < 0 )
    {
      dim.y += od.y;
      od.y = 0;
    }
    if ( od.y + dim.y > ppmd->dy )
      dim.y = ppmd->dy - od.y;
    if ( dim.y <= 0 )  return;
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

  if (ifcolor() == 0)
/* b&w screen */
  {
    src.pntr= ppms->data;
    dest.pntr= ppmd->data;

    if ( ppms == 0 )      /* source dans l'ecran ? */
    {
      ifhidemousex(&src);  /* cache la souris */
      src.bytes=640/8;
      src.pntr= MK_FP (0xa000,0);
      mode ^= 4;
    }

    if ( ppmd == 0 )      /* destination dans l'ecran ? */
    {
      ifhidemousex(&dest); /* cache la souris */
      dest.bytes=640/8;
      dest.pntr= MK_FP (0xa000,0);
      switch (mode)
      {
        case 0: mode = 4; break;
        case 1: mode = 6; break;
        case 6: mode = 1; break;
      }
    }
    blit (&src,&dest,mode);
    showmouse();
  }

  else
/* color screen */
  {
    src.pntr= ppms->data;
    dest.pntr= ppmd->data;

    if ( ppms == 0 )      /* source dans l'ecran ? */
    {
      ifhidemousex(&src);  /* cache la souris */
      src.bytes=640/8;
      src.pntr= MK_FP (0xa000,0);
      disable_mouse();
      for (plane=0;plane<4;plane++)
      {
        select_plane(plane);
        blit (&src,&dest,mode);
        dest.pntr+= (long) (ppmd->dy*dest.bytes);
      }
      enable_mouse();
      showmouse();
      return;
    }

    if ( ppmd == 0 )      /* destination dans l'ecran ? */
    {
      ifhidemousex(&dest); /* cache la souris */
      dest.bytes=640/8;
      dest.pntr= MK_FP (0xa000,0);
      if (ppms->nbp == 4)
      {
        disable_mouse();
//	wait_r();
        for (plane=0;plane<4;plane++)
        {
          select_plane(plane);
          blit (&src,&dest,mode);
          src.pntr+= (long) (ppms->dy*src.bytes);
        }
        enable_mouse();
        showmouse();
        return;
      }
      else
      {
        disable_mouse();
        for (plane=0;plane<4;plane++)
	{
          int chm = chgmode(mode,ppms->ccolor>>plane,ppms->scolor>>plane);
          select_plane(plane);
          blit (&src,&dest, chm);
        }
        enable_mouse();
        showmouse();
        return;
      }
    }

    if (ppms->nbp == 4)
    {
      for (plane=0;plane<4;plane++)
      {
        blit (&src,&dest,mode);
        src.pntr+= (long) (ppms->dy*src.bytes);
        dest.pntr+= (long) (ppmd->dy*dest.bytes);
      }
      showmouse();
      return;
    }
    else
    {
      if (ppmd->nbp == 4)
      {
	for (plane=0;plane<4;plane++)
	{
	  int chm = chgmode(mode,ppms->ccolor>>plane,ppms->scolor>>plane) ;
	  blit (&src,&dest, chm);
	  dest.pntr+= (long) (ppmd->dy*dest.bytes);
	}
	showmouse();
	return;
      }
      else
      {
	blit (&src,&dest, mode) ;
      }
    }
  }
}

/* ========== */
/* copypixel2 */
/* ========== */

/*
  Version for the composed LOAD - NAND - OR function
  which is aplied: (mask NAND -> back) OR -> work
 */

void copypixel2(PixelMap *pmmask, PixelMap *pmback,PixelMap *pmwork,
                Pt lu, Pt rd)
{
  struct bitmap mask,back,work;
  int plane;

    if ( lu.x < 0 )     lu.x = 0;
    if ( rd.x > pmwork->dx ) rd.x = pmwork->dx;
    if ( rd.x <= lu.x )  return;
    if ( lu.y < 0 )     lu.y = 0;
    if ( rd.y > pmwork->dy ) rd.y = pmwork->dy;
    if ( rd.y <= lu.y )  return;

  mask.left=back.left=work.left=lu.x;
  mask.right=back.right=work.right=rd.x;
  mask.top=back.top=work.top=lu.y;
  mask.bot=back.bot=work.bot=rd.y;
  mask.bytes=pmmask->dxb;
  back.bytes=pmback->dxb;
  work.bytes=pmwork->dxb;
  mask.pntr=pmmask->data;
  back.pntr=pmback->data;
  work.pntr=pmwork->data;

  if (ifcolor() == 0)
/* b&w screen */
  {
    blit2 (&mask,&back,&work);
    showmouse();
    return;
  }

  else
/* color screen */
  {
    for (plane=0;plane<4;plane++)
    {
      blit2 (&mask,&back,&work);
      back.pntr+= (long) (pmback->dy*pmback->dxb);
      work.pntr+= (long) (pmwork->dy*pmwork->dxb);
    }
    showmouse();
    return;
  }
}




char *errtext (int errn)
{
  static char texte[80] ;

  sprintf (texte, "%%s: %s", strerror (errn)) ;
  return texte ;
}


void fatalerror (char *fmt, ...)
{
  va_list argptr ;
  static char errtext[80] ;


  keyon () ;

  sprintf (errtext, "Fatal error: ") ;

  va_start (argptr, fmt) ;

  vsprintf (errtext + strlen (errtext), fmt, argptr) ;
  fatalerrptr = errtext ;

  va_end (argptr) ;
  closemachine () ;
  exit (1) ;
}




char convcode (char c)
{
  static char table[] =
  {
    129, 15,  /*  */
    130, 18,  /* ‚ */
    131, 17,  /* ƒ */
    132, 27,  /* „ */
    133, 16,  /* … */
    135, 29,  /* ‡ */
    136, 21,  /* ˆ */
    137, 20,  /* ‰ */
    138, 19,  /* Š */
    139, 22,  /* ‹ */
    140, 23,  /* Œ */
    147, 24,  /* “ */
    148, 28,  /* ” */
    150, 26,  /* – */
    151, 25,  /* — */
    0,0
  } ;

  char *p = table ;
  char car ;


  while ((car = *p++) != 0)
  {
    if (car == c)
      return *p ;
    p++ ;
  }
  return c ;
}





void cput(int para,int x,int y,char c,int col, ...)
/* x,y,c,col,rpt,dir */
{
  int rpt,dir;
  va_list ap;
  va_start(ap, col);
  if (para > 4) rpt = va_arg(ap, int);
    else rpt = 1;
  if (para > 5) dir = va_arg(ap, int);
    else dir = 0;
  if (dir < 0 || dir > 3) dir = 0;
  --x; --y;
  do
   {
    pokeb (0xb800,2*(40*y+x),c);
    if (col) pokeb (0xb800,2*(40*y+x)+1,col);
    switch (dir)
    {
      case 0: x++;break;
      case 1: y++;break;
      case 2: x--;break;
      case 3: y--;break;
      default: return;
    }
  }
  while (--rpt);
  va_end(ap);
}


char hex(char *str)
{
  char nr,c;
  c = (*str++ | 0x20) - '0';
  if (c > 9) c-='a'-'0'-10;
  if (c > 15) return (-1);
  nr = c<<4;
  c = (*str++ | 0x20) - '0';
  if (c > 9) c-='a'-'0'-10;
  if (c > 15) return (-1);
  return (nr | c);
}

void sput(int x,int y,char* str)
{
static char atr = 0xf;
char key;
while (*str) {
  if (*str != '%') cput (4,x++,y,*str++,atr);
  else {
    key = *(++str);
    switch (key) {
      case '0': cput (4,x++,y,hex(++str),atr); str+=2; break;
      case 'C':
      case 'c': atr = hex(++str); str+=2; break;
      case '%':
      default: cput (4,x++,y,*str++,atr);
    }
  }
}
}

void box (x1,y1,x2,y2,bstr,bco,fch,fco)
  int x1,y1,x2,y2,bco,fco;
  char *bstr,fch;
  {
  int i;
  char *p;
  p = bstr;
  for (i=0;i<y2-y1;i++)
    cput (5,x1,y1+i,fch,fco,x2-x1);

  cput (5,x1,y1,*p,bco,x2-x1);
  cput (5,x1,y2,*p++,bco,x2-x1);
  cput (6,x1,y1,*p,bco,y2-y1,1);
  cput (6,x2,y1,*p++,bco,y2-y1,1);
  cput (4,x1,y1,*p++,bco);
  cput (4,x2,y1,*p++,bco);
  cput (4,x1,y2,*p++,bco);
  cput (4,x2,y2,*p++,bco);
}

/* -------- */
/* dboxopen */
/* -------- */

/*
  Prepare le travail dans une dbox.
*/

static void dboxopen ()
{
  hidemouse();
  save_palet();
  text_mode();
}


/* --------- */
/* dboxclose */
/* --------- */

/*
  Termine le travail dans une dbox.
*/

static void dboxclose ()
{
  graphic_mode();
  restore_palet();
  showmouse();
}


/* ======= */
/* dboxdef */
/* ======= */

/*
  Demande les definitions.
 */

DboxOut dboxdef ()
{
  int key;
  int oklet=0;

  dboxopen();
  box (1,1,40,23,"ÍºÉ»È¼",0x1f,' ',0x1f);
  sput(5,5,"%c0cF%c1fran‡ais");
  sput(5,10,"%c0cE%c1fnglish");
  sput(5,15,"%c0cD%c1feutsch");
  while (oklet != 1)
  {
    key = bioskey(0);
    key |= 0x20;
    switch(key)  /* wait for a key */
    {
      case KEY_f:
          langue=0;
          oklet=1;
          break;
      case KEY_e:
          langue=1;
          oklet=1;
          break;
      case KEY_d:
          langue=2;
          oklet=1;
          break;
    }
    enable();        /* reenable interrupts - bug */
  }
  dboxclose();
  error_handler(0);         /* disable error handler */
//  iowrite();
  error_handler(1);         /* reenable error handler */
  return DBOXCONT;
}

/* ======== */
/* dboxcomm */
/* ======== */

/*
  Fait de la publicite.
 */

DboxOut dboxcomm (void)
{

  dboxopen();
  box (1,1,40,23,"******",0xA,'°',0xB);
  box (5,5,37,16,"      ",0x1F,' ',0x1F);
  switch(langue)
  {
    case 0:
      sput(6,6,"%c1eSi ce jeux vous int‚resse, vous");
      sput(6,7,"pouvez le commander auprŠs de :");
      break;
    case 1:
      sput(8,6,"%c1eIf you'd like to play more,");
      sput(8,7,"you can order this game at:");
      break;
    case 2:
      sput(6,6,"%c1eWenn Sie an diesem Spiel");
      sput(6,7,"interessiert sind, k”nnen Sie es");
      sput(6,8,"bei folgender Adresse bestellen:");
      break;
    case 3:
      sput(7,6,"%c1eSe questo gioco vi interessa,");
      sput(7,7,"potete ordinarlo presso :");
      break;
    case 4:
      sput(6,6,"%c1eSi este juego le interesa, lo");
      sput(6,7,"puede encargar a esta direcci¢n:");
      break;
    case 5:
      sput(8,6,"%c1eSe este jogo vous interessa,");
      sput(8,7,"voc‚s podem encomenda-lo na:");
      break;
  }
  sput(13,11,"%c1fEPSITEC-system SA");
  sput(13,12,"Ch. de la Mouette");
  sput(13,13,"CH-1092 Belmont");
  sput(11,15,"FAX 41 21 / 728 44 83");
  bioskey(0);  /* get the pressed key */
  enable();    /* reenable interrupts - bug */
  dboxclose();
  return DBOXCONT;
}



/* ======== */
/* dboxinfo */
/* ======== */

/*
  Donne quelques informations sur le logiciel.
 */

DboxOut dboxinfo (void)
{
  dboxopen();
  box (1,1,40,23,"******",0xA,'°',0xB);
  box (4,3,37,21,"      ",0x1F,' ',0x1F);
  sput(6,4,"%c1eF1 %c1f- this help screen");
  sput(6,6,"%c1eF2 %c1f- change definitions");
  sput(6,8,"%c1eF3 %c1f- sound on/off");
  sput(6,10,"%c1eF4 %c1f- background music on/off");
  sput(6,12,"%c1eF5 %c1f- blupi speed low/high");
  sput(6,14,"%c1eEsc   %c1f- quit the game");
  sput(6,16,"%c1eHome  %c1f- return to home any time");
  sput(6,18,"%c1e%01B  %01A  %c1f- left/right deplacements");
  sput(6,20,"%c1eCTRL-P%c1f- print current screen");
  bioskey(0);  /* get the pressed key */
  enable();    /* reenable interrupts - bug */
  dboxclose();
  return DBOXCONT;
}





/* ========= */
/* calccheck */
/* ========= */

/*
	Calcule une valeur de check sur 8 nombres.
 */

int calccheck (int n1, int n2, int n3, int n4, int n5, int n6, int n7, int n8)
{
  if ( n8 == 1 )  return ( ((n1-123)*(n2-n3))%400 + n4 -   ((n5+10)*(n6-n7+15))%279 )%1000;
  if ( n8 == 2 )  return ( ((n1+46)*(n3-n2))%251  + n4*4 - ((n7-12)*(n6+n5-3))%670  )%1000;
  if ( n8 == 3 )  return ( (n5+(n2*17)-n3)%321    - n4*5 + ((n1+3)*(n6-n7+61))%301  )%1000;
  if ( n8 == 4 )  return ( ((n7+123)*(n5+n3))%407 + n4 +   ((n2-9)*(n6+n1-28))%297  )%1000;
                  return ( ((n4-122)*(n6+n3))%561 - n1*7 + ((n7-13)*(n2+n5-68))%792 )%1000;
}


/* @@ PROVISOIRE */






void clearscreen (void)
{
}
