import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:admin/backend/mqtt/mqtt_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:admin/backend/mqtt/app.dart'
    if (dart.library.html) 'package:admin/backend/mqtt/web.dart' as mqttsetup;

class MQTTWrapper {
  MqttClient client = mqttsetup.setup();

  final VoidCallback onConnectedCallback;
  final Function(dynamic) onDataReceivedCallback;
  final bool debug;
  final String user;
  final bool isPublish;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  MQTTWrapper(
      {this.onConnectedCallback,
      this.onDataReceivedCallback,
      this.debug = false,
      this.user,
      this.isPublish});

  Future<void> prepareMqttClient() async {
    if (!isPublish) {
      _setupMqttClient();
      await _connectClient();
      _subscribeToTopic(user);
    }
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttCurrentConnectionState.CONNECTED) {
      print('MQTTWrapper::Subscribing to ${topic.trim()}...');
      client.subscribe(topic, MqttQos.atLeastOnce);
      client.updates.listen(_onMessage);
    }
  }

  publishMessage(
      {String uid, String gid, @required String topic, String command}) {
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    if (uid != null) {
      builder.addString("$uid,$gid");
    } else {
      builder.addString("$command");
    }
    _sendSetupMqttClient();
    _connectClient().then((_) {
      client.subscribe(topic, MqttQos.exactlyOnce);
      try {
        client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
      } on Exception catch (e) {
        print(e);
      }
    });
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    if (debug) print("MQTTWrapper::GOT A NEW MESSAGE $message");
    var out = json.decode(message);
    if (out != null) {
      onDataReceivedCallback(out);
    }
  }

  Future<void> _connectClient() async {
    try {
      //print('MQTTWrapper::Mosquitto client connecting....');
      await client.connect();
    } on Exception catch (e) {
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('MQTTWrapper::Mosquitto client connected');
    } else {
      // print('MQTTWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client.logging(on: false);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(Random().nextDouble().toString())
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    print('MQTTWrapper::Client connecting....');
    client.connectionMessage = connMess;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _sendSetupMqttClient() {
    client.logging(on: false);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(Random().nextDouble().toString())
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMess;
  }

  void _onSubscribed(String topic) {
    print('MQTTWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    //print('MQTTWrapper::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode ==
        MqttConnectReturnCode.brokerUnavailable) {
      // print('MQTTWrapper::OnDisconnected callback is solicited, this is correct');
    }
    client.disconnect();
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTWrapper::OnConnected client callback - Client connection was sucessfull');
    onConnectedCallback();
  }
}
