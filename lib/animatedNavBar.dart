import 'package:animated_navigation_bar/navigation.dart';
import 'package:flutter/material.dart';

class AnimatedNavBar extends StatefulWidget {
  ///
  /// The [pages] [color] and [borderRadius] parameters must not be null.
  final List<AnimatedNavBarPage>? pages;
  final double padding;
  final Color? color;

  ///
  /// The [defaultPage] default value is 0.
  ///
  /// The [iconColor] how the the selected tab icon's color should appear.
  ///
  /// The [inactiveIconColor] how the the unselected tab icon's color should appear.
  ///
  /// The [borderRadius] arguments indicates how the radius around the corners of the [CustomPainter].
  ///
  /// [shadow] Whether there's elevation or not.
  ///
  /// Provides the AnimatedNavBar with a [TextStyle] to stylize the tab bar titles.
  ///
  /// If the [textStyle] argument is null, the AnimatedNavBar will use the style from the
  /// closest enclosing [DefaultTextStyle].
  final int defaultPage;
  final ValueChanged<int?>? selectedPage;
  final bool activeButtonIsWide;
  final Color? iconColor;
  final Color? inactiveColor;
  final Radius? borderRadius;
  final bool shadow;
  final TextStyle? textStyle;

  const AnimatedNavBar(
      {Key? key,
      this.pages,
      this.padding = 8,
      this.color,
      this.defaultPage = 0,
      this.selectedPage,
      this.activeButtonIsWide = false,
      this.iconColor,
      this.inactiveColor,
      this.borderRadius,
      this.shadow = true,
      this.textStyle})
      : super(key: key);

  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  int? size;
  int? selected;
  Color? shadowColor;
  double? tabButtonHeight;
  Color? icnColor;

  /// turn into these parameters
  int defaultFlex = 1;

  @override
  void initState() {
    /// the limit for a [Bottom navigation] destinations is 5 according
    /// to the material.io design guidelines
    /// for more on bottom navigation bars head over to https://material.io/components/bottom-navigation#usage
    ///
    /// if you want to implement more than 5 destinations than a navigation drawer would suffice.
    if (!(widget.pages!.length > 0 && widget.pages!.length < 6))
      throw ("Total count of tabs must not exceed 5 or recede 1");
    size = widget.pages!.length;
    selected = widget.defaultPage;
    Color color = widget.color!;
    tabButtonHeight = 56;
    shadowColor = Color.fromARGB(120, (color.red * 0.2).toInt(),
        (color.green * 0.2).toInt(), (color.blue * 0.2).toInt());

    /// style init state
    if (widget.activeButtonIsWide)
      defaultFlex = 3;
    else
      defaultFlex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Stack(fit: StackFit.expand, children: [
          CustomPaint(
              painter: BackgroundPainter(
                  (Directionality.of(context) == TextDirection.rtl),
                  selected,
                  size,
                  defaultFlex,
                  widget.color,
                  shadowColor,
                  widget.borderRadius!.x,
                  tabButtonHeight,
                  widget.shadow)),
          Column(mainAxisSize: MainAxisSize.max, children: [
            // TabView
            Expanded(
                child: ClipPath(
                    clipper: BackgroundClipper(
                        (Directionality.of(context) == TextDirection.rtl),
                        selected,
                        size,
                        widget.borderRadius!.x,
                        tabButtonHeight),
                    child: Stack(
                        fit: StackFit.expand,
                        children: (() {
                          List<Widget> _list = [];
                          for (int i = 0; i < widget.pages!.length; i++) {
                            _list.add(Offstage(
                                offstage: selected != i,
                                child: TabNavigator(
                                    rootPage: widget.pages![i].pageContent,
                                    navigatorKey:
                                        widget.pages![i].navigationKey)));
                          }
                          return _list;
                        }())))),
            // TabButtons
            Row(
                children: (() {
              List<Widget> _list = [];
              for (int i = 0; i < size!; i++) {
                _list.add(Expanded(
                    flex: (selected == i) ? this.defaultFlex : 1,
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: (selected == i)
                                ? () => setState(() => widget
                                    .pages![i].navigationKey.currentState!
                                    .popUntil((route) => route.isFirst))
                                : () => setState(() {
                                      selected = i;
                                      widget.selectedPage?.call(selected);
                                    }),
                            child: Container(
                                height: tabButtonHeight,
                                alignment: Alignment.center,
                                child: (selected == i)
                                    ? (widget.activeButtonIsWide)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                                Icon(widget.pages![i].icon,
                                                    color: widget.iconColor),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(widget.pages![i].title,
                                                    style: widget.textStyle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)
                                              ])
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                Icon(widget.pages![i].icon,
                                                    color: widget.iconColor),
                                                Text(widget.pages![i].title,
                                                    style: widget.textStyle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)
                                              ])
                                    : (widget.activeButtonIsWide)
                                        ? Icon(
                                            (widget.pages![i].inactiveIcon !=
                                                    null)
                                                ? widget.pages![i].inactiveIcon
                                                : widget.pages![i].icon,
                                            color:
                                                (widget.inactiveColor != null)
                                                    ? widget.inactiveColor
                                                    : widget.iconColor,
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                Icon(
                                                  widget.pages![i].icon,
                                                  color:
                                                      (widget.inactiveColor !=
                                                              null)
                                                          ? widget.inactiveColor
                                                          : widget.iconColor,
                                                ),
                                                Text(this.widget.pages![i].title,
                                                    style: (widget
                                                                .inactiveColor !=
                                                            null)
                                                        ? TextStyle(
                                                            color: this
                                                                .widget
                                                                .inactiveColor)
                                                        : widget.textStyle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis)
                                              ]))))));
              }
              return _list;
            }()))
          ])
        ]));
  }
}

///
/// CustomClipper to clip the Tab view page
class BackgroundClipper extends CustomClipper<Path> {
  /// the [isRtl] is to check whether the directionality of the [context]
  /// is right to left or not, to see from which direction the paint should draw
  final bool isRtl;

  /// [selected] and [tabSize] are to know how to clip the background on the corners
  final int? selected;
  final int? tabSize;

  /// [radius] is the border radius value
  final double radius;

  /// to get the bottom margin
  final double? tabButtonHeight;

  BackgroundClipper(this.isRtl, this.selected, this.tabSize, this.radius,
      this.tabButtonHeight);

  @override
  Path getClip(Size size) {
    Path path = Path();

    /// to control which direction the clipper should start clipping
    /// depending on the directionality ot the [Locale]
    double extremeRight = size.width * (isRtl ? 0 : 1),
        extremeLeft = size.width * (isRtl ? 1 : 0),
        directionalitySign = (isRtl ? 1 : -1);

    /// starting point : right side, left for rtl
    path.moveTo(extremeRight, radius);

    /// top right corner, top left for rtl
    path.quadraticBezierTo(
        extremeRight, 0, extremeRight + directionalitySign * radius, 0);

    /// top line
    path.lineTo(extremeLeft - directionalitySign * radius, 0);

    /// top left corner, rop right for rtl
    path.quadraticBezierTo(extremeLeft, 0, extremeLeft, radius);

    /// bottom left corner, bottom right in case of [rtl]
    /// if selected item is the first one
    if (selected == 0) {
      path.lineTo(extremeLeft, size.height);
      path.lineTo(extremeRight + directionalitySign * radius, size.height);
      path.quadraticBezierTo(
          extremeRight, size.height, extremeRight, size.height - radius);
    } else if (selected == tabSize! - 1) {
      path.lineTo(extremeLeft, size.height - radius);
      path.quadraticBezierTo(extremeLeft, size.height,
          extremeLeft - directionalitySign * radius, size.height);
      path.lineTo(extremeRight, size.height);
    } else {
      path.lineTo(extremeLeft, size.height - radius);
      path.quadraticBezierTo(extremeLeft, size.height,
          extremeLeft - directionalitySign * radius, size.height);
      path.lineTo(extremeRight + directionalitySign * radius, size.height);
      path.quadraticBezierTo(
          extremeRight, size.height, extremeRight, size.height - radius);
    }

    path.lineTo(extremeRight, radius);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

///
/// CustomPainter to paint the Tab view background
class BackgroundPainter extends CustomPainter {
  /// the [isRtl] is to check whether the directionality of the [context]
  /// is right to left or not, to see from which direction the paint should draw
  final bool isRtl;

  /// [selected] and [tabSize] are to know how to clip the background on the corners
  final int? selected;
  final int? tabSize;
  final int defaultFlex;
  final Color? color;
  final Color? shadowColor;

  /// [radius] is the border radius value
  final double radius;
  final double? tabButtonHeight;
  final bool shadow;

  BackgroundPainter(
      this.isRtl,
      this.selected,
      this.tabSize,
      this.defaultFlex,
      this.color,
      this.shadowColor,
      this.radius,
      this.tabButtonHeight,
      this.shadow);

  @override
  void paint(Canvas canvas, Size size) {
    double flexSize = size.width / (tabSize! - 1 + this.defaultFlex);
    double activeTabWidth = flexSize * this.defaultFlex;
    Paint paint = Paint();
    paint.color = this.color!;
    paint.style = PaintingStyle.fill; // Change this to fill

    Path path = Path();

    /// to control which direction the painter should start painting
    /// depending on the directionality ot the [Locale]
    double extremeRight = size.width * (isRtl ? 0 : 1),
        extremeLeft = size.width * (isRtl ? 1 : 0),
        directionalitySign = (isRtl ? 1 : -1);

    /// starting point : right side
    path.moveTo(extremeRight, radius);

    /// top right corner
    path.quadraticBezierTo(
        extremeRight, 0, extremeRight + directionalitySign * radius, 0);

    /// top line
    path.lineTo(extremeLeft - directionalitySign * radius, 0);

    /// top left corner
    path.quadraticBezierTo(extremeLeft, 0, extremeLeft, radius);

    /// bottom left corner
    if (selected == 0)
      path.lineTo(extremeLeft, size.height - tabButtonHeight!);
    else {
      path.lineTo(extremeLeft, size.height - tabButtonHeight! - radius);
      path.quadraticBezierTo(
          extremeLeft,
          size.height - tabButtonHeight!,
          extremeLeft - directionalitySign * radius,
          size.height - tabButtonHeight!);
    }

    /// tab buttons
    for (int i = 0; i < tabSize!; i++) {
      /// if painter is before selected item
      if (i == selected! - 1) {
        path.lineTo(
            extremeLeft - directionalitySign * (flexSize * (i + 1) - radius),
            size.height - tabButtonHeight!);
        path.quadraticBezierTo(
            extremeLeft - directionalitySign * (flexSize * (i + 1)),
            size.height - tabButtonHeight!,
            extremeLeft - directionalitySign * (flexSize * (i + 1)),
            size.height - tabButtonHeight! + radius);
      }

      /// if painter is on selected item
      if (i == selected) {
        path.lineTo(extremeLeft - directionalitySign * (flexSize * i),
            size.height - radius);
        path.quadraticBezierTo(
            extremeLeft - directionalitySign * (flexSize * i),
            size.height,
            extremeLeft - directionalitySign * (flexSize * i + radius),
            size.height);
        path.lineTo(
            extremeLeft -
                directionalitySign * (flexSize * i + activeTabWidth - radius),
            size.height);
        path.quadraticBezierTo(
            extremeLeft - directionalitySign * (flexSize * i + activeTabWidth),
            size.height,
            extremeLeft - directionalitySign * (flexSize * i + activeTabWidth),
            size.height - radius);
      }

      /// if painter is after selected item
      if (i == selected! + 1) {
        path.lineTo(
            extremeLeft -
                directionalitySign * (flexSize * (i - 1) + activeTabWidth),
            size.height - tabButtonHeight! + radius);
        path.quadraticBezierTo(
            extremeLeft -
                directionalitySign * (flexSize * (i - 1) + activeTabWidth),
            size.height - tabButtonHeight!,
            extremeLeft -
                directionalitySign *
                    (flexSize * (i - 1) + activeTabWidth + radius),
            size.height - tabButtonHeight!);
      }
    }

    /// bottom right corner
    if (selected == tabSize! - 1)
      path.lineTo(extremeRight, radius);
    else {
      path.lineTo(extremeRight + directionalitySign * radius,
          size.height - tabButtonHeight!);
      path.quadraticBezierTo(extremeRight, size.height - tabButtonHeight!,
          extremeRight, size.height - tabButtonHeight! - radius);
      path.lineTo(extremeRight, radius);
    }

    /// drawing the canvas
    if (this.shadow) canvas.drawShadow(path, this.shadowColor!, 4.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// This class's main purpose is to provide an [AnimatedNavPage] with pages.
class AnimatedNavBarPage {
  ///
  /// The [title] [pageContent] and [icon] parameters must not be null.
  ///
  /// The [inactiveIcon] property's replaced by the [icon] argument when null.
  final String title;
  final Widget pageContent;
  final IconData? icon;
  final IconData? inactiveIcon;
  final GlobalKey<NavigatorState> navigationKey;

  const AnimatedNavBarPage(
      {Key? key,
      required this.title,
      required this.pageContent,
      required this.navigationKey,
      this.icon,
      this.inactiveIcon});
}
