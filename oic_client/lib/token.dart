part of oic_client;


/**
 * Represents a JWT token that we get from OAM
 */
class Token {

  // base64 encoded reprresentation
  String _base64Value;

  // JSON representation of token
  dynamic _jsonTokenType;
  dynamic _jsonToken;
  List<int> _signature;

  String get encodedTokenValue => _base64Value;

  /**
   * Create a token from a base 64 encoded value
   *
   * The JWT token is a triplet seperated by "."
   * The values are base64 encoded.
   * The first value is the token type (json)
   * The next is the token value (json)
   * The third is the signature hash for the token
   */
  Token.fromBase64(String b64) {
    _base64Value = b64;

    var s = b64.split('.');
    assert( s.length == 3);
    _jsonTokenType = _parse(s[0]);
    _jsonToken = _parse(s[1]);
    _signature = Base64.base64ToList(s[2].codeUnits);
  }

  _parse(String x) {
    var t = Base64.base64ToString(x);
    return json.parse(t);
  }

  /**
   * Todo - not sure we need this. We probably never need to create
   * these tokens ourselves?
   */
  Token.fromJSON(dynamic ttype, dynamic tvalue,List<int> signature) {
    _jsonTokenType = ttype;
    _jsonToken = tvalue;
    _signature = signature;
    // todo.
    //_base64Value = new Base64.defaultCodec().encodeString(j.toString);
  }

  String toString() => "Token($_jsonTokenType $_jsonToken \n base64=$_base64Value)";
}

