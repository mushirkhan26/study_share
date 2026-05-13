import 'package:flutter/material.dart';
import '../api/network/chat_service.dart';
import '../api/network/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();

  List<dynamic> _conversations = [];
  List<dynamic> _messages = [];
  bool _isLoading = false;
  String? _activeConversationId;

  List<dynamic> get conversations => _conversations;
  List<dynamic> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get activeConversationId => _activeConversationId;

  ChatProvider() {
    _socketService.initSocket();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketService.onGlobalMessageReceived = (data) {
      if (_activeConversationId == data['conversationId']) {
        _messages.add(data);
        notifyListeners();
        markAsRead(data['conversationId']);
      }
      fetchConversations();
    };
  }

  Future<void> fetchConversations() async {
    final response = await _chatService.getConversations();
    if (response.success && response.data != null) {
      _conversations = response.data!;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    _isLoading = true;
    _activeConversationId = conversationId;
    _socketService.activeConversationId = conversationId;
    _socketService.joinChat(conversationId);
    notifyListeners();

    final response = await _chatService.getMessages(conversationId);
    if (response.success && response.data != null) {
      _messages = response.data!;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initializeChat({String? conversationId, String? sellerId, String? bookId}) async {
    _isLoading = true;
    _messages = [];
    _activeConversationId = conversationId;
    notifyListeners();

    String? id = conversationId;

    if (id == null && sellerId != null && bookId != null) {
      final response = await _chatService.getOrCreateConversation(sellerId, bookId);
      if (response.success && response.data != null) {
        id = response.data!['id'] ?? response.data!['_id'];
      }
    }

    if (id != null) {
      _activeConversationId = id;
      _socketService.activeConversationId = id;
      _socketService.joinChat(id);
      
      final response = await _chatService.getMessages(id);
      if (response.success && response.data != null) {
        // Merge instead of overwrite if local messages were added (optimistic UI)
        final fetchedMessages = response.data!;
        _messages = [...fetchedMessages, ..._messages.where((m) => !fetchedMessages.any((fm) => fm['id'] == m['id'] || fm['text'] == m['text'] && fm['senderId'] == m['senderId']))];
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void sendMessage(String conversationId, String text, String senderId, String receiverId) {
    _socketService.sendMessage(conversationId, senderId, text);
    final messageData = {
      'conversationId': conversationId,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': DateTime.now().toIso8601String(),
    };
    _messages.add(messageData);
    notifyListeners();
  }

  Future<void> markAsRead(String conversationId) async {
    await _chatService.markAsRead(conversationId);
    fetchConversations();
  }

  void clearActiveConversation() {
    _activeConversationId = null;
    _socketService.activeConversationId = null;
    _messages = [];
    notifyListeners();
  }

  Future<String?> getOrCreateConversation(String sellerId, String bookId) async {
    final response = await _chatService.getOrCreateConversation(sellerId, bookId);
    if (response.success && response.data != null) {
      return response.data!['_id'];
    }
    return null;
  }
}
