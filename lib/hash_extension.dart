import 'dart:convert';
import 'package:crypto/crypto.dart';

/// A dart extension is a method that just extends a functionality of a library or a class. For example a String
/// we are going to be extending this extension functionality on a String
/// we added a getter function and called it "hashValue" that will return a string
///  We returned an encrypted version of the string id or in SHA-256
extension HashStringExtension on String{

  /// Returns the SHA256 hash of this [String]
  String get hashValue{
    return sha256.convert(utf8.encode(this)).toString();
  }
}