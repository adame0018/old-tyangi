import 'dart:async';
import 'dart:io' show Platform;
import 'package:Tyangi/pages/addListing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tyangi/pages/auth/singup.dart';
import 'package:Tyangi/pages/home/home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('',
          style: TextStyle(
            color: Colors.black
          ),),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
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
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Login to Continue",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 50),
                _entryFeild("Email", controller: _emailController),
                
                _entryFeild("Password", controller: _passwordController, isPassword: true),
                
                _emailLoginButton(context),
    
                    Text(
                      "Don't have an Account?"
                    ),
                    FlatButton(
                      onPressed: _navigator,
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      )),
                  
      
              ],

            ),
          ),
      ),
        ),
    );
  }

  _navigator(){

    if(Platform.isAndroid)  
      return Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUp()));
    if(Platform.isIOS)
      return Navigator.of(context).push(CupertinoPageRoute(builder: (_) => SignUp()));
    
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller, bool isPassword = false, bool isNumeric = false}) {
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
        keyboardType: isNumeric ? TextInputType.phone : TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  setLoading(){
    setState(() {
      isLoading = false;
    });
  }

  _emailLogin() async {

    if(_emailController.text == null || _emailController.text.isEmpty ||
        _passwordController.text == null || _passwordController.text.isEmpty){
          showSnackBar("Please Fill all the fields");
        }
    
    setState(() {
      isLoading=true;
    });

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text
        ).then((value) {
          if(mounted){

            Navigator.of(context).push(
            Platform.isAndroid ?
            MaterialPageRoute(builder: (_)=> Home())
            :
            CupertinoPageRoute(builder: (_)=>Home())
            );
          }
        });
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
        showSnackBar('No user found for that email.');
        setState(() {
          isLoading=false;
        });
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong password provided for that user.');
        setState(() {
          isLoading=false;
        });
      }
    } 
    if(mounted){

      setState(() {
        isLoading = false;
      });
    }
    
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 3.0,
          spreadRadius: 1.0,
          offset: Offset(1,2),
        )],
        borderRadius: BorderRadius.circular(30)
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 35),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.blue[300],
        onPressed: _emailLogin,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: !isLoading ?
        Text('Log In',
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