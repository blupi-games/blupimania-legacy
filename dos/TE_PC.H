

#define u_short unsigned short int
#define u_long  unsigned long  int
#define u_char	unsigned char


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
/* Structure d'une image chargee */
/* ----------------------------- */

typedef struct
{
  Image *head;			/* pointe l'en-tete */
  char	*clut;			/* pointe la clut */
  char	*data;			/* pointe l'image codee */
}
ImagePC;

/* Variables externes */

extern int filsson; 		/* son a entendre */
extern int filsrep; 		/* pas de repetition */
extern char demo_onoff;
extern char sound_onoff;
extern char music_onoff;
extern char speed_onoff;
extern char Key_Code;
extern char state_space ;
extern char state_left ;
extern char state_right ;

extern char keyison ;


/* --------------------------- */
/*	  Function prototypes	   */
/* --------------------------- */

void tcol_loadclut (void *ptable);
void decode_image(void *sourcedata,void *destdata,int bits);
void select_plane(int plane);
int  graphic_mode(void);
void text_mode(void);
void hidemouse(void);
void showmouse(void);
void setposmouse (Pt pos);
Pt getposmouse (void);
void farmemset (void *p, char fill, long lgt) ;

void keyon (void) ;
void keyoff (void) ;
