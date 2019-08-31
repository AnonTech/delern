import 'package:delern_flutter/flutter/user_messages.dart';
import 'package:delern_flutter/view_models/base/screen_bloc.dart';
import 'package:flutter/material.dart';

class ScreenBlocView extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final ScreenBloc bloc;
  final Widget floatingActionButton;

  const ScreenBlocView(
      {@required this.appBar,
      @required this.body,
      @required this.bloc,
      this.floatingActionButton})
      : assert(appBar != null),
        assert(body != null),
        assert(bloc != null);

  @override
  State<StatefulWidget> createState() => _ScreenBlocViewState();
}

class _ScreenBlocViewState extends State<ScreenBlocView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.bloc.doPop.listen((_) => Navigator.pop(context));
    widget.bloc.doShowError.listen(_showUserMessage);
    widget.bloc.doShowMessage.listen(_showUserMessage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        // Bloc decides what happens when user requested to leave screen
        widget.bloc.onCloseScreen.add(null);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: widget.appBar,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
      ));

  void _showUserMessage(String message) {
    UserMessages.showMessage(_scaffoldKey.currentState, message);
  }

  @mustCallSuper
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
