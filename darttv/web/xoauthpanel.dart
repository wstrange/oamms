import 'package:web_ui/web_ui.dart';
import 'package:oic_client/oic.dart';
import 'package:darttv/app.dart';
import 'package:web_ui/watcher.dart' as watchers;

import 'package:oauth2/oauth2.dart'

class OAuthPanel extends WebComponent {

  String userName = "user0";
  String password = "Oracle123";


  Token tokenResponse;

  String validResponse;


  void send() {
    oicClient.userTokenRequest(userName,password).then( (Token t) {
      print('Got token $t');
      tokenResponse = t;

      watchers.dispatch();
    }).catchError( (e) {
      print("got an error $e");
    });
  }

  void clear() {}


}

