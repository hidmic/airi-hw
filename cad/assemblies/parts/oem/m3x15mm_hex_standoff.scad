include <generic/lib.scad>;

use <generic/standoffs.scad>;

function vM3x15mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=15, width=5.5);

module mM3x15mmHexThreadedStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x15mmHexThreadedStandoffDatasheet());
}

function vM3x15mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(length=15, width=5.5);

module mM3x15mmHexStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x15mmHexStandoffDatasheet());
}
