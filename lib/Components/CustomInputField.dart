import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController myController;
  final String? Function(String?)? validator;
  final String hintText;
  final double width;
  final double height;
  final IconData icon;
  final bool obscureText;
  final void Function(String)? onChanged;
  const CustomTextFormField({
    super.key,
    required this.myController,
    required this.obscureText,
    required this.hintText,
    required this.validator,
    required this.width,
    required this.icon,
    required this.height,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.65,
      height: height * 0.055,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Image.asset(
            "assets/images/inputFieldEdit2.png",
            width: width * 0.65,
            height: height * 0.08,
            fit: BoxFit.fill,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child:
                Row(
                  children: [
                    Icon(
                      icon,
                      color: const Color(0xFF8188DA),
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        validator: validator,
                        onChanged:onChanged,
                        controller: myController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            height: 0.1,
                            fontSize: 12
                          ),
                          hintStyle: const TextStyle(
                            color: Color(0xFF8188DA),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),

                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8188DA),
                        ),

                      ),
                    ),

                  ],
                ),


          ),
        ],

      ),

    );

  }
}