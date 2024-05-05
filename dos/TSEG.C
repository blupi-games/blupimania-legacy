#define MK_FP(seg,ofs)	((void _seg *)(seg) + (void near *)(ofs))
#define FP_SEG(fp)      ((unsigned)(void _seg *)(void far *)(fp))
#define FP_OFF(fp)      ((unsigned)(fp))



main ()
{
  char huge *p = MK_FP (0xa000,0x2000) ;
  unsigned short s,o ;

  long l ;

  char *q = MK_FP (FP_SEG (p) , FP_OFF(p)) ;

  printf ("\np = %p, %lx\nq = %p\n", p,p,q) ;

  s = FP_SEG (p) ;
  o = (short)FP_OFF (p) ;


  printf ("o = %x\n") ;
  l = (unsigned long)(s)<< 4 + o ;

  printf ("l = %lx\n", l) ;

  for (l = 0 ; l < 10 ; l++)
  {
    p += 30000 ;
    printf ("%p\n", p) ;
  }

  getch () ;
  
}