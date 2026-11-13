/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

Muselli-MacLane clusters and cluster pictures - type ClM, ClPicM

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

type ClM:
  Sigma,           // parent cluster picture
  index,           // 1..#clusters in the cluster picture
  parentindex,     // index of the parent of (s,v), 0 if top cluster
  size,            // size |s| of the cluster
  rootcls,         // indices in Sigma`C of root (improper) clusters contained in s
                   // <-> irr factors of f if K complete
  v,               // MacLane valuation which cuts out the cluster
  dv,              // degree of v
  lambda,          // radius of v
  min,             // is degree minimal cluster?
  bv,              // b_v = e_v/epsilon_v = denominator(lambda*dv)
  ev,              // e_v=b_v d_v
  nuv,             // v(f)
  nv,              // 1 if ev nuv is odd, 2 if even
  mv,              // 2ev/nv
  tv,              // |s|/dv
  pv,              // 1 if tv is odd, 2 if even
  sv,              // 1/2*(tv*lambda+pv*lambda-nuv)
  gammav,          // 2 if tv is even and nuv*dv-|s|*lambda is odd, 1 otherwise
  delta,           // 1 if min, 0 else
  pv0,             // 1 if min{r in s}[K(r):K]=dv and min, 2 otherwise
  sv0,             // -nuv/2+lambda
  gammav0,         // 2 if pv0=2 and nuv*dv is odd, 1 otherwise
  lv,              // 0<=lv<bv, lv*lambda*dv-1/bv in Z
  vtilde,          // children (t,w) with |t|/ev-lv*nuv*dw not in 2Z
  cv0,             // 1 if (2-pv0)/bv-lv*nuv*dv not in 2Z, 0 otherwise
  uv,              // (|s|-sum_{(t,w)<(s,v)}|t|-dv(2-pv0))/ev+|vtilde|+delta*cv0
  g,               // genus = 0 if nv=1, max(0,floor((uv-1)/2)) else
  ubereven;        // true if reduced eqn if y^2=const

type ClPicM:
  D,       // RngDVR
  K,       // original base field
  F,       // unramified extension where Centers are defined
  v,       // valuation on F
  k,       // residue field of F
  p,       // residue characteristic
  f,       // defining polynomial
  g,       // genus
  s,       // clusters, of type ClM
  C;       // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [223]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [241]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [247]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [253]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [259]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [268]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [274]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [282]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [290]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [298]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [319]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [336]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [343]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [349]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [355]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [361]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [448]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [536]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [640]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [741]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [751]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [242]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [260]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [266]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [272]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [278]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [287]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [293]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [301]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [309]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [317]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [338]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [355]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [362]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [368]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [374]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [380]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [467]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [555]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [659]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [760]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [770]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [331]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [349]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [355]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [361]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [367]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [376]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [382]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [390]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [398]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [406]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [427]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [444]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [451]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [457]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [463]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [469]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [556]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [644]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [748]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [849]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [859]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [420]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [438]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [444]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [450]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [456]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [465]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [471]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [479]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [487]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [495]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [516]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [533]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [540]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [546]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [552]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [558]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [645]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [733]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [837]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [938]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [948]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [509]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [527]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [533]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [539]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [545]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [554]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [560]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [568]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [576]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [584]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [605]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [622]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [629]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [635]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [641]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [647]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [734]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [822]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [926]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [1027]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [1037]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.

*
* IMPLEMENTS
*
type ClM
type ClPicM
declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions for clusters (ClM)
*
intrinsic Print(s::ClM, level::MonStgElt)                                                                       [598]
  Print a MacLane-Muselli cluster
*
* Basic cluster invariants (ClM)
*
intrinsic Degree(s::ClM) -> RngIntElt                                                                           [616]
  Degree of a MacLane-Muselli cluster = degree of the defining valuation
intrinsic Valuation(s::ClM) -> RngIntElt                                                                        [622]
  Valuation that cuts out the cluster
intrinsic ClusterPicture(s::ClM) -> ClPicM                                                                      [628]
  Cluster picture in which the cluster s lives
intrinsic Index(s::ClM) -> RngIntElt                                                                            [634]
  Index of the cluster in the cluster picture
*
* Equality and children 
*
intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt                                                                     [643]
  Equality testing for MacLane-Muselli clusters in the same cluster picture
intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt                                                             [649]
  True if s is properly contained in p (for s,p MacLane-Muselli clusters)
intrinsic Children(s::ClM) -> SeqEnum                                                                           [657]
  Proper children of a MacLane-Muselli cluster
intrinsic ParentCluster(s::ClM) -> ClM                                                                          [665]
  Parent of a MacLane-Muselli cluster
intrinsic RootClusters(s::ClM) -> SeqEnum                                                                       [673]
  List of root cluster valuations contained in the MacLane-Muselli cluster s
*
* Basic type functions for cluster pictures (ClPicM)
*
intrinsic Print(Sigma::ClPicM, level::MonStgElt)                                                                [694]
  Print a MacLane-Muselli cluster picture
*
* Basic invariants for cluster pictures (ClPicM)
*
intrinsic Genus(Sigma::ClPicM) -> RngIntElt                                                                     [711]
  Genus of a MacLane-Muselli cluster picture
intrinsic BaseField(Sigma::ClPicM) -> Fld                                                                       [718]
  Original base field K for a MacLane-Muselli cluster picture
intrinsic ResidueField(Sigma::ClPicM) -> Fld                                                                    [724]
  Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined
intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld                                                               [730]
  Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are
  defined
intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]                                                               [736]
  List of all clusters (of type ClM) that form the cluster picture
intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)                                                          [823]
*
* Creation functions for cluster pictures
*
intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM                                                    [911]
  Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued
  field (RngDVR) of residue characteristic not 2.
*
* Dual graph from a cluster picture and associated model (Muselli's theorem)
*
intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual             [1015]
intrinsic TeX(Sigma::ClPicM) -> MonStgElt                                                                       [1116]
  List of clusters as an TeX array
intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel                                         [1126]
  MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued
  field (RngDVR) of residue characteristic not 2.
*/

/*
Manual
The file provides Muselli's machinery of rational clusters, and the corresponding models of hyperelliptic curves in odd residue characteristic. It is based on MacLane valuations (maclane.m).

\par\medskip
See S. Muselli, \emph{Regular models of hyperelliptic curves}, Indag. Math. (2023). 

In the examples below we set
\begin{verbatim}
Q:=Rationals();
R<x>:=PolynomialRing(Q);
\end{verbatim}

The package defines two types: rational MacLane-Muselli clusters (ClM) and the 
associated cluster pictures:
*/

declare type ClM;  // MacLane-Muselli cluster (s,v) - see Defn 1.5=6.1 in Simone's paper

declare attributes ClM:
  Sigma,          // parent cluster picture 
  index,          // 1..#clusters in the cluster picture
  parentindex,    // index of the parent of (s,v), 0 if top cluster
  size,           // size |s| of the cluster
  rootcls,        // indices in Sigma`C of root (improper) clusters contained in s 
                  //   <-> irr factors of f if K complete
  v,              // MacLane valuation which cuts out the cluster
  dv,             // degree of v
  lambda,         // radius of v
  min,            // is degree minimal cluster?
  bv,             // b_v = e_v/epsilon_v = denominator(lambda*dv)
  ev,             // e_v=b_v d_v
  nuv,            // v(f)
  nv,             // 1 if ev nuv is odd, 2 if even
  mv,             // 2ev/nv
  tv,             // |s|/dv
  pv,             // 1 if tv is odd, 2 if even
  sv,             // 1/2*(tv*lambda+pv*lambda-nuv)
  gammav,         // 2 if tv is even and nuv*dv-|s|*lambda is odd, 1 otherwise
  delta,          // 1 if min, 0 else
  pv0,            // 1 if min{r in s}[K(r):K]=dv and min, 2 otherwise
  sv0,            // -nuv/2+lambda
  gammav0,        // 2 if pv0=2 and nuv*dv is odd, 1 otherwise
  lv,             // 0<=lv<bv, lv*lambda*dv-1/bv in Z
  vtilde,         // children (t,w) with |t|/ev-lv*nuv*dw not in 2Z
  cv0,            // 1 if (2-pv0)/bv-lv*nuv*dv not in 2Z, 0 otherwise
  uv,             // (|s|-sum_{(t,w)<(s,v)}|t|-dv(2-pv0))/ev+|vtilde|+delta*cv0
  g,              // genus = 0 if nv=1, max(0,floor((uv-1)/2)) else 
  ubereven;       // true if reduced eqn if y^2=const

declare type ClPicM;

declare attributes ClPicM:
  D,      // RngDVR
  K,      // original base field
  F,      // unramified extension where Centers are defined
  v,      // valuation on F
  k,      // residue field of F
  p,      // residue characteristic
  f,      // defining polynomial
  g,      // genus
  s,      // clusters, of type ClM
  C;      // root cluster valuations (for improper clusters <=> irr factors of f if K is complete)


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


/// Basic type functions for clusters (ClM)


intrinsic IsCoercible(s::ClM, y::.) -> BoolElt, .    //
{Coerce a MacLane-Muselli cluster}
  return false, _;
end intrinsic;


intrinsic 'in'(s::ClM, y::.) -> BoolElt     //
{"in" function for a MacLane-Muselli cluster}
  return false;
end intrinsic;


intrinsic Print(s::ClM, level::MonStgElt)
{Print a MacLane-Muselli cluster}
  printf "#%o %-20o d%o b%o e%o nu%-5o n%o m%o t%o p%o s%o gamma=%o pv0=%o sv0=%-4o gammav0=%o u=%o g=%o",  
    #s,s`v,s`dv,s`bv,s`ev,s`nuv,s`nv,s`mv,s`tv,s`pv,s`sv,s`gammav,
    assigned s`pv0 select s`pv0 else "?",assigned s`sv0 select s`sv0 else "?",assigned s`gammav0 select s`gammav0 else "?",
    assigned s`uv select s`uv else "?",assigned s`g select s`g else "?";
end intrinsic;


/// Basic cluster invariants (ClM)


intrinsic '#'(s::ClM) -> RngIntElt
{Size of a MacLane-Muselli cluster = number of roots inside}
  return s`size;
end intrinsic;


intrinsic Degree(s::ClM) -> RngIntElt
{Degree of a MacLane-Muselli cluster = degree of the defining valuation}
  return Degree(s`v);
end intrinsic;


intrinsic Valuation(s::ClM) -> RngIntElt
{Valuation that cuts out the cluster}
  return s`v;
end intrinsic;


intrinsic ClusterPicture(s::ClM) -> ClPicM
{Cluster picture in which the cluster s lives}
  return s`Sigma;
end intrinsic;


intrinsic Index(s::ClM) -> RngIntElt
{Index of the cluster in the cluster picture}
  return s`index;
end intrinsic;


/// Equality and children 


intrinsic 'eq'(s1::ClM, s2::ClM) -> BoolElt
{Equality testing for MacLane-Muselli clusters in the same cluster picture}
  return (s1`rootcls eq s2`rootcls) and (s1`lambda eq s2`lambda) and (s1`dv eq s2`dv) and (s1`size eq s2`size);
end intrinsic;


intrinsic IsProperSubset(s::ClM, p::ClM) -> BoolElt
{True if s is properly contained in p (for s,p MacLane-Muselli clusters)}
  return s`index eq p`index select false else
    ((s`rootcls subset p`rootcls) and (#p`rootcls ne #s`rootcls)) 
      or ((p`rootcls eq s`rootcls) and (s`lambda gt p`lambda)); 
end intrinsic;


intrinsic Children(s::ClM) -> SeqEnum
{Proper children of a MacLane-Muselli cluster}
  T:=s`Sigma;
  return [d: d in T`s | IsProperSubset(d,s) 
    and not exists{t: t in T`s | IsProperSubset(d,t) and IsProperSubset(t,s)}];
end intrinsic;


intrinsic ParentCluster(s::ClM) -> ClM
{Parent of a MacLane-Muselli cluster}
  T:=s`Sigma;
  up:=[d: d in T`s | IsProperSubset(s,d)];
  return IsEmpty(up) select 0 else up[1];
end intrinsic;


intrinsic RootClusters(s::ClM) -> SeqEnum
{List of root cluster valuations contained in the MacLane-Muselli cluster s}
  return s`Sigma`C[s`rootcls];
end intrinsic;


/// Basic type functions for cluster pictures (ClPicM)


intrinsic IsCoercible(Sigma::ClPicM, y::.) -> BoolElt, .      //
{Coerce a MacLane-Muselli cluster picture}
  return false, _;
end intrinsic;


intrinsic 'in'(Sigma::ClPicM, y::.) -> BoolElt      //
{"in" function for a MacLane-Muselli cluster picture}
  return false;
end intrinsic;


intrinsic Print(Sigma::ClPicM, level::MonStgElt)
{Print a MacLane-Muselli cluster picture}
  printf "g=%o cluster picture (%o roots) /F%o%o%o",Sigma`g,Degree(Sigma`f),
  Sigma`p,IsPrime(#Sigma`k) select "" else Sprintf("^%o",Valuation(#Sigma`k,Sigma`p)),
    level eq "Minimal" select "" else &cat["\n"*Sprint(s,level): s in Sigma`s];  // print clusters
end intrinsic;


/// Basic invariants for cluster pictures (ClPicM)


intrinsic '#'(Sigma::ClPicM) -> RngIntElt
{Total size of a MacLane-Muselli cluster picture}
  return Degree(Sigma`f);
end intrinsic;


intrinsic Genus(Sigma::ClPicM) -> RngIntElt
{Genus of a MacLane-Muselli cluster picture}
  assert Sigma`g eq (#Sigma-1) div 2;
  return Sigma`g;
end intrinsic;


intrinsic BaseField(Sigma::ClPicM) -> Fld
{Original base field K for a MacLane-Muselli cluster picture}
  return Sigma`K;
end intrinsic;


intrinsic ResidueField(Sigma::ClPicM) -> Fld
{Residue field k of the base field K over which a MacLane-Muselli cluster picture is defined}
  return Sigma`k;
end intrinsic;


intrinsic FieldOfDefinition(Sigma::ClPicM) -> Fld
{Unramified extension F of the base field K of a MacLane-Muselli cluster picture over which the centers are defined}
  return Sigma`F;
end intrinsic;


intrinsic Clusters(Sigma::ClPicM) -> SeqEnum[ClM]
{List of all clusters (of type ClM) that form the cluster picture}
  return Sigma`s;
end intrinsic;


function BasicShift(v,s,r)
  d:=Denominator(s*v`e);
  newg:=Center(v)^d - r * Monomial(Truncate(v),d*s);
  if d eq 1 then   
    g:=Append(Prune(v`g),newg);            // shift v by a generalised monomial to increase slope
    lambda:=Append(Prune(v`lambda),Q!s);
  else 
    g:=Append(v`g, newg);                  // Augment v to a new valuation with g_n^d-m
    lambda:=Prune(v`lambda) cat [Q|s,d*s];
  end if;
  return MacLaneValuation(v`D,g,lambda);
end function;


function RootClustersMain(D,f)
  lead:=func<a|a eq 0 select 0 else D`red(a/D`pi^D`v(a))>;
  Rk<t>:=PR(D`k);
  v0:=GaussValuation(D);
  stack:=[v0];
  firststep:=true;
  z:=[];
  repeat
    v:=stack[1];
    vprint CrvHyp,1: "Processing",DelSpaces(v);
    Remove(~stack,1);
    Nv:=NewtonPolygon(f,v);
    for si->s in Nv do
      slope,e,moncfs:=Explode(s);
      vprintf CrvHyp,1: "%o s=%o N=%o\n",DelSpaces(v),slope,Dotted(DelSpaces(NewtonPolygon(f,v)),40);
      if not firststep and slope le Radius(v) then continue; end if;
      if (si eq 1) and (slope eq Infinity() or (/*e**/#moncfs eq 2)) then                     // linear polynomial -> done
        slope:=slope eq Infinity() select Q!Ceiling(Radius(v)+1/10) else slope;
        vnew:=ChangeSlope(v,slope);
        vprint CrvHyp,1: "->",DelSpaces(vnew);
        Append(~z,vnew);
        continue; 
      end if;   
  
      L:=[];
      e:=false;
      for j in D`k do
        if j eq 0 then continue; end if;
        vnew:=BasicShift(v,slope,D`lift(j)); 
        N:=NewtonPolygon(f,vnew); 
        r:=N[1][1] gt Radius(vnew) select D`k!0 else lead(N[1][3][1]);
        Append(~L,<[j],r>);
        vprint CrvHyp,3: j,DelSpaces(vnew),DelSpaces(N),"->",Last(L)[2];
        if (r ne 0) and (#L ge #N[1][3]+1) then e:=Z!N[1][2]; break; end if;
      end for;

      if e cmpeq false 
        then rpol:=false;
        else rpol:=PolynomialFit([<[d[1][1]^e],d[2]>: d in L],#L-2);
      end if;    
      if rpol cmpeq false then
        error if #D`k gt Degree(f)+3, Sprintf("p=%o L=%o deg(f)=%o fit failed completely",Characteristic(D`k),DelSpaces(L),Degree(f));
        return 2,[];
      end if;
      
      rpol:=Evaluate(Rk!rpol,t^e);
      vprint CrvHyp,2: "Residue polynomial",/*PrintFactor(rpol: var:="t");*/DelSpaces(rpol);

      for fct in Factorisation(rpol) do
        rpol,mult:=Explode(fct);      
        if Evaluate(rpol,0) eq 0 then continue; end if;
        deg:=Degree(rpol);
        if deg ne 1 then                 // deg>1 => need residue degree => extend D
          return deg,[];
        end if;
        r:=Roots(rpol)[1,1];
        vnew:=BasicShift(v,slope,D`lift(r)); 
        vprint CrvHyp,1: "Adding",DelSpaces(vnew),Dotted(DelSpaces(NewtonPolygon(f,vnew)),40);
        Append(~stack,vnew);
      end for;
    end for;
    firststep:=false;
  until IsEmpty(stack);
  return 1,z;
end function;


intrinsic RootClusters(~D::RngDVR, ~f::RngUPolElt, ~S)
{Construct S := MacLane valuations (<-> improper root clusters) for a polynomial f over a DVR. 
These correspond to factors of f over the unramfied closure of the completion of K. 
When f is irreducible over it, such a MacLane valuation is unique, and it is the truncation 
of the unique pseudo-valuation that f->infty at the last step of its MacLane presentation. 
This function may change D and f if an unramified base extension is needed along the way.}
  S:=[];
  repeat
    deg,S:=RootClustersMain(D,f);
    if deg eq 1 then return; end if;        // deg=1 => done
    D:=Extend(D,deg);                       // deg>1 => failed to find roots somewhere; extend D and repeat
    f:=PolynomialRing(D`K)!f;
  until false;
end intrinsic;


/*
Example RootClusters
// Take $f=(x^3-3)^2+3^5$ over $\Q_3$. It is irreducible over $\Q_3^{nr}$, and there is a unique MacLane pseudo-valuation that ends with $f\to\infty$, namely
// $$v=[x\to 1/3,\>x^3\!-\!3\to 5/2,\>f\to \infty]$$
// We can recover it by using RootClusters. When constructing the regular model of $y^2=f(x)$ over $\Q_3$, this valuation corresponds to the unique root cluster, in Muselli's terminology:
Qp:=pAdicField(3,20);         // Q3 with precision 20 
D:=DVR(Qp);                   // and the corresponding DVR
f:=(x^3-3)^2+3^5;            
RootClusters(~D,~f,~S);       
DelSpaces(S); //> S;
f:=x*(x-1)*(x-2);             // another example:
RootClusters(~D,~f,~S);       // here f(x) factors completely over Q3
S;
f:=x^6+9;                     // here f(x)=x^6+9=(x^3+3i)(x^3-3i) over Q3^nr  
RootClusters(~D,~f,~S);       // and the function changes D to Q3(i)
D;
S;
*/


/// Creation functions for cluster pictures


function ClusterValuations(D,f,S)
  vprint CrvHyp,1: "Computing clusters from root clusters";
  K:=D`K;
  k:=D`k;
  R<X>:=PR(k);
  den:=func<x|Type(x) eq Infty select 1 else Denominator(x)>;

  M:=[[Distance(v,w): w in S]: v in S];   // Distances between Centers
  
  R:=[];
  for i:=1 to #S do
    v:=S[i];
    while not exists{r: r in R | r[1] eq Degree(f)} or not IsGauss(v) do
      g_n:=Center(v);
      v0:=Truncate(v);
      e:=v0`e;
      
      MinSlope:=IsGauss(v0) select -Infinity() else Valuation(g_n,v0);   
      N:=NewtonPolygon(f,v);
      for k:=1 to #N do 
        lambda:=N[k][1];
        if lambda le MinSlope or lambda eq Infinity() then continue; end if;   // ignore low slopes and size 1 clusters
  
        clv:=ChangeSlope(v,lambda);
        rootcl:=[i: i->w in S | Degree(g) ge Degree(v) and forall{d: d in NewtonPolygon(g,v) | d[1] ge lambda} where g is Center(w)];
       
        rootdist:=Min([M[i,j]: i,j in rootcl]);
        
        size:=&+[RamificationDegree(r): r in S[rootcl]]; 
        assert size mod e eq 0;
        
        if not exists{s: s in R | s[1] eq size and s[2] eq rootcl and s[3] eq e}     // add if don't have already
             and size ne e then                                                      //     and proper

          if i notin rootcl then
            ; // Sprintf("i=%o rootdist=%o lambda=%o %o",i,rootdist,lambda,i in rootcl);  ??
          else 
            Append(~R,<size,rootcl,e,lambda,clv>);
          end if;
        end if;
      end for;
      if IsGauss(v) then break; end if;
      v:=Truncate(v);
    end while;
  end for;
  return R;
end function;


intrinsic ClusterPicture(f::RngUPolElt, D::RngDVR) -> ClPicM
{Construct a MacLane-Muselli cluster picture for a hyperelliptic curve y^2=f(x) defined over a discrete valued field (RngDVR) of residue characteristic not 2.}

  K0:=D`K;                        // Original field
  RootClusters(~D,~f,~S);         // Root (<=>improper) clusters; extend K if necessary

  K,k,vK,red,lift,pi:=Eltseq(D);
  Sigma:=New(ClPicM);   // MacLane-Muselli cluster picture
  Sigma`K:=K0;          // original base field
  Sigma`F:=K;           // unramified extension where Centers are defined
  Sigma`k:=k;           // residue field of F
  Sigma`v:=vK;          // valuation on F
  Sigma`p:=Characteristic(k);  // prime
  Sigma`f:=f;           // defining polynomial
  Sigma`g:=(Degree(f)-1) div 2;   // genus
  Sigma`C:=S;                     // valuations that cut out root clusters

  error if Sigma`p eq 2, "Cluster pictures are only valid in res char <>2";

  R:=ClusterValuations(D,f,S);    // cluster sizes and radii <size,rootcl,e,lambda,clv>
  SortBy(~R,func<c|[c[1],-c[3],#c[2]]>); 

  Sigma`s:=[];                    // MacLane-Muselli clusters in Sigma

  for index->c in R do            // Set basic information (everything except children-related)
    size,rootcls,e,lambda,v:=Explode(c);
    assert lambda eq Radius(v);
    g_n:=Center(v);
    dv:=Degree(v);
    vparent:=Truncate(v);
    assert dv eq RamificationDegree(vparent);
    vprint CrvHyp, 1: Sprintf("  size %-2o %o->%o e%o at %o",size,DelSpaces(g_n),lambda,e,DelSpaces(rootcls)); 
    bv:=Denominator(lambda*dv);
    ev:=bv*dv;
    nuv:=Valuation(f,v);
    nv:=IsOddZ(nuv*ev) select 1 else 2;
    mv:=Z!(2*ev/nv);
    tv:=Z!(size/dv);
    pv:=IsOdd(tv) select 1 else 2;
    sv:=1/2*(tv*lambda+pv*lambda-nuv);
    gammav:=IsEven(tv) and IsOddZ(nuv*dv-size*lambda) select 2 else 1;
    assert exists(lv){lv: lv in [0..bv-1] | IsCoercible(Z,lv*lambda*dv-1/bv)};
    vprintf CrvHyp,1: "  rootcls %o %o\n",DelSpaces(v),DelSpaces(rootcls);
    s:=New(ClM);
    s`Sigma:=Sigma;
    s`index:=index;
    s`rootcls:=rootcls;
    s`size:=size;
    s`v:=v;
    s`dv:=dv;
    s`lambda:=lambda;
    s`bv:=bv;
    s`ev:=ev;
    s`nuv:=nuv;
    s`nv:=nv;
    s`mv:=mv;
    s`tv:=tv;
    s`pv:=pv;
    s`sv:=sv;
    s`gammav:=gammav;
    s`lv:=lv;
    Append(~Sigma`s,s);
  end for;  

  // Define remaining quantities now that we can compute children: 
  // parentindex, min, delta, ds, pv0, sv0, gammav0, vtilde, cv0, g, ubereven

  for i:=1 to #Sigma`s do
    s:=Sigma`s[i];
    parent:=ParentCluster(s);
    s`parentindex:=parent cmpeq 0 select 0 else parent`index;
    c:=Children(s);
    s`min:=not exists{t: t in c | Degree(t) eq Degree(s)};
    s`delta:=s`min select 1 else 0;
    minwithroot:=s`min and exists{w: w in RootClusters(s) | RamificationDegree(w) eq Degree(s`v)}; 
    vprint CrvHyp,1: "minwithroot",s`min,DelSpaces({[RamificationDegree(w),Degree(s`v)]: w in RootClusters(s)}),"->",minwithroot;
    s`pv0:=minwithroot select 1 else 2;
    s`sv0:=-s`nuv/2+s`lambda;
    s`gammav0:=s`pv0 eq 2 and IsOddZ(s`nuv*s`dv) select 2 else 1;
    s`vtilde:={t: t in c | not IsEvenZ(#t/s`ev-s`lv*s`nuv*Degree(t))};  
    s`cv0:=IsEvenZ((2-s`pv0)/s`bv-s`lv*s`nuv*s`dv) select 0 else 1;
    s`uv:=(#s-&+[Z|#t: t in c]-s`dv*(2-s`pv0))/s`ev+#s`vtilde+s`delta*s`cv0;
    if not IsCoercible(Z,s`uv) then "ERROR! uv is not an integer"; end if;
    s`g:=s`nv eq 1 select 0 else Max(0,Floor((s`uv-1)/2));
    s`ubereven:=s`nv eq 2 and s`uv eq 0;
    Sigma`s[i]:=s;
  end for;  

  return Sigma;
end intrinsic;    


/*
Example
D:=DVR(Q,3);                 
TeX(ClusterPicture(x^3+3,D));                 // One cluster of size 3
TeX(ClusterPicture((x^3+3)*(x-1)*(x-2),D));   // Two nested clusters
TeX(ClusterPicture((x^2-3)^3+x^7,D));         // Non-rational cluster
*/


/// Dual graph from a cluster picture and associated model (Muselli's theorem)


intrinsic DualGraph(Sigma::ClPicM: check:=true, contract:=true, texsettings:="default") -> GrphDual
{Returns the dual graph of a special fibre of a regular model with normal crossings constructed from a MacLane-Muselli cluster picture (Muselli's Theorem). Two optional flags:
check: test multiplicities (default true);
contract: contract components to get minimal r.n.c. model (default true);}

  if texsettings cmpeq "default" then
    texsettings:=[["dualgraph.princompnamestyle","inner sep=2pt,below left,scale=0.6"]];
  end if;

  G:=DualGraph(: texsettings:=texsettings);
  clusters:=Sigma`s;

  for i->s in clusters do                // (1) Principal components 
    S:=Sprint(i);
    texname:=Sprintf("$%o\\colon %o$",#s,TeX(s`v));
    m:=s`mv;
    if (s`nv eq 2) and (s`uv eq 0) then
      AddComponent(~G,S*"+",0,m: texname:=ReplaceStringFunc(texname,"\\colon","{+}\\colon"));
      AddComponent(~G,S*"-",0,m: texname:=ReplaceStringFunc(texname,"\\colon","{-}\\colon"));
    else
      AddComponent(~G,S,s`g,m: texname:=texname);
      AddAlias(~G,S,S*"+");
      AddAlias(~G,S,S*"-");
    end if;
  end for;

  t:=Last(clusters);                     // Top Cluster
  assert not check or ParentCluster(t) cmpeq 0;

  for s in clusters do 
    S:=Sprint(s`index);
    Sminus:=S*"-";
    Splus:=S*"+";
    ch:=Children(s);  

    if s`nv eq 1 then                                      // (2) P1s for roots that aren't children 
      nchains:=(#s-&+[Z|#t: t in ch]+s`dv*s`delta*(s`pv0-2))/s`ev;
      if not IsCoercible(Z,nchains) then
        "ERROR!: non-integral number of chains";
        nchains:=1; ev:=2;
      end if;
      for j:=1 to Z!nchains do
        vprint CrvHyp, 3: "chain2>",[s`ev];
        AddChain(~G,S,"",[s`ev]);
      end for;
    end if;

    if s`delta eq 1 then                                                   // (3a)
      vprint CrvHyp, 3: "chain3ab>",[s`dv*s`gammav0,-s`sv0];
      AddMinimalOuterChain(~G,Sminus,s`dv*s`gammav0,-s`sv0);    
      if s`pv0/s`gammav0 eq 2 then                                         // (3b)
        AddMinimalOuterChain(~G,Splus,s`dv*s`gammav0,-s`sv0);    
      end if;
    end if;

    t:=ParentCluster(s);                                                   
    if t cmpne 0 then
      T:=Sprint(t`index);
      Tminus:=T*"-";
      Tplus:=T*"+";                                                        // (3c)
      vprint CrvHyp, 3: "chain3cd>",[s`dv*s`gammav,s`sv,s`sv-s`pv/2*(s`lambda-s`dv/t`dv*t`lambda)];
      AddMinimalInnerChain(~G,Sminus,Tminus,s`dv*s`gammav,s`sv,s`sv-s`pv/2*(s`lambda-s`dv/t`dv*t`lambda));    
      if s`pv/s`gammav eq 2 then                                           // (3d)
        AddMinimalInnerChain(~G,Splus,Tplus,s`dv*s`gammav,s`sv,s`sv-s`pv/2*(s`lambda-s`dv/t`dv*t`lambda));    
      end if;
    end if;

    if t cmpeq 0 then                                                      // (3e)
      vprint CrvHyp, 3: "chain3ef>",[s`dv*s`gammav,s`sv];
      AddMinimalOuterChain(~G,Sminus,s`dv*s`gammav,s`sv);    
      if s`pv/s`gammav eq 2 then                                           // (3f)
        AddMinimalOuterChain(~G,Splus,s`dv*s`gammav,s`sv);    
      end if;
    end if;      
  end for;

  if check or contract then
    assert IsConnected(G);                      // Check connectedness
    assert HasIntegralSelfIntersections(G);     // Check self-intersections
  end if;

  if contract then
    MakeMRNC(~G);
  end if;

  return G;
end intrinsic;


/*
Example
D:=DVR(Q,3);                 
Sigma:=ClusterPicture(x^3+3,D);                  // One cluster of size 3
TeX(DualGraph(Sigma));
Sigma:=ClusterPicture((x^3+3)*(x-1)*(x-2),D);    // Two nested clusters
TeX(DualGraph(Sigma));
Sigma:=ClusterPicture((x^2-3)^3+x^7,D);          // Non-rational cluster
TeX(DualGraph(Sigma));
*/


intrinsic TeX(Sigma::ClPicM) -> MonStgElt
{List of clusters as an TeX array}
  s:="{\\mathfrak s} & v & |{\\mathfrak s}| & d_v & b_v & e_v & \\nu_v & n_v & m_v & t_v & p_v & s_v & \\gamma_v & p_v^0 & s_v^0 & \\gamma_v^0 & u_v & g \\cr";
  s*:=&cat[Sprintf( PrintSequence(["%o": i in [1..18]]: sep:=" & ")*"\\cr\n",
    Sprintf("{\\mathfrak s}_%o",s`index),TeX(s`v),#s,s`dv,s`bv,s`ev,s`nuv,s`nv,s`mv,s`tv,s`pv,s`sv,s`gammav,s`pv0,s`sv0,s`gammav0,s`uv,s`g):
    s in Sigma`s];
  return Sprintf("\\begin{array}{llllllllllllllllll}\n%o\\end{array}\n",s);
end intrinsic;


intrinsic MuselliModel(f::RngUPolElt, D::RngDVR: Style:=[]) -> CrvModel
{MacLane-Muselli model with normal crossings of a hyperelliptic curve y^2=f(x) defined over a discretely valued field (RngDVR) of residue characteristic not 2.}

  settings:=DefaultModelSettings();
  AddSettings(~settings,Style);

  K,k,v,red,lift,pi:=Eltseq(D);
  p:=Characteristic(k);
  error if p eq 2, "MacLane-Muselli model of a hyperelliptic curve only works in residue characteristic <>2";

  RK<x>:=PR(K);
  f:=RK!f;

  repeat
    min:=Min([v(c): c in Coefficients(f)]); 
    if min lt 0 then f:=f*pi^(2*((1-min) div 2)); end if;             // make integral and primitive
    if min gt 0 then f:=f div pi^(2*(min div 2)); end if;   
    if v(LeadingCoefficient(f)) le 1 then break; end if;   // and v(lead coeff)<=1
    f:=Evaluate(f,x/pi^2);
  until false;  

  Sigma:=ClusterPicture(f,D);
  G:=DualGraph(Sigma);
  R:=ReductionType(G);

  M:=New(CrvModel);
  M`forg:=f;       // original equation defining the curve C
  M`f:=f;          // working equation for the curve C
  M`K:=K;          // base field
  M`k:=k;          // residue field
  M`pi:=pi;        // uniformiser
  M`red:=red;      // reduction map O_K->k
  M`lift:=lift;     // lifting k->O_K
  M`v:=v;          // valuation on K
  M`G:=G;          // dual graph
  M`R:=R;          // reduction type
  // Cluster picture in the hyperelliptic p<>2 case
  M`Sigma:=Sigma;
  // Settings and TeX
  M`type:="clusters";
  M`Style:=settings;   // defining settings for showing graphs and reduction types

  return M;
end intrinsic; 


/*
Example
D:=DVR(Q,3);                 
M:=MuselliModel(x^3+3,D);                  // One cluster of size 3
ReductionType(M);
M:=MuselliModel((x^3+3)*(x-1)*(x-2),D);    // Two nested clusters
ReductionType(M);
M:=MuselliModel((x^2-3)^3+x^7,D);          // Non-rational cluster
ReductionType(M);
*/


