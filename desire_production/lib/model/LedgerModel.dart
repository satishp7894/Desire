class LedgerModel {
  bool status;
  String message;
  List<CustomerLedger> customerLedger;

  LedgerModel({this.status, this.message, this.customerLedger});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerLedger'] != null) {
      customerLedger = new List<CustomerLedger>();
      json['customerLedger'].forEach((v) {
        customerLedger.add(new CustomerLedger.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerLedger != null) {
      data['customerLedger'] =
          this.customerLedger.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerLedger {
  String accountName;
  String totalCreditAmount;
  String totalDebitAmount;
  String totalAmount;

  CustomerLedger(
      {this.accountName,
        this.totalCreditAmount,
        this.totalDebitAmount,
        this.totalAmount});

  CustomerLedger.fromJson(Map<String, dynamic> json) {
    accountName = json['account_name'];
    totalCreditAmount = json['total_credit_amount'];
    totalDebitAmount = json['total_debit_amount'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_name'] = this.accountName;
    data['total_credit_amount'] = this.totalCreditAmount;
    data['total_debit_amount'] = this.totalDebitAmount;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}