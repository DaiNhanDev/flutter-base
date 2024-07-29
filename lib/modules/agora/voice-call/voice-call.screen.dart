import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/common.dart';
import '../../../widgets/nav_bar/nav_bar.dart';
import '../../../widgets/text/x_text.dart';

const appId = 'b3965ab191db4e6ab05b3fd709ccdc27';
const token =
    '007eJxTYPjCnP/3wyPT3UrzmE9tao9k7TjpXbThnVPUXxEDudi8piYFhiRjSzPTxCRDS8OUJJNUs8QkA9Mk47QUcwPL5OSUZCPz3TkL0hoCGRkaE+RYGRkgEMTnZMjLSMyLL0ktLmFgAAAoHCHv';
const channelId = 'nhan_test';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VoiceCallScreen> {
  late final RtcEngine _engine;
  Set<int> remoteUid = {};

  bool isJoined = false,
      openMicrophone = true,
      muteMicrophone = false,
      muteAllRemoteAudio = false,
      enableSpeakerphone = true,
      playEffect = false;
  bool _isSetDefaultAudioRouteToSpeakerphone = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 100,
      _playbackVolume = 100,
      _inEarMonitoringVolume = 100;

  late final RtcEngineEventHandler _rtcEngineEventHandler;

  @override
  void initState() {
    super.initState();
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
      channelProfile: ChannelProfileType.channelProfileCommunication,
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
        setState(() {
          remoteUid.add(rUid);
        });
      },
      onRemoteAudioStateChanged: (RtcConnection connection, int remoteUid,
          RemoteAudioState state, RemoteAudioStateReason reason, int elapsed) {
        log.warning(
            '[onRemoteAudioStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        print(
            '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == rUid);
        });
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
      onAudioRoutingChanged: (routing) {
        log.warning('[onAudioRoutingChanged] routing: $routing');
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    await _engine.enableAudio();
    await _engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          autoSubscribeAudio: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
      muteMicrophone = false;
      muteAllRemoteAudio = false;
      enableSpeakerphone = true;
      playEffect = false;
      _enableInEarMonitoring = false;
      _recordingVolume = 100;
      _playbackVolume = 100;
      _inEarMonitoringVolume = 100;
    });
  }

  Future<void> _switchMicrophone() async {
    await _engine.muteLocalAudioStream(!openMicrophone);
    await _engine.enableLocalAudio(!openMicrophone);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  Future<void> _switchSpeakerphone() async {
    await _engine.setEnableSpeakerphone(!enableSpeakerphone);
    setState(() {
      enableSpeakerphone = !enableSpeakerphone;
    });
  }

  Future<void> _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  Future<void> _toggleInEarMonitoring(value) async {
    try {
      await _engine.enableInEarMonitoring(
          enabled: value,
          includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      _enableInEarMonitoring = value;
      // setState(() {});
    } catch (e) {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(
          statusBarHeight: MediaQuery.of(context).padding.top,
          center: const XText.headlineMedium('Voice Call'),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _switchMicrophone,
                        child:
                            Text('Microphone ${openMicrophone ? 'on' : 'off'}'),
                      ),
                      if (!kIsWeb) ...[
                        ElevatedButton(
                          onPressed: () {
                            _isSetDefaultAudioRouteToSpeakerphone =
                                !_isSetDefaultAudioRouteToSpeakerphone;
                            _engine.setDefaultAudioRouteToSpeakerphone(
                                _isSetDefaultAudioRouteToSpeakerphone);
                            setState(() {});
                          },
                          child: Text(!_isSetDefaultAudioRouteToSpeakerphone
                              ? 'SetDefaultAudioRouteToSpeakerphone'
                              : 'UnsetDefaultAudioRouteToSpeakerphone'),
                        ),
                        ElevatedButton(
                          onPressed: isJoined ? _switchSpeakerphone : null,
                          child: Text(
                              enableSpeakerphone ? 'Speakerphone' : 'Earpiece'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('RecordingVolume:'),
                            Slider(
                              value: _recordingVolume,
                              min: 0,
                              max: 400,
                              divisions: 5,
                              label: 'RecordingVolume',
                              onChanged: isJoined
                                  ? (double value) async {
                                      setState(() {
                                        _recordingVolume = value;
                                      });
                                      await _engine.adjustRecordingSignalVolume(
                                          value.toInt());
                                    }
                                  : null,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('PlaybackVolume:'),
                            Slider(
                              value: _playbackVolume,
                              min: 0,
                              max: 400,
                              divisions: 5,
                              label: 'PlaybackVolume',
                              onChanged: isJoined
                                  ? (double value) async {
                                      setState(() {
                                        _playbackVolume = value;
                                      });
                                      await _engine.adjustPlaybackSignalVolume(
                                          value.toInt());
                                    }
                                  : null,
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              const Text('InEar Monitoring Volume:'),
                              Switch(
                                value: _enableInEarMonitoring,
                                onChanged:
                                    isJoined ? _toggleInEarMonitoring : null,
                                activeTrackColor: Colors.grey[350],
                                activeColor: Colors.white,
                              )
                            ]),
                            if (_enableInEarMonitoring)
                              SizedBox(
                                  width: 300,
                                  child: Slider(
                                    value: _inEarMonitoringVolume,
                                    min: 0,
                                    max: 100,
                                    divisions: 5,
                                    label:
                                        'InEar Monitoring Volume $_inEarMonitoringVolume',
                                    onChanged: isJoined
                                        ? _onChangeInEarMonitoringVolume
                                        : null,
                                  ))
                          ],
                        ),
                      ],
                    ],
                  ),
                ))
          ],
        ));
  }
}
