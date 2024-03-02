class WorkExperience {
  final int id;
  final String companyName;
  final String designation;
  final String fromDate;
  final String toDate;
  final String description;
  final bool relevant; // Change type to bool
  final String personName;
  final String personContact;

  WorkExperience({
    required this.id,
    required this.companyName,
    required this.designation,
    required this.fromDate,
    required this.toDate,
    required this.description,
    required this.relevant,
    required this.personName,
    required this.personContact,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as int,
      companyName: json['company_name'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      fromDate: json['from_date'] as String? ?? '',
      toDate: json['to_date'] as String? ?? '',
      description: json['description'] as String? ?? '',
      relevant: json['relevant'] as bool? ??
          false, // Parse as bool, default to false if null
      personName: json['verify_person_name'] as String? ?? '',
      personContact: json['verify_person_contact'] as String? ?? '',
    );
  }
}
