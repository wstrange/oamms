import 'package:web_ui/web_ui.dart';
import 'package:oic_client/oic.dart';
import 'package:darttv/app.dart';

class OICTestPanel extends WebComponent {

  String userName = "user0";
  String password = "Oracle123";


  String tokenResponse;

  String validResponse;


  void send() {
    print('request token');

    oicClient.userTokenRequest(userName,password).then( (Token t) {
      print('Got token $t');
    }).catchError( (e) {
      print("got an error $e");
    });
  }

  void clear() {}


}

