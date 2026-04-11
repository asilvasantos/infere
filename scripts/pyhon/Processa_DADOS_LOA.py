#+-------------------------------------------------------+
#|Projeto: INFERE                                        |
#|Autor: Alexandre Silva dos Santos                      |
#|Descrição: Script de processamento da regionalização   |
#|           dos dados da LOA.                           | 
#|Data começo: 08/07/2025                                |
#|Data fim: 21/01/2026                                   |
#+-------------------------------------------------------+

##########################################################
# Comentário do Nelson com a série gerada em: 15/10/2025 #
# "problemas sérios em 11,12,13 e 14"                    #
##########################################################

import pandas as pd
import numpy as np
from SIGA_Util import * 

# Caminhos dos arquivos
caminho_arquivo = '../dados/0_dados_originais/'
caminho_arquivo_saida = '../infere/dados/1_dados_regionalizadoss/'

arquivo = "LOA2001.csv"


# Leitura do arquivo CSV
# 2024 está com separador diferente
#df = pd.read_csv(caminho_arquivo + arquivo, sep=";" )

#Demais anos
df = pd.read_csv(caminho_arquivo + arquivo, sep="," , quotechar='"' )

# Descomentar para 2001, 2002
#df = df.rename(columns={'Liquidado (Favorecido)': 'Liquidado'})
#df = df.rename(columns={'Despesa Executada (Subelemento)': 'Despesa Executada'})
df = df.drop(columns=['UG.UF'])
df = df.rename(columns={'CEP': 'UG.UF'})

# Descomentar para 2002_A_2014
df = df.rename(columns={'Liquidado (Favorecido)': 'Liquidado'})
df = df.rename(columns={'Despesa Executada (Favorecido)': 'Despesa Executada'})

#####################################################################################
#                                                                                   *
#  ATENÇÃO COM ESSE FILTRO - PROBLEMA EM ALGUNS ANOS                                *
#                                                                                   *
# Pré-processamentos de GND e UG                                                    *
# Filtro: GND (Cod) == 4 e Despesa Executada (R$) != 0                              *
##########################################################################################################
df_filtrado = df[((df['GND (Cod)']=='4') | (df['GND (Cod)']== 4 )) &
                 (df['Despesa Executada'] != '0') ]#&
                 #(df['UG (Cod/Desc)'] != 'NÃO APLICÁVEL - NÃO APLICÁVEL') &
                 #(df['Sub-elemento Despesa (Cod/Desc)'] != 'NÃO APLICÁVEL - NÃO APLICÁVEL')]

# Descomentar para 2015
#df_filtrado['Localidade.UF'] = df_filtrado['UF']
#df_filtrado['UG.UF'] = df_filtrado['CEP']

# Descomentar para 2011
#df_filtrado = df_filtrado.drop(columns=['UG.UF'])
#df_filtrado['UG.UF'] = df_filtrado['CEP']
#df_filtrado = df_filtrado.drop(columns=['CEP'])

# Descomentar para 2023
'''
if arquivo == "LOA2023.csv":
    df_filtrado['Dotação Inicial'] = df['Dotação Inicial'].str.replace(",", "", regex=False).astype(float)
    df_filtrado['Autorizado'] = df['Autorizado'].astype(str).str.replace(",", "", regex=False).astype(float)
    df_filtrado['Empenhado'] = df['Empenhado'].astype(str).str.replace(",", "", regex=False).astype(float)
    df_filtrado['Despesa Executada'] = df['Despesa Executada'].str.replace(",", "", regex=False).astype(float)
    df_filtrado['Pago'] = df['Pago'].str.replace(",", "", regex=False).astype(float)
    df_filtrado['RP Pago'] = df['RP Pago'].str.replace(",", "", regex=False).astype(float)
'''

#+--------------------
#| Ajuste de colunas para os dados que vem da LOA
#+--------------------
df_filtrado['elemento_desp_cod'] = df_filtrado['Elemento Despesa (Cod/Desc)'].str.split('-').str[0]
df_filtrado['sub_elemento_cod'] = df_filtrado['Mod. Aplic. (Cod/Desc)'].str.split('-').str[0]
df_filtrado['sub_elemento_cod_uf'] = df_filtrado['Sub-elemento Despesa (Cod/Desc)'].astype(str).str[6:8]
df_filtrado['acao_cod'] = df_filtrado['Ação (Cod/Desc)  (Ajustada)'].str.split('-').str[0]
df_filtrado['acao_desc'] = df_filtrado['Ação (Cod/Desc)  (Ajustada)'].str.split('-').str[1]
df_filtrado['subtitulo_desc'] = df_filtrado['Subtítulo (Cod/Desc)'].str.split('-').str[1]
df_filtrado['uo_desc'] = df_filtrado['UO (Cod/Desc) (Ajustado)'].str.split('-').str[1]
df_filtrado['ug_cod'] = df_filtrado['UG (Cod/Desc)'].str.split('-').str[0]
df_filtrado['ug_desc'] = df_filtrado['UG (Cod/Desc)'].str.split('-').str[1]
df_filtrado['prog_cod'] = df_filtrado['Programa (Cod/Desc)'].str.split('-').str[0]

#Remove os espaços
df_filtrado['elemento_desp_cod'] = df_filtrado['elemento_desp_cod'].str.strip() 
df_filtrado['acao_cod'] = df_filtrado['acao_cod'].str.strip() 
df_filtrado['acao_desc'] = df_filtrado['acao_desc'].str.strip() 
df_filtrado['sub_elemento_cod'] = df_filtrado['sub_elemento_cod'].str.strip() 
df_filtrado['sub_elemento_cod_uf'] = df_filtrado['sub_elemento_cod_uf'].str.strip()
df_filtrado['subtitulo_desc'] = df_filtrado['subtitulo_desc'].str.strip() 
df_filtrado['uo_desc'] = df_filtrado['uo_desc'].str.strip() 
df_filtrado['ug_cod'] = df_filtrado['ug_cod'].str.strip()
df_filtrado['ug_desc'] = df_filtrado['ug_desc'].str.strip() 
df_filtrado['prog_cod'] = df_filtrado['prog_cod'].str.strip()

#df_filtrado['Despesa Executada (mil)'] = pd.to_numeric(df_filtrado['Despesa Executada'], errors='coerce')
#df_filtrado['Despesa Executada (mil)'] = df_filtrado['Despesa Executada (mil)']/1000000

## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 
##
##   PROCESSO DE REGIONALIZACAO EM PASSOS
##
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 

# Remove informação invalida no campo localidade UF/ Região antes de remover o DF
df_filtrado = substituir_dados_coluna_por_nd(df_filtrado,'Localidade.UF','NÃO INFORMADO')
df_filtrado = substituir_dados_coluna_por_nd(df_filtrado,'Região','NÃO INFORMADO')
df_filtrado['Localidade.UF.Tmp'] = df_filtrado['Localidade.UF']

# Remove regionalização do DF
df_filtrado = substituir_dados_coluna_por_nd(df_filtrado,'Localidade.UF.Tmp','DF')

#+-------------------
#| Descomentar para 2011 se utilizar a coluna com estados (DF, ES, RJ, SP...)
#+-------------------
# df_filtrado = substituir_df_por_nd(df_filtrado,'UG.UF')

# PASSO 1) USANDO AS VARIAVEIS: Modalidade Aplicação (Cod) e Sub-elemento Despesa (Cod) 
# # Aplica ao DataFrame e grava na coluna UF_IPEA01
df_filtrado['UF_IPEA01'] = df_filtrado.apply(mapear_uf, axis=1)
#df_filtrado['UF_IPEA01'] = df.apply(lambda row: mapear_uf, axis=1)

# PASSO 2)
# Cria nova coluna UF_IPEA02 e tenta regionalizar por parte que contenham estados pelo metódo - identificar_estado
df_filtrado['UF_IPEA02'] = df_filtrado.apply(identificar_estado_por_sub_elemento, axis=1)

# PASSO 3) Busca casos específicos de regionalização
# Carrega regionalização da UG_COD_DESC

df_filtrado = mapear_valores_por_coluna(df_filtrado,'acao_cod',mapa_acao_ajustada_cod_reg,'UF_IPEA03_01','ND')
df_filtrado = mapear_valores_por_coluna(df_filtrado,'acao_desc',mapa_acao_ajustada_desp,'UF_IPEA03_02','ND')
df_filtrado = mapear_valores_por_coluna(df_filtrado,'uo_desc',mapa_acao_ajustada_desp,'UF_IPEA03_03','ND')
df_filtrado = mapear_valores_por_coluna(df_filtrado,'subtitulo_desc',mapa_acao_ajustada_desp,'UF_IPEA03_04','ND')
df_filtrado = mapear_valores_por_coluna(df_filtrado,'elemento_desp_cod',mapa_elemento_cod_reg,'UF_IPEA03_05','ND')
df_filtrado = mapear_valores_por_coluna(df_filtrado,'prog_cod',mapa_prog_cod_reg,'UF_IPEA03_06','ND')
df_filtrado['UF_IPEA03_07'] = df_filtrado.apply(identificar_estado_por_subtitulo_desc, axis=1)

colunas_prioritarias = ['UF_IPEA03_01', 'UF_IPEA03_02','UF_IPEA03_03',
                        'UF_IPEA03_04', 'UF_IPEA03_05','UF_IPEA03_06','UF_IPEA03_07']
df_filtrado = merge_colunas_prioritarias(df_filtrado, colunas_prioritarias, 'UF_IPEA03','ND')

# PASSO 4) USANDO A VARIAVEL
# `UG (Cod/Desc)`
# Utilizando uma logica de CEP (Codigo de Enderecamento Postal)
# um sistema de codigos que visa racionalizar o processo de encaminhamento e entrega
# de correspondencias atraves da divisao do pais em regioes postais

# Cada algarismo do CEP possui um significado. 
# Da esquerda para a direita, os numeros indicam a regiao, sub-regiao, setor,
# sub-setor, divisor de sub-setor e identificadores de distribuicao (tres ultimos algarismos).
# O Brasil e dividido em dez regioes postais, que compoem o primeiro dos numeros do CEP:
#     
# Regiao 0 - Grande Sao Paulo;
# Regiao 1 - Interior de Sao Paulo;
# Regiao 2 - Rio de Janeiro e Espirito Santo;
# Regiao 3 - Minas Gerais;
# Regiao 4 - Bahia e Sergipe;
# Regiao 5 - Pernambuco, Alagoas, Paraiba e Rio Grande do Norte;
# Regiao 6 - Ceara, Piaui, Maranhao, Para, Amazonas, Acre, Amapa e Roraima;
# Regiao 7 - Distrito Federal, Goias, Tocantins, Mato Grosso, Mato Grosso do Sul e Rondonia;
# Regiao 8 - Parana e Santa Catarina;
# Regiao 9 - Rio Grande do Sul.

# Extrair cod.ug e cod.ug1
df_filtrado['cod.ug'] = df_filtrado['UG (Cod/Desc)'].str[:7].astype(float)
df_filtrado['cod.ug1'] = df_filtrado['UG (Cod/Desc)'].str[:4].astype(float)

# Cria colunas e certifica se UG.UF, cod.ug e cod.ug1 sejam numéricos
df_filtrado['UG.UF'] = pd.to_numeric(df_filtrado['UG.UF'], errors='coerce')
df_filtrado['cod.ug'] = pd.to_numeric(df_filtrado['cod.ug'], errors='coerce')
df_filtrado['cod.ug1'] = pd.to_numeric(df_filtrado['cod.ug1'], errors='coerce')

# Aplicar a função e criar nova coluna
df_filtrado['UF_IPEA04'] = df_filtrado['UG.UF'].apply(mapear_estado)

# Primeiro critério: substituir Estado para 'EX' quando condições forem verdadeiras
cond1 = (df_filtrado['UG.UF'] > 1) & (df_filtrado['UG.UF'] <= 110011)
cond2 = (df_filtrado['cod.ug'] == 120091) & (df_filtrado['UG.UF'] == 1)
cond3 = (df_filtrado['UG.UF'] > 110111) & (
            (df_filtrado['cod.ug1'] == 2402) | (df_filtrado['cod.ug1'] == 2400)
        )

df_filtrado.loc[cond1 | cond2 | cond3, 'UF_IPEA04'] = 'EX'

# Segundo critério: se não for 'EX', marcar como 'SP'
cond4 = (df_filtrado['UG.UF'] > 1) & (df_filtrado['UG.UF'] <= 9999999) & (df_filtrado['UF_IPEA04'] != 'EX')
df_filtrado.loc[cond4, 'UF_IPEA04'] = 'SP'

df_filtrado = substituir_dados_coluna_por_nd(df_filtrado,'UF_IPEA04','DF')

# PASSO 5) Utiliza Ug Descrição
# Cria nova coluna UF_IPEA05 e tenta regionalizar por parte que contenham estados 

#print(mapa_ug_cod_uf)
#df_filtrado = mapear_valores_por_coluna(df_filtrado,'ug_cod',mapa_ug_cod_uf,'UF_IPEA05','ND')
df_filtrado['UF_IPEA05'] = df_filtrado.apply(identificar_uf_por_ug_desc, axis=1)
df_filtrado = substituir_dados_coluna_por_nd(df_filtrado,'UF_IPEA05','DF')

#-> Era assim o passo na regionalização feita em 2025
#df_filtrado['UF_IPEA05'] = df_filtrado.apply(identificar_estado_por_ug_desc, axis=1)

# PASSO 6) Unifica colunas de regionalização
colunas_prioritarias = ['UF_IPEA01', 'UF_IPEA02', 'UF_IPEA03','UF_IPEA04','UF_IPEA05','Localidade.UF.Tmp']
df_filtrado = merge_colunas_prioritarias(df_filtrado, colunas_prioritarias, 'UF_FINAL','ND')

# PASSO 7 ) 
# Cria a coluna de regiões com base nas localidade s
df_filtrado['REGIAO_IPEA'] = df_filtrado['UF_FINAL'].apply(obter_regiao_nome)

# Visualização de exemplo
print(df_filtrado[['Localidade.UF.Tmp','UF_FINAL','REGIAO_IPEA']].head(10))

#Remove colunas desnecessárias
#df_filtrado = df_filtrado.drop(columns=['UF_IPEA03_01', 'UF_IPEA03_02','UF_IPEA03_03',
#                                        'sub_elemento_cod','acao_cod','acao_desc','Pago','RP Pago',
#                                        'subtitulo_desc','uo_desc','sub_elemento_cod_uf',
#                                        'cod.ug','cod.ug1','Localidade.UF.Tmp'])

df_filtrado = df_filtrado.drop(columns=['UF_IPEA03_01', 'UF_IPEA03_02','UF_IPEA03_03',
                                        'UF_IPEA03_04','UF_IPEA03_05',
                                        'UF_IPEA03_06','UF_IPEA03_07',
                                        'Pago','RP Pago','sub_elemento_cod',
                                        'acao_desc','subtitulo_desc', 'ug_desc',
                                        'elemento_desp_cod','prog_cod',
                                        'uo_desc','sub_elemento_cod_uf',
                                        'Localidade.UF.Tmp','cod.ug','cod.ug1'])

# (Opcional) Salvar resultado
#df_filtrado.to_csv('NOVA_LOA_2020_final_com_regiao.csv', index=False)
df_filtrado.to_csv(caminho_arquivo_saida + arquivo +'_final_com_regiao.csv', index=False , sep="," , quotechar='"')
#df_filtrado.to_excel(caminho_arquivo_saida + arquivo +'_final_com_regiao.xlsx', index=False)