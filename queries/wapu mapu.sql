SELECT
    COUNT(DISTINCT (
        CASE 
            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') AND createdAt >= now() - INTERVAL 7 DAY AND userId != '' THEN userId ELSE null END
    )) as wapuCurrentWeek,
    COUNT(DISTINCT (
        CASE 
            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') AND createdAt >= now() - INTERVAL 14 DAY AND userId != '' AND createdAt <= now() - INTERVAL 7 DAY THEN userId ELSE null END
    )) as wapuLastWeek,
        COUNT(DISTINCT (
        CASE 
            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') AND createdAt >= now() - INTERVAL 30 DAY AND userId != '' THEN userId ELSE null END
    )) as mapuCurrentMonth,
    COUNT(DISTINCT (
        CASE 
            WHEN (accessType = 'SUB' OR accessType = 'CONTENT' OR accessType = 'PASS') AND createdAt >= now() - INTERVAL 60 DAY AND userId != '' AND createdAt <= now() - INTERVAL 30 DAY THEN userId ELSE null END
    )) as mapuLastMonth

FROM 
    ${TABLE}
WHERE 
    clientId = '${clientId}'
    AND eventType = 'VIEW'
    AND eventLocation = 'PAGE'
    AND createdAt >= now() - INTERVAL 60 DAY
SETTINGS 
    min_bytes_to_use_direct_io=1