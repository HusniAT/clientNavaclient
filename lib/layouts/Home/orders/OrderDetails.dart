import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart' as map;
import 'package:navaclient/helpers/constants/LoadingDialog.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:navaclient/helpers/constants/base.dart';
import 'package:navaclient/helpers/customs/AppBarFoot.dart';
import 'package:navaclient/helpers/customs/CustomButton.dart';
import 'package:navaclient/helpers/customs/Loading.dart';
import 'package:navaclient/helpers/customs/QrInvoice.dart';
import 'package:navaclient/helpers/models/OrderDetailsModel.dart';
import 'package:navaclient/layouts/Home/Home.dart';
import 'package:navaclient/layouts/settings/contact_us/ContactUs.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../../../helpers/customs/LabelTextField.dart';
import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import '../cart/MadaWebView.dart';
import '../cart/VisaWebView.dart';
import 'Star_Rating.dart';
import 'SuccessfulOrder.dart';
import 'invoice.dart';

class OrderDetails extends StatefulWidget {
  final int id;

  OrderDetails({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController scrollController = ScrollController();
  double rating;
  String commentText;
  TextEditingController _textFieldController = TextEditingController();
  Future<void> MessagesaGuarantee() async {
    //print(widget.id);
    String Message = _textFieldController.text;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // API URL
    final url = Uri.http(
      URL,
      "api/order-guarantee",
    );
    LoadingDialog.showLoadingDialog();
    try {
      var response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "order_id": widget.id,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet';
      });
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          //Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Sent Successfully");
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      } else {
        EasyLoading.dismiss();
        print("${response.statusCode}");
      }
    } catch (err) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Sorry you cant add guarntee");
    }
  }

  @override
  var message;
  GlobalKey<FormState> _formKey = new GlobalKey();

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(tr("hasBeenSent")),
      ),
    );
  }

  void initState() {
    print(widget.id);
    getOrderDetails();
    super.initState();
  }

  double calculateTotalPrice() {
    double total = 0;
    orderDetailsModel.data.details.services.forEach((element) {
      total += element.total;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "${tr("orderDetails")} ${loading ? "" : orderDetailsModel.data.details.orderNum}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
        actions: [
          CustomChatButton(ctx: context,),
        ],

      ),

      bottomSheet: loading
          ? MyLoading()
          : Container(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  orderDetailsModel.data.details.isPayment &&
                          orderDetailsModel.data.status == "in-progress"
                      ? CustomButton(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          title: tr("payingOff"),
                          width: MediaQuery.of(context).size.width * 0.8,
                          onTap: () async {
                            print("====================================");
                            print(orderDetailsModel.data.payType);
                            print("====================================");
                            if (orderDetailsModel.data.details.payType ==
                                    'cash' ||
                                orderDetailsModel.data.details.payType ==
                                    "كاش" ||
                                orderDetailsModel.data.details.payType ==
                                    'wallet' ||
                                orderDetailsModel.data.details.payType ==
                                    "محفطه") {
                              await payWithWalletOrCash(
                                orderDetailsModel.data.details.id,
                              ).then(
                                (value) {
                                  if (value == 'success') {
                                    //notification add here
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return RatingDialog(
                                              title: Text(
                                                tr(
                                                  "rateTechnical",
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              message: Text(
                                                tr('anyComments'),
                                                textAlign: TextAlign.center,
                                              ),
                                              image: Icon(
                                                Icons.star,
                                                size: 100,
                                                color: Color(0xff2BC3F3),
                                              ),
                                              submitButtonText: tr('done'),
                                              onSubmitted: (response) async {
                                                await rateOrder(response.rating,
                                                    response.comment);
                                              });
                                        });
                                  }
                                },
                              );
                            } else if (orderDetailsModel.data.details.payType ==
                                'visa') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => VisaWebView(
                                    orderId: orderDetailsModel.data.details.id,
                                  ),
                                ),
                              );
                            } else if (orderDetailsModel.data.details.payType ==
                                'mada') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => MadaWebView(
                                    orderId: orderDetailsModel.data.details.id,
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      : orderDetailsModel.data.invoice
                          ? CustomButton(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              title: tr("showInvoice"),
                              width: MediaQuery.of(context).size.width * 0.8,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (c) => Invoice(
                                      billNo: orderDetailsModel.data.billId,
                                    ),
                                  ),
                                );
                              },
                            )
                          : orderDetailsModel.data.status == "created"
                              ? CustomButton(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  title: tr("cancelOrder"),
                                  color: MyColors.red,
                                  onTap: () {
                                    cancelOrder();
                                  },
                                )
                              : orderDetailsModel.data.status == "finished"
                                  ? CustomButton(
                                      // margin:
                                      //     EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      title: tr("addGuarantee"),
                                      //color: MyColors.accent,
                                      //borderColor: MyColors.offPrimary,
                                      //textColor: MyColors.offPrimary,
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Form(
                                                key: _formKey,
                                                child: AlertDialog(
                                                  title: Text(
                                                    tr("messagesGuarantee"),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: MyColors.black,
                                                    ),
                                                  ),
                                                  content: TextField(
                                                    controller:
                                                        _textFieldController,
                                                    decoration: InputDecoration(
                                                      hintText: tr("writeHere"),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    new TextButton(
                                                      onPressed: () {
                                                        _textFieldController
                                                            .text = "";
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        tr("cancel"),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColors
                                                              .offPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                    new TextButton(
                                                      child: new Text(
                                                        tr("send"),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyColors
                                                              .offPrimary,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (_textFieldController
                                                            .text.isNotEmpty) {
                                                          await MessagesaGuarantee();
                                                          _textFieldController
                                                              .text = "";
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          _textFieldController
                                                              .text = "";
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      })
                                  : Container(),
                ],
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: loading
            ? MyLoading()
            : ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyColors.containerColor),
                    child: Column(
                      children: [
                        followItem(
                          title: orderDetailsModel.data.allStatus.created,
                          done: orderDetailsModel.data.status == "created"
                              ? true
                              : false,
                          location: "top",
                        ),
                        followItem(
                          title: orderDetailsModel.data.allStatus.accepted,
                          done: orderDetailsModel.data.status == "accepted"
                              ? true
                              : false,
                          location: "",
                        ),
                        followItem(
                            title: orderDetailsModel.data.allStatus.arrived,
                            done: orderDetailsModel.data.status == "arrived"
                                ? true
                                : false,
                            location: ""),
                        followItem(
                            title: orderDetailsModel.data.allStatus.inProgress,
                            done: orderDetailsModel.data.status == "in-progress"
                                ? true
                                : false,
                            location: ""),
                        Visibility(
                          visible: orderDetailsModel.data.invoice,
                          child: followItem(
                              title: ("thereIsNewInvoice").tr(),
                              done:
                                  orderDetailsModel.data.status == "new-invoice"
                                      ? true
                                      : false,
                              location: ""),
                        ),
                        followItem(
                            title: orderDetailsModel.data.allStatus.finished,
                            done: orderDetailsModel.data.status == "finished"
                                ? true
                                : false,
                            location: "end"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    // margin: EdgeInsets.only(top: 18, right: 12, left: 12),
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      //color: MyColors.white,
                      borderRadius: BorderRadius.circular(5),
                      //border: Border.all(color: Colors.grey.shade400),
                      color: MyColors.containerColor,
                    ),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text:tr("neighbor")+" : ",
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "x",//orderDetailsModel.data.details.,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                  )
                                ]
                            )

                        ),
                        RichText(
                            text: TextSpan(
                                text:tr("street")+" : ",
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: orderDetailsModel.data.details.street,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                  )
                                ]
                            )

                        ),
                        RichText(
                            text: TextSpan(
                                text:tr("house")+" : ",
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "x",//orderDetailsModel.data.details.,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                  )
                                ]
                            )

                        ),
                        RichText(
                            text: TextSpan(
                                text:tr("floor")+" : ",
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: orderDetailsModel.data.details.floor,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                  )
                                ]
                            )

                        ),
                        RichText(
                            text: TextSpan(
                                text:tr("addressNotes")+" : ",
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: orderDetailsModel.data.details.addressNotes,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                  )
                                ]
                            )

                        ),


                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: MyColors.secondary,
                      borderRadius: BorderRadius.circular(5),
                      //border: Border.all(width: .5),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Text(
                                //  'القسم :  ',
                                tr("category")+' :  ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                orderDetailsModel.data.details.categoryTitle,
                                // 'كهرباء',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          // ListTile(
                          //   title:,
                          //   trailing:,
                          //
                          //   //Text(orderDetailsModel.data!.orderNum!,style: TextStyle(fontWeight: FontWeight.bold),),
                          // ),

                          Row(
                            children: [
                              Text(
                                // 'الخدمات :',

                                tr("services")+' :  ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Container(
                            //height: 260.0 * cartDetailsModel.data.services.length,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                orderDetailsModel.data.details.services.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (c, i) {
                                  return serviceItem2(
                                    index: i,
                                    // img: orderDetailsModel
                                    //     .data!.services![i].image,
                                    title: orderDetailsModel
                                        .data.details.services[i].title,
                                    price: orderDetailsModel
                                        .data.details.services[i].total
                                        .toString(),
                                  );
                                }),
                          ),
                          //
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           RichText(
                          //               text: TextSpan(
                          //                   text: "Service : ",
                          //                   style: TextStyle(color: Colors.grey),
                          //                   children: <TextSpan>[
                          //                     TextSpan(
                          //                       text: "title",
                          //                       style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                          //                     )
                          //                   ]
                          //               )
                          //
                          //           ),
                          //
                          //         ],
                          //       ),
                          //
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          //   child: Row(children: [
                          //     Text(
                          //       "الخدمة : ",
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //
                          //   ],),
                          // ),
                          //
                          // Container(
                          //   height: cartModel.data.services[index].services.length * 30.0,
                          //   child: ListView.builder(
                          //     shrinkWrap: true,
                          //     physics: NeverScrollableScrollPhysics(),
                          //     padding: const EdgeInsets.symmetric(horizontal: 8),
                          //     itemCount: cartModel.data.services[index].services.length,
                          //     itemBuilder: (c, i) => cartServiceItem(
                          //       title: cartModel.data.services[index].services[i].title,
                          //       price:
                          //       cartModel.data.services[index].services[i].price.toString(),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ) ,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.containerColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 7,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                tr("valueAddedTax"),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),


                              ),
                              Spacer(),
                              Text(
                                "12",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),



                              ),
                              Text(
                                " "+ tr("rs"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              ),



                            ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                tr("total"),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),


                              ),
                              Spacer(),
                              Text(
                                "12",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),



                              ),
                              Text(
                                " "+ tr("rs"),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),



                            ],),
                        ),

                        // RichText(
                        //     text: TextSpan(
                        //         text:tr("neighbor")+" : ",
                        //         style: TextStyle(color: Colors.grey),
                        //         children: <TextSpan>[
                        //           TextSpan(
                        //             text: "x",//orderDetailsModel.data.details.,
                        //             style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                        //           )
                        //         ]
                        //     )
                        //
                        // ),
                        //
                        // ListTile(
                        //   title: Text(
                        //     tr("payWay"),
                        //   ),
                        //   trailing: Text(
                        //     orderDetailsModel.data.payType,
                        //     style: TextStyle(
                        //       color: MyColors.offPrimary,
                        //     ),
                        //   ),
                        // ),
                        // ListTile(
                        //   title: Text(
                        //     "Total",
                        //   ),
                        //   trailing: Text(
                        //     orderDetailsModel.data.details.total,
                        //     style: TextStyle(
                        //       color: MyColors.offPrimary,
                        //     ),
                        //   ),
                        // ),

                      ],
                    ),
                  ),


                  SizedBox(
                    height: 10,
                  ),



                  //
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.containerColor,
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "${tr("category")}: ",
                  //         style: TextStyle(color: MyColors.grey),
                  //       ),
                  //       Text(
                  //         orderDetailsModel.data.details.services[0].title,
                  //         style: TextStyle(
                  //             //fontSize: 18,
                  //             //fontWeight: FontWeight.bold,
                  //             fontFamily: 'Tajawal-Bold'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.containerColor,
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       ListTile(
                  //         contentPadding: EdgeInsets.zero,
                  //         title: Text(
                  //           tr("address"),
                  //           style: TextStyle(fontFamily: 'Tajawal-Bold'),
                  //         ),
                  //         trailing: ElevatedButton(
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: MyColors.primary,
                  //             elevation: 0,
                  //           ),
                  //           onPressed: () async {
                  //             final coords = map.Coords(
                  //                 orderDetailsModel.data.details.lat,
                  //                 orderDetailsModel.data.details.lng);
                  //             if (await map.MapLauncher.isMapAvailable(
                  //                 map.MapType.google)) {
                  //               await map.MapLauncher.showMarker(
                  //                 mapType: map.MapType.google,
                  //                 coords: coords,
                  //                 title: 'عنوان العميل',
                  //                 description:
                  //                     orderDetailsModel.data.details.street,
                  //               );
                  //             } else if (await map.MapLauncher.isMapAvailable(
                  //                 map.MapType.apple)) {
                  //               await map.MapLauncher.showMarker(
                  //                 mapType: map.MapType.apple,
                  //                 coords: coords,
                  //                 title: 'عنوان العميل',
                  //                 description: '',
                  //               );
                  //             }
                  //             // MapsLauncher.launchCoordinates(
                  //             //     cartDetailsModel.data.lat, cartDetailsModel.data.lng);
                  //           },
                  //           child: Text(tr("showMap")),
                  //         ),
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             "${tr("city")} : ",
                  //             style: TextStyle(fontSize: 15),
                  //           ),
                  //           Text(
                  //             orderDetailsModel.data.details.region,
                  //             style: TextStyle(
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       if (orderDetailsModel
                  //           .data.details.addressNotes.isNotEmpty)
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //       if (orderDetailsModel
                  //           .data.details.addressNotes.isNotEmpty)
                  //         Row(
                  //           children: [
                  //             Text(
                  //               "${tr("addedNotes")} : ",
                  //               style: TextStyle(fontSize: 15),
                  //             ),
                  //             Text(
                  //               orderDetailsModel.data.details.addressNotes,
                  //               style: TextStyle(
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),
                  //
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.containerColor,
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         tr("serviceDetails"),
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //           color: MyColors.offPrimary,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Container(
                  //         //height: 260.0 * cartDetailsModel.data.services.length,
                  //         child: ListView.builder(
                  //             shrinkWrap: true,
                  //             itemCount: orderDetailsModel
                  //                 .data.details.services.length,
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemBuilder: (c, i) {
                  //               return serviceItem(
                  //                 index: i,
                  //                 img: orderDetailsModel
                  //                     .data.details.services[i].image,
                  //                 title: orderDetailsModel
                  //                     .data.details.services[i].title,
                  //                 price: orderDetailsModel
                  //                     .data.details.services[i].total
                  //                     .toString(),
                  //               );
                  //             }),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     color: MyColors.containerColor,
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       if (orderDetailsModel.data.details.bills.isNotEmpty)
                  //         Text(
                  //           tr("extraBills"),
                  //           style: TextStyle(fontSize: 18),
                  //         ).tr(),
                  //       ...orderDetailsModel.data.details.bills.map(
                  //         (e) => Column(
                  //           children: [
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Text(tr("billDetails")),
                  //                 Spacer(),
                  //                 SizedBox(height: 50, child: Text(e.text)),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Text(tr("vat")),
                  //                 Spacer(),
                  //                 Text(e.tax.toString()),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 10,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Text(tr("total")),
                  //                 Spacer(),
                  //                 Text(e.price.toString()),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             tr("vat"),
                  //             style: TextStyle(fontSize: 16),
                  //           ),
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(horizontal: 4),
                  //                 child: Text(
                  //                   orderDetailsModel.data.details.tax
                  //                       .toString(),
                  //                   style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //               Text(
                  //                 tr("rs"),
                  //                 style: TextStyle(
                  //                     fontSize: 14, color: MyColors.grey),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             tr("total"),
                  //             style: TextStyle(
                  //                 fontSize: 16, fontWeight: FontWeight.bold),
                  //           ),
                  //           Row(
                  //             children: [
                  //               Padding(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(horizontal: 4),
                  //                 child: Text(
                  //                   orderDetailsModel.data.details.total
                  //                       .toString(),
                  //                   style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold),
                  //                 ),
                  //               ),
                  //               Text(
                  //                 tr("rs"),
                  //                 style: TextStyle(
                  //                     fontSize: 14, color: MyColors.grey),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.containerColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      title: Text(
                        tr("payWay"),
                      ),
                      trailing: Text(
                        orderDetailsModel.data.payType,
                        style: TextStyle(
                          color: MyColors.offPrimary,
                        ),
                      ),
                    ),
                  ),

                  //Image BarCode
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: MyColors.containerColor,
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: Text(
                  //     tr("elecInvoice"),
                  //     style: TextStyle(fontFamily: 'Tajawal-Bold'),
                  //   ),
                  // ),
                  // QrInvoice(
                  //   price: calculateTotalPrice(),
                  //   date: orderDetailsModel.data.details.date,
                  //   tax: orderDetailsModel.data.details.tax,
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.11,
                  )
                ],
              ),
      ),
    );
  }

  Future rateOrder(double rate, String comment) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    final url = Uri.http(URL, "api/rate-order-tech");
    print(orderDetailsModel.data.details.id);
    try {
      final httpResponse = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${preferences.getString("token")}",
        },
        body: {
          "order_id": orderDetailsModel.data.details.id,
          "rate": rate,
          "comment": comment,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(httpResponse.body);
      if (httpResponse.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessfulOrder(),
            ),
          );
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessfulOrder(),
            ),
          );
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessfulOrder(),
        ),
      );
      //Fluttertoast.showToast(msg: "Somthing went wrong");
    }
    // rating="${response.rating}" as double;
    // commentText="${response.rating}";
    // print("Value Rating : "+ rating.toString());
    // print("Value Comment : "+commentText.toString());
  }

  Widget followItem({String title, bool done, String location}) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              // width: 25,
              // height: 55,
              // margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                //color: MyColors.white,
                borderRadius: location == "top"
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                    : location == "end"
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                        : BorderRadius.circular(0),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: done
                        ? MyColors.primary
                        : MyColors.grey.withOpacity(.8),
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: done ? 18 : 16,
                        fontWeight: done ? FontWeight.bold : FontWeight.normal),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget serviceItem({int index, String img, title, price}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: MediaQuery.of(context).size.width,
      // height: 150,
      decoration: BoxDecoration(
          //color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // height:
            //     orderDetailsModel.data.details.services[index].services.length *
            //         26.0,
            child: ListView.builder(
              itemCount: orderDetailsModel
                  .data.details.services[index].services.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    orderDetailsModel
                        .data.details.services[index].services[i].title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MyColors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("price"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tr("rs"),
                      style: TextStyle(fontSize: 14, color: MyColors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget serviceItem2({int index, String img, title, price}) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(bottom: 3),
      width: MediaQuery.of(context).size.width,
      // height: 150,
      decoration: BoxDecoration(
        //  color: MyColors.grey,
        //  borderRadius: BorderRadius.circular(5),
        // border: Border.all(),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   title,
          //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
            orderDetailsModel.data.details.services[index].services.length,
            itemBuilder: (c, i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                   // orderDetailsModel.data.details.services[index].title,
                    //tr("price"),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(
                       // orderDetailsModel.data.details.services[index].total.toString(),
                         price,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                       " "+ tr("rs"),
                        style: TextStyle(fontSize: 14, color: MyColors.grey),
                      ),
                    ],
                  ),
                ],
              );

              //   Text(
              //   orderDetailsModel.data!.services![index].services![i].title!,
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.bold,
              //     color: MyColors.offPrimary,
              //   ),
              // );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       tr("price"),
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           price,
          //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //         ),
          //         Text(
          //           tr("rs"),
          //           style: TextStyle(fontSize: 14, color: MyColors.grey),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  bool loading = true;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel();

  Future getOrderDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token"));
    final url = Uri.http(URL, "api/order-details");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          orderDetailsModel = OrderDetailsModel.fromJson(responseData);
          print(response.body);
          print(orderDetailsModel.data.status);
          _add();
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
      setState(() {
        loading = false;
      });
    } catch (e, t) {
      setState(() {
        loading = false;
      });
      print("error $e" + " ==>> track $t");
    }
  }

  Future cancelOrder() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/order-cancel");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => Home()), (route) => false);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future granteeOrder() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/order-guarantee");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => Home()), (route) => false);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(orderDetailsModel.data.details.lat,
          orderDetailsModel.data.details.lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future payWithWalletOrCash(int billNo) async {
    String endPoint;
    if (orderDetailsModel.data.payType == 'كاش' ||
        orderDetailsModel.data.payType == 'cash') {
      endPoint = "api/pay-cash";
    } else if (orderDetailsModel.data.payType == 'محفظه' ||
        orderDetailsModel.data.payType == 'wallet') {
      endPoint = "api/wallet-pay";
    }
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(
      URL,
      endPoint,
      {
        "lang": preferences.getString("lang"),
        "order_id": billNo.toString(),
      },
    );
    print(url);
    try {
      final response = await http.post(url, headers: {
        "Authorization": "Bearer ${preferences.getString("token")}"
      }).timeout(
        Duration(seconds: 10),
        onTimeout: () => throw 'no internet please connect to internet',
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          return responseData["key"];
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
          return responseData["key"];
        }
      }
      EasyLoading.dismiss();
    } catch (e, t) {
      EasyLoading.dismiss();
      print("error $e   track $t");
    }
  }
}
