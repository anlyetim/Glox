import 'package:flutter/material.dart';
import '../services/sound_manager.dart';

/// Stateful mute button that updates when toggled
class MuteButton extends StatefulWidget {
  const MuteButton({super.key});

  @override
  State<MuteButton> createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  final SoundManager _soundManager = SoundManager();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _soundManager.isMuted ? Icons.volume_off : Icons.volume_up,
      ),
      onPressed: () {
        setState(() {
          _soundManager.toggleMute();
        });
      },
      tooltip: _soundManager.isMuted ? 'Unmute' : 'Mute',
    );
  }
}
