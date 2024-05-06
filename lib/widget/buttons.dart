import 'package:flutter/material.dart';
import 'package:sicepat/shared/theme.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed; 
  const CustomFilledButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 50,
    this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: width,
            height: height,
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: redColor,
                
              ), 
              child: Text(
                'Login',
                style: poppinsboldWhite.copyWith(
                  fontSize: 15,
                  fontWeight: bold
                ),
                ),
            ),
          );
  }
}