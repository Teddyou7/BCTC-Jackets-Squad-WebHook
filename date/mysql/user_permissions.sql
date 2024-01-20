CREATE TABLE user_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    steamid VARCHAR(255) NOT NULL COMMENT 'SteamID',
    organization_id INT NOT NULL COMMENT '组织ID',
    permission_operation_timestamp TIMESTAMP NOT NULL COMMENT '权限操作时间戳',
    is_increase TINYINT NOT NULL CHECK (is_increase IN (0, 1)) COMMENT '1=增加，0=减少',
    permission_expiration_timestamp TIMESTAMP NOT NULL COMMENT '权限到期时间戳',
    permission_name ENUM('RESERVE', 'SIGNVIP') NOT NULL COMMENT '权限名称',
    note TEXT COMMENT '备注信息',
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间'
) COMMENT='用户权限管理表';
