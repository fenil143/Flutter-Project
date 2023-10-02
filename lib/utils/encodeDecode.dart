import 'dart:convert';

String encodeUrl(String email){
  return base64Url.encode(utf8.encode(email));
}

String decodeUrl(String url){
  return utf8.decode(base64Url.decode(url));
}