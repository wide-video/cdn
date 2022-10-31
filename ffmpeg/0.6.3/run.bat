@ECHO off

REM 7z https://github.com/mcmilk/7-Zip-zstd
REM brotli https://mirror.msys2.org/mingw/mingw32/mingw-w64-i686-brotli-1.0.9-5-any.pkg.tar.zst

IF NOT EXIST wasm.tar.gz (
	ECHO wasm.tar.gz not found
	PAUSE
	EXIT
)

IF NOT EXIST ffmpeg.exe (
	ECHO ffmpeg.exe not found
	PAUSE
	EXIT
)

7z x wasm.tar.gz -aoa
DEL wasm.tar.gz

7z x wasm.tar -aoa
DEL wasm.tar

ECHO. > .htaccess
for /r %%i in (*.exe, *.js, *.wasm) do (
	brotli %%i -o %%i.br -Z -f

	ECHO ^<FilesMatch "(%%~nxi\.br)$"^> >> .htaccess
	ECHO Header set x-content-length %%~zi >> .htaccess
	ECHO ^</FilesMatch^> >> .htaccess

	DEL %%i
)