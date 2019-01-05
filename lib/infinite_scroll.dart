import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class InfiniteScroll extends StatefulWidget {
  @override
  _InfiniteScrollState createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  @override
  void initState() {
    // build initial 10 rows
    _items = List<Data>();
    for (int i = 0; i < 10; i++) {
      _items.add(Data(index: i, loading: false));
    }

    // Scroll controller for list
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (loadmore && _items.last.loading == false) {
        print("Loading more");

        int currentLength = _items.length;

        setState(() {
          _items.add(Data(index: currentLength, loading: true));
        });

        Future.delayed(Duration(seconds: 1), () {
          if (_items.last.loading) {
            setState(() {
              // Remove dummy item
              _items.removeLast();

              // Add 10 more
              for (int i = 0; i < 10; i++) {
                _items.add(Data(index: currentLength + i, loading: false));
              }
            });
          }
        });
      }
    });

    // FAB
    fab = FloatingActionButton(
      child: Icon(Icons.arrow_upward),
      onPressed: () {
        scrollController.animateTo(
          0.0,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      },
    );

    // Scroll Listener for FAB
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if ((scrollMark - scrollController.position.pixels) > 50.0) {
          setState(() {
            reversing = true;
          });
        }
      } else {
        scrollMark = scrollController.position.pixels;
        setState(() {
          reversing = false;
        });
      }
    });

    super.initState();
  }

  double scrollMark;

  // Data to show
  List<Data> _items;

  ScrollController scrollController;

  // Whether we should load more
  bool loadmore = false;

  bool reversing = false;
  FloatingActionButton fab;

  FloatingActionButton getFab() {
    if (reversing && scrollController.position.pixels > 0.0) {
      return fab;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Infinite Scroll Demo"),
        ),
        floatingActionButton: getFab(),
        body: ListView.builder(
          controller: scrollController,
          itemCount: _items.length,
          itemBuilder: (context, i) {
            // we should load more
            if (loadmore == false && i == _items.length - 1) {
              loadmore = true;
              print("Load more = true");
            }

            if (_items[i].loading) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Center(
                    child: Text("Loading..."),
                  ),
                ),
              );
            } else {
              return Card(
                  child: Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                child: Center(
                    child: Text(
                  _items[i].index.toString(),
                  style: TextStyle(fontSize: 40.0),
                )),
              ));
            }
          },
        ));
  }
}

class Data {
  Data({this.index = 0, this.loading});

  int index;
  bool loading;
}