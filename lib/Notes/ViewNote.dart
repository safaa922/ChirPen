import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseplaylist/Components/CustomDrawer.dart';
import 'package:firebaseplaylist/Components/CustomInputField.dart';
import 'package:firebaseplaylist/Notes/NoteDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Components/CustomFloatingButton.dart';

class ViewNote extends StatefulWidget {
  final String CategoryId;

  const ViewNote({super.key, required this.CategoryId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {

  final GlobalKey<ScaffoldState> ViewNoteScf = GlobalKey<ScaffoldState>();
  bool isLoading=true;
  // bool fav = false;
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = [];
  TextEditingController searchController = TextEditingController();

  getData()async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Categories")
        .doc(widget.CategoryId)
        .collection("Notes")
        .get();
    // await Future.delayed(Duration:(seconds:1));
    data.clear();
    filteredData.clear();
    data.addAll(querySnapshot.docs);
    filteredData.addAll(querySnapshot.docs);
    filteredData = List.from(data);

    isLoading=false;
    setState(() {

    });
  }

  void SearchNote(String value){
    filteredData = data.where((Note){
      String name = Note["Title"].toString().toLowerCase();
      return name.contains(value.toLowerCase());
    }).toList();
    setState(() {

    });
  }

  Future<void> Favorite(int index) async {
    try {
      bool currentValue = filteredData[index]["isPinned"] ?? false;

      await FirebaseFirestore.instance
          .collection("Categories")
          .doc(widget.CategoryId)
          .collection("Notes")
          .doc(filteredData[index].id)
          .update({
        "isPinned": !currentValue,
      });

      // refresh local data
      data.clear();
      filteredData.clear();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Categories")
          .doc(widget.CategoryId)
          .collection("Notes")
          .get();

      data.addAll(querySnapshot.docs);
      filteredData.addAll(querySnapshot.docs);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
  void initState(){
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        key: ViewNoteScf,
        endDrawer: Customdrawer(),

        floatingActionButton: Padding(padding: EdgeInsets.only(left: 20),
          child: Customfloatingbutton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                NoteDetails( CategorydocId: widget.CategoryId, isEdit: false)));
          },
          ),
        ),

        body: WillPopScope(child: isLoading==true?  Center(child:CircularProgressIndicator()):
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: height*0.038,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 23,vertical: 30),
                child:  Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){

                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.chevron_left_rounded,size: 38,color: Color(0xFF8188DA),),),
                    //  SizedBox(width: width*0.1,),
                    Text(
                      " My\n Notes".tr,
                      style: GoogleFonts.patuaOne(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8188DA)
                      ),
                    ),
                    SizedBox(width: width*0.42,),
                    IconButton(onPressed: (){
                      ViewNoteScf.currentState!.openEndDrawer();
                    },
                      icon: const Icon(Icons.settings, size: 28,color: Color(0xFF8188DA),),

                    )
                  ],
                ),
              ),

              CustomTextFormField(myController: searchController,
                  obscureText: false, hintText: "Search by title".tr, validator:(val){},
                  width: width*1.24, icon: Icons.search, height: height,
                  onChanged: (value){
                  SearchNote(value);
                  }

        ),

              SizedBox(height: height*0.038,),
              filteredData.isNotEmpty ? Expanded(child:  ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context,index){
                    DateTime date = filteredData[index]["CreatedAt"].toDate();
                    return InkWell(
                      onTap: (){

                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                            NoteDetails(docId: filteredData[index].id, CategorydocId: widget.CategoryId,
                              OldName:filteredData[index]["Title"], OldContent: filteredData[index]["content"],
                              isEdit: true,CreatedAt: filteredData[index]["CreatedAt"],)));

                      },

                      child: Padding(
                        padding: EdgeInsets.only(left: 0,right: 20,bottom: 20),

                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors:[Color(0xFFFFF4F4),Color(0xFFF1F5FF) ],
                                      transform: GradientRotation(0.7)
                                  )

                              ),
                              height: height*0.13,
                              width: width*0.64,

                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // SizedBox(height: height*0.06),
                                      // SizedBox(width: width*0.47),
                                      // Padding (
                                      // ),
                                      // SizedBox(width: width*0.01),
                                      IconButton(onPressed: ()async{
                                        showDialog(context: context, builder: (context)=>
                                            AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: Text("Warning".tr,style: GoogleFonts.marmelad
                                                (color: Color(0xFF8188DA),fontWeight: FontWeight.bold),),
                                              content: Text("Are you sure you want to delete?".tr,style:TextStyle(color: Color(0xFF8188DA),fontWeight: FontWeight.w500)),
                                              actions: [
                                                TextButton(onPressed: ()async{
                                                  await FirebaseFirestore.instance.collection("Categories").doc(widget.CategoryId).collection("Notes").doc(filteredData[index].id).delete();
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(CategoryId: widget.CategoryId)));
                                                },  child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFACB0D0),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            height: height*0.05,
                                            width: width*0.16,

                                            child: Center(
                                              child: Text("Delete".tr
                                                ,style:  GoogleFonts.marmelad(color: Colors.white,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                        ),
                                                ),

                                                TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                },child: Container(
                                        decoration: BoxDecoration(
                                        color: Color(0xFF8188DA) ,
                                        borderRadius: BorderRadius.circular(10)
                                        ),
                                        height: height*0.05,
                                        width: width*0.16,

                                        child: Center(
                                        child: Text("Cancel".tr
                                        ,style:  GoogleFonts.marmelad(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                        ),
                                        ),),
                                              ],

                                            )
                                        );


                                      }, icon: Icon(Icons.delete),color: Color(0xFFF1A49E),),

                                      Padding(padding: EdgeInsets.only(right:52),
                                        child:  IconButton(
                                          onPressed: ()async{
                                          await  Favorite(index);
                                          },
                                          icon:  filteredData[index]["isPinned"]==false?  Icon(Icons.star_border_rounded,size: 28,color: Color(0xFFF3D290))
                                              :
                                          Icon(Icons.star_rate_rounded,size: 28,),color: Color(0xFFF3D290),),
                                      ),
                                      SizedBox(width: width*0.04),
                                      Expanded(child:   Text(
                                        "${filteredData[index]["Title"]}",style: TextStyle(color:  Color(0xFF6394E9),fontSize: 18),
                                        overflow: TextOverflow.ellipsis,

                                        maxLines: 1,
                                      ),),

                                      SizedBox(width: width*0.05),
                                    ],
                                  ),


                                  Padding(
                                    padding: EdgeInsets.only(right: 24,left: 23,top: 10),
                                    child:  Text(
                                      textAlign: TextAlign.right,
                                      "${filteredData[index]["content"]}",style: TextStyle(color: Color(0xFF757FA9),fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 16,),
                            Container(
                                height: height*0.1,
                                width: width*0.2,
                                decoration: BoxDecoration(
                                    color: Color(0xFF91A7F1),
                                    borderRadius: BorderRadius.circular(20)
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${date.year}",style: TextStyle(color: Colors.white,fontSize: 16),
                                    ),
                                    SizedBox(height: height*0.009),
                                    Text(
                                      "${date.month} / ${date.day}",style: TextStyle(color: Colors.white,fontSize: 16),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        // Text("${data[index]["Title"]}")

                      ),

                    );
                  }

              ),


              ) : Center(
                  child: Column(
                    children: [
                      SizedBox(height: height*0.13,),
                      Text("Try Adding some Notes".tr,style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8a9fe3).withOpacity(0.9)
                      ),),
                      Container(
                        height: height*0.3,
                        width: width*0.66,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(
                              "assets/images/NoNotes.jpg",
                            ))
                        ),
                      ),
                      SizedBox(height: height*0.02,),

                    ],
                  )),

            ],

          ),
        ),
            onWillPop: (){
              Navigator.of(context).pushNamedAndRemoveUntil("/HomePage", (route)=>false); ///goes to the homepage instead of AddNotes
              return Future.value(false); //////// Future.value(false) prevents the default back behavior
            }
        )
    );
  }
}
