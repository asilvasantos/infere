# 🔬 INFERE  
### Um microscópio sobre o orçamento público brasileiro

📊 Plataforma de análise e regionalização de investimentos federais  
📍 Aumentando a qualidade da informação de 45% → 85%  

---

![status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![python](https://img.shields.io/badge/Python-3.10-blue)
![r](https://img.shields.io/badge/R-Analytics-blue)
![powerbi](https://img.shields.io/badge/PowerBI-dashboard-yellow)

---
## 🧠 Sobre o Projeto

O **INFERE** é uma plataforma de Business Intelligence que melhora a qualidade dos dados de investimento público no Brasil.

💡 Problema:
- Apenas ~45% dos investimentos possuem localização definida

✅ Solução:
- Algoritmo de inferência e reclassificação de dados
- Regionalização ampliada para ~85%

📈 Impacto:
- Melhor análise territorial
- Apoio à tomada de decisão pública
- Aumento da transparência

👥 Autores

- **Nelson Zackseski**    
  Técnico de Planejamento e Pesquisa – Dirur/Ipea  
  📧 nelson.zackseski@ipea.gov.br

- **Alexandre Silva dos Santos**  
  Bolsista do PNPD – Diretoria de Estudos e Políticas Regionais, Urbanas e Ambientais (Dirur/Ipea)  
  📧 alexandresantoscompunb@gmail.com  

- **Bruno de Oliveira Cruz**  
  Técnico de Planejamento e Pesquisa e Coordenador de Desenvolvimento Regional – Dirur/Ipea  
  📧 bruno.cruz@ipea.gov.br  

---
## ⚙️ Pipeline do Sistema

O INFERE segue as seguintes etapas:

1️⃣ Extração de dados (SIGA Brasil / SIAFI)  
2️⃣ Tratamento e padronização  
3️⃣ Aplicação do algoritmo de regionalização  
4️⃣ Enriquecimento dos dados  
5️⃣ Armazenamento  
6️⃣ Visualização em dashboard (Power BI)  

---

### 🔎 Algoritmo de Inferência

O processo de reclassificação ocorre em 5 níveis:

- 🗺️ UF do empenho  
- 🔤 Mineração de texto  
- 🧾 Subelemento de despesa  
- 🌐 Dados externos  
- 🏢 Unidade gestora  

---

## 📊 Resultados

- 📈 Regionalização: **45% → 85%**
- 🧭 Melhor identificação territorial dos investimentos
- 💰 Correção de subestimações regionais
- 📚 Série histórica: 2000–2025

### Exemplos:
- Nordeste: +R$ 14 bilhões identificados
- Educação: 38,7% → 94,5% de regionalização

---

## 🛠️ Tecnologias

- 🐍 Python
- 📊 R
- 📈 Power BI
- 🗄️ SIGA Brasil / SIAFI
- 🧠 Business Intelligence

---

## 📂 Estrutura do projeto

```bash
infere/
├── dados/
├── dashboard/
├── scripts/
├── documentos/
└── README.md
```
## ▶️ Como Executar

Siga os passos abaixo para processar os dados do INFERE:

### 1️⃣ Obter o repositório

Clone ou faça o download do projeto:

```bash
git clone https://github.com/seu-usuario/infere.git
cd infere
```

### 2️⃣ Preparar os dados

Acesse a pasta:
```bash
cd data/0_dados_originais/
```
📦 Descompacte todos os arquivos disponíveis nessa pasta
⚠️ Esse passo é obrigatório para que o processamento funcione corretamente

### 3️⃣ Executar o processamento

Acesse a pasta:
```bash
cd scripts/python/
```

Execute o arquivo:
```bash
processa_todos_os_anos_loa.bat
```
### 🔄 O que acontece durante a execução?

O script irá automaticamente:

- 📥 Ler todos os anos disponíveis em 0_dados_originais
- 🧠 Aplicar o algoritmo de regionalização
- 📂 Gerar os dados processados em:
1_dados_regionalizados/
- 📊 Consolidar os dados finais em:
2_dados_empilhados/

### ✅ Resultado final

Ao final da execução, você terá:

- Dados regionalizados por ano
- Base consolidada pronta para análise e visualização 
