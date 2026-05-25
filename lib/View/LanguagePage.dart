

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseplaylist/Auth/Login.dart';
import 'package:firebaseplaylist/Localization/LocaleController.dart';
import 'package:firebaseplaylist/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Languagepage extends StatelessWidget {
  const Languagepage({super.key});


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    LocaleController controller = Get.find();

    sharedPref!.setBool("LangChosen", false);
    return Scaffold(

      body: Container(
        color: Colors.white,
       child:  Center(

          child: Column(

            children: [
              SizedBox(height: 100,),

              Text("Welcome to Chirpen, \n keep your notes here !".tr,style: GoogleFonts.marmelad(
                  fontSize: 20,
                  color: Color((0xFF8188DA),),
                  fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 20,),

              Container(
                width: width * 0.48,
                height: height * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(
                    "assets/images/TwoBirds3.png"
                  ), fit: BoxFit.fill),
                ),
              ),
              SizedBox(height: 40,),
              Text("Choose The Language".tr,style: GoogleFonts.marmelad(
                  fontSize: 19,
                  color: Color((0xFF8188DA),),
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 36,),
              MaterialButton(onPressed: (){
                controller.changeLang("ar");
                sharedPref!.setBool("LangChosen", true);
                user==null? Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login())):
                Navigator.of(context).pop();
              },
                  child: Container(
                    width: width*0.63,
                    height: height*0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [Color(0xFFFCCBBF),Color(0xFF7AA6FF)])
                    ),
                    child: Center(
                      child: Text("عربي",style: GoogleFonts.marmelad(fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,),),
                    ),
                  )
              ),
              SizedBox(height: 27,),

              MaterialButton(onPressed: (){
                controller.changeLang("en");
                sharedPref!.setBool("LangChosen", true);
                user==null? Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login())):
                Navigator.of(context).pop();
              },
                child: Container(
                  width: width*0.63,
                  height: height*0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [Color(0xFFFCCBBF),Color(0xFF7AA6FF)])
                  ),
                  child: Center(
                    child: Text("English",style: GoogleFonts.marmelad(fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,),),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
