import 'package:socket_io_client/socket_io_client.dart' as io_client;
import '../../constants/app_constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io_client.Socket? _socket;
  static const String serverUrl = AppConstants.socketBaseUrl;
  
  // Track active chat to prevent redundant notifications
  String? activeConversationId;
  
  // Global callback for notifications
  Function(dynamic)? onGlobalMessageReceived;

  void initSocket() {
    if (_socket != null && _socket!.connected) return;

    _socket = io_client.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, // Use forceNew to ensure a clean connection
    });

    _socket!.onConnect((_) {
      print('Socket Connected: ${_socket?.id}');
    });
    _socket!.onConnectError((err) {
      print('Socket Connect Error: $err');
    });
    _socket!.onDisconnect((reason) {
      print('Socket Disconnected: $reason');
    });
    _socket!.on('error', (err) {
      print('Socket Error: $err');
    });
    _socket!.onReconnectAttempt((_) => print('Socket Reconnect Attempt'));
    _socket!.onReconnect((_) => print('Socket Reconnected'));
    
    // Global listener for notifications
    _socket!.on('receive_message', (data) {
      if (onGlobalMessageReceived != null) {
        onGlobalMessageReceived!(data);
      }
    });
  }

  void joinChat(String conversationId) {
    if (_socket == null || !_socket!.connected) {
      initSocket();
    }
    _socket?.emit('join_chat', conversationId);
  }

  void sendMessage(String conversationId, String senderId, String text) {
    if (_socket == null || !_socket!.connected) {
      print('Cannot send message: Socket not connected');
      initSocket();
      return;
    }

    _socket?.emit('send_message', {
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
    });
  }

  void onMessageReceived(Function(dynamic) callback) {
    // This is used by specific ChatScreens
    _socket?.on('receive_message', callback);
  }

  void removeMessageListener(Function(dynamic) callback) {
    _socket?.off('receive_message', callback);
  }

  void disconnect() {
    // _socket?.disconnect();
  }
}
