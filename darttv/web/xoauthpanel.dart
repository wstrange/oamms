import 'package:web_ui/web_ui.dart';
import 'package:oic_client/oic.dart';
import 'package:darttv/app.dart';
import 'package:web_ui/watcher.dart' as watchers;
import 'dart:html';
import 'dart:json' as JSON;

//import 'package:oauth2/oauth2.dart';

import "package:google_oauth2_client/google_oauth2_browser.dart" as oauth;



class OAuthPanel extends WebComponent {

  String userName = "user0";
  String password = "Oracle123";

  static final clientId = '259570338662-d6795keq3grsl3pb7uprjpgp42gvmfrq.apps.googleusercontent.com';

  static final scopes = ["https://www.googleapis.com/auth/plus.me"];

  var auth;

  String responseString = "";

  oauth.Token requestToken;


  String tokenInfo() => requestToken.toString();


  void login() {
    if( auth == null)
      auth = new oauth.GoogleOAuth2(clientId,scopes,tokenLoaded:oauthReady);
    auth.login();
  }



  // callback invoked after consent has been granted and we have our
  // request token
  void oauthReady(oauth.Token token) {

    var testOAuth = new oauth.SimpleOAuth2(token.data);

    requestToken = token;
    var request = new HttpRequest();
    final url = "https://www.googleapis.com/plus/v1/people/me";

    request.onLoadEnd.listen((Event e) {
      if (request.status == 200) {
        var data = JSON.parse(request.responseText);
        responseString = "Logged in as ${data["displayName"]} data=$data";
      } else {
        responseString = "Error ${request.status}: ${request.statusText}";
      }
      watchers.dispatch();
    });

    request.open("GET", url);
    testOAuth.authenticate(request).then((request) => request.send());

    //request.setRequestHeader("Authorization", "${token.type} ${token.data}");
    //request.send();
  }
}

