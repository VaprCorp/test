@ECHO Off & Goto :main
:ColorMenu
 rem Set /A "RR=!random! %%195 + 60","GG=!random! %%195 + 60","BB=!random! %%195 + 60"
 rem Set "%~1=%/E%38;2;!RR!;!GG!;!BB!m!%~1!%/E%0m"
 Set "rV="& IF "!#A!"=="" (Set #A=32)
 (For %%C in ("!%~1!")Do Set "rv=!rV!%/E%!#A!m%%~C%/E%0m"& Set /A "#A+=1"& IF "!#A!"=="37" (Set #A=31)) & Set "%~1=!rV!"
Exit /B 0
:main
(Set LF=^


%= empty lines above are required. =%)
For /F eol^=^%LF%%LF%^ delims^= %%A in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x09"') do Set "TAB=%%A"
 For /F %%a in ('echo prompt $E ^| cmd')do (Set "/E=%%a[")
 Set "ChoList=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 Set "Menu=For %%n in (1 2)Do if %%n==2 (!DIV!&Set "CH#=0"&(Set "CHCS="&For %%G in (!Options!)Do For %%i in (!CH#!)Do (Set "CHCS=!CHCS!!ChoList:~%%i,1!"&Set "Opt[!ChoList:~%%i,1!]=%%~G"& Set "Opt=%%~G" &Call :ColorMenu Opt &<Nul Set /P "=[!ChoList:~%%i,1!] !Opt!"&Set /A "CH#+=1"&Echo/))&!DIV!& For /F "Delims=" %%o in ('Choice /N /C:!CHCS!')Do (Set "OPTION=!Opt[%%o]!"))Else Set Options="
 rem /* outdated */ Set "Menu=For %%n in (1 2)Do if %%n==2 ((Set "CHCS="&For %%G in (!Options!)Do (Set "Opt=%%~G"& Set "CHCS=!CHCS!!Opt:~0,1!"&Set "Opt[!Opt:~0,1!]=%%~G"& Set "Opt=[!Opt:~0,1!]!Opt:~1!"&Call :ColorMenu Opt &Echo/!Opt!))&!DIV!& For /F "Delims=" %%o in ('Choice /N /C:!CHCS!')Do (For %%C in ("!Opt[%%o]!")Do (Set "OPTION=%%~C")))Else Set Options="
 Set "DEF/array=(If "!#$E!"=="" (Set "#$E=-1"))&For %%n in (1 2)Do if %%n==2 (Set /A "#$E+=1"&For %%G in (!$E!)Do (Set "$E[!#$E!]=%%~G"))Else Set $E="
 Set "DEL/array=(Set "#$E="&(For /F "Tokens=1,2 Delims==" %%G in ('Set $E[ 2^> Nul ')Do Set "%%G=" > Nul 2> Nul ))"
 Set "GetFiles=(For /F "Delims=" %%O in ('Dir /B *.$E /O:-D')Do %DEF/array%"%%~fO")"
 Set "SelectFile=%DEL/array% & %GetFiles% & If "!#$E!"=="" (!DIV!&Echo/No $E files in !CD!&!DIV!&Goto :Eof)Else For %%n in (1 2)Do If %%n==2 (Set "Ext=$E"&Set "FN="&(If /I "!#$E!"=="-1" (Echo/No $E Files found. & Exit /B 0))& (For /L %%i in (0 1 !#$E!) Do If Not "!$E[%%i]!"=="" Echo/%%i:!TAB!!$E[%%i]!)&!DIV!&Echo/[%/E%36mExit%/E%0m] or Select a $E file number [%/E%36m0%/E%0m-%/E%36m!#$E!%/E%0m]:&!DIV!&Set /P "FN=FN: "&For %%v in ("!FN!")do (If /I "!FN!"=="Exit" (Exit /B 0)Else If /I "!FN!"=="E" (Exit /B 0)Else If not "!$E[%%~v]!"=="" (Set "PATH[$E]=!$E[%%~v]!"&!DIV!&Echo/!$E[%%~v]! Selected)Else (Echo/invalid file index&!DIV!& Timeout 1 /Nobreak > Nul & Goto :!rLabel! )))Else Set rLabel="
 Set "GetFolders=%DEL/array% & Set "#$E="&For /F "Delims=" %%O in ('Dir /B /A:D')Do %DEF/array%"%%~fO""
 Set "SelectFolder=Set "FN="&(If /I "!#$E!"=="-1" (Echo/No Folders found in !CD!.))& (For /L %%i in (0 1 !#$E!) Do If Not "!$E[%%i]!"=="" Echo/%%i:!TAB!!$E[%%i]!)&!DIV!&Echo/[%/E%36mExit%/E%0m ^| %/E%36m..%/E%0m] Select a $E number [%/E%36m0%/E%0m-%/E%36m!#$E!%/E%0m]:&!DIV!&Set /P "FN=$E #: "&For %%v in ("!FN!")do (If /I "!FN!"=="Exit" (Exit /B 0)Else If /I "!FN!"=="E" (Exit /B 0)Else If "!FN!"==".." (CD .. &!DIV!&Echo/!CD!&!DIV!&Exit /B)Else If not "!$E[%%~v]!"=="" (Set "$E=!$E[%%~v]!"&!DIV!&Echo/!$E[%%~v]! Selected)Else (Echo/invalid index&!DIV!& Timeout 1 /Nobreak > Nul & Goto :Dir ))"
 Set "Do=Set "FN="&If /I "!Option!"=="Exit" (Goto :Eof)Else IF /I "!Option!"=="Ren" (For %%P in ("!Path[$E]!")Do (Set /P "FN=New Name: " & If "!FN!"=="" (!DIV!%/E%31mFilename required%/E%0m&!DIV!& Goto :!rLabel!)Else If Not exist "!FN!.$E" (Ren %%~nxP !FN!.$E)Else (!DIV!&Echo/%/E%31m"!FN!.$E" Already exists.%/E%0m&!DIV! & Goto :!rLabel!)) & !DIV!&Echo/%/E%32mRename Succesful.%/E%0m&!DIV! & Goto :!rLabel!)Else IF /I "!Option!"=="View Info" (Echo/Modified:!TAB!!TAB!Size:!TAB!Attribs:!TAB!Location:&!DIV! & For %%I in ("!Path[$E]!")Do (Echo/%%~tI!TAB!%%~zI!TAB!%%~aI!TAB!%%~dpI))Else (For %%i in ("!Path[$E]!")Do IF /I Not "!Option!"=="View Info" Echo/[!Option!] !Path[$E]!&!DIV!&!Option! "%%~i")"
 Set "Wait= Echo/&!DIV!&For %%n in (1 2) Do If %%n==2 (Set "$S=Str"& Call :ColorMenu $S & Echo/!$S!&!DIV! & Timeout !TO! > Nul 2> Nul )Else Set TO="
 Setlocal EnableDelayedExpansion
 for /F "usebackq tokens=2* delims=: " %%W in (`mode con ^| findstr Columns`) do Set "Console_Width=%%%W"
 Set "DIV="&For /L %%i in (2 1 %Console_Width%)Do Set "DIV=!DIV!-"
 Set "DIV=Echo/%/E%33m!DIV!%/E%0m"
 If exist "%userprofile%\Desktop\" (Set "SourceDir=%userprofile%\Desktop\") Else (Set "SourceDir=%~dp0")
 PUSHD "%SourceDir%" && cls || (Echo/You lack write permission in %~dp0 & Exit /B 1)
%Wait:Str=[!CD!]%0
:menu
 Title %~n0
 %Menu% Exit "Dir Change" Batch Text Vbs Cls "All Files" "User specified command" "Attribs"
 If /I "!Option!"=="Exit" (POPD & Endlocal & Endlocal & Goto :Eof) Else If "!Option!"=="Cls" (Cls)Else Call :!Option! 2> Nul
 Set "#A=32"
 %Wait:Str=!CD!%0
 %DEL/array:$E=Bat% & %DEL/array:$E=Txt% & %DEL/array:$E=Vbs%
Goto :menu
:Dir Change
 %GetFolders:$E=DirPath%
 %SelectFolder:$E=DirPath%
  PUSHD "%DirPath%"
Exit /B
:Batch
 %SelectFile:$E=Bat%Batch
 (%Menu% "Exit /B" "Attribs" Type Call "Start """ "Ren" "Del /P" Notepad.exe "View Info" "User Specified Command") && If "!Option!"=="User Specified Command" ( Call :!Option! 2> Nul )Else If /I "!Option!"=="Attribs" (Call :Attribs)Else %Do:$E=Bat%
 %Wait:Str=Continue %50
Goto :Batch
:Text
 %SelectFile:$E=Txt%Text
 (%Menu% "Exit /B" Type "Ren" "Del /P" Notepad.exe "View Info" "User Specified Command") && If "!Option!"=="User Specified Command" ( Call :!Option! 2> Nul )Else %Do:$E=Txt%
 %Wait:Str=Continue.%50
Goto :Text
:Vbs
 %SelectFile:$E=Vbs%Vbs
 (%Menu% "Exit /B" Type "Ren" "Del /P" "Start """ Notepad.exe "View Info" "User Specified Command") && If "!Option!"=="User Specified Command" ( Call :!Option! 2> Nul )Else %Do:$E=Vbs%
 %Wait:Str=Continue.%50
Goto :Vbs
:All Files
Set "Spacer=                                                  "
 Echo/%/E%4m%/E%32mModified:%TAB%%TAB%%/E%90mSize:%TAB%%TAB%%/E%31mAttribs:%TAB%%/E%34mType:%TAB%%/E%36mName:%/E%0m&Echo/
For /F "Delims=" %%G in ('Dir /B *.* /O:-D /T:W /A:-D') Do (
 SETLOCAL DISABLEdelayedExpansion
 Set "T=%%~tG" & Set "S=%%~zG%Spacer%" & Set "A=%%~aG%Spacer%" & Set "X=%%~xG%Spacer%" & Set "N=%%~nG"
 SETLOCAL ENABLEdelayedExpansion
 <Nul Set /P"=%/E%32m!T:~0,20!!TAB!%/E%90m!S:~0,12!!TAB!%/E%31m!A:~0,14!!TAB!%/E%34m!X:~0,5!!TAB!%/E%36m!N!%/E%0m"&Echo/
 ENDLOCAL
 ENDLOCAL
)
Goto :Eof
:Attribs
If Not Exist "!Path[%Ext%]!" (Echo/["!Path[%Ext%]!"] File selected does not exist & Exit /B 0)
For %%G in ("!Path[%Ext%]!")Do Echo/%/E%32m !Path[%Ext%]! %/E%36m%%~aG%/E%0m
%Menu%  "Exit /B" "Attrib -R" "Attrib +R" "Attrib -H" "Attrib +H"
if /I "%Option%"=="Exit /B" (Exit /B 0)Else %Option% "!Path[%Ext%]!"
Goto :Attribs
:User specified command
Setlocal DISABLEdelayedexpansion
Set "CM="& Set /P "CM=[%/E%36mExit%/E%0m] Enter your Command: "&!DIV!
Endlocal & Set "CM=%CM%"
IF "%CM%" == "" (Echo/Command Required& Goto :User)Else If /I "%CM%" == "Exit" (Exit /B 0)Else If /I "%CM%" == "E" (Exit /B 0)
cmd /k "%CM% & Exit /B 0" 
If Not Errorlevel 0 Echo/Invalid command specified or command failed.
Echo/&!DIV!
Goto :User