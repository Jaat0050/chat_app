import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app_flutter/utils/constant.dart';
import 'package:chat_app_flutter/screens/bottomnav.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/login_screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD-PydyGkqOl6Aw0WIxR1A720TiEQa0MQg",
      authDomain: "flutter-chat-app-fc292.firebaseapp.com",
      projectId: "flutter-chat-app-fc292",
      storageBucket: "flutter-chat-app-fc292.appspot.com",
      messagingSenderId: "982902920559",
      appId: "1:982902920559:android:7e522dc3af68e54967c49a",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> userSignedIn() async {
    //check user in database or not i.e. signed in or not
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      UserModel userModel = UserModel.fromJson(userData);
      return BottomNav(user: userModel);
    } else {
      return const SigninScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'ChatBox',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primaryColor),
            useMaterial3: false,
          ),
          home: AnimatedSplashScreen(
            splash: 'images/Splash.png',
            centered: true,
            splashIconSize: double.infinity,
            nextScreen: Scaffold(
              body: DoubleBackToCloseApp(
                // snackBar: const SnackBar(content: Text('double tap to exit app')),
                snackBar: SnackBar(
                  backgroundColor: const Color(0xffF3F5F7),
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(2.0), // Starting shape
                    ),
                    const StadiumBorder(), // Ending shape
                    0.2, // Interpolation factor (0.0 to 1.0)
                  )!,
                  width: 200,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'double tap to exit app',
                    style: TextStyle(
                      color: MyColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 1),
                ),
                // child: SharedPreferencesHelper.getisFirstTime() == true
                //     ? const OnBoardingScreen()
                //     : BottomNav(
                //         currentIndex: 0,
                //       ),
                child: FutureBuilder(
                  future: userSignedIn(),
                  builder: (context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
