SELECT
    SUM(revenue) as revenue,
    SUM(lastMonthRevenue) as lastMonthRevenue,
    repeatOrNot
    FROM
    (
        SELECT
            userId,
            SUM(CASE WHEN clientPrice>=0 AND createdAt >= toDate('2023-11-01') THEN clientPrice ELSE 0 END) as revenue,
            SUM(CASE WHEN clientPrice>=0 AND createdAt < toDate('2023-11-01') THEN clientPrice ELSE 0 END) as lastMonthRevenue
        FROM
            ${TABLE}
        WHERE
            clientId = '${clientId}' 
            AND createdAt >= toDateTime('2023-10-01') 
            AND createdAt < toDateTime('2023-12-01')
            AND eventType = 'PURCHASE'
        GROUP BY
            userId
    ) t1
    LEFT JOIN (
        SELECT
            userId,
            totalPurchases > 1 as repeatOrNot
        FROM
            (
                SELECT
                    userId,
                    COUNT(*) as totalPurchases
                FROM
                    ${TABLE}
                WHERE
                    clientId = '${clientId}' 
                    AND eventType = 'PURCHASE'
                GROUP BY
                    userId
            )
    ) t2 ON t1.userId = t2.userId
    GROUP BY
    repeatOrNot
    SETTINGS 
    min_bytes_to_use_direct_io=1