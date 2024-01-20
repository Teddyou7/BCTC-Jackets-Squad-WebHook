<?php
include 'parseConfig.php';

$response = ['error' => false, 'message' => ''];


$fieldMappings = [
    'ServerIP' => '服务器IP',
	'RconPort' => 'Rcon 端口号',
	'RconPasswd' => 'Rcon 密码',
	'Org' => '组织标识',
	'PointsName' => '积分名称',
	'PointsActivationReservedLow' => '积分兑换预留位最低值',
	'GrantReservedWelfareLow' => '发福利最低发放限制',
	'PointsToReserved' => '积分兑换预留位比例',
	'SignMod' => '用户签到模式',
	'VIPSignRecharge' => '预留位签到加时秒数',
	'SignSessionDurationMin' => '签到在线时间限制',
	'HandOutRedEnvelopesStart' => '是否开启发红包的功能',
	'HandOutRedEnvelopesLow' => '发红包单个红包最低值',
	'SnatchingRedEnvelopesMod' => '抢得红包处理方式',
	'RedEnvelopesBecomeDue' => '红包过期时间',
	'RedEnvelopesCooldown' => '每次抢红包间隔时间',
	'PlayerServerSpeakerPoints' => '小喇叭消耗积分',
	'PlayerGroupSpeakerPoints' => '大喇叭消耗积分',
	'PlayerGroupSpeakerIf' => '是否上传大喇叭联动',
	'NiuZiChangDuIf' => '是否开启牛子长度娱乐功能',
	'NiuZiChangDuTimeTmp' => '牛子长度留存分钟数',
	'IfWeatherBroadcast' => '是否开启预留位IP定位气象播报',
	'IfWeatherBroadcastCity' => '定位广播是否精确到地市',
	'ServerVipNname' => 'VIP名称',
	'WeatherBroadcastServerNname' => '气象广播时的服务器名称',
	'CreatSquad_BroadcastMODE' => '小队创建广播模式',
	'SLSteamDuration' => '模式3不符合指定时长广播阈值',
	'BCTC_TrainingMatchIf' => '开局跳过并解除所有限制',
	'BCTC_TrainingActualDamageIf' => '击杀检测及炮手位检查自动踢出',
	'BCTC_TrainingTurretIf' => '炮手位检查自动踢出',
	'BCTC_TrainingChangeLayer' => '玩家身份自助切换地图',
	'BCTC_TrainingChangeLayerCDTime' => '玩家身份自助切换地图冷却时间',
	'BCTC_LogSquadGameEventsIf' => '结束时时间倍数控制',
	'EndMatchTimeMultiplier' => '对局结束时刻的时间倍数',
    // 添加其他字段的映射...
];


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    foreach ($_POST as $key => $value) {
        if (preg_match('/\s/', $value)) {
            // 使用字段映射来生成更友好的错误消息
			$fieldName = isset($fieldMappings[$key]) ? $fieldMappings[$key] : $key;
            $response = ['error' => true, 'message' => "\n输入内容禁止包含空格\n以下选项包含空格\n\n{$fieldName}"];
            break;
        }
    }
    // 检查提交的每个字段是否被设置且不是空字符串
    foreach ($_POST as $key => $value) {
        if (!isset($value) || $value === '') {
			$fieldName = isset($fieldMappings[$key]) ? $fieldMappings[$key] : $key;
            $response = ['error' => true, 'message' => "\n以下选项未被填写：\n\n{$fieldName}"];
            break;
        }
    }
    // 如果没有发现错误，则继续处理
    if (!$response['error']) {
        $originalConfig = parse_ini_file_custom("/PathWaitingForCompletion/nginx/html/function_config.sh");

        // 更新配置值
        foreach ($_POST as $key => $value) {
            $originalConfig[$key] = '"' .  $value . '"';
        }

        // 添加额外的配置
        $additionalConfig = [
            "Admins_User_S" => '"${WBHKHOME}/date/BasicData/Admins_S"',
            "Admins_User_A" => '"${WBHKHOME}/date/BasicData/Admins_A"',
            // ...更多配置
        ];

        // 合并配置
        //$finalConfig = array_merge($originalConfig, $additionalConfig);
        $finalConfig = array_merge($originalConfig);

        // 将配置写回文件
        $fileContent = "";
        foreach ($finalConfig as $key => $value) {
            $fileContent .= $key . "=" . $value . "\n";
        }

        file_put_contents("/Jackets/config/zg/cfg.sh", $fileContent);
        $response['message'] = '\n除训练场相关配置需要管理员重启，其他配置即时生效。';
    }

    // 返回 JSON 响应
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}


function parse_ini_file_custom($file) {
    $result = [];
    if (file_exists($file)) {
        $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                // 跳过注释行
                continue;
            }
            $parts = explode('=', $line, 2);
            if (count($parts) === 2) {
                $result[trim($parts[0])] = trim($parts[1]);
            }
        }
    }
    return $result;
}

?>
