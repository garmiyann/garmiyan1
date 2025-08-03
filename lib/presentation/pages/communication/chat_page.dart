import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Telegram white background
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF527DA3), // Telegram blue
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.otherUserAvatar.isNotEmpty
                ? NetworkImage(widget.otherUserAvatar)
                : null,
            child: widget.otherUserAvatar.isEmpty
                ? Text(
                    widget.otherUserName.isNotEmpty
                        ? widget.otherUserName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'last seen recently',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          onPressed: () => _makeVoiceCall(),
        ),
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white),
          onPressed: () => _makeVideoCall(),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            switch (value) {
              case 'view_profile':
                _viewProfile();
                break;
              case 'search':
                _searchInChat();
                break;
              case 'mute':
                _muteChat();
                break;
              case 'clear_history':
                _clearHistory();
                break;
              case 'delete_chat':
                _deleteChat();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'view_profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem(
              value: 'media',
              child: Text('Media'),
            ),
            const PopupMenuItem(
              value: 'search',
              child: Text('Search'),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Text('Mute'),
            ),
            const PopupMenuItem(
              value: 'clear_history',
              child: Text('Clear History'),
            ),
            const PopupMenuItem(
              value: 'delete_chat',
              child: Text('Delete Chat'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Start your conversation',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final message = snapshot.data!.docs[index];
            final messageData = message.data() as Map<String, dynamic>;
            return MessageBubble(
              message: messageData['text'] ?? '',
              isMe: messageData['senderId'] ==
                  FirebaseAuth.instance.currentUser?.uid,
              timestamp: messageData['timestamp'] as Timestamp?,
              messageStatus: messageData['status'] ?? 'sent',
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      onChanged: (value) {
                        setState(() {
                          _isTyping = value.trim().isNotEmpty;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () => _showAttachmentOptions(),
                  ),
                  if (!_isTyping)
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: () {},
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: const Color(0xFF40A2E3), // Telegram blue
            onPressed: _isTyping ? _sendMessage : _sendVoiceMessage,
            child: Icon(
              _isTyping ? Icons.send : Icons.mic,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.indigo,
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.headset,
                  label: 'Audio',
                  color: Colors.orange,
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.person,
                  label: 'Contact',
                  color: Colors.blue,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _isTyping = false;
    });

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      // Add message to Firestore first
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'sent',
      });

      // Update chat's last message and timestamp
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  void _sendVoiceMessage() {
    // Implement voice message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message feature coming soon!')),
    );
  }

  void _makeVoiceCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${widget.otherUserName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF40A2E3),
              backgroundImage: widget.otherUserAvatar.isNotEmpty
                  ? NetworkImage(widget.otherUserAvatar)
                  : null,
              child: widget.otherUserAvatar.isEmpty
                  ? Text(
                      widget.otherUserName.isNotEmpty
                          ? widget.otherUserName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            const Text('Calling...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.call_end, color: Colors.red, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_off, color: Colors.grey, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon:
                      const Icon(Icons.volume_up, color: Colors.blue, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeVideoCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Video Call ${widget.otherUserName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.videocam, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Connecting...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.call_end, color: Colors.red, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_off, color: Colors.grey, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam_off,
                      color: Colors.grey, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(widget.otherUserName),
            backgroundColor: const Color(0xFF40A2E3),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: const Color(0xFF40A2E3),
                  backgroundImage: widget.otherUserAvatar.isNotEmpty
                      ? NetworkImage(widget.otherUserAvatar)
                      : null,
                  child: widget.otherUserAvatar.isEmpty
                      ? Text(
                          widget.otherUserName.isNotEmpty
                              ? widget.otherUserName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.otherUserName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Online', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _searchInChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search in chat feature coming soon!')),
    );
  }

  void _muteChat() {
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'muted': true,
      'mutedAt': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat with ${widget.otherUserName} muted')),
    );
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
            'Are you sure you want to clear all messages in this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _deleteChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text(
            'Are you sure you want to delete your chat with ${widget.otherUserName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to messenger screen
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp? timestamp;
  final String messageStatus;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.timestamp,
    required this.messageStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 50),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF40A2E3) : const Color(0xFFF1F1F2),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getStatusIcon(),
                          size: 16,
                          color: _getStatusColor(),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 50),
        ],
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon() {
    switch (messageStatus) {
      case 'sent':
        return Icons.check;
      case 'delivered':
        return Icons.done_all;
      case 'read':
        return Icons.done_all;
      default:
        return Icons.access_time;
    }
  }

  Color _getStatusColor() {
    switch (messageStatus) {
      case 'read':
        return const Color(0xFF40A2E3);
      case 'delivered':
        return Colors.white70;
      default:
        return Colors.white70;
    }
  }
}
