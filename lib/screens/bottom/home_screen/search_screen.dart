import 'package:chat_app_flutter/model/user_model.dart';
import 'package:chat_app_flutter/screens/bottom/home_screen/chat_screen.dart';
import 'package:chat_app_flutter/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Searchscreen extends StatefulWidget {
  UserModel user;
  Searchscreen(this.user, {super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    //make search page empty
    setState(
      () {
        searchResult = [];
        isLoading = true;
      },
    );
    //load data from database
    await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchController.text)
        .get()
        .then(
      (value) {
        //check if name is there
        if (value.docs.length < 1) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text("No user found"),
          //   ),
          // );
          setState(
            () {
              isLoading = false;
            },
          );
          return;
        }
        //else
        value.docs.forEach(
          (user) {
            //check user is not searching itselt
            if (user.data()['email'] != widget.user.email) {
              //add data to list(searchresult) and show search in search page
              searchResult.add(
                user.data(),
              );
            }
          },
        );
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Search",
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Write friends name",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (value) {
                        onSearch();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {
                      onSearch();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please Enter Name first",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: MyColors.primaryColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 10, bottom: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 40),

            //for search result showing
            if (searchResult.length > 0)
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15);
                  },
                  itemCount: searchResult.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: ListTile(
                        leading: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                searchResult[index]['image'],
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: Text(
                          searchResult[index]['name'],
                          style: GoogleFonts.getFont(
                            'DM Sans',
                            textStyle: TextStyle(
                              color: Color(0xFF000D07),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          searchResult[index]['email'],
                          style: GoogleFonts.getFont(
                            'Lora',
                            textStyle: TextStyle(
                              color: Color(0xFF797C7A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.message,
                          color: MyColors.primaryColor,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                currentUser: widget.user,
                                friendId: searchResult[index]['uid'],
                                friendname: searchResult[index]['name'],
                                friendImage: searchResult[index]['image'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            else if (isLoading == true)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (isLoading == false)
              Padding(
                padding: const EdgeInsets.only(top: 280),
                child: Center(
                  child: Text(
                    'No User Found ...',
                    style: GoogleFonts.getFont(
                      'DM Sans',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
