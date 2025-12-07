class ContactModel{
  String id;
  final String name;
  final String? email;
  final String phone;
  bool isFavorite;


  ContactModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.isFavorite=false,
  });
// (3) تحويل الموديل لـ Map عشان نخزنه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite,
    };
  }

  // (4) إنشاء موديل من DocumentSnapshot جاي من Firestore
  factory ContactModel.fromDoc(String docId, Map<String, dynamic> data) {
    return ContactModel(
      id: docId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // (5) نسخة جديدة مع تعديل بيانات معينة (مفيدة في التعديل)
  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    bool? isFavorite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}