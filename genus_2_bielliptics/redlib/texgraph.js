/*
New javascript graph version translated from texgraph.py
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER
Implements TeXDualGraph and SVGDualGraph

*
* IMPLEMENTS
*
*
* Settings
*
function get(setting)                                                                                           [261]
  Retrieve the value for a given setting from DualGraphSettings.
function getarray(setting)                                                                                      [277]
  Retrieve the value from DualGraphSettings, evaluate it, and check if it is an array of numbers.
function set(setting, value)                                                                                    [296]
  Set the value for a given setting in the DualGraphSettings object.
*
* Auxiliary mathematical functions 
*
function mod(a, b)                                                                                              [316]
*
* Auxiliary functions for tikz output
*
function PrintReal(x, prec = 2)                                                                                 [344]
  Print a real number in TeX, with given precision and no trailing zeroes after the dot.
function RR(x)                                                                                                  [391]
  Print a real number in TeX, accepts various formats (int, str, float)
function TikzOptions(options)                                                                                   [405]
  Print a sequence of TikZ options "[..., ..., ]" if non-empty
function RotateCoordinates(x, y, rx, ry, rad)                                                                   [432]
function closestDirection(angle)                                                                                [453]
  Function to find the closest direction after rotation
function rotateAnchorMatch(match, rotationAngle)                                                                [465]
function rotateDirections(text, deg)                                                                            [474]
  Function to rotate directions in the text
function TikzTransform(s, rx, ry, phi)                                                                          [484]
  Scale by rx, ry and rotate by phi (degrees) a TikZ picture in `s`. Affects numeric positions (e.g.
  (0.23,-0.12)) and anchor strings (e.g. anchor=west)
function dxdyToAngle(dx, dy)                                                                                    [511]
  Convert direction dx, dy to an angle in degrees.
function RefineMargin(S, minmax)                                                                                [525]
  mm = "Min" or "Max", S = [[x,y1,y2,y1a,y2a],...]
function VerticalScaleSegment(S, r)                                                                             [560]
  Scale one margin segment x,y1,y2,y1a,y2a vertically by a factor of r
function VerticalOverlap(ya1, ya2, yb1, yb2)                                                                    [598]
  Returns True if the vertical segments [ya1, ya2] and [yb1, yb2] overlap.
function MarginDistance(P, C)                                                                                   [608]
  Returns the minimum distance between the right margins of P and the left margins of C.
*
* TBox
*
class TBox
  TBox.constructor(width = 0, height = 0, banchors = null, tanchors = null, margins = [0, 0, 0, 0], texFunc = (B) => "", svgFunc= (B) => "")  [632]
    Attributes initialization for a new TBox
  TBox.toString()                                                                                               [651]
  TBox.Copy()                                                                                                   [689]
    Create a copy of the TBox including its children.
  TBox.AbsX()                                                                                                   [724]
    Calculate absolute x-position by summing up the x-positions in the hierarchy.
  TBox.AbsY()                                                                                                   [740]
    Calculate absolute y-position by summing up the y-positions in the hierarchy.
  TBox.TikzCoordinates(x, y, scale = 1)                                                                         [756]
    Generate the TikZ string "(x,y)" with absolute placement of the box
  TBox.SVGxCoordinate(x, scale=1, tostring=true)                                                                [763]
    Generate "x" with absolute x-coordinate of the box, for use in SVG
  TBox.SVGyCoordinate(y, scale=1, tostring=true)                                                                [772]
    Generate "y" with absolute y-coordinate of the box, for use in SVG
  TBox.SVGCoordinates()                                                                                         [790]
    Coordinates x1,y1,x2,y2 as numbers, for further calculation
  TBox.TeX(standalone = false, depth = 1)                                                                       [801]
    Generate the TikZ code for this TBox and its children
  TBox.SVG()                                                                                                    [841]
    Generate the svg code for this TBox and its children
  TBox.LeftMarginWRXY()                                                                                         [852]
    Adjust the left margin with respect to the current x1 and y1.
  TBox.RightMarginWRXY()                                                                                        [859]
    Adjust the right margin with respect to the current x1 and y1.
  TBox.SizeAndMarginsFromChildren()                                                                             [866]
    Compute the size (width and height) and margins based on the children boxes.
  TBox.SetBottomAnchorsFromBoxes(ch)                                                                            [881]
    Set bottom anchors based on the list of children.
  TBox.SetTopAnchorsFromBoxes(ch)                                                                               [888]
    Set top anchors based on the list of children.
  TBox.VerticalScale(r)                                                                                         [895]
    Rescale a box vertically by a factor of r.
  TBox.VerticalScaleTo(H)                                                                                       [921]
    Rescale a box vertically to height H.
  TBox.HeightWithMargins()                                                                                      [929]
    Calculate the height of the box, considering the maximum y2 values from the left and right margins.
*
* Chains and children
*
function VerticalScale(C, r)                                                                                    [949]
  Rescale a sequence of boxes vertically by a factor of r.
function VerticalScaleTo(C, H)                                                                                  [959]
  Rescale a sequence of boxes vertically to height H.
function Box(c)                                                                                                 [969]
  Create a box encompassing the given children.
function AddChild(P, C, options={})                                                                             [999]
*
* Box primitives: TLine, TDottedChain, TPrincipalComponent, TNode, TSingularPoint
*
function TLineTeX(B)                                                                                            [1072]
  TikZ printing function for a TBox of type TLine.
function format(template, context)                                                                              [1096]
  Function for manual template formatting
function TLineSVG(B)                                                                                            [1104]
  SVG printing function for a TBox of type TLine.
function TLine(dx, dy, options = {})                                                                            [1159]
function DottedChainTeX(B)                                                                                      [1210]
  Generate a TikZ representation for a dotted chain.
function TDottedChain(dx, dy, multiplicity, count)                                                              [1266]
  TBox with a chain of P1s in the direction dx,dy with given initial style and labels (multiplicity, count)
function TDottedLoop(multiplicity = "", count = "")                                                             [1286]
function TDTail(m)                                                                                              [1320]
  A TBox representing a D-tail
function TArcComponentSVG(B)                                                                                    [1360]
function TArcComponent(linestyle = "", label = "", labelstyle = "")                                             [1376]
  Create an arc representing P1s meeting a principal component in two points.
function TSpecialLinkBox(data, dx, dy)                                                                          [1396]
  Create a special link box based on the provided data=['dotted',multiplicity,count] and direction dx,dy.
function TDashedLine(l)                                                                                         [1407]
  TBox representing an empty P1 chain drawn as a blue dashed line, for two principal components meeting at a
  point.
function TLoopTeX(B)                                                                                            [1427]
function TLoopSVG(B)                                                                                            [1437]
function TLoop(style = "")                                                                                      [1448]
  TBox representing a node (thick loop) on a principal component.
function LoopDirections(N)                                                                                      [1465]
  get the directions to draw a loop with N components on a principal component (N >= 2).
function DirectionsTodxdylabel(d, l)                                                                            [1522]
  Convert direction d returned by LoopDirections and length l to dx, dy, label.
function TChain(m, linksup, loop, options={})                                                                   [1544]
  TBox from chain of multiplicities - each one a number (multiplicity) or tuple <"dotted", mult, len> for a
  dotted chain.
function TPrincipalComponent(B, genus, mult, singular, childrenabove, childrenbelow, source = "")               [1725]
  Thick horizontal line representing a principal component to be placed in the box B. Returns its box and
  x-coordinate where it is to be placed.
function PlacePrincipalComponent(G, B, chb, chu, w, ypos = 0)                                                   [1795]
function IsDTail(G, v)                                                                                          [1827]
  Is this a principal component in a D-tail?
function BoxChain(Vchain, G, D, open = false, placefirst = false)                                               [1842]
function ExtendChain(chain, root, Neighbours)                                                                   [1975]
function RemoveArrayElement(arr, val)                                                                           [2031]
  Remove an element val from an array arr, raising an error if it is not there
function RemoveVertex(P, D, v)                                                                                  [2041]
function MaxBoxHeight(ch)                                                                                       [2057]
  Height of a chain
function TeXDualGraphMain(G, root)                                                                              [2068]
function TeXDualGraph(G, options={})                                                                            [2432]
function SVGDualGraph(G, options={})                                                                            [2532]
*/


/*
Execute
const originalLog = console.log;
console.log = (...args) => {
  const inspectedArgs = args.map(arg => typeof arg === 'object' ? Deno.inspect(arg, { compact: true }) : arg);
  originalLog(...inspectedArgs);
};
function Assert(condition, message) {if (!condition) {throw new Error(message || 'Assertion failed');}}
import redlib from './redtype.ts';
<INCLUDELIBRARY>
<TESTS>
<EXAMPLES>
*/


// Verbose printing 

let TVERBOSE      = false,
    vprintcounttg = 0;

function vprint(...args) {         //
  if (TVERBOSE && vprintcounttg<100) {  
    console.log(...args);  
    vprintcounttg++;
  }
}


/// Settings


// Dual graph TeX settings
const DualGraphDefaultSettings = {
  "dualgraph.DebugBoxMargins": "none",                 // Show box margins in green for debugging: all/top/none
  "dualgraph.DebugMarginLineColor": "green!60",
  "dualgraph.DebugMarginShadeColor": "green!10",
  "dualgraph.DebugMarginShadeWidth": "0.08",
  "dualgraph.DebugBAnchorColor": "green",
  "dualgraph.DebugTAnchorColor": "green!50!black",
  "dualgraph.DebugAnchorRadius": "2pt",

  "dualgraph.scale": "1",                               // Global scaling for the whole TikZ picture
  "dualgraph.xscale": "1",                              // [xscale*scale, yscale*scale]
  "dualgraph.yscale": "0.9",

  "dualgraph.root": "all",                              // By default, try all components at the bottom and return best picture

  "dualgraph.P1linelength": "3/5",                      // P1 in a chain: length in TikZ units
  "dualgraph.P1extlinelength": "4/5",                   // Extended when the only component between two principal ones
  "dualgraph.P1linestyle": "shorten <=-3pt, shorten >=-3pt", // \draw[...] style for P1s in a chain or loop (with overlaps)
  "dualgraph.P1endlinestyle": "shorten <=-3pt",         // Last P1 does not have anything to overlap with
  "dualgraph.P1singlinestyle": "shorten <=-3pt, shorten >=-3pt, thick, red", // Same as above but for singular chains
  "dualgraph.P1singendlinestyle": "shorten <=-3pt, thick, red",
  "dualgraph.P1multstyle": "inner sep=2pt,scale=0.8,blue", // Label style for multiplicity
  "dualgraph.P1linemargins": "[2/5,2/5,3/5,0]",         // Margins to repel other boxes (l, r, t, b) 
  "dualgraph.P1arcmargins": "[1/4,1/4,1/8,1/8]",        // Margins for an arc of P1s

  "dualgraph.compactifydtails": "1",                    // Compactify D-tails yes (1)/no (0)
  "dualgraph.dtailmargins": "[1/3,1/3,1/3,0]",          //   for an D-tail on top of a chains
  "dualgraph.dtailprinlength": "7/5",                   //   length of the principal component in a D-tail
  "dualgraph.dtailprinlinestyle": "",                   //   style for the principal component in a D-tail

  "dualgraph.chaincollisiondist": "3/5",                // Horizontal min collision distance between chain anchors

  "dualgraph.chdotlinestyle": "",                       // Dotted chain: line style
  "dualgraph.chdotlengthfactor": "2",                   // Length factor compared to standard P1
  "dualgraph.chdotmultstyle": "blue,scale=0.7",         // Chain multiplicity label style
  "dualgraph.chdotlenstyle": "auto,inner sep=5,scale=0.7", // Chain length label style
  "dualgraph.chdotmargins": "[1/2,1/2,1/2,1/2]",       // Box margins
  "dualgraph.chdotloopscale": "0.8",                    // Dotted loop: overall scale
  "dualgraph.chdotlooplenstyle": "below=0.1,anchor=north,scale=0.7", // Chain loop label style
  "dualgraph.chdotloopmargins": "[1/3,1/3,1/3,1/3]",   // Margins for loop case

  "dualgraph.princompnamestyle": "inner sep=2pt,below left,scale=0.8", // Style for the component name (below right)
  "dualgraph.princompstyle": "thick,shorten >=2",       // Principal non-singular component line style (above right)
  "dualgraph.looplinestyle": "thick",                   // Loop (node) on a principal component (TLoop)
  "dualgraph.princompsingstyle": "red,thick,shorten >=2", // Principal singular component line style
  "dualgraph.princompmultstyle": "inner sep=2pt,blue,above left,scale=0.8", // Principal non-singular component multiplicity style
  "dualgraph.prinsingcompmultstyle": "red,above left,scale=0.8", // Principal singular component multiplicity style
  "dualgraph.princompmultsize": "1/5",                  // Approximate horizontal label size per m-g letter
  "dualgraph.princompmultofs": "1/5",                   // Extend component to print labels on the right
  "dualgraph.princompmargins": "[2/5,3/5,2/5,1/4]",     // l, r, t, b margins for principal components

  "dualgraph.singptstyle": "red",                       // Singular point on a principal component (red bullet)
  "dualgraph.singptlabelstyle": "above,inner sep=0pt,scale=0.7,red", // Label style for singular points
  "dualgraph.singptsize": "1/10",                       // Size of singular point on a component
  "dualgraph.singptmargins": "[1/5,1/5,1/5,1/5]",       // Margins for singular points
  
  "dualgraph.minsvgwidth": "600",                       // Extend viewbox if width < minsvgwidth
  "dualgraph.minsvgheight": "160",                      // Sink down if height < minsvgheight
  "dualgraph.svgleftxmargin": "0.5",                    // Margins around the picture in svg to make sure labels fit
  "dualgraph.svgrightxmargin": "0",                     // 
  "dualgraph.svgtopymargin": "0.5",                     // 
  "dualgraph.svgbottomymargin": "0.2",                  // 
  "dualgraph.svgxscale": "60",                          // Scale from default tikz points to svg
  "dualgraph.svgyscale": "50",
  "dualgraph.svgP1extension": "0.1",                    // extend P1s on both sides
};

let DualGraphSettings = {}; // To hold the current settings

function get(setting) {
  /*
  Retrieve the value for a given setting from DualGraphSettings.
  */
  if (Object.keys(DualGraphSettings).length === 0) {
    DualGraphSettings = { ...DualGraphDefaultSettings }; // Initialize with default settings
  }
  
  const key = "dualgraph." + setting; // Construct the key
  if (key in DualGraphSettings) {
    return DualGraphSettings[key]; // Return the setting value
  } else {
    throw new Error(`Setting '${key}' not found in DualGraphSettings.`);
  }
}

function getarray(setting) {
  /*
  Retrieve the value from DualGraphSettings, evaluate it, and check if it is an array of numbers.
  */
  const result = get(setting); 
  try {
    const evaluatedResult = eval(result);
    if (!Array.isArray(evaluatedResult)) {
      throw new Error(`Setting '${setting}' is not an array.`);
    }
    if (!evaluatedResult.every(item => typeof item === 'number')) {
      throw new Error(`Setting '${setting}' is not an array of numbers.`);
    }
    return evaluatedResult; // Return the validated array of numbers
  } catch (error) {
    throw new Error(`Error in getarray (${setting} = ${result}): ${error.message}`);
  }
}

function set(setting, value) {
  /*
  Set the value for a given setting in the DualGraphSettings object.
  */
  if (Object.keys(DualGraphSettings).length === 0) {
    DualGraphSettings = { ...DualGraphDefaultSettings }; // Initialize with default settings
  }
  
  const key = "dualgraph." + setting; // Construct the key
  if (key in DualGraphSettings) {
    DualGraphSettings[key] = String(value); // Set the new value as a string
  } else {
    throw new Error(`Setting '${key}' not found in DualGraphSettings.`);
  }
}


/// Auxiliary mathematical functions 


function mod(a, b) {
  /*
  Computes the modulus of a with respect to b, returning a non-negative result.
  Like in Magma and python: -1 mod 3 = 2 rather than -1
  */
  return ((a % b) + b) % b;
}


function gcd_two(a, b) {                          // GCD of two integers
  return b === 0 ? Math.abs(a) : gcd_two(b, mod(a,b));
}


function GCD(...numbers) {     // GCD of any number of integers
  if (numbers.length === 0) {     // GCD([])=0
    return 0;
  }
  if (numbers.length === 1) {     // GCD([a])=a 
    return numbers[0];          
  }
  return numbers.reduce((acc, num) => gcd_two(acc, num));     // reduce inductively
}


/// Auxiliary functions for tikz output


function PrintReal(x, prec = 2) {
  /*
  Print a real number in TeX, with given precision and no trailing zeroes after the dot.
  */

  if (Math.abs(x) < Math.pow(10, -prec)) { // If x is very close to 0, return "0"
    return "0";
  }

  let s = x.toFixed(prec); // Format the number as a string with given precision
  if (s.includes("e") || s.includes("E")) { // Check for floating-point exponent representation
    throw new Error("Floating point representation with exponent is not implemented");
  }

  s = s.replace(/0+$/, ""); // Remove trailing zeros
  if (s.endsWith(".")) { // Remove trailing decimal point if necessary
    s = s.slice(0, -1);
  }

  return s;
}


function ArraysEqual(seq1, seq2) {     //
  /*
  Checks if two sequences seq1 and seq2 are equal in length and content,
  supporting nested sequences (arrays of arrays).
  */

  if (!Array.isArray(seq1) || !Array.isArray(seq2)) {             // Use direct comparison if not both arrays
    return seq1 === seq2;                                         // (for FindMinimumPaths in case of general labels)
  }
  
  if (seq1.length !== seq2.length) return false;                  // Early return if lengths differ
  
  for (let i = 0; i < seq1.length; i++) {
    if (Array.isArray(seq1[i]) && Array.isArray(seq2[i])) {
      if (!ArraysEqual(seq1[i], seq2[i])) return false;              // Recursively check nested arrays
    } else if (seq1[i] !== seq2[i]) { 
      return false;                           // Elements must be strictly equal for non-array elements
    }
  }
  
  return true;                                                    // Arrays are equal in length and content
}


function RR(x) {
  /*
  Print a real number in TeX, accepts various formats (int, str, float)
  */
  if (typeof x === "number") {           // Handle integer/floating point input
    return PrintReal(x, 2);              // Precision 2 for floating-point numbers
  } else if (typeof x === "string") {      // Handle string input
    return String(x);
  } else {
    throw new TypeError(`RR: Don't know how to print ${x} of type ${typeof x}`);
  }
}


function TikzOptions(options) {
  /*
  Print a sequence of TikZ options "[..., ..., ]" if non-empty
  */
  if (typeof options === "string") { // Check if input is a string
    options = [options];
  }

  const L = [];
  for (let o of options) {
    if (o.length === 0) { // Skip empty options
      continue;
    }
    if (o.startsWith("[") && o.endsWith("]")) { // Strip surrounding brackets
      L.push(o.slice(1, -1));
    } else {
      L.push(o);
    }
  }

  if (L.length === 0) { // Return an empty string if no valid options
    return "";
  }
  return "[" + L.join(",") + "]"; // Join options with commas and wrap in brackets
}


function RotateCoordinates(x, y, rx, ry, rad) {
  // console.log(`Rotating s=${JSON.stringify(s)} rx=${rx} ry=${ry} rad=${rad}`);
  const xnew = rx * x * Math.cos(rad) - ry * y * Math.sin(rad);
  const ynew = rx * x * Math.sin(rad) + ry * y * Math.cos(rad);
  // console.log(`xnew=${xnew} ynew=${ynew}`);
  return `(${RR(xnew)},${RR(ynew)})`;
}


const CompassDirections = [  // List of directions and their corresponding angles in degrees
  ["anchor=east", 0],
  ["anchor=north east", 45],
  ["anchor=north", 90],
  ["anchor=north west", 135],
  ["anchor=west", 180],
  ["anchor=south west", 225],
  ["anchor=south", 270],
  ["anchor=south east", 315]
];


function closestDirection(angle) {
  /*
  Function to find the closest direction after rotation
  */
  angle = angle % 360;
  return CompassDirections.reduce((closest, direction) => {
    const diff = Math.abs(angle - direction[1]);
    return diff < Math.abs(angle - closest[1]) ? direction : closest;
  })[0];
}


function rotateAnchorMatch(match, rotationAngle) {
  const originalDirection = match[0]; // Extract the matched direction
  const originalAngle = Object.fromEntries(CompassDirections)[originalDirection]; // get the corresponding angle for the original direction
  const newAngle = originalAngle + rotationAngle; // Calculate the new angle by rotating the original one
  const newDirection = closestDirection(newAngle); // Find the closest compass direction to the new angle
  return newDirection;
}


function rotateDirections(text, deg) {
  /*
  Function to rotate directions in the text
  */
  const directionNames = CompassDirections.map(d => d[0]).map(d => d.replace(/[-\/\\^$.*+?()[\]{}|]/g, '\\$&')).join("|"); // Regex pattern to match any of the compass directions
  const pattern = new RegExp(`\\b(${directionNames})\\b`, 'g');
  return text.replace(pattern, (match) => rotateAnchorMatch([match], deg)); // Use replace to apply the rotation
}


function TikzTransform(s, rx, ry, phi) {
  /*
  Scale by rx, ry and rotate by phi (degrees) a TikZ picture in `s`. Affects numeric positions (e.g. (0.23,-0.12)) and anchor strings (e.g. anchor=west)
  */
  if (typeof s !== "string") {
    throw new TypeError("TikzTransform: Expected a TikZ string");
  }

  const rad = phi * Math.PI / 180; // Convert phi to radians

  // Stage 1: Rotate numeric positions (x, y)
  s = s.replace(/\((-?[.\d]+),(-?[.\d]+)\)/g, (match, x, y) => RotateCoordinates(x, y, rx, ry, rad));
  
  // Stage 2: Rotate anchors of the form anchor=north (east, south west, ...)
  s = rotateDirections(s, phi);

  return s;
}


/*
Example TikzTransform
var s = "(0,0)--[anchor=north](1,1);";
console.log(TikzTransform(s, 1, 1, 90));     // rotate by 90 degrees
*/


function dxdyToAngle(dx, dy) {
  /*
  Convert direction dx, dy to an angle in degrees.
  */
  if (dx < 0) {  
    return 180 + dxdyToAngle(-dx, -dy);
  }
  if (Math.abs(dx) <= Math.abs(dy) / 10000) {  
    return dy > 0 ? 90 : 270;  
  }
  return (Math.atan(dy / dx) / Math.PI) * 180;
}


function RefineMargin(S, minmax) {
  /*
  mm = "Min" or "Max", S = [[x,y1,y2,y1a,y2a],...]
  */

  const Ys = Array.from(new Set(S.flatMap(d => [d[1], d[2]]))).sort();  // Extract and sort y1s and y2s
  // console.log("Ys=", Ys);
  const need = new Set();

  for (const y of Ys) {
    const I = S.map((m, i) => m[1] <= y && y <= m[2] ? i : -1).filter(i => i !== -1);  // Find segments containing y
    if (I.length === 0) {  
      continue;
    }

    // console.log("I = ", I, minmax, "S = ", S);

    let j;
    if (minmax === "Min") {
      j = I.reduce((minIndex, i, indx) => (S[i][0] < S[I[minIndex]][0] ? indx : minIndex), 0);  // get smallest x-coordinate index
    } else if (minmax === "Max") {
      j = I.reduce((maxIndex, i, indx) => (S[i][0] > S[I[maxIndex]][0] ? indx : maxIndex), 0);  // get largest x-coordinate index
    } else {
      throw new Error("Invalid minmax function. Must be 'Min' or 'Max'");
    }
    
    need.add(I[j]);                     // Keep the segment we need
  }

  // console.log(`Refined(${minmax} ${S} -> {[S[i] for i in sorted(need)]}`);

  return Array.from(need).sort((a, b) => a - b).map(i => S[i]);  // Return sorted segments
}


function VerticalScaleSegment(S, r) {
  /*
  Scale one margin segment x,y1,y2,y1a,y2a vertically by a factor of r
  */
  var x = S[0], y1 = S[1], y2 = S[2], y1a = S[3], y2a = S[4];  // Unpack the segment
  // console.log("Scaling", x, y1, y2, y1a, y2a, "by", r);

  if (y1a < y1) {  // Ensure that y1a is greater than or equal to y1
    throw new Error(`VerticalScaleSegment: expected y1a >= y1 in ${S}`);
  }

  var eps1 = y1a - y1;
  if (y2a > y2) {  // Ensure that y2a is less than or equal to y2
    throw new Error(`VerticalScaleSegment: expected y2a <= y2 in ${S}`);
  }

  var eps2 = y2 - y2a;
  y1a *= r;          // Scale y anchor points
  y2a *= r;
  y1 = y1a - eps1;   // Adjust y1 to maintain segment length
  y2 = y2a + eps2;

  // console.log("Got", x, y1, y2, y1a, y2a);  
  return [x, y1, y2, y1a, y2a];
}


/*
Example
// Rescale a segment (-0.25,1.25) with anchor points at 0 and 1 by a factor of 3. The x-position 10 is unchanged,
// the anchor points y1a, y2a, are rescaled by a factor of 3, and the whole interval (y1,y2) adjusted accordingly so that
// the distances y1 to y1a and y2a to y2 stay the same.
var S = [10, -0.25, 1.25, 0, 1]; 
console.log(VerticalScaleSegment(S, 3));
*/



function VerticalOverlap(ya1, ya2, yb1, yb2) {
  /*
  Returns True if the vertical segments [ya1, ya2] and [yb1, yb2] overlap.
  */
  if (ya1 >= yb2) return false;
  if (yb1 >= ya2) return false;
  return true;
}


function MarginDistance(P, C) {
  /*
  Returns the minimum distance between the right margins of P and the left margins of C.
  */

  let shift = -1000000;
  for (const dP of P.right) {
    for (const dC of C.left) {
      if (VerticalOverlap(dP[1], dP[2], C.y1 + dC[1], C.y1 + dC[2])) {
        shift = Math.max(shift, (P.x1 + dP[0]) - (C.x1 + dC[0]));
      }
    }
  }

  // console.log(`MarginDistance P.right=${P.right} - C.left=${C.left} shift=${shift}`);

  return shift;
}


/// TBox


class TBox {
  constructor(width = 0, height = 0, banchors = null, tanchors = null, margins = [0, 0, 0, 0], texFunc = (B) => "", svgFunc= (B) => "") {
    /*
    Attributes initialization for a new TBox
    */
    this.c = [];          // children
    this.parent = null;
    this.banchors = banchors !== null ? banchors : [0];  // bottom anchors
    this.tanchors = tanchors !== null ? tanchors : [];   // top anchors
    this.width = width;
    this.height = height;
    this.left = [[-margins[0], -margins[3], height + margins[2], 0, height]];
    this.right = [[width + margins[1], -margins[3], height + margins[2], 0, height]];
    this.x1 = 0;          // current x-position in parent
    this.y1 = 0;          // current y-position in parent
    this.tex = texFunc;   // function(B) to render TikZ code
    this.svg = svgFunc;   // function(B) to render svg code
    this.style = [];      // array of box-specific parameters (converted from tuple)
  }

  toString() {
    // TeX Box representation for printing
    return `TBox[${this.c.length}] at (${RR(this.x1)},${RR(this.y1)}) abs (${RR(this.AbsX())},${RR(this.AbsY())}) `
      + `size ${RR(this.width)}x${RR(this.height)} `
      + `[${this.banchors.map(RR).join(",")}]->[${this.tanchors.map(RR).join(",")}]`;
  }

  static TBoxCreate() {
    /*
    Create an empty TBox with a default anchor at the bottom-left corner.
    */
    return new TBox();
  }

  static Box(width, height, banchors, tanchors, margins, texFunc, svgFunc) {
    /*
    Create a new TBox with given parameters.
    */

    // Ensure the dimensions are valid
    if ((width === 0 && height === 0) || width < 0 || height < 0) {
      throw new Error(`Box: invalid dimensions width=${width}, height=${height}`);
    }
    // Create the box
    return new TBox(width, height, banchors, tanchors, margins, texFunc, svgFunc);
  }

  /*
  Example
  // The following creates a 2x1 box with a margin of 1/2 on each side and $x$ in the middle.
  const BoxDraw = (B) => `\\node at ${B.TikzCoordinates(1, 1/2)} {x};`;
  const B = new TBox(2, 1, [0, 1/2, 1], [1/2], [1/2, 1/2, 1/2, 1/2], BoxDraw);
  // Set margins, box boundary and bottom/top anchors to visible
  set("DebugBoxMargins", "all");
  console.log(B.TeX(true));
  set("DebugBoxMargins", "none");
  */

  Copy() {
    /*
    Create a copy of the TBox including its children.
    */

    const B_copy = TBox.Box(this.width, this.height, [...this.banchors], [...this.tanchors], [0, 0, 0, 0], this.tex, this.svg);
    B_copy.x1 = this.x1;
    B_copy.y1 = this.y1;
    B_copy.left = this.left.map(m => [...m]);   // Shallow copy of the left array entries
    B_copy.right = this.right.map(m => [...m]); // Shallow copy of the right array entries
    B_copy.parent = null;
    B_copy.style = this.style;
    B_copy.c = this.c.map(child => {
      const childCopy = child.Copy();           // Recursively copy children
      childCopy.parent = B_copy;                // Set the parent for the child
      return childCopy;
    });
    return B_copy;
  }


  /*
  Example Three of the boxes above with Copy and AddChild
  let BoxDraw = (B) => `\\node at ${B.TikzCoordinates(1, 1/2)} {x};`;
  var B = TBox.Box(2, 1, [0, 1/2, 1], [1/2], [1/2, 1/2, 1/2, 1/2], BoxDraw);
  var P = TBox.TBoxCreate();
  AddChild(P, B);
  AddChild(P, B.Copy(), {ypos: 1/4} );
  AddChild(P, B.Copy(), {ypos: 1/2} );
  set("DebugBoxMargins", "all");
  console.log(P.TeX(true));
  set("DebugBoxMargins", "none");
  */


  AbsX() {
    /*
    Calculate absolute x-position by summing up the x-positions in the hierarchy.
    */
    let x = 0;
    let B = this;
    while (B !== null) {
      x += B.x1;
      B = B.parent;
    }
    if (!Number.isFinite(x)) {    
      throw new Error(`AbsX: got x=${JSON.stringify(x)} type ${typeof x}`);
    }
    return x;
  }

  AbsY() {
    /*
    Calculate absolute y-position by summing up the y-positions in the hierarchy.
    */
    let y = 0;
    let B = this;
    while (B !== null) {
      y += B.y1;
      B = B.parent;
    }
    if (!Number.isFinite(y)) {    
      throw new Error(`AbsX: got y=${JSON.stringify(y)} type ${typeof y}`);
    }
    return y;
  }

  TikzCoordinates(x, y, scale = 1) {
    /*
    Generate the TikZ string "(x,y)" with absolute placement of the box
    */
    return `(${RR(scale * (x + this.AbsX()))},${RR(scale * (y + this.AbsY()))})`;
  }

  SVGxCoordinate(x, scale=1, tostring=true) {
    /*
    Generate "x" with absolute x-coordinate of the box, for use in SVG
    */
    scale *= eval(get("svgxscale"));
    x = scale * (x + this.AbsX());
    return tostring ? RR(x) : x;
  }

  SVGyCoordinate(y, scale=1, tostring=true) {
    /*
    Generate "y" with absolute y-coordinate of the box, for use in SVG
    */

    let B = this;            // Compute absolute parent and subtract y from height 
    let height;              //   to put the whole picture upside down
    while (B !== null) {
      height = B.height;
      B = B.parent;
    }
    // console.log(y, height, height - (y + this.AbsY()), RR(scale * (height - (y + this.AbsY()))));

    scale *= eval(get("svgyscale"));
    y = scale * (height - (y + this.AbsY()));
    return tostring ? RR(y) : y;
  }

  SVGCoordinates() {
    /*
    Coordinates x1,y1,x2,y2 as numbers, for further calculation
    */
    var x1 = this.SVGxCoordinate(0,1,false);
    var y1 = this.SVGyCoordinate(0,1,false);
    var x2 = this.SVGxCoordinate(this.width,1,false);
    var y2 = this.SVGyCoordinate(this.height,1,false);
    return [x1,y1,x2,y2];
  }

  TeX(standalone = false, depth = 1) {
    /*
    Generate the TikZ code for this TBox and its children
    */

    let s = "";

    // Box margins for debugging
    let show = get("DebugBoxMargins");
    if (show == "all" || (show == "top" && depth === 1)) {
      let DebugMarginLineColor = get("DebugMarginLineColor");
      let DebugMarginShadeColor = get("DebugMarginShadeColor");
      let DebugMarginShadeWidth = eval(get("DebugMarginShadeWidth"));
      s += `\\draw[${DebugMarginLineColor}] ${this.TikzCoordinates(0, 0)} rectangle ${this.TikzCoordinates(this.width, this.height)};`;
      for (let margin of this.left.concat(this.right)) {
        let [x, y1, y2, ,] = margin;
        let sgn = margin in this.left ? 1 : -1;
        s += `\\fill[${DebugMarginShadeColor}] ${this.TikzCoordinates(x, y1)} rectangle ${this.TikzCoordinates(x + sgn * DebugMarginShadeWidth, y2)};`;
        s += `\\draw[${DebugMarginLineColor}] ${this.TikzCoordinates(x, y1)}--${this.TikzCoordinates(x, y2)};`;
      }
      for (let x of this.banchors) {
        s += `\\draw${TikzOptions(get('DebugBAnchorColor'))} ${this.TikzCoordinates(x, 0)} circle [radius=${get('DebugAnchorRadius')}];\n`;
      }
      for (let x of this.tanchors) {
        s += `\\draw${TikzOptions(get('DebugTAnchorColor'))} ${this.TikzCoordinates(x, this.height)} circle [radius=${get('DebugAnchorRadius')}];\n`;
      }
    }

    s += this.tex(this);                 // Box itself
    for (let child of this.c) {
      s += child.TeX(false, depth + 1);  // Render children recursively
    }

    if (standalone) {
      return `\\tikz{\n${s}}`;
    } else {
      return s;
    }
  }

  SVG() {
    /*
    Generate the svg code for this TBox and its children
    */
    let s = this.svg(this);            // Box itself
    for (let child of this.c) {
      s += child.SVG();                // Render children recursively
    }
    return s;
  }

  LeftMarginWRXY() {
    /*
    Adjust the left margin with respect to the current x1 and y1.
    */
    return this.left.map(d => [d[0] + this.x1, d[1] + this.y1, d[2] + this.y1, d[3] + this.y1, d[4] + this.y1]);
  }

  RightMarginWRXY() {
    /*
    Adjust the right margin with respect to the current x1 and y1.
    */
    return this.right.map(d => [d[0] + this.x1, d[1] + this.y1, d[2] + this.y1, d[3] + this.y1, d[4] + this.y1]);
  }

  SizeAndMarginsFromChildren() {
    /*
    Compute the size (width and height) and margins based on the children boxes.
    */
    const c = this.c;

    // Compute the maximum width and height from children
    this.width = Math.max(...c.map(b => b.x1 + b.width));
    this.height = Math.max(...c.map(b => b.y1 + b.height));

    // Compute the left and right margins based on children
    this.left = RefineMargin(c.flatMap(b => b.LeftMarginWRXY()), 'Min');
    this.right = RefineMargin(c.flatMap(b => b.RightMarginWRXY()), 'Max');
  }

  SetBottomAnchorsFromBoxes(ch) {
    /*
    Set bottom anchors based on the list of children.
    */
    this.banchors = ch.flatMap(b => b.banchors.map(a => b.x1 + a));
  }

  SetTopAnchorsFromBoxes(ch) {
    /*
    Set top anchors based on the list of children.
    */
    this.tanchors = ch.flatMap(b => b.tanchors.map(a => b.x1 + a));
  }

  VerticalScale(r) {
    /*
    Rescale a box vertically by a factor of r.
    */
    if (r === 1) return;  // No scaling needed

    // Scale position in parent and total height
    this.y1 *= r;
    this.height *= r;

    // Scale children
    for (const child of this.c) {
      child.VerticalScale(r);
    }

    // Scale left margins
    for (let i = 0; i < this.left.length; i++) {
      this.left[i] = VerticalScaleSegment(this.left[i], r);
    }

    // Scale right margins
    for (let i = 0; i < this.right.length; i++) {
      this.right[i] = VerticalScaleSegment(this.right[i], r);
    }
  }

  VerticalScaleTo(H) {
    /*
    Rescale a box vertically to height H.
    */
    if (this.height === 0 || this.height === H) return;  // No scaling needed
    this.VerticalScale(H / this.height);
  }

  HeightWithMargins() {
    /*
    Calculate the height of the box, considering the maximum y2 values from the left and right margins.
    */
    let H = this.height;

    for (const r of [...this.left, ...this.right]) {
      const [, , y2] = r;  // Only interested in y2
      H = Math.max(H, y2);  // Update H with the maximum y2
    }

    return H;
  }

}


/// Chains and children


function VerticalScale(C, r) {
  /*
  Rescale a sequence of boxes vertically by a factor of r.
  */
  for (const box of C) {
    if (!box.tanchors.length) continue;  // Skip boxes with no top anchors
    box.VerticalScale(r);
  }
}

function VerticalScaleTo(C, H) {
  /*
  Rescale a sequence of boxes vertically to height H.
  */
  for (const box of C) {
    if (!box.tanchors.length) continue;  // Skip boxes with no top anchors
    box.VerticalScaleTo(H);
  }
}

function Box(c) {
  /*
  Create a box encompassing the given children.
  */
  if (!Array.isArray(c) || !c.length) {
    throw new Error("Box(...) expects a non-empty array of children");
  }

  const B = new TBox();

  // Translate the children so the box starts at (0, 0)
  const minx1 = Math.min(...c.map(b => b.x1));  // Min x1 among children
  const miny1 = Math.min(...c.map(b => b.y1));  // Min y1 among children

  for (const child of c) {
    if (child.parent) {
      throw new Error(`Box(SeqEnum): ${child} already has a parent=${child.parent}`);
    }
    child.x1 -= minx1;  // Adjust x1 so that box starts at 0
    child.y1 -= miny1;  // Adjust y1 so that box starts at 0
    child.parent = B;   // Set the parent to the new box
  }

  B.c = c;                         // Assign the children to the new box
  B.SizeAndMarginsFromChildren();  // Calculate dimensions and margins based on children
  // console.log("Box(c)",B.x1,B.y1);
  return B;
}


function AddChild(P, C, options={}) {
  /*
  Place a new child box C into a parent box P. first:=true declares C should be the first child of P.
  Otherwise it is last (default), and placing starts as position (xpos,ypos), default (0,0) 
  and shifts it to the right of P. 
  Avoids collisions between bottom anchors of C and top anchors in avoid (sequence of boxes).
  */

  if (typeof options !== 'object' || options === null || Array.isArray(options)) {
    throw new Error("Options parameter is not an object, expected {first, avoid, xpos, ypos}.");
  }

  let {first = false, avoid = [], xpos = 0, ypos = 0} = options;

  vprint(`AddChild P=${P.toString()} C=${C.toString()} first=${first} avoid=${avoid.toString()} xpos=${xpos} ypos=${ypos}`);

  if (C.parent) {     // Copy a box if it already has a parent (e.g. used in a different chain)
    C = C.Copy();
  }

  P.c = first ? [C].concat(P.c) : P.c.concat([C]);  // Parental-child relationship
  C.parent = P;

  C.x1 = xpos;                              // Starting position
  C.y1 = ypos;

  let shift;                                // used outside loops

  if (!first) {                             // Place to the right of everything already in P
    shift = Math.max(0, MarginDistance(P, C));
    C.x1 += shift;
  }

  // console.log(`shift=${shift}`);

  var epsilon = eval(get("chaincollisiondist"));

  // console.log(avoid.toString());

  let avoidx = [].concat(...avoid.map(D => D.tanchors.map(t => D.AbsX() + t)));
  // console.log(avoidx);
  var x = C.AbsX();

  var steps=0;

  while (true) {

    steps+=1;
    if (steps>100) {throw new Error("Too many steps in AddChild when trying to compute shifts");}
    
    const shifts = avoidx.map(xa => 
      Math.max(0, epsilon - Math.abs(xa - x - C.banchors[0])) // Assuming C.banchors has at least one element
    );
    shift = Math.max(...shifts);  // Use the spread operator to get the maximum shift value
    if (shift <= 0.01) {break;}
    C.x1 += shift;  // Update C.x1 with the computed shift
    x += shift;     // Update x with the computed shift
  } 
 
  // console.log(`shift=${shift} type ${typeof shift}`);
  // console.log(`x=${x} type ${typeof x}`);

  // console.log("AddChild P>",P.toString());
  // console.log("AddChild C>",C.x1,C.y1);
  P.SizeAndMarginsFromChildren();
  // console.log("Pa>",P.x1,P.y1);
}


/// Box primitives: TLine, TDottedChain, TPrincipalComponent, TNode, TSingularPoint



function TLineTeX(B) {
  /*
  TikZ printing function for a TBox of type TLine.
  */
  let [linestyle, label, labelstyle, labelpos, rightcode, svgclass, svgtext] = B.style; 
  // console.log(`TLine ${B.TikzCoordinates(B.banchors[0], 0)}-${B.TikzCoordinates(B.tanchors[0], B.height)} {${label}}`);

  if (label) {
    label = `node${TikzOptions(labelstyle)} {${label}} `; 
  }

  if (rightcode && rightcode[0] !== " ") {
    rightcode = " " + rightcode;  
  }

  const x1 = B.banchors[0];
  const y1 = 0;
  const x2 = B.tanchors[0];
  const y2 = B.height;

  return `\\draw${TikzOptions(linestyle)} ${B.TikzCoordinates(x1, y1)}--${label}${B.TikzCoordinates(x2, y2)}${rightcode};\n`;
}


function format(template, context) {
  /*
  Function for manual template formatting
  */
  return new Function(...Object.keys(context), `return \`${template}\`;`)(...Object.values(context));
}


function TLineSVG(B) {
  /*
  SVG printing function for a TBox of type TLine.
  */
  let [linestyle /* unused */, label, labelstyle, labelpos, rightcode, svgclass, svgtext] = B.style; 
  var x1 = B.banchors[0];          // line coordinates
  var y1 = 0;
  var x2 = B.tanchors[0];
  var y2 = B.height;
  var dx = 0;                      // label offset from line middle
  var dy = 0;
  var diag = 0;                    // =2 if two of the words right, left, above, below are included
  var anchor = "middle";

  // If label is present, it is placed at the middle of the line, using labelpos ('above' etc.)
  if (label) {
    labelpos = labelpos.includes('=') 
      ? labelpos.split('=')[0].trim()      // Split at '=' and trim, e.g. 'above = 1pt' becomes 'above'
      : labelpos.trim();                   //   else keep as is
    if (labelpos.includes('right')) { dx=5; dy=-5; anchor='start'; diag+=1; }
    if (labelpos.includes('left'))  { dx=-5; dy=-5; anchor='end'; diag+=1; }
    if (labelpos.includes('above')) { dy=5; diag+=1; }
    if (labelpos.includes('below')) { dy=-5; diag+=1; }
    if (diag==2) { dx=2*dx; }              // move further away from a diagonal line
    svgtext.push('<text x="${(x1+x2)/2+dx}" y="${(y1+y2)/2-dy}" text-anchor="${anchor}" class="P1label">${label}</text>\n');
  }

  if (svgclass == "P1") {                          // Extend P1s on both sides (if class 'edge')
    let epsilon = eval(get("svgP1extension"));
    let dx = x2 - x1;
    let dy = y2 - y1;
    let length = Math.sqrt(dx * dx + dy * dy);
    let unitDx = dx / length;
    let unitDy = dy / length;
    x1 -= epsilon * unitDx; 
    y1 -= epsilon * unitDy; 
    x2 += epsilon * unitDx; 
    y2 += epsilon * unitDy; 
  }

  let context = {                                  // Plug in x1,y1,x2,y2,svgclass values into 
    x1: eval(B.SVGxCoordinate(x1)),                //   both line code and any svgtext provided
    y1: eval(B.SVGyCoordinate(y1)), 
    x2: eval(B.SVGxCoordinate(x2)), 
    y2: eval(B.SVGyCoordinate(y2)),
    svgclass, label, dx, dy, anchor, RR
  };
  
  let svgline = '<line x1="${RR(x1)}" y1="${RR(y1)}" x2="${RR(x2)}" y2="${RR(y2)}" class="${svgclass}" />\n'
  svgline = format(svgline,context);
  svgtext = svgtext.map(s => format(s, context)); 
  return svgline + svgtext;
}


function TLine(dx, dy, options = {}) {
  /*
  General line primitive in the direction dx, dy with given options.
  options should contain label, linestyle, labelstyle, margins, rightcode.
  */

  if (typeof options !== 'object' || options === null || Array.isArray(options)) {
    throw new Error("Options parameter is not an object, expected {label, linestyle, labelstyle, margins, rightcode, svgclass, svgrightcode}.");
  }

  const {
    label = "",
    labelpos = "",
    linestyle = "",
    labelstyle = "",
    margins = [0, 0, 0, 0],
    rightcode = "",
    svgclass = "P1",
    svgtext = []
  } = options;

  const width = Math.abs(dx);   // Absolute width
  const height = Math.abs(dy);  // Absolute height

  let banchors, tanchors;
  
  if ((dy >= 0 && dx >= 0) || (dy < 0 && dx < 0)) {
    banchors = [0];         // Bottom anchor at (0,0)
    tanchors = [width];     // Top anchor at (width, height)
  } else {
    banchors = [width];     // Bottom anchor at (width, 0)
    tanchors = [0];         // Top anchor at (0, height)
  }

  const B = TBox.Box(width, height, banchors, tanchors, margins, TLineTeX, TLineSVG);
  B.style = [linestyle, label, labelstyle, labelpos, rightcode, svgclass, svgtext]; 
  // console.log("B>",B.x1,B.y1);  
  return B;
}


/*
Example TLine
const linestyle = "thick"
const labelstyle = "above left"
const margins = [1/2, 1/2, 1/2, 1/2]
var B = TLine(1, 1, { label: "a", linestyle, labelstyle, margins, rightcode: " node [right] {g1}" });
console.log(B.TeX(true));
*/


function DottedChainTeX(B) {
  /*
  Generate a TikZ representation for a dotted chain.
  */
  
  // Unpack the style settings
  const [dx, dy, chainmult, chainlen] = B.style;  
  // Calculate starting and ending points for the line
  const x1 = dx < 0 ? B.width : 0;
  const y1 = dy < 0 ? B.height : 0;
  const x2 = dx > 0 ? B.width : 0;
  const y2 = dy > 0 ? B.height : 0;
  const len = Math.sqrt(B.width ** 2 + B.height ** 2);  // Calculate the length of the line
  const ang = dxdyToAngle(x2 - x1, y2 - y1);            // get the angle of the line

  // Retrieve style settings
  const style = get("chdotlinestyle");
  const chmultstyle = get("chdotmultstyle");
  const chlenstyle = get("chdotlenstyle");

  // Define the TikZ draw command
  let src = `\\draw{style} {coords} 
    ++(0.11,-0.11)--++(-0.38,0.41)++(0.18,-0.15)  
    ++(0,0.02)
      node{chmultstylewest} {{chainmult}}
    ++(0,-0.02)
    ++(-0.18,-0.01)--++(0.36,0.38)++(-0.15,0.04)  
    node{$\\cdot$} ++(-0.1,0.1) node{$\\cdot$}
    ++(-0.10,0.10) node{$\\cdot$}++(0.2,-0.06) node[{chlenstyle},anchor=west]{{chainlen}}
    ++(-0.3,0.12)--++(0.36,0.38)++(-0.20,-0.00)   
    ++(0.02,-0.04)
      node{chmultstyleeast} {{chainmult}}
    ++(-0.02,0.04)
    ++(0.20,0.00)++(0,-0.15)--++(-0.38,0.41);`;
    
  const r = len / 1.41;       // Scaling factor
  const phi = ang - 90 - 13;  // Adjust the angle

  const shrinkfactor = Math.min(1, 1 / r);  // Calculate the shrink factor
  const shr = TikzTransform(src, shrinkfactor, 1, 0);  // Shrink if too large
  const rot = TikzTransform(shr, r, r, phi);  // Rotate the positions and anchors

  //console.log("phi = ",phi);
  //console.log("\\begin{verbatim}","src = ",src,'\\end{verbatim}');
  //console.log("\\begin{verbatim}","rot = ",rot,'\\end{verbatim}');

  return rot.replaceAll("{style}", TikzOptions(style))
            .replaceAll("{coords}", B.TikzCoordinates(x1, y1))
            .replaceAll("{chmultstylewest}", TikzOptions([chmultstyle,"inner sep=1","anchor=west"]))
            .replaceAll("{chmultstyleeast}", TikzOptions([chmultstyle,"inner sep=1","anchor=east"]))
            .replaceAll("{chainmult}", chainmult)
            .replaceAll("{chlenstyle}", chlenstyle)
            .replaceAll("{chainlen}", chainlen);
}


function TDottedChain(dx, dy, multiplicity, count) {
  /*
  TBox with a chain of P1s in the direction dx,dy with given initial style and labels (multiplicity, count)
  */
  var margins = getarray("chdotmargins");   // Retrieve margins
  var banchors = (dx < 0) ? [Math.abs(dx)] : [0];  // Bottom anchors
  var tanchors = (dx < 0) ? [0] : [Math.abs(dx)];  // Top anchors
  var B = TBox.Box(Math.abs(dx), Math.abs(dy), banchors, tanchors, margins, DottedChainTeX);  // Create the box
  B.style = [dx, dy, multiplicity, count];  // Set the style
  return B;                                 // Return the created box
}


/*
Example
let B = TDottedChain(1, 1, "1", "n");
console.log(B.TeX(true));
*/


function TDottedLoop(multiplicity = "", count = "") {
  /*
  Create a hexagon shape with dots on top representing a variable length loop
  indicating the given multiplicity and chain count.
  */
  var chdotmultstyle_east = TikzOptions(["anchor=east", get("chdotmultstyle")]);  
  var chdotmultstyle_west = TikzOptions(["anchor=west", get("chdotmultstyle")]);  
  var chdotlenstyle = TikzOptions(get("chdotlooplenstyle"));  
  var scale = eval(get("chdotloopscale"));  

  var scalestr = Math.abs(scale - 1) > 0.001 ? `scale=${scale}` : "";
  var chdotlinestyle = TikzOptions(get("chdotlinestyle"));  

  var margins = getarray("chdotloopmargins");  
  return TBox.Box(13 / 10 * scale, scale, [3 / 10 * scale, 105 / 100 * scale], [], margins, function(B) {
    return `\\draw${TikzOptions([scalestr, chdotlinestyle])} ${B.TikzCoordinates(0, 0, scale = 1 / scale)} 
    ++(0.05,0.3) node${chdotmultstyle_east}{${multiplicity}} 
    ++(0.3,-0.45)--++(115:0.75)++(295:0.15)++(245:0.15)--++(65:0.75)++(245:0.15)++(180:0.15)
    --++(0:0.22) ++(0:0.15) node{{$\\cdot$}} ++(0:0.15) node{{$\\cdot$}} 
    node${chdotlenstyle}{${count}} 
    ++(0:0.15) node{{$\\cdot$}} ++(0:0.15) 
    --++(0:0.22)++(180:0.15)++(115:0.15)--++(295:0.75)++(115:0.15)++(65:0.15)--++(245:0.75)
    ++(0.3,0.45) node${chdotmultstyle_west}{${multiplicity}};`;
  });
}


/*
Example TDottedLoop
let B = TDottedLoop("1", "n");
console.log(B.TeX(true));
*/


function TDTail(m) {
  /*
  A TBox representing a D-tail
  */
  if (m < 2 || m % 2 !== 0) {
    throw new Error("TDTail: expected even multiplicity");
  }
  const labelstyle = get("P1multstyle");
  const P1style = get("P1endlinestyle");
  const P1length = eval(get("P1linelength"));
  const prinlength = eval(get("dtailprinlength"));
  const margins = eval(get("dtailmargins"));
  const prinlinestyle = get("dtailprinlinestyle");
  const B1 = TLine(prinlength, 0, {label: String(m), linestyle: TikzOptions([prinlinestyle,"above","pos=0.6"]), labelstyle, labelpos: "above right", margins, svgclass: "DTail"});
  const B2 = TLine(0, P1length, {label: String(Math.floor(m / 2)), linestyle: TikzOptions([P1style,"left"]), labelstyle, labelpos: "left", margins});
  B2.x1 = 1 / 5;
  const B3 = TLine(0, P1length, {label: String(Math.floor(m / 2)), linestyle: TikzOptions([P1style,"right"]), labelstyle, labelpos: "right", margins});
  B3.x1 = prinlength - 1/5;
  const B = Box([B1, B2, B3]);
  B.banchors = [prinlength/2-1/10];
  B.tanchors = [];
  return B;
}


/*
Example D-tail
B = new TDTail(2);
set("DebugBoxMargins", "top");
console.log(B.TeX(true));
set("DebugBoxMargins", "none");
*/


/*
Example Multiple D-tails
console.log(TeXDualGraph(redlib.ReductionType("24^1,11,20,18,22_D,D,D").DualGraph()));
*/


function TArcComponentSVG(B) {
  let [label] = B.style;
  var [x1,y1,x2,y2] = B.SVGCoordinates();
  var r  = (x2-x1)/2;
  var xm = x1 + r;
  var ym = y1 - r;
  // Draw arc, shifted down so that it intersects the principal component
  let svg = `<path d="M ${RR(x1)},${RR(y1+5)} A ${RR(r)},${RR(r)} 0 0 1 ${RR(x2)},${RR(y1+5)}" fill="none" class="P1" />\n`;
  // Draw label
  if (label != "") {
    svg += `<text x="${RR(xm)}" y="${RR(ym)}" dy="0" text-anchor="middle" class="P1label">${label}</text>\n`;
  }
  return svg;
}


function TArcComponent(linestyle = "", label = "", labelstyle = "") {
  /*
  Create an arc representing P1s meeting a principal component in two points.
  */
  labelstyle = TikzOptions([labelstyle, "midway", "above"]);  
  let tex = B => `\\draw${TikzOptions(linestyle)} ${B.TikzCoordinates(0, 0)} ++(1,0) arc (0:180:0.5) node${TikzOptions(labelstyle)} {{${label}}};`;

  let B = TBox.Box(1, 1, [0, 1], [], getarray("P1arcmargins"), tex, TArcComponentSVG);
  B.style = [label];  // for SVG use
  return B;
}


/*
Example TArcComponent
let B = TArcComponent("blue","1","above")
console.log(B.TeX(true))
*/


function TSpecialLinkBox(data, dx, dy) {
  /*
  Create a special link box based on the provided data=['dotted',multiplicity,count] and direction dx,dy.
  */
  if (data.length !== 3 || data[0] !== "dotted") {
    throw new Error(`Dotted chain: data(${data}) should be a 3-tuple <'dotted', multiplicity, length>`);
  }
  return TDottedChain(dx, dy, String(data[1]), String(data[2]));  // Return the dotted chain
}


function TDashedLine(l) {
  /*
  TBox representing an empty P1 chain drawn as a blue dashed line, for two principal components meeting at a point.
  */
  // console.log("TDashedLine: empty P1 chain (two components meeting at a point)"); 

  const style = TikzOptions("blue!80!white,densely dashed");
  const tex = (B) => `\\draw${style} ${B.TikzCoordinates(0, 0)}--${B.TikzCoordinates(B.width, B.height)};\n`
  const svg = (B) => `<line x1="${B.SVGxCoordinate(0)}" y1="${B.SVGyCoordinate(0)}" x2="${B.SVGxCoordinate(B.width)}" y2="${B.SVGyCoordinate(B.height)}" class="P1dashed" stroke-dasharray="8,4"/>\n`
  return TBox.Box(0, l, [0], [0], [1/3, 1/3, 1/3, 1/3], tex, svg);
}


/*
Example TDashedLine
let B = TDashedLine(5/4);
console.log(B.TeX(true));
*/


function TLoopTeX(B) {
  let [style] = B.style;
  return `\\path${TikzOptions(['draw', style])} `
       + `${B.TikzCoordinates(0, 0)}`
       + `edge[white,line width=2] ++(0.6,0) `          // remove piece of original black component
       + `edge[out=0,in=-90] ++(0.6,0.4) ++(0.6,0.4) edge[out=90,in=0] ++(-0.3,0.3) ++(-0.3,0.3) `
       + `edge[out=180,in=90] ++(-0.3,-0.3) ++(-0.3,-0.3) edge[out=-90,in=180] ++(0.6,-0.4);\n`;
}


function TLoopSVG(B) {
  var [x1,y1,x2,y2] = B.SVGCoordinates();
  let X = (x => RR(x1 + 0.8*(x-80)));
  let Y = (y => RR(y1 + 0.7*(y-100)));
  return `<path d="M ${X(80)},${Y(100)} H ${X(120)}" fill="none" stroke="currentColor" stroke-width="3" />\n` + 
  `<path d="M ${X(80)},${Y(100)} C ${X(130)},${Y(100)} ${X(130)},${Y(50)} ` + 
  `${X(100)},${Y(50)} C ${X(70)},${Y(50)} ${X(70)},${Y(100)} ${X(120)},${Y(100)}" fill="none"` + 
  `stroke="black" stroke-width="2" />\n`;
}


function TLoop(style = "") {
  /*
  TBox representing a node (thick loop) on a principal component.
  */
  let B = TBox.Box(0.6, 1, [0, 0.6], [], [1/3, 1/3, 1/3, 1/3], TLoopTeX, TLoopSVG);
  B.style = [style];
  return B;
}


/*
Example TLoop
var B = TLoop("thick");
console.log(B.TeX(true));
*/


function LoopDirections(N) {
  /*
  get the directions to draw a loop with N components on a principal component (N >= 2).
  */

  if (N < 2) {
    throw new Error("N must be at least 2");
  }

  const r8 = mod(N,8);                                      // Remainder when N is divided by 8
  const d8 = Math.max(0,Math.floor(N / 8) - (r8 === 4 || r8 === 5 || r8 === 6 || r8 === 7 ? 0 : 1));  // Division and adjustment for d8

  const URUL = [].concat(...Array(d8).fill(["U", "R", "Ur", "L"]));
  const ULUR = [].concat(...Array(d8).fill(["Ur", "L", "U", "R"]));
  const LDRD = [].concat(...Array(d8).fill(["L", "Dl", "R", "D"]));
  const RDLD = [].concat(...Array(d8).fill(["R", "D", "L", "Dl"]));

  //  const URUL = [].concat(...Array(d8).fill([["U", "R", "Ur", "L"]]));
  //  const ULUR = [].concat(...Array(d8).fill([["Ur", "L", "U", "R"]]));
  //  const LDRD = [].concat(...Array(d8).fill([["L", "Dl", "R", "D"]]));
  //  const RDLD = [].concat(...Array(d8).fill([["R", "D", "L", "Dl"]]));

  // Determine direction based on the number of components
  let dir;
  if (N >= 2 && N < 10) {
    dir = [
      ["LSU", "LSD"],  // 2
      ["U", "R", "D"],  // 3
      ["U", "RU", "RD", "D"],  // 4
      ["LSU", "RSU", "R", "RSDa", "LSD"],  // 5
      ["LSU", "U", "RU", "RD", "D", "LSD"],  // 6
      ["LSU", "U", "RU", "R", "RD", "D", "LSD"],  // 7
      ["U", "R", "Ur", "RU", "RD", "Dl", "R", "D"],  // 8
      ["U", "LU", "U", "RU", "R", "RD", "D", "LD", "D"]  // 9
    ][N - 2];  // Index is N - 2 because of zero-based indexing
  } else if (r8 === 0) {
    dir = URUL.concat(["U", "R", "Ur", "RU", "RD", "Dl", "R", "D"], LDRD);  // 16, 24, ...
  } else if (r8 === 1) {
    dir = URUL.concat(["LSU", "RSU", "R", "RSUb", "R", "RSD", "R", "RSDa", "LSD"], LDRD);  // 17
  } else if (r8 === 2) {
    dir = ULUR.concat(["Ur", "L", "U", "R", "RU", "RD", "R", "D", "L", "Dl"], RDLD);  // 10, 18
  } else if (r8 === 3) {
    dir = ULUR.concat(["Ur", "L", "U", "R", "RSU", "R", "RSDa", "R", "D", "L", "Dl"], RDLD);  // 11, 19
  } else if (r8 === 4) {
    dir = ["RU"].concat(ULUR, ["RU", "RD"], RDLD, ["RD"]);  // 12
  } else if (r8 === 5) {
    dir = ["LSU"].concat(ULUR, ["RSU", "R", "RSDa"], RDLD, ["LSD"]);  // 13
  } else if (r8 === 6) {
    dir = URUL.concat(["U", "R", "RU", "RD", "R", "D"], LDRD);  // 14
  } else {
    dir = URUL.concat(["U", "R", "RSUb", "R", "RSD", "R", "D"], LDRD);  // 15
  }

  return dir;  // Return the list of directions
}


function DirectionsTodxdylabel(d, l) {
  /*
  Convert direction d returned by LoopDirections and length l to dx, dy, label.
  */
  const l34 = (3 / 4) * l;     // 3/4 of the length
  const l2 = l / 2;            // 1/2 of the length
  const direction_map = {
    "L": [-l, 0, "above"], "U": [0, l, "left"], "Ur": [0, l, "right"], "D": [0, -l, "right"], "Dl": [0, -l, "left"], "R": [l, 0, "above"],
    "RU": [l34, l34, "above left=0pt and -1pt"], "RUb": [l34, l34, "below right=-1pt and -1pt"],
    "RD": [l34, -l34, "above right=0pt and -1pt"], "LU": [-l34, l34, "below left=0pt and -1pt"],
    "LUb": [-l34, l34, "below left=-1pt and -1pt"], "LD": [-l34, -l34, "below right=0pt and -1pt"],
    "LSU": [-l2, l, "above right"], "LSD": [-l2, -l, "above left"], "RSU": [l2, l, "above left"],
    "RSUb": [l2, l, "below right"], "RSD": [l2, -l, "below left"], "RSDa": [l2, -l, "above right"],
  };
  if (d in direction_map) {
    return direction_map[d];  // Return the (dx, dy, label)
  } else {
    throw new Error(`Unrecognized direction ${d}`);
  }
}


function TChain(m, linksup, loop, options={}) {
  /*
  TBox from chain of multiplicities - each one a number (multiplicity) or tuple <"dotted", mult, len> for a dotted chain.
  */

  if (typeof options !== 'object' || options === null || Array.isArray(options)) {
    throw new Error("Options parameter is not an object, expected {linestyle, endlinestyle, labelstyle, linemargins, P1linelength, P1extlinelength}.");
  }

  let {
    linestyle = "default", 
    endlinestyle = "default", 
    labelstyle = "default", 
    linemargins = "default", 
    P1linelength = "default", 
    P1extlinelength = "default"
  } = options;

  if (!(Array.isArray(m) || typeof m === 'object' && m !== null && 'length' in m)) {  // Ensure m is a list or tuple
    throw new Error(`Box: chain ${m} is neither a List nor SeqEnum of multiplicities`);
  }

  if (linestyle === "default") {
    linestyle = get("P1linestyle");  // e.g. "shorten <=-2pt,shorten >=-2pt"
  }
  if (endlinestyle === "default") {
    endlinestyle = get("P1endlinestyle");  // e.g. "shorten <=-2pt"
  }
  if (labelstyle === "default") {
    labelstyle = get("P1multstyle");  // e.g. "inner sep=2pt,scale=0.8,blue"
  }
  if (linemargins === "default") {
    linemargins = getarray("P1linemargins");  // e.g. "[2/5,2/5,1/3,1/3]"
  }
  if (P1linelength === "default") {
    P1linelength = get("P1linelength");  // e.g. "2/3"
  }
  if (P1extlinelength === "default") {
    P1extlinelength = get("P1extlinelength");  // e.g. "1"
  }

  P1linelength = eval(P1linelength);        // length in tikz units
  P1extlinelength = eval(P1extlinelength);  // extended when the only component between two principal ones

  if (!loop && m.length === 0) {
    return TDashedLine(P1extlinelength);  // two components meeting at a point => dashed line
  }
  if (loop && m.length === 0) {
    return TLoop(get("looplinestyle"));  // node (thick loop) on a principal component
  }

  const isspecial = i => 1 <= i && i <= m.length && Array.isArray(m[i - 1]);  // i -> is m[i] special tuple ('dotted',len,mult) ?

  if (loop && m.length === 1 && isspecial(1)) {                // loop of variable length (mult, len)
    if (m[0][0] !== "dotted") {
      throw new Error(`Got m=${m} expected to start with 'dotted'`);
    }
    return TDottedLoop(String(m[0][1]), String(m[0][2]));
  }

  if (m.length === 1 && loop) {                                // arc on a principal component
    return TArcComponent(linestyle, String(m[0]), labelstyle);
  }

  let x = 0, y = 0, c = [];

  // OPEN CHAIN OR TO CHAIN TO ANOTHER COMPONENT

  if (!loop) {
    for (let i = 1; i <= m.length; i++) {
      let d = ["Ur", "L", "U", "R"][mod(i-1,4)];  // P1s go up, left, up, right, ...
      let length = P1linelength;
      if (linksup && mod(i,4) === 1 && m.length === 1) {
        length = P1extlinelength;  // extra long when only one P1
      }
      if (linksup && i === m.length && mod(i,2) === 0) {
        d += "Ub";  // tilt last line up if horizontal to meet next principal component
      }
      let [dx, dy, labelpos] = DirectionsTodxdylabel(d, length);
      if (mod(i,2) === 0 && isspecial(i + 1)) {
        labelpos = "below";  // move label below to avoid clash with dotted chains
      }
      if (i === m.length && !isspecial(i) && !linksup) {
        linestyle = endlinestyle;  // make last line shorter in an open chain
      }
      let thislabelstyle = TikzOptions([labelstyle, labelpos]);
      let b;
      if (isspecial(i)) {  // variable length chain link or other specials - stretch vertically
        let dfactor = eval(get("chdotlengthfactor"));
        if (dx < 0 && dy > 0) {  // last chain pointing left => rotate upwards to meet top component better
          dx /= 4;
          dy *= 5 / 4;
        }
        dx *= dfactor;
        dy *= dfactor;
        b = TSpecialLinkBox(m[i - 1], dx, dy);  // Tup -> create a special box
      } else {
        let lineoptions = {label: String(m[i - 1]), linestyle, labelpos, labelstyle: thislabelstyle, margins: linemargins};
        b = TLine(dx, dy, lineoptions);  // Int -> create a line 
      }
      b.x1 = x - b.banchors[0];  // Position its bottom left corner
      b.y1 = y;
      x += dx;  // Move position to next line
      y += dy;
      c.push(b);
    }
    let B = Box(c);  // Box all lines together 
    // console.log("BB>",B.x1,B.y1);
    B.banchors = [c[0].x1 + c[0].banchors[0]];  // bottom anchor from first box
    if (linksup) {
      B.tanchors = [c[c.length - 1].x1 + c[c.length - 1].tanchors[0]];  // top anchor (if linksup=true)
    }
    return B;
  }

  // LOOP ON A PRINCIPAL COMPONENT

  let dir = LoopDirections(m.length);
  let segmentlength = (1.5 * (m.some(d => Array.isArray(d))) ? 1 : 1) * P1linelength;

  for (let i = 1; i <= m.length; i++) {
    let d = dir[i - 1];
    let [dx, dy, labelpos] = DirectionsTodxdylabel(d, segmentlength);

    let b;
    if (Array.isArray(m[i - 1])) {  // variable length chain link or other specials
      b = TSpecialLinkBox(m[i - 1], dx, dy);
    } else {
      let thislabelstyle = TikzOptions([labelstyle, labelpos]);
      let lineoptions = {label: String(m[i - 1]), linestyle, labelpos, labelstyle: thislabelstyle, margins: linemargins};
      b = TLine(dx, dy, lineoptions);  // Create a line box
    }

    b.x1 = Math.min(x, x + dx);
    b.y1 = Math.min(y, y + dy);
    c.push(b);

    x += dx;
    y += dy;
  }

  let B = Box(c);
  // console.log("BB>",B.x1,B.y1);
  B.banchors = [c[c.length - 1].x1 + c[c.length - 1].banchors[0], c[0].x1 + c[0].banchors[0]].sort((a, b) => a - b);
  return B;
}


/*
Example TChain for regular and variable chains
let B = TChain([1, 2, 3, 4, 5, 6, 7], false, true);
console.log(B.TeX(true));
B = TChain([1, 2, ["dotted", "1", "2"], 4, 5], true, false);
console.log(B.TeX(true));
B = TChain([1, 2, 3, 4, 5, 6, 7, ["dotted", "1", "2"], 4, 5], false, true);
console.log(B.TeX(true));
B = TChain([1, ["dotted", "1", "2"]], true, true);
console.log(B.TeX(true));
*/

/*
Example TChain of different lengths without and with links up
var B1 = Array.from({length: 8}, (_, n) => new TChain(Array.from({length: n + 1}, (_, i) => i + 1), false, false));
console.log(B1.map(b => b.TeX(true)).join(" \\qquad "));
var B2 = Array.from({length: 8}, (_, n) => new TChain(Array.from({length: n + 1}, (_, i) => i + 1), true, false));
console.log(B2.map(b => b.TeX(true)).join(" \\qquad "));
*/

/*
Example looped TChain of different lengths
var B = Array.from({length: 24}, (_, n) => TChain(Array.from({length: n + 1}, (_, i) => i + 1), true, true));
console.log(B.slice(0, 8).map(b => b.TeX(true)).join(" \\qquad "));
console.log(B.slice(8, 12).map(b => b.TeX(true)).join(" \\qquad "));
console.log(B.slice(12, 16).map(b => b.TeX(true)).join(" \\qquad "));
console.log(B.slice(12, 16).map(b => b.TeX(true)).join(" \\qquad "));
console.log(B.slice(16, 20).map(b => b.TeX(true)).join(" \\qquad "));
console.log(B.slice(20, 24).map(b => b.TeX(true)).join(" \\qquad "));
*/



function TPrincipalComponent(B, genus, mult, singular, childrenabove, childrenbelow, source = "") {
  /*
  Thick horizontal line representing a principal component to be placed in the box B. Returns its box and x-coordinate where it is to be placed.
  */

// console.log(`TPrincipalComponent g=${genus}<5} m=${mult}<5} sing=${singular}<5} src=${source}<5}`);

  let anchors = [];

  for (let c of childrenabove) {
    for (let b of c.banchors) {
      // console.log(">",JSON.stringify(c.AbsX()));
      // console.log(">",JSON.stringify(B.AbsX()));
      anchors.push(b + c.AbsX() - B.AbsX());
    }
  }
  for (let c of childrenbelow) {
    for (let t of c.tanchors) {
      anchors.push(t + c.AbsX() - B.AbsX());
    }
  }
  if (anchors.length === 0) {
    anchors = [0];
  }
 
  let x1 = Math.min(...anchors) - (1 / 3);  // extend to the left and right of children
  let x2 = Math.max(...anchors) + (1 / 3); 

  let linestyle = get(singular ? "princompsingstyle" : "princompstyle");
  let margins = getarray("princompmargins");

  mult = String(mult);
  genus = String(genus);
  if (genus === "0") {
    genus = "";
  }
  source = String(source);

  let princompmultofs = eval(get("princompmultofs"));     // initial offset 
  let princompmultsize = eval(get("princompmultsize"));   // per letter
  let rightlabelofs = (mult.length + genus.length + source.length === 0) ? 0 :
    princompmultofs + princompmultsize * Math.max(mult.length + genus.length, source.length === 0 ? 0 : 2);

  // console.log(">",rightlabelofs);

  let mglabel    = genus !== "" ? `${mult} \\smash{g}${genus}` : String(mult);
  let svgmglabel = genus !== "" ? `${mult} g${genus}` : String(mult);

  if (mglabel !== "") {
    let style = get(singular ? "prinsingcompmultstyle" : "princompmultstyle");
    mglabel = ` node${TikzOptions(style)} {${mglabel}}`;
  }

  if (source !== "") {
    mglabel += ` node${TikzOptions(get('princompnamestyle'))} {${source}}`;
  }

  let width = x2 - x1 + (1 / 2) + rightlabelofs;
  let height = 0;

  let svgtext = ['<text x="${x2}" y="${y2}"' + ` dy="-5" class="prinmult">${svgmglabel}</text>\n`];
  let H = TLine(width, height, {linestyle, margins, rightcode: mglabel, svgclass: "prinline", svgtext});

  // console.log(`TPrincipalComponent: H=${H.toString()}`);
  
  return {H: H, x: x1};
}



function PlacePrincipalComponent(G, B, chb, chu, w, ypos = 0) {
  /*
  Place a principal component w from a dual graph in the box B, with optional y-coordinate, covering the
  anchors of given sequences of boxes from below and above.
  */
  var g = G.Genus(w);                           // genus
  var m = G.Multiplicity(w);                    // multiplicity
  var texname = G.TeXName(w);                   // tex name, e.g. from cluster, face, etc., to display 
  var singular = false;                         // NOT IMPLEMENTED
  var Hdata = TPrincipalComponent(B, g, m, singular, chb, chu, texname); 
  AddChild(B, Hdata.H, { xpos: Hdata.x, ypos: ypos, first: true });
  // console.log("PPC>",Hdata.H.toString());
}


/*
Example
let G = redlib.DualGraph([2], [3], [], ["$c_1$"]);
let B = TBox.TBoxCreate();
PlacePrincipalComponent(G, B, [], [], "1");
console.log(B.TeX(true));
*/

/*
import redlib from './redtype.ts';
let G = redlib.DualGraph([2], [3], [], ["$c_1$"]);
let B = TBox.TBoxCreate();
PlacePrincipalComponent(G, B, [], [], "1");
console.log(B.TeX(true));
*/


function IsDTail(G, v) {
  /*
  Is this a principal component in a D-tail?
  */
  var g = G.Genus(v);                           // genus
  var m = G.Multiplicity(v);                    // multiplicity
  var texname = G.TeXName(v);                   // tex name, e.g. from cluster, face, etc., to display 
  var singular = false;                         // NOT IMPLEMENTED
  if (singular || texname !== "" || g > 0 || mod(m,2)==1) { 
    return false; 
  }
  return ArraysEqual(G.Neighbours(v).map(function(w) {return mod(G.Multiplicity(w),m);}).sort(),[0, m / 2, m / 2]);
}


function BoxChain(Vchain, G, D, open = false, placefirst = false) {
  /*
  Vchain = sequence of vertices v_1,...,v_n, representing either an open chain (open=True) or not (open=False)
  placefirst=True  : add the first component into the box as well, and its children
  placefirst=False : does not add the first component
  */

  for (let i = 0; i < Vchain.length - 1; i++) {          // Check we have a valid chain 
    if (D[ [Vchain[i],Vchain[i+1]] ].length === 0) {     //   with all intermediate links present
      throw new Error(`Invalid chain ${Vchain} - D is empty at [${i},${i+1}]`);
  }}     

  var B = [];
  var height = 0;

  // console.log(`BoxChain [${Vchain}] ${open ? 'open' : 'closed'} ${placefirst ? 'placefirst' : ''}`);

  var prinmargin = getarray("princompmargins");
  var minvspace = prinmargin[2] + prinmargin[3];  // top + bottom margins of a principal component

  for (let i = 0; i < Vchain.length; i++) {
    var w = Vchain[i];
    if (i === Vchain.length - 1 && !open) {
      break;
    }

    B.push(new TBox());
    B[i].x1 = 0;

    /*
    if (i>0) {
      console.log("B[i-1].y1>",B[i-1].y1);
      console.log("height   >",height);
      console.log("sum>      ",B[i - 1].y1 + height);
    }
    */

    if (i === 0) {
      var v = null;  // previous vertex
      var lastchain = [];  // children from v to w
      B[i].y1 = 0;  // where to place ith box vertically
      // console.log(`i=${i} c=${Vchain}: B[i].y1=0`);
    } else {
      v = Vchain[i - 1];
      // console.log(`i=${i} c=${Vchain}: B[i-1].y1=${B[i-1].y1} + height=${height} => B[i].y1=${B[i - 1].y1 + height}`);
      B[i].y1 = B[i - 1].y1 + height;
      lastchain = D[[v, w]];
    }

    // console.log("B[i].y1>",B[i].y1);
 
    var z = (i === Vchain.length - 1) ? null : Vchain[i + 1];
    var nextchain = (i === Vchain.length - 1) ? [] : D[[w, z]];
    // console.log("nextchain>",nextchain.toString());

    // Add w's children (loops, bullets, open chains, etc.), 
    // avoiding top anchors from lastchain
    // unless not placing this box yet
    if ((i !== 0 || placefirst) && (i !== Vchain.length - 1 || open)) {
      // console.log("D[[w]]>",D[[w]]);
      for (var b of D[[w]]) {
        AddChild(B[i], b, { avoid: lastchain });
      }
    }
    
    if (nextchain.length>0) {
      // Compute new height and rescale nextchain to match it
      
      height = Math.max(...[B[i].HeightWithMargins()].concat(nextchain.map(b => b.height)).concat([minvspace]));
      // console.log("ht",[B[i].HeightWithMargins()].concat(nextchain.map(b => b.height)).concat([minvspace]));
      // console.log("mht",height);
           
      VerticalScaleTo(nextchain, height);

      // Add children in nextchain, avoiding B[i]'s own children added before and top anchors from lastchain
      for (let j = 0; j < nextchain.length; j++) {
        var b = nextchain[j];
        AddChild(B[i], b, { avoid: lastchain });
      }
    }

    B[i].SetTopAnchorsFromBoxes(nextchain);
    B[i].SetBottomAnchorsFromBoxes(B[i].c);

    if (get("compactifydtails") !== "0" && IsDTail(G, w) &&         // Special case: D-tail, replace last box
        nextchain.length === 0 && lastchain.length === 1) {  
      var y = B[i].y1;                            // copy y coordinate from B[i] but overwrite the box itself
      B[i] = TDTail(G.Multiplicity(w));           // with a D-tail
      B[i].x1 = lastchain[0].x1 + lastchain[0].tanchors[0] - B[i].banchors[0];  // and place it
      B[i].y1 = y;
    } 

    // Add the principal component itself at the bottom, spanning to cover all children above and below
    else if ((i !== 0 || placefirst) && (i !== Vchain.length - 1 || open)) {

      // Squeeze children together if possible
      const bx = B[i].c.flatMap(C => C.banchors.map(b => C.AbsX() + b));    // Bottom anchors from newly placed children
      const tx = lastchain.flatMap(C => C.tanchors.map(t => C.AbsX() + t)); // Top anchors from below

      if (bx.length>0 && tx.length>0) {
        var epsilon = eval(get("chaincollisiondist"));
        var shift = 0;
        if (Math.max(...bx) + epsilon < Math.min(...tx)) {
          shift = Math.min(...tx) - Math.max(...bx) - epsilon;  // shift all bottom anchors to the right
        } else if (Math.max(...tx) + epsilon < Math.min(...bx)) {
          shift = Math.min(...bx) - Math.max(...tx) - epsilon;  // shift all bottom anchors to the left
        }

        if (shift !== 0) {
          vprint(`Shifting children of ${w} by ${shift}`);
          for (let j = 0; j < B[i].c.length; j++) {
            B[i].c[j].x1 -= shift;
          }

          B[i].SizeAndMarginsFromChildren();
          B[i].SetBottomAnchorsFromBoxes(B[i].c);
        }
      }

      PlacePrincipalComponent(G, B[i], B[i].c, lastchain, w, 0);
    }
  }

  var F = (B.length === 1) ? B[0] : Box(B);  // Put everything in one box
  if (B.length > 1) {
    F.SetBottomAnchorsFromBoxes([B[0]]);  // set bottom anchors from the first box in the chain
    F.SetTopAnchorsFromBoxes([B[B.length - 1]]);    // set top anchors from the last box in the chain
  }

  return F;
}


function ExtendChain(chain, root, Neighbours) {
  /*
  Extend a chain of vertices until it reaches the root or a vertex with more than two neighbours.
  chain: List of vertices forming the chain
  root: The root vertex
  Neighbours: A function that returns the neighbours of a vertex
  */
  
  while (true) {
    const v = chain[chain.length - 1];
    const N = Neighbours(v);

    if (v === root || N.length > 2) {
      return chain;
    }

    const Nnew = new Set(N).difference(new Set(chain));

    if (Nnew.size === 0) {            // If no new neighbors
      if (N.includes(chain[0])) {     // Close the loop if chain starts at a neighbor
        chain.push(chain[0]);
      }
      return chain;
    }

    chain.push([...Nnew][0]);  // Append a new neighbor to the chain
  }
}


/*
function ExtendChain(chain, root, Neighbours) {  //

  while (true) {
    var v = chain[chain.length - 1];
    var N = Neighbours(v);

    if (v === root || N.length > 2) {
      return chain;
    }

    var Nnew = new Set(N.filter(x => !chain.includes(x)));

    if (Nnew.size === 0) {  // If no new neighbors
      if (chain[0] in N) {  // Close the loop if chain starts at a neighbor
        chain.push(chain[0]);
      }
      return chain;
    }

    chain.push([...Nnew][0]);  // Append a new neighbor to the chain
  }
}
*/


function RemoveArrayElement(arr, val) {
  /*
  Remove an element val from an array arr, raising an error if it is not there
  */
  let index = arr.indexOf(val);
  console.assert(index != -1);
  arr.splice(index, 1);  
}


function RemoveVertex(P, D, v) {
  /*
  Remove a vertex from P and update the edge data in D.
  P: array of principal vertices
  D: pbject (dictionary) vertices [v], pairs [v,w] => sequence of boxes
  v: vertex to remove
  */
  RemoveArrayElement(P,v);      // Remove vertex from P
  delete D[[v]];                // Remove vertex v data from D
  for (let w of P) {            // Remove edge v,* data from D
    delete D[[v, w]];
    delete D[[w, v]];
  }
}


function MaxBoxHeight(ch) {
  /*
  Height of a chain
  */
  return Math.max(0, ...ch.map(b => b.tanchors.length>0 ? b.height : b.HeightWithMargins()));
  // return Math.max(0, ...ch.map(b => b.HeightWithMargins()));
  // return Math.max(0, ...ch.map(b => b.height));
  // return Math.max(0, ...ch.map(b => b.height + (b.tanchors.length>0 ? 0 : 0.5)));
}


function TeXDualGraphMain(G, root) {
  /*
  Main function to draw a dual graph, placing the root at the bottom. 
  root is the component to be placed at the bottom. Returns the final TBox.
  */

  // Step 1: Get the principal components
  var P = G.PrincipalComponents().slice();  // Shallow copy of the array

  if (new Set(P).size !== P.length) {  // Ensure no repeated names for principal components
    throw new Error("Repeated names of principal components in G");
  }

  // Step 2: Create an associative array (dictionary) to store vertex and edge data
  var D = {};

  for (var v of P) {
    D[[v]] = [];          // Initialize with an empty list for vertex v

    /*
    // Step 3: Loop through special/singular points and components of vertex v
    for (const [j, p] of G['V'][v]['singpts'].concat(G['V'][v]['pts']).entries()) {
      if (p === ["redbullet"]) {
        B = new TSingularPoint("");
      } else if (p === ["bluenode"]) {
        B = new TChain([["dotted", "", "?"]], true, true);
      } else {
        // Ensure the point is a tuple and has 5 elements
        if (!Array.isArray(p) || p.length !== 5) {
          throw new Error("Element of v['singpts'] must be 'redbullet', 'bluenode' or a tuple <style, node, width, height, margins>");
        }

        const [style, node, width, height, margins] = p;
        B = new TNode(style, node, width, height, margins);
      }

      // Append the constructed box B for this singular point/component
      D[[v]].push([[-1, j], B]);
    }
    */

    // Step 4: Initialize pair (v, w) for vertices w ? v
    for (var w of P) {
      if (w !== v) {
        D[[v, w]] = [];
      }
    }
  }

  for (const [j, chain] of G.specialchains.entries()) {

    // Unpacking chain elements
    var [v1, v2, singular, linestyle, endlinestyle, labelstyle, linemargins, P1linelength, c] = chain;

    // Convert elements of c based on their type
    c = c.map(d => typeof d === 'object' ? ["dotted", d[0], d[1]] : d);

    // Default linestyle adjustments for singular chains
    if (linestyle === "default" && singular) {
      linestyle = get("P1singlinestyle");
    }
    if (endlinestyle === "default" && singular) {
      endlinestyle = get("P1singendlinestyle");
    }

    // Determine if this is a loop or a link
    var linksup = (v2 !== "") && (v2 !== null);
    var loop = (v1 === v2);
    if (loop) {
      v2 = "";  // If loop, v2 is set to empty string
    }

    var sortdata = [-2, j];        // for sorting special chains

    // Create the chain box B
    var B = new TChain(
      c, linksup, loop, 
      { linestyle: linestyle, 
        endlinestyle: endlinestyle, 
        labelstyle: labelstyle, 
        linemargins: linemargins, 
        P1linelength: P1linelength }
    );

    // Append the chain to the dictionary D based on whether it's a loop or a link
    if (v2) {
      // If there's a link, append the box to both (v1, v2) and (v2, v1) in D
      D[[v1, v2]].push([sortdata, B]);

      // Create a reversed version of the chain for the reverse direction (v2 -> v1)
      var RB = new TChain(
        [...c].reverse(), linksup, loop,
        { linestyle: linestyle, 
          endlinestyle: endlinestyle, 
          labelstyle: labelstyle, 
          linemargins: linemargins, 
          P1linelength: P1linelength }
      );
      D[[v2, v1]].push([sortdata, RB]);

    } else {
      // If it's a loop, append only to (v1,)
      D[[v1]].push([sortdata, B]);
    }
  }

  for (var chain of G.ChainsOfP1s()) {                       // Chains of P1s
    var v1 = chain[0], v2 = chain[1], c = chain[2];   
    var m1 = G.Multiplicity(v1);

    var m2;
    if (!v2) {
      m2 = "undefined";
      if (!c) { 
        throw new Error("open chain cannot be empty");
      }
    } else {
      m2 = G.Multiplicity(v2);
    }

    var gcd = c.length>0 ? GCD(m1, c[0]) : GCD(m1, m2);                 // gcd of a chain
    var depth = c.length>0 ? c.filter((x) => x === gcd).length-1 : 0;   // depth of a chain or 0 (for sorting)

    // Handle different types of chains
    if (!v2) {  // Open chain
      if (!D[[v1]]) D[[v1]] = [];
      D[[v1]].push([[0, gcd, c[0]], TChain(c, false, false)]);

    } else if (v1 === v2) {  // Loop on a principal component
      var sortdata;
      if (!c) {  // If chain is empty
        sortdata = [1, gcd, m1, m1, 0];
      } else {
        // Reverse the chain if the first element is greater than the last
        if (c[0] > c[c.length - 1]) {
          c = [...c].reverse();
        }
        sortdata = [1, gcd, c[0], c[c.length - 1], depth];
      }

      if (!D[[v1]]) D[[v1]] = [];
      D[[v1]].push([sortdata, TChain(c, false, true)]);

    } else {  // Link chain between two different vertices
      var sortdata1, sortdata2;
      if (!c) {  // If chain is empty
        sortdata1 = [2, gcd, m2, m1];
        sortdata2 = [2, gcd, m1, m2];
      } else {
        sortdata1 = [2, gcd, c[0], c[c.length - 1]];
        sortdata2 = [2, gcd, c[c.length - 1], c[0]];
      }

      // Add depth to the sorting data
      sortdata1.push(depth);
      sortdata2.push(depth);

      // Add the chain in both directions (v1 -> v2 and v2 -> v1)
      if (!D[[v1, v2]]) D[[v1, v2]] = [];
      if (!D[[v2, v1]]) D[[v2, v1]] = [];
      D[[v1, v2]].push([sortdata1, TChain(c, true, false)]);
      D[[v2, v1]].push([sortdata2, TChain([...c].reverse(), true, false)]);
    }
  }

  for (var k in D) {    // sort by sortdata, and remove it from D keeping only the boxes
    var A = D[k];
    A.sort((d1, d2) => d1[0] - d2[0]);
    D[k] = A.map(d => d[1]);
  }

  /*
  Object.keys(D).forEach(k => {console.log(`${k} : ${D[k].length}`);});  
  function Neighbours(v) {          // Neighbours of v function for current D
    return P.filter(w => v !== w && D[[v, w]].length>0);
  }
  console.log(Neighbours("1"));
  console.log(Neighbours("2"));
  console.log(Neighbours("3"));
  */

  while (true) {  // Repeatedly contract tails and chains 

    while (true) {           // FIND AND CONTRACT TAILS
      var tail = [];       

      function Neighbours(v) {          // Neighbours of v function for current D
        return P.filter(w => v !== w && D[[v, w]].length>0);
      }

      for (var v of P) {         
        if (v === root || Neighbours(v).length !== 1) {
          continue;
        }
        tail = [...ExtendChain([v], root, Neighbours)].reverse();
        break;
      }

      if (tail.length === 0) {          // no tails left
        break;
      }

      vprint(`Contracting tail: ${tail}`);  

      var troot = tail[0];
      var F = BoxChain(tail, G, D, true); 
      // console.log("F>",F.x1,F.y1);
      D[[troot]] = D[[troot]].concat([F]);      // Append the chain F to troot's children

      for (var v of tail) {                       // Remove all vertices in the tail except the root
        if (v !== troot) {
          RemoveVertex(P, D, v);
        }
      }

    }

    // FIND AND CONTRACT CHAINS

    var chain = [];  
    var Neighbours = function(v) { return P.filter(w => v !== w && D[[v, w]].length>0); };

    for (var v of P) {
      if (v === root || Neighbours(v).length !== 2) {
        continue;
      }
      chain = ExtendChain([v], root, Neighbours);                    // Extend chain from v to root
      chain = ExtendChain([...chain].reverse(), root, Neighbours);   // Extend in the opposite direction
      break;
    }

    if (chain.length === 0) {
      break;
    }

    if (chain.length <= 2) {
      throw new Error(`Expected a chain of length >= 3, got ${chain}`);
    }

    var circular = chain[0] === chain[chain.length - 1];  // Check if the chain is circular

    // If circular, split the chain in two halves
    var contract, keep;
    if (circular) {
      var i = Math.floor((chain.length + 1) / 2);
      var c1 = chain.slice(0, i);      // First half, up to chain[i-1], inclusive
      var c2 = chain.slice(i - 1);    // Second half, from chain[i-1], inclusive
      contract = [c1, [...c2].reverse(), c2, [...c1].reverse()];  // Create contract lists with reversed chains
      keep = new Set([chain[0], chain[i - 1]]);                   // Keep track of first and mid-point vertices
    } else {
      contract = [chain, [...chain].reverse()];                   // Create contract lists with reversed chain
      keep = new Set([chain[0], chain[chain.length - 1]]);        // Keep track of first and last vertices
    }

    vprint(`Contracting ${circular ? 'circular' : 'linear'} chains: ${JSON.stringify(contract)}`);

    // Contract the chains
    for (var c of contract) {
      if (c.length === 2) {
        continue;
      }
      var v1 = c[0];
      var v2 = c[c.length - 1];
      console.assert(keep.has(v1) && keep.has(v2));   // Check again that the vertices to keep are correct
      var F = BoxChain(c, G, D);      // Contract the chain and store in F
      D[[v1, v2]].push(F);
    }

    // Remove vertices not in keep
    for (var v of chain) {
      if (!keep.has(v)) {
        RemoveVertex(P, D, v);
      }
    }
  }

  if (P.length === 4 &&                     // *** K4 ***
      (P.flatMap((v, i) => 
        P.map((w, j) => (i !== j ? D[[v, w]].length > 0 : true)) // Return true for equal indices
      ).every(isValid => isValid)))
  {
    var O = [root].concat(P.filter(s => s !== root));       // Sort vertices: root first (rest doesn't matter)

    const dd = s => D[s.map(i => P[i-1])];
   
    function PlaceBoxesAtHeight(B, H, C, avoid) {
      for (var c of C) {
        AddChild(B, c, {avoid: avoid, ypos: H});     // Add child boxes at specified height
      }
    }

    var H1 = 0;                                             // Height to place box #1 = 0 
    var ch1 = dd([1, 2]).concat(dd([1]));  
    var H2 = MaxBoxHeight(ch1);                             // Height for box #2
    var ch2A = dd([1, 3]);
    var ch2B = dd([2]).concat(dd([2, 3]));
    var H3 = Math.max(MaxBoxHeight(ch2A), H2 + MaxBoxHeight(ch2B));  // Height for box #2
    var ch3A = dd([1, 4]);
    var ch3B = dd([2, 4]);
    var ch3C = dd([3]).concat(dd([3, 4]));
    var H4 = Math.max(MaxBoxHeight(ch3A), H2 + MaxBoxHeight(ch3B), H3 + MaxBoxHeight(ch3C));  // Height for box #2

    VerticalScaleTo(ch1,  H2);                           // Rescale all children accordingly
    VerticalScaleTo(ch2A, H3);                          
    VerticalScaleTo(ch2B, H3 - H2);
    VerticalScaleTo(ch3A, H4);
    VerticalScaleTo(ch3B, H4 - H2);
    VerticalScaleTo(ch3C, H4 - H3);

    var B = new TBox();                                         // Create a new box
    PlaceBoxesAtHeight(B, H1, ch3A.concat(ch2A).concat(ch1), []);   // Place boxes at height H1
    PlaceBoxesAtHeight(B, H2, ch2B, ch1);               // Place boxes at height H2
    PlaceBoxesAtHeight(B, H3, ch3C, ch2A.concat(ch2B));       // Place boxes at height H3
    PlacePrincipalComponent(G, B, ch3C, ch2A.concat(ch2B), O[2], H3);  // Place principal component at height H3
    PlaceBoxesAtHeight(B, H2, ch3B, ch1);               // Place boxes at height H2
    PlacePrincipalComponent(G, B, ch2B.concat(ch3B), ch1, O[1], H2);        // Place principal component at height H2
    PlacePrincipalComponent(G, B, [], ch3A.concat(ch3B).concat(ch3C), O[3], H4);  // Place principal component at height H4

    for (var s of [O[1], O[2], O[3]]) {
      RemoveVertex(P, D, s);                            // Remove the three non-root vertices
    }

    B.SetBottomAnchorsFromBoxes(ch3A.concat(ch2A).concat(ch1));

    D[[root]] = [B]; 

  }

  // FINISHED, ONE VERTEX LEFT

  if (P.length === 1) {                                
    // console.log(`Placing final vertex D=${D}`);
    var F = BoxChain(P, G, D, true, true);    // Box it and return
    return F;  
  } else {
    return false;  // Return false if more than one vertex remains
  }

}


/*
Example Reduction types consisting of one tail
let L  = ["1g1", "1g1-1g1", "1g1-(3)1g1", "IV", "1g1--1g1", "1g1-1g1-1g1", "I0*-I0*"];   // works
let Rs = L.map(s => redlib.ReductionType(s));          // Reduction types
let Gs = Rs.map(R => R.DualGraph());                   // Dual graphs
let Fs = Gs.map(G => TeXDualGraphMain(G, "1"));        // TBoxes from each
let Ts = Fs.map(F => `\\cbox{${F.TeX(true)}}`);
console.log(`\\begin{minipage}{\\textwidth}${Ts.join(" \\qquad ")}\\end{minipage}`);
*/


/*
Example Reduction types consisting of one chain
let L  = ["1g1-1g1-1g1-c1", "IV-III-IV-1g1-c1"];
//    L  = [];      // doesn't
let Rs = L.map(s => redlib.ReductionType(s));          // Reduction types
let Gs = Rs.map(R => R.DualGraph());                   // Dual graphs
let Fs = Gs.map(G => TeXDualGraphMain(G, "1"));        // TBoxes from each
let Ts = Fs.map(F => `\\cbox{${F.TeX(true)}}`);
console.log(`\\begin{minipage}{\\textwidth}${Ts.join(" \\qquad ")}\\end{minipage}`);
*/


function TeXDualGraph(G, options={}) {
  /*
  Returns a tikz picture drawing a dual graph G, or a TBox if the option box=true. Options are:
    xscale = "default"      horizontal scale
    yscale = "default"      vertical scale
    scale = "default"       overall scale (cumulative with xscale, yscale)
    root = "default"        root, e.g. "all" or "1", "2", ... principal component to draw at the bottom
    weight = "width"          if root="all", try all and minimise "width", "height" or "area"
    oneline = false         replace line breaks by spaces in resulting TeX code
    [texsettings = []        other TeX settings - not yet implemented, just use Set/Get]
    box = false             return TBox instead of picture if box=true (used in SVGDualGraph)
  */

  /*
  savedsettings = get("settings");
  set("settings", [...savedsettings, ...texsettings]);
  */

  if (typeof options !== 'object' || options === null || Array.isArray(options)) {
    throw new Error("Options parameter is not an object, expected {xscale, yscale, scale, root, oneline, texsettings, box}.");
  }

  let {
    xscale = "default", 
    yscale = "default", 
    scale = "default", 
    root = "default", 
    weight = "area", 
    oneline = false, 
    texsettings = [], 
    box = false
  } = options;

  // x-scale and y-scale for the whole tikz picture

  if (scale === "default") { scale = eval(get("scale")); }
  if (xscale === "default") { xscale = eval(get("xscale")); }
  if (yscale === "default") { yscale = eval(get("yscale")); }
  xscale = scale * xscale;
  yscale = scale * yscale;

  // root to put at the bottom. if "all", will try all principal components, 
  // and choose best picture

  var roots;
  if (root === "default") { root = get("root"); }
  if (root === "all") {
    roots = G.PrincipalComponents();
  } else {
    if (!G.PrincipalComponents().includes(root)) {
      throw new Error("root, if specified, must be in G.PrincipalComponents()");
    }
    roots = [root];
  }

  if (!["area", "width", "height"].includes(weight)) {
    throw new Error("weight should be area, width or height");
  }

  let Weight;
  if (weight === "area")         {Weight = B => B.width * B.height;} 
    else if (weight === "width") {Weight = B => B.width;} 
    else                         {Weight = B => B.height;}

  let best = false;
  for (let root of roots) {
    let B = TeXDualGraphMain(G, root);
    if (B === false) {
      continue;
    }
    if (best === false || Weight(B) < Weight(best)) {
      best = B;
    }
  }

  /*
  set("settings", savedsettings);
  */

  if (best === false) {return "";}              // Failed
  if (box) {return best;}                       // return box for debugging

  let out = "\\begin{tikzpicture}[xscale={xscale},yscale={yscale}]\n{pic}\\end{tikzpicture}";
  out = out.replace("{xscale}", RR(xscale)).replace("{yscale}", RR(yscale)).replace("{pic}", best.TeX());
  if (oneline) {
    out = out.replace("\n", " ").replace("    ", " ").replace("   ", " ").replace("  ", " ");
  }

  return out;
}


function SVGDualGraph(G, options={}) {
/*
Returns a svg drawing a dual graph. See TeXDualGraph for the description of options.}
  */
  options.box = true;
  options.weight = (options.weight=="area" || options.weight=="height") ? options.weight : "width";
  var B = TeXDualGraph(G, options);
  if (B === "") {   // Failed 
    throw new Error("Not planar or too complex to draw");
  }
  let leftxmargin = eval(get("svgleftxmargin"));
  let rightxmargin = eval(get("svgrightxmargin"));
  let topymargin = eval(get("svgtopymargin"));
  let bottomymargin = eval(get("svgbottomymargin"));
  B.x1 = leftxmargin;
  B.y1 = -topymargin;

  var width     = B.SVGxCoordinate(B.width + leftxmargin + rightxmargin);      // default width and height
  var height    = B.SVGyCoordinate(0 - topymargin - bottomymargin);
  var minWidth  = eval(get("minsvgwidth"));                  
  var minHeight = eval(get("minsvgheight"));                 
  var viewBoxX  = 0;
  var viewBoxY  = 0;
 
  if (width < minWidth) {                        // extend margins if too small horizontally
    viewBoxX = (width - minWidth) / 2;           
    width = minWidth;          
  }
  if (height < minHeight) {                      // sink down if too small vertically
    viewBoxY = (height-minHeight) * 0.8;
    height = minHeight;
  }

  var header = `<svg viewBox="${viewBoxX} ${viewBoxY} ${width} ${height}" xmlns="http://www.w3.org/2000/svg">\n`;
  var footer = `</svg>\n`;
  var texcode = B.SVG();
  
  return header+texcode+footer;
}


/*
Example Dual graphs of various reduction types
var L = ["III", "II_D", "II_(2)D", "IV-IV", "I1", "D=D=D", "IV-III-1g1-I19", "D=D=D&c2=D", "1g1-1g2-1g3", "1g1-1g1-1g1-c1", "1g1-1g1-1g1-1g1-c1"];
var Rs = L.map(s => redlib.ReductionType(s));     // Reduction types
var Gs = Rs.map(R => R.DualGraph());              // Dual graphs
var Fs = Gs.map(G => TeXDualGraph(G, {xscale: 0.8, yscale: 0.8}));  // TeX each one
var Ts = Fs.map(F => "\\cbox{" + F + "}");
console.log("\\begin{minipage}{\\textwidth}" + Ts.join(" \\qquad ") + "\\end{minipage}");
*/


/*
Example K4
let R = redlib.ReductionType("1-(3)IV-(3)IV*-(2)I0*-(3)c1-(2)c3&c2-(4)c4");
console.log(R.TeX({scale: 1.5}));
let G = R.DualGraph();
console.log(TeXDualGraph(G));
*/



/*
let L  = ["1g1-1g1", "1g1-(3)1g1", "IV", "1g1--1g1--1g1", "1g1-1g1-1g1"];
*/

/*
import redlib from './redtype.ts';
TVERBOSE = true;

let L  = ["1g1-1g1-1g1-c1", "IV-III-IV-1g1-c1"];
    L  = ["1g1-1g1-1g1-1g1-c1"];      // doesn't
let Rs = L.map(s => redlib.ReductionType(s));          // Reduction types
let Gs = Rs.map(R => R.DualGraph());                   // Dual graphs
let Fs = Gs.map(G => TeXDualGraphMain(G, "2"));        // TBoxes from each
let Ts = Fs.map(F => `\\cbox{${F.TeX(true)}}`);
console.log(`\\begin{minipage}{\\textwidth}${Ts.join(" \\qquad ")}\\end{minipage}`);
console.log(TeXSize(Fs[0]));
*/

//console.log(Fs[0].toString());
//console.log(Fs[0].c[0].toString());
//console.log(Fs[0].c[1].toString());
//console.log(Fs[0].c[1].c[0].toString());
//console.log(Fs[0].c[1].c[0].c[0].toString());
//console.log(Fs[0].c[1].c[0].c[1].toString());
//console.log(Fs[0].c[1].c[0].c[2].toString());

/*
Example
const R = redlib.ReductionType("1g1-(3)IV-(3)IV*_{3-3}18-(2)I0*-(3)c1-(2)c3&c2-(4)c4");
const G = R.DualGraph();
console.log(TeXDualGraph(G));
*/

/*
import redlib from './redtype.ts';

let R = redlib.ReductionType("I1");
let G = R.DualGraph();
// TVERBOSE = true;
// console.log(TeXDualGraph(G));
//let B = TeXDualGraphMain(G,"1");

//console.log(redlib.SVGGraph(G.G));
console.log(SVGDualGraph(G));
*/

/*
import redlib from './redtype.ts';

//let R = redlib.ReductionType("I0*_D");
let R = redlib.ReductionType("1g1-(10)1g1");
let G = R.DualGraph();
console.log(SVGDualGraph(G));

*/


/*
import redlib from './redtype.ts';

var R = redlib.ReductionType("I0*_1,2,3,4,12,D,2D,3D");
const G = R.DualGraph();
var html = SVGDualGraph(G);

console.log(html);
*/
