part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadContactsEvent extends ContactsEvent {}

class AddContactEvent extends ContactsEvent {
  final ContactModel contact;
  AddContactEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}

class UpdateContactEvent extends ContactsEvent {
  final ContactModel contact;
  UpdateContactEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}

class DeleteContactEvent extends ContactsEvent {
  final String id;
  DeleteContactEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavoriteEvent extends ContactsEvent {
  final ContactModel contact;
  ToggleFavoriteEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}

class CallContactEvent extends ContactsEvent {
  final ContactModel contact;
  CallContactEvent(this.contact);

  @override
  List<Object?> get props => [contact];
}
