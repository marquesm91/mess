import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const GITHUB_CLIENT_ID = "92bb26bc5992be389e45";
const GITHUB_CLIENT_SECRET = "4f419a1619420da3847a5921553403228e1d4c9a";

class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest({this.clientId, this.clientSecret, this.code});

  dynamic toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
      };
}

class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  GitHubLoginResponse({this.accessToken, this.tokenType, this.scope});

  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      GitHubLoginResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        scope: json["scope"],
      );
}

void signInWithGithub() async {
  const String url = "https://github.com/login/oauth/authorize" +
      "?client_id=" +
      GITHUB_CLIENT_ID +
      "&scope=read:user%20user:email";

  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    print("CANNOT LAUNCH THIS URL!");
  }
}

Future<FirebaseUser> loginWithGitHub(String code) async {
  final response = await http.post(
    "https://github.com/login/oauth/access_token",
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode(GitHubLoginRequest(
      clientId: GITHUB_CLIENT_ID,
      clientSecret: GITHUB_CLIENT_SECRET,
      code: code,
    )),
  );

  GitHubLoginResponse loginResponse =
      GitHubLoginResponse.fromJson(json.decode(response.body));

  final AuthCredential credential = GithubAuthProvider.getCredential(
    token: loginResponse.accessToken,
  );

  final FirebaseUser user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  return user;
}
