import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navaclient/helpers/constants/DioBase.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';

class VisaWebView extends StatefulWidget {
  final int orderId;

  const VisaWebView({Key key, this.orderId}) : super(key: key);

  @override
  _VisaWebViewState createState() => _VisaWebViewState();
}

class _VisaWebViewState extends State<VisaWebView> {
  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  DioBase dioBase = DioBase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("----------------initState------------");
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("----------------on destroy------------");
    });

    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        if (url == 'http://navaservices.net/api/success') {
          Fluttertoast.showToast(msg: 'تم دفع الطلب بنجاح');
          Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (url == 'http://navaservices.net/api/fail') {
          Fluttertoast.showToast(msg: 'لم يتم دفع الطلب');
          Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        print(
            "------------------------ onUrlChanged --------------------------");
        print("url: $url");
      }
    });
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scafold,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(tr("visa"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      url:
          "http://navaservices.net/api/pay-visa?lang=ar&order_id=${widget.orderId}",
    );
  }
}
