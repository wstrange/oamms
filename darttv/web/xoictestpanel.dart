import 'package:web_ui/web_ui.dart';
import 'package:oic_client/oic.dart';

class OICTestPanel extends WebComponent {

  String userName = "user0";
  String password = "Oracle123";


  String tokenResponse;

  String validResponse;


  void send() {
    print('send token');
  }

  void clear() {}


}

