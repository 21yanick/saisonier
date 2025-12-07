import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeCard extends StatelessWidget {
  final Widget child;

  const GyroscopeCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GyroscopeEvent>(
      stream: gyroscopeEventStream(),
      builder: (context, snapshot) {
        double tiltX = 0;
        double tiltY = 0;

        if (snapshot.hasData) {
          // Amplify and clamp signal
          tiltY = (snapshot.data!.y * 0.1).clamp(-0.15, 0.15); // Rotate X axis based on Y tilt
          tiltX = (snapshot.data!.x * 0.1).clamp(-0.15, 0.15); // Rotate Y axis based on X tilt
        }

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(tiltY)
            ..rotateY(-tiltX), // Invert X for natural feel
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
