import 'package:web_ui/web_ui.dart';

import 'package:oic_client/oic.dart';

/**
 * Widget for Admin Panel settings
 */
class AdminPanel extends WebComponent {

  OICClient oic;

  String serverUrl = "http://localhost:14100/oic_oic";
  String serviceDomain = "MobileServiceDomain";


  void updateSettings() {
    oic.serviceUrl = serverUrl;
    oic.serviceDomain = serviceDomain;
  }

  void reset() {
    serverUrl = oic.serviceUrl;
    serviceDomain = oic.serviceDomain;
  }
}

