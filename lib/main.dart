import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'logic_provider.dart';

void main() => runApp(StoreProviderApp());

class StoreProviderApp extends StatelessWidget {
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
//        child: const OptimizeViewModelPage(),
//        child: const ViewModelProviderPage(),
//        child: const ViewModelStreamProviderPage(),
//        child: const LogicProviderPage(),
        child: const LogicStreamProviderPage(),
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
