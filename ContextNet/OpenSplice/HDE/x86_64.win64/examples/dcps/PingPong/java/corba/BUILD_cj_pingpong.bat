@echo off
echo cd %~dp0
cd %~dp0
setlocal

set JARFILE=cj_pingpong.jar
set MANIFEST=cj_pingpong.manifest

IF [%1]==[] GOTO build
IF /I "%1"=="clean" GOTO clean
IF /I "%1"=="rebuild" GOTO clean
ECHO Error: unrecognised option: %1
GOTO error

:clean
REM
REM Clean any previous output
REM
echo Cleaning...
del /f/s/q classes\%MANIFEST% 2>nul
del /f/s/q pingpongDcps.idl pingpong\*.java  2>nul
del /f/s/q classes\pingpong\*.class 2>nul

IF /I "%1"=="clean" GOTO end

:build

REM
REM Generate java classes from IDL
REM
echo Processing ..\..\idl\pingpong.idl....
echo "..\..\..\..\..\bin\idlpp" -I "..\..\..\..\..\etc\idl" -C -l java ..\..\idl\pingpong.idl
"..\..\..\..\..\bin\idlpp" -I "..\..\..\..\..\etc\idl" -C -l java ..\..\idl\pingpong.idl
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Compilation of ..\..\idl\pingpong.idl failed
  ECHO:
  GOTO error
)
echo java -classpath "%JACORB_HOME%\lib\idl.jar;%JACORB_HOME%\lib\endorsed\logkit.jar" org.jacorb.idl.parser -I..\..\..\..\..\etc\idl ..\..\idl\pingpong.idl
java -classpath "%JACORB_HOME%\lib\idl.jar;%JACORB_HOME%\lib\endorsed\logkit.jar" org.jacorb.idl.parser -I..\..\..\..\..\etc\idl ..\..\idl\pingpong.idl
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Post compilation step java -classpath "%JACORB_HOME%\lib\idl.jar;%JACORB_HOME%\lib\endorsed\logkit.jar" org.jacorb.idl.parser -I..\..\..\..\..\etc\idl ..\..\idl\pingpong.idl failed
  ECHO:
  GOTO error
)
echo Processing pingpongDcps.idl....
echo java -classpath "%JACORB_HOME%\lib\idl.jar;%JACORB_HOME%\lib\endorsed\logkit.jar" org.jacorb.idl.parser -I..\..\..\..\..\etc\idl -I../../idl pingpongDcps.idl
java -classpath "%JACORB_HOME%\lib\idl.jar;%JACORB_HOME%\lib\endorsed\logkit.jar" org.jacorb.idl.parser -I..\..\..\..\..\etc\idl -I../../idl pingpongDcps.idl
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Compilation of pingpongDcps.idl failed
  ECHO:
  GOTO error
)


REM
REM Compile java code
REM
echo Creating class output dir classes\....
if not exist classes\ echo mkdir classes\
if not exist classes\ mkdir classes\
echo Compiling Java classes....
echo javac -endorseddirs "%JACORB_HOME%\lib\endorsed" -cp "classes\;..\..\..\..\..\jar\dcpscj.jar;" -d classes\ pingpong\*.java
javac -endorseddirs "%JACORB_HOME%\lib\endorsed" -cp "classes\;..\..\..\..\..\jar\dcpscj.jar;" -d classes\ pingpong\*.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of pingpong\*.java failed
  ECHO:
  GOTO error
)

REM
REM Build a jar file
REM
set JARFLAGS=cvfm
echo Building a jar file....
echo echo Class-Path: ..\..\..\..\..\jar\dcpscj.jar ^> classes\%MANIFEST%
echo Class-Path: ..\..\..\..\..\jar\dcpscj.jar > classes\%MANIFEST%
echo pushd classes\ ^& jar %JARFLAGS% %JARFILE% %MANIFEST%  pingpong\*.class ^& popd
pushd classes\ & jar %JARFLAGS% %JARFILE% %MANIFEST%  pingpong\*.class & popd
echo move /y classes\%JARFILE% .
move /y classes\%JARFILE% .
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Building jar file %JARFILE% failed
  ECHO:
  GOTO error
)

GOTO end

:error
ECHO An error occurred, exiting now
:end
