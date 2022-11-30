// To parse this JSON data, do
//
//     final loadGroupMessagesModel = loadGroupMessagesModelFromJson(jsonString);

import 'dart:convert';

LoadGroupMessagesModel loadGroupMessagesModelFromJson(String str) => LoadGroupMessagesModel.fromJson(json.decode(str));

String loadGroupMessagesModelToJson(LoadGroupMessagesModel data) => json.encode(data.toJson());

class LoadGroupMessagesModel {
  LoadGroupMessagesModel({
    this.item1,
    this.item2,
  });

  Item1 item1;
  List<Item2> item2;

  factory LoadGroupMessagesModel.fromJson(Map<String, dynamic> json) => LoadGroupMessagesModel(
    item1: Item1.fromJson(json["Item1"]),
    item2: List<Item2>.from(json["Item2"].map((x) => Item2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Item1": item1.toJson(),
    "Item2": List<dynamic>.from(item2.map((x) => x.toJson())),
  };
}

class Item1 {
  Item1({
    this.isSuccess,
    this.msg,
  });

  bool isSuccess;
  String msg;

  factory Item1.fromJson(Map<String, dynamic> json) => Item1(
    isSuccess: json["IsSuccess"],
    msg: json["Msg"],
  );

  Map<String, dynamic> toJson() => {
    "IsSuccess": isSuccess,
    "Msg": msg,
  };
}

class Item2 {
  Item2({
    this.text,
    this.createdDate,
    this.seen,
    this.fromId,
    this.toId,
    this.fromName,
    this.toName,
    this.filePath,
    this.count,
    this.statusModal,
  });

  String text;
  DateTime createdDate;
  dynamic seen;
  String fromId;
  String toId;
  String fromName;
  String toName;
  String filePath;
  int count;
  dynamic statusModal;

  factory Item2.fromJson(Map<String, dynamic> json) => Item2(
    text: json["Text"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    seen: json["Seen"],
    fromId: json["FromId"],
    toId: json["ToId"],
    fromName: json["FromName"],
    toName: json["ToName"],
    filePath: json["FilePath"],
    count: json["Count"],
    statusModal: json["StatusModal"],
  );

  Map<String, dynamic> toJson() => {
    "Text": text,
    "CreatedDate": createdDate.toIso8601String(),
    "Seen": seen,
    "FromId": fromId,
    "ToId": toId,
    "FromName": fromName,
    "ToName": toName,
    "FilePath": filePath,
    "Count": count,
    "StatusModal": statusModal,
  };
}
