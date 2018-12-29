import 'package:flutter/material.dart';
import '../service/userDefault.dart';
import '../service/eventBus.dart';
import '../view/topic_list_controller.dart';
import '../view/setting_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  bool _hideSummary = UserDefault.shared.settingSync?.hideSummary;

  @override
  void initState() {
    super.initState();
    UserDefault.shared.setting.then((value) {
      setState(() {
        _hideSummary = value.hideSummary;
      });
    });
    bus.on("setting", handleSettingChange);
  }

  @override
  void dispose() {
    bus.off("setting", handleSettingChange);
    super.dispose();
  }

  handleSettingChange([arg]) {
    setState(() {
      _hideSummary = (arg as Setting).hideSummary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = _hideSummary == null
        ? CircularProgressIndicator()
        : TopicListController( key: Key(_hideSummary ? "hide" : "show") ,hideSummary: _hideSummary,);
    return Scaffold(
      appBar: AppBar(
        title: Text("Readhub"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return SettingController();
                }));
              })
        ],
      ),
      body: body,
    );
  }
}
