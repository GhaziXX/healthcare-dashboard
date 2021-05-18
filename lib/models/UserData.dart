class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String description;
  final String age;
  final String gender;
  final String address;
  final String speciality;
  final String phoneNumber;
  final bool isDoctor;
  final String birthdate;
  UserData(
      {this.firstName,
      this.lastName,
      this.description,
      this.age,
      this.gender,
      this.speciality,
      this.phoneNumber,
      this.id,
      this.email,
      this.address,
      this.isDoctor,
      this.birthdate});
  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        firstName = data['first'],
        lastName = data['last'],
        description = data['description'],
        age = data['age'],
        gender = data['gender'],
        speciality = data['speciality'],
        phoneNumber = data['phoneNumber'],
        email = data['email'],
        isDoctor = data['isDoctor'],
        birthdate = data['birthdate'],
        address = data['address'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'description': description,
      'age': age,
      'gender': gender,
      'speciality': speciality,
      'phoneNumber': phoneNumber,
      'email': email,
      'isDoctor': isDoctor,
      'address': address,
      'birthdate': birthdate
    };
  }
}
