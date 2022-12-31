import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../layouts/chat.dart';
import '../constants/MyColors.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton(
      { @required this.ctx, this.isFromAuth = false});

  BuildContext ctx;
  bool isFromAuth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(ctx).pop();
      },
      icon: Icon(
        isFromAuth
            ? EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
                ? Icons.arrow_circle_right_outlined
                : Icons.arrow_circle_left_outlined
            : EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
                ? Icons.arrow_circle_right 
                : Icons.arrow_circle_left,
        size: 30,
        color: isFromAuth ? MyColors.secondary : MyColors.primary,
      ),
    );
  }
}

class CustomChatButton extends StatelessWidget {
  CustomChatButton(
      { @required this.ctx, this.isFromAuth = false});

  BuildContext ctx;
  bool isFromAuth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => Chat(
            ),
          ),
        );
      },
      icon: Icon(
        isFromAuth
            ? EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
            ? CupertinoIcons.chat_bubble_fill
            : CupertinoIcons.chat_bubble_fill
            : EasyLocalization.of(context).currentLocale.toString() == "ar_EG"
            ? CupertinoIcons.chat_bubble_fill
            : CupertinoIcons.chat_bubble_fill ,
        size: 30,
        color: isFromAuth ? MyColors.secondary : MyColors.primary,
      ),
    );
  }
}
