import 'package:chat_app_flutter/utils/constant.dart';
import 'package:chat_app_flutter/main.dart';
import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/bottomnav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    //signin(get authentication and credentials) from google account and check user (google accounts)
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      //user does not choose any account just go back
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //firebase can access account and store data
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

//succellfully signed in and now store data in firebase

    //getting data from database
    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    //checking if user already exists
    if (userExist.exists) {
      // ignore: avoid_print
      print("user already exists");
    } else {
      //updating data base
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    }

    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    UserModel userModel = UserModel.fromJson(userData);

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNav(user: userModel),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 70,
              child: Container(
                decoration: const BoxDecoration(),
                child: Image.asset(
                  "images/shade.png",
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              top: 70,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/minlogo.png",
                    fit: BoxFit.contain,
                    width: 16,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Chatbox',
                      // textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Lora',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 0.07,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            // child: Container(
            //   decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage("images/I1.jpg"),
            //         colorFilter:
            //             ColorFilter.mode(Colors.green, BlendMode.color),
            //         fit: BoxFit.cover),
            //   ),
            // ),
            // ),
            Positioned(
              top: 130,
              left: 20,
              width: 400,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Connect friends',
                      style: GoogleFonts.getFont(
                        'DM Sans',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' easily & quickly',
                      style: GoogleFonts.getFont(
                        'DM Sans',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 68,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 490,
              left: 20,
              width: 300,
              child: Text(
                'Our chat app is the perfect way to stay connected with friends and family.',
                style: GoogleFonts.getFont(
                  'Lora',
                  textStyle: TextStyle(
                    color: Color(0xFFB9C1BE),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            //------------------------------------fb google apple -------------------------------//
            Positioned(
              top: 585,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFA8B0AF)),
                      ),
                    ),
                    child: Image.asset(
                      "images/fb.png",
                      fit: BoxFit.contain,
                      height: 38,
                      width: 48,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFA8B0AF)),
                      ),
                    ),
                    child: Image.asset(
                      "images/google.png",
                      fit: BoxFit.contain,
                      height: 38,
                      width: 48,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1A1A1A),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFA8B0AF)),
                      ),
                    ),
                    child: Image.asset(
                      "images/apple.png",
                      fit: BoxFit.contain,
                      height: 38,
                      width: 48,
                    ),
                  )
                ],
              ),
            ),
            //-------------------------------------or-----------------------------------------------//
            Positioned(
              top: 685,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.20,
                    child: Container(
                      width: 132,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFCDD1D0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'OR',
                      style: GoogleFonts.getFont(
                        'DM Sans',
                        textStyle: TextStyle(
                          color: Color(0xFFD6E4DF),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 0.07,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Opacity(
                    opacity: 0.20,
                    child: Container(
                      width: 132,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFCDD1D0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //-------------------------------------google sign in----------------------------------//
            Positioned(
              bottom: 50,
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await signInFunction();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Align(
                          alignment: Alignment.center,
                          child: SpinKitThreeBounce(
                            color: MyColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Row(
                          children: [
                            Image.asset(
                              "images/google.png",
                              fit: BoxFit.cover,
                              height: 28,
                              width: 45,
                            ),
                            Text(
                              'Sign up withn Google',
                              style: GoogleFonts.getFont(
                                'DM Sans',
                                textStyle: TextStyle(
                                  color: Color(0xFF000D07),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isLoading = false;
}
