/// createTime: 2023/10/20 on 21:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/generated/assets/network_capture_assets.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';
import 'package:network_capture/view/widget/request_item_widget.dart';
import 'package:network_capture/view/widget/search_widget.dart';

class NetworkListWidget extends StatefulWidget {
  const NetworkListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkListWidgetState();

  static Future<T?> showDialog<T>(NavigatorState navigator) {
    return navigator.push<T?>(
      ModalBottomSheetRoute(
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF6F7F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.cw),
            topRight: Radius.circular(16.cw),
          ),
        ),
        builder: (_) {
          final height = MediaQuery.of(_).size.height * 0.85;
          return SizedBox(
            height: height,
            child: const NetworkListWidget(),
          );
        },
      ),
    );
  }
}

class _NetworkListWidgetState extends State<NetworkListWidget> {
  List<Map<String, Object?>>? list;

  @override
  void initState() {
    super.initState();
    _refresh(null, null);
  }

  Future<void> _refresh(String? where, List<Object?>? whereArgs) async {
    final value = await AppDb.instance.query(
      NetworkHistoryTable.tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'id DESC',
    );
    setState(() {
      list = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          _header(),
          Padding(
            padding: EdgeInsets.only(top: 4.cw),
            child: SearchWidget(
              search: (List<dynamic>? sql) {
                _refresh(sql?.first, sql?.last);
              },
            ),
          ),
          if (list?.isEmpty ?? true)
            _emptyView()
          else
            Expanded(
              child: RemoveRippleWidget(
                child: ListView.separated(
                  itemCount: list?.length ?? 0,
                  padding: EdgeInsets.only(top: 8.cw, bottom: 16.cw),
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10.cw);
                  },
                  itemBuilder: (_, index) {
                    final table = NetworkHistoryTable.fromMap(list![index]);
                    return RequestItemWidget(table: table);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.cw),
          topRight: Radius.circular(16.cw),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.cw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 36.cw),
            Text(
              'Network Capture',
              style: TextStyle(fontSize: 16.cw, fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 16.cw),
                child: Image.asset(
                  NetworkCaptureAssets.icClear,
                  width: 20.cw,
                  height: 20.cw,
                ),
              ),
              onTap: () {
                AppDb.instance.delete(NetworkHistoryTable.tableName);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Padding(
      padding: EdgeInsets.only(top: 100.cw),
      child: Image.asset(
        NetworkCaptureAssets.icEmpty,
        width: 96.cw,
        height: 96.cw,
        color: Colors.grey,
      ),
    );
  }
}
