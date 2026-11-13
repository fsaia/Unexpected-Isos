178,0
T,TBox,-,0
A,TBox,12,c,parent,banchors,tanchors,width,height,left,right,x1,y1,tex,style
S,IsCoercible,Coerce a TeX Box,0,2,0,0,0,0,0,0,0,-1,,0,0,TBox,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a TeX Box",0,2,0,0,0,0,0,0,0,-1,,0,0,TBox,,36,-38,-38,-38,-38,-38
S,Print,"Print a TeX Box - #children, pos in parent, at width x height, bottom -> top anchors",0,2,0,0,1,0,0,0,0,298,,0,0,TBox,,-38,-38,-38,-38,-38,-38
S,AbsX,Absolute x1 position of a box,0,1,0,0,0,0,0,0,0,TBox,,267,-38,-38,-38,-38,-38
S,AbsY,Absolute y1 position of a box,0,1,0,0,0,0,0,0,0,TBox,,267,-38,-38,-38,-38,-38
S,TikzCoordinates,"Tikz string ""(x,y)"" represesenting absolute placement of the box",0,3,0,0,0,0,0,0,0,-1,,0,0,-1,,0,0,TBox,,298,-38,-38,-38,-38,-38
S,TeX,Tikz code for a TBox with all its children. depth is used when dualgraph.DebugBoxMargins is set to 'top'. standalone:=true wraps the output in tikz,0,1,0,0,0,0,0,0,0,TBox,,298,-38,-38,-38,-38,-38
S,SizeAndMarginsFromChildren,Compute dimensions and margins of a box from its children,0,1,0,0,1,0,0,1,1,TBox,,-38,-38,-38,-38,-38,-38
S,VerticalScale,Rescale a box vertically by a factor of r,0,2,0,0,1,0,0,0,0,-1,,1,1,TBox,,-38,-38,-38,-38,-38,-38
S,VerticalScaleTo,Rescale a box vertically to height H,0,2,0,0,1,0,0,0,0,-1,,1,1,TBox,,-38,-38,-38,-38,-38,-38
S,VerticalScaleTo,"Rescale sequence of boxes vertically to height H, not touching ones with no top anchors",1,0,1,82,0,TBox,2,0,0,1,0,0,0,0,-1,,1,1,82,,-38,-38,-38,-38,-38,-38
S,VerticalScaleTo,"Rescale sequence of boxes vertically to height H, not touching ones with no top anchors",0,2,0,0,1,0,0,0,0,-1,,1,1,168,,-38,-38,-38,-38,-38,-38
S,TBoxCreate,"Create an empty TeX Box. By default, it has an one anchor at the bottom left corner, and no top anchors",0,0,0,0,0,0,0,TBox,-38,-38,-38,-38,-38
S,Box,"Create a general box of given width, height, bottom and top anchors, margins, and a drawing in tikz code. The code should use TikzCoordinates(B,x,y) because absolute positions, width and height may change by  the time the box is drawn",0,6,0,0,0,0,0,0,0,41,,0,0,303,,0,0,82,,0,0,82,,0,0,-1,,0,0,-1,,TBox,-38,-38,-38,-38,-38
S,Copy,Duplicate a box with all its children,0,1,0,0,0,0,0,0,0,TBox,,TBox,-38,-38,-38,-38,-38
S,Box,Create box encompassing given children. Does not do anything to them except translate all of them so that all the box boundaries touch them,1,0,1,82,0,TBox,1,0,0,0,0,0,0,0,82,,TBox,-38,-38,-38,-38,-38
S,TLine,"General line primitive in the direction dx,dy and given label, margins, style and optional tikz code to put  at the end of the tikz draw primitive",0,6,0,0,0,0,0,0,0,303,,0,0,298,,0,0,298,,0,0,298,,0,0,-1,,0,0,-1,,TBox,-38,-38,-38,-38,-38
S,TDottedChain,"TBox with a chain of P1s in the direction dx,dy with given initial style and labels (multiplicity, count)",0,4,0,0,0,0,0,0,0,298,,0,0,298,,0,0,-1,,0,0,-1,,TBox,-38,-38,-38,-38,-38
S,TDottedLoop,Hexagon shape with dots on top for a variable length loop representing a node on a principal component. Indicates given multiplity and chain count,0,2,0,0,0,0,0,0,0,298,,0,0,298,,TBox,-38,-38,-38,-38,-38
S,TDTail,A TBox representing a D-tail,0,1,0,0,0,0,0,0,0,148,,298,-38,-38,-38,-38,-38
S,TArcComponent,An arc representing a P1s meeting a principal component in two points,0,3,0,0,0,0,0,0,0,298,,0,0,298,,0,0,298,,298,-38,-38,-38,-38,-38
S,TDashedLine,"TBox representing an empty P1 chain drawn as a blue dashed line, for two principal components meeting at a point",0,1,0,0,0,0,0,0,0,267,,298,-38,-38,-38,-38,-38
S,TLoop,TBox representing a node (thick loop) on a principal component,0,1,0,0,0,0,0,0,0,298,,298,-38,-38,-38,-38,-38
S,TChain,"TBox from chain of multiplicities - each one a number (multiplicity) or tuple <""dotted"",mult,len> for a dotted chain, e.g. m=[1,2,3] or [*3,2,<""dotted"",""1"",""n"">,2,3*]",0,3,0,0,0,0,0,0,0,36,,0,0,36,,0,0,-1,,TBox,-38,-38,-38,-38,-38
S,TPrincipalComponent,Thick horizontal line representing a principal component to be place in the box B. Returns its box and x-coordinate where it is to be placed,0,6,0,0,0,0,0,0,0,82,,0,0,82,,0,0,36,,0,0,-1,,0,0,-1,,0,0,TBox,,TBox,402,-38,-38,-38,-38
S,PlacePrincipalComponent,"Place a principal component w from a dual graph in the box B, with optional y-coordinate, covering the anchors of given sequences of boxes from below and above",0,5,0,0,1,0,0,0,0,298,,0,0,82,,0,0,82,,1,1,TBox,,0,0,GrphDual,,-38,-38,-38,-38,-38,-38
S,TNode,TBox with a special point (e.g. for a singular point),0,5,0,0,0,0,0,0,0,303,,0,0,-1,,0,0,-1,,0,0,298,,0,0,-1,,TBox,-38,-38,-38,-38,-38
S,TSingularPoint,"TBox with red singular point, and optional label above it",0,1,0,0,0,0,0,0,0,298,,TBox,-38,-38,-38,-38,-38
S,AddChild,"Place a new child box C into a parent box P. first:=true declares C should be the first child of P. Otherwise it is otherwise last (default), and placing starts as position (xpos,ypos), default (0,0)  and shifts it to the right of P.  Avoids collisions between bottom anchors of C and top anchors in avoid (sequence of boxes)",0,2,0,0,1,0,0,0,0,TBox,,1,1,TBox,,-38,-38,-38,-38,-38,-38
S,TeX,"Returns a tikz picture drawing a dual graph.  Set xscale, yscale and scale to control the size of the tikz picture.  Set oneline:=true to put the tikz picture into one (long) line of Tikz code. weight should be ""area"" (default), ""width"" or ""height"" and determines which parameter should be minimised. shownamed:=true forces all principal components that were set up with non-empty texname drawn as principal",0,1,0,0,0,0,0,0,0,GrphDual,,298,-38,-38,-38,-38,-38
