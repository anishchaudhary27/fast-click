SELECT 
    subId,
    price,
    sortOrder,
    userPercentage,
    revenuePercentage
    FROM
    (
    SELECT 
        subId,
        max(clientPrice) as price,
        'REVENUE' as sortOrder, 
        COUNT(DISTINCT CASE WHEN eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' THEN userId ELSE null END) as subscribers,
        SUM(CASE WHEN eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND clientPrice >=0 THEN clientPrice ELSE 0 END) as revenue,
        (SELECT SUM(clientPrice) as revenue from ${TABLE} WHERE clientId = '${clientId}' AND eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND createdAt >= now() - INTERVAL 30 DAY ) as totalSubRevenue,
        (SELECT COUNT(DISTINCT(userId)) as revenue from ${TABLE} WHERE clientId = '${clientId}' AND eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND createdAt >= now() - INTERVAL 30 DAY) as totalSubscribers,
        subscribers*100/totalSubscribers as userPercentage,
        revenue*100/totalSubRevenue as revenuePercentage
    
    FROM
        ${TABLE}
    WHERE
        clientId = '${clientId}' AND tierId != '' AND createdAt >= now() - INTERVAL 30 DAY -- Can be updated to include a date filter, also specify clientId h3GetRes0Indexes
    GROUP BY
        subId
    ORDER BY
        revenue desc
    LIMIT 1
     SETTINGS 
    min_bytes_to_use_direct_io=1
    UNION ALL
    
    
    SELECT 
        subId,
        max(clientPrice) as price,
        'USERS' as sortOrder, 
        COUNT(DISTINCT CASE WHEN eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' THEN userId ELSE null END) as subscribers,
        SUM(CASE WHEN eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND clientPrice >=0 THEN clientPrice ELSE 0 END) as revenue,
        (SELECT SUM(clientPrice) as revenue from ${TABLE} WHERE clientId = '${clientId}' AND eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND createdAt >= now() - INTERVAL 30 DAY ) as totalSubRevenue,
        (SELECT COUNT(DISTINCT(userId)) as revenue from ${TABLE} WHERE clientId = '${clientId}' AND eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' AND createdAt >= now() - INTERVAL 30 DAY) as totalSubscribers,
        subscribers*100/totalSubscribers as userPercentage,
        revenue*100/totalSubRevenue as revenuePercentage
    
    FROM
        ${TABLE}
    WHERE
        clientId = '${clientId}' AND tierId != ''  AND createdAt >= now() - INTERVAL 30 DAY -- Can be updated to include a date filter, also specify clientId h3GetRes0Indexes
    GROUP BY
        subId
    ORDER BY
        subscribers desc
    LIMIT 1
     SETTINGS 
    min_bytes_to_use_direct_io=1
    )