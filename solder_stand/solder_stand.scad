$fa=6;
$fs=.5;

module spacer(){
difference(){
cylinder(d=15,h=35);
	cylinder(d=2.5,h=80,center=true);
}
}


module stand(){difference(){
union(){
hull(){
	cylinder(d=5,h=5);
	translate([40,0,0])cylinder(d=5,h=5);
}
rotate(60)hull(){
	cylinder(d=5,h=5);
	translate([40,0,0])cylinder(d=5,h=5);
}
translate([40,0,0])rotate(120)hull(){
	cylinder(d=5,h=5);
	translate([40,0,0])cylinder(d=5,h=5);
}
}

translate([20+(30*.5*tan(30)),0,0])rotate([0,30,0])cylinder(d=2.7,h=20,center=true);
rotate(60)translate([40,0,0])cylinder(d=2.5,h=20,center=true);
}
}

module print(){
spacer();
translate([-20,-11.5,0]){
	stand();
translate([0,0,5+.25])stand();
}
}
print();

/*
_ 00 01 11 10 SR
0 0  0  x  1
1 1  0  x  1
Q

s|(!r&q)*/