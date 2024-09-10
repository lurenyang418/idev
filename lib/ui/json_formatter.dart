import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:highlight/languages/json.dart';
import 'package:idev/utils/utils.dart';

class FormatterPage extends StatefulWidget {
  const FormatterPage({super.key});

  @override
  State<FormatterPage> createState() => _FormatterPageState();
}

const List<String> list = <String>[
  '2s',
  '4s',
];

const demoText = '''{
  "user": {
    "id": 123,
    "name": "Tom",
    "email": "tom@jerry.com"
  }
}''';

class _FormatterPageState extends State<FormatterPage> {
  final _codeTextCtl = CodeController(
    text: demoText,
    language: json,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _codeTextCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JSON 格式化")),
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          _buildMenu(),
          Expanded(
            child: _buildCodeEditor(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {
              _codeTextCtl.fullText = demoText;
            },
            icon: const Icon(Icons.texture_outlined),
            label: const Text('示例'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(40, 130, 101, 101),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.format_indent_increase),
                TextButton.icon(
                  onPressed: () {
                    if (_codeTextCtl.fullText == "") return;
                    var indent = IndentType.getTypeByTitle('2space');
                    _codeTextCtl.fullText =
                        jsonFormatWithIndent(_codeTextCtl.fullText, indent);
                  },
                  label: const Text("2space"),
                  // icon: const Icon(Icons.for),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (_codeTextCtl.fullText == "") return;
                    var indent = IndentType.getTypeByTitle('4space');
                    _codeTextCtl.fullText =
                        jsonFormatWithIndent(_codeTextCtl.fullText, indent);
                  },
                  label: const Text("4space"),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _codeTextCtl.fullText = jsonFlat(_codeTextCtl.fullText);
            },
            icon: const Icon(Icons.compress_outlined),
            label: const Text('压缩'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.copy_all),
            onPressed: () {
              if (_codeTextCtl.text == "") {
                return;
              }
              BotToast.showText(
                  text: "已复制", duration: const Duration(milliseconds: 400));
              Clipboard.setData(ClipboardData(text: _codeTextCtl.text));
            },
            label: const Text('复制'),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeEditor() {
    return Scaffold(
      body: CodeTheme(
          data: CodeThemeData(styles: tomorrowTheme),
          child: SingleChildScrollView(
              child: CodeField(
            minLines: 10,
            maxLines: 50,
            controller: _codeTextCtl,
          ))),
    );
  }
}
