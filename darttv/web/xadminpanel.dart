import 'package:web_ui/web_ui.dart';

import 'package:oic_client/oic.dart';
import 'package:darttv/app.dart';

/**
 * Widget for Admin Panel settings
 */
class AdminPanel extends WebComponent {

  //String serverUrl = "http://demo.oracleads.com:14100/";
  String serverUrl = "http://slc04jlj.us.oracle.com:14100/";
  //String serviceDomain = "MobileServiceDomain";
  String serviceDomain = "DemoDesktopDomain";



  void updateSettings() {
    oicClient.serviceUrl = serverUrl;
    oicClient.serviceDomain = serviceDomain;
  }

  void reset() {
    serverUrl = oicClient.serviceUrl;
    serviceDomain = oicClient.serviceDomain;
  }
}

