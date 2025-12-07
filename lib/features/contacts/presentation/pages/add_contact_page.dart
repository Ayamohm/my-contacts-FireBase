import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../bloc/contacts_bloc.dart';

class AddEditContactScreen extends StatefulWidget {
  final ContactModel? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? selectedCountryCode ;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    final phone = widget.contact?.phone ?? '';
    _phoneController = TextEditingController(text: phone);

    isFavorite = widget.contact?.isFavorite == 1;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Contact" : "Add Contact",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // NAME FIELD
              Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter contact name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),

              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        selectedCountryCode = country.dialCode!;
                      });
                    },
                    initialSelection: selectedCountryCode,
                    padding: EdgeInsets.zero,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone number",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // FAVORITE TOGGLE
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                ),
                child: SwitchListTile(
                  title: const Text("Mark as Favorite"),
                  value: isFavorite,
                  activeColor: Colors.blue,
                  onChanged: (value) => setState(() => isFavorite = value),
                ),
              ),
              const SizedBox(height: 25),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEdit ? "Update Contact" : "Save Contact",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final contact = ContactModel(
                        id: widget.contact!.id,
                        name: _nameController.text,
                        phone: "$selectedCountryCode${_phoneController.text}",
                        isFavorite: isFavorite ? true : false,
                      );

                      if (isEdit) {
                        context.read<ContactsBloc>().add(UpdateContactEvent(contact));
                      } else {
                        context.read<ContactsBloc>().add(AddContactEvent(contact));
                      }

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
