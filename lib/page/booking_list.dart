import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/bloc/booking_list_bloc.dart';
import 'package:sabbieparks/models/booking.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';

class BookingListPage extends Page<BookingListBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
            size: 32.0,
          ),
        ),
        title: Text(
          'My Bookings',
          style: TextStyle(
              color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 32.0,
            ),
            onPressed: () async {
              Future<DateTime> selectedDate = showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2018),
                lastDate: DateTime(2030),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              );
              await selectedDate.then((DateTime date) {
                if (date != null) {
                  bloc.getBookings(date);
                }
              });
            },
          )
        ],
      ),
      body: StreamBuilder<dynamic>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (bloc.isLoading) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[new CircularProgressIndicator()],
                ),
              );
            }
            if (bloc.bookings.isEmpty) {
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(
                      Icons.mood_bad,
                      size: 40.0,
                    ),
                    const SizedBox(height: 16),
                    Text('No records found!!'),
                    const SizedBox(height: 16),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.refresh),
                          Text(' Refresh'),
                        ],
                      ),
                      onTap: () {
                        bloc.getBookings(DateTime.now());
                      },
                    ),
                  ],
                ),
              );
            }
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildBookingCard(context, index);
                      },
                      itemCount: bloc.bookings.length,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildBookingCard(BuildContext context, int index) {
    Booking booking = bloc.bookings[index];
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blueGrey),
            ),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width) * 0.20,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.network(
                  appUrl + booking.vehicle.vehicleType.icon,
                  height: 100,
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Text(
                    booking.vehicle.model_type,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    booking.vehicle.registration_no,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    booking.vehicle.vehicleType.name,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            DateTime.now().isBefore(DateTime.parse(booking.created_at)
                    .add(new Duration(days: booking.expiry_time)))
                ? Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {},
                            child: Text(
                              "Checkin",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ),
                          CountdownTimer(
                            endTime: DateTime.parse(booking.created_at)
                                .add(new Duration(minutes: booking.expiry_time))
                                .millisecondsSinceEpoch,
                            daysSymbol: " days ",
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            booking.status != false
                                ? Icon(
                                    Icons.verified_user,
                                    size: 30.0,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.cancel,
                                    size: 30.0,
                                    color: Colors.red,
                                  ),
                            SizedBox(
                              width: 6.0,
                            ),
                            booking.status != false
                                ? Text(
                                    'Completed',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.normal),
                                  )
                                : Text(
                                    'Incomplete',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.normal),
                                  )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Parking spot - ${booking.spot.parking_spot_code}',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18.0),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Inconvinience fee - ${booking.inconvenience_fee}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )
                          ],
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
