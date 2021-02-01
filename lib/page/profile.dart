import 'package:flutter/material.dart';
import 'package:sabbieparks/bloc/home_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class ProfilePage extends Page<HomeBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return bloc.isLoading
              ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[new CircularProgressIndicator()],
                  ),
                )
              : Scaffold(
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
                  'My Profile',
                  style: TextStyle(
                      color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.bold),
                ),
              ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(5.0),
                              child: Form(
                                key: bloc.loginFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        bloc.pickImage();
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40.0),
                                        child: bloc.user.avatar != null
                                            ? Image.network(
                                                appUrl + bloc.user.avatar,
                                                height: 150,
                                              )
                                            : Image.asset(
                                                profile,
                                                height: 150,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(bloc.file == null ? 'No file selected: Tap on image to select a file' : bloc.file.path.split("/").last),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: bloc.titleController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: true,
                                      onFieldSubmitted: (value) {},
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Title is required';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Title",
                                        hintText: "Mr/Mrs",
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: bloc.firstNameController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: true,
                                      onFieldSubmitted: (value) {},
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'First name is required';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "First Name",
                                        hintText: "Sabbie",
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: bloc.lastNameController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: true,
                                      onFieldSubmitted: (value) {},
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Last name is required';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Last Name",
                                        hintText: "Karanja",
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: bloc.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: true,
                                      onFieldSubmitted: (value) {},
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        hintText: "email address",
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ButtonTheme(
                                      minWidth: 200.0,
                                      height: 50.0,
                                      child: RaisedButton(
                                        color: Colors.green,
                                        onPressed: () {
                                          bloc.updateProfile();
                                        },
                                        child: Text(
                                          "Update Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
