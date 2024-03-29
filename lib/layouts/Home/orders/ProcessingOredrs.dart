import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:navaclient/helpers/constants/base.dart';
import 'package:navaclient/helpers/customs/EmptyBox.dart';
import 'package:navaclient/helpers/customs/Loading.dart';
import 'package:navaclient/helpers/models/ProcessingOrdersModel.dart';
import 'package:navaclient/layouts/Home/orders/ChatScreen.dart';
import 'package:navaclient/layouts/Home/orders/OrderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessingOrders extends StatefulWidget {
  @override
  _ProcessingOrdersState createState() => _ProcessingOrdersState();
}

class _ProcessingOrdersState extends State<ProcessingOrders> {
  @override
  void initState() {
    getProcessingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? MyLoading()
          :
      processingOrdersModel.data.length == 0

        //processingOrdersModel.data.length == 0
              ? EmptyBox(
                  title: tr("noOrders"),
                  widget: Container(),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  padding: EdgeInsets.all(20),
                  itemCount:4,

                  //processingOrdersModel.data.length,
                  itemBuilder: (c, i) {

                    return orderItem2(id: 1,);
                    // return orderItem(
                    //   id: processingOrdersModel.data[i].id,
                    //   title: processingOrdersModel.data[i].categoryTitle,
                    //   icon: processingOrdersModel.data[i].categoryIcon,
                    //   orderNum: processingOrdersModel.data[i].orderNum,
                    //   price: processingOrdersModel.data[i].price,
                    //   status: processingOrdersModel.data[i].status,
                    //   roomId: processingOrdersModel.data[i].roomId,
                    // );
                  }),
    );
  }

  Widget orderItem(
      {int id, roomId, String title, status, price, orderNum, icon}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => OrderDetails(
              id: id,
            ),
          ),
        );
      },
      child: Container(
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
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("totalPrice"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  price + " " + tr("rs"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Divider(
            //   thickness: 1,
            //   height: 2,
            //   color: Colors.grey.shade400,
            //   indent: 8,
            //   endIndent: 8,
            // ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("orderNum"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  orderNum,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: roomId != 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("ContactTheTechnician"),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        splashColor: MyColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                roomId: roomId,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Mdi.messageTextOutline,
                            size: 32,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderItem2({int id})
  {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => OrderDetails(
              id: 18,
            ),
          ),
        );
      },
      child: Container(
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

            Row(

              children: [
                RichText(
                    text: TextSpan(
                      text:tr("section")+" : ",
                      style: TextStyle(color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Electric",
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                        )
                      ]
                    )

                ),
                Spacer(),
                RichText(
                    text: TextSpan(
                        text:tr("date")+" : ",
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: "12/12/2022",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          )
                        ]
                    )

                ),


              ],
            ),
            SizedBox(height: 3,),
            Row(

              children: [
                RichText(
                    text: TextSpan(
                        text:tr("service")+" : ",
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: "aaa",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          )
                        ]
                    )

                ),
                Spacer(),
                RichText(
                    text: TextSpan(
                        text:tr('time')+" : ",
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: "12:22 am",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          )
                        ]
                    )

                ),


              ],
            ),
            SizedBox(height: 3,),

            Row(

              children: [
                RichText(
                    text: TextSpan(
                        text:tr("total")+" : ",
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: "20 RS",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          )
                        ]
                    )

                ),
                Spacer(),
                RichText(
                    text: TextSpan(
                        text:tr("orderNum")+" : ",
                        style: TextStyle(color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: "1234",
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                          )
                        ]
                    )

                ),


              ],
            ),

            // Text(
            //   title,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       tr("totalPrice"),
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     Text(
            //       price + " " + tr("rs"),
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
            // // Divider(
            // //   thickness: 1,
            // //   height: 2,
            // //   color: Colors.grey.shade400,
            // //   indent: 8,
            // //   endIndent: 8,
            // // ),
            // SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       tr("orderNum"),
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     Text(
            //       orderNum,
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),
            // Visibility(
            //   visible: roomId != 0,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 10, right: 8, left: 8),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(tr("ContactTheTechnician"),
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.w600,
            //             )),
            //         Material(
            //           borderRadius: BorderRadius.circular(8),
            //           child: InkWell(
            //             splashColor: MyColors.primary,
            //             borderRadius: BorderRadius.circular(8),
            //             onTap: () {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(
            //                   builder: (_) => ChatScreen(
            //                     roomId: roomId,
            //                   ),
            //                 ),
            //               );
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.all(6.0),
            //               child: Icon(
            //                 Mdi.messageTextOutline,
            //                 size: 32,
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  bool loading = true;
  ProcessingOrdersModel processingOrdersModel = ProcessingOrdersModel();
  Future getProcessingOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/my-orders/current");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          // "uuid": preferences.getString("uuid"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          print("----------------------------------------");
          processingOrdersModel = ProcessingOrdersModel.fromJson(responseData);
          print("----------------------------------------");

        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}
