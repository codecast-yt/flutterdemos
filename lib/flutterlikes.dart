import 'package:flutter/material.dart';

class FlutterLikesPage extends StatefulWidget {
  @override
  _FlutterLikesPageState createState() => _FlutterLikesPageState();
}

class _FlutterLikesPageState extends State<FlutterLikesPage> with TickerProviderStateMixin {
  MaterialColor _color;
  List<MaterialColor> _colors;
  List<int> _likes;
  List<FlutterLikes> flutterlikes;
  List<IconButton> buttons;

  TabController tabController;
  TabBarView tabbarview;

  void _incrementCounter() {
    print("INCREMENTING INSIDE MAIN APP: ${tabController.index}");

    setState(() {
      print("FROM: ${_likes[tabController.index]}");
      _likes[tabController.index]++;
      print("TO: ${_likes[tabController.index]}");
    });
  }

  @override
  void initState() {
    super.initState();

    _color = Colors.pink;
    _colors = [
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.grey,
      Colors.amber,
    ];

    _likes = List<int>();

    tabController = TabController(length: _colors.length, vsync: this);

    tabController.addListener(() {
      print ("tab changed");
      setState(() {
        _color = _colors[tabController.index];
      });
    });

    // Build the bottom buttons
    buttons = List<IconButton>();

    for (int i = 0; i < _colors.length; i++) {
      MaterialColor color = _colors[i];
      buttons.add(IconButton(
        icon: Icon(Icons.color_lens, color: color),
        onPressed: () {
          setState(() {
            tabController.index = i;
            _color = color;
          });
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the main screens
    flutterlikes = List<FlutterLikes>();

    for (int i = 0; i < _colors.length; i++) {
      MaterialColor color = _colors[i];
      _likes.add(0);
      flutterlikes.add(FlutterLikes(color: color, likes: _likes[i]));
    }

    tabbarview = TabBarView(
      controller: tabController,
      children: flutterlikes,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: _color,
          title: Text("Flutter Demo"),
        ),
        body: tabbarview,
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              _incrementCounter();
            },
            tooltip: 'Increment',
            child: Icon(Icons.favorite, color: _color)));
  }
}

class FlutterLikes extends StatelessWidget {
  final MaterialColor color;
  final int likes;
  const FlutterLikes({this.color, this.likes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FlutterLogo(
            size: 30.0 + likes,
            colors: color,
          ),
          Divider(),
          Text('You have given Flutter $likes likes!',
              style: TextStyle(fontSize: 22.0, color: color)),
        ],
      ),
    );
  }
}
