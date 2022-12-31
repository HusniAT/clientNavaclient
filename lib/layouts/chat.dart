import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:navaclient/helpers/constants/LoadingDialog.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:navaclient/helpers/constants/base.dart';
import 'package:navaclient/helpers/customs/AppBarFoot.dart';
import 'package:navaclient/helpers/customs/CustomButton.dart';
import 'package:navaclient/helpers/customs/Loading.dart';
import 'package:navaclient/helpers/customs/Visitor.dart';
import 'package:navaclient/helpers/models/AddToCartModel.dart';
import 'package:navaclient/helpers/models/SubCategoryDetailsModel.dart';
import 'package:navaclient/helpers/providers/visitor_provider.dart';
import 'package:navaclient/layouts/Home/cart/Cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/customs/CustomBackButton.dart';

class Chat extends StatefulWidget {


  const Chat(
      {Key key})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "Chat",
            // widget.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
        // actions: [
        //   CustomChatButton (ctx: context)      ],
      ),
      // bottomSheet: loading
      //     ? MyLoading()
      //     : Padding(
      //         padding: const EdgeInsets.all(20),
      //         child: Container(
      //           width: MediaQuery.of(context).size.width,
      //           //height: MediaQuery.of(context).size.height * .32,
      //           decoration: BoxDecoration(
      //             color: MyColors.secondary,
      //             //border: Border.all(color: MyColors.grey, width: .5),
      //             borderRadius: BorderRadius.circular(5),
      //           ),
      //           child: Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10),
      //                   child: Column(
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Text(tr("vat"), style: TextStyle(fontSize: 14)),
      //                           Row(
      //                             children: [
      //                               Padding(
      //                                 padding: const EdgeInsets.symmetric(
      //                                   horizontal: 5,
      //                                 ),
      //                                 child: Text(
      //                                   addToCartModel.data == null
      //                                       ? subCategoryDetailsModel.data.tax
      //                                           .toString()
      //                                       : addToCartModel.data.tax
      //                                           .toString(),
      //                                   style: TextStyle(
      //                                     fontSize: 15,
      //                                     //fontWeight: FontWeight.bold,
      //                                     color: MyColors.black,
      //                                   ),
      //                                 ),
      //                               ),
      //                               Text(
      //                                 tr("rs"),
      //                                 style: TextStyle(fontSize: 14),
      //                               ),
      //                             ],
      //                           )
      //                         ],
      //                       ),
      //                       Padding(
      //                         padding: const EdgeInsets.symmetric(vertical: 10),
      //                         child: Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Text(
      //                               tr("total"),
      //                               style: TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                             Row(
      //                               children: [
      //                                 Padding(
      //                                   padding: const EdgeInsets.symmetric(
      //                                       horizontal: 5),
      //                                   child: Text(
      //                                     addToCartModel.data == null
      //                                         ? subCategoryDetailsModel
      //                                             .data.price
      //                                             .toString()
      //                                         : addToCartModel.data.price
      //                                             .toString(),
      //                                     style: TextStyle(
      //                                       fontSize: 16,
      //                                       //fontWeight: FontWeight.bold,
      //                                       color: MyColors.black,
      //                                     ),
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   tr("rs"),
      //                                   style: TextStyle(fontSize: 14),
      //                                 ),
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       Divider(),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 20),
      //                   child: Text(
      //                     tr("longText01"),
      //                     style: TextStyle(
      //                         fontSize: 11,
      //                         //fontWeight: FontWeight.bold,
      //                         color: MyColors.grey),
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 ),
      //                 CustomButton(
      //                   height: 40,
      //                   title: tr("continue"),
      //                   onTap: () {
      //                     if (subCategoryDetailsModel.data.price == 0 &&
      //                         addToCartModel.data == null) {
      //                       Fluttertoast.showToast(
      //                         msg: "youShouldAtLeastAddOneServiceToContinue"
      //                             .tr(),
      //                       );
      //                       return;
      //                     }
      //                     Navigator.of(context).push(
      //                       MaterialPageRoute(
      //                         builder: (c) => Cart(
      //                           categoryId: widget.categoryId,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //                 CustomButton(
      //                   height: 40,
      //                   title: tr("goToCart"),
      //                   onTap: () {
      //                     Navigator.of(context).push(
      //                       MaterialPageRoute(
      //                         builder: (c) => Cart(
      //                           categoryId: widget.categoryId,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      body: Container(),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 5,),

            Container(
              color: Colors.grey.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.mic),
              ),
            ),
            SizedBox(width: 5,),
            Container(
              color: Colors.grey.withOpacity(0.3),
              child: IconButton(
                icon: Icon(Icons.attach_file),
              ),
            ),
            SizedBox(width: 5,),

            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message ...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            IconButton(
              onPressed: (){
                print('send');
              },
              icon: Icon(
                Icons.send,
                color: Colors.grey[500],
              ),
            )

          ],
        ),
      ),
    );
  }


}
