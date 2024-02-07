create database Squad_打胶室_1 character set utf8mb4;

-- 创建战斗信息视图表并按时间降序排序
CREATE VIEW Squad_打胶室_1.战斗信息 AS
SELECT
    id AS `序号`,
    operator_steamid AS `操作者Steam ID`,
    operator_nickname AS `操作者昵称`,
    action AS `战斗动作类型`,
    target_steamid AS `被操作者Steam ID`,
    target_nickname AS `被操作者昵称`,
    weapon AS `使用的武器`,
    health AS `生命值`,
    action_time AS `发生的时间`
FROM jackets.hj1_combat_info
ORDER BY action_time DESC;

-- 创建历史图层视图表并按时间降序排序
CREATE VIEW Squad_打胶室_1.历史图层 AS
SELECT
    id AS `序号`,
    map_name AS `地图名称`,
    timestamp AS `记录时间`
FROM jackets.hj1_historical_layers
ORDER BY timestamp DESC;

-- 创建小队创建信息视图表并按时间降序排序
CREATE VIEW Squad_打胶室_1.小队创建信息 AS
SELECT
    id AS `序号`,
    leader_steamid AS `小队长的Steam ID`,
    leader_nickname AS `小队长昵称`,
    squad_name AS `小队名称`,
    team_id AS `Team ID`,
    squad_id AS `Squad ID`,
    creation_time AS `创建时间`
FROM jackets.hj1_squad_creation_info
ORDER BY creation_time DESC;

-- 创建玩家统计信息视图表并按时间降序排序
CREATE VIEW Squad_打胶室_1.玩家统计信息 AS
SELECT
    id AS `序号`,
    steamid AS `SteamID`,
    eosid AS `EosID`,
    nickname AS `昵称`,
    playtime AS `游戏时长_分钟`,
    login_ip AS `登录IP`,
    timestamp AS `时间`
FROM jackets.hj1_player_stats
ORDER BY timestamp DESC;

-- 创建新用户并为其分配查询权限
CREATE USER 'hj1'@'%' IDENTIFIED BY 'xf7NZ0LlDswF';

-- 为新用户授予查询权限
GRANT SELECT ON Squad_打胶室_1.* TO 'hj1'@'%';

-- 需要替换的内容
-- Squad_打胶室_1 --> 数据库名称
-- hj1 --> 数据表前缀
