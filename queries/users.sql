SELECT
    uniqCombined(CASE WHEN createdAt < toDate('2023-11-01') THEN anonId ELSE NULL END) as lastTotalUsers,
    uniqCombined(CASE WHEN createdAt >= toDate('2023-11-01') THEN anonId ELSE NULL END) as currTotalUsers,
    uniqCombined(CASE WHEN createdAt < toDate('2023-11-01') THEN userId ELSE NULL END) as lastRegUsers,
    uniqCombined(CASE WHEN createdAt >= toDate('2023-11-01') THEN userId ELSE NULL END) as currRegUsers
FROM 
    v0
WHERE
    clientId = '${clientId}'
    AND eventType = 'VIEW'
    AND createdAt >= toDate('2023-10-01')
    AND createdAt < toDate('2023-12-01')
SETTINGS 
    min_bytes_to_use_direct_io=1