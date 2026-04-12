import pandas as pd
import re

# Mapeamento de estados para regiões (usei suas siglas)
uf_to_regiao = {
    'AC': 'NO', 'AP': 'NO', 'AM': 'NO', 'PA': 'NO', 'RO': 'NO', 'RR': 'NO', 'TO': 'NO',
    'AL': 'NE', 'BA': 'NE', 'CE': 'NE', 'MA': 'NE', 'PB': 'NE', 'PE': 'NE', 'PI': 'NE', 'RN': 'NE', 'SE': 'NE',
    'ES': 'SD', 'MG': 'SD', 'RJ': 'SD', 'SP': 'SD',
    'PR': 'SL', 'RS': 'SL', 'SC': 'SL',
    'DF': 'CO', 'GO': 'CO', 'MT': 'CO', 'MS': 'CO'
}

# Lista de todas as UFs para busca
ufs = list(uf_to_regiao.keys())

def extrair_reg_uf(desc):
    if pd.isna(desc):
        return ''
    
    # Encontrar todas as siglas de UF no texto (maiúsculas, com ou sem acento/ponto)
    encontradas = set()
    for uf in ufs:
        # Busca flexível: UF isolada ou seguida de / , - etc.
        if re.search(rf'\b{uf}\b|\b{uf}/|\b{uf}-|\b{uf}\s', desc.upper()):
            encontradas.add(uf)
    
    if len(encontradas) == 0:
        # Tenta inferir por cidades conhecidas (exemplos comuns do seu arquivo)
        desc_upper = desc.upper()
        if any(x in desc_upper for x in ['BRASILIA', 'ANAPOLIS', 'GOIANIA']):
            return 'CO'  # ou 'GO'/'DF' se quiser mais preciso
        if any(x in desc_upper for x in ['MANAUS', 'PORTO VELHO', 'BOA VISTA', 'RIO BRANCO', 'MACAPA', 'PALMAS']):
            return 'NO'
        if 'RECIFE' in desc_upper or 'SALVADOR' in desc_upper or 'FORTALEZA' in desc_upper:
            return 'NE'
        if 'SAO PAULO' in desc_upper or 'RIO DE JANEIRO' in desc_upper:
            return 'SD'
        if 'PORTO ALEGRE' in desc_upper or 'CURITIBA' in desc_upper or 'FLORIANOPOLIS' in desc_upper:
            return 'SL'
        return ''  # ou 'ND'
    
    elif len(encontradas) == 1:
        uf = list(encontradas)[0]
        return uf  # retorna a sigla única
    
    else:
        # Mais de uma UF → pega a região (assumindo que são da mesma região; se não, pode ajustar)
        regioes = set(uf_to_regiao[uf] for uf in encontradas)
        if len(regioes) == 1:
            return list(regioes)[0]
        else:
            return 'MULT'  # ou liste as regiões, mas por enquanto marca como múltiplas

# Carregar o CSV (ajuste o caminho/nome do arquivo)
df = pd.read_csv('ugs_sem_regionalizacao.csv', sep=',', encoding='utf-8', on_bad_lines='skip')

# Aplicar a função na coluna UG_DESC
df['REG_UF'] = df['UG_DESC'].apply(extrair_reg_uf)

# Salvar o resultado
df.to_csv('ugs_com_regionalizacao_final.csv', index=False, encoding='utf-8')

print(df[['UG_COD', 'UG_DESC', 'REG_UF']].head(20))  # ver amostra