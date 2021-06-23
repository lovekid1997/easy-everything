import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';

enum StatusButton { loaded, loading, success, error }

class EasyEverythingButton extends StatefulWidget {
  /// Button controller, now required
  final EasyEverythingButtonController controller;

  ///child label button
  final String label;

  ///style label
  final TextStyle style;

  ///background color button, default: primary color
  final Color? backgroundColor;

  ///hover color, default: hover color
  final Color? overlayColor;

  ///shadow color is long press, default shadowColor
  final Color? shadowColor;

  ///
  final double? elevation;

  ///border radius, default 45/2
  final double borderRadius;

  /// default 45
  final double height;

  ///on tap button, is null button disable
  final Function? onTap;

  ///duration animation
  final int durationAnimation;

  ///enable button = false is on tap not available
  final bool enableButton;

  ///size icon left
  final double sizeIconLeft;

  ///size icon right
  final double sizeIconRight;

  /// example Icons.add,
  final IconData? iconLeft;

  /// example Icons.add,
  final IconData? iconRight;

  /// path svg, png, in assets,
  /// example: 'assets/images/icon.png'
  final String? iconPathLeft;

  /// path svg, png, in assets,
  /// example: 'assets/images/icon.png'
  final String? iconPathRight;

  ///padding beetwen icon (p) label
  final double? paddingIconLeftLabel;

  ///padding beetwen label (p) icon
  final double? paddingIconRightLabel;

  final Color? colorIconLeft;
  final Color? colorIconRight;

  final double sizeLoading;
  const EasyEverythingButton({
    required this.controller,
    this.label = 'This is button',
    this.style = const TextStyle(),
    this.height = 45,
    this.backgroundColor,
    this.overlayColor,
    this.shadowColor,
    this.elevation,
    this.borderRadius = 15,
    this.durationAnimation = 1000,
    this.enableButton = false,
    this.onTap,
    this.sizeIconLeft = 24,
    this.sizeIconRight = 24,
    this.iconLeft,
    this.iconRight,
    this.iconPathLeft,
    this.iconPathRight,
    this.paddingIconLeftLabel,
    this.paddingIconRightLabel,
    this.colorIconLeft,
    this.colorIconRight,
    this.sizeLoading = 18,
  }) : assert(!(sizeLoading > height / 2),
            'load size no larger than split height 2');

  @override
  _EasyEverythingButtonState createState() => _EasyEverythingButtonState();
}

class _EasyEverythingButtonState extends State<EasyEverythingButton>
    with TickerProviderStateMixin {
  final BehaviorSubject<StatusButton> _subjectStatusButton =
      BehaviorSubject<StatusButton>.seeded(StatusButton.loaded);
  late Animation _bounceIconAnimation;
  late AnimationController _bounceIconController;

  //
  late Animation _resizeAnimation;
  late AnimationController _resizeController;
  //
  late AnimationController _borderController;
  late Animation _borderAnimation;
  //
  late AnimationController _bouncerController;
  late Animation _bouncerAnimation;
  @override
  void dispose() {
    _subjectStatusButton.close();
    _bounceIconController.dispose();
    _resizeController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bounceIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationAnimation),
    );
    _bounceIconAnimation = Tween<double>(begin: widget.sizeIconLeft, end: 0)
        .animate(CurvedAnimation(
            parent: _bounceIconController, curve: Curves.easeInOutCirc));

    //
    _borderController = AnimationController(
        duration: Duration(milliseconds: widget.durationAnimation),
        vsync: this);
    _borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(widget.borderRadius),
            end: BorderRadius.circular(widget.height / 2))
        .animate(_borderController);
    _borderAnimation.addListener(() {
      print('val1 ${_borderAnimation.value}');
      setState(() {});
    });

    //
    _resizeController = AnimationController(
        duration: Duration(milliseconds: widget.durationAnimation),
        vsync: this);
    _resizeAnimation = Tween<double>(begin: 300, end: widget.height).animate(
        CurvedAnimation(
            parent: _resizeController, curve: Curves.easeInOutCirc));
    _resizeAnimation.addListener(() {
      print('val ${_resizeAnimation.value}');
      print('_bounceIconAnimation.value ${_bounceIconAnimation.value}');
      setState(() {});
    });
    _resizeAnimation.addStatusListener((AnimationStatus state) {
      print('AnimationStatus $state');
      if (state == AnimationStatus.completed) {
        _subjectStatusButton.sink.add(StatusButton.loading);
      }
    });
    //

    _bouncerController = AnimationController(
        duration: Duration(milliseconds: widget.durationAnimation),
        vsync: this);
    _bouncerAnimation = Tween<double>(begin: 0, end: widget.height).animate(
        CurvedAnimation(parent: _bouncerController, curve: Curves.elasticOut));
    _bouncerAnimation.addListener(() {
      setState(() {});
    });

    //controller button
    widget.controller.addListeners(_start, _stop, _success, _error, _reset);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var _success = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius:
            BorderRadius.all(Radius.circular(_bouncerAnimation.value / 2)),
      ),
      width: _bouncerAnimation.value,
      height: _bouncerAnimation.value,
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
    var stream = StreamBuilder<StatusButton>(
      stream: _subjectStatusButton,
      builder: (context, AsyncSnapshot<Object?> snapshot) {
        final Object? status = snapshot.data;
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: status == StatusButton.loading
              ? _Loading(size: widget.sizeLoading)
              : _content(),
        );
      },
    );
    final _btn = SizedBox.fromSize(
      size: Size(_resizeAnimation.value, widget.height),
      child: ButtonTheme(
        disabledColor: theme.disabledColor,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            overlayColor: MaterialStateProperty.all(
                widget.overlayColor ?? theme.hoverColor),
            elevation: MaterialStateProperty.all(widget.elevation),
            backgroundColor: widget.enableButton
                ? null
                : MaterialStateProperty.all(
                    widget.backgroundColor ?? theme.primaryColor),
            shadowColor: MaterialStateProperty.all(
                widget.shadowColor ?? theme.shadowColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: _borderAnimation.value,
              ),
            ),
          ),
          onPressed: widget.enableButton
              ? null
              : widget.onTap != null
                  ? () {
                      widget.onTap!();
                    }
                  : null,
          child: stream,
        ),
      ),
    );
    return Container(
      height: widget.height,
      child:
          _subjectStatusButton.value == StatusButton.success ? _success : _btn,
    );
  }

  _buildIconLeft() {
    if (widget.iconLeft == null && widget.iconPathLeft == null)
      return SizedBox.shrink();
    else if (widget.iconLeft != null) {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconLeftLabel ?? 0),
        child: Icon(
          widget.iconLeft,
          size: _bounceIconAnimation.value,
          color: widget.colorIconLeft,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconLeftLabel ?? 0),
        child: widget.iconPathLeft!.loadImage(size: _bounceIconAnimation.value),
      );
    }
  }

  _buildIconRight() {
    if (widget.iconRight == null && widget.iconPathRight == null)
      return SizedBox.shrink();
    else if (widget.iconRight != null) {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconRightLabel ?? 0),
        child: Icon(
          widget.iconRight,
          size: _bounceIconAnimation.value,
          color: widget.colorIconRight,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconRightLabel ?? 0),
        child:
            widget.iconPathRight!.loadImage(size: _bounceIconAnimation.value),
      );
    }
  }

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconLeft(),
          Flexible(
            child: AutoSizeText(
              widget.label,
              style: widget.style,
              minFontSize: 0,
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildIconRight()
        ],
      ),
    );
  }

  _start() {
    _bounceIconController.forward();
    _resizeController.forward();
    _borderController.forward();
  }

  _stop() {
    _subjectStatusButton.sink.add(StatusButton.loaded);
    _resizeController.reverse();
    _borderController.reverse();
    _bounceIconController.reverse();
  }

  _success() {
    _subjectStatusButton.sink.add(StatusButton.success);
    _bouncerController.forward();
    print('StatusButton ${_subjectStatusButton.value}');
  }

  _error() {}

  _reset() {}
}

class EasyEverythingButtonController {
  late VoidCallback _startListener;
  late VoidCallback _stopListener;
  late VoidCallback _successListener;
  late VoidCallback _errorListener;
  late VoidCallback _resetListener;

  addListeners(
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      VoidCallback errorListener,
      VoidCallback resetListener) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  /// Notify listeners to start the loading animation
  void start() {
    _startListener();
  }

  /// Notify listeners to start the stop animation
  void stop() {
    _stopListener();
  }

  /// Notify listeners to start the sucess animation
  void success() {
    _successListener();
  }

  /// Notify listeners to start the error animation
  void error() {
    _errorListener();
  }

  /// Notify listeners to start the reset animation
  void reset() {
    _resetListener();
  }
}

extension ImageHelper on String {
  Widget loadImage(
      {double? width, double? height, double? size, Color? color}) {
    if (size != null && size > 0) {
      width = size;
      height = size;
    }
    // if (contains('http')) {
    //   return CachedNetworkImage(
    //     imageUrl: this,
    //     width: width,
    //     height: height,
    //     color: color,
    //     errorWidget: (context, url, error) => Icon(Icons.error),
    //   );
    // }

    if (contains('.svg')) {
      var img = SvgPicture.asset(
        this,
        width: width ?? 24,
        height: height ?? 24,
        color: color,
      );
      return img;
    }

    if (contains('.png')) {
      return Image.asset(
        this,
        width: width,
        height: height,
        color: color,
      );
    }

    throw 'Assest $this failed to load';
  }
}

class _Loading extends StatelessWidget {
  final double size;

  const _Loading({Key? key, required this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size,
      color: Colors.white,
    );
  }
}
