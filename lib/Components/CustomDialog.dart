import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog extends StatelessWidget {

  final String title;
  final String content;
  final void Function()? onPressed;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content, this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title,style: GoogleFonts.marmelad
        (color: Color(0xFF8188DA),fontWeight: FontWeight.bold),),
      content: Text(content,style:TextStyle(color: Color(0xFF8188DA))),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF8188DA),
              borderRadius: BorderRadius.circular(10)
            ),
            height: height*0.05,
            width: width*0.16,

            child: Center(
              child: Text("OK".tr
              ,style:  GoogleFonts.marmelad(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            )
          )
        )
      ],
    );
  }
}