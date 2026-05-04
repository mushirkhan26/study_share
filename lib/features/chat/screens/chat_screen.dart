import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sellerName;
  final String bookTitle;
  final int bookPrice;

  const ChatScreen({
    super.key,
    this.sellerName = "Amit Kumar", // Dummy default
    this.bookTitle = "Let Us C", // Dummy default
    this.bookPrice = 150, // Dummy default
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Dummy messages list
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hi Amit, is 'Let Us C' still available?", "isMe": true, "time": "10:30 AM"},
    {"text": "Yes bhai, it's available.", "isMe": false, "time": "10:32 AM"},
    {"text": "Is the price negotiable? 150 is a bit high for me.", "isMe": true, "time": "10:33 AM"},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": _messageController.text,
        "isMe": true,
        "time": "10:38 AM" // Currently fixed, will be dynamic later
      });
      _messageController.clear();
    });

    // Yahan aage chalkar aapka Socket.io wala logic aayega (emit message)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF00BFA5).withValues(alpha: 0.2),
              child: const Text("A", style: TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.sellerName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 📦 Ad Banner (Jiske bare mein chat ho rahi hai)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 30,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.book, size: 20, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("₹${widget.bookPrice}", style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View Ad Details logic
                  },
                  child: const Text("View Ad", style: TextStyle(color: Color(0xFF00BFA5))),
                )
              ],
            ),
          ),

          // 💬 Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'];

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00BFA5) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: Radius.circular(isMe ? 15 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          msg['time'],
                          style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ⌨️ Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF00BFA5),
                  radius: 22,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
