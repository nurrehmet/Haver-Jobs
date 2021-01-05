class JobsApi {
  JobsApi({this.job_provider,this.api_url});
  String job_provider;
  String api_url;
  
  getApi(){
    switch(job_provider){
      case "lokernas":{
        api_url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.blogger.com%2Ffeeds%2F5309385973701982564%2Fposts%2Fdefault&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        return api_url;
      }
      break;
      case "disnakerja":{
        api_url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        return api_url;
      }
    }
  }
}