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

#include "bm_x.h"
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
char  _SMAIDE[] = "(C)  Daniel ROUX et EPSITEC-system sa";



static int visumouse ;
static short heli ;

/* ---------------------------- */
/* Constantes globales internes */
/* ---------------------------- */


#define RESMEM    200000    /* reserve de memoire */
#define KEYDBOX   0x7E00    /* "touche" tres speciale ! */

#define DBIONCLE  (1<<27)   /* mode pour dbox */

#define COLORBLANC  15   /* 0 blanc */
#define COLORJAUNE  14   /* 1 jaune */
#define COLORORANGE 2   /* orange */
#define COLORROUGE  3   /* rouge */
#define COLORBRUN 4   /* brun */
#define COLORGRISF  5   /* gris fonce */
#define COLORGRISC  6   /* gris clair */
#define COLORVERT 7   /* vert */
#define COLORNOIR 0    /* noir */


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
static Pixmap   pmicon1 = {0,0};    /* pixel-map des icones1 (chair) */
static Pixmap   pmicon2 = {0,0};    /* pixel-map des icones2 (masque) */
static Pt   origine;      /* coin sup/gauche de l'origine */
static long   atime = 0;      /* temps de debut */
static int    nokey;        /* numero du clavier */
static char   eventmouse = 0;     /* 1 = evenement de la souris */
static char   heremouse = 1;      /* 1 = souris presente */



void clrfifo (void)
{
  disable () ;
  *(int far *)MK_FP (0x40, 0x1a) =
  *(int far *)MK_FP (0x40, 0x1c) ;
  enable () ;
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

  1 fin d'une action
  2 toto retombe par-terre
  3 toto voit les etoiles
  4 glouglou sirop (docteur)
  5 tac (porte, bouton, etc.)
  6 boum (bombe)
  7 plouf (plonge dans l'ocean)
  8 baguette magique
  9 reacteur de la fusee
  10  glou tres court (bain)
  11  pouet-pouet (clown)
  12  elephant
  13  youpie (famille)
  14  accord de guitare
  15  helice de l'helicoptere
  16  bzzz (insect)
  17  moteur de la jeep
  18  clonc de la machine
  19  glou de toto qui est sous l'eau
  20  ooh (paquet)
  21  miam (yogourt)
  22  helice du ventilateur
  23  pan (western)
  24  note haute du xylophone
  25  note basse du xylophone
  26  aie (toto tombe)
  27  ressort (lit, jeep, etc.)
  28  c'est juste
  29  c'est faux
  30  pin-pon
 */

void playsound (int sound)
{
  filsson = sound;      /* donne le numero au processus fils */
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
    mouse(1);
    visumouse = 1;
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
/* ifhidemouse */
/* ----------- */

/*
  Cache la souris si elle est dans un rectangle.
 */

static void ifhidemouse (struct bitmap *r)
{
  Pt    mouse;

  mouse = getmousepos();    /* lit la position de la souris */
  if ( mouse.x-10 > r->right )  return;
  if ( mouse.x+20 < r->left )  return;
  if ( mouse.y-10 > r->bot )  return;
  if ( mouse.y+20 < r->top )  return;
  hidemouse();        /* cache la souris */
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


  short monitor_type=0, available_vmodes=0;
  u_long mtype ;


//  signal (SIGFPE, catcher) ;


#if 0
  farheapfillfree (0) ;

  heap_check () ;

  if (have_obsolete_mouse || (mouse_type () & 0xffff) < 0x0801)
    mouse_disable_mode (1) ;
  else
    mouse_disable_mode (0) ;
#endif
  querry_video(&monitor_type,&available_vmodes);


  if (farcoreleft() < 12000L)
  {
    printf("Not enough memory");
    exit(3);
  }
  randomize();        /* initialise random nr generator */
  save_video_mode();
  err=graphic_mode();
  if (err != 0) {
    fprintf(stderr,"\nUnsupported graphic mode");
    exit(1);          /* retour dans MAIN */
  }
  initmouse(); /* initmouse after a video mode change */

  screen(0);          /* black screen */

  lxwdo = 640;        /* init largeur fenetre */
  lywdo = LYIMAGE;    /* init hauteur fenetre */

  screen(1);

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
  toneoff();
  release_interrupts();

  restore_video_mode();

  if (fatalerrptr != NULL)
    {
      printf (fatalerrptr) ;
      getch () ;
    }
}