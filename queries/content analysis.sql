SELECT 
    contentId,
    contentTitle,
    url,
    views,
    cpt,
    revenue,
    rpt,
    avgTimeSpent,
    totalTimeSpent,
    purchases

FROM 
(
	SELECT
      contentId,
      MAX(CASE WHEN eventType = 'VIEW' AND eventLocation = 'PAGE' THEN url ELSE '' END) as url,
      MAX(contentTitle) as contentTitle,
    	SUM(
        	CASE
           		WHEN eventType = 'VIEW'
            	AND eventLocation = 'PAGE' THEN 1
            	ELSE 0
        	END
   		) as views,
    	SUM(
      		CASE
          		WHEN eventType = 'VIEW'
          		AND eventLocation = 'PAYWALL' THEN 1
          		ELSE 0
      		END
  		) as paywallViews,
    SUM(
        CASE
            WHEN eventType = 'PURCHASE' THEN 1
            ELSE 0
        END
    ) * 1000 / (paywallViews+1) as cpt,
    SUM(
        CASE
            WHEN eventType = 'PURCHASE'
            THEN clientPrice
            ELSE 0
        END
    ) as revenue,

    round(revenue*1000/(views+1),2) as rpt,

    SUM(activeTimeSpent) as totalTimeSpent,
    totalTimeSpent/views as avgTimeSpent,
    SUM(
        CASE
            WHEN eventType = 'PURCHASE' THEN 1
            ELSE 0
        END
    ) as purchases
    FROM
    ${TABLE}
    WHERE
    	clientId = '${clientId}'
    	AND toDate(TIMESTAMPADD(MINUTE,330,createdAt)) >= toDate('2023-11-01')
    	AND toDate(TIMESTAMPADD(MINUTE,330,createdAt)) < toDate('2023-12-01')  
    	AND eventType IN ['VIEW','PURCHASE']
    	AND contentId != ''
    GROUP BY
    	contentId
    ORDER BY
    	rpt desc
    LIMIT 20
)