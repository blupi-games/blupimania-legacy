#include <dos.h>
#include "..\bprotect\protect.h"
#include "..\bprotect\protecti.h"

static char protect_mark[] = PROTECT_MARK ;
static unsigned int protect_id = 12345 ;


unsigned int calc_protect_id (void)
{
   unsigned char *p = MK_FP(0xfc00, 0);
   unsigned int i ;

   unsigned int check = 0 ;

   for (i = 0; i <= 0x300; i++)
   {
     check += *p++ ;
   }

   return check ;
}


int test_new_protection (void)
{
#if 1
 // return 1 ;    /** VERSION SHAREWARE **/
  return 0 ;    /** version commerciale **/

  return (protect_id == 12345) ;
#else
  return (calc_protect_id () != protect_id) ;
#endif
}


