class UserModel {
        
  final String name;
  final String email;
  final String password;  
  final String phone;
  final String gender;
  final String job;
  final String address;
  final String? profileImage; 

  UserModel({
  
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.job,
    required this.address,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
     
      'name': name,
      'email': email,
      'password': password, 
      'phone': phone,
      'gender': gender,
      'job': job,
      'address': address,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      job: map['job'] ?? '',
      address: map['address'] ?? '',
      profileImage: map['profileImage'],
    );
  }
  @override
String toString() {
  return 'UserModel(name: $name, email: $email, phone: $phone, gender: $gender, job: $job, address: $address, profileImage: $profileImage)';
}

}

