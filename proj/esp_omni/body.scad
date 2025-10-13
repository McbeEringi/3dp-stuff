use <omni2.scad>
$fa=1;$fs=1;
module tomegu(t=5){
	difference(){
		union(){
			circle(d=15);
			translate([15/2,0,0])scale(-1)square([15,10/2+t]);
			translate([ 15/2,-10/2,0])square(1);
			translate([-15/2,-10/2,0])scale([-1,1])square(1);
			translate([ 12/2,-10/2-t,0])scale([1,-1])square(3);
			translate([-12/2,-10/2-t,0])scale(-1)square(3);
		}
		intersection(){
			circle(d=12);
			square([12,10],center=true);
		}
		translate([12/2,-3,0])scale(-1)square([12,15/2]);
	}
}

//linear_extrude(10)tomegu();

linear_extrude(5)difference(){
	circle(d=150);
	for(i=[0:4-1])rotate(360/4*i){
		%translate([75,0])scale(-1)omni_bb();
		translate([75,0])scale(-1)omni_bb_2d(2);
	}
}
