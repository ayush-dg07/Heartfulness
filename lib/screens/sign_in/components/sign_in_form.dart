
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/complete_profile/components/complete_profile_form.dart';
import 'package:shop_app/helper/urls.dart';
import 'package:shop_app/services/UserCache.dart';
import 'package:shop_app/services/GlobalVariables.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  GlobalVariables g = GlobalVariables();
  final _formKey = GlobalKey<FormState>();
  //String userName;
  String password;
  bool remember = false;
  final List<String> errors = [];

  Storage cache = Storage();


  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: Colors.lightGreen,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press : () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                String key = await userLogin(g.userName, password);
                Future<dynamic> user = cache.getCache(g.userKey);
                if(user != ""){
                  bool flag = await checkData(g.userName);
                  if(flag == true){
                    print("ready to go to stories page");
                  } else {
                    Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  var completeForm = new CompleteProfileForm();
  bool loginPressed = false;

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => g.userName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        } else if (userNameValidatorRegExp.hasMatch(value)) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        } else if (!userNameValidatorRegExp.hasMatch(value)) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Username",
        hintText: "Enter your username",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  //concerned with only logging the user into the account
  userLogin(username, password) async{

    var body = json.encode(
      {
        "username": username,
        "password": password
      }
    );

    try {
      var response = await http.post(
          Urls.login,
          headers: {"Content-Type": "application/json"},
          body: body);
      var cookieQuery = response.headers["set-cookie"];
      List list = cookieQuery.split(";");
      List cookieBody = list[0].split("=");
      print(cookieBody[1]);

      g.userKey = cookieBody[1];
      // ignore: unrelated_type_equality_checks
      if(response.statusCode == HttpStatus.ok){
        print("Inside signIn block: ${response.statusCode}");
        print("${response.body}");
        try{
          cache.setCache(g.userKey);
          return g.userKey;
        }catch(e){
          print("Error in the try block of userLogin: " + e);
        }
      }else
        print(response.statusCode);
      return response;
    } catch (e) {
      print("Failed post request with exception: $e");
    }


}
  //using getUser endpoint to check if there's phone number in it; if phonenumber then already updated else get those details
  Future<bool> checkData(username) async {
    bool isSet = false;
    var response = await http.get(
      Urls.getUser,
      headers: {"Content-Type": "application/json"}
    );

    var body = json.decode(response.body);
    List rest = body["data"] ?? [];
    print(rest);

    if(rest.contains('phone')){
      //contains number
      isSet = true;
      return isSet;
    } else {
      isSet = false;
      return isSet;
    }
  }

}



