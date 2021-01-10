// To parse this JSON data, do
//
//     final getJobsData = getJobsDataFromJson(jsonString);

import 'dart:convert';

List<GetJobsData> getListJobsFromJson(String str) => List<GetJobsData>.from(json.decode(str).map((x) => GetJobsData.fromJson(x)));

String getListJobsToJson(List<GetJobsData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class GetJobsData {
    GetJobsData({
        this.status,
        this.feed,
        this.items,
    });

    String status;
    Feed feed;
    List<Item> items;

    factory GetJobsData.fromJson(Map<String, dynamic> json) => GetJobsData(
        status: json["status"],
        feed: Feed.fromJson(json["feed"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "feed": feed.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Feed {
    Feed({
        this.url,
        this.title,
        this.link,
        this.author,
        this.description,
        this.image,
    });

    String url;
    String title;
    String link;
    String author;
    String description;
    String image;

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        url: json["url"],
        title: json["title"],
        link: json["link"],
        author: json["author"],
        description: json["description"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "link": link,
        "author": author,
        "description": description,
        "image": image,
    };
}

class Item {
    Item({
        this.title,
        this.pubDate,
        this.link,
        this.guid,
        this.author,
        this.thumbnail,
        this.description,
        this.content,
        this.enclosure,
        this.categories,
    });

    String title;
    DateTime pubDate;
    String link;
    String guid;
    Author author;
    String thumbnail;
    Description description;
    String content;
    Enclosure enclosure;
    List<String> categories;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        title: json["title"],
        pubDate: DateTime.parse(json["pubDate"]),
        link: json["link"],
        guid: json["guid"],
        author: authorValues.map[json["author"]],
        thumbnail: json["thumbnail"],
        description: descriptionValues.map[json["description"]],
        content: json["content"],
        enclosure: Enclosure.fromJson(json["enclosure"]),
        categories: List<String>.from(json["categories"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "pubDate": pubDate.toIso8601String(),
        "link": link,
        "guid": guid,
        "author": authorValues.reverse[author],
        "thumbnail": thumbnail,
        "description": descriptionValues.reverse[description],
        "content": content,
        "enclosure": enclosure.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
    };
}

enum Author { PUPUT, SUGI }

final authorValues = EnumValues({
    "puput": Author.PUPUT,
    "Sugi": Author.SUGI
});

enum Description { EMPTY }

final descriptionValues = EnumValues({
    "...": Description.EMPTY
});

class Enclosure {
    Enclosure();

    factory Enclosure.fromJson(Map<String, dynamic> json) => Enclosure(
    );

    Map<String, dynamic> toJson() => {
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
