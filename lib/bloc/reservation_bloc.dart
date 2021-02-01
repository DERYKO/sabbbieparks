import 'package:sabbieparks/models/reservation.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class ReservationBloc extends Bloc {
  bool isLoading = false;
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
  }

  getReservations() async {}
}
