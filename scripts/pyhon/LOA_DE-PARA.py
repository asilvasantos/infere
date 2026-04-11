#+-------------------------------------------------------+
#|Projeto: INFERE                                        |
#|Autor: Alexandre Santos                                |
#|Colaborador: Bruno Gontijo                             |
#|Descrição: Script de conversão das colunas uguf em uf  |
#|Data começo: 27/09/2024                                |
#|Data fim: 14/10/2024                                   |
#+-------------------------------------------------------+

import requests
import pandas as pd
import psycopg2

conn = psycopg2.connect(database = "postgres", 
                        user = "postgres", 
                        host= 'localhost',
                        password = "postgres",
                        port = 5432)  

cur = conn.cursor()
str_insert="select distinct uguf from infere.tb_loa_final where character_length(uguf)=8;"

loa_final=pd.read_sql_query(str_insert, conn)


print(loa_final)

uguf=loa_final['uguf'] = [x for x in loa_final['uguf']]
uguf=pd.DataFrame(uguf, columns=['uguf'])

uf_ug=[]
regiao_ug=[]
cep_ug=[]

num_quero=[]

for index,rows in uguf.iterrows():
    code=str(rows[0])
    cep_ug.append(code)
    uguf=requests.get('https://brasilapi.com.br/api/cep/v2/'+code)
    codi=(uguf.status_code)
    print(codi)
    if codi==200:
        ret = uguf.json()
        sigla=ret['state']

        uf_ug.append(sigla)

        
        if sigla == 'AC' or sigla == 'AP' or sigla == 'AM' or sigla == 'PA' or sigla == 'RO' or sigla == 'TO' or sigla == 'RR':
            regiao_ug.append('REGIAO NORTE')
        elif sigla == 'AL' or sigla == 'BA' or sigla == 'CE' or sigla == 'MA' or sigla == 'PB' or sigla == 'PE' or sigla == 'PI' or sigla == 'RN' or sigla == 'SE': 
            regiao_ug.append('REGIAO NORDESTE')
        elif sigla == 'DF' or sigla == 'GO' or sigla == 'MT' or sigla == 'MS': 
            regiao_ug.append('REGIAO CENTRO OESTE')
        elif sigla == 'ES' or sigla == 'MG' or sigla == 'RJ' or sigla == 'SP': 
            regiao_ug.append('REGIAO SUDESTE')
        elif sigla == 'PR' or sigla == 'SC' or sigla == 'RS': 
            regiao_ug.append('REGIAO SUL')

    elif codi==404:
        num_quero.append('NA')
        num_quero.append('NA')


    elif codi==400:
        num_quero.append('NA')
        num_quero.append('NA')

conn.close()

cep_ug=pd.DataFrame(cep_ug, columns=['CEP_UG'])
uf_ug=pd.DataFrame(uf_ug, columns=['UF_UG'])
regiao_ug=pd.DataFrame(regiao_ug, columns=['REGIAO_UG'])

#print(cep_ug,uf_ug,regiao_ug)

fim=pd.concat([cep_ug,uf_ug,regiao_ug],axis=1)

fim.to_csv("UG_POR_UF.csv", sep=';',   encoding='utf-8', index=False)

