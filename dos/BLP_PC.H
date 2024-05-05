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



struct bitmap
  {
    int left;
    int top;
    int right;
    int bot;
    int bytes;
    char huge *pntr;
  };




/* Variables externes */

extern int filsson; 		/* son a entendre */
extern int filsrep; 		/* pas de repetition */
extern char demo_onoff;
extern char sound_onoff;
extern char music_onoff;
extern char speed_onoff;
extern char Key_Code;

/* --------------------------- */
/*	  Function prototipes	   */
/* --------------------------- */

extern	void tcol_loadclut (void *ptable);
extern	void decode_image(void *sourcedata,void *destdata,int bits);
extern	void select_plane(int plane);
extern	int  graphic_mode(void);
extern	void text_mode(void);
extern	void text2_mode(void);
extern	int vfy_mouse(void) ;
extern	void save_video_mode (void) ;
extern	void screen (int on, int border) ;
extern	void decode_screen (char *data, int bits) ;
extern	void trap_interrupts (void) ;
extern	void release_interrupts (void) ;
extern	void restore_video_mode (void);
extern	void blit (struct bitmap *b1, struct bitmap *b2, ShowMode mode) ;
extern	void wait_r (void) ;
extern	void farmemset (char *ptr, int val, long lgt) ;
extern	void save_palet (void) ;
extern	void restore_palet (void) ;
extern	u_long  mouse_type (void) ;
extern	void error_handler (int on) ;
extern	int vfy_obsmouse (void) ;
extern	void mouse_disable_mode (int mode) ;
extern	void querry_video (short *monitor, short *mode) ;
//extern  void disable_mouse (void) ;
//extern  void enable_mouse (void) ;
