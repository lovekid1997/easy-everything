# Easy Widget
A new Flutter package.
## Getting Started
For work reason I needed to change some properties so I built this widget with rounded_loading_button in mind.
I have added icons, optionally added loading widgets, gradient color,...
Since I'm a newbie, I'm looking forward to everyone's suggestions, thanks.
Get an idea from a package on pub.dev
Link rounded loading: [rounded_loading_button](https://pub.dev/packages/rounded_loading_button). 
## Required version
##### SDK: ">=2.12.0 <3.0.0"
##### FLUTTER: ">=2.0.0"
## Example
Ví dụ này có thêm [flutter_spinkit ](https://pub.dev/packages/flutter_spinkit).
```dart
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
````



