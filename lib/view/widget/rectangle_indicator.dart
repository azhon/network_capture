import 'package:flutter/material.dart';

/// createTime: 2023/10/23 on 14:18
/// desc:
///
/// @author azhon
class RectangleIndicator extends Decoration {
  final double borderWidth;
  final Color borderColor;
  final Color bgColor;
  final double borderRadius;

  const RectangleIndicator({
    this.borderWidth = 1,
    this.borderColor = const Color(0XFFFF9900),
    this.bgColor = Colors.white,
    this.borderRadius = 1000,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomBoxPainter(this);
  }
}

class _CustomBoxPainter extends BoxPainter {
  final RectangleIndicator widget;

  _CustomBoxPainter(this.widget);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    ///每个Tab的宽高
    final Size tabSize =
        Size(configuration.size!.width, configuration.size!.height);
    final Paint paint = Paint();
    paint.style = PaintingStyle.fill;

    ///边框
    paint.color = widget.borderColor;
    final Rect rectRed = offset & tabSize;
    canvas.drawRRect(
      RRect.fromRectXY(rectRed, widget.borderRadius, widget.borderRadius),
      paint,
    );

    ///背景色
    final Rect rectWhite =
        offset.translate(widget.borderWidth, widget.borderWidth) &
            Size(
              tabSize.width - 2 * widget.borderWidth,
              tabSize.height - 2 * widget.borderWidth,
            );
    paint.color = widget.bgColor;

    ///画Tab矩形
    canvas.drawRRect(
      RRect.fromRectXY(rectWhite, widget.borderRadius, widget.borderRadius),
      paint,
    );
  }
}
