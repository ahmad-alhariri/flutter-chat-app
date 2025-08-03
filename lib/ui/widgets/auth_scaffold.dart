import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/widgets/beizer_container_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  const AuthScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            const Positioned(top: 0, left: 0, right: 0, child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}