import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/view/route/newMethodRoute.dart';

class MethodRoute extends StatefulWidget {
  @override
  _MethodRouteState createState() => _MethodRouteState();
}

class _MethodRouteState extends State<MethodRoute> {
  @override
  Widget build(BuildContext context) {
    ///处理删除按钮回调
    void _handleDelete() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(XiaomingLocalizations.of(context).deleteAllMethod),
              actions: <Widget>[
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).delete),
                  onPressed: () {
                    setState(() {
                      UserData.userFunctions = [];
                      UserData.deleteAllUF();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(XiaomingLocalizations.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return CupertinoPageScaffold(
      child: Builder(
        builder: (context) {

          ///存储方法卡片列表
          final List<Widget> tiles = <Widget>[];
          Locale myLocale = Localizations.localeOf(context);
          String funName;
          String funDescrip;

          ///将内置方法及已保存的方法加载进tiles
          for (int index = 0; index < UserData.userFunctions.length; index ++) {
            var u = UserData.userFunctions[index];
            tiles.add(Dismissible(
              onDismissed: (item) {
                var temp;
                setState(() {
                  temp = UserData.userFunctions.removeAt(index);
                  UserData.deleteUF(u.funName);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(XiaomingLocalizations.of(context).removeUF),
                  action: SnackBarAction(label: XiaomingLocalizations.of(context).undo, onPressed: ()=>setState((){
                    UserData.userFunctions.insert(index, temp);
                    UserData.addUF(u.funName, u.paras, u.funCmds);
                  })),
                ));
              },
              background: Container(
                color: Colors.red,
              ),
              key: Key(u.funName),
              child: Card(
                color: Colors.purple,
                child: new ListTile(
                  leading: new Text(
                    u.funName,
                  ),
                  title: new Text(
                      '${u.funName}(${u.paras.toString().substring(1, u.paras.toString().length - 1)})'),
                  subtitle: new Text(u.funCmds.toString()),
                ),
              ),
            ));
          }
          for (CmdMethod method in UserData.cmdMethods) {
            if (myLocale.countryCode == 'CH') {
              funName = method.name;
              funDescrip = method.methodDescription;
            } else {
              funName = method.ename;
              funDescrip = method.emethodDescription;
            }
            tiles.add(Card(
              color: Colors.yellow,
              child: ListTile(
                title: Text(
                  funName,
                ),
                subtitle: Text(funDescrip),
              ),
            ));
          }
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return ListView(
            children: divided,
          );
        } ,
      ),
    );
  }
}
