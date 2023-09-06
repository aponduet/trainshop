class Otp {
  final String? email;
  Otp({
    this.email,
  });
  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(
      email: json['email'],
    );
  }
  static Map<String, dynamic> toJson(Otp value) => {'email': value.email};
}
