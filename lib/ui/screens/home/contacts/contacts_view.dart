import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/models/user_model.dart';
import 'package:flutter_chat_app/core/viewmodels/contacts_viewmodel.dart';
import 'package:flutter_chat_app/ui/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

// ==================================================
// PURPOSE: Displays a list of all users in the app for the user to start a new conversation with.
// ==================================================
class ContactsView extends StatelessWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: StreamBuilder<List<UserModel>>(
        stream: viewModel.usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Something Went Wrong',
              message: 'We couldn\'t load your contacts. Please try again later.',
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.people_outline,
              title: 'No Contacts Found',
              message: 'It looks like you are the first one here!',
            );
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
                onTap: () => viewModel.navigateToChat(user),
              );
            },
          );
        },
      ),
    );
  }
}