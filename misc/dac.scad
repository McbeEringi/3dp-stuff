// https://www.amazon.co.jp/dp/B0CZ455K2C
fa=1;$fs=.2;
module rl(d,y,x=.001){
	minkowski(){circle(d=d);square([x,y-d],center=true);}
}

module plug(){
	linear_extrude(1.5)rl(2.5,8.3);
	hull(){
		translate([0,0,1.5])linear_extrude(.001)rl(2.5,8.3);
		translate([0,0,2])linear_extrude(.001)rl(3.7,8.6);
	}
	translate([0,0,2])linear_extrude(2)rl(3.7,8.6);
}

module board(){
	translate([-1.2/2,-10/2,4])cube([1.2,10,14.7]);
	translate([1.2/2,-6.9/2,6])cube([4,6.9,13]);
	translate([5.2/2,0,19])cylinder(d=5.6,h=2);
}

module boardbb(){
	translate([0,0,4])linear_extrude(15)rl(4,11);
	translate([4/2,-7/2,6])cube([3,7,13]);
	translate([5.2/2,0,19])cylinder(d=5.7,h=2);
}

module out(){
	difference(){
		union(){
			linear_extrude(5)rl(6,12);
			translate([3/2,0,5])linear_extrude(13.999)rl(6,12,3);
		}
		plug();
		#boardbb();
	}
}

out();
