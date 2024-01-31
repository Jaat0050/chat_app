import 'package:chat_app_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String friendImage;
  final String friendName;

  const Message({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
    required this.friendImage,
    required this.friendName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              //--------------------------------------------------------------------------------------------//
              if (!isMe)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        friendImage,
                        height: 35,
                        width: 35,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '$friendName',
                      style: GoogleFonts.getFont(
                        'DM Sans',
                        textStyle: TextStyle(
                          color: Color(0xFF000D07),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 0.07,
                        ),
                      ),
                    )
                  ],
                ),
              //-----------------------------------------------------------------------------------//
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: !isMe ? 50 : 0),

                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    // margin: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(maxWidth: 200),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Color.fromRGBO(32, 160, 144, 1)
                          : Color.fromRGBO(242, 247, 251, 1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight:
                            isMe ? Radius.circular(5) : Radius.circular(15),
                        topLeft:
                            isMe ? Radius.circular(15) : Radius.circular(5),
                      ),
                    ),
                    child: Text(
                      message,
                      style: GoogleFonts.getFont(
                        'Lora',
                        textStyle: TextStyle(
                          color: isMe ? Colors.white : Color(0xFF000D07),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  //-----------------------------------------------------------------------------------//
                  Padding(
                    padding: EdgeInsets.only(right: 5, top: 8),
                    child: Text(
                      time,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.getFont(
                        'Lora',
                        textStyle: TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
