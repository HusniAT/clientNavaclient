import 'package:flutter/material.dart';
import 'package:navaclient/helpers/constants/MyColors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  String title;
  Function onTap;
  Color textColor;
  Color color;
  Color borderColor;
  BorderRadius borderRadius;
  EdgeInsets margin;
  double width;
  double height;
  double textSize;
  IconData icon;

  CustomButton(
      {@required this.title,
      @required this.onTap,
      this.color,
      this.textColor,
      this.borderRadius,
      this.margin,
      this.borderColor,
      this.height,
      this.width,
      this.icon,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    Color border = color ?? MyColors.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color ?? MyColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: textColor ?? MyColors.white,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "$title",
                style: TextStyle(
                  fontSize: textSize ?? 18,
                  color: textColor ?? MyColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
