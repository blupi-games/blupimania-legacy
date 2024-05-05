/*
 *      Name:           MUS File Player
 *      Version:        1.50
 *      Author:         Vladimir Arnost (QA-Software)
 *      Last revision:  Oct-30-1994
 *      Compiler:       Borland C++ 3.1
 *
 */

/*
 * Revision History:
 *
 *      Aug-8-1994      V1.00   V.Arnost
 *              Written from scratch
 *      Aug-9-1994      V1.10   V.Arnost
 *              Some minor changes to improve sound quality. Tried to add
 *              stereo sound capabilities, but failed to -- my SB Pro refuses
 *              to switch to stereo mode.
 *      Aug-13-1994     V1.20   V.Arnost
 *              Stereo sound fixed. Now works also with Sound Blaster Pro II
 *              (chip OPL3 -- gives 18 "stereo" (ahem) channels).
 *              Changed code to handle properly notes without volume.
 *              (Uses previous volume on given channel.)
 *              Added cyclic channel usage to avoid annoying clicking noise.
 *      Aug-17-1994     V1.30   V.Arnost
 *              Completely rewritten time synchronization. Now the player runs
 *              on IRQ 8 (RTC Clock - 1024 Hz).
 *      Aug-28-1994     V1.40   V.Arnost
 *              Added Adlib and SB Pro II detection.
 *              Fixed bug that caused high part of 32-bit registers (EAX,EBX...)
 *              to be corrupted.
 *      Oct-30-1994     V1.50   V.Arnost
 *              Tidied up the source code
 *              Added C key - invoke COMMAND.COM
 *              Added RTC timer interrupt flag check (0000:04A0)
 *              Added BLASTER environment variable parsing
 *              FIRST PUBLIC RELEASE
 */



#define USE_DMAGAP


//#define USE_EMS


#include <stdio.h>
#include <stdlib.h>
#include <alloc.h>
#include <string.h>
#include <mem.h>
#include <bios.h>
#include <dos.h>
#include <conio.h>
#include "adlib.h"
#include "emm.h"
#include "muspl.h"
#include "sndparam.h"
#include "blpinfo.h"

extern struct blpinfo blpinfo ;


#if defined(USE_DMAGAP)
#include "dacdma.h"
#define MIN_GAPLENGTH 100
#endif




/* Global type declarations */

#define TIMERIRQ 0x1c


#define CHANNELS 16             // total channels 0..CHANNELS-1
#define PERCUSSION 15           // percussion channel

#define INSTRSIZE 36            // instrument size (in bytes)
#define NBINSTRUMENTS 175
#define INSFILELEN (INSTRSIZE * NBINSTRUMENTS)

struct MUSheader {
	char    ID[4];          // identifier "MUS" 0x1A
	WORD    scoreLen;
	WORD    scoreStart;
	WORD    channels;
	WORD    dummy1;
	WORD    instrCnt;
	WORD    dummy2;
//      WORD    instruments[];
} header;

#ifdef DEBUG
  #include "musinstr.c"                 // instrument names (for debugging)
#endif

#define ADLIB9 1
#define ADLIB18 2


static int soundcardtype ;

WORD    SBProPort = SBPROPORT;
WORD    channelInstr[CHANNELS];         // instrument #
BYTE    channelVolume[CHANNELS];        // volume
BYTE    channelLastVolume[CHANNELS];    // last volume
signed char channelPan[CHANNELS];       // pan, 0=normal
signed char channelPitch[CHANNELS];     // pitch wheel, 0=normal
DWORD   Adlibtime[OUTPUTCHANNELS];      // Adlib channel start time
WORD    Adlibchannel[OUTPUTCHANNELS];   // Adlib channel & note #
BYTE    Adlibnote[OUTPUTCHANNELS];      // Adlib channel note
BYTE   *Adlibinstr[OUTPUTCHANNELS];     // Adlib channel instrument address
BYTE    Adlibvolume[OUTPUTCHANNELS];    // Adlib channel volume
signed char Adlibfinetune[OUTPUTCHANNELS];// Adlib 2nd channel pitch difference

static volatile DWORD   MUStime;
static volatile WORD    playingAtOnce = 0;
static volatile WORD    playingPeak = 0;
static volatile WORD    playingChannels = 0;

static BYTE   *score;
static BYTE   *instruments = NULL ;

/* Command-line parameters */
char    instrname[] = SND_INSTNAME ;
int     singlevoice = 0;
int     stereo = 1;


#if defined(USE_DMAGAP)
static BYTE   *score2;
static unsigned int gaplength ;
#endif


static int music_over = 1;	// music fini
static int playonce ;       // ne repŠte pas le morceau
static int current_volume = 100 ;
static int old_volume = 100 ;

void interrupt (*oldHandler) () = NULL;
int timerDivisor = 1 ;
int interruptCount ;
int intercount1 ;

volatile BYTE *data ;
BYTE JUNK[10] ;
volatile DWORD ticks = 0, playtime = 0;
volatile int music_is_on ;




int have_adlib9 (void)
{
  return soundcardtype == ADLIB9 ;
}


int have_adlib18 (void)
{
  return soundcardtype == ADLIB18 ;
}




static int readMUS(FILE *f)
{
  if (fread(&header, sizeof(BYTE), sizeof header, f) != sizeof header)
  {
    puts("Unexpected end of file.");
    return -1;
  }

  if (header.ID[0] != 'M' ||
      header.ID[1] != 'U' ||
      header.ID[2] != 'S' ||
      header.ID[3] != 0x1A)
  {
    puts("Bad file.");
    return -1;
  }

  fseek(f, header.scoreStart, SEEK_SET);

#ifdef USE_DMAGAP

  if (gaplength > 0 && header.scoreLen > gaplength)
  {
    if (fread(score, sizeof(BYTE), gaplength, f) != gaplength)
    {
      puts("Unexpected end of file.");
      return -1;
    }

    if (fread(score2, sizeof(BYTE), header.scoreLen - gaplength, f) !=
				    header.scoreLen - gaplength)
    {
      puts("Unexpected end of file.");
      return -1;
    }
  }
  else
  {
    if (fread(score, sizeof(BYTE), header.scoreLen , f) != header.scoreLen)
    {
      puts("Unexpected end of file.");
      return -1;
    }
  }

#else

  if (fread(score, sizeof(BYTE), header.scoreLen , f) != header.scoreLen)
    {
      puts("Unexpected end of file.");
      return -1;
    }

#endif /* USE_DMAGAP */ 

  return 0;
}



static int readINS(FILE *f)
{
    char hdr[8];
    static char masterhdr[8] = {'#','O','P','L','_','I','I','#'};

    if (fread(&hdr, sizeof(BYTE), sizeof hdr, f) != sizeof hdr)
    {
	  puts("Unexpected end of instrument file.");
	  return -1;
	}
	if (memcmp(hdr, masterhdr, sizeof hdr))
	{
	  puts("Bad instrument file.\n");
	  return -1;
	}
	if (instruments == NULL) ;
	  if ( (instruments = calloc(NBINSTRUMENTS, INSTRSIZE)) == NULL)
	  {
		puts("Fatal error: instrument file\n");
		return -1;
	  }
	if (fread(instruments, INSTRSIZE, NBINSTRUMENTS, f) != NBINSTRUMENTS)
	{
	  puts("Unexpected end of instrument file.\n");
	  return -1;
	}
	return 0;
}

static WORD freqtable[] = {
	172, 183, 194, 205, 217, 230, 244, 258, 274, 290, 307, 326,
	345, 365, 387, 410, 435, 460, 488, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 517, 547, 580, 615, 651,
	690, 731, 774, 820, 869, 921, 975, 1023, 1023, 1023, 1023, 1023,
	1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023};
static char octavetable[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2,
	2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3,
	3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,
	4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,
	5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6,
	6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7,
	7, 7, 7, 7, 7, 7, 7, -1, -1, -1, -1, -1,
	-1, -1, -1, -1, -1, -1, -1, -1};

static void WriteFrequency(BYTE Adlibchannel, WORD note, int pitch, BYTE keyOn)
{
    WORD freq = freqtable[note];
    WORD octave = octavetable[note];

    if (pitch > 0)
    {
	int freq2;
	int octave2 = octavetable[note+1] - octave;

	if (octave2)
	{
	    octave++;
	    freq >>= 1;
	}
	freq2 = freqtable[note+1] - freq;
	freq += (freq2 * pitch) / 64;
    } else
    if (pitch < 0)
    {
	int freq2;
	int octave2 = octave - octavetable[note-1];

	if (octave2)
	{
	    octave--;
	    freq <<= 1;
	}
	freq2 = freq - freqtable[note-1];
	freq -= (freq2 * -pitch) / 64;
    }
    WriteFreq(Adlibchannel, freq, octave, keyOn);
}


static int OccupyChannel(WORD i, WORD channel, BYTE note, int volume, BYTE *instr,
		  WORD flag)
{
    playingChannels++;
    Adlibchannel[i] = (channel << 8) | note | (flag << 15);
    Adlibtime[i] = MUStime;
    if (volume == -1)
	volume = channelLastVolume[channel];
    else
	channelLastVolume[channel] = volume;
    volume = channelVolume[channel] * (Adlibvolume[i] = volume) / 127;
    if (instr[0] & 1)
	note = instr[3];
    else if (channel == PERCUSSION)
	note = 60;                      // C-5
    if (flag && (instr[0] & 4))
	Adlibfinetune[i] = instr[2] - 0x80;
    else
	Adlibfinetune[i] = 0;
    if (flag)
	instr += 16+4;
    else
	instr += 4;
    WriteInstrument(i, Adlibinstr[i] = instr);
    WritePan(i, instr, channelPan[channel]);
    WriteVolume(i, instr, volume);
    Adlibnote[i] = note += instr[14] + 12;
    WriteFrequency(i, note, Adlibfinetune[i]+channelPitch[channel], 1);
    return i;
}

static int ReleaseChannel(WORD i, WORD killed)
{
    WORD channel = (Adlibchannel[i] >> 8) & 0x7F;
    playingChannels--;
    WriteFrequency(i, Adlibnote[i], Adlibfinetune[i]+channelPitch[channel], 0);
    Adlibchannel[i] = 0xFFFF;
    if (killed)
    {
	WriteChannel(0x80, i, 0x0F, 0x0F);      // release rate - fastest
	WriteChannel(0x40, i, 0x3F, 0x3F);      // no volume
    }
    return i;
}

static int FindFreeChannel(WORD flag)
{
    static WORD last = 0xFFFF;
    WORD i;
    WORD latest = 0xFFFF;
    DWORD latesttime = MUStime;

    for(i = 0; i < AdlibChannels; i++)
    {
	if (++last == AdlibChannels)
	    last = 0;
	if (Adlibchannel[last] == 0xFFFF)
	    return last;
    }

    if (flag & 1)
	return -1;

    for(i = 0; i < AdlibChannels; i++)
    {
	if ((Adlibchannel[i] & 0x8000))
	{
	    ReleaseChannel(i, -1);
	    return i;
	} else
	    if (Adlibtime[i] < latesttime)
	    {
		latesttime = Adlibtime[i];
		latest = i;
	    }
    }

    if (!(flag & 2) && latest != 0xFFFF)
    {
	ReleaseChannel(latest, -1);
	return latest;
    }


#ifdef DEBUG
    printf("DEBUG: Full!!!\n");
#endif
    return -1;
}

// code 1: play note
static void playNote(WORD channel, BYTE note, int volume)
{
    int i; // orignote = note;
    BYTE *instr, instrnumber;

    if (channel == PERCUSSION)
    {

// uncomment foll. line to supress percussions
// return ;

	if (note < 35 || note > 81)
	    return;                     // wrong percussion number
	instrnumber = (128-35) + note;
    } else
	instrnumber = channelInstr[channel];
    instr = &instruments[instrnumber*INSTRSIZE];

    if ( (i = FindFreeChannel((channel == PERCUSSION) ? 2 : 0)) != -1)
    {
	OccupyChannel(i, channel, note, volume, instr, 0);
	if (!singlevoice && instr[0] == 4)
	{
	    if ( (i = FindFreeChannel((channel == PERCUSSION) ? 3 : 1)) != -1)
		OccupyChannel(i, channel, note, volume, instr, 1);
	}
    }
}

// code 0: release note
static void releaseNote(WORD channel, BYTE note)
{
    WORD i;

    channel = (channel << 8) | note;
    for(i = 0; i < AdlibChannels; i++)
	if ((Adlibchannel[i] & 0x7FFF) == channel)
	{
	    ReleaseChannel(i, 0);
//          return;
	}
}

// code 2: change pitch wheel (bender)
void pitchWheel(WORD channel, int pitch)
{
    WORD i;

    channelPitch[channel] = pitch;
    for(i = 0; i < AdlibChannels; i++)
	if (((Adlibchannel[i] >> 8) & 0x7F) == channel)
	{
	    Adlibtime[i] = MUStime;
	    WriteFrequency(i, Adlibnote[i], Adlibfinetune[i]+pitch, 1);
	}
}

// code 4: change control
static void changeControl(WORD channel, BYTE controller, int value)
{
    WORD i;

    switch (controller) {
	case 0: // change instrument
	    channelInstr[channel] = value;
	    break;
	case 3: // change volume
	    channelVolume[channel] = value;
	    for(i = 0; i < AdlibChannels; i++)
		if (((Adlibchannel[i] >> 8) & 0x7F) == channel)
		{
		    Adlibtime[i] = MUStime;
		    WriteVolume(i, Adlibinstr[i], value * Adlibvolume[i] / 127);
		}
	    break;
	case 4: // change pan (balance)
	    channelPan[channel] = value -= 64;
	    for(i = 0; i < AdlibChannels; i++)
		if (((Adlibchannel[i] >> 8) & 0x7F) == channel)
		{
		    Adlibtime[i] = MUStime;
		    WritePan(i, Adlibinstr[i], value);
		}
	    break;
    }
}



#ifdef USE_DMAGAP
static volatile int datacount ;
static int gulp[20] ;
static volatile int playscore2 ;

static int gulp2[20] ;

static volatile BYTE nextbyte (BYTE **data)
{
  BYTE retval ;

//  disable () ;
  datacount++ ;
  retval = *(*data)++ ;

  if (!playscore2 && datacount == gaplength)
  {
    *data = score2 ;
    playscore2 = 1 ;
  }
//  enable () ;
  return retval ;
}
#endif



static BYTE *playTick(BYTE *data)
{
    for(;;) {
	BYTE command = (*data >> 4) & 7;
	BYTE channel = *data & 0x0F;
	BYTE last = *data & 0x80;

#ifdef USE_DMAGAP
	nextbyte (&data) ;
#else
	data++;
#endif



	switch (command) {
	    case 0:     // release note
		playingAtOnce--;
#ifdef USE_DMAGAP
		releaseNote(channel, nextbyte (&data));
#else
		releaseNote(channel, *data++);
#endif
		break;
	    case 1: {   // play note
#ifdef USE_DMAGAP
		BYTE note = nextbyte (&data) ;
#else
		BYTE note = *data++;
#endif
		playingAtOnce++;

		if (playingAtOnce > playingPeak)
		    playingPeak = playingAtOnce;
		if (note & 0x80)        // note with volume
#ifdef USE_DMAGAP
		    playNote(channel, note & 0x7F, nextbyte (&data));
#else
		    playNote(channel, note & 0x7F, *data++);
#endif
		else
		    playNote(channel, note, -1);
		} break;
	    case 2:     // pitch wheel
#ifdef USE_DMAGAP
		pitchWheel(channel, nextbyte(&data) - 0x80);
#else
		pitchWheel(channel, *data++ - 0x80);
#endif
		break;
	    case 4:     // change control
#ifdef USE_DMAGAP
		{
		  BYTE b1, b2 ;
		  b1 = nextbyte (&data) ;
		  b2 = nextbyte (&data) ;
		  changeControl(channel, b1, b2) ;
		}
#else
		changeControl(channel, data[0], data[1]);
		data += 2;
#endif
		break;
	    case 6:     // end
		return NULL;
	    case 5:     // ???
	    case 7:     // ???
		break;
	    case 3:     // set tempo ??? -- ignore it
#ifdef USE_DMAGAP
		nextbyte (&data) ;
#else
	data++;
#endif
		break;
	}
	if (last)
	    break;
    }
    return data;
}




static BYTE *delayTicks(BYTE *data, DWORD *delaytime)
{
    DWORD time = 0;

    do {
	time <<= 7;
	time += *data & 0x7F;
#ifdef USE_DMAGAP
    } while (nextbyte (&data) & 0x80);
#else
    } while (*data++ & 0x80);

#endif

    *delaytime = time;
    return data;
}




static int detectHardware(void)
{
    int retval ;

    SBProPort = 0 ; // @@

    if (blpinfo.sbtype == -1)
    {
      DetectBlaster(&SBProPort, NULL, NULL, NULL);
      printf ("SBproport = %x\n", SBProPort) ;
//      getch () ;
      blpinfo.sbadr = SBProPort ;

      if (!DetectAdlib(ADLIBPORT))
	return -1;

      retval = DetectSBProII(SBProPort);

      return retval ;
    }
    else
    {
      if (blpinfo.sbtype > SBNONE)
      {
	SBProPort = blpinfo.sbadr ;
	if (!DetectAdlib(ADLIBPORT))
	  return -1;
	retval = DetectSBProII(SBProPort);

// uncomment following line to simulate non SBPRO card
// retval = 0 ;

	if (blpinfo.sbtype > SBSIMPLE)
	  return 1 ;
	else
	  return retval ;
      }
      else
	return -1 ;
    }
}




extern void /* interrupt */ timer_int () ;


static junk (int i)
{
  int a  ;

  a = 2 * i ;
}



static volatile int inint, intercount ;


static volatile long intcount = 0;
static halt ()
{
  printf ("**** halt **** intcount = %ld, interruptcount = %d, inint = %d", intcount,
	    interruptCount, inint ) ;
  for (;;) ;
}

static volatile long counter4, ticksnull, maxticks ;

static volatile dblint = 0 ;


static void interrupt
FMISR (__CPPARGS)
{

  void FMMusicNew (void) ;
  void FMMusicOn (int) ;

  disable () ;
  if (inint)
  {
    dblint++ ;
    enable () ;
    return ;
  }

  inint++ ;
  intercount++ ;

  intcount++ ;

#if 1

  if (music_is_on)
  {
    if (data != NULL)
    {
      if (!ticks)
      {
       counter4++ ;
       data = playTick(data);
       if (data == NULL)
	 goto nop ;

       data = delayTicks(data, &ticks);

       if (ticks > maxticks)
	 maxticks = ticks ;

       if (ticks > 1000 || ticks <= 0)
       {
	 ticksnull = 1 ;
	 ticks = 1 ;
	 data = score ;
	 datacount = 0 ;
	 FMMusicNew () ;
	 FMMusicOn (1) ;
       }
      }
      ticks--;
    }
    else
    {
#ifdef USE_DMAGAP
      datacount = 0 ;
      playscore2 = 0 ;
#else

#endif
      if (playonce)
      {
	FMMusicNew () ;
	FMMusicOn(0) ;
	music_over = 1 ;
      }
      else
      {
	FMMusicNew () ;
	FMMusicOn (1) ;
      }
      data = score ;
playscore2 = 0 ;
    }
  }

nop:


#if 0
 {
   int i ;
   for (i = 0 ;i < 1000 ; i++)
     junk (i) ;
 }
#endif


#endif

  if (intercount1++ == timerDivisor)
  {
    intercount1 = 0 ;
//    oldHandler () ;
  }

  if (++interruptCount >= timerDivisor / 4)
    {
      interruptCount = 0;
	timer_int () ;
    }

  inint-- ;
  enable () ;
}


static long checksum (BYTE *ptr, int length)
{
  int i ;
  long sum = 0 ;

  for (i = 0; i < length ; i++)
  {
    sum += ptr[i] ;
  }
  return sum ;
}


void muscounters (long *mt, long *dt, long *t, long *tn,
		  long *ft, long *chks1, long *chks2)
{
  *mt = maxticks ;
  *dt = data ;
  *t = playscore2 ;
  *tn = ticksnull ;
#ifdef USE_DMAGAP
  *ft = *(long*)score2 ;
#else
  *ft = 0 ;
#endif

  *chks1 = intercount ;
  *chks2 = datacount ;

//  *chks1 = checksum (score, gaplength) ;
//  *chks2 = checksum (score2, header.scoreLen - gaplength) ;
}





static void
FMInstallISR (int td)
{
  unsigned int timerSpeed;
  timerDivisor = td;
  if (td != 1)
    {                           /* tell the timer to speed up the ticks */
      timerSpeed = 0x10000L / td;
      disable ();
      outp (0x43, 0x36);
      outp (0x40, timerSpeed & 0xff);
      outp (0x40, timerSpeed >> 8);
      enable ();
    }

  oldHandler = getvect (TIMERIRQ);
  setvect (TIMERIRQ, FMISR);
}



static void
FMRemoveISR (void)
{
  if (oldHandler)
    {
      setvect (TIMERIRQ, oldHandler);
      if (timerDivisor != 1)
	{                       /* return the ticks to normal speed */
	  disable ();
	  outp (0x43, 0x36);
	  outp (0x40, 0);
	  outp (0x40, 0);
	  enable ();
	}
    }
}



void FMMusicOn (int state)
{
  if (have_adlib9 () || have_adlib18 ())
  {
    music_is_on = state ;
#if 1
    if (state == 0)
      SetGeneralVolume (0) ;
    else
    {
      SetGeneralVolume (current_volume) ;
    }
#endif
  }
}




void FMInitAdlib ()
{
    if (stereo)
	InitAdlib(SBProPort, 1);
    else
	InitAdlib(ADLIBPORT, 0);
}


/* pr‚pare un nouveau morceau */

void FMMusicNew (void)
{
    int i ;

    FMInitAdlib () ;

    setmem(Adlibchannel, sizeof Adlibchannel, 0xFF);
    for (i = 0; i < CHANNELS; i++)
    {
	channelVolume[i] = 127;         // default volume 127 (full volume)
	channelLastVolume[i] = 100;
    }
    MUStime = 0;

    FMMusicOn (0) ;
    playscore2 = 0 ;
    ticksnull = 0 ;
    music_over = 0 ;
}





static int get_memory (void)
{

#if defined(USE_DMAGAP)

  gaplength = dmagap_length () ;

  score2 = NULL ;

  if (gaplength >= MIN_GAPLENGTH)
  {
    int readlen ;
	int supdata = 0 ;
	char huge *hugescore ;

	hugescore = dmagap_memory () ;

	if (gaplength >= INSFILELEN + MIN_GAPLENGTH)
	{
	  printf ("Instrument file loaded in DMA gap.\n") ;
	  instruments= hugescore ;
	  hugescore += INSFILELEN ;
	  gaplength -= INSFILELEN ;

	}
	score = hugescore ;

    if ((unsigned int)SND_MAX_MUS_SIZE > (unsigned int)gaplength)
    {
      supdata = 1 ;
//      printf ("supdata = 1\n") ;
      score2 =
      farmalloc(((unsigned int)SND_MAX_MUS_SIZE - (unsigned int)gaplength)) ;
      if (score2 == NULL)
      {
//	printf ("mem error") ;
	return -1 ;
      }
    }
    else
    {
      supdata = 0 ;
    }
  }
  else
  {
    gaplength = 0 ;
    if ( (score = farmalloc (SND_MAX_MUS_SIZE)) == NULL)
    {
      puts("Not enough memory.");
      return -1;
    }

  }
//  printf ("score2 = %p\n", score2) ;

#else

  if ( (score = farmalloc (MAX_MUS_SIZE) == NULL)
  {
    puts("Not enough memory.");
    return -1;
  }

#endif

//  printf ("score = %p\n", score) ;

//  getch () ;
  return 0 ;
}





static int Adlib_initialized ;


int FMMusicInit (void)
{
    int i ;
    int retval ;
    FILE *f ;


/*  La ISR du timer est install‚ de toute fa‡on
    pour la raison suivante:

    La ISR du timer pour BLUPI est acc‚ler‚ d'un facteur
    4 par rapport … la fr‚quence par d‚faut.

    La ISR FM doit ˆtre acc‚l‚r‚ d'un facteur 8 par
    rapport … la normale.

    Donc: on installa d'abord la ISR BLUPI.
	  Ensuite on installe la ISR FM tout en acc‚l‚rant
	  le timer d'un facteur 8. Cette ISR appellera la
	  ISR timer BLUPI une fois sur deux, et la routine
	  ISR timer BLUPI appellera la routine par d‚faut une
	  fois sur 4.

	  La fonction trap_interrupts du module TE_TIM.ASM
	  ne modifie donc plus la vitesse du timer.

	  FMMusicInit doit ˆtre appel‚e aprŠs trap_interrupts !!
*/


    FMInstallISR (8) ;


    switch (detectHardware())
    {
	case -1:
		puts("Adlib not detected. Exiting.");
	    return 4 ;
	case 0:
	    stereo = 0;
	    soundcardtype = ADLIB9 ;
		puts("Adlib detected (9 channels mono)");
	    break;
	case 1:
		puts("Sound Blaster Pro II detected (18 channels stereo)");
	    soundcardtype = ADLIB18 ;

	    break;
    }

//getch () ;

    if (get_memory () != 0)
      return -2 ;


    Adlib_initialized = 1 ;

    FMMusicNew () ;

    if ( (f = fopen(instrname, "rb")) == NULL)
    {
	printf("Can't open file %s\n", instrname);
	return 7;
    }
//      printf("Reading file %s ...\n", instrname);

    if (readINS(f))
    {
	fclose(f);
	return 8;
    }
    fclose(f);

    music_over = 1 ;

    return 0 ;
}



void FMMusicDeinit (void)
{
  FMMusicOn (0) ;

  if (Adlib_initialized)
    DeinitAdlib();

  FMRemoveISR () ;
}


int FMSetVolume (int volume)
{
  SetGeneralVolume (volume) ;
  current_volume = volume ;
}





static char last_musname[20] ;


int FMLoadSong (char *musname)
{
  FILE *f ;

  if (soundcardtype == 0)
    return 0 ;

  FMMusicNew () ;

    if ( (f = fopen(musname, "rb")) == NULL)
    {
	printf("Can't open file %s\n", musname);
	return 5;
    }

    strcpy (last_musname, musname) ;

    FMMusicOn (0) ;
    if (readMUS(f))
    {
	fclose(f);
	return 6;
    }
    fclose(f);

    data = score;

#ifdef USE_DMAGAP
    datacount = 0 ;
#else

#endif

    return 0 ;
}



int musicstopped ;

FMStopMusic ()
{
    int i ;

    musicstopped = 1 ;

    FMInitAdlib () ;

    setmem(Adlibchannel, sizeof Adlibchannel, 0xFF);
    for (i = 0; i < CHANNELS; i++)
    {
	channelVolume[i] = 127;         // default volume 127 (full volume)
	channelLastVolume[i] = 100;
    }

    FMMusicOn (0) ;
}



FMStartMusic ()
{
  if (musicstopped)
  {
    FMMusicOn (1) ;
    musicstopped = 0 ;
  }
}




void FMPlayOnce (int mode)
{
  playonce = mode ;
}


FMMusicFinished (void)
{
  return music_over ;
}