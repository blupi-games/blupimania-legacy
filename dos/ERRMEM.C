
#include <stdio.h>
#include <alloc.h>
#include "..\blang\_lang.h"


void errmem (long supp, long min)
{
#ifdef FRENCH
   printf("Vous n'avez pas assez de mÇmoire conventionnelle pour dÇmarrer\n"
	   "ce programme. Vous avez actuellement %ld octets de mÇmoire\n"
	   "conventionnelle de libre, et vous avez besoin d'au moins %ld octets\n"
	   "de mÇmoire conventionnelle libre.\n", supp + farcoreleft (), min) ;
#endif

#ifdef GERMAN
   printf ("Sie haben nicht genug Speicherplatz, um dieses Program zu starten.\n"
	   "Zur Zeit stehen Ihnen %ld Bytes freier konventioneller Speicher zur\n"
	   "VerfÅgung. Sie benîtigen aber mindestens %ld Bytes freien\n"
	   "konventionellen Speicher\n", supp + farcoreleft (), min) ;
#endif

#ifdef ENGLISH
   printf("Youn don't have enough free conventional memory for this program.\n"
	  "You have %ld bytes of free conventional memory and you need at\n"
	  "least %ld bytes of free conventional memory.", supp + farcoreleft (), min) ;
#endif


    exit(3);
}
