include <oem.scad>;

$fn = 32;

kCaseDiameter = 420;
kCaseHeight = 110;
kCaseThickness = 2;
kCaseFillet = 5;

kCaseWirewayRadius = 120;
kCaseWirewayDepth = 10;
kCaseWirewayWidth = 10;
kCaseWirewayAngle = 20;

kCaseSlitHeight = kCaseHeight - 9;
kCaseSlitWidth = kA1M8r1WorkingWidth + 2;

kSonarMountingAngles = [-45, 0, 45];
kSonarCount = len(kSonarMountingAngles);

kSonarPolarAngle = 75;
kSonarBracketDistanceToCase = 2 * kSonarHeight;
kSonarBracketPinWidth = 10;


