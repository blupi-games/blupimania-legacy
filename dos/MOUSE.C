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