import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';

class ContactsService {
  final CollectionReference _contactsRef =
  FirebaseFirestore.instance.collection('contacts');      // (1)

  // إضافة Contact جديد
  Future<void> addContact(ContactModel contact) async {       // (2)
    await _contactsRef.add(contact.toMap());                  // (3)
  }

  // جلب كل الـ Contacts كسيل من البيانات (Stream)
  Stream<List<ContactModel>> getContactsStream() {            // (4)
    return _contactsRef
        .snapshots()                                          // (5)
        .map((querySnapshot) {                                // (6)
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ContactModel.fromDoc(doc.id, data);            // (7)
      }).toList();
    });
  }

  // تحديث Contact
  Future<void> updateContact(ContactModel contact) async {    // (8)
    await _contactsRef.doc(contact.id).update(contact.toMap());
  }

  // حذف Contact
  Future<void> deleteContact(String id) async {               // (9)
    await _contactsRef.doc(id).delete();
  }

  // تغيير حالة Favorite
  Future<void> toggleFavorite(ContactModel contact) async {   // (10)
    await _contactsRef.doc(contact.id).update({
      'isFav': !contact.isFavorite,
    });
  }
}
