import 'dart:ui';
import 'dart:math' as math;

final Color red = Color.fromARGB(255, 219, 68, 55);
final Color green = Color.fromARGB(255, 15, 157, 88);
final Color blue = Color.fromARGB(255, 66, 133, 244);
final Color yellow = Color.fromARGB(255, 244, 180, 0);
final Color grey = Color.fromARGB(255, 210, 210, 210);
final Color midGrey = Color.fromARGB(255, 170, 170, 170);
final Color darkerGrey = Color.fromARGB(255, 130, 130, 130);

final double clockWidthOffset = -169.0;
final double clockHeightOffset = 0.0;
final centerOffset = Offset(clockWidthOffset, clockHeightOffset);

final clockTickAngle = math.pi / 30;
final perpAngle = math.pi / 2;

final double globalScale = 1.0;