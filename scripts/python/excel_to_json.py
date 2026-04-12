import pandas as pd

# Caminhos
arquivo_xlsx = "dados_municipios_2022.xlsx"
arquivo_json = "dados_municipios_2022.json"

# Lê o Excel
df = pd.read_excel(arquivo_xlsx)

# Converte para JSON
df.to_json(
    arquivo_json,
    orient="records",
    force_ascii=False,
    indent=2
)

print("Arquivo JSON gerado com sucesso!")
