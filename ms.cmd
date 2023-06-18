
python start.py %1 mips1.asm %2 %3

if "%2" == "nocomp" goto ENDE
if "%3" == "nocomp" goto ENDE

java -jar Mars.jar mips1.asm

:ENDE







