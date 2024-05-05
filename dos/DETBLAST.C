

#include <stdlib.h>
#include "detblast.h"



/*
 * Parse BLASTER environment variable
 */

int DetectBlaster(WORD *port, BYTE *irq, BYTE *dma, BYTE *type)
{
    const char *blaster = getenv("BLASTER");


    if (blaster == NULL)
    {
      blaster = getenv("SBMODE") ;
      if (blaster == NULL)
	return 0;
    }

    while (*blaster)
    {
	char *endpos = NULL;
	long value;

	switch (*blaster++)
	{
	    case 'A':	// base I/O address
		value = strtol(blaster, &endpos, 16);
		if (port) *port = value;
		break;
	    case 'I':	// IRQ number
		value = strtol(blaster, &endpos, 0);
		if (irq) *irq = value;
		break;
	    case 'D':	// DMA number
		value = strtol(blaster, &endpos, 0);
		if (dma) *dma = value;
		break;
	    case 'T':	// card type
		value = strtol(blaster, &endpos, 0);
		if (type) *type = value;
		break;
	    // ignore anything else (spaces, ...)
	}
	if (endpos)
	    blaster = endpos;
    }
    return 1;
}
