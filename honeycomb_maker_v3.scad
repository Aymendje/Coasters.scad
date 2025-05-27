include <BOSL2/std.scad>

TEXT = "<PLACEHOLDER>";

mul = 1;
// Cell Radius mm
cellrad = 2 / mul; 
// Cell Depth mm
cellheight = 2; 
// Cell Wall Thickness mm
cellthick = 0.80; 

// Rows
rows = 100 * mul;
// Columns
cols = 100 * mul; 

border_thick = 1;
lip = 2;
text_size = 20;
font_name = "Billion Dreams"; // Change this to your preferred font available on your system

function get_text_width(txt) = txt == "" ? 0 : textmetrics(txt, size = text_size, font = font_name).size[0];


module opencell(radius,height,thickness) {
	difference() {
		cylinder(r=radius,h=height,$fn=6);
		translate([0,0,-0.5]) cylinder(r=radius-thickness,h=height+1,$fn=6);
	}
}


module honeycomb_internal(rows,cols) {
	cellsize = cellrad-cellthick/2;
	voff = cellsize*1.5;
	hoff = sqrt(pow(cellsize*2,2)-pow(cellsize,2));
	//rnd = rands(-3,2,rows*cols);
	for (i=[0:rows-1]) {
		for (j=[0:cols-1]){
			translate([j*hoff+i%2*(hoff/2),i*voff,0])
			rotate([0,0,30]) 
			//opencell(cellrad,cellheight+0.2*rnd[i*cols + j],cellthick);
			opencell(cellrad,cellheight+0.2,cellthick);
		}
	}
}

module border_ring() {
	height = cellheight + 1 + lip;
	translate([0,0,-1])
	difference() {
		cylinder(r=50, h=height, center=false, $fn=360);
		cylinder(r=50 - border_thick*2, center=false, h=height+border_thick, $fn=360);
	}
}

module honeycomb() {
	intersection() {
		translate([-50, -50]) honeycomb_internal(rows,cols);
		cylinder(r=50, h=cellheight+1, $fn=360);
	}
}

scale_factor = 75 / get_text_width(TEXT);

color("black") 
union() {
	difference() {
		honeycomb();
		scale([scale_factor, scale_factor, 100]) 
		translate([0, 0, -0.2]) 
		linear_extrude(height = 100) text(TEXT, size=text_size, valign="center", halign="center", font=font_name);;
	}
	border_ring();
	translate([0,0,-1]) cylinder(r=50, h=1, $fn=360);
}

color("gold")
scale([scale_factor, scale_factor, 1]) 
translate([0, 0, -0.2]) 
linear_extrude(height = 0.4) text(TEXT, size=text_size, valign="center", halign="center", font=font_name);;
