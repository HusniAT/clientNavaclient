// // To parse this JSON data, do
// //
// //     final processingOrdersModel = processingOrdersModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ProcessingOrdersModel processingOrdersModelFromJson(String str) =>
//     ProcessingOrdersModel.fromJson(json.decode(str));
//
// String processingOrdersModelToJson(ProcessingOrdersModel data) =>
//     json.encode(data.toJson());
//
// class ProcessingOrdersModel {
//   ProcessingOrdersModel({
//     this.key,
//     this.msg,
//     this.data,
//   });
//
//   String key;
//   String msg;
//   List<Datum> data;
//
//   factory ProcessingOrdersModel.fromJson(Map<String, dynamic> json) =>
//       ProcessingOrdersModel(
//         key: json["key"],
//         msg: json["msg"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "key": key,
//         "msg": msg,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }
//
// class Datum {
//   Datum(
//       {
//         this.id,
//        // this.address,
//       this.orderNum,
//       this.categoryTitle,
//        // this.createdAt,
//       //  this.date,
//       //  this.time,
//         this.status,
//        // this.price,
//
//
//         this.roomId,
//       this.categoryIcon,
//
//       });
//
//   int id;
//  // String address;
//   String orderNum;
//   String categoryTitle;
//  // String createdAt;
// ////  String date;
//   String time;
//   String status;
//  // String price;
//  // List<ServiceData> service;
//
//
//
//   String categoryIcon;
//   int roomId;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//
//     orderNum: json["order_num"],
//         categoryTitle: json["category_title"],
//         categoryIcon: json["category_icon"],
//        // price: json["price"],
//         status: json["status"],
//         roomId: json["room_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "order_num": orderNum,
//         "category_title": categoryTitle,
//         "category_icon": categoryIcon,
//         //"price": price,
//         "status": status,
//         "room_id": roomId,
//       };
// }
//
// // class ServiceData {
// //
// //   ServiceData(
// //       {
// //         this.id,
// //         this.title,
// //       });
// //
// //   int id;
// //   String title;
// //
// // }

// To parse this JSON data, do
//
//     final processingOrdersModel = processingOrdersModelFromJson(jsonString);

import 'dart:convert';

ProcessingOrdersModel processingOrdersModelFromJson(String str) =>
    ProcessingOrdersModel.fromJson(json.decode(str));

String processingOrdersModelToJson(ProcessingOrdersModel data) =>
    json.encode(data.toJson());

class ProcessingOrdersModel {
  ProcessingOrdersModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<Datum> data;

  factory ProcessingOrdersModel.fromJson(Map<String, dynamic> json) =>
      ProcessingOrdersModel(
        key: json["key"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    // this.address,
    this.orderNum,
    this.categoryTitle,
    // this.createdAt,
    this.date,
    this.time,
    this.status,
    this.price,

    // this.roomId,
    // this.categoryIcon,
    this.service,
  });

  int id;
  // String address;
  String orderNum;
  String categoryTitle;
  // String createdAt;
  String date;
  String time;
  String status;
  String price;
  List<ServiceData> service;

  // String categoryIcon;
  // int roomId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],

      orderNum: json["order_num"],
      categoryTitle: json["category_title"],
      // categoryIcon: json["category_icon"],
      price: json["price"],
      status: json["status"],
      service: json["service"]
    // roomId: json["room_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "category_title": categoryTitle,
    // "category_icon": categoryIcon,
    "price": price,
    "status": status,
    "service" : service
    // "room_id": roomId,
  };
}

class ServiceData {

  ServiceData(
      {
        this.id,
        this.title,
      });

  int id;
  String title;
  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
      id: json["id"],

    title: json["title"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,

  };

}