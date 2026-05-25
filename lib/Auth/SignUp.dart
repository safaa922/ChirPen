
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseplaylist/Components/CustomButton.dart';
import 'package:firebaseplaylist/Components/CustomDialog.dart';
import 'package:firebaseplaylist/Components/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}


GlobalKey<FormState> formState = GlobalKey();
class _SignupState extends State<Signup> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController ConfirmPassController = TextEditingController();

  Future signUpWithGoogle()async{
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      if(user==null){
        return "";
      }
      final GoogleSignInAuthentication? userAuth = await user?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: userAuth?.accessToken,
        idToken: userAuth?.idToken
      );
       await FirebaseAuth.instance.signInWithCredential(credential);
       await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
      .set(
         {
           "FirstName":user.displayName?.split(" ").first??"",
           "LastName":user.displayName?.split(" ").length!=1?
               user.displayName?.split(" ").last:"",
           "Email":user.email
         },
         SetOptions(merge: true),
       );
      Navigator.of(context)
          .pushReplacementNamed("/HomePage");

    } on FirebaseAuthException catch (e) {
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

  void dispose(){
    EmailController.dispose();
    PasswordController.dispose();
    FirstNameController.dispose();
    LastNameController.dispose();
    ConfirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formState,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/SignUpBg3.jpg'),fit: BoxFit.fill)
          ),

       child: SingleChildScrollView(

         // child:  Center(
             child: Column(

               children: [
                 SizedBox(height: height*0.17,),
                 Container(
                   height: height * 0.74,
                   width: width*0.879,
                   // color: Colors.white,
                   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                   // child: Expanded(
                   child: Column(
                   children: [

                   SizedBox(height: height*0.06,),

                   CustomTextFormField(myController: FirstNameController, hintText: "First Name".tr, validator: (val) {
                     if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                     }
                   }, icon: Icons.person, width: width*1.07,height: height, obscureText: false,),
                   SizedBox(height: height*0.027,),

                   CustomTextFormField(myController: LastNameController, obscureText: false, hintText: "Last Name".tr, validator: (val){
                     if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                     }
                   },
                       width: width*1.07, icon: Icons.person, height: height),

                   SizedBox(height: height*0.027,),

                   CustomTextFormField(myController: EmailController, hintText: "Email".tr, validator: (val) {
                     if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                     }
                     // final EmailRegex = RegExp(r'^[A-Za-z0-9._%+-]+@gmail\.com$');
                     final EmailRegex = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z]+\.[A-Za-z]{2,}$');
                     if(!EmailRegex.hasMatch(val)){
                       return "Please Enter a valid email".tr;
                     }
                     return null;
                   }, width: width*1.07,icon: Icons.email,height: height, obscureText: false,),
                   SizedBox(height: height*0.027,),

                   CustomTextFormField(myController: PasswordController, hintText: "Password".tr, validator: (val) {
                     if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                     }
                     final passRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!#)^(%~*?&]{8,}$');
                     if(!passRegex.hasMatch(val)){
                       return "make it longer,include special chars".tr;
                     }
                     return null;
                   }, width: width*1.07, icon: Icons.lock,height: height, obscureText: true,),

                   SizedBox(height: height*0.026,),
                   CustomTextFormField(myController: ConfirmPassController, hintText: "Confirm Password".tr, validator: (val){
                     if(val==null || val.trim().isEmpty){
                       return "Cannot be empty".tr;
                     }
                     if(val!=PasswordController.text){
                       return "Passwords do not match".tr;
                     }
                     return null;
                   }, width: width*1.07,icon: Icons.lock_reset,height: height, obscureText: true,),
                   SizedBox(height: height*0.03,),

                   CustomButton(
                     onPressed: () async {
                       if (formState.currentState!.validate()) {
                         try {
                           final credential = await FirebaseAuth.instance
                               .createUserWithEmailAndPassword(
                               email: EmailController.text,
                               password: PasswordController.text);
                           await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
                           .set({
                             "FirstName": FirstNameController.text,
                             "LastName": LastNameController.text,
                             "Email": EmailController.text,
                           });
                           await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                           showDialog(
                             context: context,
                             builder: (context) => CustomDialog(
                               title: "Success".tr,
                               content: "Verification email sent".tr,
                               onPressed: (){
                                 Navigator.of(context).pushReplacementNamed("/Login".tr);
                               },
                             ),
                           );

                         }

                         on FirebaseAuthException
                         catch (e) {
                           if (e.code == "weak-password") {
                             print("must be 8+ chars,including upper,lower, \n a number & special char".tr);
                             showDialog(context: context,
                                 builder: (context)=>
                                     CustomDialog(title: 'ًWeak Password'.tr, content: 'must be 8+ chars,including upper,lower, \n a number & special char'.tr,onPressed: (){
                                       Navigator.of(context).pop();
                                     },));
                           }
                           else if (e.code == "email-already-in-use") {
                             print("The account already exists for this email".tr);
                             showDialog(context: context,
                                 builder: (context)=>
                                     CustomDialog(title: 'Error'.tr, content: 'The account already exists for this email'.tr,
                                         onPressed: (){Navigator.of(context).pop();}));

                           }
                           else if(e.code=="invalid-email"){
                             print("invalid email".tr);
                             showDialog(context: context,
                                 builder: (context)=>
                                     CustomDialog(title: 'Error'.tr, content: 'invalid email'.tr,onPressed: (){
    Navigator.of(context).pop();}));
                           }
                         }
                         catch (e) {
                           print(e);
                         }
                       }

                       else {
                         print("invalid form".tr);
                       }
                     }
                     ,buttonText: "Sign Up".tr,

                   ),
                   SizedBox(height: height*0.01,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Or Register with".tr,style: TextStyle( fontSize: 15,
                           color: Color((0xFF8188DA),),
                           fontWeight: FontWeight.w500),),

                       SizedBox(width: width*0.026,),


                       GestureDetector(
                         onTap:(){
                           signUpWithGoogle();
                         },
                         child: Container(
                           height: height*0.07,
                           width: width*0.07,
                           decoration: BoxDecoration(
                               image: DecorationImage(image: AssetImage("assets/images/GoogleLogo.png"))
                           ),
                         ),
                       )
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       InkWell(
                         child: Text("Already have an account?".tr,style: TextStyle( fontSize: 15,
                             color: Color((0xFF8188DA),),
                             fontWeight: FontWeight.w500),),
                         onTap: (){
                           Navigator.of(context).pushReplacementNamed("/Login");
                         },
                       ),
                     ],
                   )

                   ],
                 ),
                   // ),
                 ),
               ],
             )
         // ),
       ),
    ),

      ),
    );
  }
}
