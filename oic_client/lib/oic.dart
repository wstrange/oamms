
library oic_client;

import 'dart:html';
import 'dart:async';
import 'dart:json' as json;

import 'package:base64/base64.dart'; // needed by Token. todo: make token a lib

part 'token.dart';


class OICClient {

  // Service Url where OAM is installed without the trailing /.
  // Example:  http://myhost.com:14100
  String serviceUrl = "http://localhost:14100";

  // Service Domain.Defaults to MobileServiceDomain
  String serviceDomain = "MobileServiceDomain";

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
    req.setRequestHeader("X-IDAAS-SERVICEDOMAIN", serviceDomain);

    req.onLoadEnd.listen((event) {
      if (req.status != 200) {
        print("Auth error ${req.responseText}");
        c.completeError("Authentication error. Status ${req.status} ${req.responseText}");
      } else {
        //print("response text = ${req.responseText}");
        c.complete(_parseResponse(req.responseText));
      }
    });

    req.send(reqString);
    return c.future;
  }

  Token _parseResponse(String r) {
    var pj = json.parse(r);
    var t = pj['X-Idaas-Rest-Token-Value'];
    return new Token.fromBase64(t);
  }

  /**
   * Validate a JWT token [t] that we got from the server before
   *
   * If the token is valid the Completer will return with
   * the JWT token response from OAM (as a json triplet
   * string). If not valid the Future error method will be called.
   */

  Future<Token> validateToken(Token t) {

    Completer c = new Completer<Token>();
    var tv = 'X-Idaas-Rest-Subject-Value=${t.encodedTokenValue}';
    var ttype = 'X-Idaas-Rest-Subject-Type=TOKEN';
    var url = '$oicEndpoint/jwtauthentication/validate?$tv&${ttype}';


    var req = new HttpRequest();

    //req.setRequestHeader("Content-Type", "application/json");

    req.open('GET',url);
    req.setRequestHeader("X-IDAAS-SERVICEDOMAIN", serviceDomain);


    req.onReadyStateChange.listen((e) {
        //print("event is ${req.readyState} req= ${req.responseText}");
        if( req.readyState == HttpRequest.DONE ) {
            if(req.status == 200 || req.status == 0) {
              c.complete(_parseResponse(req.responseText));
            }
        else {
          c.completeError("Error ${req.status} ${req.responseText}");
        }
      }
    },
    onError: (AsyncError e) {
      c.completeError("Error ${e.error}");
    });
    req.send();
    return c.future;
  }

  /**
   * TODO
   */
  Future<Token> validateTokenAndPIN(Token t, String pin) {
    var c = new Completer<Token>();
    c.complete("OK");

    return c;
  }
}

