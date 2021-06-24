import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
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

  ///Size(size, size)
  final double sizeLoading;

  final double strokeWidth;

  final Color colorLoading;

  /// size widget loading should size = 20
  /// if null show loading default CircularProgressIndicator
  final Widget? widgetLoading;

  final Color colorIconError;
  final Color colorIconSucess;
  final Color colorBackgroundError;
  final Color colorBackgroundSuccess;

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
    this.durationAnimation = 800,
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
    this.strokeWidth = 2,
    this.colorLoading = Colors.white,
    this.widgetLoading,
    this.colorIconError = Colors.white,
    this.colorIconSucess = Colors.white,
    this.colorBackgroundError = Colors.red,
    this.colorBackgroundSuccess = Colors.green,
  }) : assert(!(sizeLoading > height / 2),
            'load size no larger than split height 2');

  @override
  _EasyEverythingButtonState createState() => _EasyEverythingButtonState();
}

class _EasyEverythingButtonState extends State<EasyEverythingButton>
    with TickerProviderStateMixin {
  final BehaviorSubject<StatusButton> _subjectStatusButton =
      BehaviorSubject<StatusButton>.seeded(StatusButton.loaded);
  late Animation<double> _resizeIconAnimation;
  late AnimationController _resizeIconController;

  //
  late Animation<double> _resizeAnimation;
  late AnimationController _resizeController;
  //
  late AnimationController _borderController;
  late Animation<BorderRadius> _borderAnimation;
  //
  late AnimationController _bouncerController;
  late Animation<double> _bouncerAnimation;
  @override
  void dispose() {
    _subjectStatusButton.close();
    _resizeIconController.dispose();
    _resizeController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _resizeIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationAnimation),
    );
    _resizeIconAnimation = Tween<double>(begin: widget.sizeIconLeft, end: 0)
        .animate(CurvedAnimation(
            parent: _resizeIconController, curve: Curves.easeInOutCirc));

    //
    _borderController = AnimationController(
        duration: Duration(milliseconds: widget.durationAnimation),
        vsync: this);
    _borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(widget.borderRadius),
            end: BorderRadius.circular(widget.height / 2))
        .animate(_borderController);
    _borderAnimation.addListener(() {
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
      setState(() {});
    });
    _resizeAnimation.addStatusListener((AnimationStatus state) {
      if (state == AnimationStatus.completed &&
          _subjectStatusButton.value != StatusButton.success &&
          _subjectStatusButton.value != StatusButton.error) {
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
    widget.controller.addListeners(_start, _stop, _success, _error);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _error = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: widget.colorBackgroundError,
        borderRadius:
            BorderRadius.all(Radius.circular(_bouncerAnimation.value / 2)),
      ),
      width: _bouncerAnimation.value,
      height: _bouncerAnimation.value,
      child: Icon(
        Icons.error,
        color: widget.colorIconError,
      ),
    );
    final _success = Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: widget.colorBackgroundSuccess,
        borderRadius:
            BorderRadius.all(Radius.circular(_bouncerAnimation.value / 2)),
      ),
      width: _bouncerAnimation.value,
      height: _bouncerAnimation.value,
      child: Icon(
        Icons.check,
        color: widget.colorIconSucess,
      ),
    );
    final stream = StreamBuilder<StatusButton>(
      stream: _subjectStatusButton,
      builder: (context, AsyncSnapshot<Object?> snapshot) {
        final Object? status = snapshot.data;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: status == StatusButton.loading
              ? _Loading(
                  size: widget.sizeLoading,
                  colorLoading: widget.colorLoading,
                  strokeWidth: widget.strokeWidth,
                  widgetLoading: widget.widgetLoading,
                )
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
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
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
    return SizedBox(
        height: widget.height,
        child: StreamBuilder<StatusButton>(
            stream: _subjectStatusButton,
            builder: (context, AsyncSnapshot<Object?> snapshot) {
              return snapshot.data == StatusButton.success
                  ? _success
                  : snapshot.data == StatusButton.error
                      ? _error
                      : _btn;
            }));
  }

  Widget _buildIconLeft() {
    if (widget.iconLeft == null && widget.iconPathLeft == null) {
      return const SizedBox.shrink();
    } else if (widget.iconLeft != null) {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconLeftLabel ?? 0),
        child: Icon(
          widget.iconLeft,
          size: _resizeIconAnimation.value,
          color: widget.colorIconLeft,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconLeftLabel ?? 0),
        child: widget.iconPathLeft!.loadImage(size: _resizeIconAnimation.value),
      );
    }
  }

  Widget _buildIconRight() {
    if (widget.iconRight == null && widget.iconPathRight == null) {
      return const SizedBox.shrink();
    } else if (widget.iconRight != null) {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconRightLabel ?? 0),
        child: Icon(
          widget.iconRight,
          size: _resizeIconAnimation.value,
          color: widget.colorIconRight,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: widget.paddingIconRightLabel ?? 0),
        child:
            widget.iconPathRight!.loadImage(size: _resizeIconAnimation.value),
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
              softWrap: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
          _buildIconRight()
        ],
      ),
    );
  }

  void _start() {
    _resizeIconController.forward();
    _resizeController.forward();
    _borderController.forward();
  }

  void _stop() {
    _subjectStatusButton.sink.add(StatusButton.loaded);
    _resizeController.reverse();
    _borderController.reverse();
    _resizeIconController.reverse();
    _bouncerController.reset();
  }

  void _success() {
    _subjectStatusButton.sink.add(StatusButton.success);
    _bouncerController.forward();
  }

  void _error() {
    _subjectStatusButton.sink.add(StatusButton.error);
    _bouncerController.forward();
  }
}

class EasyEverythingButtonController {
  late VoidCallback _startListener;
  late VoidCallback _stopListener;
  late VoidCallback _successListener;
  late VoidCallback _errorListener;

  void addListeners(VoidCallback startListener, VoidCallback stopListener,
      VoidCallback successListener, VoidCallback errorListener) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
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
}

extension ImageHelper on String {
  Widget loadImage({required double size, Color? color}) {
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
      final img = SvgPicture.asset(
        this,
        width: size,
        height: size,
        color: color,
      );
      return img;
    }

    if (contains('.png')) {
      return Image.asset(
        this,
        width: size,
        height: size,
        color: color,
      );
    }

    throw 'Assest $this failed to load';
  }
}

class _Loading extends StatelessWidget {
  final double size;
  final Color colorLoading;
  final double strokeWidth;
  final Widget? widgetLoading;
  const _Loading({
    Key? key,
    required this.size,
    required this.colorLoading,
    required this.strokeWidth,
    this.widgetLoading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return widgetLoading ??
        SizedBox.fromSize(
          size: Size(size, size),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorLoading),
            strokeWidth: strokeWidth,
          ),
        );
  }
}
