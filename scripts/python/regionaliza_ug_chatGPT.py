#+-------------------------------------------------------+
#|Projeto: INFERE                                        |
#|Autor: Alexandre Silva dos Santos                      |
#|Descrição: Script de processamento de enriquecimento de|
#|           dados com base na UG_COD_DESC.              | 
#|Data começo: 19/01/2026                                |
#|Data fim: 21/01/2026                                   |
#+-------------------------------------------------------+

import pandas as pd
import json
import re
import time
from openai import OpenAI

# =========================
# CONFIGURAÇÃO
# =========================
#API_KEY ="token do chatgpt"

INPUT_CSV = "ug_cod_desc_bruto.csv"
OUTPUT_CSV = "ugs_com_regionalizacao_final_enriquecido.csv"

client = OpenAI(api_key=API_KEY)

# =========================
# FUNÇÕES AUXILIARES
# =========================
def parse_resposta_llm(texto):
    """
    Tenta extrair UF e REGIAO de forma tolerante.
    Nunca quebra o script.
    """
    # 1) tenta JSON direto
    try:
        return json.loads(texto)
    except:
        pass

    # 2) tenta extrair JSON dentro do texto
    try:
        match = re.search(r"\{.*\}", texto, re.DOTALL)
        if match:
            return json.loads(match.group())
    except:
        pass

    # 3) fallback seguro
    return {"UF": "INDETERMINADO", "REGIAO": "INDETERMINADA"}


def inferir_uf_regiao(ug_desc):
    prompt = f"""
Você é especialista em administração pública brasileira.

Informe a UF e a região da seguinte Unidade Gestora:

{ug_desc}

Responda EXCLUSIVAMENTE em JSON válido, sem qualquer texto extra:
{{"UF":"XX","REGIAO":"YYY"}}
"""

    response = client.chat.completions.create(
        model="gpt-4.1-mini",
        messages=[{"role": "user", "content": prompt}],
        temperature=0
    )

    texto = response.choices[0].message.content.strip()
    return parse_resposta_llm(texto)

# =========================
# PROCESSAMENTO
# =========================
df = pd.read_csv(INPUT_CSV)

# cria colunas se não existirem
if "REGIAO" not in df.columns:
    df["REGIAO"] = ""

if "FONTE_REGIONALIZACAO" not in df.columns:
    df["FONTE_REGIONALIZACAO"] = ""

for idx, row in df.iterrows():
    uf_atual = str(row.get("UF", "")).strip()

    if uf_atual == "" or uf_atual.upper() == "NAN":
        ug_desc = row["UG_COD_DESC"]

        try:
            resultado = inferir_uf_regiao(ug_desc)

            df.at[idx, "UF"] = resultado["UF"]
            df.at[idx, "REGIAO"] = resultado["REGIAO"]
            df.at[idx, "FONTE_REGIONALIZACAO"] = "LLM"

            print(f"✔ {ug_desc} → {resultado}")

            time.sleep(1.2)  # evita rate limit

        except Exception as e:
            print(f"✖ Erro em {ug_desc}: {e}")

# =========================
# SALVA RESULTADO
# =========================
df.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")

print("\nArquivo final gerado:", OUTPUT_CSV)
