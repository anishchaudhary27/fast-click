SELECT 
	toDate((TIMESTAMPADD(MINUTE, 330, createdAt))) as eventDate,
	uniqCombined(
		CASE WHEN 
			(eventType = 'PURCHASE' 
			OR (eventType  = 'VALIDATION' AND eventLocation = 'CONTENT_FLOW_OTP' AND paywallType = 'REGWALL'))
			AND paywallId != ''
		THEN userId ELSE NULL END
	) as converted,
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
		THEN anonId ELSE NULL END
	) as users
FROM ${TABLE}
WHERE 
	clientId = '${clientId}'
	AND eventType in ['PURCHASE', 'VIEW', 'VALIDATION']
	AND createdAt < toDate('2023-12-27')
	AND createdAt >= toDate('2023-11-27')
GROUP BY eventDate
SETTINGS 
	min_bytes_to_use_direct_io=1