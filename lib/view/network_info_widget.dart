/// createTime: 2023/10/23 on 14:04
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/view/tab/headers_widget.dart';
import 'package:network_capture/view/tab/hex_widget.dart';
import 'package:network_capture/view/tab/json_text_widget.dart';
import 'package:network_capture/view/tab/query_string_widget.dart';
import 'package:network_capture/view/tab/text_widget.dart';
import 'package:network_capture/view/widget/rectangle_indicator.dart';

class NetworkInfoWidget extends StatefulWidget {
  final NetworkHistoryTable table;

  const NetworkInfoWidget({required this.table, super.key});

  @override
  State<StatefulWidget> createState() => _NetworkInfoWidgetState();
}

class _NetworkInfoWidgetState extends State<NetworkInfoWidget>
    with TickerProviderStateMixin {
  final List<String> reqTab = [];
  final List<String> rspTab = ['Headers', 'JSON Text', 'Text', 'Hex'];
  late TabController _reqController;
  late TabController _rspController;

  @override
  void initState() {
    super.initState();
    _reqController = _createReqTab();
    _rspController = TabController(length: rspTab.length, vsync: this);
  }

  ///不同的请求类型 tab不一样
  TabController _createReqTab() {
    if (widget.table.method == 'GET') {
      reqTab.addAll(['Headers', 'Query String']);
    } else {
      reqTab.addAll(['Headers', 'JSON Text', 'Text', 'Hex']);
    }
    return TabController(length: reqTab.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _tabBar(reqTab, _reqController),
          SizedBox(
            height: 200.cw,
            child: _reqTabBarView(),
          ),
          _tabBar(rspTab, _rspController),
          Expanded(
            child: _rspTabBarView(),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: const Color(0XFFFF9900),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.table.path,
        style: TextStyle(color: Colors.white, fontSize: 14.csp),
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
        width: double.infinity,
        color: Colors.black12,
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
              case 'Headers':
                return HeadersWidget(
                  headers: {
                    '': '${widget.table.method} ${widget.table.pathParams}',
                  }..addAll(widget.table.requestHeaders ?? {}),
                );
              case 'Query String':
                return QueryStringWidget(
                  queryString: widget.table.params,
                  leftPadding: 8.cw,
                );
              case 'JSON Text':
                return JsonTextWidget(
                  text: widget.table.params,
                  fontSize: 12.csp,
                  leftPadding: 4.cw,
                );
              case 'Text':
                return TextWidget(text: widget.table.params);
              case 'Hex':
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
              case 'Headers':
                return HeadersWidget(
                  headers: {
                    '': 'HTTP/1.1 ${widget.table.statusCode} '
                        '${widget.table.reasonPhrase}',
                  }..addAll(widget.table.responseHeaders ?? {}),
                );
              case 'JSON Text':
                return JsonTextWidget(
                  text: widget.table.response,
                  fontSize: 12.csp,
                  leftPadding: 4.cw,
                );
              case 'Text':
                return TextWidget(text: widget.table.response);
              case 'Hex':
                return HexWidget(text: widget.table.response);
            }
          })
          .cast<Widget>()
          .toList(),
    );
  }

  Widget _menu() {
    final List<String> menus = [
      'Copy URL',
      'Copy cURL Request',
      'Copy Response',
    ];
    return PopupMenuButton(
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
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}
