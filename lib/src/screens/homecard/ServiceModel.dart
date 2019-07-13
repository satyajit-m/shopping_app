class Service {
  String _serviceName;
  String _serviceUrl;


  Service(this._serviceName,this._serviceUrl,);

  //setter
  set serviceName(String serviceName){
    this._serviceName = serviceName;
  }

  set serviceUrl(String serviceUrl){
    this._serviceUrl = serviceUrl;
  }

  
  String get serviceName => this._serviceName;

  String get serviceUrl => this._serviceUrl;

}