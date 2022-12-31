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
import '../../../helpers/models/TimesModel.dart';
import '../../../res.dart';

import 'helpers/constants/DioBase.dart';
import 'layouts/Home/cart/Address.dart';

class SelectDateAndTime2 extends StatefulWidget {
  final int orderId;

  const SelectDateAndTime2({Key key, this.orderId}) : super(key: key);

  @override
  _SelectDateAndTime2State createState() => _SelectDateAndTime2State();
}

class _SelectDateAndTime2State extends State<SelectDateAndTime2> {
  String _selectedDate = '';
  //String _dateCount = '';
  // String _range = '';
  // String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    final f = new DateFormat('yyyy-MM-dd');
    if (args.value is DateTime) {
       _selectedDate = args.value.toString();
      TimeAndDateAndAdressModel.Date =
          f.format(args.value); // تاكد من  شكل ال DATE
    }
    await getTimes(); // اعمل جواته statemangement
    // setState(() {
    //   if (args.value is DateTime) {
    //     // _selectedDate = args.value;
    //     TimeAndDateAndAdressModel.Date =
    //         f.format(args.value); // تاكد من  شكل ال DATE
    //   }
    // });

    print(_selectedDate);
  }

  // استدعيه لما تعمل select لل وقت
  void _onTimeSelected(String time) {
    TimeAndDateAndAdressModel.Time = time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Date And Time22",
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
                DateTime.now().add(
                  const Duration(days: 3),
                ),
              ),
            ),
            SizedBox(height: 5,),
            ElevatedButton(

              onPressed: (){},
            child: Text("00"),

            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
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

  TimesModel timesModel = TimesModel();
  Future getTimes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/hours-range");
    try {
      final response = await http.post(
        url,
        body: {
          "lang": preferences.getString("lang"),
          "date": TimeAndDateAndAdressModel.date
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData["key"] == "success") {
          timesModel = TimesModel.fromJson(responseData);
          print(response.body);
          print(timesModel);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}
///////////////////////////////////////////////

class TimeAndDateAndAdressModel {
  static String date;
  static String time;
  static set Date(String value){
    date = value;
  }
  static set Time(String value){
    time = value;
  }
}

//////////////////////////////////////////////////

class selectTime with ChangeNotifier {
  // final List<Widget> controllerOrders = [
  //   OrderDetailsStatus(),
  // ];
  // void pushOrPopWidget(Widget widget,bool isPush,String title,BuildContext ctx) {
  //   if(isPush){
  //     controllerOrders.add(widget);
  //   }else{
  //     controllerOrders.removeLast();
  //   }
  //   Provider.of<AppBarViewModel>(ctx,listen: false).setAppBarTitle(title, 1, isPush);
  //   notifyListeners();
  // }
  // void backToMainOrders(){
  //   final Widget fWidget = OrderDetailsStatus();
  //   controllerOrders.clear();
  //   controllerOrders.add(fWidget);
  //   controllerOrders.add(OperationDoneSuccessfully());
  //   notifyListeners();
  // }
  // void backToHome(){
  //   controllerOrders.clear();
  //   controllerOrders.add(OrderDetailsStatus());
  //   notifyListeners();
  // }
}