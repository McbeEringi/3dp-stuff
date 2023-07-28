$fs=.1;$fa=6;
difference(){
translate([-10,0,-.5])cube([15,160,1]);
for(i=[0:15])translate([0,5+i*10]){
linear_extrude(1)text(str(i,"号 "),3,font="HGGothicM",halign="right");
cylinder(d=2.1+i*.3,h=10,center=true);
}
}