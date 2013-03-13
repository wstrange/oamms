

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


      // try a bogus token - it should fail
      var token2 = new Token.fromBase64( "${token.encodedTokenValue}JUNK");
      oic.validateToken(token2).then( guardAsync(() {
        fail("Token should not be valid");
      }),
      onError:expectAsync1((e) {
        print('Got expected validation error. Error = $e');
      }));


    })
    ).catchError( (e) => guardAsync( () { expect(false,'should not be reached');}));

  });

}