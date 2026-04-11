#+-----------------------------------------------------+
#|Projeto: INFERE                                      |
#|Autor: Alexandre Santos                              |
#|Colaborador: Bruno Gontijo                           |
#|Descrição: Script de inserção das tabelas LOA no DB  |
#|Data começo: 27/09/2024                              |
#|Data fim: 14/10/2024                                 |
#+-----------------------------------------------------+

import psycopg2
import pandas as pd

#df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C': [7, 8, 9]})
LOA_FINAL= pd.read_csv('D:/Arquivos/Scripts/LOA_FINAL.csv', sep =";", index_col=False)
#LOA_FINAL.info()

conn = psycopg2.connect(database = "postgres", 
                        user = "postgres", 
                        host= 'localhost',
                        password = "postgres",
                        port = 5432)  

COL_ANO=0
COL_LOCALIDADE_UF=1
COL_REGIAO=2
COL_ORGAO__COD_DESC=3
COL_ORGAO_SUPERIOR_COD_DESC=4
COL_UG=5
COL_UG_UF=6
COL_UO_COD_DESC_AJUSTADO=7
COL_FUNCAO_COD_DESC=8
COL_SUBFUNCAO_COD_DESC=9
COL_PROGRAMA_COD_DESC=10
COL_FUNCIONAL=11
COL_ACAO_COD_DESCRICAO_AJUSTADO = 12
COL_SUBTITULO_COD_DESC=13
COL_ESFERA_COD_DESC=14
COL_GND_COD=15
COL_MOD_APLIC_COD_DESC=16
COL_ELEMENTO_DESPESA_COD_DESC=17
COL_SUB_ELEMENTO_DESPESA_COD_DESC=18
COL_DOTACAO_INICIAL=19
COL_AUTORIZADO=20
COL_EMPENHADO=21
COL_LIQUIDADO=22
COL_DESPESA_EXE=23
COL_PAGO=24
COL_RPPAGO=25

for index, row in LOA_FINAL.iterrows():    
    localidadeuf=str(row[COL_LOCALIDADE_UF])
    localidadeuf=localidadeuf.replace("'","")


    regiao=str(row[COL_REGIAO])
    regiao=regiao.replace("'","")


    orgaocoddesc=str(row[COL_ORGAO__COD_DESC])
    orgaocoddesc=orgaocoddesc.replace("'","")


    orgaosuperior=(row[COL_ORGAO_SUPERIOR_COD_DESC])
    orgaosuperior=orgaosuperior.replace("'","")
    orgaosuperior=orgaosuperior.replace('"','')

    ug=str(row[COL_UG])
    ug=ug.replace("'","")
    ug=ug.replace('"','')
    


    uguf=str(row[COL_UG_UF])
    uguf=uguf.replace("'","")


    uocoddescajustado=str(row[COL_UO_COD_DESC_AJUSTADO])
    uocoddescajustado=uocoddescajustado.replace("'","")

    funcaocoddesc=str(row[COL_FUNCAO_COD_DESC])
    funcaocoddesc=funcaocoddesc.replace("'","")


    subfuncaocoddesc=str(row[COL_SUBFUNCAO_COD_DESC])
    subfuncaocoddesc=subfuncaocoddesc.replace("'","")

    programacoddesc=str(row[COL_PROGRAMA_COD_DESC])
    programacoddesc=programacoddesc.replace("'","")


    funcional=str(row[COL_FUNCIONAL])
    funcional=funcional.replace("'","")

    acaocodigodescricaoajustado=str(row[COL_ACAO_COD_DESCRICAO_AJUSTADO])
    acaocodigodescricaoajustado=acaocodigodescricaoajustado.replace("'","")

    subtitulocodigodescricao=str(row[COL_SUBTITULO_COD_DESC])
    subtitulocodigodescricao = subtitulocodigodescricao.replace("'","")
    

    esferacoddesc=str(row[COL_ESFERA_COD_DESC])
    esferacoddesc = esferacoddesc.replace("'","")


    gndcod=str(row[COL_GND_COD])
    gndcod = gndcod.replace("'","")

    modapliccoddesc=str(row[COL_MOD_APLIC_COD_DESC])
    modapliccoddesc = modapliccoddesc.replace("'","")

    elementodespesacoddesc=str(row[COL_ELEMENTO_DESPESA_COD_DESC])
    elementodespesacoddesc = elementodespesacoddesc.replace("'","")

    subelementodespesacoddesc=str(row[COL_SUB_ELEMENTO_DESPESA_COD_DESC])
    subelementodespesacoddesc = subelementodespesacoddesc.replace("'","")

    dotacaoinicial=str(row[COL_DOTACAO_INICIAL])
    dotacaoinicial = dotacaoinicial.replace(",", ".")

    autorizado=str(row[COL_AUTORIZADO])
    autorizado = autorizado.replace(",", ".")

    empenhado=str(row[COL_EMPENHADO])
    empenhado = empenhado.replace(",", ".")

    liquidado=str(row[COL_LIQUIDADO])
    liquidado = liquidado.replace(",", ".")

    despesaexecutada=str(row[COL_DESPESA_EXE])
    despesaexecutada = despesaexecutada.replace(",", ".")

    pago=str(row[COL_PAGO])
    pago = pago.replace(",", ".")

    rppago=str(row[COL_RPPAGO])
    rppago = rppago.replace(",", ".")

#+------------------------------+
#|Montagem da string de comando|
#+------------------------------+
    cur = conn.cursor() 
    str_insert = 'INSERT INTO infere.loa_final'
    str_insert+='(ano,'
    str_insert+='localidadeuf,'
    str_insert+='regiao,'
    str_insert+='orgaocodigodescricao,'
    str_insert+='orgaosuperiorcodigodescricao, '
    str_insert+='ug, '
    str_insert+='uguf, '
    str_insert+='uocodigodescricaoajustado, '
    str_insert+='funcaocodigodescricao, '
    str_insert+='subfuncaocodigodescricao, '
    str_insert+='programacodigodescricao, '
    str_insert+='funcional, '
    str_insert+='acaocodigodescricaoajustado, '
    str_insert+='subtitulocodigodescricao, '
    str_insert+='esferacodigodescricao, '
    str_insert+='gndcodigo, '
    str_insert+='modapliccodigodescricao, '
    str_insert+='elementodespesacodigodescricao, '
    str_insert+='subelementodespesacodigodescricao, '
    str_insert+='dotacaoinicial, '
    str_insert+='autorizado, '
    str_insert+='empenhado, '
    str_insert+='liquidado, '
    str_insert+='despesaexecutada, '
    str_insert+='pago, '
    str_insert+='rppago) VALUES ('"'" 
    str_insert+=str(row[COL_ANO]) + "'"+','+ "'"  #COL 0 Ano
    str_insert+=str(localidadeuf) + "'" +','+ "'"  #COL 1 Localidade.UF
    str_insert+=str(regiao) + "'" +','+ "'" #COL 2  Região
    str_insert+=str(orgaocoddesc) + "'" +','+"'"  #COL 3 Órgão (Cod/Desc)
    str_insert+=str(orgaosuperior) + "'" +','+"'"  #COL 4 Órgão Superior (Cod/Desc)
    str_insert+=str(ug) + "'" +','+"'"  #COL 5 UG (Cod/Desc)
    str_insert+=str(uguf) + "'" +','+"'" #COLUNA 6 UG.UF
    str_insert+=str(uocoddescajustado) + "'" +','+"'" #COL 7 UO (Cod/Desc) (Ajustado)
    str_insert+=str(funcaocoddesc) + "'" +','+"'" #COL 8 Função (Cod/Desc)
    str_insert+=str(subfuncaocoddesc) + "'" +','+"'" #COL 9 Subfunção (Cod/Desc)
    str_insert+=str(programacoddesc) + "'" +','+"'"  #COL 10 Programa (Cod/Desc)
    str_insert+=str(funcional) + "'" +','+"'"  #COL 11 Funcional
    str_insert+=str(acaocodigodescricaoajustado) + "'" +','+"'" #COL 12 Ação (Cod/Desc) (Ajustado)
    str_insert+=str(subtitulocodigodescricao) + "'" +','+"'"  #COL 13 Subtítulo (Cod/Desc)
    str_insert+=str(esferacoddesc) + "'" +','+"'"  #COL 14 Esfera (Cod/Desc)
    str_insert+=str(gndcod) + "'" +','+"'"  #COL 15 GND (Cod)
    str_insert+=str(modapliccoddesc) + "'" +','+"'"  #COL 16 Mod. Aplic. (Cod/Desc)
    str_insert+=str(elementodespesacoddesc) + "'" +','+"'"  #COL 17 Elemento Despesa (Cod/Desc)
    str_insert+=str(subelementodespesacoddesc) + "'" +','+"'"  #COL 18 Sub-elemento Despesa (Cod/Desc)
    str_insert+=str(dotacaoinicial) + "'" +','+"'"  #COL 19 Dotação Inicial
    str_insert+=str(autorizado) + "'" +','+"'"  #COL 20 Despesa Executada
    str_insert+=str(empenhado) + "'" +','+"'"  #COL 21 Empenhado
    str_insert+=str(liquidado) + "'" +','+"'"      #COL 22 Liquidado            
    str_insert+=str(despesaexecutada) + "'" +','+"'"       #COL 23 Despesa Executada
    str_insert+=str(pago) + "'" +','+"'"       #COL 24 Pago    
    str_insert+=str(rppago) + "'" + ');'  #COL 25 RP Pago
    #print(str_insert)
    cur.execute(str_insert)
    conn.commit()
    #print(row[0])

conn.close()


