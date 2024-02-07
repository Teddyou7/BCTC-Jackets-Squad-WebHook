CREATE TABLE combat_info (
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
