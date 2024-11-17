SELECT 
    COUNT(DISTINCT CASE WHEN is_fraud = '1' THEN trans_num END) AS QTD_TRANSACOES_FRAUDE,
    COUNT(DISTINCT CASE WHEN is_fraud = '0' THEN trans_num END) AS QTD_TRANSACOES_SEM_IRREGULARIDADE,
    COUNT(DISTINCT  CASE WHEN is_fraud in ('0','1') THEN trans_num END) AS QTD_TRANSACOES,
    ROUND(
        CAST(
            COUNT(DISTINCT CASE WHEN is_fraud = '1' THEN trans_num END) AS FLOAT) /
            NULLIF(COUNT(DISTINCT  CASE WHEN is_fraud in ('0','1') THEN trans_num END), 0) * 100 
        , 2) AS PROPORCAO_FRAUDE,
    merchant AS ESTABELECIMENTO_DA_COMPRA
FROM 
    df_inicial
GROUP BY 
    merchant
ORDER BY 
  ROUND(
        CAST(
            COUNT(DISTINCT CASE WHEN is_fraud = '1' THEN trans_num END) AS FLOAT) /
            NULLIF(COUNT(DISTINCT  CASE WHEN is_fraud in ('0','1') THEN trans_num END), 0) * 100 
        , 2)   DESC;