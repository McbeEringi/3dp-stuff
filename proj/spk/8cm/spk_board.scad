$fa=6;
$fs=.5;

module pin(){
	cylinder(5,3,2);
	translate([0,0,5]){
		cylinder(d=4,h=1);
		translate([0,0,1]){
			cylinder(3,1,1.5);
			translate([0,0,3])cylinder(d=4,h=1);
		}
	}
}
module stopper(){
	difference(){
		translate([-4,-2.5,0])cube([8,5,2.7]);
		cylinder(3,1,1.5);
		translate([2,0,0])cube([8,1.5,6],center=true);
	}
}

module board(){
	difference(){
		translate([-65,-45,0])minkowski(){
			cube([110,90,4]);
			cylinder(d=10,h=1);
		}
		cylinder(d=76,h=20,center=true);
		#for(i=[1:4])rotate([180,0,(i+.5)/4*360])translate([42,0,-5])scale(1.03){#pin();translate([0,0,6])rotate(90)stopper();}
		translate([-50,0,0])#cube([4.5,4.5,15],center=true);
	}
}
module rstick(l=50){hull(){
		cylinder(d=10,h=10);
		translate([l,0,0])cylinder(d=10,h=10);
	}
}
module stand(){
	difference(){
		union(){
			rstick(90);
			rotate(75){
				rstick(15);
				translate([30,-15.5,0])rotate(-105)rstick(50);
			}
		}
		rotate(75)translate([6,-10.5,0])#cube([120,5.5,10]);
	}
}

module print(){
	for(i=[-1:2])translate([10*i,0,0]){translate([0,0,4])rotate([-96,0,0])pin();translate([0,-10,0])stopper();}
	board();
	translate([-60,60,0])stand();
	rotate([180,0,0])translate([-60,60,-10])stand();
}
module main(){
	for(i=[-1,1])translate([0,5+30*i,5])rotate([90,0,0])stand();
	rotate([0,-75,0])translate([81,0,-9])board();
}

print();
