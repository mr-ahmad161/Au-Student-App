// To parse this JSON data, do
//
//     final paymentApiResponse = paymentApiResponseFromJson(jsonString);

import 'dart:convert';

PaymentApiResponse paymentApiResponseFromJson(String str) => PaymentApiResponse.fromJson(json.decode(str));

String paymentApiResponseToJson(PaymentApiResponse data) => json.encode(data.toJson());

class PaymentApiResponse {
  PaymentApiResponse({
    this.paymentLink,
    this.referenceNumber,
    this.responseBody,
  });

  String paymentLink;
  String referenceNumber;
  ResponseBody responseBody;

  factory PaymentApiResponse.fromJson(Map<String, dynamic> json) => PaymentApiResponse(
    paymentLink: json["PaymentLink"],
    referenceNumber: json["ReferenceNumber"],
    responseBody: ResponseBody.fromJson(json["responseBody"]),
  );

  Map<String, dynamic> toJson() => {
    "PaymentLink": paymentLink,
    "ReferenceNumber": referenceNumber,
    "responseBody": responseBody.toJson(),
  };
}

class ResponseBody {
  ResponseBody({
    this.id,
    this.links,
    this.type,
    this.merchantDefinedData,
    this.action,
    this.amount,
    this.language,
    this.merchantAttributes,
    this.emailAddress,
    this.reference,
    this.outletId,
    this.createDateTime,
    this.paymentMethods,
    this.billingAddress,
    this.referrer,
    this.merchantOrderReference,
    this.formattedAmount,
    this.formattedOrderSummary,
    this.embedded,
  });

  String id;
  ResponseBodyLinks links;
  String type;
  MerchantDefinedData merchantDefinedData;
  String action;
  Amount amount;
  String language;
  MerchantAttributes merchantAttributes;
  String emailAddress;
  String reference;
  String outletId;
  DateTime createDateTime;
  PaymentMethods paymentMethods;
  BillingAddress billingAddress;
  String referrer;
  String merchantOrderReference;
  String formattedAmount;
  FormattedOrderSummary formattedOrderSummary;
  Embedded embedded;

  factory ResponseBody.fromJson(Map<String, dynamic> json) => ResponseBody(
    id: json["_id"],
    links: ResponseBodyLinks.fromJson(json["_links"]),
    type: json["type"],
    merchantDefinedData: MerchantDefinedData.fromJson(json["merchantDefinedData"]),
    action: json["action"],
    amount: Amount.fromJson(json["amount"]),
    language: json["language"],
    merchantAttributes: MerchantAttributes.fromJson(json["merchantAttributes"]),
    emailAddress: json["emailAddress"],
    reference: json["reference"],
    outletId: json["outletId"],
    createDateTime: DateTime.parse(json["createDateTime"]),
    paymentMethods: PaymentMethods.fromJson(json["paymentMethods"]),
    billingAddress: BillingAddress.fromJson(json["billingAddress"]),
    referrer: json["referrer"],
    merchantOrderReference: json["merchantOrderReference"],
    formattedAmount: json["formattedAmount"],
    formattedOrderSummary: FormattedOrderSummary.fromJson(json["formattedOrderSummary"]),
    embedded: Embedded.fromJson(json["_embedded"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "_links": links.toJson(),
    "type": type,
    "merchantDefinedData": merchantDefinedData.toJson(),
    "action": action,
    "amount": amount.toJson(),
    "language": language,
    "merchantAttributes": merchantAttributes.toJson(),
    "emailAddress": emailAddress,
    "reference": reference,
    "outletId": outletId,
    "createDateTime": createDateTime.toIso8601String(),
    "paymentMethods": paymentMethods.toJson(),
    "billingAddress": billingAddress.toJson(),
    "referrer": referrer,
    "merchantOrderReference": merchantOrderReference,
    "formattedAmount": formattedAmount,
    "formattedOrderSummary": formattedOrderSummary.toJson(),
    "_embedded": embedded.toJson(),
  };
}

class Amount {
  Amount({
    this.currencyCode,
    this.value,
  });

  String currencyCode;
  int value;

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    currencyCode: json["currencyCode"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "currencyCode": currencyCode,
    "value": value,
  };
}

class BillingAddress {
  BillingAddress({
    this.firstName,
    this.lastName,
    this.address1,
    this.city,
    this.countryCode,
  });

  String firstName;
  String lastName;
  String address1;
  String city;
  String countryCode;

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    firstName: json["firstName"],
    lastName: json["lastName"],
    address1: json["address1"],
    city: json["city"],
    countryCode: json["countryCode"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "address1": address1,
    "city": city,
    "countryCode": countryCode,
  };
}

class Embedded {
  Embedded({
    this.payment,
  });

  List<Payment> payment;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
    payment: List<Payment>.from(json["payment"].map((x) => Payment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payment": List<dynamic>.from(payment.map((x) => x.toJson())),
  };
}

class Payment {
  Payment({
    this.id,
    this.links,
    this.state,
    this.amount,
    this.updateDateTime,
    this.outletId,
    this.orderReference,
    this.merchantOrderReference,
  });

  String id;
  PaymentLinks links;
  String state;
  Amount amount;
  DateTime updateDateTime;
  String outletId;
  String orderReference;
  String merchantOrderReference;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["_id"],
    links: PaymentLinks.fromJson(json["_links"]),
    state: json["state"],
    amount: Amount.fromJson(json["amount"]),
    updateDateTime: DateTime.parse(json["updateDateTime"]),
    outletId: json["outletId"],
    orderReference: json["orderReference"],
    merchantOrderReference: json["merchantOrderReference"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "_links": links.toJson(),
    "state": state,
    "amount": amount.toJson(),
    "updateDateTime": updateDateTime.toIso8601String(),
    "outletId": outletId,
    "orderReference": orderReference,
    "merchantOrderReference": merchantOrderReference,
  };
}

class PaymentLinks {
  PaymentLinks({
    this.self,
    this.paymentCard,
    this.curies,
  });

  CnpPaymentLink self;
  CnpPaymentLink paymentCard;
  List<Cury> curies;

  factory PaymentLinks.fromJson(Map<String, dynamic> json) => PaymentLinks(
    self: CnpPaymentLink.fromJson(json["self"]),
    paymentCard: CnpPaymentLink.fromJson(json["payment:card"]),
    curies: List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self.toJson(),
    "payment:card": paymentCard.toJson(),
    "curies": List<dynamic>.from(curies.map((x) => x.toJson())),
  };
}

class Cury {
  Cury({
    this.name,
    this.href,
    this.templated,
  });

  String name;
  String href;
  bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
    name: json["name"],
    href: json["href"],
    templated: json["templated"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "href": href,
    "templated": templated,
  };
}

class CnpPaymentLink {
  CnpPaymentLink({
    this.href,
  });

  String href;

  factory CnpPaymentLink.fromJson(Map<String, dynamic> json) => CnpPaymentLink(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class FormattedOrderSummary {
  FormattedOrderSummary();

  factory FormattedOrderSummary.fromJson(Map<String, dynamic> json) => FormattedOrderSummary(
  );

  Map<String, dynamic> toJson() => {
  };
}

class ResponseBodyLinks {
  ResponseBodyLinks({
    this.cnpPaymentLink,
    this.paymentAuthorization,
    this.self,
    this.tenantBrand,
    this.payment,
    this.merchantBrand,
  });

  CnpPaymentLink cnpPaymentLink;
  CnpPaymentLink paymentAuthorization;
  CnpPaymentLink self;
  CnpPaymentLink tenantBrand;
  CnpPaymentLink payment;
  CnpPaymentLink merchantBrand;

  factory ResponseBodyLinks.fromJson(Map<String, dynamic> json) => ResponseBodyLinks(
    cnpPaymentLink: CnpPaymentLink.fromJson(json["cnp:payment-link"]),
    paymentAuthorization: CnpPaymentLink.fromJson(json["payment-authorization"]),
    self: CnpPaymentLink.fromJson(json["self"]),
    tenantBrand: CnpPaymentLink.fromJson(json["tenant-brand"]),
    payment: CnpPaymentLink.fromJson(json["payment"]),
    merchantBrand: CnpPaymentLink.fromJson(json["merchant-brand"]),
  );

  Map<String, dynamic> toJson() => {
    "cnp:payment-link": cnpPaymentLink.toJson(),
    "payment-authorization": paymentAuthorization.toJson(),
    "self": self.toJson(),
    "tenant-brand": tenantBrand.toJson(),
    "payment": payment.toJson(),
    "merchant-brand": merchantBrand.toJson(),
  };
}

class MerchantAttributes {
  MerchantAttributes({
    this.cancelUrl,
    this.redirectUrl,
    this.skipConfirmationPage,
    this.skip3Ds,
    this.cancelText,
  });

  String cancelUrl;
  String redirectUrl;
  String skipConfirmationPage;
  String skip3Ds;
  String cancelText;

  factory MerchantAttributes.fromJson(Map<String, dynamic> json) => MerchantAttributes(
    cancelUrl: json["cancelUrl"],
    redirectUrl: json["redirectUrl"],
    skipConfirmationPage: json["skipConfirmationPage"],
    skip3Ds: json["skip3DS"],
    cancelText: json["cancelText"],
  );

  Map<String, dynamic> toJson() => {
    "cancelUrl": cancelUrl,
    "redirectUrl": redirectUrl,
    "skipConfirmationPage": skipConfirmationPage,
    "skip3DS": skip3Ds,
    "cancelText": cancelText,
  };
}

class MerchantDefinedData {
  MerchantDefinedData({
    this.payerId,
  });

  String payerId;

  factory MerchantDefinedData.fromJson(Map<String, dynamic> json) => MerchantDefinedData(
    payerId: json["payerId"],
  );

  Map<String, dynamic> toJson() => {
    "payerId": payerId,
  };
}

class PaymentMethods {
  PaymentMethods({
    this.card,
  });

  List<String> card;

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
    card: List<String>.from(json["card"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "card": List<dynamic>.from(card.map((x) => x)),
  };
}
