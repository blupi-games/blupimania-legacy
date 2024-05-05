@rem Cree la distribution CD pour BLUPIMANIA
set d=h:\cdblupim
md %d%\FRANCAIS
md %d%\FRANCAIS\BLUPIMAN
md %d%\ALLEMAND
md %d%\ALLEMAND\BLUPIMAN
md %d%\DEUTSCH
md %d%\DEUTSCH\BLUPIMAN
md %d%\DEMO
md %d%\DEMO\FRANCAIS
md %d%\DEMO\FRANCAIS\BLUPI-M
md %d%\DEMO\FRANCAIS\BLUPI-S
md %d%\DEMO\FRANCAIS\BLUPI-P
md %d%\DEMO\FRANCAIS\BLUPI-E
md %d%\DEMO\ENGLISH
md %d%\DEMO\ENGLISH\BLUPI-M
md %d%\DEMO\ENGLISH\BLUPI-S
md %d%\DEMO\ENGLISH\BLUPI-P
md %d%\DEMO\ENGLISH\BLUPI-E
md %d%\DEMO\DEUTSCH
md %d%\DEMO\DEUTSCH\BLUPI-M
md %d%\DEMO\DEUTSCH\BLUPI-S
md %d%\DEMO\DEUTSCH\BLUPI-P
md %d%\DEMO\DEUTSCH\BLUPI-E
REM
call DIST-F
call maked-cd
CD DIST
XCOPY *.* %d%\FRANCAIS\BLUPIMAN /S
CD ..
call DIST-D
call maked-cd
CD DIST
XCOPY *.* %d%\DEUTSCH\BLUPIMAN /S
CD ..
REM
CD ..
CD BLUPI-E
REM
call DIST-F
call maked-cd
CD DIST
XCOPY *.* %d%\DEMO\FRANCAIS\BLUPI-E /S
CD ..
call DIST-DCH
call maked-cd
CD DIST
XCOPY *.* %d%\DEMO\DEUTSCH\BLUPI-E /S
CD ..
call DIST-E
call maked-cd
CD DIST
XCOPY *.* %d%\DEMO\ENGLISH\BLUPI-E /S
CD ..
