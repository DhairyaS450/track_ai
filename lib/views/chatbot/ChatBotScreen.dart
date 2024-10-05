import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> messages = []; // List to hold chatbot and user messages
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": message}); // User message
      if (message == 'Hello') {
        messages.add({"sender": "bot", "text": "Hello, how can I assist you today?"}); // Chatbot response 
      } else if (message == 'Can you help me with this problem? There is a right angled triangle with a leg of 3cm and another leg of 4cm. What is the length of the hypotenuse?') {
        messages.add({"sender": "bot", "text": "To find the length of the hypotenuse you can use the Pythagorean theorem. The theorum states: \n a^2 + b^2 = c^2 \n Applying the pythagorean theorum, 3^2 + 4^2 = c^2\n9 + 16 = c^2\n25 = c^2\n c = sqrt(25) = 5\nThus the length of the hypotenuse is 5 cm. \nIf you have any other questions, please feel free to ask."});
      } else if (message == 'Create a study session tommorow from 5PM-6PM for math') {
        messages.add({"sender": "bot", "text": "The study session has been created from 5PM-6PM tommorow, go to your study sessions to view or edit it"});
      }
    });

    _controller.clear(); // Clear the input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(), // Input field and send button
        ],
      ),
    );
  }

  // Input field and send button widget
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_controller.text),
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
