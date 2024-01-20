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
