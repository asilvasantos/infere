#+----------------------------------------------------+
#|Projeto: INFERE                                     |
#|Autor: Alexandre Santos                             |
#|Colaborador: Bruno Gontijo                          |
#|Descrição: Script de empilhamento das tabelas LOA   |
#|Data começo: 26/09/2024                             |
#|Data fim: 04/10/2024                                |
#+----------------------------------------------------+

import pandas as pd

#+-------------------+
#|Leitura das tabelas|
#+-------------------+

#Leitura das tableas LOA de 2002 a 2023, 'sep' define qual o separador foi utilizado nas tabelas, o parâmetro 'index_col=False' faz com que o pandas não use a primeira coluna como índice


#df = pd.read_csv('E:/Alex/Livano/IPEA/ipea-promob/dados_estatísticos/Demanda - Nelson/Trabalho_Atual/INVESTIMENTO_FEDERAL/_dados/0_dados_originais/Relatório 1.csv', sep =",", index_col=False, skiprows=3)
#SIGA_BRASIL_2020
path = 'E:/Alex/Livano/IPEA/ipea-promob/dados_estatísticos/Demanda - Nelson/Trabalho_Atual/INVESTIMENTO_FEDERAL/_dados/0_dados_originais/'
entrada = 'LOA2024.csv'
#df = pd.read_excel(  path +  'SIGA_BRASIL_2020.xlsx', sep =",", index_col=False, skiprows=3)
#df = pd.read_excel(  path +  'SIGA_BRASIL_2020.xlsx', index_col=False, skiprows=3)
df = pd.read_csv(  path +  entrada)

# Substitui células vazias por NA (pandas reconhece como pd.NA)
df.replace(r'^\s*$', pd.NA, regex=True, inplace=True)

print("Leitura de Arquivo - OK")
print(df.columns)

# Filtra as linhas onde a coluna 'GND (Cod)' é igual a 4
#df_filtrado = df[
    #(df['GND (Cod)'] == 4) & 
    #(df['Despesa Executada'] != '0')
df_filtrado = df[df["GND (Cod) DESP"] == '4']

# Salva o resultado em um novo arquivo CSV
arquivo_saida = 'SIGA_BRASIL_2020_Tratado.xlsx'
#caminho = "E:/Alex/Livano/IPEA/ipea-promob/dados_estatísticos/Demanda - Nelson/Trabalho_Atual/INVESTIMENTO_FEDERAL/_dados/0_dados_originais/"
#df_filtrado.to_csv(path + arquivo_saida, index=False, na_rep='NA')
df_filtrado.to_excel(path + arquivo_saida, index=False, na_rep='NA')

print(f'Dados filtrados salvos em: {arquivo_saida}')