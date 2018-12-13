import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/topic.dart';
import '../service/network.dart';
import 'webController.dart';
import 'topicDetailController.dart';

class TopicCell extends StatefulWidget {
  final Topic topic;
  TopicCell({this.topic});

  @override
  _TopicCellSate createState() => _TopicCellSate.build(topic);
}

class _TopicCellSate extends State<TopicCell> {
  Topic _topic;
  DateTime _time;
  bool _isExpand = false;

  _TopicCellSate.build(Topic topic) {
    _topic = topic;
    _topic.title =
        _topic.title.replaceAll(RegExp(r"[\n\r]*$", multiLine: true), "");
    _topic.summary =
        _topic.summary.replaceAll(RegExp(r"[\n\r]*$", multiLine: true), "");
    _time = DateTime.parse(_topic.publishDate);
  }

  changeExpandState() {
    setState(() {
      _isExpand = !_isExpand;
    });
  }

  Widget buildBody() {
    List<Widget> list = [
      Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: _topic.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: Colors.black)),
            TextSpan(
                text: "\n" + timeago.format(_time, locale: 'en'),
                style: TextStyle(
                    fontSize: 12, height: 1.2, color: Colors.black54)),
          ]))),
      Text(
        _topic.summary,
        maxLines: _isExpand ? null : 3,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 1.2,
            color: Colors.black87),
      )
    ];
    if (_isExpand) {
      for (NewsArray news in _topic.newsArray) {
        list.add(Container(
          margin: EdgeInsets.only(top: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return WebController(title: news.title, url: news.url);
              }));
            },
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: " ∙  " + news.title,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
              TextSpan(
                  text: "  " + news.siteName,
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
            ])),
          ),
        ));
      }

      list.add(ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: FlatButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return TopicDetailController(topic: _topic,);
          }));
        }, child: Row(children: <Widget>[Text("查看话题 ‣")], mainAxisAlignment: MainAxisAlignment.end,)),
      ));
    }

    return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(12, 12, 12, _isExpand ? 2 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeExpandState();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 0), blurRadius: 10)
          ]),
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: buildBody(),
          ),
        ),
      ),
    );
  }
}

class TopocListController extends StatefulWidget {
  @override
  _TopocListControllerState createState() => _TopocListControllerState();
}

class _TopocListControllerState extends State<TopocListController> {
  List<Topic> _list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      return Center(
        child: FlatButton(
            onPressed: () {
              loadData();
            },
            child: Text("Reload")),
      );
    } else {
      return ListView.builder(
          itemCount: _list.length,
          itemBuilder: (ctx, index) {
            return TopicCell(
              topic: _list[index],
            );
          });
    }
  }

  loadData() {
    Network.shared.getList(0).then((value) {
      setState(() {
//          _list = value.data.cast<Topic>();
        _list = value.data;
      });
    });
  }
}
