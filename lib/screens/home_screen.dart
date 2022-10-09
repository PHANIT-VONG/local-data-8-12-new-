import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences preferences;
  final String keyName = 'name';
  final String keyNumber = 'number';

  String name = '';
  int number = 0;
  @override
  void initState() {
    onInit();
    super.initState();
  }

  void onInit() async {
    preferences = await SharedPreferences.getInstance();
    int? number = preferences.getInt(keyNumber);
    if (number == null) return;
    setState(() {
      this.number = number;
    });
    // String? name = preferences.getString(keyName);
    // if (name == null) return;
    // setState(() {
    //   this.name = name;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Data'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              //name,
              number.toString(),
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('Save'),
              onPressed: () async {
                //await preferences.setString(keyName, 'Phanith');
                await preferences.setInt(keyNumber, 3000);
              },
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text('Read'),
              onPressed: () {
                int? number = preferences.getInt(keyNumber);
                if (number == null) return;
                setState(() {
                  this.number = number;
                });
                // String? name = preferences.getString(keyName);
                // if (name == null) return;
                // setState(() {
                //   this.name = name;
                // });
              },
            ),
          ],
        ),
      ),
    );
  }
}
