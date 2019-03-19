import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

///单个输出文本的视图
class TextView extends StatelessWidget {
  ScaffoldState scaffoldState = new ScaffoldState();
  TextView({this.context, this.text, this.animationController});
  final BuildContext context;
  final AnimationController animationController;
  final String text;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new GestureDetector(
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: new Text(
            text,
            style:TextStyle(fontSize : 20.0)
          ),
        ),
        onLongPress: _handleLongPress,
      ),
    );
  }

  void _handleLongPress() {
    Clipboard.setData(new ClipboardData(text: text));
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: new Text(XiaomingLocalizations.of(context).copyHint),
    ));
  }
}