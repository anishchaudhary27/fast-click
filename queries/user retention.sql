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
        	  MIN(toDate(createdAt)) as firstActivityDate
          FROM 
        	  ${TABLE}
          WHERE 
        	  clientId = '${clientId}'
        	  AND eventType in ['VIEW']
        	  AND userId != '' 
          GROUP BY 
        	  userId
	      )  firstActivityTbl
	      INNER JOIN (
          SELECT toDate(createdAt) as createdAt, userId FROM ${TABLE} 
          WHERE 
            clientId = '${clientId}'
        	  AND eventType in ['VIEW']
            AND userId != ''
          GROUP By userId, createdAt
        ) ev2
        ON 
          firstActivityTbl.userId = ev2.userId
    	  WHERE 
            firstActivityDate <= toDateTime('2023-12-27')
            AND firstActivityDate >= toDateTime('2023-11-26')
    	    AND DATEDIFF('day',firstActivityDate, toDate(createdAt)) <= 30
      ) grouped_days
      GROUP BY day_diff
      ORDER BY day_diffs asc