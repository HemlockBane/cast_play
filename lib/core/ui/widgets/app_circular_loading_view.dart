import 'package:flutter/material.dart';

class AppCircularLoadingView extends StatelessWidget {
  const AppCircularLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.amber[800],
      ),
    );
  }
}
