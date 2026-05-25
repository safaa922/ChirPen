

import 'dart:io';
import 'package:firebaseplaylist/Components/CustomButton.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseplaylist/Components/CustomDialog.dart';
import 'package:firebaseplaylist/Components/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CategoryPage extends StatefulWidget {
  final String? docId;
  final String? OldName;
  final String? OldImgUrl;
  final bool isEdit;
  const CategoryPage({super.key, this.docId,  this.OldName, this.OldImgUrl, required this.isEdit});

  @override
  State<CategoryPage> createState() => _CategoryCategoryState();
}
GlobalKey<FormState> formState = GlobalKey();


CollectionReference categories = FirebaseFirestore.instance.collection("Categories");


class _CategoryCategoryState extends State<CategoryPage> {
  TextEditingController nameController = TextEditingController();

  File? file;
  String? imageUrl;

  Future<void> pickImage()async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        file=File(image.path);
      });
    }
  }

  Future<String>UploadImage()async{
    if(file==null){
      return "";
    }
    String cloudName = "dtfqc1o8z";
    String UploadPreset="NoteApp";
    var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    var request = http.MultipartRequest("POST",uri);
    request.fields['upload_preset']=UploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', file!.path),
    );
    var response = await request.send();
    if(response.statusCode==200){
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    }
    else{
      throw Exception("Failed to upload image");
    }
  }



  Future<void> AddCat()async{
    if(formState.currentState!.validate()){
      try {
        String uploaded_ImgUrL = "";
        if(file!=null) {
          uploaded_ImgUrL = await UploadImage();
        }

        DocumentReference response= await categories.add({
          "Name":nameController.text,
          "id":FirebaseAuth.instance.currentUser!.uid,
          "Image":uploaded_ImgUrL

        });
        Navigator.of(context).pushNamedAndRemoveUntil("/HomePage",(route)=>false);
      } on Exception catch (e) {
        print(e);
        showDialog(context: context,
            builder: (context)=>
        CustomDialog(title: 'Error', content: 'Failed to add category ${e}',));
      }
  }

  }

  Future<void> EditCat()async{
    if(formState.currentState!.validate()){
      try{
        String uploadedImageUrl = file!=null ?
        await UploadImage() : widget.OldImgUrl??"";
        setState(() {

        });
        await categories.doc(widget.docId).set(
          {
            "Name":nameController.text,
            "id": FirebaseAuth.instance.currentUser!.uid,
            "Image":uploadedImageUrl
          },
            SetOptions(merge:true)
        );
        Navigator.of(context).pushNamedAndRemoveUntil("/HomePage",(route)=>false);
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
    if(widget.isEdit==true) {
      nameController.text = widget.OldName!;
    }
    super.initState();
  }
  @override
  void dispose(){
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
            padding: EdgeInsets.only(left: 20),
          child: Text("Category".tr,style: TextStyle(color: Color(0xFF8188DA),fontWeight: FontWeight.bold),),
        ),
      leading: Container(
      child: Stack(
        children: [
          Positioned(
            left: 20,
            child: Row(
              children: [

                IconButton(onPressed: (){

                  Navigator.of(context).pop();
                }, icon: Icon(Icons.chevron_left_rounded,size: 38,color: Color(0xFF8188DA),),)
              ],
            ),)
        ],
      )
    ),
      ),
      body: Form(
        key: formState,
       child: Container(
           color: Colors.white,
         child: Center(

           child: Column(

             children: [
               SizedBox(height: height*0.16,),
               CustomTextFormField(myController: nameController, hintText: "Category Name".tr, validator: (val){
                 if(val ==null || val.trim().isEmpty){
                   return "Cannot be empty".tr;
                 }
               }, width: width*0.9, icon: Icons.category,height: height, obscureText: false,),
               SizedBox(height: 40,),
               GestureDetector(
                 onTap: (){
                   pickImage();
                 },
                 child: Container(
                   height: 220,
                   width: 220,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     color: Color(0xFF96AAE5),
                     image: file!=null?
                     // ( (widget.isEdit==false?
                     DecorationImage(image: FileImage(file!), fit: BoxFit.cover)
                         :
                     (widget.isEdit==true && widget.OldImgUrl!=null && widget.OldImgUrl!.isNotEmpty)?
                     DecorationImage(
                         image: NetworkImage(widget.OldImgUrl!),
                       fit: BoxFit.cover
                     )
                         :null,

                   ),
                   child: Icon(Icons.photo_camera,size: 50,color: Colors.white,),
                 ),
               ),
               SizedBox(height: 50,),
               CustomButton(onPressed: (){
                 widget.isEdit==true?
                 EditCat():
                 AddCat();
               }, buttonText: "Save".tr)
             ],
           ),
         )
       )
      ),
    );
  }
}
