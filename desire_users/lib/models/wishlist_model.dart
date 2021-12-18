
class WishListModel {
  WishListModel({
    this.status,
    this.wishlist,
    this.message,
  });

  bool status;
  List<Wishlist> wishlist;
  String message;

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    status: json["status"],
    wishlist: List<Wishlist>.from(json["data"].map((x) => Wishlist.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(wishlist.map((x) => x.toJson())),
    "message": message,
  };
}

class Wishlist {
  Wishlist({
    this.id,
    this.productName,
    this.wishlistId,
    this.imagePath,
    this.image,
  });

  String id;
  String productName;
  String wishlistId;
  String imagePath;
  List<String> image;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    id: json["id"],
    productName: json["product_name"],
    wishlistId: json["wishlist_id"],
    imagePath: json["image_path"],
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "wishlist_id": wishlistId,
    "image_path": imagePath,
    "image": List<dynamic>.from(image.map((x) => x)),
  };
}
