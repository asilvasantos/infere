import pandas as pd
import numpy as np
import glob
import os

# Pega o diretório atual
diretorio_base = os.getcwd()

# Caminho da pasta onde estão os CSVs
pasta = os.path.join(os.path.dirname(os.path.dirname(diretorio_base)) , 'dados' ,'1_dados_regionalizados')
pasta_saida = os.path.join(os.path.dirname(os.path.dirname(diretorio_base)) , 'dados','2_dados_empilhados')
print(pasta)
arquivos = glob.glob(os.path.join(pasta, "*.csv"))

if not arquivos:
    raise ValueError("Nenhum arquivo CSV encontrado na pasta!")

# ---------------------------------------------------------
# 1. Diagnóstico inicial: colunas de cada arquivo
print("Diagnóstico das colunas por arquivo:")
colunas_gerais = set()
for arq in arquivos:
    df_temp = pd.read_csv(arq, nrows=1)  # só lê 1 linha para ser rápido
    colunas = df_temp.columns.str.strip().str.upper().tolist()
    colunas_gerais.update(colunas)
    print(f"- {os.path.basename(arq)}: {colunas}")

colunas_gerais = sorted(colunas_gerais)
print("\nConjunto total de colunas detectadas:", colunas_gerais)

# ---------------------------------------------------------
# 2. Padronizar e empilhar
dfs = []
for arq in arquivos:
    df = pd.read_csv(arq)

    # Normaliza nomes das colunas
    df.columns = df.columns.str.strip().str.upper()

    # Garante todas as colunas detectadas
    for c in colunas_gerais:
        if c not in df.columns:
            df[c] = None  # adiciona coluna faltante

    # Reordena as colunas na mesma ordem
    df = df[colunas_gerais]

    dfs.append(df)

# ---------------------------------------------------------
# 3. Concatena tudo
final = pd.concat(dfs, ignore_index=True)

# preenche campos vazios
'''final['LOCALIDADE.UF'] = (df['LOCALIDADE.UF'].astype(str)                    # força string
                                             .str.strip()                    # remove espaços invisíveis
                                             .replace(
                                                ["", "nan", "NaN", "None", "NA", "<NA>"],
                                                np.nan
                                            ).fillna("ND"))
'''
'''
final['REGIÃO'] = (df['REGIÃO'].astype(str) # força string
                                .str.strip()                    # remove espaços invisíveis
                                .replace(
                                ["", "nan", "NaN", "None", "NA", "<NA>"],
                                np.nan
                                ).fillna("ND"))
'''
#Preenchimento dos campos vazios.
final['LOCALIDADE.UF'] = (
    final['LOCALIDADE.UF']
    .fillna('ND')          # NaN → ND
    .str.strip()           # remove espaços
    .replace('', 'ND')     # vazio → ND
)
final['LOCALIDADE.UF'] = (
    final['LOCALIDADE.UF']
    .fillna('ND')          # NaN → ND
    .str.strip()           # remove espaços
    .replace('NÃO APLICÁVEL', 'ND')     # vazio → ND
)

#Preenchimento dos campos vazios.
final['REGIÃO'] = (
    final['REGIÃO']
    .fillna('ND')          # NaN → ND
    .str.strip()           # remove espaços
    .replace('', 'ND')     # vazio → ND
)
final['REGIÃO'] = (
    final['REGIÃO']
    .fillna('ND')          # NaN → ND
    .str.strip()           # remove espaços
    .replace('NÃO APLICÁVEL', 'ND')     # vazio → ND
)


         
# Ordena colunas
ordem = [
       # 'ACAO_COD', 
        'AÇÃO (COD/DESC)  (AJUSTADA)', 
        'ESFERA (COD/DESC)', 
        'ELEMENTO DESPESA (COD/DESC)', 
        'FUNCIONAL', 
        'FUNÇÃO (COD/DESC)', 
        'MOD. APLIC. (COD/DESC)', 
        'PROGRAMA (COD/DESC)',
        'UG (COD/DESC)',
        'UG.UF',
        'UO (COD/DESC) (AJUSTADO)',
        'ÓRGÃO (COD/DESC)',
        'ÓRGÃO SUPERIOR (COD/DESC)',
        'SUB-ELEMENTO DESPESA (COD/DESC)', 
        'SUBFUNÇÃO (COD/DESC)', 
        'SUBTÍTULO (COD/DESC)', 
        'GND (COD)', 
        'LOCALIDADE.UF', 
        'REGIÃO', 
        'UF_IPEA01',
        'UF_IPEA02',
        'UF_IPEA03',
        'UF_IPEA04',
        'UF_IPEA05',
        'UF_FINAL', 
        'REGIAO_IPEA', 
        #'LIQUIDADO', 
        #'LIQUIDADO (SUBELEMENTO)', 
        'DOTAÇÃO INICIAL', 
        'AUTORIZADO',
        'EMPENHADO', 
        'DESPESA EXECUTADA', 
        'ANO' 
        ]
final = final [ordem]

# ---------------------------------------------------------
# 4. Salva o resultado
saida = pasta_saida + "/" + "loa_regionalizada_unificada.csv"
final.to_csv(saida, index=False, encoding="utf-8-sig")

print(f"\n🎉 Arquivo final salvo como: {saida}")
print(f"Linhas combinadas: {len(final)} | Colunas: {len(final.columns)}")