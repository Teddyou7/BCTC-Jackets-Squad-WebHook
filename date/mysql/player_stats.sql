CREATE TABLE player_stats (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    steamid VARCHAR(255) NOT NULL COMMENT 'SteamID',
    eosid VARCHAR(255) NOT NULL COMMENT 'EosID',
    nickname VARCHAR(255) COMMENT '昵称',
    playtime INT COMMENT '游戏时长（分钟）',
    login_ip VARCHAR(255) COMMENT '登录IP',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '时间'
) COMMENT='玩家统计信息表';
