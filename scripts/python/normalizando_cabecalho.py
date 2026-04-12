import pandas as pd
import unicodedata
import re

def normalizar_cabecalho(coluna):
    # Remove acentos
    coluna = unicodedata.normalize('NFKD', coluna).encode('ASCII', 'ignore').decode('utf-8')
    # Remove espaços extras e substitui por underscore
    coluna = re.sub(r'\s+', '_', coluna.strip())
    # Remove qualquer caractere que não seja alfanumérico ou underscore
    coluna = re.sub(r'[^\w]', '', coluna)
    return coluna.lower()

def normalizar_csv(caminho_entrada, caminho_saida):
    df = pd.read_csv(caminho_entrada)
    df.columns = [normalizar_cabecalho(col) for col in df.columns]
    df.to_csv(caminho_saida, index=False)
    print(f"Arquivo normalizado salvo em: {caminho_saida}")

# Exemplo de uso
entrada = 'SIGA_BRASIL_2020.csv'
saida = 'dados_normalizados_siga_brasil.csv'
normalizar_csv(entrada, saida)