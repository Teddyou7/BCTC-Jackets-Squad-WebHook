#组织标签，此标签控制玩家数据
db_tag="bctc"
#服务器表前缀，此表用来记录战斗数据
db_server="bctc4_"

#数据库连接地址
db_host="cd-cdb-pr2i0saw.sql.tencentcdb.com"
#数据库连接端口
db_port="63876"
#数据库连接用户
db_user="teddyou"
#数据库连接密码
db_password="Jym^e5oY_S6n"

#数据库database
db_name="jackets"

export MYSQL_PWD=$db_password

mysql_cmd="mysql -h $db_host -P $db_port -u $db_user -D $db_name -s -N -e "
