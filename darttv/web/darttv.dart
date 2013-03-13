import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:widget/widget.dart';

import 'package:oic_client/oic.dart';


// Top Level App entry point

/*
AdminPanel adminPanel() {
  var x = document.query('#adminPanel');
  if( x != null ) return x.xtag as AdminPanel;
  return null;
}

String connectString() {
  var x = adminPanel();
  return (x == null ? "No connection" : x.serverUrl);
}
U*/

var oic = new OICClient("http://localhost:14100", "MobileServiceDomain");

// Learn about the Web UI package by visiting
// http://www.dartlang.org/articles/dart-web-components/
void main() {
  //useShadowDom = true; // to enable use of experimental Shadow DOM in the browser
}
