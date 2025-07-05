$fs=.5;$fa=1;

wire_d=1;
h=50;
wire_x=15;

module speaker(d=0){
	minkowski(){
		square([7,.01],center=true);
		circle(8+d);
	}
}

module shape(d=0){
	minkowski(){
		square([40,40],center=true);
		circle(5+d);
	}
}

module wire_notch(){
	minkowski(){
		translate([-wire_d/2,0])square([wire_d,.01]);
		circle(d=wire_d);
	}
}


difference(){
	linear_extrude(2)shape();
	translate([0,0,1])linear_extrude(2)speaker(-3);
}
translate([0,0,2]){
	linear_extrude(3)difference(){
		speaker(2);
		speaker(.2);
	}
	difference(){
		union(){
			linear_extrude(wire_d/2)difference(){
				shape();
				shape(-2);
			}
			linear_extrude(10)difference(){
				shape(-2);
				shape(-4);
			}
		}
		translate([0,wire_x,wire_d/2])rotate([90,0,90])linear_extrude(100)union(){
			wire_notch();
			translate([-wire_d/2,0])square([wire_d,10]);
		}
	}
}

translate([60,0,2+wire_d/2])rotate([0,180,0]){
	difference(){
		linear_extrude(h-2-wire_d/2-2)difference(){
			shape();
			shape(-2);
		}
		translate([0,wire_x,0])rotate([90,0,90])linear_extrude(100)wire_notch();
	}
	translate([0,0,h-2-wire_d/2-2])linear_extrude(2)shape();
}

/*
difference(){
	linear_extrude(2)minkowski(){
		circle(r=5);
		square([40,40],center=true);
	}
	translate([0,0,1.01])linear_extrude(1)minkowski(){
		circle(r=5);
		square([7,.001],center=true);
	}
}
translate([0,0,2])linear_extrude(3)difference(){
	minkowski(){
		circle(r=10);
		square([7,.001],center=true);
	}
	minkowski(){
		circle(r=8);
		square([7,.001],center=true);
	}
}
translate([15,15,2+1/2])rotate([0,90,0])linear_extrude(5)difference(){
	square([2,5],center=true);
	minkowski(){
		circle(d=1);
		square([.001,1],center=true);
	}
	square([3,1],center=true);
}

translate([60,0,0])rotate([0,180,0]){
	difference(){
		translate([0,0,.01])linear_extrude(50)minkowski(){
			circle(r=6);
			square([40,40],center=true);
		}
		linear_extrude(48)minkowski(){
			circle(r=4);
			square([40,40],center=true);
		}
		linear_extrude(2)minkowski(){
			circle(r=5);
			square([40,40],center=true);
		}
		translate([50/2-1,15,0])rotate([0,90,0])linear_extrude(2)#minkowski(){
			circle(r=.5);
			square([5,1],center=true);
		}
	}

}
*/