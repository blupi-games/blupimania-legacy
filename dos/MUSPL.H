
/* MUS Player */


int have_adlib9 (void) ;

int have_adlib18 (void) ;

void FMMusicOn (int state) ;

int FMMusicInit (void) ;

void FMMusicDeinit (void) ;

int FMLoadSong (char *musname) ;

void FMPlayOnce (int mode) ;

int FMMusicFinished (void) ;

int FMSetVolume (int volume) ;
