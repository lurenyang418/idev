import 'package:network_info_plus/network_info_plus.dart';

Future<String> getLocalIp() async {
  final info = NetworkInfo();
  final wifiIp = await info.getWifiIP();
  return wifiIp?? "未找到网络信息";
}