//
// PARAMETRIC Cable Chain v0.5
// Zerginator 10/2015
//

// - changes V1.2:
//  - added missing grip-size modifiers
//
// - changes V1.1:
//  - added variable hinge length:
//    "hiHeight" now specifies the height of the hinge pin, relative to the bottom.

use <text_on.scad>


chainlength = 30;
//ChainDef = [[1,0],[1,10],[1,10],[1,15],[1,15],[1,15],[1,15],[1,15],[1,15],[1,15],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,8],[1,7],[1,5],[1,5],[1,4],[1,4],[1,3],[1,3],[1,2],[1,1]];

ChainDef = [[1,0],[1,5],[1,15],[1,15],[1,20],[1,20],[1,20],[1,20],[1,15],[1,15],[1,10],[1,10],[1,10],[1,10],[1,10],[1,10],[1,7],[1,6],[1,5],[1,5],[1,5],[1,5],[1,5],[1,5],[1,4],[1,4],[1,4],[1,4],[1,3],[1,3],[1,0],[1,0]];

//$fs=0.5;
//$fa=0.5;

// ===============================================================================
// Type
Type        =       2;         // 1: +45° Bewegbar, 2: +-45°, Adapter auf Frei, Adapter Richtungswechsel
Round       =       1;         // Runder oder eckiger Typ
ChainP      =       0;          // Chainprintable
Start       =       0;          // -45°
End         =       0;          // +-45°
Open        =       0;          // Open / Closed / Closed with Filament / Closed with 2 Filaments
PrintCl     =       1;          // Print Closing Element
Tolerance   =       0;
space       =       0.3;        // Space between the chain parts and the matches - 0.2
anglerest       =      90;          // anglerest for maximum bending of one peace. -  45 // Possible values from 0 - 90
overlapping =       0.01;       // overlapping value to make the Object simple - leave this at 0.01
conntweak   =       0;          // Connection tweak - 0 - You may add or subtract here a little for the nopples, so the whole thing gets stickier or less between the chainparts.



// ===============================================================================
// box parameters
width       =       45;       // length of the box (Standard: 16.6)
height      =       20;         // width of the box (Standard: 13)
length      =       25;         // height of the lid  (Standard: 25, min 30 für Eckig)
wall        =       1.2;        // Wall thinkness - 1.2


// ===============================================================================
// === OUTPUT


// ===Check Consistency of Values
if((!Type && !Start && !End) || ((Round != 1) && (length/height<2.2)))
{
    // === IDIOT BOX (if imposible values were selected)
    cube([30,30,30]);
    color("red")
    text_on_cube("Doh!!", locn_vec=[15,15,15], cube_size=30, face="top", size=5, center=true); 
    color("red")
    text_on_cube("Error!!", locn_vec=[15,15,15], cube_size=30, face="front", size=5, center=true);   
    color("red")
    text_on_cube("Fehler!!", locn_vec=[15,15,15], cube_size=30, face="right", size=4, center=true);   
    color("red")
    text_on_cube("Défaut!!", locn_vec=[15,15,15], cube_size=30, face="left", size=4, center=true);   
    color("red")
    text_on_cube("ошибка!!", locn_vec=[15,15,15], cube_size=30, face="back", size=4, center=true); 
    color("red")
    text_on_cube("错误!!", locn_vec=[15,15,15], cube_size=30, face="bottom", size=4, center=true);     
}

else
// === Put the Parts together to a single Chain object
// === Magic happens here, make several chain parts and add them to a chain
{
    if( Round == 1)
    {
        vec = select2(ChainDef,[1]);
        for (i = [1:len(ChainDef)]) { 
            c = sumv(vec,i-1,0);
            a = coslength(i,ChainDef,vec); //c-ChainDef[i-1][1]
            b = sinlength(i,ChainDef,vec); //(sin(ChainDef[i-1][1]));
           echo(i,c,c-ChainDef[i-1][1],b);
//            echo(((height/13)*(length-10.5))*(sin(ChainDef[i-1][1])));
//            translate([236.317,254.444,521])
//            rotate(a=90, v=[0,0,1])
//            rotate(a=-90, v=[0,1,0])
            pcsOChain(width, length, height, wall,anglerest, 0, a, b, c);
        }
    }


    if( Round != 1)
    {
        for (i = [0:len(ChainDef)-1]) { 
            pcsOChain(width, length, height, wall,anglerest, 0, i * (length - height), 0, 30);
        }
    }
}


// ===============================================================================
// === Mathematikfunktionen
function sumv(v,i,s=0) = (i==s ? v[i] : v[i] + sumv(v,i-1,s));
function select(source_vector,select_vector)=
   [ for (i = [0 : len(select_vector) - 1]) source_vector[select_vector[i]] ];
function select2(source_vector,select_vector)=
   [ for (i = [0 : len(source_vector) - 1]) source_vector[i][1] ];
function coslength(j,ChainDef,vec,s=1)=
   (j==s ? (((height/13)*(length-10.5)) * cos(sumv(vec,j-1,0)-ChainDef[j-1][1])) : (((height/13)*(length-10.5))) * cos(sumv(vec,j-1,0)-ChainDef[j-1][1]) + coslength(j-1,ChainDef,vec));  
   
function sinlength(j,ChainDef,vec,s=1)=
   (j==s ? ((height/13)*(length-10.5))*(sin(sumv(vec,j-1,0)-ChainDef[j-1][1])) : ((height/13)*(length-10.5))*(sin(sumv(vec,j-1,0)-ChainDef[j-1][1])) + sinlength(j-1,ChainDef,vec));


// ===============================================================================
// === Generate Chain module
module pcsOChain(width, length, height, wall, anglerest, posx,posy,posz, ChainAngle) 
    {    
        translate([posx,posy,posz])
        translate([0,(height/13)*4.5,(height/13)*6.5])  
        rotate(a=ChainAngle, v=[1,0,0])
        translate([0,-(height/13)*4.5,-(height/13)*6.5])  
        if (Round != 1)
        {
            pcsMiddlePart(width, length, height, wall);
            pcsOFront(width, length, height, wall,anglerest);
            translate([0,length - height - overlapping,0]) pcsOBack(width, length, height, wall);
        }
        else
        {
            CableChain(width, length, height, wall);
        }
    }





// ===============================================================================
// ===============================================================================
// ===============================================================================




// ===============================================================================
// === Cable Chain (Rund)

module CableChain(width, length, height, wall)
{
translate([width,0,0])
rotate(a=90, v=[0,0,1])
difference()
    {
    union()
        {
        difference()
            {
                union()
                   {
                    translate([0,0.1,0])
                        rotate(a=0, v=[0,0,1])
                            cube([(height/13)*(length-7.5),width,(height/13)*13]);
                    translate([(height/13)*(length-7.5),0.1,(height/13)*6.5])
                        rotate(a=90, v=[-1,0,0])
                            cylinder(r=(height/13)*6.5, h=width);
                   }

                union()
                    {
                    union()
                        {
                        if (Type == 1)
                        {
                            translate([(height/13)*-0.8,-1,(height/13)*6.4])
                                rotate(a=35, v=[0,-1,0])
                                    cube([(height/13)*9,width+1.5,(height/13)*5]);
                            translate([(height/13)*3.2,-1,(height/13)*9.9])
                                rotate(a=0, v=[0,0,1])
                                    cube([(height/13)*7,width+1.5,(height/13)*4]);
                        } 
                        translate([(height/13)*4.6,2,(height/13)*6.5])
                            rotate(a=90, v=[1,0,0])   
                                cylinder(r=(height/13)*6.85, h=3);
                        
                        //FEMALE
                            translate([(height/13)*(length-6),width+0.5,(height/13)*6.5])
                                rotate(a=90, v=[1,0,0])   
                                    cylinder(r=(height/13)*2.45, h=width+0.9);                         
                         translate([(height/13)*4.6,width+1.3,(height/13)*6.5])
                            rotate(a=90, v=[1,0,0])   
                                cylinder(r=(height/13)*6.85, h=3);
                        }
                    difference()
                        {
                        translate([0,-0.5,0])
                            rotate(a=0, v=[0,0,1])
                                cube([(height/13)*5,width+0.9,(height/13)*4]);
                        {
                        translate([(height/13)*5,width+0.4,(height/13)*5.5])
                            rotate(a=90, v=[1,0,0])   
                                cylinder(r=(height/13)*5.5, h=width+0.9);
                            }
                        }
                    if (Type == 2)
                        {
                        difference()
                            {
                            translate([0,-0.5,9])
                                rotate(a=0, v=[0,0,1])
                                    cube([(height/13)*5,width+0.9,(height/13)*4]);
                            {
                            translate([(height/13)*5,width+0.4,(height/13)*7.5])
                                rotate(a=90, v=[1,0,0])   
                                    cylinder(r=(height/13)*5.5, h=width+0.9);
                                }
                            }
                        }
                    }
                }
                
                // MALE
                difference()
                {
                    translate([(height/13)*4.5,width-0.3,(height/13)*6.5])
                        rotate(a=90, v=[1,0,0])   
                            cylinder(r=(height/13)*1.85, h=width-0.8); 
                    translate([(height/13)-1,-2,(height/13)*4.5])
                        rotate(a=-20, v=[0,0,1])
                            cube([4,4,4]);
                    translate([(height/13)-1,18.8,(height/13)*4.5]) //2.5
                            rotate(a=-70, v=[0,0,1]) //-15
                                cube([4,4,4]);
                } 
        } 
        
    union()
        {
            translate([(height/13)*-1,3.4,1.5])
                rotate(a=0, v=[0,0,1])
                    cube([(height/13)*(length+1),width-6.6,height-3]);
           translate([(height/13)*(length-9.65),3.4,(height/13)*3.5])
                rotate(a=0, v=[0,0,1])
                    cube([(height/13)*8,width-6.6,(height/13)*10]);    
            
            if (Type == 1)
            {
                translate([(height/13)*-1,3.4,(height/13)*-1.5])
                    rotate(a=0, v=[0,0,1])
                        cube([(height/13)*8,width-6.6,(height/13)*13]);
                translate([(height/13)*(length-12.5),1.6,(height/13)*9.7])
                    rotate(a=-60, v=[1,0,0])
                        cube([(height/13)*11,3,3]);  
                translate([(height/13)*(length-12.5),width-1.4,(height/13)*9.7])
                    rotate(a=150, v=[1,0,0])
                        cube([(height/13)*11,3,3]);
                translate([(height/13)*(length-12.5),1.6,1.5])
                    rotate(a=0, v=[0,0,1])
                        cube([(height/13)*6,width-3,((height/13)*8.2)+((height/13)*1.5-1.5)]);
                translate([(height/13)*(length-9.65),1.6,0])
                    rotate(a=0, v=[0,0,1])
                        cube([(height/13)*10,width-3,(height/13)*9.7]);
            }
            
            if (Type == 2)
            {
            translate([(height/13)*-1,3.4,(height/13)*-1.5])
                    rotate(a=0, v=[0,0,1])
                        cube([(height/13)*8,width-6.6,(height/13)*16]);
            translate([(height/13)*(length-12.5),1.6,1.5])
                    rotate(a=0, v=[0,0,1])
                        cube([(height/13)*6,width-3,height-3]);

            translate([(height/13)*(length-9.65),1.6,0])
                rotate(a=0, v=[0,0,1])
                    cube([(height/13)*10,width-3,(height/13)*13]);
            }
        }
    }    
    
} // END CABLE CHAIN RUND

// ===============================================================================
// === Cable Chain (ECKIG)
// Middle part of a Chainpeace
module pcsMiddlePart(width, length, height, wall) 
{
	difference() {
		// Main Object
		cube([width,length - height * 2 ,height]);
		// Hole in the Middle
		translate([2 * wall + space,-1 ,wall]) 
			cube([width - 4 * wall - 2 * space,length + 2 ,height - 2* wall]);
		// Cutout Front
		translate([1 * wall , 0 - overlapping,wall])	
			cube([width - 2 * wall , space * 2 ,height - 2 * wall]);
		// Cutout Back left
		translate([- overlapping,length - height * 2 - 2 * space + overlapping,-.5]) 
			cube([wall+space+overlapping, space * 2, height + 1]);
		// Cutout Back Right
		translate([width - wall - space ,length - height * 2 - 2 * space + overlapping,-.5]) 
			cube([wall+space+overlapping, space * 2, height + 1]);
	}
}

// Front Part, the one with the nopples
module pcsOFront(width, length, height, wall,anglerest)
{
	// Add all the single Objects
	union() { 
		// Cut out the Hole from the big Part
		difference() {
			// Model the full object
			union() {
				rotate([0,90,0])	
					translate([-height/2,-height/2,0]) 
						cylinder(width,height/2,height/2, $fn=48);
				translate([0,-height / 2,0]) 
					cube([width,height/2,height]);
				translate([0,-height , 0]) 
					cube([width,height/2,height/2]);
				difference() {
					translate([0,-height/2,height/2])
						rotate([90-anglerest,0,0])
							cube([wall,height/2,height/2]);
 					translate([-1,-height,height])
							cube([wall+2, height, height]);
				}
				difference() {
					translate([width - wall,-height/2,height/2])
						rotate([90-anglerest,0,0])
							cube([wall,height/2,height/2]);
 					translate([width - wall -1,-height,height])
							cube([wall+2, height, height]);
				}

			}
			// Cut out cableway
			translate([wall,-height -1 ,-1]) 
				cube([width - 2 * wall,height+2,height+2]);
		}
		// Add the Nopples
		translate([wall,-height/2,height/2]) 
			rotate([0,90,0]) 
				cylinder(wall + space,wall*2 + space + conntweak,wall + space+ conntweak, $fn=48);
		translate([width-wall ,-height/2,height/2]) 
			rotate([180,90,0]) 
				cylinder(wall + space,wall*2 + space+ conntweak,wall + space+ conntweak, $fn=48);
	}
}

// Back Part, the one with the holes
module pcsOBack(width, length, height, wall)
{
	// Cut out all the holes we need
	difference() { 
		// Cut out the Hole from the big Part
		difference() {
			// Model the full Object
			union() {
				rotate([0,90,0])	
					translate([-height/2,-height/2,wall + space]) 
						cylinder(width - 2 * (wall + space),height/2,height/2, $fn=48);
				translate([wall + space ,-height,0]) 
					cube([width - 2 * (wall + space),height/2,height]);
			}
			translate([2 * wall + space, -height -1 ,-1]) 
				cube([width - 4 * wall - 2 * space,height+2,height+2]);
		}
		translate([wall + space -overlapping,- height/2,height/2]) 
			rotate([0,90,0]) 
				cylinder(wall+space,wall*2+space,wall+space, $fn=48);
		translate([width - wall + overlapping - space,-height/2,height/2]) 
			rotate([180,90,0]) 
				cylinder(wall+space,wall*2+space,wall+space, $fn=48);
	}


} // END CABLE CHAIN ECKIG


