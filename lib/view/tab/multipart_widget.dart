import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';

/// createTime: 2023/10/23 on 14:53
/// desc:
///
/// @author azhon
class MultipartWidget extends StatelessWidget {
  final String? multipart;
  final double leftPadding;

  const MultipartWidget({
    required this.multipart,
    this.leftPadding = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = _parseMultipart(multipart);
    int line = 0;
    return SelectionArea(
      child: LayoutBuilder(
        builder: (context, constrain) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Table(
              columnWidths: {
                0: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.2),
                  const FractionColumnWidth(0.1),
                ),
                1: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.3),
                  const FractionColumnWidth(0.1),
                ),
                2: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.3),
                  const FractionColumnWidth(0.1),
                ),
                3: MaxColumnWidth(
                  FixedColumnWidth(constrain.maxWidth * 0.2),
                  const FractionColumnWidth(0.1),
                ),
              },
              children: [
                    _tableHeader(),
                  ] +
                  list
                      .map(
                        (e) => _tableRow(e, ++line),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }

  TableRow _tableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'part',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'content-type',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'filename',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Text(
            'value',
            style: TextStyle(
              fontSize: 12.csp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _tableRow(_MultipartBean bean, int line) {
    return TableRow(
      decoration: BoxDecoration(
        color: line.isEven ? const Color(0xFFF5F5F5) : Colors.white60,
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              bean.part ?? '',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.csp,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              bean.contentType ?? '',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.csp,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              bean.fileName ?? '',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.csp,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              bean.value ?? '',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.csp,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///解析multipart数据
  List<_MultipartBean> _parseMultipart(String? multipart) {
    final List<_MultipartBean> result = [];
    if (multipart == null || multipart.isEmpty) {
      return result;
    }
    final split = multipart.split('\r\n');
    split.removeWhere((e) {
      ///移除无用数据
      return e.endsWith('--') || e.isEmpty;
    });
    for (final value in split) {
      if (value.startsWith('----dio-boundary')) {
        result.add(_MultipartBean());
        continue;
      }

      ///匹配是否是上传文件
      final filename = _match(value, 'filename="(.*?)"');
      if (filename != null) {
        result.last.fileName = filename.replaceAll(RegExp('filename=|"'), '');
        final name = _match(value, 'name="(.*?)"');
        result.last.part = name?.replaceAll(RegExp('name=|"'), '');
        continue;
      }

      ///匹配键值对
      final name = _match(value, 'name="(.*?)"');
      if (name != null) {
        result.last.part = name.replaceAll(RegExp('name=|"'), '');
        continue;
      }
      if (value.startsWith('content-type')) {
        result.last.contentType = value;
        continue;
      }
      result.last.value = value;
    }
    return result;
  }

  ///正则匹配
  String? _match(String input, String regexp) {
    final reg = RegExp(regexp);
    if (reg.hasMatch(input)) {
      return reg.firstMatch(input)!.group(0);
    }
    return null;
  }
}

class _MultipartBean {
  String? part;
  String? contentType;
  String? fileName;
  String? value;

  _MultipartBean();
}
