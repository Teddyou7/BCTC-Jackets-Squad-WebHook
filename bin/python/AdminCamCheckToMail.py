import smtplib
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

# 获取脚本参数
operator_id = sys.argv[1]
to_addr = sys.argv[2]
config_path = sys.argv[3]
csv_file = sys.argv[4]

# 动态加载邮件配置
sys.path.append(config_path.rsplit('/', 1)[0])
from mail_config import email_config

# 创建邮件消息
msg = MIMEMultipart()
msg['From'] = email_config['from_addr']
msg['To'] = to_addr
msg['Subject'] = f"检查到{operator_id}使用摄像头后仍进行战斗"

# 设置邮件正文
body = f"您好，\n检查到{operator_id}在使用摄像头后仍进行战斗，请查看附件了解详细信息。\n\n本技术由冲锋号社区提供"
msg.attach(MIMEText(body, 'plain'))

# 处理附件
filename = csv_file.split("/")[-1]

# 读取CSV文件内容，替换tab为逗号，转换为UTF-8
with open(csv_file, "r", encoding='utf-8') as file:
    csv_content = file.read().replace('\t', ',')
    
# 将CSV内容转换为字节流，并附加到邮件中
part = MIMEBase('application', 'octet-stream')
#part.set_payload(csv_content.encode('utf-8'))
part.set_payload(csv_content.encode('gbk'))
encoders.encode_base64(part)
part.add_header('Content-Disposition', f"attachment; filename={filename}")

msg.attach(part)

# 发送邮件
try:
    server = smtplib.SMTP(email_config['smtp_server'], email_config['smtp_port'])
    server.starttls()
    server.login(email_config['username'], email_config['password'])
    text = msg.as_string()
    server.sendmail(email_config['from_addr'], to_addr, text)
    server.quit()
    print("邮件已成功发送")
except Exception as e:
    print(f"邮件发送失败: {e}")
