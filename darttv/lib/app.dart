/*
 * top level App class
 *
 * not sure if this is canonical web_ui or not
 * This holds our top level (global) context.
 *
 */

library app;

import 'package:oic_client/oic.dart';


var oicClient = new OICClient("http://demo.oracleads.com:14100", "MobileServiceDomain");


var adultChannels = ['Pay Per View', 'Golf Channel', 'ShowTime', 'HBO'];
var kidChannels = ['Disney', 'Treehouse', 'PBS'];
var other = ["CBC", 'CTV', 'ABC'];



/**
 * Sample user class.
 *
 *
 */
class User {


  String name;
  String login;
  bool isAdult;
  List<String> favoriteChannels = new List<String>();

  // The JWT Token issued by OAM for this user
  Token jwtToken;

  User(String n, [bool isAdult = true]) {
    login = n;
    name = _capitalize(n);
    if( isAdult )
      favoriteChannels.addAll(adultChannels);
    else
      favoriteChannels.addAll(kidChannels);
    favoriteChannels.addAll(other);
  }


  static final userMap = new Map<String,User> ();


  // built in users
  static final registeredUsers = ["family","mom", "dad", "sally", "frank"];
  static createDemoUsers() {
   registeredUsers.forEach(  (s) {
     var adult = (s == "mom" || s == "dad");
     var u = new User(s,adult);
     userMap[u.login] = u;
   });
  }

  String _capitalize(String s) => "${s.substring(0,1).toUpperCase()}${s.substring(1)}";

  static User getUser(String name) => userMap[name];

  static User currentUser = null;

  // do whatever is needed to login user. They have authenticated at this point
  static void setCurrentUser(String login) {
    currentUser = getUser(login);
  }

}


//var users = registeredUsers.forEach( (u) )