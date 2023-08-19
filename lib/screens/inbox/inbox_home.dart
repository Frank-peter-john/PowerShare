import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:powershare/screens/inbox/chat_screen.dart';
import 'package:powershare/utils/colors.dart';
import '../../utils/dimensions.dart';

class InboxFeedScreen extends StatelessWidget {
  const InboxFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Inbox')),
        backgroundColor: isDark ? deepGreen : greenColor,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display skeleton screens while data is loading
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonChatItem(),
            );
          }

          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonChatItem(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final currentUserApartmentName = userData['apartment name'];

          final currrentUsersName = userData['name'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'apartment name',
                  isEqualTo: currentUserApartmentName,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display skeleton screens while data is loading
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => const SkeletonChatItem(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Oops! something went wrong'),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                      'No Tenant have joined, they will appear here when they join.'),
                );
              }

              final users = snapshot.data!.docs;

              if (users.isNotEmpty) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    final userData = user.data() as Map<String, dynamic>;
                    // Determine the display name based on the user's role
                    final name = userData['name'];
                    final displayName = userData['role'] == 'owner'
                        ? 'Landlord'
                        : userData['name'];

                    if (currrentUsersName != name) {
                      List<String> ids = [uid, user.id];
                      ids.sort();
                      String chatRoomId = ids.join("_");
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['imageUrl']),
                          backgroundColor:
                              isDark ? darkSearchBarColor : greyColor,
                        ),
                        title: Text(
                          displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chatRoomId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(); // Return an empty container while waiting for data
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Row(
                                children: [
                                  Text(
                                    'Open to start a chat',
                                  ),
                                  SizedBox(width: 8),
                                  Text('')
                                ],
                              );
                            }

                            final latestMessage = snapshot.data!.docs[0];
                            final message = latestMessage['message'];
                            final timestamp = latestMessage['timestamp'];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(message), // Display the message
                                const SizedBox(width: 8),
                                Text(
                                  _getTimeAgo(timestamp),
                                ), // Display the timestamp
                              ],
                            );
                          },
                        ),
                        onTap: () {
                          // Handle tapping on a chat item
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return ChatScreen(
                              receiverId: user.id,
                              receiverName: userData['role'] == 'owner'
                                  ? 'Landlord'
                                  : name,
                            );
                          }));
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            },
          );
        },
      ),
    );
  }

  String _getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inDays >= 365) {
      // Return date, month, and year for messages older than one year
      final formattedDate = DateFormat('dd MMM yyyy').format(messageTime);
      return formattedDate;
    } else if (difference.inDays >= 7) {
      // Return day and month for messages older than one week
      final formattedDate = DateFormat('dd MMM').format(messageTime);
      return formattedDate;
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inHours >= 1) {
      // Return hour:minute AM/PM format for messages less than 24 hours
      final formattedTime = DateFormat('h:mm a').format(messageTime);
      return formattedTime;
    } else {
      // Return exact time (hour:minute AM/PM) for messages less than 1 minute ago
      final formattedTime = DateFormat('h:mm a').format(messageTime);
      return formattedTime;
    }
  }
}

// A simple skeleton screen for the chat item
class SkeletonChatItem extends StatelessWidget {
  const SkeletonChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height20),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? darkSearchBarColor : buttonBackgroundColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Dimensions.width30 * 3,
                  height: Dimensions.height30 / 1.5,
                  decoration: BoxDecoration(
                    color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                  ),
                ),
                Container(
                  width: Dimensions.width30 * 2,
                  height: Dimensions.height30 / 1.5,
                  decoration: BoxDecoration(
                    color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height7),
            Container(
              width: Dimensions.width30 * 2,
              height: Dimensions.height30 / 2,
              decoration: BoxDecoration(
                color: isDark ? darkSearchBarColor : buttonBackgroundColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
