CREATE TABLE bctc6_combat_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    operator_steamid VARCHAR(255) NOT NULL COMMENT '操作者Steam ID',
    operator_nickname VARCHAR(255) NOT NULL COMMENT '操作者昵称',
    action ENUM('revived', 'ActualDamage', 'OnPossess', 'OnUnPossess', 'Die', 'Wound') NOT NULL COMMENT '战斗动作类型，包括revived, ActualDamage, OnPossess, OnUnPossess, Die, Wound',
    target_steamid VARCHAR(255) COMMENT '被操作者Steam ID',
    target_nickname VARCHAR(255) COMMENT '被操作者昵称',
    weapon VARCHAR(255) COMMENT '使用的武器',
    health INT DEFAULT 0 COMMENT '生命值',
    action_time DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '发生的时间'
) COMMENT='战斗信息表';


CREATE TABLE bctc6_historical_layers (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    map_name VARCHAR(255) NOT NULL COMMENT '地图名称',
    timestamp DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '记录时间'
) COMMENT='历史图层表';

CREATE TABLE bctc6_squad_creation_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    leader_steamid VARCHAR(255) NOT NULL COMMENT '小队长的Steam ID',
    leader_nickname VARCHAR(255) COMMENT '小队长昵称',
    squad_name VARCHAR(255) COMMENT '小队名称',
    team_id INT COMMENT 'Team ID',
    squad_id INT NOT NULL COMMENT 'Squad ID',
    creation_time DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间'
) COMMENT='小队创建信息表';

CREATE TABLE bctc6_player_stats (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    steamid VARCHAR(255) NOT NULL COMMENT 'SteamID',
    eosid VARCHAR(255) NOT NULL COMMENT 'EosID',
    nickname VARCHAR(255) COMMENT '昵称',
    playtime INT COMMENT '游戏时长（分钟）',
    login_ip VARCHAR(255) COMMENT '登录IP',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '时间'
) COMMENT='玩家统计信息表';

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '序号',
    steamid VARCHAR(255) NOT NULL COMMENT 'steamid',
    organization_tag VARCHAR(255) NOT NULL COMMENT '组织标签',
    transaction_amount DECIMAL(10, 2) NOT NULL COMMENT '交易金额',
    current_balance DECIMAL(10, 2) NOT NULL COMMENT '当前余额',
    type TINYINT NOT NULL CHECK (type IN (0, 1)) COMMENT '类型，0=支出，1=收入',
    note TEXT COMMENT '备注',
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '交易时间'
) COMMENT='交易数据表';
