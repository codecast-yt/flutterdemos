import 'package:flutter/material.dart';
import 'dart:math';


class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  PageController pageController;
  int numberOfPages = 6;
  double viewportFraction = 0.75;

  @override
  void initState() {
    pageController = PageController(viewportFraction: viewportFraction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MaterialColor> colors = [
      Colors.amber,
      Colors.red,
      Colors.green,
      Colors.lightBlue,
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: numberOfPages,
            itemBuilder: (context, index) => new ScalablePage(
                  minScale: 0.7,
                  pageController: pageController,
                  index: index,
                  child: RotatablePage(
                    index: index,
                    pageController: pageController,
                    maxRotate: 10.0,
                    child: Material(
                      color: colors[index % colors.length],
                      child: Container(
                        child: Center(
                          child: Text(
                            "Page ${index + 1}",
                            style: TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_rewind),
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () {
                pageController.animateToPage(
                  numberOfPages,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

class RotatablePage extends StatefulWidget {
  RotatablePage({
    @required this.child,
    @required this.pageController,
    @required this.index,
    this.maxRotate = 0.0,
  });

  final Widget child;
  final double maxRotate;
  final PageController pageController;
  final int index;

  @override
  _RotatablePageState createState() => _RotatablePageState();
}

class _RotatablePageState extends State<RotatablePage> {
  double rotate = 0.0;
  double diff = 0.0;

  @override
  void initState() {
    widget.pageController.addListener(_setRotate);

    if (widget.index == widget.pageController.initialPage) {
      rotate = 0.0;
    } else {
      rotate = widget.maxRotate;
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_setRotate);
    super.dispose();
  }

  _setRotate() {
    setState(() {
      _updateRotate();
    });
  }

  _updateRotate() {
    if (widget.pageController?.page != null) {
      diff = (widget.pageController.page - widget.index).clamp(-1.0, 1.0);
    } else {
      diff = 1.0;
    }

    if (diff < 0) {
      rotate = Curves.ease.transform(-diff) * widget.maxRotate;
    } else {
      rotate = -Curves.ease.transform(diff) * widget.maxRotate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate * pi / 180,
      child: widget.child,
    );
  }
}

class ScalablePage extends StatefulWidget {
  ScalablePage({
    @required this.child,
    @required this.pageController,
    @required this.index,
    this.minScale = 0.7,
  });

  final Widget child;
  final double minScale;
  final PageController pageController;
  final int index;

  @override
  _ScalablePageState createState() => _ScalablePageState();
}

class _ScalablePageState extends State<ScalablePage> {
  double scale = 1.0;
  double diff = 0.0;

  @override
  void initState() {
    widget.pageController.addListener(_setScale);

    if (widget.index == widget.pageController.initialPage) {
      scale = 1.0;
    } else {
      scale = widget.minScale;
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_setScale);
    super.dispose();
  }

  _setScale() {
    setState(() {
      _updateScale();
    });
  }

  _updateScale() {
    if (widget.pageController?.page != null) {
      diff = (widget.pageController.page - widget.index).clamp(-1.0, 1.0);
    } else {
      diff = 1.0;
    }

    double absDiff = diff < 0 ? diff * -1 : diff;

    double _scale = 1.0 - (absDiff);

    scale = widget.minScale +
        (Curves.ease.transform(_scale) * (1.0 - widget.minScale));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Stack(
        children: <Widget>[
          Material(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}