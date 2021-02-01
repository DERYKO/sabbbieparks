import 'package:flutter/material.dart';
import 'package:sabbieparks/bloc/reservation_bloc.dart';
import 'package:sabbieparks/widgets/page.dart';

class ReservationPage extends Page<ReservationBloc>{
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
          'My Reservations',
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
            onPressed: () {},
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
            if (bloc.reservations.isEmpty) {
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(
                      Icons.mood_bad,
                      size: 40.0,
                    ),
                    const SizedBox(height: 16),
                    Text('No previous record found!!'),
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
                        bloc.getReservations();
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }
}