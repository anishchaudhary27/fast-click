SELECT
    toString(purchaseType) as purchaseType,
     COUNT(
         DISTINCT(
             CASE
                 WHEN createdAt  >= now() - INTERVAL 30 DAY
                 THEN userId ELSE null
             END
         )
     ) as currentPeriod,
     COUNT(
         DISTINCT(
             CASE
                 WHEN createdAt  >= now() - INTERVAL 60 DAY AND createdAt  <= now() - INTERVAL 30 DAY
                 THEN userId ELSE null
             END
         )
     ) as lastPeriod
 FROM 
 ${TABLE}
 WHERE
 eventType = 'PURCHASE' AND clientId = '${clientId}'
 AND createdAt  >= now() - INTERVAL 60 DAY
 GROUP BY 
    purchaseType
 SETTINGS 
    min_bytes_to_use_direct_io=1