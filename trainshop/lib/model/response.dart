class Response {
  final int? statusCode;
  final dynamic body;
  final dynamic bodyBytes;

  Response({
    this.statusCode,
    this.body,
    this.bodyBytes,
  });
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      statusCode: json['statusCode'],
      body: json['body'],
      bodyBytes: json['bodyBytes'],
    );
  }
  static Map<String, dynamic> toJson(Response value) => {
        'statusCode': value.statusCode,
        'body': value.body,
        'bodyBytes': value.bodyBytes,
      };
}
