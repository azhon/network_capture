/// createTime: 2023/10/23 on 16:33
/// desc:
///
/// @author azhon
class HexUtil {
  static String encode(List<int>? list) {
    if (list == null) {
      return '';
    }
    final result = StringBuffer();
    for (var i = 0; i < list.length; i++) {
      final part = list[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }
}
