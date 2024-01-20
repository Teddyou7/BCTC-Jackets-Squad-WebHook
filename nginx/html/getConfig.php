<?php
function parse_ini_file_custom($file) {
    $result = [];
    if (file_exists($file)) {
        $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                continue;  // 跳过注释行
            }
            $parts = explode('=', $line, 2);
            if (count($parts) === 2) {
                $key = trim($parts[0]);
                $value = trim($parts[1]);
                // 移除双引号
                $value = trim($value, '"');
                $result[$key] = $value;
            }
        }
    }
    return $result;
}

$config = parse_ini_file_custom("/PathWaitingForCompletion/nginx/html/function_config.sh");
echo json_encode($config);
?>

