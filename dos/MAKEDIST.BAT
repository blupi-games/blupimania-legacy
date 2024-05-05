md dist
md dist\blupiman
echo O | del dist\*.*
echo O | del dist\blupiman\*.*
TDSTRIP BLUPIMAN.EXE

call bat\_copyrdm.bat

copy LZCOL.COM dist\blupiman
copy blupiman.bma dist\blupiman
copy blupiman.exe dist\blupiman
copy setup.exe    dist\blupiman
copy blpx*.wav   dist\blupiman
copy bmx*.mus   dist\blupiman
copy bmx*.ins   dist\blupiman
copy dat\*.dat   dist\blupiman
copy blupiman.ico dist\blupiman
copy blupiman.pif dist\blupiman
copy setup.pif dist\blupiman
copy install.pif dist
copy install.exe dist
cd dist\blupiman
gzip *.*
ren *.??z *.??_
copy ..\..\zipped\*.co_ .

