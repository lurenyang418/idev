import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';

class DropFilePage extends StatefulWidget {
  const DropFilePage({super.key});

  @override
  State<DropFilePage> createState() => _DropFilePageState();
}

class _DropFilePageState extends State<DropFilePage> {
  XFile? file;

  void _dragDone(DropDoneDetails detail) {
    setState(() {
      file = detail.files.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: _dragDone,
      child: file == null ? uploadImage() : ViewImage(file!),
    );
  }

  Widget uploadImage() {
    return Center(
      child: Container(
        width: 400,
        height: 200,
        decoration: const BoxDecoration(
          color:  Color.fromARGB(255, 43, 44, 44),
          borderRadius:  BorderRadius.all(Radius.circular(24)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 60, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              '拖动图片打开',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewImage extends StatelessWidget {
  const ViewImage(this.file, {super.key});

  final XFile file;

  Future<Uint8List> _getFile(XFile file) async {
    var bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: FutureBuilder(
          future: _getFile(file),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return ImageDecorated(
                child: Image.memory(
                  snapshot.data,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              );
            }
            return Text('图片加载出错了: ${snapshot.error}');
          },
        ),
      ),
    );
  }
}

class ImageDecorated extends StatelessWidget {
  const ImageDecorated({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black26),
        ],
      ),
      child: child,
    );
  }
}