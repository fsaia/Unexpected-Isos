/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

Model, ReductionType wrapping functions (type CrvModel)

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

type CrvModel:
  // Original equation, ground field, valuation
  forg,        // original equation defining the curve C
  f,           // working equation for the curve C
  K,           // base field
  k,           // residue field
  pi,          // uniformiser
  red,         // reduction map O_K->k
  lift,        // lifting k->O_K
  v,           // valuation on K
   // Delta and Delta_v polytopes and v-faces of dimension 2,1,0
  Delta,       // 2D polytope from the monomials of the defining equation
  mons,        // monomial exponents [[x,y,v],...]
  InnP,        // interior integer points on Delta, their number is the genus of C
  AllP,        // all integer points on Delta, including the boundary
  vF,          // z-coordinate function on jth 2-face evaluated at [x,y]
  vP,          // values of vF on points in AllP (with respect to their faces)
  Fs,          // v-Faces of Delta (2-dim polytopes)
  Ls,          // v-Edges of Delta (1-dim polytopes)
  Vs,          // v-Vertices of Delta (0-dim polytopes)
  AllFP,       // all integer points on v-faces
  AllLP,       // all integer points on v-edges
  InnFP,       // interior integer points on v-faces
  InnLP,       // interior integer points on v-edges
  deltaF,      // index v_F(F)/Z = multiplicity m of the corresponding component
  deltaL,      // index v_L(L)/Z = gcd of the corresponding chain
  FIsRemovable,       // booleans for faces in Fs - removable?
  FIsContractible,    // - contractible?
  FIsSingular,        // - singular reduction?
  FL,          // list of 1-faces on a given 2-face
  FV,          // list of 0-faces on a given 2-face
  FC,          // centers of 2-faces
  LF,          // list of non-removable 2-faces bounding a given 1-face
  MFwd,        // chart transformation matrices
  MInv,        // and their inverses
  comps,       // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...] - components
  Lpts,        // [<Lindex,root,mult,sing,name>,...] of type LPtsRec - singular points from edges
  ContractibleChains,   // list of contractible chains (if ContractFaces is set to true in Style)
  // Dual graph and reduction type
  G,           // dual graph
  R,           // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  Sigma,
  // Model type
  type,        // "clusters" (MacLane-Muselli) or "delta" (Delta-regular)
  // Settings and TeX
  Style,       // defining settings passed to Model
  eqnTeX,      // defining equation in TeX
  sigmaTeX,    // clusters in TeX (Maclane-Muselli)
  deltaTeX,    // Newton polytope and v-faces in TikZ (Delta-regular)
  chartsTeX;   // charts for components in TeX (Delta-regular)

*
* IMPLEMENTS
*
type CrvModel
declare attributes CrvModel: 
  // Original equation, ground field, valuation
  forg,       // original equation defining the curve C
  f,          // working equation for the curve C
  K,          // base field
  k,          // residue field
  pi,         // uniformiser
  red,        // reduction map O_K->k
  lift,       // lifting k->O_K
  v,          // valuation on K
  // Delta and Delta_v polytopes and v-faces of dimension 2,1,0
  Delta,      // 2D polytope from the monomials of the defining equation
  mons,       // monomial exponents [[x,y,v],...]
  InnP,       // interior integer points on Delta, their number is the genus of C
  AllP,       // all integer points on Delta, including the boundary 
  vF,         // z-coordinate function on jth 2-face evaluated at [x,y]
  vP,         // values of vF on points in AllP (with respect to their faces)
  Fs,         // v-Faces of Delta (2-dim polytopes)
  Ls,         // v-Edges of Delta (1-dim polytopes)
  Vs,         // v-Vertices of Delta (0-dim polytopes)
  AllFP,      // all integer points on v-faces
  AllLP,      // all integer points on v-edges
  InnFP,      // interior integer points on v-faces
  InnLP,      // interior integer points on v-edges
  deltaF,     // index v_F(F)/Z = multiplicity m of the corresponding component
  deltaL,     // index v_L(L)/Z = gcd of the corresponding chain
  FIsRemovable,      // booleans for faces in Fs - removable?
  FIsContractible,   // - contractible?
  FIsSingular,       // - singular reduction?
  FL,         // list of 1-faces on a given 2-face
  FV,         // list of 0-faces on a given 2-face
  FC,         // centers of 2-faces
  LF,         // list of non-removable 2-faces bounding a given 1-face
  MFwd,       // chart transformation matrices
  MInv,       // and their inverses
  comps,      // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...] - components
  Lpts,       // [<Lindex,root,mult,sing,name>,...] of type LPtsRec - singular points from edges
  ContractibleChains,  // list of contractible chains (if ContractFaces is set to true in Style)
  // Dual graph and reduction type
  G,          // dual graph
  R,          // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  Sigma,
  // Model type
  type,       // "clusters" (MacLane-Muselli) or "delta" (Delta-regular)
  // Settings and TeX
  Style,      // defining settings passed to Model  
  eqnTeX,     // defining equation in TeX
  sigmaTeX,   // clusters in TeX (Maclane-Muselli) 
  deltaTeX,   // Newton polytope and v-faces in TikZ (Delta-regular)
  chartsTeX;  // charts for components in TeX (Delta-regular)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(C::CrvModel, level::MonStgElt)                                                                  [191]
  Print a curve model
*
* Invariants
*
intrinsic DualGraph(C::CrvModel) -> GrphDual                                                                    [206]
  Dual graph of a curve model
intrinsic ReductionType(C::CrvModel) -> RedType                                                                 [212]
  Reduction graph of a curve model, or false if singular
intrinsic IsSingular(C::CrvModel) -> RedType                                                                    [218]
  true if failed to find a regular model (neither hyperelliptic nor Delta_v-regular)
intrinsic Genus(C::CrvModel) -> RngIntElt                                                                       [224]
  Genus of the generic fibre of a model
intrinsic IsGood(C::CrvModel) -> BoolElt                                                                        [232]
  true if comes from a curve wih good reduction
intrinsic IsSemistable(C::CrvModel) -> BoolElt                                                                  [239]
  true if comes from a curve with semistable reduction
intrinsic IsSemistableTotallyToric(C::CrvModel) -> BoolElt                                                      [246]
  true if comes from a curve with semistable totally toric reduction
intrinsic IsSemistableTotallyAbelian(C::CrvModel) -> BoolElt                                                    [253]
  true if comes from a curve with semistable totally abelian reduction
intrinsic TeX(M::CrvModel: Charts:=false, Equation:=false, Delta:=false, RedType:=false, texsettings:=[]) -> MonStgElt  [280]
  Full TeX description of a model of a curve
*
* Model and ReductionType wrappers
*
intrinsic Model(X::Any, P::Any: model:="default", Style:=[]) -> CrvModel                                        [326]
intrinsic Model(X::Any: model:="default", Style:=[]) -> CrvModel                                                [418]
intrinsic ReductionType(X::Any, P::Any) -> RedType                                                              [428]
  Reduction type of X at P
intrinsic ReductionType(X::Any) -> RedType                                                                      [434]
  Reduction type of X at the default valuation of its base field

*
* IMPLEMENTS
*
type CrvModel
declare attributes CrvModel: 
  // Original equation, ground field, valuation
  forg,       // original equation defining the curve C
  f,          // working equation for the curve C
  K,          // base field
  k,          // residue field
  pi,         // uniformiser
  red,        // reduction map O_K->k
  lift,       // lifting k->O_K
  v,          // valuation on K
  // Delta and Delta_v polytopes and v-faces of dimension 2,1,0
  Delta,      // 2D polytope from the monomials of the defining equation
  mons,       // monomial exponents [[x,y,v],...]
  InnP,       // interior integer points on Delta, their number is the genus of C
  AllP,       // all integer points on Delta, including the boundary 
  vF,         // z-coordinate function on jth 2-face evaluated at [x,y]
  vP,         // values of vF on points in AllP (with respect to their faces)
  Fs,         // v-Faces of Delta (2-dim polytopes)
  Ls,         // v-Edges of Delta (1-dim polytopes)
  Vs,         // v-Vertices of Delta (0-dim polytopes)
  AllFP,      // all integer points on v-faces
  AllLP,      // all integer points on v-edges
  InnFP,      // interior integer points on v-faces
  InnLP,      // interior integer points on v-edges
  deltaF,     // index v_F(F)/Z = multiplicity m of the corresponding component
  deltaL,     // index v_L(L)/Z = gcd of the corresponding chain
  FIsRemovable,      // booleans for faces in Fs - removable?
  FIsContractible,   // - contractible?
  FIsSingular,       // - singular reduction?
  FL,         // list of 1-faces on a given 2-face
  FV,         // list of 0-faces on a given 2-face
  FC,         // centers of 2-faces
  LF,         // list of non-removable 2-faces bounding a given 1-face
  MFwd,       // chart transformation matrices
  MInv,       // and their inverses
  comps,      // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...] - components
  Lpts,       // [<Lindex,root,mult,sing,name>,...] of type LPtsRec - singular points from edges
  ContractibleChains,  // list of contractible chains (if ContractFaces is set to true in Style)
  // Dual graph and reduction type
  G,          // dual graph
  R,          // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  Sigma,
  // Model type
  type,       // "clusters" (MacLane-Muselli) or "delta" (Delta-regular)
  // Settings and TeX
  Style,      // defining settings passed to Model  
  eqnTeX,     // defining equation in TeX
  sigmaTeX,   // clusters in TeX (Maclane-Muselli) 
  deltaTeX,   // Newton polytope and v-faces in TikZ (Delta-regular)
  chartsTeX;  // charts for components in TeX (Delta-regular)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(C::CrvModel, level::MonStgElt)                                                                  [250]
  Print a curve model
*
* Invariants
*
intrinsic DualGraph(C::CrvModel) -> GrphDual                                                                    [265]
  Dual graph of a curve model
intrinsic ReductionType(C::CrvModel) -> RedType                                                                 [271]
  Reduction graph of a curve model, or false if singular
intrinsic IsSingular(C::CrvModel) -> RedType                                                                    [277]
  true if failed to find a regular model (neither hyperelliptic nor Delta_v-regular)
intrinsic Genus(C::CrvModel) -> RngIntElt                                                                       [283]
  Genus of the generic fibre of a model
intrinsic IsGood(C::CrvModel) -> BoolElt                                                                        [291]
  true if comes from a curve wih good reduction
intrinsic IsSemistable(C::CrvModel) -> BoolElt                                                                  [298]
  true if comes from a curve with semistable reduction
intrinsic IsSemistableTotallyToric(C::CrvModel) -> BoolElt                                                      [305]
  true if comes from a curve with semistable totally toric reduction
intrinsic IsSemistableTotallyAbelian(C::CrvModel) -> BoolElt                                                    [312]
  true if comes from a curve with semistable totally abelian reduction
intrinsic TeX(M::CrvModel: Charts:=false, Equation:=false, Delta:=false, RedType:=false, texsettings:=[]) -> MonStgElt  [339]
  Full TeX description of a model of a curve
*
* Model and ReductionType wrappers
*
intrinsic Model(X::Any, P::Any: model:="default", Style:=[]) -> CrvModel                                        [385]
intrinsic Model(X::Any: model:="default", Style:=[]) -> CrvModel                                                [477]
intrinsic ReductionType(X::Any, P::Any) -> RedType                                                              [487]
  Reduction type of X at P
intrinsic ReductionType(X::Any) -> RedType                                                                      [493]
  Reduction type of X at the default valuation of its base field

*
* IMPLEMENTS
*
type CrvModel
declare attributes CrvModel: 
  // Original equation, ground field, valuation
  forg,       // original equation defining the curve C
  f,          // working equation for the curve C
  K,          // base field
  k,          // residue field
  pi,         // uniformiser
  red,        // reduction map O_K->k
  lift,       // lifting k->O_K
  v,          // valuation on K
  // Delta and Delta_v polytopes and v-faces of dimension 2,1,0
  Delta,      // 2D polytope from the monomials of the defining equation
  mons,       // monomial exponents [[x,y,v],...]
  InnP,       // interior integer points on Delta, their number is the genus of C
  AllP,       // all integer points on Delta, including the boundary 
  vF,         // z-coordinate function on jth 2-face evaluated at [x,y]
  vP,         // values of vF on points in AllP (with respect to their faces)
  Fs,         // v-Faces of Delta (2-dim polytopes)
  Ls,         // v-Edges of Delta (1-dim polytopes)
  Vs,         // v-Vertices of Delta (0-dim polytopes)
  AllFP,      // all integer points on v-faces
  AllLP,      // all integer points on v-edges
  InnFP,      // interior integer points on v-faces
  InnLP,      // interior integer points on v-edges
  deltaF,     // index v_F(F)/Z = multiplicity m of the corresponding component
  deltaL,     // index v_L(L)/Z = gcd of the corresponding chain
  FIsRemovable,      // booleans for faces in Fs - removable?
  FIsContractible,   // - contractible?
  FIsSingular,       // - singular reduction?
  FL,         // list of 1-faces on a given 2-face
  FV,         // list of 0-faces on a given 2-face
  FC,         // centers of 2-faces
  LF,         // list of non-removable 2-faces bounding a given 1-face
  MFwd,       // chart transformation matrices
  MInv,       // and their inverses
  comps,      // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...] - components
  Lpts,       // [<Lindex,root,mult,sing,name>,...] of type LPtsRec - singular points from edges
  ContractibleChains,  // list of contractible chains (if ContractFaces is set to true in Style)
  // Dual graph and reduction type
  G,          // dual graph
  R,          // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  Sigma,
  // Model type
  type,       // "clusters" (MacLane-Muselli) or "delta" (Delta-regular)
  // Settings and TeX
  Style,      // defining settings passed to Model  
  eqnTeX,     // defining equation in TeX
  sigmaTeX,   // clusters in TeX (Maclane-Muselli) 
  deltaTeX,   // Newton polytope and v-faces in TikZ (Delta-regular)
  chartsTeX;  // charts for components in TeX (Delta-regular)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(C::CrvModel, level::MonStgElt)                                                                  [349]
  Print a curve model
*
* Invariants
*
intrinsic DualGraph(C::CrvModel) -> GrphDual                                                                    [364]
  Dual graph of a curve model
intrinsic ReductionType(C::CrvModel) -> RedType                                                                 [370]
  Reduction graph of a curve model, or false if singular
intrinsic IsSingular(C::CrvModel) -> RedType                                                                    [376]
  true if failed to find a regular model (neither hyperelliptic nor Delta_v-regular)
intrinsic Genus(C::CrvModel) -> RngIntElt                                                                       [382]
  Genus of the generic fibre of a model
intrinsic IsGood(C::CrvModel) -> BoolElt                                                                        [390]
  true if comes from a curve wih good reduction
intrinsic IsSemistable(C::CrvModel) -> BoolElt                                                                  [397]
  true if comes from a curve with semistable reduction
intrinsic IsSemistableTotallyToric(C::CrvModel) -> BoolElt                                                      [404]
  true if comes from a curve with semistable totally toric reduction
intrinsic IsSemistableTotallyAbelian(C::CrvModel) -> BoolElt                                                    [411]
  true if comes from a curve with semistable totally abelian reduction
intrinsic TeX(M::CrvModel: Charts:=false, Equation:=false, Delta:=false, RedType:=false, texsettings:=[]) -> MonStgElt  [438]
  Full TeX description of a model of a curve
*
* Model and ReductionType wrappers
*
intrinsic Model(X::Any, P::Any: model:="default", Style:=[]) -> CrvModel                                        [484]
intrinsic Model(X::Any: model:="default", Style:=[]) -> CrvModel                                                [576]
intrinsic ReductionType(X::Any, P::Any) -> RedType                                                              [586]
  Reduction type of X at P
intrinsic ReductionType(X::Any) -> RedType                                                                      [592]
  Reduction type of X at the default valuation of its base field
*/

declare type CrvModel;
declare attributes CrvModel: 
  // Original equation, ground field, valuation
  forg,       // original equation defining the curve C
  f,          // working equation for the curve C
  K,          // base field
  k,          // residue field
  pi,         // uniformiser
  red,        // reduction map O_K->k
  lift,       // lifting k->O_K
  v,          // valuation on K
  // Delta and Delta_v polytopes and v-faces of dimension 2,1,0
  Delta,      // 2D polytope from the monomials of the defining equation
  mons,       // monomial exponents [[x,y,v],...]
  InnP,       // interior integer points on Delta, their number is the genus of C
  AllP,       // all integer points on Delta, including the boundary 
  vF,         // z-coordinate function on jth 2-face evaluated at [x,y]
  vP,         // values of vF on points in AllP (with respect to their faces)
  Fs,         // v-Faces of Delta (2-dim polytopes)
  Ls,         // v-Edges of Delta (1-dim polytopes)
  Vs,         // v-Vertices of Delta (0-dim polytopes)
  AllFP,      // all integer points on v-faces
  AllLP,      // all integer points on v-edges
  InnFP,      // interior integer points on v-faces
  InnLP,      // interior integer points on v-edges
  deltaF,     // index v_F(F)/Z = multiplicity m of the corresponding component
  deltaL,     // index v_L(L)/Z = gcd of the corresponding chain
  FIsRemovable,      // booleans for faces in Fs - removable?
  FIsContractible,   // - contractible?
  FIsSingular,       // - singular reduction?
  FL,         // list of 1-faces on a given 2-face
  FV,         // list of 0-faces on a given 2-face
  FC,         // centers of 2-faces
  LF,         // list of non-removable 2-faces bounding a given 1-face
  MFwd,       // chart transformation matrices
  MInv,       // and their inverses
  comps,      // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...] - components
  Lpts,       // [<Lindex,root,mult,sing,name>,...] of type LPtsRec - singular points from edges
  ContractibleChains,  // list of contractible chains (if ContractFaces is set to true in Style)
  // Dual graph and reduction type
  G,          // dual graph
  R,          // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  Sigma,
  // Model type
  type,       // "clusters" (MacLane-Muselli) or "delta" (Delta-regular)
  // Settings and TeX
  Style,      // defining settings passed to Model  
  eqnTeX,     // defining equation in TeX
  sigmaTeX,   // clusters in TeX (Maclane-Muselli) 
  deltaTeX,   // Newton polytope and v-faces in TikZ (Delta-regular)
  chartsTeX;  // charts for components in TeX (Delta-regular)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;  


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
  

/// Basic type functions


intrinsic IsCoercible(D::CrvModel, y::.) -> BoolElt, .   //
{Coerce a CrvModel.}
  return false, _;
end intrinsic;


intrinsic 'in'(D::CrvModel, y::.) -> BoolElt   //
{"in" function for an CrvModel.}
  return false;
end intrinsic;


intrinsic Print(C::CrvModel, level::MonStgElt)
{Print a curve model}
  case C`type:
    when "delta": type:=Sprintf("Delta-%o",IsSingular(C) select "singular" else "regular");
    when "clusters": type:="Muselli";
    else error "Print: model has unknown type, neither muselli or clusters: "*C`type;
  end case;
  red:=IsSingular(C) select "" else " of type "*Sprint(C`R);
  printf "%o model of %o=0 at %o%o",type,DelSpaces(C`forg),Characteristic(C`k),red;
end intrinsic;


/// Invariants


intrinsic DualGraph(C::CrvModel) -> GrphDual
{Dual graph of a curve model}
  return C`G;
end intrinsic;


intrinsic ReductionType(C::CrvModel) -> RedType
{Reduction graph of a curve model, or false if singular}
  return C`R;
end intrinsic;


intrinsic IsSingular(C::CrvModel) -> RedType
{true if failed to find a regular model (neither hyperelliptic nor Delta_v-regular)}
  return IsSingular(DualGraph(C));
end intrinsic;


intrinsic Genus(C::CrvModel) -> RngIntElt
{Genus of the generic fibre of a model}
  error if IsSingular(C), "Failed to find a regular model (neither hyperelliptic nor Delta_v-regular)";
  R:=ReductionType(C);
  return Genus(R);
end intrinsic;


intrinsic IsGood(C::CrvModel) -> BoolElt
{true if comes from a curve wih good reduction}
  error if IsSingular(C), "Failed to find a regular model (neither hyperelliptic nor Delta_v-regular)";
  return IsGood(ReductionType(C));
end intrinsic;


intrinsic IsSemistable(C::CrvModel) -> BoolElt
{true if comes from a curve with semistable reduction}
  error if IsSingular(C), "Failed to find a regular model (neither hyperelliptic nor Delta_v-regular)";
  return IsSemistable(ReductionType(C));
end intrinsic;


intrinsic IsSemistableTotallyToric(C::CrvModel) -> BoolElt
{true if comes from a curve with semistable totally toric reduction}
  error if IsSingular(C), "Failed to find a regular model (neither hyperelliptic nor Delta_v-regular)";
  return IsSemistableTotallyToric(ReductionType(C));
end intrinsic;


intrinsic IsSemistableTotallyAbelian(C::CrvModel) -> BoolElt
{true if comes from a curve with semistable totally abelian reduction}
  error if IsSingular(C), "Failed to find a regular model (neither hyperelliptic nor Delta_v-regular)";
  return IsSemistableTotallyAbelian(ReductionType(C));
end intrinsic;


/*
Example Totally toric hyperelliptic curves in any residue characteristic (IsSemistableTotallyToric):
U<p>:=RationalFunctionField(GF(2));        // work over F_2(t) at t=0
R<x,y>:=PolynomialRing(U,2);
style:=[["ContractFaces","false"],["FaceNames","false"]];    // less clutter
f:=p^2*y^2+p^2+y*(x+p)*(x+1)*(p*x+1)*(p^2*x+1);    // break a Newton polygon into length 1 
M:=Model(f,p: Style:=style);                       // pieces to get totally toric reduction 
Sprintf("\\cbox{%o} \\qquad \\cbox{%o} \\qquad Genus %o",DeltaTeX(M),TeX(ReductionType(M)),Genus(M)); //> DeltaTeX(M), TeX(ReductionType(M)), "Genus", Genus(M);
f:=p^2*y^2+p^2+y*(x+p)*(x+1)*(p*x+1)*(p^2*x+1)*(p^3*x+1)*(p^4*x+1);    // same in genus 5
M:=Model(f,p: Style:=style);
Sprintf("\\cbox{%o} \\qquad \\cbox{%o} \\qquad Genus %o",DeltaTeX(M),TeX(ReductionType(M)),Genus(M)); //> DeltaTeX(M), TeX(ReductionType(M)), "Genus", Genus(M);
IsGood(M);                     // no, not 1g5
IsSemistable(M);               // yes, all components have multiplicity 1 
IsSemistableTotallyToric(M);   // yes, semistable with no positive genus components
*/


// TeX


intrinsic TeX(M::CrvModel: Charts:=false, Equation:=false, Delta:=false, RedType:=false, texsettings:=[]) -> MonStgElt
{Full TeX description of a model of a curve}

    oldsettings:=Settings();
    SetSettings(M`Style);
    AddSettings(texsettings);

    RedTypeFormat:="Type~\\hbox{%o}\\hfill\\,";
    ChartsFormat:="\\par\\bigskip\\bigskip\\noindent\\begin{center}%o{}\\end{center}";
    SigmaFormat:="\\par\\bigskip$$%o$$";
    EquationFormat:="\\noindent $f=\\>\\,${}%o\\ \\ at\\ \\ $p{}=\\>$\\p\\hfill\\,";
    DeltaFormat:="\\noindent\\pbox{10cm}{%o}\\hfill";
    DualGraphFormat:="\\pbox{10cm}{%o}";
    TeXFormat:="
  \\begingroup
  %% Defining equation
  \\def\\eqn{%o}
  %% Characteristic of the residue field
  \\def\\p{%o}
  %% Delta_v polytope
  \\def\\deltav{%o}
  %% Dual graph
  \\def\\graph{%o}
  %% Charts
  \\def\\charts{%o}
  %% equation, reduction type, dual graph, charts
  \\eqn %o\\deltav\\graph\\charts
  \\endgroup\n";

    R:=ReductionType(M);
    redtype:=RedType and R cmpne false select Sprintf(RedTypeFormat,Label(R: tex)) else "";
    ChartsStr:=not Charts select "" else 
      (M`type eq "clusters" select Sprintf(SigmaFormat,TeX(M`Sigma)) else Sprintf(ChartsFormat,ChartsTeX(M)));
    Eqn:=Equation select Sprintf(EquationFormat,ReplaceStringFunc(EquationTeX(M),["+","-"],["\\!+\\!","\\!-\\!"])) else "";
    DeltaStr:=Delta select Sprintf(DeltaFormat,DeltaTeX(M)) else "";
    DGraph:=Sprintf(DualGraphFormat,ReplaceStringFunc(TeX(DualGraph(M)),"#","##"));
    tex:=Sprintf(TeXFormat,Eqn,Characteristic(M`k),DeltaStr,DGraph,ChartsStr,redtype);

    SetSettings(oldsettings);
    return tex;
end intrinsic;


/// Model and ReductionType wrappers


intrinsic Model(X::Any, P::Any: model:="default", Style:=[]) -> CrvModel
{Minimal regular with normal crossings model of a curve X at P. 
Parameter model controls the default algorithm, and can be "default", 
"delta" (use Delta-regular machinery) or "clusters" (use Muselli-Maclane clusters 
for hyperelliptic curves in odd residue characteristic)
A univariate polynomial is interpreted as defining a hyperelliptic curve}

    error if Type(model) ne MonStgElt or model notin ["default","clusters","delta"],
      "model should be a string `clusters', `delta' or 'default', indicating preferred default behaviour";    
        //! Could add Magma if it can be modified to do mrnc
    Default:=model eq "default";
    Delta:=model eq "delta";
    Clusters:=model eq "clusters";

    if Type(X) eq RelElt then
      return Model(LHS(X)-RHS(X),P: model:=model, Style:=Style);
    end if;

    // The field K, valuation and residue characteristic
    D:=BaseDVR(X, P);
    K,k,v,red,lift,pi:=Eltseq(D);
    p:=Characteristic(k);

    if Type(X) eq RngUPolElt then          // Univariate polynomial, presumably hyperelliptic curve
      X:=HyperellipticCurve(X);
    end if;

  //! Need projective eqns as well

    if Type(X) eq CrvPln then
      X:=DefiningEquation(X);
    end if;

    if Type(X) eq RngMPolElt then          // Multivariate polynomial defining a curve
      f:=ChangeRing(X,K);
      h:=IsHomogeneous(f);
      r:=Rank(Parent(f));
      if r eq 1 then                       // Univariate -> hyperelliptic
        return Model(Evaluate(f,[PR(Q).1]): model:=model, Style:=Style);
      end if;      
      error if r le 1 or r ge 4 or (r eq 2 and h or r eq 3 and not h),
        "f does not lie in a polynomial ring in 2 variables (or homogeneous in 3)";
      if r eq 3 then                       // Dehomogenise
        R<x,y>:=PR(K,2);
        f:=Evaluate(f,[x,y,1]);
      end if;
      m,i:=Min([Degree(f,1),Degree(f,2)]);
      error if m le 1, "f=0 defines a genus 0 curve in A^2";
      if (Default or Clusters) and p ne 2 and m eq 2 then     // hyperelliptic c2(x) y^2 + c1(x) y + c0(x) = 0
        c0,c1,c2:=Explode([Coefficient(f,i,j): j in [0..2]]);        // y^2 + c1/c2 y + c0/c2 = 0
        f:=c1 eq 0 select -c0*c2 else c1^2-4*c0*c2;                  // y^2 + (c0/c2 - (c1/c2)^2/4) = 0
        f:=Evaluate(f,i eq 2 select [PR(Q).1,0] else [0,PR(Q).1]);   // y^2 = c1^2 - 4 c0c2
        error if Degree(f) le 2, "f=0 defines a genus 0 curve in A^2";
        while f mod PR(Q).1^2 eq 0 do 
          f:=f div PR(Q).1^2;
        end while;
        return MuselliModel(f,D: Style:=Style);                      
      end if;
      return DeltaRegularModel(f,D: Style:=Style);
    end if;

    if Type(X) eq CrvEll then              // Elliptic
      if Type(K) in [FldPad] 
        then loc,min:=LocalInformation(X);
        else loc:=LocalInformation(X,P);
             min:=MinimalModel(X,P);
      end if;
      R<x,y>:=PR(K,2);
      f:=Evaluate(DefiningPolynomial(min),[x,y,1]);
      return DeltaRegularModel(f,D: Style:=Style);
    end if;  

    if Type(X) eq CrvHyp then              // Hyperelliptic
      h,g:=HyperellipticPolynomials(X);
      if p eq 2 or Delta then   
        if Type(K) eq FldRat then 
          X:=MinimalWeierstrassModel(X);
        end if;
        // Delta_v regular model machinery; //! actually should help by translating singular pt to (0,0)
        R<x,y>:=PR(K,2);
        f:=y^2+Evaluate(g,x)*y-Evaluate(h,x);
        return DeltaRegularModel(f,D: Style:=Style);
      end if;
      // M-M Clusters for p<>2
      f:=g eq 0 select h else 4*h+g;      // Defining equation y^2=f(x) for cluster picture
      return MuselliModel(f,D: Style:=Style);
    end if;

    error Sprintf("Model(X,P) for X of type %o is not implemented",Type(X));  
end intrinsic;


intrinsic Model(X::Any: model:="default", Style:=[]) -> CrvModel
{Minimal regular with normal crossings model of a curve X at P. 
Parameter model controls the default algorithm, and can be "default", 
"delta" (use Delta-regular machinery) or "clusters" (use Muselli-Maclane clusters 
for hyperelliptic curves in odd residue characteristic)
A univariate polynomial is interpreted as defining a hyperelliptic curve}
  return Model(X, "default": model:=model, Style:=Style);
end intrinsic;


intrinsic ReductionType(X::Any, P::Any) -> RedType
{Reduction type of X at P}
  return ReductionType(Model(X,P));
end intrinsic;


intrinsic ReductionType(X::Any) -> RedType
{Reduction type of X at the default valuation of its base field}
  return ReductionType(Model(X));
end intrinsic;


/*
Example See \protect{\cite[Table 1 (v),(viii),(ix)]{newton}}
R<x,y>:=PolynomialRing(Q,2);
eqn:=(y-1)^2=(x-1)*(x-2)*(x-3)^2*(x-4)+5^4;   // Example (v)
M:=Model(eqn,5: model:="delta");
TeX(M: Delta);
eqn:=y^2=(x-1)*(x-2)*(x-3)^2*(x-4)+5^4;       // Example (viii)
M:=Model(eqn,5: model:="delta");
TeX(M: Delta);
M:=Model(eqn,5);       // Actual model for those two, computed with Muselli
Sprintf("%o \\hfill %o",Label(ReductionType(M): tex),TeX(M)); //> Label(ReductionType(M): tex),TeX(M);
eqn:=x^4*y^2=x*(y-x)^2+5^3;                  // Example (ix)
M:=Model(eqn,5: model:="delta");
TeX(M: Delta);
M:=Model(eqn,5);       // Actual model, computed with Muselli
Sprintf("%o \\hfill %o",Label(ReductionType(M): tex),TeX(M)); //> Label(ReductionType(M): tex),TeX(M);
*/
