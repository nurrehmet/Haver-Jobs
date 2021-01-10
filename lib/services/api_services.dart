import 'dart:convert';
import 'package:haverjob/services/get_jobs_response.dart';
import 'package:http/http.dart' show Client;

class ApiServices {

  final String url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
  Client client = Client();

  Future<List<GetJobsData>> getJobs() async {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      return getListJobsFromJson(response.body);
    } else {
      return null;
    }
  }
}