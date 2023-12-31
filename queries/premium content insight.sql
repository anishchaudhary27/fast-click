SELECT
                    uniqCombined(
                      CASE
                            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') THEN anonId
                            ELSE NULL
                        END
                    ) as totalUsers,
                    SUM (
                        CASE
                            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') THEN 1 
                            ELSE 0
                        END
                    ) as totalViews
                FROM
                    ${TABLE}
                WHERE
                    clientId = '${clientId}'
                    AND eventType = 'VIEW'
                    AND createdAt  >= toDateTime('2023-11-01')
                    AND createdAt  <= toDateTime('2023-12-01')