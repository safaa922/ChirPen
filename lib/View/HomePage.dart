import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseplaylist/Categories/Category.dart';
import 'package:firebaseplaylist/Components/CustomDrawer.dart';
import 'package:firebaseplaylist/Components/CustomFloatingButton.dart';
import 'package:firebaseplaylist/Components/CustomInputField.dart';
import 'package:firebaseplaylist/Notes/ViewNote.dart';
import 'package:firebaseplaylist/View/LanguagePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  bool isLoading=true;

  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = [];
  TextEditingController searchController = TextEditingController();

  getData()async{
   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
       .collection("Categories")
       .where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

  void SearchCat(String value){
    filteredData = data.where((category){
      String name = category["Name"].toString().toLowerCase();
      return name.contains(value.toLowerCase());
    }).toList();
    setState(() {

    });
  }

  void initState(){
    getData();
    super.initState();
  }

  final GlobalKey<ScaffoldState> scfState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scfState,

        endDrawer:Customdrawer(),

      floatingActionButton: Padding(padding:
      EdgeInsets.only(left: 230,bottom: 20),child:  Customfloatingbutton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryPage(isEdit: false)));
        },
      ),
      ),

      body: isLoading==true? const Center(child:CircularProgressIndicator())

          :  Container(
          color: Colors.white,
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical: 40),

            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My\nCategories".tr,
                        style: GoogleFonts.patuaOne(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8188DA)
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          scfState.currentState!.openEndDrawer();
                        },
                        icon: const Icon(Icons.settings, size: 28,color: Color(0xFF8188DA),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextFormField(myController: searchController,
                    obscureText: false, hintText: "search by name".tr, validator: (val){

                },
                    width: width*1.2, icon: Icons.search,
                    height: height,
                onChanged: (value){
                  SearchCat(value);
                }
                ),


                const SizedBox(height: 25),
                filteredData!.isNotEmpty?
                Expanded(
                  child:GridView.builder(
                    itemCount: filteredData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                    ), itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewNote(CategoryId: filteredData[index].id)));
                      },
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>
                            AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text("ِAlert".tr,style: GoogleFonts.marmelad
                              (color: Color(0xFF8188DA),fontWeight: FontWeight.bold),),
                              content: Text("What do you want to do?".tr,style:TextStyle(color: Color(0xFF8188DA),fontWeight: FontWeight.w500)),
                              actions: [
                                TextButton(onPressed: ()async{
                                  await FirebaseFirestore.instance.collection("Categories").doc(filteredData[index].id).delete();
                                  Navigator.of(context).pushReplacementNamed("/HomePage");
                                }, child: Container(
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
                        ),),


                                TextButton(onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryPage(isEdit:true,docId: filteredData[index].id, OldName: data[index]["Name"], OldImgUrl: data[index]["Image"],)));
                                },child: Container(
                        decoration: BoxDecoration(
                        color: Color(0xFF8188DA),
                        borderRadius: BorderRadius.circular(10)
                        ),
                        height: height*0.05,
                        width: width*0.16,

                        child: Center(
                        child: Text("Edit".tr
                        ,style:  GoogleFonts.marmelad(color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                        ),
                        ),),
                              ],
                            ));
                      },


                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:SizedBox(
                              height: height*0.24,
                              width: double.infinity,

                              child: filteredData[index]["Image"]!=""? Image.network(filteredData[index]["Image"],
                                  fit: BoxFit.fill,errorBuilder: (context,error,stackTrace){
                                    return Icon(Icons.image_not_supported_rounded);
                                  }): Icon(Icons.image_not_supported_rounded),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100),
                            child:  Text(
                                filteredData[index]["Name"],
                                style:  TextStyle(
                                  shadows: [
                                    Shadow(color: Color(0xFF4c4c9c),blurRadius: 10,offset: Offset(0, 2))
                                  ],
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),

                        ],

                      ),
                    );

                  },
                  ),

                )
            :Center(
      child: Column(
      children: [
        SizedBox(height: height*0.18,),
        Text("Try Adding some categories".tr,style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8a9fe3).withOpacity(0.9)
        ),),
      Container(
      height: height*0.3,
      width: width*0.66,
      decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(
        "assets/images/NoCategories.jpg",
      ))
    ),
    ),
    SizedBox(height: height*0.02,),

    ],
    ))
              ],
            ),
          )
      )

    );

  }
}