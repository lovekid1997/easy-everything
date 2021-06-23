import 'package:flutter/material.dart';
import 'package:easy_everything/easy_everything.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyExample(),
    );
  }
}

class MyExample extends StatelessWidget {
  final EasyEverythingButtonController controller =
      EasyEverythingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: EasyEverythingButton(
                controller: controller,
                onTap: () async {
                  controller.start();
                  await Future.delayed(Duration(seconds: 4));
                  controller.success();
                  await Future.delayed(Duration(seconds: 4));
                  controller.stop();
                },
                label: 'sdasdasdaszxcjzxklj',
                iconRight: Icons.ac_unit,
                iconLeft: Icons.add,
              ),
            )
          ],
        ),
      ),
    );
  }
}
