import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';

class CockpitScreen extends StatefulWidget {
  const CockpitScreen({super.key});

  @override
  State<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends State<CockpitScreen> {
  var _isConnected = false;

  final _peer = Peer(
    id: 'cockpit',
    options: PeerOptions(
      debug: LogLevel.All,
    ),
  );
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _remoteRenderer.initialize();

    _peer.on<MediaConnection>('call').listen((call) async {
      final mediaStream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': false});

      call.answer(mediaStream);

      call.on('close').listen((event) {
        setState(() => _isConnected = false);
      });

      call.on<MediaStream>('stream').listen((event) {
        _remoteRenderer.srcObject = event;
        setState(() => _isConnected = true);
      });
    });
  }

  @override
  void dispose() {
    _peer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/circuit_track.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isConnected)
                RotatedBox(
                  quarterTurns: 1,
                  child: RTCVideoView(
                    _remoteRenderer,
                    mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              Positioned(
                top: size.height - 88.0,
                right: (size.width / 2) - 90.0,
                child: Container(
                  height: 80.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Colors.black87,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 58.0,
                          child: Text(
                            '00',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontFamily: 'Orbitron',
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Text(
                          '  km/h',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
