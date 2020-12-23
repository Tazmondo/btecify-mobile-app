import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart' as prefs;

import 'package:MobileApp/objects.dart';

const String api = "http://10.0.2.2:5000";
const String api2 =
    "http://195.188.1.165:5000"; // todo: Change to domain name later, or add option to set own ip.
const String apiLogin = api + "/authenticate";
const String apiTestAuth = api + "/testauth";
const String apiPlaylist = api + "/playlist";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      title: "btecify",
      home: PlaylistPage(),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    Key key,
  }) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final Set<Playlist> _playlists = Set();
  bool _loggedIn = false;
  final MyClient _client = MyClient();

  void _loginCallback(bool isLoggedIn) {
    _loggedIn = isLoggedIn;
  }

  void _fetchPlaylists() {
    if (!_loggedIn) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return LoginRoute(_client, _loginCallback);
      }));
    } else {
      // todo: fetch playlists if logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playlists"),
        leading: Icon(Icons.playlist_play_rounded),
      ),
      body: ListView(), // todo: Add functionality
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchPlaylists,
        tooltip: "Fetch Playlists",
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}

class LoginRoute extends StatefulWidget {
  final MyClient _client;
  final _loginCallback;

  LoginRoute(this._client, this._loginCallback);

  static final String _usernameDefault = "Username";

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  bool _loggedIn = false;

  final TextEditingController _usernameController =
      TextEditingController(text: LoginRoute._usernameDefault);

  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    setState(() {
      final String username = _usernameController.value.text;
      final String password = _passwordController.value.text;

      final encoded = jsonEncode({'username': username, 'password': password});
      print(encoded);

      widget._client.post(apiLogin,
          body: encoded,
          headers: {"Content-Type": "application/json"}).then((r) {
        print("Login returned status code: ${r.statusCode}");
        if (r.statusCode == 200) {
          _loggedIn = true;
        } else {
          widget._client.get(apiTestAuth).then((r2) {
            if (r2.statusCode == 200) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "New details incorrect, remaining logged in with old details."),
                ),
              );
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Details incorrect."),
                ),
              );
              _loggedIn = false;
            }
          }, onError: (error) {
            print(error);
          });
        }
      }, onError: (error) {
        print(error);
      });
      widget._loginCallback(_loggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn || true) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Login to btecify"),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 175,
                child: Container(
                  color: Colors.black26,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      // Username entry
                      TextField(
                        autocorrect: false,
                        controller: _usernameController,
                        onTap: _usernameController.clear,
                      ),
                      // Password entry
                      TextField(
                        autocorrect: false,
                        controller: _passwordController,
                        obscureText: true,
                        onTap: _passwordController.clear,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _login(context);
                        },
                        child: Text("LOGIN"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    } else {}
  }
}
