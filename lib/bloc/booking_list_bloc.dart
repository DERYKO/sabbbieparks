import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/models/booking.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class BookingListBloc extends Bloc {
  bool isLoading = false;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    getBookings(DateTime.now());
  }

  getBookings(DateTime dateTime) async {
    showLoader();
    try{
      bookings = [];
      var response = await api.getBookings(dateTime);
      print(response);
      for(var i = 0; i < response.data.length; i++){
        bookings.add(Booking.fromJson(response.data[i]));
      }
      showLoader(false);
    }catch(e){
     showLoader(false);
    }
  }
  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }
}
