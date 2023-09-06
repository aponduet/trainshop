class UserInfo {
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? aboutme;
  final String? address;
  final String? mobile;
  final String? dateofbirth;
  final String? facebook;
  final String? twitter;
  final String? whatsapp;
  final String? email;
  final String? userid;
  final String? jwt;
  final String? imageurl;
  final String? selectedtrainId;
  final bool? isDarkTheme;
  final bool? isLogedIn;
  final String? countryid;

  const UserInfo({
    this.username,
    this.firstname,
    this.lastname,
    this.aboutme,
    this.address,
    this.mobile,
    this.dateofbirth,
    this.facebook,
    this.twitter,
    this.whatsapp,
    this.email,
    this.userid,
    this.jwt,
    this.imageurl,
    this.selectedtrainId,
    this.isDarkTheme,
    this.countryid,
    this.isLogedIn,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      address: json['address'],
      aboutme: json['aboutme'],
      mobile: json['mobile'],
      dateofbirth: json['dateofbirth'],
      facebook: json['facebook'],
      twitter: json['twitter'],
      whatsapp: json['whatsapp'],
      email: json['email'],
      userid: json['userid'],
      jwt: json['jwt'],
      imageurl: json['imageurl'],
      selectedtrainId: json['selectedtrainId'],
      isDarkTheme: json['isDarkTheme'],
      isLogedIn: json['isLogedIn'],
      countryid: json['countryid'],
    );
  }

  static Map<String, dynamic> toJson(UserInfo value) => {
        'username': value.username,
        'firstname': value.firstname,
        'lastname': value.lastname,
        'address': value.address,
        'aboutme': value.aboutme,
        'mobile': value.mobile,
        'dateofbirth': value.dateofbirth,
        'facebook': value.facebook,
        'twitter': value.twitter,
        'whatsapp': value.whatsapp,
        'email': value.email,
        'userid': value.userid,
        'jwt': value.jwt,
        'imageurl': value.imageurl,
        'selectedtrainId': value.selectedtrainId,
        'isDarkTheme': value.isDarkTheme,
        'isLogedIn': value.isLogedIn,
        'countryid': value.countryid,
      };
}
//  OTP Model for Client Side


/*     গুরুত্বপূর্ণ নোটঃ ক্লাইন্ট থেকে সার্ভারে ডাটা পাঠাতে গেলে  অবশ্যই ঐ ডাটাকে
        জিসন স্ট্রিং এ কনভার্ট করে নিতে হবে। এবং সার্ভার থেকে ডাটা রিসিভ করতে হলে জিসন স্ট্রিং ডাটাকে 
        অবজেক্ট ডাটাতে পরিনত করে ব্যবহার করতে হয়।
        মনে রাখতে হবে জিসন স্ট্রিং আর ডার্টের ম্যাপ ডাটা টাইপ এক নয়।
        জিসন স্ট্রিং এর কী এবং ভ্যালু উভয়ই স্ট্রিং, 
        *** অবজেক্ট ডাটা কে প্রথমে tojson() দিয়ে ম্যাপ ডাটা টাইপে পরিনত করতে হবে, 
        এরপর ঐ ম্যাপ ডাটাকে jsonEncode() দিয়ে জিসন স্ট্রিং ডাটাতে পরিনত করতে হবে।
        *** জিসন স্ট্রিং ডাটা কে প্রথমে jsonDecode() দিয়ে ম্যাপ ডাটা টাইপে পরিনত করতে হবে, 
        এরপর ঐ ম্যাপ ডাটাকে fromjson() দিয়ে অবজেক্ট ডাটাতে পরিনত করতে হবে।
        tojson() == অবজেক্ট ডাটা কে ম্যাপ ডাটায় কনভার্ট করে।
        fromjson()  == ম্যাপ ডাটা কে অবজেক্ট ডাটায় কনভার্ট করে।
        jsonDecode() == জিসন স্ট্রিং ডাটা কে ম্যাপ ডাটায় কনভার্ট করে।
        jsonEncode() == ম্যাপ ডাটা কে জিসন স্ট্রিং ডাটায় কনভার্ট করে।
        উল্লেখ্যঃ 
        ম্যাপ ডাটা টাইপঃ      Map<String, dynamic> == {'username': Sohel Rana, 'age': 30, 'sex': 'male'}
        জিসন স্ট্রিং ডাটা টাইপঃ Map<String, String> == {'username': "Sohel Rana", "age": "30", "sex" : "male" }
         অবজেক্ট ডাটা টাইপঃ  {username: "Sohel Rana" , age: 30, sex: "male"}
         
        */