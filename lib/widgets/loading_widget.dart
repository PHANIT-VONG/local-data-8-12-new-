import 'package:flutter/material.dart';

class LoadingWidget {
  static Future<void> showLoading(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text('Loading...', style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}
