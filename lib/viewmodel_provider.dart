import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'viewmodel.dart';

class ViewModelProviderPage extends StatelessWidget {
  const ViewModelProviderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ViewModelProviderPage: build');
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
        print('ViewModelProviderPage: StoreConnector builder');
        return Provider.value(
          value: viewModel,
          child: const ViewModelProviderPageContent(),
        );
      },
    );
  }
}

class ViewModelProviderPageContent extends StatelessWidget {
  const ViewModelProviderPageContent();

  @override
  Widget build(BuildContext context) {
    print('ViewModelProviderPageContent: build');
    final viewModel = Provider.of<ViewModel>(context, listen: false);
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
            Selector<ViewModel, int>(
              selector: (context, viewModel) => viewModel.state.count,
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
        onPressed: viewModel.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
