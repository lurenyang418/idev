import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HashPage extends StatefulWidget {
  const HashPage({super.key});

  @override
  State<HashPage> createState() => _HashPageState();
}

class _HashPageState extends State<HashPage> {
  final List<Tab> hashTabs = [
    const Tab(
      text: "hash",
    ),
    const Tab(
      text: "jwt",
    )
  ];

  String md5Str = "";
  String bcryptStr = "";
  String md5AndBcryptStr = "";

  final TextEditingController _ctl = TextEditingController();

  final TextEditingController _jwtLeftCtl = TextEditingController();
  final TextEditingController _infoCtl = TextEditingController();
  final TextEditingController _headCtl = TextEditingController();
  final TextEditingController _bodyCtl = TextEditingController();
  final TextEditingController _keyCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctl.addListener(() {
      setState(() {
        if (_ctl.text.trim() == "") {
          md5Str = "";
          bcryptStr = "";
          return;
        }

        md5Str = md5.convert(utf8.encode(_ctl.text)).toString();
        bcryptStr = BCrypt.hashpw(_ctl.text, BCrypt.gensalt());
        md5AndBcryptStr = BCrypt.hashpw(md5Str, BCrypt.gensalt());
      });
    });
    _jwtLeftCtl.addListener(() {
      print(_jwtLeftCtl.text);
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    _jwtLeftCtl.dispose();
    _infoCtl.dispose();
    _headCtl.dispose();
    _bodyCtl.dispose();
    _keyCtl.dispose();
    super.dispose();
  }

  void handleDecodeJWT() {
    final token = _jwtLeftCtl.text.trim();
    if (token == "") {
      return;
    }
    _headCtl.text = "";
    _bodyCtl.text = "";
    _infoCtl.text = "";
    try {
      final jwt = JWT.decode(token);
      _headCtl.text = const JsonEncoder.withIndent("  ").convert(jwt.header);
      _bodyCtl.text = const JsonEncoder.withIndent("  ").convert(jwt.payload);
    } catch (e) {
      _infoCtl.text = e.toString();
    }
  }

  // TODO
  void handleEncodeJWT() {}

  void handleVerifyJWT() {
    final key = _keyCtl.text.trim();
    if (key == "") {
      _infoCtl.text = "请提供密钥";
      return;
    }
    final token = _jwtLeftCtl.text.trim();
    try {
      JWT.verify(token, SecretKey(key));
      _infoCtl.text = "有效";
    } on JWTExpiredException {
      final jwt = JWT.decode(token);
      Map<String, dynamic> payload = jwt.payload;
      final expiration = payload["exp"];
      final d = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(expiration * 1000));
      _infoCtl.text = "已过期. 过期时长 $d";
    } on JWTInvalidException {
      _infoCtl.text = "签名无效";
    } catch (e) {
      _infoCtl.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: hashTabs.length,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: hashTabs,
              isScrollable: false,
              indicatorColor: Colors.red,
            ),
          ),
          body: TabBarView(
            children: [_buildItem("hash"), _buildJwt("jwt")],
          )),
    );
  }

  Widget _buildItem(String text) {
    return SizedBox(
      width: 650,
      child: Column(
        children: [
          TextField(
            controller: _ctl,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Text(
                md5Str,
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  if (md5Str == "") {
                    return;
                  }
                  BotToast.showText(
                      text: "已复制", duration: const Duration(milliseconds: 400));
                  Clipboard.setData(ClipboardData(text: md5Str));
                },
                icon: const Icon(Icons.copy),
                label: const Text("md5"),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                bcryptStr,
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  if (bcryptStr == "") {
                    return;
                  }
                  BotToast.showText(
                      text: "已复制", duration: const Duration(milliseconds: 400));
                  Clipboard.setData(ClipboardData(text: bcryptStr));
                },
                icon: const Icon(Icons.copy_sharp),
                label: const Text("bcrypt"),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                md5AndBcryptStr,
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  if (md5AndBcryptStr == "") {
                    return;
                  }
                  BotToast.showText(
                      text: "已复制", duration: const Duration(milliseconds: 400));
                  Clipboard.setData(ClipboardData(text: md5AndBcryptStr));
                },
                icon: const Icon(Icons.copy_sharp),
                label: const Text("md5 & bcrypt"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJwt(String s) {
    return SizedBox(
      height: 600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            constraints: const BoxConstraints(
              maxHeight: 500,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(color: const Color.fromARGB(255, 196, 195, 195)),
            ),
            child: Column(
              children: [
                const Text(
                  "编码区域",
                  style: TextStyle(fontSize: 24),
                ),
                const Divider(height: 2),
                TextField(
                  controller: _jwtLeftCtl,
                  minLines: 5,
                  maxLines: 10,
                ),
                const Spacer(),
                TextField(
                  controller: _infoCtl,
                  readOnly: true,
                  minLines: 1,
                  maxLines: 7,
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 500,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Text(
                  "操作",
                  style: TextStyle(fontSize: 24),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: handleDecodeJWT,
                  icon: const Icon(Icons.arrow_right_outlined),
                  label: const Text("解码"),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_left_outlined),
                  label: const Text("编码"),
                ),
                TextButton.icon(
                  onPressed: handleVerifyJWT,
                  icon: const Icon(Icons.check),
                  label: const Text("校验"),
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: 350,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(color: const Color.fromARGB(255, 196, 195, 195)),
            ),
            child: Column(
              children: [
                const Text(
                  "解码区域",
                  style: TextStyle(fontSize: 24),
                ),
                const Divider(height: 2),
                const Text("头部"),
                TextField(
                  controller: _headCtl,
                  minLines: 3,
                  maxLines: 5,
                ),
                const Text("载荷"),
                TextField(
                  controller: _bodyCtl,
                  minLines: 5,
                  maxLines: 5,
                ),
                const Text("密钥"),
                TextField(
                  controller: _keyCtl,
                  minLines: 1,
                  maxLines: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
