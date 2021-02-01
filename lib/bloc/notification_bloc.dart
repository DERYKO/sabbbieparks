import 'package:sabbieparks/models/notification.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';
import 'package:sabbieparks/database/database_helper.dart';

class NotificationBloc extends Bloc {
  final dbHelper = DatabaseHelper.instance;
  List<Notify> notifications = [];
  bool isLoading = false;
  var database;
  var notes;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<List> getNotes() async {
    showLoader();
    var result = await dbHelper.getNotes();
    await dbHelper.updateRead();
    for (var i = 0; i < result.toList().length; i++) {
      notifications.add(Notify.fromJson(result.toList()[i]));
    }
    showLoader(false);
  }
  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }
}
