@echo off
D:\Software\DEV\Programs\Pandoc\pandoc.exe -s --toc -c ahk-theme.css -B header.html -A footer.html index.md -o index.html
rem pause
START file:///D:\Software\DEV\Work\AHK\Projects\Make_Doc\index.html
