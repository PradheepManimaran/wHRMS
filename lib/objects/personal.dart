class EmployeeName {
  final String firstname;
  final String lastname;
  // final String age;
  // final String dateofBirth;
  final String uan;
  final String pan;
  final String workNumber;
  final String personalNumber;
  final String personalEmail;
  final String address;

  EmployeeName(
      this.firstname,
      this.lastname,
      // this.age,
      // this.dateofBirth,
      this.uan,
      this.pan,
      this.workNumber,
      this.personalNumber,
      this.personalEmail,
      this.address);

  factory EmployeeName.fromJson(Map<String, dynamic> json) {
    return EmployeeName(
      json['first_name'] as String? ?? '',
      json['last_name'] as String? ?? '',
      // json['age'] as String? ?? '',
      // json['date_of_birth'] as String? ?? '',
      json['uan'] as String? ?? '',
      json['pan'] as String? ?? '',
      json['working_phone'] as String? ?? '',
      json['personal_phone'] as String? ?? '',
      json['personal_email'] as String? ?? '',
      json['address'] as String? ?? '',
    );
  }
}
