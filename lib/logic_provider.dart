import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Logic {
  Logic({
    this.increment,
  });

  final VoidCallback increment;
}

class LogicProviderPage extends StatelessWidget {
  const LogicProviderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LogicProviderPage: build');
    final store = StoreProvider.of<AppState>(context);
    return Provider.value(
      value: Logic(
        increment: () {
          store.dispatch(UpdateCount(store.state.count + 1));
        },
      ),
      child: const LogicProviderPageContent(),
    );
  }
}

class LogicProviderPageContent extends StatelessWidget {
  const LogicProviderPageContent();

  @override
  Widget build(BuildContext context) {
    print('LogicProviderPageContent: build');
    final logic = Provider.of<Logic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel and Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StoreConnector<AppState, int>(
              converter: (store) => store.state.count,
              builder: (context, count) {
                print('LogicProviderPageContent: StoreConnector builder');
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
