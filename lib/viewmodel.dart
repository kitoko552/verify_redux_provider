import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'main.dart';

class ViewModel {
  ViewModel({
    this.state,
    this.increment,
  });

  final AppState state;
  final VoidCallback increment;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewModel &&
          runtimeType == other.runtimeType &&
          state == other.state;

  @override
  int get hashCode => state.hashCode;
}

class ViewModelPage extends StatelessWidget {
  const ViewModelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      converter: (store) {
        return ViewModel(
          state: store.state,
          increment: () {
            store.dispatch(UpdateCount(store.state.count + 1));
          },
        );
      },
      builder: (context, viewModel) {
        return ViewModelPageContent(viewModel);
      },
    );
  }
}

class ViewModelPageContent extends StatelessWidget {
  const ViewModelPageContent(this.viewModel);

  final ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '${viewModel.state.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class OptimizeViewModelPage extends StatelessWidget {
  const OptimizeViewModelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel Optimize'),
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
      floatingActionButton: StoreConnector<AppState, VoidCallback>(
        ignoreChange: (state) => true,
        converter: (store) => () {
          store.dispatch(UpdateCount(store.state.count + 1));
        },
        builder: (context, increment) {
          return FloatingActionButton(
            onPressed: increment,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
