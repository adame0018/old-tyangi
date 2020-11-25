import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget entryField(String hint,
      {TextEditingController controller, bool isPassword = false, bool isNumeric = false, 
      Icon prefixIcon, FocusNode focusNode, FontWeight fontWeight}) {
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
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: prefixIcon ?? null,
          hintText: hint,
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: Colors.blue[200])),
          border: InputBorder.none,
        
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
        ),
      ),
    );
  }

  Widget dropDown({String hint, TextEditingController controller, List<dynamic> items,
   void Function(dynamic) onChanged, var value, FocusNode focusNode}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          focusNode: focusNode,
          isExpanded: true,
          disabledHint: Text("Sub Category"),
          value: value,
          items: items.isNotEmpty ? items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
              );
            }).toList() : null,
            hint: Text(hint),
            onChanged: onChanged,
        ),
      ),
    );
  }

  Widget richEntryField(String hint,
      {TextEditingController controller, bool isPassword = false, bool isNumeric = false, FocusNode focusNode,
      int minLines, int maxLines}) {
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
      child: CupertinoTextField(
        focusNode: focusNode,
        decoration: BoxDecoration(
          
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        placeholder: "Description",
        placeholderStyle: TextStyle(
          fontSize: 18,
          color: CupertinoColors.placeholderText
        ),
        minLines: minLines,
        maxLines: maxLines,
        scrollPadding: EdgeInsets.only(bottom: 250),
        controller: controller,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        // decoration: BoxDecoration(
        //   hintText: hint,
        //   // border: OutlineInputBorder(
        //   //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
        //   //     borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))),
        //   // focusedBorder: OutlineInputBorder(
        //   //     borderRadius: BorderRadius.all(Radius.circular(12.0)),
        //   //     borderSide: BorderSide(color: Colors.blue[200])),
        //   border: InputBorder.none,
        
        //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // ),
      ),
    );
  }

  Widget submitButton({BuildContext context, String hint, Function() onSubmit, bool isLoading=false}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 30),
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
        onPressed: onSubmit,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: !isLoading ?
        Text(hint,
         style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 20
         ),
        
        ) : CircularProgressIndicator(),
      ),
    );
  }