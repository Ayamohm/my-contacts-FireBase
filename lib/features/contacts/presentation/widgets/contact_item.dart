import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/contact_model.dart';
import '../bloc/contacts_bloc.dart';
import '../pages/add_contact_page.dart';

class ContactItem extends StatelessWidget {
  final ContactModel contact;
  const ContactItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            contact.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          contact.phone,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                final Uri url = Uri(scheme: 'tel', path: contact.phone);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cannot launch dialer")),
                  );
                }
              },
              icon: const Icon(Icons.call, color: Colors.blue, size: 25),
            ),
            IconButton(
              onPressed: () {
                context.read<ContactsBloc>().add(
                  ToggleFavoriteEvent(
                    contact.copyWith(isFavorite: contact.isFavorite == true ? false : true),
                  ),
                );
              },
              icon: Icon(
                contact.isFavorite == true ? Icons.star : Icons.star_border,
                color: contact.isFavorite == true ? Colors.amber : Colors.grey,
                size: 25,
              ),
            ),


            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 25),
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    context.read<ContactsBloc>().add(DeleteContactEvent(contact.id));
                    break;
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditContactScreen(contact: contact)),
                    );
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20,
                        color: Colors.blueAccent,),
                        SizedBox(width: 10,),
                        Text('Edit'),
                        ]
                    )

                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20,
                        color: Colors.red,),
                      SizedBox(width: 10,),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
