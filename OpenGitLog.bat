@echo off
REM 環境変数 path に "C:\Program Files\Git\cmd" を追加しておく
set SOURCE_TREE=%homedrive%%homepath%\AppData\Local\SourceTree\SourceTree.exe
set FIND_PATH=%~1\..\
set REPOS_ROOT=""
cd %FIND_PATH%
set DRIVE_ROOT=%~d1\
set WORK_FILE=%homedrive%%homepath%\.opengitlog

:FIND_HEAD
dir %CD% /ad /b > %WORK_FILE%
for /f %%L in (%WORK_FILE%) do (
	if "%%L" == ".git" (
		set REPOS_ROOT=%CD%
	)
	if %%L == %DRIVE_ROOT% (
		set REPOS_ROOT=0
	)
)
if %REPOS_ROOT% == "" (
	CD ../
	goto :FIND_HEAD
)
if %REPOS_ROOT% == 0 (
	exit
)

set RELATIVE_PATH=`git -C %REPOS_ROOT% ls-files --full-name %~1`
%SOURCE_TREE% -f %REPOS_ROOT% filelog %~1%
del %WORK_FILE%