INSTALL spatial;
LOAD spatial;

SELECT 
    CAST(TRY_CAST(is_fraud AS BIGINT) AS BIGINT) AS TARGET_FRAUDE,
    
    -- CLASSIFICAÇÃO DE RISCO PARA A OCUPAÇÃO DO CLIENTE
job EMPREGO,

    -- CLASSIFICAÇÃO DE RISCO PARA A CATEGORIA DA COMPRA 
    CASE 
        WHEN C.PROPORCAO_FRAUDE <= 5 THEN 'BAIXO RISCO'
        ELSE category 
    END AS RISCO_CATEGORIA_COMPRA,

    -- CLASSIFICAÇÃO DE RISCO PARA O ESTABELECIMENTO DA COMPRA
    CASE 
        WHEN D.PROPORCAO_FRAUDE <= 20 THEN 'BAIXO RISCO'
        ELSE merchant
    END AS RISCO_ESTABELECIMENTO,

    -- CLASSIFICAÇÃO PARA A CIDADE DO CLIENTE
    CASE 
        WHEN E.PROPORCAO_FRAUDE <= 20 THEN 'BAIXO RISCO'
        ELSE  city 
    END AS RISCO_CIDADE,

    -- CLASSIFICAÇÃO PARA O ESTADO DO CLIENTE
    CASE 
        WHEN F.PROPORCAO_FRAUDE <= 9.6 THEN 'BAIXO RISCO'
        ELSE state
    END AS RISCO_ESTADO,

    CAST(SUBSTR(trans_date_trans_time, -4, -2) AS BIGINT) AS HORA_DA_TRANSACAO,
    strptime(substr(trans_date_trans_time, 1, 10), '%d-%m-%Y') AS DATA_DA_TRANSACAO,
    dayofweek(strptime(substr(trans_date_trans_time, 1, 10), '%d-%m-%Y')) AS DIA_DA_SEMANA,
    ST_DISTANCE(ST_POINT(long,lat),ST_POINT(merch_long,merch_lat)) DISTANCIA,
    city_pop AS POPULACAO_CIDADE, amt as VALOR_TRANSACAO
FROM df_inicial A 
LEFT JOIN df_ocupacao_do_comprador B ON A.job = B.OCUPACAO_DO_CLIENTE
LEFT JOIN df_categoria_da_compra C ON A.category = C.CATEGORIA_DA_COMPRA
LEFT JOIN df_analise_por_estabelecimento D ON A.merchant = D.ESTABELECIMENTO_DA_COMPRA
LEFT JOIN df_analise_por_cidade_do_cliente E ON A.city = E.CIDADE_DO_CLIENTE
LEFT JOIN df_analise_por_estado_do_cliente F ON A.state = F.ESTADO_DO_CLIENTE