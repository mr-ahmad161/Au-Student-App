// To parse this JSON data, do
//
//     final section = sectionFromJson(jsonString);

import 'dart:convert';

List<Section> sectionFromJson(String str) => List<Section>.from(json.decode(str).map((x) => Section.fromJson(x)));

String sectionToJson(List<Section> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Section {
  Section({
    this.sectionId,
    this.courseId,
    this.courseCode,
    this.courseName,
    this.faculty,
    this.isAccessibleByStudent,
    this.notAccessibleMessage,
    this.facultyImage,
    this.sectionCode,
    this.mergeId,
    this.facultyId
  });

  int sectionId;
  int courseId;
  String courseCode;
  String courseName;
  String faculty;
  bool isAccessibleByStudent;
  String notAccessibleMessage;
  String facultyImage;
  String facultyId;
  String sectionCode;
  String mergeId;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json["SectionID"],
    courseId: json["CourseID"],
    courseCode: json["CourseCode"],
    courseName: json["CourseName"],
    faculty: json["Faculty"],
    isAccessibleByStudent: json["IsAccessibleByStudent"],
    notAccessibleMessage: json["NotAccessibleMessage"],
    facultyImage: json["FacultyImage"],
    facultyId: json["FacultyID"],
    sectionCode: json["SectionCode"],
    mergeId: json["MergeID"],
  );

  Map<String, dynamic> toJson() => {
    "SectionID": sectionId,
    "CourseID": courseId,
    "CourseCode": courseCode,
    "CourseName": courseName,
    "Faculty": faculty,
    "IsAccessibleByStudent": isAccessibleByStudent,
    "NotAccessibleMessage": notAccessibleMessage,
    "FacultyImage": facultyImage,
    "FacultyID": facultyId,
    "SectionCode": sectionCode,
    "MergeID": mergeId
  };
}
