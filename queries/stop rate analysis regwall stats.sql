SELECT 
	uniqCombined(
		CASE WHEN 
			eventType  = 'VALIDATION' 
			AND eventLocation = 'CONTENT_FLOW_OTP'
			AND createdAt >= toDate('2023-11-27')
		THEN userId ELSE NULL END
	) as converted,
	uniqCombined(
		CASE WHEN 
			eventType  = 'VALIDATION' 
			AND eventLocation = 'CONTENT_FLOW_OTP'
			AND createdAt < toDate('2023-11-27')
		THEN userId ELSE NULL END
	) as lastMonthConverted,
	uniqCombined(
		CASE WHEN 
			eventType = 'VIEW' 
			AND eventLocation = 'PAYWALL'
			AND createdAt >= toDate('2023-11-27')
		THEN anonId ELSE NULL END
	) as views,
	uniqCombined(
		CASE WHEN 
			eventType = 'VIEW' 
			AND eventLocation = 'PAYWALL'
			AND createdAt < toDate('2023-11-27')
		THEN anonId ELSE NULL END
	) as lastMonthViewers
FROM ${TABLE}
WHERE 
	clientId = '${clientId}'
	AND eventType in ['VIEW', 'VALIDATION']
	AND paywallType = 'REGWALL'
	AND createdAt < toDate('2023-12-27')
	AND createdAt >= toDate('2023-10-27')
 SETTINGS 
    min_bytes_to_use_direct_io=1