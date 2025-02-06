mixin CurrencyWebSocketServiceImplMixin {
  // Reconnection Configurations
  final int maxReconnectAttempts = 5;
  final Duration reconnectDelay = const Duration(seconds: 5);
  int reconnectAttempts = 0;
  bool isManuallyDisconnected = false;
  final Duration timeout = const Duration(seconds: 10);
}
