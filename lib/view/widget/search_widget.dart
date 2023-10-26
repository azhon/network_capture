/// createTime: 2023/10/26 on 10:47
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<List<dynamic>?>? search;

  const SearchWidget({super.key, this.search});

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _condition = [
    CheckStatus('GET', false, CheckStatus.method),
    CheckStatus('POST', false, CheckStatus.method),
    CheckStatus('DEL', false, CheckStatus.method),
    CheckStatus('PUT', false, CheckStatus.method),
    CheckStatus('=200', false, CheckStatus.code),
    CheckStatus('!=200', false, CheckStatus.code),
  ];

  @override
  Widget build(BuildContext context) {
    return RemoveRippleWidget(
      child: SizedBox(
        height: 20.cw,
        child: ListView.separated(
          itemCount: _condition.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 16.cw),
          itemBuilder: (_, index) {
            return _label(_condition[index]);
          },
          separatorBuilder: (_, index) {
            return SizedBox(width: 10.cw);
          },
        ),
      ),
    );
  }

  Widget _label(CheckStatus status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          status.check = !status.check;
        });
        widget.search?.call(_generateCondition());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.cw),
        decoration: BoxDecoration(
          color: status.check ? Colors.white : null,
          borderRadius: BorderRadius.circular(100),
          border: status.check
              ? Border.all(color: const Color(0XFFFF9900))
              : Border.all(color: Colors.grey),
        ),
        child: Text(
          status.title,
          style: TextStyle(
            fontSize: 10.csp,
            fontWeight: FontWeight.w500,
            color: status.check ? const Color(0XFFFF9900) : Colors.grey,
          ),
        ),
      ),
    );
  }

  List<dynamic>? _generateCondition() {
    final List<String> where = [];
    final List<Object> args = [];
    _condition.forEach((e) {
      if (!e.check) {
        return;
      }
      if (e.type == CheckStatus.method) {
        where.add('method = ?');
        args.add(e.title);
      }
      if (e.title == '=200') {
        where.add('statusCode = ?');
        args.add(200);
      }
      if (e.title == '!=200') {
        where.add('statusCode != ?');
        args.add(200);
      }
    });
    if (where.isEmpty) {
      return null;
    }
    return [where.join(' AND '), args];
  }
}

class CheckStatus {
  static const int method = 0x1A;
  static const int code = 0x1B;
  String title;
  bool check;
  final int type;

  CheckStatus(this.title, this.check, this.type);
}
