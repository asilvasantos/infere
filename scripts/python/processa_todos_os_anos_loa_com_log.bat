@echo off
echo Iniciando processamento... > log.txt

for /L %%i in (2001,1,2025) do (
    echo Processando LOA%%i.csv... >> log.txt
    python Processa_DADOS_LOA.py LOA%%i.csv >> log.txt 2>&1
)

echo Finalizado! >> log.txt
pause