class CustomerWiseLedger {
  bool status;
  String message;
  List<CustomerLedger> customerLedger;

  CustomerWiseLedger({this.status, this.message, this.customerLedger});

  CustomerWiseLedger.fromJson(Map<String, dynamic> json) {
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
  String customerLedgerId;
  String ledgerDate;
  String ledgerAccount;
  String type;
  String debitAmount;
  String creditAmount;

  CustomerLedger(
      {this.customerLedgerId,
        this.ledgerDate,
        this.ledgerAccount,
        this.type,
        this.debitAmount,
        this.creditAmount});

  CustomerLedger.fromJson(Map<String, dynamic> json) {
    customerLedgerId = json['customer_ledger_id'];
    ledgerDate = json['ledger_date'];
    ledgerAccount = json['ledger_account'];
    type = json['type'];
    debitAmount = json['debit_amount'];
    creditAmount = json['credit_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_ledger_id'] = this.customerLedgerId;
    data['ledger_date'] = this.ledgerDate;
    data['ledger_account'] = this.ledgerAccount;
    data['type'] = this.type;
    data['debit_amount'] = this.debitAmount;
    data['credit_amount'] = this.creditAmount;
    return data;
  }
}