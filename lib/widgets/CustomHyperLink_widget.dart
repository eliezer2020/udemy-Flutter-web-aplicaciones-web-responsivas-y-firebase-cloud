import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CustomHyperLink extends StatefulWidget {
  final String label;
  final Function callback;
  final Color hoverColor;
  final Color defaultColor;

  const CustomHyperLink(
      {Key key, this.label, this.callback, this.hoverColor, this.defaultColor})
      : super(key: key);

  State<StatefulWidget> createState() => _CustomHyperLinkState();
}

class _CustomHyperLinkState extends State<CustomHyperLink> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: GestureDetector(
        onTap: super.widget.callback,
        child: Text(
          super.widget.label,
          style: TextStyle(
            color:
                (isHover) ? super.widget.hoverColor : super.widget.defaultColor,
            fontWeight: (isHover) ? FontWeight.bold : FontWeight.normal,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
