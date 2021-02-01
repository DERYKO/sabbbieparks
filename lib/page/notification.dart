import 'package:flutter/material.dart';
import 'package:sabbieparks/bloc/notification_bloc.dart';
import 'package:sabbieparks/models/notification.dart';
import 'package:sabbieparks/widgets/page.dart';

class NotificationPage extends Page<NotificationBloc> {
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
          'Notifications',
          style: TextStyle(
              color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
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
            if (bloc.notifications.isEmpty) {
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(
                      Icons.mood,
                      size: 40.0,
                    ),
                    const SizedBox(height: 16),
                    Text('No new notifications',style: TextStyle(
                      fontSize: 22.0
                    ),),
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
                        bloc.getNotes();
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
                        Notify notify = bloc.notifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: GestureDetector(
                            child: Card(
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: MediaQuery.of(context).size.width * 0.75,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        child: Text('${notify.message}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black))),
                                    Column(
                                      children: <Widget>[
                                        notify.read == 0
                                            ? Icon(
                                          Icons.notifications_off,
                                          size: 26.0,
                                          color: Colors.grey,
                                        )
                                            : Icon(
                                          Icons.notifications,
                                          size: 26.0,
                                          color: Colors.green,
                                        ),
                                        Text('${notify.date}',style: TextStyle(fontSize: 10.0,color: Colors.grey),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: bloc.notifications.length,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
