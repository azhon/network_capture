import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/generated/assets/network_capture_assets.dart';
import 'package:network_capture/util/constant.dart';
import 'package:network_capture/util/dialog_util.dart';
import 'package:network_capture/util/toast_util.dart';
import 'package:network_capture/view/tab/headers_widget.dart';
import 'package:network_capture/view/tab/hex_widget.dart';
import 'package:network_capture/view/tab/json_text_widget.dart';
import 'package:network_capture/view/tab/query_string_widget.dart';
import 'package:network_capture/view/tab/text_widget.dart';
import 'package:network_capture/view/widget/rectangle_indicator.dart';

/// createTime: 2023/10/23 on 14:04
/// desc:
///
/// @author azhon
class NetworkInfoWidget extends StatefulWidget {
  final NetworkHistoryTable table;

  const NetworkInfoWidget({required this.table, super.key});

  @override
  State<StatefulWidget> createState() => _NetworkInfoWidgetState();
}

class _NetworkInfoWidgetState extends State<NetworkInfoWidget>
    with TickerProviderStateMixin {
  final List<String> reqTab = [];
  final List<String> rspTab = [];
  late TabController _reqController;
  late TabController _rspController;
  final _minHeight = 50.cw;
  double _topHeight = 200.cw;
  double _maxHeight = 0;

  @override
  void initState() {
    super.initState();
    _reqController = _createReqTab();
    _rspController = _createRspTab();
  }

  ///不同的请求类型 tab不一样
  TabController _createReqTab() {
    reqTab.add(Constant.headers);
    if (widget.table.method == Constant.get) {
      reqTab.add(Constant.queryString);
    }
    final String contentType =
        widget.table.requestHeaders?[HttpHeaders.contentTypeHeader] ?? '';
    if (contentType.contains(Constant.jsonH)) {
      reqTab.add(Constant.jsonText);
    }
    if (contentType.contains(Constant.multipartH)) {
      reqTab.add(Constant.multipart);
    }
    reqTab.add(Constant.text);
    reqTab.add(Constant.hex);
    return TabController(length: reqTab.length, vsync: this);
  }

  TabController _createRspTab() {
    rspTab.add(Constant.headers);

    final String contentType =
        widget.table.responseHeaders?[HttpHeaders.contentTypeHeader] ?? '';
    if (contentType.contains(Constant.jsonH)) {
      rspTab.add(Constant.jsonText);
    }
    rspTab.add(Constant.text);
    rspTab.add(Constant.hex);
    return TabController(length: rspTab.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          _maxHeight = constraints.maxHeight - _minHeight - 68.cw;
          return Column(
            children: [
              _tabBar(reqTab, _reqController),
              SizedBox(
                height: _topHeight,
                child: _reqTabBarView(),
              ),
              GestureDetector(
                onVerticalDragUpdate: _dragUpdate,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: -8.cw,
                      child: Image.asset(
                        NetworkCaptureAssets.icDrag,
                        width: 52.cw,
                        height: 8.cw,
                      ),
                    ),
                    _tabBar(rspTab, _rspController),
                  ],
                ),
              ),
              Expanded(
                child: _rspTabBarView(),
              ),
            ],
          );
        },
      ),
    );
  }

  ///上下拖拽
  void _dragUpdate(DragUpdateDetails details) {
    _topHeight += details.delta.dy;
    if (_topHeight <= _minHeight) {
      _topHeight = _minHeight;
    }
    if (_topHeight >= _maxHeight) {
      _topHeight = _maxHeight;
    }
    setState(() {});
  }

  AppBar _appBar() {
    final isError = widget.table.statusCode != HttpStatus.ok;
    return AppBar(
      backgroundColor: isError ? Colors.red : const Color(0XFFFF9900),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: GestureDetector(
        onDoubleTap: () =>
            DialogUtil.showCopyDialog(context, widget.table.path),
        child: Text(
          widget.table.path,
          style: TextStyle(color: Colors.white, fontSize: 14.csp),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.cw),
          child: _menu(),
        ),
      ],
    );
  }

  Widget _tabBar(List<String> tab, TabController controller) {
    return Theme(
      ///去除tabBar 分割线
      data: Theme.of(context).copyWith(
        tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              dividerColor: Colors.transparent,
            ),
      ),
      child: Container(
        height: 34.cw,
        color: Colors.black12,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 4.cw, bottom: 4.cw),
        child: TabBar(
          isScrollable: true,
          controller: controller,
          overlayColor: MaterialStateColor.resolveWith(
            (states) => Colors.transparent,
          ),
          unselectedLabelColor: const Color(0xFF333333),
          labelColor: const Color(0XFFFF9900),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.cw),
          indicator: const RectangleIndicator(),
          tabs: tab
              .map(
                (e) => Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.cw, horizontal: 12.cw),
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 12.csp),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  ///请求
  TabBarView _reqTabBarView() {
    return TabBarView(
      controller: _reqController,
      physics: const NeverScrollableScrollPhysics(),
      children: reqTab
          .map((e) {
            switch (e) {
              case Constant.headers:
                return HeadersWidget(
                  headers: {
                    '': '${widget.table.method} ${widget.table.pathParams}',
                  }..addAll(widget.table.requestHeaders ?? {}),
                );
              case Constant.queryString:
                return QueryStringWidget(
                  queryString: widget.table.params,
                  leftPadding: 8.cw,
                );
              case Constant.multipart:
                return QueryStringWidget(
                  queryString: widget.table.params,
                  leftPadding: 8.cw,
                );
              case Constant.jsonText:
                return JsonTextWidget(text: widget.table.params);
              case Constant.text:
                return TextWidget(text: widget.table.params);
              case Constant.hex:
                return HexWidget(text: widget.table.params);
            }
          })
          .cast<Widget>()
          .toList(),
    );
  }

  ///响应
  TabBarView _rspTabBarView() {
    return TabBarView(
      controller: _rspController,
      physics: const NeverScrollableScrollPhysics(),
      children: rspTab
          .map((e) {
            switch (e) {
              case Constant.headers:
                return HeadersWidget(
                  headers: {
                    '': 'HTTP/1.1 ${widget.table.statusCode} '
                        '${widget.table.reasonPhrase}',
                  }..addAll(widget.table.responseHeaders ?? {}),
                  safeBottom: true,
                );
              case Constant.jsonText:
                return JsonTextWidget(
                  text: widget.table.response,
                  safeBottom: true,
                );
              case Constant.text:
                return TextWidget(
                  text: widget.table.response,
                  safeBottom: true,
                );
              case Constant.hex:
                return HexWidget(
                  text: widget.table.response,
                  safeBottom: true,
                );
            }
          })
          .cast<Widget>()
          .toList(),
    );
  }

  Widget _menu() {
    final List<String> menus = [
      Constant.copyUrl,
      Constant.copyCUrl,
      Constant.copyResponse,
    ];
    return PopupMenuButton<String>(
      itemBuilder: (_) {
        return menus
            .map(
              (e) => PopupMenuItem<String>(
                height: 30.cw,
                value: e,
                labelTextStyle: MaterialStateTextStyle.resolveWith(
                  (states) => TextStyle(
                    fontSize: 12.csp,
                    color: const Color(0xFF333333),
                  ),
                ),
                child: Text(e),
              ),
            )
            .toList();
      },
      onSelected: _menuClick,
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  void _menuClick(String value) {
    String text = '';
    switch (value) {
      case Constant.copyUrl:
        text = widget.table.url ?? '';
        break;
      case Constant.copyCUrl:
        text = _createCurl(widget.table);
        break;
      case Constant.copyResponse:
        text = widget.table.response ?? '';
        break;
    }
    Clipboard.setData(ClipboardData(text: text));
    ToastUtil.showSnackBar(context, 'Copied!');
  }

  String _createCurl(NetworkHistoryTable table) {
    final sb = StringBuffer();
    sb.write('curl');
    table.requestHeaders?.forEach((key, value) {
      sb.write(' -H "$key: $value"');
    });
    sb.write(' -X ${table.method}');
    if (table.method == Constant.post || table.method == Constant.put) {
      sb.write(' -d "${table.params?.replaceAll('"', r'\"')}"');
    }
    sb.write(' "${table.url}"');
    return sb.toString();
  }
}
