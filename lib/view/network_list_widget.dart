/// createTime: 2023/10/20 on 21:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/db/app_db.dart';
import 'package:network_capture/db/table/network_history_table.dart';
import 'package:network_capture/generated/assets/network_capture_assets.dart';
import 'package:network_capture/network_capture.dart';
import 'package:network_capture/view/widget/request_item_widget.dart';

class NetworkListWidget extends StatefulWidget {
  const NetworkListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkListWidgetState();

  static Future showDialog(
    BuildContext context,
  ) {
    return ncNavigator.push(
      ModalBottomSheetRoute(
        isScrollControlled: true,
        backgroundColor: const Color(0xFFEEEEEE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.cw),
            topRight: Radius.circular(16.cw),
          ),
        ),
        builder: (_) {
          final height = MediaQuery.of(context).size.height * 0.9;
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
    _refresh();
  }

  void _refresh() {
    AppDb.instance
        .query(NetworkHistoryTable.tableName, orderBy: 'id DESC')
        .then((value) {
      setState(() {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: ListView.separated(
            itemCount: list?.length ?? 0,
            separatorBuilder: (_, index) {
              return SizedBox(height: 10.cw);
            },
            itemBuilder: (_, index) {
              final table = NetworkHistoryTable.fromMap(list![index]);
              return RequestItemWidget(table: table);
            },
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.cw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 36.cw),
          Text(
            '网络请求',
            style: TextStyle(fontSize: 18.cw, fontWeight: FontWeight.w500),
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
    );
  }
}
