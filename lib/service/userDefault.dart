import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Setting {
  Brightness brightness;
  bool hideSummary;
  Setting({this.brightness, this.hideSummary});

  Setting apply({Brightness brightness, bool hideSummary}) {
    return Setting(
        brightness: brightness ?? this.brightness,
        hideSummary: hideSummary ?? this.hideSummary);
  }

  @override
  String toString() {
    return "{brightness: $brightness, hideSummary: $hideSummary}";
  }
}

class UserDefault {
  //私有构造函数
  UserDefault._internal();

  //保存单例
  static UserDefault shared = new UserDefault._internal();

  //工厂构造函数
  factory UserDefault() => shared;

  Setting _setting;

  Setting get settingSync => _setting;

  Future<Setting> get setting async {
    if (_setting != null) {
      return _setting;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final brightness = (prefs.getBool("brightness") ?? true)
          ? Brightness.light
          : Brightness.dark;
      final hideSummary = prefs.getBool("hideSummary") ?? false;
      final st = Setting(brightness: brightness, hideSummary: hideSummary);
      print("Load setting success $st");
      _setting = st;
      return st;
    }
  }

  setBrightness(Brightness value) {
    _setting.brightness = value;
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("brightness", value == Brightness.light).then((value) {
        print("Set brightness success");
      }).catchError((error) {
        print("Set brightness $error");
      });
    });
  }

  setHideSummary(bool value) {
    _setting.hideSummary = value;
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("hideSummary", value).then((value) {
        print("Set hideSummary success");
      }).catchError((error) {
        print("Set hideSummary $error");
      });
    });
  }
}
