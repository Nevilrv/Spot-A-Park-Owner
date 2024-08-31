class BankDetailsModel {
  String? ownerID;
  String? holderName;
  String? accountNumber;
  String? swiftCode;
  String? bankName;
  String? branchCity;
  String? branchCountry;

  BankDetailsModel({
    this.ownerID,
    this.holderName,
    this.accountNumber,
    this.swiftCode,
    this.bankName,
    this.branchCity,
    this.branchCountry,
  });

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    ownerID = json['ownerID'];
    holderName = json['holderName'];
    accountNumber = json['accountNumber'];
    swiftCode = json['swiftCode'];
    bankName = json['bankName'];
    branchCity = json['branchCity'];
    branchCountry = json['branchCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ownerID'] = ownerID;
    data['holderName'] = holderName;
    data['accountNumber'] = accountNumber;
    data['swiftCode'] = swiftCode;
    data['bankName'] = bankName;
    data['branchCity'] = branchCity;
    data['branchCountry'] = branchCountry;
    return data;
  }
}
