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
    @required this.selectedIndex,
  });

  AppState.init()
      : this(
          count: 0,
          selectedIndex: 0,
        );

  final int count;
  final int selectedIndex;

  AppState copyWith({
    int count,
    int selectedIndex,
  }) {
    return AppState(
      count: count ?? this.count,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          count == other.count &&
          selectedIndex == other.selectedIndex;

  @override
  int get hashCode => count.hashCode ^ selectedIndex.hashCode;
}

final Reducer<AppState> reducer = combineReducers<AppState>([
  TypedReducer(countReducer),
  TypedReducer(indexReducer),
]);

AppState countReducer(AppState state, UpdateCount action) {
  return state.copyWith(count: action.count);
}

AppState indexReducer(AppState state, UpdateSelectedIndex action) {
  return state.copyWith(selectedIndex: action.index);
}

class UpdateCount {
  UpdateCount(this.count);
  final int count;
}

class UpdateSelectedIndex {
  UpdateSelectedIndex(this.index);
  final int index;
}
