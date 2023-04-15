r = 2;
width = 15;
length = 10;
height = 10;

grid_thickness = 1.6;

cube_size = 10;
$fn = $preview ? 20 : 120;

tolerance = 0.1;
overhang = 2;


module density_cube(additional_padding = 0) {
    translate([0, -overhang-length/2+cube_size/2, height])
        cube(cube_size + 2*additional_padding, center=true);
}

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

module grid_foot() {
    hull() {
        four_corners(width-2*r-2*grid_thickness, length-2*r-2*grid_thickness)
            cylinder(r=r, h=0.1);
        translate([0,0,grid_thickness])
        four_corners(width-2*r, length-2*r)
            cylinder(r=r, h=0.1);
    }
}

module base() {
    grid_foot();

    translate([0,0,grid_thickness])
        hull() {
            four_corners(width-2*r, length-2*r)
                cylinder(r=r, h=height-cube_size/2-grid_thickness);
        }

    intersection() {
        union() {
            // left lip
            translate([-width/2-tolerance,0,height-cube_size/2])
                rotate([0,90,0])  rotate([0,0,180])
                    intersection() {
                        cylinder(r=cube_size-overhang, h=(width-cube_size)/2);
                        cube([cube_size-overhang, cube_size-overhang, (width-cube_size)/2]);
                    }

            // right lip
            translate([width/2+tolerance,0,height-cube_size/2])
                rotate([0,-90,0]) rotate([0,0,-90])
                    intersection() {
                        cylinder(r=cube_size-overhang, h=(width-cube_size)/2);
                        cube([cube_size-overhang, cube_size-overhang, (width-cube_size)/2]);
                    }

            // back
            difference() {
                translate([0, 0, height-cube_size/2])
                    hull() {
                        four_corners(width-2*r, length-2*r)
                            cylinder(r=r, h=cube_size-overhang);
                    }

                density_cube(tolerance);

                translate([width/2 +1, 0, 0]) rotate([0,0,180]) cube([width+2, length/2+1, height+cube_size/2-overhang+1]);
            }
        }
        hull() {
            four_corners(width-2*r, length-2*r)
                cylinder(r=r, h=height+cube_size/2);
        }
    }
}

base();

if ($preview) {
    color("gray") density_cube();
}