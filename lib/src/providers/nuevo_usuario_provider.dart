import 'dart:convert';
import 'package:form_val/src/prefs/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final _apiToken = 'AIzaSyAFAw4hp88FjaW1dyR3U5sbHoCAWS8j69Q';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String pss) async {
    final authData = {
      'email': email,
      'password': pss,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiToken',
        body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(String email, String pss) async {
    final authData = {
      'email': email,
      'password': pss,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiToken',
        body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
