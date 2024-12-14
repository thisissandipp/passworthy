import 'dart:typed_data';

/// Extension on [Uint8List].
extension Uint8ListExt on Uint8List {
  /// Creates a hexdecimal representation of this.
  String get toHexString {
    final result = StringBuffer();
    for (var i = 0; i < lengthInBytes; i++) {
      final part = this[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }
}

/// Extension on [String].
extension StringExt on String {
  /// Creates binary data from this hexdecimal String.
  Uint8List get toUint8List {
    final result = Uint8List(length ~/ 2);
    for (var i = 0; i < length; i += 2) {
      final num = substring(i, i + 2);
      final byte = int.parse(num, radix: 16);
      result[i ~/ 2] = byte;
    }
    return result;
  }
}
