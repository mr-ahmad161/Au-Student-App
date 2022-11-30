// To parse this JSON data, do
//
//     final paymentRequestModel = paymentRequestModelFromJson(jsonString);

import 'dart:convert';

PaymentRequestModel paymentRequestModelFromJson(String str) => PaymentRequestModel.fromJson(json.decode(str));

String paymentRequestModelToJson(PaymentRequestModel data) => json.encode(data.toJson());

class PaymentRequestModel {
  PaymentRequestModel({
    this.studentId,
    this.firstName,
    this.lastName,
    this.email,
    this.amountToPay,
    this.billingAddress,
    this.billingCity,
    this.billingCountry,
  });

  String studentId;
  String firstName;
  String lastName;
  String email;
  double amountToPay;
  String billingAddress;
  String billingCity;
  String billingCountry;

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) => PaymentRequestModel(
    studentId: json["StudentID"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
    amountToPay: json["AmountToPay"].toDouble(),
    billingAddress: json["BillingAddress"],
    billingCity: json["BillingCity"],
    billingCountry: json["BillingCountry"],
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "AmountToPay": amountToPay,
    "BillingAddress": billingAddress,
    "BillingCity": billingCity,
    "BillingCountry": billingCountry,
  };
}
