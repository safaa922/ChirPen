

import 'package:flutter/material.dart';

class Customfloatingbutton extends StatelessWidget {
  final VoidCallback? onPressed;
  const Customfloatingbutton({super.key, required this.onPressed});

  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            Color(0xFFFCCBBF),Color(0xFF7AA6FF)
          ],
           transform: GradientRotation(0.57)
          )
      ),


      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,

          onPressed:onPressed,

    child: const Icon(Icons.add_rounded,color: Colors.white,size: 30,),
    ));
  }
}
