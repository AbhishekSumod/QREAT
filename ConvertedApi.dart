class ConvertedApi {
  String? sId;
  String? CategoryName;
  String? CategoryImage;
  String? name;
  String? quantity;
  int? price; // Change the type to int
  String? createdAt;
  String? star;
  String? updatedAt;
  String? Image;
  String? descrption;
  int? iV;
  int? count;

  ConvertedApi(
      {this.sId,
      this.CategoryName,
      this.CategoryImage,
      this.name,
      this.quantity,
      this.price,
      this.Image,
      this.descrption,
      this.createdAt,
      this.updatedAt,
      this.star,
      this.iV,
      this.count});

  ConvertedApi.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    CategoryName = json['CategoryName'];
    CategoryImage = json['CategoryImage']; // Corrected field name
    name = json['name'];
    quantity = json['quantity'];
    descrption = json['descrption'];
    price = json['price'];
    Image = json['Image'];
    star = json['star'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['CategoryName'] = this.CategoryName;
    data['CategoryImage'] = this.CategoryImage;
    data['descrption'] = this.descrption;
    data['quantity'] = this.quantity;
    //data['Image'] = this.Image;
    data['price'] = this.price;
    data['count'] = this.count;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
