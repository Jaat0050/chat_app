import 'package:chat_app_flutter/utils/constant.dart';
import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/bottom/home_screen/chat_screen.dart';
import 'package:chat_app_flutter/screens/bottom/home_screen/search_screen.dart';
import 'package:chat_app_flutter/screens/login_screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  UserModel user;
  MessagePage({required this.user, super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Searchscreen(widget.user)));
          },
          child: Container(
            width: 42,
            height: 42,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              // color: Color(0xFF000D07),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF363F3B),
                width: 1,
              ),
            ),
            child: Icon(Icons.search),
          ),
        ),
        title: Text(
          'Home',
          style: GoogleFonts.getFont(
            'DM Sans',
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await GoogleSignIn().signOut();
          //     await FirebaseAuth.instance.signOut();
          //     // ignore: use_build_context_synchronously
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const SigninScreen(),
          //         ),
          //         (route) => false);
          //   },
          //   icon: const Icon(
          //     Icons.logout,
          //     size: 30,
          //   ),
          // )
          Container(
            width: 44,
            height: 44,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.user.image),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      // to show the chat at
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 15,
                child: Container(
                  height: 100,
                  width: size.width,
                  padding: EdgeInsets.only(
                    bottom: 5,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 20,
                      );
                    },
                    padding: EdgeInsets.only(right: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 70,
                        // height: 130,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 70,
                                height: 70,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFF4D5255),
                                    // color: MyColors.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.user.image),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 28,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 4,
                              child: Text(
                                'My status',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont(
                                  'DM Sans',
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 160,
                child: Container(
                  height: size.height - 160,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 180),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.uid)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length < 1) {
                            return const Center(
                              child: Text("no chats available !"),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var friendId = snapshot.data.docs[index].id;
                              var lastMsg =
                                  snapshot.data.docs[index]['last_msg'];

                              Timestamp timestamp =
                                  snapshot.data.docs[index]['time_last_msg'];
                              DateTime dateTime = timestamp.toDate();
                              String formattedTime =
                                  DateFormat.jm().format(dateTime);
                              // var timeLastMsg =
                              //     snapshot.data.docs[index]['time_last_msg'];
                              return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(friendId)
                                    .get(),
                                builder:
                                    (context, AsyncSnapshot asyncSnapshot) {
                                  if (asyncSnapshot.hasData) {
                                    var friend = asyncSnapshot.data;
                                    return Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Slidable(
                                        direction: Axis.horizontal,
                                        endActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          extentRatio: 0.31,
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) {},
                                              icon: Icons.notifications_none,
                                              foregroundColor:
                                                  Color(0xFF000D07),
                                              backgroundColor:
                                                  Color(0xFFF1F6FA),
                                            ),
                                            SlidableAction(
                                              onPressed: (context) {},
                                              icon: Icons.delete,
                                              foregroundColor:
                                                  Color(0xFFE93635),
                                              backgroundColor:
                                                  Color(0xFFF1F6FA),
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          tileColor: Color(0xFFF1F6FA),
                                          selectedTileColor: Colors.white,
                                          leading: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  friend['image'],
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            friend['name'],
                                            style: GoogleFonts.getFont(
                                              'DM Sans',
                                              textStyle: TextStyle(
                                                color: Color(0xFF000D07),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          subtitle: Text(
                                            "$lastMsg",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.getFont(
                                              'Lora',
                                              textStyle: TextStyle(
                                                color: Color(0xFF797C7A),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '$formattedTime',
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.getFont(
                                                  'Lora',
                                                  textStyle: TextStyle(
                                                    color: Color(0xFF797C7B),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 22,
                                                width: 22,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFF04A4C),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '4',
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.getFont(
                                                      'Lora',
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  currentUser: widget.user,
                                                  friendId: friend['uid'],
                                                  friendname: friend['name'],
                                                  friendImage: friend['image'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  return const LinearProgressIndicator();
                                },
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.search),
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => Searchscreen(widget.user)));
      //     }),
    );
  }
}
