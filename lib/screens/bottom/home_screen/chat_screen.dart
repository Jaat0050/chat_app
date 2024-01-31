import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/widgets/message.dart';
import 'package:chat_app_flutter/screens/widgets/message_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendname;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendname,
    required this.friendImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String formatDateWithLabel(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              height: 44,
              width: 44,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      widget.friendImage,
                      height: 44,
                      width: 44,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade200,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendname,
                  style: GoogleFonts.getFont(
                    'DM Sans',
                    textStyle: TextStyle(
                      color: Color(0xFF000D07),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Active now',
                  style: GoogleFonts.getFont(
                    'Lora',
                    textStyle: TextStyle(
                      color: Color(0xFF797C7B),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 0.08,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          Icon(
            Icons.call_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.videocam_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.currentUser.uid)
                    .collection('messages')
                    .doc(widget.friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(child: Text("Say Hi"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            widget.currentUser.uid;

                        Timestamp timestamp = snapshot.data.docs[index]['date'];
                        DateTime dateTime = timestamp.toDate();
                        //  time  //
                        String formattedTime = DateFormat.jm().format(dateTime);
                        //  date  //
                        String formattedDate = formatDateWithLabel(dateTime);

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: isMe ? 20 : 0, top: 10),
                              child: Center(
                                child: Text(
                                  '$formattedDate',
                                  style: GoogleFonts.dmSans(
                                    textStyle: TextStyle(
                                      color: Color(0xFF000D07),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0.08,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Message(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe,
                              time: formattedTime,
                              friendImage: widget.friendImage,
                              friendName: widget.friendname,
                            ),
                          ],
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
          MessageTextField(widget.currentUser.uid, widget.friendId),
        ],
      ),
    );
  }
}
