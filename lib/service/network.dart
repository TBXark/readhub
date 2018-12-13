import 'package:dio/dio.dart';
import '../model/topic.dart';

class Network {

  static Network shared = Network();
  Dio dio = Dio();

  Network() {
    dio.options.baseUrl = "https://api.readhub.cn/";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 5000;
  }

  Future<TopicList> getList(int page) async {
    try {
      Response response = await dio.get("topic?lastCursor&pageSize=20&page=$page");
      var json = response.data as Map<String, dynamic>;
      var temp = TopicList.fromJson(json);
      return temp;
    } catch(e) {
      return Future.error(e);
    }
  }

  Future<TopicDetail> getDetail(String id) async {
    try {
      Response response = await dio.get("topic/$id");
      var json = response.data as Map<String, dynamic>;
      var temp = TopicDetail.fromJson(json);
      return temp;
    } catch(e) {
      return Future.error(e);
    }
  }

  Future<InstantView> getInstantView(String id) async {
    try {
      Response response = await dio.get("topic/instantview?topicId=$id");
      var json = response.data as Map<String, dynamic>;
      var temp = InstantView.fromJson(json);
      return temp;
    } catch(e) {
      return Future.error(e);
    }
  }
}
