use <generic/oring.scad>;

function v35x1_5mmORingDatasheet() =
     pvORingDatasheet(main_diameter=35, cross_section_diameter=1.5);

module m35x1_5mmORing() {
     color("black") {
          render() pmORing(v35x1_5mmORingDatasheet());
     }
}

m35x1_5mmORing();
