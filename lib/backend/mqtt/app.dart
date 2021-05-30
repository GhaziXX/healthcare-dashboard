import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:admin/constants/mqtt_constants.dart' as CONST;

MqttClient setup() {
  return MqttServerClient.withPort(
      CONST.broker, CONST.clientIdentifier, CONST.mobilePort);
}
