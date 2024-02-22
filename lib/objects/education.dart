class EducationDetails {
  final int id;
  final String universityName;
  final String degree;
  final String specialization;
  final String completeyear;
  final String cgpa;
  final String tableId; // Add tableId property

  EducationDetails(
      {required this.id,
      required this.universityName,
      required this.degree,
      required this.specialization,
      required this.completeyear,
      required this.cgpa,
      required this.tableId});

  factory EducationDetails.fromJson(Map<String, dynamic> json) {
    return EducationDetails(
      id: json['id'] as int,
      universityName: json['institute_name'] as String? ?? '',
      degree: json['degree_diploma'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      completeyear: json['date_of_completion'] as String? ?? '',
      cgpa: json['cgpa'] as String? ?? '',
      tableId: json['table_id'] as String? ?? '', // Map 'table_id' from JSON
    );
  }
}
