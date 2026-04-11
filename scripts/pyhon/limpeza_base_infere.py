import pandas as pd

# Caminho do arquivo Excel
arquivo_excel = 'Amostra_atual_corrigido(AL-MA-ND)_em_05jan2024.xlsx'

# Nome da aba (se souber, senão pode deixar como default)
nome_aba = 'Amostra'

# Carregar o arquivo
df = pd.read_excel(arquivo_excel, sheet_name=nome_aba)

# Remover colunas específicas (substitua pelos nomes das colunas que deseja excluir)
# 01- Remoção das colunas:
# Subfunção..Cod.Desc.
# Função..Cod.Desc.
# Programa..Cod.Desc.
# Empenhado_igpdi
# codigo
# nome_funcional

# 02- Renomeada a coluna:
# Região* para Região_IPEA

# 03- Agrupamento da coluna Mod..Aplic...Cod.Desc. na coluna Modalidade_Aplicação respeitando as seguintes regras para os conjuntos de códigos:
# Aplicações diretas: 90 e 91
# Outras transferências: 15, 50, 60, 70 e 80
# Transferências à Municípios: 40, 41 e 42
# Transferências Estados e DF: 30, 31 e 32
colunas_para_remover = ['Subfunção..Cod.Desc.', 'Função..Cod.Desc.','Programa..Cod.Desc.','Empenhado_igpdi','codigo','nome_funcional']
df = df.drop(columns=colunas_para_remover)

# Remover linhas com valor 0 em uma coluna específica
coluna_verificacao = 'Despesa.Executada_igpdi'
df = df[df[coluna_verificacao] != 0]

# (Opcional) Salvar o resultado em um novo Excel
df.to_excel('Amostra_atual_download.xlsx', index=False)

print("Processamento concluído. Arquivo salvo como 'Amostra_atual_download.xlsx'.")
