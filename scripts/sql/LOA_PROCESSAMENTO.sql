--+----------------------------------------------------------+
--|Projeto: INFERE                                           |
--|Autor: Alexandre Santos                                   |
--|Colaborador: Bruno Gontijo                                |
--|Descrição: Script de processamento das tabelas LOA no DB  |
--|Data começo: 27/09/2024                                   |
--|Data fim: 14/10/2024                                      |
--+----------------------------------------------------------+

---------------------------------------------------------------------------------------------------------------------------
--Script de criação do schema infere e da tabela tb_loa_final
---------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA infere
	CREATE TABLE infere.tb_loa_final (
		ID integer primary key,
		ANO integer NOT NULL,
		LOCALIDADEUF character varying(500),
		REGIAO character varying(500),
		ORGAOCODIGODESCRICAO character varying (500),
		ORGAOSUPERIORCODIGODESCRICAO character varying (500),  
		UG character varying (500),
		UGUF character varying(500), 
		UOCODIGODESCRICAOAJUSTADO character varying(500),
		FUNCAOCODIGODESCRICAO character varying (500),
		SUBFUNCAOCODIGODESCRICAO character varying (500),
		PROGRAMACODIGODESCRICAO character varying (500),
		FUNCIONAL character varying (500),
		ACAOCODIGODESCRICAOAJUSTADO character varying (500),
		SUBTITULOCODIGODESCRICAO character varying (500),
		ESFERACODIGODESCRICAO character varying (500),
		GNDCODIGO character varying (500),
		MODAPLICCODIGODESCRICAO character varying (500),
		ELEMENTODESPESACODIGODESCRICAO character varying (500),
		SUBELEMENTODESPESACODIGODESCRICAO character varying (500),
		DOTACAOINICIAL NUMERIC, 
		AUTORIZADO NUMERIC, 
		EMPENHADO NUMERIC, 
		LIQUIDADO NUMERIC, 
		DESPESAEXECUTADA NUMERIC, 
		PAGO NUMERIC, 
		RPPAGO NUMERIC
	);
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
--Script de criação da view view_loa_final_clean, com as diretrizes propostas
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_final_clean AS
SELECT
	*
FROM
  infere.tb_loa_final
  WHERE 	
 	despesaexecutada <> 0  
  and
    despesaexecutada <> 'NaN'
  and
  	gndcodigo = '4'
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
--  *******        **        ********    ********     *******       ** 
-- /**////**      ****      **//////    **//////     **/////**     *** 
-- /**   /**     **//**    /**         /**          **     //**   //** 
-- /*******     **  //**   /*********  /*********  /**      /**    /** 
-- /**////     **********  ////////**  ////////**  /**      /**    /** 
-- /**        /**//////**        /**         /**   //**     **     /** 
-- /**        /**     /**  ********    ********    //*******      ****
-- //         //      //   ////////    ////////      ///////      ////
---------------------------------------------------------------------------------------------------------------------------
--Passo 1: Executa uma verificação nos digitos especificados no script com as variaveis modapliccodigodescricao e 
--subelementodespesacodigodescricao se os valores forem verdadeiros, será atribuido um valor a uma nova variavel 
--uf_elemento, se os valores forem falsos será atribuido o valor ND a variavel uf_elemento.
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_1 AS
select 
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
	   case when (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '01') THEN 'AC'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '03') THEN 'AC'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '05') THEN 'AM'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '04') THEN 'AP'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '07') THEN 'BA'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '09') THEN 'CE'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '11') THEN 'DF'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '21') THEN 'MS'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '19') THEN 'MT'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '39') THEN 'RS'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '47') THEN 'SE'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '15') THEN 'GO'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '33') THEN 'PI'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '27') THEN 'PB'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '25') THEN 'PA'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '29') THEN 'PR'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '42') THEN 'RR'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '23') THEN 'MG'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '22') THEN 'MG'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '35') THEN 'RJ'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '37') THEN 'RN'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '45') THEN 'SP'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '43') THEN 'SC'
	  	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '13') THEN 'ES'	  	  	   	   
	 	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '31') THEN 'PE'
	 	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '48') THEN 'TO'
	 	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '17') THEN 'MA'
	 	   WHEN (codigo_referencia >= '30') and (codigo_referencia <= '49') and (codigo_uf = '41') THEN 'RO'
	 	   else 'ND'
	   end as uf_elemento
from (select id,
ano,
localidadeuf,
regiao,
orgaocodigodescricao,
orgaosuperiorcodigodescricao,
ug,
uguf,
uocodigodescricaoajustado,
funcaocodigodescricao,
subfuncaocodigodescricao,
programacodigodescricao,
funcional,
acaocodigodescricaoajustado,
subtitulocodigodescricao,
esferacodigodescricao,
gndcodigo,
modapliccodigodescricao,
elementodespesacodigodescricao,
subelementodespesacodigodescricao,
dotacaoinicial,
autorizado,
empenhado,
liquidado,
despesaexecutada,
pago,
rppago,  
substring(modapliccodigodescricao, 1, 2) as codigo_referencia, 
substring(subelementodespesacodigodescricao, 7, 2) as codigo_uf
from infere.view_loa_final_clean)view_loa_passo_1;
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
--  *******        **        ********    ********     *******      **** 
-- /**////**      ****      **//////    **//////     **/////**    */// *
-- /**   /**     **//**    /**         /**          **     //**/      /*
-- /*******     **  //**   /*********  /*********  /**      /**     *** 
-- /**////     **********  ////////**  ////////**  /**      /**    *//  
-- /**        /**//////**         /**         /**  //**     **    *     
-- /**        /**     /**   ********    ********    //*******    /******
-- //         //      //   ////////    ////////      ///////     ////// 
---------------------------------------------------------------------------------------------------------------------------
--Passo 2: Executa uma verificação nos digitos especificados no script com a variavel uguf. 
--Se os valores forem verdadeiros, será atribuido um valor a uma nova variavel 
--estado, se os valores forem falsos será atribuido o valor ND a variavel estado.
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_2 AS
select 
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
case
   		   WHEN uguf_1_1 = '0' THEN 'SP'
	  	   WHEN uguf_1_1 = '1' THEN 'SP'
	  	   WHEN uguf_1_1 = '3' THEN 'MG'
	  	   WHEN uguf_1_1 = '9' THEN 'RS'
	  	   WHEN uguf_1_2 = '29' THEN 'ES'
	  	   WHEN uguf_1_2 = '49' THEN 'SE'
	  	   WHEN uguf_1_2 = '64' THEN 'PI'
	  	   WHEN uguf_1_2 = '65' THEN 'MA'
	  	   WHEN uguf_1_2 = '77' THEN 'TO'
	  	   WHEN uguf_1_2 = '79' THEN 'MS'
		   WHEN uguf_1_2 = '57' THEN 'AL'
		   WHEN uguf_1_2 = '58' THEN 'PB'
		   WHEN uguf_1_2 = '59' THEN 'RN'
	  	   WHEN (uguf_1_2 = '78') and (uguf_1_3 <> '789') THEN 'GO'
	  	   WHEN (uguf_1_2 >= '20') and (uguf_1_2 <= '28') THEN 'RJ'
	  	   WHEN (uguf_1_2 >= '40') and (uguf_1_2 <= '48') THEN 'BA'
	  	   WHEN (uguf_1_2 >= '80') and (uguf_1_2 <= '87') THEN 'PR'
	  	   WHEN (uguf_1_2 >= '88') and (uguf_1_2 <= '89') THEN 'SC'
	  	   WHEN (uguf_1_2 >= '50') and (uguf_1_2 <= '56') THEN 'PE'
	  	   WHEN (uguf_1_2 >= '60') and (uguf_1_2 <= '63') THEN 'CE'
	  	   WHEN (uguf_1_2 >= '66') and (uguf_1_2 <= '68') THEN 'PA'
	  	   WHEN (uguf_1_3 >= '690') and (uguf_1_3 <= '692') THEN 'AM'
	  	   WHEN (uguf_1_3 >= '694') and (uguf_1_3 <= '698') THEN 'AM'
	  	   WHEN (uguf_1_3 >= '700') and (uguf_1_3 <= '727') THEN 'DF'
	  	   WHEN (uguf_1_3 >= '730') and (uguf_1_3 <= '736') THEN 'DF'
	  	   WHEN (uguf_1_3 >= '768') and (uguf_1_3 <= '769') THEN 'RO'	  	  	   	   
	 	   WHEN (uguf_1_3 >= '789') and (uguf_1_3 <= '789') THEN 'RO'
	 	   WHEN (uguf_1_3 >= '728') and (uguf_1_3 <= '728') THEN 'GO'
	 	   WHEN (uguf_1_3 >= '737') and (uguf_1_3 <= '767') THEN 'GO'
	 	   else 'ND'
	   end as estado
from (select id,
ano,
localidadeuf,
regiao,
orgaocodigodescricao,
orgaosuperiorcodigodescricao,
ug,
uguf,
uocodigodescricaoajustado,
funcaocodigodescricao,
subfuncaocodigodescricao,
programacodigodescricao,
funcional,
acaocodigodescricaoajustado,
subtitulocodigodescricao,
esferacodigodescricao,
gndcodigo,
modapliccodigodescricao,
elementodespesacodigodescricao,
subelementodespesacodigodescricao,
dotacaoinicial,
autorizado,
empenhado,
liquidado,
despesaexecutada,
pago,
rppago,  
uf_elemento,
substring(uguf, 1, 1) as uguf_1_1, 
substring(uguf, 1, 2) as uguf_1_2, 
substring(uguf, 1, 3) as uguf_1_3
from infere.view_loa_passo_1)view_loa_passo_2;
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
-- *******        **        ********    ********     *******      **** 
-- /**////**      ****      **//////    **//////     **/////**    */// *
-- /**   /**     **//**    /**         /**          **     //**  /    /*
-- /*******     **  //**   /*********  /*********  /**      /**     *** 
-- /**////     **********  ////////**  ////////**  /**      /**    /// *
-- /**        /**//////**         /**         /**  //**     **    *   /*
-- /**        /**     /**   ********    ********    //*******   / **** 
-- //         //      //   ////////    ////////      ///////      ////  
---------------------------------------------------------------------------------------------------------------------------
--Passo 3: Executa outra checagem na variavel uguf, digitos de 1 a 7. Visando encontrar as linhas correlacionadas ao
--exterior. Se for verdadeiro será atribuido o valor EX a nova variavel estado_ex, se for falso será reutilizado
--o valor da variavel estado.
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_3 AS
select 
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
estado,
case
	 	   when (uguf_1_1 > '1') and (uguf_1_6 <= '110011') then 'EX'
	 	   when (ug_1_6 > '120091') and (uguf_1_1 <= '1') then 'EX'
   	       when (ug_1_6 = '110111') and (uguf_1_1 = '1') then 'EX'
   	       when (ug_1_6 > '110111') and (ug_1_4 = '2402') and (ug_1_6 > '110111') and (ug_1_4 = '2400') then 'EX'
		   else estado
	   end as estado_ex
from (select id,
ano,
localidadeuf,
regiao,
orgaocodigodescricao,
orgaosuperiorcodigodescricao,
ug,
uguf,
uocodigodescricaoajustado,
funcaocodigodescricao,
subfuncaocodigodescricao,
programacodigodescricao,
funcional,
acaocodigodescricaoajustado,
subtitulocodigodescricao,
esferacodigodescricao,
gndcodigo,
modapliccodigodescricao,
elementodespesacodigodescricao,
subelementodespesacodigodescricao,
dotacaoinicial,
autorizado,
empenhado,
liquidado,
despesaexecutada,
pago,
rppago,  
uf_elemento,
estado,
substring(uguf, 1, 1) as uguf_1_1, 
substring(uguf, 1, 2) as uguf_1_2, 
substring(uguf, 1, 3) as uguf_1_3,
substring(uguf, 1, 6) as uguf_1_6,
substring(uguf, 1, 7) as uguf_1_7,
substring(ug, 1, 6) as ug_1_6,
substring(ug, 1, 4) as ug_1_4
from infere.view_loa_passo_2)view_loa_passo_3;
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
-- *******        **        ********    ********     *******        ** 
-- /**////**      ****      **//////    **//////     **/////**      */* 
-- /**   /**     **//**    /**         /**          **     //**    * /* 
-- /*******     **  //**   /*********  /*********  /**      /**   ******
-- /**////     **********  ////////**  ////////**  /**      /**  /////* 
-- /**        /**//////**         /**         /**  //**     **       /* 
-- /**        /**     /**   ********    ********    //*******        /* 
-- //         //      //   ////////    ////////      ///////         / 
---------------------------------------------------------------------------------------------------------------------------
--Passo 4: Executa um LEFT JOIN da tabela tb_loa_cep com a view anterior view_loa_passo_3. Compara os valores contidos
--na variavel uguf correspondentes a codigos CEP e atribui UFs ao fim.
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_4 AS
select 
vlp.id, 
vlp.ano, 
vlp.localidadeuf, 
vlp.regiao, 
vlp.orgaocodigodescricao, 
vlp.orgaosuperiorcodigodescricao, 
vlp.ug, 
vlp.uguf, 
vlp.uocodigodescricaoajustado, 
vlp.funcaocodigodescricao, 
vlp.subfuncaocodigodescricao, 
vlp.programacodigodescricao, 
vlp.funcional, 
vlp.acaocodigodescricaoajustado, 
vlp.subtitulocodigodescricao, 
vlp.esferacodigodescricao, 
vlp.gndcodigo, 
vlp.modapliccodigodescricao, 
vlp.elementodespesacodigodescricao, 
vlp.subelementodespesacodigodescricao, 
vlp.dotacaoinicial, 
vlp.autorizado, 
vlp.empenhado, 
vlp.liquidado, 
vlp.despesaexecutada, 
vlp.pago, 
vlp.rppago, 
vlp.uf_elemento,
vlp.estado_ex,
tlc.uf_ug 
FROM  infere.view_loa_passo_3 vlp 
LEFT JOIN infere.tb_loa_cep tlc
ON vlp.uguf = tlc.uguf;
---------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------
-- *******        **        ********    ********     *******     ******
-- /**////**      ****      **//////    **//////     **/////**   /*//// 
-- /**   /**     **//**    /**         /**          **     //**  /***** 
-- /*******     **  //**   /*********  /*********  /**      /**  ///// *
-- /**////     **********  ////////**  ////////**  /**      /**       /*
-- /**        /**//////**         /**         /**  //**     **    *   /*
-- /**        /**     /**   ********    ********    //*******    / **** 
-- //         //      //   ////////    ////////      ///////      ////  
---------------------------------------------------------------------------------------------------------------------------
--Passo 5: Executa uma checagem de strings nas variaveis subtitulocodigodescricao, acaocodigodescricaoajustado, 
--uocodigodescricaoajustado. Se for verdadeiro será atribuido valores a uma nova 
--variavel estado_ex, se for falso será reutilizado a variavel estado_ex. 
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_5 AS
select
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
estado_ex,
uf_ug,
		case
	 	   when subtitulocodigodescricao like '%TECNOLOGIA NUCLEAR DA MARINHA%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%IMPLANTAÇÃO DE ESTALEIRO E BASE NAVAL PARA CONSTRUÇÃO E MANUTENÇÃO DE SUBMARINOS CONVENCIONAIS E NUCLEARES%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%CONSTRUÇÃO DE SUBMARINO DE PROPULSÃO NUCLEAR%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%APOIO À REALIZAÇÃO DE GRANDES EVENTOS%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%CONSTRUÇÃO DE SUBMARINOS CONVENCIONAIS%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%APRESTAMENTO DA MARINHA%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%DESENVOLVIMENTO TECNOLÓGICO DA MARINHA%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%CAPACITAÇÃO PROFISSIONAL DA MARINHA%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%OPERACIONALIZACAO DAS ACOES DE SEGURANCA PUBLICA PARA AS OLIMPIADAS E PARAOLIMPIADAS RIO 2016%' THEN 'RJ'
	  	   when acaocodigodescricaoajustado like '%PARTICIPAÇÃO BRASILEIRA EM MISSÕES DE PAZ%' THEN 'EX'
	  	   when acaocodigodescricaoajustado like '%IMUNOBIOLÓGICOS E INSUMOS PARA PREVENÇÃO E CONTROLE DE DOENÇAS%' THEN 'EX'
	  	   when acaocodigodescricaoajustado like '%APOIO LOGÍSTICO À PESQUISA CIENTÍFICA NA ANTÁRTICA%' THEN 'EX'
	  	   when acaocodigodescricaoajustado like '%%LONDRES%' THEN 'EX'
	  	   when uocodigodescricaoajustado like '%SUPERINTENDÊNCIA DA ZONA FRANCA DE MANAUS - SUFRAMA%' THEN 'EX'
	 	   when (subtitulocodigodescricao like '%EXTERIOR%') and (estado_ex = 'ND') THEN 'EX'
	 	   else estado_ex
	   	   end as ufis
from (select 
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
estado_ex,
uf_ug 
from infere.view_loa_passo_4)view_loa_passo_5;
---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
-- *******        **        ********    ********     *******          **** 
-- /**////**      ****      **//////    **//////     **/////**        */// *
-- /**   /**     **//**    /**         /**          **     //**      /*   / 
-- /*******     **  //**   /*********  /*********  /**      /**      /***** 
-- /**////     **********  ////////**  ////////**  /**      /**      /*/// *
-- /**        /**//////**         /**         /**  //**     **       /*   /*
-- /**        /**     /**   ********    ********    //*******        / **** 
-- //         //      //   ////////    ////////      ///////          //// 
---------------------------------------------------------------------------------------------------------------------------
--Passo 6: Executa uma comparação com parametros entre as variaveis criadas nos passos anteriores, atribuindo ou ignorando
--certas variaveis apartir de extensivas analises e atribui o valor das que passarem pela checagem em uma nova variavel
--uf_nova
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_6 AS
select
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
uf_ug,
ufis,
case 
	when localidadeuf in ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO','EX') then localidadeuf
	when ufis in ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO','EX') then ufis
	when (uf_elemento <> 'ND') and (codigo_uf >= '30') and (codigo_uf <= '49') then uf_elemento
	when (uf_ug  IS NOT NULL) and (ufis = 'ND') and (uf_elemento = 'ND')  then uf_ug
	else ufis
	end as uf_nova
from (select id,
ano,
localidadeuf,
regiao,
orgaocodigodescricao,
orgaosuperiorcodigodescricao,
ug,
uguf,
uocodigodescricaoajustado,
funcaocodigodescricao,
subfuncaocodigodescricao,
programacodigodescricao,
funcional,
acaocodigodescricaoajustado,
subtitulocodigodescricao,
esferacodigodescricao,
gndcodigo,
modapliccodigodescricao,
elementodespesacodigodescricao,
subelementodespesacodigodescricao,
dotacaoinicial,
autorizado,
empenhado,
liquidado,
despesaexecutada,
pago,
rppago,  
uf_elemento,
uf_ug,
ufis,
substring(subelementodespesacodigodescricao, 7, 2) as codigo_uf
from infere.view_loa_passo_5 )view_loa_passo_6;
---------------------------------------------------------------------------------------------------------------------------

 
---------------------------------------------------------------------------------------------------------------------------

--  *******        **        ********    ********     *******     ******      
-- /**////**      ****      **//////    **//////     **/////**   //////*      
-- /**   /**     **//**    /**         /**          **     //**       /*      
-- /*******     **  //**   /*********  /*********  /**      /**       *       
-- /**////     **********  ////////**  ////////**  /**      /**      *        
-- /**        /**//////**         /**         /**  //**     **      *         
-- /**        /**     /**   ********    ********    //*******      *          
-- //         //      //   ////////    ////////      ///////      /      
---------------------------------------------------------------------------------------------------------------------------
--Passo 7: Verifica a variavel uf_nova e as UFs contidas para descobrir a região do brasil a quais pertencem.
---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW infere.view_loa_passo_7 AS
select
id, 
ano, 
localidadeuf, 
regiao, 
orgaocodigodescricao, 
orgaosuperiorcodigodescricao, 
ug, 
uguf, 
uocodigodescricaoajustado, 
funcaocodigodescricao, 
subfuncaocodigodescricao, 
programacodigodescricao, 
funcional, 
acaocodigodescricaoajustado, 
subtitulocodigodescricao, 
esferacodigodescricao, 
gndcodigo, 
modapliccodigodescricao, 
elementodespesacodigodescricao, 
subelementodespesacodigodescricao, 
dotacaoinicial, 
autorizado, 
empenhado, 
liquidado, 
despesaexecutada, 
pago, 
rppago, 
uf_elemento,
ufis,
uf_ug,
uf_nova,
case
	WHEN localidadeuf in ('PB','PE','CE','RN','PI','BA','AL','SE','MA') THEN 'NE'
	  	   WHEN uf_nova in ('ES','MG','RJ','SP') THEN 'SE'
	  	   WHEN uf_nova in ('AC','AP','AM','PA','RO','RR','TO') THEN 'N'
	  	   WHEN uf_nova in ('PR','SC','RS') THEN 'S'
		   WHEN uf_nova in ('DF','MT','GO','MS') THEN 'CO'
		   when acaocodigodescricaoajustado like '%MELHORAMENTOS NO CANAL DE NAVEGAÇÃO DA HIDROVIA DOS RIOS PARANÁ E PARAGUAI%' THEN 'CO'
   	  	   when acaocodigodescricaoajustado like '%DESENVOLVIMENTO E IMPLEMENTAÇÃO DO SISTEMA DE GERENCIAMENTO DA AMAZÔNIA AZUL (SISGAAZ)%' THEN 'NO'
	  	   when acaocodigodescricaoajustado like '%MANUTENÇÃO DO SISTEMA DE PROTEÇÃO DA AMAZÔNIA - SIPAM%' THEN 'NO'
	  	   when (subtitulocodigodescricao like '%MATOPIBA%') and (uf_nova = 'ND') THEN 'NE'
	  	   when (acaocodigodescricaoajustado like '%RIO SAO FRANCISCO%') and (uf_nova = 'ND') THEN 'NE'
	  	   when (subtitulocodigodescricao like '%CENTRO-OESTE%') and  (uf_nova = 'ND') THEN 'CO' 
	  	   when (uocodigodescricaoajustado like '%CENTRO-OESTE%') and  (uf_nova = 'ND') THEN 'CO'
	  	   when (uocodigodescricaoajustado like '%VALES DO SÃO FRANCISCO E DO PARNAÍBA%') and  (uf_nova = 'ND') THEN 'NE'
	  	   when (uocodigodescricaoajustado like '%RIO SAO FRANCISCO%') and (uf_nova not in ('SE','BA','CE','PB','PE','PI','RN','NE') ) THEN 'NE'
	 	   when (acaocodigodescricaoajustado like '%RIO SAO FRANCISCO%') and (uf_nova not in ('SE','BA','CE','PB','PE','PI','RN','NE') ) THEN 'NE'
	 	   when (uocodigodescricaoajustado like '%AMAZÔNIA%') and (uf_nova = 'ND') THEN 'NE'
	 	   else 'ND'
	       end as reg_nova
   from(select id,
   ano,
localidadeuf,
regiao,
orgaocodigodescricao,
orgaosuperiorcodigodescricao,
ug,
uguf,
uocodigodescricaoajustado,
funcaocodigodescricao,
subfuncaocodigodescricao,
programacodigodescricao,
funcional,
acaocodigodescricaoajustado,
subtitulocodigodescricao,
esferacodigodescricao,
gndcodigo,
modapliccodigodescricao,
elementodespesacodigodescricao,
subelementodespesacodigodescricao,
dotacaoinicial,
autorizado,
empenhado,
liquidado,
despesaexecutada,
pago,
rppago,  
uf_elemento,
ufis,
uf_ug,
uf_nova
from infere.view_loa_passo_6)view_loa_passo_7;
---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
--Passo 8 DF(ver questão de tratar UG.UF como CEP - deu problema no SQL): Verifica se variavel Localidade.UF for DF ou NA mantem como NA 
---------------------------------------------------------------------------------------------------------------------------