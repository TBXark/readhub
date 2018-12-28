import 'dart:async';
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
  int _unloadTopicCount = 1;
  Timer _loadUnloadCountRequestTimer;
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    loadData(true);
    _loadUnloadCountRequestTimer = Timer.periodic(Duration(seconds: 10), (t) {
      loadUnreadCount();
    });
  }

  @override
  void dispose() {
    _loadUnloadCountRequestTimer?.cancel();
    super.dispose();
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
      var list = SmartRefresher(
        controller: _refreshController,
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
      var children = <Widget>[Positioned.fill(child: list)];
      if (_unloadTopicCount > 0) {
        children.add(Positioned(
          top: 10,
          left: 0,
          right: 0,
          height: 30,
          child: Container(
              alignment: Alignment.center,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 3),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black38
                                  : Colors.white30),
                    ]),
                child: Container(
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: FlatButton(
                      onPressed: () {
                        _refreshController.scrollController
                            ?.animateTo(0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut)
                            ?.then((some) {
                          _refreshController.requestRefresh(true);
                        });
                      },
                      child: Text(
                        "发现$_unloadTopicCount条新的资讯",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .apply(color: Theme.of(context).hintColor),
                      )),
                ),
              )),
        ));
      }
      return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: children,
        ),
      );
    }
  }

  loadUnreadCount() {
    if (_list?.first?.topic?.order != null) {
      Network.shared.getNewCount(_list?.first?.topic?.order).then((count) {
        setState(() {
          _unloadTopicCount = count.count ?? 0;
        });
      }).catchError((e) {
        _unloadTopicCount = 0;
      });
    } else {
      setState(() {
        _unloadTopicCount = 0;
      });
    }
  }

  loadData(bool up) {
    var lastCursor = up ? null : _list.last.topic.order;
    Network.shared.getList(lastCursor).then((value) {
      var temp = value.data.map((v) => _TopicCellWrapper(v)).toList();
      try {
        _refreshController.sendBack(up, RefreshStatus.completed);
        _refreshController.sendBack(up, RefreshStatus.idle);
      } catch (e) {}
      setState(() {
        if (up) {
          _list = temp;
          _unloadTopicCount = 0;
        } else {
          _list.addAll(temp);
        }
      });
    }).catchError((error) {
      try {
        _refreshController.sendBack(up, RefreshStatus.failed);
        _refreshController.sendBack(up, RefreshStatus.idle);
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
          text: topic.topic.title, style: Theme.of(context).textTheme.title));
    }
    if (topic?.publishDate != null) {
      textSpans.add(TextSpan(
          text: "\n" + timeago.format(topic.publishDate, locale: 'en'),
          style: Theme.of(context).textTheme.overline));
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
        style: Theme.of(context).textTheme.caption,
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
                    style: Theme.of(context).textTheme.subhead),
                TextSpan(
                    text: "  " + news.siteName,
                    style: Theme.of(context).textTheme.overline),
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
              children: <Widget>[
                Text(
                  "查看话题 ‣",
                  style: Theme.of(context).textTheme.button,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            )),
      ));
    }

    return Container(
        color: Theme.of(context).cardColor,
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
        child: _buildBody(),
      ),
    );
  }
}
