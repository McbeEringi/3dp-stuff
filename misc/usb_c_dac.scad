// https://www.amazon.co.jp/dp/B0CZ455K2C
$fa=1;$fs=.2;
module rl(d,y,x=.001){
	minkowski(){circle(d=d);square([x,y-d],center=true);}
}

module plug(){
	translate([0,0,-6.5])linear_extrude(8.5)rl(2.5,8.3);
	hull(){
		translate([0,0,1.5])linear_extrude(1)rl(2.5,8.3);
		translate([0,0,2])linear_extrude(2.01)rl(3.7,8.6);
	}
}

module board(){
	translate([0,0,4])linear_extrude(16){
		square([2,10],center=true);
		rl(3.7,8.6);
	}
	translate([.8/2,-7/2,6])cube([5-.8/2,7,14]);
	translate([5.2/2,0,20])cylinder(d=5.5,h=2);
}

module out(){
	difference(){
		union(){
			linear_extrude(19.99)rl(6,12);
			translate([3/2,0,5])linear_extrude(14.99)rl(6,12,3);
		}
		plug();
		board();
	}
	%translate([10,0,0]){plug();board();}
	
	translate([20,0,0])difference(){
		translate([3/2,0,20.01])linear_extrude(1.98)rl(6,12,3);
		board();
	}
}

rotate([180,0,0])out();
