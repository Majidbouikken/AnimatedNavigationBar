import 'package:flutter/material.dart';

class AnimatedNavBar extends StatefulWidget {
  final List<AnimatedNavBarPage> pages;
  final double padding;
  final Color color;
  final Color backgroundColor;
  final Color iconColor;
  final Color inactiveIconColor;
  final Radius borderRadius;
  final bool shadow;
  final TextStyle textStyle;

  const AnimatedNavBar(
      {Key key,
      this.pages,
      this.padding = 8,
      this.color,
      this.backgroundColor,
      this.iconColor,
      this.inactiveIconColor,
      this.borderRadius,
      this.shadow = true,
      this.textStyle})
      : super(key: key);

  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  int size;
  int selected;
  Color shadowColor;
  double tabButtonHeight;
  Color icnColor;

  @override
  void initState() {
    if (!(this.widget.pages.length > 0 && this.widget.pages.length < 6))
      throw ("Total count of tabs must not exceed 5 or recede 1");
    size = widget.pages.length;
    selected = 0;
    Color color = this.widget.color;
    tabButtonHeight = 48;
    shadowColor = Color.fromARGB(120, (color.red * 0.2).toInt(),
        (color.green * 0.2).toInt(), (color.blue * 0.2).toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(this.widget.padding),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: Background(
                  selected,
                  size,
                  this.widget.color,
                  shadowColor,
                  this.widget.borderRadius.x,
                  tabButtonHeight,
                  this.widget.shadow),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // TabView
                Expanded(
                  child: this.widget.pages[selected].pageContent,
                ),
                // TabButtons
                Row(
                  children: (() {
                    List<Widget> _list = [];
                    for (int i = 0; i < size; i++) {
                      _list.add(Expanded(
                          flex: (selected == i) ? 3 : 1,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selected = i;
                                });
                              },
                              child: Container(
                                height: tabButtonHeight,
                                alignment: Alignment.center,
                                child: (selected == i)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            this.widget.pages[i].icon,
                                            color: this.widget.iconColor,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            this.widget.pages[i].title,
                                            style: this.widget.textStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      )
                                    : Icon(
                                        (this.widget.pages[i].inactiveIcon !=
                                                null)
                                            ? this.widget.pages[i].inactiveIcon
                                            : this.widget.pages[i].icon,
                                        color: (this.widget.inactiveIconColor !=
                                                null)
                                            ? this.widget.inactiveIconColor
                                            : this.widget.iconColor,
                                      ),
                              ),
                            ),
                          )));
                    }
                    return _list;
                  }()),
                )
              ],
            ),
          ],
        ));
  }
}

class Background extends CustomPainter {
  final int selected;
  final int tabSize;
  final Color color;
  final Color shadowColor;
  final double radius;
  final double tabButtonHeight;
  final bool shadow;

  Background(this.selected, this.tabSize, this.color, this.shadowColor,
      this.radius, this.tabButtonHeight, this.shadow);

  @override
  void paint(Canvas canvas, Size size) {
    var flexSize = size.width / (tabSize - 1 + 3);
    var activeTabWidth = flexSize * 3;
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    // starting point (right side)
    path.moveTo(size.width, radius);
    // top right corner
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
    // top line
    path.lineTo(radius, 0);
    // top left corner
    path.quadraticBezierTo(0, 0, 0, radius);

    // bottom left corner
    if (selected == 0)
      path.lineTo(0, size.height - tabButtonHeight);
    else {
      path.lineTo(0, size.height - tabButtonHeight - radius);
      path.quadraticBezierTo(0, size.height - tabButtonHeight, radius,
          size.height - tabButtonHeight);
    }
    // tab buttons
    for (int i = 0; i < tabSize; i++) {
      // if painter is before selected item
      if (i == selected - 1) {
        path.lineTo(flexSize * (i + 1) - radius, size.height - tabButtonHeight);
        path.quadraticBezierTo(
            flexSize * (i + 1),
            size.height - tabButtonHeight,
            flexSize * (i + 1),
            size.height - tabButtonHeight + radius);
      }
      // if painter is on selected item
      if (i == selected) {
        path.lineTo(flexSize * i, size.height - radius);
        path.quadraticBezierTo(
            flexSize * i, size.height, flexSize * i + radius, size.height);
        path.lineTo(flexSize * i + activeTabWidth - radius, size.height);
        path.quadraticBezierTo(flexSize * i + activeTabWidth, size.height,
            flexSize * i + activeTabWidth, size.height - radius);
      }
      // if painter is after selected item
      if (i == selected + 1) {
        path.lineTo(flexSize * (i - 1) + activeTabWidth,
            size.height - tabButtonHeight + radius);
        path.quadraticBezierTo(
            flexSize * (i - 1) + activeTabWidth,
            size.height - tabButtonHeight,
            flexSize * (i - 1) + activeTabWidth + radius,
            size.height - tabButtonHeight);
      }
    }
    // bottom right corner
    if (selected == tabSize - 1)
      path.lineTo(size.width, radius);
    else {
      path.lineTo(size.width - radius, size.height - tabButtonHeight);
      path.quadraticBezierTo(size.width, size.height - tabButtonHeight,
          size.width, size.height - tabButtonHeight - radius);
      path.lineTo(size.width, radius);
    }

    // drawing the canvas
    if (this.shadow) canvas.drawShadow(path, this.shadowColor, 4.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// page
class AnimatedNavBarPage {
  final String title;
  final Widget pageContent;
  final IconData icon;
  final IconData inactiveIcon;

  const AnimatedNavBarPage(
      {Key key, this.title, this.pageContent, this.icon, this.inactiveIcon});
}
