import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contacts_bloc.dart';
import '../widgets/contact_item.dart';
import 'add_contact_page.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContactsBloc>().add(LoadContactsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditContactScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContactsLoadedState) {
            final contacts = state.contacts;

            if (contacts.isEmpty) {
              return Center(child: Text("No Contacts Found"));
            }

            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ContactItem(contact: contacts[index]);
              },
            );
          } else {
            return Center(child: Text("No Contacts"));
          }
        },
      ),
    );
  }
}
