import 'dart:async';
import 'dart:convert';
import 'package:asset_tracker/core/constants/enums/web_socket_enum.dart';
import 'package:asset_tracker/core/mixins/service_mixin/currency_web_socket_service_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

class CurrencyWebSocketServiceImpl
    with CurrencyWebSocketServiceImplMixin
    implements ICurrencyWebSocketService {
  final String _url;
  final StreamController<CurrencyResponse> _streamController =
      StreamController<CurrencyResponse>.broadcast();
  late WebSocket _webSocket;

  CurrencyWebSocketServiceImpl(this._url);

  @override
  Stream<CurrencyResponse> connectEndListen() {
    _connectSocket(); // Initial connection
    return _streamController.stream;
  }

  Future<void> _connectSocket() async {
    try {
      _webSocket = WebSocket(Uri.parse(_url), timeout: timeout);

      _webSocket.connection.listen(
        (connectionState) {
          if (connectionState is Connected) {
            debugPrint('WebSocket connected');
            reconnectAttempts = 0; // Reset reconnect attempts
            _webSocket
                .send(WebSocketActionEnum.REQUEST.value); // Initial handshake
          } else if (connectionState is Reconnecting) {
            debugPrint('WebSocket reconnecting...');
          } else if (connectionState is Disconnected) {
            debugPrint('WebSocket disconnected');
            if (!isManuallyDisconnected) {
              _attemptReconnect();
            }
          }
        },
      );

      _webSocket.messages.listen(
        (message) {
          try {
            if (message
                .toString()
                .startsWith(WebSocketActionEnum.RESEND.value)) {
              final dataString = message.toString().substring(2);
              final decodedJson = jsonDecode(dataString)[1];
              final response = CurrencyResponse.fromJson(decodedJson);
              _streamController.add(response);
            } else if (message
                .toString()
                .startsWith(WebSocketActionEnum.REFRESH.value)) {
              debugPrint('Refreshing connection');
              _webSocket.send(WebSocketActionEnum.REQUEST.value);
            }
          } catch (e) {
            _streamController.addError(Exception('Error parsing message: $e'));
            debugPrint('Error parsing message: $e');
          }
        },
        onError: (error) {
          debugPrint('WebSocket message error: $error');
          _streamController.addError(Exception('WebSocket Error: $error'));
        },
        onDone: () {
          debugPrint('WebSocket message stream closed');
          if (!isManuallyDisconnected) {
            _attemptReconnect();
          }
        },
      );
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (reconnectAttempts < maxReconnectAttempts) {
      reconnectAttempts++;
      debugPrint(
          'Attempt $reconnectAttempts to reconnect in ${reconnectDelay.inSeconds} seconds...');
      Future.delayed(reconnectDelay, () {
        _connectSocket();
      });
    } else {
      debugPrint('Maximum reconnect attempts reached. Giving up.');
      _streamController
          .addError(Exception('Unable to reconnect to WebSocket.'));
    }
  }

  @override
  void disconnect() {
    isManuallyDisconnected = true; // Mark as manually disconnected
    _webSocket.close();
    _streamController.close();
    debugPrint('WebSocket connection closed manually');
  }
}
