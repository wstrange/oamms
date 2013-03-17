
import 'package:web_ui/web_ui.dart';
import 'package:darttv/app.dart';
import 'package:web_ui/watcher.dart' as watchers;
import 'dart:html';
import 'dart:async';

/*
 * Implements the Login popup widget.
 *
 * The user can choose from a list of registered users
 * If we have a valid long lived token for the user we simply ask them
 * to ente a PIN (not their password).
 * If we have no long lived token we ask for the password but not the PIN.
 */

class LoginPopup extends WebComponent {

  String pin = "1234";

  // user selected for login
  User selectedUser = null;
  String password = "";
  bool validationError = false;
  String validationMessage = "";


  // Called when a user is selected for login
  // this does not mean the user is valid yet
  void selectUser(Event e) {
    // todo: Is there a better way of getting the target?
    var elem = e.target as SelectElement;

    var s = elem.selectedOptions.first.text;
    print("Selected user = $s");

    selectedUser = User.getUserByName(s);
  }

  // true if we should collect and validate a PIN
  bool get collectPIN => (selectedUser != null && selectedUser.loginToken == null );
  // true if we should collect and validate the password
  bool get collectPassword => (selectedUser != null && selectedUser.loginToken == null);

  void checkPassword() {
    print("password = $password");

  }

  void login() {
    print("login called");
    if( collectPassword )
      _validatePassword();
    if( collectPIN )
      _validatePIN();
  }

  void _validatePassword() {
    print("validate password");

  }


  // Called to validates the PIN
  void _validatePIN() {
    print("PIN entered for $selectedUser is  $pin");
    // do something with PIN

    _checkPIN(pin).then( (v) {
      print('PIN status is $v');
      // PIN is BAD? Put up pop up again
      if( v != "OK") {
        validationError = true;
        query('#login_popup').xtag.show();
      }
      else {
        validationError = false;
        query('#login_popup').xtag.hide();
        User.currentUser = selectedUser;
      }
      watchers.dispatch();
    });

    // reset PIN
    pin = "1234";
  }


  Future<String> _checkPIN(String pin) {
    var c = new Completer();

    // simulate time delay of server
    new Timer( new Duration(seconds:1), () {
      if( pin == "1234")
        c.complete("OK");
      else
        c.complete("BAD");
    });

    return c.future;
  }

  // reset the form
  cancel() {
    print("do cancel");
    selectedUser = null;
    password = "";
    validationError = false;
    validationMessage = "";
  }

}

