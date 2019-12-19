import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoreProvider(
        store: Store<AppState>(
          reducer,
          initialState: AppState.init(),
        ),
//        child: const ViewModelPage(),
        child: const OptimizeViewModelPage(),
//        child: const ViewModelProviderPage(),
      ),
    );
  }
}

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
    print('ViewModelPage: build');
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
        print('ViewModelPage: StoreConnector builder');
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
    print('ViewModelPageContent: build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OptimizeViewModelPage extends StatelessWidget {
  const OptimizeViewModelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('OptimizeViewModelPage: build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Redux with ViewModel Optimize'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StoreConnector<AppState, int>(
              distinct: true,
              converter: (store) => store.state.count,
              builder: (context, count) {
                print('OptimizeViewModelPage: StoreConnector builder Text');
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
          print(
              'OptimizeViewModelPage: StoreConnector builder FloatingActionButton');
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
    final viewModel = Provider.of<ViewModel>(context);
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

@immutable
class AppState {
  AppState({
    @required this.count,
  });

  AppState.init()
      : this(
          count: 0,
        );

  final int count;

  AppState copyWith({
    int count,
  }) {
    return AppState(
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          count == other.count;

  @override
  int get hashCode => count.hashCode;
}

final Reducer<AppState> reducer = combineReducers<AppState>([
  TypedReducer(countReducer),
]);

AppState countReducer(AppState state, UpdateCount action) {
  return state.copyWith(count: action.count);
}

class UpdateCount {
  UpdateCount(this.count);
  final int count;
}
