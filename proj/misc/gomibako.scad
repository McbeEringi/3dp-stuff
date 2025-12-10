h=120;
w=100;
r=10;
b=1;
difference(){
scale([1,1,-1])linear_extrude(h)
minkowski(){
square([w-r*2,w-r*2],center=true);
circle(r);
}
minkowski(){
	cube([w-r*2,w-r*2,(h-r)*2],center=true);
	sphere(r-b);
}
translate([0,-(w-b)/2,-h/2])rotate([90,0,0])linear_extrude(b/2)text("護美箱",font="serif",direction="ttb",size=h/5,valign="center");
}

