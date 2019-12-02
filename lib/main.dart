import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

// this class contains all the state used in the sample app
class CounterState with ChangeNotifier {
  // the actual state is private (hence the leading "_" in the var name)
  int _value = 0;
  // this allows us read-only access to the state
  // - thus ensuring the only modification of the state is via whatever methods
  //   we expose (in this case that is "increment" only)
  int get value => _value;

  // how we modify the state and notify consumers (e.g. the App UI)
  void increment() {
    _value += 1;
    // this call notifies the consumer of this data that something has been
    //  updated - thus avoiding any need for setState()
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // here's where we insert our Provider into the Widget tree. This
      //  MyHomePage widget, and any widget created below that, can access this
      //  instance of CounterState by simply calling
      //  "Provider.of<CounterState>(context)" in it's build method.
      home: ChangeNotifierProvider(
        create: (context) => CounterState(),
        child: MyHomePage(title: 'Stateless Flutter Demo'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is (now) stateless,
  //  meaning that it may define "final" vars only. It may still be used for
  //  a dynamic (changing) UI if it is passed dynamic data from outside and
  //  the build method is re-run (which is precisely what happens in this App)
  //
  // Any data that can change over time can be defined in an outer scope (i.e.
  //  higher up the tree)

  final String title;

  @override
  Widget build(BuildContext context) {
    //
    // This method is rerun every time notifyListeners is called from the
    //  Provider, as is done inside the _incrementCounter method below.
    //
    // for Stateless Widgets, the build context is accessible from within the
    //  "build" method only, and we need that context to find the Provider
    //  state higher up in the tree - so much of the logic moves into "build"
    //
    // "listen: true" is the default already, but is included here in case
    //  you're wondering how to control that. In case you wanted to fetch the
    //  value just once (ignoring subsequent updates), you could use
    //  "listen: false" and that would avoid "build" being re-run needlessly
    final counterState = Provider.of<CounterState>(context, listen: true);
    //
    // some convenience definitions to replace the State instance properties
    //  from the original sample app. Note that since these are defined inside
    //  the build method, they're no longer instance properties and so there's
    //  no longer any value in prefixing them with "_" (except that I do so to
    //  minimize the code-changes in the Scaffold below)
    final _counter = counterState.value;
    void _incrementCounter() => counterState.increment();
    //
    // none of the code below here has changed from the original app (although
    //  the comments have been updated where appropriate)
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the title instance property, to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
