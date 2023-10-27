import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

class HighlightViewSelectable extends StatefulWidget {
  /// The original code to be highlighted
  final String source;

  /// Highlight language
  ///
  /// It is recommended to give it a value for performance
  ///
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  final String? language;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final Map<String, TextStyle> theme;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Text styles
  ///
  /// Specify text styles such as font family and font size
  final TextStyle? textStyle;
  final bool wantKeepAlive;

  HighlightViewSelectable(
    String input, {
    super.key,
    this.language,
    this.theme = const {},
    this.padding,
    this.textStyle,
    this.wantKeepAlive = false,
    int tabSize = 8,
  }) : source = input.replaceAll('\t', ' ' * tabSize);

  @override
  State<StatefulWidget> createState() => _HighlightViewSelectableState();
}

class _HighlightViewSelectableState extends State<HighlightViewSelectable>
    with AutomaticKeepAliveClientMixin {
  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);
  static const _defaultBackgroundColor = Color(0xffffffff);

  // See: https://github.com/flutter/flutter/issues/39998
  // So we just use monospace here for now
  static const _defaultFontFamily = 'monospace';
  List<TextSpan>? _list;

  @override
  void initState() {
    super.initState();
    compute(_convert, [widget.source, widget.language, widget.theme])
        .then((value) {
      setState(() {
        _list = value;
      });
    });
  }

  static List<TextSpan> _convert(List<dynamic> params) {
    final List<Node> nodes =
        highlight.parse(params[0], language: params[1]).nodes!;
    final List<TextSpan> spans = [];
    var currentSpans = spans;
    final List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(
                  text: node.value,
                  style: params[2][node.className!],
                ),
        );
      } else if (node.children != null) {
        final List<TextSpan> tmp = [];
        currentSpans
            .add(TextSpan(children: tmp, style: params[2][node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children!.forEach((n) {
          _traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    nodes.forEach(_traverse);
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _textStyle = TextStyle(
      fontFamily: _defaultFontFamily,
      color: widget.theme[_rootKey]?.color ?? _defaultFontColor,
    );
    if (widget.textStyle != null) {
      _textStyle = _textStyle.merge(widget.textStyle);
    }
    return Container(
      color: widget.theme[_rootKey]?.backgroundColor ?? _defaultBackgroundColor,
      padding: widget.padding,
      child: _list == null
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 230,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0XFFFF9900),
                ),
              ),
            )
          : SelectableText.rich(
              TextSpan(
                style: _textStyle,
                children: _list,
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
