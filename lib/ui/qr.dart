import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @protected
  late QrImage qrImage;

  final _qrTextCtl = TextEditingController();

  String data = "123";

  @override
  void initState() {
    super.initState();
    _qrTextCtl.addListener(() {
      setState(() {
        data = _qrTextCtl.text;
      });
    });
  }

  @override
  void dispose() {
    _qrTextCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("二维码")),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 256,
              child: TextField(
                controller: _qrTextCtl,
                maxLines: 5,
                minLines: 1,
                maxLength: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 256,
                width: 256,
                child: PrettyQrView.data(
                  data: data,
                  decoration: const PrettyQrDecoration(),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton.icon(
              onPressed: () async {
                var d = await getApplicationDocumentsDirectory();
                final qrImage = QrImage(QrCode.fromData(
                    data: data, errorCorrectLevel: QrErrorCorrectLevel.H));
                final bytes = await qrImage.toImageAsBytes(size: 256);
                final filePath = '${d.path}/qr.png';
                final file = await File(filePath).create();
                await file.writeAsBytes(bytes!.buffer.asUint8List());

                BotToast.showText(
                    text: "已保存至$filePath",
                    duration: const Duration(seconds: 10));
                launchUrl(Uri.file(d.path));
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text("保存"),
            )
          ],
        ),
      ),
    );
  }
}
