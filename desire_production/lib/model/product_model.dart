class ProductModel {
  ProductModel({
    this.status,
    this.product,
    this.message,
  });

  bool status;
  List<Product> product;
  String message;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    product: json["data"] == "null" ? null : List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(product.map((x) => x.toJson())),
    "message": message,
  };
}

class Product {
  Product({
    this.id,
    this.productName,
    this.profileNo,
    this.modelNo,
    this.dimensionId,
    this.category,
    this.futureProduct,
    this.newProduct,
    this.bestSeller,
    this.Customerprice,
    this.Distributorprice,
    this.Salesmanprice,
    this.Customernewprice,
    this.imagepath,
    this.image,
    this.isStatus,
  });

  String id;
  String productName;
  String profileNo;
  String modelNo;
  String dimensionId;
  String category;
  String futureProduct;
  String newProduct;
  String bestSeller;
  String Customerprice;
  String Distributorprice;
  String Salesmanprice;
  String Customernewprice;
  String imagepath;
  List<String> image;
  String isStatus;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["product_name"],
    profileNo: json["profile_No"] == null ? null : json["profile_No"],
    modelNo: json["model_no"] == null ? null : json["model_no"],
    dimensionId: json["dimension_id"] == null ? null : json["dimension_id"],
    category: json["category"] == null ? null : json["category"],
    futureProduct: json["Future_Product"] == null ? null : json["Future_Product"],
    newProduct: json["New_Product"] == null ? null : json["New_Product"],
    bestSeller: json["Best_Seller"] == null ? null : json["Best_Seller"],
    Customerprice : json["Customerprice"] == null ? null : json["Customerprice"],
    Distributorprice : json["Distributorprice"] == null ? null : json["Distributorprice"],
    Salesmanprice : json["Salesmanprice"] == null ? null : json["Salesmanprice"],
    Customernewprice : json["Customernewprice"] == null ? null : json["Customernewprice"],
    imagepath: json["imagepath"] == null ? null : json["imagepath"],
    image: json["image"] == null ? null : List<String>.from(json["image"].map((x) => x)),
    isStatus: json["is_status"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": id,
    "product_name": productName,
    "profile_No": profileNo,
    "model_no": modelNo,
    "dimension_id": dimensionId,
    "category": category,
    "Future_Product": futureProduct,
    "New_Product": newProduct,
    "Best_Seller": bestSeller,
    "Customerprice": Customerprice,
    "Distributorprice": Distributorprice,
    "Salesmanprice": Salesmanprice,
    "Customernewprice": Customernewprice,
    "imagepath": imagepath,
    "image": List<dynamic>.from(image.map((x) => x)),
    "is_status": isStatus,
  };

}
