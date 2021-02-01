part of 'bloc_provider.dart';

class Bloc {
  BuildContext context;
  StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();
  Stream<dynamic> get stream => _controller.stream;
  ProgressDialog progressDialog;
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;
  bool isLoading = false;
  bool hasError = false;
  String message = "";

  void dispose() {}
  void initState() {
    progressDialog = ProgressDialog(context);
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    print('Connection status changed');
    isOffline = !hasConnection;
    notifyChanges();
  }

  void showOfflineNotification() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Text(
                    'Ooops !!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.cloud_off,
                      size: 60,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Text('Looks like you are offline.')
                ],
              ),
            ),
          );
        });
  }

  void notifyChanges([callback]) {
    if (callback != null) {
      callback();
    }
    _controller.sink.add(0);
  }

  Future<dynamic> navigate<T extends Bloc>(
      {@required Page page, @required T bloc}) async {
    return await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
      return BlocProvider(child: page, bloc: bloc);
    }));
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  pop([results]) {
    if (results == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(results);
    }
  }

  Future<Null> alert(title, body, {onOk = null}) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              child: Text(body),
            ),
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onOk != null) {
                    onOk();
                  }
                },
              ),
            ],
          );
        });
  }

  void popAndNavigate<T extends Bloc>(
      {@required Page page, @required T bloc}) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return BlocProvider(child: page, bloc: bloc);
    }));
  }
}