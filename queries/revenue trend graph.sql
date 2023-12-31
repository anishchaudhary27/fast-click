SELECT 
        toDate(TIMESTAMPADD(MINUTE,330,createdAt)) as eventDate,
        SUM(clientPrice) as revenue
    FROM    
        ${TABLE}
    WHERE 
    clientId = '${clientId}' 
    AND eventType = 'PURCHASE' 
    AND eventDate >= toDate('2023-10-01') 
    AND eventDate <= toDate('2023-12-01') 
    GROUP BY eventDate
    ORDER BY eventDate desc