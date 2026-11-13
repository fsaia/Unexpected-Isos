/*
(c) Tim Dokchitser, redlib library, v3.3, May 2025, https://people.maths.bris.ac.uk/~matyd/redlib/

Classification of reduction types

[F7] translate redtype.m magma-complete.gpt
[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

*
* IMPLEMENTS
*
*
* Outer and inner chains
*
intrinsic OuterSequence(m::RngIntElt, d::RngIntElt: includem:=true) -> SeqEnum[RngIntElt]                       [465]
intrinsic InnerSequence(m1::RngIntElt, d1::RngIntElt, m2::RngIntElt, dk::RngIntElt, n::RngIntElt: includem:=true) -> SeqEnum[RngIntElt]  [503]
intrinsic MinimalDepth(m1::RngIntElt, d1::RngIntElt, m2::RngIntElt, dk::RngIntElt) -> RngIntElt                 [562]
intrinsic SortMultiplicities(m::RngIntElt, O::SeqEnum) -> SeqEnum                                               [622]
  Sort a sequence of multiplicities O by gcd with m (weight), then by o. This is how outer and edge
  multiplicities are sorted in reduction types.
intrinsic DefaultMultiplicities(m1::RngIntElt, o1::SeqEnum, m2::RngIntElt, o2::SeqEnum, loop::BoolElt) -> RngIntElt, RngIntElt  [640]
  Default edge multiplicities d1,d2 for a component with multiplicity m1, available outgoing multiplicities o1,
  and one with m2,o2. Parameter loop:boolean specifies whether it is a loop or links two different principal
  components
*
* Principal component core (RedCore)
*
type RedCore
intrinsic Core(m::RngIntElt, O::SeqEnum) -> RedCore                                                             [720]
  Create a new core from principal multiplicity m and outgoing multiplicities O.
intrinsic Print(C::RedCore, level::MonStgElt)                                                                   [748]
  Print a principal component core through its label.
*
* Basic invariants and printing
*
intrinsic Multiplicity(C::RedCore) -> RngIntElt                                                                 [773]
  Principal multiplicity m of a reduction type core.
intrinsic OuterMultiplicities(C::RedCore) -> SeqEnum                                                            [779]
  Outgoing multiplicities O of a reduction type core, sorted with SortMultiplicities
intrinsic Chi(C::RedCore) -> RngIntElt                                                                          [785]
  Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)
intrinsic Label(C::RedCore: tex:=false) -> MonStgElt                                                            [805]
  Label of a reduction type core, for printing (or TeX if tex:=true)
intrinsic TeX(C::RedCore) -> MonStgElt                                                                          [820]
  Print a reduction type core in TeX.
intrinsic Cores(chi::RngIntElt: mbound:="all", sort:=true) -> SeqEnum                                           [838]
  Returns all reduction type cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely
  many, so a bound on m must be given
*
* Inner chains (RedChain)
*
type RedChain
intrinsic Link(class::RngIntElt, mi::RngIntElt, di::RngIntElt, mj::Any, dj::Any:                                [941]
  depth:=false, Si:=false, Sj:=false, index:=false) -> RedChain
intrinsic Print(c::RedChain, level::MonStgElt)                                                                  [989]
  Print a chain c like 'class mi,di - (depth) mj,dj', together with indices of Si, Sj and c if assigned
*
* Invariants and depth
*
intrinsic Class(c::RedChain) -> RngIntElt                                                                       [1011]
  Class of a RedChain - cLoop, cD or cEdge depending on the type of the chain
intrinsic Weight(c::RedChain) -> RngIntElt                                                                      [1017]
  Weight od the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,dj))
intrinsic Index(c::RedChain) -> RngIntElt                                                                       [1057]
  Index of the chain c used for ordering chains in a reduction type, and sorting in label.
intrinsic DepthString(c::RedChain) -> MonStgElt                                                                 [1081]
  String set by SetDepths how c is printed, e.g. "1" or "n"
intrinsic SetDepthString(c::RedChain, depth::Any)                                                               [1087]
  Set how c is printed, e.g. "1" or "n"
*
* Principal component types (RedPrin) 
*
type RedPrin
declare attributes RedPrin: 
  m,             // principal multiplicity
  g,             // genus
  C,             // chains: outer, loops, D-links or edge from S 
  O,             // outgoing multiplicities for outer chains
  L,             // outgoing multiplicities from all other chains
  gcd,           // gcd(m,O,L)
  core,          // core of type RedCore (divide by gcd)
  chi,           // Euler characteristic =chi(m,g,O,L)
  index;         // index in a reduction type
*
* Creation functions
*
intrinsic PrincipalType(m::RngIntElt, g::RngIntElt, O::SeqEnum, Lloops::SeqEnum, LD::SeqEnum, Ledge::SeqEnum: index:=0) -> RedPrin  [1331]
  Create a new principal type from its primary invariants, and check integral self-intersection.
intrinsic PrincipalTypes(chi::RngIntElt, C::RedCore: withweights:=false, sorted:=true) -> SeqEnum[RedPrin], SeqEnum[SeqEnum[RngIntElt]]  [1402]
intrinsic PrincipalTypes(chi::RngIntElt: semistable:=false, withweights:=false, sorted:=true) -> SeqEnum, SeqEnum  [1460]
intrinsic PrincipalTypes(chi::RngIntElt, weight::SeqEnum: semistable:=false, withweights:=false, sorted:=true) -> SeqEnum  [1497]
  All possible principal types with a given Euler characteristic chi and GCDs of edge multiplicities. If
  withweights:=true, also returns [weight] as a second parameter (like all other PrincipalTypes instances).
*
* Invariants of principal types
*
intrinsic Multiplicity(S::RedPrin) -> RngIntElt                                                                 [1556]
  Principal multiplicity m of a principal type
intrinsic GeometricGenus(S::RedPrin) -> RngIntElt                                                               [1562]
  Geometric genus g of a principal type S=(m,g,O,...)
intrinsic Index(S::RedPrin) -> RngIntElt                                                                        [1568]
  Index of the principal component in a reduction type, 0 if freestanding
intrinsic Chains(S::RedPrin: class:=0) -> SeqEnum[RedChain]                                                     [1574]
intrinsic OuterMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]                                                 [1584]
  Sequence of outer multiplicities S`O of a principal type, sorted
intrinsic EdgeMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]                                                  [1590]
  Sequence of edge multiplicities of a principal type, sorted
intrinsic InnerMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]                                                 [1596]
  Sequence of inner multiplicities S`L of a principal type, sorted as in label
intrinsic Loops(S::RedPrin) -> SeqEnum[RedChain]                                                                [1602]
  Sequence of chains in S representing loops (class cLoop)
intrinsic DLinks(S::RedPrin) -> SeqEnum[RedChain]                                                               [1608]
  Sequence of chains in S representing D-links (class cD)
intrinsic GCD(S::RedPrin) -> RngIntElt                                                                          [1628]
  Return GCD(m,O,L) for a principal type
intrinsic Core(S::RedPrin) -> RedCore                                                                           [1634]
  Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m,O)=1
intrinsic Chi(S::RedPrin) -> RngIntElt                                                                          [1640]
  Euler characteristic chi of a principal type (m,g,O,Lloops,LD,Ledge), chi = m(2-2g-|O|-|L|) + sum_(o in O)
  gcd(o,m), where L consists of all the inner multiplicities in Lloops (2 from each), LD (1 from each), Ledge
  (1 from each)
intrinsic Weight(S::RedPrin) -> SeqEnum[RngIntElt]                                                              [1646]
  Outgoing link pattern of a principal type = multiset of GCDs of edges with m.
*
* RedPrin: Score and comparison
*
intrinsic Score(S::RedPrin) -> SeqEnum[RngIntElt]                                                               [1717]
  Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a
  principal type, and characterises it uniquely.
intrinsic PrincipalType(w::SeqEnum[RngIntElt]) -> RedPrin                                                       [1730]
  Create a principal type S from its score sequence w (=Score(S)).
intrinsic 'eq'(S1::RedPrin, S2::RedPrin) -> BoolElt                                                             [1762]
  Compare two principal types by their score
intrinsic 'lt'(S1::RedPrin, S2::RedPrin) -> BoolElt                                                             [1768]
  Compare two principal types by their score
intrinsic 'le'(S1::RedPrin, S2::RedPrin) -> BoolElt                                                             [1774]
  Compare two principal types by their score
intrinsic 'gt'(S1::RedPrin, S2::RedPrin) -> BoolElt                                                             [1780]
  Compare two principal types by their score
intrinsic 'ge'(S1::RedPrin, S2::RedPrin) -> BoolElt                                                             [1786]
  Compare two principal types by their score
intrinsic Sort(S::SeqEnum[RedPrin]) -> SeqEnum[RedPrin]                                                         [1792]
  Sort principal types by their score
intrinsic Sort(~S::SeqEnum[RedPrin])                                                                            [1799]
  Sort principal types by their score
*
* Printing
*
intrinsic Label(S::RedPrin: tex:=false, html:=false, edge:=false, wrap:=true, forcesubs:=false) -> MonStgElt    [2019]
intrinsic Print(S::RedPrin, level::MonStgElt)                                                                   [2059]
  Print a principal type as an ascii label or as an evaluatable Magma string (when level="Magma").
intrinsic TeX(S::RedPrin: length:="35pt", label:=false, standalone:=false) -> MonStgElt                         [2074]
intrinsic TeX(T::SeqEnum[RedPrin]: width:=10, scale:=0.8, sort:=true, label:=false, length:="35pt", yshift:="default") -> MonStgElt  [2105]
*
* Shapes (RedShape)
*
type RedShape
declare attributes RedShape: 
  G,       // Underlying undirected graph with vertices labelled by [chi] 
           //   and edges by [weight1,weight2,...] (gcds are sorted)
  V,       // Vertex set of G
  E,       // Edge set of G
  D,       // Double graph: vertex for every vertex of G, and for every edge 
           //   of G except simple edges with weight=[1]. Edges are unlabelled,
           //   and D determines the shape up to isomorphism.
  label;   // Label based on minimum path, determines the shape up to isomorphism.
*
* Printing and TeX
*
intrinsic Print(S::RedShape, level::MonStgElt)                                                                  [2206]
intrinsic TeX(S::RedShape: scale:=1.5, center:=false, shapelabel:="", complabel:="default", ref:="default", forceweights:=false, boundingbox:=false) -> MonStgElt, FldReElt, FldReElt, FldReElt, FldReElt  [2287]
  Tikz picture for a shape S of a reduction graph, or, if boundingbox:=true, returns S,x1,y1,x2,y2, where the
  last four define the bounding box.
*
* Construction and isomorphism testing
*
intrinsic Shape(V::SeqEnum[RngIntElt], E::SeqEnum[SeqEnum[RngIntElt]]) -> RedShape                              [2368]
intrinsic IsIsomorphic(S1::RedShape, S2::RedShape) -> BoolElt                                                   [2411]
  Check whether two shapes are isomorphic via their double graphs
*
* Primary invariants
*
intrinsic Graph(S::RedShape) -> GrphUnd                                                                         [2430]
  Labelled underlying graph G of the shape
intrinsic DoubleGraph(S::RedShape) -> GrphUnd                                                                   [2436]
  Vertex-labelled double graph D of the shape, used for isomorphism testing
intrinsic Vertices(S::RedShape) -> SetIndx                                                                      [2442]
  Vertices of the underlying graph Graph(S), as an indexed set
intrinsic Edges(S::RedShape) -> SetIndx                                                                         [2448]
  Edges of the underlying graph Graph(S), an an indexed set
intrinsic Chi(S::RedShape, v::GrphVert) -> RngIntElt                                                            [2460]
  Euler characteristic chi(v_i)<=0 of ith vertex of the graph G in a shape S
intrinsic Weights(S::RedShape, v::GrphVert) -> RngIntElt                                                        [2469]
  Weights of a vertex v that together with chi determine the vertex type (chi, weights)
intrinsic Chi(S::RedShape) -> RngIntElt                                                                         [2475]
  Total Euler characteristic of a graph shape chi<=0, sum over chi's of vertices
intrinsic VertexLabels(S::RedShape) -> SeqEnum                                                                  [2483]
  Sequence of -chi's for individual components of the shape S so that S=Shape(VertexLabels(S),EdgeLabels(S))
intrinsic EdgeLabels(S::RedShape) -> SeqEnum                                                                    [2489]
  List of edges v_i->v_j of the form [i,j,edgegcd] so that S=Shape(VertexLabels(S),EdgeLabels(S))
intrinsic ScoreIsSmaller(new::SeqEnum, best::SeqEnum) -> MonStgElt                                              [2543]
intrinsic MinimumScorePaths(D::GrphUnd) -> SeqEnum, SeqEnum                                                     [2575]
intrinsic Label(G::GrphUnd) -> MonStgElt                                                                        [2718]
  Graph label based on a minimum score path, determines G up to isomorphism
intrinsic MinimumScorePaths(S::RedShape) -> SeqEnum, SeqEnum                                                    [2741]
*
* Reduction Types (RedType)
*
type RedType
declare attributes RedType:
  C,       // array of principal types of type RedPrin, ordered in label order;
           // either one with chi=0 (for g=1) or all with chi<0.
  L,       // all inner chains, sorted as for label, of type SeqEnum[RedChain]
  family,  // true if family (variable depths), false if one reduction type
  score,   // score used for comparison and sorting
  shape,   // shape of R of type RedShape
  bestscore,     // e.g. [<0,{*-1*},true>,<0,{*-2*},true>,<0,{*-1*},false>,.. from MinimumScorePaths
  besttrail;      // e.g. [1,2,3,4,1,3] tracing vertices with repetitions (actual vertex indices in R)
intrinsic Print(R::RedType, level::MonStgElt)                                                                   [3078]
  Print a reduction type through its Label.
intrinsic ReductionType(m::SeqEnum[RngIntElt], g::SeqEnum[RngIntElt], O::SeqEnum[SeqEnum], L::SeqEnum[SeqEnum]) -> RedType  [3084]
intrinsic ReductionTypes(g::RngIntElt: semistable:=false, countonly:=false, elliptic:=false) -> SeqEnum[RedType]  [3166]
intrinsic ReductionTypes(S::RedShape: countonly:=false, semistable:=false) -> SeqEnum[RedType]                  [3199]
  Sequence of reduction types with a given shape. If countonly=true, only count their number
*
* Arithmetic invariants
*
intrinsic Chi(R::RedType) -> RngIntElt                                                                          [3324]
  Total Euler characteristic of R
intrinsic Genus(R::RedType) -> RngIntElt                                                                        [3330]
  Total genus of R
intrinsic IsFamily(R::RedType) -> BoolElt                                                                       [3344]
  Returns true if R is a reduction family, false if it is a single reduction type.
intrinsic IsGood(R::RedType) -> BoolElt                                                                         [3350]
  true if comes from a curve wih good reduction
intrinsic IsSemistable(R::RedType) -> BoolElt                                                                   [3356]
  true if comes from a curve with semistable reduction (all (principal) components of an mrnc model have
  multiplicity 1)
intrinsic IsSemistableTotallyToric(R::RedType) -> BoolElt                                                       [3362]
  true if comes from a curve with semistable totally toric reduction (semistable with no positive genus
  components)
intrinsic IsSemistableTotallyAbelian(R::RedType) -> BoolElt                                                     [3368]
  true if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual
  graph)
intrinsic TamagawaNumber(R::RedType) -> RngIntElt                                                               [3388]
  Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field (in other
  words, totally split)
*
* Invariants of individual principal components and chains
*
intrinsic PrincipalTypes(R::RedType) -> SeqEnum[RedPrin]                                                        [3417]
  Principal types (vertices) R of the reduction type R
intrinsic PrincipalType(R::RedType, i::RngIntElt) -> RedPrin                                                    [3436]
  Principal type number i in the reduction type R, same as R!!i
intrinsic InnerChains(R::RedType) -> SeqEnum[RedChain]                                                          [3443]
  Return all the inner chains in R, including loops and D-links, as a sequence SeqEnum[RedChain], sorted as in
  label
intrinsic EdgeChains(R::RedType) -> SeqEnum[RedChain]                                                           [3449]
  Return all the inner chains in R between different principal components, as a sequence SeqEnum[RedChain],
  sorted as in label
intrinsic Multiplicities(R::RedType) -> SeqEnum                                                                 [3455]
  Sequence of multiplicities of principal types
intrinsic Genera(R::RedType) -> SeqEnum                                                                         [3461]
  Sequence of geometric genera of principal types
intrinsic GCD(R::RedType) -> RngIntElt                                                                          [3467]
  GCD detecting non-primitive types
intrinsic Shape(R::RedType) -> RedShape                                                                         [3473]
  The shape of the reduction type R. Every principal type is a vertex that only remembers its Euler
  characteristic, and every edge only remembers the gcd of the corresponding inner chain
*
* Comparison
*
intrinsic Score(R::RedType) -> SeqEnum[RngIntElt]                                                               [3497]
  Score of a reduction type, used for comparison and sorting
intrinsic 'eq'(R1::RedType, R2::RedType) -> BoolElt                                                             [3507]
  Compare two reduction types by their score
intrinsic 'lt'(R1::RedType, R2::RedType) -> BoolElt                                                             [3513]
  Compare two reduction types by their score
intrinsic 'gt'(R1::RedType, R2::RedType) -> BoolElt                                                             [3519]
  Compare two reduction types by their score
intrinsic 'le'(R1::RedType, R2::RedType) -> BoolElt                                                             [3525]
  Compare two reduction types by their score
intrinsic 'ge'(R1::RedType, R2::RedType) -> BoolElt                                                             [3531]
  Compare two reduction types by their score
intrinsic Sort(S::SeqEnum[RedType]) -> SeqEnum[RedType]                                                         [3537]
  Sort reduction types by their score
intrinsic Sort(~S::SeqEnum[RedType])                                                                            [3544]
  Sort reduction types by their score
*
* Reduction types, labels, and dual graphs
*
intrinsic ReductionType(G::GrphDual: family:=false) -> RedType                                                  [3578]
  Create a reduction type from a full dual mrnc graph or return false if G does not come from a reduction type
  of positive genus
intrinsic ReductionFamily(G::GrphDual) -> RedType                                                               [3664]
  Create a reduction family from a full dual mrnc graph or return false if G does not come from a reduction type
  of positive genus
intrinsic ReductionFamily(R::RedType) -> RedType                                                                [3670]
  Family of types in which R lives
intrinsic ReductionType(F::RedType) -> RedType                                                                  [3677]
  Representative of a family of reduction types of minimal depths
intrinsic ReductionFamily(S::MonStgElt: family:=false) -> RedType                                               [3684]
  Construct a reduction type from a string label.
intrinsic DualGraph(R::RedType: compnames:="default", family:="default") -> GrphDual                            [3987]
  Full dual graph from a reduction type, possibly with variable length edges
intrinsic Label(R::RedType: tex:=false, html:=false, wrap:=true, forcesubs:=true, forcesups:=false, depths:="default") -> MonStgElt  [4082]
intrinsic ReductionType(S::MonStgElt: family:=false) -> RedType                                                 [4186]
  Construct a reduction type from a string label.
intrinsic LabelRegex(R::RedType: magma:=true) -> MonStgElt                                                      [4473]
intrinsic TeX(R::RedType: forcesups:=false, forcesubs:="default", scale:=0.8, xscale:=1, yscale:=1, oneline:=false) -> MonStgElt  [4552]
*
* Variable depths for families (in Label and DualGraph)
*
intrinsic SetDepths(~R::RedType, depth::UserProgram)                                                            [4663]
intrinsic SetDepths(~R::RedType, S::SeqEnum)                                                                    [4679]
  Set depths for DualGraph and Label to a sequence, e.g. S=["m","n","2"]
intrinsic SetVariableDepths(~R::RedType)                                                                        [4686]
  Set depths for DualGraph and Label to i->"n_i"
intrinsic SetOriginalDepths(~R::RedType)                                                                        [4692]
  Remove depths set by SetDepths, so that original ones are printed by Label and other functions
intrinsic SetMinimalDepths(~R::RedType)                                                                         [4698]
  Set depths to minimal ones in the family (MinimalDepth = -1,0 or 1) for every edge
intrinsic SetFamilyDepths(~R::RedType)                                                                          [4704]
  Set depths to family notation (x for loop depth placeholders, no depths otherwise) for every edge
intrinsic GetDepths(R::RedType) -> SeqEnum                                                                      [4710]
  Return depths (string sequence) set by SetDepths or originals if not changed from defaults
*
* Namikawa-Ueno conversion in genus 2
*
intrinsic NamikawaUeno(R::RedType: pottype:="all", depths:="original", warnings:=true) -> MonStgElt, RngIntElt  [4957]
*/


/*
Execute This and the following long comments are used for automatic manual generation and executing examples
errorcode:=0;
writernq("manual-examples.merr",1); 
AttachSpec("redlib.spec");
import "redtype.m": MultiSubsets, Decorations;
<TESTS>; 
<EXAMPLES>; 
writernq("manual-examples.merr",errorcode);
quit;
*/


/*
Manual
The library redtype.m implements the combinatorics of reduction types, in particular
\begin{itemize}
\item Arithmetic of outer and inner sequences that controls the shapes of chains of $\P^1$s in special fibres
  of minimal regular normal crossing models,
\item Methods for reduction types (RedType), their cores (RedCore), inner chains (RedChain) and shapes (RedShape),
\item Canonical labels for reduction types,
\item Reduction types and their labels in TeX,
\item Conversion between dual graphs, reduction type, and their labels:
\end{itemize}
\begin{center}
\begin{tikzpicture}[node distance=5cm, auto, arr/.style={-{>[scale=2]}, bend left}]
  \node (dual) {\{dual graphs\}};
  \node (reduction) [right of=dual] {\{reduction types\}};
  \node (labels) [right of=reduction] {\{labels\}.};
  \draw [arr] (dual) to (reduction);
  \draw [arr] (reduction) to (dual);
  \draw [arr] (reduction) to (labels);
  \draw [arr] (labels) to (reduction);
\end{tikzpicture}
\end{center}
*/


/*
Example Reduction types, labels and dual graphs
R:=ReductionType("I2*-I3*-I4*");
Label(R);             // Plain label
Label(R: tex);        // TeX label
TeX(R);               // Reduction type as a graph
TeX(DualGraph(R));    // Associated dual graph, in TeX
// This is a large dual graph on 22 components, all of multiplicity 1 or 2, and all of genus 0. 
// Taking the associated reduction type gives back R:
G:=DualGraph([2,2,2,1,1,2,1,1,2,1,2,1,1,2,2,1,2,1,1,2,2,2], [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], [[1,4],[1,9],[1,10],[2,10],[2,14],[2,16],[3,5],[3,16],[3,20], [6,7],[6,8],[6,9],[11,12],[11,13],[11,15],[14,15], [17,18],[17,19],[17,22],[20,21],[21,22]]);
ReductionType(G);
*/


declare verbose redlib, 3;


import "mmylib.m": 
  Z, PrintSequence, DelSpaces, SortBy, PrintReal, IncludeAssoc, Left, Right,
  SortedEndVertices, writernq, Last, SortByFunc, SortSet, PermutationsMultiset, 
  IncludeAssocIfNotIsomorphic, ReplaceString, ReplaceStringFunc, Count, 
  PreferenceOrder, PreferenceOrder2, StringSplit, DelCRs, Swap, TokenSplit;


// Printing


function TeXPrintParameter(s: tex:=true, sym:="", plainsym:="", texsym:="", printempty:=true)
  s:=Sprint(s);
  if #s eq 0 and not printempty then return ""; end if;
  sym:=sym eq "" select (tex select texsym else plainsym) else sym;
  par:=tex and #s gt 1 select "{"*s*"}" else s;
  return sym*par;
end function;


// Multisets functions (internal)


function MultiSubsets(multiset)    // Sequence of all multi-subsets of a given multiset 

  unique_elements := SetToSequence(Set(multiset));                          // unique elements 
  multiplicities := [Multiplicity(multiset,x): x in unique_elements];       // and their multiplicities
  out := [[]];                             // Initialize the result with the empty multiset

  for i->elem in unique_elements do        // Iterate through each unique element and its multiplicity
    multiplicity := multiplicities[i];  
    current_subsets := [];                 // Generate all possible counts of the current element in the subsets
    for count in [0..multiplicity], S in out do
      current_subsets cat:= [S cat [elem: i in [1..count]]];     // Append the current count of the element to each S
    end for;
    out := current_subsets;                // Update the result with the new subsets including the current element
  end for;

  return out;
end function;


// Difference for inner sequences (unsorted result)
function SequenceDifference(S1,S2)
  return MultisetToSequence(Multiset(S1) diff Multiset(S2));
end function;


function IsSubMultiset(S1,S2)
  return Multiset(S1) subset Multiset(S2);
end function;


/*
Test
assert #MultiSubsets([])              eq 1;
assert #MultiSubsets([1])             eq 2;
assert #MultiSubsets([1,1])           eq 3;
assert #MultiSubsets([1,1,2])         eq 6;
assert #MultiSubsets([1,1,2,2,2,3,3]) eq 36;
*/


/// Outer and inner chains


/*
Manual
A reduction type is a graph with principal types as vertices 
(like \redtype{I^*_2}, \redtype{I^*_3}, \redtype{I^*_4} above) and inner chains as edges. 
Principal types encode principal components together with outer chains, loops and D-links. 
The three functions that control multiplicities of outer and inner chains, and their depths
are as follows:
*/


intrinsic OuterSequence(m::RngIntElt, d::RngIntElt: includem:=true) -> SeqEnum[RngIntElt]
{Unique outer sequence of type (m,d) for integers m>=1 and 1<d<m. It is of the form 
   [m,d,...,gcd(m,d)] 
with every three consecutive terms d_(i-1), d_i, d_(i+1) satisfying
   d_(i-1) + d_(i+1) = d_i * (integer > 1).
If includem:=false, exclude the starting point m from the sequence.}
  if not includem then
    S:=OuterSequence(m,d);
    return S[[2..#S]];
  end if;
  error if Type(m) ne RngIntElt or Type(d) ne RngIntElt or m le 0 or d lt 0,
    Sprintf("Expected %o:%o and %o:%o to be integers with m>0",m,Type(m),d,Type(d));
  d:=d mod m;
  if d eq 0 then 
    return [m];                                  // empty chain
  end if; 
  return [m] cat OuterSequence(d,d-(m mod d));    // construct inductively 
end intrinsic;


/*
Test
assert OuterSequence(10,2) eq [10,2];
assert OuterSequence(10,8) eq [10,8,6,4,2];
assert OuterSequence(10,7) eq [10,7,4,1];
assert OuterSequence(13,8) eq [13,8,3,1];
assert OuterSequence(13,8: includem:=false) eq [8,3,1];
assert OuterSequence(6,6: includem:=false) eq [];
*/


/*
Example OuterSequence
OuterSequence(6,5);
OuterSequence(13,8);
*/


intrinsic InnerSequence(m1::RngIntElt, d1::RngIntElt, m2::RngIntElt, dk::RngIntElt, n::RngIntElt: includem:=true) -> SeqEnum[RngIntElt]
{Unique inner sequence of type m1(d1-dk-n)m2, that is of the form [m1,d1,...,dk,m2] with n+1 terms 
equal to gcd(m1,d1)=gcd(m2,dk) and satisfying the chain condition: for every three consecutive terms 
   d_(i-1), d_i, d_(i+1) 
we have
   d_(i-1) + d_(i+1) = d_i * (integer > 1).
If includem:=false, exclude the endpoints m1,m2 from the sequence.}
  if not includem then
    S:=InnerSequence(m1,d1,m2,dk,n);
    return S[[2..#S-1]];
  end if;
  error if Type(m1) ne RngIntElt or Type(d1) ne RngIntElt or m1 le 0 or
           Type(m2) ne RngIntElt or Type(dk) ne RngIntElt or m2 le 0,
    Sprintf("Expected m1=%o, d1=%o, m2=%o, dk=%o to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2",m1,d1,m2,dk);
  vprintf redlib, 2: "InnerSequence: m1=%o, d1=%o, m2=%o, dk=%o\n",m1,d1,m2,dk;
  c:=GCD(m1,d1);
  error if c ne GCD(m2,dk),
    Sprintf("No inner sequence %o,%o,...,%o,%o exists as GCD(%o,%o)<>GCD(%o,%o)",m1,d1,dk,m2,m1,d1,m2,dk);
  d1:=d1 mod m1;
  dk:=dk mod m2;
  n0 := MinimalDepth(m1,d1,m2,dk);
  error if n lt n0,
    Sprintf("No inner sequence %o,%o,...,%o,%o of depth %o<%o exists",m1,d1,dk,m2,n,n0);
  // Case 1: n>-1: glue two outer sequences together
  if n gt -1 then                              
    seq_start:=OuterSequence(m1,d1);            // both end with c
    seq_end:=Reverse(OuterSequence(m2,dk));
    if n eq 0 then 
      return Prune(seq_start) cat seq_end;                // one c 
    end if;
    return seq_start cat [c: i in [1..n-1]] cat seq_end;  // at least 2 c's
  end if;
  // Case 2: n=-1: 
  if (dk-m1) mod m2 eq 0 and (d1-m2) mod m1 eq 0 then return [m1,m2]; end if;   // point (4) in Thm
  if m1 ge m2 then
    return [m1] cat InnerSequence(d1,-m1,m2,dk,-1);        // point (5) in Thm
  end if;
  return InnerSequence(m1,d1,dk,-m2,-1) cat [m2];          // point (6) in Thm
end intrinsic;


/*
Test
assert InnerSequence(5,4,1,-1,0) eq [5,4,3,2,1];
assert InnerSequence(3,2,3,2,-1) eq [3,2,3];
assert InnerSequence(6,5,6,5,-1) eq [6,5,4,3,2,3,4,5,6];
assert InnerSequence(6,5,6,5,-1: includem:=false) eq [5,4,3,2,3,4,5];
assert InnerSequence(2,1,3,2,-1: includem:=false) eq [];
*/


/*
Example InnerSequence
InnerSequence(3,2,3,2,-1);
InnerSequence(3,2,3,2,0);
InnerSequence(3,2,3,2,1);
*/


intrinsic MinimalDepth(m1::RngIntElt, d1::RngIntElt, m2::RngIntElt, dk::RngIntElt) -> RngIntElt
{Minimal depth of an inner chain m1=d0,d1,d2,...,dk,m2=d(k+1) of P1s between principal components 
of multiplicity m1, m2 and initial inner multiplicities d1,dk. The depth is defined as 
   -1 + number of times gcd(d1,...,dk) appears in the sequence. 
For example, 5,4,3,2,1 is a valid inner sequence, and MinimalDepth(5,4,1,2) = -1 + 1 = 0.}
  error if Type(m1) ne RngIntElt or Type(d1) ne RngIntElt or m1 le 0 or
           Type(m2) ne RngIntElt or Type(dk) ne RngIntElt or m2 le 0,
    Sprintf("MinimalDepth: Expected m1=%o, d1=%o, m2=%o, dk=%o to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2",m1,d1,m2,dk);
  error if GCD(m1,d1) ne GCD(m2,dk),
    Sprintf("MinimalDepth: No inner sequence %o,%o,...,%o,%o exists as GCD(%o,%o)<>GCD(%o,%o)",m1,d1,dk,m2,m1,d1,m2,dk);
  _,d1i,_:=XGCD(d1 mod m1,m1);
  _,dki,_:=XGCD(dk mod m2,m2);
  // n + f > 0 <=> n > -f <=> n > -f+epsilon <=> n >= Ceiling(-f+epsilon);
  n:=Ceiling( -FractionalPart(d1i/m1)-FractionalPart(dki/m2)+1/(2*m1*m2) );     
  return n;
end intrinsic;


/*
Example
// Example from the description of the intrinsic:
MinimalDepth(5,4,1,2);   
// For another example, the minimal $n$ in the Kodaira type \redtype{I^*_n} is 1. Here the chain links
// two components of multiplicity 2, and the initial multiplicities are 2 on both sides as well:
MinimalDepth(2,2,2,2);   
// Here is an example of a reduction type with an inner chain between two components of multiplicity 3 and outgoing multiplicities 2 on both sides:
R:=ReductionType("IV*-(2)IV*");   
TeX(DualGraph(R));
// The inner chain has gcd=GCD(3,2)=1 and 
// \begin{center}
//    depth = $-1$ + \#1's(=gcd) in the sequence $3,2,1,1,1,2,3$ = 2
// \end{center}
// This is the depth specified in round brackets in {\tt IV*-(2)IV*}
MinimalDepth(3,2,3,2);        // Minimal possible depth for such a chain = -1
R1:=ReductionType("IV*-IV*");     // used by default when no expicit depth is specified
R2:=ReductionType("IV*-(-1)IV*");
assert R1 eq R2;
TeX(DualGraph(R1));
*/


/*
Test
assert MinimalDepth(1,0,1,0) eq 1;
assert MinimalDepth(1,0,2,1) eq 0;
assert MinimalDepth(2,1,1,0) eq 0;
assert MinimalDepth(2,0,2,0) eq 1;
assert MinimalDepth(3,2,3,1) eq 0;
assert MinimalDepth(3,2,3,2) eq -1;
assert MinimalDepth(7,6,7,3) eq -1;
assert MinimalDepth(7,4,7,2) eq 0;
*/

/*
Manual
The next two functions are used in Label to determine the ordering of chains (including loops and D-links),
and default multiplicities which are not printed in labels.
*/


intrinsic SortMultiplicities(m::RngIntElt, O::SeqEnum) -> SeqEnum
{Sort a sequence of multiplicities O by gcd with m (weight), then by o. This is how outer and edge multiplicities are sorted in reduction types.}
  if #O le 1 then return O; end if;
  function w(l)                            // score for sorting: gcd(m,l) followed by l
    assert l ge 1 and l le m; 
    return [GCD(l,m),l];
  end function;    
  SortBy(~O,w);
  return O;                
end intrinsic;


/*
Example Ordering outer multiplicities in reduction types
SortMultiplicities(6,[1,2,3,3,4,5]);     // sort O by gcd(o,m) (=weight), then by o mod m
*/


intrinsic DefaultMultiplicities(m1::RngIntElt, o1::SeqEnum, m2::RngIntElt, o2::SeqEnum, loop::BoolElt) -> RngIntElt, RngIntElt
{Default edge multiplicities d1,d2 for a component with multiplicity m1, available outgoing multiplicities o1, and one with m2,o2. Parameter loop:boolean specifies whether it is a loop or links two different principal components}

  X1:=[[GCD(m1,d),d]: d in o1] cat [[m1,m1],[m1,m1]];                  // possible pairs [chain gcd,outgoing mult d]
  X2:=[[GCD(m2,d),d]: d in o2] cat [[m2,m2],[m2,m2]];
  if loop   
    then good:={D[1]: D in X1 | #[E: E in X1 | E[1] eq D[1]] ge 2};    // good = possible set of chain gcds
    else good:={D[1]: D in X1} meet {D[1]: D in X2};                   //   (need one on each side resp two for loops)
  end if;
  X1:=[D: D in X1 | D[1] in good];
  X2:=[D: D in X2 | D[1] in good];
  error if IsEmpty(X1) or not loop and IsEmpty(X2) or loop and #X2 le 1,
    Sprintf("DefaultMultiplicities(%o,%o,%o,%o,%o): cannot construct edge m1=%o o1=%o - m2=%o o2=%o because no valid default multiplicities could be found",
      m1,DelSpaces(o1),m2,DelSpaces(o2),loop,m1,DelSpaces(o1),m2,DelSpaces(o2));
  d1min:=Min(X1)[2];
  X2left:=loop select Exclude(X2,[GCD(m1,d1min),d1min]) else X2;
  d2min:=Min(X2left)[2];
  return d1min,d2min;
end intrinsic;


/*
Example DefaultMultiplicities
// Let us illustrate what happens when we take a principal component \redtype{9^{1,1,1,3,3}} and add
// five default loops of depth 2,2,1,2,3, to get a reduction type \redtype{9^{1,1,1,3,3}_{2,2,1,2,3}}. 
// How do default loops decide which initial multiplicities to take? \par
// We start with a component of multiplicity $m=9$ and outer multiplicities $\cO=\{1,1,1,3,3\}$.
R:=ReductionType("9^1,1,1,3,3");
TeX(DualGraph(R));
// We can add a loop to it linking two 1's of depth 2 by
R:=ReductionType("9^1,1,1,3,3_{1-1}2");
TeX(DualGraph(R));
// In this case, \{1-1\} does not need to be specified because this is the minimal pair of possible multiplicities in $\cO$, as sorted by SortMultiplicities:
DefaultMultiplicities(9,[1,1,1,3,3],9,[1,1,1,3,3],true); 
assert R eq ReductionType("9^1,1,1,3,3_2");
// After adding the loop, $\{1,3,3\}$ are left as potential outgoing multiplicities, so the next default loop links 3 and 3. Note that $1,3$ is not a valid pair because $\gcd(1,9)\ne\gcd(3,9)$.
DefaultMultiplicities(9,[1,3,3],9,[1,3,3],true); 
R2:=ReductionType("9^1,1,1,3,3_2,2");       // 2 loops, use 1-1 and 3-3
TeX(DualGraph(R2));
DefaultMultiplicities(9,[1],9,[1],true);    
R3:=ReductionType("9^1,1,1,3,3_2,2,1,2,3"); // no pairs left -> next three loops
TeX(DualGraph(R3));                         //    use (m,m)=(9,9)
assert R3 eq ReductionType("9^1,1,1,3,3_{1-1}2,{3-3}2,{9-9}1,{9-9}2,{9-9}3");
*/



/// Principal component core (RedCore)


declare type RedCore;   // Principal component core: type RedCore. Prints as m^o1,...,on or D,T,I0*,IV,IV*,III,III*,II,II*
declare attributes RedCore: 
  m,          // main component multiplicity
  O,          // sequence of outgoing multiplicities in Z/mZ with GCD(m,O)=1, sorted with SortMultiplicities
  chi;        // Euler characteristic m*(2-#O) + sum_{o in O} GCD(m,o), even <=2


/*
Manual
A core is a pair $(m,O)$ with `principal multiplicity' $m\ge 1$ and `outgoing multiplicities' $O=\{o_1,o_2,...\}$
that add up to a multiple of $m$, and such that $\gcd(m,O)=1$. It is implemented as the following type:
\begin{verbatim}
declare type RedCore;   
declare attributes RedCore: 
  m,          // main component multiplicity
  O,          // outgoing multiplicities in Z/mZ with GCD(m,O)=1, sorted with SortMultiplicities
  chi;        // Euler characteristic m*(2-#O) + sum_{o in O} GCD(m,o), even <=2
\end{verbatim}
*/


// RedCore: constructor and basic type functions


function CoreChi(m,g,O,L)
  chi := m*(2-2*g-#O-#L) + &+[Z| GCD(m,d): d in O];
  return chi;
end function;


intrinsic Core(m::RngIntElt, O::SeqEnum) -> RedCore
{Create a new core from principal multiplicity m and outgoing multiplicities O.}
  error if m lt 1, "Principal multiplicity m should be at least 1";
  O:=[ Z| o mod m: o in O ];
  error if 0 in O, "Outgoing multiplicity in a core cannot be 0";
  error if GCD(Include(O,m)) ne 1, Sprintf("Core should have GCD(m,O)=1 (m=%o O=%o)",m,DelSpaces(O));
  error if &+O mod m ne 0, Sprintf("Core with non-integral self-intersection (m=%o O=%o)",m,DelSpaces(O));
  C:=New(RedCore);
  C`m:=m;
  C`O:=SortMultiplicities(m,O);
  C`chi:=CoreChi(m,0,O,[]);
  error if IsOdd(C`chi), Sprintf("Core: expected even chi when m=%o O=%o",m,DelSpaces(O));
  return C;
end intrinsic;


intrinsic IsCoercible(C::RedCore, y::.) -> BoolElt, .   //
{Coerce a principal component core.}
  return false, _;
end intrinsic;


intrinsic 'in'(C::RedCore, y::.) -> BoolElt    // 
{"in" function for a principal component core.}
  return false;
end intrinsic;


intrinsic Print(C::RedCore, level::MonStgElt)
{Print a principal component core through its label.}
  if level eq "Magma" then
    printf "Core(%o,%o)",Multiplicity(C),DelSpaces(OuterMultiplicities(C));    // Magma: "Core(m,O)"
  else
    printf "%o", Label(C);       // otherwise print label, e.g. II or 4^1,1,1,1
  end if;
end intrinsic;


/*
Example Create and print a principal component core $(m,O)$
Core(8,[1,3,4]);     // Typical core - multiplicities add up to a multiple of m
Core(8,[9,3,4]);     // Same core, as they are in Z/mZ
// This is how cores are printed, with the exception of 7 cores of $\chi=0$ (see below) 
// that come from Kodaira types and two additional special ones D and T:
Core(6,[1,2,3]);                   // from a Kodaira type
DelCRs([Core(2,[1,1]),Core(3,[1,2])]); //> [Core(2,[1,1]),Core(3,[1,2])];     // two special ones
*/



/// Basic invariants and printing


intrinsic Multiplicity(C::RedCore) -> RngIntElt
{Principal multiplicity m of a reduction type core.}
  return C`m;
end intrinsic;


intrinsic OuterMultiplicities(C::RedCore) -> SeqEnum
{Outgoing multiplicities O of a reduction type core, sorted with SortMultiplicities}
  return C`O;
end intrinsic;


intrinsic Chi(C::RedCore) -> RngIntElt
{Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)}
  return C`chi;
end intrinsic;


StandardCoreNames:=[
  <1,[],        "I",    "{\\rm I}">,
  <2,[1,1],     "D",    "{\\rm D}">,
  <3,[1,2],     "T",    "{\\rm T}">,
  <2,[1,1,1,1], "I0*",  "{\\rm I}_0^*">,
  <3,[1,1,1],   "IV",   "{\\rm IV}">,
  <3,[2,2,2],   "IV*",  "{\\rm IV}^*">,
  <4,[1,1,2],   "III",  "{\\rm III}">,
  <4,[3,3,2],   "III*", "{\\rm III}^*">,
  <6,[1,2,3],   "II",   "{\\rm II}">,
  <6,[5,4,3],   "II*",  "{\\rm II}^*">
];


intrinsic Label(C::RedCore: tex:=false) -> MonStgElt
{Label of a reduction type core, for printing (or TeX if tex:=true)}
  m:=C`m;
  O:=C`O;
  if (C`chi lt 0) or ((C`chi eq 2) and (m notin [1,2,3])) then       // m^o1,o2,...,ok
    O:=PrintSequence(C`O: sep:=",");
    return Sprintf("%o%o",m,TeXPrintParameter(O: sym:="^", tex:=tex, printempty:=false)); 
  else                                                              // D,T,II,... etc.
    error if not exists(D){D: D in StandardCoreNames | D[1] eq m and D[2] eq O},
      Sprintf("Could not find standard component for m=%o O=%o",m,DelSpaces(O));
    return tex select D[4] else D[3];
  end if;
end intrinsic;


intrinsic TeX(C::RedCore) -> MonStgElt
{Print a reduction type core in TeX.}
  return Label(C: tex);
end intrinsic;


/*
Example Core labels and invariants
C:=Core(2,[1,1,1,1]);
Multiplicity(C);        // Principal multiplicity m
OuterMultiplicities(C);  // Outgoing multiplicities O
Chi(C);                 // Euler characteristic
Label(C);               // Plain label
TeX(C);                 // TeX label
C: Magma;               // How it can be defined
*/


intrinsic Cores(chi::RngIntElt: mbound:="all", sort:=true) -> SeqEnum
{Returns all reduction type cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a bound on m must be given}

  if chi eq 2 then                // chi=2
    error if mbound cmpeq "all", "mbound must be set when chi=2, otherwise there are infinitely many cores";
    list:=[Core(1,[])]; 
    for m in [2..mbound], a in [1..m div 2] do 
    if GCD(m,a) eq 1 then 
      Append(~list,Core(m,[a,m-a]));      
    end if;
    end for;
    return list;
  end if;

  // chi<=0
  error if IsOdd(chi) or chi gt 0, "chi should be a even number <=0 (or =2 with mbound set)";
  list:=[];
  g:=(2-chi) div 2;
  for m:=1 to 4*g+2 do         // m = principal component multiplicity <= 4*g + 2
  if mbound cmpne "all" and m gt mbound then continue; end if;
  for k:=2 to 4*g   do         // k = |O| = total number of outgoing chains
    if (k/2-2)*m gt -chi then break; end if;
    for M in Multisets({1..m-1},k-1) do
      S:=MultisetToSequence(M);
      e:=(-&+S) mod m;
      if e eq 0 then continue; end if;
      if e lt Max(S) then continue; end if;
      if GCD(Append(S,m)) ne 1 then continue; end if;
      O:=Append(S,e);
      if CoreChi(m,0,O,[]) ne chi then continue; end if;
      Append(~list,Core(m,O));
    end for; 
  end for;
  end for;        

  if sort then
    SortBy(~list,func<c|[c`m] cat c`O>);
  end if;
  return list;
end intrinsic;


/*
Example Cores
PrintSequence(Cores(0)); //> Cores(0);                             // I0*,IV,IV*,III,III*,II,II* (7 of them)
[#Cores(i): i in [0..-10 by -2]];     // 7, 16, 43, 65, 64, ...
*/


/// Inner chains (RedChain)


/*
Manual
Inner chains between principal components fall into three classes: loops on a principal type, D-link 
on a principal type, and chains between principal types that link two of their edge endpoints. 
All of these are implemented as type RedChain that carries class=cLoop, cD or cEdge, and keeps track
of all the invariants.

\begin{verbatim}
declare type RedChain;         // Inner chain: loop, D-link or linking two edge 
declare attributes RedChain:   //   endpoints of two distinct principal components
  class,    // cLoop, cD, cEdge - must be assigned
            // all other attributes may be false if unassigned
  index,    // unique identifier, eventually index in a global array of edges
  Si,Sj,    // principal types S[i], S[j] between which the edge is going
  mi,mj,    // principal multiplicities of the components S[i], S[j]
  di,dj,    // outgoing multiplicities of the inner chain, so that it is mi,di,...,dj,mj
  depth,    // original depth, used for sorting
  depthstr; // string for printing, by default Sprint(depth), but could me "m", "n", etc.
\end{verbatim}
*/


cLoop  := 1;    // Constants for edge class
cD     := 2;
cEdge  := 3;


declare type RedChain;         // Inner chain: loop, D-link or linking two 
declare attributes RedChain:   //   edges of distinct principal components
  class,    // cLoop=1, cD=2, cEdge=3 - must be assigned, and so should be mi,di
            // other attributes may be false if unassigned
  index,    // unique identifier, eventually index in a global array of inner chains 
  Si,Sj,    // principal types S[i], S[j] between which the inner chain is going
  mi,mj,    // principal multiplicities of the components S[i], S[j]
  di,dj,    // outgoing multiplicities of the inner chain, so that it is mi,di,...,dj,mj
  depth,    // original depth, used for sorting
  depthstr; // string for printing, by default Sprint(depth), but could me "m", "n", etc.


intrinsic IsCoercible(c::RedChain, y::.) -> BoolElt, .    //
{Coerce a reduction type edge.}
  return false, _;
end intrinsic;


intrinsic 'in'(c::RedChain, y::.) -> BoolElt              // 
{"in" function for a reduction type edge.}
  return false;
end intrinsic;


intrinsic Link(class::RngIntElt, mi::RngIntElt, di::RngIntElt, mj::Any, dj::Any: 
  depth:=false, Si:=false, Sj:=false, index:=false) -> RedChain
{Return an inner chain of a given class and specified invaraints:
  class   = cLoop (loop), cD (D-link) or cEdge (inner chain between different principal types)
  Si      = originating principal type S_i (by default unspecified (Si:=false))
  mi, di  = principal multiplicity of S_i and outgoing multiplicity of the chain from S_i
  Sj      = target principal type S_j (by default unspecified (Sj:=false))
  mj, dj  = principal multiplicity of S_j and outgoing multiplicity of the chain from S_j
    so that the chain of P1s has multiplicities [mi,di,...,dj,mj]
  depth   = depth of the chain (by default minimal (depth:=false))
  index   = index in the list of inner chains of a reduction type to which the chain belongs
            (by default unspecified (index:=false))}
  requirerange class, cLoop, cEdge;
  error if exists(x){x: x in [*mj,dj,depth*] | Type(x) ne RngIntElt and x cmpne false}, 
    Sprintf("Link: %o is neither an integer nor 'false'",x);
  c:=New(RedChain);
  c`class:=class;
  c`index:=index;
  c`Si:=Si;
  c`Sj:=Sj;
  if class eq cD then
    if mj cmpeq false then mj:=GCD(mi,di); end if;
    if dj cmpeq false then dj:=mj; end if;
    error if IsOdd(mj), Sprintf("Link: invalid D-link with mj=%o dj=%o",mj,dj);
  end if;
  if mi cmpne false and di cmpne false then
    di:=di mod mi;
    if di eq 0 then di:=mi; end if;
  end if;
  if mj cmpne false and dj cmpne false then
    dj:=dj mod mj;
    if dj eq 0 then dj:=mj; end if;
    error if GCD(mi,di) ne GCD(mj,dj),
      Sprintf("RedChain: Cannot construct an edge because GCD(mi=%o,di=%o)<>GCD(mj=%o,dj=%o)",mi,di,mj,dj);
    if depth cmpeq false then 
      depth:=MinimalDepth(mi,di,mj,dj);
    end if;
  end if;
  c`mi:=mi;
  c`mj:=mj;
  c`di:=di;
  c`dj:=dj;
  c`depth:=depth;
  c`depthstr:=depth cmpeq false select false else Sprint(depth);
  return c;
end intrinsic;


intrinsic Print(c::RedChain, level::MonStgElt)
{Print a chain c like 'class mi,di - (depth) mj,dj', together with indices of Si, Sj and c if assigned}
  classstr:=["loop","D-link","edge"][c`class];
  indexstr:=c`index cmpeq false select "" else Sprintf("[%o] ",c`index);
  Sistr:=c`Si cmpeq false select "" else Sprintf("c%o ",c`Si`index); 
  Sjstr:=c`Sj cmpeq false select "" else Sprintf("c%o ",c`Sj`index); 
  printf "%o%o %o%o,%o -(%o) %o%o,%o",indexstr,classstr,Sistr,c`mi,c`di,c`depthstr,Sjstr,c`mj,c`dj;
end intrinsic;


/*
Example Some inner chains, with no principal types specified
cLoop, cD, cEdge := Explode([1,2,3]);
Link(cLoop,2,1,2,1);               // loop 
Link(cD,2,2,false,false);          // D-link
Link(cEdge,2,2,false,false);      // to another (yet unspecified) principal type
*/


/// Invariants and depth


intrinsic Class(c::RedChain) -> RngIntElt
{Class of a RedChain - cLoop, cD or cEdge depending on the type of the chain}
  return c`class;
end intrinsic;


intrinsic Weight(c::RedChain) -> RngIntElt
{Weight od the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,dj))}
  return GCD(c`mi,c`di);
end intrinsic;


intrinsic Copy(c::RedChain) -> RedChain             //
{Make a copy of an inner chain}
  f:=New(RedChain);
  f`class:=c`class;
  f`index:=c`index;
  f`Si:=c`Si;
  f`Sj:=c`Sj;
  f`mi:=c`mi;
  f`mj:=c`mj;
  f`di:=c`di;
  f`dj:=c`dj;
  f`depth:=c`depth;
  f`depthstr:=c`depthstr;
  return f;
end intrinsic;


intrinsic Reverse(c::RedChain) -> RedChain         // 
{Reverse the direction of an inner chain}
  f:=New(RedChain);
  f`class:=c`class;
  f`index:=c`index;
  f`Sj:=c`Si;
  f`Si:=c`Sj;
  f`mj:=c`mi;
  f`mi:=c`mj;
  f`dj:=c`di;
  f`di:=c`dj;
  f`depth:=c`depth;
  f`depthstr:=c`depthstr;
  return f;
end intrinsic;


intrinsic Index(c::RedChain) -> RngIntElt
{Index of the chain c used for ordering chains in a reduction type, and sorting in label.}
  return c`index;
end intrinsic;


intrinsic SetDepth(~e::RedChain, n::RngIntElt)            //
{Set depth and depth string of an inner chain e}
  min:=MinimalDepth(e`mi,e`di,e`mj,e`dj);  
  error if n lt min, Sprintf("SetDepth for e=%o: n < MinimalDepth",DelCRs(e));
  e`depth:=n;
  e`depthstr:=Sprint(n);
end intrinsic;


intrinsic SetDepth(~e::RedChain, n::BoolElt)              //
{Set depth and depth string of an inner chain e to the minimal possible n (assumes n=False)}
  assert n eq false;
  min:=MinimalDepth(e`mi,e`di,e`mj,e`dj);  
  e`depth:=min;
  e`depthstr:=Sprint(min);
end intrinsic;


intrinsic DepthString(c::RedChain) -> MonStgElt
{String set by SetDepths how c is printed, e.g. "1" or "n"}
  return c`depthstr;
end intrinsic;


intrinsic SetDepthString(c::RedChain, depth::Any)
{Set how c is printed, e.g. "1" or "n"}
  c`depthstr:=Sprint(depth);
end intrinsic;


/*
Example Invariants of inner chains
// Take a genus 2 reduction type \redtype{I_2\e(1)I*_2} whose special fibre 
// consists of Kodaira types \redtype{I_2} (loop of $\P^1$s) and \redtype{I^*_2} linked 
// by a chain of $\P^1$s of multiplicity 1.
R:=ReductionType("I2-(1)I2*");  
TeX(DualGraph(R));              
// There are two principal types R!!1=\redtype{I_2} and R!!2=\redtype{I^*_2}, with a loop on R!!1 (class cLoop=1), 
// an inner chain between them (class cEdge=3), and a D-link on R!!2 (class cD=2)
// This is the order in which they are printed in the label.
DelCRs([R!!1,R!!2]); //> [R!!1,R!!2];                     // two principal types R!!1 and R!!2
c1,c2,c3:=Explode(InnerChains(R)); c1,c2,c3;
Class(c3);                       // cLoop=1, *cD=2*, cEdge=3
Weight(c3);                      // GCD of the chain multiplicities [2,2,2]
Index(c3);                       // index in the reduction type
SetDepthString(c3, "n");         // change how its depth is printed in labels
c3;                              //   and drawn in dual graphs of reduction types
Label(R);
TeX(DualGraph(R));
*/


/// Principal component types (RedPrin) 


declare type RedPrin;               
declare attributes RedPrin: 
  m,             // principal multiplicity
  g,             // genus
  C,             // chains: outer, loops, D-links or edge from S 
  O,             // outgoing multiplicities for outer chains
  L,             // outgoing multiplicities from all other chains
  gcd,           // gcd(m,O,L)
  core,          // core of type RedCore (divide by gcd)
  chi,           // Euler characteristic =chi(m,g,O,L)
  index;         // index in a reduction type 



/*
Manual
The classification of special fibre of mrnc models is based on principal types. 
For curves of genus $\ge 2$ such a type is a principal component with $\chi<0$, together with its outer chains,
loops, chains to principal component with $\chi=0$ (called D-links) and a tally of inner chains to other principal 
components with $\chi<0$, called edges. For example, the following reduction type has only principal
type (component~$\Gamma_1$) with one loop and one D-link:

\begin{tikzpicture}[xscale=0.8,yscale=0.7,
  lfnt/.style={font=\tiny},
  l2end/.style={shorten <=-0.3em},
  mainl/.style={scale=0.8,above left=-0.17em and -1.5em},
  rightl/.style={right=-3pt,lfnt},
  l2/.style={shorten >=-0.3em,shorten <=-0.3em},
  aboverightl/.style={above right=-4.5pt,lfnt},
  l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick},
  aboveleftl/.style={above left=-4.5pt,lfnt},
  facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}]
\draw[l1] (0,0)--(5.2,0) node[mainl] {8} node[facel] {$\Gamma_1$};
\draw[l2end] (0,0)--node[rightl] {1} (0,0.66);
\draw[l2end] (0.8,0)--node[rightl] {2} (0.8,0.66);
\draw[l2end] (1.6,0)--node[rightl] {1} (1.6,0.66);
\draw[l2] (2.73,0)--node[aboverightl] {1} (2.4,0.66);
\draw[l2] (2.4,0.66)--node[aboveleftl] {1} (3.06,1.33);
\draw[l2] (3.73,0.66)--node[aboverightl] {1} (3.06,1.33);
\draw[l2] (3.4,0)--node[aboveleftl] {1} (3.73,0.66);
\draw[l1] (4.53,0.66)--(6.6,0.66) node[mainl] {2} node[facel] {};
\draw[l2] (4.53,0)--node[rightl] {2} (4.53,0.66);
\draw[l2end] (5.13,0.66)--node[rightl] {1} (5.13,1.33);
\draw[l2end] (5.93,0.66)--node[rightl] {1} (5.93,1.33);
\node[scale=0.9] at (2,-1) (L) {loop};
\node[scale=0.9] at (6.5,-1) (P) {principal component $\Gamma_1$};
\node[scale=0.9] at (10,0.55) (D) {D-link};
\draw[->] (L) edge[out=20,in=-90] (3.08,0.4);
\draw[->] (P) edge[out=20,in=0] (6.2,0);
\draw[->] (D) edge[out=180,in=0] (7.6,0.66);
\end{tikzpicture}

A principal type is implemented as the following Magma type. 

\begin{verbatim}
declare type RedPrin;               // (m,g,O,Lloops,LD,ledge)
declare attributes RedPrin: 
  m,        // principal multiplicity
  g,        // genus
  C,        // chains: outer, loops, D-links or edge from S 
  O,        // outgoing multiplicities for outer chains
  L,        // outgoing multiplicities from all other chains
  gcd,      // gcd(m,O,L)
  core,     // core of type RedCore (divide by gcd)
  chi;      // Euler characteristic =chi(m,g,O,L)
\end{verbatim}
*/


intrinsic IsCoercible(S::RedPrin, y::.) -> BoolElt, .   //
{Coerce a principal type (internal function).}
  return false, _;
end intrinsic;


intrinsic 'in'(S::RedPrin, y::.) -> BoolElt     //
{"in" function for a principal type (internal function).}
  return false;
end intrinsic;


/// Creation functions


procedure AddOuterMultiplicity(~S, o)
  // Add outer multiplicity and outer chain to a principal type S
  m:=S`m;
  error if o mod m eq 0, "AddOuterMultiplicity: Outer multiplicities must be non-zero mod m";
  S`O:=SortMultiplicities(m,Append(S`O,o mod m));
end procedure;


procedure AddInnerMultiplicitiesAndLoop(~S, di, dj: depth:=false, index:=false)
  // Add two inner multiplicities and a loop to a principal type S; depth should be an integer or false
  m:=S`m;
  error if GCD(m,di) ne GCD(m,dj), Sprintf("AddInnerMultiplicitiesAndLoop: GCD(%o,%o)<>GCD(%o,%o)",m,di,m,dj);
  di:=di mod m;
  if di eq 0 then di:=m; end if;
  dj:=dj mod m;
  if dj eq 0 then dj:=m; end if;
  if di gt dj then
    tmp:=di; di:=dj; dj:=tmp;
  end if;
  Append(~S`L,di);
  Append(~S`L,dj);
  Append(~S`C,Link(cLoop,S`m,di,S`m,dj: Si:=S, Sj:=S, depth:=depth, index:=index));
end procedure;


procedure AddInnerMultiplicityAndDLink(~S, d: depth:=false, index:=false)
  // Add inner multiplicity and a D-link to a principal type S; depth should be an integer or false
  m:=S`m;
  error if IsOdd(m) or IsOdd(d),
    Sprintf("To have D-links, multiplicities m(%o) and di(%o) must be even",m,d); 
  d:=d mod m;
  if d eq 0 then d:=m; end if;  
  mj:=GCD(m,d);
  dj:=mj;
  Append(~S`L,d);
  Append(~S`C,Link(cD,S`m,d,mj,dj: Si:=S, depth:=depth, index:=index));
end procedure;


procedure AddInnerMultiplicityAndEdgeLink(~S, d: index:=false)
  // Add inner multiplicity and a edge to a principal type S
  m:=S`m;
  d:=d mod m;
  if d eq 0 then d:=m; end if;  
  Append(~S`L,d);
  Append(~S`C,Link(cEdge,S`m,d,false,false: Si:=S, index:=index));
end procedure;


procedure MergeEdgeEndpoints(Si,di,Sj,dj: depth:=false, index:=false)
  vprint redlib,2: "Merging",DelSpaces(Si),di,DelSpaces(Sj),dj;
  error if not exists(i1){i: i->e in Si`C | Class(e) eq cEdge and e`di eq di and e`Sj cmpeq false},
    Sprintf("Could not find a edge endpoints in %o of multiplicity %o",Sprint(Si,"Magma"),di);
  error if not exists(i2){i: i->e in Sj`C | Class(e) eq cEdge and e`di eq dj and e`Sj cmpeq false},
    Sprintf("Could not find a edge endpoints in %o of multiplicity %o",Sprint(Sj,"Magma"),dj);
  error if GCD(Multiplicity(Si),di) ne GCD(Multiplicity(Sj),dj),
    Sprintf("MergeEdgeEndpoints: GCD(%o,%o)<>GCD(%o,%o)",Multiplicity(Si),di,Multiplicity(Sj),dj);
  e:=Si`C[i1];
  e`Sj:=Sj;
  e`mj:=Sj`m;
  e`dj:=dj;
  SetDepth(~e,depth);
  e`index:=index;  
  Sj`C[i2]:=Reverse(e);
end procedure;


procedure AddInnerMultiplicityAndChain(~S1, d1, ~S2, d2: depth:=false, index:=false)
  // Add inner multiplicity and a edge to a principal type S
  m1:=S1`m;
  d1:=d1 mod m1;
  if d1 eq 0 then d1:=m1; end if;  
  m2:=S2`m;
  d2:=d2 mod m2;
  if d2 eq 0 then d2:=m2; end if;  
  e:=Link(cEdge,S1`m,d1,S2`m,d2: depth:=depth, Si:=S1, Sj:=S2, index:=index);
  Append(~S1`L,d1);
  Append(~S2`L,d2);
  Append(~S1`C,e);
  Append(~S2`C,Reverse(e));
end procedure;


procedure Finalize(~S)
  // Sort all chains in a principal type S, set core, chi and gcd. Assumes mutiplicity, genus, O and L are set.
  m:=S`m;
  g:=S`g;
  S`chi:=CoreChi(m,g,S`O,S`L);                                  // chi
  gcd:=GCD(S`O cat S`L cat [m]);
  corem:=m div gcd;
  coreO:=[ d div gcd: d in S`O cat S`L | d ne m ];              // gcd and core 
  S`gcd:=gcd;
  S`core:=Core(corem,coreO); 
  if IsEmpty(S`C) then return; end if;
  m:=S`m;
  function order(e)
    return [e`class,GCD(m,e`di),e`di,e`dj cmpeq false select 0 else e`dj,e`depth cmpeq false select 0 else e`depth];
  end function;
  SortBy(~S`C,order);
end procedure;


function NewPrincipalType(m, g: index:=0, O:=[])
// Create a new principal type of multiplicity m and genus g, optionally O (with chains to be added later).

  S:=New(RedPrin);
  S`index:=index;
  S`O:=[Z|];
  S`L:=[Z|];
  S`C:=[];

  error if m le 0, "Principal multiplicity should be >=1"; 
  S`m:=m;                                                       // Principal multiplicity

  error if g lt 0, "Geometric genus should be >=0"; 
  S`g:=g;                                                       // genus

  S`chi:=CoreChi(m,g,[],[]); 
  S`gcd:=m;
  S`core:=Core(1,[]); 
  
  for o in O do                                                 // outer chains
    AddOuterMultiplicity(~S,o);
  end for;
    
  return S;
end function;


intrinsic PrincipalType(m::RngIntElt, g::RngIntElt, O::SeqEnum, Lloops::SeqEnum, LD::SeqEnum, Ledge::SeqEnum: index:=0) -> RedPrin
{Create a new principal type from its primary invariants, and check integral self-intersection.}

  S:=NewPrincipalType(m,g: index:=index, O:=O);                        // Create empty type

  for l in Lloops do                                                   // loops
    error if ExtendedType(l) ne SeqEnum[RngIntElt] or #l notin [2,3],
      "Loops must be a sequence [d1,d2] or [d1,d2,depth]"; 
    di,dj:=Explode(l);
    depth:=false;
    if #l eq 3 then
      depth:=l[3];
      error if depth lt MinimalDepth(m,di,m,dj),
        Sprintf("depth %o < MinimalDepth(%o,%o,%o,%o) in loop %o",depth,m,di,m,dj,DelSpaces(l));
    end if;
    AddInnerMultiplicitiesAndLoop(~S,di,dj: depth:=depth);
  end for;

  for l in LD do                                                      // D-links
    error if ExtendedType(l) ne SeqEnum[RngIntElt] or #l notin [1,2],
      "LD must be a sequence [d1] or [d1,depth]"; 
    di:=Explode(l);
    error if IsOdd(m) or IsOdd(di),
      Sprintf("To have D-links, multiplicities m(%o) and di(%o) must be even",m,di); 
    mj:=GCD(m,di);
    dj:=mj;
    depth:=false;
    if #l eq 2 then
      depth:=l[2];
      error if depth lt MinimalDepth(m,di,mj,dj),
        Sprintf("depth %o < MinimalDepth(%o,%o,%o,%o) in D-link %o",depth,m,di,mj,dj,DelSpaces(l));
    end if;
    AddInnerMultiplicityAndDLink(~S,di: depth:=depth);
  end for;

  for d in Ledge do                                                 // edges
    AddInnerMultiplicityAndEdgeLink(~S,d);
  end for;

  error if (&+S`O + &+S`L) mod m ne 0,
    Sprintf("Principal type with non-integral self intersection: m=%o O=%o L=%o",m,DelSpaces(S`O),DelSpaces(S`L));

  Finalize(~S);

  return S;
end intrinsic;



/*
Example
// We construct the principal type from example above. It has $m=8$, $g=0$, outer multiplicities 1,1,2,
// loop $1-1$ of depth 3, a D-link with outgoing multiplicity 2 of depth 1, and no edges
// (so that it is a reduction type in itself).
S:=PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[]);
// We print S in a format that can be evaluated back (S: Magma), print its label 
// (by printing S or Label(S)) and draw its dual graph.
S:Magma;
S;
TeX(DualGraph(ReductionType("8^1,1,1,1,2,2_3,1D")));
*/


/*
Manual
We can generate all principal types S a given Euler characteristic Chi(S), or restrict to those with a given core
or a given sequence of gcd's of outgoing multiplicities of all edges. The latter are used to generate
all reduction types in given genus through their shapes (see RedShape), where such types placed at the vertices`.
*/


intrinsic PrincipalTypes(chi::RngIntElt, C::RedCore: withweights:=false, sorted:=true) -> SeqEnum[RedPrin], SeqEnum[SeqEnum[RngIntElt]]
{Find all possible principal types S with a given core C and Euler characteristic chi. Return a sequence of them.
If withweights:=true, also return a sequence weights representing all possible Weight(S).}
  error if chi gt 0, "chi should be negative in PrincipalTypes";
  error if chi eq 0, "Infinitely many principal types with chi=0";
  out:=[];       // List of principal components found (of type RedPrin)
  weights:=[];     // Set of Weights found (of type SeqEnum[RngIntElt])
  for d in Divisors(Abs(chi)) do                   // [d]C is the starting point
    if d*Chi(C) lt chi then continue; end if;
    m:=d*Multiplicity(C);
    OC:=[d*o: o in OuterMultiplicities(C)];
    for U in MultiSubsets(OC) do                   // Convert outers to links in all possible ways
      chiL:=d*Chi(C) - &+[Z| GCD(d,m): d in U];       //   -> decreases chi by sum of gcds
      if (chiL lt chi) or ((chiL-chi) mod m ne 0) then continue; end if;
      O:=SequenceDifference(OC,U);
      n:=(chiL-chi) div m;                         // Space left to add new links or increase genus
      for g:=0 to n div 2 do
        L:=U cat [ m: i in [2*g..n-1] ];           // Now split L into D's, loops and edges
        Leven:=IsEven(m) select [d: d in L | IsEven(d)] else [];
        for LD in MultiSubsets(Leven) do           // loops through possible D-links
          Lleft:=SequenceDifference(L,LD);
          pairs:={[l1,l2]: l1,l2 in Set(Lleft) | (l1 le l2) and (GCD(l1,m) eq GCD(l2,m))    // set of pairs that
            and ((l1 ne l2) or Multiplicity(Lleft,l1) ge 2)};                               // could define valid loops
          possibleloops:=[[]];
          for p in pairs do
          for i->c0 in possibleloops do
            c:=c0;
            repeat
              cnew:=Append(c,p);
              if not IsSubMultiset(&cat cnew,Lleft) then break; end if;
              c:=cnew;
              Append(~possibleloops,c);
            until false;
          end for;      
          end for;      
          vprintf redlib,2: "pairs=%o possibleloops=%o\n",DelSpaces(pairs),DelSpaces(possibleloops);
          for Lloops in possibleloops do
            Ledge:=SequenceDifference(Lleft,&cat Lloops);       // edges
            S:=PrincipalType(m,g,O,Lloops,[[d]: d in LD],Ledge);   
            Append(~out,S);
            if Weight(S) notin weights then 
              Append(~weights,Weight(S));
            end if;
          end for;
        end for;
      end for;
    end for;
  end for;
  if sorted then
    Sort(~out);
  end if;
  if withweights 
    then return out,weights;
    else return out;
  end if;
end intrinsic;


intrinsic PrincipalTypes(chi::RngIntElt: semistable:=false, withweights:=false, sorted:=true) -> SeqEnum, SeqEnum
{Find all possible principal types S with a given Euler characteristic chi. Return a sequence of them.
If withweights:=true, also return a sequence weights representing all possible Weight(S).}

  error if chi gt 0, "PrincipalTypes: chi must be negative for a principal type";
  error if chi eq 0, "PrincipalTypes: Infinitely many principal types with chi=0";

  if semistable then
    comps:=[C: C in PrincipalTypes(chi,Core(1,[])) | Multiplicity(C) eq 1];    // trivial core, multiplicity 1
    weights:=SetToSequence({Weight(S): S in comps});
    return comps,weights;
  end if;

  out:=[];
  weights:=[];

  for c:=2 to chi by -2 do
    mbound:=c eq 2 select -chi+2 else "all";
    for C in Cores(c: mbound:=mbound) do 
      comps,weightc:=PrincipalTypes(chi,C: withweights);
      out cat:= comps;
      for weight in weightc do 
        if weight notin weights then Append(~weights,weight); end if;
      end for;
    end for;
  end for;

  if sorted then
    Sort(~out);
  end if;
  if withweights 
    then return out,weights;
    else return out;
  end if;
end intrinsic;


intrinsic PrincipalTypes(chi::RngIntElt, weight::SeqEnum: semistable:=false, withweights:=false, sorted:=true) -> SeqEnum
{All possible principal types with a given Euler characteristic chi and GCDs of edge multiplicities. If withweights:=true,  also returns [weight] as a second parameter (like all other PrincipalTypes instances).}
  Sort(~weight);
  out:=[S: S in PrincipalTypes(chi: semistable:=semistable) | Weight(S) eq weight]; 
  if sorted then
    Sort(~out);
  end if;
  if withweights 
    then return out,[weight];
    else return out;
  end if;
end intrinsic;


/*
Test
assert #PrincipalTypes(-1,[0]) eq 0;
assert #PrincipalTypes(-1,[1]) eq 10;
assert #PrincipalTypes(-1,[1,1,1]) eq 1;
assert #PrincipalTypes(-1,[1,2]) eq 1;
assert #PrincipalTypes(-1,[3]) eq 1;
assert #PrincipalTypes(-2,[]) eq 46;
assert #PrincipalTypes(-2,[0]) eq 0;
assert #PrincipalTypes(-2,[1]) eq 0;
assert #PrincipalTypes(-2,[1,1]) eq 8;
assert #PrincipalTypes(-2,[2,2]) eq 2;
assert #PrincipalTypes(-2,[6]) eq 1;
assert #PrincipalTypes(-2,[2]) eq 18;
assert #PrincipalTypes(-3,[1]) eq 39;
assert #PrincipalTypes(-1) eq 13;
assert #PrincipalTypes(-2) eq 83;
assert #PrincipalTypes(-3) eq 75;
*/


/*
Example Generating principal types
// Geneate principal types of Euler characteristic $\chi=-1, -2, -3, -4$
[#PrincipalTypes(-n): n in [1..4]];      // 13, 83, 75, 277, 176, 591, ...
// Generate those with $\chi=-1$ and one edge of multiplicity 1
assert #PrincipalTypes(-1,[1]) eq 10;    // Table 1_10^1 in the classification paper
// Principal types with core $\chi=-1$ and core IV
PrintSequence(PrincipalTypes(-2,Core(3,[1,1,1]))); //> PrincipalTypes(-2,Core(3,[1,1,1]));
*/

/*
Example Principal type with given $\chi$ and gcds of edges
S:=PrincipalType(4,0,[1,2],[],[],[1]);   
S;              // Kodaira type with one edge
Chi(S);         // with chi(S)  = -1
Weight(S);        // and  Weight(S) = [1]
DelCRs(PrincipalTypes(Chi(S),Weight(S))); //> PrincipalTypes(Chi(S),Weight(S));    // all principal types with these parameters
*/



/// Invariants of principal types


intrinsic Multiplicity(S::RedPrin) -> RngIntElt
{Principal multiplicity m of a principal type}
  return S`m;
end intrinsic;


intrinsic GeometricGenus(S::RedPrin) -> RngIntElt
{Geometric genus g of a principal type S=(m,g,O,...)}
  return S`g;
end intrinsic;


intrinsic Index(S::RedPrin) -> RngIntElt
{Index of the principal component in a reduction type, 0 if freestanding}
  return S`index;
end intrinsic;


intrinsic Chains(S::RedPrin: class:=0) -> SeqEnum[RedChain]
{Sequence of chains of type RedChain originating in S. By default, all (loops, D-links, edge) 
are returned, unless class is specified.}
  if class eq 0 
    then return S`C;
    else return [e: e in S`C | e`class eq class];
  end if;
end intrinsic;


intrinsic OuterMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]
{Sequence of outer multiplicities S`O of a principal type, sorted}
  return S`O;
end intrinsic;


intrinsic EdgeMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]
{Sequence of edge multiplicities of a principal type, sorted}
  return [e`di: e in Chains(S: class:=cEdge)];
end intrinsic;


intrinsic InnerMultiplicities(S::RedPrin) -> SeqEnum[RngIntElt]
{Sequence of inner multiplicities S`L of a principal type, sorted as in label}
  return S`L;
end intrinsic;


intrinsic Loops(S::RedPrin) -> SeqEnum[RedChain]
{Sequence of chains in S representing loops (class cLoop)}
  return Chains(S: class:=cLoop);
end intrinsic;


intrinsic DLinks(S::RedPrin) -> SeqEnum[RedChain]
{Sequence of chains in S representing D-links (class cD)}
  return Chains(S: class:=cD);
end intrinsic;


/*
Example Invariants of principal types
S:=PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[]);     // Example above
TeX(DualGraph(ReductionType([S])));
Multiplicity(S);          // Principal component multiplicity
GeometricGenus(S);        // Geometric genus of the principal component
OuterMultiplicities(S);    // Outer chain initial multiplicities O=[1,1,2]
DelCRs(Loops(S)); //> Loops(S);                 // Loops (of type RedChain)
DelCRs(DLinks(S)); //> DLinks(S);                // D-Links (of type RedChain)
EdgeMultiplicities(S);   // Edge multiplicities
InnerMultiplicities(S);    // All initial inner multiplicities (loops, D-links, edge)
*/


intrinsic GCD(S::RedPrin) -> RngIntElt
{Return GCD(m,O,L) for a principal type}
  return S`gcd;
end intrinsic;


intrinsic Core(S::RedPrin) -> RedCore
{Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m,O)=1}
  return S`core;
end intrinsic;


intrinsic Chi(S::RedPrin) -> RngIntElt
{Euler characteristic chi of a principal type (m,g,O,Lloops,LD,Ledge), chi = m(2-2g-|O|-|L|) + sum_(o in O) gcd(o,m), where L consists of all the inner multiplicities in Lloops (2 from each), LD (1 from each), Ledge (1 from each)}
  return S`chi;
end intrinsic;


intrinsic Weight(S::RedPrin) -> SeqEnum[RngIntElt]
{Outgoing link pattern of a principal type = multiset of GCDs of edges with m.}
  m:=Multiplicity(S);
  return [GCD(a,m): a in EdgeMultiplicities(S)];
end intrinsic;


intrinsic Copy(S::RedPrin: index:=false) -> RedPrin    //
{Make a copy of a principal type.}
  N:=New(RedPrin);
  N`m:=S`m;
  N`g:=S`g;
  N`C:=[Copy(e): e in S`C];
  for i:=1 to #N`C do
    c:=N`C[i];
    c`Si:=N;                                    // Set originating component to N
    if Class(c) eq cLoop then c`Sj:=N; 
    else error if c`Sj cmpne false, "Copy(S): Expected no target component in c";
    end if;
  end for;
  N`O:=S`O;
  N`L:=S`L;
  N`gcd:=S`gcd;
  N`core:=Core(S`core`m,S`core`O);
  N`chi:=S`chi;  
  if index cmpeq false
    then N`index:=S`index;
    else N`index:=index;
  end if;
  return N;
end intrinsic;


/*
Example GCD
// Define a principal component type by its primary invariants: $m=6$, $g=1$, outer multiplicities $\cO=\{4\}$, 
// no loops, one D-link with initial multiplicity 2 and length 1, and no edges:
S:=PrincipalType(6,1,[4],[],[[2,1]],[]);    
GCD(S);                 // its GCD(m,O,L)=GCD(4,[2],[2])=2
Core(S);                // divide by GCD, unlink all chains
S;                      // these are seen as [2] and T in the name
// Note, however, that S is not a multiple of 2 of another principal component type because its D-link is primitive. 
// In other words, the special fibre has odd multiplicity components.
TeX(DualGraph(ReductionType("[2]Tg1_1D")));
*/


/*
assert #PrincipalTypes(-1,[0]) eq 0;
assert #PrincipalTypes(-1,[1]) eq 10;
assert #PrincipalTypes(-1,[1,1,1]) eq 1;
assert #PrincipalTypes(-1,[1,2]) eq 1;
assert #PrincipalTypes(-1,[3]) eq 1;
assert #PrincipalTypes(-2,[]) eq 46;
assert #PrincipalTypes(-2,[0]) eq 0;
assert #PrincipalTypes(-2,[1]) eq 0;
assert #PrincipalTypes(-2,[1,1]) eq 8;
assert #PrincipalTypes(-2,[2,2]) eq 2;
assert #PrincipalTypes(-2,[6]) eq 1;
assert #PrincipalTypes(-2,[2]) eq 18;
assert #PrincipalTypes(-3,[1]) eq 39;
assert #PrincipalTypes(-1) eq 13;
assert #PrincipalTypes(-2) eq 83;
assert #PrincipalTypes(-3) eq 75;
for d in PrincipalTypes(-2,[]) do assert d eq eval Sprint(d,"Magma"); end for;
*/


/// RedPrin: Score and comparison


intrinsic Score(S::RedPrin) -> SeqEnum[RngIntElt]
{Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a principal type, and characterises it uniquely.}
  w:=[Chi(S),Multiplicity(S),-GeometricGenus(S),#EdgeMultiplicities(S),#DLinks(S),#Loops(S),#OuterMultiplicities(S)]
    cat OuterMultiplicities(S) 
    cat Flat([[e`di,e`dj]: e in Loops(S)])
    cat [e`di: e in DLinks(S)] 
    cat EdgeMultiplicities(S)
    cat [e`depth: e in Loops(S)]
    cat [e`depth: e in DLinks(S)];
  return w;
end intrinsic;


intrinsic PrincipalType(w::SeqEnum[RngIntElt]) -> RedPrin
{Create a principal type S from its score sequence w (=Score(S)).}
  error if #w lt 7, "Score "*DelSpaces(w)*" is too short for a score sequence for a principal type";
  chi,m,g,numedges,numD,numloops,numO:=Explode(w);        // extract 7 basic invariants
  wlength:=7 + numO + numedges + 2*numD + 3*numloops;
  error if #w ne wlength, "Score sequence "*DelSpaces(w)*" has incorrect length";
  Oofs:=7;
  loopsofs:=Oofs + numO;
  Dofs:=loopsofs + 2*numloops;
  edgeofs:=Dofs + numD;
  loopsdepthsofs:=edgeofs + numedges;
  Ddepthsofs:=loopsdepthsofs + numloops;

  O:=[Z | w[Oofs+j]: j in [1..numO] ];                                                          // extract outer multiplicities
  Lloops:= [[Z| w[loopsofs+2*i-1], w[loopsofs+2*i], w[loopsdepthsofs+i]]: i in [1..numloops]];  // extract loops
  LD:= [[Z| w[Dofs+i], w[Ddepthsofs+i]]: i in [1..numD]];                                       // extract D-links
  Ledge:=[Z | w[edgeofs+j]: j in [1..numedges] ];                                               // extract edges
  S:=PrincipalType(m,-g,O,Lloops,LD,Ledge); 
  error if Score(S) ne w, "Score sequence "*DelSpaces(w)*" does not agree with Score(S)";
  return S;
end intrinsic;


/*
Example Score
S:=PrincipalType(8,0,[4,2],[[1,1,1]],[[2,1]],[6]);   // create principal type 
w:=Score(S);             // its score encodes chi,m,g,... and characterises it
w;
PrincipalType(w): Magma;  // so that the component can be reconstructed
*/


intrinsic 'eq'(S1::RedPrin, S2::RedPrin) -> BoolElt
{Compare two principal types by their score}
  return Score(S1) eq Score(S2);
end intrinsic;


intrinsic 'lt'(S1::RedPrin, S2::RedPrin) -> BoolElt
{Compare two principal types by their score}
  return Score(S1) lt Score(S2);
end intrinsic;


intrinsic 'le'(S1::RedPrin, S2::RedPrin) -> BoolElt
{Compare two principal types by their score}
  return Score(S1) le Score(S2);
end intrinsic;


intrinsic 'gt'(S1::RedPrin, S2::RedPrin) -> BoolElt
{Compare two principal types by their score}
  return Score(S1) gt Score(S2);
end intrinsic;


intrinsic 'ge'(S1::RedPrin, S2::RedPrin) -> BoolElt
{Compare two principal types by their score}
  return Score(S1) ge Score(S2);
end intrinsic;


intrinsic Sort(S::SeqEnum[RedPrin]) -> SeqEnum[RedPrin]
{Sort principal types by their score}
  S:=SortByFunc(S,Score);
  return S;
end intrinsic;


intrinsic Sort(~S::SeqEnum[RedPrin])
{Sort principal types by their score}
  SortBy(~S,Score);
end intrinsic;


/*
Example Sorting principal types by Score in increasing order
L := PrincipalTypes(-2,[4]) cat PrincipalTypes(-2,[2,2]);
"["*PrintSequence([DelSpaces(Score(S)): S in L])*"]"; //> [Score(S): S in L];
"["*PrintSequence(Sort(L))*"]"; //> Sort(L);
*/


/// Printing


function Decorations(e: Oi:="default", Oj:="default", forcesups:=false, forcesubs:=true)
  /*
    returns sym, sups, subs: symbol - or = , list of superscripts and list of subscripts 
      for an edge of type RedChain. 
    Oi = available multiplicites on the left, by default from e`Si`O + e`Si`L, sorted 
    Oj = available multiplicites on the left, by default from e`Sj`O + e`Sj`L, sorted
    forcesups and forcesubs force subscripts to be present even when they are default
  */
  error if e`mj cmpeq false or e`dj cmpeq false, 
    "Decorations: second component data is not defined";

  if Oi cmpeq "default" then
    Oi:=SortMultiplicities(e`mi,[ d: d in OuterMultiplicities(e`Si) cat EdgeMultiplicities(e`Si) | d ne e`mi ]);
  end if;  
  if Oj cmpeq "default" then
    Oj:=SortMultiplicities(e`mj,[ d: d in OuterMultiplicities(e`Sj) cat EdgeMultiplicities(e`Sj) | d ne e`mj ]);
  end if;  

  vprintf redlib,3: "Decorations %o Oi=%o Oj=%o\n",e,DelSpaces(Oi),DelSpaces(Oj);

  loop:=Class(e) eq cLoop;
   
  printsub:=(forcesubs or                           // print subscript unless minimal chain length
    e`depthstr ne Sprint(MinimalDepth(e`mi,e`di,e`mj,e`dj))) and (e`depthstr ne "");     

  subs:=printsub select [e`depthstr] else [];      //   or if forced by forcesubs
  if loop and not printsub then 
    printsub:=true; subs:=["x"];
  end if;

  dimin,djmin:=DefaultMultiplicities(e`mi,Oi,e`mj,Oj,loop);    // print superscripts until default multiplicities
  
  if e`di eq dimin and e`dj eq djmin and not forcesups then    // Case 1: minimal possible multiplicities on both sides 
    sym:="-"; sups:=[Z|];                                      //   -> print - with no superscripts
    // Executive decision to remove '=' from notation
    //  elif e`di eq e`mi and e`dj eq e`mj and not loop and not forcesups then   // Case 2: print = with no superscripts
    //    sym:="="; sups:=[Z|];  
  else
    sym:="-"; sups:=[e`di,e`dj];                               // Case 3: print - with both superscripts (forced by forcesups)
  end if;  
  
  vprintf redlib,3: "Decorations> min:%o sym:%o sups:%o subs:%o\n",e`di eq dimin and e`dj eq djmin,sym,DelSpaces(sups),DelSpaces(subs);
  return sym,sups,subs;
end function;


/*
Test
e:=Link(3,6,1,6,1: depth:=1);     // edge 6,1 -(1) 6,1  (not min depth)
sym,sups,subs:=Decorations(e: Oi:=[1,2,3], Oj:=[1,2,3]);
assert (sym eq "-") and (sups eq []) and (subs eq ["1"]); 
e:=Link(3,6,1,6,1: depth:=0);     // edge 6,1 -(0) 6,1  (min depth)
sym,sups,subs:=Decorations(e: Oi:=[1,2,3], Oj:=[1,2,3], forcesubs:=false);
assert (sym eq "-") and (sups eq []) and (subs eq []); 
sym,sups,subs:=Decorations(e: Oi:=[1,2,3], Oj:=[1,2,3], forcesups, forcesubs);
assert (sym eq "-") and (sups eq [1,1]) and (subs eq ["0"]); 
e:=Link(1,6,6,6,6: depth:=1);    // loop on 6^1,2,3
sym,sups,subs:=Decorations(e: Oi:=[1,2,3], Oj:=[1,2,3]);
assert (sym eq "-") and (sups eq []) and (subs eq ["1"]);
*/


function PrincipalTypeDecorations(S: forcesubs:=false)

  // for a principal type S returns:
  //   dstr    =  multiple "[d]" or ""
  //   cstr    =  core name without stars or subscripts e.g. "I", "T", "D", "II", "6" etc.
  //   presups =  superscripts belonging to the core, i.e. ["*"] for I0*,In*,II*,... or []
  //   sups    =  superscripts as a sequence of multiplicities ["5","4","3","3"]
  //   presubs =  superscripts belonging to the core, i.e. ["0","g1"] for I0*g1, In*,... or []
  //   subs    =  subscripts from all other loops and D-links
  //   edges   =  edges ["-{2}",...]

  m:=S`m;                        // Principal component multiplicity
  loops:=Loops(S);               // loops
  Dlinks:=DLinks(S);             // D-links

  // dstr =  multiple "[d]" or ""
  d:=GCD(S);
  dstr:=d eq 1 select "" else Sprintf("[%o]",d);          // print [d] if not primitive  

  // initalise superscripts and subscripts to be empty
  presups:=[];
  presubs:=[];
  sups:=[];
  subs:=[];

  // cstr   =  core name without stars e.g. "I", "T", "D", "II", "6" etc.
  cstr:=Label(Core(S));
  if Position(cstr,"*") eq #cstr then     // Move * to presups
    presups:=["*"];
    cstr:=cstr[[1..#cstr-1]];
  end if;
  p:=Position(cstr,"^");                  // 6^1,2,3 -> cstr:="6"; sups:=["1","2","3"];
  if p ne 0 then
    sups:=Split(cstr[[p+1..#cstr]],",");
    cstr:=cstr[[1..p-1]]; 
  end if;
  if cstr eq "I0" then                    // move * from I0* to presubscript
    cstr:="I"; Append(~presubs,"0");
  end if;
  genus:=S`g;                             // genus is the next presubscript
  if genus ne 0 then 
    Append(~presubs,"g"*Sprint(genus)); 
  end if;

  // LOOPS

  OL:=SortMultiplicities(m,[ d: d in OuterMultiplicities(S) cat InnerMultiplicities(S) | d ne m ]);

  if cstr eq "I" and "0" notin presubs and #loops ne 0 then      // I_2,... -> I2,...
    Insert(~presubs,1,DepthString(loops[1]));
    Remove(~loops,1);
  end if;    

  for l in loops do            // loops [[d1,d2,depth],...], sorted
    _,supinds,subinds:=Decorations(l: Oi:=OL, Oj:=OL, forcesubs:=forcesubs);
    OL:=Exclude(Exclude(OL,l`di),l`dj);
    if IsEmpty(supinds) 
      then Append(~subs,DepthString(l));
      else Append(~subs,Sprintf("{%o}%o",PrintSequence(supinds: sep:="-"),PrintSequence(subinds)));
    end if;
  end for;

  // D-LINKS

  if cstr eq "D" and exists(i){i: i in [1..#Dlinks] | Dlinks[i]`di eq m} then     // Replace D_nD by In*
    cstr:="I";
    presups:=["*"];
    D:=Dlinks[i];
    Remove(~Dlinks,i);
    depth:=DepthString(D);
    Insert(~presubs, 1, depth);          // add a depth presubscript at the very beginning (like in In*g1)
  end if;

  for D in Dlinks do        // D-links [[d1(even),depth],...]
    _,_,subinds:=Decorations(D: Oi:=OL, Oj:=[D`dj], forcesubs:=forcesubs);
    multpos:=Position(Append(OL,m),D`di);
    supinds:=exists{i: i in [1..multpos-1] | IsEven(OL[i])} select [D`di] else [];
    Exclude(~OL,D`di);
    if IsEmpty(supinds) 
      then Append(~subs,Sprintf("%oD",PrintSequence(subinds)));
      else Append(~subs,Sprintf("{%o}%oD",PrintSequence(supinds: sep:="-"),PrintSequence(subinds)));
    end if;
  end for;

  presubs:=[s eq "" select "x" else s: s in presubs];        // loop and D-tails must have a subscript
  subs:=[s eq "" select "x" else s: s in subs];

  edges:=[Sprintf("-{%o}",o): o in EdgeMultiplicities(S)];    // edges

  return dstr,cstr,presups,sups,presubs,subs,edges;
  
end function;


function TeXLabelPrincipalType(S: edge:=false, wrap:=false, forcesubs:=false)      // TeX label of a principal type
  // Setting wrap:=true wraps the label in \redtype{...}
  // Setting edge:=true prints outgoing edges as well (standalone principal type).

  dstr,cstr,presups,sups,presubs,subs,edges:=PrincipalTypeDecorations(S: forcesubs:=forcesubs);
  for i->s in subs do
    if s eq "-1" then continue; end if;                          // ignore "-1" subscripts
    ReplaceString(~subs[i],["{","}","-"],["\\{","\\}","\\m"]);   // make {,},- in others \redtype-compatible
  end for;
  substr:=PrintSequence(presubs cat subs: sep:=",");
  substr:=TeXPrintParameter(substr: sym:="_", printempty:=false);   // print subscripts (genus, loops, D-tails)
  supstr:=PrintSequence(presups cat sups: sep:=",");
  supstr:=TeXPrintParameter(supstr: sym:="^", printempty:=false);   // print superscripts ('*' or outer/edge multiplicities)
  if edge then
    edgestr:=PrintSequence(edges: sep:="");
    ReplaceString(~edgestr,"-","\\e");                           // replace - by \e in edges
  else 
    edgestr:="";
  end if;
  out:=Sprintf("%o%o%o%o%o",dstr,cstr,supstr,substr,edgestr);
  if wrap then out:=Sprintf("\\redtype{%o}",out); end if;
  return out;
end function;


function HTMLLabelPrincipalType(S: edge:=false, forcesubs:=false)
  // Setting edge:=true prints outgoing edges as well (standalone principal type).

  dstr,cstr,presups,sups,presubs,subs,edges:=PrincipalTypeDecorations(S: forcesubs:=forcesubs);
  substr:=PrintSequence(presubs cat subs: sep:=",");
  substr:=#substr eq 0 select "" else "<sub>"*substr*"</sub>";     // print subscripts (genus, loops, D-tails)
  supstr:=PrintSequence(presups cat sups: sep:=",");
  supstr:=#supstr eq 0 select "" else "<sup>"*supstr*"</sup>";     // print superscripts ('*' or outer/edge multiplicities)
  ReplaceString(~supstr,"*","&#x204E;");
  if #substr ne 0 and #supstr ne 0 then 
    supstr:="<span class='spb'>"*supstr;
    substr:=substr*"</span>";
  end if;
  if edge 
    then edgestr:=PrintSequence(edges: sep:="");
    else edgestr:="";
  end if;
  out:=Sprintf("%o%o%o%o%o",dstr,cstr,supstr,substr,edgestr);
  return out;
end function;


intrinsic Label(S::RedPrin: tex:=false, html:=false, edge:=false, wrap:=true, forcesubs:=false) -> MonStgElt
{Plain, TeX or HTML label of a principal type. 
Setting tex:=true prints the tex label, in \redtype... format by default, unless wrap:=false. 
Setting html:=true prints the html label. 
Setting edge:=true prints outgoing edges as well (standalone principal type).}

  if html then
    assert not tex; 
    return HTMLLabelPrincipalType(S: edge:=edge, forcesubs:=forcesubs);
  end if;
  if tex then 
    assert not html;
    return TeXLabelPrincipalType(S: edge:=edge, wrap:=wrap, forcesubs:=forcesubs);
  end if;

  dstr,cstr,presups,sups,presubs,subs,edges:=PrincipalTypeDecorations(S: forcesubs:=forcesubs);
  presubstr:=PrintSequence(presubs: sep:="");
  substr:=PrintSequence(subs: sep:=",");
  substr:=TeXPrintParameter(substr: tex:=false, sym:="_", printempty:=false);   // print subscripts (genus, loops, D-tails)
  presupstr:=PrintSequence(presups);
  supstr:=PrintSequence(sups: sep:=",");
  supstr:=TeXPrintParameter(supstr: tex:=false, sym:="^", printempty:=false);   // print superscripts ('*' or outer/edge multiplicities)
  if edge 
    then edgestr:=PrintSequence(edges: sep:="");
    else edgestr:="";
  end if;
  out:=Sprintf("%o%o%o%o%o%o%o",dstr,cstr,presubstr,presupstr,supstr,substr,edgestr);
  return out;
end intrinsic;


/*
Example Labels without and with edges.
// The former are used for printing reduction types 
// (where edges form edges) and the latter are standalone, and define the type uniquely.
DelCRs([Label(S): S in PrincipalTypes(-1)]); //> [Label(S): S in PrincipalTypes(-1)];
DelCRs([Sprint(S): S in PrincipalTypes(-1)]); //> [Sprint(S): S in PrincipalTypes(-1)];
*/


intrinsic Print(S::RedPrin, level::MonStgElt)
{Print a principal type as an ascii label or as an evaluatable Magma string (when level="Magma").}
  if level ne "Magma" then
    printf "%o",Label(S: edge);
    return;
  end if;
  p:=func<L|PrintSequence(L: sep:=",")>;             // print a sequence of strings, comma-separated
  printf "PrincipalType(%o,%o,[%o],[%o],[%o],[%o])",
    Multiplicity(S),GeometricGenus(S),p(OuterMultiplicities(S)),
    p(["["*p([l`di,l`dj,l`depth])*"]": l in Loops(S)]),
    p(["["*p([l`di,l`depth])*"]": l in DLinks(S)]),
    p(EdgeMultiplicities(S));
end intrinsic;


intrinsic TeX(S::RedPrin: length:="35pt", label:=false, standalone:=false) -> MonStgElt
{TeX a principal type as a tikz arc with outer and inner lines, loops and Ds. 
label:=true puts its label underneath
standalone:=true wraps it in \tikz}
  m:=Multiplicity(S);
  g:=GeometricGenus(S);
  outer:=[Sprintf("%o-%o",l`di,l`dj): l in Loops(S)]   // loops
         cat [Sprint(l): l in EdgeMultiplicities(S)]   // edges
         cat ["."*Sprint(l`di): l in DLinks(S)];       // D's
  outer:=PrintSequence(outer: sep:=",");
  inner:=PrintSequence(OuterMultiplicities(S): sep:=",");
  gstr:=g eq 0 select "" else "g"*Sprint(g);
  out:=
    label select Sprintf("\\shapearclabel{%o}{%o}{%o}{%o%o}{%o}",length,outer,inner,m,gstr,Label(S: tex, edge))
            else Sprintf("\\shapearc{%o}{%o}{%o}{%o%o}",length,outer,inner,m,gstr);
  return standalone select Sprintf("\\tikz{\\draw(0,0)%o;}",out) else out;
end intrinsic;



/*
Example TeX
// We define a principal type starting from a core $8^{1,1,2,2,4,6}$, keeping $g=0$, and declaring 
// $\cO=\{2,4\}$ to be outer multiplicities, linking 1,1 one loop of depth 1, using one 2 for a D-link of depth 1,
// and leaving one 6 as a edge multiplicity. 
S:=PrincipalType(8,0,[2,4],[[1,1,1]],[[2,1]],[6]);
TeX(S: standalone)*"\\vspace{-17pt}"; //> TeX(S: standalone);  // how it appears in the tables (wrapped in \tikz{...})
*/



intrinsic TeX(T::SeqEnum[RedPrin]: width:=10, scale:=0.8, sort:=true, label:=false, length:="35pt", yshift:="default") -> MonStgElt
{TeX a list of principal types as a rectangular table in a tikz picture.
  label:=true puts principal type label underneath.
  sort:=true sorts the types by Score first, in decreasing order.
  yshift:="default" changes y by 2 (with label) / 1.2 (without label) after every row
  width:=10 puts 10 principal types in every row
  scale:=0.8 controls tikz picture global scale}
  if sort then
    Sort(~T);
  end if;
  if yshift cmpeq "default" then
    yshift:=label select 2 else 1.2;
  end if;
  out:=[];
  for i->S in T do
    if i mod width ne 0 then dx:=2.5; dy:=0; else dx:=-(width-1)*dx; dy:=-yshift; end if;
    if i eq #T 
      then shift:="";
      else shift:=Sprintf(" ++(%o,%o)",PrintReal(dx),PrintReal(dy));
    end if;
    Append(~out,TeX(S: label:=label, length:=length)*shift);
  end for;
  out:=Sprintf("\\begin{tikzpicture}[scale=%o]\n\\draw(0,0)\n%o;\n\\end{tikzpicture}\n",
    PrintReal(scale),PrintSequence(out: sep:=" "));
  return out;
end intrinsic;


/*
Example TeX table of principal types
list:=PrincipalTypes(-1);                   // All 13 principal types with chi=-1, sorted
TeX(list: label, width:=7, yshift:=2.2);    //    (10 Kodaira + 3 'exotic')
*/


/// Shapes (RedShape)


declare type RedShape;  
declare attributes RedShape: 
  G,       // Underlying undirected graph with vertices labelled by [chi] 
           //   and edges by [weight1,weight2,...] (gcds are sorted)
  V,       // Vertex set of G
  E,       // Edge set of G
  D,       // Double graph: vertex for every vertex of G, and for every edge 
           //   of G except simple edges with weight=[1]. Edges are unlabelled,
           //   and D determines the shape up to isomorphism.
  label;   // Label based on minimum path, determines the shape up to isomorphism.


/*
Manual
A reduction type a graph whose vertices are principal types (type RedPrin) 
and edges are inner chains. They fall naturally into `shapes', where every vertex only remembers the 
Euler characteristic $\chi$ of the type, and edge the gcd of the chain. Thus, the problem
of finding all reduction types in a given genus (see ReductionTypes) reduces to that of finding the possible
shapes (see Shapes) and filling in shape components with given $\chi$ and gcds of edges (see PrincipalTypes).
*/

/*
Example
// Here is how this works in genus 2. The 104 reduction families break into five possible shapes, with all 
// but three types in the first two shape (46 and 55 types, respectively):
L:=Shapes(2);
&cat [TeX(D[1]: shapelabel:=Sprint(D[2])): D in L];
*/


/*
Manual
A shape is represented by a Magma type RedShape with the following invariants:
\begin{verbatim}
declare type RedShape;  
declare attributes RedShape: 
  G,       // Underlying undirected graph with vertices labelled by [chi] 
           //   and edges by [weight1,weight2,...] (gcds are sorted)
  V,       // Vertex set of G
  E,       // Edge set of G
  D,       // Double graph: vertex for every vertex of G, and for every edge 
           //   of G except simple edges with weight=[1]. Edges are unlabelled,
           //   and D determines the shape up to isomorphism.
  label;   // Label based on minimum path, determines the shape up to isomorphism.
\end{verbatim}
*/


/// Printing and TeX


intrinsic IsCoercible(S::RedShape, y::.) -> BoolElt, .  //
{Coerce a shape - internal function, returns false}
  return false, _;
end intrinsic;


intrinsic 'in'(S::RedShape, y::.) -> BoolElt  //
{"in" function for a shape - internal function, returns false}  
  return false;
end intrinsic;


intrinsic Print(S::RedShape, level::MonStgElt)
{Print a shape as Shape(vertices,edges) so that the shape can be reconstructed. Vertices are '-chi' 
of principal types, and edges are of the form [from_vertex,to_vertex,gcd1,gcd2,...] with gcd_i the 
gcd's of the inner chains between principal types}
  printf "Shape(%o,%o)",DelSpaces(VertexLabels(S)),DelSpaces(EdgeLabels(S));
end intrinsic;


/*
Example Printing a shape
Shape(ReductionType("IV-IV-IV"));    // 3 vertices with chi=-1,-2,-1 and 2 edges
Shape(ReductionType("1---1"));       // 2 vertices with chi=-1,-1 and a triple edge
*/

/*
function UniqueShapeCompType(chi,weights)
  L:=PrincipalTypes(chi, weights);
  error if #L ne 1,
    Sprintf("UniqueShapeCompType: Principal with chi=%o weights=%o type is not unique: L = %o",chi,DelSpaces(weights),DelSpaces(L));
  return L[1];
end function;


function FirstShapeCompType(chi,weights)
  L:=Sort(PrincipalTypes(chi, weights));
  return L[1];
end function;


intrinsic TeXShapeVertex(chi::RngIntElt, weights::SeqEnum: complabel:="default") -> MonStgElt    //
{Shape component TeX label, such as 3_(5)^1,1,1 with links as superscripts and number of types as a subscript}
  if Type(complabel) eq UserProgram then
    complabel:=complabel(chi,weights);
  end if;
  error if Type(complabel) ne MonStgElt, "complabel is not 'default' or a string or a function(chi,weights)->string";
  if complabel eq "default" then
    N:=#PrincipalTypes(chi,weights);
    return N eq 1 
      select Label(UniqueShapeCompType(chi,weights): tex, wrap)
      else   Sprintf("%o^{\\scriptscriptstyle %o}_{(%o)}",-chi,PrintSequence(weights: empty:="\\emptyset"),N);
      // else   Sprintf("\{%o\}_{\\scriptscriptstyle %o}^{\\scriptscriptstyle %o}",N,chi,PrintSequence(weights: empty:="\\emptyset"));
  else return complabel; end if;
end intrinsic;
*/

/*
intrinsic TeXShapePlaceVertex(S::RedShape, i::RngIntElt, x::MonStgElt, y::MonStgElt: ref:="") -> MonStgElt    //
{Place shape component vertex label - new version}
  v:=Vertices(S)[i];
  chi:=Chi(S,v);
  weights:=Weights(S,v);
  L:=Sort(PrincipalTypes(chi, weights));
  first:=Label(L[1]: tex, wrap);
  same:=forall{i: i->T in L | i eq 1 or Label(T: tex, wrap) eq first};
  if ref eq "" and not same then
    ref:=Sprintf("^{\\color{blue}%o}",#L);
  end if;
  return Sprintf("\\node[inner sep=2pt] at (%o,%o) (%o) {$%o%o$};",x,y,i,ref,first);
end intrinsic;
*/

/*
intrinsic TeXShapeVertex(S::RedShape, v::GrphVert: complabel:="default") -> MonStgElt   //
{Shape component TeX label, such as 3_(5)^1,1,1 with links as superscripts and number of types as a subscript}
  return TeXShapeVertex(Chi(S,v),Weights(S,v): complabel:=complabel);
end intrinsic;
*/


function ShapeVertexDefaultLabel(chi,weights: ref:="", color:=true)
  L:=Sort(PrincipalTypes(chi, weights));
  first:=Label(L[1]: tex, wrap);
  // same:=forall{i: i->T in L | i eq 1 or Label(T: tex, wrap) eq first};
  blue:=color select "\\color{blue}" else "";
  // count:=same select "" else Sprintf("^{%o%o}",blue,#L);   // Option 1: #L superscript on the left, or(?)
  count:=/*same select "" else*/ Sprintf("^{%o%o}",blue,-chi);    // Option 2: -chi superscript on the left
  out:=Sprintf("$%o%o$",count,first);
  return ref eq "" select out else Sprintf("\\hyperref[%o]{%o}",ref,out);
end function;


intrinsic TeX(S::RedShape: scale:=1.5, center:=false, shapelabel:="", complabel:="default", ref:="default", forceweights:=false, boundingbox:=false) -> MonStgElt, FldReElt, FldReElt, FldReElt, FldReElt
{Tikz picture for a shape S of a reduction graph, or, if boundingbox:=true, returns S,x1,y1,x2,y2, where the last four define the bounding box.}

  PR:=func<x|PrintReal(RealField(2)!x)>;
  if ref cmpeq "default" then ref:=func<chi, weights|"">; end if;
  error if Type(ref) ne UserProgram, "Expected ref to be `default' or a function(chi,weights)->TeX reference";
  if complabel cmpeq "default" then 
    complabel:=func<chi,weights|ShapeVertexDefaultLabel(chi,weights: ref:=ref(chi,weights))>; 
  end if;
  error if Type(complabel) ne UserProgram, "Expected complabel to be `default' or a function(chi,weights)->TeX string";

  // Compute standard coordinates and center 
  x,y:=StandardGraphCoordinates(UnlabelledGraph(S`G));
  cx:=&+x/#x;
  cy:=&+y/#y - 0.1;        // slightly off the center, help tikz/auto with labels of horizontal shapes
  vdist:=Max(y)-Min(y);
  if vdist gt 1.3 then y:=[a*1.3/vdist: a in y]; end if;
  basey:=(Max(y)+Min(y))/2;

  // Output: string of tikz commands
  out:=[];   

  // Place vertices
  for i->v in Vertices(S) do
    label:=complabel(Chi(S,v),Weights(S,v));
    Append(~out,Sprintf("\\node[inner sep=2pt] at (%o,%o) (%o) {%o};",PR(x[i]),PR(y[i]),i,label));
  end for;

  // Place edges
  for e in Edges(S) do
    i1,i2:=SortedEndVertices(e: index);

    if (x[i1]-cx)*(y[i2]-cy) - (y[i1]-cy)*(x[i2]-cx) gt 0 then     // Check clockwise around cx,cy 
      i1,i2 := Explode([i2,i1]);                                   // and swap if necessary, to help tikz->auto
    end if;                                                        // place labels on the outside

    E:=Label(e);                  // gcds of edges between same vertices
    gcdlabel:=E eq [1] and not forceweights select "" else Sprintf("node[gcd] {%o} ",PrintSequence(Sort(E): sep:=","));
    Append(~out,Sprintf("\\draw[thick] (%o) to %o(%o);",i1,gcdlabel,i2));
  end for;

  // baseline and output tikz picture
  baseline:=center select Sprintf("baseline=%o,",PR(basey)) else "";
  labelstr:=shapelabel eq "" select "" else
    Sprintf("\\node at (%o,%o) {%o};\n",PR((Min(x)+Max(x))/2),PR(basey-1),shapelabel);
  x1:=Min(x)-0.3;
  y1:=basey-(shapelabel eq "" select 0 else 1)-0.3;
  x2:=Max(x)+0.3;
  y2:=Max(y)+0.5;
  labelstr*:=Sprintf("\\useasboundingbox (%o,%o) rectangle (%o,%o);\n",PR(x1),PR(y1),PR(x2),PR(y2));
  out:=Sprintf("\\begin{tikzpicture}[scale=%o,%ogcd/.style={auto,scale=0.6}]\n%o\n%o\\end{tikzpicture}",
    PR(scale),baseline,PrintSequence(out: sep:="\n"),labelstr);

  if boundingbox 
    then return out,x1,y1,x2,y2;
    else return out;
  end if;
end intrinsic;



/*
Example Reduction types in a family of curves
// We look at curves $$p^nxy^4=x^2(1\!+\!x)y+pxy(x^4\!+\!x^2y\!+\!y^2)+p^2(1\!+\!x^2\!+\!x^4y^2)$$ for $p=7$ and $n\ge 3$.
_<x,y>:=PolynomialRing(Q,2);
p:=7;
f:=func<n| p^n*x*y^4=x^2*(1+x)*y+p*x*y*(x^4+x^2*y+y^2)+p^2*(1+x^2+x^4*y^2) >;
M:=func<n| Model(f(n),p) >;                 // Model 
R:=func<n| ReductionType(M(n)) >;           //   and Reduction type as a function of n
// The curves are $\Delta_v$-regular and the shape of $\Delta_v$ is unchanged as long as $n>3$, with only the height of one vertex being affected. For $n\le 3$ some of the faces merge:
&cat [DeltaTeX(M(n)): n in [2..5]]; //> [DeltaTeX(M(n)): n in [2..5]];
PrintSequence([TeX(R(n)): n in [2..6]]: sep:="\\qquad"); //> [TeX(R(n)): n in [2..6]];
// For $n>3$ the shape of the reduction type remains the same:
TeX(Shape(R(6)));
*/



/// Construction and isomorphism testing


intrinsic Shape(V::SeqEnum[RngIntElt], E::SeqEnum[SeqEnum[RngIntElt]]) -> RedShape
{Constructs a graph shape from the data V,E as in shapes*.txt data files:
   V = sequence of -chi's for individual components
   E = list of edges v_i->v_j of the form [i,j,edgegcd1,edgegcd2,...]}

  assert V eq [0] or forall{d: d in V | d gt 0};       // >0, unless one vertex with =0
  assert forall{e: e in E | #e ge 3 and Min(e) gt 0};  // edge gcd's>0

  // Create shape graph G, a double graph D and their labels
  n:=#V;
  k:=0;                                          // number of extra vertices #V(D)-#V(G)
  G:=Graph<n|>;                                  //   from edges in E with gcds<>[1]
  D:=Graph<n|>;
  AssignLabels(Vertices(G),[[-v]: v in V]);     // D starts with the same vertices as G
  AssignLabels(Vertices(D),[[-v]: v in V]);

  for e in E do                                  // e=[i,j,gcd1,...]
    i,j:=Explode(e);
    gcds:=Sort(e[[3..#e]]);
    numedges:=#Edges(G);
    error if i eq j, Sprintf("Edge %o-%o is a loop, not allowed in a shape",i,j);
    AddEdge(~G,i,j,gcds);
    error if numedges eq #Edges(G), Sprintf("Already have an edge %o-%o in the shape",i,j);
    if gcds eq [1] then
      AddEdge(~D,i,j);         // unique edge of gcd one - no intermediate vertices
    else   
      k+:=1;
      AddVertex(~D,gcds);      // append a vertex indexed n+k with label gcds
      AddEdge(~D,n+k,i);       // add two (unlabelled) edges connecting it to v_i and v_j
      AddEdge(~D,n+k,j);
    end if;
  end for;

  S:=New(RedShape);             // Create a new RedShape S, fill in values and return
  S`G:=G;
  S`V:=Vertices(G);
  S`E:=Edges(G);
  S`D:=D;

  return S;
end intrinsic;


intrinsic IsIsomorphic(S1::RedShape, S2::RedShape) -> BoolElt
{Check whether two shapes are isomorphic via their double graphs}
  return IsIsomorphic(S1`D,S2`D);
end intrinsic;


/*
Example Shape isomorphism testing
S1:=Shape([1,2,3],[[1,2,3],[2,3,1],[1,3,2]]);  
S2:=Shape([2,3,1],[[1,2,1],[2,3,2],[1,3,3]]);   // rotate the graph
assert IsIsomorphic(S1,S2);
S3:=Shape(VertexLabels(S1),EdgeLabels(S1));     // reconstruct S1 from labels
assert IsIsomorphic(S1,S3);
*/


/// Primary invariants


intrinsic Graph(S::RedShape) -> GrphUnd
{Labelled underlying graph G of the shape}
  return S`G;
end intrinsic;


intrinsic DoubleGraph(S::RedShape) -> GrphUnd
{Vertex-labelled double graph D of the shape, used for isomorphism testing}
  return S`D;
end intrinsic;


intrinsic Vertices(S::RedShape) -> SetIndx
{Vertices of the underlying graph Graph(S), as an indexed set}
  return S`V;
end intrinsic;


intrinsic Edges(S::RedShape) -> SetIndx
{Edges of the underlying graph Graph(S), an an indexed set}
  return S`E;
end intrinsic;


intrinsic '#'(S::RedShape) -> RngIntElt
{Number of vertices in the graph G underlying a shape}
  return #Vertices(S);
end intrinsic;


intrinsic Chi(S::RedShape, v::GrphVert) -> RngIntElt
{Euler characteristic chi(v_i)<=0 of ith vertex of the graph G in a shape S}
  assert v in Vertices(S);
  chi:=Label(v)[1];
  assert chi le 0;
  return chi;
end intrinsic;


intrinsic Weights(S::RedShape, v::GrphVert) -> RngIntElt
{Weights of a vertex v that together with chi determine the vertex type (chi, weights)}
  return Sort(&cat [Label(e): e in IncidentEdges(v)]);
end intrinsic;


intrinsic Chi(S::RedShape) -> RngIntElt
{Total Euler characteristic of a graph shape chi<=0, sum over chi's of vertices}
  chi:=&+[Z| Chi(S,v): v in Vertices(S)];
  assert chi le 0;
  return chi;
end intrinsic;


intrinsic VertexLabels(S::RedShape) -> SeqEnum
{Sequence of -chi's for individual components of the shape S so that S=Shape(VertexLabels(S),EdgeLabels(S))}
  return [-Chi(S,v): v in Vertices(S)];
end intrinsic;


intrinsic EdgeLabels(S::RedShape) -> SeqEnum
{List of edges v_i->v_j of the form [i,j,edgegcd] so that S=Shape(VertexLabels(S),EdgeLabels(S))}
  E:=[];
  for e in Edges(S) do
    v1,v2:=SortedEndVertices(e: index);
    Append(~E,[v1,v2] cat Label(e));
  end for;
  return E;
end intrinsic;


function EdgeLeadsTo(e,v)
  V:=EndVertices(e);
  return v in V select Representative(V diff {v}) else false;
end function;



/*
Example Graph, DoubleGraph and primary invariants for shapes
// Under the hood of shapes of reduction types are their labelled graphs and associated `double' graphs. 
// As an example, take the following reduction type:
R:=ReductionType("Ig2--IV=IV-Ig1-c1");   
TeX(R);
// There are four principal types, and they become vertices of Shape(R) whose labels are their Euler characteristics
// $-5, -2, -4, -5$. The edges are labelled with GCDs of the inner chain between the types.
// For example:\par
// \begin{tabular}{@{\qquad}l}
// --- the inner chain Ig2-Ig1 of gcd 1 becomes the label ``1'', \cr
// --- the inner chain IV=IV of gcd 3 becomes ``3'',\cr
// --- the two chains Ig2--IV of gcd 1 become ``1,1''\cr
// \end{tabular}\par
// on the corresponding edges. 
S:=Shape(R); S;
TeXGraph(Graph(S): scale:=1);
Vertices(S);          // Indexed set of vertices of Graph(S)
Edges(S);             //   and edges {@ {from_vertex, to_vertex}, ... @}
DelSpaces(VertexLabels(S)); //> VertexLabels(S);      // [-chi] for each type
DelSpaces(EdgeLabels(S)); //> EdgeLabels(S);        // [ [from_vertex, to_vertex, gcd1, gcd2, ...], ...]
// Both Magma's IsIsomorphic for graphs and MinimumScorePaths are implemented for graphs with labelled vertices
// but not edges. To use them for shapes, the underlying graphs are converted to graphs with only labelled
// vertices. This is done simply by introducing a new vertex on every edge which carries the corresponding edge 
// label. For compactness, if the label is ``1'' (most common case), we don't introduce the vertex at all.
// This is called the double graph of the shape:
blue:="circle,scale=0.7,inner sep=2pt,fill=blue!20";      // former vertices
red:="circle,draw,scale=0.5,inner sep=2pt, fill=red!20";  // former edges
bluered:=func<v|&+Label(v) le 0 select blue else red>;

TeXGraph(DoubleGraph(S): scale:=1, vertexnodestyle:=bluered);
// These are used in isomorphism testing for shapes, and to construct minimal paths.
// % Label(DoubleGraph(S));
*/


intrinsic ScoreIsSmaller(new::SeqEnum, best::SeqEnum) -> MonStgElt
{Compares two sequences of integers, and returns "<", ">", "l", "s", "=":
  <=smaller   : new has smaller score than best
  >=greater   : new has greater score
  l=longer    : new and best coincide until #best, and new is longer
  s=shorter   : new and best coincide until #new,  and new is shorter
  ==identical : new=best}
  for i:=1 to Min(#new,#best) do
    if new[i] lt best[i] then return "<"; end if;
    if new[i] gt best[i] then return ">"; end if;
  end for;
  if #new eq #best then return "="; end if;
  return (#new gt #best select "l" else "s");
end intrinsic;


/*
Test ScoreIsSmaller
assert ScoreIsSmaller([1, 2, 3], [4, 5, 6]) eq "<"; // Test 1: New is smaller
assert ScoreIsSmaller([5, 6, 7], [1, 2, 3]) eq ">"; // Test 2: New is greater
assert ScoreIsSmaller([3, 4, 5], [3, 4, 5]) eq "="; // Test 3: Identical sequences
assert ScoreIsSmaller([2, 3], [2, 3, 4]) eq "s";    // Test 4: New is shorter but identical start
assert ScoreIsSmaller([1, 2, 3, 4], [1, 2, 3]) eq "l"; // Test 5: New is longer but identical start
assert ScoreIsSmaller([2, 1, 5], [2, 3, 4]) eq "<"; // Test 6: New has smaller value earlier
assert ScoreIsSmaller([7, 8, 1], [7, 5, 9]) eq ">"; // Test 7: New has greater value earlier
assert ScoreIsSmaller([2, 3, 4, 5], [3, 4, 5]) eq "<"; // Test 8: New is longer and starts smaller
assert ScoreIsSmaller([4, 5], [3, 4, 5]) eq ">";    // Test 9: New is shorter but starts greater
assert ScoreIsSmaller([3, 4], [3, 4, 2]) eq "s";    // Test 10: Identical start but new is shorter
*/



intrinsic MinimumScorePaths(D::GrphUnd) -> SeqEnum, SeqEnum
{Minimum score paths for a labelled undirected graph (e.g. double graph underlying shape)
returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism) 
  and I=list of possible vertex index sequences
For example for a rectangular loop G with all vertex chis=-1 and edges as follows
  V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  
the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is 
  W = [<0,[-1],false>,<0,[-1],false>,<0,[-1],false>,<0,[1,1],false>,<0,[-1],false>,
       <0,[2],false>,<1,[-1],true>]
The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded
  T = [[3,2,1,6,4,5,3]]}

  // implemented for connected graphs with (possibly) labelled vertices and unlabelled edges
  error if not IsConnected(D),
    "MinimumScorePaths requires the graph to be connected";
  error if IsLabelled(EdgeSet(D)),               
    "MinimumScorePaths is implemented for unlabelled edges";

  V:=Vertices(D);                                // V vertices, E edges 
  E:=Edges(D);
  vprint redlib,3: "Edges:",DelSpaces([e: e in E]); 

  unlabelled:=not IsLabelled(VertexSet(D));      // if unlabelled:
  if unlabelled then                             //   assign empty labels
    AssignLabels(V,["": v in V]);
    W,T:=MinimumScorePaths(D);                  //   compute paths
    DeleteLabels(VertexSet(D));                  //   remove labels
    return W,T;                                  //   and return
  end if;

  O:={V| v: v in V | IsOdd(Degree(v))};      // odd degree vertices - possible starting points
  start:=IsEmpty(O) select V else Set(O);    //   unless there are none, in which case every vertex is

  // restrict to those with -chi minimal, in particular true vertices in case of reduction types
  // (relevant when every vertex has even degree)
  min:=Min(Labels([v: v in start]));
  start:=[v: v in start | Label(v) eq min];   

  // score is a sequence [<index, label, jump>,...]  (which, when finished, determines S up to isomorphism)
  //   index  = first time vertex v appears in the path, numbered from 1
  //   label  = label of the vertex v in the path (=-chi(component) for reduction types)
  //   jump   = false if we are doing an edge from v to the next vertex, true if we are out of edges
  // path = <indices, edgesleft, odd, score, v>
  //   indices   = where each vertex in V first appears in the path, -1 if not yet
  //   edgesleft = set of edges indices in 1..#E not done yet, in sets of connected components
  //   odd       = vertices of odd degree with respect to edgesleft
  //   score    = score of the current path, as above
  //   v         = last vertex in the path
  // P = sequence of current paths

  P:=[];  
  for v in start do
    label:=Label(v);
    jump:=#V eq 1;
    index:=1;
    indices:=[w eq v select 1 else 0: w in V];
    edgesleft:={{e: e in E}};        // all edges in one connected component
    score:=[<0,label,jump>];
    Append(~P,<indices,edgesleft,O,score,v>);
  end for;

  vprintf redlib,3: "Starting paths %o\n",DelSpaces(P);

  bestscore:=score;
  bestindices:=[indices];
  counter:=0;
  repeat
    counter+:=1;
    p:=P[1];      // process the next path, P is a queue
    Remove(~P,1);
    indices,edgesleft,odd,score,v:=Explode(p);
    vprintf redlib,3: "%o Processing ind=%o elft=%o odd=%o wt=%o v=%o(%o) [bestwt=%o]\n",
      counter,DelSpaces(indices),DelSpaces(edgesleft),DelSpaces(odd),DelSpaces(score),v,Label(v),DelSpaces(bestscore);
    if ScoreIsSmaller(score,bestscore) eq ">" then continue; end if;   // abandon path
    index,label,jump:=Explode(Last(score));
    //"indices",DelSpaces(indices),"edgesleft",DelSpaces(edgesleft),"odd",DelSpaces(odd),"score",DelSpaces(score),"v",DelSpaces(v);
    if not jump then                               // Vnext = possible next vertices (out of v)
      Vnext:=[]; 
      for component in edgesleft do
      for e in component do
        w:=EdgeLeadsTo(e,v);
        if w cmpeq false then continue; end if;    // look at edges v->w from v
        vprintf redlib,3: "Trying edge %o->%o\n",v,w;
        newodd:=odd sdiff {v,w};                   // apply symmetric difference to compute new odd degree vertices
        D0:=sub<D|Exclude(component,e)>;
        C:=[{V!a: a in c}: c in ConnectedComponents(D0) | #c gt 1];              // found connected component 
        vprint redlib,3: "C =",DelSpaces(C);
        if exists{c: c in C | Index(w) notin c and IsEmpty(c meet newodd)} then  // without odd vertices
          vprintf redlib,3: "Trying %o(%o) -> Abandoning\n",w,Label(w); continue;    //   => abandon path
        end if;  
        newedgeleft:={{e2: e2 in component | e2 ne e and EndVertices(e2) subset c}: c in C}
          join Exclude(edgesleft,component);                                     // new set of edges left
        Append(~Vnext,<w,newedgeleft,newodd>);
        vprintf redlib,3: "Trying %o(%o) -> Adding\n",w,Label(w); 
      end for;
      end for;
    else
      Vnext:=[<o,edgesleft,odd>: o in odd];
    end if;

    vprintf redlib,3: "Vnext = %o\n",DelSpaces(Vnext); 

    for data in Vnext do
      newv,newedgesleft,newodd:=Explode(data);
      i:=Index(newv);
      newlabel:=Label(newv);
      newjump:=not exists{e: e in E0, E0 in newedgesleft | newv in EndVertices(e)};
      vprintf redlib,3: "newedgesleft=%o i=%o(%o,%o) -> jump %o\n",DelSpaces(newedgesleft),i,newv,DelSpaces(newlabel),newjump;
      newindices:=indices;
      newindex:=newindices[i];     
      newscore:=Append(score,<newindex,newlabel,newjump>);

      sgn:=ScoreIsSmaller(newscore,bestscore);     // <=smaller, >=greater, l=longer, s=shorter or ==identical

      addindices:=newindices;
      if newindex eq 0 then
        addindices[i]:=#newscore;
      end if;

      error if #newscore gt #bestscore and sgn ne "l",
        Sprintf("MinimumScorePaths internal error: new score is longer than best score but not compatible (sgn=%o)\nnew score  = %o\nbest score=%o",sgn,newscore,bestscore);

      vprintf redlib,3: "newi=%o new=%o best=%o sgn=%o\n",newindex,DelSpaces(newscore),DelSpaces(bestscore),sgn;

      if sgn in ["<","l"] then bestindices:=[addindices]; bestscore:=newscore; 
      elif sgn eq "="     then Append(~bestindices,addindices);
        else continue; 
      end if;

      newp:=<addindices,newedgesleft,newodd,newscore,newv>;
      Append(~P,newp);
    end for;
  until IsEmpty(P);

  // convert assignment indices to paths
  P:=bestscore;
  vprintf redlib,3: "#steps=%o bestscore=%o bestindices=%o\n",counter,DelSpaces(bestscore),DelSpaces(bestindices);
  trails:=[[Position(a, p[1] eq 0 select i else p[1]): i->p in P]: a in bestindices];

  return bestscore, trails;
end intrinsic;


intrinsic Label(G::GrphUnd) -> MonStgElt
{Graph label based on a minimum score path, determines G up to isomorphism}
  P,_:=MinimumScorePaths(G);
  label := "";
  for data in P do
    vindex, vlabel, jump := Explode(data);
    if vlabel cmpeq ""                   // vertices are printed as 
      then vstr:="v";                    //    "v"        (unlabelled case)
      else vstr:=Sprintf("%o",vlabel);   //    "[label]"  (labelled case)
    end if;
    if vindex eq 0 
      then label*:=vstr;                 // new vertex
      else label*:="c"*Sprint(vindex);   // revisited vertex
    end if;
    if jump 
      then label*:="&";                  // jump
      else label*:="-";                  // edge
    end if;
  end for;
  return label[1..#label-1];             // remove last jump symbol
end intrinsic;


intrinsic MinimumScorePaths(S::RedShape) -> SeqEnum, SeqEnum
{Minimum score paths for a shape, computed through its double graph and refers 
to its vertices and edges. 
Returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism) 
  and I=list of possible vertex index sequences
For example for a rectangular loop G with all vertex chis=-1 and edges as follows
  V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  
the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is 
  W = [<0,[-1],false>,<0,[-1],false>,<0,[-1],false>,<0,[1,1],false>,<0,[-1],false>,
       <0,[2],false>,<1,[-1],true>]
The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded
  T = [[3,2,1,6,4,5,3]]}
  return MinimumScorePaths(S`D);
end intrinsic;


/*
Test
G:=Graph<3|{{1,2},{2,3},{1,3}}>;     
P,a:=MinimumScorePaths(G);
assert #P eq 4 and #a eq 6;
assert Label(G) eq "v-v-v-c1";
G:=Graph<3|{{1,2},{2,3},{1,3}}>;     
AssignLabels(Vertices(G),["A","A","A"]);    
P,a:=MinimumScorePaths(G);
assert #P eq 4 and #a eq 6;
assert Label(G) eq "A-A-A-c1";
G:=Graph<3|{{2,1},{2,3}}>;     
P,a:=MinimumScorePaths(G);
assert #P eq 3 and #a eq 2;
assert Label(G) eq "v-v-v";
G:=Graph<3|{{2,1},{2,3}}>;     
AssignLabels(Vertices(G),["A","B","A"]);    
P,a:=MinimumScorePaths(G);
assert #P eq 3 and #a eq 2;
assert Label(G) eq "A-B-A";
*/


/*
Example MinimumScorePaths
G:=Graph<4|{{1,2},{2,3},{3,4},{4,1},{1,3}}>;     // labelled graph on four vertices 
AssignLabels(Vertices(G),["C","B","C","A"]);    // v1(C), v2(B), v3(C), v4(A)
TeXGraph(G);
P,a:=MinimumScorePaths(G);
// All shortest paths start and end in a C vertex (Eulerian path), and the minimal path is C--A--C--B--1--3. Note that C--A--C--1--B--2 is also a valid path, but it is not minimal. By our convention, vertex labels (B) precede used vertex indices (1) in the lexicographic ordering used to define the minimal path.
DelSpaces(P); //> P;       
Label(G);             // Graph label derived from minimal path
// Here is another graph on five vertices, this time not Eulerian:
G:=Graph<5|{{2,1},{2,3},{2,4},{2,5}}>;                 
AssignLabels(Vertices(G),["A","B","A","A","C"]);     
TeXGraph(G);
SetVerbose("redlib",0);
P,a:=MinimumScorePaths(G);         // Minimal path is A-B-A&A-2-C
DelSpaces(P); //> P;       
// There are 6 ways to trace this path, and they form an Aut($G$)=$S_3$-torsor. The first one is
// $$ v_1\mapsto v_2\mapsto v_3\mapsto v_4\mapsto v_2\mapsto v_5$$ 
DelSpaces(a); //> a;         
GroupName(AutomorphismGroup(G));    
Label(G);             // Graph label derived from minimal path
*/


/*
# Example
SetVerbose("redlib",0);
G:=Graph<3|{{1,2},{2,3},{1,3}}>;     
AssignLabels(Vertices(G),["A","A","A"]);    
P,a:=MinimumScorePaths(G);
P;
a;
*/

/*
# Example
SetVerbose("redlib",2);
G:=Graph<3|{{2,1},{2,3}}>;     
AssignLabels(Vertices(G),["A","B","A"]);    
P,a:=MinimumScorePaths(G);
P;
a;
*/


intrinsic GenerateAllShapesInGenus(genus::RngIntElt: filemask:="data/shapes%o.txt", overwrite:=false) 
{Generate all possible shapes in a given genus and write them to a data file. 
Currently computed for 1<=genus<=6 with numbers 1, 5, 35, 310, 3700, 56253  [growth factors 5,7,9,12,15]}

  outfile:=Sprintf(filemask,genus);
  if not overwrite and ReadTest(outfile) then 
    outfile*" already exists"; return;
  end if;
  
  chi:=2-2*genus;    // total chi
  
  // Assign GS = possible shape components WeightS for a given c<=chi
  GS:=[];
  for c:=1 to -chi do
    _,S:=PrincipalTypes(-c: withweights);
    GS[c]:={Multiset(weights): weights in S};
  end for;
  MaxEdgesChi:=[Max([#gcds: gcds in G]): G in GS];  // looks like 3,4,5,...
  // which means for a vertex of degree d, its chi is >=d-2
  // which means total chi >= sum of degrees - 2*N = 2*#E-2*#V
  // and if #E-#V > chi/2 then we can skip the graph
  
  // double array [chi,i] -> sequence of weights that are possible with i terms and given chi (1<=i<=MaxEdgesChi[chi])
  PossibleGCDs:=[[[S: S in G | #S eq i] : i in [1..MaxEdgesChi[c]]] where G is Set(GS[c]): c in [1..#GS]];
   
  pcount:=0;   // Partition count for printing
  
  shapes:=[Shape([-chi],[])];   // Unique one for N=1
  out:=[Sprintf("// All possible shapes S in genus %o",genus),
        "// generated by redlib/GenerateAllShapesInGenus",
        "// format: V E nums count",
        "//   V = sequence of chi's for individual components",
        "//   E = list of edges v_i->v_j of the form [i,j,gcd1,gcd2,...]",
        "//   nums = sequence of #PrincipalTypes(chi_i,vgcds_i) for i=1..#V that determine reduction types with shape=Shape(V,E)",
        "//   count = #ReductionTypes(S)"
       ];
  total:=#PrincipalTypes(chi,[]);      // first separate entry for closed types
  Append(~out,Sprintf("[%o] [] [%o] %o",-chi,total,total));
  
  for N:=2 to -chi do      // number of components in the shape
  
    PList:=Partitions(-chi,N);    // ways to assign chi's to vertices
    PStabs:=[&meet[Stabiliser(Sym(N),{i: i in [1..N] | P[i] eq j}): j in Set(P)]: P in PList];    // stabiliser of the partition P in Sym(N)
    
    D:=SmallGraphDatabase(N);  
  
    for Gindex:=1 to #D do   
      G:=Graph(D,Gindex);
      if NumberOfEdges(G)-NumberOfVertices(G) gt -chi/2 then continue; end if;  // see above: cannot realise chi
      
      Gname:=DelSpaces(Edges(G));
      
      A,V,E,AP,A2AP:=AutomorphismGroup(G);
      
      for Pindex->P in PList do            // sorted in decreasing order
        pcount+:=1;
        if genus le 4 or pcount mod 500 eq 0 then
          "Graph",Gname;
          "Partition",DelSpaces(P);
        end if;
        PStab:=PStabs[Pindex];
     
        //assert forall{g: g in PStab | PermuteSequence(P,g) eq P};  // debugging
        
        R:=DoubleCosetRepresentatives(Sym(N),A,PStab);  // guess! NEEDS CHECKING
        assert #{PermuteSequence(P,g): g in R} eq #R;   // ways to assign score to graph vertices
        // could also assert that the resulting graphs are non-isomorphic, for debugging
        
        for g in R do
          chi_v:=PermuteSequence(P,g);                  // -chi of vertices
          gcd_v:=[{*Z|*}: v in V];                      // assigned gcds, by vertex
          gcd_e:=[{*Z|*}: e in E];                      // assigned gcds, by edges
          
          numedges:=[#IncidentEdges(v): v in V];
          maxedges:=MaxEdgesChi[chi_v];
        
          procedure go(edgeindex,~numedges,~gcd_v,~gcd_e,~shapes,~locshapes,~out) 
            if edgeindex gt #E then
              nums:=[#PrincipalTypes(-chi_v[i],MultisetToSequence(gcd_v[i])): i in [1..N]];
              if 0 in nums then return; end if;
              shape_V:=chi_v;
              shape_E:=[ [v1,v2] cat MultisetToSequence(gcd_e[i]) where v1,v2 is SortedEndVertices(e: index) : i->e in E ];
              shape:=Shape(shape_V,shape_E);
              if exists{S: S in locshapes | IsIsomorphic(shape,S)} then return; end if;
              total:=ReductionTypes(shape: countonly);
              Append(~out,Sprintf("%o %o %o %o",DelSpaces(shape_V),DelSpaces(shape_E),DelSpaces(nums),total));
              Append(~locshapes,shape);
              Append(~shapes,shape);
              if genus le 3 or #shapes mod 100 eq 0 then
                #shapes,DelSpaces(chi_v),DelSpaces(gcd_v),DelSpaces(gcd_e),DelSpaces(nums);
              end if;
              return;
            end if;
            e:=E[edgeindex];   // next unassigned edge
            v1,v2:=SortedEndVertices(e: index);
            min:=1;
            max:=Min(maxedges[v1]-numedges[v1]+1,maxedges[v2]-numedges[v2]+1);
        
            chi1:=chi_v[v1];
            gcd1:=Multiset(gcd_v[v1]);
            S1:=[S diff gcd1: S in GS[chi1] | gcd1 subset S]; 
            chi2:=chi_v[v2];
            gcd2:=Multiset(gcd_v[v2]);
            S2:=[S diff gcd2: S in GS[chi2] | gcd2 subset S]; 
        
            done:={};
            for g1 in S1, g2 in S2 do
              int:=g1 meet g2;
              if #int lt min then continue; end if;
              for i:=min to Min(max,#int) do
              for U in Multisets(Set(int),i) do
                if not (U subset int) or (U in done) then continue; end if;
                Include(~done,U); 
                saven1:=numedges[v1];
                saven2:=numedges[v2];
                saveg1:=gcd_v[v1];
                saveg2:=gcd_v[v2];
                gcd_e[edgeindex]:=U;
                numedges[v1]+:=#U-1;
                numedges[v2]+:=#U-1;
                gcd_v[v1] join:= U;
                gcd_v[v2] join:= U;
                go(edgeindex+1,~numedges,~gcd_v,~gcd_e,~shapes,~locshapes,~out);
                numedges[v1]:=saven1;
                numedges[v2]:=saven2;
                gcd_v[v1]:=saveg1;
                gcd_v[v2]:=saveg2;
              end for;
              end for;
            end for;  
            
          end procedure;
          
          locshapes:=[];
          go(1,~numedges,~gcd_v,~gcd_e,~shapes,~locshapes,~out);
        end for;
      end for;
    end for;
  end for;
  
  "Found",#shapes,"shapes in total for genus",genus;
  
  writernq(outfile,PrintSequence(out: sep:="\n"));

end intrinsic;


intrinsic Shapes(genus::RngIntElt: filemask:="data/shapes%o.txt") -> SeqEnum[Tup]
{All shapes in a given genus, assuming they were created already by GenerateAllShapesInGenus and numbers computed and stored in the log file}
  error if genus le 0, "Shapes: expected genus >=2";
  error if genus eq 1, "Shapes: infinitely many reduction types in genus 1";
  filename:=Sprintf(filemask,genus);
  ok,S:=ReadTest(filename);
  if not ok then 
    Sprintf("Shape file %o not found: running GenerateAllShapesInGenus(%o)",filename,genus);
    GenerateAllShapesInGenus(genus: filemask:=filemask);
    ok,S:=ReadTest(filename);
    error if not ok, "Failed to generate shapes";
  end if;
  return [<Shape(eval d[1],eval d[2]),eval d[4]> where d is Split(s," "): s in Split(S) | #s ne 0 and s[1] eq "["];
end intrinsic;


/*
Example Shapes
// Here is a table of all genus 2 shapes, with numbers of reduction types for each one:
L:=Shapes(2);
&cat [TeX(D[1]: shapelabel:=Sprint(D[2])): D in L];
// The total is 104, the number of genus 2 reduction types families.
*/


/// Reduction Types (RedType)


/*
Manual
Now we come to reduction types, implemented through the following type RedType:

\medskip

\begin{verbatim}
declare type RedType;
declare attributes RedType:
  C,       // array of principal types of type RedPrin, ordered in label order
           // either one with chi=0 (for g=1) or all with chi<0.
  L,       // all inner chains, sorted as for label, of type SeqEnum[RedChain]
  score,  // score used for comparison and sorting
  shape,   // shape of R of type RedShape
  bestscore,     // e.g. [<0,{*-1*},true>,<0,{*-2*},true>,<0,{*-1*},false>,...
                  // constructed with MinimumScorePaths, used in canonical label
  besttrail;      // e.g. [1,2,3,4,1,3] tracing vertices with repetitions.
\end{verbatim}

\medskip

They can be constructed in a variety of ways:

\begin{tabular}{l@{\quad}l}
\texttt{ReductionType(m,g,O,L)} & Construct from a sequence of components (including all principal\cr
                                &  ones), their multiplicities m, genera g, outgoing multiplicities\cr 
                                & of outer chains O, and inner chains L beween them, e.g.\cr
                                & \texttt{ReductionType([1],[0],[[]],[[1,1,0,0,3]]);} \hfill (Type \redtype{I_3})\cr
\texttt{ReductionTypes(g)}      & All reduction types in genus g. Can restrict to just semistable ones\cr
                                & and/or ask for their count instead of actual the types, e.g.\cr
                                & \texttt{ReductionTypes(2);} \hfill (all 104 genus 2 types)\cr
                                & \texttt{ReductionTypes(2: countonly);} \hfill (only count them)\cr
                                & \texttt{ReductionTypes(2: semistable);} \hfill (7 semistable ones)\cr
\texttt{ReductionType(label)}   & Construct from a canonical label, e.g.\cr
                                & \texttt{ReductionType("I3");}\cr
\texttt{ReductionType(G)}       & Construct from a dual graph, e.g.\cr
                                & \texttt{ReductionType(DualGraph([1],[1],[]));} \hfill (good elliptic curve)\cr
\texttt{ReductionTypes(S)}      & Reduction types with a given shape, e.g.\cr
                                & \texttt{ReductionTypes(Shape([2],[]));} \hfill (46 of the genus 2 types)\cr
\end{tabular}

\medskip

Conversely, from a reduction type we can construct its dual graph (\texttt{DualGraph}) 
and a canonical label {\texttt{Label}), and these functions are also described in this section.
Finally,
there are functions to draw reduction types and their dual graphs in TeX (\texttt{TeX}).
*/


declare type RedType;
declare attributes RedType:
  C,       // array of principal types of type RedPrin, ordered in label order;
           // either one with chi=0 (for g=1) or all with chi<0.
  L,       // all inner chains, sorted as for label, of type SeqEnum[RedChain]
  family,  // true if family (variable depths), false if one reduction type
  score,   // score used for comparison and sorting
  shape,   // shape of R of type RedShape
  bestscore,     // e.g. [<0,{*-1*},true>,<0,{*-2*},true>,<0,{*-1*},false>,.. from MinimumScorePaths
  besttrail;      // e.g. [1,2,3,4,1,3] tracing vertices with repetitions (actual vertex indices in R)


/*
Manual
*/

intrinsic IsCoercible(R::RedType, y::.) -> BoolElt, .    //
{Coerce a reduction type.}
  return false, _;
end intrinsic;


intrinsic 'in'(R::RedType, y::.) -> BoolElt              // 
{"in" function for a reduction type.}
  return false;
end intrinsic;


intrinsic Print(R::RedType, level::MonStgElt)
{Print a reduction type through its Label.}
  printf "%o",Label(R);
end intrinsic;


intrinsic ReductionType(m::SeqEnum[RngIntElt], g::SeqEnum[RngIntElt], O::SeqEnum[SeqEnum], L::SeqEnum[SeqEnum]) -> RedType
{Construct a reduction type from a sequence of components, their invariants, and chains of P1s:
  m = sequence of multiplicities of components c_1,...,c_k
  g = sequence of their geometric genera
  O = outgoing multiplicities of outer chains, one sequence for each component
  L = inner chains, of the form
      [[i,j,di,dj,n],...] - inner chain from c_i to c_j with multiplicities m[i],di,...,dj,m[j], of depth n
      n can be omitted, and chain data [i,j,di,dj] is interpreted as having minimal possible depth.}
  error if #m ne #g or #m ne #O, "Sequences of genera, mulitplicities, and of outer multiplicities must have the same length equal to the number of components";

  error if exists(d){d: d in O | not IsEmpty(d) and Universe(d) ne Z} 
        or exists(d){d: d in L | not IsEmpty(d) and Universe(d) ne Z},
    Sprintf("ReductionType: %o: Expected integers (RngIntElt) as elements",DelSpaces(d));

  // outer chains
  E:=[ [i,0] cat OuterSequence(m[i],o: includem:=false): o in O[i], i in [1..#m] ];      

  // inner chains
  for d in L do 
    error if #d notin [4,5] or d[1] notin [1..#m] or d[2] notin [1..#m],
      Sprintf("ReductionType: %o: Expected link data [i,j,di,dj] or [i,j,di,dj,n]",DelSpaces(d));
    i,j,di,dj:=Explode(d);
    if #d eq 5
      then n:=d[5];
      else n:=MinimalDepth(m[i],di,m[j],dj);
    end if;
    Append(~E,[i,j] cat InnerSequence(m[i],di,m[j],dj,n: includem:=false));
  end for;  

  // construct dual graph and associated reduction type
  G:=DualGraph(m,g,E);
  return ReductionType(G);
end intrinsic;


/*
Test
m:=[1];             // Type I3
g:=[0];
O:=[[Z|]];
L:=[[1,1,0,0,3]];
assert ReductionType(m,g,O,L) eq ReductionType("I3");
m:=[6];             // Type II
g:=[0];
O:=[[1,2,3]];
L:=[];
assert ReductionType(m,g,O,L) eq ReductionType("II");
m:=[6];             // Type II*
g:=[0];
O:=[[5,4,3]];
L:=[];
assert ReductionType(m,g,O,L) eq ReductionType("II*");
m:=[3,3,3];         
g:=[1,2,3];
O:=[[2],[1],[1]];
L:=[[1,2,2,1,1],[2,3,1,1,1],[3,1,1,2,2]];
assert ReductionType(m,g,O,L) eq ReductionType("IVg3-(1)IVg2-(1)IV*g1-(2)c1");
*/


/*
Example Type II*
m:=[6];             // multiplicities of starting components 
g:=[0];             // their geometric genera
O:=[[3,4,5]];       // outgoing multiplicities of outer chains from each of them
L:=[];              // inner chains
R:=ReductionType(m,g,O,L);
Label(R: tex)*"\\qquad"*TeX(DualGraph(R)); //> R, TeX(DualGraph(R));
*/


/*
Example Type I3*
m:=[2,2];            // multiplicities of starting components Gamma_1, Gamma_2
g:=[0,0];            // their geometric genera
O:=[[1,1],[1,1]];    // outgoing multiplicities of outer chains from each of them
L:=[[1,2, 2,2, 3]];  // inner chains [[i,j, di,dj ,optional depth],...]
R:=ReductionType(m,g,O,L);
Label(R: tex)*"\\qquad"*TeX(DualGraph(R)); //> R, TeX(DualGraph(R));
*/


intrinsic ReductionTypes(g::RngIntElt: semistable:=false, countonly:=false, elliptic:=false) -> SeqEnum[RedType]
{All reduction types in genus g<=6 or their count (if countonly:=true; faster). 
semistable:=true restricts to semistable types, elliptic:=true (when g=1) to Kodaira types of elliptic curves.}
  requirege g,1;
  error if g ne 1 and elliptic,
    "ReductionTypes: elliptic:=true setting can only be used in genus 1";
  if g eq 1 then
    if   semistable then types:=["Ig1","I1"];
    elif elliptic   then types:=["Ig1","I1","I0*","I1*","IV","IV*","III","III*","II","II*"];
    else error "Infinitely many reduction types in genus 1. They are of the form [d]K for any d>=1 and one of 10 Kodaira type K (set elliptic:=true)";
    end if;
    return countonly select #types else [ReductionType(s): s in types];
  end if;
  R:=[ReductionTypes(S[1]: semistable:=semistable, countonly:=countonly): S in Shapes(g)];
  return countonly select &+ChangeUniverse(R,Z) else &cat R;
end intrinsic;


/*
Example
DelCRs(ReductionTypes(1: elliptic)); //> ReductionTypes(1: elliptic);                // 10 Kodaira types of elliptic curves
ReductionTypes(2: countonly);               // Genus 2 count
ReductionTypes(3: semistable, countonly);   // Genus 3 semistable count
*/


function LinkOrderings(L,m,gcd)   // given a multiset of links L, select all possible orderings sorted by gcd with m
  assert #L eq #gcd;
  if #Set(L) eq #Set(gcd) then return [SortByFunc([l: l in L],func<a|GCD(a,m)>)]; end if;
  return [&cat [d: d in c]: c in CartesianProduct([PermutationsMultiset({*d: d in L | GCD(d,m) eq g*}): g in SortSet(gcd)])];
end function;


intrinsic ReductionTypes(S::RedShape: countonly:=false, semistable:=false) -> SeqEnum[RedType]
{Sequence of reduction types with a given shape. If countonly=true, only count their number}
  V:=VertexLabels(S);           //   V = sequ ence of chi's for individual components
  E:=EdgeLabels(S);             //   E = list of edges v_i->v_j of the form [i,j,-edgegcd], total number NE
  NE:=&+[Z| #e-2: e in E];      // total number of edges in S 
  weights:=[Weights(S,v): v in Vertices(S)];   //   weights = list of weight multisets for every vertex

  if semistable and exists{weight: weight in weights | not IsEmpty(weight) and Max(weight) ne 1} then     // when semistable=true, need all weight=1
    return countonly select 0 else [];
  end if;

  DG:=Graph<#V + 2*NE|>;        // Construct double graph with two consecutive edges for each edge 
  VA:=[[]: v in V];             // Sequence of vertex label assignments [link index,vertexindex] 
  ei:=0;                        //   for every principal vertex
  for e in E do
    i,j:=Explode(e);
    for gcd in e[[3..#e]] do
      ei+:=1;
      AddEdge(~DG,i,#V+ei);
      AddEdge(~DG,#V+ei,#V+NE+ei);
      AddEdge(~DG,#V+NE+ei,j);
      pi:=Position(weights[i],gcd);
      assert pi ne 0;
      while exists{d: d in VA[i] | d[1] eq pi} do pi+:=1; end while; 
      Append(~VA[i],[pi,#V+ei]);
      pj:=Position(weights[j],gcd);
      assert pj ne 0;
      while exists{d: d in VA[j] | d[1] eq pj} do pj+:=1; end while; 
      Append(~VA[j],[pj,#V+NE+ei]);
    end for;
  end for;
  for i:=1 to #V do
    Sort(~VA[i]);   // sort VA by link index
  end for;

  // Now recode VA so that it is just a sequence of vertex indices 
  // e.g. [[3,4,5],[6,7,8]] mean that three inner multiplicities of V[1] get assigned to vertices 3,4,5, 
  //      and of V[2] to 6,7,8
  VA:=[[d[2]: d in v]: v in VA];

  // C = sets of tuples (one for each i=1..#V) of the form
  //     {<index,links},...}
  // where index is a unique index (in UsedShapeComps) characterising a shape component type, and links are its ordered links

  done:=[];   // <chi,weight> already seen
  C:=[[]: i in [1..#V]]; 
  UsedShapeComps:=[];
  for i:=1 to #V do 
    chi:=-V[i];
    weight:=weights[i];
    p:=Position(done,<chi,weight>);
    if p ne 0 then C[i]:=C[p]; done[i]:=done[p]; continue; end if;
    Append(~done,<chi,weight>);
    A:=PrincipalTypes(chi,weight: semistable:=semistable);
    for c in A do
      Append(~UsedShapeComps,c);
      for links in LinkOrderings(EdgeMultiplicities(c),Multiplicity(c),weight) do
        Append(~C[i],<#UsedShapeComps,links>);
      end for;
    end for;
  end for;

  graphs:=AssociativeArray();               // All double graphs up to isomorphism (<-> reduction types)
  for vdata in CartesianProduct(C) do
    D:=DG;   // copy dual graph
    shapecompindices:=[d[1]: d in vdata];  
    labels:=shapecompindices cat [0: i in [1..2*NE]];     //assert #labels eq #Vertices(D);
    for i->d in vdata do
      links:=d[2];
      for j:=1 to #links do 
        labels[VA[i][j]]:=-links[j];
      end for;
    end for;
    AssignLabels(~D,Vertices(D),labels);
    IncludeAssocIfNotIsomorphic(~graphs,Multiset(shapecompindices),D);
  end for;

  if countonly then return &+[#graphs[k]: k in Keys(graphs)]; end if;

  families:={};
  redtypes:=[];  
  for key in Keys(graphs), D in graphs[key] do     // Construct reduction types from double graphs
    VD:=Vertices(D);
    L:=[Label(v): v in VD];  
    RV:=[Copy(UsedShapeComps[L[i]]: index:=i): i in [1..#V]];  // principal types 
    for k:=1 to NE do     // all other edges 
      e1,e2:=Explode([e: e in IncidentEdges(VD[#V+k])]);
      i1,i2:=SortedEndVertices(e1: index);
      i3,i4:=SortedEndVertices(e2: index);
      i:=Min([i1,i2,i3,i4]);
      e1,e2:=Explode([e: e in IncidentEdges(VD[#V+NE+k])]);
      i1,i2:=SortedEndVertices(e1: index);
      i3,i4:=SortedEndVertices(e2: index);
      j:=Min([i1,i2,i3,i4]);
      di:=-L[#V+k];
      dj:=-L[#V+NE+k];
      MergeEdgeEndpoints(RV[i],di,RV[j],dj);
    end for;
    vprint redlib,2: Sprintf("Trying RV=%o",PrintSequence([Sprint(S,"Magma"): S in RV]));
    R:=ReductionType(RV); 
    label:=Label(R);  
    // Sprintf("Succeeded %o",label);
    error if label in families,"Already have family "*label; 
    Include(~families,label);
    Append(~redtypes,R);
  end for;

  return redtypes;  
end intrinsic;


/*
Example Reduction types with a given shape
// There are 1901 reduction types in genus 3, in 35 different shapes. Here is one of the more `exotic' ones, with
// 6 types in it. It has two vertices with $\chi=-3$ and $\chi=-1$ and two edges between them, with gcd 1 and 2.
S:=Shape([3,1],[[1,2,1,2]]);
TeX(S);
L:=ReductionTypes(S); L;
&cat [TeX(R: scale:=1.5, forcesups): R in L];
*/


/// Arithmetic invariants


intrinsic Chi(R::RedType) -> RngIntElt
{Total Euler characteristic of R}
  return &+[Chi(R!!i): i in [1..#R]]; 
end intrinsic;


intrinsic Genus(R::RedType) -> RngIntElt
{Total genus of R}
  return Z!((2-Chi(R))/2);
end intrinsic;


/*
Example
R:=ReductionType("III=(3)III-{2-2}II-{6-12}18g2^6,12");
Label(R);      // Canonical label
Genus(R);      // Total genus
*/


intrinsic IsFamily(R::RedType) -> BoolElt
{Returns true if R is a reduction family, false if it is a single reduction type.}
  return R`family;
end intrinsic;


intrinsic IsGood(R::RedType) -> BoolElt
{true if comes from a curve wih good reduction}
  return #R eq 1 and Multiplicity(R!!1) eq 1;       // 1 component of multiplicity 1
end intrinsic;


intrinsic IsSemistable(R::RedType) -> BoolElt
{true if comes from a curve with semistable reduction (all (principal) components of an mrnc model have multiplicity 1)}
  return Max(Multiplicities(R)) eq 1;  
end intrinsic;


intrinsic IsSemistableTotallyToric(R::RedType) -> BoolElt
{true if comes from a curve with semistable totally toric reduction (semistable with no positive genus components)}
  return IsSemistable(R) and &+Genera(R) eq 0;
end intrinsic;


intrinsic IsSemistableTotallyAbelian(R::RedType) -> BoolElt
{true if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual graph)}
  return IsSemistable(R) and &+Genera(R) eq Genus(R);
end intrinsic;



/*
Example Semistable reduction types
semi:=ReductionTypes(3: semistable);                 // genus 3, semistable,
ab:=[R: R in semi | IsSemistableTotallyAbelian(R)];  //   totally abelian reduction 
PrintSequence(["\\cbox{$"*TeX(R)*"$}": R in ab]: sep:="\\qquad "); //> [TeX(R): R in ab];
tor:=[R: R in semi | IsSemistableTotallyToric(R)];
#tor;                                                //   totally toric reduction
"\\begin{minipage}[t]{1.0\\textwidth}"*PrintSequence(["\\cbox{$"*TeX(R)*"$}": R in tor]: sep:="\\quad ")*"\\end{minipage}"; //> [TeX(R): R in tor];
// Count semistable reduction types in genus 2,3,4,5
[ReductionTypes(n: semistable, countonly): n in [2..5]];   // OEIS A174224
*/


intrinsic TamagawaNumber(R::RedType) -> RngIntElt
{Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field (in other words, totally split)}
  M:=IntersectionMatrix(DualGraph(R));
  N:=NumberOfColumns(M);
  error if Rank(M) ne N-1, Sprintf("Error in IntersectionMatrix: expected rank=%o to be #columns-1 = %o",Rank(M),N-1);
  tamagawa:=GCD(Minors(M,Rank(M)));
  return tamagawa;
end intrinsic;


/*
Test
assert TamagawaNumber(ReductionType("III")) eq 2;
assert TamagawaNumber(ReductionType("III*")) eq 2;
assert TamagawaNumber(ReductionType("I0*")) eq 4;
assert TamagawaNumber(ReductionType("I1*")) eq 4;
assert TamagawaNumber(ReductionType("I7")) eq 7;
*/


/*
Example Tamagawa numbers for elliptic curves
for R in ReductionTypes(1: elliptic) do Label(R),TamagawaNumber(R); end for;
*/


/// Invariants of individual principal components and chains


intrinsic PrincipalTypes(R::RedType) -> SeqEnum[RedPrin]
{Principal types (vertices) R of the reduction type R}
  return R`C;
end intrinsic;


intrinsic '#'(R::RedType) -> RngIntElt
{Number of principal types; used as an index in Chi, InnerMultiplicities, OuterMultiplicities}
  return #PrincipalTypes(R);
end intrinsic;


intrinsic '!!'(R::RedType, i::RngIntElt) -> RedPrin
{Principal type number i in the reduction type R}
  requirerange i,1,#R`C;
  return R`C[i];
end intrinsic;


intrinsic PrincipalType(R::RedType, i::RngIntElt) -> RedPrin
{Principal type number i in the reduction type R, same as R!!i}
  requirerange i,1,#R`C;
  return R`C[i];
end intrinsic;


intrinsic InnerChains(R::RedType) -> SeqEnum[RedChain]
{Return all the inner chains in R, including loops and D-links, as a sequence SeqEnum[RedChain], sorted as in label}
  return R`L;
end intrinsic;


intrinsic EdgeChains(R::RedType) -> SeqEnum[RedChain]
{Return all the inner chains in R between different principal components, as a sequence SeqEnum[RedChain], sorted as in label}
  return [e: e in InnerChains(R) | Class(e) eq cEdge];
end intrinsic;


intrinsic Multiplicities(R::RedType) -> SeqEnum
{Sequence of multiplicities of principal types}
  return [Multiplicity(S): S in PrincipalTypes(R)];
end intrinsic;


intrinsic Genera(R::RedType) -> SeqEnum
{Sequence of geometric genera of principal types}
  return [GeometricGenus(S): S in PrincipalTypes(R)];
end intrinsic;


intrinsic GCD(R::RedType) -> RngIntElt
{GCD detecting non-primitive types}
  return GCD([GCD(R!!i): i in [1..#R]]);
end intrinsic;


intrinsic Shape(R::RedType) -> RedShape
{The shape of the reduction type R. Every principal type is a vertex that only remembers its Euler characteristic, and every edge only remembers the gcd of the corresponding inner chain}
  return R`shape;
end intrinsic;


/*
Example Principal types and chains
// Take a reduction type that consists of smooth curves of genus 3, 2 and 1, connected
// with two chains of $\P^1$s of depth 2.
R:=ReductionType("Ig3-(2)Ig2-(2)Ig1");
TeX(DualGraph(R));  
// This is how we access the three principal types, their primary invariants, and the chains.
// Both the principal types and the chains are ordered as in the canonical label.
R!!1, R!!2, R!!3;     // individual principal types, same as PrincipalTypes(R) 
Genera(R);            // geometric genus g of each principal type
Multiplicities(R);    // multiplicity m of each principal type
InnerChains(R);        // all chains between them (including loops and D-links)
*/


/// Comparison


intrinsic Score(R::RedType) -> SeqEnum[RngIntElt]
{Score of a reduction type, used for comparison and sorting}
  if assigned R`score then return R`score; end if;
  label:=Label(R: depths:="original");
  R`score:=[#R,#EdgeChains(R)] cat Sort([Weight(e): e in EdgeChains(R)]) cat 
     &cat [Score(R!!i): i in [1..#R]] cat [#label] cat [StringToCode(c): c in Eltseq(label)];
  return R`score;
end intrinsic;


intrinsic 'eq'(R1::RedType, R2::RedType) -> BoolElt
{Compare two reduction types by their score}
  return Score(R1) eq Score(R2);
end intrinsic;


intrinsic 'lt'(R1::RedType, R2::RedType) -> BoolElt
{Compare two reduction types by their score}
  return Score(R1) lt Score(R2);
end intrinsic;


intrinsic 'gt'(R1::RedType, R2::RedType) -> BoolElt
{Compare two reduction types by their score}
  return Score(R1) gt Score(R2);
end intrinsic;


intrinsic 'le'(R1::RedType, R2::RedType) -> BoolElt
{Compare two reduction types by their score}
  return Score(R1) le Score(R2);
end intrinsic;


intrinsic 'ge'(R1::RedType, R2::RedType) -> BoolElt
{Compare two reduction types by their score}
  return Score(R1) ge Score(R2);
end intrinsic;


intrinsic Sort(S::SeqEnum[RedType]) -> SeqEnum[RedType]
{Sort reduction types by their score}
  S:=SortByFunc(S,Score);
  return S;
end intrinsic;


intrinsic Sort(~S::SeqEnum[RedType])
{Sort reduction types by their score}
  SortBy(~S,Score);
end intrinsic;


/*
Example Sorted reduction types in genus 1 and 2
PrintSequence(Sort(ReductionTypes(1: elliptic))); //> Sort(ReductionTypes(1: elliptic));
PrintSequence(Sort(ReductionTypes(2))); //> Sort(ReductionTypes(2));
*/


/// Reduction types, labels, and dual graphs


function ChainParameters(mi,mj,c)
  // Return di,dj,gcd,depth from a inner sequence [mi] cat c cat [mj]
  //   di,dj are normalised mod mi, mj, and taken from principal multiplicities if the chain is empty
  di:=IsEmpty(c) select mj else c[1];       // outgoing multiplicity from P[i]
  di:=di mod mi;
  if di eq 0 then di:=mi; end if;
  dj:=IsEmpty(c) select mi else Last(c);    // outgoing multiplicity from P[j]
  dj:=dj mod mj;
  if dj eq 0 then dj:=mj; end if;
  fullchain:=[mi] cat c cat [mj];
  gcd:=GCD(fullchain);                      // gcd of the chain
  depth:=Count(fullchain,gcd) - 1;          // depth of the chain
  error if depth lt MinimalDepth(mi,di,mj,dj), 
    Sprintf("ChainParameters: Found depth %o < minimal allowed for m1=%o d1=%o m2=%o d2=%o",depth,mi,di,mj,dj);
  return di,dj,gcd,depth;
end function;


intrinsic ReductionType(G::GrphDual: family:=false) -> RedType
{Create a reduction type from a full dual mrnc graph or return false if G does not come from a reduction type of positive genus}

  if IsSingular(G) or #G eq 0 or not IsConnected(G) or not HasIntegralSelfIntersections(G) then return false; end if;
  MakeMRNC(~G);

  P:=PrincipalComponents(G);      // Get principal components (possibly with chi=0 to be absorbed in D-links 
  Ch:=ChainsOfP1s(G);             // and all chains of P1s between them, including loops

  // Extract multiplicities, genera, outer and inner chains for all principal components                                
  m:=[Multiplicity(G,c): c in P];          
  g:=[Genus(G,c): c in P];

  O:=[[d[3][1]: d in Ch | d[1] eq v and d[2] eq ""]: v in P];     // Outer multiplicities, unsorted
  L:=[                                                            // Inner multiplicities (total)
      [Z| d[3][1]: d in Ch | d[1] eq v and d[2] ne "" and not IsEmpty(d[3])] cat    // chains v-w, non-empty
      [Z| Last(d[3]): d in Ch | d[2] eq v and not IsEmpty(d[3])] cat                // chains w-v, non-empty                         
      [Z| m[Position(P,d[2])]: d in Ch | d[1] eq v and d[2] ne "" and IsEmpty(d[3])] cat    // chains v-w, empty
      [Z| m[Position(P,d[1])]: d in Ch | d[2] eq v and IsEmpty(d[3])]              // chains w-v, empty
     : v in P]; 
  Chi:=[Z| CoreChi(m[i],g[i],O[i],L[i]): i in [1..#P]];   

  TotalChi:=&+Chi;
  error if IsOdd(TotalChi), Sprintf("Expected even Chi, got Chi=&+[%o] in ReductionType(GrphDual)",DelSpaces(Chi));
  TotalGenus:=Z!(1-TotalChi/2);

  if TotalGenus eq 0 then return false; end if;
  error if TotalGenus eq 1 and not forall{c: c in Chi | c eq 0},
    "ReductionType(GrphDual): Expected all principal components to have chi=0 in genus 1";

  // Set indices of those that will become components of R
  if TotalGenus eq 1                               // PCInd = Indices of principal components that enter Shape(R)
    then PCInd:=[1];                               //    in genus 1 take any one principal component (unique unless [d]In*)
    else PCInd:=[i: i in [1..#P] | Chi[i] lt 0];   //    in genus>1 take all with chi<0
  end if;

  // Create initial principal types in R
  C:=[NewPrincipalType(m[c],g[c]: index:=i): i->c in PCInd];

  // Add outer chains
  for i->c in PCInd, o in O[c] do
    AddOuterMultiplicity(~C[i],o);
  end for;

  index:=0;                    // Inner chain index to store (to be sorted later)
  for chain in Ch do
    v1,v2,c:=Explode(chain);             // v1-v2, [multiplicities]
    if v2 eq "" then continue; end if;   // outer chains already created
    index+:=1;
    i:=Position(P,v1);
    j:=Position(P,v2);
    assert i ne 0 and j ne 0;
    mi:=m[i];
    mj:=m[j];
    di,dj,gcd,depth:=ChainParameters(mi,mj,c);     
    if family then
      depth:=MinimalDepth(mi,di,mj,dj);
    end if;
    pci:=Position(PCInd,i);
    pcj:=Position(PCInd,j);
    if pci eq pcj then                      
      AddInnerMultiplicitiesAndLoop(~C[pci],di,dj: depth:=depth, index:=index);   // Add loop 
    elif pci eq 0 then
      error if not (mi eq GCD(mj,dj)) and IsEven(mi) and (O[i] eq [mi div 2, mi div 2]),
        Sprintf("ReductionType(GrphDual): Found a D-link with invalid parameters m1=%o d1=%o m2=%o d2=%o depth=%o",mj,dj,mi,di,depth);
      AddInnerMultiplicityAndDLink(~C[pcj],dj: depth:=depth, index:=index);       // Add D-link
    elif pcj eq 0 then
      error if not (mj eq GCD(mi,di)) and IsEven(mj) and (O[j] eq [mj div 2, mj div 2]),
        Sprintf("ReductionType(GrphDual): Found a D-link with invalid parameters m1=%o d1=%o m2=%o d2=%o depth=%o",mi,di,mj,dj,depth);
      AddInnerMultiplicityAndDLink(~C[pci],di: depth:=depth, index:=index);    
    else
      AddInnerMultiplicityAndChain(~C[pci],di,~C[pcj],dj: depth:=depth, index:=index);     // Add inner chain
    end if;
  end for;

  for i:=1 to #C do 
    Finalize(~C[i]);          // Compute cores, gcd, and sort chains
  end for;

  vprint redlib,1: "Indices of principal types:",DelSpaces(PCInd);
  vprint redlib,1: "Principal types:",DelSpaces(C);

  return ReductionType(C: family:=family);
end intrinsic;


intrinsic ReductionFamily(G::GrphDual) -> RedType
{Create a reduction family from a full dual mrnc graph or return false if G does not come from a reduction type of positive genus}
  return ReductionType(G: family);
end intrinsic;


intrinsic ReductionFamily(R::RedType) -> RedType
{Family of types in which R lives}
  if IsFamily(R) then return R; end if;
  return ReductionType(DualGraph(R: family): family);
end intrinsic;


intrinsic ReductionType(F::RedType) -> RedType
{Representative of a family of reduction types of minimal depths}
  error if not IsFamily(F), "ReductionType(F): Expected a family";
  return ReductionType(DualGraph(F));
end intrinsic;


intrinsic ReductionFamily(S::MonStgElt: family:=false) -> RedType
{Construct a reduction type from a string label.}
  return ReductionType(S: family);
end intrinsic;


intrinsic Shape(C::SeqEnum[RedPrin]) -> RedShape, SeqEnum[RedChain]     //
{Construct a shape from a sequence C of principal types, provided all inner chains between them have been created.
As a a second parameter returns the sequence of all inner chains in C, including loops and D-links}

  error if IsEmpty(C), "Shape: Array of principal types cannot be empty";

  SV:=[-Chi(S): S in C];                          // Construct shape: 
  SE:=[];                                         //   vertices SV, decorated with -chi

  E:=&cat [Chains(S: class:=cLoop) cat Chains(S: class:=cD): S in C];
 
  for i:=1 to #C-1 do                             //   edges SE from inner chains of class cEdge
  for j:=i+1 to #C do
    edge:=[i,j];
    for e in Chains(C[i]: class:=cEdge) do
      if e`Sj`index eq C[j]`index then Append(~edge,Weight(e)); Append(~E,e); end if;
    end for;
    if #edge gt 2 then
      Append(~SE,edge);
    end if;
  end for;
  end for;
  shape:=Shape(SV,SE);                
  vprint redlib,1: "Shape",shape;
  return shape, E;
end intrinsic;


function ExtractEdges(E,S1,S2)
  /*
  Given an array E of reduction type edges [[i,mi,di,j,mj,dj,depth,...] (RedChain),...],
  extract those from componet S1 to S2 as [di,dj,depth], sorted in a standard way
  */  
  L:=[e: e in Chains(S1: class:=cEdge) | e`Sj`index eq S2`index];
  return SortByFunc(L,func<e|[e`di,e`dj,e`depth]>);   // sort by di,dj,depth and return
end function;


intrinsic EdgesScore(E::SeqEnum[RedChain], Si::RedPrin, Sj::RedPrin) -> SeqEnum[RngIntElt]   //
{Score associated to edges from ith to jth component specified by a sequence of edges E, used in Label when determining the canonical minimal path}
  return &cat [[e`di,e`dj,e`depth]: e in ExtractEdges(E,Si,Sj)];
end intrinsic;


intrinsic EdgesScore(R::RedType, i::RngIntElt, j::RngIntElt) -> SeqEnum[RngIntElt]      //
{Score associated to edges from ith to jth component of R, used in Label when determining the canonical minimal path}
  return EdgesScore(InnerChains(R),R`C[i],R`C[j]);
end intrinsic;


intrinsic ReductionType(C::SeqEnum[RedPrin]: family:=false) -> RedType                   //
{Construct a reduction type from a sequence C of principal types, provided all links chains between 
them are complete. Computes best path (for label) and initialises all indices}

  for i in [1..#C] do                              // Assign indices
    C[i]`index:=i;
  end for;

  // Consistency checks
  indices:={S`index: S in C};
  error if #indices ne #C, Sprintf("ReductionType(C): repeated principal types in C=%o ind=%o",DelSpaces(C),DelSpaces(indices));
  error if exists(d){<i,c>: c in Chains(S), i->S in C | c`Si`index ne i},
    Sprintf("ReductionType(C): chain c=%o on C[%o]=%o has component index %o<>%o in c`Si",DelCRs(d[2]),d[1],DelCRs(C[d[1]]),d[2]`Si`index,d[1]);

  shape, E:=Shape(C);

  P,T:=MinimumScorePaths(shape);      // Minimum shape path score, and possible trails (Aut(shape) torsor) 
  VW:=[Score(S): S in C];                                  // Vertex scores
  EW:=[[[EdgesScore(E,Si,Sj)]: Si in C]: Sj in C];         // Edge scores

  vprintf redlib,1: "P=%o\nT=%o\nVW=%o\nEW=%o\n",DelSpaces(P),DelSpaces(T),DelSpaces(VW),DelSpaces(EW);

  VO:=PreferenceOrder([1..#VW], func<i|VW[i]>);   
  EO:=PreferenceOrder2(EW,func<x|x>);

  vprintf redlib,2: "VO=%o\n",DelSpaces(VO);
  vprintf redlib,2: "EO=%o\n",DelSpaces(EO);

  prindices:=[i: i->w in P | forall{x: x in w[2] | x le 0}];    // principal vertex indices in double graph
  
  zeroes:=0;
  zerocount:=[];
  for i->d in P do
    if d[1] eq 0 and (i in prindices) then zeroes+:=1; end if;
    Append(~zerocount,zeroes); 
  end for;

  MinW:=P[prindices];   // non-negative labels correspond to actual vertices of R
  MinW:=[<d[1] eq 0 select 0 else zerocount[d[1]],d[2],d[3]>: d in MinW];    // recode non-zero indices to correspond to prindices

  infwt:=Max([Multiplicity(S): S in C])+1;      // dominates all edge scores
  vprintf redlib,2: "prindices=%o zerocount=%o MinW=%o\n",DelSpaces(prindices),DelSpaces(zerocount),DelSpaces(MinW);

  bestscore:=[];
  for fulltrail in T do
    trail:=fulltrail[prindices];
    score:=[];
    for step->i in trail do
      index,_,jump:=Explode(MinW[step]);    // VERTEX SCORE
      if index ne 0 
        then Append(~score,0);             // repeated vertex score (larger than new vertex scores)
        else Append(~score,VO[i]);         // new vertex score
      end if;
      if not jump                           // EDGES SCORE
        then vprintf redlib,2: "i=%o step=%o trail=%o\n",i,step,DelSpaces(trail);
             Append(~score,EO[i,trail[step+1]]);  
        else Append(~score,infwt);
      end if;
      sgn:=ScoreIsSmaller(score,bestscore);   // <=smaller, >=greater, l=longer, s=shorter or ==identical
      if sgn eq ">" then break; end if;   // worse, abandon
      if sgn in ["<","l"] then            // better or longer
        vprint redlib,2: DelSpaces(trail),"->",DelSpaces(score),sgn,DelSpaces(bestscore);
        bestscore:=score;
        besttrail:=trail;
      end if; 
    end for;
  end for;

  vprint redlib,1: "besttrail",DelSpaces(besttrail);
  vprint redlib,1: "bestscore",DelSpaces(bestscore);
  vprintf redlib,1: "Shape(R):\nW =%o\ntr=%o\nwt=%o\n",DelSpaces(P),DelSpaces(besttrail),DelSpaces(bestscore);

  NewC:=[];                 // NewC = reordered list of principal types, following best trail
  NewE:=[];                 // NewE = reordered list of edges

  PermuteC:=[];
  for step->i in besttrail do                     // follow the path, keep track of order of vertices and edges
    index,_,jump:=Explode(MinW[step]);     
    if index eq 0 then                            // new vertex i
      Append(~NewC,C[i]);
      C[i]`index:=i;
      PermuteC[i]:=#NewC;
      NewE cat:= Chains(C[i]: class:=cLoop);
      NewE cat:= Chains(C[i]: class:=cD);
      vprintf redlib,2: "(%o) component %o\n",step,i; 
    end if;        
    if jump then continue; end if;        
    j:=besttrail[step+1];
    vprintf redlib,2: "(%o) edges %o-%o\n",step,i,j; 
    NewE cat:= ExtractEdges(E,C[i],C[j]);
  end for;

  for i in [1..#C] do                              // Change components order
    NewC[i]`index:=i;
  end for;
  for i in [1..#NewE] do                           // Change edges order
    NewE[i]`index:=i;
  end for;
  
  // Sanity checks
  error if #C ne #NewC, 
    Sprintf("Mismatched number of components after reordering: C=%o NewC=%o",DelSpaces(C),DelSpaces(NewC));
  error if #E ne #NewE,
    Sprintf("Mismatched number of edges after reordering: E=%o NewE=%o",DelCRs(E),DelCRs(NewE));   
  vprintf redlib,1: "C=%o -> NewC=%o (permuteC=%o)\n",PrintSequence(C),PrintSequence(NewC),DelSpaces(PermuteC);

  newshape:=Shape(NewC);     

  R:=New(RedType);
  R`C:=NewC;
  R`L:=NewE;
  R`shape:=newshape;
  R`bestscore:=MinW;
  R`besttrail:=PermuteC[besttrail];
  R`family:=family;
  if family 
    then SetFamilyDepths(~R);
    else SetOriginalDepths(~R);
  end if;
  error if R`besttrail[1] ne 1,  
    Sprintf("Expected recoded besttrail in R to start with 1: %o",R`besttrail);
  return R;
  
end intrinsic;


procedure AddInnerChain(~m,~g,~E,e,i,j,family)
  depth:=family select MinimalDepth(e`mi,e`di,e`mj,e`dj) else e`depth;
  L:=InnerSequence(e`mi,e`di,e`mj,e`dj,depth);
  vprintf redlib,2: "inner chain v%o:%o,%o -(%o) v%o:%o,%o -> %o\n",i,e`mi,e`di,depth,j,e`mj,e`dj,DelSpaces(L);
  assert L[1] eq e`mi and L[#L] eq e`mj;
  for k:=1 to #L do
    if   k eq 1 then  prev:=i;                  // start the chain, don't create vertices
    elif k eq #L then Append(~E,[prev,j]);      // finish the chain, don't create vertices
    else                                        // create a new vertex
      Append(~m,L[k]);                          //   of multiplicity L[i] and genus 0
      Append(~g,0);      
      Append(~E,[prev,#m]);                     //   and link it to the previous one
      prev:=#m;
    end if;
  end for;
end procedure;


procedure AddOuterChain(~m,~g,~E,i,mi,di)
  O:=OuterSequence(mi,di);
  vprintf redlib,2: "outer chain v%o:%o,%o -> %o\n",i,mi,di,DelSpaces(O);
  assert O[1] eq mi and O[#O] eq GCD(O);
  for k:=1 to #O do
    if   k eq 1 then  prev:=i;                  // start the chain, don't create vertices
    else                                        // create a new vertex
      Append(~m,O[k]);                          //   of multiplicity O[i] and genus 0
      Append(~g,0);      
      Append(~E,[prev,#m]);                     //   and link it to the previous one
      prev:=#m;
    end if;
  end for;
end procedure;


function VariableChain(e)
  L:=InnerSequence(e`mi,e`di,e`mj,e`dj,2);
  L:=L[[2..#L-1]];

  // How many P1^s are there depending on the (variable) chain length
  shift:=1 - (e`mi eq e`di select 1 else 0) - (e`mj eq e`dj select 1 else 0);
  if e`class eq cLoop and e`mi eq e`di and e`mj eq e`dj then shift:=0; end if;   // drawn as loop
  if   shift eq 0 then shiftstr:="";
  elif shift eq 1 then shiftstr:="\\!+\\!1";
  else                 shiftstr:="\\!-\\!1";
  end if;
  depth:="$"*DepthString(e)*shiftstr*"$";  

  gcd:=Weight(e);
  p:=Position(L,gcd);
  assert p ne 0;
  Lhead:=L[[1..p-1]];
  Ltail:=[d: d in L[[p..#L]] | d ne gcd];
  return [* d: d in Lhead *] cat [* <gcd,depth> *] cat [* d: d in Ltail *];  
end function;


intrinsic Links(C::SeqEnum[RedPrin]) -> SeqEnum[RedChain]    //
{All inner chains between principal types (including loops and D-links)}
  E:=&cat [Loops(S) cat DLinks(S): S in C];       // loops and D-links
  for i:=1 to #C-1 do                             // edge, counted once
  for j:=i+1 to #C do
    for e in Chains(C[i]: class:=cEdge) do
      if e`Sj`index eq C[j]`index then Append(~E,e); end if;
    end for;
  end for;
  end for;
  return E;
end intrinsic;


intrinsic DualGraph(C::SeqEnum[RedPrin]: compnames:="default", family:=false) -> RedType      //
{Construct a dual graph from a sequence C of principal types, with all links initialised.}

  indices:=[S`index: S in C];
  error if indices ne [1..#C], Sprintf("DualGraph(C): indices %o are incomplete for C=%o",DelSpaces(indices),DelSpaces(C));

  m:=[Multiplicity(S): S in C];   // multiplicities and genera of principal types
  g:=[GeometricGenus(S): S in C];          
  GE:=[];                         // initialize edges of the dual graph 

  for i->S in C, d in OuterMultiplicities(S) do      // Start with outer chains from all principal types
    AddOuterChain(~m,~g,~GE,i,Multiplicity(S),d);
  end for;
  
  VarChains:=[];
  for e in Links(C) do                      // Links C[i] -> C[j], and loops & D-links
    i:=Index(e`Si);
    if Class(e) in [cLoop,cEdge] then 
      j:=Index(e`Sj); 
    end if;
    if e`class eq cD then         // D-link -> create target component
      Append(~m,e`mj);            //   and let j = its index
      Append(~g,0);
      j:=#m;                      
      AddOuterChain(~m,~g,~GE,j,e`mj,e`mj div 2);    // Add its outer chains
      AddOuterChain(~m,~g,~GE,j,e`mj,e`mj div 2);
    end if;
    if DepthString(e) ne Sprint(e`depth) and DepthString(e) notin ["","x"] and not family
      then Append(~VarChains,<i,j,VariableChain(e)>);     // Variable length chain (e.g. depthstr="n_1")
      else AddInnerChain(~m,~g,~GE,e,i,j,family);         // Regular inner chain (e.g. depthstr="2") or minimal
    end if;
  end for;

  if compnames cmpeq "default" then
    compnames:="\\Gamma_"; 
  end if;
  if Type(compnames) eq MonStgElt then
    compnames := ["$"*TeXPrintParameter(i: tex, sym:=compnames)*"$": i in [1..#C]] cat  // TeX names of principal components
                 ["": i in [1..#m-#C]];                                                  // no names of others

  end if;  
  
  G:=DualGraph(m,g,GE: comptexnames:=compnames);
  for chain in VarChains do
    i,j,mults:=Explode(chain);
    AddVariableChain(~G,Sprint(i),Sprint(j),mults);
  end for;
  return G;
end intrinsic;


intrinsic DualGraph(R::RedType: compnames:="default", family:="default") -> GrphDual
{Full dual graph from a reduction type, possibly with variable length edges}
  if family cmpeq "default" then family:=IsFamily(R); end if;
  return DualGraph(R`C: compnames:=compnames, family:=family);
end intrinsic;


function HTMLLabel(R: forcesubs:=true, forcesups:=false)
  // HTML Label in subp span for superscripts/subscripts and edg/edd spans for edges

  path:=R`bestscore;
  trail:=R`besttrail;

  out:="";
  for index->p in path do
    n,_,jump:=Explode(p);
    i:=trail[index];
   
    if n eq 0 then          // labels for individual components
      out*:=HTMLLabelPrincipalType(R!!i: forcesubs:=forcesubs, forcesubs:=forcesubs);
    else      // Print principal type when first encountering vertex 
      out*:="c<sub>"*Sprint(n)*"</sub>";   // Else print c_n
    end if;
    if jump then
      out*:=index eq #path select "" else "&";
    else
      j:=trail[index+1];                   // print edges from i to j
      E:=ExtractEdges(InnerChains(R),R!!i,R!!j);
      vprintf redlib,2: "Extracted edges %o-%o: %o\n",i,j,DelSpaces(E);
      edgespace:=false;
      for e in E do
        sym,sups,subs:=Decorations(e: forcesubs:=forcesubs, forcesups:=forcesups);
        edgeclass:=sym eq "-" select "edg" else "edd";                          // class for single (-) / double (=) edge
        if IsEmpty(sups) and IsEmpty(subs) then
          if edgespace then out*:="&thinsp;"; end if;
          out*:=sym eq "-" select "&ndash;" else "=";
          edgespace:=true;
        else
          edgespace:=false;
          out*:=Sprintf("<span class='%o'><sup>%o</sup><sub>%o</sub></span>",
            edgeclass,
            IsEmpty(sups) select "&nbsp;" else PrintSequence(sups: sep:=","),     // superscripts, comma separated
            IsEmpty(subs) select "&nbsp;" else PrintSequence(subs: sep:=",")      // subscripts
          );
        end if;
      end for;        
    end if;
  end for;
  return out;
end function;


function PrintEdge(sym,sups,subs)
  sups:=IsEmpty(sups) select "" else "{"*PrintSequence(sups: sep:="-")*"}";
  subs:=IsEmpty(subs) select "" else "("*Sprint(subs[1])*")";
  return Sprintf("%o%o%o",sym,sups,subs);
end function;


function TeXLabelReductionType(R: forcesubs:=true, forcesups:=false, wrap:=true)
  // TeX label of a reduction type used with the \redtype macro

  path:=R`bestscore;
  trail:=R`besttrail;

  out:="";
  for index->p in path do
    n,_,jump:=Explode(p);
    i:=trail[index];
    if n eq 0 then                                  // labels for individual components when encounter first
      out*:=TeXLabelPrincipalType(R!!i: forcesubs:=forcesubs);
    else 
      out*:="c"*TeXPrintParameter(n: sym:="_");                               // Else print c_n
    end if;
    if jump then
      out*:=index eq #path select "" else "\\&";
    else
      j:=trail[index+1];                   // print edges from i to j
      E:=ExtractEdges(InnerChains(R),R!!i,R!!j);
      vprintf redlib,2: "Extracted edges %o-%o: %o\n",i,j,DelSpaces(E);
      edgespace:=false;
      for e in E do
        sym,sups,subs:=Decorations(e: forcesubs:=forcesubs, forcesups:=forcesups);
        sups:=IsEmpty(sups) select "" else "{"*PrintSequence(sups: sep:="-")*"}";
        subs:=IsEmpty(subs) select "" else "("*subs[1]*")";
        sym:=sym eq "-" select "\\e" else "\\d";
        space:=#sups+#subs eq 0 select " " else "";
        out*:=Sprintf("%o%o%o%o",sym,sups,subs,space);
      end for;        
    end if;
  end for;
  return wrap select "\\redtype{"*out*"}" else out;
end function;


intrinsic Label(R::RedType: tex:=false, html:=false, wrap:=true, forcesubs:=true, forcesups:=false, depths:="default") -> MonStgElt
{Return canonical string label of a reduction type.
     tex:=true       gives a TeX-friendly label (\redtype ...) 
     html:=true      gives a HTML-friendly label (<span...>...</span>) 
     wrap:=false     keeps the format above but removes \redtype wrapping
     forcesubs:=true forces lengths of chains and loops to be always printed (usually in round brackets)
     forcesups:=true forces outgoing chain multiplicities to be always printed (in curly brackets).}

  if depths cmpne "default" then
    orgdepths:=GetDepths(R);
    if depths cmpeq "original" then
      SetOriginalDepths(~R);
    elif depths cmpeq "minimal" then
      SetMinimalDepths(~R);
    elif Type(depths) eq SeqEnum then
      SetDepths(~R,depths);
    else 
      error "depths is neither 'default', 'original', 'minimal' nor a sequence of strings";
    end if;
    label:=Label(R: tex:=tex, wrap:=wrap, html:=html, forcesubs:=forcesubs, forcesups:=forcesups);
    SetDepths(~R,orgdepths);
    return label;
  end if;

  if tex then 
    return TeXLabelReductionType(R: forcesubs:=forcesubs, forcesups:=forcesups, wrap:=wrap); 
  end if;

  if html then 
    return HTMLLabel(R: forcesubs:=forcesubs, forcesups:=forcesups); 
  end if;

  path:=R`bestscore;     // Plain label
  trail:=R`besttrail;

  out:="";
  for index->p in path do
    n,_,jump:=Explode(p);
    i:=trail[index];
    out*:=(n eq 0)        // Print principal type when first encountering vertex 
      select Label(R!!i: forcesubs:=forcesubs) else "c"*TeXPrintParameter(n: tex:=false, texsym:="_");   // Else print c_n
    if jump then
      out*:=index eq #path select "" else "&";
    else
      j:=trail[index+1];                   // print edges from i to j
      E:=ExtractEdges(InnerChains(R),R!!i,R!!j);
      vprintf redlib,2: "Extracted edges %o-%o: %o\n",i,j,DelSpaces(E);
      for e in E do
        sym,sups,subs:=Decorations(e: forcesubs:=forcesubs, forcesups:=forcesups);
        out*:=PrintEdge(sym,sups,subs);
      end for;        
    end if;
  end for;
  return out;      
end intrinsic;


procedure _AddEdge(class,S1,d1,S2,d2,n,family)
  /*  
    class = cLoop, cD or cEdge
    S1, S2 principal types between the edge is to be added
    d1, d2 initial chain multiplicities
    sym = edge symbol (-=)
  */
  vprintf redlib,1: "_AddEdge [%o] S1=%o d1=%o S2=%o d2=%o n=%o\n",class,S1,d1,S2,d2,n;
  
  def1:=d1 cmpeq false;             // d1=d2=false     -> set d1,d2 to minimal edge multiplicities             
  def2:=d2 cmpeq false;
  error if def1 ne def2 and class ne cD,
    Sprintf("_AddEdge: d1=%o d2=%o is not a valid option",d1,d2); 
  if def1 then 
    A1:=OuterMultiplicities(S1) cat EdgeMultiplicities(S1);
    A2:=OuterMultiplicities(S2) cat EdgeMultiplicities(S2);
    d1,d2:=DefaultMultiplicities(S1`m,A1,S2`m,A2,S1`index eq S2`index);  
  end if;

  if family then n:=false; end if;   // Minimal depth in a family
  
  if class eq cLoop then
    AddInnerMultiplicitiesAndLoop(~S1,d1,d2: depth:=n);
  elif class eq cD then
    AddInnerMultiplicityAndDLink(~S1,d1: depth:=n);
  elif class eq cEdge then
    AddInnerMultiplicityAndChain(~S1,d1,~S2,d2: depth:=n);
  else
    error Sprintf("AddEdge: class(%o) should be cLoop=%o, cD=%o or cEdge=%o",class,cLoop,cD,cEdge);
  end if;
  
  Exclude(~S1`O,Last(S1`C)`di);                    // remove d1 from outer multiplicities S1`O
  if class in [cLoop,cEdge] then
    Exclude(~S2`O,Last(S1`C)`dj);                  // remove d2 from outer multiplicities S2`O
  end if;

  vprintf redlib,1: "Added edge %o\n",Last(S1`C);
end procedure;


/*
intrinsic Family(R::RedType: tex:=false, html:=false) -> MonStgElt   //
{Label of the reduction family (no chain depths)}
  return Label(R: depths:="minimal", forcesubs:=false, tex:=tex, html:=html);
end intrinsic;
*/

intrinsic ReductionType(S::MonStgElt: family:=false) -> RedType
{Construct a reduction type from a string label.}

  tComp,         // tComp (1): [* tComp, mult, m, g, sups *] each one "default" if undefined
  tEdge,         // tEdge (2): [* tEdge, sym, mults, len *]
  tLoop,         // tLoop (3): [* tLoop, sym, mults, len *]
  tName,tMult,tInt,tcComp,tGenus,tEdgeSym,tEdgeMult,tEdgeLen,tSup,tUnderline,tAmp,tComma,tOther:=Explode([1..16]);

  ReplaceString(~S,["_-1",",-1"],["_(-1)",",(-1)"]);

  T:=StringSplit(S,[
    <tName,"([IVDT]+[IVDT*0-9]*)">,    // tName: II, III, I0*, T etc.        
    <tMult,"[[]([0-9]+)[]]">,          // tMult: [2]                         
    <tInt,"([0-9]+)">,                 // tInt: 0,1,2,... (non-negative)     
    <tcComp,"c([0-9]+)">,              // tComp: c2                          
    <tGenus,"_?g([0-9]+)">,            // tGenus: g2                         
    <tEdgeSym,"([-=<>])">,             // tEdgeSym: -=<>                     
    <tEdgeMult,"[{]([0-9-]+)[}]">,     // tEdgeMult: {1-2}
    <tEdgeLen,"[(](-?[0-9]+)[)]">,     // tEdgeLen: (2) or (-1) 
    <tSup,"[/^]([0-9,]+)">,            // tSup: ^1,2,3
    <tUnderline,"([_])">,              // tUnderline: symbol _
    <tAmp,"([&])">,                    // tAmp: symbol &
    <tComma,"([,])">,                  // tComma: symbol ,
    <tOther,"(.)">                     // tSym: unmatched character
  ]);

  vprintf redlib, 1: "Initial tokens %o:\n%o\n",S,PrintSequence([DelCRs(t): t in T]: sep:="\n");

  subscript:=false;    // Step 1: Split into tokens belonging to components, edges and loops
  i:=1;
  while i le #T do
    t,s:=Explode(T[i]);                    // t=type, s=data string 
    if t eq tUnderline then subscript:=true; end if;
    if t in [tEdgeSym,tAmp] then subscript:=false; end if;
    case t:           // Process all token and split them into component, edge, loop data (or '&' '_' ',')
      when tName:                                 // component name
        ok,_,B:=Regexp("^I([0-9]+)([*]?)$",s);    // In or In*
        if ok and B[1] ne "0" then
          if B[2] eq "" 
            then T:=T[[1..i-1]] cat [ [*tComp,false,1,false,[]*], [*tLoop,false,false,eval B[1]*] ] cat T[[i+1..#T]];  // In
            else d:=i gt 1 and T[i-1][1] eq tComp and T[i-1][2] cmpne false select T[i-1][2] else 1;   // [d]In*
                 T:=T[[1..i-1]] cat [ [*tComp,false,2,false,[1,1]*], [*tLoop,"D",[2*d],eval B[1]*] ] cat T[[i+1..#T]]; // In*
          end if;        
          i+:=2; 
          subscript:=i le #T and T[i][1] in [tUnderline,tComma,tGenus];
          if subscript and T[i][1] ne tGenus then 
            T[i]:=[*tComma,","*];
            if T[i+1][1] in [tComma,tEdgeSym] then Remove(~T,i); end if; 
          end if;
          if subscript and #T ge i+1 and T[i][1] eq tGenus and T[i+1][1] eq tUnderline then
            T[i+1]:=[*tComma,","*];
          end if;
          continue;
        elif not exists(D){D: D in StandardCoreNames | D[3] eq s} 
          then error("Component name "*s*" not recognised in "*S); 
        end if;
        if subscript 
          then error if s ne "D", "Expected an edge: "*s*" in "*S; 
               T[i]:=[* tLoop, "D", false, false *];
          else T[i]:=[* tComp, false, D[1], false, [d: d in D[2]] *];        // [* tComp, mult, m, g, sups *]
        end if;
      when tMult: T[i]:=[* tComp, eval s, false, false, false *];
      when tGenus: T[i]:=[* tComp, false, false, eval s, false *];
      when tSup: T[i]:=[* tComp, false, false, false, [ eval d: d in Split(s,",") ] *];
      when tInt: if subscript 
          then T[i]:=[* tLoop, false, false, eval s *];            // integer means loop length
          else T[i]:=[* tComp, false, eval s, false, false *];     // integer means component
        end if;
      // edges & loops: tEdge: [* tEdge, sym, mults, len *]
      when tEdgeSym:  T[i]:=[* tEdge, s, false, false *];
      when tEdgeMult: T[i]:=[* subscript select tLoop else tEdge, false, [ eval d: d in Split(s,"-") ], false *];
      when tEdgeLen: T[i]:=[* subscript select tLoop else tEdge, false, false, eval s *];
      when tAmp: ;
      when tcComp: T[i]:=[* tcComp, eval s *];
      when tComma: error if not subscript, "',' not in subscript in "*S*"\nTokens:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");
      when tOther: error "Unexpected symbol "*s*" in "*S;
    end case;
    i+:=1;
  end while;

  vprint redlib, 1: "  Tokens after splitting [*tComp=1,mult,m,g,sups*][*tEdge=2,sym,mults,len*][*tLoop=3,sym,mults,len*]:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");

  for i:=#T-1 to 1 by -1 do    // move genus subscripts left over loops
    if T[i][1] eq tLoop and T[i+1][1] eq tComp and T[i+1][4] cmpne false then
      Swap(~T,i,i+1);
    end if;
  end for;

  vprint redlib, 1: "  Tokens after swapping:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");

  // Group components, edges and loops tokens from adjacent ones of the same type
  for i:=#T to 1 by -1 do
    t:=T[i][1];
    if t in [tComma,tAmp,tUnderline] then continue; end if;
    if (i eq #T) or (t ne T[i+1][1]) then continue; end if;
    if t eq tEdge and T[i+1][2] cmpne false then continue; end if;   // edge symbol must be on the left of other data  
    error if #T[i] ne #T[i+1] or exists(j){j: j in [2..#T[i]] | T[i][j] cmpne false and T[i+1][j] cmpne false},
      "Could not merge data (duplicate information) in "*DelCRs(T[i])*" and "*DelCRs(T[i+1])*" in "*S; 
    T[i]:=[* d cmpeq false select T[i+1][j] else d: j->d in T[i] *];
    Remove(~T,i+1);
  end for;

  vprint redlib, 1: "  Tokens after merging:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");

  // Remove symbols '_' '&' ',' assuming they were placed correctly as we won't need them anymore  
  error if IsEmpty(T) or T[1][1] ne tComp, "Reduction type name must start with a component";
  error if exists{i: i->t in T | (t[1] eq tUnderline) and ((i eq 1) or (T[i-1][1] ne tComp) or
    (i eq #T) or (T[i+1][1] ne tLoop))}, "Symbol _ must separate a component and a loop in "*S; 
  error if exists{i: i->t in T | (t[1] eq tComma) and ((i eq 1) or (T[i-1][1] ne tLoop) or
    (i eq #T) or (T[i+1][1] ne tLoop))}, "Symbol , must separate two loops in "*S; 
  error if exists{i: i->t in T | (t[1] eq tAmp) and ((i eq 1) or (T[i-1][1] notin [tcComp,tComp,tLoop]) or
    (i eq #T) or (T[i+1][1] notin [tcComp,tComp]))}, "Symbol & must separate two components in "*S; 
  T:=[t: t in T | t[1] notin [tUnderline,tComma]];

  vprint redlib, 1: "Collected tokens:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");

  V:=[];     // principal components  

  vprintf redlib, 1: "Have %o main components\n",#[d: d in T | d[1] eq tComp];

  i:=0;
  repeat                                          // PRINCIPAL COMPONENTS, LOOPS AND D-TAILS
    i+:=1;
    if i gt #T then break; end if;
    d:=T[i];
    error if d[1] eq tcComp and d[2] gt #V, "Component c"*Sprint(d[2])*" has not been defined yet";
    if d[1] ne tComp then continue; end if;
    _,gcd,m,g,O:=Explode(d);
    if gcd cmpeq false then gcd:=1; end if;       // default: multiplicity=1
    if m cmpeq false then m:=1; end if;           //          m=1
    if g cmpeq false then g:=0; end if;           //          g=0
    if O cmpeq false then O:=[Z|]; end if;        //          O=[]

    m:=gcd*m;                                     // multiply by gcd
    O:=[Z| gcd*o: o in O];

    S:=NewPrincipalType(m,g: O:=O, index:=#V+1);  // Create new principal type S, add to V
    Append(~V,S); 
    T[i]:=[* tcComp,#V *];                        // replace token by "seen before"

    while (i+1 le #T) and (T[i+1][1] eq tLoop) do     // Process loops and D-tails belonging to this component
      vprintf redlib, 1: "Processing loop/D-tail for c%o at i=%o\n",#V,i;
      _,sym,mult,len:=Explode(T[i+1]);
      if mult cmpeq false then mult:=[]; end if;
      // *** D-tail ***
      if sym cmpeq "D" then                       
        error if (mult cmpne false) and (#mult gt 1), "D-tail in a subscript must have <=1 edge multiplicity";
        error if IsOdd(m), "Component of odd multiplicity "*Sprint(m)*" cannot have a D-tail";
        if IsEmpty(mult) then                     // if not specified, mult is the smallest even multiplicity
          I:=SortMultiplicities(m,[d: d in OuterMultiplicities(S) | IsEven(d)]);
          l:=IsEmpty(I) select m else I[1];
        else
          l:=r eq 0 select m else r where r is mult[1] mod m;
          error if IsOdd(l), "Cannot use odd multiplicity "*Sprint(l)*" to use in a D-tail";
          error if (l notin OuterMultiplicities(S)) and (l ne m), "Have no available multiplicity "*Sprint(l)*" to use in a D-tail";
        end if;
        _AddEdge(cD,S,l,false,false,len,family);          // _AddEdge: add D-link
      else                                                      
        // *** loop ***
        if (mult cmpne false) and (#mult notin [0,2]) then return false, "Loop must have zero or two edge multiplicities"; end if;
        if mult cmpne false and #mult eq 2 
          then d1,d2:=Explode(mult); 
          else d1,d2:=Explode([false,false]);
        end if;
        _AddEdge(cLoop,S,d1,S,d2,len,family);             // _AddEdge: add loop
      end if;
      //vprint redlib, 1: "Before removal:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");
      Remove(~T,i+1);
      //vprint redlib, 1: "After removal:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");
    end while;
  until false;

  vprint redlib, 1: "After processing loops:\n"*PrintSequence([DelCRs(t): t in T]: sep:="\n");

  // EDGES BETWEEN DIFFERENT COMPONENTS

  doneedges:={};
  for i->d in T do        // PRINCIPAL COMPONENTS, LOOPS AND D-TAILS
    if (d[1] ne tcComp) or (i eq #T) then continue; end if;
    error if d[2] notin [1..#V], "Invalid component reference "*Sprint(d[2])*" in "*S;
    error if not exists(j){j: j in [i+1..#T] | T[j][1] eq tcComp}, "Could not find a component terminating the edge in "*S;
    error if j eq i+1, "No edges specified between two components in "*S;
    if j eq i+2 and T[i+1][1] eq tAmp then continue; end if;
    error if not forall(k){k: k in [i+1..j-1] | T[k][1] eq tEdge}, "Unrecognized non-edge tokens between two components in "*S;
    i1:=T[i][2];           // indices in V of the two principal components
    i2:=T[j][2];
    error if {i1,i2} in doneedges, Sprintf("Edges c%o-c%o have already been defined in %o",i1,i2,S);
    error if i1 eq i2, "Loops have to be specified in subscripts, not as edges in "*S;
    Include(~doneedges,{i1,i2});
    for k:=i+1 to j-1 do             // Process edges one by one
      _,sym,mult,len:=Explode(T[k]);
      d1,d2:=Explode([false,false]);
      error if (mult cmpne false) and (sym eq "-") and (#mult ne 2), "Edge - can only have two inner multiplicities in "*Sprint(S);
      error if (mult cmpne false) and (sym eq "="), "Edge = can have no inner multiplicities in "*Sprint(S);
      if mult cmpne false and #mult eq 2 then d1,d2:=Explode(mult); end if;
      _AddEdge(cEdge,V[i1],d1,V[i2],d2,len,family);       // _AddEdge: link edge between different components
    end for;
  end for;

  error if IsEmpty(V), "No principal components in reduction type string "*S;

  for i:=1 to #V do
    Finalize(~V[i]);
  end for;

  vprint redlib, 1: "Done V:",PrintSequence([Label(S): S in V]);

  chi:=[Chi(S): S in V];           // Euler characteristics of provided components
  error if Max(chi) gt 0, "Have a component with chi>0 - not a valid reduction type"; 
  if Max(chi) lt 0 then            // Looks fine as is
    return ReductionType(V: family:=family);
  else                             // May have edge D-links like [2]I_D,D or [2]T_D,D, convert to a dual graph and return
    return ReductionType(DualGraph(V): family:=family);
  end if;
end intrinsic;


/*
Example Plain and TeX labels for reduction types
R:=ReductionType("IIg1_1-(3)III-(4)IV");
Label(R);               // plain text label
R2:=ReductionType(Label(R));
assert R eq R2;         // can be used to reconstruct the type
Label(R: tex);          // print label in TeX, wrap in \redtype{...} macro
Label(R: html);         // print label in HTML, wrap in redtype span
R!!1;                   // first principal type as a standalone type
Label(R!!1);            // first principal type: label in R
Label(R!!1: tex);       // first principal type: TeX label
F:=ReductionFamily(R);  // family (varying depths of chains) 
Label(F);
Label(F: tex);
Label(F: html);
*/

/*
Example Canonical label in detail
// Take a graph $G$ on 4 vertices
G:=Graph<4|{{1,2},{1,3},{1,4}}>;
TeXGraph(G: labels:="none");
// Place a component of multiplicity 1 at the root and \II, \IIIS, \IZS{} at the three leaves. Link each leaf to the root with a chain of multiplicity~1. This gives a reduction type that occurs for genus~3 curves:
R:=ReductionType("1-II&c1-III*&c1-I0*");    // First component is the root, 
TeX(R);                                     //   the other three are leaves
TeX(DualGraph(R));   // Here is the corresponding special fibre
// How is the following canonical label chosen among all possible labels?
R;
// Each principal component is a principal type (as there are no loops or D-links), and its primary invariants are its Euler characteristic $\chi$ and a multiset weight of gcd's of outgoing (edge) inner chains
DelCRs([R!!i: i in [1..#R]]); //> [R!!i: i in [1..#R]]; 
DelCRs([Chi(R!!i): i in [1..#R]]); //> [Chi(R!!i): i in [1..#R]];      // add up to 2-2*genus, so genus=3
DelSpaces([Weight(R!!i): i in [1..#R]]); //> [Weight(R!!i): i in [1..#R]];
// The three leaves have $\chi=-1$, weight=$[1]$ and the root $\chi=-1$, weight=$[1,1,1]$.
DelCRs(PrincipalTypes(-1,[1])); //> PrincipalTypes(-1,[1]);        // 10 such (II-, III-, IV-, ...) drawn $1^1_{(10)}$
DelCRs(PrincipalTypes(-1,[1,1,1])); //> PrincipalTypes(-1,[1,1,1]);    // unique one of this type, drawn as 1
// Together they form a shape graph $S$ as follows:
S:=Shape(R); 
TeX(S: scale:=1);
// The vertices and edges of $S$ are assigned scores. Vertex scores are $\chi$'s, edge scores are weight's
DelSpaces([Label(v): v in Vertices(S)]); //> [Label(v): v in Vertices(S)];
DelSpaces([Label(e): e in Edges(S)]); //> [Label(e): e in Edges(S)];
// Then the shortest path is found using MinimumScorePaths. It is v-v-v\&v-2 (v=new vertex with $\chi=-1$, -=edge, \&=jump). Note that by convention actual edges are preferred to jumps, and going to a new vertex preferred to revisiting an old one. Also vertices with smaller $\chi$ come first, if possible, as they have smaller labels.
// \par\begin{tabular}{llllll}
// v-v-v\&v-2 &$<$& v-v\&v-2-v && (jumps are larger than edge marks)\cr
// v-v-v\&v-2 &$<$& v-v-v\&2-v && (repeated vertex indices are larger than vertex marks)\cr
// \end{tabular}
P,T:=MinimumScorePaths(S);
DelSpaces(P); //> P;      // v-v-v&v-2
// This path can be used to construct the graph, and determines it up to isomorphism. There are $|\Aut S|=6$ ways to trail $S$ in accordance with this path, and as far the shape is concerned, they are completely identical.
DelSpaces(T); //> T;
// This gives six possible labels for our reduction type that all traverse the shape according to path $P$:
t:=[Label(R!!i): i in [1..#R]];   
PrintSequence([Sprintf("%o-%o-%o&%o-c2",t[c[1]],t[c[2]],t[c[3]],t[c[4]]): c in T]: sep:=" "); //> [Sprintf("%o-%o-%o&%o-c2",t[c[1]],t[c[2]],t[c[3]],t[c[4]]): c in T];
// Now we assign scores to vertices and edges that characterise the actual shape components (rather than just their $\chi$) and inner chains (rather than just their weight)
Score(R!!1), Score(R!!2), Score(R!!3), Score(R!!4);
EdgesScore(R,2,1);    // score of the 1-II inner chain
EdgesScore(R,2,3);    // score of the 1-I0* inner chain
EdgesScore(R,2,4);    // score of the 1-III* inner chain
// The component score Score(R!!i) starts with $(\chi,m,-g,...)$ so when all components have the same $\chi$ like in this example, the ones with smaller multiplicity $m$ have smaller score. Because m(II)=6, m(III*)=4, m(I0*)=2, the trails $T[1]$ and $T[2]$ are preferred to the other four. They both start with a component \IZS, then an edge \IZS-1 and a component 1. After that they differ in that $T[1]$ traverses an edge 1-II and $T[2]$ an edge 1-III*. Because the edge score is smaller for $T[1]$, this is the minimal path, and it determines the label for $R$:
R;
*/


/*
Example Labels of individual principal types
R:=ReductionType("II-III-IV");
[Label(R!!i): i in [1..#R]];
*/


intrinsic LabelRegex(R::RedType: magma:=true) -> MonStgElt
{Returns a regular expression that recognises reduction types in the same family as R and captures 
the corresponding edge depths. For example, 
  LabelRegex(ReductionType("Dg1_1"));
returns ^Dg1_([0-9]+)$, which is a regular expression that matches Dg1_n for any n>=0 and returns n 
in the captured group. Flag magma:=true makes the returned regex compatible with Magma's Regexp 
function (which is old V8) but may have brackets around the returned integers. Setting magma:=false
makes it compatible with all recent regex implementations, and only returns pure integers in
captured groups.}
  olddepths:=GetDepths(R);
  SetDepths(~R,func<e|Sprintf("<%o>",e`index)>);  
  varlabel:=Label(R);             // label such as "II*-(<1>)I<2>*" for string replacement

  froms:=["[","]","*","^","y","z"];        // protect regex special characters
  tos  :=["y","z","[*]","[/^]","[[]","[]]"];

  for e in InnerChains(R) do
    i:=Index(e`Si);
    depth:=MinimalDepth(e`mi,e`di,e`mj,e`dj);   // minimal depth
    depthstr:=DepthString(e);                       // "<index>"
    vprintf redlib,2: "R=%o e=%o",R,e;
    optional_in_brackets:=Class(e) eq cEdge;                                       // regular edge
    optional_no_brackets:=Class(e) eq cD and 
        Position(varlabel,Sprintf("I<%o>*",i)) eq 0                                // either D-link not of In* type
      or Class(e) eq cLoop and Position(varlabel,Sprintf("}<%o>",i)) ne 0;         // or loop with {...} specified
    if   depth eq -1 then int:="-?[0-9]+";             // Match integer, possibly negative
    elif depth eq 0  then int:="[0-9]+";               // Match n>=0 
    else                  int:="[1-9][0-9]*";          // Match n>=1
    end if;
    vprintf redlib,2: "e=%o o_inb=%o o_nob=%o int=%o depthstr=%o\n",
      DelSpaces(e),optional_in_brackets,optional_no_brackets,int,depthstr;
    if optional_in_brackets then                 // integer in brackets, omittable
      Append(~froms,"("*depthstr*")");
      if magma 
        then Append(~tos,"([(]"*int*"[)])?");    // Magma does not support ?: in regexp
        else Append(~tos,"(?:[(]("*int*")[)])?");   
      end if;
    elif optional_no_brackets then               // integer without brackets, omittable
      Append(~froms,depthstr);
      Append(~tos,"("*int*")?");    
    else                                         // integer that cannot be omitted
      Append(~froms,depthstr);
      Append(~tos,"("*int*")");             
    end if;
  end for;

  regexp:="^"*ReplaceStringFunc(varlabel,froms,tos)*"$";
  error if Position(regexp,"<") ne 0,
    Sprintf("Something went wrong in LabelRegex for R=%o varlabel=%o -> %o",
      R,varlabel,regexp);

  SetDepths(~R,olddepths);  
  return regexp;
end intrinsic;  


/*
Example
R:=ReductionType("III-II");
re:=LabelRegex(R); re;
// This regex matches III-II or III-(2)II which are in the correct format,  but not II-2III which is not 
ok,_,B:=Regexp(re,"III-II"); ok, B;            // Yes
ok,_,B:=Regexp(re,"III-(2)II"); ok, B;         // Yes
Regexp(re,"III-2II");                          // No
// B contains the captured lengths, possibly in brackets (as above), and [eval b: b in B] gives them as integers. The reason for the brackets is that Magma uses old (V8) regex format that does not support non-capturing groups. Calling
LabelRegex(R: magma:=false);
// returns a newer regex format (supported in python, javascript etc.) that has the same behaviour but just captures integer lengths.
*/


function EdgeBends(N: factor:=1)    // Angles to bends edges depending on their number for Tikz
  if N le 5 
    then bends:=[[],[0],[-30,30],[-60,0,60],[-90,-30,30,90],[-100,-50,0,50,100]][N+1];
    else bends:=[i*240/(N-1)-120: i in [0..N-1]];
  end if;
  return [Round(b/factor): b in bends];
end function;


intrinsic TeX(R::RedType: forcesups:=false, forcesubs:="default", scale:=0.8, xscale:=1, yscale:=1, oneline:=false) -> MonStgElt
{TikZ representation of a reduction type, as a graph with PrincipalTypes (principal components with chi>0) as vertices, and edges for inner chains. 
oneline:=true removes line breaks. 
forcesups:=true and/or forcesubs:=true shows edge decorations (outgoing multiplicities and/or chain depths) even when they are default.}

  if forcesubs cmpeq "default" then
    forcesubs:=not IsFamily(R);
  end if;

  out:="\\begin{tikzpicture}[xscale=1.2,yscale=1.2,
    sup/.style={midway,auto,scale=0.5},  
    sub/.style={sup,swap},
    lrg/.style={scale=0.9,inner sep=0.1em,text depth=0.5ex,text height=1.6ex}]\n";

  RR:=func<x|PrintReal(x: prec:=2)>;   // print coordinates with two digits after ., and no trailing zeroes

  nodestr:=[];      // names of nodes (genus, multiplicity, subscripts, superscripts from principal type label)

  Sh:=R`C;          // principal types and edges between them
  edges:={{Index(e`Si),Index(e`Sj)}: e in InnerChains(R) | Class(e) eq cEdge};
  x,y:=StandardGraphCoordinates(Graph<#Sh|edges>);

  oleft:=[[]: v in Sh]; 

  if #Sh eq 1 then   // one component - no tikz necessary
    return Label(R!!1: tex, wrap, forcesubs:=forcesubs);
  end if;

  for i->S in Sh do            // place nodes for principal types
    out*:=Sprintf("\\node[lrg] at (%o,%o) (%o) {$%o$};\n",RR(scale*xscale*x[i]),RR(scale*yscale*y[i]),
      i,Label(S: tex, wrap, forcesubs:=forcesubs));
  end for;

  for e0 in edges do            // place edges  
    p1,p2:=Explode(SetToSequence(e0));
    dx:=x[p2]-x[p1];
    dy:=y[p2]-y[p1];
    if dx lt 0 or ((Abs(dx) lt Abs(dy)) and (dy lt 0))      // reverse vertices and multiplicities
      then tmp:=p1; p1:=p2; p2:=tmp;
    end if;
    E:=ExtractEdges(R,R!!p1,R!!p2);
    bends:=EdgeBends(#E);

    for i->e in E do  
      options:=[];             // bend multiple edges (add other edge options if necessary)
      if bends[i] ne 0 then Append(~options,Sprintf("bend right=%o",bends[i])); end if;
      sym,supinds,subinds:=Decorations(e: forcesubs:=forcesubs, forcesups:=forcesups);
      supstr:=not IsEmpty(supinds) select Sprintf("node [sup] {%o} ",PrintSequence(supinds: sep:="-")) else "";   
      substr:=not IsEmpty(subinds) select Sprintf("node [sub] {%o} ",subinds[1]) else ""; 
      if sym eq "=" then Append(~options,"double"); end if;     // double distance=1pt
      optstr:=PrintSequence(options: sep:=",", br:="[");     
      s:=Sprintf("\\draw (%o) edge%o %o%o(%o);",p1,optstr,supstr,substr,p2);
      out*:=s*"\n";
    end for;
  end for;

  out*:="\\end{tikzpicture}\n";
  if oneline then  
    ReplaceString(~out,["\n","    ","   ","  "],[" "," "," "," "]);
  end if;
  return out;
end intrinsic;


/*
Example TeX for reduction types
R:=ReductionType("Ig1--I1-I1"); 
Sprintf("\\cbox{%o}\\qquad\\cbox{%o}",TeX(R),TeX(R: forcesups, forcesubs, scale:=1.5)); //> TeX(R), TeX(R: forcesups, forcesubs, scale:=1.5);
*/

/*
// Test
// Star shaped type where best path starts in the middle
C:=[PrincipalType(1,0,[],[[1,1,1]],[],[1]), PrincipalType(1,0,[],[[1,1,1]],[],[1]), PrincipalType(2,0,[1,1,1],[],[],[1]), PrincipalType(1,0,[],[[1,1,1]],[],[1,1,1])];
E:=[ReductionTypeEdge(1,1,1,4,1,1:depth:=1,id:=0),ReductionTypeEdge(2,1,1,4,1,1:depth:=1,id:=0),ReductionTypeEdge(3,2,1,4,1,1:depth:=0,id:=0)];
R:=ReductionType(C, E: edgeonly);
assert Label(R) eq "I1-I0*&I1-c1-I1";
*/

/*
Example Degenerations of two elliptic curves meeting at a point
S:=Shape(ReductionType("Ig1-Ig1"));    // Two elliptic curves meeting at a point (genus 2)
// The corresponding shape is a graph v-v with two vertices with $\chi=-1$ and one edge of gcd 1
TeX(S);
DelCRs(PrincipalTypes(-1,[1])); //> PrincipalTypes(-1,[1]);                 // There are 10 possibilities for such a vertex,
                                       // one for each Kodaira type
ReductionTypes(S: countonly);          // and Binomial(10,2) such types in total
DelCRs(ReductionTypes(S)[[1..10]]); //> ReductionTypes(S)[[1..10]];            // first 10 of these
*/


/*
Test
L:=ReductionTypes(3: semistable);
assert #L eq 42;
complabels:={Label(R!!i): i in [1..#R], R in L};
assert complabels eq {"I1g1", "Ig3", "Ig1", "I", "I1g1_1", "I1g2", "I1_1,1", "Ig2", "I1", "I1_1"};
*/


/// Variable depths for families (in Label and DualGraph)


/*
Manual
Reduction types belong to the same family if they are the same apart except that the depths of chains of $\P^1$s
may differ. This section describes functions to print labels and draw dual graphs of reduction families 
with variable depths.
*/


intrinsic SetDepths(~R::RedType, depth::UserProgram)
{Set depths for DualGraph and Label to be determined by depth function.
  depth has to be of the form
    function depth(e::RedChain) -> integer/string
  to show how the depth in the edge is to be printed
  For example,
    f(e) = e`depth                                [ original as in SetDepths(R,true) ]
    f(e) = MinimalDepth(e`mi,e`di,e`mj,e`dj)  [ minimal  as in SetDepths(R,false) ]
    f(e) = Sprintf("n_%o",e`index)                [ "n_1","n_2",...]}
  // error if not IsFamily(R), "SetDepths only works with reduction families, not individual types";
  for e in InnerChains(R) do 
    SetDepthString(e,depth(e));
  end for;
end intrinsic;


intrinsic SetDepths(~R::RedType, S::SeqEnum)
{Set depths for DualGraph and Label to a sequence, e.g. S=["m","n","2"]}
  error if #S ne #InnerChains(R), Sprintf("#S(=%o) <> no of edges (=%o) for R=%o",#S,#InnerChains(R),R);
  SetDepths(~R,func<e|S[e`index]>);
end intrinsic;


intrinsic SetVariableDepths(~R::RedType)
{Set depths for DualGraph and Label to i->"n_i"}
  SetDepths(~R,func<e|"n_"*TeXPrintParameter(e`index)>);
end intrinsic;


intrinsic SetOriginalDepths(~R::RedType)
{Remove depths set by SetDepths, so that original ones are printed by Label and other functions}
  SetDepths(~R,func<e|e`depth>);
end intrinsic;


intrinsic SetMinimalDepths(~R::RedType)
{Set depths to minimal ones in the family (MinimalDepth = -1,0 or 1) for every edge}
  SetDepths(~R,func<e|MinimalDepth(e`mi,e`di,e`mj,e`dj)>);
end intrinsic;


intrinsic SetFamilyDepths(~R::RedType)
{Set depths to family notation (x for loop depth placeholders, no depths otherwise) for every edge}
  SetDepths(~R,func<e|"">);
end intrinsic;


intrinsic GetDepths(R::RedType) -> SeqEnum
{Return depths (string sequence) set by SetDepths or originals if not changed from defaults}
  // error if not IsFamily(R), "GetDepths only works with reduction families, not individual types";
  return [DepthString(e): e in InnerChains(R)];
end intrinsic;


/*
Example Setting variable depths for drawing families
R:=ReductionType("I3-(2)I5");
Label(R: tex);
TeX(DualGraph(R));
SetDepths(~R,["a","b","5"]);    // Make two of the three chains variable depth
Label(R: tex);
TeX(DualGraph(R));
SetOriginalDepths(~R);
R;
*/


/*
Example $\rm I^*_{1000}$
// This can also be used to draw types with large depths:
R:=ReductionType("I1*");
SetDepths(~R,["1000"]); 
TeX(DualGraph(R));
*/


/// Namikawa-Ueno conversion in genus 2


function BasicNUType(nu)
  if Position(nu,"VIII") eq 0 and Position(nu,"IX") eq 0 then
    D:="0123456789";                     
    t:=ReplaceStringFunc(nu,["-(-1)","--1","-0}","{0","-0-"],["-#","-#","-%}","{%","-%-"]);
    s:=Split(t,D);  // basic type
    s:=PrintSequence(s: sep:="z");
    if t[1] in D then 
      assert t[2] notin D;
      s:=t[1] cat s; 
    end if;
    if Last(t) in D then s*:="z"; end if;
    return ReplaceStringFunc(s,["%","#","z"],["0","(-1)","x"]);
  end if;
  return nu;
end function;


/*
// Populate NUPages array, copied into NUPageData
list,found:=ReadExamples();   // namuenoconvert.m
NUPages:=AssociativeArray();
for d in list do IncludeAssoc(~NUPages,BasicNUType(d[2]),d[3]); end for;                     
error if #Keys(NUPages) lt 85, "Expected >=85 entries in NUPages";
PrintSequence([DelSpaces(<k,NUPages[k]>): k in Keys(NUPages)]: sep:=", ");
// After that sorted, fixed and hand-crafted
*/
  
  
NUPageData:=    // Sorted by hand, but see above
// Missing I$_{x}$-I$^*_{0}$-x = I$^*_{0}$-I$_{x}$-x
[
<"I$_{0-0-0}$", { 155 }>,
<"I$^*_{0-0-0}$", { 155 }>,
<"II", { 155 }>,
<"III", { 155 }>,
<"IV", { 155 }>,
<"V", { 156 }>,
<"V$^*$", { 156 }>,
<"VI", { 156 }>,
<"VII", { 156 }>,
<"VII$^*$", { 156 }>,
<"VIII-1", { 156 }>,
<"VIII-2", { 157 }>,
<"VIII-3", { 157 }>,
<"VIII-4", { 157 }>,
<"IX-1", { 157 }>,
<"IX-2", { 157 }>,
<"IX-3", { 157 }>,
<"IX-4", { 158 }>,
<"I$_{0}$-I$_{0}$-x", { 158 }>,
<"I$^*_{0}$-I$^*_{0}$-x", { 158 }>,
<"I$_{0}$-I$^*_{0}$-x", { 159 }>,
<"2I$_{0}$-x", { 159 }>,
<"2I$^*_{0}$-x", { 159 }>,
<"I$_{0}$-II-x", { 159 }>,
<"I$_{0}$-II$^*$-x", { 160 }>,
<"I$_{0}$-IV-x", { 160 }>,
<"I$_{0}$-IV$^*$-x", { 160 }>,
<"I$^*_{0}$-II-x", { 160 }>,
<"I$^*_{0}$-II$^*$-x", { 160 }>,
<"I$^*_{0}$-II$^*$-(-1)", { 161 }>,
<"I$^*_{0}$-IV-x", { 161 }>,
<"I$^*_{0}$-IV$^*$-x", { 161 }>,
<"I$^*_{0}$-IV$^*$-(-1)", { 161 }>,
<"I$_{0}$-III-x", { 161 }>,
<"I$_{0}$-III$^*$-x", { 162 }>,
<"I$^*_{0}$-III-x", { 162 }>,
<"I$^*_{0}$-III$^*$-x", { 162 }>,
<"I$^*_{0}$-III$^*$-(-1)", { 162 }>,
<"2II-x", { 162 }>,
<"2II$^*$-x", { 163 }>,
<"II-II-x", { 163 }>,
<"II-II$^*$-x", { 163 }>,
<"II$^*$-II$^*$-x", { 163 }>,
<"II$^*$-II$^*$-(-1)", { 163 }>,
<"II-IV-x", { 164 }>,
<"II-IV$^*$-x", { 164 }>,
<"II$^*$-IV-x", { 164 }>,
<"II$^*$-IV-(-1)", { 164 }>,
<"II$^*$-IV$^*$-x", { 164 }>,
<"II$^*$-IV$^*$-(-1)", { 165 }>,
<"2IV-x", { 165 }>,
<"2IV$^*$-x", { 165 }>,
<"IV-IV-x", { 165 }>,
<"IV-IV$^*$-x", { 165 }>,
<"IV$^*$-IV$^*$-x", { 166 }>,
<"IV$^*$-IV$^*$-(-1)", { 166 }>,
<"II-III-x", { 166 }>,
<"II-III$^*$-x", { 166 }>,
<"II$^*$-III-x", { 166 }>,
<"II$^*$-III-(-1)", { 167 }>,
<"II$^*$-III$^*$-x", { 167 }>,
<"II$^*$-III$^*$-(-1)", { 167 }>,
<"III-IV-x", { 167 }>,   // Liu 
<"IV-III-x", { 167 }>,   // NU
<"III$^*$-IV-x", { 167 }>,  // Liu
<"IV-III$^*$-x", { 167 }>,  // NU
<"III$^*$-IV-(-1)", { 167 }>,  // Liu
<"IV-III$^*$-(-1)", { 167 }>,  // NU
<"III-IV$^*$-x", { 168 }>,        // Liu
<"IV$^*$-III-x", { 168 }>,        // NU
<"III$^*$-IV$^*$-x", { 168 }>,    // Liu
<"IV$^*$-III$^*$-x", { 168 }>,    // NU
<"III$^*$-IV$^*$-(-1)", { 168 }>, // Liu
<"IV$^*$-III$^*$-(-1)", { 168 }>, // NU
<"2III-x", { 168 }>,
<"2III$^*$-x", { 168 }>,
<"III-III-x", { 169 }>,
<"III-III$^*$-x", { 169 }>,
<"III$^*$-III$^*$-x", { 169 }>,
<"III$^*$-III$^*$-(-1)", { 169 }>,
<"I$_{x-0-0}$", { 170 }>,
<"I$_{0}$-I$_{x}$-x", { 170 }>,   // Liu
<"I$_{x}$-I$_{0}$-x", { 170 }>,   // NU
<"I$^*_{x}$-I$_{0}$-x", { 170 }>, // Liu
<"I$_{0}$-I$^*_{x}$-x", { 170 }>, // NU
<"I$^*_{0}$-I$_{x}$-x", { 171 }>, // Liu
<"I$_{x}$-I$^*_{0}$-x", { 171 }>, // NU
<"I$^*_{x-0-0}$", { 171 }>,
<"I$^*_{x}$-I$^*_{0}$-x", { 171 }>,  // Liu
<"I$^*_{0}$-I$^*_{x}$-x", { 171 }>,  // NU
<"II$_{x-0}$", { 171 }>,
<"II$^*_{x-0}$", { 172 }>,
<"I$_{x}$-II-x", { 172 }>,   // Liu
<"II-I$_{x}$-x", { 172 }>,   // NU
<"I$_{x}$-II$^*$-x", { 172 }>,   // Liu
<"II$^*$-I$_{x}$-x", { 172 }>,   // NU
<"I$_{x}$-IV-x", { 173 }>,   // Liu
<"IV-I$_{x}$-x", { 173 }>,   // NU
<"I$_{x}$-IV$^*$-x", { 173 }>,   // Liu
<"IV$^*$-I$_{x}$-x", { 173 }>,   // NU
<"I$^*_{x}$-II-x", { 173 }>,   // Liu
<"II-I$^*_{x}$-x", { 173 }>,   // NU
<"I$^*_{x}$-II$^*$-x", { 174 }>,   // Liu
<"II$^*$-I$^*_{x}$-x", { 174 }>,   // NU
<"I$^*_{x}$-II$^*$-(-1)", { 174 }>,   // Liu
<"II$^*$-I$^*_{x}$-(-1)", { 174 }>,   // NU
<"I$^*_{x}$-IV-x", { 174 }>,   // Liu
<"IV-I$^*_{x}$-x", { 174 }>,   // NU
<"I$^*_{x}$-IV$^*$-x", { 174 }>,   // Liu
<"IV$^*$-I$^*_{x}$-x", { 174 }>,   // NU
<"I$^*_{x}$-IV$^*$-(-1)", { 175 }>,   // Liu
<"IV$^*$-I$^*_{x}$-(-1)", { 175 }>,   // NU
<"IV-II$_{x}$", { 175 }>,
<"IV$^*$-II$_{x}$", { 175 }>,
<"II-II$^*_{x}$", { 176 }>,
<"II$^*$-II$^*_{x}$", { 176 }>,
<"I$_{x}$-III-x", { 176 }>,   // Liu
<"III-I$_{x}$-x", { 176 }>,   // NU
<"I$_{x}$-III$^*$-x", { 176 }>,   // Liu
<"III$^*$-I$_{x}$-x", { 176 }>,   // NU
<"I$^*_{x}$-III-x", { 177 }>,   // Liu
<"III-I$^*_{x}$-x", { 177 }>,   // NU
<"I$^*_{x}$-III$^*$-x", { 177 }>,   // Liu
<"III$^*$-I$^*_{x}$-x", { 177 }>,   // NU
<"I$^*_{x}$-III$^*$-(-1)", { 177 }>,   // Liu
<"III$^*$-I$^*_{x}$-(-1)", { 177 }>,   // NU
<"II$_{x}$-III", { 177 }>,   // Liu
<"III-II$_{x}$", { 177 }>,   // NU
<"II$_{x}$-III$^*$", { 178 }>, // Liu
<"III$^*$-II$_{x}$", { 178 }>, // NU
<"II$^*_{x}$-III", { 178 }>,   // Liu
<"III-II$^*_{x}$", { 178 }>,   // NU
<"II$^*_{x}$-III$^*$", { 178 }>,   // Liu
<"III$^*$-II$^*_{x}$", { 178 }>,   // NU
<"I$_{x-x-0}$", { 179 }>,
<"I$_{x}$-I$_{x}$-x", { 179 }>,
<"I$^*_{x-x-0}$", { 180 }>,
<"I$^*_{x}$-I$^*_{x}$-x", { 180 }>,
<"I$_{x}$-I$^*_{x}$-x", { 180 }>,
<"2I$_{x}$-x", { 181 }>,
<"2I$^*_{x}$-x", { 181 }>,
<"II$_{x-x}$", { 182, 183 }>,
<"III$_{x}$", { 182, 184 }>,
<"I$_{x-x-x}$", { 182 }>,
<"I$^*_{x-x-x}$", { 183 }>,   // + one from 182
<"II$^*_{x-x}$", { 184 }>,
<"III$^*_{x}$", { 184 }>      // + one from 182
];

NUPages:=AssociativeArray();
for d in NUPageData do NUPages[d[1]]:=d[2]; end for;

function nupage(s: warnings:=true)
  b:=BasicNUType(s);
  if Left(b,11) eq "II$^*_{0}$-"    then b:="II$^*_{x}$-"*b[[12..#b]]; end if;   // 0 is allowed in 
  if Left(b,9)  eq "II$_{0}$-"      then b:="II$_{x}$-"*b[[10..#b]]; end if;     //   ***-II_n and ***-II^*_n
  if Right(b,11) eq "-II$^*_{0}$" or Right(b,9) eq "-II$_{0}$" then b:=b[[1..#b-4]]*"{x}$"; end if;    
  ok,D:=IsDefined(NUPages,b);
  if ok then
    return #D eq 1 select Representative(D) else D;
  end if; 
  if warnings then
    "Warning: could not find "*s*" -> "*b*" in NUPages";
  end if;
  return "???"; 
end function;
   
   
kodaira:=["Ig1","Ix","I0*","Ix*","II","II*","III","III*","IV","IV*"];
minus1:=func<len|len eq -1 select "(-1)" else len>;

function CompRecode(s,c)
  p:=Position(kodaira,s);
  error if p eq 0, "NU: component "*s*" not recognised";
  if s eq "Ig1" then s:="I$_{0}$"; 
  elif s eq "Ix" then s:=Sprintf("I$_{%o}$",c[1]); 
  elif s eq "I0*" then s:="I$^*_{0}$";
  elif s eq "Ix*" then s:=Sprintf("I$^*_{%o}$",c[1]); 
  else ReplaceString(~s,["*"],["$^*$"]);
  end if;
  return s,p+(IsEmpty(c) select 0 else c[1]/10^6); 
end function;


intrinsic NamikawaUeno(R::RedType: pottype:="all", depths:="original", warnings:=true) -> MonStgElt, RngIntElt
{returns Namikawa-Ueno reduction type pair nutype, page if unique,
  or false, [<pottype,guess,page>,...] if there are several depending 
  on the potential semistable type (I,II,III,...,VII)}

  error if Genus(R) ne 2, "Expected genus(R)=2 in NamikawaUenoType";

  family:=Label(ReductionFamily(R));

  if depths cmpeq "original" then
    l:=[eval d: d in GetDepths(R)];
  else
    l:=depths;
  end if;
  ld:=not IsEmpty(l) and Type(Universe(l)) eq RngInt 
    select Reverse(Sort(l)) else l;    // decreasing order for NU I_{m-n-r} convention m>n>r

  guess:="?";
  page:="?";

  if   family eq "T-{3-3}T"  then guess:=Sprintf("III$_{%o}$",l[1]); page:=184;         // T=T       -> III_n page 184
  elif family eq "4^1,3_D"   then guess:=Sprintf("III$_{%o}$",l[1]); page:=182;         // 4^1,3_D   -> III_n page 182
  elif family eq "[2]T_{6}D" then guess:=Sprintf("III$^*_{%o}$",l[1]);                  // [2]T_{6}D -> III*_n
  elif family eq "Ix_x"      then guess:=Sprintf("I$_{%o-%o-0}$",ld[1],ld[2]);          // I_m,n -> I_{m,n,0}
  elif family eq "I---I"     then guess:=Sprintf("I$_{%o-%o-%o}$",ld[1],ld[2],ld[3]);   // 1---1
  elif family eq "Ix*_D"     then guess:=Sprintf("I$^*_{%o-%o-0}$",l[1],l[2]);          // D=D=D
  elif family eq "[2]I_D,D,D" then guess:=Sprintf("I$^*_{%o-%o-%o}$",ld[3],ld[2],ld[1]); // [2]I_D,D,D  // why reversed?

  elif exists(guess){D[2]: D in [["10^1,4,5","VIII-1"], ["10^3,2,5","VIII-3"], ["10^9,6,5","VIII-4"], ["10^7,8,5","VIII-2"], 
         ["Ig2","I$_{0-0-0}$"], ["2^1,1,1,1,1,1","I$^*_{0-0-0}$"], ["3^1,1,2,2","III"], ["4^1,3,2,2","VI"], 
         ["5^1,1,3","IX-2"], ["5^1,2,2","IX-1"], ["5^2,4,4","IX-3"], ["5^3,3,4","IX-4"], ["6^1,1,4","V"],
         ["6^2,4,3,3","IV"], ["6^5,5,2","V$^*$"], ["8^1,3,4","VII"], ["8^5,7,4","VII$^*$"], ["Dg1","II"]] | D[1] eq family}
       then ;                // One principal component, no loops or D-tails => table lookup

  elif family eq "D--{2-2}D" then                   // D-=D
    guess:=Sprintf("II$_{%o-%o}$",l[1]+1,l[2]);     // CHECK edge order
    if pottype eq "all" then 
      page:=[<"III",guess,182>,<"IV",guess,183>];
      guess:=false; 
    else
      assert pottype in ["III","IV"];
      page:=pottype eq "III" select 182 else 183;   
    end if;

  elif family eq "Ix*_x" then
    guess:=Sprintf("II$_{%o-%o}$",l[1]+1,l[2]);       // Ix*_x
    if pottype eq "all" then 
      page:=[<"III",guess,182>,<"IV",guess,183>];
      guess:=false;
    else
      assert pottype in ["III","IV"];
      page:=pottype eq "III" select 182 else 183;                  
    end if;

  elif #R eq 2 then                                // III-IV-n and the like (55 types)
    P1,P2:=Explode(Split(family,"-"));
    P1len:=P1 in ["Ix","Ix*"];
    P2len:=P2 in ["Ix","Ix*"];
    c1,o1:=CompRecode(P1,P1len select [l[1]] else []);
    n:=P1len select l[2] else l[1];                // CHECK

    c2,o2:=CompRecode(P2,P2len select [l[P1len select 3 else 2]] else []);
    if o1 gt o2 then t:=c1; c1:=c2; c2:=t; t:=o1; o1:=o2; o2:=t; end if; 
    guess:=Sprintf("%o-%o-%o",c1,c2,minus1(n));
    if guess eq "III$^*$-IV-(-1)" then guess:="IV-III$^*$-(-1)"; end if;    // pari convention, as opposed to III*-IV-n for n>=0?

  elif Left(family,3) eq "[2]" and Right(family,1) eq "D" then       // [2]K_D
    r:=family[[4..Position(family,"_")-1]];
    if r eq "Ig1" then                                    // 2I_0<D : NU 2I{0}-n p159 and II*{n-0} p172 - asked Liu
      if pottype eq "all" then 
        guess:=false; page:=[<"II",Sprintf("II$^*_{%o-0}$",l[1]),172>,<"V",Sprintf("2I$_{0}$-%o",l[1]),159>];
      else
        assert pottype in ["II","V"];  
        if pottype eq "II" 
          then guess:=Sprintf("II$^*_{%o-0}$",l[1]); page:=172;
          else guess:=Sprintf("2I$_{0}$-%o",l[1]); page:=159;
        end if;
      end if;
    elif r eq "Ix" then                                 // [2]Ix_D
      guess:=false;    
      if pottype eq "all" then 
        guess:=false; page:=[<"VII",Sprintf("2I$_{%o}$-%o",l[2],l[1]),181>, <"IV",Sprintf("II$^*_{%o-%o}$",l[2],l[1]),184>];
      else
        assert pottype in ["VII","IV"];  
        if pottype eq "VII" 
          then guess:=Sprintf("2I$_{%o}$-%o",l[2],l[1]); page:=181;
          else guess:=Sprintf("II$^*_{%o-%o}$",l[2],l[1]); page:=184;
        end if;
      end if;
    elif r in kodaira then
      assert r ne "Ix";                                 // 2K_D
      rlen:=r in ["Ix*"];
      Ls:=CompRecode(r,rlen select [l[2]] else []);
      Ds:=l[1];
      guess:=Sprintf("2%o-%o",Ls,Ds);
    else 
      error "Unrecognized type [2]K_D with R="*DelSpaces(family)*" and r="*Sprint(r);
    end if;

  elif Right(family,1) eq "D" then                                  // K_D
    r:=family[[1..Position(family,"_")-1]];
    assert r in kodaira;

    c1:=CompRecode(r,r in ["Ix"] select [l[1]] else []);
    c2:=Sprintf("II$^*_{%o}$",Last(l));     
    if r eq "I0*" 
      then guess:=Sprintf("I$^*_{%o-0-0}$",l[1]);
      else guess:=r in ["III","III*"] select Sprintf("%o-%o",c2,c1) else Sprintf("%o-%o",c1,c2);
    end if;

  elif (#R eq 1) then        // One component + one loop on it (of length l)
    r:=family[[1..Position(family*"_","_")-1]];        
    if r in ["III","III*","IV","IV*"] then           // III_n, III*_n, IV_n, IV*_n
      c1:=CompRecode(r,[]);
      c2:=Sprintf("II$_{%o}$",l[1]+2-(r in ["IV*","III*"] select 1 else 2));   // CHECK
      guess:=r in ["III","III*"] select c2*"-"*c1 else c1*"-"*c2;
    elif r eq "Ixg1"    then guess:=Sprintf("I$_{%o-0-0}$",l[1]);     // Ilg1      CHECK
    elif r eq "I0*"     then guess:=Sprintf("II$_{%o-0}$",l[1]+1);    // I0*_l
    elif r eq "D"       then guess:=Sprintf("2I$_{%o}$-0",l[1]);      // D_{2,2}
    else error "Unexpected type with one loop"; 
    end if;

  else
    error Sprintf("NamikawaUeno: %o not recognised",family);
  end if;

  // lookup pages when they are unique
  showpage:=Type(page) eq SeqEnum select PrintSequence([d[3]: d in page]) else page;
  if page cmpeq "?" then 
    page:=nupage(guess: warnings:=warnings); 
    showpage:=page; 
  end if;
  vprintf redlib,1: "NU %-20o -> %-25o page %-5o\n",DelCRs(R),guess,showpage;

  return guess, page;
end intrinsic;


intrinsic NamikawaUenoFamily(R: pottype:="all") -> MonStgElt, RngIntElt     //
{For a reduction type with variable names (say SetLengths(~R,func<c|["n","m","r"][c`index]>))
  return the Namikawa-Ueno type pair 'nu, page' if unique,
  or false, [<pottype,guess,page>,...] if there are several depending 
  on the potential semistable type (I,II,III,...,VII)}
  names:=GetDepths(R);
  SetDepths(~R,func<c|[100,100^2,100^3][c`index]>);

  guess,page:=NamikawaUeno(R: pottype:=pottype);
  if guess cmpeq false then
    SetDepths(~R,names);
    return false, [<d[1],f,pg> where f,pg:=NamikawaUenoFamily(R: pottype:=d[1]): d in page];
  end if;

  T:=TokenSplit(guess,"0123456789");
  U:=PolynomialRing(Z,3);
  AssignNames(~U,names);
  for i->t in T do
    if not Regexp("[0-9]",t) then continue; end if;
    N:=eval t;
    v:=[];
    for i:=1 to 4 do
      a:=N-100*Round(N/100); 
      v[i]:=a;
      error if Abs(a) gt 5, Sprintf("lift: %o not close to 0",N);
      N:=(N-a) div 100;
    end for;
    s:=DelSpaces(v[1]+v[2]*U.1+v[3]*U.2+v[4]*U.3);
    br:=(i gt 1) and Last(T[i-1]) eq "{" and (i lt #T) and T[i+1][1] eq "}";
    if Count(v,0) lt 3 and not br then s:="("*s*")"; end if;
    T[i]:=s;
  end for;
  SetDepths(~R,names);
  return &cat T,page;
end intrinsic;


intrinsic HasAlphaType(R::RedType) -> BoolElt, MonStgElt, MonStgElt, RngIntElt      //
{true if a Namikawa-Ueno type (genus 2) that has an -alpha variant.
If yes, returns true, TeX family label for R, TeX N-U family label, N-U page}
  if Genus(R) ne 2 then return false,_,_,_; end if;
  alpha:=exists(c){c: c in EdgeChains(R) | c`depth eq -1};
  if not alpha then return false,_,_,_; end if;
  oldlen:=GetDepths(R);
  SetDepths(~R,func<c|c`class eq cEdge select "-1" else ["n","m","r"][c`index]>);
  nu,page:=NamikawaUenoFamily(R);
  error if Position(nu,"--1") eq 0,Sprintf("HasAlphaType: R=%o nu=%o page=%o failed",R,nu,page);
  ReplaceString(~nu,"--1","-(-1)");
  nu0:=ReplaceStringFunc(nu,["m","n"],["x","x"]);
  ok:=exists(d){d: d in NUPageData | d[1] eq nu0};
  error if not ok, "Alpha type not found for "*Label(R)*" nu0="*nu0;
  SetDepths(~R,oldlen);
  return true,Label(R: tex),ReplaceStringFunc(nu,"(-1)","$\\alpha$"),d[2];
end intrinsic;


/*
Example
R:=ReductionType("5^1,1,3");
NamikawaUeno(R);
R:=ReductionType("[2]I1_D");        // several possible types 
NamikawaUeno(R);
NamikawaUeno(R: pottype:="VII");    // specify Liu's potential semistable type
*/

