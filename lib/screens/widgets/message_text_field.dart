import 'package:chat_app_flutter/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //make message writing box
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 20, right: 12, left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.attach_file_outlined),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Write your message",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.primaryColor,
            ),
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 5),

          //making send button and function of that
          GestureDetector(
            onTap: _controller.text.isEmpty
                ? null
                : () async {
                    String message = _controller.text;
                    _controller.clear();

                    //message store by current user
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentId)
                        .collection('messages')
                        .doc(widget.friendId)
                        .collection('chats')
                        .add({
                      "senderId": widget.currentId,
                      "recieverId": widget.friendId,
                      "message": message,
                      "type": "text",
                      "date": DateTime.now(),
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.currentId)
                          .collection('messages')
                          .doc(widget.friendId)
                          .set({
                        'last_msg': message,
                        'time_last_msg': DateTime.now(),
                      });
                    });

                    //message store by friend
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.friendId)
                        .collection('messages')
                        .doc(widget.currentId)
                        .collection('chats')
                        .add({
                      "senderId": widget.currentId,
                      "recieverId": widget.friendId,
                      "message": message,
                      "type": "text",
                      "date": DateTime.now(),
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.friendId)
                          .collection('messages')
                          .doc(widget.currentId)
                          .set({
                        'last_msg': message,
                        'time_last_msg': DateTime.now(),
                      });
                    });
                  },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primaryColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
