import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mdi/mdi.dart';
import 'package:navaclient/helpers/constants/DioBase.dart';
import 'package:navaclient/helpers/constants/LoadingDialog.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:navaclient/helpers/constants/base.dart';
import 'package:navaclient/helpers/customs/AppBarFoot.dart';
import 'package:navaclient/helpers/customs/CustomButton.dart';
import 'package:navaclient/helpers/customs/InkWellTextField.dart';
import 'package:navaclient/helpers/customs/LabelTextField.dart';
import 'package:navaclient/helpers/models/RegionsModel.dart';
import 'package:navaclient/helpers/models/TimesModel.dart';
import 'package:navaclient/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import '../orders/Star_Rating.dart';
import 'DetailedBill.dart';
import 'MapScreen.dart';

class Address extends StatefulWidget {
  final int orderId;

  const Address({Key key, this.orderId}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  // TextEditingController date = new TextEditingController();
  // TextEditingController time = new TextEditingController();
   TextEditingController mapAddress = new TextEditingController();
  // TextEditingController neighbor = new TextEditingController();
  // TextEditingController name = new TextEditingController();
  // TextEditingController email = new TextEditingController();
  // TextEditingController notes = new TextEditingController();

  TextEditingController neighborController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController houseController = new TextEditingController();
  TextEditingController floorController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();

  @override
  void initState() {
   // getRegions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(tr("address"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          leading: CustomBackButton(ctx: context),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWellTextField(
                    fillColor: MyColors.secondary,
                    borderColor: MyColors.secondary,
                    controller: mapAddress,
                    label: address ?? tr("mapAddress"),
                    icon: Icon(
                      Icons.location_on,
                      color: MyColors.black,
                      size: 26,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    onTab: () async {
                      await goToLocationScreen();
                      print("-----> Receipt Address");
                    },
                  ),

                  LabelTextField(
                    controller: neighborController,
                    hint: tr('enterNeighbor'),
                    action: TextInputAction.next,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  LabelTextField(
                    controller: streetController,
                    hint: tr('enterStreet'),
                    action: TextInputAction.next,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  LabelTextField(
                    controller: houseController,
                    hint: tr('enterHouse'),
                    action: TextInputAction.next,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  LabelTextField(
                    controller: floorController,
                    hint: tr('enterFloor'),
                    action: TextInputAction.next,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  // LabelTextField(
                  //   controller: name,
                  //   hint: tr('enterName'),
                  //   action: TextInputAction.next,
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  // ),


                  // LabelTextField(
                  //   controller: name,
                  //   hint: tr('enterName'),
                  //   action: TextInputAction.next,
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  // ),
                  // LabelTextField(
                  //   controller: email,
                  //   hint: tr('enterEmail'),
                  //   type: TextInputType.emailAddress,
                  //   action: TextInputAction.next,
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  // ),
                  // InkWellTextField(
                  //   controller: date,
                  //   label: myDate ?? tr("selectDate"),
                  //   icon: Icon(
                  //     CupertinoIcons.calendar,
                  //     color: MyColors.accent,
                  //     size: 26,
                  //   ),
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  //   onTab: () {
                  //     showDatePicker();
                  //   },
                  // ),
                  // InkWellTextField(
                  //   controller: time,
                  //   label: selectedTime ?? tr("selectTime"),
                  //   icon: Icon(
                  //     CupertinoIcons.time,
                  //     color: MyColors.accent,
                  //     size: 26,
                  //   ),
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  //   onTab: () {
                  //     openTimes();
                  //   },
                  // ),
                  // InkWellTextField(
                  //   controller: neighbor,
                  //   label: selectedNeighbor ?? tr("selectCity"),
                  //   icon: Icon(
                  //     Icons.expand_more,
                  //     color: MyColors.accent,
                  //     size: 30,
                  //   ),
                  //   margin: EdgeInsets.symmetric(vertical: 8),
                  //   onTab: () {
                  //     openNeighbors();
                  //   },
                  // ),
                  LabelTextField(
                    hint: tr("enterNote"),
                    controller: noteController,
                    label: tr("notes"),
                    action: TextInputAction.done,
                    lines: 10,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(height: 4,),
                  CustomButton(
                    title: tr("continue"),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    onTap: () {
                    //  addAddressNotes();
                      Navigator.of(context).push(MaterialPageRoute(
                                    builder: (c) => DetailedBill(
                                             orderId: widget.orderId,
                                           )));
                    },
                  ),
                  SizedBox(height: 4,),

                  // CustomButton(
                  //   title: "Rating",
                  //   margin: EdgeInsets.symmetric(vertical: 15),
                  //   onTap: () {
                  //     //  addAddressNotes();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (c) => StarRating(
                  //         //  orderId: widget.orderId,
                  //         )));
                  //   },
                  // ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> result = List();
  String address;
  double lat, lng;

  Future goToLocationScreen() async {
    result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapScreen()));
    print(result);
    setState(() {
      address = result[0];
      lat = result[1];
      lng = result[2];
    });
  }

  // DateTime selectedDate;
  // String myDate;
  // final f = new DateFormat('yyyy-MM-dd');
  // showDatePicker() {
  //   return showDialog(
  //     context: context,
  //     builder: (c) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: ColorScheme.light(
  //             primary: MyColors.primary,
  //             onPrimary: MyColors.white,
  //             surface: MyColors.black,
  //             onSurface: MyColors.black,
  //           ),
  //           dialogBackgroundColor: MyColors.white,
  //         ),
  //         child: DatePickerDialog(
  //           initialDate: DateTime.now(),
  //           firstDate: DateTime.now(),
  //           lastDate: DateTime(DateTime.now().year + 1),
  //         ),
  //       );
  //     },
  //   ).then((pickedDate) {
  //     getTimes();
  //     setState(() {
  //       selectedDate = pickedDate;
  //       myDate = f.format(pickedDate);
  //     });
  //   });
  // }

  // TimeOfDay lateTime;
  // String myTime;
  // openTimePicker() {
  //   return showDialog(
  //     context: context,
  //     barrierColor: MyColors.offPrimary.withOpacity(.1),
  //     builder: (c) {
  //       return TimePickerTheme(
  //           data: TimePickerThemeData(
  //               backgroundColor: MyColors.white,
  //               dayPeriodTextColor: MyColors.black,
  //               helpTextStyle: TextStyle(color: MyColors.primary),
  //               dialTextColor: MyColors.primary,
  //               dialBackgroundColor: MyColors.accent,
  //               dialHandColor: MyColors.white
  //           ),
  //           child: TimePickerDialog(
  //             initialTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1))),
  //             initialEntryMode: TimePickerEntryMode.dial,
  //           )
  //       );
  //     },
  //   ).then((pickedTime) {
  //     setState(() {
  //       lateTime = pickedTime;
  //       myTime = pickedTime.format(context);
  //     });
  //   });
  // }

  // String selectedNeighbor;
  // String selectedRegionId;
  // openNeighbors() {
  //   return showCupertinoModalPopup(
  //     barrierDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoActionSheet(
  //         title: Center(
  //             child: Text(
  //           tr("selectCity"),
  //           style: TextStyle(
  //             fontSize: 18,
  //             color: MyColors.offPrimary,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         )),
  //         actions: <Widget>[
  //           Container(
  //             height: 300,
  //             child: regionsModel.data == null
  //                 ? Center(
  //                     child: Text(
  //                       tr("noCites"),
  //                     ),
  //                   )
  //                 : ListView.builder(
  //                     itemCount: regionsModel.data.length,
  //                     itemBuilder: (c, i) {
  //                       return Column(
  //                         children: [
  //                           TextButton(
  //                             child: Text(regionsModel.data[i].title),
  //                             onPressed: () {
  //                               setState(() {
  //                                 selectedNeighbor = regionsModel.data[i].title;
  //                                 selectedRegionId =
  //                                     regionsModel.data[i].id.toString();
  //                               });
  //                               Navigator.of(context).pop();
  //                             },
  //                           ),
  //                           Divider(
  //                             height: 0,
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // String selectedTime;
  // openTimes() {
  //   return showCupertinoModalPopup(
  //     barrierDismissible: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoActionSheet(
  //         title: Center(
  //             child: Text(
  //           tr("selectTime"),
  //           style: GoogleFonts.almarai(
  //               fontSize: 18,
  //               color: MyColors.offPrimary,
  //               fontWeight: FontWeight.bold),
  //         )),
  //         actions: <Widget>[
  //           Container(
  //             height: 300,
  //             child: timesModel.data == null
  //                 ? Center(
  //                     child: Text(
  //                       tr("noAvTimes"),
  //                     ),
  //                   )
  //                 : ListView.builder(
  //                     itemCount: timesModel.data.length,
  //                     itemBuilder: (c, i) {
  //                       return Column(
  //                         children: [
  //                           TextButton(
  //                             child: Text(timesModel.data[i]),
  //                             onPressed: () {
  //                               setState(() {
  //                                 selectedTime = timesModel.data[i];
  //                               });
  //                               Navigator.of(context).pop();
  //                             },
  //                           ),
  //                           Divider(
  //                             height: 0,
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // TimesModel timesModel = TimesModel();
  // Future getTimes() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.http(URL, "api/hours-range");
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: {"lang": preferences.getString("lang"), "date": myDate},
  //     ).timeout(Duration(seconds: 10),
  //         onTimeout: () => throw 'no internet please connect to internet');
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       if (responseData["key"] == "success") {
  //         timesModel = TimesModel.fromJson(responseData);
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e, t) {
  //     print("error $e" + " ==>> track $t");
  //   }
  // }

  // RegionsModel regionsModel = RegionsModel();
  // Future getRegions() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final url = Uri.http(URL, "api/regions");
  //   print(preferences.getString("lang"));
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: {
  //         "lang": preferences.getString("lang"),
  //         "city_id": preferences.getInt("cityId").toString(),
  //       },
  //     ).timeout(Duration(seconds: 10),
  //         onTimeout: () => throw 'no internet please connect to internet');
  //     final responseData = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       print(responseData);
  //       if (responseData["key"] == "success") {
  //         regionsModel = RegionsModel.fromJson(responseData);
  //       } else {
  //         Fluttertoast.showToast(msg: responseData["msg"]);
  //       }
  //     }
  //   } catch (e, t) {
  //     print("error $e" + " ==>> track $t");
  //   }
  // }

  DioBase dioBase = DioBase();
  // Future addAddressNotes() async {
  //   LoadingDialog.showLoadingDialog();
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${preferences.getString("token")}"
  //   };
  //   FormData bodyData = FormData.fromMap({
  //     "lang": preferences.getString("lang"),
  //     "order_id": widget.orderId.toString(),
  //     "date": myDate,
  //     "time": selectedTime,
  //     "name": name.text,
  //     "email": email.text,
  //     // lateTime!=null?"${lateTime.hour}:${lateTime.minute}:00":null,
  //     "lat": lat.toString(),
  //     "lng": lng.toString(),
  //     "address": address,
  //     "region_id": selectedRegionId,
  //     // "floor":"floor",
  //     // "residence":"house",
  //     // "street":"street",
  //     "address_notes": notes.text == "" ? null : notes.text,
  //   });
  //   dioBase
  //       .post("addDateAndAddress", body: bodyData, headers: headers)
  //       .then((response) {
  //     if (response.statusCode == 200) {
  //       EasyLoading.dismiss();
  //       if (response.data["key"] == "success") {
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (c) => DetailedBill(
  //                   orderId: widget.orderId,
  //                 )));
  //         Fluttertoast.showToast(msg: response.data["msg"]);
  //         print("---------------------------------------successsuccess");
  //       } else {
  //         EasyLoading.dismiss();
  //         print("---------------------------------------else else");
  //         Fluttertoast.showToast(msg: response.data["msg"]);
  //       }
  //     } else {
  //       EasyLoading.dismiss();
  //       Fluttertoast.showToast(
  //         msg: response.data["msg"],
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   });
  // }
}
