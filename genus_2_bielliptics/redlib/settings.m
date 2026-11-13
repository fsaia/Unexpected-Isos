/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

Global settings array (Q`Settings)
*/

/*****

*** Controlling global settings ***

intrinsic Settings() -> Assoc
  Current global settings
intrinsic Settings(S::SeqEnum[SeqEnum[MonStgElt]]) -> Assoc
  Convert S=[["key","value"],...] to a setting array
intrinsic SetSettings(S::Assoc)
  Set all global settings (overwrite)
intrinsic SetSettings(S::SeqEnum[SeqEnum[MonStgElt]])
  Set all global settings (overwrite), S=[["key","value"],...]
intrinsic AddSettings(~S::Assoc, N::Assoc)
  Add settings N to S
intrinsic AddSettings(~S::Assoc, N::SeqEnum[SeqEnum[MonStgElt]])
  Add N=[["key","value"],...] to settings S
intrinsic AddSettings(N::Assoc)
  Add to global settings
intrinsic AddSettings(N::SeqEnum[SeqEnum[MonStgElt]])
  Add to global settings, N=[["key","value"],...]
intrinsic GetSetting(S::Assoc, key::MonStgElt) -> .
  Get a setting from a setting array S, raise error if not found
intrinsic GetSetting(key::MonStgElt) -> .
  Get a global setting, raise error if not found
intrinsic GetSettingZ(S::Assoc, key::MonStgElt) -> RngIntElt
  Get an integer setting from a setting array S, raise error if not found
intrinsic GetSettingZ(key::MonStgElt) -> RngIntElt
  Get a global integer setting, raise error if not found
intrinsic GetSettingBool(S::Assoc, key::MonStgElt) -> RngIntElt
  Get a boolean setting from a setting array S, raise error if not found
intrinsic GetSettingBool(key::MonStgElt) -> RngIntElt
  Get a global boolean setting, raise error if not found
intrinsic HaveSetting(S::Assoc, key::MonStgElt) -> BoolElt, .
  Check if S has a setting key, return true, S[key] if yes
intrinsic HaveSetting(key::MonStgElt) -> BoolElt, .
  Check if there is a global setting key, return true, Settings()[key] if yes
intrinsic SetSetting(~S::Assoc, key::MonStgElt, v::Any : new:=false)
  Set a setting S[key]:=v; if new=true, only set if not set yet
intrinsic SetSetting(key::MonStgElt, v::Any : new:=false)
  Set a global setting; if new=true, only set if not set yet
intrinsic DefaultModelSettings(: DeltaScale:="0.8,0.6", ModelScale:="0.8,0.7") -> Assoc
  Default TeX settings for regular models
*****/


import "mmylib.m": Z, SetQAttribute, GetQAttribute;


/// Controlling global settings


intrinsic Settings() -> Assoc
{Current global settings}
  return GetQAttribute("Settings", DefaultModelSettings);
end intrinsic;


intrinsic Settings(S::SeqEnum[SeqEnum[MonStgElt]]) -> Assoc
{Convert S=[["key","value"],...] to a setting array}
  A:=AssociativeArray();
  for d in S do
    A[d[1]]:=d[2]; 
  end for;
  return A;
end intrinsic;


intrinsic SetSettings(S::Assoc)
{Set all global settings (overwrite)}
  SetQAttribute("Settings", S);
end intrinsic;


intrinsic SetSettings(S::SeqEnum[SeqEnum[MonStgElt]])
{Set all global settings (overwrite), S=[["key","value"],...]}
  A:=AssociativeArray();
  for d in S do
    A[d[1]]:=d[2]; 
  end for;
  SetSettings(A);
end intrinsic;


intrinsic AddSettings(~S::Assoc, N::Assoc)
{Add settings N to S}
  for k in Keys(N) do
    S[k]:=N[k];
  end for;
end intrinsic;


intrinsic AddSettings(~S::Assoc, N::SeqEnum[SeqEnum[MonStgElt]])
{Add N=[["key","value"],...] to settings S}
  for d in N do
    S[d[1]]:=d[2]; 
  end for;
end intrinsic;


intrinsic AddSettings(N::Assoc)
{Add to global settings}
  S:=Settings();
  for k in Keys(N) do
    S[k]:=N[k];
  end for;
  SetSettings(S);
end intrinsic;


intrinsic AddSettings(N::SeqEnum[SeqEnum[MonStgElt]])
{Add to global settings, N=[["key","value"],...]}
  A:=AssociativeArray();
  for d in N do
    A[d[1]]:=d[2]; 
  end for;
  AddSettings(A);
end intrinsic;


intrinsic GetSetting(S::Assoc, key::MonStgElt) -> .
{Get a setting from a setting array S, raise error if not found}
  ok,v:=IsDefined(S,key);
  error if not ok, Sprintf("Setting %o is not defined (have %o keys)", key, #Keys(S));
  return v;
end intrinsic;


intrinsic GetSetting(key::MonStgElt) -> .
{Get a global setting, raise error if not found}
  return GetSetting(Settings(),key);
end intrinsic;


intrinsic GetSettingZ(S::Assoc, key::MonStgElt) -> RngIntElt
{Get an integer setting from a setting array S, raise error if not found}
  return Z!(eval GetSetting(S,key));
end intrinsic;


intrinsic GetSettingZ(key::MonStgElt) -> RngIntElt
{Get a global integer setting, raise error if not found}
  return Z!(eval GetSetting(key));
end intrinsic;


intrinsic GetSettingBool(S::Assoc, key::MonStgElt) -> BoolElt
{Get a boolean setting from a setting array S, raise error if not found}
  return Parent(true)!(eval GetSetting(S,key));
end intrinsic;


intrinsic GetSettingBool(key::MonStgElt) -> BoolElt
{Get a global boolean setting, raise error if not found}
  return Parent(true)!(eval GetSetting(key));
end intrinsic;


intrinsic HaveSetting(S::Assoc, key::MonStgElt) -> BoolElt, .
{Check if S has a setting key, return true, S[key] if yes}
  return IsDefined(S,key);
end intrinsic;


intrinsic HaveSetting(key::MonStgElt) -> BoolElt, .
{Check if there is a global setting key, return true, Settings()[key] if yes}
  return IsDefined(Settings(),key);
end intrinsic;


intrinsic SetSetting(~S::Assoc, key::MonStgElt, v::Any : new:=false)
{Set a setting S[key]:=v; if new=true, only set if not set yet}
  if not (new and IsDefined(S,key)) then  
    S[key]:=v;
  end if;
end intrinsic;


intrinsic SetSetting(key::MonStgElt, v::Any : new:=false)
{Set a global setting; if new=true, only set if not set yet}
  S:=Settings();
  if not (new and IsDefined(S,key)) then  
    S[key]:=v;
    SetSettings(S);
  end if;
end intrinsic;


intrinsic DefaultModelSettings(: DeltaScale:="0.8,0.6", ModelScale:="0.8,0.7") -> Assoc
{Default TeX settings for regular models}
  return Settings([
    // Formats
    ["OutputFormat","%o\\hfill%o\\hfill\\hfill\n%o\\hfill%o"],
    ["DeltaFormat","\\pbox[c]{20cm}{\n%o\n}"],
    ["ModelFormat","\\pbox[c]{20cm}{\n%o\n}"],
    ["ChartsFormat","$\\begin{array}{lllll}\n%o\\end{array}\n$"],
    ["EquationFormat","$%o$"],
    // Main parameters
    ["SmallValuations","true"],
    ["LargeValuations","true"],
    ["ContractFaces","true"],
    ["RemoveFaces","true"],
    ["BakerRegulars","true"],
    ["ShowCharts","false"],
    ["FaceNames","true"],
    ["ChainNumbers","false"],
    ["Warnings","true"],
    ["ShowEquation","false"],    // true, false or an integer (max number of terms)
    ["DeltaScale",DeltaScale],    // e.g. "1" (no scaling), "0.7" or "0.8,0.6" (vert,horiz)
    ["ModelScale",ModelScale],    //      same
    // Delta_v tikz setting 
    ["sml","scale=0.55"], 
    ["lrg","scale=0.9,inner sep=0.2em"],   // ,text depth=0.3ex, text height=1.7ex as a strut?
    ["fname","blue,scale=0.55"], 
    ["lname","scale=0.55,sloped,red,above=-0.07em,near end"],
    ["lin","-,shorten <=-0.07em,shorten >=-0.07em"],
    ["rem","black!20,thin"],

    // Dual graph TeX settings

    ["dualgraph.DebugBoxMargins","none"],                  // Show BoX margins in green for debugging all/top/none
    ["dualgraph.DebugMarginLineColor","green!60"],
    ["dualgraph.DebugMarginShadeColor","green!10"],
    ["dualgraph.DebugMarginShadeWidth","0.08"],
    ["dualgraph.DebugBAnchorColor","green"],
    ["dualgraph.DebugTAnchorColor","green!50!black"],
    ["dualgraph.DebugAnchorRadius","2pt"],
    
    ["dualgraph.scale","1"],                               // Global scaling for the whole tikzpicture
    ["dualgraph.xscale","1"],                              //   [xscale*scale, yscale*scale]
    ["dualgraph.yscale","0.9"],                            

    ["dualgraph.root","all"],                              // by default try all comps at the bottom and return best picture
    ["dualgraph.conncompsep","\n\n"],                      // separate connected components if multiple
    
    ["dualgraph.P1linelength","3/5"],                                // P1 in a chain: length in tikz units
    ["dualgraph.P1extlinelength","4/5"],                             //   extended when the only component between two principal ones
    ["dualgraph.P1linestyle","shorten <=-3pt, shorten >=-3pt"],      //   \draw[...] style for P1s in a chain or loop (w overlaps)
    ["dualgraph.P1endlinestyle","shorten <=-3pt"],                   //   last P1 does not have anything to overlap with
    ["dualgraph.P1singlinestyle","shorten <=-3pt, shorten >=-3pt, thick, red"],// same as last two but for singular chains
    ["dualgraph.P1singendlinestyle","shorten <=-3pt, thick, red"],   //   
    ["dualgraph.P1multstyle","inner sep=2pt,scale=0.8,blue"],        //   label style for multiplicity
    ["dualgraph.P1linemargins","<2/5,2/5,3/5,0>"],                   //   margins to repel other boxes (l,r,t,b)
    ["dualgraph.P1arcmargins","<1/4,1/4,1/8,1/8>"],                  //   for an arc of P1s

    ["dualgraph.compactifydtails","1"],                              // Compactify D-tails yes (1)/no (0)
    ["dualgraph.dtailmargins","<1/3,1/3,1/3,0>"],                    //   for an D-tail on top of a chains
    ["dualgraph.dtailprinlength","7/5"],                             //   length of the principal component in a D-tail
    ["dualgraph.dtailprinlinestyle",""],                             //   style for the principal component in a D-tail
    
    ["dualgraph.chaincollisiondist","3/5"],                          // horizontal min collision distance between chain anchors
    
    ["dualgraph.chdotlinestyle",""],                                 // Dotted chain: line style
    ["dualgraph.chdotlengthfactor","2"],                             //   length factor compared to std P1
    ["dualgraph.chdotmultstyle","blue,scale=0.7"],                   //   chain multiplicity label style
    ["dualgraph.chdotlenstyle","auto,inner sep=5,scale=0.7"],        //   chain length label style
    ["dualgraph.chdotmargins","<1/2,1/2,1/2,1/2>"],                  //   box margins
    ["dualgraph.chdotloopscale","0.8"],                              // Dotted loop: overall scale
    ["dualgraph.chdotlooplenstyle","below=0.1,anchor=north,scale=0.7"],  //   chain loop label style
    ["dualgraph.chdotloopmargins","<1/3,1/3,1/3,1/3>"],              //   margins in loop case
    
    ["dualgraph.princompnamestyle","inner sep=2pt,below left,scale=0.8"],  // style for the component name (below right)
    ["dualgraph.princompstyle","thick,shorten >=2"],                 // principal non-singular component line style (above right)
    ["dualgraph.looplinestyle","thick"],                             // loop (node) on a principal component (TLoop)
    ["dualgraph.princompsingstyle","red,thick,shorten >=2"],         // principal singular component line style
    ["dualgraph.princompmultstyle","inner sep=2pt,blue,above left,scale=0.8"], // principal non-singular component multiplicity style
    ["dualgraph.prinsingcompmultstyle","red,above left,scale=0.8"],            // principal singular component multiplicity style
    ["dualgraph.princompmultsize","1/5"],                            // approximate horizontal label size per m-g letter
    ["dualgraph.princompmultofs","3/5"],                             // extend component to print labels on the right
    ["dualgraph.princompmargins","<2/5,3/5,2/5,1/4>"],               // l, r, t, b margins for principal components
    
    ["dualgraph.singptstyle","red"],                                 // singular point on a principal component (red bullet)
    ["dualgraph.singptlabelstyle","above,inner sep=0pt,scale=0.7,red"],// label style
    ["dualgraph.singptsize","1/10"],                                 //   size on a component
    ["dualgraph.singptmargins","<1/5,1/5,1/5,1/5>"],                 //   margins 
    
    ["delta.erroronden","true"],                   // deltalib5.m error when den(p)<>1
    ["delta.erroronsteps","true"],                 // deltalib5.m error when out of steps in EquationToXYZ
    ["delta.erroronmatneg","true"],                // deltalib5.m error when mat[3][3]<=0 in ResolveSingularity
    ["delta.errorondim1","true"],                  // deltalib5.m error when 1-dim singular locus
    ["delta.texgraphweight","height"],             // what to minimise
    ["delta.scale","1"],                           // deltalib.m TeX(DeltaModel) parameters
    ["delta.xscale","0.9"],
    ["delta.yscale","0.9"],
    ["delta.dualgraph.scale","1"],
    ["delta.dualgraph.xscale","0.6"],
    ["delta.dualgraph.yscale","0.9"],
    ["delta.edgestyle",""],                        // regular edge line style
    ["delta.invisibleedgestyle","black!30"],       // lies on an invisible face (v_Z(Z)<0)
    ["delta.terminaledgestyle","green!85!black"],  // v_Y(Z)=0, outer edge of denominator delta_L=delta_F (see Newton p.19, dagger)
    ["delta.invalidedgestyle","thick,purple"],     // v_Y(Z)<0 or v_Z(Z)<0, contradicts m23, m33>=0 (see Newton p.20)
    ["delta.drawinvisible","false"]                // draw invisible faces and edges 
    
  ]);  
end intrinsic;
