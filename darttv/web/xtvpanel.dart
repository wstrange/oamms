
import 'package:web_ui/web_ui.dart';
import 'package:darttv/app.dart';
import 'package:web_ui/watcher.dart' as watchers;
import 'dart:html';
import 'dart:async';

class TVPanel extends WebComponent {

  String pin = "1234";
  String selectedUser = "none";
  bool pinCheckFailed = false;


  // Called when a user is selected for login
  // this does not mean the user is valid yet
  void loginSelectUser(Event e) {
    // todo: Is there a better way of getting the target?
    var elem = e.target as SelectElement;
    var i = elem.selectedIndex;

    selectedUser = User.registeredUsers[i];
    //query('#login_modal').xtag.show();
  }

  // Called to validates the PIN
  void validatePIN() {
    print("PIN entered for $selectedUser is  $pin");
    // do something with PIN


    checkPIN(pin).then( (v) {
      print('PIN is $v');
      // PIN is BAD? Put up pop up again
      if( v != "OK") {
        pinCheckFailed = true;
        query('#login_modal').xtag.show();
      }
      else {
        pinCheckFailed = false;
        query('#login_modal').xtag.hide();
        User.setCurrentUser(selectedUser);
      }
      watchers.dispatch();
    });

    // reset PIN
    pin = "1234";
  }


  Future<String> checkPIN(String pin) {
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


}

