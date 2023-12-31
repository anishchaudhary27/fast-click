SELECT
 	toDate((TIMESTAMPADD(MINUTE, 330, createdAt))) as eventDate,
    uniqCombined(anonId) as total,
    uniqCombined(userId) as registered,
    total - registered as anonymous
FROM 
    v0
WHERE
    clientId = '${clientId}'
    AND eventType = 'VIEW'
    AND createdAt >= toDate('2023-11-01')
    AND createdAt < toDate('2023-12-01')
GROUP BY 
	eventDate
SETTINGS 
    min_bytes_to_use_direct_io=1