import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return SizedBox(
      height: 68,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
        height: height*0.12,
        width: width*0.7,
        child: Center(
          child: Text("${buttonText}" ,style: GoogleFonts.marmelad(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(colors:[Color(0xFFFFE4E5),Color(0xFF7AA6FF) ])
        ),
      ),

      ),
    );
  }
}
