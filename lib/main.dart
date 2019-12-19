import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:simple_logger/simple_logger.dart';

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
        child: const ViewModelPage(),
//        child: const OptimizeViewModelPage(),
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
    logger.severe('ViewModelPage: build');
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
        logger.severe('ViewModelPage: StoreConnector builder');
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
      },
    );
  }
}

class OptimizeViewModelPage extends StatelessWidget {
  const OptimizeViewModelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.severe('OptimizeViewModelPage: build');
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
                logger.severe(
                    'OptimizeViewModelPage: StoreConnector builder Text');
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
          logger.severe(
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

final logger = SimpleLogger()
  ..setLevel(
    kReleaseMode ? Level.OFF : Level.INFO, // リリースビルド時はログを吐かない
    includeCallerInfo: !kReleaseMode,
  )
  ..mode = LoggerMode.print;
