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
import 'package:http/http.dart' as http;
import 'package:navaclient/helpers/constants/LoadingDialog.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:navaclient/helpers/constants/base.dart';
import 'package:navaclient/helpers/customs/AppBarFoot.dart';
import 'package:navaclient/helpers/customs/CustomButton.dart';
import 'package:navaclient/layouts/Home/cart/MadaWebView.dart';
import 'package:navaclient/layouts/Home/cart/VisaWebView.dart';
import 'package:navaclient/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';
import '../cart/Address.dart';
import 'SuccessfulOrder.dart';


class SelectDateAndTime extends StatefulWidget {
  final int orderId;

  const SelectDateAndTime({Key key, this.orderId}) : super(key: key);


  @override
  _SelectDateAndTimeState createState() => _SelectDateAndTimeState();
}

class _SelectDateAndTimeState extends State<SelectDateAndTime> {
  String _selectedDate = '';
  //String _dateCount = '';
 // String _range = '';
 // String _rangeCount = '';


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {

       if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        _selectedDate=_selectedDate.split(" ")[0];
      }

    });

  print(_selectedDate);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            "Date And Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SfDateRangePicker(
              backgroundColor: Colors.grey.withOpacity(0.4),
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              initialDisplayDate: DateTime.now(),
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),

            SizedBox(height:MediaQuery.of(context).size.height*0.4),
            CustomButton(
              margin: EdgeInsets.only(top: 8),
              title: tr("continue"),
              onTap: () {

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => Address(
                      orderId: widget.orderId,
                    ),
                  ),
                );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (c) => Address(
                //       orderId: cartModel.data.id,
                //     ),
                //   ),
                // );
              },
            ),


          ],
        ),
      ),


    );
  }

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

}
