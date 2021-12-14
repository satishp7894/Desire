class ProductModel {
  bool status;
  String imagepath;
  List<Product> product;
  String message;

  ProductModel({this.status, this.imagepath, this.product, this.message});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    imagepath = json['imagepath'];
    if (json['data'] != null) {
      product = new List<Product>();
      json['data'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['imagepath'] = this.imagepath;
    if (this.product != null) {
      data['data'] = this.product.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Product {
  String id;
  String productName;
  String profileNo;
  String modelNo;
  String dimensionId;
  String category;
  String futureProduct;
  String newProduct;
  String bestSeller;
  String customerprice;
  String distributorprice;
  String salesmanprice;
  String customernewprice;
  bool inPriceList;
  List<String> image;
  String isStatus;

  Product(
      {this.id,
        this.productName,
        this.profileNo,
        this.modelNo,
        this.dimensionId,
        this.category,
        this.futureProduct,
        this.newProduct,
        this.bestSeller,
        this.customerprice,
        this.distributorprice,
        this.salesmanprice,
        this.customernewprice,
        this.inPriceList,
        this.image,
        this.isStatus});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    profileNo = json['profile_No'];
    modelNo = json['model_no'];
    dimensionId = json['dimension_id'];
    category = json['category'];
    futureProduct = json['Future_Product'];
    newProduct = json['New_Product'];
    bestSeller = json['Best_Seller'];
    customerprice = json['Customerprice'];
    distributorprice = json['Distributorprice'];
    salesmanprice = json['Salesmanprice'];
    customernewprice = json['Customernewprice'];
    inPriceList = json['in_price_list'];
    image = json['image'].cast<String>();
    isStatus = json['is_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['profile_No'] = this.profileNo;
    data['model_no'] = this.modelNo;
    data['dimension_id'] = this.dimensionId;
    data['category'] = this.category;
    data['Future_Product'] = this.futureProduct;
    data['New_Product'] = this.newProduct;
    data['Best_Seller'] = this.bestSeller;
    data['Customerprice'] = this.customerprice;
    data['Distributorprice'] = this.distributorprice;
    data['Salesmanprice'] = this.salesmanprice;
    data['Customernewprice'] = this.customernewprice;
    data['in_price_list'] = this.inPriceList;
    data['image'] = this.image;
    data['is_status'] = this.isStatus;
    return data;
  }
}
