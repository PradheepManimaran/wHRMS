class FamilyDetails {
  final int id;
  final String name;
  final String relation;
  final String phoneNumber;
  final String address;

  final String tableId; // Add tableId property

  FamilyDetails(
      {required this.id,
      required this.name,
      required this.relation,
      required this.phoneNumber,
      required this.address,
      required this.tableId});

  factory FamilyDetails.fromJson(Map<String, dynamic> json) {
    return FamilyDetails(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      relation: json['relationship'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      tableId: json['table_id'] as String? ?? '',
    );
  }
}
