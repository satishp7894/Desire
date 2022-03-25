class StateModel {
  bool status;
  String message;
  List<StateData> stateData;

  StateModel({this.status, this.message, this.stateData});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['stateData'] != null) {
      stateData = <StateData>[];
      json['stateData'].forEach((v) {
        stateData.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.stateData != null) {
      data['stateData'] = this.stateData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateData {
  String stateId;
  String stateName;
  String stateDescription;
  String isActive;
  bool isCheck = false;

  StateData(
      {this.stateId,
      this.stateName,
      this.stateDescription,
      this.isActive,
      this.isCheck});

  StateData.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
    stateDescription = json['state_description'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['state_description'] = this.stateDescription;
    data['is_active'] = this.isActive;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{ ${this.stateName}, ${this.stateId}, ${this.stateDescription} }';
  }


}
