import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../models/base/events.dart';
import '../../models/base/keyed_list_item.dart';
import '../../view_models/base/keyed_list_event_processor.dart';
import '../../view_models/base/observable_keyed_list.dart';
import 'helper_progress_indicator.dart';

typedef ObservingAnimatedListItemBuilder<T extends KeyedListItem> = Widget
    Function(
  BuildContext context,
  T item,
  Animation<double> animation,
  int index,
);

typedef WidgetBuilder = Widget Function();

class ObservingAnimatedList<T extends KeyedListItem> extends StatefulWidget {
  const ObservingAnimatedList({
    @required this.list,
    @required this.itemBuilder,
    @required this.emptyMessageBuilder,
    Key key,
  })  : assert(itemBuilder != null),
        super(key: key);

  final KeyedListEventProcessor<T, ListEvent<T>> list;
  final ObservingAnimatedListItemBuilder<T> itemBuilder;
  final WidgetBuilder emptyMessageBuilder;

  @override
  ObservingAnimatedListState<T> createState() =>
      ObservingAnimatedListState<T>();
}

class ObservingAnimatedListState<T extends KeyedListItem>
    extends State<ObservingAnimatedList<T>> {
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  StreamSubscription<ListEvent<T>> _listSubscription;

  @override
  void didChangeDependencies() {
    _listSubscription?.cancel();
    _listSubscription = widget.list.events.listen(_processListEvent);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _listSubscription.cancel();
    super.dispose();
  }

  void _processListEvent(ListEvent<T> event) {
    if (_animatedListKey.currentState == null) {
      // The list state is not available because the widget has not been created
      // yet. This may happen when the data is empty and we show an 'empty list'
      // message instead of the list widget.
      setState(() {});
      return;
    }

    switch (event.eventType) {
      case ListEventType.itemAdded:
        _animatedListKey.currentState.insertItem(event.index);
        break;
      case ListEventType.itemRemoved:
        _animatedListKey.currentState.removeItem(
            event.index,
            (context, animation) => widget.itemBuilder(
                context, event.previousValue, animation, event.index));
        break;
      case ListEventType.setAll:
      // Note: number of items must not change here (unless it's the first
      // update; we validate this in proxy_keyed_list.dart).
      case ListEventType.itemChanged:
      case ListEventType.itemMoved:
        setState(() {});
        break;
    }
  }

  Widget _buildItem(
          BuildContext context, int index, Animation<double> animation) =>
      widget.itemBuilder(context, widget.list.value[index], animation, index);

  @override
  Widget build(BuildContext context) {
    if (widget.list == null) {
      return HelperProgressIndicator();
    }

    if (widget.list.value.isEmpty) {
      return widget.emptyMessageBuilder();
    }

    return AnimatedList(
      key: _animatedListKey,
      itemBuilder: _buildItem,
      initialItemCount: widget.list.value.length,
    );
  }
}
