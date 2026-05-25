import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseplaylist/Components/CustomDialog.dart';
import 'package:firebaseplaylist/Components/CustomInputField.dart';
import 'package:firebaseplaylist/View/ForgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();



class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey();


  Future signInWithGoogle()async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
      );
       await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
          {
            "FirstName":googleUser.displayName?.split(" ").first??"",
            "LastName":googleUser.displayName?.split(" ").length!=1?
            googleUser.displayName?.split(" ").last:"",
            "Email":googleUser.email
          },
          SetOptions(merge: true)
      );
      Navigator.of(context)
          .pushReplacementNamed("/HomePage");
    }
    on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: "Error".tr,
          content: e.message ?? "Google sign in failed".tr,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
    catch (e) {

      showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: "Error".tr,
          content: e.toString(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        // autovalidateMode : AutovalidateMode.onUserInteraction,
        key: formState,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.white,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/LoginBg.png'),fit: BoxFit.fill)
          ),
          child: Column(
                children: [
                  SizedBox(height: height*0.20,),
                  Padding(padding: EdgeInsets.only(left: width*0.093),
                    child:  Container(
                    width: width * 0.51,
                    height: height * 0.193,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/BirdFullMain.png'),fit: BoxFit.fill)
                    ),
                  ),),
                  SizedBox(height: height*0.024,),
                  // Text("Login".tr),
                  CustomTextFormField(myController: EmailController, hintText: "Email".tr, validator: (val){
                    if(val==null || val.trim().isEmpty){
                      return "Cannot be empty".tr;
                    }
                  }, width: width,icon: Icons.email,height: height, obscureText: false,),
                  SizedBox(height: height*0.0199,),
                  CustomTextFormField(myController: PasswordController,obscureText:true, hintText: "Password".tr, validator: (val) {
                    if(val==null || val.trim().isEmpty){
                      return "Cannot be empty".tr;
                    }
                  }, width: width, icon: Icons.lock, height: height,),
                  SizedBox(height: height*0.0199,),

                  Padding(padding: EdgeInsets.only(left: 170),
                      child:InkWell(
                          child: Text("Forgot Password ?".tr,
                            style: TextStyle(fontSize: 14,
                              color: Color((0xFF8188DA),),
                              fontWeight: FontWeight.w600,),),
                          onTap: ()async {

                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Forgotpassword(Email: EmailController.text)));
                          }
                      ),
                  ),

                  SizedBox(height: height*0.015,),
                  MaterialButton(

                      onPressed: ()async{
                        if(formState.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: EmailController.text,
                                password: PasswordController.text);
                            await FirebaseAuth.instance.currentUser!.reload();
                            if (FirebaseAuth.instance.currentUser!.emailVerified && FirebaseAuth.instance.currentUser!=null) {
                              Navigator.of(context).pushReplacementNamed("/HomePage");
                            }
                            else {
                              // if (context.mounted) {
                              showDialog(context: context,
                                  builder: (context)=>
                                      AlertDialog(
                                        title: Text("Alert".tr,style: GoogleFonts.marmelad
                                          (color: Color(0xFF8188DA),fontWeight: FontWeight.bold),),
                                        content: Text("there's an email verification message sent to your email\n do you want to resend?".tr
                                            ,style:TextStyle(color: Color(0xFF8188DA),fontWeight: FontWeight.w500)),
                                        actions: [
                                          TextButton(onPressed: ()async{
                                            await FirebaseAuth.instance.currentUser!
                                                .sendEmailVerification();}, child:  Container(
                                            decoration: BoxDecoration(
                                                color:  Color(0xFF8188DA),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            height: height*0.05,
                                            width: width*0.16,

                                            child: Center(
                                              child: Text("Yes".tr
                                                ,style:  GoogleFonts.marmelad(color: Colors.white,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),),
                                          TextButton(onPressed: (){Navigator.of(context).pop();}, child:  Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFACB0D0),
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
                                      ));
                            }
                            // }
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == "user-not-found") {
                              print("No User Found");
                              showDialog(context: context,
                                  builder: (context)=>
                                      CustomDialog(title: 'Error'.tr, content: 'No User Found'.tr,onPressed: (){
                                        Navigator.of(context).pop();
                                      },));
                            }
                            else if (e.code == "invalid-email") {
                              print("invalid email");
                              showDialog(context: context,
                                  builder: (context)=>
                                      CustomDialog(title: 'Error'.tr, content: 'Invalid Email'.tr,onPressed: (){
                                        Navigator.of(context).pop();
                                      },));
                            }

                            else if (e.code == "wrong-password" || e.code=="invalid-credential") {
                              showDialog(context: context,
                                  builder: (context)=>
                                      CustomDialog(title: 'Error'.tr, content: 'Wrong email or Password'.tr,onPressed: (){
                                        Navigator.of(context).pop();
                                      },));
                            }
                          }
                          catch (e) {
                            print(e);
                          }
                        }
                        else{
                          print("invalid form");
                        }
                      },

                      child: Container(
                        width: width*0.65,
                        height: height*0.08,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [Color(0xFFFCCBBF),Color(0xFF7AA6FF)])
                        ),
                        child: Center(
                          child: Text("Login".tr,style: GoogleFonts.marmelad(fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,),),
                        ),
                      )),
                  SizedBox(height: height*0.016,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Or Login With".tr,style: TextStyle( fontSize: 15,
                      color: Color((0xFF8188DA),),
                      fontWeight: FontWeight.w500),),

                      SizedBox(width: width*0.028,),
                      GestureDetector(
                        onTap:(){
                          signInWithGoogle();
                        },
                        child: Container(
                          height: height*0.073,
                          width: width*0.073,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/images/GoogleLogo.png"))
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text("Don't have an account yet?".tr,style: TextStyle( fontSize: 15,
                            color: Color((0xFF8188DA),),
                            fontWeight: FontWeight.w500),),
                        onTap: (){
                          Navigator.of(context).pushReplacementNamed("/SignUp");
                        },
                      ),
                    ],
                  ),
                ],
          ),

        ),
      ),
    );
  }
}
