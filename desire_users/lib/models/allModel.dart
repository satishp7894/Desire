class AllModel {
  bool status;
  String message;
  String imagepath;
  List<Data> data;

  AllModel({this.status, this.message, this.imagepath, this.data});

  AllModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    imagepath = json['imagepath'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['imagepath'] = this.imagepath;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String modelNoId;
  String modelNo;
  String dimensionsId;
  String size;
  String image;

  Data(
      {this.modelNoId, this.modelNo, this.dimensionsId, this.size, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    dimensionsId = json['dimensions_id'];
    size = json['size'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['dimensions_id'] = this.dimensionsId;
    data['size'] = this.size;
    data['image'] = this.image;
    return data;
  }
}
