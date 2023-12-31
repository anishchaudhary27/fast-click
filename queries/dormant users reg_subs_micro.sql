WITH t as 
(
SELECT 
        MAX(createdAt) as lastActivity,
        userId,
        SUM(CASE WHEN eventType = 'PURCHASE' AND purchaseType = 'SUBSCRIPTION' THEN 1 ELSE 0 END) as subscriber,
    	SUM(CASE WHEN eventType = 'PURCHASE' AND (purchaseType = 'CONTENT' OR purchaseType = 'PASS') THEN 1 ELSE 0 END) as micropayer
    FROM
        ${TABLE}
    WHERE 
        clientId = '${clientId}'
        AND userId != ''
        AND eventType in ['VIEW', 'PURCHASE']
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
	AND subscriber = 0
	AND micropayer = 0
GROUP BY date  