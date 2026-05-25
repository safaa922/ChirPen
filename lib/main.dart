import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseplaylist/Auth/Login.dart';
import 'package:firebaseplaylist/Auth/SignUp.dart';
import 'package:firebaseplaylist/Categories/Category.dart';
import 'package:firebaseplaylist/Localization/LocaleController.dart';
import 'package:firebaseplaylist/Localization/LocaleMap.dart';
import 'package:firebaseplaylist/View/ForgotPassword.dart';
import 'package:firebaseplaylist/View/HomePage.dart';
import 'package:firebaseplaylist/View/LanguagePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPref;
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
     //options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
void initState(){
  FirebaseAuth.instance.authStateChanges().listen((User? user){
    if(user==null){
      print("user is currently signed out");
    }
    else{
      print("User is signed in");
    }
  });
  super.initState();
}


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
  LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      //home: FirebaseAuth.instance.currentUser!=null && FirebaseAuth.instance.currentUser!.emailVerified ?HomePage():Login(),
     home: sharedPref!.getBool("LangChosen")==true? (user!=null && user.emailVerified? HomePage():Login()) :const Languagepage(),
      debugShowCheckedModeBanner: false,
      translations:LocaleMap(),
      locale: controller.initLang,
      routes: {
        "/SignUp":(context)=>Signup(),
        "/Login":(context)=>Login(),
        "/HomePage":(context)=>HomePage(),
        // "/AddCategory":(context)=>Category(),

      },
    );
  }
}
