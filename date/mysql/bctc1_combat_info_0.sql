-- 当前的对局战斗信息bctc1_
CREATE VIEW bctc6_combat_info_0 AS
SELECT ci.*
FROM bctc6_combat_info ci
JOIN (
    SELECT MAX(timestamp) AS latest_map_time
    FROM bctc6_historical_layers
) hl ON ci.action_time >= hl.latest_map_time;

-- 上局的对局战斗信息bctc1_
CREATE VIEW bctc6_combat_info_1 AS
SELECT ci.*
FROM bctc6_combat_info ci
JOIN (
    SELECT 
        MIN(timestamp) AS start_time,
        MAX(timestamp) AS end_time
    FROM (
        SELECT 
            timestamp,
            ROW_NUMBER() OVER (ORDER BY timestamp DESC) AS rn
        FROM bctc6_historical_layers
    ) AS ranked_times
    WHERE rn BETWEEN 1 AND 2
) hl ON ci.action_time BETWEEN hl.start_time AND hl.end_time;

-- 上上局的对局战斗信息bctc1_
CREATE VIEW bctc6_combat_info_2 AS
SELECT ci.*
FROM bctc6_combat_info ci
JOIN (
    SELECT 
        MIN(timestamp) AS start_time,
        MAX(timestamp) AS end_time
    FROM (
        SELECT 
            timestamp,
            ROW_NUMBER() OVER (ORDER BY timestamp DESC) AS rn
        FROM bctc6_historical_layers
    ) AS ranked_times
    WHERE rn BETWEEN 2 AND 3
) hl ON ci.action_time BETWEEN hl.start_time AND hl.end_time;

