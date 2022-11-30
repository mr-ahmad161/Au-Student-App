// To parse this JSON data, do
//
//     final groupsResponseModel = groupsResponseModelFromJson(jsonString);

import 'dart:convert';

GroupsResponseModel groupsResponseModelFromJson(String str) => GroupsResponseModel.fromJson(json.decode(str));

String groupsResponseModelToJson(GroupsResponseModel data) => json.encode(data.toJson());

class GroupsResponseModel {
  GroupsResponseModel({
    this.item1,
    this.item2,
  });

  Item1 item1;
  List<Item2> item2;

  factory GroupsResponseModel.fromJson(Map<String, dynamic> json) => GroupsResponseModel(
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
    this.mergeId,
    this.id,
    this.name,
  });

  String mergeId;
  String id;
  String name;

  factory Item2.fromJson(Map<String, dynamic> json) => Item2(
    mergeId: json["MergeID"],
    id: json["Id"] == null ? null : json["Id"],
    name: json["Name"] == null ? null : json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "MergeID": mergeId,
    "Id": id == null ? null : id,
    "Name": name == null ? null : name,
  };
}
