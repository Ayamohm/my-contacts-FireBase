part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsLoadingState extends ContactsState {}

class ContactsLoadedState extends ContactsState {
  final List<ContactModel> contacts;
  ContactsLoadedState(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactsErrorState extends ContactsState {
  final String message;
  ContactsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
