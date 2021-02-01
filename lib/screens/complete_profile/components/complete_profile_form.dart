import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/urls.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/services/UserCache.dart';
import 'package:shop_app/screens/otp/components/otp_core.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:shop_app/services/GlobalVariables.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  GlobalVariables g = GlobalVariables();
  final _formKey = GlobalKey<FormState>();
  final cache = Storage();
  final List<String> errors = [];

  //CompleteProfileForm userName;
  String firstName;
  String lastName;
  String profession;
  String age;
  String phone;
  String address;
  String city;
  String country;
  String pinCode;

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

  Future<http.Response> userDetails(userName, firstName, lastName, profession, age, phoneNumber, address, city, country, pinCode) async {
    var body = json.encode({
      "userName": userName,
      "phoneNumber": phoneNumber,
      "userData": {
        "firstName": firstName,
        "lastName": lastName,
        "profession": profession,
        "age": age,
        "address": {
          "line1": address,
          "city": city,
          "country": country,
          "pinCode": pinCode
        }
      }
    });


    var session = cache.getCache(g.userKey);
    var response = await http.post(Urls.update,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print("${response.statusCode}");
    print(json.decode(response.body).toString());

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildProfessionFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildAgeFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCityFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildCountryFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          buildPinCodeFormField(),
          SizedBox(height: getProportionateScreenHeight(25)),
          DefaultButton(
            text: "Submit details",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                await cache.setPhoneNumber(phone);
                otpSend(context, phone);
                userDetails(
                    g.userName,
                    firstName,
                    lastName,
                    profession,
                    age,
                    phone,
                    address,
                    city,
                    country,
                    pinCode
                );
                Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      onSaved: (newValue) => city = newValue,
      decoration: InputDecoration(
        labelText: "City",
        hintText: "Enter your City",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      onSaved: (newValue) => country = newValue,
      decoration: InputDecoration(
        labelText: "Country",
        hintText: "Enter your Country",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPinCodeFormField() {
    return TextFormField(
      onSaved: (newValue) => pinCode = newValue,
      decoration: InputDecoration(
        labelText: "Pin-Code",
        hintText: "Enter your Pin-Code",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildAgeFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => age = newValue,
      decoration: InputDecoration(
        labelText: "Age",
        hintText: "Enter your age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildProfessionFormField() {
    return TextFormField(
      onSaved: (newValue) => profession = newValue,
      decoration: InputDecoration(
        labelText: "Profession",
        hintText: "Enter your profession",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


}
