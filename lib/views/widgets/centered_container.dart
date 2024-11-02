import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that creates a centered container with a fixed minimum width
/// and applies styling such as padding, margin, border radius, and box shadow.
class CenteredContainerWidget extends StatelessWidget {
  // The width of the screen to determine the container's size
  final double screenWidth;
  
  // The child widget to be displayed inside the container
  final Widget child;

  const CenteredContainerWidget({
    super.key,
    required this.screenWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // The container width is a quarter of the screen width or 500 pixels, whichever is larger
      width: max(screenWidth * 0.25, 500),
      
      // Adds padding inside the container to create space around the child widget
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      
      // Adds margin outside the container to create space around it
      // margin: const EdgeInsets.all(50),
      
      // Applies styling to the container
      decoration: const BoxDecoration(
        color: Colors.transparent, // Sets the background color of the container
        // borderRadius: BorderRadius.circular(10), // Rounds the corners of the container
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.3), // Applies a shadow with partial opacity
        //     spreadRadius: 5, // The spread of the shadow
        //     blurRadius: 7, // The blur radius of the shadow
        //     offset: const Offset(0, 3), // The position of the shadow (x, y)
        //   ),
        // ],
      ),
      
      // The widget to be displayed inside the container
      child: child,
    );
  }
}
