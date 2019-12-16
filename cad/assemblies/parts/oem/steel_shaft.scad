include <generic/lib.scad>;

use <generic/shaft.scad>;

function v100x8mmSteelShaftDatasheet() =
     pvShaftDatasheet(length=100, diameter=8);

module m100x8mmSteelShaft() {
     color("silver") render() pmShaft(v100x8mmSteelShaftDatasheet());
}
