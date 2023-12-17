import http.server
import socketserver
import json
import os
import sys
import urllib.parse

# 获取配置文件路径
def get_config_file():
    default_config_file = os.path.splitext(__file__)[0] + '.cfg'
    # 检查是否有命令行参数
    if len(sys.argv) > 1:
        return sys.argv[1]  # 使用命令行参数指定的配置文件
    return default_config_file  # 默认配置文件

# 读取配置文件
def load_config(config_file):
    with open(config_file, 'r', encoding='utf-8') as file:
        return json.load(file)

# HTTP 请求处理器
class RequestHandler(http.server.SimpleHTTPRequestHandler):
    def version_string(self):
        """返回自定义服务器版本信息"""
        return "Apache"

    def do_GET(self):
        config = load_config(get_config_file())
        # 验证请求路径
        parsed_path = urllib.parse.urlparse(self.path)
        request_path = parsed_path.path

        if request_path in [path['url'] for path in config['paths']]:
            for path in config['paths']:
                if request_path == path['url']:
                    try:
                        with open(path['file'], 'rb') as file:
                            self.send_response(200)
                            self.send_header('Content-Type', 'text/plain; charset=utf-8')
                            self.send_header('Content-Security-Policy', "default-src 'none';")
                            self.send_header('X-Content-Type-Options', 'nosniff')
                            self.end_headers()
                            self.wfile.write(file.read())
                            return
                    except FileNotFoundError:
                        self.log_error("File not found: %s", path['file'])
                        self.send_error(404, "File Not Found")
                        return
        else:
            self.log_error("Invalid access attempt: %s", self.path)
            self.send_error(403, "Access Forbidden")
            return

# 主函数
def run(server_class=http.server.HTTPServer, handler_class=RequestHandler):
    config_file = get_config_file()
    config = load_config(config_file)
    port = config['port']
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f"Starting httpd on port {port} using config file '{config_file}'")
    print("You can specify a different config file by providing it as an argument.")
    httpd.serve_forever()

if __name__ == '__main__':
    run()

