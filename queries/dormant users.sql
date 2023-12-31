WITH t as 
(
SELECT 
        MAX(createdAt) as lastActivity,
        userId
    FROM
        ${TABLE}
    WHERE 
        clientId = '${clientId}'
        AND userId != ''
        AND eventType = 'VIEW'
    GROUP BY 
        userId 
)
SELECT 
	SUM(1) as total, 
	toDate(lastActivity + INTERVAL 30 DAY) as date 
FROM t 
WHERE 
	lastActivity >= NOW() - INTERVAL 60 DAY 
	AND lastActivity <= NOW() - INTERVAL 30 DAY 
GROUP BY date   