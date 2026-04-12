#+-------------------------------------------------------+
#|Projeto: INFERE                                        |
#|Autor: Alexandre Santos                                |
#|Descrição: Script de processamento da regionalização   |
#|           dos dados da LOA ou SIGA Brasil.            | 
#|Data começo: 01/05/2025                                |
#|Data fim: 21/01/2026                                   |
#+-------------------------------------------------------+

import pandas as pd
import csv
import os

# Pega o diretório atual
dir_base = os.getcwd()

caminho_ug_cod_uf =  os.path.join(dir_base ,'dados_proc','ugs_com_regionalizacao_final_enriquecido.csv')
caminho_ug_cod_uf = caminho_ug_cod_uf.replace('\\','/')

# Dicionário de estados por região
mapa_regioes = {
    'Norte': ['AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO','NO'],
    'Nordeste': ['AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE','NE'],
    'Centro-Oeste': ['DF', 'GO', 'MT', 'MS', 'CO'],
    'Sudeste': ['ES', 'MG', 'RJ', 'SP','SD'],
    'Sul': ['PR', 'RS', 'SC','SL'],
    'Exterior': ['EX']
}

# Lista de estados brasileiros
estados = [
    'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal', 'Espírito Santo',
    'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 'Minas Gerais', 'Pará', 'Paraíba',
    'Paraná', 'Pernambuco', 'Piauí', 'Rio de Janeiro', 'Rio Grande do Norte', 'Rio Grande do Sul',
    'Rondônia', 'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe', 'Tocantins','Brasília'
]

# Mapeamento de estados brasileiros e suas siglas e outros casos
mapeamento_estados = {
    'ACRE': 'AC', 'ALAGOAS': 'AL', 'AMAPA': 'AP', 'AMAPÁ': 'AP', 'AMAZONAS': 'AM', 'BAHIA': 'BA',
    'CEARA': 'CE', 'CEARÁ': 'CE', 'DISTRITO FEDERAL': 'DF', 'BRASÍLIA': 'DF','ESPIRITO SANTO': 'ES', 'ESPÍRITO SANTO': 'ES',
    'GOIAS': 'GO', 'GOIÁS': 'GO', 'MARANHAO': 'MA', 'MARANHÃO': 'MA', 'MATO GROSSO': 'MT',
    'MATO GROSSO DO SUL': 'MS', 'MINAS GERAIS': 'MG', 'PARÁ': 'PA', 'PARAIBA': 'PB',
    'PARAÍBA': 'PB', 'PARANA': 'PR', 'PARANÁ': 'PR', 'PERNAMBUCO': 'PE', 'PIAUI': 'PI', 'PIAUÍ': 'PI',
    'RIO DE JANEIRO': 'RJ', 'RIO GRANDE DO NORTE': 'RN', 'RIO GRANDE DO SUL': 'RS', 'RONDONIA': 'RO',
    'RONDÔNIA': 'RO', 'RORAIMA': 'RR', 'SANTA CATARINA': 'SC', 'SAO PAULO': 'SP', 'SÃO PAULO': 'SP',
    'SERGIPE': 'SE', 'TOCANTINS': 'TO', 'BELO HORIZONTE': 'MG', 
    #Outros casos
    "NO EXTERIOR": 'EX',"NA EUROPA":'EX','EM WASHINGTON':'EX',
    'EXERCITO DE BRASILIA':'DF', 'ESTADO DE RO':'RO','ARTILHARIA DE CAMPANHA (ES)':'ES',
    'IPHAN NO RIO G. NORTE/RN':'RN', 'NORTE DE MG':'MG','REGIAO AMAZONICA':'AM', 
    'SUPERINTENDENCIA REG. NO ESTADO PE':'PE','OFICIAIS DA RESERVA DE BH':'MG',
    'TEC.DO NORTE DE MG':'MG', 'BASE AEREA DE BELEM':'PA','HOSPITAL GERAL DE CURITIBA':'PR',
    'BASE AEREA DE SANTA MARIA':'RS',
    'SUPERINTENDÊNCIA DE ADMINISTRAÇÃO DO MF/SC':'SC'
}

# Mapeamento de strings no campo acao ajustada desp
mapa_acao_ajustada_desp = {
    'TECNOLOGIA NUCLEAR DA MARINHA':'RJ', 
    'IMPLANTAÇÃO DE ESTALEIRO E BASE NAVAL PARA CONSTRUÇÃO E MANUTENÇÃO DE SUBMARINOS CONVENCIONAIS E NUCLEARES':'RJ',
    'CONSTRUÇÃO DE SUBMARINO DE PROPULSÃO NUCLEAR':'RJ',
    'APOIO À REALIZAÇÃO DE GRANDES EVENTOS':'RJ',
    'CONSTRUÇÃO DE SUBMARINOS CONVENCIONAIS':'RJ',
    'APRESTAMENTO DA MARINHA':'RJ',
    'MELHORAMENTOS NO CANAL DE NAVEGAÇÃO DA HIDROVIA DOS RIOS PARANÁ E PARAGUAI':'CO',
    'DESENVOLVIMENTO TECNOLÓGICO DA MARINHA':'RJ',
    'CAPACITAÇÃO PROFISSIONAL DA MARINHA':'RJ',
    'OPERACIONALIZACAO DAS ACOES DE SEGURANCA PUBLICA PARA AS OLIMPIADAS E PARAOLIMPIADAS RIO 2016':'RJ',
    'DESENVOLVIMENTO E IMPLEMENTAÇÃO DO SISTEMA DE GERENCIAMENTO DA AMAZÔNIA AZUL (SISGAAZ)':'NO',
    'MANUTENÇÃO DO SISTEMA DE PROTEÇÃO DA AMAZÔNIA':'NO',
    'PARTICIPAÇÃO BRASILEIRA EM MISSÕES DE PAZ':'EX',
    'IMUNOBIOLÓGICOS E INSUMOS PARA PREVENÇÃO E CONTROLE DE DOENÇAS':'EX',
    'APOIO LOGÍSTICO À PESQUISA CIENTÍFICA NA ANTÁRTICA':'EX',
    'RIO SÃO FRANCISCO':'NE',
    'LONDRES':'EX',
    'EXTERIOR': 'EX',
    'OBTENÇÃO DE MEIOS DA MARINHA': 'EX',
    'SUPERINTENDÊNCIA DA ZONA FRANCA DE MANAUS':'AM',
    'COMPANHIA DE DESENVOLVIMENTO DOS VALES DO SÃO FRANCISCO E DO PARNAÍBA':'NE',
    'MATOPIBA':'NE',
    'EMBAIXADA':'EX',
    'CONSULADO':'EX',
    'DELEGACAO':'EX'
 }

mapa_acao_ajustada_cod_reg = {
    '116X':'TO',
    '123H':'RJ',
    '2D55':'EX',
    '2B42':'EX',
    '2367':'EX',
    '20TU':'EX'
}

mapa_elemento_cod_reg = {
    '33':'EX'
}

mapa_prog_cod_reg = {
    '2057':'EX',
    '2118':'EX'
}

# Função para determinar a região com base em UF DESP ou pela linha
def obter_regiao_IPEA(linha):
    uf = str(linha.get('Localidade.UF', '')).strip()
    
    # Usa diretamente se UF DESP estiver preenchido
    if uf and uf != '-' or uf != 'NA':
        return uf  

    # Caso contrário, tenta detectar o estado nas colunas
    for valor in linha:
        if isinstance(valor, str):
            for estado in estados:
                if estado in valor:
                    return estado
    return None

# Função para buscar qualquer valor correspondente, independentemente de caixa
def identificar_estado_por_sub_elemento(row):
    uf = str(row.get('Localidade.UF.Tmp', '')).strip()
    valor = str(row.get('Sub-elemento Despesa (Cod/Desc)', ''))
    # Usa diretamente se UF DESP estiver preenchido
    if  uf == '-' or uf == 'nan' or uf == 'NA' or uf == 'ND' or uf == 'NaN':
        if isinstance(valor, str):
            texto_maiusculo = valor.upper()
            for nome, sigla in mapeamento_estados.items():
                #if (nome in texto_maiusculo) or (sigla in texto_maiusculo):
                if nome in texto_maiusculo:
                    return sigla
        return 'ND'
    else:
        return uf  

# Função para buscar qualquer valor correspondente, independentemente de caixa
def identificar_estado_por_ug_desc(row):
    uf = str(row.get('Localidade.UF.Tmp', '')).strip()
    valor = str(row.get('ug_desc', ''))
    # Usa diretamente se UF DESP estiver preenchido
    if  uf == '-' or uf == 'nan' or uf == 'NA' or uf == 'ND' or uf == 'NaN':
        if isinstance(valor, str):
            texto_maiusculo = valor.upper()
            for nome, sigla in mapeamento_estados.items():
                #if (nome in texto_maiusculo) or (sigla in texto_maiusculo):
                if nome in texto_maiusculo:
                    return sigla
        return 'ND'
    else:
        return uf  

# mapeamento ug cod - estado
def carregar_mapa_ug_cod_uf(caminho_csv):
    mapa_ug_cod_uf = {}

    with open(caminho_csv, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for linha in reader:
            ug_cod = linha['UG_COD'].strip()
            uf = linha['UF'].strip()

            if ug_cod and uf:
                mapa_ug_cod_uf[ug_cod] = uf

    return mapa_ug_cod_uf

mapa_ug_cod_uf = carregar_mapa_ug_cod_uf(caminho_ug_cod_uf)

# Função para buscar qualquer valor correspondente, independentemente de caixa
def identificar_uf_por_ug_desc(row):
    uf = str(row.get('Localidade.UF.Tmp', '')).strip()
    valor = str(row.get('UG (Cod/Desc)', ''))
    ug_cod_desc = valor.split('-')
    # Usa diretamente se UF DESP estiver preenchido
    if  uf == '-' or uf == 'nan' or uf == 'NA' or uf == 'ND' or uf == 'NaN':
        if isinstance(valor, str):
            for cod, uf_ug in mapa_ug_cod_uf.items():
                if int(cod) == int(ug_cod_desc[0]):
                    return uf_ug
        return 'ND'
    else:
        return uf  

# Função para buscar qualquer valor correspondente, independentemente de caixa
def identificar_estado_por_subtitulo_desc(row):
    uf = str(row.get('Localidade.UF.Tmp', '')).strip()
    valor = str(row.get('Subtítulo (Cod/Desc)', ''))
    # Usa diretamente se UF DESP estiver preenchido
    if  uf == '-' or uf == 'nan' or uf == 'NA' or uf == 'ND' or uf == 'NaN':
        if isinstance(valor, str):
            texto_maiusculo = valor.upper()
            for nome, sigla in mapeamento_estados.items():
                #if (nome in texto_maiusculo) or (sigla in texto_maiusculo):
                if nome in texto_maiusculo:
                    return sigla
        return 'ND'
    else:
        return uf  


# Função para mapear sigla de estado para nome da região
def obter_regiao_nome(uf):
    for regiao, estados in mapa_regioes.items():
        if uf in estados:
            return regiao
    return 'ND'  # Não definido

# Função para substituir dados de uma coluna por por ND
#def substituir_df_por_nd(df, coluna):
#    df.loc[df[coluna] == 'DF', coluna] = 'ND'
#    return df

# Função para substituir dados de uma coluna por por ND
def substituir_dados_coluna_por_nd(df, coluna, dado_substituir ):
    df.loc[df[coluna] == dado_substituir, coluna] = 'ND'
    return df

# Função para mapear para UF com base nas regras
def mapear_uf(row):
    cod = row['sub_elemento_cod']
    uf_cod = row['sub_elemento_cod_uf']
    
    if cod.isdigit() and uf_cod.isdigit():
        cod = int(cod)
        uf_cod = int(uf_cod )
    else:
        return 'ND'

    if 30 <= cod <= 49:
        mapeamento = {
            1: "AC", 3: "AL", 5: "AM", 2: "AM", 4: "AP", 7: "BA", 9: "CE", 11: "DF",
            21: "MS", 19: "MT", 39: "RS", 47: "SE", 15: "GO", 33: "PI", 27: "PB",
            25: "PA", 29: "PR", 42: "RR", 23: "MG", 22: "MG", 35: "RJ", 37: "RN",
            45: "SP", 43: "SC", 13: "ES", 31: "PE", 48: "TO", 17: "MA", 41: "RO"
        }
        return mapeamento.get(int(uf_cod), 'ND')
    else:
        return 'ND'


def mapear_valores_por_coluna(df, coluna, mapa, nova_coluna, valor_padrao):
    """
    Mapeia os valores da coluna especificada com base em um dicionário e salva em nova coluna.
    
    Parâmetros:
        df (DataFrame): o DataFrame a ser processado.
        coluna (str): nome da coluna a ser verificada.
        mapa (dict): dicionário de mapeamento (chave = valor a buscar, valor = valor a atribuir).
        nova_coluna (str): nome da nova coluna que receberá os valores mapeados.
        valor_padrao: valor a ser usado caso o valor não esteja no dicionário (padrão: None).
        
    Retorna:
        DataFrame com nova coluna mapeada.
    """
    df[nova_coluna] = df[coluna].map(mapa).fillna(valor_padrao)
    return df


def merge_colunas_prioritarias(df, colunas, nova_coluna, valor_nulo):
    """
    Mescla N colunas mantendo o primeiro valor diferente de 'ND' em ordem de prioridade.

    Parâmetros:
        df (DataFrame): o DataFrame original.
        colunas (list): lista com os nomes das colunas a serem mescladas.
        nova_coluna (str): nome da nova coluna de saída.
        valor_nulo (str): valor que será considerado como "nulo" ou "vazio lógico", ex: 'ND'.

    Retorna:
        DataFrame com a nova coluna criada.
    """
    def selecionar_valor_prioritario(linha):
        for col in colunas:
            valor = linha[col]
            if pd.notna(valor) and valor != valor_nulo:
                return valor
        return valor_nulo

    df[nova_coluna] = df.apply(selecionar_valor_prioritario, axis=1)
    return df


# Função para mapear os códigos para estados
def mapear_estado(cod):
    if pd.isna(cod): return 'ND'
    cod = str(int(cod))
    cod2 = int(cod[:2]) if len(cod) >= 2 else -1
    cod3 = int(cod[:3]) if len(cod) >= 3 else -1
    c1 = cod[0]

    if c1 in ['0', '1']:
        return 'SP'
    elif c1 == '3':
        return 'MG'
    elif c1 == '9':
        return 'RS'
    elif cod2 == 29:
        return 'ES'
    elif cod2 == 49:
        return 'SE'
    elif cod2 == 64:
        return 'PI'
    elif cod2 == 65:
        return 'MA'
    elif cod3 == 689:
        return 'AP'
    elif cod3 == 699:
        return 'AC'
    elif cod3 == 693:
        return 'RR'
    elif cod2 == 77:
        return 'TO'
    elif cod2 == 79:
        return 'MS'
    elif cod2 == 78 and cod3 != 789:
        return 'MT'
    elif cod2 == 57:
        return 'AL'
    elif cod2 == 58:
        return 'PB'
    elif cod2 == 59:
        return 'RN'
    elif 20 <= cod2 <= 28:
        return 'RJ'
    elif 40 <= cod2 <= 48:
        return 'BA'
    elif 80 <= cod2 <= 87:
        return 'PR'
    elif 88 <= cod2 <= 89:
        return 'SC'
    elif 50 <= cod2 <= 56:
        return 'PE'
    elif 60 <= cod2 <= 63:
        return 'CE'
    elif 66 <= cod2 <= 68:
        return 'PA'
    elif 690 <= cod3 <= 692 or 694 <= cod3 <= 698:
        return 'AM'
    elif 700 <= cod3 <= 727 or 730 <= cod3 <= 736:
        return 'DF'
    elif 768 <= cod3 <= 769 or cod3 == 789:
        return 'RO'
    elif 728 <= cod3 <= 729 or 737 <= cod3 <= 767:
        return 'GO'
    else:
        return 'ND'

