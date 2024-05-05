/* Include file for Soundblaster library */

/* Defines for Soundblaster and Soundblaster Pro IO address */
#define LEFT_FM_STATUS      0x00    /* Pro only */
#define LEFT_FM_ADDRESS     0x00    /* Pro only */
#define LEFT_FM_DATA        0x01    /* Pro only */
#define RIGHT_FM_STATUS     0x02    /* Pro only */
#define RIGHT_FM_ADDRESS    0x02    /* Pro only */
#define RIGHT_FM_DATA       0x03    /* Pro only */
#define MIXER_ADDRESS       0x04    /* Pro only */
#define MIXER_DATA          0x05    /* Pro only */
#define DSP_RESET           0x06
#define FM_STATUS           0x08
#define FM_ADDRESS          0x08
#define FM_DATA             0x09
#define DSP_READ_DATA       0x0A
#define DSP_WRITE_DATA      0x0C
#define DSP_WRITE_STATUS    0x0C
#define DSP_DATA_AVAIL      0x0E
#define CD_ROM_DATA         0x10    /* Pro only */
#define CD_ROM_STATUS       0x11    /* Pro only */
#define CD_ROM_RESET        0x12    /* Pro only */
#define CD_ROM_ENABLE       0x13    /* Pro only */

#define ADLIB_FM_STATUS     0x388
#define ADLIB_FM_ADDRESS    0x388
#define ADLIB_FM_DATA       0x389

/* Defines for 8237 DMA Controller IO addresses */
#define DMA         0x00
#define CH0_BASE    DMA+0
#define CH0_COUNT   DMA+1
#define CH1_BASE    DMA+2
#define CH1_COUNT   DMA+3
#define CH2_BASE    DMA+4
#define CH2_COUNT   DMA+5
#define CH3_BASE    DMA+6
#define CH3_COUNT   DMA+7
#define DMA_STATUS  DMA+8
#define DMA_CMD     DMA+8
#define DMA_REQUEST DMA+9
#define DMA_MASK    DMA+10
#define DMA_MODE    DMA+11
#define DMA_FF      DMA+12
#define DMA_TMP     DMA+13
#define DMA_CLEAR   DMA+13
#define DMA_CLRMSK  DMA+14
#define DMA_WRMSK   DMA+15
#define DMAPAGE     0x80

/* Types of Soundblaster Cards */
#define SB15	1
#define SBPro	2
#define SB20	3

/* DSP Commands */
#define DIRECT_8_BIT_DAC    0x10
#define DMA_8_BIT_DAC	    0x14
#define DMA_2_BIT_DAC	    0x16
#define DMA_2_BIT_REF_DAC   0x17
#define DIRECT_ADC	    0x20
#define DMA_ADC 	    0x24
#define MIDI_READ_POLL	    0x30
#define MIDI_READ_IRQ	    0x31
#define MIDI_WRITE_POLL     0x38
#define TIME_CONSTANT	    0x40
#define DMA_4_BIT_DAC	    0x74
#define DMA_4_BIT_REF_DAC   0x75
#define DMA_26_BIT_DAC	    0x76
#define DMA_26_BIT_REF_DAC  0x77
#define HALT_DMA	    0xD0
#define CONTINUE_DMA	    0xD4
#define SPEAKER_ON	    0xD1
#define SPEAKER_OFF	    0xD3
#define DSP_ID		    0xE0
#define DSP_VER 	    0xE1
#define MDAC1		    0x61
#define MDAC2		    0x62
#define MDAC3		    0x63
#define MDAC4		    0x64
#define MDAC5		    0x65
#define MDAC6		    0x66
#define MDAC7		    0x67

enum { RECORD = 0, PLAY = 1 };       /* For the 'direction' argument */

/* High-speed parameters */
#define MAX_LO_REC 12048
#define MAX_LO_PLAY 22222
#define SET_HS_SIZE 0x48
#define HS_DAC 0x91
#define HS_ADC 0x99

/* Functions that are in the library */
int Sb_Init(void);
int Sb_Get_Params(void);
unsigned Sb_Sample_Rate(unsigned rate, int direction);
void Sb_Voice(int state);
void Sb_Voice_DMA(char far *data, unsigned dlen, int stereo, int direction);
void Sb_Init_Voice_DMA(void interrupt (*handler)(void));
void Sb_DeInit_Voice_DMA(void);
int Sb_DMA_Complete(void);
void Sb_Halt_DMA(void);
void Sb_Continue_DMA(void);

/* DMA routines */
int dma_setup(int Channel,char far *Buffer,unsigned Length,int Dir);
int prevent_dma(int Channel);
int allow_dma(int Channel);
unsigned dma_count(int Channel);
unsigned dma_addr(int Channel);

extern int dma_errno;
extern char far *dma_errlist[];

/* Card parameters */
extern unsigned SbIOaddr;
extern unsigned SbIRQ;
extern unsigned SbDMAchan;
extern int	SbType;


/* Define a useful macro for writing data to the DAC */
#define writedac(x) { while(inportb(SbIOaddr+DSP_WRITE_STATUS) & 0x80); \
                      outportb(SbIOaddr+DSP_WRITE_DATA,(x)); }

/* Write a byte to the SB Pro mixer chip */
#define writemixer(x,y) { outportb(SbIOaddr+MIXER_ADDRESS,(x)); \
			  outportb(SbIOaddr+MIXER_DATA,(y)); }

/* FM Instrument definition */
typedef struct {
    unsigned char SoundCharacteristic[2];
    unsigned char Level[2];
    unsigned char AttackDecay[2];
    unsigned char SustainRelease[2];
    unsigned char WaveSelect[2];
    unsigned char Feedback;
    unsigned char filler[5];
} FM_Instrument;

/* FM sound routines */
void Sb_FM_Reset(void);
void Sb_FM_Key_Off(int voice);
void Sb_FM_Key_On(int voice, int freq, int octave);
void Sb_FM_Voice_Volume(int voice, int vol);
void Sb_FM_Set_Voice(int voice_num, FM_Instrument *ins);

/* MIDI routines */
int Sb_Read_MIDI(void);
void Sb_Write_MIDI(int data);
