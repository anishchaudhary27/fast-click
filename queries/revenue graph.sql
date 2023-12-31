SELECT
	toDate((TIMESTAMPADD(MINUTE, 330, createdAt))) as eventDate,
    toString(purchaseType) as purchaseType,
    SUM(
        CASE
            WHEN (TIMESTAMPADD(MINUTE, 330, createdAt)) >= toDateTime('2023-10-01')
            AND (TIMESTAMPADD(MINUTE, 330, createdAt)) < toDateTime('2023-11-01') 
            THEN clientPrice
            ELSE 0
        END
    ) as lastPeriod,
    SUM(
        CASE
            WHEN 
                (TIMESTAMPADD(MINUTE, 330, createdAt)) >= toDateTime('2023-11-01')
                AND (TIMESTAMPADD(MINUTE, 330, createdAt)) < toDateTime('2023-12-01')  
            THEN clientPrice
            ELSE 0
        END
    ) as currentPeriod
FROM
    ${TABLE}
WHERE
    eventType = 'PURCHASE'
    AND clientId = '${clientId}'
    AND (TIMESTAMPADD(MINUTE, 330, createdAt)) >= toDateTime('2023-10-01')
    AND (TIMESTAMPADD(MINUTE, 330, createdAt)) < toDateTime('2023-12-01')  
GROUP BY
    purchaseType, eventDate
SETTINGS 
    min_bytes_to_use_direct_io=1