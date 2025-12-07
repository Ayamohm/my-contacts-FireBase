import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/contact_model.dart';
import '../../data/service/contacts_service.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsService _contactsService = ContactsService();
  StreamSubscription? _contactsSubscription;

  ContactsBloc() : super(ContactsLoadingState()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<CallContactEvent>(_onCallContact);

    add(LoadContactsEvent());
  }

  void _onLoadContacts(
      LoadContactsEvent event, Emitter<ContactsState> emit) {
    emit(ContactsLoadingState());

    _contactsSubscription?.cancel();
    _contactsSubscription =
        _contactsService.getContactsStream().listen((contacts) {
          emit(ContactsLoadedState(contacts));
        });
  }

  Future<void> _onAddContact(
      AddContactEvent event, Emitter<ContactsState> emit) async {
    await _contactsService.addContact(event.contact);
  }

  Future<void> _onUpdateContact(
      UpdateContactEvent event, Emitter<ContactsState> emit) async {
    await _contactsService.updateContact(event.contact);
  }

  Future<void> _onDeleteContact(
      DeleteContactEvent event, Emitter<ContactsState> emit) async {
    await _contactsService.deleteContact(event.id);
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<ContactsState> emit) async {
    await _contactsService.toggleFavorite(event.contact);
  }

  Future<void> _onCallContact(
      CallContactEvent event, Emitter<ContactsState> emit) async {
    final phoneNumber = event.contact.phone;
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(url)) {
        if (await Permission.phone.request().isGranted) {
          await launchUrl(url);
        } else if (await Permission.phone.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    } catch (e) {
      print("Call Error: $e");
    }
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
