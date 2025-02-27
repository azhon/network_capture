/// createTime: 2023/10/31 on 16:00
/// desc:
///
/// @author azhon
class Constant {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';

  static const jsonH = 'json';
  static const multipartH = 'multipart';

  ///
  static const headers = 'Headers';
  static const queryString = 'Query String';
  static const jsonText = 'JSON Text';
  static const text = 'Text';
  static const hex = 'Hex';
  static const multipart = 'Multipart';

  ///
  static const copyUrl = 'Copy URL';
  static const copyCUrl = 'Copy cURL Request';
  static const copyResponse = 'Copy Response';

  ///max response sizes 1.8M
  static const maxResponseSize = 1024 * 1024 * 1.8;
  static const maxResponseData = '{"result":"Response too large!"}';
}
