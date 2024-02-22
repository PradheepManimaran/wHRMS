class EmployeesField {
  final int id;
  final String username;

  final String emailid;

  EmployeesField(this.id, this.username, this.emailid);

  factory EmployeesField.fromJson(Map<String, dynamic> json) {
    return EmployeesField(
      json['id'] as int? ?? 0,
      json['username'] as String? ?? '',
      json['email'] as String? ?? '',
    );
  }
}

class Employe {
  final int age;
  final String date;

  Employe(this.age, this.date);

  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      json['age'] as int? ?? 0,
      json['date_of_birth'] as String? ?? '',
    );
  }
}
