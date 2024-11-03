import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final double? iconPadding;
  final double? width;
  final double? height;

  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.iconPadding,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];

    if (iconPath != null) {
      rowChildren.add(Image.asset(iconPath!, fit: BoxFit.contain));
    }

    if (iconPadding != null && iconPath != null) {
      rowChildren.add(SizedBox(width: iconPadding));
    }

    rowChildren.add(Flexible(
      child: AutoSizeText(
        text,
        style: GoogleFonts.inter(
          fontSize: fontSize ?? 15, color: Colors.white, fontWeight: FontWeight.w600),
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    ));

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rowChildren,
        ),
      ),
    );
  }
}
