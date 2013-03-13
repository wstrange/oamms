

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
//import 'package:unittest/interactive_html_config.dart';

import 'package:oic_client/oic.dart';


main() {

  var oam = "http://demo.oracleads.com:14100";
  var domain = "Default";

  //useInteractiveHtmlConfiguration();

  useHtmlEnhancedConfiguration() ;

  test('OIC AuthN test', () {

    var oic = new OICClient(oam,domain);

    oic.userTokenRequest("user0", "Oracle123").then( expectAsync1((Token token) {
      print('Got token $token');

      // now we have the token lets  validate
      oic.validateToken(token).then( expectAsync1((s) {
        print("Validated token OK $s");
      }));

      // try to validate a bad token
      token.encodedTokenValue = "BOGUSVALUE";
      oic.validateToken(token).then( protectAsync1((e) {
        fail('should not be reached');
      }),
      onError:expectAsync1((e) {
        print('Got expected validation error. Error = $e');
      }));


    })
    ).catchError( (e) => guardAsync( () { expect(false,'should not be reached');}));

  });

}