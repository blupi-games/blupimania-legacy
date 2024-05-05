rem call e
DEL *.obj
make
cd ..\binstall
call iblupima
cd ..\blupiman
copy ..\binstall\install.exe
copy ..\binstall\setup.exe
