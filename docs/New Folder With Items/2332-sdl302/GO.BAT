@echo off
echo Type "Go n" where n=port number
echo -
echo -
PCSDL -p%1 -r57600 -vNA3.0.2 -vSD3.0.2 -nSDie -nNAie -b

