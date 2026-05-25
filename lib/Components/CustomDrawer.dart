


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseplaylist/View/LanguagePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Customdrawer extends StatelessWidget {
  const Customdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
       child:Drawer(

        width: width*0.49,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors:[Color(0xFF96B0FF),Color(0xFFFFECED) ],
                  transform: GradientRotation(1.4)
              )

          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 70,bottom: 60,left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings,  color: Colors.white,),

                      SizedBox(width: 20,),
                      Text("Settings".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ),


              ListTile(
                title: Text("Language".tr,
                style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.language,color: Colors.white),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Languagepage()));
                },
              ),
              ListTile(
                title: Text("Log Out".tr,
                    style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.exit_to_app,color: Colors.white),
                onTap: ()async{
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("/Login");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
