/// createTime: 2023/10/26 on 10:47
/// desc:
///
/// @author azhon
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/adapter/capture_screen_adapter.dart';
import 'package:network_capture/view/widget/remove_ripple_widget.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<List<dynamic>?>? search;

  const SearchWidget({super.key, this.search});

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final FocusNode _focusNode = FocusNode();
  final _condition = [
    CheckStatus('GET', false, CheckStatus.method),
    CheckStatus('POST', false, CheckStatus.method),
    CheckStatus('DEL', false, CheckStatus.method),
    CheckStatus('PUT', false, CheckStatus.method),
    CheckStatus('=200', false, CheckStatus.code),
    CheckStatus('!=200', false, CheckStatus.code),
  ];

  @override
  void initState() {
    super.initState();
    _createAnimation();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _animationController.reverse();
      }
    });
  }

  void _createAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return RemoveRippleWidget(
      child: SizedBox(
        height: 36.cw,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
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
                  ),
                  SizedBox(width: 8.cw),
                  _searchWidget(),
                ],
              ),
            ),
            Positioned(
              right: 12.cw,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (_, child) {
                  return SizedBox(
                    width: (width - 24.cw) * _animation.value,
                    height: 36.cw,
                    child: CupertinoTextField(
                      focusNode: _focusNode,
                      placeholder: 'Input host、uri、path、params',
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      clearButtonMode: OverlayVisibilityMode.always,
                      textInputAction: TextInputAction.search,
                      placeholderStyle: TextStyle(
                        fontSize: 12.csp,
                        color: Colors.grey,
                      ),
                      style: TextStyle(
                        fontSize: 12.csp,
                        color: const Color(0xFF333333),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.cw),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(CheckStatus status) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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

  Widget _searchWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(right: 16.cw),
        child: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        _animationController.forward();
        _focusNode.requestFocus();
      },
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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _focusNode.dispose();
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
