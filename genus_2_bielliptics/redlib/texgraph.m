/*
New TeX graph version
[F7] translate texgraph.py magma-to-py.gpt
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

*
* IMPLEMENTS
*
type TBox
intrinsic Print(B::TBox, level::MonStgElt)                                                                      [228]
  Print a TeX Box - #children, pos in parent, at width x height, bottom -> top anchors
*
* TeX a TBox and all its children
*
intrinsic AbsX(B::TBox) -> FldRatElt                                                                            [238]
  Absolute x1 position of a box
intrinsic AbsY(B::TBox) -> FldRatElt                                                                            [249]
  Absolute y1 position of a box
intrinsic TikzCoordinates(B::TBox, x, y: scale:=1) -> MonStgElt                                                 [260]
  Tikz string "(x,y)" represesenting absolute placement of the box
intrinsic TeX(B::TBox: depth:=1, standalone:=false) -> MonStgElt                                                [266]
*
* Setting margins, anchors and dimensions from children
*
intrinsic SizeAndMarginsFromChildren(~B::TBox)                                                                  [335]
  Compute dimensions and margins of a box from its children
*
* Scaling
*
intrinsic VerticalScale(~B::TBox, r)                                                                            [377]
  Rescale a box vertically by a factor of r
intrinsic VerticalScaleTo(~B::TBox, H)                                                                          [391]
  Rescale a box vertically to height H
intrinsic VerticalScaleTo(~C::SeqEnum[TBox], H)                                                                 [398]
  Rescale sequence of boxes vertically to height H, not touching ones with no top anchors
intrinsic VerticalScaleTo(~C::List, H)                                                                          [407]
  Rescale sequence of boxes vertically to height H, not touching ones with no top anchors
intrinsic HorizontalScale(~B::TBox, r)                                                                          [415]
  Rescale a box horizontally by a factor of r
*
* Creation functions
*
intrinsic TBoxCreate() -> TBox                                                                                  [440]
  Create an empty TeX Box. By default, it has an one anchor at the bottom left corner, and no top anchors.
intrinsic Box(width, height, banchors::SeqEnum, tanchors::SeqEnum, margins::Tup, tex::UserProgram) -> TBox      [453]
intrinsic Copy(b::TBox) -> TBox                                                                                 [484]
  Duplicate a box with all its children.
intrinsic Box(c::SeqEnum[TBox]) -> TBox                                                                         [501]
*
* Box primitives: TLine, TDottedChain, TPrincipalComponent, TNode, TSingularPoint
*
intrinsic TLine(dx, dy, label::MonStgElt, linestyle::MonStgElt, labelstyle::MonStgElt, margins::Tup: rightcode:="") -> TBox  [549]
intrinsic TDottedChain(dx, dy, multiplicity::MonStgElt, count::MonStgElt) -> TBox                               [612]
  TBox with a chain of P1s in the direction dx,dy with given initial style and labels (multiplicity, count)
intrinsic TDottedLoop(multiplicity::MonStgElt, count::MonStgElt) -> TBox                                        [630]
intrinsic TDTail(m::RngIntElt) -> MonStgElt                                                                     [664]
  A TBox representing a D-tail
intrinsic TArcComponent(linestyle::MonStgElt, label::MonStgElt, labelstyle::MonStgElt) -> MonStgElt             [700]
  An arc representing a P1s meeting a principal component in two points
intrinsic TDashedLine(l::FldRatElt) -> MonStgElt                                                                [725]
  TBox representing an empty P1 chain drawn as a blue dashed line, for two principal components meeting at a
  point.
intrinsic TLoop(style::MonStgElt) -> MonStgElt                                                                  [747]
  TBox representing a node (thick loop) on a principal component
intrinsic TChain(m::Any, linksup::BoolElt, loop::BoolElt: linestyle:="default", endlinestyle:="default", labelstyle:="default",   [841]
  linemargins:="default", P1linelength:="default", P1extlinelength:="default") -> TBox
intrinsic TPrincipalComponent(B::TBox, genus, mult, singular::BoolElt, childrenabove::SeqEnum, childrenbelow::SeqEnum: source:="") -> TBox, FldReElt  [1004]
  Thick horizontal line representing a principal component to be place in the box B. Returns its box and
  x-coordinate where it is to be placed.
intrinsic PlacePrincipalComponent(G::GrphDual, ~B::TBox, chb::SeqEnum, chu::SeqEnum, w::MonStgElt: ypos:=0)     [1052]
intrinsic TNode(style, label::MonStgElt, width, height, margins::Tup) -> TBox                                   [1078]
  TBox with a special point (e.g. for a singular point)
intrinsic TSingularPoint(label::MonStgElt) -> TBox                                                              [1084]
  TBox with red singular point, and optional label above it
*
* Placing children
*
intrinsic AddChild(~P::TBox, C::TBox: first:=false, avoid:=[], xpos:=0, ypos:=0)                                [1122]
intrinsic TeX(G::GrphDual: xscale:="default", yscale:="default", root:="default", scale:="default", oneline:=false, weight:="area", texsettings:=[], box:=false) -> MonStgElt  [1544]
*/


/*
Execute This and the following long comments are used for automatic manual generation and executing examples
errorcode:=0;
writernq("manual-examples.merr",1); 
AttachSpec("redlib.spec");
<TESTS>; 
<EXAMPLES>; 
writernq("manual-examples.merr",errorcode);
quit;
*/


declare type TBox;                   // TeX Box

declare attributes TBox: 
  c,parent,     // children, parent
  banchors,     // [x1,x2,...] x-coordinates of anchors at the bottom
  tanchors,     // x-coordinates anchors at the top, possibly empty (if open chain)
  width,height, // width and height
  left,right,   // left, right edges = [[x,y1,y2,y1a,y2a],...] set of segments
                //   indicating that other boxes should not cross the line (x,y1)-(x,y2)
                //   y1a, y1b are anchor points used in scaling 
                // segments y1-y1a, y2a-y2 are not scaled in VerticalScale
                //      **** all of the above are measured from 0,0 ***
  x1,y1,        // where currently placed in the parent
  tex,          // function(B) -> draw everything necessary except children, returns tikz string
                // additional data for components
  style;        // tuple of box-specific parameters that tex(B) can access 


import "mmylib.m": DelSpaces, SortSet, Last, trim, Left, ReplaceString, 
  PrintSequence, DelCRs, PrintReal, dxdyToAngle, IncludeAssoc, Count, SortBy;


/*
Manual
\begin{verbatim}
type TBox: 
  c,parent,     // children, parent
  banchors,     // [x1,x2,...] x-coordinates of anchors at the bottom
  tanchors,     // x-coordinates anchors at the top, possibly empty (if open chain)
  width,height, // width and height in tikz units
  left,right,   // left, right edges = [[x,y1,y2,y1a,y2a],...] set of segments
                //   indicating that other boxes should not cross (x,y1)-(x,y2)
                //   y1a, y1b are anchor points used in scaling 
                // segments y1-y1a, y2a-y2 are not scaled in VerticalScale
                //      **** all of the above are measured from 0,0 ***
  x1,y1,        // where currently placed in the parent
  tex,          // function(B) -> draw everything necessary except children, 
                // returns tikz string
  style;        // tuple of box-specific parameters that tex(B) can access
\end{verbatim}
*/


function get(s)
  return GetSetting("dualgraph."*s);
end function;


// General Tikz options: TikzOptions, TikzTransform


function TikzOptions(options)
  // Print a sequence of tikz options "[..., ..., ]" if non-empty
  if Type(options) eq MonStgElt then options:=[options]; end if;
  L:=[];
  for o in options do
    if #o eq 0 then continue; end if;
    if o[1] eq "[" and o[#o] eq "]" 
      then Append(~L,o[[2..#o-1]]); 
      else Append(~L,o);
    end if;
  end for;
  if IsEmpty(L) then return ""; end if;
  return "["*PrintSequence(L: sep:=",")*"]";
end function;


function TikzTransform(s,rx,ry,phi: prec:=2)
  // Scale by rx,ry and rotate by phi (degrees) a tikz picture in s
  // Affects numeric positions (0.23,-0.12) and anchor strings anchor=west

  error if Type(s) ne MonStgElt, "RotateTikz: Expected a tikz string in s";

  t:="";                               // accummulated output
  rad:=phi*Pi(RealField())/180;

  // Stage 1: Rotate numeric positions (x,y)
  repeat
    ok,_,B:=Regexp("(.*)[(](-?[.0-9]+),(-?[.0-9]+)[)](.*)",s);
    if not ok then t:=s*t; break; end if;
    x:=eval B[2];
    y:=eval B[3];
    xnew:=rx*x*Cos(rad)-ry*y*Sin(rad);
    ynew:=rx*x*Sin(rad)+ry*y*Cos(rad);
    t:=Sprintf("(%o,%o)%o%o",PrintReal(xnew: prec:=prec),PrintReal(ynew: prec:=prec),B[4],t);
    s:=B[1];
  until false;

  // Stage 2: rotate anchors anchor=north etc.
  s:=t;
  t:="";
  Directions:=[<"east",0>,<"north east",45>,<"north",90>,<"north west",135>,<"west",180>,
    <"south west",225>,<"south",270>,<"south east",315>];
  repeat
    ok,_,B:=Regexp("(.*)anchor[ ]*=[ ]*([a-zA-Z]+)(.*)",s);
    ok:=ok and (exists(a){d[2]: d in Directions | d[1] eq x} where x is ToLower(B[2]));
    if not ok then t:=s*t; break; end if;
    anew:=45*Round((a + phi)/45); 
    assert exists(d){d[1]: d in Directions | anew mod 360 eq d[2]};
    t:=Sprintf("anchor=%o%o%o",d,B[3],t);
    s:=B[1];
  until false;
  return t;
  
end function;


// Basic type functions (TBox)


intrinsic IsCoercible(M::TBox, y::.) -> BoolElt, .        //
{Coerce a TeX Box.}
  return false, _; 
end intrinsic;

  
intrinsic 'in'(x::TBox, y::.) -> BoolElt                  //
{"in" function for a TeX Box.}
  return false; 
end intrinsic;


function RR(x)
  if Type(x) in [RngIntElt, FldRatElt, MonStgElt] then 
    return Sprint(x);
  elif Type(x) eq FldReElt then
    return PrintReal(x: prec:=2);
  else
    error Sprintf("RR: Don't know how to print %o of type %o",DelCRs(x),Type(x));
  end if;
end function;


intrinsic Print(B::TBox, level::MonStgElt)
{Print a TeX Box - #children, pos in parent, at width x height, bottom -> top anchors}
  printf "TBox[%o] at (%o,%o) size %ox%o %o->%o",#B`c,
    RR(B`x1),RR(B`y1),RR(B`width),RR(B`height),DelSpaces([RR(x): x in B`banchors]),DelSpaces([RR(x): x in B`tanchors]);
end intrinsic;


/// TeX a TBox and all its children


intrinsic AbsX(B::TBox) -> FldRatElt
{Absolute x1 position of a box}
  x:=0;
  while Type(B) eq TBox do
    x:=x+B`x1;
    B:=B`parent;
  end while;
  return x;
end intrinsic;


intrinsic AbsY(B::TBox) -> FldRatElt
{Absolute y1 position of a box}
  y:=0;
  while Type(B) eq TBox do
    y:=y+B`y1;
    B:=B`parent;
  end while;
  return y;
end intrinsic;


intrinsic TikzCoordinates(B::TBox, x, y: scale:=1) -> MonStgElt
{Tikz string "(x,y)" represesenting absolute placement of the box}
  return Sprintf("(%o,%o)",RR(scale*(x+AbsX(B))),RR(scale*(y+AbsY(B))));
end intrinsic;


intrinsic TeX(B::TBox: depth:=1, standalone:=false) -> MonStgElt
{Tikz code for a TBox with all its children. depth is used when dualgraph.DebugBoxMargins is set to 'top'.
standalone:=true wraps the output in \tikz.}

  s:="";

  // Box margins for debugging
  show:=get("DebugBoxMargins");
  if show eq "all" or show eq "top" and depth eq 1 then
    DebugMarginLineColor:=get("DebugMarginLineColor"); 
    DebugMarginShadeColor:=get("DebugMarginShadeColor");
    DebugMarginShadeWidth:=eval get("DebugMarginShadeWidth");
    s*:=Sprintf("\\draw[%o] %o rectangle %o;",DebugMarginLineColor,TikzCoordinates(B,0,0),TikzCoordinates(B,B`width,B`height));
    for m in B`left cat B`right do     // margins
      x,y1,y2,_,_:=Explode(m);
      sgn:=m in B`left select 1 else -1;
      s*:=Sprintf("\\fill[%o] %o rectangle %o;",DebugMarginShadeColor,TikzCoordinates(B,x,y1),TikzCoordinates(B,x+sgn*DebugMarginShadeWidth,y2));
      s*:=Sprintf("\\draw[%o] %o--%o;",DebugMarginLineColor,TikzCoordinates(B,x,y1),TikzCoordinates(B,x,y2));
    end for;    
    for x in B`banchors do
      s*:=Sprintf("\\draw%o %o circle [radius=%o];\n",TikzOptions(get("DebugBAnchorColor")),TikzCoordinates(B,x,0),get("DebugAnchorRadius"));
    end for;
    for x in B`tanchors do
      s*:=Sprintf("\\draw%o %o circle [radius=%o];\n",TikzOptions(get("DebugTAnchorColor")),TikzCoordinates(B,x,B`height),get("DebugAnchorRadius"));
    end for;
  end if;

  s*:=B`tex(B);                   // Box itself
  for b in B`c do
    s*:=TeX(b: depth:=depth+1);       // followed by all the children
  end for;

  if standalone
    then return "\\tikz{\n"*s*"}";
    else return s;
  end if; 
end intrinsic;


/// Setting margins, anchors and dimensions from children


function RefineMargin(S,minmax)   // mm = "Min" or "Max",
  // S = [[x,y1,y2,y1a,y2a],...]
  Ys:=SortSet(&join[{d[2],d[3]}: d in S]);        // Extract all y1s,y2s and sort them
  need:={};
  for y in Ys do                                   
    I:=[i: i->m in S | y ge m[2] and y le m[3]];  // find all segments that contain y 
    _,j:=minmax([S[i][1]: i in I]);               // smallest/largest x-coordinate index
    Include(~need,I[j]);                          // these are the segments that we need to keep
  end for;
  return S[SortSet(need)];  
end function;


function LeftMarginWRXY(B)
  x:=B`x1;
  y:=B`y1;
  return [[d[1]+x,d[2]+y,d[3]+y,d[4]+y,d[5]+y]: d in B`left];
end function;


function RightMarginWRXY(B)
  x:=B`x1;
  y:=B`y1;
  return [[d[1]+x,d[2]+y,d[3]+y,d[4]+y,d[5]+y]: d in B`right];
end function;


intrinsic SizeAndMarginsFromChildren(~B::TBox)
{Compute dimensions and margins of a box from its children}
  c:=B`c;
  // box size
  B`width:=Max([b`x1+b`width: b in c]);
  B`height:=Max([b`y1+b`height: b in c]);
  // margins
  B`left:=RefineMargin(&cat [LeftMarginWRXY(b): b in c],Min);
  B`right:=RefineMargin(&cat [RightMarginWRXY(b): b in c],Max);
end intrinsic;


procedure SetBottomAnchorsFromBoxes(~B,ch); 
  B`banchors:=[b`x1+a: a in b`banchors, b in ch];
end procedure;


procedure SetTopAnchorsFromBoxes(~B,ch); 
  B`tanchors:=[b`x1+a: a in b`tanchors, b in ch];
end procedure;


/// Scaling


function VerticalScaleSegment(S,r)
  // scale one segment x,y1,y2,y1a,y2a vertically by a factor of r
  x,y1,y2,y1a,y2a:=Explode(S);
  //"Scaling",x,y1,y2,y1a,y2a,"by",r;
  error if y1a lt y1, "VerticalScaleSegment: expected y1a>=y1 in "*Sprint(S);
  eps1:=y1a-y1;
  error if y2a gt y2, "VerticalScaleSegment: expected y2a<=y2 in "*Sprint(S);
  eps2:=y2-y2a;
  y1a:=r*y1a;     // keep x, scale y anchor points
  y2a:=r*y2a;
  y1:=y1a-eps1;    // segments y1-y1a, y2-y2a of length eps1, eps2 do not scale
  y2:=y2a+eps2;
  //"Got    ",x,y1,y2,y1a,y2a;
  return [x,y1,y2,y1a,y2a]; 
end function;


intrinsic VerticalScale(~B::TBox, r)
{Rescale a box vertically by a factor of r}
  if r eq 1 then return; end if;
  H:=B`height;
  B`y1*:=r;                                // position in parent and total height
  B`height*:=r;                            
  for i:=1 to #B`c do                      // children
    VerticalScale(~B`c[i],r);
  end for;
  B`left:=[VerticalScaleSegment(S,r): S in B`left];
  B`right:=[VerticalScaleSegment(S,r): S in B`right];
end intrinsic;


intrinsic VerticalScaleTo(~B::TBox, H)
{Rescale a box vertically to height H}
  if B`height in [0,H] then return; end if;
  VerticalScale(~B,H/B`height);
end intrinsic;


intrinsic VerticalScaleTo(~C::SeqEnum[TBox], H)
{Rescale sequence of boxes vertically to height H, not touching ones with no top anchors}
  for i:=1 to #C do
    if IsEmpty(C[i]`tanchors) then continue; end if;
    VerticalScaleTo(~C[i],H);
  end for;
end intrinsic;


intrinsic VerticalScaleTo(~C::List, H)
{Rescale sequence of boxes vertically to height H, not touching ones with no top anchors}
  S:=[c: c in C | Type(c) eq TBox];
  VerticalScaleTo(~S,H);
end intrinsic;


/*
intrinsic HorizontalScale(~B::TBox, r)
{Rescale a box horizontally by a factor of r}
  if r eq 1 then return; end if;
  B`x1*:=r;                                // position in parent and total height
  B`width*:=r;                            
  B`banchors:=[r*x: x in B`banchors];
  B`tanchors:=[r*x: x in B`tanchors];
  for i:=1 to #B`c do                      // children
    HorizontalScale(~B`c[i],r);
  end for;
  for i:=1 to #B`left do                   // left margin
    x,y1,y2:=Explode(B`left[i]);
    B`left[i]:=[r*x,y1,y2];
  end for;
  for i:=1 to #B`right do                  // right margin
    x,y1,y2:=Explode(B`right[i]);
    B`right[i]:=[r*x,y1,y2];
  end for;
end intrinsic;
*/


/// Creation functions


intrinsic TBoxCreate() -> TBox
{Create an empty TeX Box. By default, it has an one anchor at the bottom left corner, and no top anchors.}
  B:=New(TBox); 
  B`c:=[]; B`left:=[]; B`right:=[]; 
  B`banchors:=[0]; B`tanchors:=[]; 
  B`parent:=false;
  B`x1:=0; B`y1:=0; B`width:=0; B`height:=0;
  B`tex:=func<B|"">;
  B`style:=<>;
  return B;
end intrinsic;


intrinsic Box(width, height, banchors::SeqEnum, tanchors::SeqEnum, margins::Tup, tex::UserProgram) -> TBox
{Create a general box of given width, height, bottom and top anchors, margins, and a drawing in tikz code.
The code should use TikzCoordinates(B,x,y) because absolute positions, width and height may change by 
the time the box is drawn.}
  error if width eq 0 and height eq 0 or width lt 0 or height lt 0,
    Sprintf("Box: invalid dimensions width=%o, height=%o",width,height);
  B:=TBoxCreate();
  leftmargin,rightmargin,topmargin,bottommargin:=Explode(margins);
  B`left:=[[-leftmargin,-bottommargin,height+topmargin,0,height]];
  B`right:=[[width+rightmargin,-bottommargin,height+topmargin,0,height]];
  B`banchors:=banchors;
  B`tanchors:=tanchors;
  B`tex:=tex;
  B`width:=width;
  B`height:=height;
  return B;
end intrinsic;


/*
Example
// The following creates a 2x1 box with a margin of 1/2 on each side and $x$ in the middle.
BoxDraw:=func<B|Sprintf("\\node at %o {x};",TikzCoordinates(B,1,1/2))>;
B:=Box(2,1,[0,1/2,1],[1/2],<1/2,1/2,1/2,1/2>,BoxDraw);
// Set margins, box boundary and bottom/top anchors to visible
SetSetting("dualgraph.DebugBoxMargins","all");
TeX(B: standalone);
SetSetting("dualgraph.DebugBoxMargins","none");
*/


intrinsic Copy(b::TBox) -> TBox
{Duplicate a box with all its children.}
  B:=Box(b`width,b`height,b`banchors,b`tanchors,<0,0,0,0>,b`tex);
  B`x1:=b`x1;
  B`y1:=b`y1;
  B`left:=b`left;
  B`right:=b`right;
  B`parent:=false;
  B`style:=b`style;
  B`c:=[Copy(ch): ch in b`c];
  for i:=1 to #B`c do 
    B`c[i]`parent:=B;
  end for;
  return B;
end intrinsic;


intrinsic Box(c::SeqEnum[TBox]) -> TBox
{Create box encompassing given children. Does not do anything to them except translate all of them so that all
the box boundaries touch them.}
  error if IsEmpty(c), "No children to create box from";
  B:=TBoxCreate();
  minx1:=Min([b`x1: b in c]);       // translate the children so that the box 
  miny1:=Min([b`y1: b in c]);       //   starts at (0,0), and set parent
  for i:=1 to #c do
    error if c[i]`parent cmpne false,
      Sprintf("Box(SeqEnum): %o already has set parent=%o",c[i],c[i]`parent);
    c[i]`x1-:=minx1; c[i]`y1-:=miny1; c[i]`parent:=B;
  end for;
  B`c:=c;
  SizeAndMarginsFromChildren(~B);
  return B;
end intrinsic;


/*
Example Three of the boxes above with Copy and AddChild
BoxDraw:=func<B|Sprintf("\\node at %o {x};",TikzCoordinates(B,1,1/2))>;
B:=Box(2,1,[0,1/2,1],[1/2],<1/2,1/2,1/2,1/2>,BoxDraw);
P:=TBoxCreate();
AddChild(~P,B);
AddChild(~P,Copy(B): ypos:=1/4);
AddChild(~P,Copy(B): ypos:=1/2);
SetSetting("dualgraph.DebugBoxMargins","all");
TeX(P: standalone);
SetSetting("dualgraph.DebugBoxMargins","none");
*/


/// Box primitives: TLine, TDottedChain, TPrincipalComponent, TNode, TSingularPoint


function TLineTeX(B)
  linestyle,label,labelstyle,rightcode:=Explode(B`style);
  vprintf redlib,2: "TLine %o-%o {%o}\n",TikzCoordinates(B,B`banchors[1],0),TikzCoordinates(B,B`tanchors[1],B`height),label;
  if label ne "" then label:=Sprintf("node%o {%o} ",TikzOptions(labelstyle),label); end if;
  if rightcode ne "" and rightcode[1] ne " " then rightcode:=" "*rightcode; end if;
  x1:=B`banchors[1];
  y1:=0;
  x2:=B`tanchors[1];
  y2:=B`height;
  return Sprintf("\\draw%o %o--%o%o%o;\n",TikzOptions(linestyle),TikzCoordinates(B,x1,y1),label,TikzCoordinates(B,x2,y2),rightcode);
end function;


intrinsic TLine(dx, dy, label::MonStgElt, linestyle::MonStgElt, labelstyle::MonStgElt, margins::Tup: rightcode:="") -> TBox
{General line primitive in the direction dx,dy and given label, margins, style and optional tikz code to put 
at the end of the tikz draw primitive.}
  width:=Abs(dx);
  height:=Abs(dy);
  if (dy ge 0 and dx ge 0) or (dy lt 0 and dx lt 0) then    // Right upwards, straight right, straight up or left downwards
    banchors:=[0];
    tanchors:=[width];
  else  
    banchors:=[width];
    tanchors:=[0];
  end if;
  B:=Box(width,height,banchors,tanchors,margins,TLineTeX);
  B`style:=<linestyle,label,labelstyle,rightcode>;
  return B;
end intrinsic;


/*
Example TLine
linestyle:="thick";
labelstyle:="above left";
margins:=<1/2,1/2,1/2,1/2>;
B:=TLine(1, 1, "a", linestyle, labelstyle, margins: rightcode:=" node [right] {g1}");
TeX(B: standalone);
*/


function DottedChainTeX(B)                        // Dotted chain (chain of unknown length)
  // color and other style settings, if any
  dx,dy,chainmult,chainlen:=Explode(B`style);
  // Line (x1,y1)->(x2,y2)
  x1:=dx lt 0 select B`width else 0;
  y1:=dy lt 0 select B`height else 0;
  x2:=dx gt 0 select B`width else 0;
  y2:=dy gt 0 select B`height else 0;
  len:=Sqrt(B`width^2+B`height^2); 
  ang:=dxdyToAngle(x2-x1,y2-y1);
  style:=get("chdotlinestyle");
  chmultstyle:=get("chdotmultstyle");
  chlenstyle:=get("chdotlenstyle");
  src:="\\draw%o %o 
    ++(0.11,-0.11)--++(-0.38,0.41)++(0.18,-0.15)  
    ++(0,0.02)
      node[%o,inner sep=1,anchor=west]{%o}
    ++(0,-0.02)
    ++(-0.18,-0.01)--++(0.36,0.38)++(-0.15,0.04)  
    node{$\\cdot$} ++(-0.1,0.1) node{$\\cdot$}
    ++(-0.10,0.10) node{$\\cdot$}++(0.2,-0.06)    node[%o,anchor=west]{%o}
    ++(-0.3,0.12)--++(0.36,0.38)++(-0.20,-0.00)   
    ++(0.02,-0.04)
      node[%o,inner sep=1,anchor=east]{%o}
    ++(-0.02,0.04)
    ++(0.20,0.00)++(0,-0.15)--++(-0.38,0.41);\n";
  r:=len/1.41;
  phi:=ang-90-13;
  shrinkfactor:=Min(1,1/r);
  shr:=TikzTransform(src,shrinkfactor,1,0);      // shrink vertically if too large
  rot:=TikzTransform(shr,r,r,phi);               // rotate absolute positions and anchors
  return Sprintf(rot,TikzOptions(style),TikzCoordinates(B,x1,y1),chmultstyle,chainmult,chlenstyle,chainlen,chmultstyle,chainmult);
end function;


intrinsic TDottedChain(dx, dy, multiplicity::MonStgElt, count::MonStgElt) -> TBox
{TBox with a chain of P1s in the direction dx,dy with given initial style and labels (multiplicity, count)}
  margins:=eval get("chdotmargins"); 
  banchors:=dx lt 0 select [Abs(dx)] else [0];
  tanchors:=dx lt 0 select [0] else [Abs(dx)];
  B:=Box(Abs(dx),Abs(dy),banchors,tanchors,margins,DottedChainTeX);
  B`style:=<dx,dy,multiplicity,count>;
  return B;
end intrinsic;


/*
Example TDottedChain
B:=TDottedChain(1,1,"1","n");
TeX(B: standalone);
*/


intrinsic TDottedLoop(multiplicity::MonStgElt, count::MonStgElt) -> TBox
{Hexagon shape with dots on top for a variable length loop representing a node on a principal component.
Indicates given multiplity and chain count.}
  chdotmultstyle_east:=TikzOptions(["anchor=east",get("chdotmultstyle")]);
  chdotmultstyle_west:=TikzOptions(["anchor=west",get("chdotmultstyle")]);
  chdotlenstyle:=TikzOptions(get("chdotlooplenstyle"));
  scale:=eval get("chdotloopscale");
  if Abs(scale-1) gt 0.001 
    then scalestr:=Sprintf("scale=%o",RR(scale));
    else scalestr:="";
  end if;
  chdotlinestyle:=TikzOptions(get("chdotlinestyle"));
  s:="\\draw%o %o "* 
      "++(0.05,0.3) node%o {%o} "*
      "++(0.3,-0.45)--++(115:0.75)++(295:0.15)++(245:0.15)--++(65:0.75)++(245:0.15)++(180:0.15)"*
      "--++(0:0.22) ++(0:0.15) node{$\\cdot$} ++(0:0.15) node{$\\cdot$} "*
      "node%o{%o}"*
      "++(0:0.15) node{$\\cdot$} ++(0:0.15) "*
      "--++(0:0.22)++(180:0.15)++(115:0.15)--++(295:0.75)++(115:0.15)++(65:0.15)--++(245:0.75)"*
      "++(0.3,0.45) node%o {%o};";
  tex:=func<B|Sprintf(s,TikzOptions([scalestr,chdotlinestyle]),TikzCoordinates(B,0,0: scale:=1/scale),chdotmultstyle_east, 
    multiplicity,chdotlenstyle,count,chdotmultstyle_west,multiplicity)>;
  margins:=eval get("chdotloopmargins");
  return Box(13/10*scale, scale, [3/10*scale,105/100*scale], [], margins, tex);
end intrinsic;


/*
Example TDottedLoop
B:=TDottedLoop("1","n");
TeX(B: standalone);
*/


intrinsic TDTail(m::RngIntElt) -> MonStgElt
{A TBox representing a D-tail}
  error if m lt 2 or IsOdd(m), "TDTail: expected even multiplicity";
  labelstyle:=get("P1multstyle");
  P1style:=get("P1endlinestyle");
  P1length:=eval get("P1linelength");
  prinlength:=eval get("dtailprinlength");
  margins:=eval get("dtailmargins");
  prinlinestyle:=get("dtailprinlinestyle");
  B1 := TLine(prinlength, 0, Sprint(m), prinlinestyle, TikzOptions([labelstyle,"above","pos=0.6"]), margins);
  B2 := TLine(0,P1length, Sprint(m div 2), P1style, TikzOptions([labelstyle,"left"]), margins);
  B2`x1:=1/5;
  B3 := TLine(0,P1length, Sprint(m div 2), P1style, TikzOptions([labelstyle,"right"]), margins);
  B3`x1:=prinlength-1/5;
  B:=Box([B1,B2,B3]);
  B`banchors:=[prinlength/2-1/10];
  B`tanchors:=[];
  return B;
end intrinsic;


/*
Example D-tail
B:=TDTail(2);
SetSetting("dualgraph.DebugBoxMargins","top");
TeX(B: standalone);
SetSetting("dualgraph.DebugBoxMargins","none");
*/


/*
Example Multiple D-tails
TeX(DualGraph(ReductionType("24^1,11,20,18,22_D,D,D")));
*/


intrinsic TArcComponent(linestyle::MonStgElt, label::MonStgElt, labelstyle::MonStgElt) -> MonStgElt
{An arc representing a P1s meeting a principal component in two points}
  s:="\\draw%o %o ++(1,0) arc (0:180:0.5) node%o {%o};";    
  labelstyle:=TikzOptions([labelstyle,"midway","above"]);
  margins:=eval get("P1arcmargins");
  tex:=func<B|Sprintf(s,TikzOptions(linestyle),TikzCoordinates(B,0,0),TikzOptions(labelstyle),label)>;
  B:=Box(1, 1, [0,1], [], margins, tex);
  return B;
end intrinsic;


/*
Example TArcComponent
B:=TArcComponent("blue","1","above");
TeX(B: standalone);
*/


function TSpecialLinkBox(data,dx,dy)
  error if #data ne 3 or data[1] cmpne "dotted", 
    "Dotted chain: "*Sprint(data)*" should be a 3-tuple <\"dotted\",multiplicity, length>";
  return TDottedChain(dx,dy,Sprint(data[2]),Sprint(data[3]));
end function;


intrinsic TDashedLine(l::FldRatElt) -> MonStgElt
{TBox representing an empty P1 chain drawn as a blue dashed line, for two principal components meeting at a point.}
  vprint redlib,2: "TDashedLine: empty P1 chain (two components meeting at a point)";
  style:="blue!80!white,densely dashed";
  s:="\\draw%o %o--%o;";
  tex:=func<B|Sprintf(s,TikzOptions(style),TikzCoordinates(B,0,0),TikzCoordinates(B,B`width,B`height))>;
  return Box(0,l,[0],[0], <1/3,1/3,1/3,1/3>, tex);       
end intrinsic;


/*
Example TDashedLine
B:=TDashedLine(5/4);
TeX(B: standalone);
*/


function TeXPath(style,format)
  return func<B|Sprintf("\\path%o %o;\n",TikzOptions(["draw",style]),Sprintf(format,TikzCoordinates(B,0,0)))>;
end function;


intrinsic TLoop(style::MonStgElt) -> MonStgElt
{TBox representing a node (thick loop) on a principal component}
  return Box(0.6, 1, [0,0.6], [], <1/3,1/3,1/3,1/3>,    // node (thick loop) on a principal component
    TeXPath(style,"%o edge[white,line width=2] ++(0.6,0) "*
        "edge[out=0,in=-90] ++(0.6,0.4) ++(0.6,0.4) edge[out=90,in=0] ++(-0.3,0.3) ++(-0.3,0.3) "*
        "edge[out=180,in=90] ++(-0.3,-0.3) ++(-0.3,-0.3) edge[out=-90,in=180] ++(0.6,-0.4)")
  );
end intrinsic;  


/*
Example TLoop
B:=TLoop("thick");
TeX(B: standalone);
*/


function LoopDirections(N)
  // directions to draw a loop with N components on a principal component, N>=2.
  // returns array e.g. ["U","R","D"] for N=3, indicating component going up, then right, then down
  // Left, Right, Up, Down, Skew combinations. Small letters r,l,b,a indicate position of the label
  //   right, left, below and above respectively, instead of a standard (opposite) one 

  assert N ge 2;  
  r8:=N mod 8;
  d8:=N div 8 - (N mod 8 in [4,5,6,7] select 0 else 1);
  URUL:=&cat[["U","R","Ur","L"]: i in [1..d8]];
  ULUR:=&cat[["Ur","L","U","R"]: i in [1..d8]];
  LDRD:=&cat[["L","Dl","R","D"]: i in [1..d8]];
  RDLD:=&cat[["R","D","L","Dl"]: i in [1..d8]];
 
  if N in [2..9] then dir:=
    [["LSU","LSD"],                                     // 2 : chains by hand for N=2..9
     ["U","R","D"],                                     // 3
     ["U","RU","RD","D"],                               // 4
     ["LSU","RSU","R","RSDa","LSD"],                    // 5
     ["LSU","U","RU","RD","D","LSD"],                   // 6
     ["LSU","U","RU","R","RD","D","LSD"],               // 7
     ["U","R","Ur","RU","RD","Dl","R","D"],             // 8
     ["U","LU","U","RU","R","RD","D","LD","D"]]         // 9
   [N-1];
  elif r8 eq 0 then
    dir:=URUL cat ["U","R","Ur","RU","RD","Dl","R","D"] cat LDRD;                   // 16, 24, ...
  elif r8 eq 1 then
    dir:=URUL cat ["LSU","RSU","R","RSUb","R","RSD","R","RSDa","LSD"] cat LDRD;     // 17
  elif r8 eq 2 then
    dir:=ULUR cat ["Ur","L","U","R","RU","RD","R","D","L","Dl"] cat RDLD;           // 10, 18
  elif r8 eq 3 then    
    dir:=ULUR cat ["Ur","L","U","R","RSU","R","RSDa","R","D","L","Dl"] cat RDLD;    // 11, 19
  elif r8 eq 4 then
    dir:=["RU"] cat ULUR cat ["RU","RD"] cat RDLD cat ["RD"];                       // 12
  elif r8 eq 5 then
    dir:=["LSU"] cat ULUR cat ["RSU","R","RSDa"] cat RDLD cat ["LSD"];              // 13
  elif r8 eq 6 then
    dir:=URUL cat ["U","R","RU","RD","R","D"] cat LDRD;                             // 14
  else
    dir:=URUL cat ["U","R","RSUb","R","RSD","R","D"] cat LDRD;                      // 15
  end if; 
  
  return dir;
end function;


function DirectionsTodxdylabel(d, l)
  // Convert direction d returned by LoopDirections and length l to dx,dy,label

  l34:=3/4*l;
  l2:=l/2;
    
  if   d eq "L"     then dx:=-l;  dy:=0;   label:="above";
  elif d eq "U"     then dx:=0;   dy:=l;   label:="left";
  elif d eq "Ur"    then dx:=0;   dy:=l;   label:="right";
  elif d eq "D"     then dx:=0;   dy:=-l;  label:="right";
  elif d eq "Dl"    then dx:=0;   dy:=-l;  label:="left";
  elif d eq "R"     then dx:=l;   dy:=0;   label:="above";
  elif d eq "RU"    then dx:=l34;   dy:=l34;   label:="above left=0pt and -1pt";
  elif d eq "RUb"   then dx:=l34;   dy:=l34;   label:="below right=-1pt and -1pt";
  elif d eq "RD"    then dx:=l34;   dy:=-l34;  label:="above right=0pt and -1pt";
  elif d eq "LU"    then dx:=-l34;  dy:=l34;   label:="below left=0pt and -1pt"; 
  elif d eq "LUb"   then dx:=-l34;  dy:=l34;   label:="below left=-1pt and -1pt"; 
  elif d eq "LD"    then dx:=-l34;  dy:=-l34;  label:="below right=0pt and -1pt";  
  elif d eq "LSU"   then dx:=-l2; dy:=l;   label:="above right"; 
  elif d eq "LSD"   then dx:=-l2; dy:=-l;  label:="above left";  
  elif d eq "RSU"   then dx:=l2;  dy:=l;   label:="above left"; 
  elif d eq "RSUb"  then dx:=l2;  dy:=l;   label:="below right"; 
  elif d eq "RSD"   then dx:=l2;  dy:=-l;  label:="below left"; 
  elif d eq "RSDa"  then dx:=l2;  dy:=-l;  label:="above right"; 
  else error "Unrecognized direction "*d; 
  end if;
  
  return dx,dy,label;
end function;


intrinsic TChain(m::Any, linksup::BoolElt, loop::BoolElt: linestyle:="default", endlinestyle:="default", labelstyle:="default", 
  linemargins:="default", P1linelength:="default", P1extlinelength:="default") -> TBox
{TBox from chain of multiplicities - each one a number (multiplicity) or tuple <"dotted",mult,len> for a dotted chain,
e.g. m=[1,2,3] or [*3,2,<"dotted","1","n">,2,3*]}

  error if Type(m) notin [SeqEnum,List], "Box: chain "*Sprint(m)*" is neither a List nor SeqEnum of multiplicities";

  if linestyle eq "default" then
    linestyle:=get("P1linestyle");                        // e.g. "shorten <=-2pt,shorten >=-2pt"
  end if;
  if endlinestyle eq "default" then
    endlinestyle:=get("P1endlinestyle");                  // e.g. "shorten <=-2pt
  end if;
  if labelstyle eq "default" then 
    labelstyle:=get("P1multstyle");                      // e.g. "inner sep=2pt,scale=0.8,blue"
  end if;
  if linemargins eq "default" then
    linemargins:=get("P1linemargins");                    // e.g. "<2/5,2/5,1/3,1/3>"
  end if;
  if P1linelength eq "default" then
    P1linelength:=get("P1linelength");                    // e.g. "2/3"
  end if;
  if P1extlinelength eq "default" then
    P1extlinelength:=get("P1extlinelength");              // e.g. "1"
  end if;

  linemargins:=eval linemargins;          // tuple <left,right,top,bottom>
  P1linelength:=eval P1linelength;        // length in tikz units
  P1extlinelength:=eval P1extlinelength;  // extended when the only component between two principal ones

  if not loop and #m eq 0 then
    return TDashedLine(P1extlinelength);  // two components meeting at a point => dashed line
  end if;

  if loop and #m eq 0 then
    return TLoop(get("looplinestyle"));   // node (thick loop) on a principal component
  end if;

  isspecial:=func<i|i ge 1 and i le #m and Type(m[i]) eq Tup>;       // i -> is m[i] special tuple <len,mult> ?

  if loop and #m eq 1 and isspecial(1) then              // loop of variable length <mult, len>
    error if m[1][1] cmpne "dotted",
      Sprintf("Got m=%o expected to start with 'dotted'",DelSpaces(m));
    return TDottedLoop(Sprint(m[1][2]),Sprint(m[1][3]));
  end if;

  if #m eq 1 and loop then                                     // arc on a principal component
    return TArcComponent(linestyle,Sprint(m[1]),labelstyle);
  end if;   

  x:=0;
  y:=0;
  c:=[];

  // OPEN CHAIN OR TO CHAIN TO ANOTHER COMPONENT 

  if not loop then  

    for i:=1 to #m do
      d:=["Ur","L","U","R"][(i-1) mod 4 + 1];     // P1s go up, left, up, right, ...
      len := P1linelength;
      if (linksup and i mod 4 eq 1 and #m eq 1) or               // extra long when only one P1
        not isspecial(i) and (isspecial(i-1) or isspecial(i+1))  //! or when neighbours a dotted chain
        then len:=P1extlinelength; end if;     
      if linksup and i eq #m and IsEven(i) then d*:="Ub"; end if;        // tilt last line up if horizontal to meet next principal component
      dx,dy,labelpos:=DirectionsTodxdylabel(d, len);
      //if IsEven(i) and isspecial(i+1) then labelpos:="below"; end if;    // move label below to avoid clash with dotted chains
      if (i eq #m) and not isspecial(i) and not linksup then             // make last line shorter in an open chain
        linestyle:=endlinestyle;
      end if;
      thislabelstyle:=TikzOptions([labelstyle,labelpos]);
      if isspecial(i) then              // variable length chain link or other specials - stretch vertically
        dfactor:=eval get("chdotlengthfactor");
        if dx lt 0 and dy gt 0 then     // last chain pointing left => rotate upwards to meet top component better
          dx:=dx/4; dy:=dy*5/4;
        end if;
        dx,dy:=Explode([dfactor*dx,dfactor*dy]);
        b:=TSpecialLinkBox(m[i],dx,dy);                                        // Tup -> create a special box
      else      
        b:=TLine(dx,dy,Sprint(m[i]),linestyle,thislabelstyle,linemargins);     // Int -> create a line 
      end if;
      b`x1:=x - b`banchors[1];      // Position its bottom left corner
      b`y1:=y;
      x+:=dx;                       // Move position to next line
      y+:=dy;
      vprintf redlib,2: "Line d=(%o,%o) m:%-2o at (%o,%o) w=%o h=%o\n",dx,dy,m[i],b`x1,b`y1,b`width,b`height;
      Append(~c,b);
    end for;
    B:=Box(c);                                    // Box all lines together 
    B`banchors:=[c[1]`x1+c[1]`banchors[1]];       // bottom anchor from first box
    if linksup then 
      B`tanchors:=[c[#c]`x1+c[#c]`tanchors[1]];   // top anchor (if linksup=true)
    end if;
    vprint redlib,2: "Chain",B;
    return B;
  end if;

  // LOOP ON A PRINCIPAL COMPONENT

  dir:=LoopDirections(#m);

  for i:=1 to #m do
    segmentlength:=//(exists{d: d in m | Type(d) eq Tup} select 1.5 else 1) *   //!
       isspecial(i) select ((eval get("chdotlengthfactor")) * P1linelength) else
        (isspecial(i-1) or isspecial(i+1) select P1extlinelength else P1linelength);

    d:=dir[i];   
    dx,dy,label:=DirectionsTodxdylabel(d, segmentlength);

    if Type(m[i]) eq Tup then                     // variable length chain link or other specials
      b:=TSpecialLinkBox(m[i],dx,dy);
    else
      thislabelstyle:=TikzOptions([labelstyle,label]);
      b:=TLine(dx,dy,Sprint(m[i]),linestyle,thislabelstyle,linemargins);      // Create a line box
    end if;

    b`x1:=Min(x,x+dx);
    b`y1:=Min(y,y+dy);
    vprintf redlib,3: "TChain.loop: %o x=%o y=%o dx=%o dy=%o bx1=%o by1=%o\n",d,RR(x),RR(y),RR(dx),RR(dy),RR(b`x1),RR(b`y1);
    Append(~c,b);

    x+:=dx;
    y+:=dy;

  end for;

  B:=Box(c);
  B`banchors:=Sort([c[#c]`x1+c[#c]`banchors[1],c[1]`x1+c[1]`banchors[1]]);
  return B;
end intrinsic;


/*
Example TChain for regular and variable chains
B:=TChain([* 1,2,3,4,5,6,7 *],false,true);
TeX(B: standalone);
B:=TChain([* 1,2,<"dotted","1","2">,4,5 *],true,false);
TeX(B: standalone);
B:=TChain([* 1,2,3,4,5,6,7,<"dotted","1","2">,4,5 *],false,true);
TeX(B: standalone);
*/


/*
Example TChain of different lengths without and with links up
B1:=[TChain([1..n],false,false): n in [1..8]];
PrintSequence([TeX(b: standalone): b in B1]: sep:="\\qquad"); //> [TeX(b: standalone): b in B1];
B2:=[TChain([1..n],true,false): n in [1..8]];
PrintSequence([TeX(b: standalone): b in B2]: sep:="\\qquad"); //> [TeX(b: standalone): b in B2];
*/


/*
Example looped TChain of different lengths
B:=[TChain([1..n],true,true): n in [1..24]];
PrintSequence([TeX(b: standalone): b in B[[1..8]]]: sep:="\\qquad"); //> [TeX(b: standalone): b in B[[1..8]]];
PrintSequence([TeX(b: standalone): b in B[[9..12]]]: sep:="\\qquad"); //> [TeX(b: standalone): b in B[[9..12]]];
PrintSequence([TeX(b: standalone): b in B[[13..16]]]: sep:="\\qquad"); //> [TeX(b: standalone): b in B[[13..16]]];
PrintSequence([TeX(b: standalone): b in B[[17..20]]]: sep:="\\qquad"); //> [TeX(b: standalone): b in B[[17..20]]];
PrintSequence([TeX(b: standalone): b in B[[21..24]]]: sep:="\\qquad"); //> [TeX(b: standalone): b in B[[21..24]]];
*/


intrinsic TPrincipalComponent(B::TBox, genus, mult, singular::BoolElt, childrenabove::SeqEnum, childrenbelow::SeqEnum: source:="") -> TBox, FldReElt
{Thick horizontal line representing a principal component to be place in the box B. Returns its box and x-coordinate where it is to be placed.}

  vprintf redlib,2: "TPrincipalComponent g=%-5o m=%-5o sing=%-5o src=%-5o\n",genus,mult,singular,source;

  anchors:=[b+AbsX(c)-AbsX(B): b in c`banchors, c in childrenabove]
       cat [t+AbsX(c)-AbsX(B): t in c`tanchors, c in childrenbelow];
  if IsEmpty(anchors) then anchors:=[0]; end if;

  x1:= Min(anchors) - 1/3;    // extend to the left and right of children
  x2:= Max(anchors) + 1/3; 

  linestyle:=get(singular select "princompsingstyle" else "princompstyle");
  margins:=eval get("princompmargins");

  // multiplicity and genus label above, source below
  mult:=Sprint(mult);
  genus:=Sprint(genus);
  if genus eq "0" then genus:=""; end if;
  source:=Sprint(source);

  // adjust how much line extends to the right if labels are present 
  princompmultofs:=eval get("princompmultofs");      // initial offset 
  princompmultsize:=eval get("princompmultsize");    // per letter
  rightlabelofs:=#mult+#genus+#source eq 0 select 0 else    
    princompmultofs + princompmultsize * Max(#mult+#genus,#source eq 0 select 0 else 2);

  if genus ne "" then 
    mglabel:=trim(Sprintf("%o \\smash{g}%o",mult,genus));
  else 
    mglabel:=Sprint(mult);
  end if;
  if mglabel ne "" then
    style:=get(singular select "prinsingcompmultstyle" else "princompmultstyle");
    mglabel:=Sprintf(" node%o {%o}",TikzOptions(style),mglabel);
  end if;

  if source ne "" then
    mglabel*:=Sprintf(" node%o {%o}",TikzOptions(get("princompnamestyle")),source);
  end if;

  width:=x2-x1+1/2+rightlabelofs;
  height:=0;
  H:=TLine(width,height,"",linestyle,"",margins: rightcode:=mglabel);
  return H,x1;
end intrinsic;


intrinsic PlacePrincipalComponent(G::GrphDual, ~B::TBox, chb::SeqEnum, chu::SeqEnum, w::MonStgElt: ypos:=0)
{Place a principal component w from a dual graph in the box B, with optional y-coordinate, covering the
anchors of given sequences of boxes from below and above.}
  g:=G`V[w]`g;                      // genus
  m:=G`V[w]`m;                      // multiplicity
  texname:=G`V[w]`texname;          // tex name, e.g. from cluster, face, etc., to display 
  singular:=G`V[w]`singular;        // whether it is singular
  H,x:=TPrincipalComponent(B,g,m,singular,chb,chu: source:=texname);
  AddChild(~B,H: xpos:=x, ypos:=ypos, first);
end intrinsic;


/*
Example
G:=DualGraph([2],[3],[]: comptexnames:=["$c_1$"]);
B:=TBoxCreate();
PlacePrincipalComponent(G,~B,[],[],"1");
TeX(B: standalone);
*/


function TNodeTeX(B, style, label)
  return Sprintf("\\node%o at %o {%o};\n",TikzOptions(style),TikzCoordinates(B,0,0),label);
end function;


intrinsic TNode(style, label::MonStgElt, width, height, margins::Tup) -> TBox
{TBox with a special point (e.g. for a singular point)}
  return Box(width,height,[0],[],margins,func<B|TNodeTeX(B,style,label)>);
end intrinsic;


intrinsic TSingularPoint(label::MonStgElt) -> TBox
{TBox with red singular point, and optional label above it}
  singptstyle:=get("singptstyle");
  singptlabelstyle:=get("singptlabelstyle");
  singptsize:=eval get("singptsize");
  singptmargins:=eval get("singptmargins");
  abovelabel:=Sprintf("label={%o%o}",TikzOptions(singptlabelstyle),label);
  return TNode([singptstyle,abovelabel],"$\\bullet$",singptsize,singptsize,singptmargins);
end intrinsic;


/// Placing children


function VerticalOverlap(ya1,ya2,yb1,yb2)
  // True if vertical segments [ya1,ya2] and [yb1,yb2] overlap
  if ya1 ge yb2 then return false; end if;
  if yb1 ge ya2 then return false; end if;
  return true; 
end function;


function MarginDistance(P,C)
  // min distance between right margins of P and left margins of C
  shift:=-10^6;
  vprint redlib,3: "P`right = ",DelSpaces(P`right);
  vprint redlib,3: "C`left  = ",DelSpaces(C`left);
  RS:=func<S|DelSpaces([RR(x): x in S])>;
  for dP in P`right, dC in C`left do
    if VerticalOverlap( dP[2],dP[3], C`y1+dC[2],C`y1+dC[3] ) then 
      vprint redlib,3: "dP",RS(dP),"dC",RS(dC),"overlap",VerticalOverlap(P`y1+dP[2],P`y1+dP[3],C`y1+dC[2],C`y1+dC[3]),"shift",RS([shift]);
      shift:=Max(shift,(P`x1+dP[1])-(C`x1+dC[1]));
    end if;
  end for;
  return shift;
end function;


intrinsic AddChild(~P::TBox, C::TBox: first:=false, avoid:=[], xpos:=0, ypos:=0)
{Place a new child box C into a parent box P. first:=true declares C should be the first child of P.
Otherwise it is otherwise last (default), and placing starts as position (xpos,ypos), default (0,0) 
and shifts it to the right of P. 
Avoids collisions between bottom anchors of C and top anchors in avoid (sequence of boxes).}

  if C`parent cmpne false then       // Copy a box if it already has a parent (e.g. used in a different chain)
    C:=Copy(C);
  end if;

  P`c:=first select [C] cat P`c else P`c cat [C];    // Parental-child relationship
  C`parent:=P;

  C`x1:=xpos;          // Starting position
  C`y1:=ypos;
  if not first then         // Place to the right of everything already in P
    shift:=Max(0,MarginDistance(P,C));
    C`x1+:=shift;
  end if;

  epsilon:=eval get("chaincollisiondist");

  avoidx:=[AbsX(D)+t: t in D`tanchors, D in avoid];
  x:=AbsX(C);

  if not IsEmpty(avoidx) then 
    vprintf redlib,3: "A: %o from %o\n",x,DelSpaces(avoidx);
  end if;
  while exists(shift){epsilon-Abs(xa-x-b): xa in avoidx, b in C`banchors | Abs(xa-x-b) lt epsilon-0.01} do
    C`x1+:=shift;
    x+:=shift;
  end while;        

  SizeAndMarginsFromChildren(~P);
end intrinsic;


procedure SetBottomAnchorsFromBoxes(~B,ch); 
  // Set bottom anchors of B from a sequence ch of (some of) its children
  B`banchors:=[b`x1+a: a in b`banchors, b in ch];
end procedure;


procedure SetTopAnchorsFromBoxes(~B,ch); 
  // Set top anchors of B from a sequence ch of (some of) its children
  B`tanchors:=[b`x1+a: a in b`tanchors, b in ch];
end procedure;


function HeightWithMargins(B)
  H:=B`height;
  for r in B`left cat B`right do
    x,y1,y2,y1a,y2a:=Explode(r);
    H:=Max(H,y2);
  end for;
  return H;
end function;


function IsDTail(G,v)        // Is this a principal component in a D-tail? 
  g:=G`V[v]`g;                      // genus
  m:=G`V[v]`m;                      // multiplicity
  texname:=G`V[v]`texname;          // tex name
  singular:=G`V[v]`singular;        // whether it is singular or special
  if singular or texname ne "" or g gt 0 or IsOdd(m) then return false; end if;   
  return Sort([Multiplicity(G,w) mod m: w in Neighbors(G,v)]) eq [0,m div 2, m div 2];   
end function;


procedure BoxChain(Vchain, G, ~D, ~F: open:=false, placefirst:=false)
  // Vchain = sequence of vertices v_1,...,v_n, representing either an open chain (open=true) or not (open=false)
  // placefirst:=true  add the first component into the box as well, and its children
  // placefirst:=false does not 

  B:=[];
  F:="";
  height:=0;

  vprint redlib,1: "BoxChain",DelSpaces(Vchain),open select "open" else "closed", placefirst select placefirst else "";

//  extraheight:=eval get("openbreathingdist");
  prinmargin:=eval get("princompmargins");
  minvspace:=prinmargin[3]+prinmargin[4];     // top+bottom margins of a principal component
  
  for i->w in Vchain do              // we work with a subset v-w-z of the chain on every step
    
    if i eq #Vchain and not open then break; end if;

    B[i]:=TBoxCreate();
    B[i]`x1:=0;

    if i eq 1 then
      v:="undefined";                   // v         = previous vertex
      lastchain:=[];                    // lastchain = children from v to w 
      B[i]`y1:=0;                       // B[i]`y1   = where to place ith box vertically
    else
      v:=Vchain[i-1];
      B[i]`y1:=B[i-1]`y1+height;
      lastchain:=D[[v,w]];
    end if;      

    if i eq #Vchain then
      z:="undefined";                   // z         = next vertex
      nextchain:=[];                    // nextchain = children from w to z
    else
      z:=Vchain[i+1];
      nextchain:=D[[w,z]];
      error if IsEmpty(nextchain), "Empty nextchain for a non-final vertex in BoxChain";
    end if;

    // Add own w's children (loops, bullets, open chains, etc.), avoiding top anchors from lastchain
    // unless not placing this box yet
    if (i ne 1 or placefirst) and (i ne #Vchain or open) then 
      for b in D[[w]] do    
        AddChild(~B[i],b: avoid:=lastchain);
      end for;
    end if;

    if not IsEmpty(nextchain) then 
      // Compute new height, and rescale nextchain to go until there
      height:=Max([HeightWithMargins(B[i])] cat [b`height: b in nextchain] /*cat [minvspace]*/);
      VerticalScaleTo(~nextchain,height); 
      // Add children in nextchain, avoiding B[i]'s own children added before, and top anchors from lastchain
      for j->b in nextchain do       
        AddChild(~B[i],b: avoid:=lastchain);      
      end for;
    end if;

    SetTopAnchorsFromBoxes(~B[i],nextchain);       
    SetBottomAnchorsFromBoxes(~B[i],B[i]`c);       
    
    if (eval get("compactifydtails")) ne 0 and IsDTail(G,w) and         // Special case: D-tail, replace last box
        IsEmpty(nextchain) and #lastchain eq 1 then  
      y:=B[i]`y1;                            // copy y coordinate from B[i] but overwrite the box itself
      B[i]:=TDTail(Multiplicity(G,w));       // with a D-tail
      B[i]`x1 := lastchain[1]`x1 + lastchain[1]`tanchors[1] - B[i]`banchors[1];   // and place it
      B[i]`y1:=y;
    
    // Add principal component itself at the bottom spanning to cover all the children above and below 
    elif (i ne 1 or placefirst) and (i ne #Vchain or open) then 

      // Squeeze children together if possible
      bx:=[AbsX(C)+b: b in C`banchors, C in B[i]`c];       // bottom anchors from newly placed children
      tx:=[AbsX(C)+t: t in C`tanchors, C in lastchain];    // top anchors from below
      if not IsEmpty(bx) and not IsEmpty(tx) then         
        epsilon:=eval get("chaincollisiondist");    // try to compress the children of the component
        if Max(bx)+epsilon lt Min(tx) then
          shift:=Min(tx)-Max(bx)-epsilon;            // could shift all bottom anchors to the right
        elif Max(tx)+epsilon lt Min(bx) then  
          shift:=Min(bx)-Max(tx)-epsilon;            // could shift all bottom anchors to the left
        else 
          shift:=0;                                  // cannot shift anything 
        end if;
        if shift ne 0 then
          vprintf redlib,2: "Shifting children of %o by %o\n",w,shift;
          for j:=1 to #B[i]`c do
            B[i]`c[j]`x1 -:= shift;
          end for;
          SizeAndMarginsFromChildren(~B[i]);
          SetBottomAnchorsFromBoxes(~B[i],B[i]`c);       
        end if;
      end if;        
      PlacePrincipalComponent(G,~B[i],B[i]`c,lastchain,w: ypos:=0);
    end if;

  end for;

  if #B eq 1 then
    F:=B[1];
  else
    F:=Box(B);                                  // Put everything in one box 
    SetBottomAnchorsFromBoxes(~F,[B[1]]);       // and set its bottom and top anchors
    SetTopAnchorsFromBoxes(~F,[B[#B]]);         // from first and last box in chain
  end if;    
end procedure;


function ExtendChain(chain,root,Neighbours)
  repeat
    v:=Last(chain);
    N:=Neighbours(v);
    if v eq root or #N gt 2 then return chain; end if;
    Nnew:=Set(N) diff Set(chain);
    if IsEmpty(Nnew) then 
      return chain[1] in N select Append(chain,chain[1]) else chain; 
    end if;
    Append(~chain,Representative(Nnew));
  until false;
end function;


procedure RemoveVertex(~P,~D,v) 
  vprint redlib,2: "Removing vertex",v;
  assert v in P;
  Exclude(~P,v);
  Remove(~D,[v]);
  for w in P do
    Remove(~D,[v,w]);
    Remove(~D,[w,v]);
  end for;    
end procedure;


function MaxBoxHeight(ch)
  // Height of a chain
  return Max([0] cat [not IsEmpty(b`tanchors) select b`height else HeightWithMargins(b): b in ch]);
end function;


function TeXDualGraphMain(G, root: shownamed:=false)
// Main function to draw dual graph, placing root at the bottom. Returns final box.

  P:=[p: p in PrincipalComponents(G: shownamed:=shownamed)];               // Principal components, copied
  error if #Set(P) ne #P, 
    "Repeated names of principal components in G";
  D:=AssociativeArray();
  for v in P do
    D[[v]]:=[];
    for j->p in G`V[v]`singpts cat G`V[v]`pts do     // special and singular points and components
      if p cmpeq [* "redbullet" *] then
        B:=TSingularPoint("");
      elif p cmpeq [* "bluenode" *] then
        B:=TChain([<"dotted","","?">],true,true);
      else 
        error if Type(p) ne Tup or #p ne 5, "Element of v`singpts must be 'redbullet', 'bluenode' or a tuple <style, node, width, height, margins>";
        style, node, width, height, margins:=Explode(p);
        B:=TNode(style, node, width, height, margins);
      end if;
      Append(~D[[v]],<[-1,j],B>);
    end for;
    for w in P do 
    if w ne v then
      D[[v,w]]:=[];
    end if;
    end for;
  end for;
  
  for j->chain in G`specialchains do
    v1,v2,singular,linestyle,endlinestyle,labelstyle,linemargins,P1linelength,c:=Explode(chain);
    c:=[* Type(d) eq Tup select <"dotted",d[1],d[2]> else d: d in c *];
    if linestyle eq "default" and singular then
      linestyle:=get("P1singlinestyle");
    end if;
    if endlinestyle eq "default" and singular then
      endlinestyle:=get("P1singendlinestyle");
    end if;
    //if exists{d: d in c | Type(d) eq Tup} then continue; end if;
    linksup:=v2 ne "";
    loop:=v1 eq v2;
    if loop then v2:=""; end if;
    sortdata:=[-2,j];
    B:=TChain(c,linksup,loop: linestyle:=linestyle, endlinestyle:=endlinestyle, 
      labelstyle:=labelstyle, linemargins:=linemargins, P1linelength:=P1linelength);
    if v2 ne "" then
      Append(~D[[v1,v2]],<sortdata,B>);   
      RB:=TChain(Reverse(c),linksup,loop: linestyle:=linestyle, endlinestyle:=endlinestyle, 
      labelstyle:=labelstyle, linemargins:=linemargins, P1linelength:=P1linelength);
      Append(~D[[v2,v1]],<sortdata,RB>);   
    else
      Append(~D[[v1]],<sortdata,B>);
    end if;   
  //  v1,v2,singular,c;
  end for;
  
  for chain in ChainsOfP1s(G: shownamed:=shownamed) do                 // Chains of P1s 
    v1,v2,c:=Explode(chain);
    m1:=Multiplicity(G,v1);
    if v2 eq ""  
      then m2:="undefined";
           error if IsEmpty(c), "open chain cannot be empty";
      else m2:=Multiplicity(G,v2);
    end if;
    gcd:=IsEmpty(c) select GCD(m1,m2) else GCD(m1,c[1]);
    depth:=Count(c,gcd)-1;
    if v2 eq "" then 
      Append(~D[[v1]],<[0,gcd,c[1]],TChain(c,false,false)>);   // open chain
    elif v1 eq v2 then 
      if IsEmpty(c) then 
        sortdata:=[1,gcd,m1,m1,0];
      else
        if c[1] gt c[#c] then c:=Reverse(c); end if;
        sortdata:=[1,gcd,c[1],c[#c],depth];
      end if;
      Append(~D[[v1]],<sortdata,TChain(c,false,true)>);    // loop on a principal component
    else 
      if IsEmpty(c) then 
        sortdata1:=[2,gcd,m2,m1]; sortdata2:=[2,gcd,m1,m2];
      else
        sortdata1:=[2,gcd,c[1],c[#c]]; sortdata2:=[2,gcd,c[#c],c[1]];
      end if;
      // v1,v2,DelSpaces(c),"=>",DelSpaces(sortdata1),DelSpaces(sortdata2);
      Append(~sortdata1,depth);
      Append(~sortdata2,depth);
      Append(~D[[v1,v2]],<sortdata1,TChain(c,true,false)>);                 // link chains 
      Append(~D[[v2,v1]],<sortdata2,TChain(Reverse(c),true,false)>);        // create both directions
    end if;
  end for;
  
  for k in Keys(D) do                    // sort by sortdata, and remove it from D keeping only the boxes
    A:=D[k];
    SortBy(~A,func<d|d[1]>);
    D[k]:=[d[2]: d in A];
  end for;
  
  /////////////////////
  
  repeat
  
    repeat
      tail:=[];                                                           // Find a tail
      Neighbours:=func<v|[w: w in P | v ne w and not IsEmpty(D[[v,w]])]>;
      for v in P do
        if v eq root or #Neighbours(v) ne 1 then continue; end if;
        tail:=Reverse(ExtendChain([v],root,Neighbours)); 
        break;  
      end for;
      if #tail eq 0 then break; end if; 
      vprint redlib, 1: "Contracting tail:",tail;                         // If found, contract it to a child of troot
      troot:=tail[1];
      BoxChain(tail,G,~D,~F: open);
      Append(~D[[troot]],F);
      //D[[troot]]:=[F] cat D[[troot]];
      for v in tail do
        if v ne troot then RemoveVertex(~P,~D,v); end if;
      end for;
    until false;
  
    chain:=[];                                                           // Find a chain
    Neighbours:=func<v|[w: w in P | v ne w and not IsEmpty(D[[v,w]])]>;
    for v in P do
      if v eq root or #Neighbours(v) ne 2 then continue; end if;
      chain:=ExtendChain([v],root,Neighbours); 
      chain:=ExtendChain(Reverse(chain),root,Neighbours); 
      break;  
    end for;
    if #chain eq 0 then break; end if;
    error if #chain le 2, 
      "Expected a chain of length >=3, got "*DelSpaces(chain);
    circular:=chain[1] eq chain[#chain];                                // If found, contract it 
    if circular 
      then i:=(#chain+1) div 2;                                         // break in two halves if circular
           c1:=chain[[1..i]];
           c2:=chain[[i..#chain]];
           contract:=[c1,Reverse(c2),c2,Reverse(c1)]; 
           keep:={chain[1],chain[i]};
      else contract:=[chain,Reverse(chain)]; 
           keep:={chain[1],chain[#chain]};
    end if;
    vprintf redlib, 1: "Contracting %o chains: %o\n", circular select "circular" else "linear",DelSpaces(contract);
    for c in contract do
      if #c eq 2 then continue; end if;
      v1:=c[1];
      v2:=c[#c];
      assert {v1,v2} eq keep;
      BoxChain(c,G,~D,~F);
      Append(~D[[v1,v2]],F);
      // D[[v1,v2]]:=[F] cat D[[v1,v2]]; 
    end for;
    for v in chain do
      if v notin keep then RemoveVertex(~P,~D,v); end if;
    end for;
  until false;
  
  if #P eq 4 and forall{v: v,w in P | v eq w or not IsEmpty(D[[v,w]])} then     // *** K4 ***
  
    O:=[root] cat [s: s in P | s ne root];    // Sort vertices: root first (rest doesn't matter)
  
    dd:=func<s|D[[O[i]: i in s]]>;
  
    procedure PlaceBoxesAtHeight(~B, H, C, avoid)
      for c in C do
        AddChild(~B,c: avoid:=avoid, ypos:=H);
      end for;
    end procedure;
     
    H1:=0;                                               // Height to place box #1 = 0 
    ch1:=dd([1,2]) cat dd([1]); 
    H2:=MaxBoxHeight(ch1);                               // #2
    ch2A:=dd([1,3]);
    ch2B:=dd([2]) cat dd([2,3]);
    H3:=Max(MaxBoxHeight(ch2A),H2+MaxBoxHeight(ch2B));   // #3
    ch3A:=dd([1,4]);
    ch3B:=dd([2,4]);
    ch3C:=dd([3]) cat dd([3,4]);
    H4:=Max([MaxBoxHeight(ch3A),H2+MaxBoxHeight(ch3B),H3+MaxBoxHeight(ch3C)]); // #4
  
    VerticalScaleTo(~ch1,H2);                             // Rescale all children accordingly
    VerticalScaleTo(~ch2A,H3);                            
    VerticalScaleTo(~ch2B,H3-H2);
    VerticalScaleTo(~ch3A,H4);
    VerticalScaleTo(~ch3B,H4-H2);
    VerticalScaleTo(~ch3C,H4-H3);
  
    B:=TBoxCreate();
    PlaceBoxesAtHeight(~B,H1,ch3A cat ch2A cat ch1,[]);   //! could avoid stuff below #1 if necessary
    PlaceBoxesAtHeight(~B,H2,ch2B,ch1);
    PlaceBoxesAtHeight(~B,H3,ch3C,ch2A cat ch2B);
    PlacePrincipalComponent(G,~B, ch3C, ch2A cat ch2B, O[3]: ypos:=H3); 
    PlaceBoxesAtHeight(~B,H2,ch3B,ch1);
    PlacePrincipalComponent(G,~B, ch2B cat ch3B, ch1, O[2]: ypos:=H2);
    PlacePrincipalComponent(G,~B, [], ch3A cat ch3B cat ch3C, O[4]: ypos:=H4);
  
    for s in [O[2],O[3],O[4]] do
      RemoveVertex(~P,~D,s);
    end for;
  
    SetBottomAnchorsFromBoxes(~B, ch3A cat ch2A cat ch1);       
  
    D[[root]]:=[B] /*cat ch3A cat ch2A cat ch1*/;
  end if;
  
  if #P eq 1 then        // Finished, one vertex left
    vprint redlib,1: "Placing final vertex",P[1];
    BoxChain(P,G,~D,~F: open, placefirst);
    return F;
  else
    return false;
  end if;
  
end function;


intrinsic TeX(G::GrphDual: xscale:="default", yscale:="default", root:="default", scale:="default", oneline:=false, weight:="area", texsettings:=[], box:=false, shownamed:=false) -> MonStgElt
{Returns a tikz picture drawing a dual graph. 
Set xscale, yscale and scale to control the size of the tikz picture. 
Set oneline:=true to put the tikz picture into one (long) line of Tikz code.
weight should be "area" (default), "width" or "height" and determines which parameter should be minimised.
shownamed:=true forces all principal components that were set up with non-empty texname drawn as principal.
}

  if #G eq 0 then return "empty"; end if;

  savedsettings:=Settings();
  AddSettings(G`texsettings);
  AddSettings(texsettings);

  C:=ConnectedComponents(G);
  if #C gt 1 then 
    sep:=GetSetting("dualgraph.conncompsep");
    out:=PrintSequence([TeX(c: xscale:=xscale, yscale:=yscale, scale:=scale, oneline:=oneline, weight:=weight, texsettings:=texsettings, box:=box, shownamed:=shownamed): c in C]: sep:=sep);
    SetSettings(savedsettings);
    return out;
  end if;
  
  error if weight notin ["area","width","height"], 
    "weight should be area, width or height";
  if   weight eq "area"  then Weight:=func<B|B`width*B`height>;
  elif weight eq "width" then Weight:=func<B|B`width>;
                         else Weight:=func<B|B`height>;
  end if;

  // x-scale and y-scale for the whole tikz picture

  if scale cmpeq "default" then  scale:=eval get("scale");   end if;
  if xscale cmpeq "default" then xscale:=eval get("xscale"); end if;
  if yscale cmpeq "default" then yscale:=eval get("yscale"); end if;
  if Type(xscale) ne MonStgElt then xscale:=scale*xscale; end if;
  if Type(yscale) ne MonStgElt then yscale:=scale*yscale; end if;

  // root to put at the bottom. if "all", will try all principal components, and choose best picture

  if root eq "default" then 
    root:=get("root");
  end if;
  if root eq "all" 
    then roots:=PrincipalComponents(G: shownamed:=shownamed);
    else error if root notin PrincipalComponents(G: shownamed:=shownamed), 
           "root, if specified, must be in PrincipalComponents(G)";
         roots:=[root];
  end if;

  best:=false;
  for root in roots do
    B:=TeXDualGraphMain(G, root: shownamed:=shownamed);
    if B cmpeq false then continue; end if;
    if best cmpeq false or Weight(B) lt Weight(best) then
      best:=B;
    end if;
  end for;

  SetSettings(savedsettings);

  if best cmpeq false then return ""; end if;    // Failed

  if box then return best; end if;               // return box for debugging

  out:=Sprintf("\\begin{tikzpicture}[xscale=%o,yscale=%o]\n%o\\end{tikzpicture} ",
    RR(xscale), RR(yscale), TeX(best));
  if oneline then  
    ReplaceString(~out,["\n","    ","   ","  "],[" "," "," "," "]);
  end if;

  return out;
end intrinsic;


/*
Example
G:=DualGraph();
AddComponent(~G,"1",0,1: texname:="$c_1$");  // name,genus,multiplicity [+ component name]
AddComponent(~G,"2",1,1: texname:="$c_2$", singular);  // singular component (red)  
AddSingularPoint(~G,"2","bluenode");         // singular points (standard)
AddSingularPoint(~G,"2","bluenode");         //   node of unknown length
AddSingularPoint(~G,"2","redbullet");        //   red bullet singular point
AddSpecialPoint(~G,"1","blue,inner sep=0pt,above=-1pt","$\\circ$");     // singular pt
AddSpecialPoint(~G,"1","above,scale=0.5","$\\infty$": singular:=false); // non-sing pt
AddChain(~G,"1","1",[]);                     // self-chain of length 0 (node)
AddChain(~G,"1","2",[]);                     // chain of length 0 (dashed)
AddChain(~G,"1","0",[1]);                    // open chain 
AddSingularChain(~G,"1","2");                // singular chain (red line)
AddSingularChain(~G,"2","0": mults:=["X"]);  // singular open chain 
// Add a ``zigzag'' style chain of unknown length and multiplicity 4
AddSingularChain(~G,"1","2": mults:=["$\\hspace{-11pt}?\\ \\ 4$"], linestyle:="snake=zigzag,segment length=2,segment amplitude=1,blue!70!black"); 
// Add a custom purple chain with multiplicties 1,2,3
AddSingularChain(~G,"1","2": mults:=[1,2,3], linestyle:="shorten <=-3pt,shorten >=-3pt, very thick, purple");    
AddVariableChain(~G,"1","2",[* 1,<2,"$n$">,3*]);         // variable length
AddVariableChain(~G,"1","1",[* 1,2,<3,"$m$">,2,1 *]);    // self-chain of variable length
TeX(G);
*/
