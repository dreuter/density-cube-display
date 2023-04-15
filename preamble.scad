$fn = $preview ? 20 : 120;

include <constants.scad>

module four_corners(x,y) {
    translate([-x/2, -y/2, 0])
        children();
    translate([-x/2, y/2, 0])
        children();
    translate([x/2, -y/2, 0])
        children();
    translate([x/2, y/2, 0])
        children();
}
