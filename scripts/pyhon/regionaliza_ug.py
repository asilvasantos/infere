import pandas as pd
import numpy as np

# ============================================================
# CONFIGURAÇÕES
# ============================================================

ARQUIVO_ENTRADA = "lista de ugs.csv"
ARQUIVO_SAIDA = "ugs_com_regionalizacao.csv"
SEPARADOR = ";"
ENCODING = "utf-8-sig"

# ============================================================
# LEITURA DO ARQUIVO
# ============================================================

df = pd.read_csv(ARQUIVO_ENTRADA)
df.columns = ["UG_RAW"]

# ============================================================
# TRATAMENTO DA UG (código e descrição)
# ============================================================

df["UG_COD"] = df["UG_RAW"].str.extract(r"^(\d+)")
df["UG_DESC"] = df["UG_RAW"].str.replace(
    r"^\d+\s*-\s*", "", regex=True
)

# ============================================================
# DICIONÁRIO DE ESTADOS (UF)
# ============================================================

UF_MAP = {
    "ACRE": "AC",
    "ALAGOAS": "AL",
    "AMAPA": "AP",
    "AMAZONAS": "AM",
    "BAHIA": "BA",
    "CEARA": "CE",
    "DISTRITO FEDERAL": "DF",
    "ESPIRITO SANTO": "ES",
    "GOIAS": "GO",
    "MARANHAO": "MA",
    "MATO GROSSO DO SUL": "MS",
    "MATO GROSSO": "MT",
    "MINAS GERAIS": "MG",
    "PARA": "PA",
    "PARAIBA": "PB",
    "PARANA": "PR",
    "PERNAMBUCO": "PE",
    "PIAUI": "PI",
    "RIO DE JANEIRO": "RJ",
    "RIO GRANDE DO NORTE": "RN",
    "RIO GRANDE DO SUL": "RS",
    "RONDONIA": "RO",
    "RORAIMA": "RR",
    "SANTA CATARINA": "SC",
    "SAO PAULO": "SP",
    "SERGIPE": "SE",
    "TOCANTINS": "TO"
}

# ============================================================
# FUNÇÃO DE INFERÊNCIA DE UF
# ============================================================

def inferir_uf(descricao):
    if pd.isna(descricao):
        return None

    desc = descricao.upper()
    for nome_estado, sigla in UF_MAP.items():
        if nome_estado in desc:
            return sigla
    return None

# ============================================================
# APLICAÇÃO DAS REGRAS
# ============================================================

df["UF"] = df["UG_DESC"].apply(inferir_uf)

df["TIPO_UG"] = np.where(
    df["UF"].isna(),
    "NACIONAL",
    "ESTADUAL"
)

df["REGIONALIZAVEL"] = np.where(
    df["TIPO_UG"] == "ESTADUAL",
    "SIM",
    "NAO"
)

# ============================================================
# AJUSTES FINAIS
# ============================================================

df_final = df[[
    "UG_COD",
    "UG_DESC",
    "UF",
    "TIPO_UG",
    "REGIONALIZAVEL"
]]

# Remove duplicidades por UG
df_final = df_final.drop_duplicates(subset=["UG_COD"])

# ============================================================
# GRAVAÇÃO DO CSV FINAL
# ============================================================

df_final.to_csv(
    ARQUIVO_SAIDA,
    index=False,
    sep=SEPARADOR,
    encoding=ENCODING
)

print("Arquivo gerado com sucesso:", ARQUIVO_SAIDA)
