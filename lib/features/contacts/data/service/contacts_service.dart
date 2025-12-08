import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';

class ContactsService {
  final CollectionReference _contactsRef =
  FirebaseFirestore.instance.collection('contacts');

  // إضافة Contact جديد
  Future<void> addContact(ContactModel contact) async {
    await _contactsRef.add(contact.toMap());
  }

  // جلب كل الـ Contacts كسيل من البيانات (Stream)
  Stream<List<ContactModel>> getContactsStream() {
    return _contactsRef
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ContactModel.fromDoc(doc.id, data);
      }).toList();
    });
  }

  // تحديث Contact
  Future<void> updateContact(ContactModel contact) async {
    await _contactsRef.doc(contact.id).update(contact.toMap());
  }

  // حذف Contact
  Future<void> deleteContact(String id) async {
    await _contactsRef.doc(id).delete();
  }

  // تغيير حالة Favorite
  Future<void> toggleFavorite(ContactModel contact) async {
    await _contactsRef.doc(contact.id).update({
      'isFavorite': !contact.isFavorite,
    });
  }
}
