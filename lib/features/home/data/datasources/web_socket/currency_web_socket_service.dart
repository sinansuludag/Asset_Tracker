import 'dart:async';
import 'dart:convert';
import 'package:asset_tracker/core/constants/enums/web_socket_enum.dart';
import 'package:asset_tracker/core/mixins/service_mixin/currency_web_socket_service_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// Haremaltın WebSocket servisinin implementasyonu
/// Real-time döviz kurları için WebSocket bağlantısı
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
    _connectSocket(); // WebSocket bağlantısını başlat
    return _streamController.stream;
  }

  Future<void> _connectSocket() async {
    try {
      debugPrint('🔗 Connecting to WebSocket: $_url');

      // WebSocket bağlantısını kur
      _webSocket = WebSocket(Uri.parse(_url), timeout: timeout);

      // Bağlantı durumu değişikliklerini dinle
      _webSocket.connection.listen(
        (connectionState) {
          if (connectionState is Connected) {
            debugPrint('✅ WebSocket connected successfully');
            reconnectAttempts = 0;
            // Bağlandığında ilk veri talebini gönder
            _webSocket.send(WebSocketActionEnum.REQUEST.value);
          } else if (connectionState is Reconnecting) {
            debugPrint('🔄 WebSocket reconnecting...');
          } else if (connectionState is Disconnected) {
            debugPrint('❌ WebSocket disconnected');
            if (!isManuallyDisconnected) {
              _attemptReconnect();
            }
          }
        },
      );

      // Gelen mesajları işle
      _webSocket.messages.listen(
        (message) {
          try {
            final messageStr = message.toString();

            // Haremaltın Socket.IO formatı kontrolü
            if (messageStr.startsWith(WebSocketActionEnum.RESEND.value)) {
              // "42" ile başlayan mesajlar - gerçek veri
              final dataString = messageStr.substring(2);
              final decodedJson = jsonDecode(dataString);

              // Haremaltın formatı: [event_name, data]
              if (decodedJson is List && decodedJson.length > 1) {
                final currencyData = decodedJson[1];
                final response = CurrencyResponse.fromJson(currencyData);
                _streamController.add(response);

                debugPrint(
                    '📈 Currency data received: ${response.currencies.length} assets');
              }
            } else if (messageStr
                .startsWith(WebSocketActionEnum.REFRESH.value)) {
              // "2" ile başlayan mesajlar - ping/pong
              debugPrint('🔄 Refreshing connection');
              _webSocket.send(WebSocketActionEnum.REQUEST.value);
            }
          } catch (e) {
            debugPrint('❌ Error parsing WebSocket message: $e');
            _streamController.addError(Exception('Error parsing message: $e'));
          }
        },
        onError: (error) {
          debugPrint('❌ WebSocket message error: $error');
          _streamController.addError(Exception('WebSocket Error: $error'));
        },
        onDone: () {
          debugPrint('⚠️ WebSocket message stream closed');
          if (!isManuallyDisconnected) {
            _attemptReconnect();
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error connecting to WebSocket: $e');
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (reconnectAttempts < maxReconnectAttempts) {
      reconnectAttempts++;
      debugPrint(
          '🔄 Reconnect attempt $reconnectAttempts/$maxReconnectAttempts in ${reconnectDelay.inSeconds}s');

      Future.delayed(reconnectDelay, () {
        if (!isManuallyDisconnected) {
          _connectSocket();
        }
      });
    } else {
      debugPrint('❌ Maximum reconnect attempts reached. Giving up.');
      _streamController
          .addError(Exception('Unable to reconnect to WebSocket.'));
    }
  }

  @override
  void disconnect() {
    debugPrint('🔌 Disconnecting WebSocket manually');
    isManuallyDisconnected = true;
    _webSocket.close();
    _streamController.close();
  }
}
