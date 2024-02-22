class WorkExperience {
  final int id; // Make id final

  final String companyName;
  final String designation;
  final String fromDate;
  final String toDate;
  final String description;

  WorkExperience({
    required this.id, // Add id as a required parameter
    required this.companyName,
    required this.designation,
    required this.fromDate,
    required this.toDate,
    required this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as int, // Correctly assign id from JSON
      companyName: json['company_name'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      fromDate: json['from_date'] as String? ?? '',
      toDate: json['to_date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
