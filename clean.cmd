@ECHO OFF

:: Clean 2.0 by FRUiT©, enjoy for free. 
:: !!WARNING!! This is an experimental free Windows NT script ! Use at your OWN RISK !
:: For a better cleanup, please restart in the msdos inline command mode, then call clean.cmd
TITLE Clean 2.0 by FRUiT
ECHO.
IF "%OS%" NEQ "Windows_NT" (ECHO ERROR: Clean 2.0 is intended for Microsoft Windows 2000/2003, XP or Vista only) & (GOTO BADVERSION)
ECHO $temp > %SYSTEMROOT%\$tmp$.tm$ 2>NUL
COPY %SYSTEMROOT%\$tmp$.tm$ %HOMEDRIVE%\ > NUL 2>&1
IF ERRORLEVEL 1 (
    IF EXIST %SYSTEMROOT%\$tmp$.tm$ DEL %SYSTEMROOT%\$tmp$.tm$ > NUL 2>&1
    ECHO ERROR: Cannot run in a restricted user account
    GOTO BADVERSION
)
IF NOT EXIST "%~dp0" GOTO BADVERSION
IF NOT EXIST %SYSTEMROOT%\SYSTEM32\AUTOEXEC.NT (
    ECHO @ ECHO OFF > %SYSTEMROOT%\SYSTEM32\AUTOEXEC.NT
    ECHO LH %SystemRoot%\system32\mscdexnt.exe >> %SYSTEMROOT%\SYSTEM32\AUTOEXEC.NT
    ECHO LH %SystemRoot%\system32\redir >> %SYSTEMROOT%\SYSTEM32\AUTOEXEC.NT
    ECHO LH %SystemRoot%\system32\dosx >> %SYSTEMROOT%\SYSTEM32\AUTOEXEC.NT
)
IF NOT DEFINED HOMEDRIVE IF DEFINED SYSTEMDRIVE SET HOMEDRIVE=%SYSTEMDRIVE%
IF NOT DEFINED HOMEDRIVE SET HOMEDRIVE=C:
HELP 2>NUL | FIND /I "valeur" > NUL 2>&1
IF ERRORLEVEL 1 (
    SET MSLANG=EN
    SET BYTESFREE=bytes free
    SET BYTES=bytes
) ELSE (
    SET MSLANG=FR
    SET BYTESFREE=octets libres
    SET BYTES=octets
)
SET DTMP=%CD%
SET EXTEND=NO
SET SFCCLEAN=NO
SET REGSCAN=NO
SET ALLDRIVES=NO
SET FRAUD=YES

:GETPARAM
    IF "%1" == "" GOTO LOGSTART
	IF /I "%1" == "/h" GOTO GETUSAGE
	IF /I "%1" == "/help" GOTO GETUSAGE
	IF /I "%1" == "/?" GOTO GETUSAGE
	IF /I "%1" == "-?" GOTO GETUSAGE
    IF /I "%1" == "/all" (
        SET EXTEND=YES
        SET REGSCAN=YES
        SET ALLDRIVES=YES
        GOTO LOGSTART
    )
	IF /I "%1" == "/d" SET ALLDRIVES=YES
	IF /I "%1" == "/drv" SET ALLDRIVES=YES
    IF /I "%1" == "/i" SET EXTEND=YES
    IF /I "%1" == "/ini" SET EXTEND=YES
    IF /I "%1" == "/r" SET REGSCAN=YES
    IF /I "%1" == "/reg" SET REGSCAN=YES
    IF /I "%1" == "/s" SET SFCCLEAN=YES
    IF /I "%1" == "/sfc" SET SFCCLEAN=YES
    SHIFT /1
GOTO GETPARAM

:GETUSAGE
ECHO Clean v2.0 by FRUiT
ECHO Cleans one or all drives.
ECHO.
ECHO CLEAN [/h[/help]] [/d[/drv]] [/i[/ini]] [/r[/reg]] [/s[/sfc]] [/all]
ECHO.
ECHO /all		Sets all parameters active, except sfc process.
ECHO /d [/drv]	Cleans ALL the connected drives.
ECHO /i [/ini]	Refreshes Windows internal processes, tools and classes.
ECHO /r [/reg]	Performs extended registry cleanups / tweaks.
ECHO /s [/sfc]	Starts the Windows system files checker.
ECHO			Needs the original Windows installation CDROM to be inserted.
ECHO /h [/help]	Displays this dialog.
ECHO.
ECHO If the /sfc and /all options are to be used simultaneously, remember to allways
ECHO put the /sfc option FIRST on the command line.
ECHO Please keep in mind you are using this free tool AT YOUR OWN RISK.
GOTO BADVERSION

:LOGSTART
CD /d %HOMEDRIVE%\ > NUL 2>&1
ECHO e 100 "System cleaning:þ" > SCRIPT.CLN 2>NUL
ECHO rcx >> SCRIPT.CLN 2>NUL
ECHO 11 >> SCRIPT.CLN 2>NUL
ECHO n MAINMSG.DAT >> SCRIPT.CLN 2>NUL
ECHO w >> SCRIPT.CLN 2>NUL
ECHO q >> SCRIPT.CLN 2>NUL
DEBUG < SCRIPT.CLN > NUL 2>&1
ECHO e 100 "þ" > SCRIPT.CLN 2>NUL
ECHO rcx >> SCRIPT.CLN 2>NUL
ECHO 1 >> SCRIPT.CLN 2>NUL
ECHO n PROGRES.DAT >> SCRIPT.CLN 2>NUL
ECHO w >> SCRIPT.CLN 2>NUL
ECHO q >> SCRIPT.CLN 2>NUL
DEBUG < SCRIPT.CLN > NUL 2>&1
ECHO e 100 "DISKFRE3.BAT" > SCRIPT.CLN 2>NUL
ECHO rcx >> SCRIPT.CLN 2>NUL
ECHO c >> SCRIPT.CLN 2>NUL
ECHO n DISKFREE.DAT >> SCRIPT.CLN 2>NUL
ECHO w >> SCRIPT.CLN 2>NUL
ECHO q >> SCRIPT.CLN 2>NUL
DEBUG < SCRIPT.CLN > NUL 2>&1
ECHO @ECHO OFF > DISKFRE3.BAT
ECHO IF "%%5"=="%BYTES%" SET DISKFREE=%%3 >> DISKFRE3.BAT
ECHO IF "%%6"=="%BYTES%" SET DISKFREE=%%3%%4 >> DISKFRE3.BAT
ECHO IF "%%7"=="%BYTES%" SET DISKFREE=%%3%%4%%5 >> DISKFRE3.BAT
ECHO IF "%%8"=="%BYTES%" SET DISKFREE=%%3%%4%%5%%6 >> DISKFRE3.BAT
COPY DISKFREE.DAT DISKFRE2.BAT > NUL 2>&1
DIR %HOMEDRIVE% | FIND /I "%BYTESFREE%" >> DISKFRE2.BAT 2>NUL
CALL DISKFRE2.BAT > NUL 2>&1
DEL DISKFRE2.BAT > NUL 2>&1
DEL DISKFRE3.BAT > NUL 2>&1
ECHO. > "%~dp0"\Clean.log
ECHO Last Clean on %DATE% at %TIME% by %COMPUTERNAME%/%USERNAME% >> "%~dp0"\Clean.log 2>NUL
VER >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\SYSTEM32\CHKNTFS.exe %SYSTEMROOT%\SYSTEM32\CHKNTFS %HOMEDRIVE% >> "%~dp0"\Clean.log 2>&1
:REGVERIFY
IF EXIST %SYSTEMROOT%\SYSTEM32\REG.EXE GOTO GOTREG
    CD /d %HOMEDRIVE%\ > NUL 2>&1
    SET REGFOLDER=
    ECHO e 100 "REGLOC01.BAT" > SCRIPT.CLN 2>NUL
    ECHO rcx >> SCRIPT.CLN 2>NUL
    ECHO c >> SCRIPT.CLN 2>NUL
    ECHO n CREGFIND.DAT >> SCRIPT.CLN 2>NUL
    ECHO w >> SCRIPT.CLN 2>NUL
    ECHO q >> SCRIPT.CLN 2>NUL
    DEBUG < SCRIPT.CLN > NUL 2>&1
    ECHO @ECHO OFF > REGLOC01.BAT
    ECHO SET REGFOLDER=%%3 %%4 %%5 %%6 %%7 %%8 %%9>> REGLOC01.BAT
    COPY CREGFIND.DAT REGLOC02.BAT > NUL 2>&1
    DIR /S REG.EXE 2>NUL | FIND /I "\">> REGLOC02.BAT
    IF ERRORLEVEL 1 GOTO REGDL
    CALL REGLOC02.BAT > NUL 2>&1
    IF DEFINED REGFOLDER CD /d %REGFOLDER% > NUL 2>&1
    IF EXIST REG.EXE MOVE REG.EXE %SYSTEMROOT%\SYSTEM32 > NUL 2>&1
    CD /d %HOMEDRIVE%\ > NUL 2>&1
    (DEL CREGFIND.DAT > NUL 2>&1) & (DEL REGLOC0*.BAT > NUL 2>&1) & (SET REGFOLDER=)
    GOTO GOTREG
:REGDL
    PING http://www.secteur7.net -n 1 > NUL 2>&1
    IF %ERRORLEVEL%==0 (
        "%PROGRAMFILES%\INTERN~1\IEXPLORE.EXE" http://www.secteur7.net/div/reg.exe > NUL 2>&1
    ) ELSE (
        (DEL CREGFIND.DAT > NUL 2>&1) & (DEL REGLOC0*.BAT > NUL 2>&1) & (SET REGFOLDER=)
        GOTO GOTREG
    )
    GOTO REGVERIFY
:GOTREG
IF NOT EXIST %SYSTEMROOT%\SYSTEM32\REG.EXE (
    ECHO REG.EXE not present. Some registry cleanups will not be performed. >> "%~dp0"\Clean.log
    ECHO You may download it for free at http://www.dynawell.com/reskit/microsoft/win2000/reg.zip >> "%~dp0"\Clean.log
    ECHO And just extract the .exe file in your SYSTEM32 folder.>> "%~dp0"\Clean.log
    GOTO LOGEND
)
FOR /F "delims=	 tokens=2*" %%I IN ('REG QUERY "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v ProcessorNameString ^|FIND "REG_SZ"') DO ECHO Processor : %%J, %PROCESSOR_IDENTIFIER% >> "%~dp0"\Clean.log
REG QUERY "HKLM\SOFTWARE\CleanByFRUiT" /v Utilisation > NUL 2>&1
IF ERRORLEVEL 1 REG ADD "HKLM\SOFTWARE\CleanByFRUiT" /v Utilisation /t REG_SZ /d 0 > NUL 2>&1
FOR /F "delims=	 tokens=2*" %%I IN ('REG QUERY HKLM\SOFTWARE\CleanByFRUiT /v Utilisation ^|FIND "REG_SZ"') DO SET UTIL=%%J > NUL 2>&1
SET /a UTIL=%UTIL%+1
ECHO Cleaned this system %UTIL% times >> "%~dp0"\Clean.log
REG ADD "HKLM\SOFTWARE\CleanByFRUiT" /v Utilisation /t REG_SZ /d %UTIL% /f > NUL 2>&1
:LOGEND
SET NOKILL=YES
%SYSTEMROOT%\SYSTEM32\TASKKILL.EXE /im explorer.exe /F > NUL 2>&1
IF EXIST %SYSTEMROOT%\SYSTEM32\TASKKILL.EXE SET NOKILL=NO
ECHO. >> "%~dp0"\Clean.log
IF DEFINED UTIL IF %UTIL% LEQ 3 IF EXIST "%~dp0"\Cleanhlp.txt IF EXIST %SYSTEMROOT%\NOTEPAD.EXE NOTEPAD "%~dp0\Cleanhlp.txt"
TYPE %HOMEDRIVE%\MAINMSG.DAT > CON 2>NUL ::1

IF "%ALLDRIVES%" == "YES" (
    FOR %%I IN (C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:) DO IF EXIST %%I CALL :CLEANDRV %%I
) ELSE (
    CALL :CLEANDRV %HOMEDRIVE%
)
GOTO ROOTDRV

:CLEANDRV
    COPY %SYSTEMROOT%\$tmp$.tm$ %1\ > NUL 2>&1
    IF ERRORLEVEL 1 GOTO:EOF
    IF EXIST %1\$tmp$.tm$ (
        ECHO. >> "%~dp0"\Clean.log
        ECHO FILE DELETION RESULT DRIVE %1 >> "%~dp0"\Clean.log
        CD /d %1\ > NUL 2>&1
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (TEMP) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (IF ERRORLEVEL 0 DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (TEMP) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (IF ERRORLEVEL 0 DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        FOR /R %1\ %%A IN (TEMPOR~1) DO IF EXIST %%A (ATTRIB -h -r -s "%%A"\*.* /S /D > NUL 2>&1) && (DEL /S /Q /F /A "%%A"\*.* >> "%~dp0"\Clean.log 2>NUL)
        TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
        CD /d %1\ > NUL 2>&1
        FOR /R %1\ %%A IN (APPLIC~1) DO IF EXIST %%A (
            CD /d %%A\ > NUL 2>&1
            FOR /R %%B IN (CACHE) DO IF EXIST %%B (DEL /S /Q /F /A "%%B"\*.* >> "%~dp0"\Clean.log 2>NUL)
        )
        CD /d %1\ > NUL 2>&1
        FOR /R %1\ %%A IN (OPERA) DO IF EXIST %%A (
            CD /d %%A\ > NUL 2>&1
            FOR /R %%B IN (CACHE4) DO IF EXIST %%B (DEL /S /Q /F /A "%%B"\*.* >> "%~dp0"\Clean.log 2>NUL)
        )
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (COOKIES) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (COOKIES) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (USERDATA) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (USERDATA) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (RECENT) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (RECENT) DO IF EXIST %%A (CD /d %%A > NUL 2>&1) && (DEL /S /Q /F /A *.* >> "%~dp0"\Clean.log 2>NUL)
        CD /d %1 > NUL 2>&1
        FOR /R %1\ %%A IN (*.tmpl) DO IF EXIST %%A (REN "%%A" "%%~nA.$$pl") >> "%~dp0"\Clean.log 2>NUL
        FOR /R %1\ %%A IN (*.tmp) DO IF EXIST %%A (DEL /Q /F /A "%%A" > NUL 2>&1) && (ECHO %%A >> "%~dp0"\Clean.log 2>NUL)
        FOR /R %1\ %%A IN (*.$$pl) DO IF EXIST %%A (REN "%%A" "%%~nA.tmpl") >> "%~dp0"\Clean.log 2>NUL
        CD /d %1\ > NUL 2>&1
        DEL /S /Q /F /A thumb?.d? >> "%~dp0"\Clean.log 2>NUL
        TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (LOCALS~1\HISTOR~1) DO IF EXIST %%A (CD /d %%A) && (DEL /S /Q /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (LOCALS~1\HISTOR~1) DO IF EXIST %%A (CD /d %%A) && (DEL /S /Q /A *.* >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (DATA.BAK) DO IF EXIST %%A (REN "%%A" "DATA.$AK") >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (DATA.BAK) DO IF EXIST %%A (REN "%%A" "DATA.$AK") >> "%~dp0"\Clean.log 2>NUL
        FOR /R %1\ %%A IN (*.bad *.bak *.BAK *.BK* *.NU3 *.NU4 *.cnt *.cpy *.dmp *.err *.err! *.old *.gid *.grp *.$$$ file????._dd *.fts *.ftg *.chk *.shd *.syd *.m01 *.rip *.prv *.wbk *.--- *.~~~ *.~_~ *._mp *.@@@) DO IF EXIST %%A (ATTRIB -h -r -s "%%A" /S /D > NUL 2>&1) && (ECHO %%A >> "%~dp0"\Clean.log) && (DEL /Q /F /A "%%A" > NUL 2>&1)
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (DATA.$AK) DO IF EXIST %%A (REN "%%A" "DATA.BAK") >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (DATA.$AK) DO IF EXIST %%A (REN "%%A" "DATA.BAK") >> "%~dp0"\Clean.log 2>NUL
        CD /d %1\ > NUL 2>&1
        IF EXIST %1\PROGRA~1\DAP\TEMP DEL /S /Q %1\PROGRA~1\DAP\TEMP\*.* >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\PROGRA~1\DAP\ADS DEL /S /Q %1\PROGRA~1\DAP\ADS\*.* >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\PROGRA~1\DAP\LOG DEL /S /Q %1\PROGRA~1\DAP\LOG\*.* >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\PROGRA~1\EMULE\CONFIG\AC_SearchStrings.dat DEL /S /Q %1\PROGRA~1\EMULE\CONFIG\AC_SearchStrings.dat >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\PROGRA~1\NETSCAPE\USERS\DEFAULT (
            CD /d %1\PROGRA~1\NETSCAPE\USERS\DEFAULT\
            DEL /S /Q netscape.hst >> "%~dp0"\Clean.log 2>NUL
            DEL /S /Q cookies.txt >> "%~dp0"\Clean.log 2>NUL
            DEL /S /Q /A %1\PROGRA~1\NETSCAPE\USERS\DEFAULT\CACHE\*.* >> "%~dp0"\Clean.log 2>NUL
            CD /d %1\ > NUL 2>&1
        )
        IF EXIST %1\RECYCLER (DEL /S /Q /F /A %1\RECYCLER\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q RECYCLER > NUL 2>&1)
        TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
        CD /d %1\ > NUL 2>&1
        FOR /R %1\ %%A IN (erro.log images.blb imageDB.ddf imagedb.aid reginfo.txt RealPlayer-log.txt errorlog.txt modem.log comsetup.log directx.log mpcsetup.log setuplog.txt netsetup.log) DO IF EXIST %%A (DEL A /F /Q "%%A" > NUL 2>&1) && (ECHO %%A >> "%~dp0"\Clean.log 2>NUL)
        IF EXIST %1\DOCUME~1 FOR /R %1\DOCUME~1\ %%A IN (QTPlayerSession.xml cookies.txt downloads.rdf history.dat formhistory.dat ctd.dat realplayer.ste MEDIATAB0.DAT) DO IF EXIST %%A DEL /S /Q /F /A "%%A" >> "%~dp0"\Clean.log 2>NUL
        IF EXIST %1\USERS FOR /R %1\USERS\ %%A IN (QTPlayerSession.xml cookies.txt downloads.rdf history.dat formhistory.dat ctd.dat realplayer.ste MEDIATAB0.DAT) DO IF EXIST %%A DEL /S /Q /F /A "%%A" >> "%~dp0"\Clean.log 2>NUL
        CD /d %1\ > NUL 2>&1
        FOR /R %1\ %%A IN (WUTEMP) DO IF EXIST %%A (DEL /S /Q /F /A "%%A"\*.*  >> "%~dp0"\Clean.log 2>NUL) && (RD /S /Q "%%A")
        IF EXIST "%1\Users\Public\Recorded TV\Sample Media\" DO DEL /S /Q /A "%1\Users\Public\Recorded TV\Sample Media"\*.*  >> "%~dp0"\Clean.log 2>NUL
        ECHO. >> "%~dp0"\Clean.log
        DEL %1\$tmp$.tm$ > NUL 2>&1
    )
GOTO:EOF

:ROOTDRV
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
ECHO SYSTEM ROOT FOLDER CLEANING RESULT: %SYSTEMROOT% >> "%~dp0"\Clean.log
IF EXIST %SYSTEMROOT%\PREFETCH DEL /S /Q /F /A %SYSTEMROOT%\PREFETCH\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\INTERN~1 DEL /S /Q /F %SYSTEMROOT%\INTERN~1\zalog*.* >> "%~dp0"\Clean.log 2>NUL
FOR /R %SYSTEMROOT%\ %%A IN (TEMP) DO IF EXIST %%A (CD /d %%A) && (DEL /S /Q /F *.* >> "%~dp0"\Clean.log 2>NUL)
FOR /R %SYSTEMROOT%\ %%G IN (Q*.LOG KB*.LOG) DO IF EXIST %%G DEL /S /Q /A "%%G" >> "%~dp0"\Clean.log 2>NUL
CD /d %SYSTEMROOT%\ > NUL 2>&1
IF EXIST %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourStrt.exe (ATTRIB -h -r -s %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourStrt.exe) & (DEL /S /Q /F /A %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourStrt.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourW.exe (ATTRIB -h -r -s %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourW.exe) & (DEL /S /Q /F /A %SYSTEMROOT%\SYSTEM32\DLLCACHE\TourW.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST %SYSTEMROOT%\HELP\TOURS (DEL /S /Q %SYSTEMROOT%\HELP\TOURS\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q %SYSTEMROOT%\HELP\TOURS > NUL 2>&1)
IF EXIST %SYSTEMROOT%\SYSTEM32\Tourstart.exe DEL /S /Q %SYSTEMROOT%\SYSTEM32\Tourstart.exe >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\MINIDUMP DEL /S /Q /A %SYSTEMROOT%\MINIDUMP\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\SYSTEM32\SPOOL\PRINTERS DEL /S /Q %SYSTEMROOT%\SYSTEM32\SPOOL\PRINTERS\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\DOWNLO~1 DEL /S /Q /F /A %SYSTEMROOT%\DOWNLO~1\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\PCHEALTH\HELPCTR\DATACOLL DEL /S /Q /F /A %SYSTEMROOT%\PCHEALTH\HELPCTR\DATACOLL\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\SYSTEM32\WBEM\LOGS DEL /S /Q /F /A %SYSTEMROOT%\SYSTEM32\WBEM\LOGS\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST "%SYSTEMROOT%\DEBUG" DEL /S /Q /F /A "%SYSTEMROOT%\DEBUG"\*.log >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\SECURITY\LOGS DEL /S /Q /F /A %SYSTEMROOT%\SECURITY\LOGS\*.log >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\SYSTEM32\LOGFILES DEL /S /Q /F /A %SYSTEMROOT%\SYSTEM32\LOGFILES\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\AU_Backup DEL /S /Q /F /A %SYSTEMROOT%\AU_Backup\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\AU_Log DEL /S /Q /F /A %SYSTEMROOT%\AU_Log\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST %SYSTEMROOT%\AU_Temp DEL /S /Q /F /A %SYSTEMROOT%\AU_Temp\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST "%USERPROFILE%\LOCALS~1\APPLIC~1\IconCache.db" DEL /S /Q /F /A "%USERPROFILE%\LOCALS~1\APPLIC~1\IconCache.db" >> "%~dp0"\Clean.log 2>NUL
IF EXIST "%USERPROFILE%\LOCALS~1\APPLIC~1\MICROS~1\MEDIAP~1" DEL /S /Q /F /A "%USERPROFILE%\LOCALS~1\APPLIC~1\MICROS~1\MEDIAP~1"\*.* >> "%~dp0"\Clean.log 2>NUL
IF EXIST "%USERPROFILE%\LOCALS~1\APPLIC~1\Adobe\Acrobat\7.0\Cache\Search70" DEL /S /F /Q /A "%USERPROFILE%\Local Settings\Application Data\Adobe\Acrobat\7.0\Cache\Search70"\*.* >> "%~dp0"\Clean.log 2>&1
IF EXIST "%USERPROFILE%\APPLIC~1\Azureus\logs" DEL /S /F /Q /A "%USERPROFILE%\APPLIC~1\Azureus\logs"\*.* >> "%~dp0"\Clean.log 2>&1
CD /d %SYSTEMROOT%\ > NUL 2>&1
FOR /R %SYSTEMROOT%\ %%A IN (t.txt wmsetup*.log snap*.dat SchedLog.txt SchedLgU.txt Luresult.txt setuperr.log wga.log) DO IF EXIST %%A (ECHO %%A >> "%~dp0"\Clean.log 2>NUL) && (DEL /Q /F /A "%%A" > NUL 2>&1)
::IF EXIST %SYSTEMROOT%\SYSTEM32\COMPACT.EXE (
::    PUSHD %SYSTEMROOT%
::    COMPACT /U /S $NtU* > NUL 2>&1
::    ATTRIB -h -r -s -a $NtU* /D /S > NUL 2>&1
::    FOR /D %%A IN ($NtU*) DO IF EXIST %%A (DEL /S /F /Q /A "%%A"\*.* >> "%~dp0"\Clean.log 2>&1) && (RD /S /Q %%A > NUL 2>&1)
::    POPD
::)
IF EXIST %SYSTEMROOT%\SYSTEM32\COMPACT.EXE IF EXIST %SYSTEMROOT%\SYSTEM32\TFTP* (
    PUSHD %SYSTEMROOT%\SYSTEM32
    IF EXIST tftp.exe REN tftp.exe $$ftp.exe > NUL 2>&1
    COMPACT /U TFTP* > NUL 2>&1
    ATTRIB -h -r -s -a TFTP* > NUL 2>&1
    FOR %%A IN (TFTP*) DO IF EXIST %%A (DEL /F /Q /A "%%A" > NUL 2>&1) && (ECHO %SYSTEMROOT%\SYSTEM32\%%A >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST $$ftp.exe REN $$ftp.exe tftp.exe > NUL 2>&1
    POPD
)
CD /d %SYSTEMROOT%\SYSTEM32\ > NUL 2>&1
FOR %%A IN (tmp*.FOT msnlog.log perf*.dat) DO IF EXIST %%A (DEL /F /Q /A "%%A" > NUL 2>&1) && (ECHO %SYSTEMROOT%\SYSTEM32\%%A >> "%~dp0"\Clean.log 2>NUL)
CD /d %SYSTEMROOT%\ > NUL 2>&1
IF EXIST %SYSTEMROOT%\SYSTEM32\SC.EXE (
    CALL %SYSTEMROOT%\SYSTEM32\SC.EXE QUERY MESSENGER > NUL 2>&1
    IF ERRORLEVEL 0 (
        CALL %SYSTEMROOT%\SYSTEM32\SC.EXE STOP MESSENGER > NUL 2>&1
        ECHO. >> "%~dp0"\Clean.log 2>&1
        ECHO POPUPS and Messenger Messaging Service disabling...  >> "%~dp0"\Clean.log
        CALL %SYSTEMROOT%\SYSTEM32\SC.EXE CONFIG MESSENGER START= DISABLED >> "%~dp0"\Clean.log 2>&1
        CALL %SYSTEMROOT%\SYSTEM32\SC.EXE QUERY MESSENGER >> "%~dp0"\Clean.log 2>&1
    )
)
IF NOT "%SAFEBOOT_OPTION%" == "MINIMAL" (
    RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True >> "%~dp0"\Clean.log 2>&1
    RUNDLL32.EXE IEdkcs32.dll,Clear >> "%~dp0"\Clean.log 2>&1
    RUNDLL32.EXE Shell32.dll,SHEmptyRecycleBin >> "%~dp0"\Clean.log 2>&1
    REGSVR32.EXE /u /s %SYSTEMROOT%\SYSTEM32\regwizc.dll >> "%~dp0"\Clean.log 2>&1
    REGSVR32.EXE /u /s %SYSTEMROOT%\SYSTEM32\shmedia.dll >> "%~dp0"\Clean.log 2>&1
    IF EXIST %SYSTEMROOT%\SYSTEM32\IPConfig.exe %SYSTEMROOT%\SYSTEM32\IPCONFIG /FLUSHDNS >> "%~dp0"\Clean.log 2>&1
)
TYPE %SYSTEMROOT%\SYSTEM32\DRIVERS\ETC\HOSTS | FIND /I "mpa.one.microsoft.com" > NUL 2>&1
IF ERRORLEVEL 1 (ECHO. >> %SYSTEMROOT%\SYSTEM32\DRIVERS\ETC\HOSTS 2>NUL) & (ECHO 127.0.0.1       mpa.one.microsoft.com >> %SYSTEMROOT%\SYSTEM32\DRIVERS\ETC\HOSTS 2>NUL)

:REGISTRY
IF "%REGSCAN%" NEQ "YES" GOTO MRUD
IF NOT EXIST %SYSTEMROOT%\SYSTEM32\REG.EXE GOTO MRUD
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
REG ADD "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d Y /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Welcome\RegWiz" /v @ /t REG_SZ /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMftZoneReservation /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeOut /t REG_SZ /d 15 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Update" /v UpdateMode /t REG_DWORD /d 7 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\ContentIndex" /v FilterFilesWithUnknownExtensions /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Network\Connections" /v ShowLanErrors /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
:: REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 2 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\GlobalLogger" /v "Start" /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Vxd\mstcp" /v DefaultTTL /t REG_SZ /d 64 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableCMPRedirect /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SYSTEM\ControlSet001\Services\W32Time\TimeProviders\NtpClient" /v SpecialPollInterval /t REG_DWORD /d 86400 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Java VM" /v Generation0Size /t REG_DWORD /d 20000 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" /v RegDone /t REG_SZ /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v AlwaysUnloadDll /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_DWORD /d 2048 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Protocoldefaults" /v About: /t REG_DWORD /d 4 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v KeepRasConnections /t REG_DWORD /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\Control Panel\Desktop" /v WaitToKillTimeout /t REG_SZ /d 2000 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\Control Panel\Desktop" /v PaintDesktopVersion /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /v "Shell Icon BPP" /t REG_SZ /d 32 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v PlayerScriptCommandsEnabled /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPerServer /t REG_DWORD /d 12 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPer1_0Server /t REG_DWORD /d 12 /f >> "%~dp0"\Clean.log 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft Internet Explorer\Main" /v IEWatsonDisabled /d 1 /f >> "%~dp0"\Clean.log 2>&1
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-4C6A-11CF-8D87-00AA0060F5BF}" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" /f >> "%~dp0"\Clean.log 2>NUL
ECHO. >> "%~dp0"\Clean.log 2>NUL
ECHO The registry keys have been correctly tweaked! >> "%~dp0"\Clean.log 2>NUL

:MRUD
IF NOT EXIST %SYSTEMROOT%\SYSTEM32\REG.EXE GOTO SMITFRAUD
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
REG DELETE "HKCU\Identities\{BAF5DD30-42A4-41C3-9C6A-208404AE456E}\Software\Microsoft\Outlook Express\5.0\Rules\Filter\MRU List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Conferencing\UI\CallMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\TypedUrls" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\IntelliForms\SPW" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\FilesNamedMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ContainingTextMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MSE\10.0\FileMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MSE\10.0\ProjectMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MSE\10.0\SolutionMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Search Assistant\ACMru\5001" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Search Assistant\ACMru\5604" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Search Assistant\ACMru\5603" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Search Assistant\ACMru\5647" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Search Assistant\ACMru\5647" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WorkgroupCrawler\Printers" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{5E6AB780-7743-11CF-A12B-00AA004AE837}\Count" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\{75048700-EF1F-11D0-9888-006097DEACF9}\Count" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Applets\Tours" /v RunCount /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Tour" /va /f >> "%~dp0"\Clean.log 2>NUL
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Tour" /v RunCount /t REG_DWORD /d 0 /f >> "%~dp0"\Clean.log 2>&1
REG DELETE "HKCU\Software\Microsoft\Microsoft Management Console\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Player\RecentFileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Player\RecentURLList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Preferences\FindFolders" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v PlaylistEditLastNode /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v LastPlaylist /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Preferences" /v LastPlaylistIndex /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Player\Settings" /v SaveAsDir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MediaPlayer\Radio\MRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Microsoft\Outlook Express\5.0\Default Settings\Recent Stationery List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Excel\Recent Files" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Common\Open Find\Microsoft Office Word\Settings\Save As\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\PowerPoint\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Publisher\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\InfoPath\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Common\Internet\Server Cache" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Common\Internet" /v UseRWHlinkNavigation /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MSPaper 11.0\Persist File Name" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MSPaper 11.0\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\11.0\Word\Data" /v Settings /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Common\Open Find\Microsoft Word\Settings\Enregistrer sous\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Common\Open Find\Microsoft Excel\Settings\Enregistrer sous\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Word\Data" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Outlook\Contact\QuickFindMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Outlook\Contact\StripSearchMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Outlook\Preferences\LocationMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Outlook\Office Finder\MRU 1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Outlook\Office Finder\MRU 3" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\10.0\Excel\Recent Files" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Common\Open Find\Microsoft Word\Settings\Save As\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Common\Open Find\Microsoft Excel\Settings\Save As\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Common\Open Find\Microsoft Office Binder\Settings\Save As\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Common\Open Find\Microsoft PowerPoint\Settings\Save As\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Common\Open Find\Office\Settings\Open Office Document\File Name MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Word\Data" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Outlook\Contact\QuickFindMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Office\9.0\Excel\Recent Files" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\6.0\FileMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\6.0\ProjectMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\7.0\FileMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\7.0\ProjectMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\8.0\FileMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\VisualStudio\8.0\ProjectMRUList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Direct3D\MostRecentApplication" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\DirectDraw\MostRecentApplication" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\DirectInput\MostRecentApplication" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\ClipArt Gallery\2.0\MRUDescription" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\ClipArt Gallery\2.0\MRUName" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Photo Editor\3.0\Microsoft Photo Editor" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Journal Viewer\MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Acrobat Reader\5.0\AVGeneral\cRecentFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Acrobat Reader\6.0\AVGeneral\cRecentFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Acrobat Reader\7.0\AVGeneral\cRecentFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\ImageReady 7.0\Preferences\URLHistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\ImageReady 7.0\Preferences\SaveDir" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\ImageReady 7.0\Preferences\RecentFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Photoshop\6.0\VisitedDirs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Photoshop\7.0\VisitedDirs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Photoshop\8.0\VisitedDirs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\Photoshop\9.0\VisitedDirs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Adobe\MediaBrowser\MRU\Photoshop\FileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Google\NavClient\1.1\History" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Google\NavClient\1.1\Options" /v KillPopupCount /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Google\Deskbar\termhistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Google\Deskbar\urlhistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Apple Computer, Inc.\QuickTime\Recent Movies" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Andrei Jefremov\AVIPreview by Andrei Jefremov, visit www.avipreview.com for more\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\InstallShield\Developer\7.0\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Ulead Systems\Ulead SmartSaver Pro\3.0\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Terminal Server Client\Default" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\ahead\Nero - Burning Rom\Settings" /v BrowserDir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\ahead\Nero - Burning Rom\Settings" /v ImageDir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\ahead\Nero - Burning Rom\Settings" /v WorkingDir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\ahead\Nero - Burning Rom\Settings" /v BootImageDir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Ahead\Nero - Burning Rom\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\e-merge\WinAce\2.0\Favorites" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\e-merge\WinAce\2.0\MRU Items" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Kazaa\Search" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\WinISO\Reopen" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Gabest\Media Player Classic\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Gabest\Media Player Classic\Recent Dub List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Gabest\Media Player Classic\Capture" /v FileName /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\MessengerService\ListCache\.NET Messenger Service" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\7-ZIP\Compression\ArcHistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\7-ZIP\Extraction\PathHistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\7-Zip\FM" /v CopyHistory /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\7-Zip\FM" /v FolderHistory /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\7-Zip\FM" /v PanelPath0 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\FreshDevices\FreshDownload\History" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Helios\TextPad 4\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Cronosoft\LeechGet\History" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Morpheus\Morpheus\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\DVD Shrink\DVD Shrink 3.2\Recent Targets" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\DVD Shrink\DVD Shrink 3.2\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\DVD Shrink\DVDSHRINK103\TargetFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\DVD Shrink\DVDSHRINK103\SourceFolders" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Google\Google Earth Plus\Search" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Foxit Software\Foxit Reader\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Freeware\VirtualDub\MRU List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\WinRAR\ArcHistory" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\WinRAR\DialogEditHistory\ArcName" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\WinRAR\DialogEditHistory\ExtrPath" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\PowerArchiver\RecentFileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 7\RecentFileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 8\RecentFileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 9\RecentFileList" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 9\WorkspaceMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 9\JascCmdFile\FileSaveAs" /v FileFolder /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Jasc\Paint Shop Pro 9\JascCmdFile\FileOpen" /v Folder /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Corel\Paint Shop Pro\10\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Corel\Paint Shop Pro\10\WorkspaceMRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Corel\Paint Shop Pro\10\CmdFile\FileSaveAs" /v FileFolder /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Corel\Paint Shop Pro\10\CmdFile\FileOpen" /v Folder /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Flash 4\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Flash 5\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Flash 6\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Flash 7\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\HomeSite5\RecentFiles" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Flash MX\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Firework 6\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Dreamweaver 4\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Macromedia\Dreamweaver MX 2004\Recent File List" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\DivXNetworks\The Playa" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\ORL\VNCviewer\MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\RealVNC\VNCviewer4\MRU" /va /f >> "%~dp0"\Clean.log 2>NUL
ECHO. >> "%~dp0"\Clean.log
ECHO SMITFRAUD REGISTRY KILL RESULT ON %HOMEDRIVE% (thanks to S!Ri for SMITFRAUDFIX) >> "%~dp0"\Clean.log
REG DELETE "HKCR\AppID\MyBHOImpl.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\SpywareStrike.EXE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\WStart.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\{70F17C8C-1744-41B6-9D07-575DB448DCC5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\{77a7d7ab-576a-4b90-b4ee-909093c3bc69}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\{78364D99-A640-4ddf-B91A-67EFF8373045}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\AppID\{F6BDB4E5-D6AA-4D1F-8B67-BCB0F2246E21}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{020b1227-417d-4682-9ac3-61f43cb5b6b1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{04f3168f-5afc-4531-b3b4-16ca93720415}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{057e242f-2947-4e0a-8e61-a11345d97ea6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{0878F045-B52E-46B3-9724-D3AE69D50067}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{0976BE78-EA53-4DD6-91E6-E6175940032B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{0BC9BC01-54D4-4CCE-2B7D-955164314CD4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{0EA04667-E53B-4E81-8E7C-DE2CA114CBD6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{0F25878F-F8AE-5D5D-2BB7-31B5F803290D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{125494b2-acad-414c-98b9-452f3ef7703a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{145E6FB1-1256-44ED-A336-8BBA43373BE6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{16875E09-927B-4494-82BD-158A1CD46BA0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{17E02586-A91D-4A9D-A74E-187B05DFFE6F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{187a8428-bd94-470d-a178-a2347f940519}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1B68470C-2DEF-493B-8A4A-8E2D81BE4EA5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1BD98DFD-2DA9-4C54-85D7-BE03A0F9C487}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1C3B31AE-FD16-D2CE-43FF-DC4CD5C1BC5E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1C94EA51-3800-4F08-B5DC-A5B67823FFEA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1ca480cd-c0e5-4548-874e-b85b17905b3a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1CA7DBAF-B066-4554-977E-5CEBB7FA59C8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{1CBC7F79-C21A-4468-8116-38E8AD875816}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{203B1C4D9-BC71-8916-38AD-9DEA5D213614}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{20a3d913-30ef-4e69-b3f7-93b3f1fb9d5c}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{20D1AF34-6E19-42D8-AF9F-BDFBE45C2454}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{21E132C9-1F98-4151-BDAD-7D9B49C60A8E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{23F7AD29-F51A-4BA1-BE70-143B1CB25BD1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{265C2AF8-C94C-4AFF-B2B6-340D3982562C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{27150f81-0877-42e9-af13-55e5a3439a26}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{2865930b-4588-4ff3-8227-6d4f66c92c7a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{29D3E589-2DCC-699E-1A0F-61AF30BAA3A4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{2C1CD3D7-86AC-4068-93BC-A02304BB8C34}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{2C59D5EC-6B91-4896-BD6F-5F121D87A7F8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{2F34E0E0-F0BB-477F-AFB8-509262FA0AD1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{2fe2edc0-9e62-4f34-8a73-bc66dae48ef3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{31EE3286-D785-4E3F-95FC-51D00FDABC01}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{330A77C2-C15A-43B5-055C-B4E35EAED279}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{357a87ed-3e5d-437d-b334-deb7eb4982a3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{35a88e51-b53d-43e9-b8a7-75d4c31b4676}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{35ED274E-3F42-4A78-BBDC-3B7D73E85578}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3946A33D-BBC6-4792-A383-D855E0F76D91}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3a3a8c24-8ff0-4140-9731-54d9483ea70b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3a906593-b4bd-48ed-84b0-3249bed65ef9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3d00a39c-655b-428b-aeb2-2fba03dcc49c}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3D74D140-F780-4AE3-8D6D-F8DC39107213}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3E9B951E-6F72-431B-82CF-4A9FBF2F53BC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{3F245C2A-1558-3CCA-04A8-7AA23B60E40F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{405132A4-5DD1-4BA8-A181-95C8D435093A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{408f660a-9465-44a3-b557-8709dfd992bc}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{41D7BB0A-64E0-4AB2-BD0B-69EA78E462E8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{429F4BB8-7BF7-4152-8011-3C6F9EB7E892}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{4823B0A6-EAB4-4577-9792-C59231379CEA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{49443D6E-CE4E-47A9-8DEB-F5774CE14984}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{49b72a72-01f5-4ae8-bbd7-daa67f1e303b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{4AA55E8C-2C19-4F3A-91EC-43B6DF937C4F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{4da4616d-7e6e-4fd9-a2d5-b6c535733e22}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{4F141CBA-1457-6CCA-03A7-7AA21B61EA0F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{4F93062D-7BDA-48BE-AEB6-88AF2B1FE2D4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{52034AD2-914C-4634-B375-9299631E5525}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{5206DF89-97FC-41AD-BAE3-993E87053A99}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{5321E378-FFAD-4999-8C62-03CA8155F0B3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{5B55C4E3-C179-BA0B-B4FD-F2DB862D6202}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{58E68548-42E2-479D-A9E0-86D9F2EAF02E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{5E5A79A6-C67B-444E-BE58-BD0ACEFCDA07}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{5f6bbd8a-18cf-4d55-8b4c-c9b4c9328dfe}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{64ba30a2-811a-4597-b0af-d551128be340}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{66BD9D4C-FAF3-38B9-F43F-169E15DB1A3C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{67196B3E-55A0-49DE-BA11-66F07DF804DB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{673BA504-3DDA-4851-8B3C-37AE54E2D688}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{6ae3aca6-1be3-4443-98dd-effcfa793d35}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7198F8DA-012C-4DB4-ABD8-923A54C87900}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{724510C3-F3C8-4FB7-879A-D99F29008A2F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7288C0BD-7F2F-4229-A0C4-3C90A6E2A881}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{736B5468-BDAD-41BE-92D0-22AE2DDF7BCB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7507739F-BC2E-4DC3-B233-816783C25DC9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7702C521-76AE-42C0-A181-3B5A96C2EEF7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{78364D99-A640-4ddf-B91A-67EFF8373045}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{784aa380-13f2-422e-8540-f2280f1dd4f1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{787dec39-69d0-40b3-b173-e0411c59b300}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{79ddf2ef-d881-464b-b2af-5af8816a3964}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7A7E6D97-B492-4884-9ABB-C31281DCC4F2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7A932ED2-1737-4AB8-B84D-C71779958551}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7ADDA344-1D36-4446-9F4B-B2351FB19EFD}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7caf96a2-c556-460a-988e-76fc7895d284}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{7D98221E-AF8F-4D29-8BB1-1DFABC288173}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{813c8e86-4c90-4617-b59e-e130cc068140}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{826B2228-BC09-49F2-B5F8-42CE26B1B711}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{826B2228-BC09-49F2-B5F8-42CE26B1B712}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{82847700-FE61-46A3-B3EE-761A1E312ACA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{89133bce-57d0-4d2b-afaf-a97b74ad704e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{893FAD3A-931E-4E53-B515-B1426D63799B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8C2A05C5-780F-4A2E-AE1C-FB8181F860E4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8c56b6ce-c53f-44c4-9bdc-a9bc1711d05a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8D82BB89-B58C-4F21-9C5D-377F65947806}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8d83b16e-0de1-452b-ac52-96ec0b34aa4b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8DCA6B3D-1FCA-4500-B210-76119BB5C69E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8e99f990-b75a-4568-b3c8-24cbc8cbbfc1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8ee6bf73-b370-4d13-9126-eb0071178f2e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{8f40cc34-fe77-4618-aa3d-bd2efacaa8dc}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9114249C-F5E5-36A3-4480-169B869E0556}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{957bab51-81ff-8195-f273-d7e286ea702f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9746B450-6064-4EC8-9480-72A289AA2237}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{97f56e12-c706-4aeb-9ffb-133c05ee5d38}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9896231A-C487-43A5-8369-6EC9B0A96CC0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9bb7e700-4e48-476d-b75c-6f47606be988}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9C5875B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9EAC0102-5E61-2312-BC2D-4D54434D5443}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9F230924-E275-4FD2-BC99-5C30362332E3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{9f89e240-06a6-4e1c-ba84-f267de7db391}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{A2C8F6B1-7C2A-3D1C-A3C6-A1FDA113B43F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{A2D9D3F0-8C2A-2A1D-A376-1BECFB10AB72}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{A6790AA5-C6C7-4BCF-A46D-0FDAC4EA90EB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{AC1B4DA2-12FA-31F2-1A7D-CD2B14E6AD4E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{ACC647EE-991A-4811-B420-F063F50CDDC1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{AEECBFDA-12FA-4881-BDCE-8C3E1CE4B344}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{b0398eca-0bcd-4645-8261-5e9dc70248d0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{B212D577-05B7-4963-911E-4A8588160DFA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{b60a0e56-548d-40ae-9383-d752531f653f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{b67b0756-2528-4996-b4bd-c993614cc0b6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{bcc51ea9-6340-4ebe-8736-13a752ecb0be}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{B75F75B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{BA12780E-B91E-41A7-A51A-528CBD64284E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C0E5FF11-4AE0-4699-A6A7-2FB7118F2081}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C1212066-16A4-F478-E898-BC64A80D4908}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C1A2FDA2-1A5B-2A8F-F3A2-B22DA1A3C41D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C1A2FDA2-2A5B-2C8A-F2A2-BA2DB3A2C31C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C1A8B6A1-2C81-1C3D-A3C6-A1CCDB10B47F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C5A40FCE-0A0F-40CA-985E-661C28B5B431}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C5B70256-5B08-4056-B84E-C6CE084967F5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C7CF1142-0785-4B12-A280-B64681E4D45E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C7F22879-7151-4C71-8C50-9557AFDA66C6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{C9FA1DC9-1FB3-C2A8-2F1A-DC1A33E7AF9D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CA14EE13-ED15-C4A2-17FF-DA4D15C1BC5E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CA5E7959-60B5-47B7-80AC-1606309733F3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{cbcaca58-1aee-4600-8cf0-e8b30bff1535}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CBE4B748-08F9-44DB-8FB1-9AD25979DA35}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CD5E2AC9-25CE-A1C5-D1E2-DC6B28A6ED5A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CDD964C2-FB78-4A74-BB1E-1CB1FCB72018}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{CEABF027-6CDC-4D47-ADF6-AC5D065826A6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{D1A2E7CD-F5C1-21A8-CA2C-13D0AC72D19D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{D25F7446-4D36-4203-9EA5-5422B26FA9D0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{d6d64cdf-0363-4261-b723-29a3af365e1d}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{D7BF3304-138B-4DD5-86EE-491BB6A2286C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{D81E2FC4-B0A2-11D3-21AC-07C04C21A18A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{e0103cd4-d1ce-411a-b75b-4fec072867f4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{E12AAACF-8AF2-4C31-BA94-E3787B44F90E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{E2CA7CD1-1AD9-F1C4-3D2A-DC1A33E7AF9D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{E479197F-49E5-4E60-9FA2-A71D4C7C2BBC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{E802FFFF-8E58-4d2c-A435-8BEEFB10AB77}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{e9719d38-ec55-4c8b-9df0-080ade95a9fa}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{EA26CE12-DE64-A1C5-9A4F-FC1A64E6AC2E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{edbf1bc8-39ab-48eb-a0a9-c75078eb7c8e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{EEE7178C-BBC3-4153-9DDE-CD0E9AB1B5B6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{f4b3e25a-33b4-4647-9a78-b627dde211a6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{F4E04583-354E-4076-BE7D-ED6A80FD66DA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{F33812FB-F35C-4674-90F6-FD757C419C51}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{f79fd28e-36ee-4989-aa61-9dd8e30a82fa}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{F880B4F2-75BF-44EC-B7AA-45EC37448027}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{FCADDC14-BD46-408A-9842-CDBE1C6D37EB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{FEFEC367-0557-50DA-92D8-EFF9A710070B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{FFF5092F-7172-4018-827B-FA5868FB0478}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\VMHomepage" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\VMHomepage.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{001501E7-C970-4CB1-9740-E055BF3DDFD6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{08101c3e-6c90-439e-9734-6e4dd1b53b69}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{09b90087-4ffa-4a44-be69-da117a710f07}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{0f68a8aa-a9a8-4711-be36-ae363efa6443}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{0FBBBC44-296D-4A2F-AF45-BE1EE387F569}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{1449f89c-ad28-427a-97ff-1d5bd812ea43}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{163469FD-6009-48E2-AD8C-47BB2E0D88BE}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{1694E5C6-9E1F-4C3B-B79A-828C2FC40003}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{189518DF-7EBA-4D31-A7E1-73B5BB60E8D5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{1c08d3d0-1e04-4dde-ab0a-75355ea2585e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{1E1B2878-88FF-11D2-8D96-D7ACAC95951F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{200BD3A6-A02B-4BAC-A364-A9D8017E3C4E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{206538f7-f98c-4a46-a7d4-4a37fcdc932b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{20C59F9F-33CB-4B1B-AFB6-B710DB845709}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{20f8b70d-9f16-4dcb-8788-90a0498e46b9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{23D627FE-3F02-44CF-9EE1-7B9E44BD9E13}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{23D80835-4A3A-4572-9F5F-3F24A7A28AE5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{255CDDA3-576B-44C9-B944-46EAC18D5D6F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{28420952-c82b-47d9-a042-fa2217d8a082}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{28fedb90-53c7-4928-994a-cee782606507}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{2C15CDEA-3EF4-4405-90B0-19A1389B36ED}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{2c462d06-3ba0-48bb-9282-bb6519fe86e9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{3115A433-3FA0-483B-AB01-2A61C951FE58}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{3261F690-1CA4-4839-928B-F4F898B74EB7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{376C5E0D-E8DD-4161-B74B-37E6323E538E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{37B9988B-1997-41F4-A832-DAE42CC3F7C2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{3a350193-c7f7-4e10-b347-02ff4c3cc4e9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{3c099c83-8587-4b35-8af0-fc3a169ce14f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{3fe13f31-e890-4c37-8213-4b5f9a511c26}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{43CFEFBE-8AE4-400E-BBE4-A2B61BB140FB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{4723879b-8f52-4be7-9994-626afa539366}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{4cad27dc-1b60-42f4-820e-316fe0a13512}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{50F91B80-0270-46CE-86B1-4C508F5CB280}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{51FEFA9C-1D5A-41C4-81FE-8C0FBE9254F0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{54874d12-c0c6-44cc-83fb-2c35202f881b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{54a3200b-d76e-48d1-b35c-d87eaf6d90bd}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{5790B963-23C5-43C1-BCF5-01C9B5A3E44E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{57F88FBD-FFD2-4AF2-B138-CD644A8E62B5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{5B861FB8-903C-4996-B1D3-E9A86ED4BBCF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{5CCC8D01-9F75-4F07-9ACF-DEB314176C79}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{5D42DDF4-81EB-4668-9951-819A1D5BEFC8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{5E7BF614-960B-4A1F-9236-9EC01AC4C5E2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{663dfe59-032c-46fb-a09a-ffc2dc074f54}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{66F0AC1C-DED5-4965-9E31-39788DF1B264}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{6876543E-DA55-4F90-9CD2-5ED380D9516C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{69ce4fbc-4861-4206-8211-dd5a9ee79ad3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{6DEEE498-08CC-43F0-BCA0-DBB5A25C9501}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{701E8C3A-7910-4CCD-A9F8-7B9A5F5B3947}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{71237FD0-9DF9-46B3-8F1C-6F2998543EA2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{76D06077-D5D3-40CA-B32D-6A67A7FF3F06}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{7b6a3434-8625-4abf-b79d-09d98c2498c4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{849E056A-D67A-431E-9370-2275F26D39B5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{850300D6-D53B-4720-9372-6D31B85537E1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{86C7E6C3-EC47-44E5-AA08-EE0D0A25895F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{8b6c0168-baac-4c7c-911e-0132590f5661}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{8B7AFBFD-631C-45BA-9145-F059EB58DD73}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{8C803228-BD61-4744-8B79-949E3F512DDC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{8ec33b7d-9953-4edb-ace2-d4c105968601}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{9283DAC1-43F5-4580-BF86-841F22AF2335}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{9EF3F6BA-1BF9-4B4E-9475-437A02DBFA8B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{a00e2305-7001-4200-ba00-5779f9a3e7d3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{a20f5672-7486-4d27-bd2b-e555e4692c5f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{a917b2f3-a9bf-477c-a0e3-0382d0376159}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{AE90CAFC-09D4-47F0-9E11-CE621C424F08}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{afa9056f-aa11-4771-ae01-04ecfde18206}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{AFEB8519-0B8B-4023-8C15-FFB17D5225F9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{b26b5883-f15f-4283-b3d5-a1728077de47}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{B7C685F0-1804-4382-A8EF-17D33DF97069}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{b803d266-a08d-4a4c-9604-6d35689abe09}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{b8f2487f-aa6a-4914-9a3f-db84e6868d66}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{BA397E39-F67F-423F-BC6E-65939450093A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{BA9CC151-4581-438E-94AF-4C703201B7CA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{BC74C336-FF2C-40C9-AD4E-3772C208406B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{BDF00F24-A571-4392-95EC-04FDFF82A82C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{BEC8A83D-01D4-4F15-B8A9-4B4AB24253A7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{C4E953E6-770E-4F59-A5E3-43E9F0D682E2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{C4EEDC19-992D-409A-B323-ED57D511AFA5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{c6e2a22c-b3a8-43a4-b5ec-a5bb671ab3f7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{cb9385ab-8541-4b2f-a363-48f64c612993}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{cf1674cc-ec9a-4aee-996e-65a8f7c0b0e4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{D4D2958F-EDBE-430B-AB15-793E921C3A09}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{d5d6e9b5-30d5-4457-ac8b-399205f50411}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{d6a7d177-0b2f-4283-b2e8-b6310a45e606}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{DCFAB192-4A0E-4720-8E24-70D5F0CB8C39}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{DD90F677-D205-4F70-9014-659614AABCB2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{E0105E7C-D0C4-4DEA-AA21-B02F2960ECAF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{e0d6c30a-b9a3-4181-8099-3b0d5a2b98af}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{E3DF91F3-F24F-441E-9001-D61F36024322}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{e4645720-e02f-4bb2-8e6d-be7653dd1bf2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{ED39CB7C-1BF6-429B-A275-F183B4A3EFCB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{f100a342-3ac5-47ff-b5b3-fcdb6fc9f016}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{F23AA637-31D5-4526-B5C6-9FF89E16202C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{f4364eec-31f5-4b8b-a7e0-3b6394c9d23f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{F4394F24-163D-430B-B5AF-B68B56031B99}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Interface\{F459EADB-5903-48D5-864C-2B7B46AB1424}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{fa46b160-c9dd-4040-b9d9-ccf5d3db5438}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{fc1f0c2c-8117-427d-816c-215b68524f74}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{FC4EDF66-0547-4F1A-AE96-7CFCAD711C90}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{fd1eee96-8dc7-478d-be3b-7d06ac67fb66}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\interface\{fd8e5ed7-0091-416f-a55b-1d072d58a24f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ADP.UrlCatcher" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ADP.UrlCatcher.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.foundcollection" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.foundcollection.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.foundobject" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.foundobject.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.killedprocessescollection" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.killedprocessescollection.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.killedprocessinfo" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.killedprocessinfo.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.license" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.license.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.options" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.options.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.quarantine" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.quarantine.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.realtime" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.realtime.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.rtobject" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.rtobject.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.safemode" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.safemode.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.scaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.scaner.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.scanstatistic" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.scanstatistic.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.theapp" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.theapp.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.update" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.update.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.updateinfo" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.updateinfo.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.versioninfo" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\avecore.versioninfo.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Balloon.Application" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\NLS.UrlCatcher" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\NLS.UrlCatcher.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Replace.HBO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Replace.HBO.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\SpecSoft2.BrowserHook" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\SpecSoft2.BrowserHook.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\SpecSoft2.IExplorerHelper" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\SpecSoft2.IExplorerHelper.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TDS.MyBHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TDS.MyBHO.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Tubby.ToolBandObj" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\Tubby.ToolBandObj.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.Window" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.Window.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.WindowCollection" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.WindowCollection.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.WindowLayer" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WndLayer.WindowLayer.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\VMHomepage" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\VMHomepage.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\winapi32.Intelinks" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\winapi32.MyBaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\winapi32.MyBHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WStart.WHttpHelper" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\WStart.WHttpHelper.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.activator" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.activator.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.ParamWr" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.ParamWr.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.StockBar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\ZToolbar.StockBar.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{1E1B286C-88FF-11D2-8D96-D7ACAC95951F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{244B730E-D899-4E38-9428-03D1143242E0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{31E956BF-8CA9-4D75-B534-7EBC79770002}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{661173EE-FA31-4769-97D4-B556B5D09BDA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{6E9E448E-B195-4627-953C-5377FA9BBA36}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{77A7D7AB-576A-4B90-B4EE-909093C3BC69}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{7885264B-8B30-46EB-8361-ECA766800258}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\TypeLib\{84C94803-B5EC-4491-B2BE-7B113E013B77}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\typelib\{982392f9-9c65-48b4-b667-3459c46630d1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\typelib\{B82C3D8C-F764-4B4E-8272-DC1185CE12FC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\typelib\{C1A4C0C9-DBD0-493A-93F8-0B05EDC96224}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\typelib\{f61d1ce1-5199-4b57-b59e-c6819ea92f3b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{0BC9BC01-54D4-4CCE-2B7D-955164314CD4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{1C3B31AE-FD16-D2CE-43FF-DC4CD5C1BC5E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{203B1C4D9-BC71-8916-38AD-9DEA5D213614}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{27150f81-0877-42e9-af13-55e5a3439a26}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{35a88e51-b53d-43e9-b8a7-75d4c31b4676}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{3F245C2A-1558-3CCA-04A8-7AA23B60E40F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{429F4BB8-7BF7-4152-8011-3C6F9EB7E892}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{4F141CBA-1457-6CCA-03A7-7AA21B61EA0F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{64ba30a2-811a-4597-b0af-d551128be340}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{8e99f990-b75a-4568-b3c8-24cbc8cbbfc1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{AC1B4DA2-12FA-31F2-1A7D-CD2B14E6AD4E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{C1A2FDA2-1A5B-2A8F-F3A2-B22DA1A3C41D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{C1A2FDA2-2A5B-2C8A-F2A2-BA2DB3A2C31C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{C9FA1DC9-1FB3-C2A8-2F1A-DC1A33E7AF9D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{CA14EE13-ED15-C4A2-17FF-DA4D15C1BC5E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{CD5E2AC9-25CE-A1C5-D1E2-DC6B28A6ED5A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{D1A2E7CD-F5C1-21A8-CA2C-13D0AC72D19D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{D81E2FC4-B0A2-11D3-21AC-07C04C21A18A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{EA26CE12-DE64-A1C5-9A4F-FC1A64E6AC2E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{E2CA7CD1-1AD9-F1C4-3D2A-DC1A33E7AF9D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Classes\CLSID\{F33812FB-F35C-4674-90F6-FD757C419C51}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\Desktop\Components\1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\IPCheck" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\st3" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\style2" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\style3" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\style32" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{4DA4616D-7E6E-4FD9-A2D5-B6C535733E22}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{736B5468-BDAD-41BE-92D0-22AE2DDF7BCB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\ADV" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\BraveSentry" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\PestTrap" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\SpySheriff" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\SNO2" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\TheSpyGuard" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\.key" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\DailyToolbar.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\WStart.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\MyBHOImpl.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\MalwareWipe.EXE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\SpyAxe.EXE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\SpywareStrike.EXE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\WStart.DLL" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\{70F17C8C-1744-41B6-9D07-575DB448DCC5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\{77a7d7ab-576a-4b90-b4ee-909093c3bc69}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\{78364D99-A640-4ddf-B91A-67EFF8373045}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\AppID\{951B3138-AE8E-4676-A05A-250A5F111631}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\AppID\{F6BDB4E5-D6AA-4D1F-8B67-BCB0F2246E21}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{008E3200-28EB-463b-9B58-75C23D80911A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{06506B3A-857D-431f-BE0B-038B1EC386B3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{081669BA-EFC4-48C2-A8F4-874052D02553}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{0878F045-B52E-46B3-9724-D3AE69D50067}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{0BFF94F7-9748-43d1-BAC4-D963351B63E7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{0C580891-CA9D-4619-BDC9-85378EB65931}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{0EA04667-E53B-4E81-8E7C-DE2CA114CBD6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{0F25878F-F8AE-5D5D-2BB7-31B5F803290D}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{145E6FB1-1256-44ED-A336-8BBA43373BE6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{15DC7116-E58E-4395-A45A-A1C99B17C030}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{17E02586-A91D-4A9D-A74E-187B05DFFE6F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{196B9CB5-4C83-46F7-9B06-9672ECD9D99B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\CLSID\{1B68470C-2DEF-493B-8A4A-8E2D81BE4EA5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1BD98DFD-2DA9-4C54-85D7-BE03A0F9C487}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1C94EA51-3800-4F08-B5DC-A5B67823FFEA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1ca480cd-c0e5-4548-874e-b85b17905b3a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1CA7DBAF-B066-4554-977E-5CEBB7FA59C8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1CBC7F79-C21A-4468-8116-38E8AD875816}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{1D27320E-2DA2-41E2-A103-B5FD9D6A798B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{20D1AF34-6E19-42D8-AF9F-BDFBE45C2454}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{21E132C9-1F98-4151-BDAD-7D9B49C60A8E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{23F7AD29-F51A-4BA1-BE70-143B1CB25BD1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{265C2AF8-C94C-4AFF-B2B6-340D3982562C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{27150f81-0877-42e9-af13-55e5a3439a26}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{29D3E589-2DCC-699E-1A0F-61AF30BAA3A4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{2C1CD3D7-86AC-4068-93BC-A02304BB8C34}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{2C59D5EC-6B91-4896-BD6F-5F121D87A7F8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{2F34E0E0-F0BB-477F-AFB8-509262FA0AD1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{31EE3286-D785-4E3F-95FC-51D00FDABC01}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{330A77C2-C15A-43B5-055C-B4E35EAED279}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{35ED274E-3F42-4A78-BBDC-3B7D73E85578}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{3946A33D-BBC6-4792-A383-D855E0F76D91}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{3D74D140-F780-4AE3-8D6D-F8DC39107213}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{3E9B951E-6F72-431B-82CF-4A9FBF2F53BC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{3F245C2A-1558-3CCA-04A8-7AA23B60E40F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{41D7BB0A-64E0-4AB2-BD0B-69EA78E462E8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{429F4BB8-7BF7-4152-8011-3C6F9EB7E892}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{4823B0A6-EAB4-4577-9792-C59231379CEA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{49443D6E-CE4E-47A9-8DEB-F5774CE14984}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{4AA55E8C-2C19-4F3A-91EC-43B6DF937C4F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{4da4616d-7e6e-4fd9-a2d5-b6c535733e22}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{4F93062D-7BDA-48BE-AEB6-88AF2B1FE2D4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{52034AD2-914C-4634-B375-9299631E5525}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5206DF89-97FC-41AD-BAE3-993E87053A99}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5321E378-FFAD-4999-8C62-03CA8155F0B3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{53525A6C-3774-4b47-B317-BC7DFE4FC7ED}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{58E68548-42E2-479D-A9E0-86D9F2EAF02E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{58F9B276-E1CC-458e-8159-21CBC021874B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5B55C4E3-C179-BA0B-B4FD-F2DB862D6202}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5DEB9A24-19E0-49e6-A6B2-110BC3E1062A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5E1ACE2A-8638-4775-8AA9-5C187AD40A82}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{5E5A79A6-C67B-444E-BE58-BD0ACEFCDA07}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{60e2e76b-60e2e76b-60e2e76b-60e2e76b-60e2e76b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{629C4FE9-B627-4905-AF5B-AD652BB1B5C5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{62E2E094-F989-48C6-B947-6E79DA2294F9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{659F78EA-6FF2-40f8-8EA3-06F7418A209E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{66BD9D4C-FAF3-38B9-F43F-169E15DB1A3C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{67196B3E-55A0-49DE-BA11-66F07DF804DB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{673BA504-3DDA-4851-8B3C-37AE54E2D688}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7198F8DA-012C-4DB4-ABD8-923A54C87900}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{724510C3-F3C8-4FB7-879A-D99F29008A2F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7288C0BD-7F2F-4229-A0C4-3C90A6E2A881}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{736B5468-BDAD-41BE-92D0-22AE2DDF7BCB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7507739F-BC2E-4DC3-B233-816783C25DC9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7616A7F7-DF99-432f-870D-4AFEA0D079F4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7702C521-76AE-42C0-A181-3B5A96C2EEF7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{78364D99-A640-4ddf-B91A-67EFF8373045}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{784aa380-13f2-422e-8540-f2280f1dd4f1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7A932ED2-1737-4AB8-B84D-C71779958551}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7ADDA344-1D36-4446-9F4B-B2351FB19EFD}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7caf96a2-c556-460a-988e-76fc7895d284}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7D98221E-AF8F-4D29-8BB1-1DFABC288173}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{7EB22F36-2CCD-4003-89EE-6CF40EBC4282}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{80bb7465-a638-43b5-9827-8e8fe38dfcc1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{826B2228-BC09-49F2-B5F8-42CE26B1B711}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{82847700-FE61-46A3-B3EE-761A1E312ACA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{8333C319-0669-4893-A418-F56D9249FCA6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{893FAD3A-931E-4E53-B515-B1426D63799B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{8C2A05C5-780F-4A2E-AE1C-FB8181F860E4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{8d83b16e-0de1-452b-ac52-96ec0b34aa4b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{8DCA6B3D-1FCA-4500-B210-76119BB5C69E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9114249C-F5E5-36A3-4480-169B869E0556}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9746B450-6064-4EC8-9480-72A289AA2237}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9896231A-C487-43A5-8369-6EC9B0A96CC0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9C5875B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9EAC0102-5E61-2312-BC2D-4D54434D5443}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{9F230924-E275-4FD2-BC99-5C30362332E3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{A0D06AA3-499B-4156-9FFD-0BE236F0D4E5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{A2C8F6B1-7C2A-3D1C-A3C6-A1FDA113B43F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{A5C70510-5A01-B2A5-CF84-D6DC13859967}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{A6790AA5-C6C7-4BCF-A46D-0FDAC4EA90EB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{AEECBFDA-12FA-4881-BDCE-8C3E1CE4B344}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{ACC647EE-991A-4811-B420-F063F50CDDC1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{b0398eca-0bcd-4645-8261-5e9dc70248d0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{B599C57E-113A-4488-A5E9-BC552C4F1152}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{B6610F1D-DA77-42c4-8300-721D9DA9D70B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{B75F75B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{BA12780E-B91E-41A7-A51A-528CBD64284E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C1212066-16A4-F478-E898-BC64A80D4908}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C1A8B6A1-2C81-1C3D-A3C6-A1CCDB10B47F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C5991634-0185-4B0D-B4F9-6C45597962B7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C5A40FCE-0A0F-40CA-985E-661C28B5B431}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C5B70256-5B08-4056-B84E-C6CE084967F5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C7EDAB2E-D7F9-11D8-BA48-C79B0C409D70}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{C7F22879-7151-4C71-8C50-9557AFDA66C6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{CA5E7959-60B5-47B7-80AC-1606309733F3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{CBE4B748-08F9-44DB-8FB1-9AD25979DA35}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{CDD964C2-FB78-4A74-BB1E-1CB1FCB72018}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{CEABF027-6CDC-4D47-ADF6-AC5D065826A6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{D25F7446-4D36-4203-9EA5-5422B26FA9D0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{D56A1203-1452-EBA1-7294-EE3377770000}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{D7BF3304-138B-4DD5-86EE-491BB6A2286C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{e0103cd4-d1ce-411a-b75b-4fec072867f4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{E0AA0493-C410-4CBD-B1DB-1723374FA8E0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{E12AAACF-8AF2-4C31-BA94-E3787B44F90E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{E479197F-49E5-4E60-9FA2-A71D4C7C2BBC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{E52DEDBB-D168-4BDB-B229-C48160800E81}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{E5D78BD8-3874-4AA0-9D45-CFB79382C484}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{edbf1bc8-39ab-48eb-a0a9-c75078eb7c8e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{EEE7178C-BBC3-4153-9DDE-CD0E9AB1B5B6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{F1FABE79-25FC-46de-8C5A-2C6DB9D64333}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{F4E04583-354E-4076-BE7D-ED6A80FD66DA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{f79fd28e-36ee-4989-aa61-9dd8e30a82fa}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{F880B4F2-75BF-44EC-B7AA-45EC37448027}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Classes\CLSID\{FEFEC367-0557-50DA-92D8-EFF9A710070B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\CLSID\{FFF5092F-7172-4018-827B-FA5868FB0478}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\AlxTB.BHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ADP.UrlCatcher" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ADP.UrlCatcher.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Balloon.Application" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Bridge.brdg" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\DailyToolbar.IEBand" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\DailyToolbar.SysMgr" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\IEToolbar.AffiliateCtl" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\jao.jao" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\PopMenu.Menu" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Popup.HTMLEvent." /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Popup.PopupKiller" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\url_relpacer.URLResolver" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\winapi32.MyBHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{001501E7-C970-4CB1-9740-E055BF3DDFD6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{0B595E3D-27BE-4DA1-A278-CA4D904B5823}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{0BBB0424-E98E-4405-9A94-481854765C80}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{0CBD1CBA-E034-4287-9B49-5F2912E1D33B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{0F3332B5-BC98-48AF-9FAC-05FEC94EBE73}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{0FBBBC44-296D-4A2F-AF45-BE1EE387F569}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{10195311-E434-47A9-ADBA-48839E3F7E4E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{163469FD-6009-48E2-AD8C-47BB2E0D88BE}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{1694E5C6-9E1F-4C3B-B79A-828C2FC40003}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{18575620-E41D-4204-BF6F-964069D80F45}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{189518DF-7EBA-4D31-A7E1-73B5BB60E8D5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{1D1E9B3D-5A4C-4C70-A9B4-5A19E0C625DC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{200BD3A6-A02B-4BAC-A364-A9D8017E3C4E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{23D627FE-3F02-44CF-9EE1-7B9E44BD9E13}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{23D80835-4A3A-4572-9F5F-3F24A7A28AE5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{255CDDA3-576B-44C9-B944-46EAC18D5D6F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{2A34546C-C437-460A-88AF-D4703A548EA9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{2C15CDEA-3EF4-4405-90B0-19A1389B36ED}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{3115A433-3FA0-483B-AB01-2A61C951FE58}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{3261F690-1CA4-4839-928B-F4F898B74EB7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{376C5E0D-E8DD-4161-B74B-37E6323E538E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{37B9988B-1997-41F4-A832-DAE42CC3F7C2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{3D9FD47C-E0B5-4005-9ADE-552980D3761F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{3E5B0894-FE91-4063-BB41-D885C7691581}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{3E60160F-0ED6-4DCC-B6B6-850CDE4FD217}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{4B860BE9-5B96-4443-9714-6ACD89989D1E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{43CFEFBE-8AE4-400E-BBE4-A2B61BB140FB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{479B1AEA-4414-4E43-8CBF-94BFC7C69B56}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{4A2ECC12-46BA-4C52-9749-C0FAF38D507B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{4D6079CB-FD9E-46AF-A896-6E8582E52827}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{4FDBDBAD-FEFE-4C4C-9CC1-1181052AFB12}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{50F91B80-0270-46CE-86B1-4C508F5CB280}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{511A9BB1-917A-414A-88FD-3128E37032A1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{51FEFA9C-1D5A-41C4-81FE-8C0FBE9254F0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5796859D-53C4-46C1-AD6F-2A3C4D4306EB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5790B963-23C5-43C1-BCF5-01C9B5A3E44E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{57F88FBD-FFD2-4AF2-B138-CD644A8E62B5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{597892CA-A878-4A04-978F-DBA8DC2BB2FB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5B861FB8-903C-4996-B1D3-E9A86ED4BBCF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5CCC8D01-9F75-4F07-9ACF-DEB314176C79}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5D42DDF4-81EB-4668-9951-819A1D5BEFC8}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{5E7BF614-960B-4A1F-9236-9EC01AC4C5E2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{66F0AC1C-DED5-4965-9E31-39788DF1B264}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{673A88D4-C0E0-40D2-9B93-AE39D9A1675F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{6876543E-DA55-4F90-9CD2-5ED380D9516C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{701E8C3A-7910-4CCD-A9F8-7B9A5F5B3947}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{71237FD0-9DF9-46B3-8F1C-6F2998543EA2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{74AC67A5-CDB1-4FD2-A30B-47BD59FF28A9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{76D06077-D5D3-40CA-B32D-6A67A7FF3F06}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{7CC220DA-D962-4935-AD3A-21F7CA4962E3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{849E056A-D67A-431E-9370-2275F26D39B5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{850300D6-D53B-4720-9372-6D31B85537E1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{86C7E6C3-EC47-44E5-AA08-EE0D0A25895F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{8B7AFBFD-631C-45BA-9145-F059EB58DD73}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{8C803228-BD61-4744-8B79-949E3F512DDC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{8CBED98F-8DDD-4AF0-A9EA-C75E10C937BC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{9283DAC1-43F5-4580-BF86-841F22AF2335}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{9DD57F95-DA3A-4EDA-9475-27CCF366A4FD}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{9EF3F6BA-1BF9-4B4E-9475-437A02DBFA8B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{A44CAB15-6B7E-406B-9D9B-B1C1C6BA8CDB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{A69107CC-BEC8-4A34-B474-211B0F46A764}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{A6A68CBD-6673-41B1-B997-3F83A25B45B0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{A99AC77F-4DE5-4AA2-810A-35FAB5FC114B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{ABAFA0B4-F78D-42E5-8C31-1A441D01C1DF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{AE90CAFC-09D4-47F0-9E11-CE621C424F08}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{AFEB8519-0B8B-4023-8C15-FFB17D5225F9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B4D9C59B-A091-4D79-90CC-DD92F3BACF63}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B71C7D9A-DA43-4E8B-BB98-1684AC2AF324}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B74B2B6C-9B8D-47D9-872F-E83D475AAF34}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B7B84995-8B92-46BF-94AA-FA2F3DD23B84}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B7C685F0-1804-4382-A8EF-17D33DF97069}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{B8F90F00-CF78-4431-A13F-58B979F7EE20}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{BA397E39-F67F-423F-BC6E-65939450093A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{BA9CC151-4581-438E-94AF-4C703201B7CA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{BC74C336-FF2C-40C9-AD4E-3772C208406B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{BDF00F24-A571-4392-95EC-04FDFF82A82C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{BEC8A83D-01D4-4F15-B8A9-4B4AB24253A7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{C4E953E6-770E-4F59-A5E3-43E9F0D682E2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{C4EEDC19-992D-409A-B323-ED57D511AFA5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{CDEB1FD8-0917-40A2-B915-8FB9D7FDD75C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{CE5ECF63-6065-4B92-8B7E-72B5042C2F25}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{CF277F5A-347E-40C2-BAF0-4F09D0607041}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{D4BFBB89-4BC5-4D13-8D3A-75EDCC0CF50C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{D4D2958F-EDBE-430B-AB15-793E921C3A09}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{D5DE421A-4AA5-4FE3-AA43-7D2A87D6267F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{DD2D402A-DE41-47A6-AAC9-0D756776203E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{DD90F677-D205-4F70-9014-659614AABCB2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{E0105E7C-D0C4-4DEA-AA21-B02F2960ECAF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{E2F430FD-3062-4808-B23F-4B322BFED93F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{E3DF91F3-F24F-441E-9001-D61F36024322}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{E86D0281-FA5A-4E36-B993-84FD87DA9DF1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{E9B91E0C-305A-4DD2-9987-B3B0C254C6DE}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{ED39CB7C-1BF6-429B-A275-F183B4A3EFCB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{EFD28371-A165-4873-A158-421D208FFE5A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{F23AA637-31D5-4526-B5C6-9FF89E16202C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{F459EADB-5903-48D5-864C-2B7B46AB1424}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{FA77AD79-09CF-41FB-B171-CC856F9E737F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Interface\{FC4EDF66-0547-4F1A-AE96-7CFCAD711C90}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\NLS.UrlCatcher" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\NLS.UrlCatcher.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Replace.HBO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Replace.HBO.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpecSoft2.BrowserHook" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpecSoft2.BrowserHook.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpecSoft2.IExplorerHelper" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpecSoft2.IExplorerHelper.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Backup" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Backup.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.EngineListener" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.EngineListener.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Log" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Log.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.LogRecord" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.LogRecord.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Paths" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Paths.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Quarantine" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Quarantine.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.RunAs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.RunAs.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Scanner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.Scanner.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.SearchItem" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.SearchItem.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.ThreatCollection" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyAxe.ThreatCollection.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyFalcon.PopupBlockerConnector" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\SpyFalcon.PopupBlockerConnector.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TDS.MyBHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TDS.MyBHO.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Tubby.ToolBandObj" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\Tubby.ToolBandObj.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\winapi32.Intelinks" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\winapi32.MyBaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\winapi32.MyBHO" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\WStart.WHttpHelper" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\WStart.WHttpHelper.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.activator" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.activator.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.ParamWr" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.ParamWr.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.StockBar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\ZToolbar.StockBar.1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{177E74D6-E1D1-4D15-9D36-85399BA00729}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{244B730E-D899-4E38-9428-03D1143242E0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{2BB3BCBF-411A-4C67-8E69-F4BB301DC333}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{31E956BF-8CA9-4D75-B534-7EBC79770002}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{31F9B5A7-5B94-445D-922C-E97BF52F5FD7}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{547AB549-4DD8-4ea0-B070-F6EA062148FF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{661173EE-FA31-4769-97D4-B556B5D09BDA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{6E9E448E-B195-4627-953C-5377FA9BBA36}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{77A7D7AB-576A-4B90-B4EE-909093C3BC69}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{7885264B-8B30-46EB-8361-ECA766800258}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{B4E17829-DACB-4320-9ABF-DCB382221FC2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{B82C3D8C-F764-4B4E-8272-DC1185CE12FC}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{84C94803-B5EC-4491-B2BE-7B113E013B77}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{c094876d-1b0e-46fa-b6a6-7ffc0f970c27}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Classes\TypeLib\{C1A4C0C9-DBD0-493A-93F8-0B05EDC96224}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\drsmartload" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\curre" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\app paths\antivirusgold.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MalwareWipe.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\spyaxe.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SpyFalcon.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SpywareQuake.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SpywareStrike.exe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{1ca480cd-c0e5-4548-874e-b85b17905b3a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{3e9b951e-6f72-431b-82cf-4a9fbf2f53bc}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{4da4616d-7e6e-4fd9-a2d5-b6c535733e22}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{724510C3-F3C8-4FB7-879A-D99F29008A2F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{7288C0BD-7F2F-4229-A0C4-3C90A6E2A881}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{7A932ED2-1737-4AB8-B84D-C71779958551}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{7caf96a2-c556-460a-988e-76fc7895d284}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{893fad3a-931e-4e53-b515-b1426d63799b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{8d83b16e-0de1-452b-ac52-96ec0b34aa4b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{b0398eca-0bcd-4645-8261-5e9dc70248d0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{e0103cd4-d1ce-411a-b75b-4fec072867f4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{edbf1bc8-39ab-48eb-a0a9-c75078eb7c8e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objecta\{f79fd28e-36ee-4989-aa61-9dd8e30a82fa}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{00000000-59D4-4008-9058-080011001200}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{00000000-C1EC-0345-6EC2-4D0300000000}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{00000000-F09C-02B4-6EC2-AD0300000000}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{0976BE78-EA53-4DD6-91E6-E6175940032B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{16875E09-927B-4494-82BD-158A1CD46BA0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{196B9CB5-4C83-46F7-9B06-9672ECD9D99B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1B68470C-2DEF-493B-8A4A-8E2D81BE4EA5}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1ca480cd-c0e5-4548-874e-b85b17905b3a}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1CBC7F79-C21A-4468-8116-38E8AD875816}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{27150f81-0877-42e9-af13-55e5a3439a26}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{3ceff6cd-6f08-4e4d-bccd-ff7415288c3b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{3e9b951e-6f72-431b-82cf-4a9fbf2f53bc}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{405132A4-5DD1-4BA8-A181-95C8D435093A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{4da4616d-7e6e-4fd9-a2d5-b6c535733e22}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{5321E378-FFAD-4999-8C62-03CA8155F0B3}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{62E2E094-F989-48C6-B947-6E79DA2294F9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{66BD9D4C-FAF3-38B9-F43F-169E15DB1A3C}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{6AC3806F-8B39-4746-9C38-6B01CB7331FF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{724510C3-F3C8-4FB7-879A-D99F29008A2F}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7288C0BD-7F2F-4229-A0C4-3C90A6E2A881}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7507739F-BC2E-4DC3-B233-816783C25DC9}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7A7E6D97-B492-4884-9ABB-C31281DCC4F2}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7A932ED2-1737-4AB8-B84D-C71779958551}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{78364D99-A640-4ddf-B91A-67EFF8373045}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{784aa380-13f2-422e-8540-f2280f1dd4f1}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7b55bb05-0b4d-44fd-81a6-b136188f5deb}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7caf96a2-c556-460a-988e-76fc7895d284}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{826B2228-BC09-49F2-B5F8-42CE26B1B711}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{826B2228-BC09-49F2-B5F8-42CE26B1B712}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{8333c319-0669-4893-a418-f56d9249fca6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\Currentversion\Explorer\Browser Helper Objects\{893fad3a-931e-4e53-b515-b1426d63799b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{8D82BB89-B58C-4F21-9C5D-377F65947806}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{8d83b16e-0de1-452b-ac52-96ec0b34aa4b}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{9114249C-F5E5-36A3-4480-169B869E0556}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{9896231A-C487-43A5-8369-6EC9B0A96CC0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{9C5875B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{9c691a33-7dda-4c2f-be4c-c176083f35cf}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{9EAC0102-5E61-2312-BC2D-4D54434D5443}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{AEECBFDA-12FA-4881-BDCE-8C3E1CE4B344}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{b0398eca-0bcd-4645-8261-5e9dc70248d0}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B212D577-05B7-4963-911E-4A8588160DFA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{B75F75B8-93F3-429D-FF34-660B206D897A}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{BA12780E-B91E-41A7-A51A-528CBD64284E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{C0E5FF11-4AE0-4699-A6A7-2FB7118F2081}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{C7CF1142-0785-4B12-A280-B64681E4D45E}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{e0103cd4-d1ce-411a-b75b-4fec072867f4}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{e52dedbb-d168-4bdb-b229-c48160800e81}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{edbf1bc8-39ab-48eb-a0a9-c75078eb7c8e}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{EEE7178C-BBC3-4153-9DDE-CD0E9AB1B5B6}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4E04583-354E-4076-BE7D-ED6A80FD66DA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{f79fd28e-36ee-4989-aa61-9dd8e30a82fa}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{FCADDC14-BD46-408A-9842-CDBE1C6D37EB}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{FEFEC367-0557-50DA-92D8-EFF9A710070B}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{ffd2825e-0785-40c5-9a41-518f53a8261f}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{FFF5092F-7172-4018-827B-FA5868FB0478}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\Currentversion\Explorer\Browser Helper Objects\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFA}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\Currentversion\Explorer\Browser Helper Objects\{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\AdwareSheriff_is1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\Alexa Toolbar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\AlfaCleaner.com_is1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\antivirusgold" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\BlueScreen W@rning" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\BraveSentry" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\bridge" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\microsoft\windows\currentversion\uninstall\Daily Weather Forecast" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Desktop Uninstall" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Internet update" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Internet Connection Update and HomeP KB234087" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MalwareWipe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PestTrap" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PSGuard" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Security Toolbar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpyAxe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\The Spy Guard" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpyKiller" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpyFalcon" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpySheriff" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Spy Sheriff" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpywareQuake" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpywareQuake.com" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpywareSheriff_is1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SpywareStrike" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Spyware Soft Stop_is1" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinHound spyware remover" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Alexa Internet" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Alexa Toolbar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\DailyToolbar" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\muwq" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\NIX Solutions" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Licenses" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\AdwareDelete" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\AntivirusGold" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\MalwareWipe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\RespondMiter" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\ShudderLTD\PSGuard" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Software\TPS108" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\SpyAxe" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\SpyFalcon" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\SpywareQuake" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\SpywareQuake.com" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\SpywareStrike" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\TDS" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Transponder" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\WMuse" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\WSoft" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\ZEROSOFT" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\ZSearchCo\ZSearch" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\browsela" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\gg" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\ggg" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\gggg" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\ggggg" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\gs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\nuclabdll" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\msupdate" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\style2" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\style32" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\st3" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\st3i" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Enum\Root\LEGACY_ALFACLEANER" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Enum\Root\LEGACY_ALFACLEANERSERVICE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Enum\Root\LEGACY_RPCXSS" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\Eventlog\System\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\alfacleaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\RpcxSs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet002\Enum\Root\LEGACY_ALFACLEANERSERVICE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet002\Services\alfacleaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet002\Services\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet002\Services\Eventlog\System\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet003\Services\HTTP\Parameters\S" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet003\Services\SharedAccess\Parameters\r" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_ALFACLEANER" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_ALFACLEANERSERVICE" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_RPCXSS" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Services\alfacleaner" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Services\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Services\RpcxSs" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System\AlfaCleanerService" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Code Store Database\Distribution Units\{10003000-1000-0000-1000-000000000000}" /va /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCR\CLSID\{00020424-0000-0000-C000-000000000046}" /v InprocServer32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\" /v ColorTable19 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\" /v ColorTable20 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Control Panel\Colors" /v WallpaperStyle /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Control Panel\Desktop" /v Wallpaper /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Control Panel\Desktop" /v WallpaperStyle /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v Default_Page_URL /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v HomeOldSP /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Search Bar" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Use Search Asst" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\Search" /v SearchAssistant /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser" /v {736B5468-BDAD-41BE-92D0-22AE2DDF7BCB} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoComponents /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoAddingComponents /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoDeletingComponents /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoEditingComponents /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoHTMLWallpaper /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoSaveSettings /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktopChanges /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ForceActiveDesktopOn /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktop /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoThemesTab /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ClassicShell /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispAppearancePage /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispBackgroundPage /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispCpl /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispScrSavPage /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoDispSettingsPage /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoVisualStyleChoice /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoColorChoice /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v NoSizeChoice /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v SetVisualStyle /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v aupd /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v BraveSentry /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v bxproxy /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v CU1 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v CU2 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v ieengine /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Intel system tool" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Key /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v mquu /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v multitran /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v muwq /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v netfilt4 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v pro /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Paytime /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v PestTrap /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v qofk /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v qwum /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v services32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SNInstall /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SpySheriff /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SpyKiller /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v System /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v taskdir /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v tetriz3 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "The Spy Guard" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "The Spy Guard Monitor" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v truetype /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsFY /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsFZ /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsUpdateNT /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows installer" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows update loader" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WinMedia /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v xp_system /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Srv32 spool service" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Svr32 spool service" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v run /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft" /v ATI_VER /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Desktop\General" /v WallpaperFileTime /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Desktop\General" /v WallpaperLocalFileTime /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Search Bar" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Toolbar" /v {736B5468-BDAD-41BE-92D0-22AE2DDF7BCB} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Toolbar" /v {9EAC0102-5E61-2312-BC2D-4D54434D5443} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\Toolbar" /v {A6790AA5-C6C7-4BCF-A46D-0FDAC4EA90EB} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\URLSearchHooks" /v {66BD9D4C-FAF3-38B9-F43F-169E15DB1A3C} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\URLSearchHooks" /v {9114249C-F5E5-36A3-4480-169B869E0556} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\URLSearchHooks" /v {FEFEC367-0557-50DA-92D8-EFF9A710070B} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {0BC9BC01-54D4-4CCE-2B7D-955164314CD4} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {16875E09-927B-4494-82BD-158A1CD46BA0} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {1B68470C-2DEF-493B-8A4A-8E2D81BE4EA5} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {1C3B31AE-FD16-D2CE-43FF-DC4CD5C1BC5E} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {203B1C4D9-BC71-8916-38AD-9DEA5D213614} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {2C1CD3D7-86AC-4068-93BC-A02304BB8C34} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {31EE3286-D785-4E3F-95FC-51D00FDABC01} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {35a88e51-b53d-43e9-b8a7-75d4c31b4676} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {3F245C2A-1558-3CCA-04A8-7AA23B60E40F} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {429F4BB8-7BF7-4152-8011-3C6F9EB7E892} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {4F141CBA-1457-6CCA-03A7-7AA21B61EA0F} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {64ba30a2-811a-4597-b0af-d551128be340} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {6AC3806F-8B39-4746-9C38-6B01CB7331FF} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {7A7E6D97-B492-4884-9ABB-C31281DCC4F2} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {8e99f990-b75a-4568-b3c8-24cbc8cbbfc1} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {A2C8F6B1-7C2A-3D1C-A3C6-A1FDA113B43F} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {A2D9D3F0-8C2A-2A1D-A376-1BECFB10AB72} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {AC1B4DA2-12FA-31F2-1A7D-CD2B14E6AD4E} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {B212D577-05B7-4963-911E-4A8588160DFA} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {C1A2FDA2-1A5B-2A8F-F3A2-B22DA1A3C41D} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {C1A2FDA2-2A5B-2C8A-F2A2-BA2DB3A2C31C} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {C1A8B6A1-2C81-1C3D-A3C6-A1CCDB10B47F} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {C7CF1142-0785-4B12-A280-B64681E4D45E} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {C9FA1DC9-1FB3-C2A8-2F1A-DC1A33E7AF9D} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {CA14EE13-ED15-C4A2-17FF-DA4D15C1BC5E} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {CD5E2AC9-25CE-A1C5-D1E2-DC6B28A6ED5A} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {D1A2E7CD-F5C1-21A8-CA2C-13D0AC72D19D} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {D56A1203-1452-EBA1-7294-EE3377770000} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {D81E2FC4-B0A2-11D3-21AC-07C04C21A18A} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {EA26CE12-DE64-A1C5-9A4F-FC1A64E6AC2E} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {E2CA7CD1-1AD9-F1C4-3D2A-DC1A33E7AF9D} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {E802FFFF-8E58-4d2c-A435-8BEEFB10AB77} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {F33812FB-F35C-4674-90F6-FD757C419C51} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler" /v {FCADDC14-BD46-408A-9842-CDBE1C6D37EB} /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktopChanges /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktop /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v dcomcfg.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v kernel32.dll /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v msmsgs.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v notepad.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v notepad2.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v nvctrl.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v paint.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v popuper.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v shnlog.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v wininet.dll /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\explorer\run" /v winlogon.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v 3.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v 4.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v 3.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v 4.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v A.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v A.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v AdService /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v adtech2005 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v adtech2006 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Adware.Srv32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v AlfaCleaner /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v B.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v B.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v BatSrv /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v bxproxy /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v C.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v C.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v combo.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v ControlPanel /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v CsRss /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v D.tmp /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v D.tmp.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v d3dn32.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v d3pb.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Daily Weather Forecast /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v defender /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v drsmartloadb /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v ecsiin /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Explorer32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Fast Start /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v FH /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v FHPage /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v FHStart /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v FSH /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v gimmysmileys /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v HostSrv /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v ieyi.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v intel32.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v intell321.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v intell32.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Intel system tool /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v keyboard /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v load32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v lich /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v links /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v MalwareWipe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Microsoft Office /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Microsoft standard protector /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v mousepad /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v MSN Messenger /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v multitran /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v netfilt4 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v newname /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v NTCommLib3 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Paytime /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v pop06ap /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v P.S.Guard /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PSGuard /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PSGuard spyware remover /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v RegSvr32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v sdkqq.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SpyAxe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SpyFalcon /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SpywareQuake /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SpywareQuake.com /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SpywareStrike /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Software Soft Stop /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Start Page /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v sysjv32.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v sysen.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v sysvx /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v System /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v System Redirect /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SystemLoader /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v SysTray /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v tetriz3 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v timessquare /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Transponder /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v truetype /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Win32.Virus.Smart32 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Win32.Exploit.A /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v windesktop /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WindowsFZ /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WindowsUpdate /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WindowsUpdateNT /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v WinHound /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v winsysban /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v winsysupd /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v xp_system /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v yaemu.exe /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v ZPoint /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Srv32 spool service" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "Svr32 spool service" /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v tlc /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v Explorer64 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v multitran /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v SystemTools /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v tetriz3 /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v truetype /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices" /v windesktop /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad" /v DCOM Server /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Control\Session Manager" /v AllowProtectedRenames /f >> "%~dp0"\Clean.log 2>NUL
REG DELETE "HKLM\SYSTEM\ControlSet001\Control\Session Manager" /v PendingFileRenameOperations /f >> "%~dp0"\Clean.log 2>NUL

:SMITFRAUD
IF "%FRAUD%" NEQ "YES" GOTO EXTEND
ECHO. >> "%~dp0"\Clean.log
ECHO SMITFRAUD FILE INFECTION SCAN ON %HOMEDRIVE% >> "%~dp0"\Clean.log
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
CD /d %HOMEDRIVE%\ > NUL 2>&1
IF "%NOKILL%" == "YES" GOTO NOTASKKILL
TASKKILL /im 1.tmp /T /F >NUL 2>&1
TASKKILL /im 3.tmp /T /F >NUL 2>&1
TASKKILL /im 4.tmp /T /F >NUL 2>&1
TASKKILL /im a.exe /T /F >NUL 2>&1
TASKKILL /im adsmart.exe /T /F >NUL 2>&1
TASKKILL /im adtech2005.exe /T /F >NUL 2>&1
TASKKILL /im adtech2006a.exe /T /F >NUL 2>&1
TASKKILL /im AlfaCleaner.exe /T /F >NUL 2>&1
TASKKILL /im AntivirusGold.exe /T /F >NUL 2>&1
TASKKILL /im asheriff.exe /T /F >NUL 2>&1
TASKKILL /im atmclk.exe /T /F >NUL 2>&1
TASKKILL /im batserv2.exe /T /F >NUL 2>&1
TASKKILL /im BraveSentry.exe /T /F >NUL 2>&1
TASKKILL /im bsw.exe /T /F >NUL 2>&1
TASKKILL /im bu.exe /T /F >NUL 2>&1
TASKKILL /im bxproxy.exe /T /F >NUL 2>&1
TASKKILL /im cmd32.exe /T /F >NUL 2>&1
TASKKILL /im cmdtel.exe /T /F >NUL 2>&1
TASKKILL /im combo.exe /T /F >NUL 2>&1
TASKKILL /im contextplus.exe /T /F >NUL 2>&1
TASKKILL /im CWS_iestart.exe /T /F >NUL 2>&1
TASKKILL /im d3dn32.exe /T /F >NUL 2>&1
TASKKILL /im d3pb.exe /T /F >NUL 2>&1
TASKKILL /im dcomcfg.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq1.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq2.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq3.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq4.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq5.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq6.exe /T /F >NUL 2>&1
TASKKILL /im dlh9jkdq7.exe /T /F >NUL 2>&1
TASKKILL /im doser.exe /T /F >NUL 2>&1
TASKKILL /im dfrgsrv.exe /T /F >NUL 2>&1
TASKKILL /im drsmartload95a.exe /T /F >NUL 2>&1
TASKKILL /im dxole32.exe /T /F >NUL 2>&1
TASKKILL /im ecsiin.stub.exe /T /F >NUL 2>&1
TASKKILL /im efsdfgxg.exe /T /F >NUL 2>&1
TASKKILL /im exa32.exe /T /F >NUL 2>&1
TASKKILL /im exeha2.exe /T /F >NUL 2>&1
TASKKILL /im exeha3.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys1.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys2.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys3.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys4.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys5.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys6.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys7.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys8.exe /T /F >NUL 2>&1
TASKKILL /im gimmysmileys9.exe /T /F >NUL 2>&1
TASKKILL /im gunist.exe /T /F >NUL 2>&1
TASKKILL /im helper.exe /T /F >NUL 2>&1
TASKKILL /im hookdump.exe /T /F >NUL 2>&1
TASKKILL /im ieengine.exe /T /F >NUL 2>&1
TASKKILL /im ieyi.exe /T /F >NUL 2>&1
TASKKILL /im intel32.exe /T /F >NUL 2>&1
TASKKILL /im intell321.exe /T /F >NUL 2>&1
TASKKILL /im intell32.exe /T /F >NUL 2>&1
TASKKILL /im intmon.exe /T /F >NUL 2>&1
TASKKILL /im intmonp.exe /T /F >NUL 2>&1
TASKKILL /im intxt.exe /T /F >NUL 2>&1
TASKKILL /im kernels8.exe /T /F >NUL 2>&1
TASKKILL /im kernels32.exe /T /F >NUL 2>&1
TASKKILL /im kernels64.exe /T /F >NUL 2>&1
TASKKILL /im keyboard.exe /T /F >NUL 2>&1
TASKKILL /im keyboard1.exe /T /F >NUL 2>&1
TASKKILL /im keyboard2.exe /T /F >NUL 2>&1
TASKKILL /im keyboard3.exe /T /F >NUL 2>&1
TASKKILL /im keyboard4.exe /T /F >NUL 2>&1
TASKKILL /im keyboard5.exe /T /F >NUL 2>&1
TASKKILL /im keyboard6.exe /T /F >NUL 2>&1
TASKKILL /im keyboard7.exe /T /F >NUL 2>&1
TASKKILL /im keyboard8.exe /T /F >NUL 2>&1
TASKKILL /im keyboard9.exe /T /F >NUL 2>&1
TASKKILL /im kl.exe /T /F >NUL 2>&1
TASKKILL /im kl1.exe /T /F >NUL 2>&1
TASKKILL /im latest.exe /T /F >NUL 2>&1
TASKKILL /im lich.exe /T /F >NUL 2>&1
TASKKILL /im links.exe /T /F >NUL 2>&1
TASKKILL /im ll.exe /T /F >NUL 2>&1
TASKKILL /im loadadv728.exe /T /F >NUL 2>&1
TASKKILL /im loader.exe /T /F >NUL 2>&1
TASKKILL /im MalwareWipe.exe /T /F >NUL 2>&1
TASKKILL /im maxd1.exe /T /F >NUL 2>&1
TASKKILL /im maxd64.exe /T /F >NUL 2>&1
TASKKILL /im mirarsearch_toolbar.exe /T /F >NUL 2>&1
TASKKILL /im mousepad.exe /T /F >NUL 2>&1
TASKKILL /im mousepad1.exe /T /F >NUL 2>&1
TASKKILL /im mousepad2.exe /T /F >NUL 2>&1
TASKKILL /im mousepad3.exe /T /F >NUL 2>&1
TASKKILL /im mousepad4.exe /T /F >NUL 2>&1
TASKKILL /im mousepad5.exe /T /F >NUL 2>&1
TASKKILL /im mousepad6.exe /T /F >NUL 2>&1
TASKKILL /im mousepad7.exe /T /F >NUL 2>&1
TASKKILL /im mousepad8.exe /T /F >NUL 2>&1
TASKKILL /im mousepad9.exe /T /F >NUL 2>&1
TASKKILL /im ms1.exe /T /F >NUL 2>&1
TASKKILL /im mscornet.exe /T /F >NUL 2>&1
TASKKILL /im mssearchnet.exe /T /F >NUL 2>&1
TASKKILL /im msmsgs.exe /T /F >NUL 2>&1
TASKKILL /im msole32.exe /T /F >NUL 2>&1
TASKKILL /im msvcp.exe /T /F >NUL 2>&1
TASKKILL /im mswinb32.exe /T /F >NUL 2>&1
TASKKILL /im mswinf32.exe /T /F >NUL 2>&1
TASKKILL /im multitran.exe /T /F >NUL 2>&1
TASKKILL /im muwqa.exe /T /F >NUL 2>&1
TASKKILL /im muwql.exe /T /F >NUL 2>&1
TASKKILL /im muwqm.exe /T /F >NUL 2>&1
TASKKILL /im muwqp.exe /T /F >NUL 2>&1
TASKKILL /im netfilt4.exe /T /F >NUL 2>&1
TASKKILL /im newname1.exe /T /F >NUL 2>&1
TASKKILL /im newname2.exe /T /F >NUL 2>&1
TASKKILL /im newname3.exe /T /F >NUL 2>&1
TASKKILL /im newname4.exe /T /F >NUL 2>&1
TASKKILL /im newname5.exe /T /F >NUL 2>&1
TASKKILL /im newname6.exe /T /F >NUL 2>&1
TASKKILL /im newname7.exe /T /F >NUL 2>&1
TASKKILL /im newname8.exe /T /F >NUL 2>&1
TASKKILL /im newname9.exe /T /F >NUL 2>&1
TASKKILL /im NTCommLib3.exe /T /F >NUL 2>&1
TASKKILL /im ntdetecd.exe /T /F >NUL 2>&1
TASKKILL /im ntnc.exe /T /F >NUL 2>&1
TASKKILL /im ntps.exe /T /F >NUL 2>&1
TASKKILL /im nvctrl.exe /T /F >NUL 2>&1
TASKKILL /im officescan.exe /T /F >NUL 2>&1
TASKKILL /im ole32vbs.exe /T /F >NUL 2>&1
TASKKILL /im ongi.exe /T /F >NUL 2>&1
TASKKILL /im osaupd.exe /T /F >NUL 2>&1
TASKKILL /im parad.raw.exe /T /F >NUL 2>&1
TASKKILL /im paradise.raw.exe /T /F >NUL 2>&1
TASKKILL /im paytime.exe /T /F >NUL 2>&1
TASKKILL /im PestTrap.exe /T /F >NUL 2>&1
TASKKILL /im pop06ap2.exe /T /F >NUL 2>&1
TASKKILL /im popuper.exe /T /F >NUL 2>&1
TASKKILL /im priva.exe /T /F >NUL 2>&1
TASKKILL /im r.exe /T /F >NUL 2>&1
TASKKILL /im reger.exe /T /F >NUL 2>&1
TASKKILL /im regperf.exe /T /F >NUL 2>&1
TASKKILL /im repigsp.exe /T /F >NUL 2>&1
TASKKILL /im runsrv32.exe /T /F >NUL 2>&1
TASKKILL /im sachostc.exe /T /F >NUL 2>&1
TASKKILL /im sachostp.exe /T /F >NUL 2>&1
TASKKILL /im sachosts.exe /T /F >NUL 2>&1
TASKKILL /im sachostx.exe /T /F >NUL 2>&1
TASKKILL /im sdfdil.exe /T /F >NUL 2>&1
TASKKILL /im sdkqq.exe /T /F >NUL 2>&1
TASKKILL /im sender.exe /T /F >NUL 2>&1
TASKKILL /im shdochp.exe /T /F >NUL 2>&1
TASKKILL /im shdocsvc.exe /T /F >NUL 2>&1
TASKKILL /im shell386.exe /T /F >NUL 2>&1
TASKKILL /im shnlog.exe /T /F >NUL 2>&1
TASKKILL /im services32.exe /T /F >NUL 2>&1
TASKKILL /im socks.exe /T /F >NUL 2>&1
TASKKILL /im split.exe /T /F >NUL 2>&1
TASKKILL /im split1.exe /T /F >NUL 2>&1
TASKKILL /im split2.exe /T /F >NUL 2>&1
TASKKILL /im spoolsrv32.exe /T /F >NUL 2>&1
TASKKILL /im spyaxe.exe /T /F >NUL 2>&1
TASKKILL /im spyguard.exe /T /F >NUL 2>&1
TASKKILL /im spyguard_monitor.exe /T /F >NUL 2>&1
TASKKILL /im SpyFalcon.exe /T /F >NUL 2>&1
TASKKILL /im spysheriff.exe /T /F >NUL 2>&1
TASKKILL /im SpywareQuake.exe /T /F >NUL 2>&1
TASKKILL /im Spyware-Quake.exe /T /F >NUL 2>&1
TASKKILL /im spywarestrike.exe /T /F >NUL 2>&1
TASKKILL /im "Spyware Soft Stop.exe" /T /F >NUL 2>&1
TASKKILL /im susp.exe /T /F >NUL 2>&1
TASKKILL /im svchop.exe /T /F >NUL 2>&1
TASKKILL /im svchosts.exe /T /F >NUL 2>&1
TASKKILL /im svcnt.exe /T /F >NUL 2>&1
TASKKILL /im svcnt32.exe /T /F >NUL 2>&1
TASKKILL /im svwhost.exe /T /F >NUL 2>&1
TASKKILL /im symsvcsa.exe /T /F >NUL 2>&1
TASKKILL /im sysbho.exe /T /F >NUL 2>&1
TASKKILL /im sysen.exe /T /F >NUL 2>&1
TASKKILL /im sysinit32z.exe /T /F >NUL 2>&1
TASKKILL /im sysjv32.exe /T /F >NUL 2>&1
TASKKILL /im sysldr32.exe /T /F >NUL 2>&1
TASKKILL /im sysvcs.exe /T /F >NUL 2>&1
TASKKILL /im sysvx.exe /T /F >NUL 2>&1
TASKKILL /im sysvx_.exe /T /F >NUL 2>&1
TASKKILL /im sywsvcs.exe /T /F >NUL 2>&1
TASKKILL /im taras.exe /T /F >NUL 2>&1
TASKKILL /im temp.000.exe /T /F >NUL 2>&1
TASKKILL /im tetriz3.exe /T /F >NUL 2>&1
TASKKILL /im timessquare.exe /T /F >NUL 2>&1
TASKKILL /im tool1.exe /T /F >NUL 2>&1
TASKKILL /im tool2.exe /T /F >NUL 2>&1
TASKKILL /im tool3.exe /T /F >NUL 2>&1
TASKKILL /im tool4.exe /T /F >NUL 2>&1
TASKKILL /im tool5.exe /T /F >NUL 2>&1
TASKKILL /im toolbar.exe /T /F >NUL 2>&1
TASKKILL /im truetype.exe /T /F >NUL 2>&1
TASKKILL /im uninst.exe /T /F >NUL 2>&1
TASKKILL /im uninstDsk /T /F >NUL 2>&1
TASKKILL /im uninstIU.exe /T /F >NUL 2>&1
TASKKILL /im VCClient.exe /T /F >NUL 2>&1
TASKKILL /im VCMain.exe /T /F >NUL 2>&1
TASKKILL /im w8673492.exe /T /F >NUL 2>&1
TASKKILL /im weather.exe /T /F >NUL 2>&1
TASKKILL /im web.exe /T /F >NUL 2>&1
TASKKILL /im win64.exe /T /F >NUL 2>&1
TASKKILL /im windesktop.exe /T /F >NUL 2>&1
TASKKILL /im WinHound.exe /T /F >NUL 2>&1
TASKKILL /im winldra.exe /T /F >NUL 2>&1
TASKKILL /im winmuse.exe /T /F >NUL 2>&1
TASKKILL /im winnook.exe /T /F >NUL 2>&1
TASKKILL /im winsrv32.exe /T /F >NUL 2>&1
TASKKILL /im winstall.exe /T /F >NUL 2>&1
TASKKILL /im winsysupd.exe /T /F >NUL 2>&1
TASKKILL /im winsysban.exe /T /F >NUL 2>&1
TASKKILL /im winsysban8.exe /T /F >NUL 2>&1
TASKKILL /im wp.exe /T /F >NUL 2>&1
TASKKILL /im wupdmgr.exe /T /F >NUL 2>&1
TASKKILL /im xpupdate.exe /T /F >NUL 2>&1
TASKKILL /im xxx.exe /T /F >NUL 2>&1
TASKKILL /im yaemu.exe /T /F >NUL 2>&1
TASKKILL /im z11.exe /T /F >NUL 2>&1
TASKKILL /im z12.exe /T /F >NUL 2>&1
TASKKILL /im z13.exe /T /F >NUL 2>&1
TASKKILL /im z14.exe /T /F >NUL 2>&1
TASKKILL /im z15.exe /T /F >NUL 2>&1
TASKKILL /im z16.exe /T /F >NUL 2>&1
TASKKILL /im zloader3.exe /T /F >NUL 2>&1
:NOTASKKILL
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
pushd %HOMEDRIVE%\ > NUL 2>&1
IF EXIST bsw.exe (ATTRIB -r -s -h bsw.exe > NUL 2>&1) & (DEL /A /F /Q bsw.exe > NUL 2>&1) & (ECHO %CD%bsw.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST contextplus.exe (ATTRIB -r -s -h contextplus.exe > NUL 2>&1) & (DEL /A /F /Q contextplus.exe > NUL 2>&1) & (ECHO %CD%contextplus.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST country.exe (ATTRIB -r -s -h country.exe > NUL 2>&1) & (DEL /A /F /Q country.exe > NUL 2>&1) & (ECHO %CD%country.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST drsmartload1.exe (ATTRIB -r -s -h drsmartload1.exe > NUL 2>&1) & (DEL /A /F /Q drsmartload1.exe > NUL 2>&1) & (ECHO %CD%drsmartload1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST drsmartloadb.exe (ATTRIB -r -s -h drsmartloadb.exe > NUL 2>&1) & (DEL /A /F /Q drsmartloadb.exe > NUL 2>&1) & (ECHO %CD%drsmartloadb.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ecsiin.stub.exe (ATTRIB -r -s -h ecsiin.stub.exe > NUL 2>&1) & (DEL /A /F /S /Q ecsiin.stub.exe > NUL 2>&1) & (ECHO %CD%ecsiin.stub.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST exit (ATTRIB -r -s -h exit > NUL 2>&1) & (del /a /f /Q exit > NUL 2>&1) & (ECHO %CD%exit >> "%~dp0"\Clean.log 2>NUL)
IF EXIST gimmysmileys.exe (ATTRIB -r -s -h gimmysmileys.exe > NUL 2>&1) & (DEL /A /F /Q gimmysmileys.exe > NUL 2>&1) & (ECHO %CD%gimmysmileys.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST gimmysmileys?.exe (ATTRIB -r -s -h gimmysmileys?.exe > NUL 2>&1) & (DEL /A /F /Q gimmysmileys?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard.exe (ATTRIB -r -s -h keyboard.exe > NUL 2>&1) & (DEL /A /F /Q keyboard.exe > NUL 2>&1) & (ECHO %CD%keyboard.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard?.exe (ATTRIB -r -s -h keyboard?.exe > NUL 2>&1) & (DEL /A /F /Q keyboard?.exe > NUL 2>&1) & (ECHO %CD%keyboard?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard??.exe (ATTRIB -r -s -h keyboard??.exe > NUL 2>&1) & (DEL /A /F /Q keyboard??.exe > NUL 2>&1) & (ECHO %CD%keyboard??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kl1.exe (ATTRIB -r -s -h kl1.exe > NUL 2>&1) & (DEL /A /F /Q kl1.exe > NUL 2>&1) & (ECHO %CD%kl1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST loader.exe (ATTRIB -r -s -h loader.exe > NUL 2>&1) & (DEL /A /F /Q loader.exe > NUL 2>&1) & (ECHO %CD%loader.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad.exe (ATTRIB -r -s -h mousepad.exe > NUL 2>&1) & (DEL /A /F /Q mousepad.exe > NUL 2>&1) & (ECHO %CD%mousepad.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad?.exe (ATTRIB -r -s -h mousepad?.exe > NUL 2>&1) & (DEL /A /F /Q mousepad?.exe > NUL 2>&1) & (ECHO %CD%mousepad?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad??.exe (ATTRIB -r -s -h mousepad??.exe > NUL 2>&1) & (DEL /A /F /Q mousepad??.exe > NUL 2>&1) & (ECHO %CD%mousepad??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ms1.exe (ATTRIB -r -s -h ms1.exe > NUL 2>&1) & (DEL /A /F /Q ms1.exe > NUL 2>&1) & (ECHO %CD%ms1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST newname?.exe (ATTRIB -r -s -h newname?.exe > NUL 2>&1) & (DEL /A /F /Q newname?.exe > NUL 2>&1) & (ECHO %CD%newname?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST newname??.exe (ATTRIB -r -s -h newname??.exe > NUL 2>&1) & (DEL /A /F /Q newname??.exe > NUL 2>&1) & (ECHO %CD%newname??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ntdetecd.exe (ATTRIB -r -s -h ntdetecd.exe > NUL 2>&1) & (DEL /A /F /Q ntdetecd.exe > NUL 2>&1) & (ECHO %CD%ntdetecd.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ntnc.exe (ATTRIB -r -s -h ntnc.exe > NUL 2>&1) & (DEL /A /F /Q ntnc.exe > NUL 2>&1) & (ECHO %CD%ntfc.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ntps.exe (ATTRIB -r -s -h ntps.exe > NUL 2>&1) & (DEL /A /F /Q ntps.exe > NUL 2>&1) & (ECHO %CD%ntps.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST r.exe (ATTRIB -r -s -h r.exe > NUL 2>&1) & (DEL /A /Q r.exe > NUL 2>&1) & (ECHO %CD%r.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST secure32.html (ATTRIB -r -s -h secure32.html > NUL 2>&1) & (DEL /A /F /S /Q secure32.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST stub_113_4_0_4_0.exe (ATTRIB -r -s -h stub_113_4_0_4_0.exe > NUL 2>&1) & (DEL /A /F /S /Q stub_113_4_0_4_0.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool1.exe (ATTRIB -r -s -h tool1.exe > NUL 2>&1) & (DEL /A /F /Q tool1.exe > NUL 2>&1) & (ECHO %CD%tool1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool2.exe (ATTRIB -r -s -h tool2.exe > NUL 2>&1) & (DEL /A /F /Q tool2.exe > NUL 2>&1) & (ECHO %CD%tool2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool3.exe (ATTRIB -r -s -h tool3.exe > NUL 2>&1) & (DEL /A /F /Q tool3.exe > NUL 2>&1) & (ECHO %CD%tool3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool4.exe (ATTRIB -r -s -h tool4.exe > NUL 2>&1) & (DEL /A /F /Q tool4.exe > NUL 2>&1) & (ECHO %CD%tool4.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool5.exe (ATTRIB -r -s -h tool5.exe > NUL 2>&1) & (DEL /A /F /Q tool5.exe > NUL 2>&1) & (ECHO %CD%tool5.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST toolbar.exe (ATTRIB -r -s -h toolbar.exe > NUL 2>&1) & (DEL /A /F /Q toolbar.exe > NUL 2>&1) & (ECHO %CD%toolbar.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST uniq.exe (ATTRIB -r -s -h uniq.exe > NUL 2>&1) & (DEL /A /F /Q uniq.exe > NUL 2>&1) & (ECHO %CD%uniq.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winsrv32.exe (ATTRIB -r -s -h winsrv32.exe > NUL 2>&1) & (DEL /A /F /Q winsrv32.exe > NUL 2>&1) & (ECHO %CD%winsrv32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winstall.exe (ATTRIB -r -s -h winstall.exe > NUL 2>&1) & (DEL /A /F /Q winstall.exe > NUL 2>&1) & (ECHO %CD%winstall.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wp.bmp (ATTRIB -r -s -h wp.bmp > NUL 2>&1) & (DEL /A /F /Q p.bmp > NUL 2>&1) & (ECHO %CD%p.bmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wp.exe (ATTRIB -r -s -h wp.exe > NUL 2>&1) & (DEL /A /F /S /Q wp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST xxx.exe (ATTRIB -r -s -h xxx.exe > NUL 2>&1) & (DEL /A /F /S /Q xxx.exe >> "%~dp0"\Clean.log 2>NUL)
popd
pushd %SYSTEMROOT%
IF EXIST ".protected".exe (ATTRIB -r -s -h ".protected".exe > NUL 2>&1) & (DEL /A /F /S /Q ".protected".exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsldpbc.exe (ATTRIB -r -s -h adsldpbc.exe > NUL 2>&1) & (DEL /A /F /S /Q adsldpbc.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsldpbd.exe (ATTRIB -r -s -h adsldpbd.exe > NUL 2>&1) & (DEL /A /F /S /Q adsldpbd.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsldpbe.exe (ATTRIB -r -s -h adsldpbe.exe > NUL 2>&1) & (DEL /A /F /S /Q adsldpbe.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsldpbf.exe (ATTRIB -r -s -h adsldpbf.exe > NUL 2>&1) & (DEL /A /F /S /Q adsldpbf.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsldpbj.exe (ATTRIB -r -s -h adsldpbj.exe > NUL 2>&1) & (DEL /A /F /S /Q adsldpbj.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adtech2005.exe (ATTRIB -r -s -h adtech2005.exe > NUL 2>&1) & (DEL /A /F /S /Q adtech2005.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adtech2006a.exe (ATTRIB -r -s -h adtech2006a.exe > NUL 2>&1) & (DEL /A /F /S /Q adtech2006a.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adw.exe (ATTRIB -r -s -h adw.exe > NUL 2>&1) & (DEL /A /F /S /Q adw.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "adware-sheriff-box.gif" (ATTRIB -r -s -h "adware-sheriff-box.gif" > NUL 2>&1) & (DEL /A /F /S /Q "adware-sheriff-box.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "adware-sheriff-header.gif" (ATTRIB -r -s -h "adware-sheriff-header.gif" > NUL 2>&1) & (DEL /A /F /S /Q "adware-sheriff-header.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST alexaie.dll (ATTRIB -r -s -h alexaie.dll > NUL 2>&1) & (DEL /A /F /S /Q alexaie.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST alxie328.dll (ATTRIB -r -s -h alxie328.dll > NUL 2>&1) & (DEL /A /F /S /Q alxie328.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST alxtb1.dll (ATTRIB -r -s -h alxtb1.dll > NUL 2>&1) & (DEL /A /F /S /Q alxtb1.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "antispylab-logo.gif" (ATTRIB -r -s -h "antispylab-logo.gif" > NUL 2>&1) & (DEL /A /F /S /Q "antispylab-logo.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST azesearch.bmp (ATTRIB -r -s -h azesearch.bmp > NUL 2>&1) & (DEL /A /F /S /Q azesearch.bmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST back.gif (ATTRIB -r -s -h back.gif > NUL 2>&1) & (DEL /A /F /S /Q back.gif >> "%~dp0"\Clean.log 2>NUL)
IF EXIST batserv2.gif (ATTRIB -r -s -h batserv2.gif > NUL 2>&1) & (DEL /A /F /S /Q batserv2.gif >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bg.gif (ATTRIB -r -s -h bg.gif > NUL 2>&1) & (DEL /A /F /S /Q bg.gif >> "%~dp0"\Clean.log 2>NUL)
IF EXIST blank.mht (ATTRIB -r -s -h blank.mht > NUL 2>&1) & (DEL /A /F /S /Q blank.mht >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "blue-bg.gif" (ATTRIB -r -s -h "blue-bg.gif" > NUL 2>&1) & (DEL /A /F /S /Q "blue-bg.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST BTGrab.dll (ATTRIB -r -s -h BTGrab.dll > NUL 2>&1) & (DEL /A /F /S /Q BTGrab.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST buy-btn.gif (ATTRIB -r -s -h buy-btn.gif > NUL 2>&1) & (DEL /A /F /S /Q buy-btn.gif >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "buy-now-btn.gif" (ATTRIB -r -s -h "buy-now-btn.gif" > NUL 2>&1) & (DEL /A /F /S /Q "buy-now-btn.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bxproxy.exe (ATTRIB -r -s -h bxproxy.exe > NUL 2>&1) & (DEL /A /F /S /Q bxproxy.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "close-bar.gif" (ATTRIB -r -s -h "close-bar.gif" > NUL 2>&1) & (DEL /A /F /S /Q "close-bar.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "corner-left.gif" (ATTRIB -r -s -h "corner-left.gif" > NUL 2>&1) & (DEL /A /F /S /Q "corner-left.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "corner-right.gif" (ATTRIB -r -s -h "corner-right.gif" > NUL 2>&1) & (DEL /A /F /S /Q "corner-right.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST country.exe (ATTRIB -r -s -h country.exe > NUL 2>&1) & (DEL /A /F /S /Q country.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST d3dn32.exe (ATTRIB -r -s -h d3dn32.exe > NUL 2>&1) & (DEL /A /F /S /Q d3dn32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST d3??.dll (ATTRIB -r -s -h d3??.dll > NUL 2>&1) & (DEL /A /F /S /Q d3??.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST d3pb.exe (ATTRIB -r -s -h d3pb.exe > NUL 2>&1) & (DEL /A /F /S /Q d3pb.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST defender??.exe (ATTRIB -r -s -h defender??.exe > NUL 2>&1) & (DEL /A /F /S /Q defender??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST desktop.html (ATTRIB -r -s -h desktop.html > NUL 2>&1) & (DEL /A /F /S /Q desktop.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dlmax.dll (ATTRIB -r -s -h dlmax.dll > NUL 2>&1) & (DEL /A /F /S /Q dlmask.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST download-btn.gif (ATTRIB -r -s -h download-btn.gif > NUL 2>&1) & (DEL /A /F /S /Q download-btn.gif >> "%~dp0"\Clean.log 2>NUL)
IF EXIST drsmartload.dat (ATTRIB -r -s -h drsmartload.dat > NUL 2>&1) & (DEL /A /F /S /Q drsmartload.dat >> "%~dp0"\Clean.log 2>NUL)
IF EXIST drsmartload95a.dat (ATTRIB -r -s -h drsmartload95a.dat > NUL 2>&1) & (DEL /A /F /S /Q drsmartload95a.dat >> "%~dp0"\Clean.log 2>NUL)
IF EXIST drsmartloadb1.dat (ATTRIB -r -s -h drsmartloadb1.dat > NUL 2>&1) & (DEL /A /F /S /Q drsmartloadb1.dat >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "facts.gif" (ATTRIB -r -s -h "facts.gif" > NUL 2>&1) & (DEL /A /F /S /Q "facts.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "footer.gif" (ATTRIB -r -s -h "footer.gif" > NUL 2>&1) & (DEL /A /F /S /Q "footer.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "free-scan-btn.gif" (ATTRIB -r -s -h "free-scan-btn.gif" > NUL 2>&1) & (DEL /A /F /S /Q "free-scan-btn.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST gimmygames.dat (ATTRIB -r -s -h gimmygames.dat > NUL 2>&1) & (DEL /A /F /S /Q gimmygames.dat >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "h-line-gradient.gif" (ATTRIB -r -s -h "h-line-gradient.gif" > NUL 2>&1) & (DEL /A /F /S /Q "h-line-gradient.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "header-bg.gif" (ATTRIB -r -s -h "header-bg.gif" > NUL 2>&1) & (DEL /A /F /S /Q "header-bg.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ieyi.dll (ATTRIB -r -s -h ieyi.dll > NUL 2>&1) & (DEL /A /F /S /Q ieyi.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ieyi.exe (ATTRIB -r -s -h ieyi.exe > NUL 2>&1) & (DEL /A /F /S /Q ieyi.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST icont.exe (ATTRIB -r -s -h icont.exe > NUL 2>&1) & (DEL /A /F /S /Q icont.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "infected.gif" (ATTRIB -r -s -h "infected.gif" > NUL 2>&1) & (DEL /A /F /S /Q "infected.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "infected.gif" (ATTRIB -r -s -h "infected.gif" > NUL 2>&1) & (DEL /A /F /S /Q "infected.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "info.gif" (ATTRIB -r -s -h "info.gif" > NUL 2>&1) & (DEL /A /F /S /Q "info.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard.exe (ATTRIB -r -s -h keyboard.exe > NUL 2>&1) & (DEL /A /F /S /Q keyboard.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard?.exe (ATTRIB -r -s -h keyboard?.exe > NUL 2>&1) & (DEL /A /F /S /Q keyboard?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST keyboard??.exe (ATTRIB -r -s -h keyboard??.exe > NUL 2>&1) & (DEL /A /F /S /Q keyboard??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kl.exe (ATTRIB -r -s -h kl.exe > NUL 2>&1) & (DEL /A /F /S /Q kl.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kl1.exe (ATTRIB -r -s -h kl1.exe > NUL 2>&1) & (DEL /A /F /S /Q kl1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST loadadv728.exe (ATTRIB -r -s -h loadadv728.exe > NUL 2>&1) & (DEL /A /F /S /Q loadadv728.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad.exe (ATTRIB -r -s -h mousepad.exe > NUL 2>&1) & (DEL /A /F /S /Q mousepad.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad?.exe (ATTRIB -r -s -h mousepad?.exe > NUL 2>&1) & (DEL /A /F /S /Q mousepad?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mousepad??.exe (ATTRIB -r -s -h mousepad??.exe > NUL 2>&1) & (DEL /A /F /S /Q mousepad??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ms1.exe (ATTRIB -r -s -h ms1.exe > NUL 2>&1) & (DEL /A /F /S /Q ms1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST newname.exe (ATTRIB -r -s -h newname.exe > NUL 2>&1) & (DEL /A /F /S /Q newname.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST newname?.exe (ATTRIB -r -s -h newname?.exe > NUL 2>&1) & (DEL /A /F /S /Q newname?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST newname??.exe (ATTRIB -r -s -h newname??.exe > NUL 2>&1) & (DEL /A /F /S /Q newname??.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "no-icon.gif" (ATTRIB -r -s -h "no-icon.gif" > NUL 2>&1) & (DEL /A /F /S /Q "no-icon.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST notepad.com (ATTRIB -r -s -h notepad.com > NUL 2>&1) & (DEL /A /F /S /Q notepad.com >> "%~dp0"\Clean.log 2>NUL)
IF EXIST osaupd.com (ATTRIB -r -s -h osaupd.com > NUL 2>&1) & (DEL /A /F /S /Q osaupd.com >> "%~dp0"\Clean.log 2>NUL)
IF EXIST pop06ap2.exe (ATTRIB -r -s -h pop06ap2.exe > NUL 2>&1) & (DEL /A /F /S /Q pop06ap2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST popuper.exe (ATTRIB -r -s -h popuper.exe > NUL 2>&1) & (DEL /A /F /S /Q popuper.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST psg.exe (ATTRIB -r -s -h psg.exe > NUL 2>&1) & (DEL /A /F /S /Q psg.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST q*_disk.dll (ATTRIB -r -s -h q*_disk.dll > NUL 2>&1) & (DEL /A /F /S /Q q*_disk.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "reg-freeze-box.gif" (ATTRIB -r -s -h "reg-freeze-box.gif" > NUL 2>&1) & (DEL /A /F /S /Q "reg-freeze-box.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "reg-freeze-header.gif" (ATTRIB -r -s -h "reg-freeze-header.gif" > NUL 2>&1) & (DEL /A /F /S /Q "reg-freeze-header.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "remove-spyware-btn.gif" (ATTRIB -r -s -h "remove-spyware-btn.gif" > NUL 2>&1) & (DEL /A /F /S /Q "remove-spyware-btn.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST rzs.exe (ATTRIB -r -s -h rzs.exe > NUL 2>&1) & (DEL /A /F /S /Q rzs.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST screen.html (ATTRIB -r -s -h screen.html > NUL 2>&1) & (DEL /A /F /S /Q screen.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sdkcb.dll (ATTRIB -r -s -h sdkcb.dll > NUL 2>&1) & (DEL /A /F /S /Q sdkcb.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sdkqq.exe (ATTRIB -r -s -h sdkqq.exe > NUL 2>&1) & (DEL /A /F /S /Q sdkqq.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "spyware-sheriff-header.gif" (ATTRIB -r -s -h "spyware-sheriff-header.gif" > NUL 2>&1) & (DEL /A /F /S /Q "spyware-sheriff-header.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "spyware-sheriff-box.gif" (ATTRIB -r -s -h "spyware-sheriff-box.gif" > NUL 2>&1) & (DEL /A /F /S /Q "spyware-sheriff-box.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "star.gif" (ATTRIB -r -s -h "star.gif" > NUL 2>&1) & (DEL /A /F /S /Q "star.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "star-grey.gif" (ATTRIB -r -s -h "star-grey.gif" > NUL 2>&1) & (DEL /A /F /S /Q "star-grey.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "true-stories.gif" (ATTRIB -r -s -h "true-stories.gif" > NUL 2>&1) & (DEL /A /F /S /Q "true-stories.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sachostx.exe (ATTRIB -r -s -h sachostx.exe > NUL 2>&1) & (DEL /A /F /S /Q sachostx.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sec.exe (ATTRIB -r -s -h sec.exe > NUL 2>&1) & (DEL /A /F /S /Q sec.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST secure32.html (ATTRIB -r -s -h secure32.html > NUL 2>&1) & (DEL /A /F /S /Q secure32.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sites.ini (ATTRIB -r -s -h sites.ini > NUL 2>&1) & (DEL /A /F /S /Q sites.ini >> "%~dp0"\Clean.log 2>NUL)
IF EXIST slassac.dll (ATTRIB -r -s -h slassac.dll > NUL 2>&1) & (DEL /A /F /S /Q slassac.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST susp.exe (ATTRIB -r -s -h susp.exe > NUL 2>&1) & (DEL /A /F /S /Q susp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchost.exe (ATTRIB -r -s -h svchost.exe > NUL 2>&1) & (DEL /A /F /S /Q svchost.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysen.exe (ATTRIB -r -s -h sysen.exe > NUL 2>&1) & (DEL /A /F /S /Q sysen.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysldr32.exe (ATTRIB -r -s -h sysldr32.exe > NUL 2>&1) & (DEL /A /F /S /Q sysldr32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysvx_.exe (ATTRIB -r -s -h sysvx_.exe > NUL 2>&1) & (DEL /A /F /S /Q sysvx_.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST teller2.chk (ATTRIB -r -s -h teller2.chk > NUL 2>&1) & (DEL /A /F /S /Q teller2.chk >> "%~dp0"\Clean.log 2>NUL)
IF EXIST temp.000.exe (ATTRIB -r -s -h temp.000.exe > NUL 2>&1) & (DEL /A /F /S /Q temp.000.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST timessquare.exe (ATTRIB -r -s -h timessquare.exe > NUL 2>&1) & (DEL /A /F /S /Q timessquare.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST timessquare1.exe (ATTRIB -r -s -h timessquare1.exe > NUL 2>&1) & (DEL /A /F /S /Q timessquare1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool1.exe (ATTRIB -r -s -h tool1.exe > NUL 2>&1) & (DEL /A /F /S /Q tool1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool2.exe (ATTRIB -r -s -h tool2.exe > NUL 2>&1) & (DEL /A /F /S /Q tool2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool3.exe (ATTRIB -r -s -h tool3.exe > NUL 2>&1) & (DEL /A /F /S /Q tool3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool4.exe (ATTRIB -r -s -h tool4.exe > NUL 2>&1) & (DEL /A /F /S /Q tool4.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tool5.exe (ATTRIB -r -s -h tool5.exe > NUL 2>&1) & (DEL /A /F /S /Q tool5.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST uninstDsk.exe (ATTRIB -r -s -h uninstDsk.exe > NUL 2>&1) & (DEL /A /F /S /Q uninstDsk.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST uninstIU.exe (ATTRIB -r -s -h uninstIU.exe > NUL 2>&1) & (DEL /A /F /S /Q uninstIU.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST update13.js (ATTRIB -r -s -h update13.js > NUL 2>&1) & (DEL /A /F /S /Q update13.js >> "%~dp0"\Clean.log 2>NUL)
IF EXIST warnhp.html (ATTRIB -r -s -h warnhp.html > NUL 2>&1) & (DEL /A /F /S /Q warnhp.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "warning-bar-ico.gif" (ATTRIB -r -s -h "warning-bar-ico.gif" > NUL 2>&1) & (DEL /A /F /S /Q "warning-bar-ico.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "win-sec-center-logo.gif" (ATTRIB -r -s -h "win-sec-center-logo.gif" > NUL 2>&1) & (DEL /A /F /S /Q "win-sec-center-logo.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "windows-compatible.gif" (ATTRIB -r -s -h "windows-compatible.gif" > NUL 2>&1) & (DEL /A /F /S /Q "windows-compatible.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST windows.html (ATTRIB -r -s -h windows.html > NUL 2>&1) & (DEL /A /F /S /Q windows.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winsysupd.html (ATTRIB -r -s -h winsysupd.html > NUL 2>&1) & (DEL /A /F /S /Q winsysupd.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winsysban.html (ATTRIB -r -s -h winsysban.html > NUL 2>&1) & (DEL /A /F /S /Q winsysban.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winsysban8.html (ATTRIB -r -s -h winsysban8.html > NUL 2>&1) & (DEL /A /F /S /Q winsysban8.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wupdmgr.exe (ATTRIB -r -s -h wupdmgr.exe > NUL 2>&1) & (DEL /A /F /S /Q wupdmgr.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST xpupdate.exe (ATTRIB -r -s -h xpupdate.exe > NUL 2>&1) & (DEL /A /F /S /Q xpupdate.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "yes-icon.gif" (ATTRIB -r -s -h "yes-icon.gif" > NUL 2>&1) & (DEL /A /F /S /Q "yes-icon.gif" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST zloader3.exe (ATTRIB -r -s -h zloader3.exe > NUL 2>&1) & (DEL /A /F /S /Q zloader3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ZServ.dll (ATTRIB -r -s -h ZServ.dll > NUL 2>&1) & (DEL /A /F /S /Q ZServ.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__popuper.exe (ATTRIB -r -s -h __delete_on_reboot__popuper.exe > NUL 2>&1) & (DEL /A /F /S /Q __delete_on_reboot__popuper.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%SYSTEMROOT%\muwq" (ATTRIB -r -s -h "%windir%\muwq" > NUL 2>&1) & (DEL /A /F /S /Q "%windir%\muwq" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%SYSTEMROOT%\inet20001" (ATTRIB -r -h %SYSTEMROOT%\inet20001\*.* > NUL 2>&1) & (DEL /a /f /S /Q %SYSTEMROOT%\inet20001\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /s /S /Q "%SYSTEMROOT%\inet20001")
IF EXIST "%SYSTEMROOT%\inet20010" (ATTRIB -r -h %SYSTEMROOT%\inet20010\*.* > NUL 2>&1) & (DEL /a /f /S /Q %SYSTEMROOT%\inet20010\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /s /S /Q "%SYSTEMROOT%\inet20010")
IF EXIST "%SYSTEMROOT%\inet20066" (ATTRIB -r -h %SYSTEMROOT%\inet20066\*.* > NUL 2>&1) & (DEL /a /f /S /Q %SYSTEMROOT%\inet20066\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /s /S /Q "%SYSTEMROOT%\inet20066")
IF EXIST "%SYSTEMROOT%\inet20099" (ATTRIB -r -h %SYSTEMROOT%\inet20099\*.* > NUL 2>&1) & (DEL /a /f /S /Q %SYSTEMROOT%\inet20099\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /s /S /Q "%SYSTEMROOT%\inet20099")
popd
pushd %SYSTEMROOT%\system
IF EXIST csrss.exe (ATTRIB -r -s -h csrss.exe > NUL 2>&1) & (DEL /A /F /S /Q csrss.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchost.exe (ATTRIB -r -s -h svchost.exe > NUL 2>&1) & (DEL /A /F /S /Q svchost.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchost.dll (ATTRIB -r -s -h svchost.dll > NUL 2>&1) & (DEL /A /F /S /Q svchost.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svwhost.exe (ATTRIB -r -s -h svwhost.exe > NUL 2>&1) & (DEL /A /F /S /Q svwhost.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svwhost.dll (ATTRIB -r -s -h svwhost.dll > NUL 2>&1) & (DEL /A /F /S /Q svwhost.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svwhost.dll (ATTRIB -r -s -h svwhost.dll > NUL 2>&1) & (DEL /A /F /S /Q svwhost.dll >> "%~dp0"\Clean.log 2>NUL)
popd
IF EXIST %windir%\Web (
    pushd %windir%\Web
    IF EXIST desktop.html (ATTRIB -r -s -h desktop.html > NUL 2>&1) & (DEL /A /F /S /Q desktop.html >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST wallpaper.html (ATTRIB -r -s -h wallpaper.html > NUL 2>&1) & (DEL /A /F /S /Q wallpaper.html >> "%~dp0"\Clean.log 2>NUL)
    popd
)
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
pushd %SYSTEMROOT%\SYSTEM32
IF EXIST ~update.exe (ATTRIB -r -s -h ~update.exe > NUL 2>&1) & (DEL /A /F /S /Q ~update.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST a.exe (ATTRIB -r -s -h a.exe > NUL 2>&1) & (DEL /A /F /S /Q a.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST AdService.dll (ATTRIB -r -s -h AdService.dll > NUL 2>&1) & (DEL /A /F /S /Q AdService.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST adsmart.exe (ATTRIB -r -s -h adsmart.exe > NUL 2>&1) & (DEL /A /F /S /Q adsmart.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST alxres.dll (ATTRIB -r -s -h alxres.dll > NUL 2>&1) & (DEL /A /F /S /Q alxres.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST appmagr.dll (ATTRIB -r -s -h appmagr.dll > NUL 2>&1) & (DEL /A /F /S /Q appmagr.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST atmclk.exe (ATTRIB -r -s -h atmclk.exe > NUL 2>&1) & (DEL /A /F /S /Q atmclk.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST autodisc32.dll (ATTRIB -r -s -h autodisc32.dll > NUL 2>&1) & (DEL /A /F /S /Q autodisc32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Air Tickets.ico" (ATTRIB -r -s -h "Air Tickets.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Air Tickets.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bhoimpl.dll (ATTRIB -r -s -h bhoimpl.dll > NUL 2>&1) & (DEL /A /F /S /Q bhoimpl.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Big Tits.ico" (ATTRIB -r -s -h "Big Tits.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Big Tits.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bin29a.log (ATTRIB -r -s -h bin29a.log > NUL 2>&1) & (DEL /A /F /S /Q bin29a.log >> "%~dp0"\Clean.log 2>NUL)
IF EXIST birdihuy.dll (ATTRIB -r -s -h birdihuy.dll > NUL 2>&1) & (DEL /A /F /S /Q birdihuy.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST birdihuy32.dll (ATTRIB -r -s -h birdihuy32.dll > NUL 2>&1) & (DEL /A /F /S /Q birdihuy32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST Blackjack.ico (ATTRIB -r -s -h Blackjack.ico > NUL 2>&1) & (DEL /A /F /S /Q Blackjack.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bnmsrv.exe (ATTRIB -r -s -h bnmsrv.exe > NUL 2>&1) & (DEL /A /F /S /Q bnmsrv.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bre.dll (ATTRIB -r -s -h bre.dll > NUL 2>&1) & (DEL /A /F /S /Q bre.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bre32.dll (ATTRIB -r -s -h bre32.dll > NUL 2>&1) & (DEL /A /F /S /Q bre32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bridge.dll (ATTRIB -r -s -h bridge.dll > NUL 2>&1) & (DEL /A /F /S /Q bridge.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Britney Spears.ico" (ATTRIB -r -s -h "Britney Spears.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Britney Spears.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST browsela.dll (ATTRIB -r -s -h browsela.dll > NUL 2>&1) & (DEL /A /F /S /Q browsela.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST bu.exe (ATTRIB -r -s -h bu.exe > NUL 2>&1) & (DEL /A /F /S /Q bu.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Car Insurance.ico" (ATTRIB -r -s -h "Car Insurance.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Car Insurance.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST casino.ico (ATTRIB -r -s -h casino.ico > NUL 2>&1) & (DEL /A /F /S /Q casino.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Cheap Cigarettes.ico" (ATTRIB -r -s -h "Cheap Cigarettes.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Cheap Cigarettes.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST child.dll (ATTRIB -r -s -h child.dll > NUL 2>&1) & (DEL /A /F /S /Q child.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST chp.dll (ATTRIB -r -s -h chp.dll > NUL 2>&1) & (DEL /A /F /S /Q chp.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST cmd32.exe (ATTRIB -r -s -h cmd32.exe > NUL 2>&1) & (DEL /A /F /S /Q cmd32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST cmdtel.exe (ATTRIB -r -s -h cmdtel.exe > NUL 2>&1) & (DEL /A /F /S /Q cmdtel.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST cnymxw32.dll (ATTRIB -r -s -h cnymxw32.dll > NUL 2>&1) & (DEL /A /F /S /Q cnymxw32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST combo.exe (ATTRIB -r -s -h combo.exe > NUL 2>&1) & (DEL /A /F /S /Q combo.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST comdlg64.dll (ATTRIB -r -s -h comdlg64.dll > NUL 2>&1) & (DEL /A /F /S /Q comdlg64.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST countrydial.exe (ATTRIB -r -s -h countrydial.exe > NUL 2>&1) & (DEL /A /F /S /Q countrydial.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Credit Card.ico" (ATTRIB -r -s -h "Credit Card.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Credit Card.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST Cruises.ico (ATTRIB -r -s -h Cruises.ico > NUL 2>&1) & (DEL /A /F /S /Q Cruises.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Currency Trading.ico" (ATTRIB -r -s -h "Currency Trading.ico" > NUL 2>&1) & (DEL /A /F /S /Q "Currency Trading.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST cvxh8jkdq?.exe (ATTRIB -r -s -h cvxh8jkdq?.exe > NUL 2>&1) & (DEL /A /F /S /Q cvxh8jkdq?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST CWS_iestart.exe (ATTRIB -r -s -h CWS_iestart.exe > NUL 2>&1) & (DEL /A /F /S /Q CWS_iestart.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST date.ico (ATTRIB -r -s -h date.ico > NUL 2>&1) & (DEL /A /F /S /Q date.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dailytoolbar.dll (ATTRIB -r -s -h dailytoolbar.dll > NUL 2>&1) & (DEL /A /F /S /Q dailytoolbar.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dcom_14.dll (ATTRIB -r -s -h dcom_14.dll > NUL 2>&1) & (DEL /A /F /S /Q dcom_14.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dcom_15.dll (ATTRIB -r -s -h dcom_15.dll > NUL 2>&1) & (DEL /A /F /S /Q dcom_15.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dcom_16.dll (ATTRIB -r -s -h dcom_16.dll > NUL 2>&1) & (DEL /A /F /S /Q dcom_16.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dcomcfg.exe (ATTRIB -r -s -h dcomcfg.exe > NUL 2>&1) & (DEL /A /F /S /Q dcomcfg.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dial23.exe (ATTRIB -r -s -h dial23.exe > NUL 2>&1) & (DEL /A /F /S /Q dial23.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dlh9jkdq*.exe (ATTRIB -r -s -h dlh9jkdq*.exe > NUL 2>&1) & (DEL /A /F /S /Q dlh9jkdq*.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST doser.exe (ATTRIB -r -s -h doser.exe > NUL 2>&1) & (DEL /A /F /S /Q doser.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dfrgsrv.exe (ATTRIB -r -s -h dfrgsrv.exe > NUL 2>&1) & (DEL /A /F /S /Q dfrgsrv.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dxole32.exe (ATTRIB -r -s -h dxole32.exe > NUL 2>&1) & (DEL /A /F /S /Q dxole32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dxmpp.dll (ATTRIB -r -s -h dxmpp.dll > NUL 2>&1) & (DEL /A /F /S /Q dxmpp.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST dvdcap.dll (ATTRIB -r -s -h dvdcap.dll > NUL 2>&1) & (DEL /A /F /S /Q dvdcap.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST efsdfgxg.exe (ATTRIB -r -s -h efsdfgxg.exe > NUL 2>&1) & (DEL /A /F /S /Q efsdfgxg.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST efa32.exe (ATTRIB -r -s -h efa32.exe > NUL 2>&1) & (DEL /A /F /S /Q efa32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST exeha2.exe (ATTRIB -r -s -h exeha2.exe > NUL 2>&1) & (DEL /A /F /S /Q exeha2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST exeha3.exe (ATTRIB -r -s -h exeha3.exe > NUL 2>&1) & (DEL /A /F /S /Q exeha3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST exuc32.tmp (ATTRIB -r -s -h exuc32.tmp > NUL 2>&1) & (DEL /A /F /S /Q exuc32.tmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST games.ico (ATTRIB -r -s -h games.ico > NUL 2>&1) & (DEL /A /F /S /Q games.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ginuerep.dll (ATTRIB -r -s -h ginuerep.dll > NUL 2>&1) & (DEL /A /F /S /Q ginuerep.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST gunist.exe (ATTRIB -r -s -h gunist.exe > NUL 2>&1) & (DEL /A /F /S /Q gunist.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST helper.exe (ATTRIB -r -s -h helper.exe > NUL 2>&1) & (DEL /A /F /S /Q helper.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST hhk.dll (ATTRIB -r -s -h hhk.dll > NUL 2>&1) & (DEL /A /F /S /Q hhk.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST hookdump.exe (ATTRIB -r -s -h hookdump.exe > NUL 2>&1) & (DEL /A /F /S /Q hookdump.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST hp????.tmp (ATTRIB -r -s -h hp????.tmp > NUL 2>&1) & (DEL /A /F /S /Q hp????.tmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST IeHelperEx.dll (ATTRIB -r -s -h IeHelperEx.dll > NUL 2>&1) & (DEL /A /F /S /Q IeHelperEx.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intel32.exe (ATTRIB -r -s -h intel32.exe > NUL 2>&1) & (DEL /A /F /S /Q intel32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intell321.exe (ATTRIB -r -s -h intell321.exe > NUL 2>&1) & (DEL /A /S /Q /F intell321.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intell32.exe (ATTRIB -r -s -h intell32.exe > NUL 2>&1) & (DEL /A /S /Q /F intell32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST interf.tlb (ATTRIB -r -s -h interf.tlb > NUL 2>&1) & (DEL /A /S /Q /F interf.tlb >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intmon.exe (ATTRIB -r -s -h intmon.exe > NUL 2>&1) & (DEL /A /S /Q /F intmon.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intmonp.exe (ATTRIB -r -s -h intmonp.exe > NUL 2>&1) & (DEL /A /S /Q /F intmonp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST intxt.exe (ATTRIB -r -s -h intxt.exe > NUL 2>&1) & (DEL /A /S /Q /F intxt.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ioctrl.dll (ATTRIB -r -s -h ioctrl.dll > NUL 2>&1) & (DEL /A /S /Q /F ioctrl.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST jao.dll (ATTRIB -r -s -h jao.dll > NUL 2>&1) & (DEL /A /S /Q /F jao.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kernels8.exe (ATTRIB -r -s -h kernels8.exe > NUL 2>&1) & (DEL /A /S /Q /F kernels8.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kernels32.exe (ATTRIB -r -s -h kernels32.exe > NUL 2>&1) & (DEL /A /S /Q /F kernels32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST kernels64.exe (ATTRIB -r -s -h kernels64.exe > NUL 2>&1) & (DEL /A /S /Q /F kernels64.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST latest.exe (ATTRIB -r -s -h latest.exe > NUL 2>&1) & (DEL /A /S /Q /F latest.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ld????.tmp (ATTRIB -r -s -h ld????.tmp > NUL 2>&1) & (DEL /A /S /Q /F ld????.tmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Lesbian Sex.ico" (ATTRIB -r -s -h "Lesbian Sex.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Lesbian Sex.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST lich.exe (ATTRIB -r -s -h lich.exe > NUL 2>&1) & (DEL /A /S /Q /F lich.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST links.exe (ATTRIB -r -s -h links.exe > NUL 2>&1) & (DEL /A /S /Q /F links.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ll.exe (ATTRIB -r -s -h ll.exe > NUL 2>&1) & (DEL /A /S /Q /F ll.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST maxd64.exe (ATTRIB -r -s -h maxd64.exe > NUL 2>&1) & (DEL /A /S /Q /F maxd64.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST maxd1.exe (ATTRIB -r -s -h maxd1.exe > NUL 2>&1) & (DEL /A /S /Q /F maxd1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST migicons.exe (ATTRIB -r -s -h migicons.exe > NUL 2>&1) & (DEL /A /S /Q /F migicons.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mirarsearch_toolbar.exe (ATTRIB -r -s -h mirarsearch_toolbar.exe > NUL 2>&1) & (DEL /A /S /Q /F mirarsearch_toolbar.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mobile.ico (ATTRIB -r -s -h mobile.ico > NUL 2>&1) & (DEL /A /S /Q /F mobile.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST MP3.ico (ATTRIB -r -s -h MP3.ico > NUL 2>&1) & (DEL /A /S /Q /F MP3.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msbe.dll (ATTRIB -r -s -h msbe.dll > NUL 2>&1) & (DEL /A /S /Q /F msbe.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mscornet.exe (ATTRIB -r -s -h mscornet.exe > NUL 2>&1) & (DEL /A /S /Q /F mscornet.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mssearchnet.exe (ATTRIB -r -s -h mssearchnet.exe > NUL 2>&1) & (DEL /A /S /Q /F mssearchnet.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msnscps.dll (ATTRIB -r -s -h msnscps.dll > NUL 2>&1) & (DEL /A /S /Q /F msnscps.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msmsgs.exe (ATTRIB -r -s -h msmsgs.exe > NUL 2>&1) & (DEL /A /S /Q /F msmsgs.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msole32.exe (ATTRIB -r -s -h msole32.exe > NUL 2>&1) & (DEL /A /S /Q /F msole32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mspostsp.exe (ATTRIB -r -s -h mspostsp.exe > NUL 2>&1) & (DEL /A /S /Q /F mspostsp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msupdate32.dll (ATTRIB -r -s -h msupdate32.dll > NUL 2>&1) & (DEL /A /S /Q /F msupdate32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msvcp.exe (ATTRIB -r -s -h msvcp.exe > NUL 2>&1) & (DEL /A /S /Q /F msvcp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST msvol.tlb (ATTRIB -r -s -h msvol.tlb > NUL 2>&1) & (DEL /A /S /Q /F msvol.tlb >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinb32.dll (ATTRIB -r -s -h mswinb32.dll > NUL 2>&1) & (DEL /A /S /Q /F mswinb32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinb32.exe (ATTRIB -r -s -h mswinb32.exe > NUL 2>&1) & (DEL /A /S /Q /F mswinb32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinf32.dll (ATTRIB -r -s -h mswinf32.dll > NUL 2>&1) & (DEL /A /S /Q /F mswinf32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinf32.exe (ATTRIB -r -s -h mswinf32.exe > NUL 2>&1) & (DEL /A /S /Q /F mswinf32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinup32.dll (ATTRIB -r -s -h mswinup32.dll > NUL 2>&1) & (DEL /A /S /Q /F mswinup32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST mswinxml.dll (ATTRIB -r -s -h mswinxml.dll > NUL 2>&1) & (DEL /A /S /Q /F mswinxml.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST MTC.dll (ATTRIB -r -s -h MTC.dll > NUL 2>&1) & (DEL /A /S /Q /F MTC.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST MTC.ini (ATTRIB -r -s -h MTC.ini > NUL 2>&1) & (DEL /A /S /Q /F MTC.ini >> "%~dp0"\Clean.log 2>NUL)
IF EXIST multitran.exe (ATTRIB -r -s -h multitran.exe > NUL 2>&1) & (DEL /A /S /Q /F multitran.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ncompat.tlb (ATTRIB -r -s -h ncompat.tlb > NUL 2>&1) & (DEL /A /S /Q /F ncompat.tlb >> "%~dp0"\Clean.log 2>NUL)
IF EXIST netfilt4.exe (ATTRIB -r -s -h netfilt4.exe > NUL 2>&1) & (DEL /A /S /Q /F netfilt4.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST network.ico (ATTRIB -r -s -h network.ico > NUL 2>&1) & (DEL /A /S /Q /F network.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST netwrap.dll (ATTRIB -r -s -h netwrap.dll > NUL 2>&1) & (DEL /A /S /Q /F netwrap.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST notepad.com (ATTRIB -r -s -h notepad.com > NUL 2>&1) & (DEL /A /S /Q /F notepad.com >> "%~dp0"\Clean.log 2>NUL)
IF EXIST NTCommLib3.exe (ATTRIB -r -s -h NTCommLib3.exe > NUL 2>&1) & (DEL /A /S /Q /F NTCommLib3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST nvctrl.exe (ATTRIB -r -s -h nvctrl.exe > NUL 2>&1) & (DEL /A /S /Q /F nvctrl.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST nuclabdll.dll (ATTRIB -r -s -h nuclabdll.dll > NUL 2>&1) & (DEL /A /S /Q /F nuclabdll.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST nvms.dll (ATTRIB -r -s -h nvms.dll > NUL 2>&1) & (DEL /A /S /Q /F nvms.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST officescan.exe (ATTRIB -r -s -h officescan.exe > NUL 2>&1) & (DEL /A /S /Q /F officescan.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ole32vbs.exe (ATTRIB -r -s -h ole32vbs.exe > NUL 2>&1) & (DEL /A /S /Q /F ole32vbs.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST oleadm.dll (ATTRIB -r -s -h oleadm.dll > NUL 2>&1) & (DEL /A /S /Q /F oleadm.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST oleadm32.dll (ATTRIB -r -s -h oleadm32.dll > NUL 2>&1) & (DEL /A /S /Q /F oleadm32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST oleext.dll (ATTRIB -r -s -h oleext.dll > NUL 2>&1) & (DEL /A /S /Q /F oleext.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST oleext32.dll (ATTRIB -r -s -h oleext32.dll > NUL 2>&1) & (DEL /A /S /Q /F oleext32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Online Betting.ico" (ATTRIB -r -s -h "Online Betting.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Online Betting.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Online Gambling.ico" (ATTRIB -r -s -h "Online Gambling.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Online Gambling.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Oral Sex.ico" (ATTRIB -r -s -h "Oral Sex.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Oral Sex.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ot.ico (ATTRIB -r -s -h ot.ico > NUL 2>&1) & (DEL /A /S /Q /F ot.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST parad.raw.exe (ATTRIB -r -s -h parad.raw.exe > NUL 2>&1) & (DEL /A /S /Q /F parad.raw.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST paradise.raw.exe (ATTRIB -r -s -h paradise.raw.exe > NUL 2>&1) & (DEL /A /S /Q /F paradise.raw.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST param32.dll (ATTRIB -r -s -h param32.dll > NUL 2>&1) & (DEL /A /S /Q /F param32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Party Poker.ico" (ATTRIB -r -s -h "Party Poker.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Party Poker.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST paytime.exe (ATTRIB -r -s -h paytime.exe > NUL 2>&1) & (DEL /A /S /Q /F paytime.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST perfcii.ini (ATTRIB -r -s -h perfcii.ini > NUL 2>&1) & (DEL /A /S /Q /F perfcii.ini >> "%~dp0"\Clean.log 2>NUL)
IF EXIST performent217.dll (ATTRIB -r -s -h performent217.dll > NUL 2>&1) & (DEL /A /S /Q /F performent217.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST pharm.ico (ATTRIB -r -s -h pharm.ico > NUL 2>&1) & (DEL /A /S /Q /F pharm.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST pharm2.ico (ATTRIB -r -s -h pharm2.ico > NUL 2>&1) & (DEL /A /S /Q /F pharm2.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST Pharmacy.ico (ATTRIB -r -s -h Pharmacy.ico > NUL 2>&1) & (DEL /A /S /Q /F Pharmacy.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST Phentermine.ico (ATTRIB -r -s -h Phentermine.ico > NUL 2>&1) & (DEL /A /S /Q /F Phentermine.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST pop_up.dll (ATTRIB -r -s -h pop_up.dll > NUL 2>&1) & (DEL /A /S /Q /F pop_up.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST Pornstars.ico (ATTRIB -r -s -h Pornstars.ico > NUL 2>&1) & (DEL /A /S /Q /F Pornstars.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST priva.exe (ATTRIB -r -s -h priva.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q priva.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST prflbmsgp32.dll (ATTRIB -r -s -h prflbmsgp32.dll > NUL 2>&1) & (DEL /A /S /Q /F /S /Q prflbmsgp32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST questmod.dll (ATTRIB -r -s -h questmod.dll > NUL 2>&1) & (DEL /A /S /Q /F /S /Q questmod.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST qvxgamet?.exe (ATTRIB -r -s -h qvxgamet?.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q qvxgamet?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST reger.exe (ATTRIB -r -s -h reger.exe > NUL 2>&1) & (DEL /A /S /Q /F reger.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST regperf.exe (ATTRIB -r -s -h regperf.exe > NUL 2>&1) & (DEL /A /S /Q /F regperf.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST reglogs.dll (ATTRIB -r -s -h reglogs.dll > NUL 2>&1) & (DEL /A /S /Q /F /S /Q reglogs.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Remove Spyware.ico" (ATTRIB -r -s -h "Remove Spyware.ico" > NUL 2>&1) & (DEL /A /S /Q /F "Remove Spyware.ico" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST repigsp.exe (ATTRIB -r -s -h repigsp.exe > NUL 2>&1) & (DEL /A /S /Q /F repigsp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST replmap.dll (ATTRIB -r -s -h replmap.dll > NUL 2>&1) & (DEL /A /S /Q /F /S /Q replmap.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST RpcxSs.dll (ATTRIB -r -s -h RpcxSs.dll > NUL 2>&1) & (DEL /A /S /Q /F /S /Q RpcxSs.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST runsrv32.dll (ATTRIB -r -s -h runsrv32.dll > NUL 2>&1) & (DEL /A /S /Q /F runsrv32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST runsrv32.exe (ATTRIB -r -s -h runsrv32.exe > NUL 2>&1) & (DEL /A /S /Q /F runsrv32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sachostc.exe (ATTRIB -r -s -h sachostc.exe > NUL 2>&1) & (DEL /A /S /Q /F sachostc.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sachostp.exe (ATTRIB -r -s -h sachostp.exe > NUL 2>&1) & (DEL /A /S /Q /F sachostp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sachosts.exe (ATTRIB -r -s -h sachosts.exe > NUL 2>&1) & (DEL /A /S /Q /F sachosts.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST scanner.ico (ATTRIB -r -s -h scanner.ico > NUL 2>&1) & (DEL /A /S /Q /F scanner.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sdfdil.exe (ATTRIB -r -s -h sdfdil.exe > NUL 2>&1) & (DEL /A /S /Q /F sdfdil.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST searchdll.dll (ATTRIB -r -s -h searchdll.dll > NUL 2>&1) & (DEL /A /S /Q /F searchdll.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "Security Toolbar.dll" (ATTRIB -r -s -h "Security Toolbar.dll" > NUL 2>&1) & (DEL /A /S /Q /F "Security Toolbar.dll" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sender.exe (ATTRIB -r -s -h sender.exe > NUL 2>&1) & (DEL /A /S /Q /F sender.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdochp.dll (ATTRIB -r -s -h shdochp.dll > NUL 2>&1) & (DEL /A /S /Q /F shdochp.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdochp.exe (ATTRIB -r -s -h shdochp.exe > NUL 2>&1) & (DEL /A /S /Q /F shdochp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdochop.dll (ATTRIB -r -s -h shdochop.dll > NUL 2>&1) & (DEL /A /S /Q /F shdochop.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdocsvc.dll (ATTRIB -r -s -h shdocsvc.dll > NUL 2>&1) & (DEL /A /S /Q /F shdocsvc.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdocsvc.exe (ATTRIB -r -s -h shdocsvc.exe > NUL 2>&1) & (DEL /A /S /Q /F shdocsvc.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shdocnva.dll (ATTRIB -r -s -h shdocnva.dll > NUL 2>&1) & (DEL /A /S /Q /F shdocnva.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shell386.exe (ATTRIB -r -s -h shell386.exe > NUL 2>&1) & (DEL /A /S /Q /F shell386.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shellgui32.dll (ATTRIB -r -s -h shellgui32.dll > NUL 2>&1) & (DEL /A /S /Q /F shellgui32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shnlog.exe (ATTRIB -r -s -h shnlog.exe > NUL 2>&1) & (DEL /A /S /Q /F shnlog.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST shsexl32.dll (ATTRIB -r -s -h shsexl32.dll > NUL 2>&1) & (DEL /A /S /Q /F shsexl32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST simpole.tlb (ATTRIB -r -s -h simpole.tlb > NUL 2>&1) & (DEL /A /S /Q /F simpole.tlb >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sivudro.dll (ATTRIB -r -s -h sivudro.dll > NUL 2>&1) & (DEL /A /S /Q /F sivudro.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST socks.exe (ATTRIB -r -s -h socks.exe > NUL 2>&1) & (DEL /A /S /Q /F socks.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST spam.ico (ATTRIB -r -s -h spam.ico > NUL 2>&1) & (DEL /A /S /Q /F spam.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST split.exe (ATTRIB -r -s -h split.exe > NUL 2>&1) & (DEL /A /S /Q /F split.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST split1.exe (ATTRIB -r -s -h split1.exe > NUL 2>&1) & (DEL /A /S /Q /F split1.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST split2.exe (ATTRIB -r -s -h split2.exe > NUL 2>&1) & (DEL /A /S /Q /F split2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST spoolsrv32.exe (ATTRIB -r -s -h spoolsrv32.exe > NUL 2>&1) & (DEL /A /S /Q /F spoolsrv32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST spyware.ico (ATTRIB -r -s -h spyware.ico > NUL 2>&1) & (DEL /A /S /Q /F spyware.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST srpcsrv32.dll (ATTRIB -r -s -h srpcsrv32.dll > NUL 2>&1) & (DEL /A /S /Q /F srpcsrv32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST srpcsrv32.exe (ATTRIB -r -s -h srpcsrv32.exe > NUL 2>&1) & (DEL /A /S /Q /F srpcsrv32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST st3.dll (ATTRIB -r -s -h st3.dll > NUL 2>&1) & (DEL /A /S /Q /F st3.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST stdole3.tlb (ATTRIB -r -s -h stdole3.tlb > NUL 2>&1) & (DEL /A /S /Q /F stdole3.tlb >> "%~dp0"\Clean.log 2>NUL)
IF EXIST stickrep.dll (ATTRIB -r -s -h stickrep.dll > NUL 2>&1) & (DEL /A /S /Q /F stickrep.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST suprox.dll (ATTRIB -r -s -h suprox.dll > NUL 2>&1) & (DEL /A /S /Q /F suprox.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST susp.exe (ATTRIB -r -s -h susp.exe > NUL 2>&1) & (DEL /A /S /Q /F susp.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchop.exe (ATTRIB -r -s -h svchop.exe > NUL 2>&1) & (DEL /A /S /Q /F svchop.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchosts.dll (ATTRIB -r -s -h svchosts.dll > NUL 2>&1) & (DEL /A /S /Q /F svchosts.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svchosts.exe (ATTRIB -r -s -h svchosts.exe > NUL 2>&1) & (DEL /A /S /Q /F svchosts.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svcnt.exe (ATTRIB -r -s -h svcnt.exe > NUL 2>&1) & (DEL /A /S /Q /F svcnt.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svcnt32.exe (ATTRIB -r -s -h svcnt32.exe > NUL 2>&1) & (DEL /A /S /Q /F svcnt32.exe >> "%~dp0"\Clean.log 2>NUL) >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svcnva.exe (ATTRIB -r -s -h svcnva.exe > NUL 2>&1) & (DEL /A /S /Q /F svcnva.exe >> "%~dp0"\Clean.log 2>NUL) >> "%~dp0"\Clean.log 2>NUL)
IF EXIST svwhost.exe (ATTRIB -r -s -h svwhost.exe > NUL 2>&1) & (DEL /A /S /Q /F svwhost.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST symsvcsa.exe (ATTRIB -r -s -h symsvcsa.exe > NUL 2>&1) & (DEL /A /S /Q /F symsvcsa.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysbho.exe (ATTRIB -r -s -h sysbho.exe > NUL 2>&1) & (DEL /A /S /Q /F sysbho.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysinit32z.exe (ATTRIB -r -s -h sysinit32z.exe > NUL 2>&1) & (DEL /A /S /Q /F sysinit32z.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysjv32.exe (ATTRIB -r -s -h sysjv32.exe > NUL 2>&1) & (DEL /A /S /Q /F sysjv32.exe >> "%~dp0"\Clean.log 2>NUL)
:: IF EXIST sysmain.dll (ATTRIB -r -s -h sysmain.dll > NUL 2>&1) & (DEL /A /S /Q /F sysmain.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysvcs.exe (ATTRIB -r -s -h sysvcs.exe > NUL 2>&1) & (DEL /A /S /Q /F sysvcs.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sysvx.exe (ATTRIB -r -s -h sysvx.exe > NUL 2>&1) & (DEL /A /S /Q /F sysvx.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST sywsvcs.exe (ATTRIB -r -s -h sywsvcs.exe > NUL 2>&1) & (DEL /A /S /Q /F sywsvcs.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST taras.exe (ATTRIB -r -s -h taras.exe > NUL 2>&1) & (DEL /A /S /Q /F taras.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST taskdir.dll (ATTRIB -r -s -h taskdir.dll > NUL 2>&1) & (DEL /A /S /Q /F taskdir.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST taskdir.exe (ATTRIB -r -s -h taskdir.exe > NUL 2>&1) & (DEL /A /S /Q /F taskdir.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST taskdir~.exe (ATTRIB -r -s -h taskdir~.exe > NUL 2>&1) & (DEL /A /S /Q /F taskdir~.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tcpservice2.exe (ATTRIB -r -s -h tcpservice2.exe > NUL 2>&1) & (DEL /A /S /Q /F tcpservice2.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST tetriz3.exe (ATTRIB -r -s -h tetriz3.exe > NUL 2>&1) & (DEL /A /S /Q /F tetriz3.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST trf32.dll (ATTRIB -r -s -h trf32.dll > NUL 2>&1) & (DEL /A /S /Q /F trf32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST truetype.exe (ATTRIB -r -s -h truetype.exe > NUL 2>&1) & (DEL /A /S /Q /F truetype.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ts.ico (ATTRIB -r -s -h ts.ico > NUL 2>&1) & (DEL /A /S /Q /F ts.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST twain32.dll (ATTRIB -r -s -h twain32.dll > NUL 2>&1) & (DEL /A /S /Q /F twain32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST txfdb32.dll (ATTRIB -r -s -h txfdb32.dll > NUL 2>&1) & (DEL /A /S /Q /F txfdb32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST udpmod.dll (ATTRIB -r -s -h udpmod.dll > NUL 2>&1) & (DEL /A /S /Q /F udpmod.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST viagra.ico (ATTRIB -r -s -h viagra.ico > NUL 2>&1) & (DEL /A /S /Q /F viagra.ico >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxgame?.exe (ATTRIB -r -s -h vxgame?.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxgame?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxgame?.exe????.exe.bak (ATTRIB -r -s -h vxgame?.exe????.exe.bak > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxgame?.exe????.exe.bak >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxgame?.exe????.exe (ATTRIB -r -s -h vxgame?.exe????.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxgame?.exe????.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxgamet?.exe (ATTRIB -r -s -h vxgamet?.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxgamet?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxgamet?.exe?????.exe (ATTRIB -r -s -h vxgamet?.exe?????.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxgamet?.exe?????.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST vxh8jkdq?.exe (ATTRIB -r -s -h vxh8jkdq?.exe > NUL 2>&1) & (DEL /A /S /Q /F /S /Q vxh8jkdq?.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST w8673492.exe (ATTRIB -r -s -h w8673492.exe > NUL 2>&1) & (DEL /A /S /Q /F w8673492.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wbeconm.dll (ATTRIB -r -s -h wbeconm.dll > NUL 2>&1) & (DEL /A /S /Q /F wbeconm.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST web.exe (ATTRIB -r -s -h web.exe > NUL 2>&1) & (DEL /A /S /Q /F web.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST whitevx.lst (ATTRIB -r -s -h whitevx.lst > NUL 2>&1) & (DEL /A /S /Q /F whitevx.lst >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wiatwain.dll (ATTRIB -r -s -h wiatwain.dll > NUL 2>&1) & (DEL /A /S /Q /F wiatwain.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST win64.exe (ATTRIB -r -s -h win64.exe > NUL 2>&1) & (DEL /A /S /Q /F win64.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winapi32.dll (ATTRIB -r -s -h winapi32.dll > NUL 2>&1) & (DEL /A /S /Q /F winapi32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winbl32.dll (ATTRIB -r -s -h winbl32.dll > NUL 2>&1) & (DEL /A /S /Q /F winbl32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winbrume.dll (ATTRIB -r -s -h winbrume.dll > NUL 2>&1) & (DEL /A /S /Q /F winbrume.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winlfl32.dll (ATTRIB -r -s -h winlfl32.dll > NUL 2>&1) & (DEL /A /S /Q /F winlfl32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST windesktop.dll (ATTRIB -r -s -h windesktop.dll > NUL 2>&1) & (DEL /A /S /Q /F windesktop.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST windesktop.exe (ATTRIB -r -s -h windesktop.exe > NUL 2>&1) & (DEL /A /S /Q /F windesktop.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winldra.exe (ATTRIB -r -s -h winldra.exe > NUL 2>&1) & (DEL /A /S /Q /F winldra.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winmuse.exe (ATTRIB -r -s -h winmuse.exe > NUL 2>&1) & (DEL /A /S /Q /F winmuse.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winnook.exe (ATTRIB -r -s -h winnook.exe > NUL 2>&1) & (DEL /A /S /Q /F winnook.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winstyle2.dll (ATTRIB -r -s -h winstyle2.dll > NUL 2>&1) & (DEL /A /S /Q /F winstyle2.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winstyle3.dll (ATTRIB -r -s -h winstyle3.dll > NUL 2>&1) & (DEL /A /S /Q /F winstyle3.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST winstyle32.dll (ATTRIB -r -s -h winstyle32.dll > NUL 2>&1) & (DEL /A /S /Q /F winstyle32.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wldr.dll (ATTRIB -r -s -h wldr.dll > NUL 2>&1) & (DEL /A /S /Q /F wldr.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wp.bmp (ATTRIB -r -s -h wp.bmp > NUL 2>&1) & (DEL /A /S /Q /F wp.bmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wppp.html (ATTRIB -r -s -h wppp.html > NUL 2>&1) & (DEL /A /S /Q /F wppp.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST wstart.dll (ATTRIB -r -s -h wstart.dll > NUL 2>&1) & (DEL /A /S /Q /F wstart.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST x.exe (ATTRIB -r -s -h x.exe > NUL 2>&1) & (DEL /A /S /Q /F x.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST xenadot.dll (ATTRIB -r -s -h xenadot.dll > NUL 2>&1) & (DEL /A /S /Q /F xenadot.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST yaemu.exe (ATTRIB -r -s -h yaemu.exe > NUL 2>&1) & (DEL /A /S /Q /F yaemu.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z11.exe (ATTRIB -r -s -h z16.exe > NUL 2>&1) & (DEL /A /S /Q /F z11.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z12.exe (ATTRIB -r -s -h z12.exe > NUL 2>&1) & (DEL /A /S /Q /F z12.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z13.exe (ATTRIB -r -s -h z13.exe > NUL 2>&1) & (DEL /A /S /Q /F z13.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z14.exe (ATTRIB -r -s -h z14.exe > NUL 2>&1) & (DEL /A /S /Q /F z14.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z15.exe (ATTRIB -r -s -h z15.exe > NUL 2>&1) & (DEL /A /S /Q /F z15.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST z16.exe (ATTRIB -r -s -h z16.exe > NUL 2>&1) & (DEL /A /S /Q /F z16.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST zlbw.dll (ATTRIB -r -s -h zlbw.dll > NUL 2>&1) & (DEL /A /S /Q /F zlbw.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST zolker011.dll (ATTRIB -r -s -h zolker011.dll > NUL 2>&1) & (DEL /A /S /Q /F zolker011.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ztoolb011.dll (ATTRIB -r -s -h ztoolb011.dll > NUL 2>&1) & (DEL /A /S /Q /F ztoolb011.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ztoolbar.bmp (ATTRIB -r -s -h ztoolbar.bmp > NUL 2>&1) & (DEL /A /S /Q /F ztoolbar.bmp >> "%~dp0"\Clean.log 2>NUL)
IF EXIST ztoolbar.xml (ATTRIB -r -s -h ztoolbar.xml > NUL 2>&1) & (DEL /A /S /Q /F ztoolbar.xml >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__intmon.exe (ATTRIB -r -s -h __delete_on_reboot__intmon.exe > NUL 2>&1) & (DEL /A /S /Q /F __delete_on_reboot__intmon.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__intel32.exe (ATTRIB -r -s -h __delete_on_reboot__intel32.exe > NUL 2>&1) & (DEL /A /S /Q /F __delete_on_reboot__intel32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__intell32.exe (ATTRIB -r -s -h __delete_on_reboot__intell32.exe > NUL 2>&1) & (DEL /A /S /Q /F __delete_on_reboot__intell32.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__OLEADM.dll (ATTRIB -r -s -h __delete_on_reboot__OLEADM.dll > NUL 2>&1) & (DEL /A /S /Q /F __delete_on_reboot__OLEADM.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST __delete_on_reboot__stickrep.dll (ATTRIB -r -s -h __delete_on_reboot__stickrep.dll > NUL 2>&1) & (DEL /A /S /Q /F __delete_on_reboot__stickrep.dll >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%SYSTEMROOT%\SYSTEM32\1024" (ATTRIB -r -h %SYSTEMROOT%\SYSTEM32\1024\*.* > NUL 2>&1) & (DEL /A /S /Q /F /S /Q %SYSTEMROOT%\SYSTEM32\1024\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /s /S /Q "%SYSTEMROOT%\SYSTEM32\1024")
IF EXIST "%SYSTEMROOT%\SYSTEM32\.protected" (ATTRIB -r -s -h "%SYSTEMROOT%\SYSTEM32\drivers\.protected" > NUL 2>&1) & (DEL /A /S /Q /F "%SYSTEMROOT%\SYSTEM32\drivers\.protected" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST %SYSTEMROOT%\SYSTEM32\drivers\hesvc.sys (ATTRIB -r -s -h %SYSTEMROOT%\SYSTEM32\drivers\hesvc.sys > NUL 2>&1) & (DEL /A /S /Q /F %SYSTEMROOT%\SYSTEM32\drivers\hesvc.sys >> "%~dp0"\Clean.log 2>NUL)
popd
IF EXIST %SYSTEMROOT%\SYSTEM32\LogFiles (
    pushd %SYSTEMROOT%\SYSTEM32\LogFiles
    IF EXIST A5281300.so (ATTRIB -r -s -h A5281300.so > NUL 2>&1) & (DEL /A /F /S /Q A5281300.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST T54111925.so (ATTRIB -r -s -h T54111925.so > NUL 2>&1) & (DEL /A /F /S /Q T54111925.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST H53131712.so (ATTRIB -r -s -h H53131712.so > NUL 2>&1) & (DEL /A /F /S /Q H53131712.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST A54102200.so (ATTRIB -r -s -h A54102200.so > NUL 2>&1) & (DEL /A /F /S /Q A54102200.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST S53252000.so (ATTRIB -r -s -h S53252000.so > NUL 2>&1) & (DEL /A /F /S /Q S53252000.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST A04111925.so (ATTRIB -r -s -h A04111925.so > NUL 2>&1) & (DEL /A /F /S /Q A04111925.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST M54111925.so (ATTRIB -r -s -h M54111925.so > NUL 2>&1) & (DEL /A /F /S /Q M54111925.so >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST P54111925.so (ATTRIB -r -s -h P54111925.so > NUL 2>&1) & (DEL /A /F /S /Q P54111925.so >> "%~dp0"\Clean.log 2>NUL)
    popd
)
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
IF EXIST "%HOMEDRIVE%\Documents and Settings\LocalService\Application Data\AlfaCleaner" (DEL /S /Q /A "%HOMEDRIVE%\Documents and Settings\LocalService\Application Data\AlfaCleaner\*.*" >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%HOMEDRIVE%\Documents and Settings\LocalService\Application Data\AlfaCleaner" > NUL 2>&1)
IF EXIST "%USERPROFILE%\Application Data\Install.dat" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Install.dat" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Install.dat" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AdwareSheriff.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AdwareSheriff.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AdwareSheriff.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AlfaCleaner.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AlfaCleaner.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\AlfaCleaner.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\MalwareWipe 4.1.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\MalwareWipe 4.1.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\MalwareWipe 4.1.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpyFalcon 2.0.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpyFalcon 2.0.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpyFalcon 2.0.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake 2.0.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake 2.0.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake 2.0.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake.com 2.1.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake.com 2.1.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareQuake.com 2.1.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareSheriff.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareSheriff.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareSheriff.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareStrike 2.5.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareStrike 2.5.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\SpywareStrike 2.5.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Spyware Soft Stop.lnk" (ATTRIB -r -s -h "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Spyware Soft Stop.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "%USERPROFILE%\Application Data\Microsoft\Internet Explorer\Quick Launch\Spyware Soft Stop.lnk" >> "%~dp0"\Clean.log 2>NUL)
IF "%MSLANG%" == "FR" (pushd %USERPROFILE%\Bureau 2>NUL) ELSE (pushd %USERPROFILE%\Desktop 2>NUL)
    IF EXIST access (ATTRIB -r -s -h access > NUL 2>&1) & (DEL /A /F /S /Q access >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST asfds (ATTRIB -r -s -h asfds > NUL 2>&1) & (DEL /A /F /S /Q asfds >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST BraveSentry.lnk (ATTRIB -r -s -h BraveSentry.lnk > NUL 2>&1) & (DEL /A /F /S /Q BraveSentry.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST cdegfr (ATTRIB -r -s -h cdegfr > NUL 2>&1) & (DEL /A /F /S /Q cdegfr >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST domains (ATTRIB -r -s -h domains > NUL 2>&1) & (DEL /A /F /S /Q domains >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST fdsf (ATTRIB -r -s -h fdsf > NUL 2>&1) & (DEL /A /F /S /Q fdsf >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST map.txt (ATTRIB -r -s -h map.txt > NUL 2>&1) & (DEL /A /F /S /Q map.txt >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST m00.exe (ATTRIB -r -s -h m00.exe > NUL 2>&1) & (DEL /A /F /S /Q m00.exe >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "MalwareWipe.lnk" (ATTRIB -r -s -h "MalwareWipe.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "MalwareWipe.lnk" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "AdwareSheriff.lnk" (ATTRIB -r -s -h "AdwareSheriff.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "AdwareSheriff.lnk" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Air Tickets.url" (ATTRIB -r -s -h "Air Tickets.url" > NUL 2>&1) & (DEL /A /F /S /Q "Air Tickets.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST AlfaCleaner.lnk (ATTRIB -r -s -h AlfaCleaner.lnk > NUL 2>&1) & (DEL /A /F /S /Q AlfaCleaner.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST AntivirusGold.lnk (ATTRIB -r -s -h AntivirusGold.lnk > NUL 2>&1) & (DEL /A /F /S /Q AntivirusGold.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Big Tits.url" (ATTRIB -r -s -h "Big Tits.url" > NUL 2>&1) & (DEL /A /F /S /Q "Big Tits.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Blackjack.url (ATTRIB -r -s -h Blackjack.url > NUL 2>&1) & (DEL /A /F /S /Q Blackjack.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Blowjob.url (ATTRIB -r -s -h Blowjob.url > NUL 2>&1) & (DEL /A /F /S /Q Blowjob.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Britney Spears.url" (ATTRIB -r -s -h "Britney Spears.url" > NUL 2>&1) & (DEL /A /F /S /Q "Britney Spears.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Car Insurance.url" (ATTRIB -r -s -h "Car Insurance.url" > NUL 2>&1) & (DEL /A /F /S /Q "Car Insurance.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Cheap Cigarettes.url" (ATTRIB -r -s -h "Cheap Cigarettes.url" > NUL 2>&1) & (DEL /A /F /S /Q "Cheap Cigarettes.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Cigarettes Discount.url" (ATTRIB -r -s -h "Cigarettes Discount.url" > NUL 2>&1) & (DEL /A /F /S /Q "Cigarettes Discount.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Credit Card.url" (ATTRIB -r -s -h "Credit Card.url" > NUL 2>&1) & (DEL /A /F /S /Q "Credit Card.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Cruises.url (ATTRIB -r -s -h Cruises.url > NUL 2>&1) & (DEL /A /F /S /Q Cruises.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Currency Trading.url" (ATTRIB -r -s -h "Currency Trading.url" > NUL 2>&1) & (DEL /A /F /S /Q "Currency Trading.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Forex Trading.url" (ATTRIB -r -s -h "Forex Trading.url" > NUL 2>&1) & (DEL /A /F /S /Q "Forex Trading.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Free Ringtones.url" (ATTRIB -r -s -h "Free Ringtones.url" > NUL 2>&1) & (DEL /A /F /S /Q "Free Ringtones.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Gift Ideas.url" (ATTRIB -r -s -h "Gift Ideas.url" > NUL 2>&1) & (DEL /A /F /S /Q "Gift Ideas.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Group Sex.url" (ATTRIB -r -s -h "Group Sex.url" > NUL 2>&1) & (DEL /A /F /S /Q "Group Sex.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Home Loan.url" (ATTRIB -r -s -h "Home Loan.url" > NUL 2>&1) & (DEL /A /F /S /Q "Home Loan.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Lesbian Sex.url" (ATTRIB -r -s -h "Lesbian Sex.url" > NUL 2>&1) & (DEL /A /F /S /Q "Lesbian Sex.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST MP3.url (ATTRIB -r -s -h MP3.url > NUL 2>&1) & (DEL /A /F /S /Q MP3.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Mp3 Download.url" (ATTRIB -r -s -h "Mp3 Download.url" > NUL 2>&1) & (DEL /A /F /S /Q "Mp3 Download.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Online Betting.url" (ATTRIB -r -s -h "Online Betting.url" > NUL 2>&1) & (DEL /A /F /S /Q "Online Betting.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Online Casino.url" (ATTRIB -r -s -h "Online Casino.url" > NUL 2>&1) & (DEL /A /F /S /Q "Online Casino.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Online Dating.url" (ATTRIB -r -s -h "Online Dating.url" > NUL 2>&1) & (DEL /A /F /S /Q "Online Dating.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Online Gambling.url" (ATTRIB -r -s -h "Online Gambling.url" > NUL 2>&1) & (DEL /A /F /S /Q "Online Gambling.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Oral Sex.url" (ATTRIB -r -s -h "Oral Sex.url" > NUL 2>&1) & (DEL /A /F /S /Q "Oral Sex.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Party Poker.url" (ATTRIB -r -s -h "Party Poker.url" > NUL 2>&1) & (DEL /A /F /S /Q "Party Poker.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST PestTrap.lnk (ATTRIB -r -s -h PestTrap.lnk > NUL 2>&1) & (DEL /A /F /S /Q PestTrap.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Play Poker.url" (ATTRIB -r -s -h "Play Poker.url" > NUL 2>&1) & (DEL /A /F /S /Q "Play Poker.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Pharmacy.url (ATTRIB -r -s -h Pharmacy.url > NUL 2>&1) & (DEL /A /F /S /Q Pharmacy.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Phentermine.url (ATTRIB -r -s -h Phentermine.url > NUL 2>&1) & (DEL /A /F /S /Q Phentermine.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "PopUp Blocker.url" (ATTRIB -r -s -h "PopUp Blocker.url" > NUL 2>&1) & (DEL /A /F /S /Q "PopUp Blocker.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Porn Dvd.url" (ATTRIB -r -s -h "Porn Dvd.url" > NUL 2>&1) & (DEL /A /F /S /Q "Porn Dvd.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST Pornstars.url (ATTRIB -r -s -h Pornstars.url > NUL 2>&1) & (DEL /A /F /S /Q Pornstars.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "P.S.Guard spyware remover.lnk" (ATTRIB -r -s -h "P.S.Guard spyware remover.lnk" > NUL 2>&1) & (DEL /A /F /S /Q "P.S.Guard spyware remover.lnk" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Real Estate.url" (ATTRIB -r -s -h "Real Estate.url" > NUL 2>&1) & (DEL /A /F /S /Q "Real Estate.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Remove Spyware.url" (ATTRIB -r -s -h "Remove Spyware.url" > NUL 2>&1) & (DEL /A /F /S /Q "Remove Spyware.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST sdfdsf (ATTRIB -r -s -h sdfdsf > NUL 2>&1) & (DEL /A /F /S /Q sdfdsf >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST sdfff (ATTRIB -r -s -h sdfff > NUL 2>&1) & (DEL /A /F /S /Q sdfff >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Sport Betting.url" (ATTRIB -r -s -h "Sport Betting.url" > NUL 2>&1) & (DEL /A /F /S /Q "Sport Betting.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpyGuard.lnk (ATTRIB -r -s -h SpyGuard.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpyGuard.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpyFalcon.lnk (ATTRIB -r -s -h SpyFalcon.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpyFalcon.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpySheriff.lnk (ATTRIB -r -s -h SpySheriff.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpySheriff.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Spyware Remover.url" (ATTRIB -r -s -h "Spyware Remover.url" > NUL 2>&1) & (DEL /A /F /S /Q "Spyware Remover.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpywareQuake.lnk (ATTRIB -r -s -h SpywareQuake.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpywareQuake.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpywareQuake.com.lnk (ATTRIB -r -s -h SpywareQuake.com.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpywareQuake.com.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpywareSheriff.lnk (ATTRIB -r -s -h SpywareSheriff.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpywareSheriff.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST SpywareStrike.lnk (ATTRIB -r -s -h SpywareStrike.lnk > NUL 2>&1) & (DEL /A /F /S /Q SpywareStrike.lnk >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Spyware Soft Stop.lnk" (ATTRIB -r -s -h "Spyware Soft Stop.lnk") & (DEL /A /F /S /Q "Spyware Soft Stop.lnk" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST "Texas Holdem.url" (ATTRIB -r -s -h "Texas Holdem.url" > NUL 2>&1) & (DEL /A /F /S /Q "Texas Holdem.url" >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST viagra.url (ATTRIB -r -s -h viagra.url > NUL 2>&1) & (DEL /A /F /S /Q viagra.url >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST wdcevf (ATTRIB -r -s -h wdcevf > NUL 2>&1) & (DEL /A /F /S /Q wdcevf >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST wdcsadsad (ATTRIB -r -s -h wdcsadsad > NUL 2>&1) & (DEL /A /F /S /Q wdcsadsad >> "%~dp0"\Clean.log 2>NUL)
    IF EXIST zxczxc (ATTRIB -r -s -h zxczxc > NUL 2>&1) & (DEL /A /F /S /Q zxczxc >> "%~dp0"\Clean.log 2>NUL)
    popd
IF EXIST "%USERPROFILE%\Application Data\AlfaCleaner" (DEL /S /Q /F /A "%USERPROFILE%\Application Data\AlfaCleaner"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Application Data\AlfaCleaner")
IF EXIST "%USERPROFILE%\Application Data\PSGuard.com" (DEL /S /Q /F /A "%USERPROFILE%\Application Data\PSGuard.com"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Application Data\PSGuard.com")
IF EXIST "%USERPROFILE%\Application Data\Shudder Global Limited" (DEL /S /F /Q /A "%USERPROFILE%\Application Data\Shudder Global Limited"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Application Data\Shudder Global Limited")
IF EXIST "%USERPROFILE%\Application Data\Skinux" (DEL /S /Q /F /A "%USERPROFILE%\Application Data\Skinux"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Application Data\Skinux")
IF EXIST "%USERPROFILE%\Local Settings\Application Data\AdwareSheriff" (DEL /S /Q /F /A "%USERPROFILE%\Local Settings\Application Data\AdwareSheriff"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Local Settings\Application Data\AdwareSheriff")
IF EXIST "%USERPROFILE%\Local Settings\Application Data\SpywareSheriff" (DEL /S /Q /F /A "%USERPROFILE%\Local Settings\Application Data\SpywareSheriff"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%USERPROFILE%\Local Settings\Application Data\SpywareSheriff")
IF EXIST "%PROGRAMFILES%\paytime.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\paytime.exe" > NUL 2>&1) & (DEL /A /F /Q "%PROGRAMFILES%\paytime.exe") & (ECHO %PROGRAMFILES%\paytime.exe >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\secure32.html" (ATTRIB -r -s -h "%PROGRAMFILES%\secure32.html" > NUL 2>&1) & (DEL /A /F /Q "%PROGRAMFILES%\secure32.html") & (ECHO %PROGRAMFILES%\secure32.html >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\AdwareDelete" (DEL /S /Q /F /A "%PROGRAMFILES%\AdwareDelete"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\AdwareDelete")
IF EXIST "%PROGRAMFILES%\AdwareSheriff" (DEL /S /Q /F /A "%PROGRAMFILES%\AdwareSheriff"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\AdwareSheriff")
IF EXIST "%PROGRAMFILES%\AlfaCleaner" (DEL /S /Q /F /A "%PROGRAMFILES%\AlfaCleaner"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\AlfaCleaner")
IF EXIST "%PROGRAMFILES%\AntivirusGold" (DEL /S /Q /F /A "%PROGRAMFILES%\AntivirusGold"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\AntivirusGold")
IF EXIST "%PROGRAMFILES%\BraveSentry" (DEL /S /Q /F /A "%PROGRAMFILES%\BraveSentry"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\BraveSentry")
IF EXIST "%PROGRAMFILES%\Daily Weather Forecast" (DEL /S /Q /F /A "%PROGRAMFILES%\Daily Weather Forecast"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Daily Weather Forecast")
IF EXIST "%PROGRAMFILES%\MalwareWipe" (DEL /S /Q /F /A "%PROGRAMFILES%\MalwareWipe"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\MalwareWipe")
IF EXIST "%PROGRAMFILES%\PestTrap" (DEL /S /Q /F /A "%PROGRAMFILES%\PestTrap"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\PestTrap")
IF EXIST "%PROGRAMFILES%\PSGuard" (DEL /S /Q /F /A "%PROGRAMFILES%\PSGuard"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\PSGuard")
IF EXIST "%PROGRAMFILES%\P.S.Guard" (DEL /S /Q /F /A "%PROGRAMFILES%\P.S.Guard"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\P.S.Guard")
IF EXIST "%PROGRAMFILES%\Search Maid" (DEL /S /Q /F /A "%PROGRAMFILES%\Search Maid"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Search Maid")
IF EXIST "%PROGRAMFILES%\Security IGuard" (DEL /S /Q /F /A "%PROGRAMFILES%\Security IGuard"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Security IGuard")
IF EXIST "%PROGRAMFILES%\Security Toolbar" (DEL /S /Q /F /A "%PROGRAMFILES%\Security Toolbar"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Security Toolbar")
IF EXIST "%PROGRAMFILES%\SpyAxe" (DEL /S /Q /F /A "%PROGRAMFILES%\SpyAxe"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpyAxe")
IF EXIST "%PROGRAMFILES%\SpyGuard" (DEL /S /Q /F /A "%PROGRAMFILES%\SpyGuard"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpyGuard")
IF EXIST "%PROGRAMFILES%\SpyFalcon" (DEL /S /Q /F /A "%PROGRAMFILES%\SpyFalcon"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpyFalcon")
IF EXIST "%PROGRAMFILES%\SpySheriff" (DEL /S /Q /F /A "%PROGRAMFILES%\SpySheriff"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpySheriff")
IF EXIST "%PROGRAMFILES%\SpyKiller" (DEL /S /Q /F /A "%PROGRAMFILES%\SpyKiller"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpyKiller")
IF EXIST "%PROGRAMFILES%\SpywareQuake" (DEL /S /Q /F /A "%PROGRAMFILES%\SpywareQuake"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpywareQuake")
IF EXIST "%PROGRAMFILES%\SpywareQuake.com" (DEL /S /Q /F /A "%PROGRAMFILES%\SpywareQuake.com"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpywareQuake.com")
IF EXIST "%PROGRAMFILES%\SpywareSheriff" (DEL /S /Q /F /A "%PROGRAMFILES%\SpywareSheriff"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpywareSheriff")
IF EXIST "%PROGRAMFILES%\SpywareStrike" (DEL /S /Q /F /A "%PROGRAMFILES%\SpywareStrike"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\SpywareStrike")
IF EXIST "%PROGRAMFILES%\Spyware Soft Stop" (DEL /S /Q /F /A "%PROGRAMFILES%\Spyware Soft Stop"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Spyware Soft Stop")
IF EXIST "%PROGRAMFILES%\Virtual Maid" (DEL /S /Q /F /A "%PROGRAMFILES%\Virtual Maid"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Virtual Maid")
IF EXIST "%PROGRAMFILES%\WinHound" (DEL /S /Q /F /A "%PROGRAMFILES%\WinHound"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\WinHound")
IF EXIST "%HOMEDRIVE%\spywarevanisher-free" (DEL /S /Q /F /A "%PROGRAMFILES%\Spywarevanisher-free"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%HOMEDRIVE%\spywarevanisher-free")
IF EXIST "%PROGRAMFILES%\internet explorer\ieengine.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\internet explorer\ieengine.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\internet explorer\ieengine.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Fichiers communs\Download\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Fichiers communs\Download\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Fichiers communs\Download\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Common Files\Download\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Common Files\Download\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Common Files\Download\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Fichiers communs\InetGet\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Fichiers communs\InetGet\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Fichiers communs\InetGet\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Common Files\InetGet\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Common Files\InetGet\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Common Files\InetGet\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Fichiers communs\muwq" (DEL /S /Q /F /A "%PROGRAMFILES%\Fichiers communs\muwq"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Fichiers communs\muwq")
IF EXIST "%PROGRAMFILES%\Common Files\muwq" (DEL /S /Q /F /A "%PROGRAMFILES%\Common Files\muwq"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Common Files\muwq")
IF EXIST "%PROGRAMFILES%\Fichiers communs\Windows\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Fichiers communs\Windows\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Fichiers communs\Windows\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Common Files\Windows\mc-58-12-0000113.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Common Files\Windows\mc-58-12-0000113.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Common Files\Windows\mc-58-12-0000113.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Fichiers communs\Windows\services32.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Fichiers communs\Windows\services32.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Fichiers communs\Windows\services32.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Common Files\Windows\services32.exe" (ATTRIB -r -s -h "%PROGRAMFILES%\Common Files\Windows\services32.exe" > NUL 2>&1) & (DEL /A /F /S /Q "%PROGRAMFILES%\Common Files\Windows\services32.exe" >> "%~dp0"\Clean.log 2>NUL)
IF EXIST "%PROGRAMFILES%\Common Files\VCClient" (DEL /S /Q /F /A "%PROGRAMFILES%\Common Files\VCClient"\*.* >> "%~dp0"\Clean.log 2>NUL) & (RD /S /Q "%PROGRAMFILES%\Common Files\VCClient")
ECHO. >> "%~dp0"\Clean.log
ECHO Those spywares have been correctly deleted ! >> "%~dp0"\Clean.log

:EXTEND
IF "%EXTEND%" NEQ "YES" GOTO NOEXT
IF DEFINED SAFEBOOT_OPTION IF "%SAFEBOOT_OPTION%" == "MINIMAL" GOTO NOEXT
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
ECHO. >> "%~dp0"\Clean.log 2>&1
CD /d %SYSTEMROOT%\SYSTEM32\DLLCACHE\ > NUL 2>&1
IF EXIST CPROFILE.EXE COPY CPROFILE.EXE %SYSTEMROOT%\SYSTEM32 >NUL 2>&1
CD /d %SYSTEMROOT%\SYSTEM32\ > NUL 2>&1
IF EXIST CPROFILE.EXE CALL CPROFILE.EXE /L /V >> "%~dp0"\Clean.log 2>NUL
IF EXIST GPUPDATE.EXE CALL GPUPDATE.EXE >> "%~dp0"\Clean.log 2>&1
IF EXIST FIXMAPI.EXE CALL FIXMAPI.EXE > NUL 2>&1
IF EXIST IISRESET.EXE CALL IISRESET.EXE /START >> "%~dp0"\Clean.log 2>&1
IF EXIST NETSH.EXE CALL NETSH.EXE SET MACHINE %HOSTNAME% >> "%~dp0"\Clean.log 2>&1
IF EXIST SPIISUPD.EXE CALL SPIISUPD.EXE >> "%~dp0"\Clean.log 2>&1
IF EXIST TSCUPGRD.EXE CALL TSCUPGRD.EXE >> "%~dp0"\Clean.log 2>&1
IF EXIST NET.EXE CALL NET CONFIG SERVER /HIDDEN:YES >> "%~dp0"\Clean.log 2>NUL
CD /d "%~dp0"\ > NUL 2>&1
ECHO. >> "%~dp0"\Clean.log
IF NOT EXIST "%~dp0"\CleanCL.log GOTO NOEXT
ECHO Clean updated the following classes >> "%~dp0"\Clean.log
COPY Clean.log+CleanCL.log Cltmp.log > NUL 2>&1
(DEL /S /Q Clean.log > NUL 2>&1) & (DEL /S /Q CleanCL.log > NUL 2>&1)
REN Cltmp.log Clean.log > NUL 2>&1

:NOEXT
IF "%SFCCLEAN%" == "YES" IF EXIST %SYSTEMROOT%\SYSTEM32\SFC.EXE (
    ECHO Launching the System Files Verifier... >> "%~dp0"\Clean.log
    %SYSTEMROOT%\SYSTEM32\SFC.EXE /PURGECACHE
    %SYSTEMROOT%\SYSTEM32\SFC.EXE /SCANNOW
)
TYPE %HOMEDRIVE%\PROGRES.DAT 2>NUL
IF EXIST %SYSTEMROOT%\$tmp$.tm$ DEL %SYSTEMROOT%\$tmp$.tm$ > NUL 2>&1)
IF EXIST %SYSTEMROOT%\SYSTEM32\DEFRAG.EXE %SYSTEMROOT%\SYSTEM32\DEFRAG -b %HOMEDRIVE% >> "%~dp0"\Clean.log 2>&1
ECHO. >> "%~dp0"\Clean.log 2>&1
CD /d %HOMEDRIVE%\ > NUL 2>&1
ECHO @ECHO OFF > DISKFRE3.BAT
ECHO IF "%%5"=="%BYTES%" SET DISKAFTER=%%3 >> DISKFRE3.BAT
ECHO IF "%%6"=="%BYTES%" SET DISKAFTER=%%3%%4 >> DISKFRE3.BAT
ECHO IF "%%7"=="%BYTES%" SET DISKAFTER=%%3%%4%%5 >> DISKFRE3.BAT
ECHO IF "%%8"=="%BYTES%" SET DISKAFTER=%%3%%4%%5%%6 >> DISKFRE3.BAT
COPY DISKFREE.DAT DISKFRE4.BAT > NUL
DIR %HOMEDRIVE% | FIND /I "%BYTESFREE%" >> DISKFRE4.BAT
CALL DISKFRE4.BAT > NUL 2>&1
DEL DISKFRE4.BAT > NUL 2>&1
DEL DISKFRE3.BAT > NUL 2>&1
DEL DISKFREE.DAT > NUL 2>&1
SET DISKFR=
IF DEFINED DISKAFTER IF DEFINED DISKFREE SET /A DISKFR=%DISKAFTER%-%DISKFREE% 2>NUL
IF NOT DEFINED DISKFR GOTO NOSPACE
    IF %DISKFR% LEQ 1024 (
        IF %DISKFR% LEQ 1 (
            ECHO Clean couldn't release free space this time >> "%~dp0"\Clean.log 2>&1
        ) ELSE (
            ECHO Clean released %DISKFR% Kilobytes >> "%~dp0"\Clean.log 2>&1
        )
    ) ELSE (
        ECHO Clean released %DISKFR:~0,-3% Megabytes, %DISKFR% Kilobytes >> "%~dp0"\Clean.log 2>&1
    )
:NOSPACE

FOR /F "tokens=1" %%I IN ('TYPE "%~dp0"\Clean.log^|FIND /C "\"') DO SET /a FAMOUNT=%%I-1 > NUL 2>&1
IF DEFINED FAMOUNT ECHO Found and wiped %FAMOUNT% files >> "%~dp0"\Clean.log 2>&1
ECHO All the requested operations have been successfully performed ! >> "%~dp0"\Clean.log 2>&1
CD /d %HOMEDRIVE%\ > NUL 2>&1
DEL /F /A /Q SCRIPT.CLN > NUL 2>&1
DEL /F /A /Q MAINMSG.DAT > NUL 2>&1
DEL /F /A /Q PROGRES.DAT > NUL 2>&1
IF "%NOKILL%" =="NO" IF NOT DEFINED SAFEBOOT_OPTION START EXPLORER.EXE
ECHO.
ECHO Ok
IF DEFINED UTIL IF "%UTIL%" == "1" COPY "%~dp0"\Clean.log %SYSTEMROOT%\SYSTEM32\Clean1st.log > NUL 2>&1
IF EXIST %SYSTEMROOT%\NOTEPAD.EXE IF EXIST "%~dp0"\Clean.log START %SYSTEMROOT%\NOTEPAD.EXE "%~dp0\Clean.log"
CD /d %DTMP% > NUL 2>&1

:BADVERSION
IF DEFINED UTIL SET UTIL=
IF DEFINED DTMP SET DTMP=
IF DEFINED FRAUD SET FRAUD=
IF DEFINED EXTEND SET EXTEND=
IF DEFINED REGSCAN SET REGSCAN=
IF DEFINED ALLDRIVES SET ALLDRIVES=
IF DEFINED MRUCLEAN SET MRUCLEAN=
IF DEFINED SFCCLEAN SET SFCCLEAN=
IF DEFINED NOKILL SET NOKILL=
IF DEFINED MSLANG SET MSLANG=
IF DEFINED BYTESFREE SET BYTESFREE=
IF DEFINED BYTES SET BYTES=
IF DEFINED FAMOUNT SET FAMOUNT=
IF DEFINED DISKFREE SET DISKFREE=
IF DEFINED DISKAFTER SET DISKAFTER=
IF DEFINED DISKFR SET DISKFR=
ECHO.
TITLE Cmd
