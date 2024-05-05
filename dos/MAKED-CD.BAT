deltree/Y ..\bmandist
md ..\bmandist
md ..\bmandist\inst-d
md ..\bmandist\inst-e
md ..\bmandist\inst-f
call dist-f
call makedist
cd ..
xcopy *.* ..\..\bmandist\inst-f /E
cd ..
rem
call dist-e
call makedist
cd ..
xcopy *.* ..\..\bmandist\inst-e /E
cd ..
call dist-d
call makedist
cd ..
xcopy *.* ..\..\bmandist\inst-d /E
rem
cd ..
:fin
copy liesmich.* ..\bmandist
copy lisezmoi.* ..\bmandist
copy readme.* ..\bmandist
copy ..\binstall\menubman.exe ..\bmandist\install.exe
copy install.pif ..\bmandist
copy order-?.txt ..\bmandist

