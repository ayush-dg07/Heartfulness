

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shop_app/services/GlobalVariables.dart';

class Storage {
  var _letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";
  GlobalVariables g = GlobalVariables();
  //String key;
  String _getRandomString(int length, String givenString) {
    var rng = Random();
    var string = "";
    for (int i = 0; i < length; i++) {
      string += givenString[rng.nextInt(63)];
    }
    return string;
  }

  //Constructor class
  Storage(){
    //g.userKey = makeKey();
  }

  makeKey(){
    var string1 = _getRandomString(32, _letters);
    var string2 = _getRandomString(32, _letters);
    var string3 = string1 + string2;
    var finalKey = _getRandomString(32, string3);
    return finalKey;
  }


  setCache(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    var key =token;
    print("Setting token: "+ token);
    // return key;

  }

  getCache(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(key) ?? "" ;
    print("Got the token from cache: " + token);
    return token;
  }

  setPhoneNumber(String phone) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("phone", phone);
    print("writing phone number to cache");
  }
  getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String phoneNumber = pref.getString("phone") ?? null;
    print("phoneNumber from cache: " + phoneNumber);
    return phoneNumber;
  }
}















//
// Future<String> setId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var newId = _generateId();
//   await prefs.setString("key for username: ", newId);
//   // HelperFunctions.currentId = newId;
//   return newId;
// }
//
// Future<String> getId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var id = prefs.getString("key for username: ") ?? null;
//   //HelperFunctions.currentId = id;
//   return id;
// }