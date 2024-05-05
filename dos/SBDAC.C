#include <stdio.h>
#include <dos.h>
#include "sb.h"

static void far interrupt (*OldIRQ)();
static volatile int DMA_complete;
static int high_speed = 0;


/* Interrupt handler for DMA complete IRQ from Soundblaster */

static void (*userhandler)(void) = NULL ;

static void far interrupt SBHandler()
{
	static char counter = 2;
    enable();
    DMA_complete = 1;

	outp (0x300, counter++) ;

    /* Acknowledge the interrupt */
    inportb(DSP_DATA_AVAIL);
    outportb(0x20,0x20);

    if (userhandler != NULL)
      (*userhandler)() ;
}


void Sb_Install_handler (void (*handler)(void))
{
  userhandler = handler ;
}



/* Sets the sample rate to be used for digitising or playback */

unsigned Sb_Sample_Rate(unsigned rate, int direction)
{
    unsigned char tc;

    tc = (unsigned char) (256 - ((1000000L + rate/2)/rate));
    /* Determine the actual sampling rate */
    rate = (unsigned) (1000000L / (256 - tc));
    /* Do we need to select high-speed mode? */
    high_speed = (rate > (direction == PLAY ? MAX_LO_PLAY : MAX_LO_REC));

    writedac(TIME_CONSTANT);  /* Command byte for sample rate */
    writedac(tc);    /* Sample rate time constant */
    return rate;
}

void Sb_Voice(int state)
{
    writedac((state) ? SPEAKER_ON : SPEAKER_OFF);
}

void Sb_Voice_DMA(char far *data, unsigned dlen, int stereo, int direction)
{
    unsigned char im, tm;

    DMA_complete = 0;
    dlen--;  /* SB and DMA controller require number of bytes minus 1 */

    /* Enable interrupts on PIC */
    im = inportb(0x21);
    tm = ~(1 << SbIRQ);
    outportb(0x21,im & tm);
    enable();

    /* Setup DMA */
    prevent_dma(SbDMAchan);
    dma_setup(SbDMAchan,data,dlen,direction);

    /* Turn on stereo output */
    if(stereo && SbType == SBPro && direction == PLAY)
	writemixer(0x0e,0x13);

    /* Start the Soundblaster */
    if (high_speed) {
        writedac(SET_HS_SIZE);
        writedac(dlen & 0xff);
        writedac(dlen >> 8);
        writedac(direction == PLAY ? HS_DAC : HS_ADC);
    } else {
        writedac(direction == PLAY ? DMA_8_BIT_DAC : DMA_ADC);
        writedac(dlen & 0xff);
        writedac(dlen >> 8);
    }
}

void Sb_Init_Voice_DMA(void interrupt (*handler)(void))
{
    /* Insert our IRQ handler into interrupt chain */
    disable();
    OldIRQ = getvect(0x08 + SbIRQ);
    if(!handler)
        handler = SBHandler;

    setvect(0x08 + SbIRQ,handler);
    enable();
}

void Sb_DeInit_Voice_DMA(void)
{
    unsigned char tm;

    /* Turn off stereo output */
    if(SbType == SBPro)
	writemixer(0x0e,0x11);

    /* Restore old IRQ vector */
    disable();
    setvect(0x08 + SbIRQ,OldIRQ);
    tm = inportb(0x21);
    outportb(0x21,tm | (1 << SbIRQ));
    enable();
}

int Sb_DMA_Complete(void)
{
    return DMA_complete;
}

void Sb_Halt_DMA(void)
{
    if (high_speed) {
        prevent_dma(SbDMAchan);
    } else {
        writedac(HALT_DMA);
    }
}

void Sb_Continue_DMA(void)
{
    if (high_speed) {
        allow_dma(SbDMAchan);
    } else {
        writedac(CONTINUE_DMA);
    }
}
