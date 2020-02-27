class Service {
  String _serviceName;
  String _serviceUrl;
  String _serviceStat;


  Service(this._serviceName,this._serviceUrl,this._serviceStat);

  //setter
  set serviceName(String serviceName){
    this._serviceName = serviceName;
  }

  set serviceUrl(String serviceUrl){
    this._serviceUrl = serviceUrl;
  }
  set serviceStat(String status){
    this._serviceStat = status;
  }


  
  String get serviceName => this._serviceName;

  String get serviceUrl => this._serviceUrl;

  String get serviceStat => this._serviceStat;

}