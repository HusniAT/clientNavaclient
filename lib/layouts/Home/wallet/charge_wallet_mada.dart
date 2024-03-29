import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navaclient/helpers/constants/DioBase.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../Home.dart';
import 'package:url_launcher/url_launcher.dart';

class ChargeWalletMada extends StatefulWidget {
  final int amount;
  final int userId;
  const ChargeWalletMada({Key key, this.amount, this.userId}) : super(key: key);

  @override
  _ChargeWalletMadaState createState() => _ChargeWalletMadaState();
}

class _ChargeWalletMadaState extends State<ChargeWalletMada> {
  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  DioBase dioBase = DioBase();
  WebViewController _controller = WebViewController();

  @override
  void initState() {
    
    // TODO: implement initState
   
    super.initState();
    //  _controller
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         // Update loading bar.
    //       },
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onWebResourceError: (WebResourceError error) {},
    //     ),
    //   )
    //   ..loadRequest(Uri.parse(
    //       'http://navaclientservices.net/api/pay-wallet-mada?amount=${widget.amount}&user_id=${widget.userId}'));

    print("----------------initState------------");
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("----------------on destroy------------");
    });

    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        if (url == 'http://navaservices.net/api/success') {
          Fluttertoast.showToast(msg: "walletHasBeenCharged".tr());
          // Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (ctx) => Home(
                  index: 2,
                ),
              ),
              (route) => false);
        } else if (url == 'http://navaservices.net/api/fail') {
          Fluttertoast.showToast(msg: "walletHasn'tBeenCharged".tr());
          // Future.delayed(Duration(seconds: 2));
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
        // backgroundColor: MyColors.primary,
        // elevation: 0,
        title: Text(tr("mada"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(
          ctx: context,
        ),
      ),
      url:
          "http://navaservices.net/api/pay-wallet-mada?amount=${widget.amount}&user_id=${widget.userId}",
    );
  }
}
