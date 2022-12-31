// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:navaclient/view_model/add_notes_view_model.dart';
// import 'package:provider/provider.dart';
//
// import '../../../helpers/constants/MyColors.dart';
// import '../../../helpers/customs/CustomBackButton.dart';
// // import '../constent_variables/color_theme.dart';
// // import '../view_model/home_view_models/controller.dart';
//
// enum Files { Camera, Audio, Video }
//
// class OrderSummary extends StatelessWidget {
// //  static const routeName = "AddNotesView";
//
//   final TextEditingController _controller = TextEditingController();
//
//   final Map<String, dynamic> _notes = {
//     "note": null,
//     "image": null,
//     "audio": null,
//     "video": null,
//   };
//
//   Future _pickFile(Files type, BuildContext context) async {
//     final ImagePicker _picker = ImagePicker();
//     try {
//       String success;
//       if (type == Files.Camera) {
//         _notes['image'] = await _picker.pickImage(source: ImageSource.camera);
//         if (_notes['image'] != null) {
//           success = tr("imageAdded");
//         }
//       } else if (type == Files.Video) {
//         _notes['video'] = await _picker.pickVideo(source: ImageSource.camera);
//         if (_notes['video'] != null) {
//           success = tr("videoAdded");
//         }
//       } else {}
//       if (success != null) {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.green,
//             content: Text(success),
//           ),
//         );
//       }
//     } catch (err) {
//       print(err);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//             "Order Summary",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
//         leading: CustomBackButton(ctx: context),
//
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 minLines: 25,
//                 maxLines: 30,
//                 decoration: InputDecoration(
//                   //contentPadding: EdgeInsets.zero,
//                   hintText: tr("enterNotes"),
//                   hintStyle: TextStyle(
//                     color: MyColors.textSettings,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: const BorderSide(
//                       color: Color(0xffEEEEEE),
//                       width: 1,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     await _pickFile(Files.Video, context);
//                   },
//                   child: Column(
//                     children: [
//                       SvgPicture.asset("assets/images/vidicon-fill.svg"),
//                       Text(tr("addVid")),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Column(
//                     children: [
//                       SvgPicture.asset("assets/images/mic-fill.svg"),
//                       Text(tr("addVoice")),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     await _pickFile(Files.Camera, context);
//                   },
//                   child: Column(
//                     children: [
//                       SvgPicture.asset("assets/images/camera-fill.svg"),
//                       Text(tr("addImg")),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // if (_controller.text.isNotEmpty) {
//                       //   _notes['note'] = _controller.text;
//                       // }
//                       // AddNotesViewModel.notes = _notes;
//                       // Navigator.of(context).pop();
//                       // final homeCntroller =
//                       // Provider.of<Controller>(context, listen: false);
//                       // int pageIndex = homeCntroller.pageIndex;
//                       // homeCntroller.setPageIndex(
//                       //   ++pageIndex,
//                       //   tr("timeAndDate"),
//                       //   context,
//                       // );
//                     },
//                     child: Text(
//                       tr("continue"),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }