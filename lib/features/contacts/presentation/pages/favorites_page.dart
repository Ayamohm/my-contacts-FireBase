import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contacts_bloc.dart';
import '../widgets/contact_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
     body:BlocBuilder<ContactsBloc, ContactsState>(
    builder: (context, state) {
      if (state is ContactsLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is ContactsLoadedState) {
        final favContacts = state.contacts
            .where((c) => c.isFavorite == 1)
            .toList();

        if (favContacts.isEmpty) {
          return Center(child: Text("No Favorite Contacts"));
        }

        return ListView.builder(
          itemCount: favContacts.length,
          itemBuilder: (context, index) {
            return ContactItem(contact: favContacts[index]);
          },
        );
      }
      return Center(child: Text("No Data"));
    },
    )
    );

  }
}
