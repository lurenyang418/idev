import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
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
  ];

  String md5Str = "";
  String bcryptStr = "";

  final TextEditingController _ctl = TextEditingController();

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
      });
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
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
            children: hashTabs
                .map((Tab e) => Center(
                      child: _buildItem(e.text as String),
                    ))
                .toList()),
      ),
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
              Text(md5Str, textAlign: TextAlign.left,),
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
              Text(bcryptStr,  textAlign: TextAlign.left,),
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
        ],
      ),
    );
  }
}
