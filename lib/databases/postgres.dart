import 'package:postgres/postgres.dart';

Future<void> main() async {
  var connection = PostgreSQLConnection(
      "healthcare-do-user-8860474-0.b.db.ondigitalocean.com", 25060, "data",
      username: "admin", password: "qxgor1n3m9v4vqjs", useSSL: true);
  await connection.open();
  List<List<dynamic>> results =
      await connection.query("SELECT data FROM ghazi");
  print(results.length);
  int i = 0;
  for (final row in results) {
    print(row[0]);
    i++;
  }
  print(i);
}
