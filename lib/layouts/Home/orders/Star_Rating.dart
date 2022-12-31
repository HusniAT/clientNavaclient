import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../helpers/constants/MyColors.dart';
import '../../../helpers/customs/CustomBackButton.dart';
import '../../../helpers/customs/CustomButton.dart';
import 'SuccessfulOrder.dart';

class StarRating extends StatefulWidget {
  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  double myRating = 0;
  String commentText;



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(ctx: context),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "قيم الفني ",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight:FontWeight.w600,fontSize: 18,color: MyColors.primary),
            ),
            SizedBox(height: 15,),

            Center(
              child: RatingBar.builder(
                //unratedColor: Colors.white54,
                initialRating: myRating,
                glowColor: Colors.grey,
                minRating: 0,
                itemSize: 44,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),

                onRatingUpdate: (rating) {
                  print(myRating);

                  setState(() {
                    myRating = rating;
                  });
                  print(myRating);
                },
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  size: 100,
                  color:  Color(0xff2BC3F3),

                ),
              ),
            ),
            SizedBox(height: 100,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: CustomButton(
                title: tr('send'),
                margin: EdgeInsets.symmetric(vertical: 15),
                onTap: () {

                 // print("OnSubmitPressed rating = ${response.rating}");
                 // print('comment :${response.comment} ');

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => SuccessfulOrder()));
                  //  addAddressNotes();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (c) => StarRating(
                  //       //  orderId: widget.orderId,
                  //     )));
                },
              ),
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       show();
            //     },
            //     child: Text('Send Rating'))
          ],
        ),
      ),
    );
  }

  void show() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return RatingDialog(
              title: Text(
                "قم بتقييم الفني ",
                textAlign: TextAlign.center,
              ),
              message: Text(
                'هل يوجد لديك ملاحظات',
                textAlign: TextAlign.center,
              ),
              image: Icon(
                Icons.star,
                size: 100,
                color:  Color(0xff2BC3F3),
              ),
              submitButtonText: 'Submit',
              onSubmitted: (response) {
                print("OnSubmitPressed rating = ${response.rating}");
                print('comment :${response.comment} ');

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessfulOrder()));
              });
        });
  }
}
