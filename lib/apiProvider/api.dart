import 'package:http/http.dart' as http;

class ApiProvider {
  var urlForTopHeading = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=05f70bf5f3024c42a5c9b8e0c8fa300e");

  /// *================================= TopHeading API ===========================================* ///
  Future<http.Response> topHeading(context) async {
    var response = await http.get(urlForTopHeading);
    return response;
  }

  /// *================================= Everything API ===========================================* ///
  Future<http.Response> everything(String date, context) async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=tesla&from=$date&sortBy=publishedAt&apiKey=05f70bf5f3024c42a5c9b8e0c8fa300e"));

    return response;
  }

  // Future<http.Response> everything(context) async {
  //   var response = await http.get(urlForEverything);
  //   return response;
  // }

  static bool returnResponse(int statusCode) {
    if (statusCode >= 200 && statusCode <= 299) {
      return true;
    } else if (statusCode >= 400 && statusCode <= 499) {
      return false;
    } else if (statusCode >= 500 && statusCode <= 599) {
      return false;
    } else {
      print(
        "apiresponseis=====failedtoload====" + statusCode.toString(),
      );
      return false;
    }
  }
}
