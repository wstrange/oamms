/*
 * top level App class
 *
 * not sure if this is canonical web_ui or not
 * This holds our top level (global) context.
 *
 */

library app;

import 'package:oic_client/oic.dart';


var oicClient = new OICClient("http://slc04jlj.us.oracle.com:14100/", "DemoDesktopDomain");


//var oicClient = new OICClient("http://demo.oracleads.com:14100", "MobileServiceDomain");

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
  Token loginToken;

  // Create a new demo user
  User(String n, [bool isAdult = true]) {
    login = '$n@example.com';
    name = _capitalize(n);
    if( isAdult )
      favoriteChannels.addAll(adultChannels);
    else
      favoriteChannels.addAll(kidChannels);
    favoriteChannels.addAll(other);
  }

  // "database" of all the users we know about
  static final userMap = new Map<String,User> ();

  // built in users to create for demo
  static final registeredUsers = ["family","mom", "dad", "sally", "johhny"];

  static createDemoUsers() {
   registeredUsers.forEach(  (s) {
     var adult = (s == "mom" || s == "dad");
     var u = new User(s,adult);
     userMap[u.login] = u;
   });
   currentUser = getUserByLogin("family@example.com");
  }

  String _capitalize(String s) => "${s.substring(0,1).toUpperCase()}${s.substring(1)}";

  String toString() => "User($login,$name)";

  // static methods for the user "database"
  static User getUserByLogin(String login) => userMap[login];
  static User getUserByName(String name) =>
      userMap.values.firstMatching( (u) => (u.name == name));


  static User _currentUser;
  static void set currentUser(User u) { print("Setting current user $u");_currentUser =u;}
  static User get currentUser => _currentUser;

  static Iterable<User> get allUsers => userMap.values;

}


//var users = registeredUsers.forEach( (u) )