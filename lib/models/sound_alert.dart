class SoundAlert {
  const SoundAlert({
    required this.sound,
    required this.confidence,
    required this.receivedAt,
  });

  final String sound;
  final double confidence;
  final DateTime receivedAt;

  factory SoundAlert.fromJson(Map<String, dynamic> json) {
    return SoundAlert(
      sound: json['sound'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      receivedAt: DateTime.now(),
    );
  }

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';

  String get formattedTime {
    final t = receivedAt;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final s = t.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  String toString() => 'SoundAlert(sound: $sound, confidence: $confidence)';
}