class AllDimensionsModel {
  bool status;
  String message;
  String imagePath;
  List<AllDimension> data;

  AllDimensionsModel({this.status, this.message, this.imagePath, this.data});

  AllDimensionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    imagePath = json['imagePath'];
    if (json['data'] != null) {
      data = new List<AllDimension>();
      json['data'].forEach((v) {
        data.add(new AllDimension.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['imagePath'] = this.imagePath;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllDimension {
  String dimensionsId;
  String size;
  String sizeInch;
  String image;

  AllDimension({this.dimensionsId, this.size, this.sizeInch, this.image});

  AllDimension.fromJson(Map<String, dynamic> json) {
    dimensionsId = json['dimensions_id'];
    size = json['size'];
    sizeInch = json['size_inch'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dimensions_id'] = this.dimensionsId;
    data['size'] = this.size;
    data['size_inch'] = this.sizeInch;
    data['image'] = this.image;
    return data;
  }
}