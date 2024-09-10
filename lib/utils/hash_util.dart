import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';

String iMd5(String s) {

  return md5.convert(utf8 .encode(s)).toString();
}

String iBcrypt(String s) {
  return BCrypt.hashpw(s,BCrypt.gensalt());
}