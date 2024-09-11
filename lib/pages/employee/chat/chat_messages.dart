import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/chat/widgets/message_bubble.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/get_logged_user_provider.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(getLoggedUserProvider);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: chatBackground,
          border: Border.all(
            color: mainColor,
          )),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sohbet')
            .orderBy(
              'gonderildi',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Henüz bir mesaj yok'),
            );
          }

          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40.0, left: 13, right: 13),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;

                final currentMessageEmployeeId = chatMessage['calisan_id'];
                final nextMessageEmployeeId = nextChatMessage != null
                    ? nextChatMessage['calisan_id']
                    : null;

                final nextUserIsSame =
                    nextMessageEmployeeId == currentMessageEmployeeId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['mesaj'],
                      isMe: currentUser['id'] == currentMessageEmployeeId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['calisan_resim'],
                      username: chatMessage['calisan_isim'],
                      message: chatMessage['mesaj'],
                      isMe: currentUser['id'] == currentMessageEmployeeId);
                }
              });
        },
      ),
    );
  }
}
