
#ifdef __MSDOS__

void convshort (unsigned short *s)
{
  char t ;
  char *p = (char*)s ;

  t = p[0] ;
  p[0] = p[1] ;
  p[1] = t ;
}

void ConvMonde (Monde *m)
{
  int i,j ;

  for (i = 0 ; i < MAXCELX ; i++)
    for (j = 0 ; j < MAXCELY ; j++)
      convshort (&m->tmonde[j][i]) ;

  for (i = 0 ; i < MAXPALETTE; i++)
    convshort (&m->palette[i]) ;

  convshort (&m->freq) ;
  convshort (&m->color) ;
}

#endif

/* --------- */
/* MondeRead */
/* --------- */

/*
	Lit un nouveau monde sur le disque.
	Retourne 0 si la lecture est ok.
 */

short MondeRead (short monde, char banque)
{
	short           err = 0;
	short           max;
	
	if ( construit )  max = maxmonde-1;
	else              max = maxmonde;
	
	if ( monde >= max )  goto vide;
	
	err = FileRead(&descmonde, monde*sizeof(Monde), sizeof(Monde), BanqueToFile(banque));
	if ( err )
	{
		maxmonde = 0;
		goto vide;
	}
#ifdef __MSDOS__
	ConvMonde (&descmonde) ;
#endif
	return 0;
	
	vide:
	MondeVide();            /* retourne un monde vide */
	return err;
}


/* ---------- */
/* MondeWrite */
/* ---------- */

/*
	Ecrit un monde sur le disque.
	Retourne 0 si l'‚criture est ok.
 */

short MondeWrite (short monde, char banque)
{
	short           err;

#ifdef __MSDOS__
	ConvMonde (&descmonde) ;
#endif
	err = FileWrite(&descmonde, monde*sizeof(Monde), sizeof(Monde), BanqueToFile(banque));
#ifdef __MSDOS__
	ConvMonde (&descmonde) ;
#endif
	MondeMax(banque);
	
	return err;
}

