class Medicine {
  final String userId;
  final String id;
  final String title;
  final String body;

  Medicine({this.userId, this.id, this.title, this.body});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      userId: json['schedule'] as String,
      id: json['nappi_code'] as String,
      title: json['name'] as String,
      body: json['dispensing_fee'] as String,
    );
  }
}