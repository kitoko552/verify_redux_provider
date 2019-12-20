import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Logic {
  Logic({
    this.increment,
    this.selected,
  });

  final VoidCallback increment;
  final void Function(int) selected;
}

class LogicProviderPage extends StatelessWidget {
  const LogicProviderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Provider.value(
      value: Logic(
        increment: () {
          store.dispatch(UpdateCount(store.state.count + 1));
        },
        selected: (index) {
          store.dispatch(UpdateSelectedIndex(index));
        },
      ),
//      child: const LogicProviderPageContent(),
      child: const LogicProviderScrollPageContent(),
    );
  }
}

class LogicProviderPageContent extends StatelessWidget {
  const LogicProviderPageContent();

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<Logic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel and Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            StoreConnector<AppState, int>(
              distinct: true,
              converter: (store) => store.state.count,
              builder: (context, count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class LogicStreamProviderPage extends StatelessWidget {
  const LogicStreamProviderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return StreamProvider.value(
      initialData: AppState.init(),
      value: store.onChange.distinct(),
      child: Provider.value(
        value: Logic(
          increment: () {
            store.dispatch(UpdateCount(store.state.count + 1));
          },
          selected: (index) {
            store.dispatch(UpdateSelectedIndex(index));
          },
        ),
        child: const LogicStreamProviderPageContent(),
//        child: const LogicStreamProviderScrollPageContent(),
      ),
    );
  }
}

class LogicStreamProviderPageContent extends StatelessWidget {
  const LogicStreamProviderPageContent();

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<Logic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel and Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Selector<AppState, int>(
              selector: (context, state) => state.count,
              builder: (context, count, child) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class LogicProviderScrollPageContent extends StatelessWidget {
  const LogicProviderScrollPageContent();

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<Logic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel and Provider'),
      ),
      body: StoreConnector<AppState, int>(
        distinct: true,
        converter: (store) => store.state.count,
        builder: (context, count) {
          print('count selector');
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            itemCount: count + 1,
            itemBuilder: (context, index) {
              print('ListView');
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
                  child: StoreConnector<AppState, int>(
                    distinct: true,
                    converter: (store) => store.state.selectedIndex,
                    builder: (context, selectedIndex) {
                      print('index selector');
                      return Text(
                        'Header: selected $selectedIndex',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return ListTile(
                  onTap: () {
                    logic.selected(index - 1);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  title: Text(
                    'Item ${index - 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class LogicStreamProviderScrollPageContent extends StatelessWidget {
  const LogicStreamProviderScrollPageContent();

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<Logic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel and Provider'),
      ),
      body: Selector<AppState, int>(
        selector: (context, state) => state.count,
        builder: (context, count, child) {
          print('count selector');
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            itemCount: count + 1,
            itemBuilder: (context, index) {
              print('ListView');
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
                  child: Selector<AppState, int>(
                    selector: (context, state) => state.selectedIndex,
                    builder: (context, selectedIndex, child) {
                      print('index selector');
                      return Text(
                        'Header: selected $selectedIndex',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return ListTile(
                  onTap: () {
                    logic.selected(index - 1);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  title: Text(
                    'Item ${index - 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
