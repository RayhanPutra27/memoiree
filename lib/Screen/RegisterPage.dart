import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoiree/Screen/HomePage.dart';
import 'package:memoiree/Screen/LoginPage.dart';

import '../Utilities/AuthService.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  late final String userid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Widget _fullnameItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            key: Key('tf_name'),
            controller: nameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                labelText: 'Name',
                hintText: 'Enter your name',
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'OpenSans',
                )),
          ),
        )
      ],
    );
  }

  Widget _emailItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('email'),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            key: Key('tf_email'),
            controller: emailController,
            cursorHeight: 25,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                labelText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'OpenSans',
                )),
          ),
        )
      ],
    );
  }

  Widget _usernameItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text('Username'),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            key: Key('tf_username'),
            controller: usernameController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              labelText: 'Username',
              hintText: 'Enter your username',
              hintStyle: TextStyle(
                color: Colors.black45,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   'Password',
        // ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            key: Key('tf_password'),
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Colors.black45,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _phoneItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            key: Key('tf_phone'),
            controller: phoneController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              hintStyle: TextStyle(
                color: Colors.black45,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    padding: EdgeInsets.only(right: 0.0),
  );
  final ButtonStyle raisedButtonStyle = TextButton.styleFrom(
    padding: EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
    ),
    primary: Colors.blueAccent,
  );

  Widget _SignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        key: Key('btn_sign_up'),
        onPressed: () async {
          String name = nameController.text;
          String username = usernameController.text;
          String email = emailController.text;
          String phone = phoneController.text;
          String password = passwordController.text;

          AuthService service = AuthService(FirebaseAuth.instance);
          if (usernameController.text == "" ||
              passwordController.text == "" ||
              nameController.text == "" ||
              emailController.text == "" ||
              phoneController.text == "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Item cannot be empty!"),
            ));
          } else {
            if (passwordController.text.length < 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Password is to short, min 8 characters"),
                ),
              );
              setState(() {
                passwordController.text == "";
              });
            } else {
              final message2 = await service.signUp2(
                  email: email,
                  password: password,
                  username: username,
                  name: name,
                  phoneNumber: phone);

              if (message2!.contains('Success')) {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message2.toString()),
                  ),
                );
              }
            }
          }
        },
        style: raisedButtonStyle,
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _SigninBtn() {
    return GestureDetector(
      key: Key('btn_sign_in'),
      onTap: () => {
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => LoginPage()))
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Container(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 21.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              _emailItem(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _passwordItem(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _fullnameItem(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _usernameItem(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _phoneItem(),
                              _SignupBtn(),
                              _SigninBtn(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
