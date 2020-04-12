class User {
  String id;
  String nama;
  String email;
  String role;
  String noHp;
  String alamat;
  double latitude;
  double longitude;

  User(this.id,this.nama,this.email,this.role,this.noHp,this.alamat,this.latitude,this.longitude);

    User.fromMap(Map snapshot,String id) :
        id = id ?? '',
        nama = snapshot['nama'] ?? '',
        email = snapshot['email'] ?? '',
        role = snapshot['role'] ?? '';

  toJson() {
    return {
      "nama": nama,
      "email": email,
      "role": role,
    };
  }
}