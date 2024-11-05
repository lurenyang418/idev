import 'package:flutter/material.dart';
import 'package:idev/utils/net_util.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var wifiIP = "";

  @override
  void initState() {
    super.initState();
    _getLocalIp();
  }

  Future<void> _getLocalIp() async {
    var ip = await getLocalIp();
    setState(() {
      wifiIP = ip!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("IP地址：$wifiIP"),
    );
  }
}
