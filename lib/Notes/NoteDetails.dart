

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseplaylist/Components/CustomDialog.dart';
import 'package:firebaseplaylist/Notes/ViewNote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteDetails extends StatefulWidget {
  final String? docId;
  final Timestamp? CreatedAt;
  final String CategorydocId;
  final String? OldName;
  final String? OldContent;
  final bool isEdit;

   NoteDetails({super.key, this.docId, required this.CategorydocId,  this.OldName,  this.OldContent, required this.isEdit, this.CreatedAt});


  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}


class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController TitleController = TextEditingController();


  GlobalKey<FormState> formStateNotes = GlobalKey();
  Future<void> AddNote()async{
    CollectionReference Notes = FirebaseFirestore.instance.collection("Categories").doc(widget.CategorydocId).collection("Notes");
    if(formStateNotes.currentState!.validate()){
      try{
        setState(() {

        });
        DocumentReference response = await Notes.add({
          "Title":TitleController.text,
          "content": contentController.text,
          "CreatedAt": Timestamp.now(),
          "isPinned":false
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (_) =>ViewNote(CategoryId: widget.CategorydocId)));
      }
      on Exception catch(e){
        setState(() {

        });
        print("Error ${e}");
      }
    }
  }


  Future<void>EditNote()async{
    CollectionReference Notes = FirebaseFirestore.instance.collection("Categories").doc(widget.CategorydocId).collection("Notes");
    if(formStateNotes.currentState!.validate()){
      try{
        setState(() {

        });
        await Notes.doc(widget.docId).set({
          "Title":TitleController.text,
          "content": contentController.text,
          "CreatedAt": widget.CreatedAt,
          "isPinned":false
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>ViewNote(CategoryId: widget.CategorydocId)));

      }
      on Exception catch (e) {
        print(e);
        showDialog(context: context,
            builder: (context)=>
                CustomDialog(title: 'Error', content: 'Failed to add category ${e}',));
      }
    }
  }


  @override
  void initState(){
    super.initState();
    if(widget.isEdit==true) {
      contentController.text = widget.OldContent??"";
      TitleController.text = widget.OldName??"";
    }
  }
  @override
  void dispose(){
    contentController.dispose();
    TitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Map<int,String> months={
      1:"Jan",
    2:"Feb",
    3:"Mar",
    4:"Apr",
    5:"May",
      6: "Jun",
      7: "Jul",
      8: "Aug",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec",

    };
    int lineCount ="\n".allMatches(noteController.text).length+11;
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    DateTime date;
    if(widget.isEdit==true){
       date = widget.CreatedAt!.toDate();
    }
    else{
       date = DateTime.now();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formStateNotes,

        // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
        color: Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: height*0.03,right: height*0.03,top: height*0.07),
                child: Column(

                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: Icon(Icons.chevron_left_rounded,size: 38,color: Color(0xFF8188DA),),),
                         SizedBox(width: width*0.18,),
                        widget.OldName!=null?Container(
                          child: Text(
                              // "${widget.OldName}" , style: GoogleFonts.marmelad(
                            "Note Details".tr , style: GoogleFonts.marmelad(
                                        color: Color(0xFF607BC0),
                                          fontSize: 18
                                      ),
                          ),
                        ): Text(""),
                      ],
                    ),
                    SizedBox(height: height*0.04,),
                  Container(
                  height: height*0.057,
                  width: width*0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors:[Color(0xFFFFE9EA).withOpacity(0.7),Color(0xFFB2CCFF).withOpacity(0.7) ])
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 25),
                    child: TextFormField(
                      validator: (val){
                        if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                        }
                       else if(val.length>10){
                          return "this title is too long".tr;
                        }
                      },
                      style: GoogleFonts.marmelad(
                        color: Color(0xFF607BC0),
                        fontSize: 18
                      ),
                      controller: TitleController,
                      decoration: InputDecoration(
                        hintText: "Title".tr,
                          hintStyle: TextStyle(
                              color: Color(0xFF607BC0)
                          ),
                          border: InputBorder.none
                      ),
                    ),
                    )
                  ),


                    SizedBox(height: height*0.04,),
                    Container(
                      height: height*0.5,
                      width: width*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors:[Color(0xFFF5FAFF),Color(0xFFCFDFFF).withOpacity(0.5) ],
                            transform: GradientRotation(1.4)
                        ),

                      ),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [

                            Column(
                              children: List.generate(lineCount, (index)=>Container(
                                margin: EdgeInsets.only(top: 35),
                                height: 1,
                                color: Color(0xFF757FA9).withOpacity(0.3),
                              ),

                              ),

                            ),
                            Padding(
                              padding:const EdgeInsets.only(top: 30,bottom: 10,left: 20,right: 20),
                              child:TextFormField(
                                validator: (val){
                                  if(val==null || val.trim().isEmpty){
                                    return "Cannot be empty".tr;
                                  }
                                },
                                controller: contentController,
                                onChanged: (val){
                                  setState(() {

                                  });
                                },
                                style: TextStyle(
                                  color: Color(0xFF607BC0),
                                    letterSpacing: 2,
                                    height: 2.4
                                ),
                                maxLines: null,
                                // expands: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write your note...".tr ,
                                  hintStyle: TextStyle(
                                    color: Color(0xFF607BC0)
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ),



    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 20),
    child: Container(
    height: height * 0.073,
    width: width * 0.15,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: const Color(0xFFA5C9FF),
    ),
    child: IconButton(
    onPressed: () {
      if(widget.isEdit==true){
        EditNote();
      }
      else{
        AddNote();
      }
    },
    icon: const Icon(Icons.check, size: 26),
    color: Colors.white,
    ),
    ),
    ),

    Padding(
    padding: const EdgeInsets.only(top: 0, right: 20),
    child: SizedBox(
    height: height * 0.22,
    width: width * 0.22,
    child:        Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [

    // Circle
    Positioned(
    bottom: 20,
    child: Container(
    height: height * 0.16,
    width: width * 0.16,
    decoration: const BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
    colors: [
    Color(0xFFFFDFD6),
    Color(0xFF7CAEFF),
    ],
    transform: GradientRotation(0.57),
    ),
    ),
      child:Padding(
        padding: EdgeInsets.only(top: 47),
      child:Container(
        child: Column(
          children: [
            Text("${months[date.month]}".tr,
              style: GoogleFonts.marmelad(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("${date.day}\n".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      )),

    ),),

    // Bird
    Positioned(
     top: -55,
    left: 23,
    child: Container(
    height: height * 0.25,
    width: width * 0.25,
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage(
    "assets/images/BirdCropped.png",
    ),
    fit: BoxFit.contain,
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
                  ],
                ),
              ),
            ),
          ),
      )

    );
  }
}
