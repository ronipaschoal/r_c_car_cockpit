import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  final _peer = Peer(
    id: 'server',
    options: PeerOptions(debug: LogLevel.All),
  );
  final _remoteRenderer = RTCVideoRenderer();
  bool _isConnected = false;

  MediaConnection? _conn;

  @override
  void initState() {
    super.initState();

    _peer.on('open').listen((id) {
      setState(() {});
    });

    _peer.on<MediaConnection>('call').listen((call) async {
      final mediaStream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': false});

      call.answer(mediaStream);

      call.on('close').listen((event) {
        setState(() => _isConnected = false);
      });
    });
  }

  @override
  void dispose() {
    _peer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void connect() async {
    final mediaStream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': false});

    _conn = _peer.call('cockpit', mediaStream);

    _conn?.on('close').listen((event) {
      setState(() => _isConnected = false);
    });

    _conn?.on<MediaStream>('stream').listen((event) {
      _remoteRenderer.srcObject = event;

      setState(() => _isConnected = true);
    });
  }

  void disconnect() async {
    _remoteRenderer.srcObject = null;
    _conn?.close();
    _conn = null;
    _peer.disconnect();
    setState(() => _isConnected = false);
    print('Disconnected');
  }

  void send() {
    // conn.send('Hello!');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _renderState(),
              SelectableText(_peer.id ?? ''),
              SizedBox(height: 200),
              ElevatedButton(onPressed: connect, child: const Text('connect')),
              ElevatedButton(
                  onPressed: disconnect, child: const Text('disconnect')),
            ],
          ),
        ));
  }

  Widget _renderState() {
    Color bgColor = _isConnected ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = _isConnected ? 'Connected' : 'Standby';
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}
