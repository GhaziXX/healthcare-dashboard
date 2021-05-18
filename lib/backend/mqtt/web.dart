import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:admin/mqtt/mqtt_constants.dart' as CONST;

MqttClient setup() {
  return MqttBrowserClient.withPort(
      "ws://" + CONST.broker, CONST.clientIdentifier, CONST.webPort);
}
