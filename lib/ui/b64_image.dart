import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class B64Image extends StatefulWidget {
  const B64Image({super.key});

  @override
  State<B64Image> createState() => _B64ImageState();
}

class _B64ImageState extends State<B64Image> {
  final _b64Ctl = TextEditingController();

  Uint8List? _bytes;
  String? _error;

  // 把输入的 base64 字符串处理成 Uint8List，并更新状态
  void _decode() {
    final raw = _b64Ctl.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _bytes = null;
        _error = null;
      });
      return;
    }

    try {
      // 去掉 data:image/xxx;base64, 前缀
      final base64Str = raw.startsWith('data:image')
          ? raw.split(',').last
          : raw;
      final decoded = base64Decode(base64Str);
      setState(() {
        _bytes = decoded;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _bytes = null;
        _error = 'Base64 解码失败：${e.toString()}';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base64 → Image')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _b64Ctl,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: '输入 data:image/...;base64,xxxx 或纯 base64',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _b64Ctl.clear();
                    _decode();
                  },
                ),
              ),
              onChanged: (_) => _decode(),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_bytes != null)
              Image.memory(
                _bytes!,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                    size: 100, color: Colors.red),
              )
            else
              const Center(
                child: Icon(Icons.image_search,
                    size: 100, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}