
/* structure du fichier BLUPI-M.INF */

#define SBNONE      0
#define SBADLIB     1
#define SBSIMPLE    2
#define SBPRO       3

#define CONFIG_NAME "BLUPIMAN.INF"

struct blpinfo
  {
    int sbadr ;
    int sbdma ;
    int sbirq ;
    int sbtype ;
    char langue ;
    char music ;
    char sound ;
    char filler[17] ;
  }
;


#define SP_CONFIG_NAME "BLUPI_M.INF"

struct iostruct
{
  short majrev;
  short minrev ;
  short langue ;
} ;
