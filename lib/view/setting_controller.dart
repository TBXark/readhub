import 'package:flutter/material.dart';
import '../service/eventBus.dart';
import '../service/userDefault.dart';

class SettingController extends StatefulWidget {
  @override
  _SettingControllerState createState() => _SettingControllerState();
}

class _SettingControllerState extends State<SettingController> {

  Setting _setting;

  @override
  initState() {
    super.initState();
    UserDefault.shared.setting.then((value) {
      setState(() {
        _setting = value;
      });
    });
  }

  Widget buildSettingCell(
      String name, bool value, ValueChanged<bool> callback) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded( child: Text( name, style: Theme.of(context).textTheme.button, )),
          Switch(value: value, onChanged: callback)
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {

    List<Widget> children = List<Widget>();

    if (_setting != null) {
      children.add( buildSettingCell("夜间模式", _setting.brightness == Brightness.dark, (newValue) {
        final brightness = newValue ? Brightness.dark : Brightness.light;
        final newSetting = _setting.apply(brightness: brightness);
        UserDefault.shared.setBrightness(brightness);
        setState(() {
          _setting = newSetting;
        });
        bus.emit("setting", newSetting);
      }));
      children.add(buildSettingCell("隐藏摘要", _setting.hideSummary, (newValue) {
        final newSetting = _setting.apply(hideSummary: newValue);
        UserDefault.shared.setHideSummary(newValue);
        setState(() {
          _setting = newSetting;
        });
        print(newSetting);
        bus.emit("setting", newSetting);
      }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView(
        children:children,
      )
    );
  }
}
