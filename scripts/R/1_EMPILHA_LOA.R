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

## Seta alocacao de memoria
memory.limit(size = 9000)

## Captura usuario logado na maquina
usuario <- Sys.getenv("USERNAME")

## Reseta notacao cientifica
options(scipen=999)

## Seta diretorio de trabalho
## NOTA: Trocar conforme a necessidade

## Por padrao deixou-se na pasta DOWNLOADS com o mesmo nome da pasta 
## Enviada para os cordenadores do projeto
wd <- setwd(paste("C:/Users/", usuario, "/Downloads/INVESTIMENTO_FEDERAL/0_dados_originais", sep = ""))


setwd(paste("C:/Users/", usuario, "/Downloads/INVESTIMENTO_FEDERAL/0_dados_originais", sep = ""))


LOA_2002 <- fread("LOA2002.csv", dec = ',', encoding = "UTF-8")
LOA_2003 <- fread("LOA2003.csv", dec = ',', encoding = "UTF-8")
LOA_2004 <- fread("LOA2004.csv", dec = ',', encoding = "UTF-8")
LOA_2005 <- fread("LOA2005.csv", dec = ',', encoding = "UTF-8")
LOA_2006 <- fread("LOA2006.csv", dec = ',', encoding = "UTF-8")
LOA_2007 <- fread("LOA2007.csv", dec = ',', encoding = "UTF-8")
LOA_2008 <- fread("LOA2008.csv", dec = ',', encoding = "UTF-8")
LOA_2009 <- fread("LOA2009.csv", dec = ',', encoding = "UTF-8")
LOA_2010 <- fread("LOA2010.csv", dec = ',', encoding = "UTF-8")
LOA_2011 <- fread("LOA2011.csv", dec = ',', encoding = "UTF-8")
LOA_2012 <- fread("LOA2012.csv", dec = ',', encoding = "UTF-8")
LOA_2013 <- fread("LOA2013.csv", dec = ',', encoding = "UTF-8")
LOA_2014 <- fread("LOA2014.csv", dec = ',', encoding = "UTF-8")
LOA_2015 <- fread("LOA2015.csv", dec = ',', encoding = "UTF-8")
LOA_2016 <- fread("LOA2016.csv", dec = ',', encoding = "UTF-8")
LOA_2017 <- fread("LOA2017.csv", dec = ',', encoding = "UTF-8")
LOA_2018 <- fread("LOA2018.csv", dec = ',', encoding = "UTF-8")
LOA_2019 <- fread("LOA2019.csv", dec = ',', encoding = "UTF-8")
LOA_2020 <- fread("LOA2020.csv", dec = ',', encoding = "UTF-8")
LOA_2021 <- fread("LOA2021.csv", dec = ',', encoding = "UTF-8")
LOA_2022 <- fread("LOA2022.csv", dec = ',', encoding = "UTF-8")

## CRIA UF DA UF PARA A EXTRACAO DO ANO DE 2015
## NO SIGA BRASIL NAO CONSTA ESSA VARIAVEL NO UNIVERSO LOA2015
LOA_2015$UG.UF <- NA

## REORDENA EXTRACAO DE 2015, PARA MANTER A CONSISTENCIA
LOA_2015 <- LOA_2015[, c(1,2,3,4,5,6,26,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25)]

## REMOVE A VARIAVEL DE DOTACAO INICIAL CN
LOA_2022 <- LOA_2022 %>% select(-`Dotação Inicial CN`)

## -- -- -- -- -- -- -- - --- - - -- - -
## RENOMIA PARA MANTER O PADRAO DE NOME
names(LOA_2022)[20] <- "Dotação Inicial"


## E CONSEQUENTEMENTE RENOMEIA OS ANOS DE 2015 A 2021 PARA TAMBEM MANTER O PADRAO
names(LOA_2015)[20] <- "Dotação Inicial"
names(LOA_2016)[20] <- "Dotação Inicial"
names(LOA_2017)[20] <- "Dotação Inicial"
names(LOA_2018)[20] <- "Dotação Inicial"
names(LOA_2019)[20] <- "Dotação Inicial"
names(LOA_2020)[20] <- "Dotação Inicial"
names(LOA_2021)[20] <- "Dotação Inicial"
## -- -- -- -- -- -- -- - --- - - -- - -


LOA_2002_A_2014 <- rbind(LOA_2002, LOA_2003, LOA_2004, LOA_2005, LOA_2006,
                         LOA_2007, LOA_2008, LOA_2009, LOA_2010, LOA_2011,
                         LOA_2012, LOA_2013, LOA_2014)

names(LOA_2015)[2] <- "Localidade.UF"

LOA_2015_A_2022 <- rbind(LOA_2015, LOA_2016, LOA_2017, LOA_2018,
                         LOA_2019, LOA_2020, LOA_2021, LOA_2022)


names(LOA_2002_A_2014)[23] <- "Liquidado"
names(LOA_2002_A_2014)[24] <- "Despesa Executada"


names(LOA_2002_A_2014)[20] <- "Dotação Inicial"




LOA_FINAL <- rbind(LOA_2002_A_2014,
                   LOA_2015_A_2022)

LOA_FINAL_GND_4 <- subset(LOA_FINAL, `GND (Cod)` == "4")



## EXPORTA CSV E TXT DO ARQUIVO FULL
write.table(LOA_FINAL, "LOA_FINAL.csv", sep = ';', row.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")
fwrite(LOA_FINAL, "LOA_FINAL.txt", sep=';')


## EXPORTA CSV E TXT DO ARQUIVO CSV
write.table(LOA_FINAL_GND_4, "LOA_FINAL_GND_4.csv", sep = ';', row.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")
fwrite(LOA_FINAL_GND_4, "LOA_FINAL_GND_4.txt", sep=';')
