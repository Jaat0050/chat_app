// import 'package:flutter/material.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('SettingPage')),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TextEditingController? controllerNickname;
  TextEditingController? controllerAboutMe;

  // String id = '';
  String nickname = '';
  String aboutMe = '';

  bool isLoading = false;

  UserModel? userData;

  initialize() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      userData = UserModel.fromJson(snapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          userData?.image ??
                              'https://via.placeholder.com/60x60',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      userData?.name ?? '',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    userData?.email ?? '',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(121, 124, 123, 1),
                    ),
                  )
                ],
              ),
            ),

            //-------------------------------------------------//
            Positioned(
              top: 250,
              child: Container(
                height: size.height - 250,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),

            // SingleChildScrollView(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       // Container(
            //       //   height: 60,
            //       //   width: 60,
            //       //   decoration: BoxDecoration(
            //       //     shape: BoxShape.circle,
            //       //     image: DecorationImage(
            //       //       image: NetworkImage(
            //       //         userData?.image ??
            //       //             'https://via.placeholder.com/60x60',
            //       //       ),
            //       //       fit: BoxFit.contain,
            //       //     ),
            //       //   ),

            //       // ),

            //       // Input
            //       Column(
            //         children: <Widget>[
            //           // Username
            //           Container(
            //             child: Text(
            //               'Nickname',
            //               style: TextStyle(
            //                   fontStyle: FontStyle.italic,
            //                   fontWeight: FontWeight.bold,
            //                   color: MyColors.primaryColor),
            //             ),
            //             margin: EdgeInsets.only(left: 10, bottom: 5, top: 10),
            //           ),
            //           Container(
            //             child: Theme(
            //               data: Theme.of(context)
            //                   .copyWith(primaryColor: MyColors.primaryColor),
            //               child: TextField(
            //                 decoration: InputDecoration(
            //                   hintText: 'Sweetie',
            //                   contentPadding: EdgeInsets.all(5),
            //                   hintStyle: TextStyle(color: MyColors.greyColor),
            //                 ),
            //                 controller: controllerNickname,
            //                 onChanged: (value) {
            //                   nickname = value;
            //                 },
            //                 focusNode: FocusNode(),
            //               ),
            //             ),
            //             margin: EdgeInsets.only(left: 30, right: 30),
            //           ),

            //           // About me
            //           Container(
            //             child: Text(
            //               'About me',
            //               style: TextStyle(
            //                   fontStyle: FontStyle.italic,
            //                   fontWeight: FontWeight.bold,
            //                   color: MyColors.primaryColor),
            //             ),
            //             margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
            //           ),
            //           Container(
            //             child: Theme(
            //               data: Theme.of(context)
            //                   .copyWith(primaryColor: MyColors.primaryColor),
            //               child: TextField(
            //                 decoration: InputDecoration(
            //                   hintText: 'Fun, like travel and play PES...',
            //                   contentPadding: EdgeInsets.all(5),
            //                   hintStyle: TextStyle(color: MyColors.greyColor),
            //                 ),
            //                 controller: controllerAboutMe,
            //                 onChanged: (value) {
            //                   aboutMe = value;
            //                 },
            //                 focusNode: FocusNode(),
            //               ),
            //             ),
            //             margin: EdgeInsets.only(left: 30, right: 30),
            //           ),
            //         ],
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //       ),

            //       // Button
            //       Container(
            //         child: TextButton(
            //           // onPressed: handleUpdateData,
            //           onPressed: () {},
            //           child: Text(
            //             'Update',
            //             style: TextStyle(fontSize: 16, color: Colors.white),
            //           ),
            //           style: ButtonStyle(
            //             backgroundColor: MaterialStateProperty.all<Color>(
            //                 MyColors.primaryColor),
            //             padding: MaterialStateProperty.all<EdgeInsets>(
            //               EdgeInsets.fromLTRB(30, 10, 30, 10),
            //             ),
            //           ),
            //         ),
            //         margin: EdgeInsets.only(top: 50, bottom: 50),
            //       ),
            //     ],
            //   ),
            //   padding: EdgeInsets.only(left: 15, right: 15),
            // ),

            // Loading
            // Positioned(child: isLoading ? LoadingView() : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
