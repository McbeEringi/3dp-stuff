$fa=6;
$fs=.5;

module spacer()linear_extrude(5)difference(){
    circle(d=18);
	circle(d=3);
    translate([0,-5])square([0.5,50]);
}


module stand(a=50,d=5)linear_extrude(d)difference(){
    minkowski(){
        circle(d=a,$fn=3);
        circle(d=d);
    }
    circle(d=a-2*d,$fn=3);
    for(i=[0:2])rotate(i*120)translate([a/2,0,0])rotate(60){
        circle(d=2.6);
        translate([0,-5])square([0.5,10]);
    }
}
    

module print(){
    for(i=[0:1])translate([0,i*50,0])spacer();
    for(i=[0:1])translate([0,i*50,0])stand();
}
print();