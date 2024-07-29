import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/nav_bar/nav_bar.dart';
import '../../../widgets/text/x_text.dart';
import '../action.dart';
import '../configuration.dart';
import '../statstic.dart';

const appId = 'b3965ab191db4e6ab05b3fd709ccdc27';
const token =
    '007eJxTYPjCnP/3wyPT3UrzmE9tao9k7TjpXbThnVPUXxEDudi8piYFhiRjSzPTxCRDS8OUJJNUs8QkA9Mk47QUcwPL5OSUZCPz3TkL0hoCGRkaE+RYGRkgEMTnZMjLSMyLL0ktLmFgAAAoHCHv';
const channelId = 'nhan_test';

class LivetreamScreen extends StatefulWidget {
  const LivetreamScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LivetreamScreen> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      openCamera = true,
      muteCamera = false,
      muteAllRemoteVideo = false;

  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  final bool _isUseAndroidSurfaceView = false;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler _rtcEngineEventHandler;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: channelId);

    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    _engine.unregisterEventHandler(_rtcEngineEventHandler);
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
    ));

    _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        print(
            '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        print(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        print(
            '[onRemoteVideoStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);
  }

  Future<void> _joinChannel() async {
    await [Permission.microphone, Permission.camera].request();
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: _controller.text,
      uid: 0,
      options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          audienceLatencyLevel:
              AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      openCamera = true;
      muteCamera = false;
      muteAllRemoteVideo = false;
    });
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(
          statusBarHeight: MediaQuery.of(context).padding.top,
          center: const XText.headlineMedium('Video Call'),
        ),
        body: ExampleActionsWidget(
          displayContentBuilder: (context, isLayoutHorizontal) {
            return Stack(
              children: <Widget>[
                StatsMonitoringWidget(
                  rtcEngine: _engine,
                  uid: 0,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                      useFlutterTexture: _isUseFlutterTexture,
                      useAndroidSurfaceView: _isUseAndroidSurfaceView,
                    ),
                    onAgoraVideoViewCreated: (viewId) {
                      _engine.startPreview();
                    },
                  ),
                ),
              ],
            );
          },
          actionsBuilder: (context, isLayoutHorizontal) {
            final channelProfileType = [
              ChannelProfileType.channelProfileLiveBroadcasting,
              ChannelProfileType.channelProfileCommunication,
            ];
            final items = channelProfileType
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toString().split('.')[1],
                      ),
                    ))
                .toList();

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Channel ID'),
                ),
                if (!kIsWeb &&
                    (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Rendered by Flutter texture: '),
                            Switch(
                              value: _isUseFlutterTexture,
                              onChanged: isJoined
                                  ? null
                                  : (changed) {
                                      setState(() {
                                        _isUseFlutterTexture = changed;
                                      });
                                    },
                            )
                          ]),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Channel Profile: '),
                DropdownButton<ChannelProfileType>(
                  items: items,
                  value: _channelProfileType,
                  onChanged: isJoined
                      ? null
                      : (v) {
                          setState(() {
                            _channelProfileType = v!;
                          });
                        },
                ),
                const SizedBox(
                  height: 20,
                ),
                BasicVideoConfigurationWidget(
                  rtcEngine: _engine,
                  title: 'Video Encoder Configuration',
                  setConfigButtonText: const Text(
                    'setVideoEncoderConfiguration',
                    style: TextStyle(fontSize: 10),
                  ),
                  onConfigChanged: (width, height, frameRate, bitrate) {
                    _engine
                        .setVideoEncoderConfiguration(VideoEncoderConfiguration(
                      dimensions: VideoDimensions(width: width, height: height),
                      frameRate: frameRate,
                      bitrate: bitrate,
                    ));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: isJoined ? _leaveChannel : _joinChannel,
                        child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _switchCamera,
                  child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
                ),
              ],
            );
          },
        ));
    // if (!_isInit) return Container();
  }
}
