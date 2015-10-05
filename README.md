This is the first release of a RepRap-XY 3D printer. 
It is based on the great work of jand1122, which again is based on the excellent design of Zelogik. See the github archives at:  https://github.com/jand1122/RepRap-XY and https://github.com/zelogik/AluXY
I also use some of the parts parts clintonsam25 shared on the FreeCAD Forum and Github: https://github.com/clintonsam75/FreeCAD-library/tree/master/3D%20Printer and http://forum.freecadweb.org/viewtopic.php?f=24&t=6962

These designs and variants are discussed in the RepRap forum at:: http://forums.reprap.org/read.php?4,297740

jand1122 already changed the original design of zeologic so no more CNC-ed aluminium is needed. Based on this design he used printed parts instead of aluminium parts. 

The resulting design already has a great lot of features:

- Based on the Core-XY system. (see http://corexy.com/theory.html)
- Frame made from aluminium extrusions.
- No motors, belts and guides on the outside of the frame.

When thinking about the ideal FDM 3D printer I want to build those requirements come into my mind:

- Stiff Frame (check, aluminium extrusion profiles are great)
- High quality hotend (E3D or Kraken Printhead can be mounted, upgradeable)
- No Oozing Nozzle (Direct Feed or Closing Nozzle, like cel-robox has)
- Heated Bed for warp-free printing of ABS
- good first layer (automatic bed leveling, good sticking of layer to bed: Kapton Tape, PEI or GeckoTek)
- Capable of wide variety of materials
- Enclosed casing for warp and smell free printing (good starting point with jand1122's design, where no motors are outside the frame)
- Remote control with webcam support (Octopi)
- Multi Nozzle Printhead (higher printspeed, multi material / color prints)
- Swapable Head if possible

With the goal of adding such new features, like ocotopi webcam support, enclosed  caseing, dual nozzle printhead and others I decided to use jand1122s design as a basis for me own redesign.

I started with redesigning his FreeCAD parts, so screws are integrated in a nicer way and remodelling other parts in FreeCAD only available as STEP before.

Also I assemble the printer in the Freecad Assembly2 Module.

This is a work in progress, Use at your own risk.

The Folder src containes the FreeCAD files from jand1122 and from other open source 3D printer projects I used as basis for my design.

The Folder Assembly contains the FreeCAD Assembly and all Parts.
As the Assembly2 Module currently does not allow for import of subgroups of parts and the solver isn't able anymore to solve all constraints if the assembly gets to complicated I use the muxing ability of Assembly2 to join subgroups of parts, such as the XY-Slide into one part then used for further assembly in the complete product.

The file build.py will generate the STEP and STL files.
Just open the file in FreeCAD and run a a macro.

In the doc folder you will find a BOM. 
This BOM currently is fully based on jand1122's design. I will update it later.
This BOM is not generated from the model but hand made, so be carefull
You will not (yet?) find build instructions there.  Have a look at the sourcefiles RepRap-XY.FCStd (FreeCAD) to see how everything fits together.

To see some videos of jand1122's printer have a look at his youtube channel: https://www.youtube.com/channel/UCOyTdQOCCLdy45FtSlam_3A/feed
and some images at his imgur album: http://jand1122.imgur.com/

As I first want to complete the printer in CAD before I start any real life assembly it will be sone time until I can sho you videos or pictures of mine.

Have fun. 
