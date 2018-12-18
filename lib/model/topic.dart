class TopicList {
  List<Topic> data;
  int pageSize;
  int totalItems;
  int totalPages;

  TopicList({this.data, this.pageSize, this.totalItems, this.totalPages});

  TopicList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<Topic>();
      json['data'].forEach((v) {
        data.add(Topic.fromJson(v));
      });
    }
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }
}

class TopicSimple {
  String id;
  String title;
  String createdAt;

  TopicSimple({this.id, this.title, this.createdAt});

  TopicSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['createdAt'];
  }
}

class Topic {
  String id;
  NelData nelData;
  List<NewsArray> newsArray;
  String createdAt;
  List<EventData> eventData;
  String publishDate;
  String summary;
  String title;
  String updatedAt;
  String timeline;
  int order;
  Extra extra;

  Topic(
      {this.id,
      this.nelData,
      this.newsArray,
      this.createdAt,
      this.eventData,
      this.publishDate,
      this.summary,
      this.title,
      this.updatedAt,
      this.timeline,
      this.order,
      this.extra});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nelData =
        json['nelData'] != null ? NelData.fromJson(json['nelData']) : null;
    if (json['newsArray'] != null) {
      newsArray = List<NewsArray>();
      json['newsArray'].forEach((v) {
        newsArray.add(NewsArray.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    if (json['eventData'] != null) {
      eventData = List<EventData>();
      json['eventData'].forEach((v) {
        eventData.add(EventData.fromJson(v));
      });
    }
    publishDate = json['publishDate'];
    summary = json['summary'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    timeline = json['timeline'];
    order = json['order'];
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
  }
}

class TopicDetail {
  String id;
  List<EntityTopics> entityTopics;
  List<NewsArray> newsArray;
  String createdAt;
  List<dynamic> entityEventTopics;
  String publishDate;
  String summary;
  String title;
  String updatedAt;
  Timeline timeline;
  int order;
  bool hasInstantView;

  TopicDetail(
      {this.id,
      this.entityTopics,
      this.newsArray,
      this.createdAt,
      this.entityEventTopics,
      this.publishDate,
      this.summary,
      this.title,
      this.updatedAt,
      this.timeline,
      this.order,
      this.hasInstantView});

  TopicDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['entityTopics'] != null) {
      entityTopics = List<EntityTopics>();
      json['entityTopics'].forEach((v) {
        entityTopics.add(EntityTopics.fromJson(v));
      });
    }
    if (json['newsArray'] != null) {
      newsArray = List<NewsArray>();
      json['newsArray'].forEach((v) {
        newsArray.add(NewsArray.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    if (json['entityEventTopics'] != null) {
      entityEventTopics = List<dynamic>();
      json['entityEventTopics'].forEach((v) {
        entityEventTopics.add(v);
      });
    }
    publishDate = json['publishDate'];
    summary = json['summary'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    timeline =
        json['timeline'] != null ? Timeline.fromJson(json['timeline']) : null;
    order = json['order'];
    hasInstantView = json['hasInstantView'];
  }
}

class EntityTopics {
  num weight;
  String nerName;
  String entityId;
  String entityName;
  String entityType;
  String entityUniqueId;
  dynamic finance;

  EntityTopics(
      {this.weight,
      this.nerName,
      this.entityId,
      this.entityName,
      this.entityType,
      this.entityUniqueId,
      this.finance});

  EntityTopics.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    nerName = json['nerName'];
    entityId = json['entityId'];
    entityName = json['entityName'];
    entityType = json['entityType'];
    entityUniqueId = json['entityUniqueId'];
    finance = json['finance'];
  }
}

class Timeline {
  List<TopicSimple> topics;
  List<CommonEntities> commonEntities;
  String id;

  Timeline({this.topics, this.commonEntities, this.id});

  Timeline.fromJson(Map<String, dynamic> json) {
    if (json['topics'] != null) {
      topics = List<TopicSimple>();
      json['topics'].forEach((v) {
        topics.add(TopicSimple.fromJson(v));
      });
    }
    if (json['commonEntities'] != null) {
      commonEntities = List<CommonEntities>();
      json['commonEntities'].forEach((v) {
        commonEntities.add(CommonEntities.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class CommonEntities {
  int id;
  String topicId;
  String nerName;
  double weight;
  String entityId;
  String entityType;
  String entityName;
  bool isMain;
  dynamic extra;
  String createdAt;
  String updatedAt;

  CommonEntities(
      {this.id,
      this.topicId,
      this.nerName,
      this.weight,
      this.entityId,
      this.entityType,
      this.entityName,
      this.isMain,
      this.extra,
      this.createdAt,
      this.updatedAt});

  CommonEntities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topicId'];
    nerName = json['nerName'];
    weight = json['weight'];
    entityId = json['entityId'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    isMain = json['isMain'];
    extra = json['extra'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class NelData {
  bool state;
  List<Result> result;

  NelData({this.state, this.result});

  NelData.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    if (json['result'] != null) {
      result = List<Result>();
      json['result'].forEach((v) {
        result.add(Result.fromJson(v));
      });
    }
  }
}

class Result {
  num weight;
  String nerName;
  String entityId;
  String entityName;
  String entityType;
  String entityUniqueId;
  dynamic finance;

  Result(
      {this.weight,
      this.nerName,
      this.entityId,
      this.entityName,
      this.entityType,
      this.entityUniqueId,
      this.finance});

  Result.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    nerName = json['nerName'];
    entityId = json['entityId'];
    entityName = json['entityName'];
    entityType = json['entityType'];
    entityUniqueId = json['entityUniqueId'];
    finance = json['finance'];
  }
}

class NewsArray {
  dynamic id;
  String url;
  String title;
  String siteName;
  String mobileUrl;
  String autherName;
  num duplicateId;
  String publishDate;
  num statementType;

  NewsArray(
      {this.id,
      this.url,
      this.title,
      this.siteName,
      this.mobileUrl,
      this.autherName,
      this.duplicateId,
      this.publishDate,
      this.statementType});

  NewsArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    siteName = json['siteName'];
    mobileUrl = json['mobileUrl'];
    autherName = json['autherName'];
    duplicateId = json['duplicateId'];
    publishDate = json['publishDate'];
    statementType = json['statementType'];
  }
}

class EventData {
  int id;
  String topicId;
  int eventType;
  String entityId;
  String entityType;
  String entityName;
  int state;
  String createdAt;
  String updatedAt;

  EventData(
      {this.id,
      this.topicId,
      this.eventType,
      this.entityId,
      this.entityType,
      this.entityName,
      this.state,
      this.createdAt,
      this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topicId'];
    eventType = json['eventType'];
    entityId = json['entityId'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class Extra {
  bool instantView;

  Extra({this.instantView});

  Extra.fromJson(Map<String, dynamic> json) {
    instantView = json['instantView'];
  }
}

class InstantView {
  String url;
  String title;
  String content;
  String siteName;

  InstantView({this.url, this.title, this.content, this.siteName});

  InstantView.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    content = json['content'];
    siteName = json['siteName'];
  }

}


class NewCount {
  int count;
  List<TopicId> data;

  NewCount({this.count, this.data});

  NewCount.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<TopicId>();
      json['data'].forEach((v) {
        data.add(new TopicId.fromJson(v));
      });
    }
  }
}

class TopicId {
  String id;

  TopicId({this.id});

  TopicId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}