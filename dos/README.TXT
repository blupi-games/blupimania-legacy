
BLUPIMANIA

Contents
--------

How to pronounce Blupi
Special keys
Running Blupi from Windows(TM)
Memory setup
Using a mouse
Sound effects and music
Other hazards
Epsitec's address

How to pronounce Blupi
----------------------
Easy : just say it as it comes : Blupi, as in Blue Pea !

How to run Blupimania from Windows 3.x
--------------------------------------
When you install your BLUPIMANIA program, the files are transferred from
the diskette to a directory. The standard name for this directory is
C:\BLUPIMANIA, but you may call it almost anything you like. BLUPI.PIF
enables you to run the program from Windows(TM) and BLUPI.ICO contains
an Icon you can use. Both files in the directory mentioned above.
To run BLUPIMANIA from Windows(TM), you must create an access to
BLUPIMANIA in one of the groups in the Program Manager :
- Click on the group you want to add BLUPIMANIA in or create a new group
  using the New option in the File menu of the Program Manager.
- Select New in the File menu of the Program Manager.
- Activate the "Program" button, then click "OK".
- Fill in the options in the dialog :
    Name :          BLUPIMANIA
    Command Line :  C:\BLUPIMAN\BLUPIMAN.PIF
  Do not fill in the other elements.
- Click "Change icon..."
  A message stating no icon is available will appear. Don't worry, just
  click "OK".
- In the next dialogue, type C:\BLUPIMAN\BLUPI.ICO, then click "OK" twice.
- Validate these entries by clicking "OK" again.

Of course, if you change the name of the directory when you install
BLUPIMANIA, you must use the new name in the Path settings, instead of
C:\BLUPIMANIA in the instructions above.

How to run BLUPIMANIA from Windows 95
-------------------------------------
To run BLUPIMANIA you can create a shortcut to BLUPIMAN.EXE. Open the
folder where you have installed BLUPIMANIA. Right click on the Blupiman
application icon and choose "Create shortcut". Now you can drag the
shortcut to whatever location you want.
You may put the Blupi icon on your shortcut. Right click on the shortcut
and chose "Properties". Choose the "Program" tab, click on the
"Change icon" button, browse to the path where you have installed
BLUPIMANIA and select the BLUPIMAN.ICO file

Memory setup
------------
BLUPIMANIA needs 480000 executable program size to run properly.
If BLUPIMANIA does not run,, but displays something like

  You don't have enough free conventional memory for this program.
  You have 408224 bytes of free conventional memory and you need at
  least 480000 bytes of free conventional memory.

some conventional memory must be freed by removing resident applications
and drivers, and/or by using a high memory utility such QEMM386 by
Quarterdeck. With MS-DOS 6, the "MEMMAKER" command can also be used.
Refer to your MS-DOS manual for this command.

The "MEM" DOS command will display information relative to the occupation
of your memory. You need at least 480000 largest executable program size.

If BLUPIMANIA doesn't run, but displays:

   Not enough XMS memory

this means probably that you don't have enough memory to run BLUPIMANIA.
This message usually appears only on computers with less than 4 Mb of RAM.
You can probably free some  memory by giving less memory to the SMARTDRV
disk cache program.

Proceed like this:
- edit your AUTOEXEC.BAT file
- look for the line  that reads "SMARTDRV", "SMARTDRV /X",
  "SMARTDRV 1024" or similar.
- If a number follows "SMARTDRV" decrease the number for example by
  dividing it by 2
- If no number follows "SMARTDRV", try putting "200" or even less
  after "SMARTDRV"

For example:

     Before			After
     SMARTDRV /X 1024	SMARTDRV /X 512
     SMARTDRV			SMARTDRV 200

The number after "SMARTDRV" indicates how much memory should be allocated
to the disk cache. If you decrease that number, you increase the free
memory for BLUPIMANIA.

On the other hand it is not recommended to remove completely SMARTDRV.

Using a mouse
-------------
BLUPIMANIA is a DOS program and must be run using a DOS mouse driver. When
you install BLUPIMANIA onto your disk, a message will warn you if no DOS
mouse driver is installed.

Query:
The mouse does not respond and the arrow is not displayed.

Remedy:
The DOS mouse driver is probably not installed. Usually, the mouse driver
is loaded by AUTOEXEC.BAT or CONFIG.SYS  when your computer is started up.
The usual name for the DOS mouse driver is MOUSE.COM (for  AUTOEXEC.BAT)
or MOUSE.SYS (for CONFIG.SYS). Other common  names are AMOUSE, GMOUSE,
IMOUSE, HPMOUSE. Even if you start  BLUPIMANIA from Windows(TM), it is
necessary to install a DOS mouse driver. Please refer to your mouse
manual.

If you use a SICOS mouse driver, BLUPIMANIA may not work correctly. You
should change your mouse driver.

Using a sound board
-------------------
BLUPIMANIA comes with a great musical background and sound effects. This
means you need a SoundBlaster or compatible sound board. As sound boards

are rather touchy, here are some answers
to problems you may have :

Query:
I'm not getting any sound effects or music.

Remedies :
- Are you sure you've got a sound board ?
- Make sure your speakers are connected, and the volume turned up.
- Check the setup.  Use the SETUP program in the directory where you
  installed BLUPIMANIA.
  Please refer to your sound board manual.
  You may need to restart your computer if you change the settings.
- Check the volume controls in the BLUPIMANIA control screen (click on
  the blue machine
  on the right side of the BLUPIMANIA main screen.

Query:
- I've got music, but no sound effects or voice.

Remedies:
- Your sound board may not be SoundBlaster compatible. Sorry, no sound
  effects !
- If your sound board is SoundBlaster compatible, then check the settings
  as explained above.
- Check the volume controls in the BLUPIMANIA control screen (click on the
  blue machine on the right side of the BLUPIMANIA main screen).

Query:
I've got the sound effects, but no music.

Remedies :
- Check the volume controls in the BLUPIMANIA control screen (click on the
  blue machine on the right side of the BLUPIMANIA main screen).
- Some sound boards need auxiliary programs that are installed in the
  Config.Sys and/or AutoExec.Bat files. Check your sound board manual
  for details.

Query:
- I'm sure I've set BLUPIMANIA up correctly, but I still don't have music
  or sound effects.

Remedy:
- In some configurations, sound boards do not work properly if you run
  your program from Windows(TM). Quit Windows(TM) completely and run
  BLUPIMANIA directly at the DOS prompt. Change directory:
  CD C:\BLUPIMAN and type BLUPIMAN.

Query:
- BLUPI suddenly returns to Windows(TM) stating an error.

Remedy:
- Refer to previous remedy.


Other hazards
-------------
Query:
When I try to run SETUP, I get the Windows setup or another setup program.

Remedies :
- You are not in the correct directory.
  If you are using the Windows File Manager, open the  BLUPIMAN directory
  before clicking setup.exe. If you are in DOS, type CD C:\BLUPI-M (or the
  path you chose when you installed BLUPIMANIA)
- Have you installed BLUPIMANIA on your disk ?

Query:
- My BLUPMANIA displays an error message similar to
  "Fatal error: BLUPI20.COL: No such file or directory"
Remedy:
- One of the auxiliary files (for instance BLUPI20.COL) has been
  accidentally deleted. You must install BLUPIMANIA again.


Epsitec's address
-----------------

           EPSITEC SA
           Ch. de la Mouette
           CH-1092 Belmont
           Switzerland
           tel+fax ++41 21 / 728 44 83

           Email: epsitec@epsitec.ch
           Web: http://www.epsitec.ch


This computer program is protected by copyright law and international
treaties.Unauthorized reproduction of this program may result in severe
civil and criminal penalties, and will be prosecuted to the maximum
extend possible under the law.

The limited shareware version maybe freely distributed.


Copyright (C) 1994-1996 Epsitec SA                  All rights reserved
