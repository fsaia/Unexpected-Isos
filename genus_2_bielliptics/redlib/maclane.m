/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

MacLane valuations (type MacV)

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

type MacV:
  D,         // RngDVR
  n,         // valuation length, 0 for Gauss
  g,         // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,    // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;         // = e(v/v0), ramification index over the Gauss valuation

*
* IMPLEMENTS
*
type MacV
declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(v::MacV, level::MonStgElt)                                                                      [153]
  Print a MacLane valuation v
*
* Creation functions 
*
intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV                                      [165]
intrinsic GaussValuation(D::RngDVR) -> MacV                                                                     [183]
  Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR
intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV                                                  [189]
*
* Basic invariants
*
intrinsic Length(v::MacV) -> RngIntElt                                                                          [209]
  Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)
intrinsic Center(v::MacV) -> RngUPolElt                                                                         [215]
  Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)
intrinsic Degree(v::MacV) -> RngIntElt                                                                          [221]
  Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))
intrinsic Radius(v::MacV) -> FldRatElt                                                                          [227]
  Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)
intrinsic IsGauss(v::MacV) -> BoolElt                                                                           [233]
  True if v is the Gauss valuation
intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt                                                                [239]
  True if v2 extends v1 as a MacLane valuation
intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV                                                               [248]
  Truncate a MacLane valuation to a smaller n <= Length(v)
intrinsic Truncate(v::MacV) -> MacV                                                                             [256]
  Truncate a MacLane valuation to n-1 where n is Length(v)
intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV                                                            [262]
  Copy valuation with the last slope lambda_n changed to s
intrinsic RamificationDegree(v::MacV) -> RngIntElt                                                              [268]
  Ramification degree of a MacLane valuation over the Gauss valuation
intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt                                                         [274]
  Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively
intrinsic MacData(v::MacV) -> SeqEnum                                                                           [293]
  List of tuples [<g_i,lambda_i>] that define a given MacLane valuation
*
* Newton polygons
*
intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum                                                       [314]
  Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g
intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup                                                   [336]
intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup                                                [350]
  Valuation of a rational function f with respect to a MacLane valuation v
intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum                                                      [379]
intrinsic Distance(v,w::MacV) -> FldRatElt                                                                      [446]
*
* Printing in TeX
*
intrinsic TeX(v::MacV) -> MonStgElt                                                                             [470]
  Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names

*
* IMPLEMENTS
*
type MacV
declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(v::MacV, level::MonStgElt)                                                                      [167]
  Print a MacLane valuation v
*
* Creation functions 
*
intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV                                      [179]
intrinsic GaussValuation(D::RngDVR) -> MacV                                                                     [197]
  Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR
intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV                                                  [203]
*
* Basic invariants
*
intrinsic Length(v::MacV) -> RngIntElt                                                                          [223]
  Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)
intrinsic Center(v::MacV) -> RngUPolElt                                                                         [229]
  Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)
intrinsic Degree(v::MacV) -> RngIntElt                                                                          [235]
  Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))
intrinsic Radius(v::MacV) -> FldRatElt                                                                          [241]
  Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)
intrinsic IsGauss(v::MacV) -> BoolElt                                                                           [247]
  True if v is the Gauss valuation
intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt                                                                [253]
  True if v2 extends v1 as a MacLane valuation
intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV                                                               [262]
  Truncate a MacLane valuation to a smaller n <= Length(v)
intrinsic Truncate(v::MacV) -> MacV                                                                             [270]
  Truncate a MacLane valuation to n-1 where n is Length(v)
intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV                                                            [276]
  Copy valuation with the last slope lambda_n changed to s
intrinsic RamificationDegree(v::MacV) -> RngIntElt                                                              [282]
  Ramification degree of a MacLane valuation over the Gauss valuation
intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt                                                         [288]
  Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively
intrinsic MacData(v::MacV) -> SeqEnum                                                                           [307]
  List of tuples [<g_i,lambda_i>] that define a given MacLane valuation
*
* Newton polygons
*
intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum                                                       [328]
  Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g
intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup                                                   [350]
intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup                                                [364]
  Valuation of a rational function f with respect to a MacLane valuation v
intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum                                                      [393]
intrinsic Distance(v,w::MacV) -> FldRatElt                                                                      [460]
*
* Printing in TeX
*
intrinsic TeX(v::MacV) -> MonStgElt                                                                             [484]
  Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names

*
* IMPLEMENTS
*
type MacV
declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(v::MacV, level::MonStgElt)                                                                      [240]
  Print a MacLane valuation v
*
* Creation functions 
*
intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV                                      [252]
intrinsic GaussValuation(D::RngDVR) -> MacV                                                                     [270]
  Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR
intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV                                                  [276]
*
* Basic invariants
*
intrinsic Length(v::MacV) -> RngIntElt                                                                          [296]
  Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)
intrinsic Center(v::MacV) -> RngUPolElt                                                                         [302]
  Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)
intrinsic Degree(v::MacV) -> RngIntElt                                                                          [308]
  Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))
intrinsic Radius(v::MacV) -> FldRatElt                                                                          [314]
  Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)
intrinsic IsGauss(v::MacV) -> BoolElt                                                                           [320]
  True if v is the Gauss valuation
intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt                                                                [326]
  True if v2 extends v1 as a MacLane valuation
intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV                                                               [335]
  Truncate a MacLane valuation to a smaller n <= Length(v)
intrinsic Truncate(v::MacV) -> MacV                                                                             [343]
  Truncate a MacLane valuation to n-1 where n is Length(v)
intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV                                                            [349]
  Copy valuation with the last slope lambda_n changed to s
intrinsic RamificationDegree(v::MacV) -> RngIntElt                                                              [355]
  Ramification degree of a MacLane valuation over the Gauss valuation
intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt                                                         [361]
  Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively
intrinsic MacData(v::MacV) -> SeqEnum                                                                           [380]
  List of tuples [<g_i,lambda_i>] that define a given MacLane valuation
*
* Newton polygons
*
intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum                                                       [401]
  Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g
intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup                                                   [423]
intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup                                                [437]
  Valuation of a rational function f with respect to a MacLane valuation v
intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum                                                      [466]
intrinsic Distance(v,w::MacV) -> FldRatElt                                                                      [533]
*
* Printing in TeX
*
intrinsic TeX(v::MacV) -> MonStgElt                                                                             [557]
  Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names

*
* IMPLEMENTS
*
type MacV
declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(v::MacV, level::MonStgElt)                                                                      [313]
  Print a MacLane valuation v
*
* Creation functions 
*
intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV                                      [325]
intrinsic GaussValuation(D::RngDVR) -> MacV                                                                     [343]
  Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR
intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV                                                  [349]
*
* Basic invariants
*
intrinsic Length(v::MacV) -> RngIntElt                                                                          [369]
  Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)
intrinsic Center(v::MacV) -> RngUPolElt                                                                         [375]
  Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)
intrinsic Degree(v::MacV) -> RngIntElt                                                                          [381]
  Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))
intrinsic Radius(v::MacV) -> FldRatElt                                                                          [387]
  Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)
intrinsic IsGauss(v::MacV) -> BoolElt                                                                           [393]
  True if v is the Gauss valuation
intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt                                                                [399]
  True if v2 extends v1 as a MacLane valuation
intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV                                                               [408]
  Truncate a MacLane valuation to a smaller n <= Length(v)
intrinsic Truncate(v::MacV) -> MacV                                                                             [416]
  Truncate a MacLane valuation to n-1 where n is Length(v)
intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV                                                            [422]
  Copy valuation with the last slope lambda_n changed to s
intrinsic RamificationDegree(v::MacV) -> RngIntElt                                                              [428]
  Ramification degree of a MacLane valuation over the Gauss valuation
intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt                                                         [434]
  Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively
intrinsic MacData(v::MacV) -> SeqEnum                                                                           [453]
  List of tuples [<g_i,lambda_i>] that define a given MacLane valuation
*
* Newton polygons
*
intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum                                                       [474]
  Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g
intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup                                                   [496]
intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup                                                [510]
  Valuation of a rational function f with respect to a MacLane valuation v
intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum                                                      [539]
intrinsic Distance(v,w::MacV) -> FldRatElt                                                                      [606]
*
* Printing in TeX
*
intrinsic TeX(v::MacV) -> MonStgElt                                                                             [630]
  Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names

*
* IMPLEMENTS
*
type MacV
declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2;
*
* Basic type functions
*
intrinsic Print(v::MacV, level::MonStgElt)                                                                      [386]
  Print a MacLane valuation v
*
* Creation functions 
*
intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV                                      [398]
intrinsic GaussValuation(D::RngDVR) -> MacV                                                                     [416]
  Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR
intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV                                                  [422]
*
* Basic invariants
*
intrinsic Length(v::MacV) -> RngIntElt                                                                          [442]
  Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)
intrinsic Center(v::MacV) -> RngUPolElt                                                                         [448]
  Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)
intrinsic Degree(v::MacV) -> RngIntElt                                                                          [454]
  Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))
intrinsic Radius(v::MacV) -> FldRatElt                                                                          [460]
  Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)
intrinsic IsGauss(v::MacV) -> BoolElt                                                                           [466]
  True if v is the Gauss valuation
intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt                                                                [472]
  True if v2 extends v1 as a MacLane valuation
intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV                                                               [481]
  Truncate a MacLane valuation to a smaller n <= Length(v)
intrinsic Truncate(v::MacV) -> MacV                                                                             [489]
  Truncate a MacLane valuation to n-1 where n is Length(v)
intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV                                                            [495]
  Copy valuation with the last slope lambda_n changed to s
intrinsic RamificationDegree(v::MacV) -> RngIntElt                                                              [501]
  Ramification degree of a MacLane valuation over the Gauss valuation
intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt                                                         [507]
  Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively
intrinsic MacData(v::MacV) -> SeqEnum                                                                           [526]
  List of tuples [<g_i,lambda_i>] that define a given MacLane valuation
*
* Newton polygons
*
intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum                                                       [547]
  Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g
intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup                                                   [569]
intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup                                                [583]
  Valuation of a rational function f with respect to a MacLane valuation v
intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum                                                      [612]
intrinsic Distance(v,w::MacV) -> FldRatElt                                                                      [679]
*
* Printing in TeX
*
intrinsic TeX(v::MacV) -> MonStgElt                                                                             [703]
  Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names
*/

/*
Manual
The file provides MacLane valuations on $K[x]$, where $K$ is a field with a discrete valuation. 
This is implemented as a type MacV. As in MacLane's paper, such a valuation $v$ is constructed inductively
from the Gauss valuation $v_0$ on $K[x]$ with repeated assignments $v(g_i)=\lambda_i$ for some key polynomials $g_i$
and rationals $\lambda_i$. 

\par\medskip
See S. MacLane, \emph{A construction for absolute values in polynomial rings}, Trans. Amer. Math. Soc. 40 (1936), 
no. 3, 363--395.
*/

declare type MacV;

declare attributes MacV:           // MacLane valuation v
  D,        // RngDVR
  n,        // valuation length, 0 for Gauss
  g,        // sequence of polynomials [g_1,...,g_n]               ; v(g_i)=lambda_i
  lambda,   // sequence of rationals   [lambda_1,...,lambda_n]     ; e.g. g_1=x, g_2=x^2-p, ...
  e;        // = e(v/v0), ramification index over the Gauss valuation
  

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


intrinsic IsCoercible(v::MacV, y::.) -> BoolElt, .     //
{Coerce a MacLane valuation v (returns false)}
  return false, _;
end intrinsic;


intrinsic 'in'(v::MacV, y::.) -> BoolElt        //
{"in" function for a MacLane valuation v (returns false)}
  return false;
end intrinsic;


function pAdicPolynomialPrint(g)
  R<x>:=Parent(g);
  s:=Sprint(g);
  if Type(BaseRing(R)) in [RngPad,FldPad] then 
    repeat
      s:=DelSpaces(s);
      ok,_,m:=Regexp("(.*)[+]O[(][0-9,^]*[)](.*)",s);
      if not ok then break; end if;
      s:=m[1]*m[2];
    until false;
  end if;
  return s;
end function;


function pAdicPolynomialPrintTeX(g)
  return ReplaceStringFunc(pAdicPolynomialPrint(g),["-","+","$."],["\\!-\\!","\\!+\\!","r"]);
end function;


intrinsic Print(v::MacV, level::MonStgElt)
{Print a MacLane valuation v}
  printf "[";
  for i:=1 to v`n do 
    printf "%o->%o%o",ReplaceStringFunc(pAdicPolynomialPrint(v`g[i]),"$.","r"),v`lambda[i],i eq v`n select "]" else ",";
  end for;    
end intrinsic;


/// Creation functions 


intrinsic MacLaneValuation(D::RngDVR, g::SeqEnum, lambda::SeqEnum) -> MacV
{Create a MacLane valuation from its primary invariants: key polynomials g_i and rationals lambda_i, 
so that v(g_i)=lambda_i}
  v:=New(MacV);
  v`D:=D;
  v`g:=g;
  v`lambda:=[Q!a: a in lambda];
  n:=#g;
  v`n:=n;
    assert n gt 0;
    assert Degree(g[1]) eq 1;
    assert forall{f: f in g | IsMonic(f)}; 
    assert #g eq #lambda;
  v`e:=IsEmpty(lambda) select 1 else Denominator(VectorContent(lambda));
  return v;
end intrinsic;


intrinsic GaussValuation(D::RngDVR) -> MacV
{Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR}
  return MacLaneValuation(D,[<x,0>]) where x is PR(D`K).1;
end intrinsic;


intrinsic MacLaneValuation(D::RngDVR, t::SeqEnum[Tup]) -> MacV
{Create a MacLane valuation from its primary invariants: key polynomials g_i and rationals lambda_i, 
so that v(g_i)=lambda_i. The invariants a given as a sequence t of tuples [<g_i,lambda_i>]}
  return MacLaneValuation(D,[d[1]: d in t],[d[2]: d in t]);
end intrinsic;


/*
Example
R<x>:=PolynomialRing(Q);
D:=DVR(Q,3);
v:=MacLaneValuation(D,[<x,1/2>,<x^2-3,1>]);
v;
TeX(v);
*/


/// Basic invariants


intrinsic Length(v::MacV) -> RngIntElt
{Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)}
  return v`n;
end intrinsic;


intrinsic Center(v::MacV) -> RngUPolElt
{Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)}
  return v`g[v`n];
end intrinsic;


intrinsic Degree(v::MacV) -> RngIntElt
{Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v))}
  return Degree(Center(v));
end intrinsic;


intrinsic Radius(v::MacV) -> FldRatElt
{Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i)}
  return v`lambda[v`n];
end intrinsic;


intrinsic IsGauss(v::MacV) -> BoolElt
{True if v is the Gauss valuation}
  return Length(v) eq 1 and Degree(v) eq 1 and Radius(v) eq 0; 
end intrinsic;


intrinsic Extends(v2::MacV, v1::MacV) -> BoolElt
{True if v2 extends v1 as a MacLane valuation}
  n1:=Length(v1);
  n2:=Length(v2);
  return  (n2 ge n1) and forall{i: i in [1..n1-1] | v2`lambda[i] eq v1`lambda[i]} 
    and (v2`lambda[n1] ge v1`lambda[n1]);
end intrinsic;


intrinsic Truncate(v::MacV, n::RngIntElt) -> MacV
{Truncate a MacLane valuation to a smaller n <= Length(v)}
  if n le 0 then return GaussValuation(v`D); end if;
  if n ge v`n then return v; end if;
  return MacLaneValuation(v`D, v`g[[1..n]], v`lambda[[1..n]]);
end intrinsic;


intrinsic Truncate(v::MacV) -> MacV
{Truncate a MacLane valuation to n-1 where n is Length(v)}
  return Truncate(v,v`n-1);
end intrinsic;


intrinsic ChangeSlope(v::MacV, s::FldRatElt) -> MacV
{Copy valuation with the last slope lambda_n changed to s}
  return MacLaneValuation(v`D, v`g, Append(Prune(v`lambda),s));
end intrinsic;


intrinsic RamificationDegree(v::MacV) -> RngIntElt
{Ramification degree of a MacLane valuation over the Gauss valuation}
  return v`e;
end intrinsic;


intrinsic Monomial(v::MacV, s::FldRatElt) -> RngUPolElt
{Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively}
  D:=v`D;
  e:=v`e;
  error if Denominator(s*e) ne 1, "Monomial: slope not in the value group of v";
  if e eq 1 then              // Gauss: return power of a (suitable) uniformiser
    return (D`pi)^Z!s;
  end if;
  l:=Radius(v);               // Else reduce to v0 inductively 
  vt:=Truncate(v); 
  j:=0;
  while Denominator(s*vt`e) ne 1 do
    j+:=1;
    s-:=l;
  end while;
  return Monomial(vt,s) * Center(v)^j; 
end intrinsic;


intrinsic MacData(v::MacV) -> SeqEnum
{List of tuples [<g_i,lambda_i>] that define a given MacLane valuation}
  return [<v`g[i],v`lambda[i]>: i in [1..v`n]];
end intrinsic;


/*
Example
R<x>:=PolynomialRing(Q);
D:=DVR(Q,3);
v:=MacLaneValuation(D,[<x,1/2>,<x^2-3,1>]);
RamificationDegree(v);
Extends(v,GaussValuation(D));
DelCRs(MacData(v)); //> MacData(v);
Monomial(v,3/2);
*/


/// Newton polygons


intrinsic Expand(f::RngUPolElt, g::RngUPolElt) -> SeqEnum
{Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g}
  R:=Parent(g);
  if f eq 0 then return [R!0]; end if;
  s:=[];
  while f ne 0 do
    q,r:=Quotrem(f,g);
    Append(~s,r);
    f:=q; 
  end while;
  return s;
end intrinsic;


/*
Example
R<x>:=PolynomialRing(Q);
DelCRs(Expand((x^2-2)^3+(x^2-2)+x,x^2-2)); //> Expand((x^2-2)^3+(x^2-2)+x,x^2-2);
*/



intrinsic Valuation(f::RngUPolElt, v::MacV: n:="Full") -> Tup
{Valuation of a polynomial f with respect to a MacLane valuation v, computed inductively 
using the expansion of f in key polynomials of v}
  if n cmpeq "Full" then n:=v`n; end if;
  if n eq 0 then 
    f:=v`D`K!Coefficient(f,0);    // with respect to n=0 f is already constant
    return v`D`v(f);  
  end if;
  c:=Expand(f,v`g[n]);  
  return Min([Valuation(c[i+1],v: n:=n-1) + i*v`lambda[n]: i in [0..#c-1]]);
end intrinsic;



intrinsic Valuation(f::FldFunRatUElt, v::MacV: n:="Full") -> Tup
{Valuation of a rational function f with respect to a MacLane valuation v}
  return Valuation(Numerator(f),v)-Valuation(Denominator(f),v);
end intrinsic;


function LeadingMonomial(f,v: n:=v`n)
  if n eq 0 then 
    c:=Coefficient(f,0);    // with respect to n=0 f is already constant
    vc:=v`D`v(c);  
    if vc eq Infinity() then return <vc,0>; end if;
    return <vc,c>;
  end if;
  c:=Expand(f,v`g[n]);  
  t:=[LeadingMonomial(u,v: n:=n-1): u in c];
  m:=Infinity();
  r:=0;
  for i:=0 to #c-1 do
    vc,rc:=Explode(LeadingMonomial(c[i+1],v: n:=n-1));
    vc+:=i*v`lambda[n];
    if vc lt m then 
      m:=vc;
      r:=rc;
    end if;
  end for;
  return <m,r>;
end function;


intrinsic NewtonPolygon(f::RngUPolElt, v::MacV) -> SeqEnum
{Compute the slopes of the Newton polygon of a polynomial f with respect to a MacLane valuation v 
and relevant monomials (not reduced to the residue field). Returns a list of tuples
  [* <valuation, ramification degree, unreduced coefficients>, ... *]
valuation may be Infinity()}

  error if f eq 0, "NewtonPolygon: zero polynomial"; 

  U<x>:=PolynomialRing(v`D`k);
  c:=Expand(f,v`g[v`n]);
  error if (c[1] eq 0) and (c[2] eq 0), "f is not squarefree";

  if c[1] eq 0 then            // factor of x gives a factor <Inf,x>
    L:=[* <Infinity(),1,[x]> *]; 
    c:=c[[2..#c]];
  else
    L:=[* *];
  end if;

  V:=[Valuation(u,v): u in c]; 
  V:=[<i,V[i+1],LeadingMonomial(c[i+1],v)[2]>: i in [0..#V-1]];      // [<xcoord,ycoord,monomial>]

  // find slopes and vertex indices that give contributions to them -> S

  S:=AssociativeArray();
  for i:=0 to #V-1 do
    if V[i+1][2] eq Infinity() then continue; end if;
    leftslope:=i eq 0 select -Infinity() else Max([(V[i+1][2]-V[j][2])/(V[i+1][1]-V[j][1]): j in [1..i]]); 
    rightslope:=i eq #V-1 select Infinity() else Min([(V[i+1][2]-V[j][2])/(V[i+1][1]-V[j][1]): j in [i+2..#V]]); 
    if leftslope gt rightslope then continue; end if;
    if i ne 0 then 
      if IsDefined(S,leftslope) then Include(~S[leftslope],i); else S[leftslope]:={i}; end if;
    end if;
    if i ne #V-1 then
      if IsDefined(S,rightslope) then Include(~S[rightslope],i); else S[rightslope]:={i}; end if;
    end if;
  end for;

  // Package the answer, incl leading terms

  for s in SortSet(Keys(S)) do
    e:=Denominator(s * v`e);
    i0:=Min(S[s]); 

    r:=PR(v`D`K)!0;
    X:=Parent(r).1;
    for i in S[s] do
      r+:=V[i+1][3]*X^(Z!((i-i0)/e));
    end for;   
    Append(~L,<-s,e,Coefficients(r)>);     // slope, poly in x^e, unreduced coeffs
  end for;

  return L;
end intrinsic;


/*
Example
R<x>:=PolynomialRing(Q);
D:=DVR(Q,3);
v:=MacLaneValuation(D,[<x,1/2>,<x^2-3,1>]);
Valuation(x*(x^2-3),v);
NewtonPolygon(x*(x^2-3),v);
*/



intrinsic Distance(v,w::MacV) -> FldRatElt
{Valuation distance between v and w. The valuations are viewed as defining discoids. 
This function is symmetric, and d(v,v)=lambda_n/deg g_n}
  zw:=Center(w);
  return Min(Radius(w),Valuation(zw,v)/Degree(zw));
end intrinsic;


/*
Example
R<x>:=PolynomialRing(Q);
D:=DVR(Q,3);
v2:=MacLaneValuation(D,[<x,1/2>,<x^2-3,1>]);
v1:=Truncate(v2);
v0:=GaussValuation(D);
Distance(v0,v2);
Distance(v1,v2);
Distance(v2,v2);
*/


/// Printing in TeX


intrinsic TeX(v::MacV) -> MonStgElt
{Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names}
  return Sprintf("v(%o){\\ge}%o",pAdicPolynomialPrintTeX(Center(v)),Radius(v));
end intrinsic;

