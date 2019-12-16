use <generic/gt2_belt.scad>;

function vGT2Belt280mmLong6mmWideDatasheet() =
     pvGT2BeltDatasheet(diameter=12.22, width=6, length=280);

module mGT2Belt280mmLong6mmWide() {
     color([0.1, 0.1, 0.1]) render() pmGT2Belt(vGT2Belt280mmLong6mmWideDatasheet());
}

function vGT2Belt122mmLong6mmWideDatasheet() =
     pvGT2BeltDatasheet(diameter=12.22, width=6, length=122);

module mGT2Belt122mmLong6mmWide() {
     color([0.1, 0.1, 0.1]) render() pmGT2Belt(vGT2Belt122mmLong6mmWideDatasheet());
}

mGT2Belt122mmLong6mmWide();
