@echo off
echo Iniciando processamento...

for /L %%i in (2001,1,2025) do (
    python Processa_DADOS_LOA.py LOA%%i.csv
)

echo Finalizado!
pause