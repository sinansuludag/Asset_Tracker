enum WebSocketActionEnum {
  REQUEST('40'),
  RESEND('42'),
  REFRESH('2');

  final String value;
  const WebSocketActionEnum(this.value);
}
