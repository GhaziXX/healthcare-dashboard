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
  final String gid;
  final List<dynamic> otherIds;
  final bool isConnected;
  final String emergencyPhoneNumber;
  final String officePhoneNumber;
  final String officeAddress;
  final String photoURL;
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
      this.birthdate,
      this.gid,
      this.otherIds,
      this.isConnected,
      this.emergencyPhoneNumber,
      this.officeAddress,
      this.officePhoneNumber,
      this.photoURL});

  UserData.fromJson(Map<String, dynamic> data)
      : this(
            id: data['id'] as String,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            description: data['description'] as String,
            age: data['age'] as String,
            gender: data['gender'] as String,
            speciality: data['speciality'] as String,
            phoneNumber: data['phoneNumber'] as String,
            email: data['email'] as String,
            isDoctor: data['isDoctor'] as bool,
            birthdate: data['birthdate'] as String,
            address: data['address'] as String,
            gid: data['gid'] as String,
            otherIds: data['otherIds'] as List<dynamic>,
            isConnected: data['isConnected'] as bool,
            emergencyPhoneNumber: data['emergencyPhoneNumber'] as String,
            officeAddress: data['officeAddress'] as String,
            officePhoneNumber: data['officePhoneNumber'] as String,
            photoURL: data["photoURL"] as String);

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
      'birthdate': birthdate,
      'gid': gid,
      'otherIds': otherIds,
      'isConnected': isConnected,
      'emergencyPhoneNumber': emergencyPhoneNumber,
      "officeAddress": officeAddress,
      "officePhoneNumber": officePhoneNumber,
      "photoURL": photoURL,
    };
  }
}
