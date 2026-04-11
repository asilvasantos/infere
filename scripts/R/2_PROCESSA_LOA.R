### --- SCRIPT PROPRIAMENT DITO

# Carrega bibliotecas necessarias para o processamento
library("tidyquant")
library("openxlsx")
library("tidyverse")
library("readxl")
library("Lahman")
library("sqldf")
library("lubridate")
require("data.table")
library("rlang")
library("zoo")
library("anytime")
library("stringr")
library("readxlsb")
library("tidyr")
library("readxl")
library("dplyr")
library("openxlsx")
library("geobr")
library("BETS") 
library("scales")
library(stringi)

# Captura usuario logado / Parametrizacao SO Windows
usuario <- Sys.getenv("USERNAME")

# Notacao cientifica
options(scipen=999)

# Seta diretorio de trabalho
setwd(paste("C:/Users/", usuario, "/Downloads/INVESTIMENTO_FEDERAL/_dados/1_dados_originais_empilhados", sep = ""))


# Leitura da tabela via fread
LOA_FINAL_GND_4 <- fread('LOA_FINAL_GND_4.txt', sep = ';')

# Nota: espera-se uma dataframe de 2.132.584 registros
# com os campos Dotacao incial, Autorizado, Empenhado, Liquidado, 
# Despesa Executada, Pago e RP Pago como classes numericas


# dados espaciais dos municipios brasileiros do pacote geobr
base_referencia <- read_municipality(code_muni = "all", year = 2021) %>% 
  select(-c(geom))

# Seleciona variaveis de interesse
base_estados <- distinct(base_referencia, code_state, abbrev_state, name_state, code_region, name_region)


## Separando localidades/UF nao identificadas na base
LOA_FINAL_GND_4$UF_nova <- ifelse(LOA_FINAL_GND_4$Localidade.UF %in% c("NE","NO","CO","SD","SL"),"ND", LOA_FINAL_GND_4$Localidade.UF)

## Cria pseudo variavel de nova regiao para ser usada em etapas posteriores
LOA_FINAL_GND_4$Reg_nova <- NA

## Quebrando as colunas de Acao, Subtitulo, Mod Aplic, Subelemento

#-- --  Ação (Cod/Desc)  (Ajustada) --- 
# Usando mutate e separando para criar novas colunas 
LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(
        ACAO_CODIGO = word(`Ação (Cod/Desc)  (Ajustada)`, 1, sep = " - "),
        ACAO_DESCRICAO = word(`Ação (Cod/Desc)  (Ajustada)`, 2, sep = " - ")
    )


#-- --  `Subtítulo (Cod/Desc)` --- 
LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(
        SUBTITULO_CODIGO = word(`Subtítulo (Cod/Desc)`, 1, sep = " - "),
        SUBTITULO_DESCRICAO = word(`Subtítulo (Cod/Desc)`, 2, sep = " - ")
    )


#-- --  ``Mod. Aplic. (Cod/Desc)` --- 
LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(
        MOD_APLIC_CODIGO = word(`Mod. Aplic. (Cod/Desc)`, 1, sep = " - "),
        MOD_APLIC_DESCRICAO = word(`Mod. Aplic. (Cod/Desc)`, 2, sep = " - ")
    )


#-- --  `Sub-elemento Despesa (Cod/Desc)` --- 
LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(
        SUB_ELEMENTO_CODIGO = word(`Sub-elemento Despesa (Cod/Desc)`, 1, sep = " - "),
        SUB_ELEMENTO_DESCRICAO = word(`Sub-elemento Despesa (Cod/Desc)`, 2, sep = " - ")
    )

#-- --  `UG (Cod/Desc)` --- 
LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(
        UG_CODIGO = word(`UG (Cod/Desc)`, 1, sep = " - "),
        UG_DESCRICAO = word(`UG (Cod/Desc)`, 2, sep = " - ")
    )

## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 
##
##   PROCESSO DE REGIONALIZACAO EM PASSOS
##
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## 

# PASSO 1 ) USANDO AS VARIAVEIS:

# `Mod. Aplic. (Cod/Desc)` e`
# `Sub-elemento Despesa (Cod/Desc)`


LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
  mutate(sub_elemento_cod = substr(`Mod. Aplic. (Cod/Desc)`, 1, 2)) %>% 
  mutate(sub_elemento_cod_uf = as.numeric(substr(`Sub-elemento Despesa (Cod/Desc)`, 7, 8)),
         UF_elemento =ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 1,"AC",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 3,"AL",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 5,"AM",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 2,"AM",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 4,"AP",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 7,"BA",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 9,"CE",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 11,"DF",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 21,"MS",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 19,"MT",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 39,"RS",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 47,"SE",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 15,"GO",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 33,"PI",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 27,"PB",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 25,"PA",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 29,"PR",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 42,"RR",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 23,"MG",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 22,"MG",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 35,"RJ",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 37,"RN",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 45,"SP",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 43,"SC",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 13,"ES",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 31,"PE",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 48,"TO",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 17,"MA",
                      ifelse(sub_elemento_cod >= 30 & sub_elemento_cod <= 49 & sub_elemento_cod_uf == 41,"RO",
                      'ND'))))))))))))))))))))))))))))))  




# PASSO 2) USANDO A VARIAVEL

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




LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
        mutate(cod.ug = as.numeric(substr(`UG (Cod/Desc)`, 1, 7)),
               cod.ug1 = as.numeric(substr(`UG (Cod/Desc)`, 1, 4)),
               Estado =   ifelse(substr(UG.UF, 1,1) == 0,   'SP',   # São Paulo
                          ifelse(substr(UG.UF, 1,1) == 1,   'SP',   # São Paulo
                          ifelse(substr(UG.UF, 1,1) == 3,   'MG',   # Minas Gerais
                          ifelse(substr(UG.UF, 1,1) == 9,   'RS',   # Rio Grande do Sul
                          ifelse(substr(UG.UF, 1,2) == 29,   'ES',   # Espirito Santo
                          ifelse(substr(UG.UF, 1,2) == 49,   'SE',   # Sergipe
                          ifelse(substr(UG.UF, 1,2) == 64,   'PI',   # Piauí
                          ifelse(substr(UG.UF, 1,2) == 65,   'MA',   # Maranhão
                          ifelse(substr(UG.UF, 1,3) == 689,  'AP',   # Amapá
                          ifelse(substr(UG.UF, 1,3) == 699,  'AC',   # Acre
                          ifelse(substr(UG.UF, 1,3) == 693,  'RR',   # Roraima
                          ifelse(substr(UG.UF, 1,2) == 77,   'TO',   # Tocantins
                          ifelse(substr(UG.UF, 1,2) == 79,   'MS',   # Mato Grosso do Sul
                          ifelse(substr(UG.UF, 1,2) == 78 & substr(UG.UF, 1,3) != 789,   'MT',   # Mato Grosso
                          ifelse(substr(UG.UF, 1,2) == 57,   'AL',   # Alagoas
                          ifelse(substr(UG.UF, 1,2) == 58,   'PB',   # Paraíba
                          ifelse(substr(UG.UF, 1,2) == 59,   'RN',   # Rio Grande do Norte
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),20,28),   'RJ', # Rio de Janeiro
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),40,48),   'BA', # Bahia
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),80,87),   'PR', # Parana
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),88,89),   'SC', # Santa Catarina
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),50,56),   'PE', # Pernambuco
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),60,63),   'CE', # ceará
                          ifelse(between( as.numeric(substr(UG.UF, 1,2)),66,68),   'PA', # Pará
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),690,692), 'AM', # Amazonas
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),694,698), 'AM', # Amazonas
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),700,727), 'DF', # Distrito Federal
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),730,736), 'DF', # Distrito Federal
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),768,769), 'RO', # Rondônia
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),789,789), 'RO', # Rondônia
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),728,729), 'GO', # Goiás
                          ifelse(between( as.numeric(substr(UG.UF, 1,3)),737,767), 'GO','ND'
                          )))))))))))))))))))))))))))))))))


## INTRODUCAO DE 'EX' NA VARIAVEL ESTADO
# LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
#     mutate(Estado = ifelse(UG.UF > 1 & UG.UF <= 110011, 'EX',
#                     ifelse(cod.ug == 120091 & UG.UF == 1,'EX',
#                     ifelse((UG.UF > 110111 & cod.ug1 == 2402) | (UG.UF > 110111 & cod.ug1 == 2400) , 'EX', Estado))),
#            Estado = ifelse(UG.UF > 1 & UG.UF <= 9999999 & Estado !='EX','SP',Estado))

## CONSEQUENCIA --> GRANDE CONCENTRACAO EM SP 



# PASSO 3) NAO DEFINIDO 

# PASSO 4) ALOCACAO POR PALAVRAS CHAVE

ug_base <- read_excel("UG_POR_UF.xlsx") %>% 
  select(c(code_ug,uf_ug)) %>% 
  filter(nchar(code_ug) == 6) %>% 
  mutate(code_ug = as.character(code_ug)) %>% distinct(code_ug,uf_ug) %>% 
  mutate(uf_ug = ifelse(uf_ug %in% c("CODIGO INVALIDO",
                                     "SEM INFORMACAO") | is.na(uf_ug),"ND",uf_ug),
         uf_ug =ifelse(uf_ug == "PARA","PA",
                ifelse(uf_ug == "AMAZONAS","AM",
                ifelse(uf_ug == "AMAPA","AP",       
                ifelse(uf_ug == "ACRE","AC",
                ifelse(uf_ug == "DISTRITO FEDERAL","DF",
                ifelse(uf_ug == "PERNAMBUCO","PE",
                ifelse(uf_ug == "BAHIA","BA",
                ifelse(uf_ug == "TOCANTINS","TO",   
                ifelse(uf_ug == "CEARÁ","CE",
                ifelse(uf_ug == "CEARA","CE",
                ifelse(uf_ug == "PIAUÍ","PI",
                ifelse(uf_ug == "PIAUI","PI",
                ifelse(uf_ug == "MINAS GERAIS","MG",
                ifelse(uf_ug == "GOIÁS","GO",
                ifelse(uf_ug == "ALAGOAS","AL",
                ifelse(uf_ug == "MARANHAO","MA",
                ifelse(uf_ug == "PARAÍBA","PB",
                ifelse(uf_ug == "RIO DE JANEIRO","RJ",
                ifelse(uf_ug == "PARANA","PR",
                ifelse(uf_ug == "PARAIBA","PB",
                ifelse(uf_ug == "RONDONIA","RO",
                ifelse(uf_ug == "PARA","PA",
                ifelse(uf_ug == "PARÁ","PA",
                ifelse(uf_ug == "SAO PAULO","SP",
                ifelse(uf_ug == "MATO GROSSO","MT",
                ifelse(uf_ug == "MATO GROSSO DO SUL","MS",
                ifelse(uf_ug == "RIO GRANDE DO SUL","RS",
                ifelse(uf_ug == "RIO GRANDE DO NORTE","RN",
                ifelse(uf_ug == "SANTA CATARINA","SC",
                ifelse(uf_ug == "ESPIRITO SANTO","ES",
                ifelse(uf_ug == "ESPÍRITO SANTO","ES",
                ifelse(uf_ug == "RONDÔNIA","RO",
                ifelse(uf_ug == "RORAIMA","RR",
                ifelse(uf_ug == "SÃO PAULO","SP",
                ifelse(uf_ug == "SERGIPE","SE",
                ifelse(uf_ug == "GOIAS","GO",
                ifelse(uf_ug == "PARANÁ","PR",
                 uf_ug))))))))))))))))))))))))))))))))))))))

LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% rename(code_ug = UG_CODIGO) %>% left_join(ug_base)


## Atualizacao Lucas Henrique: 18/11/2023
## Algoritmo de machine em implementacao



# PASSO 4) ALOCACAO POR DETECAO DE STRINGS

# Cria variavel UFis com base na variavel ja existente "Estado
LOA_FINAL_GND_4$UFis <- LOA_FINAL_GND_4$Estado

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Subtítulo (Cod/Desc)`,"OBTENÇÃO DE MEIOS DA MARINHA"),"EX",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"TECNOLOGIA NUCLEAR DA MARINHA"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"IMPLANTAÇÃO DE ESTALEIRO E LOA_FINAL_GND_4 NAVAL PARA CONSTRUÇÃO E MANUTENÇÃO DE SUBMARINOS CONVENCIONAIS E NUCLEARES"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"CONSTRUÇÃO DE SUBMARINO DE PROPULSÃO NUCLEAR"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"APOIO À REALIZAÇÃO DE GRANDES EVENTOS"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"CONSTRUÇÃO DE SUBMARINOS CONVENCIONAIS"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"APRESTAMENTO DA MARINHA"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"MELHORAMENTOS NO CANAL DE NAVEGAÇÃO DA HIDROVIA DOS RIOS PARANÁ E PARAGUAI"),"CO",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"DESENVOLVIMENTO TECNOLÓGICO DA MARINHA"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"CAPACITAÇÃO PROFISSIONAL DA MARINHA"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"OPERACIONALIZACAO DAS ACOES DE SEGURANCA PUBLICA PARA AS OLIMPIADAS E PARAOLIMPIADAS RIO 2016"),"RJ",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"DESENVOLVIMENTO E IMPLEMENTAÇÃO DO SISTEMA DE GERENCIAMENTO DA AMAZÔNIA AZUL (SISGAAZ)"),"NO",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"MANUTENÇÃO DO SISTEMA DE PROTEÇÃO DA AMAZÔNIA - SIPAM"),"NO",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"PARTICIPAÇÃO BRASILEIRA EM MISSÕES DE PAZ"),"EX",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"IMUNOBIOLÓGICOS E INSUMOS PARA PREVENÇÃO E CONTROLE DE DOENÇAS"),"EX",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"APOIO LOGÍSTICO À PESQUISA CIENTÍFICA NA ANTÁRTICA"),"EX",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"LONDRES"),"EX",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`,"SUPERINTENDÊNCIA DA ZONA FRANCA DE MANAUS - SUFRAMA"),"AM",LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Subtítulo (Cod/Desc)`,"MATOPIBA") & LOA_FINAL_GND_4$UFis=="ND","NE",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`,"RIO SÃO FRANCISCO") & LOA_FINAL_GND_4$UFis=="ND","NE",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Subtítulo (Cod/Desc)`,"CENTRO-OESTE") & LOA_FINAL_GND_4$UFis=="ND","CO",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`,"CENTRO-OESTE") & LOA_FINAL_GND_4$UFis=="ND","CO",LOA_FINAL_GND_4$UFis)
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`,"VALES DO SÃO FRANCISCO E DO PARNAÍBA") & LOA_FINAL_GND_4$UFis=="ND","NE",LOA_FINAL_GND_4$UFis)


LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`, "RIO SÃO FRANCISCO") &
        !(LOA_FINAL_GND_4$UFis %in% c("SE", "BA", "CE", "PB", "PE", "PI", "RN", "NE")), "NE", LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`, "RIOS JAGUARIBE") &
        !(LOA_FINAL_GND_4$UFis %in% c("SE", "BA", "CE", "PB", "PE", "PI", "RN", "NE")), "NE", LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`, "RIO JAGUARIBE") &
        !(LOA_FINAL_GND_4$UFis %in% c("SE", "BA", "CE", "PB", "PE", "PI", "RN", "NE")), "NE", LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`, "RIO SÃO FRANCISCO") &
        !(LOA_FINAL_GND_4$UFis %in% c("SE", "BA", "CE", "PB", "PE", "PI", "RN", "NE")), "NE", LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`, "AMAZÔNIA") & LOA_FINAL_GND_4$UFis == "ND",
    "NO", LOA_FINAL_GND_4$UFis)

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`Subtítulo (Cod/Desc)`, "EXTERIOR") & LOA_FINAL_GND_4$UFis == "ND",
    "EX", LOA_FINAL_GND_4$UFis)



LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$Região, "NORDESTE") & LOA_FINAL_GND_4$UFis=="ND","NE",LOA_FINAL_GND_4$UFis) 
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$Região, "SUL")      & LOA_FINAL_GND_4$UFis=="ND","SL",LOA_FINAL_GND_4$UFis) 
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$Região, "NORTE")    & LOA_FINAL_GND_4$UFis=="ND","NO",LOA_FINAL_GND_4$UFis) 
LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$Região, "SUDESTE")  & LOA_FINAL_GND_4$UFis=="ND","SD",LOA_FINAL_GND_4$UFis) 

LOA_FINAL_GND_4$UFis <- ifelse(str_detect(LOA_FINAL_GND_4$`UG (Cod/Desc)`,"PORTO ALEGRE"),"RS",LOA_FINAL_GND_4$UFis)






## RENOMEIA COLUNA DE UF CRIADO NO INICIO DO SCRIPT
## PARA SE ADEQUAR AOS PROXIMOS PASSOS ABAIXO

LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>%
    mutate(UF_nova = ifelse(`Subtítulo (Cod/Desc)` == "NACIONAL", NA, UF_nova),
           UF_nova = gsub("- ","", UF_nova),
           UF_nova = gsub("-","", UF_nova),
           Reg_nova = gsub(", ","", Reg_nova),
           Reg_nova = ifelse(Região != "Nacional" | Região != "NÃO INFORMADO" |
                               is.na(Região),
                             Região,Reg_nova),
           Reg_nova = ifelse(Reg_nova == "PB"|
                               Reg_nova == "PE"|
                               Reg_nova == "CE"|
                               Reg_nova == "RN"|
                               Reg_nova == "PI"|
                               Reg_nova == "BA"|
                               Reg_nova == "AL"|
                               Reg_nova == "SE","Nordeste",
                      ifelse(Reg_nova == "PB"|
                               Reg_nova == "ES"|
                               Reg_nova == "MG"|
                               Reg_nova == "RJ"|
                               Reg_nova == "SP","Sudeste",
                      ifelse(Reg_nova == "PB"|
                               Reg_nova == "AM"|
                               Reg_nova == "RR"|
                               Reg_nova == "AP"|
                               Reg_nova == "PA"|
                               Reg_nova == "TO"|
                               Reg_nova == "RO"|
                               Reg_nova == "AC","Norte",
                      ifelse(Reg_nova == "PA"|
                               Reg_nova == "SC"|
                               Reg_nova == "RS","Sul",
                      ifelse(Reg_nova == "GO"|
                               Reg_nova == "MT"|
                               Reg_nova == "MS"|
                               Reg_nova == "DF","Centro-Oeste",0))))),
           UFis = ifelse(Reg_nova != 0,Reg_nova,UFis),
           UFis = ifelse(Estado != "DF",Estado,UFis),
           UFis = ifelse((UF_elemento != 'ND' | is.na(UF_elemento)) 
                         & sub_elemento_cod >= 30  
                         & sub_elemento_cod <= 49, UF_elemento, UFis),
           UFis = ifelse(is.na(UFis), UF_nova, UFis),
           UFis = ifelse(UFis == "PARA","PA",
                         ifelse(UFis == "AMAZONAS","AM",
                         ifelse(UFis == "AMAPA","AP",       
                         ifelse(UFis == "ACRE","AC",
                         ifelse(UFis == "DISTRITO FEDERAL","DF",
                         ifelse(UFis == "PERNAMBUCO","PE",
                         ifelse(UFis == "BAHIA","BA",
                         ifelse(UFis == "TOCANTINS","TO",   
                         ifelse(UFis == "CEARÁ","CE",
                         ifelse(UFis == "CEARA","CE",
                         ifelse(UFis == "PIAUÍ","PI",
                         ifelse(UFis == "PIAUI","PI",
                         ifelse(UFis == "MINAS GERAIS","MG",
                         ifelse(UFis == "GOIÁS","GO",
                         ifelse(UFis == "ALAGOAS","AL",
                         ifelse(UFis == "MARANHAO","MA",
                         ifelse(UFis == "PARAÍBA","PB",
                         ifelse(UFis == "RIO DE JANEIRO","RJ",
                         ifelse(UFis == "PARANA","PR",
                         ifelse(UFis == "PARAIBA","PB",
                         ifelse(UFis == "RONDONIA","RO",
                         ifelse(UFis == "PARA","PA",
                         ifelse(UFis == "PARÁ","PA",
                         ifelse(UFis == "SAO PAULO","SP",
                         ifelse(UFis == "MATO GROSSO","MT",
                         ifelse(UFis == "MATO GROSSO DO SUL","MS",
                         ifelse(UFis == "RIO GRANDE DO SUL","RS",
                         ifelse(UFis == "RIO GRANDE DO NORTE","RN",
                         ifelse(UFis == "SANTA CATARINA","SC",
                         ifelse(UFis == "ESPIRITO SANTO","ES",
                         ifelse(UFis == "ESPÍRITO SANTO","ES",
                         ifelse(UFis == "RONDÔNIA","RO",
                         ifelse(UFis == "RORAIMA","RR",
                         ifelse(UFis == "SÃO PAULO","SP",
                         ifelse(UFis == "SERGIPE","SE",
                         ifelse(UFis == "GOIAS","GO",
                         ifelse(UFis == "PARANÁ","PR",
                                UFis))))))))))))))))))))))))))))))))))))),
           UF = ifelse(is.na(Localidade.UF),"NÃO APLICÁVEL",Localidade.UF),
           UF = ifelse(Localidade.UF == "NÃO INFORMADO" | Localidade.UF == "NÃO APLICÁVEL", NA, Localidade.UF),
           UFis = ifelse(!is.na(Localidade.UF), Localidade.UF, UFis),
           UFis = ifelse(UFis == 0, "ND", UFis),
           UFis = ifelse(is.na(UFis),"ND",UFis),
           UFis = ifelse(is.na(UFis), Reg_nova, UFis)) %>% 
    left_join(base_estados, by = c("UFis"="abbrev_state"), copy = FALSE)

## Trabalhando a variavel UFis

LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
  mutate(UFis =  ifelse(UFis == "Nordeste" | UFis == "NORDESTE", "NE",
                 ifelse(UFis == "Norte" | UFis == "NORTE", "NO",
                 ifelse(UFis == "Sudeste" | UFis == "SUDESTE", "SD",
                 ifelse(UFis == "Sul" | UFis == "SUL", "SL",
                 ifelse(UFis == "Centro Oeste" | UFis == "CENTRO OESTE" | UFis == "Centro-Oeste", "CO", UFis))))),
         UFis  = ifelse(UFis == "ND" & Estado != "DF", Estado, UFis),
         UFis  = ifelse(UFis == "DF",Estado,UFis),
         REGis =ifelse(is.na(name_region), UFis, name_region),
         REGis =ifelse(REGis == "Nordeste" | REGis == "NORDESTE" | REGis == "NE", "NE",
                       ifelse(REGis == "Norte" | REGis == "NORTE" | REGis == "NO", "NO",
                       ifelse(REGis == "Sudeste" | REGis == "SUDESTE" | REGis == "SD", "SD",
                       ifelse(REGis == "Sul" | REGis == "SUL" | REGis == "SL", "SL",
                       ifelse(REGis == "Centro Oeste" | REGis == "CENTRO OESTE" | REGis == "CO" |
                              REGis == "Centro-Oeste", "CO",
                       ifelse(REGis == "EX","EX",
                              REGis)))))))

LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
  mutate(UFis  = ifelse(`Região` == "NACIONAL" & UFis=="DF","ND",UFis),
         REGis = ifelse(`Região` == "NACIONAL" & UFis=="DF","ND",REGis))





LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
  mutate(UFis  = ifelse(UFis == 0,"ND",UFis),
         UFis  = ifelse(is.na(UFis),"ND",UFis),
         UFis =  ifelse(UFis == "Nordeste" | UFis == "NORDESTE", "NE",
                 ifelse(UFis == "Norte" | UFis == "NORTE", "NO",
                 ifelse(UFis == "Sudeste" | UFis == "SUDESTE", "SD",
                 ifelse(UFis == "Sul" | UFis == "SUL", "SL",
                 ifelse(UFis == "Centro Oeste" | UFis == "CENTRO OESTE" | UFis == "CENTROOESTE" | 
                        UFis == "Centro-Oeste", "CO",
                        UFis))))),
         UFis     = ifelse(is.na(UFis) & is.na(Localidade.UF),Estado,UFis),
         REGis = UFis,
         REGis = 
             ifelse(REGis == "PB"|
                    REGis == "MA"|
                    REGis == "PE"|
                    REGis == "CE"|
                    REGis == "RN"|
                    REGis == "PI"|
                    REGis == "BA"|
                    REGis == "AL"|
                    REGis == "SE","NE",
             ifelse(
                    REGis == "ES"|
                    REGis == "MG"|
                    REGis == "RJ"|
                    REGis == "SP","SD",
             ifelse(
                    REGis == "AM"|
                    REGis == "RR"|
                    REGis == "AP"|
                    REGis == "PA"|
                    REGis == "TO"|
                    REGis == "RO"|
                    REGis == "AC","NO",
             ifelse(REGis == "PR"|
                    REGis == "PA"|
                    REGis == "SC"|
                    REGis == "RS","SL",
             ifelse(REGis == "GO"|
                    REGis == "MT"|
                    REGis == "MS"|
                    REGis == "DF","CO",REGis))))),
         uf_ug    = ifelse(is.na(uf_ug),"ND",uf_ug),
         UFis     = gsub(", ","",UFis),
         Região   = ifelse(Região == "NE","REGIAO NORDESTE",Região),
         Região   = ifelse(Região == "NO","REGIAO NORTE",Região),
         Região   = ifelse(Região == "SL","REGIÃO SUL",Região),
         Região   = ifelse(Região == "SD","REGIAO SUDESTE",Região),
         Região   = ifelse(Região == "CO","REGIAO CENTRO OESTE",Região),
         UFis     = ifelse(!(UFis %in% c("SE","BA","CE","PB","PE","PI","RN")) & grepl("NE",Região),"NE",UFis),
         UFis     = ifelse(!(UFis %in% c("GO","DF","MT","MS")) & grepl("CO",Região),"CO",UFis),
         UFis     = ifelse(!(UFis %in% c("PR","PA","SC","RS")) & grepl("SL",Região),"SL",UFis),
         UFis     = ifelse(!(UFis %in% c("AM","RR","AP","PA","TO","RO","AC")) & grepl("NO",Região),"NO",UFis),
         UFis     = ifelse(!(UFis %in% c("ES","MG","RJ","SP")) & grepl("SD",Região),"SD",UFis),
         "UF*"    = ifelse(!is.na(UF),UF,UFis),
         "Região*"= REGis,
         "UF*_novo" =  ifelse(UFis=="ND" & UFis!="DF" & uf_ug != "DF", uf_ug,`UF*`))





## AJUSTES MICRO
LOA_FINAL_GND_4$`UF*_novo` <- ifelse(str_detect(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`,"IPEA") & LOA_FINAL_GND_4$`UF*_novo` == "ND",
                                     "DF",
                                     LOA_FINAL_GND_4$`UF*_novo`)

LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
    mutate(`Sub-elemento Despesa (Cod/Desc)` = stri_trans_general(str = `Sub-elemento Despesa (Cod/Desc)`, 
                                                                id = "Latin-ASCII"))




LOA_FINAL_GND_4 <- LOA_FINAL_GND_4 %>% 
    mutate(`UF*_novo` = 
           ifelse(`UF*_novo` == "PARA","PA",
           ifelse(`UF*_novo` == "AMAPÁ","AP",
           ifelse(`UF*_novo` == "AMAZONAS","AM",
           ifelse(`UF*_novo` == "AMAPA","AP",       
           ifelse(`UF*_novo` == "ACRE","AC",
           ifelse(`UF*_novo` == "DISTRITO FEDERAL","DF",
           ifelse(`UF*_novo` == "PERNAMBUCO","PE",
           ifelse(`UF*_novo` == "BAHIA","BA",
           ifelse(`UF*_novo` == "TOCANTINS","TO",   
           ifelse(`UF*_novo` == "CEARÁ","CE",
           ifelse(`UF*_novo` == "CEARA","CE",
           ifelse(`UF*_novo` == "PIAUÍ","PI",
           ifelse(`UF*_novo` == "PIAUI","PI",
           ifelse(`UF*_novo` == "MINAS GERAIS","MG",
           ifelse(`UF*_novo` == "GOIÁS","GO",
           ifelse(`UF*_novo` == "ALAGOAS","AL",
           ifelse(`UF*_novo` == "MARANHAO","MA",
           ifelse(`UF*_novo` == "MARANHÃO","MA",       
           ifelse(`UF*_novo` == "PARAÍBA","PB",
           ifelse(`UF*_novo` == "RIO DE JANEIRO","RJ",
           ifelse(`UF*_novo` == "PARANA","PR",
           ifelse(`UF*_novo` == "PARAIBA","PB",
           ifelse(`UF*_novo` == "RONDONIA","RO",
           ifelse(`UF*_novo` == "PARA","PA",
           ifelse(`UF*_novo` == "PARÁ","PA",
           ifelse(`UF*_novo` == "SAO PAULO","SP",
           ifelse(`UF*_novo` == "MATO GROSSO","MT",
           ifelse(`UF*_novo` == "MATO GROSSO DO SUL","MS",
           ifelse(`UF*_novo` == "RIO GRANDE DO SUL","RS",
           ifelse(`UF*_novo` == "RIO GRANDE DO NORTE","RN",
           ifelse(`UF*_novo` == "SANTA CATARINA","SC",
           ifelse(`UF*_novo` == "ESPIRITO SANTO","ES",
           ifelse(`UF*_novo` == "ESPÍRITO SANTO","ES",
           ifelse(`UF*_novo` == "RONDÔNIA","RO",
           ifelse(`UF*_novo` == "RORAIMA","RR",
           ifelse(`UF*_novo` == "SÃO PAULO","SP",
           ifelse(`UF*_novo` == "SERGIPE","SE",
           ifelse(`UF*_novo` == "GOIAS","GO",
           ifelse(`UF*_novo` == "PARANÁ","PR",
                  `UF*_novo`))))))))))))))))))))))))))))))))))))))))


## -- -- -- -- -- -- -- -- --
##    BLOCO DE TESTES
##    E BENCHMARKS
##- -- -- -- -- -- -- -- --


# TESTE <- LOA_FINAL_GND_4
# 
# # TESTE$CHAVE_Localidade.UF <- paste(TESTE$Localidade.UF,
# #                                    TESTE$Ano,
# #                                    sep = "_")
# 
# 
# 
# # UF ORIGINAL - AGREGACAO -  --- --- -- -
# TESTE_UF_ORIGINAL_SOMASSE <- TESTE %>%
#     group_by(Localidade.UF) %>%
#     summarise(Localidade.UF = unique(Localidade.UF),
#               Despesa_Executada = sum(`Despesa Executada`, na.rm = T))
# 
# total <- sum(TESTE_UF_ORIGINAL_SOMASSE$Despesa_Executada, na.rm = TRUE)
# 
# # PROP TABLE
# TESTE_UF_ORIGINAL_SOMASSE$PROPORCAO <- (TESTE_UF_ORIGINAL_SOMASSE$Despesa_Executada)/(total)*100
# # -- -- -- -- -- -- -- -- -- -- -- - - -- -- 
# 
# 
# 
# # UF ESTRELA - AGREGACAO -  --- --- -- -
# TESTE_UF_ESTRELA_SOMASSE <- TESTE %>%
#     group_by(`UF*`) %>%
#     summarise(`UF*` = unique(`UF*`),
#               Despesa_Executada = sum(`Despesa Executada`, na.rm = T))
# 
# total <- sum(TESTE_UF_ESTRELA_SOMASSE$Despesa_Executada, na.rm = TRUE)
# 
# # PROP TABLE
# TESTE_UF_ESTRELA_SOMASSE$PROPORCAO <- (TESTE_UF_ESTRELA_SOMASSE$Despesa_Executada)/(total)*100
# # -- -- -- -- -- -- -- -- -- -- -- - - -- -- 
# 
# 
# 
# # UF ESTRELA NOVO - AGREGACAO -  --- --- -- -
# TESTE_UF_EST_NOVO_SOMASSE <- TESTE %>%
#     group_by(`UF*_novo`) %>%
#     summarise(`UF*_novo` = unique(`UF*_novo`),
#               Despesa_Executada = sum(`Despesa Executada`, na.rm = T))
# 
# total <- sum(TESTE_UF_EST_NOVO_SOMASSE$Despesa_Executada, na.rm = TRUE)
# 
# # PROP TABLE
# TESTE_UF_EST_NOVO_SOMASSE$PROPORCAO <- (TESTE_UF_EST_NOVO_SOMASSE$Despesa_Executada)/(total)*100
# # -- -- -- -- -- -- -- -- -- -- -- - - -- -- 
# 
# 
# 
# ## PROXIMO PASSO: ALGORITMO DE ML PARA LOCALIZAR POR DETECCAO DE PALAVRAS CHAVE
# ACAO_AJUSTADA_TESTE <- data_frame(unique(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`))
# SUBTITULO_AJUSTADA_TESTE <- data_frame(unique(LOA_FINAL_GND_4$`Subtítulo (Cod/Desc)`))
# UO_TESTE <- data_frame(unique(LOA_FINAL_GND_4$`UO (Cod/Desc) (Ajustado)`))
# UG_TESTE <- data_frame(unique(LOA_FINAL_GND_4$`UG (Cod/Desc)`))
# ACAO_AJUSTADA_TESTE <- data_frame(unique(LOA_FINAL_GND_4$`Ação (Cod/Desc)  (Ajustada)`))
# 
# ## teste de missingness
# NAs <- subset(LOA_FINAL_GND_4, is.na(LOA_FINAL_GND_4$Localidade.UF))

