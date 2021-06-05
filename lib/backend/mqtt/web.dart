import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:admin/constants/mqtt_constants.dart' as CONST;

MqttClient setup() {
  return MqttBrowserClient.withPort(
      "wss://" + CONST.broker, CONST.clientIdentifier, CONST.webPort);
}
