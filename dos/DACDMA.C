/* Output to SB DAC using DMA mode (up to 64K only) */

#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <io.h>
#include <alloc.h>
#include <stdlib.h>

#include "sb.h"
#include "blpinfo.h"
#include "sndparams.h"

extern struct blpinfo blpinfo ;



static int sound_is_on ;

static void myhandler (void)
{
//   printf ("*") ;

  sound_is_on = 0 ;
}




static unsigned char far *aligned ;
static unsigned char far *raw = NULL ;
static unsigned long lggasp ;


char *dmagap_memory (void)
{
  return raw ;
}

int dmagap_length (void)
{
  if (lggasp < 100)
    return 0 ;

  return lggasp - 10 ;
}


static int haveblaster ;


int have_soundblaster ()
{
  return haveblaster ;
}


int putsbinfo ()
{
  if (blpinfo.sbadr != 0)
  {
    SbIOaddr = blpinfo.sbadr ;
    SbIRQ = blpinfo.sbirq ;
    SbDMAchan = blpinfo.sbdma ;
    return 0 ;
  }
  else
    return 1 ;
}

int init_sound ()
{
    unsigned long freemem ;
    signed char far *test ;
    unsigned long physical, aligned_physical;

    printf ("Looking for Soundboard.\n") ;

    if (blpinfo.sbtype == -1)
    {
      if(!DetectBlaster (&SbIOaddr, &SbIRQ, &SbDMAchan, NULL))
      {
	printf ("BLASTER environment variable not set.\n");
      }
    }

    if (blpinfo.sbtype == 0 || blpinfo.sbtype == 1)
    {
      printf ("SB not selected.\n") ;
      return 1 ;
    }
    putsbinfo () ;


//    Sb_Install_handler (myhandler) ;

    if (Sb_Init ())
    {
	printf("Could not find Soundblaster!\n");
	return 1 ;
    }

    haveblaster = 1 ;

    printf("Soundblaster at address %xh, IRQ %d, DMA %d.\n",
	SbIOaddr,SbIRQ,SbDMAchan);

    freemem = farcoreleft () ;
    test = farmalloc (freemem - 100) ;
    farfree (test) ;

    physical = ((unsigned long)FP_OFF(test)) + (((unsigned long)FP_SEG(test)) << 4);
    aligned_physical = physical+0x0FFFFL;
    aligned_physical &= 0xF0000L;
    aligned=MK_FP((unsigned )((aligned_physical >> 4) & 0xFFFF),0);
    lggasp = aligned_physical - physical ;


    raw = (signed char far *)farmalloc(lggasp + SND_MAXSL + 100);

    printf ("Sound DMA buffer allocated at %p.\n", aligned) ;
    printf ("Gaplen = %ld.\n", lggasp) ;

	Sb_Voice(1);
	Sb_Init_Voice_DMA(NULL);   /* Use default interrupt handler */
	return 0 ;
}



void uninit_sound ()
{
  if (haveblaster)
  {
	Sb_Voice (0) ;
	Sb_DeInit_Voice_DMA();
  }
}



/* termine un son */

void end_sound ()
{
  if (haveblaster)
  {
    Sb_Halt_DMA();
    Sb_Init(); /* Necessary after early termination of a high-speed xfer */
  }
}



static int dacvolume = 100 ;

static int dacvolume ;

void setdacvolume (int num)
{
  dacvolume = num ;
}



static void setvolume (int len)
{
  unsigned char *p = aligned ;
  unsigned int i ;
  int sample ;

  for (i = 0 ; i < len ; i++)
  {
    sample = p[i] - 128 ;
    sample = (dacvolume * sample) / 100 ;
    p[i] = sample + 128 ;
  }
}

void playsoundblast (int num)
{
    static char lastname[20] ;

    FILE *f;
    static long sample_len;
    static unsigned nr, sl, sr=11000;
    static unsigned long srl ;
    int stereo = 0, error = 0;
    char ch;
    int samesound = 0 ;

    char filename[20] ;

//    if (sound_is_on)
//      return ;

    if(!Sb_DMA_Complete())
    {
	Sb_Halt_DMA();
//	Sb_Init(); /* Necessary after early termination of a high-speed xfer */
	}

    sprintf (filename, SND_WAVNAME, num) ;

	{
	  f = fopen(filename,"rb");
// printf ("open %s\n", filename) ; getch () ;
      if(f == NULL)
      {
	fatalerror ("Fichier son %s absent", filename);
	exit (1) ;
      }
      strcpy (lastname, filename) ;

#define OFFSET_SOUND 0x2c


      sample_len = filelength(fileno(f)) - OFFSET_SOUND ;
      if(sample_len > SND_MAXSL)
	sl = SND_MAXSL;
      else
	sl = (int)sample_len;


      fseek(f, 0x18, SEEK_SET) ;
      fread (&srl,1,4,f) ;
      sr = srl ;

      fseek(f,OFFSET_SOUND, SEEK_SET);
      nr = fread(aligned,1,sl,f);
      fclose(f);
    }


//    Sb_Voice(1);
    sr = Sb_Sample_Rate(sr,PLAY);

    sound_is_on = 1 ;
    setvolume (sl) ;
	Sb_Voice_DMA(aligned,sl-0x40,stereo,PLAY);

}
