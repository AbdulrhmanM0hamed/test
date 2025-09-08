import 'package:flutter/material.dart';

class ArrowBackWidget extends StatelessWidget {
  const ArrowBackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
