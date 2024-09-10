import 'dart:convert';

enum IndentType {
  twoSpaces("2space", "  "),
  fourSpaces("4space", "    "),
  oneTab("1t", "\t");

  const IndentType(this.name, this.value);

  final String name;

  // final String value;
  final String value; static IndentType getTypeByTitle(String title) => 
    IndentType.values.firstWhere((activity)=> activity.name == title);
}

String jsonFormatWithIndent(String jsonString, IndentType indent) {
  Map<String, dynamic> res;
  try {
    res = jsonDecode(jsonString);
    var encoder = JsonEncoder.withIndent(indent.value);
    var json =  encoder.convert(res); 
    return json;
  } catch (e) {
    return e.toString();
  }
}

String jsonFlat(String jsonString) {
  Map<String, dynamic> res;
  try {
    res = jsonDecode(jsonString);
    var json = jsonEncode(res);
    return json;
  } catch (e) {
    return e.toString();
  }
}
