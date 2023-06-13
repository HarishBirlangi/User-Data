import 'package:flutter/material.dart';
import 'package:userdatastorage/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, webViewPageRoute);
                },
                child: const Text('Web View')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, usersDataRoute);
                },
                child: const Text('User Data')),
          ],
        ),
      ),
    );
  }
}
