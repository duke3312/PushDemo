<?php
$deviceToken = '5ceaabf03803164b8738af8ccd53a50f18ee22028da35865b5f1d7c07b66155f';
$body['aps'] = array('type' => 1, 'sound'=>'default', 'alert' => '茜茜正在向你发送视频邀请...', 'name' => '茜茜', 'badge' => 1);
// $body['aps'] = array('type' => 2, $body=>'default', 'alert' => '【未接通话】', 'name' => 'XX', 'badge' => 1);
//把数组数据转换为json数据
$payload = json_encode($body);
echo strlen($payload),"\r\n";
 $ctx = stream_context_create();
// $pem = dirname(__FILE__) .'/'.'ck.pem';
 $pass = 'newpush';  //证书密码
$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $pass);
$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err, $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
if (!$fp) {
    print "Failed to connect $err $errstr\n";
    return;
}
else {
   print "Connection OK\n<br/>";
}
// send message
$msg = chr(0) . pack("n",32) . pack('H*', str_replace(' ', '', $deviceToken)) . pack("n",strlen($payload)) . $payload;
print "Sending message :" . $payload . "\n";  
fwrite($fp, $msg);
fclose($fp);
/*
127
Connection OK
<br/>Sending message :{"aps":{"type":1,"":"default","alert":"\u6b63\u5728\u5411\u4f60\u53d1\u9001\u89c6\u9891\u9080\u8bf7...","name":"XX","badge":1}}
*/
