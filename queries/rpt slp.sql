SELECT 
	SUM(
		CASE WHEN 
			eventType = 'PURCHASE' 
			AND landingPageId != ''
			AND paywallId = ''
			AND createdAt >= toDate('2023-11-27')
		THEN clientPrice ELSE 0 END
	) as revenue,
	SUM(
		CASE WHEN 
			eventType = 'PURCHASE' 
			AND landingPageId != ''
			AND paywallId = ''
			AND createdAt < toDate('2023-11-27')
		THEN clientPrice ELSE 0 END
	) as lastMonthRevenue,
	uniqCombined(
		CASE WHEN 
			eventType = 'VIEW' 
			AND eventLocation = 'SLP'
			AND paywallId = ''
			AND createdAt >= toDate('2023-11-27')
		THEN anonId ELSE NULL END
	) as viewers,
	uniqCombined(
		CASE WHEN 
			eventType = 'VIEW' 
			AND paywallId = ''
			AND eventLocation = 'SLP'
			AND createdAt < toDate('2023-11-27')
		THEN anonId ELSE NULL END
	) as lastMonthViewers
FROM ${TABLE}
WHERE 
	clientId = '${clientId}'
	AND eventType in ['PURCHASE', 'VIEW']
	AND createdAt < toDate('2023-12-27')
	AND createdAt >= toDate('2023-10-27')
 SETTINGS 
    min_bytes_to_use_direct_io=1