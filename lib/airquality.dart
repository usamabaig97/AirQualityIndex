class AirQuality{
  String dominentpol;
  Map city;
  Map time ;
  Map data;
  List geo;
  String cityname;

  AirQuality({this.time,this.dominentpol,this.city,this.data,this.geo,this.cityname});
  factory AirQuality.fromjson(Map<String, dynamic> json) {
    return AirQuality(
      dominentpol: json['data']['dominentpol'],
      time:        json['data']['time'],
      city:        json['data']['city'],
      data:        json['data'],
      geo: json['geo'],
      cityname: json['name'],
    );
  }

}