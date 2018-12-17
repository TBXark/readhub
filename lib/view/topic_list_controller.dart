import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import "package:pull_to_refresh/pull_to_refresh.dart";
import '../model/topic.dart';
import '../service/network.dart';
import 'web_controller.dart';
import 'topic_detail_controller.dart';

class TopocListController extends StatefulWidget {
  @override
  _TopicListControllerState createState() => _TopicListControllerState();
}

class _TopicListControllerState extends State<TopocListController> {
  List<_TopicCellWrapper> _list = [];
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    loadData(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      return Center(
        child: FlatButton(
            onPressed: () {
              loadData(true);
            },
            child: Text("Reload")),
      );
    } else {
      return SmartRefresher(
        controller: refreshController,
        enableOverScroll: true,
        enablePullDown: true,
        enablePullUp: _list.isNotEmpty,
        onRefresh: loadData,
        child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (ctx, index) {
              return _TopicCell(
                topic: _list[index],
              );
            }),
      );
    }
  }

  loadData(bool up) {
    var lastCursor = up ? null : _list.last.topic.order;
    Network.shared.getList(lastCursor).then((value) {
      var temp = value.data.map((v) => _TopicCellWrapper(v)).toList();
      try {
        refreshController.sendBack(up, RefreshStatus.completed);
        refreshController.sendBack(up, RefreshStatus.idle);
      } catch (e) {}
      setState(() {
        if (up) {
          _list = temp;
        } else {
          _list.addAll(temp);
        }
      });
    }).catchError((error) {
      try {
        refreshController.sendBack(up, RefreshStatus.failed);
        refreshController.sendBack(up, RefreshStatus.idle);
      } catch (e) {}
    });
  }
}

class _TopicCellWrapper {
  Topic topic;
  DateTime publishDate;
  bool isExpand = false;
  _TopicCellWrapper(Topic data) {
    topic = data;
    topic.title =
        data.title?.replaceAll(RegExp(r"[\n\r]*$", multiLine: true), "") ?? "";
    topic.summary =
        data.summary?.replaceAll(RegExp(r"[\n\r]*$", multiLine: true), "") ??
            "";
    publishDate = DateTime.parse(data.publishDate);
  }
}

class _TopicCell extends StatefulWidget {
  final _TopicCellWrapper topic;
  _TopicCell({this.topic});

  @override
  _TopicCellSate createState() => _TopicCellSate(topic: topic);
}

class _TopicCellSate extends State<_TopicCell> {
  final _TopicCellWrapper topic;
  _TopicCellSate({this.topic});

  changeExpandState() {
    setState(() {
      topic.isExpand = !topic.isExpand;
    });
  }

  Widget _buildTitle() {
    List<TextSpan> textSpans = [];
    if (topic?.topic?.title != null) {
      textSpans.add(TextSpan(
          text: topic.topic.title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1,
              color: Colors.black)));
    }
    if (topic?.publishDate != null) {
      textSpans.add(TextSpan(
          text: "\n" + timeago.format(topic.publishDate, locale: 'en'),
          style: TextStyle(fontSize: 12, height: 1.2, color: Colors.black54)));
    }
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text.rich(TextSpan(children: textSpans)));
  }

  Widget _buildSummary() {
    if (topic?.topic?.summary != null) {
      return Text(
        topic.topic.summary,
        maxLines: topic.isExpand ? null : 3,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            height: 1.2,
            color: Colors.black87),
      );
    } else {
      return Text("");
    }
  }

  Widget _buildBody() {
    List<Widget> list = [_buildTitle(), _buildSummary()];

    if (topic.isExpand) {
      if (topic?.topic?.newsArray != null) {
        for (NewsArray news in topic.topic.newsArray) {
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
      }

      list.add(ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return TopicDetailController(
                  topic: topic.topic,
                );
              }));
            },
            child: Row(
              children: <Widget>[Text("查看话题 ‣")],
              mainAxisAlignment: MainAxisAlignment.end,
            )),
      ));
    }

    return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(12, 12, 12, topic.isExpand ? 2 : 12),
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.black26)),
          child: _buildBody(),
        ),
      ),
    );
  }
}
