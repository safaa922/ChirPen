
import 'package:firebaseplaylist/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController{
   Locale initLang = sharedPref!.getString("lang")==null? Get.deviceLocale!: Locale(sharedPref!.getString("lang")!);

   void changeLang(String codeLang){
     Locale locale = Locale(codeLang);
     sharedPref!.setString("lang",codeLang);
     Get.updateLocale(locale);

   }
}