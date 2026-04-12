import pandas as pd

# Lê o arquivo Excel
print("Inicia processo de leitura do arquivo")
df = pd.read_excel('Amostra_atual_download.xlsx')  # Altere para o caminho correto

# Separa a coluna 'descricao' no caractere '-'
# Expande em duas novas colunas: 'codigo' e 'descricao_limpa'
print("Processando alterações")
df[['Mod.Aplic.Cod', 'Mod.Aplic.Desc.']] = df['Mod..Aplic...Cod.Desc.'].str.split('-', n=1, expand=True)

# Remove espaços extras
df['Mod.Aplic.Cod'] = df['Mod.Aplic.Cod'].str.strip()
df['Mod.Aplic.Desc.'] = df['Mod.Aplic.Desc.'].str.strip()

# Mapeamento dos códigos para categorias
categorias = {
    '90': 'Aplicações diretas',
    '91': 'Aplicações diretas',
    '15': 'Outras transferências',
    '50': 'Outras transferências',
    '60': 'Outras transferências',
    '70': 'Outras transferências',
    '80': 'Outras transferências',
    '40': 'Transferências à Municípios',
    '41': 'Transferências à Municípios',
    '42': 'Transferências à Municípios',
    '30': 'Transferências Estados e DF',
    '31': 'Transferências Estados e DF',
    '32': 'Transferências Estados e DF',
}

# Extrai os dois primeiros caracteres do código e aplica o mapeamento
df['Mod.Aplic.Desc.Nova'] = df['Mod.Aplic.Cod'].str[:2].map(categorias)

# Se quiser manter os códigos não mapeados com a string original:
df['Mod.Aplic.Desc.Nova'] = df['Mod.Aplic.Desc.Nova'].fillna(df['Mod.Aplic.Cod'])

# Nome da coluna que será separada
coluna_para_separar = 'Ação*'  

# Separa a coluna em duas com base no caractere " - "
df[['cod.Acao', 'descrica.Acao']] = df[coluna_para_separar].str.split(' - ', n=1, expand=True)

# Nome da coluna a ser modificada
coluna = 'Região'

# Substituir valores vazios (NaN ou células em branco) por "NA"
df[coluna] = df[coluna].fillna('NA')

# Renomear colunas: {"nome_atual": "novo_nome", ...}
df = df.rename(columns={
    'Região*': 'Região_IPEA',
    'UF*_novo': 'UF_IPEA'
})

print("Inicia processo de gravação do arquivo")

# Salva no Excel
df.to_excel('Amostra_atual_Mod_Ajustada_download.xlsx', index=False)

print("Processamento concluído. Arquivo salvo como 'Amostra_atual_Mod_Ajustada_download'.")