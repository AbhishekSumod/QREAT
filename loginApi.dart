class loginApi {
  String? sId;
  String? UserName;
  String? Email;
  String? createdAt;
  String? Password;
  String? updatedAt;
  int? iV;

  loginApi(
      {this.sId,
      this.UserName,
      this.Email,
      this.Password,
      this.createdAt,
      this.updatedAt,
      this.iV});

  loginApi.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    UserName = json['UserName'];
    Email = json['Email'];
    Password = json['Password'];
    //Image = json['Image'][0]['hostedLargeUrl'] as String;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['UserName'] = this.UserName;
    data['Email'] = this.Email;
    data['Password'] = this.Password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
