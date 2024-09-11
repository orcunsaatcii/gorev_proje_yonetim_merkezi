import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/get_logged_user_provider.dart';
import 'package:gorev_proje_yonetim_uygulamasi/services/firestore_service.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({super.key});

  @override
  ConsumerState<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  Future<void> _submitMessage() async {
    final message = _messageController.text;

    if (message.trim().isEmpty) {
      return;
    }
    final currentUser = ref.read(getLoggedUserProvider);
    _messageController.clear();

    await FirestoreService.sendMessage(message, currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
              labelText: 'Mesaj',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: mainColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: mainColor,
                ),
              ),
              filled: true,
              fillColor: white,
            ),
          ),
        ),
        IconButton(
          onPressed: _submitMessage,
          icon: const Icon(Icons.send),
          color: mainColor,
        )
      ],
    );
  }
}
