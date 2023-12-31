SELECT 
	      COUNT(*) as num_users, 
	      groupUniqArray(day_diff)[1] as day_diffs
	    FROM ( 
        SELECT 
          userId, 
          DATEDIFF('day', firstActivityDate, toDate(createdAt)) as day_diff
	      FROM (
          SELECT 
        	  userId, 
        	  firstActivityDate
          FROM
      		(
      			SELECT 
              		userId,
              		MIN(toDate(createdAt)) as firstActivityDate,
              		SUM(CASE WHEN purchaseType = 'SUBSCRIPTION' THEN 1 ELSE 0 END) as purchases,
              		clientId
              	FROM 
              		${TABLE} e2 
              	WHERE 
              		clientId = '${clientId}' 
              		AND eventType in ['VIEW', 'PURCHASE']
              		AND userId != ''
              	GROUP BY userId, clientId
      		)
      		WHERE purchases > 0
	      )  firstActivityTbl
	      INNER JOIN (
            SELECT toDate(createdAt) as createdAt, userId FROM ${TABLE} WHERE clientId = '${clientId}' AND eventType = 'VIEW' AND userId != '' GROUP By userId, createdAt
        ) ev2
        ON 
          firstActivityTbl.userId = ev2.userId
    	  WHERE 
            firstActivityDate <= toDateTime('2023-12-27')
            AND firstActivityDate >= toDateTime('2023-11-26')
          AND DATEDIFF('day',firstActivityDate, toDate(createdAt)) <= 30
          AND DATEDIFF('day',firstActivityDate, toDate(createdAt)) >= 0
      ) grouped_days
      GROUP BY day_diff
      ORDER BY day_diffs asc