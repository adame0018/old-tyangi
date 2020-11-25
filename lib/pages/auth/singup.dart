import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Tyangi/pages/home/home.dart';
import 'package:Tyangi/utitlities/firebase.dart';
import 'package:flutter_recaptcha_v2/flutter_recaptcha_v2.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding; 

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  TextEditingController _locationController;
  TextEditingController _contactController;
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();
  String verifyResult = 'Verify the captcha above';
  bool isHuman = false;
  bool isSignUpEnabled = false;
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  bool showPassword = false;
  final focusNode = FocusNode();
  Map<String, FocusNode> focusNodes = {
    "email": FocusNode(),
    "name": FocusNode(),
    "password": FocusNode(),
    "contact": FocusNode()
  };

  

  
  LocationData _locationData;

  
  void setPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    _permissionGranted = await location.hasPermission();
  }

  @override
  void initState(){
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _locationController = TextEditingController();
    _contactController = TextEditingController();
    setPermissions();
    
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: _navigator,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.blue,
                  ),
                Text("Sign In",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          title: Text('',
          style: TextStyle(
            color: Colors.black
          ),),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Stack(
            children: [GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: SingleChildScrollView(
              
            child: Container(
              // decoration: BoxDecoration(
              //   color: Colors.blue
              // ),
              
              padding: EdgeInsets.symmetric(horizontal: 30,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                  _entryFeild("Email", controller: _emailController, focusNode: focusNodes['email']),
                  _entryFeild("Name", controller: _nameController, focusNode: focusNodes['name']),
                  _entryFeild("Contact", controller: _contactController, isNumeric: true, focusNode: focusNodes['contact']),
                  _locationFeild("ZipCode", controller: _locationController),
                  _entryFeild("Password", controller: _passwordController, isPassword: true, focusNode: focusNodes['password']),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        focusNodes.forEach((key, node) {node.unfocus();});
                        recaptchaV2Controller.show();
                      },
                      child: Image.network(
                        "https://www.google.com/recaptcha/about/images/reCAPTCHA-logo@2x.png",
                        width: 50,
                        height: 50,
                        )
                    ),
                  ),
                  
                  Text(
                    verifyResult,
                    style: TextStyle(
                      color: isHuman ? Colors.green : Colors.black
                    ),
                  ),
                  _emailLoginButton(context, isHuman),
                  // FlatButton(
                  //   onPressed: _navigator,
                  //   child: Text(
                  //     "SignIn"
                  //   ))
                ],

              ),
            ),
      ),
          ),
          RecaptchaV2(
            apiKey: "6LfviOUZAAAAAMqP8tTqrIiXMHaqUBTHvDUXZMam",
            apiSecret: "6LfviOUZAAAAAK2GCr3dQJlmN5NGuqV1JdiNoR8k",
            controller: recaptchaV2Controller,
            onVerifiedError: (err){
              print(err);
            },
            onVerifiedSuccessfully: (success) {
              setState(() {
                if (success) {
                  isHuman = true;
                  verifyResult = "You've been verified successfully.";
                } else {
                  isHuman = false;
                  verifyResult = "Failed to verify.";
                }
              });
            },
          ),
          ]
        ),
    );
  }

   _navigator(){

    if(Platform.isAndroid)  
      return Navigator.of(context).pop();
    if(Platform.isIOS)
      return Navigator.of(context).pop();
    
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller, bool isPassword = false, bool isNumeric = false, FocusNode focusNode}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          offset: Offset(1, 2),
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 3.0,
          spreadRadius: 1.0
        )]
      ),
      child: TextField(
        focusNode: focusNode,
        scrollPadding: EdgeInsets.only(bottom: 250),
        controller: controller,
        keyboardType: isNumeric ? TextInputType.phone : TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword && !showPassword,
        decoration: InputDecoration(
          suffixIcon: isPassword ? GestureDetector(
              onTap: (){
                setState(() {
                  
                  showPassword = !showPassword;
                });
              },
              child: Icon(
                Icons.remove_red_eye,
                color: showPassword ? Colors.red : Colors.grey,
              ),
            )
            : SizedBox(),
          hintText: hint,
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.blue[200])),
          border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _locationFeild(String hint,
      {TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          offset: Offset(1, 2),
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 3.0,
          spreadRadius: 1.0
        )]
      ),
      child: TextField(
        scrollPadding: EdgeInsets.only(bottom: 250),
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: _getZipCode,
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.blue,
              ),
          ),
          hintText: hint,
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.blue[200])),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Future<void> _getZipCode () async {
    try{
      if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        showSnackBar("Location services are not enabled!");
        return;
      }
    }
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnackBar("Location access permission not granted!"); 
        return;
      }
    }

    _locationData = await location.getLocation();

    // var results = await Geocoder.local.findAddressesFromCoordinates(
    //   Coordinates(_locationData.latitude, _locationData.longitude)
    //   );
    var results = await geocoding.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
    print("results"+results[0].country);
    if(results[0].postalCode.isNotEmpty && results[0].postalCode != null){

      setState(() {
        _locationController.text = results[0].postalCode;
      });
    } 
    else{
      showSnackBar("Can't get postal code, please enter manually");
    }

    } catch (e){
      showSnackBar("An error occured");
    }
    
  }

  _emailLogin() async {
    if(_emailController.text==null || _emailController.text.isEmpty ||
      _nameController.text==null || _nameController.text.isEmpty ||
      _passwordController.text==null || _passwordController.text.isEmpty ||
      _locationController.text==null || _locationController.text.isEmpty ||
      _contactController.text==null || _contactController.text.isEmpty
    ){
      showSnackBar("Please fill all the fields");
      return;
    }
    
    

    

    setState(() {
      isLoading=true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text
      ).then((value)  {
        setupUser(
          email: _emailController.text, 
          name: _nameController.text, 
          zipCode: _locationController.text,
          contact: _contactController.text
          );
        Navigator.of(context).push(
          Platform.isAndroid ?
          MaterialPageRoute(builder: (_)=> Home())
          :
          CupertinoPageRoute(builder: (_)=>Home())
          );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          isLoading=false;
        });
        showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading=false;
        });
        showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    
    setState(() {
          isLoading=false;
    });
    

    
    
    
  }

  Widget _emailLoginButton(BuildContext context, bool isEnabled) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 35),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: Offset(1,2),
        )],
        borderRadius: BorderRadius.circular(30)
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.blue[300],
        onPressed: isEnabled ? _emailLogin : null,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: !isLoading ?
        Text('Sign Up',
         style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 20
         ),
        
        ) : CircularProgressIndicator(),
      ),
    );
  }

  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'UNDO', onPressed: _scaffoldKey.currentState.hideCurrentSnackBar),
    );
    _scaffoldKey.currentState.showSnackBar(snackBarContent);
  }

}