import 'package:flutter/services.dart';

String removeHtmlTags(String htmlText) {
  final RegExp exp = RegExp(r"<[^>]*>");
  return htmlText.replaceAll(exp, ''); // Removes HTML tags
}
