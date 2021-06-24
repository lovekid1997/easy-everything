import 'package:flutter/material.dart';
import 'package:easy_everything/easy_everything.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  final duration = 800;
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
                durationAnimation: duration,
                widgetLoading: SpinKitSquareCircle(
                  color: Colors.white,
                  size: 20,
                ),
                onTap: () async {
                  controller.start();
                  await fetchData();
                  controller.success();
                  await Future.delayed(Duration(milliseconds: duration));
                  controller.stop();
                },
                iconRight: Icons.ac_unit,
                iconLeft: Icons.add,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }
}
