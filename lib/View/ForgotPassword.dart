
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseplaylist/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/CustomDialog.dart';
import '../Components/CustomInputField.dart';
import 'package:firebaseplaylist/Components/CustomButton.dart';

class Forgotpassword extends StatefulWidget {
  final String? Email;
  const Forgotpassword({super.key, required this.Email});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

  TextEditingController EmailController = TextEditingController();
GlobalKey<FormState> ForgotformState = GlobalKey();

void initState(){
  super.initState();
  EmailController.text=widget.Email!;
}
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: ForgotformState,
        autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: width*0.08,),
                    SizedBox(height: height*0.15,),
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.chevron_left_rounded,size: 38,color: Color(0xFF8188DA),),),
                    SizedBox(width: width*0.03,),
                    Container(
                      child: Text(
                        // "${widget.OldName}" , style: GoogleFonts.marmelad(
                        "Forgot Password".tr , style: GoogleFonts.marmelad(
                          color: Color(0xFF607BC0),
                          fontSize: 18
                      ),
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: height*0.15,),
                  Container(
                    height: height*0.2,
                    width: width*0.66,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/Pigeons.jpg"),fit: BoxFit.fill)
                    ),
                  ),
                  SizedBox(height: height*0.06,),
                  CustomTextFormField(myController: EmailController, hintText: "Email".tr, validator: (val)
                  {
                    if(val==null || val.trim().isEmpty){
                      return "Cannot be empty".tr;
                    }
                  }, width: width,height: height, icon: Icons.email, obscureText: false,
                  ),
                  SizedBox(height: 30,),
                  CustomButton(onPressed: ()async{
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: EmailController.text);
                      showDialog(context: context,
                          builder: (context)=> CustomDialog(
                            title: "Alert".tr,
                            content: "an email was sent to you for resetting password".tr,
                           onPressed: (){
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                           },
                          )
                      );


                    } on Exception catch (e) {
                      print(e);
                      showDialog(
                          context:context,
                          builder:(context)=>CustomDialog(title: "Error".tr, content: "Please use a valid email".tr,onPressed: (){
    Navigator.of(context).pop();}),
                      );
                    }
                  },
                      buttonText: "Send Reset Message".tr),
              ],
              ),

            ),
          ));

  }
}
