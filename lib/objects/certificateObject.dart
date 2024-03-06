class Certificate {
  final String sslcCertificate;
  final String hscCertificate;
  final String ugCertificate;
  final String pgCertificate;

  Certificate({
    required this.sslcCertificate,
    required this.hscCertificate,
    required this.ugCertificate,
    required this.pgCertificate,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      sslcCertificate: json['sslc_certificate'] ?? '',
      hscCertificate: json['hsc_certificate'] ?? '',
      ugCertificate: json['ug_certificate'] ?? '',
      pgCertificate: json['pg_certificate'] ?? '',
    );
  }
}
