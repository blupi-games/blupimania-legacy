
/* ========== */
/* bm_decor.c */
/* ========== */

#include <stdio.h>
#include <errno.h>
#include <string.h>

#include "bm.h"
#include "bm_icon.h"
#include "actions.h"






/* --------------------------- */
/* Variables globales internes */
/* --------------------------- */

static Monde	*pmonde;						/* pointe la description du monde */

static short	imonde[MAXCELY][MAXCELX];		/* cellules du monde initial */
static Pixmap	pmdecor = {0,0,0,0,0,0,0};		/* pixmap du decor de fond */
static Pixmap	pmsuper = {0,0,0,0,0,0,0};		/* pixmap de la super cellule */
static Pixmap	pmsback = {0,0,0,0,0,0,0};		/* pixmap de la super cellule sauvee */
static short	superinv;						/* 1 -> super cellule allumee  */
static Pt		supercel;						/* super cellule visee par la souris */
static Pt		superpos;						/* position graphique super cellule */
static Pt		ovisu;							/* origine 1ere cellule (0;0) */
static Pt		lastovisu;						/* derniere origine partie visible */
static Pt		lastpmouse;						/* derniere position de la souris */
static short	lastsensuni;					/* dernier sens-unique pose */
static short	lastaccel;						/* dernier accelerateur pose */
static short	lastcaisse;						/* derniere caisse posee */
static short	lasttank;						/* dernier tank pose */


typedef struct
{
	Pt		ovisu;							/* origine 1ere cellule (0;0) */
	short	reserve[10];					/* reserve */
}
Partie;





/* ======== */
/* GraToCel */
/* ======== */

/*
	Conversion d'une position graphique dans l'ecran
	en une coordonnee dans une cellule.
		Pt  ->	[gra]
		cel <-	[monde]
 */

Pt GraToCel (Pt gra)
{
	Pt		cel;
	
	if ( gra.x < POSXDRAW || gra.x > POSXDRAW+DIMXDRAW ||
		 gra.y < POSYDRAW || gra.y > POSYDRAW+DIMYDRAW )  goto error;
	
	gra.x -= POSXDRAW + PLXICO*ovisu.x + LXICO/2 - 5;
	gra.y -= POSYDRAW + PRYICO*ovisu.y + LYICO/2 + 11;
	
	cel.x = (PRXICO*gra.y + PRYICO*gra.x) / (PRYICO*PLXICO + PRXICO*PLYICO);
	cel.y = (PLXICO*gra.y - PLYICO*gra.x) / (PRYICO*PLXICO + PRXICO*PLYICO);
	
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  goto error;
	
	return cel;
	
	error:
	cel.x = -1;
	cel.y = -1;
	return cel;
}


/* ======== */
/* CelToGra */
/* ======== */

/*
	Conversion d'une coordonnee dans une cellule
	en une position graphique dans l'ecran.
		cel ->	[monde]
		Pt  <-	[gra]
 */

Pt CelToGra (Pt cel)
{
	Pt		gra;
	
	gra.x = PLXICO*cel.x - PRXICO*cel.y;
	gra.y = PRYICO*cel.y + PLYICO*cel.x;
	
	return gra;
}



/* =========== */
/* DecorGetCel */
/* =========== */

/*
	Retourne l'icone occupant une cellule donnee.
	Retourne -1 si les coordonnees sont hors du monde !
 */

short DecorGetCel (Pt cel)
{
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  return -1;	/* sort du monde */
	
	return pmonde->tmonde[cel.y][cel.x];
}


/* =========== */
/* DecorPutCel */
/* =========== */

/*
	Modifie l'icone occupant une cellule donnee.
 */

void DecorPutCel (Pt cel, short icon)
{
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  return;	/* sort du monde */
	
	pmonde->tmonde[cel.y][cel.x] = icon;
}


/* ------ */
/* GetSol */
/* ------ */

/*
	Retourne le sol a mettre a un endroit donne.
	Cherche autour comment est le sol.
	spec = 0	->	ne cherche que les sols sur lesquels on peut poser
	spec = 1	->	cherche tous les sols
 */

short GetSol (Pt cel, short spec)
{
	short		i = 0;
	Pt			pos;
	short		max, icon;
	
	static char table[] =
	{
		+1, +1,
		 0, +1,
		-1, +1,
		-1,  0,
		-1, -1,
		 0, -1,
		+1, -1,
		+1,  0,
		
		+2, +2,
		+1, +2,
		 0, +2,
		-1, +2,
		-2, +2,
		-2, +1,
		-2,  0,
		-2, -1,
		-2, -2,
		-1, -2,
		 0, -2,
		+1, -2,
		+2, -2,
		+2, -1,
		+2,  0,
		+2, +1,
		
		+3, +3,
		+2, +3,
		+1, +3,
		 0, +3,
		-1, +3,
		-2, +3,
		-3, +3,
		-3, +2,
		-3, +1,
		-3,  0,
		-3, -1,
		-3, -2,
		-3, -3,
		-2, -3,
		-1, -3,
		 0, -3,
		+1, -3,
		+2, -3,
		+3, -3,
		+3, -2,
		+3, -1,
		+3,  0,
		+3, +1,
		+3, +2,
		
		-100
	};
	
	if ( spec )  max = ICO_SOLMAX;
	else         max = ICO_SOLOBJET;
	
	while ( table[i] != -100 )
	{
		pos.x = cel.x + table[i+0];
		pos.y = cel.y + table[i+1];
		icon = DecorGetCel(pos);
		if ( icon != -1 && icon < max )
		{
			return icon;
		}
		i += 2;
	}
	
	return ICO_SOLCARRE;
}


/* =============== */
/* DecorGetInitCel */
/* =============== */

/*
	Retourne l'icone de sol occupant une cellule donnee lorsque le monde
	a ete initialise.
	Retourne -1 si les coordonnees sont hors du monde !
 */

short DecorGetInitCel (Pt cel)
{
	short		icon;
	
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  return -1;	/* sort du monde */
	
	icon = imonde[cel.y][cel.x];
	
	if ( icon < ICO_SOLMAX ||
		 icon == ICO_BAISSEBAS ||
		 icon == ICO_UNSEUL ||
		 (icon >= ICO_SENSUNI_S && icon <= ICO_SENSUNI_O) ||
		 (icon >= ICO_ACCEL_S && icon <= ICO_ACCEL_O) )  return icon;
	
	return GetSol(cel, 0);
}


/* =============== */
/* DecorPutInitCel */
/* =============== */

/*
	Modifie l'icone de sol occupant une cellule donnee lorsque le monde
	a ete initialise.
 */

void DecorPutInitCel (Pt cel, short icon)
{
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  return;	/* sort du monde */
	
	imonde[cel.y][cel.x] = icon;
}



/* ============= */
/* DecorIconMask */
/* ============= */

/*
	Fabrique le masque permettant de dessiner une icone sur une cellule
	tout en etant masquee par les elements du decor places devant.
	La table[] donne les coordonnees relatives des cellules succeptibles
	de masquer l'objet place dans la cellule (0;0).
	Voir l'explication de cette table[] dans IMASK.IMAGE !
		ppm ->	pixmap ayant les dimensions d'une icone (80x80)
		pos ->	coordonnees exactes de l'icone a masquer [gra]
		cel ->	coordonnees de la cellule charniere [monde]
 */

void DecorIconMask(Pixmap *ppm, Pt pos, short posz, Pt cel)
{
	static char table[] =
	{
		-1,  1,
		-1,  2,
		 0,  0,
		 0,  1,
		 0,  2,
		 0,  3,
		 1, -1,
		 1,  0,
		 1,  1,
		 1,  2,
		 1,  3,
		 2,  0,
		 2,  1,
		 2,  2,
		 2,  3,
		 3,  1,
		 3,  2,
		-100
	};
	
	short		i = 0;
	short		icon;
	Pixmap		pm;
	Pt			p, c, off, dst;
	
	GetPixmap(ppm, (p.y=LYICO,p.x=LXICO,p), 0, 1);		/* efface le pixmap du masque */
	
	off = CelToGra(cel);
	off.x += PLXICO*ovisu.x;
	off.y += PRYICO*ovisu.y;
	off.x = pos.x - off.x;
	off.y = pos.y - off.y;
	
	while ( table[i] != -100 )
	{
		c.x = cel.x + table[i+0];
		c.y = cel.y + table[i+1];
		
		if ( c.x < MAXCELX && c.y < MAXCELY )
		{
			icon = pmonde->tmonde[c.y][c.x];
		}
		else
		{
			icon = ICO_SOL;
		}
		
		if ( table[i+0] == 0 && table[i+1] == 0 &&
			 icon >= ICO_PORTEO_EO && icon < ICO_PORTEO_EO+6 )  goto next;
		
		if ( c.x < MAXCELX && c.y < MAXCELY &&
			 (icon >= ICO_BLOQUE || icon == ICO_DEPART) )	/* icone en hauteur ? */
		{
			GetIcon(&pm, icon+ICOMOFF, 1);
			dst.x = PLXICO*table[i+0] - PRXICO*table[i+1] - off.x;
			dst.y = PRYICO*table[i+1] + PLYICO*table[i+0] - off.y;
			CopyPixel
			(
				&pm, (p.y=0, p.x=0, p),
				ppm, dst,
				(p.y=LYICO,p.x=LXICO,p), MODEOR
			);
		}
		
		if ( posz > 0 &&						/* icone en dessous du sol ? */
			 (table[i+0] > 0 || table[i+1] > 0 ||
			  (icon != ICO_DEPART &&
			   icon != ICO_TROU &&
			   icon != ICO_TROUBOUCHE)) )
		{
			GetIcon(&pm, ICO_SOL+ICOMOFF, 1);
			dst.x = PLXICO*table[i+0] - PRXICO*table[i+1] - off.x;
			dst.y = PRYICO*table[i+1] + PLYICO*table[i+0] - off.y;
			CopyPixel
			(
				&pm, (p.y=0, p.x=0, p),
				ppm, dst,
				(p.y=LYICO,p.x=LXICO,p), MODEOR
			);
		}
		
		next:
		i += 2;
	}
}



/* ------------ */
/* MurGetConnex */
/* ------------ */

/*
	Retourne les directions autour d'une cellule occupees par des murs.
	Ces directions devront etre connectees.
 */

short MurGetConnex (Pt cel)
{
	short	icon;
	short	connex = 0;
	
	cel.x ++;
	if ( cel.x < MAXCELX )
	{
		icon = DecorGetCel(cel);
		if ( (icon >= ICO_MURHAUT && icon <= ICO_MURHAUT_D) ||		/* est-ce un mur ? */
			 (icon >= ICO_MURBAS && icon <= ICO_MURBAS_D) ||
			 (icon >= ICO_BARRIERE && icon <= ICO_BARRIERE_D) ||
			 (icon >= ICO_VITRE && icon <= ICO_VITRE_D) ||
			 (icon >= ICO_PORTEF_EO && icon < ICO_PORTEF_EO+6) )  connex |= 1<<0;	/* est */
	}
	
	cel.x --;
	cel.y ++;
	if ( cel.y < MAXCELY )
	{
		icon = DecorGetCel(cel);
		if ( (icon >= ICO_MURHAUT && icon <= ICO_MURHAUT_D) ||		/* est-ce un mur ? */
			 (icon >= ICO_MURBAS && icon <= ICO_MURBAS_D) ||
			 (icon >= ICO_BARRIERE && icon <= ICO_BARRIERE_D) ||
			 (icon >= ICO_VITRE && icon <= ICO_VITRE_D) ||
			 (icon >= ICO_PORTEF_EO && icon < ICO_PORTEF_EO+6) )  connex |= 1<<1;	/* sud */
	}
	
	cel.x --;
	cel.y --;
	if ( cel.x >= 0 )
	{
		icon = DecorGetCel(cel);
		if ( (icon >= ICO_MURHAUT && icon <= ICO_MURHAUT_D) ||		/* est-ce un mur ? */
			 (icon >= ICO_MURBAS && icon <= ICO_MURBAS_D) ||
			 (icon >= ICO_BARRIERE && icon <= ICO_BARRIERE_D) ||
			 (icon >= ICO_VITRE && icon <= ICO_VITRE_D) ||
			 (icon >= ICO_PORTEF_EO && icon < ICO_PORTEF_EO+6) )  connex |= 1<<2;	/* ouest */
	}
	
	cel.x ++;
	cel.y --;
	if ( cel.y >= 0 )
	{
		icon = DecorGetCel(cel);
		if ( (icon >= ICO_MURHAUT && icon <= ICO_MURHAUT_D) ||		/* est-ce un mur ? */
			 (icon >= ICO_MURBAS && icon <= ICO_MURBAS_D) ||
			 (icon >= ICO_BARRIERE && icon <= ICO_BARRIERE_D) ||
			 (icon >= ICO_VITRE && icon <= ICO_VITRE_D) ||
			 (icon >= ICO_PORTEF_EO && icon < ICO_PORTEF_EO+6) )  connex |= 1<<3;	/* nord */
	}
	
	return connex;
}

/* -------- */
/* MurBuild */
/* -------- */

/*
	Met un mur dans une cellule, et raccorde les cellules voisines.
 */

void MurBuild (Pt cel, short type)
{
	short		icon, oldicon, newicon;
	Pt			celinit = cel;
	short		i;
	
	static short tmurs[] =
	{
		ICO_MURBAS+MUR_NSEO,	/* ---- */
		ICO_MURBAS+MUR_EO,		/* ---E */
		ICO_MURBAS+MUR_NS,		/* --S- */
		ICO_MURBAS+MUR_SE,		/* --SE */
		ICO_MURBAS+MUR_EO,		/* -O-- */
		ICO_MURBAS+MUR_EO,		/* -O-E */
		ICO_MURBAS+MUR_SO,		/* -OS- */
		ICO_MURBAS+MUR_SEO,		/* -OSE */
		ICO_MURBAS+MUR_NS,		/* N--- */
		ICO_MURBAS+MUR_NE,		/* N--E */
		ICO_MURBAS+MUR_NS,		/* N-S- */
		ICO_MURBAS+MUR_ENS,		/* N-SE */
		ICO_MURBAS+MUR_NO,		/* NO-- */
		ICO_MURBAS+MUR_NEO,		/* NO-E */
		ICO_MURBAS+MUR_ONS,		/* NOS- */
		ICO_MURBAS+MUR_NSEO		/* NOSE */
	};
	
	static short tpos[4*2] =
	{
		+1,  0,
		 0, +1,
		-1,  0,
		 0, -1
	};
	
	icon = tmurs[MurGetConnex(cel)];
	if ( type == 0 )
	{
		if ( GetRandom(1,0,2) == 0 )  icon -= 16;
		oldicon = DecorGetCel(cel);
		if ( oldicon >= ICO_MURHAUT && oldicon <= ICO_MURHAUT_D )  icon = oldicon+16;
		if ( oldicon >= ICO_MURBAS  && oldicon <= ICO_MURBAS_D  )  icon = oldicon-16;
	}
	if ( type == 1 )
	{
		icon += ICO_BARRIERE-ICO_MURBAS;
	}
	if ( type == 2 )
	{
		icon += ICO_VITRE-ICO_MURBAS;
	}
	DecorModif(cel, icon);
	
	for ( i=0 ; i<4 ; i++ )
	{
		cel = celinit;
		cel.x += tpos[i*2+0];
		cel.y += tpos[i*2+1];
		
		icon = DecorGetCel(cel);
		if ( type == 0 )
		{
			if ( (icon >= ICO_MURHAUT && icon <= ICO_MURHAUT_D) ||	/* est-ce un mur ? */
				 (icon >= ICO_MURBAS && icon <= ICO_MURBAS_D) )
			{
				newicon = tmurs[MurGetConnex(cel)];
				if ( icon <= ICO_MURHAUT_D )  newicon -= 16;		/* est-un mur haut ? */
				DecorModif(cel, newicon);
			}
		}
		if ( type == 1 )
		{
			if ( icon >= ICO_BARRIERE && icon <= ICO_BARRIERE_D )	/* est-ce une barriere ? */
			{
				DecorModif(cel, tmurs[MurGetConnex(cel)]+ICO_BARRIERE-ICO_MURBAS);
			}
		}
		if ( type == 2 )
		{
			if ( icon >= ICO_VITRE && icon <= ICO_VITRE_D )			/* est-ce une vitre ? */
			{
				DecorModif(cel, tmurs[MurGetConnex(cel)]+ICO_VITRE-ICO_MURBAS);
			}
		}
	}
}


/* --------- */
/* BoisBuild */
/* --------- */

/*
	Met un tas de bois sur une cellule.
 */

void BoisBuild (Pt cel)
{
	short		icon, newb, flag;
	Pt			voisin;
	
	/*	Cherche l'orientation du nouveau tas de bois a poser. */
	
	icon = DecorGetCel(cel);
	if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_EO )
	{
		if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_NS )  newb = ICO_BOIS2_EO;
		else                                                 newb = ICO_BOIS2_NS;
	}
	else
	{
		newb = ICO_BOIS2_NS;
		
		voisin.x = cel.x + 1;
		voisin.y = cel.y;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )  newb = ICO_BOIS2_EO;
		
		voisin.x -= 2;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )  newb = ICO_BOIS2_EO;
	}
	
	/*	Modifie les extremites des tas de bois. */
	
	if ( newb == ICO_BOIS2_EO )
	{
		flag = 0;
		
		voisin.x = cel.x + 1;
		voisin.y = cel.y;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )
		{
			flag |= 1<<0;
			voisin.x ++;
			icon = DecorGetCel(voisin);
			voisin.x --;
			if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )
			{
				DecorModif(voisin, ICO_BOIS2_EO);
			}
			else
			{
				DecorModif(voisin, ICO_BOIS3_EO);
			}
		}
		
		voisin.x = cel.x - 1;
		voisin.y = cel.y;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )
		{
			flag |= 1<<1;
			voisin.x --;
			icon = DecorGetCel(voisin);
			voisin.x ++;
			if ( icon >= ICO_BOIS1_EO && icon <= ICO_BOIS3_EO )
			{
				DecorModif(voisin, ICO_BOIS2_EO);
			}
			else
			{
				DecorModif(voisin, ICO_BOIS1_EO);
			}
		}
		
		if ( flag == (1<<0) )  newb = ICO_BOIS1_EO;
		if ( flag == (1<<1) )  newb = ICO_BOIS3_EO;
		DecorModif(cel, newb);
	}
	else
	{
		flag = 0;
		
		voisin.x = cel.x;
		voisin.y = cel.y + 1;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_NS )
		{
			flag |= 1<<0;
			voisin.y ++;
			icon = DecorGetCel(voisin);
			voisin.y --;
			if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_NS )
			{
				DecorModif(voisin, ICO_BOIS2_NS);
			}
			else
			{
				DecorModif(voisin, ICO_BOIS1_NS);
			}
		}
		
		voisin.x = cel.x;
		voisin.y = cel.y - 1;
		icon = DecorGetCel(voisin);
		if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_NS )
		{
			flag |= 1<<1;
			voisin.y --;
			icon = DecorGetCel(voisin);
			voisin.y ++;
			if ( icon >= ICO_BOIS1_NS && icon <= ICO_BOIS3_NS )
			{
				DecorModif(voisin, ICO_BOIS2_NS);
			}
			else
			{
				DecorModif(voisin, ICO_BOIS3_NS);
			}
		}
		
		if ( flag == (1<<0) )  newb = ICO_BOIS3_NS;
		if ( flag == (1<<1) )  newb = ICO_BOIS1_NS;
		DecorModif(cel, newb);
	}
}


/* ----------- */
/* IfCelValide */
/* ----------- */

/*
	Verifie s'il est possible d'agir dans une cellule donnee avec
	un outil donne.
	Retourne 1 si c'est possible (cellule valide).
 */

short IfCelValide (Pt cel, short outil)
{
	short	obstacle, obnext, solmax;
	
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )  return 0;
	
	if ( typejeu == 1 )						/* jeu avec toto telecommande par le joueur ? */
	{
		if ( DecorGetCel(cel) == -1 )  return 0;
		return 1;
	}
	
	obstacle = MoveGetCel(cel);
	if ( obstacle != 0 && obstacle != 2 )  return 0;	/* retourne si y'a un toto ici */
	
	obstacle = DecorGetCel(cel);
	
	if ( typeedit )  solmax = ICO_SOLMAX;
	else             solmax = ICO_SOLOBJET;
	
	if ( outil == ICO_OUTIL_TRACKS )		/* tracks ? */
	{
		if ( typeedit )  return 1;			/* en edition, le tracks peut tout detruire */
		if ( obstacle < ICO_BLOQUE ||
			 obstacle == ICO_ARRIVEE )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_TRACKSBAR )		/* tracks barriere ? */
	{
		if ( obstacle >= ICO_BARRIERE &&
			 obstacle <= ICO_BARRIERE_D )  return 1;
		return 0;
	}
	
	if ( outil == ICO_OUTIL_SOLCARRE   ||	/* sol pendant l'edition ? */
		 outil == ICO_OUTIL_SOLPAVE    ||
		 outil == ICO_OUTIL_SOLDALLE1  ||
		 outil == ICO_OUTIL_SOLDALLE2  ||
		 outil == ICO_OUTIL_SOLDALLE3  ||
		 outil == ICO_OUTIL_SOLDALLE4  ||
		 outil == ICO_OUTIL_SOLDALLE5  ||
		 outil == ICO_OUTIL_SOLELECTRO ||
		 outil == ICO_OUTIL_SOLOBJET   ||
		 outil == ICO_OUTIL_INVINCIBLE )
	{
		return 1;
	}
	
	/*	Refuse de faire autre chose si on est juste sur la case
		d'arrivee a cote de l'ascenseur. */
	
	if ( outil != ICO_OUTIL_UNSEUL )
	{
		cel.x --;
		obnext = DecorGetCel(cel);
		cel.x ++;
		if ( obnext == ICO_DEPART      ||
			 obnext == ICO_DEPARTOUV+0 ||
			 obnext == ICO_DEPARTOUV+1 ||
			 obnext == ICO_DEPARTOUV+2 )  return 0;
	}
	
	if ( outil == ICO_OUTIL_ARRIVEE  ||		/* ballon ? */
		 outil == ICO_OUTIL_JOUEUR   ||		/* toto pour joueur ? */
		 outil == ICO_OUTIL_AIMANT   ||		/* aimant ? */
		 outil == ICO_OUTIL_TROU     ||		/* trou ? */
		 outil == ICO_OUTIL_GLISSE   ||		/* glisse ? */
		 outil == ICO_OUTIL_BARRIERE ||		/* barriere ? */
		 outil == ICO_OUTIL_VITRE    ||		/* vitre ? */
		 outil == ICO_OUTIL_VISION   ||		/* lunettes ? */
		 outil == ICO_OUTIL_LIVRE    ||		/* livre ? */
		 outil == ICO_OUTIL_BAISSE   ||		/* porte electronique ? */
		 outil == ICO_OUTIL_UNSEUL   ||		/* un seul toto ? */
		 outil == ICO_OUTIL_MAGIC )			/* chapeau de magicien ? */
	{
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_DEPART )
	{
		if ( obstacle >= solmax )  return 0;
		cel.x ++;
		obnext = DecorGetCel(cel);
		cel.x --;
		if ( obnext < 0 || obnext >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_BOIT )			/* table avec boisson ? */
	{
		if ( typeedit &&
			 (obstacle == ICO_TABLEBOIT ||
			  obstacle == ICO_TABLEPOISON) )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_MUR )			/* mur ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_MURHAUT &&
			 obstacle <= ICO_MURHAUT_D )  return 1;
		if ( typeedit &&
			 obstacle >= ICO_MURBAS &&
			 obstacle <= ICO_MURBAS_D )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_BOIS )			/* tas de bois ? */
	{
		if ( obstacle >= ICO_BOIS1_NS &&
			 obstacle <= ICO_BOIS3_EO )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_PLANTE ||		/* fleur ? */
		 outil == ICO_OUTIL_PLANTEBAS )		/* fleur basse ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_PLANTEBAS &&
			 obstacle <= ICO_PLANTEHAUT_D )  return 1;
		if ( obstacle >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_TANK )			/* tank ? */
	{
		if ( (obstacle >= ICO_TANK_E &&
			  obstacle <= ICO_TANK_S) ||
			 obstacle == ICO_TANK_X   ||
			 obstacle == ICO_TANK_EO  ||
			 obstacle == ICO_TANK_NS  )  return 1;
		if ( obstacle >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_ELECTRO ||		/* electronique ? */
		 outil == ICO_OUTIL_ELECTROBAS )	/* electronique basse ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_ELECTROBAS &&
			 obstacle <= ICO_ELECTROHAUT_D )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_TECHNO )		/* techno ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_TECHNO1 &&
			 obstacle <= ICO_TECHNO1_D )  return 1;
		if ( typeedit &&
			 obstacle >= ICO_TECHNO2 &&
			 obstacle <= ICO_TECHNO2_D )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_OBSTACLE )		/* obstacle ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_OBSTACLE &&
			 obstacle <= ICO_OBSTACLE_D )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_MEUBLE )		/* meuble ? */
	{
		if ( typeedit &&
			 obstacle >= ICO_MEUBLE &&
			 obstacle <= ICO_MEUBLE_D )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_SENSUNI )		/* sens-unique ? */
	{
		if ( obstacle >= ICO_SENSUNI_S &&
			 obstacle <= ICO_SENSUNI_O )  return 1;
		if ( obstacle >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_CAISSE )		/* caisse ? */
	{
		if ( obstacle == ICO_CAISSE  ||
			 obstacle == ICO_CAISSEV ||
			 obstacle == ICO_CAISSEO ||
			 obstacle == ICO_CAISSEG )  return 1;
		if ( obstacle >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_ACCEL )			/* accelerateur ? */
	{
		if ( obstacle >= ICO_ACCEL_S &&
			 obstacle <= ICO_ACCEL_O )  return 1;
		if ( obstacle >= solmax )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_PORTE )			/* porte ? */
	{
		if ( obstacle >= ICO_PORTEF_EO  &&
			 obstacle <  ICO_PORTEF_EO+6 )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_CLE )			/* cle ? */
	{
		if ( obstacle >= ICO_CLE_A  &&
			 obstacle <= ICO_CLE_C )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_DETONATEUR )	/* detonateur ? */
	{
		if ( obstacle >= ICO_DETONATEUR_A  &&
			 obstacle <= ICO_DETONATEUR_C )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	if ( outil == ICO_OUTIL_BOMBE )			/* bombe ? */
	{
		if ( obstacle >= ICO_BOMBE_A  &&
			 obstacle <= ICO_BOMBE_C )  return 1;
		if ( obstacle >= solmax &&
			 obstacle != ICO_BAISSEBAS  &&
			 obstacle != ICO_CAISSEBAS  &&
			 obstacle != ICO_CAISSEVBAS &&
			 obstacle != ICO_CAISSEOBAS &&
			 obstacle != ICO_CAISSEGBAS )  return 0;
		return 1;
	}
	
	return 0;
}


/* ---------- */
/* GetCelMask */
/* ---------- */

/*
	Donne le masque correspondant a une cellule.
 */

void GetCelMask (Pixmap *ppm, Pt cel)
{
	Pixmap	pm;
	Pixmap	pmfront = {0,0,0,0,0,0,0};
	Pt		dst;
	Pt		p;
	short	icon;
	
	if ( typejeu == 1 )
	{
		GetIcon(&pm, ICO_CELARROWS, 1);		/* quadruple fleche */
		DuplPixel(&pm, ppm);
		return;
	}
	
	GetPixmap(ppm, (p.y=LYICO, p.x=LXICO, p), 0, 0);
	
	GetIcon(&pm, ICO_SOL+ICOMOFF, 1);		/* masque pour le sol */
	DuplPixel(&pm, ppm);
	
	icon = DecorGetCel(cel);
	if ( icon >= ICO_BLOQUE || icon == ICO_DEPART )	/* obstacle en hauteur ? */
	{
		GetIcon(&pm, icon+ICOMOFF, 1);
		CopyPixel							/* ajoute le masque en hauteur */
		(
			&pm, (p.y=0, p.x=0, p),
			ppm, (p.y=0, p.x=0, p),
			(p.y=LYICO, p.x=LXICO, p), MODEOR
		);
	}
	
	dst = CelToGra(cel);
	dst.x += PLXICO*ovisu.x;
	dst.y += PRYICO*ovisu.y;
	
	icon = pmonde->tmonde[cel.y][cel.x];
	pmonde->tmonde[cel.y][cel.x] = ICO_SOL;
	DecorIconMask(&pmfront, dst, 0, cel);	/* calcule le masque de devant */
	pmonde->tmonde[cel.y][cel.x] = icon;
	
	CopyPixel								/* masque selon les decors places devant */
	(
		&pmfront, (p.y=0, p.x=0, p),
		ppm, (p.y=0, p.x=0, p),
		(p.y=LYICO, p.x=LXICO, p), MODEAND
	);
	
	GivePixmap(&pmfront);
}


/* =========== */
/* DecorDetCel */
/* =========== */

/*
	Detecte la cellule contenant l'objet du decor montre par la souris.
	Cherche si le point montre vise une partie haute du decor placee devant
	la base cliquee, en construisant les masques des cellules pouvant
	masquer le sol de la cellule de base.
	La table[] donne les coordonnees relatives des cellules succeptibles
	de masquer l'objet place dans la cellule (0;0), depuis la plus en
	avant jusqu'a la plus en arriere.
	Voir l'explication de cette table[] dans IMASK.IMAGE !
 */

Pt DecorDetCel (Pt pos)
{
	Pixmap		pmmask  = {0,0,0,0,0,0,0};
	Pt			cel, c;
	Pt			p;
	Pt			posbase, posfront;
	short		i = 0;
	short		icon;
	char		color;
	
	static char table[] =
	{
		 2,  3,
		 1,  3,
		 3,  2,
		 2,  2,
		 1,  2,
		 0,  2,
		 2,  1,
		 1,  1,
		 0,  1,
		 1,  0,
		-100
	};
	
	if ( typejeu == 1 )
	{
		return GraToCel(pos);			/* detection "transparente" */
	}
	
	cel = GraToCel(pos);				/* calcule la cellule montree par la souris */
	if ( cel.x < 0 || cel.x >= MAXCELX ||
		 cel.y < 0 || cel.y >= MAXCELY )
	{
		cel.x = -1;
		cel.y = -1;
		return cel;
	}
	posbase = CelToGra(cel);
	posbase.x += PLXICO*ovisu.x;
	posbase.y += PRYICO*ovisu.y;
	pos.x -= POSXDRAW + posbase.x;
	pos.y -= POSYDRAW + posbase.y;		/* position relative dans l'icone de base */
	
	while ( table[i] != -100 )
	{
		c.x = cel.x + table[i+0];
		c.y = cel.y + table[i+1];
		
		icon = DecorGetCel(c);
		if ( icon >= ICO_BLOQUE || icon == ICO_DEPART )	/* cellule contenant un decor en hauteur ? */
		{
			GetCelMask(&pmmask, c);
			
			posfront = CelToGra(c);
			posfront.x += PLXICO*ovisu.x;
			posfront.y += PRYICO*ovisu.y;
			p = pos;
			p.x -= posfront.x - posbase.x;
			p.y -= posfront.y - posbase.y;
			color = GetPixel(&pmmask, p);
			if ( color > 0 )			/* point vise ? */
			{
				cel = c;				/* oui -> retourne cette cellule */
				break;
			}
		}
		
		i += 2;
	}
	GivePixmap(&pmmask);
	return cel;
}


/* ------ */
/* InvCel */
/* ------ */

/*
	Inverse rapidement une cellule.
 */

void InvCel (Pt cel, short outil)
{
	Pixmap		pmmask  = {0,0,0,0,0,0,0};
	Pt			src, dst, dim;
	short		give;
	
	if ( IfCelValide(cel, outil) )
	{
		GetCelMask(&pmmask, cel);
		give = 1;
	}
	else
	{
		GetIcon(&pmmask, ICO_CROIX, 1);		/* croix */
		give = 0;
	}
	
	src.x  = 0;
	src.y  = 0;
	dst    = CelToGra(cel);
	dst.x += POSXDRAW + PLXICO*ovisu.x;
	dst.y += POSYDRAW + PRYICO*ovisu.y;
	dim.x  = LXICO;
	dim.y  = LYICO;

	if ( dst.x < POSXDRAW )					/* depasse a gauche ? */
	{
		dim.x -= POSXDRAW-dst.x;
		if ( dim.x <= 0 )  return;
		src.x += POSXDRAW-dst.x;
		dst.x = POSXDRAW;
	}
	if ( dst.x+dim.x > POSXDRAW+DIMXDRAW )	/* depasse a droite ? */
	{
		dim.x -= dst.x+dim.x - (POSXDRAW+DIMXDRAW);
		if ( dim.x <= 0 )  return;
	}
	if ( dst.y < POSYDRAW )					/* depasse en haut ? */
	{
		dim.y -= POSYDRAW-dst.y;
		if ( dim.y <= 0 )  return;
		src.y += POSYDRAW-dst.y;
		dst.y = POSYDRAW;
	}
	if ( dst.y+dim.y > POSYDRAW+DIMYDRAW )	/* depasse en bas ? */
	{
		dim.y -= dst.y+dim.y - (POSYDRAW+DIMYDRAW);
		if ( dim.y <= 0 )  return;
	}
	
	CopyPixel(&pmmask, src, 0, dst, dim, MODEXOR);
	
	if ( give )  GivePixmap(&pmmask);
}


/* ----------- */
/* PutNewDecor */
/* ----------- */

/*
	Modifie une cellule du decor, en mettant un nouvel objet
	d'un type donne.
 */

short PutNewDecor (Pt cel, short min, short max, short first, short limit, short add)
{
	short		objet;
	
	objet = DecorGetCel(cel);
	if ( objet >= limit+add )  objet -= add;
	
	if ( objet >= min && objet < max )		/* y a-t-il deja un objet de ce type ici ? */
	{
		objet ++;							/* oui -> met le suivant */
		if ( objet >= max )  objet = min;
	}
	else
	{
		if ( first == 0 )
		{
			objet = GetRandom(1, min, max);	/* non -> choix zo zazarre */
		}
		else
		{
			objet = first;
		}
	}
	
	if ( objet >= limit )  objet += add;
	
	DecorModif(cel, objet);					/* met un autre objet */
	
	return objet;
}


#if 0
/* -------------- */
/* PutUniqueDecor */
/* -------------- */

/*
	Modifie une cellule du decor en mettant un objet unique.
	Si l'objet existe deja ailleur, met un autre.
	Retourne 1 en cas d'erreur.
 */

short PutUniqueDecor (Pt cel, short icon, short max, short offset, short first)
{
	short	i, trouve, objet;
	Pt		pos;
	
	if ( offset > 0 )
	{
		objet = DecorGetCel(cel);
		if ( objet >= icon  &&
			 objet <  icon+(offset*2) )
		{
			if ( objet < icon+offset )  objet += offset;
			else                        objet -= offset;
			DecorModif(cel, objet);
			return 0;
		}
	}
	
	for ( i=0 ; i<max ; i++ )
	{
		trouve = 0;
		for ( pos.y=0 ; pos.y<MAXCELY ; pos.y++ )
		{
			for ( pos.x=0 ; pos.x<MAXCELX ; pos.x++ )
			{
				if ( icon+i        == DecorGetCel(pos) ||
					 icon+i+offset == DecorGetCel(pos) )  trouve ++;
			}
		}
		if ( trouve == 0 )
		{
			DecorModif(cel, icon+i+first);
			return 0;
		}
	}
	return 1;
}
#endif


/* ------------- */
/* SuperCelFlush */
/* ------------- */

/*
	Faudra recalculer la super cellule.
 */

void SuperCelFlush (void)
{
	superinv   = 0;
	supercel.x = -1;						/* pas de super cellule */
	supercel.y = -1;
	superpos.x = -1;						/* pas de super cellule */
	superpos.y = -1;
	
	lastpmouse.x = -1;
}

/* ------------ */
/* SuperCelClip */
/* ------------ */

/*
	Copie une icone dans le pixmap du decor, avec clipping selon la zone.
	Retourne 0 (false) s'il ne faut rien dessiner (clipping total).
 */

short SuperCelClip (Pt *ppos, Pt *pdim)
{
	if ( ppos->x < 0 )
	{
		pdim->x += ppos->x;
		ppos->x = 0;
	}
	if ( ppos->x+pdim->x > pmdecor.dx )
	{
		pdim->x -= ppos->x+pdim->x - pmdecor.dx;
	}
	if ( pdim->x <= 0 )  return 0;
	
	if ( ppos->y < 0 )
	{
		pdim->y += ppos->y;
		ppos->y = 0;
	}
	if ( ppos->y+pdim->y > pmdecor.dy )
	{
		pdim->y -= ppos->y+pdim->y - pmdecor.dy;
	}
	if ( pdim->y <= 0 )  return 0;
	
	return 1;
}

/* ----------- */
/* SuperCelSet */
/* ----------- */

/*
	Allume la super cellule dans le pixmap du decor (si necessaire).
 */

void SuperCelSet (void)
{
	Pt		p, src, dst, dim;
	Reg		rg;
	
	if ( superpos.x == -1 && superpos.y == -1 )  return;
	if ( superinv == 1 )  return;
	superinv = 1;
	
	src = superpos;
	dst.x = 0;
	dst.y = 0;
	dim.x = LXICO;
	dim.y = LYICO;
	if ( SuperCelClip(&src, &dim) )
	{
		CopyPixel							/* sauve la zone dans pmsback */
		(
			&pmdecor, src,
			&pmsback, dst,
			dim, MODELOAD
		);
	}
	
	CopyPixel								/* allume dans pmdecor */
	(
		&pmsuper, (p.y=0, p.x=0, p),
		&pmdecor, superpos,
		(p.y=LYICO, p.x=LXICO, p), MODEOR
	);
	
	rg.r.p1.x = superpos.x;
	rg.r.p1.y = superpos.y;
	rg.r.p2.x = superpos.x + LXICO;
	rg.r.p2.y = superpos.y + LYICO;
	IconDrawUpdate(rg);						/* faudra redessiner cette partie */
}

/* ------------- */
/* SuperCelClear */
/* ------------- */

/*
	Efface la super cellule dans le pixmap du decor (si necessaire).
 */

void SuperCelClear (void)
{
	Pt		src, dst, dim;
	Reg		rg;
	
	if ( superpos.x == -1 && superpos.y == -1 )  return;
	if ( superinv == 0 )  return;
	superinv = 0;
	
	src.x = 0;
	src.y = 0;
	dst = superpos;
	dim.x = LXICO;
	dim.y = LYICO;
	if ( SuperCelClip(&dst, &dim) )
	{
		CopyPixel							/* restitue la zone dans pmsback */
		(
			&pmsback, src,
			&pmdecor, dst,
			dim, MODELOAD
		);
	}
	
	rg.r.p1.x = superpos.x;
	rg.r.p1.y = superpos.y;
	rg.r.p2.x = superpos.x + LXICO;
	rg.r.p2.y = superpos.y + LYICO;
	IconDrawUpdate(rg);						/* faudra redessiner cette partie */
}


/* ============= */
/* DecorSuperCel */
/* ============= */

/*
	Indique la super cellule visee par la souris.
 */

void DecorSuperCel (Pt pmouse)
{
	Pt			cel;
	
	if ( pmouse.x == lastpmouse.x &&
		 pmouse.y == lastpmouse.y )  return;
	
	lastpmouse = pmouse;
	
	cel = DecorDetCel(pmouse);					/* calcule la cellule montree par la souris */
	
	if ( !IfCelValide(cel, PaletteGetPress()) )
	{
		cel.x = -1;
		cel.y = -1;
	}
	
	if ( cel.x == supercel.x &&
		 cel.y == supercel.y )    return;
	
	SuperCelClear();							/* efface l'ancienne super cellule */

	supercel = cel;
	if ( cel.x == -1 )
	{
		superpos.x = -1;
		superpos.y = -1;
	}
	else
	{
		GetCelMask(&pmsuper, cel);				/* calcule la masque pour inverser */
		
		superpos = CelToGra(cel);
		superpos.x += PLXICO*ovisu.x;
		superpos.y += PRYICO*ovisu.y;
	}
	
	SuperCelSet();								/* allume la nouvelle super cellule */
}


/* ========== */
/* DecorEvent */
/* ========== */

/*
	Modifie le decor en fonction d'un evenement.
	Si poscel == 0  ->	tracking selon souris
	Si poscel != 0  ->	action directe sur la cellule pos
	Retourne 0 si l'evenement a ete traite.
 */

short DecorEvent (Pt pos, short poscel, short outil)
{
	Pt		cel, new;
	short	key;
	short	init, con, first;
	
	if ( outil < 0 )  return 1;
	
	if ( poscel )  cel = pos;
	else           cel = DecorDetCel(pos);	/* calcule la cellule montree par la souris */
	
	if ( poscel == 0 &&
		 GetEvent(&pos) != KEYCLICREL )		/* si l'on a pas relache tout de suite */
	{
		IconDrawOpen();
		SuperCelClear();					/* eteint la super cellule */
		MoveRedraw();						/* redessine tous les toto */
		IconDrawClose();
	
		InvCel(cel, outil);					/* allume premiere la cellule montree */
		while ( 1 )
		{
			key = GetEvent(&pos);
			if ( key == KEYCLICREL )  break;
			new = DecorDetCel(pos);			/* calcule la cellule montree par la souris */
			if ( new.x != cel.x || new.y != cel.y )
			{
				InvCel(cel, outil);			/* eteint l'ancienne cellule montree */
				cel = new;
				InvCel(cel, outil);			/* allume la nouvelle cellule montree */
			}
		}
		InvCel(cel, outil);					/* eteint la derniere cellule montree */
	}
	if ( !IfCelValide(cel, outil) )  return 1;
	
	PaletteUseObj(outil);					/* decremente le reste a disposition */
	MoveBack(cel);							/* fait ev. un pas en arriere */
	
	if ( outil == ICO_OUTIL_TRACKS ||		/* tracks ? */
		 outil == ICO_OUTIL_TRACKSBAR )
	{
		DecorModif(cel, GetSol(cel, 1));
		if ( !typeedit )  PlaySound(SOUND_ACTION);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLCARRE )		/* sol carre ? */
	{
		DecorModif(cel, ICO_SOLCARRE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLPAVE )		/* sol pave ? */
	{
		DecorModif(cel, ICO_SOLPAVE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLDALLE1 )		/* sol dalle ? */
	{
		DecorModif(cel, ICO_SOLDALLE1);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLDALLE2 )		/* sol dalle ? */
	{
		DecorModif(cel, ICO_SOLDALLE2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLDALLE3 )		/* sol dalle ? */
	{
		DecorModif(cel, ICO_SOLDALLE3);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLDALLE4 )		/* sol dalle ? */
	{
		DecorModif(cel, ICO_SOLDALLE4);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLDALLE5 )		/* sol dalle ? */
	{
		DecorModif(cel, ICO_SOLDALLE5);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLELECTRO )	 /* sol electronique ? */
	{
		PutNewDecor(cel, ICO_SOLELECTRO, ICO_SOLELECTRO_D+1, 0, 0, 0);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SOLOBJET )		/* sol objet ? */
	{
		PutNewDecor(cel, ICO_SOLOBJET, ICO_SOLOBJET_D+1, 0, 0, 0);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_INVINCIBLE )	/* sol invincible ? */
	{
		DecorModif(cel, ICO_INVINCIBLE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_DEPART )		/* ascenseur ? */
	{
		DecorModif(cel, ICO_DEPART);
		cel.x ++;
		DecorModif(cel, ICO_SOLOBJET+1);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_JOUEUR )		/* toto pour joueur ? */
	{
		DecorModif(cel, ICO_JOUEUR);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_ARRIVEE )		/* ballon ? */
	{
		DecorModif(cel, ICO_ARRIVEE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_BAISSE )		/* porte electronique ? */
	{
		DecorModif(cel, ICO_BAISSE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_UNSEUL )		/* un seul toto ? */
	{
		DecorModif(cel, ICO_UNSEUL);
		if ( !typeedit )  PlaySound(SOUND_UNSEUL);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_AIMANT )		/* aimant ? */
	{
		DecorModif(cel, ICO_AIMANT);
		if ( !typeedit )  PlaySound(SOUND_AIMANT);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_TROU )			/* trou ? */
	{
		DecorModif(cel, ICO_TROU);
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_GLISSE )		/* peau de banane ? */
	{
		DecorModif(cel, ICO_GLISSE);
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_MUR )			/* brique ? */
	{
		MurBuild(cel, 0);					/* met un mur */
		if ( !typeedit )  PlaySound(SOUND_CAISSE);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_BARRIERE )		/* barriere ? */
	{
		MurBuild(cel, 1);					/* met une barriere */
		if ( !typeedit )  PlaySound(SOUND_SAUT2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_VITRE )			/* vitre ? */
	{
		MurBuild(cel, 2);					/* met une vitre */
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_BOIS )			/* tas de bois ? */
	{
		BoisBuild(cel);						/* met un tas de bois */
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_PLANTEBAS )		/* fleur basse ? */
	{
		PutNewDecor(cel, ICO_PLANTEBAS, ICO_PLANTEBAS_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_PLANTE )		/* fleur haute ? */
	{
		PutNewDecor(cel, ICO_PLANTEHAUT, ICO_PLANTEHAUT_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_TANK )			/* tank ? */
	{
		init = DecorGetCel(cel);
		switch ( init )
		{
			case ICO_TANK_E:  init = ICO_TANK_N;  break;
			case ICO_TANK_N:  init = ICO_TANK_O;  break;
			case ICO_TANK_O:  init = ICO_TANK_S;  break;
			case ICO_TANK_S:  init = ICO_TANK_EO; break;
			case ICO_TANK_EO: init = ICO_TANK_NS; break;
			case ICO_TANK_NS: init = ICO_TANK_X;  break;
			case ICO_TANK_X:  init = ICO_TANK_E;  break;
			default:          init = lasttank;
		}
		DecorModif(cel, init);				/* met un tank */
		lasttank = init;
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_ELECTROBAS )	/* electronique basse ? */
	{
		PutNewDecor(cel, ICO_ELECTROBAS, ICO_ELECTROBAS_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_CAISSEO);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_ELECTRO )		/* electronique haute ? */
	{
		PutNewDecor(cel, ICO_ELECTROHAUT, ICO_ELECTROHAUT_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_CAISSEO);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_TECHNO )		/* techno ? */
	{
		PutNewDecor(cel, ICO_TECHNO1, ICO_TECHNO1+10, 0, ICO_TECHNO1+5, 16-5);
		if ( !typeedit )  PlaySound(SOUND_CAISSEV);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_OBSTACLE )		/* obstacle ? */
	{
		PutNewDecor(cel, ICO_OBSTACLE, ICO_OBSTACLE_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_SAUT2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_MEUBLE )		/* meuble ? */
	{
		PutNewDecor(cel, ICO_MEUBLE, ICO_MEUBLE_D+1, 0, 0, 0);
		if ( !typeedit )  PlaySound(SOUND_SAUT2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_SENSUNI )		/* sens-unique ? */
	{
		lastsensuni = PutNewDecor(cel, ICO_SENSUNI_S, ICO_SENSUNI_O+1, lastsensuni, 0, 0);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_ACCEL )			/* accelerateur ? */
	{
		lastaccel = PutNewDecor(cel, ICO_ACCEL_S, ICO_ACCEL_O+1, lastaccel, 0, 0);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_VISION )		/* lunettes ? */
	{
		DecorModif(cel, ICO_LUNETTES);		/* met des lunettes */
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_BOIT )			/* bouteille ? */
	{
		init = DecorGetCel(cel);
		if ( init == ICO_TABLEBOIT )  init = ICO_TABLEPOISON;
		else                          init = ICO_TABLEBOIT;
		if ( !typeedit )              init = ICO_TABLEBOIT;
		DecorModif(cel, init);				/* met une table avec bouteille */
		if ( !typeedit )  PlaySound(SOUND_SAUT2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_LIVRE )			/* livre ? */
	{
		DecorModif(cel, ICO_LIVRE);			/* met un livre */
		if ( !typeedit )  PlaySound(SOUND_SAUT2);
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_CAISSE )		/* caisse ? */
	{
		init = DecorGetCel(cel);
		switch ( init )
		{
			case ICO_CAISSE:   init = ICO_CAISSEV;  break;
			case ICO_CAISSEV:  init = ICO_CAISSEO;  break;
			case ICO_CAISSEO:  init = ICO_CAISSEG;  break;
			case ICO_CAISSEG:  init = ICO_CAISSE;   break;
			default:           init = lastcaisse;
		}
		DecorModif(cel, init);				/* met une caisse */
		lastcaisse = init;
		goto termine;
	}
	
	if ( outil == ICO_OUTIL_PORTE )			/* porte ? */
	{
		init = DecorGetCel(cel);
		MurBuild(cel, 1);					/* met une barriere (modifie murs alentours) */
		DecorModif(cel, init);
		con = MurGetConnex(cel);
		first = ICO_PORTEF_EO;
		if ( con & (1<<0) && con & (1<<2) )  first = ICO_PORTEF_NS;
		PutNewDecor(cel, ICO_PORTEF_EO, ICO_PORTEF_EO+6, first, 0, 0);
		goto termine;
	}

	if ( outil == ICO_OUTIL_CLE )			/* cle ? */
	{
		PutNewDecor(cel, ICO_CLE_A, ICO_CLE_C+1, ICO_CLE_A, 0, 0);
		goto termine;
	}

	if ( outil == ICO_OUTIL_DETONATEUR )	/* detonateur ? */
	{
		PutNewDecor(cel, ICO_DETONATEUR_A, ICO_DETONATEUR_C+1, ICO_DETONATEUR_A, 0, 0);
		goto termine;
	}

	if ( outil == ICO_OUTIL_BOMBE )			/* bombe ? */
	{
		PutNewDecor(cel, ICO_BOMBE_A, ICO_BOMBE_C+1, ICO_BOMBE_A, 0, 0);
		goto termine;
	}

	if ( outil == ICO_OUTIL_MAGIC )			/* baguette magique ? */
	{
		DecorModif(cel, ICO_MAGIC);			/* met un chapeau de magicien */
		if ( !typeedit )  PlaySound(SOUND_CLIC);
		goto termine;
	}
	
	return 1;
	
	termine:
	DecorSuperCel(pos);
	cel = supercel;
	SuperCelClear();						/* eteint la super cellule */
	SuperCelFlush();						/* super cellule plus valable */
	supercel = cel;							/* ne redessine pas tout de suite ! */
	return 0;
}


/* ----------------- */
/* GetIconCaisseSSol */
/* ----------------- */

/*
	Dessine le sol sous une boule fixe en fonction du sol contenu
	dans le monde initial ou dans les cellules voisines du decor.
 */

short GetIconCaisseSSol (Pt cel)
{
	short		icon;
	
	icon = imonde[cel.y][cel.x];
	if ( icon > ICO_SOLMAX &&
		 (icon < ICO_SENSUNI_S || icon > ICO_SENSUNI_O) &&
		 (icon < ICO_PORTEO_EO || icon > ICO_PORTEO_EO+5) &&
		 (icon < ICO_ACCEL_S || icon > ICO_ACCEL_O) &&
		 icon != ICO_UNSEUL )
	{
		icon = GetSol(cel, 0);
	}
	return icon;
}


/* ========== */
/* DecorModif */
/* ========== */

/*
	Modifie une cellule dans l'image de fond pour le decor.
	La table[] donne les coordonnees relatives des cellules ayant une
	intersection avec la cellule du decor modifiee.
 */

void DecorModif (Pt cel, short newicon)
{
	static char table[] =
	{
		-2, -3,			/* cellule derriere */
		-1, -3,			/* cellule derriere */
		-3, -2,			/* cellule derriere */
		-2, -2,			/* cellule derriere */
		-1, -2,			/* cellule derriere */
		 0, -2,			/* cellule derriere */
		-2, -1,			/* cellule derriere */
		-1, -1,			/* cellule derriere */
		 0, -1,			/* cellule derriere */
		-1,  0,			/* cellule derriere */
		 0,  0,			/* cellule en question */
		 1,  0,			/* cellule devant */
		 0,  1,			/* cellule devant */
		-100
	};
	
	short		i = 0;
	short		icon;
	Pixmap		pmnewdecor = {0,0,0,0,0,0,0};
	Pixmap		pmnewmask  = {0,0,0,0,0,0,0};
	Pixmap		pmmask     = {0,0,0,0,0,0,0};
	Pixmap		pmisol, pmissol;
	Pixmap		pm;
	Pt			p, c, dst;
	Reg			rg;
	
	if ( newicon == pmonde->tmonde[cel.y][cel.x] )  return;
	pmonde->tmonde[cel.y][cel.x] = newicon;			/* modifie une cellule du monde */
	
	SuperCelClear();								/* eteint la super cellule */
	SuperCelFlush();								/* super cellule plus valable */
	MoveModifCel(cel);								/* indique cellule modifiee a move */
	
	/*	Genere dans pmnewdecor l'image de la nouvelle partie du decor,
		en redessinant toutes les cellules placees derriere. */
	
	GetPixmap(&pmnewdecor, (p.y=LYICO,p.x=LXICO,p), 1, 1);	/* noirci le pixmap du decor */
	GetIcon(&pmisol, ICO_SOL+ICOMOFF, 1);					/* demande le masque du sol */
	
	while ( table[i] != -100 )
	{
		c.x = cel.x + table[i+0];
		c.y = cel.y + table[i+1];
		
		if ( c.x >= 0 && c.y >= 0 )
		{
			if ( c.x == MAXCELX )  icon = ICO_BORDD;	/* bord droite du plateau */
			if ( c.y == MAXCELY )  icon = ICO_BORDG;	/* bord gauche du plateau */
			if ( c.x <  MAXCELX && c.y <  MAXCELY )  icon = pmonde->tmonde[c.y][c.x];
			
			dst.x = PLXICO*table[i+0] - PRXICO*table[i+1];
			dst.y = PRYICO*table[i+1] + PLYICO*table[i+0];
			
			if ( icon != ICO_BORDG && icon != ICO_BORDD )
			{
#ifdef __MSDOS__
				GetIcon(&pmisol, ICO_SOL+ICOMOFF, 1);	/* demande le masque du sol */
#endif
				CopyPixel						/* efface la surface au sol */
				(
					&pmisol, (p.y=0, p.x=0, p),
					&pmnewdecor, dst,
					(p.y=LYICO,p.x=LXICO,p), MODEAND
				);
			}
			
			if ( icon == ICO_LUNETTES || icon == ICO_MAGIC || icon == ICO_AIMANT ||
				 icon == ICO_LIVRE || icon == ICO_OBSTACLE+8 || icon == ICO_GLISSE ||
				 icon == ICO_CAISSE || icon == ICO_CAISSEV || icon == ICO_CAISSEO ||
				 icon == ICO_CAISSEG ||
				 icon == ICO_TABLEVIDE || icon == ICO_TABLEBOIT || icon == ICO_TABLEPOISON ||
				 (icon >= ICO_MEUBLE && icon < ICO_MEUBLE+16) ||
				 (icon >= ICO_TANK_E && icon <= ICO_TANK_S) ||
				 icon == ICO_TANK_X || icon == ICO_TANK_EO || icon == ICO_TANK_NS || 
				 icon == ICO_JOUEUR ||
				 (icon >= ICO_DETONATEUR_A && icon <= ICO_BOMBE_EX) )
			{
				GetIcon(&pmissol, GetIconCaisseSSol(c), 1);
				CopyPixel						/* dessine le sol sous la boule */
				(
					&pmissol, (p.y=0, p.x=0, p),
					&pmnewdecor, dst,
					(p.y=LYICO,p.x=LXICO,p), MODEOR
				);
			}
			
			GetIcon(&pm, icon+ICOMOFF, 1);
			CopyPixel							/* efface le volume en hauteur */
			(
				&pm, (p.y=0, p.x=0, p),
				&pmnewdecor, dst,
				(p.y=LYICO,p.x=LXICO,p), MODEAND
			);
			
			GetIcon(&pm, icon, 1);
			CopyPixel							/* dessine la cellule */
			(
				&pm, (p.y=0, p.x=0, p),
				&pmnewdecor, dst,
				(p.y=LYICO,p.x=LXICO,p), MODEOR
			);
		}
		
		i += 2;
	}
	
	/*	Copie la nouvelle partie du decor dans pmdecor, mais en la masquant
		au prealable par les objets pouvant etre places devant. */
	
	dst = CelToGra(cel);
	dst.x += PLXICO*ovisu.x;
	dst.y += PRYICO*ovisu.y;
	
	pmonde->tmonde[cel.y][cel.x] = ICO_SOL;
	DecorIconMask(&pmmask, dst, 0, cel);			/* calcule le masque de devant */
	pmonde->tmonde[cel.y][cel.x] = newicon;
	
	GetPixmap(&pmnewmask, (p.y=LYICO,p.x=LXICO,p), 1, 1);	/* noirci le masque pour newdecor */
	CopyPixel
	(
		&pmmask, (p.y=0, p.x=0, p),
		&pmnewmask, (p.y=0, p.x=0, p),
		(p.y=LYICO,p.x=LXICO,p), MODEAND
	);
	CopyPixel										/* efface l'emplacemant change */
	(
		&pmnewmask, (p.y=0, p.x=0, p),
		&pmdecor, dst,
		(p.y=LYICO,p.x=LXICO,p), MODEAND
	);
	
	CopyPixel
	(
		&pmmask, (p.y=0, p.x=0, p),
		&pmnewdecor, (p.y=0, p.x=0, p),
		(p.y=LYICO,p.x=LXICO,p), MODEAND
	);
	CopyPixel										/* dessine l'emplacement change */
	(
		&pmnewdecor, (p.y=0, p.x=0, p),
		&pmdecor, dst,
		(p.y=LYICO,p.x=LXICO,p), MODEOR
	);
	
	rg.r.p1.x = dst.x;
	rg.r.p1.y = dst.y;
	rg.r.p2.x = dst.x + LXICO;
	rg.r.p2.y = dst.y + LYICO;
	IconDrawUpdate(rg);								/* faudra redessiner cette partie */
	
	GivePixmap(&pmnewdecor);
	GivePixmap(&pmnewmask);
	GivePixmap(&pmmask);
	
	DecorSuperCel(lastpmouse);						/* remet la super cellule */
}



/* ============== */
/* DecorGetPixmap */
/* ============== */

/*
	Donne le pointeur au pixmap contenant le decor.
 */

Pixmap* DecorGetPixmap (void)
{
	return &pmdecor;
}


/* =============== */
/* DecorGetOrigine */
/* =============== */

/*
	Donne l'origine de la cellule visible.
 */

Pt DecorGetOrigine (void)
{
	return ovisu;
}

/* =============== */
/* DecorSetOrigine */
/* =============== */

/*
	Donne l'origine de la cellule visible.
	quick = 0	->	decalage progressif
	quick = 1	->	decalage rapide
 */

void DecorSetOrigine (Pt origine, short quick)
{
	if ( quick )
	{
		ovisu = origine;
		
		DecorMake();							/* adapte le decor */
		IconDrawAll();							/* redessine toute la fenetre */
	}
	else
	{
		while ( ovisu.x != origine.x )
		{
#ifdef __MSDOS__
			if ( ovisu.x < origine.x )  ovisu.x += 2 ;
			else                        ovisu.x -= 2;
#else
			if ( ovisu.x < origine.x )  ovisu.x ++;
			else                        ovisu.x --;

#endif
			DecorMake();						/* adapte le decor */
			IconDrawAll();						/* redessine toute la fenetre */
			
			IconDrawOpen();
			MoveRedraw();						/* redessine sans changement */
			IconDrawClose();
		}
		
		while ( ovisu.y != origine.y )
		{
#ifdef __MSDOS__
			if ( ovisu.y < origine.y )
			{
			  ovisu.y += 3;
			  if (ovisu.y > origine.y)
				ovisu.y = origine.y ;
			}
			else
			{
			  ovisu.y -= 3;
			  if (ovisu.y < origine.y)
				ovisu.y = origine.y ;
			}
#else
			if ( ovisu.y < origine.y )  ovisu.y ++;
			else                        ovisu.y --;
#endif
			
			DecorMake();						/* adapte le decor */
			IconDrawAll();						/* redessine toute la fenetre */
			
			IconDrawOpen();
			MoveRedraw();						/* redessine sans changement */
			IconDrawClose();
		}
	}
}



/* ---------- */
/* IfHideIcon */
/* ---------- */

/*
	Teste si une icone est completement cachee, c'est-a-dire
	hors de la zone rectangulaire.
	Si oui (cachee), retourne TRUE.
	Si non (visible), retourne FALSE;
 */
 
static short IfHideIcon(Pt pos, Rectangle zone)
{
	return ( pos.x+LXICO < zone.p1.x ||
			 pos.x       > zone.p2.x ||
			 pos.y+LYICO < zone.p1.y ||
			 pos.y       > zone.p2.y );
}


/* ------------- */
/* CopyIconDecor */
/* ------------- */

/*
	Copie une icone dans le pixmap du decor, avec clipping selon la zone.
 */

void CopyIconDecor (Pixmap *ppmicon, Pt pos, ShowMode mode, Rectangle zone)
{
	Pt		src, dst, dim;
	
	src.x = 0;
	src.y = 0;
	dst   = pos;
	dim.x = LXICO;
	dim.y = LYICO;
	
	if ( dst.x < zone.p1.x )				/* depasse a gauche ? */
	{
		dim.x -= zone.p1.x - dst.x;
		if ( dim.x <= 0 )  return;
		src.x += zone.p1.x - dst.x;
		dst.x = zone.p1.x;
	}
	if ( dst.x+dim.x > zone.p2.x )			/* depasse a droite ? */
	{
		dim.x -= dst.x+dim.x - zone.p2.x;
		if ( dim.x <= 0 )  return;
	}
	if ( dst.y < zone.p1.y )				/* depasse en haut ? */
	{
		dim.y -= zone.p1.y - dst.y;
		if ( dim.y <= 0 )  return;
		src.y += zone.p1.y - dst.y;
		dst.y = zone.p1.y;
	}
	if ( dst.y+dim.y > zone.p2.y )			/* depasse en bas ? */
	{
		dim.y -= dst.y+dim.y - zone.p2.y;
		if ( dim.y <= 0 )  return;
	}
	
	CopyPixel(ppmicon, src, &pmdecor, dst, dim, mode);
}


/* ========= */
/* DecorMake */
/* ========= */

/*
	Fabrique l'image de fond pour le decor.
 */

void DecorMake (void)
{
	Pixmap		pmisol, pmissol, pmichair, pmimask;
	Rectangle	zone;
	short		lasti = -1;
	Pt			shift;
	Pt			pv, ph;
	Pt			cel;
	short		i, j, icon;
	
	SuperCelClear();								/* eteint la super cellule */
	SuperCelFlush();								/* super cellule plus valable */
	
	/*	Si c'est possible, decale une partie du contenu actuel de pmdecor
		pour n'avoir a redessiner plus que la partie effectivement
		changee, c'est-a-dire decouverte. */
	
	zone.p1.x = 0;
	zone.p1.y = 0;
	zone.p2.x = DIMXDRAW;
	zone.p2.y = DIMYDRAW;
	
	if ( lastovisu.x < 10000 )
	{
		shift.x = PLXICO*lastovisu.x - PLXICO*ovisu.x;
		shift.y = PRYICO*lastovisu.y - PRYICO*ovisu.y;
		ScrollPixel(&pmdecor, shift, COLORNOIR, &zone);
	}
	
	lastovisu = ovisu;			/* memorise l'origine actuelle */
	
	/*	Met a jour le decor dans pmdecor correspondant a la zone decouverte. */
	
	GetIcon(&pmisol, ICO_SOL+ICOMOFF, 1);			/* demande le masque du sol */
	
	pv.x = PLXICO*ovisu.x;
	pv.y = PRYICO*ovisu.y;
	for ( i=0 ; i<=MAXCELY ; i++ )
	{
		ph = pv;
		for ( j=0 ; j<=MAXCELX ; j++ )
		{
			if ( j == MAXCELX && i == MAXCELY )  return;
			if ( j == MAXCELX )  icon = ICO_BORDD;	/* bord droite du plateau */
			if ( i == MAXCELY )  icon = ICO_BORDG;	/* bord gauche du plateau */
			if ( j <  MAXCELX && i <  MAXCELY )  icon = pmonde->tmonde[i][j];
			
			if ( !IfHideIcon(ph, zone) )
			{
				if ( icon != ICO_BORDG && icon != ICO_BORDD )
				{
#ifdef __MSDOS__
					GetIcon(&pmisol, ICO_SOL+ICOMOFF, 1);	/* demande le masque du sol */
#endif
					CopyIconDecor(&pmisol, ph, MODEAND, zone);	/* efface la surface au sol */
				}
#ifndef __MSDOS__
				if ( icon != lasti )
#endif
				{
					lasti = icon;
					if ( icon >= ICO_BLOQUE || icon == ICO_DEPART ||
						 icon == ICO_BORDG  || icon == ICO_BORDD  ||
						 icon == ICO_GLISSE )
					{
						GetIcon(&pmimask, icon+ICOMOFF, 1);
					}
					GetIcon(&pmichair, icon, 1);
				}
				if ( icon == ICO_LUNETTES || icon == ICO_MAGIC || icon == ICO_AIMANT ||
					 icon == ICO_LIVRE || icon == ICO_OBSTACLE+8 || icon == ICO_GLISSE ||
					 icon == ICO_CAISSE || icon == ICO_CAISSEV || icon == ICO_CAISSEO ||
					 icon == ICO_CAISSEG ||
					 icon == ICO_TABLEVIDE || icon == ICO_TABLEBOIT || icon == ICO_TABLEPOISON ||
					 (icon >= ICO_MEUBLE && icon < ICO_MEUBLE+16) ||
					 (icon >= ICO_TANK_E && icon <= ICO_TANK_S) ||
					 icon == ICO_TANK_X || icon == ICO_TANK_EO || icon == ICO_TANK_NS || 
					 icon == ICO_JOUEUR ||
					 (icon >= ICO_DETONATEUR_A && icon <= ICO_BOMBE_EX) )
				{
					cel.x = j;
					cel.y = i;
					GetIcon(&pmissol, GetIconCaisseSSol(cel), 1);
					CopyIconDecor(&pmissol, ph, MODEOR, zone);	/* dessine le sol sous la boule */
				}
				if ( icon >= ICO_BLOQUE || icon == ICO_DEPART ||
					 icon == ICO_BORDG  || icon == ICO_BORDD  ||
					 icon == ICO_GLISSE )
				{
					CopyIconDecor(&pmimask, ph, MODEAND, zone);	/* efface le volume en hauteur */
				}
				CopyIconDecor(&pmichair, ph, MODEOR, zone);		/* dessine la cellule */
			}
			ph.x += PLXICO;
			ph.y += PLYICO;
			if ( ph.x > zone.p2.x )  break;
		}
		pv.x -= PRXICO;
		pv.y += PRYICO;
		if ( pv.y > zone.p2.y )  break;
	}
	
	DecorSuperCel(lastpmouse);		/* remet la super cellule */
}




/* ============= */
/* DecorNewMonde */
/* ============= */

/*
	Initialise un nouveau monde.
	Retourne 0 si tout est en ordre.
 */

short DecorNewMonde (Monde *pm)
{
	short		x, y;
	
	pmonde = pm;
	
	for ( y=0 ; y<MAXCELY ; y++ )
	{
		for ( x=0 ; x<MAXCELX ; x++ )
		{
			imonde[y][x] = pmonde->tmonde[y][x];
		}
	}
	
	ovisu.x = 4;
	ovisu.y = -10;
	lastovisu.x = 10000;					/* le contenu de pmdecor est vide */
	lastpmouse.x = -1;
	
	SuperCelFlush();
	
	MoveNewMonde(pmonde->freq);				/* qq initialisations dans move */
	
	return 0;
}




/* ========= */
/* DecorOpen */
/* ========= */

/*
	Ouverture des decors.
 */

short DecorOpen (void)
{
	Pt			p;
	short		err;
	
	err = GetPixmap(&pmdecor, (p.y=DIMYDRAW,p.x=DIMXDRAW,p), 1, 1);
	if ( err )  return err;
	
	err = GetPixmap(&pmsuper, (p.y=LYICO,p.x=LXICO,p), 0, 1);
	if ( err )  return err;
	
	err = GetPixmap(&pmsback, (p.y=LYICO,p.x=LXICO,p), 0, 1);
	if ( err )  return err;
	
	lastsensuni = 0;
	lastaccel   = 0;
	lastcaisse  = ICO_CAISSE;
	lasttank    = ICO_TANK_E;
	
	return 0;
}

/* ========== */
/* DecorClose */
/* ========== */

/*
	Fermeture des decors.
 */

void DecorClose (void)
{
	GivePixmap(&pmdecor);
	GivePixmap(&pmsuper);
	GivePixmap(&pmsback);
}




/* ============= */
/* DecorPartieLg */
/* ============= */

/*
	Retourne la longueur necessaire pour sauver les variables de la partie en cours.
 */

long DecorPartieLg (void)
{
	return 
		sizeof(short)*MAXCELY*MAXCELX +
		sizeof(Partie);
}


/* ================ */
/* DecorPartieWrite */
/* ================ */

/*
	Sauve les variables de la partie en cours.
 */

short DecorPartieWrite (long pos, char file)
{
	short		err;
	Partie		partie;
	
	err = FileWrite(&imonde, pos, sizeof(short)*MAXCELY*MAXCELX, file);
	if ( err )  return err;
	pos += sizeof(short)*MAXCELY*MAXCELX;
	
	partie.ovisu = ovisu;
	
	err = FileWrite(&partie, pos, sizeof(Partie), file);
	return err;
}


/* =============== */
/* DecorPartieRead */
/* =============== */

/*
	Lit les variables de la partie en cours.
 */

short DecorPartieRead (long pos, char file)
{
	short		err;
	Partie		partie;
	Pt			p;
	
	err = FileRead(&imonde, pos, sizeof(short)*MAXCELY*MAXCELX, file);
	if ( err )  return err;
	pos += sizeof(short)*MAXCELY*MAXCELX;
	
	err = FileRead(&partie, pos, sizeof(Partie), file);
	if ( err )  return err;
	
	ovisu = partie.ovisu;
	
	err = GetPixmap(&pmdecor, (p.y=DIMYDRAW,p.x=DIMXDRAW,p), 1, 1);
	if ( err )  return err;
	
	lastovisu.x = 10000;					/* le contenu de pmdecor est vide */
	SuperCelFlush();						/* plus de super cellule valide */
	DecorMake();							/* refabrique le decor */
	IconDrawAll();							/* redessine toute la fenetre */

	return 0;
}

