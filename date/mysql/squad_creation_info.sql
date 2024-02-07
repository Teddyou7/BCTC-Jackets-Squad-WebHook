CREATE TABLE squad_creation_info (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    leader_steamid VARCHAR(255) NOT NULL COMMENT '小队长的Steam ID',
    leader_nickname VARCHAR(255) COMMENT '小队长昵称',
    squad_name VARCHAR(255) COMMENT '小队名称',
    team_id INT COMMENT 'Team ID',
    squad_id INT NOT NULL COMMENT 'Squad ID',
    creation_time DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间'
) COMMENT='小队创建信息表';
