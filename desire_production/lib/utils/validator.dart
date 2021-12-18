
class Validator {

  String  validateRequired(String value) {
    if (value.isEmpty) {
      return "This field is Required";
    }
    return null;
  }

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "This field is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Name";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if(!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid Mobile Number";
    } else {
      return null;
    }
  }

  String validatePinCode(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{6}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid PinCode Number";
    } else {
      return null;
    }
  }

  String validateAmount(String value, int redeemPoints) {
    if (value.isEmpty) {
      return "This field is Required";
    } else if (int.parse(value) < 500) {
      return "Amount should be 500 or more";
    } else if (int.parse(value) > redeemPoints) {
      return "Not enough redeem points";
    }
    return null;
  }

  String validateGSTNo(String value) {
    String pattern = r'[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[Z]{1}[0-9a-zA-Z]{1}';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid GST Number";
    } else {
      return null;
    }
  }

  String validateAdhaarNo(String value) {
    String pattern = r'^[2-9]{1}[0-9]{11}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid Adhaar Number";
    } else {
      return null;
    }
  }

  String validatePANNo(String value) {
    String pattern = r'[A-Z]{5}[0-9]{4}[A-Z]{1}';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid PAN Number";
    } else {
      return null;
    }
  }


}