class BaseModel<T> {
  int errorCode;
  String errorMsg;
  T data;

  BaseModel({this.errorCode, this.errorMsg, this.data});

  factory BaseModel.fromJson(Map<String, dynamic> jsonStr) {
    return BaseModel(
        errorCode: jsonStr['errorCode'],
        errorMsg: jsonStr['errorMsg'],
        data: jsonStr['data']);
  }
}

class LoginModel {
  int errorCode;
  String errorMsg;
  LoginData data;

  LoginModel({this.errorCode, this.errorMsg, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> jsonStr) {
    var data = LoginData.fromJson(jsonStr['data']);
    return LoginModel(
        errorCode: jsonStr['errorCode'],
        errorMsg: jsonStr['errorMsg'],
        data: data);
  }
}

class LoginData {
  List<int> chapterTops;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String password;
  String token;
  int type;
  String username;

  LoginData(
      {this.chapterTops,
      this.collectIds,
      this.email,
      this.icon,
      this.id,
      this.password,
      this.token,
      this.type,
      this.username});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      chapterTops: json['chapterTops'].cast<int>(),
      collectIds: json['collectIds'].cast<int>(),
      email: json['email'],
      icon: json['icon'],
      id: json['id'],
      password: json['password'],
      token: json['token'],
      type: json['type'],
      username: json['username'],
    );
  }
}
