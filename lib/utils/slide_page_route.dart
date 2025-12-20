import 'package:flutter/material.dart';

/// Custom page route with slide transition
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Main page slides in from right
            const offsetBegin = Offset(1.0, 0.0);
            const offsetEnd = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: offsetBegin, end: offsetEnd)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}
