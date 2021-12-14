class ProductDetailModel {
  bool status;
  List<Data> data;
  String message;

  ProductDetailModel({this.status, this.data, this.message});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String id;
  String productName;
  String profileNo;
  String modelNo;
  String dimensionSize;
  String dimensionSizeInch;
  String dimensionImagePath;
  String dimensionImage;
  String category;
  String customerprice;
  String customernewprice;
  String perBoxStick;
  int boxPrice;
  bool inPriceList;
  String imagepath;
  List<String> image;
  String isStatus;

  Data(
      {this.id,
        this.productName,
        this.profileNo,
        this.modelNo,
        this.dimensionSize,
        this.dimensionSizeInch,
        this.dimensionImagePath,
        this.dimensionImage,
        this.category,
        this.customerprice,
        this.customernewprice,
        this.perBoxStick,
        this.boxPrice,
        this.inPriceList,
        this.imagepath,
        this.image,
        this.isStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    profileNo = json['profile_No'];
    modelNo = json['model_no'];
    dimensionSize = json['dimension_size'];
    dimensionSizeInch = json['dimension_size_inch'];
    dimensionImagePath = json['dimension_image_path'];
    dimensionImage = json['dimension_image'];
    category = json['category'];
    customerprice = json['Customerprice'];
    customernewprice = json['Customernewprice'];
    perBoxStick = json['per_box_stick'];
    boxPrice = json['box_price'];
    inPriceList = json['in_price_list'];
    imagepath = json['imagepath'];
    image = json['image'].cast<String>();
    isStatus = json['is_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['profile_No'] = this.profileNo;
    data['model_no'] = this.modelNo;
    data['dimension_size'] = this.dimensionSize;
    data['dimension_size_inch'] = this.dimensionSizeInch;
    data['dimension_image_path'] = this.dimensionImagePath;
    data['dimension_image'] = this.dimensionImage;
    data['category'] = this.category;
    data['Customerprice'] = this.customerprice;
    data['Customernewprice'] = this.customernewprice;
    data['per_box_stick'] = this.perBoxStick;
    data['box_price'] = this.boxPrice;
    data['in_price_list'] = this.inPriceList;
    data['imagepath'] = this.imagepath;
    data['image'] = this.image;
    data['is_status'] = this.isStatus;
    return data;
  }
}
