
library oic_client;

import 'dart:html';
import 'dart:async';
import 'dart:json' as json;

import 'package:base64/base64.dart';

part 'token.dart';


class OICClient {

  // Service Url where OAM is installed without the trailing /.
  // Example:  http://myhost.com:14100
  String serviceUrl = "http://localhost:14100";

  // Service Domain.Defaults to MobileServiceDomain
  String serviceDomain = "MobileServiceDomain";

  Base64 codec = new Base64.defaultCodec();


  static final _OIC_ENDPOINT = '/oic_rest/rest';


  OICClient(this.serviceUrl,this.serviceDomain) {

  }

  String get oicEndpoint => "$serviceUrl$_OIC_ENDPOINT";


  /**
   * Given [userName] and [password] request a JWT token from OAM.
   *
   * Returns the token in a Future
   */

  Future<Token> userTokenRequest(String userName, String password) {

    var c = new Completer<Token>();
    var url = "$oicEndpoint/jwtauthentication/authenticate";
    var reqString = '''
  {"X-Idaas-Rest-Subject-Type":"USERCREDENTIAL", "X-Idaas-Rest-Subject-Username":"${userName}",
  "X-Idaas-Rest-Subject-Password":"${password}",
  "X-Idaas-Rest-New-Token-Type-To-Create":"USERTOKEN"}
  ''';

    var req = new HttpRequest();
    req.open('POST',url);
    req.setRequestHeader("Content-Type", "application/json");

    req.onLoadEnd.listen((event) {
      if (req.status != 200) {
        c.completeError("Authentication error. Status ${req.status} ${req.responseText}");
      } else {
        //print("response text = ${req.responseText}");
        var pj = json.parse(req.responseText);
        var t = pj['X-Idaas-Rest-Token-Value'];
        var token = new Token.fromBase64(t);
        c.complete(token);
      }
    });

    req.send(reqString);
    return c.future;
  }
    /**
     * Validate a JWT token [t] that we got from the server before
     *
     * If the token is valid the Completer will return with
     * the JWT token response from OAM (as a json triplet
     * string). If not valid the Future error method will be called.
     */

  Future<String> validateToken(Token t) {

    Completer c = new Completer<String>();
    var tv = 'X-Idaas-Rest-Subject-Value=${t.encodedTokenValue}';
    var ttype = 'X-Idaas-Rest-Subject-Type=TOKEN';
    var url = '$oicEndpoint/jwtauthentication/validate?$tv&${ttype}';


    HttpRequest.getString(url).then( (e) {
      c.complete(e);
    }).catchError((AsyncError e) {
      var error = e.error;
      var t = error.currentTarget.responseText;
      print('got a validation error $t');
      c.completeError(t);
    });
    return c.future;
  }

  /**
   * TODO
   */
  Future<String> validateTokenAndPIN(Token t, String pin) {
    var c = new Completer<String>();
    c.complete("OK");

    return c;
  }
}

