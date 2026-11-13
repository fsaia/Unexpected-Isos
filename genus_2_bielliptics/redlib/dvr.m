/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

DVRs and Newton polygons (type RngDVR)

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

type RngDVR:
  K,       // Base field
  k,       // residue field
  v,       // normalised discrete valuation,
  p,       // source prime or prime ideal (only used for constructing unramified extensions)
  red,     // reduction map O_v->k
  lift,    // lifting back k->O_v
  pi;      // uniformiser

*
* IMPLEMENTS
*
type RngDVR
declare attributes RngDVR: 
  K,      // Base field 
  k,      // residue field
  v,      // normalised discrete valuation,
  p,      // source prime or prime ideal (only used for constructing unramified extensions)
  red,    // reduction map O_v->k
  lift,   // lifting back k->O_v
  pi;     // uniformiser
*
* Basic type functions: IsCoercible, in, Print
*
intrinsic Print(D::RngDVR, level::MonStgElt)                                                                    [163]
  Print a RngDVR.
*
* Creation functions
*
intrinsic DVR(K::FldRat, p::RngIntElt) -> RngDVR                                                                [189]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=Q, p=prime number
intrinsic DVR(Z::RngInt, p::RngIntElt) -> RngDVR                                                                [201]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=Z, p=prime number
intrinsic DVR(K::FldNum, p::RngOrdIdl) -> RngDVR                                                                [207]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=number field, p=prime ideal
intrinsic DVR(K::FldNum, p::PlcNumElt) -> RngDVR                                                                [219]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=number field, p=place
intrinsic DVR(K::FldNum, p::RngOrdElt) -> RngDVR                                                                [225]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal
intrinsic DVR(O::RngOrd, p::RngOrdIdl) -> RngDVR                                                                [233]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal
intrinsic DVR(O::RngOrd, p::RngOrdElt) -> RngDVR                                                                [239]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal
intrinsic DVR(K::FldPad) -> RngDVR                                                                              [245]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=p-adic field
intrinsic DVR(O::RngPad) -> RngDVR                                                                              [257]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integers in a p-adic field
intrinsic DVR(K::FldFunRat, p::FldFunRatUElt) -> RngDVR                                                         [263]
  Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for a rational function field in one variable and element p
intrinsic Extend(D::RngDVR, n::RngIntElt) -> RngDVR                                                             [296]
intrinsic Extend(D::RngDVR, F::Fld) -> RngDVR                                                                   [315]
  Make an extension of a DVR to a larger field F. Implemented for rationals, number fields and p-adics
intrinsic BaseDVR(X::Any, P::Any) -> RngDVR                                                                     [343]
intrinsic BaseDVR(X::Any) -> RngDVR                                                                             [372]
*
* Basic invariants
*
intrinsic Eltseq(D::RngDVR) -> .,.,.,.,.,.                                                                      [382]
  return 6 basic invariants K,k,v,red,lift,pi of a RngDVR
intrinsic Field(D::RngDVR) -> Fld                                                                               [388]
  Base field of fractions K for a DVR
intrinsic Valuation(D::RngDVR) -> Map                                                                           [394]
  Underlying discrete valuation v for a DVR
intrinsic ResidueField(D::RngDVR) -> Fld, Map, Map                                                              [400]
  Residue field k for a DVR, reduction map and the lifting map
intrinsic Characteristic(D::RngDVR) -> RngIntElt                                                                [406]
  Characteristic of the field of fractions K for a DVR
intrinsic ResidueCharacteristic(D::RngDVR) -> RngIntElt                                                         [412]
  Characteristic of the residue field k for a DVR
intrinsic Uniformizer(D::RngDVR) -> RngElt                                                                      [418]
  Uniformizer pi for a DVR
intrinsic UniformizingElement(D::RngDVR) -> RngElt                                                              [424]
  Uniformizer pi for a DVR
*
* Reduction and Newton polygons
*
intrinsic Reduce(D::RngDVR, f::RngMPolElt) -> RngMPolElt                                                        [446]
  Reduces the polynomial f modulo the maximal ideal of the DVR D.
intrinsic Reduce(D::RngDVR, f::FldFunRatMElt) -> RngMPolElt                                                     [458]
  Reduces the rational function f modulo the maximal ideal of the DVR D.
intrinsic ValuationsOfRoots(f::RngUPolElt, D::RngDVR) -> SeqEnum                                                [473]
  Valuations of roots of f defined over a RngDVR or its field of fractions
intrinsic NewtonPolygon(f::RngUPolElt, D::RngDVR) -> NwtnPgon                                                   [488]
  Newton polygon of f with respect to a RngDVR
intrinsic ResidualPolynomials(f::RngUPolElt, D::RngDVR) -> SeqEnum, SeqEnum, SeqEnum, SeqEnum                   [496]
  Residual polynomials, Vertices of the (lower) Newton polygon N, slopes(N), lengths(N)
*/

/*
Manual
The file provides basic support for fields with a valuation and DVRs. 
Type RngDVR incorporates a base field $K$, residue field $k$, valuation $v\colon K\to\Z$, 
uniformizer $\pi$, reduction map $O_v\to k$ and its section (lifting map) $k\to O_v$.
*/

declare type RngDVR;
declare attributes RngDVR: 
  K,      // Base field 
  k,      // residue field
  v,      // normalised discrete valuation,
  p,      // source prime or prime ideal (only used for constructing unramified extensions)
  red,    // reduction map O_v->k
  lift,   // lifting back k->O_v
  pi;     // uniformiser

/*
Manual
There is a variety of creation functions of the form DVR(field) and DVR(field, prime) to get DVRs from 
the rational, number fields, p-adics, function fields etc., as well as the function BaseDVR that 
gives an underlying DVR for an object over a field. 

Basic invariants Field, Valuation, ResidueField, Characteristic, ResidueCharacteristic, Uniformizer can be
accessed separately, or at once with an Eltseq function. 

There is basic functionality for valuations of roots, Newton polygons and residual polynomials for a polynomial
over a DVR.
*/


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, Count,
  IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
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


/// Basic type functions: IsCoercible, in, Print


intrinsic IsCoercible(D::RngDVR, y::.) -> BoolElt, .     //
{Coerce a RngDVR.}
  return false, _;
end intrinsic;


intrinsic 'in'(D::RngDVR, y::.) -> BoolElt    //
{"in" function for an RngDVR.}
  return false;
end intrinsic;


intrinsic Print(D::RngDVR, level::MonStgElt)
{Print a RngDVR.}
  printf "DVR K=%o",Sprint(D`K,level);
  if assigned D`p then
    printf " p=%o",Sprint(D`p,level);
  end if;
end intrinsic;


/// Creation functions


function NewDVR(K,k,v,red,lift,pi: p:="none") 
  assert (ISA(Type(K),Fld) /*or Type(K) eq RngSerLaur*/) and ISA(Type(k),Fld);
  D:=New(RngDVR);
  D`K:=K;
  D`k:=k;
  D`v:=v;
  D`red:=red;
  D`lift:=lift;
  D`pi:=pi;
  if p cmpne "none" then D`p:=p; end if;
  return D;
end function;


intrinsic DVR(K::FldRat, p::RngIntElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=Q, p=prime number}
  require IsPrime(p): "p is not a prime number";
  k:=GF(p);
  v:=func<x|Valuation(x,p)>;
  red:=func<x|k!x>;
  lift:=func<x|K!Z!x>;
  pi:=p;
  return NewDVR(K,k,v,red,lift,pi: p:=p);
end intrinsic;


intrinsic DVR(Z::RngInt, p::RngIntElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=Z, p=prime number}
  return DVR(Q,p);
end intrinsic;


intrinsic DVR(K::FldNum, p::RngOrdIdl) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=number field, p=prime ideal}
  require IsPrime(p): "p is not a prime ideal";
  v:=func<x|Valuation(x,p)>;
  k,m:=ResidueClassField(p);
  red:=func<x|m(K!x)>;
  lift:=func<x|K!(x@@m)>;
  pi:=UniformizingElement(p);
  return NewDVR(K,k,v,red,lift,pi: p:=p);
end intrinsic;


intrinsic DVR(K::FldNum, p::PlcNumElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=number field, p=place}
  return DVR(K,Ideal(p));
end intrinsic;


intrinsic DVR(K::FldNum, p::RngOrdElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal}
  P:=ideal<Integers(K)|p>;
  error if not IsPrime(P), "DVR(O,p): p should generate a prime ideal";
  return DVR(K,P);
end intrinsic;


intrinsic DVR(O::RngOrd, p::RngOrdIdl) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal}
  return DVR(FieldOfFractions(O),p);
end intrinsic;


intrinsic DVR(O::RngOrd, p::RngOrdElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integer ring of a number field, p=prime ideal}
  return DVR(FieldOfFractions(O),p);
end intrinsic;


intrinsic DVR(K::FldPad) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for K=p-adic field}
  v:=func<x|Valuation(x)>;
  OK:=Integers(K);   
  k,m:=ResidueClassField(OK);
  pi:=UniformizingElement(OK);  
  red:=func<x|m(OK!x)>;
  lift:=func<x|K!(x@@m)>;
  return NewDVR(K,k,v,red,lift,pi);
end intrinsic;


intrinsic DVR(O::RngPad) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for O=integers in a p-adic field}
  return DVR(FieldOfFractions(O));
end intrinsic;


intrinsic DVR(K::FldFunRat, p::FldFunRatUElt) -> RngDVR
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for a rational function field in one variable and element p}
  require Rank(K) eq 1: "DVR: K must be a rational function field of rank 1";
  OK:=Integers(K);
  pi:=OK!p;  
  v:=func<x|Valuation(x,pi)>;
  k,m:=ResidueClassField(OK,ideal<OK|pi>);
  red:=func<x|m(OK!Numerator(K!x))/m(OK!Denominator(K!x))>;
  lift:=func<x|K!(x@@m)>;
  return NewDVR(K,k,v,red,lift,pi: p:=p);
end intrinsic;


/*
intrinsic DVR(K::RngSerLaur) -> RngDVR //
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for a Laurent series ring in one variable}
  OK:=Integers(K);
  pi:=OK!(K.1);  
  v:=func<x|Valuation(x)>;
  k,m:=ResidueClassField(OK);
  red:=func<x|m(OK!x)>;
  lift:=func<x|K!(x@@m)>;
  return NewDVR(K,k,v,red,lift,pi);
end intrinsic;


intrinsic DVR(O::RngSerPow) -> RngDVR //
{Construct a DVR of type RngDVR(K,k,v,red,lift,pi) for a power series ring in one variable} 
  return DVR(FieldOfFractions(O));
end intrinsic;
*/


intrinsic Extend(D::RngDVR, n::RngIntElt) -> RngDVR
{Make an unramified degree n extension of a DVR of type RngDVR. This assumes that 
the residue field k is finite, and the base field K is p-adic or a number field}
  require IsFinite(D`k): "Residue field must be finite in Extend(D,n)";
  if Type(D`K) eq FldPad then    
    return DVR(ext<D`K|n>);  
  elif Type(D`K) in [FldRat,FldNum] then
    F:=ext<D`K|Polynomial([D`lift(c): c in Coefficients(MinimalPolynomial(ext<D`k|n>.1,D`k))])>;
    OF:=Integers(F);
    P:=Decomposition(OF,D`p);
    assert #P eq 1; // totally unramified
    P:=P[1][1];
    return DVR(F,P);
  else 
    error Sprintf("Extensions of RngDVR with K of type %o are not implemented",Type(D`K));
  end if;
end intrinsic;


intrinsic Extend(D::RngDVR, F::Fld) -> RngDVR
{Make an extension of a DVR to a larger field F. Implemented for rationals, number fields and p-adics}
  implfields:=[FldPad,FldNum,FldRat,FldQuad,FldCyc];
  if Type(D`K) eq FldPad then    
    assert Type(F) eq FldPad;
    return DVR(F);  
  elif Type(D`K) in implfields and Type(F) in implfields then
    OF:=Integers(F);
    P:=Decomposition(OF,D`p)[1][1];
    return DVR(F,P);
  else 
    error Sprintf("Extensions of RngDVR with K->F of type %o->%o are not implemented",Type(D`K),Type(F));
  end if;
end intrinsic;


/*
Example 3-adic valuation on \Q
D:=DVR(Integers(),3);
D;
Field(D);
Extend(D, QuadraticField(-1));
*/


//// Default underlying DVR for an object over a field 


intrinsic BaseDVR(X::Any, P::Any) -> RngDVR
{Guess an underlying DVR from an object X over some field K at a place p: 
the object could be a curve, polynomial, polynomial equation lhs=rhs, for example}
  T:=Type(X);
  error if Type(P) eq MonStgElt and P cmpne "default", Sprintf("BaseDVR: P is a string '%o'<>`default'",P);
  if ISA(T,RelElt) then
    return BaseDVR(LHS(X),P); 
  elif ISA(T,Crv) then                                                  // Curves/polys -> get base field
    return BaseDVR(BaseField(X),P); 
  elif ISA(T,RngUPolElt) or ISA(T,RngMPolElt) then     
    return BaseDVR(BaseRing(Parent(X)),P); 
  end if;    
  if ISA(T,Rng) and not ISA(T,Fld) then
    return BaseDVR(FieldOfFractions(X),P); 
  end if;
  if T in [FldPad,RngPad,RngSerLaur,RngSerPow] then                 // local rings/fields
    error if P cmpne "default", "P should not be specified for K: "*Sprint(T);
    return DVR(X);
  elif not ISA(T,Fld) then                                          // fields from now on
    error "Could not guess the default field for X of type "*Sprint(T);
  elif IsFinite(X) then
    error "BaseDVR failed: K is finite";
  else
    error if P cmpeq "default", "P must be specified for K: "*Sprint(T);
    return DVR(X,P);
  end if;    
end intrinsic;


intrinsic BaseDVR(X::Any) -> RngDVR
{Guess an underlying DVR from an object X over some field K that has a canonical valuation: 
the object could be a curve, polynomial, polynomial equation lhs=rhs, for example}
  return BaseDVR(X,"default");
end intrinsic;


/// Basic invariants


intrinsic Eltseq(D::RngDVR) -> .,.,.,.,.,.
{return 6 basic invariants K,k,v,red,lift,pi of a RngDVR}
  return D`K,D`k,D`v,D`red,D`lift,D`pi;  
end intrinsic;


intrinsic Field(D::RngDVR) -> Fld
{Base field of fractions K for a DVR}
  return D`K;
end intrinsic;


intrinsic Valuation(D::RngDVR) -> Map
{Underlying discrete valuation v for a DVR}
  return D`v;
end intrinsic;


intrinsic ResidueField(D::RngDVR) -> Fld, Map, Map
{Residue field k for a DVR, reduction map and the lifting map}
  return D`k,D`red,D`lift;
end intrinsic;


intrinsic Characteristic(D::RngDVR) -> RngIntElt
{Characteristic of the field of fractions K for a DVR}
  return Characteristic(Field(D));
end intrinsic;


intrinsic ResidueCharacteristic(D::RngDVR) -> RngIntElt
{Characteristic of the residue field k for a DVR}
  return Characteristic(ResidueField(D));
end intrinsic;


intrinsic Uniformizer(D::RngDVR) -> RngElt
{Uniformizer pi for a DVR}
  return D`pi; 
end intrinsic;


intrinsic UniformizingElement(D::RngDVR) -> RngElt
{Uniformizer pi for a DVR}
  return D`pi; 
end intrinsic;


/*
Example
D:=DVR(Rationals(),2);       // 2-adic valuation on Q
D;
K:=Field(D);
v:=Valuation(D);
pi:=Uniformizer(D); 
k,red,lift:=ResidueField(D);
pi^v(K!100);                 // Compute v_2(100)
lift(k!100);                 // Lift 100 from GF(2) to Q
*/


/// Reduction and Newton polygons


intrinsic Reduce(D::RngDVR, f::RngMPolElt) -> RngMPolElt
{Reduces the polynomial f modulo the maximal ideal of the DVR D.}
  n:=Rank(Parent(f));
  cfs,mons := CoefficientsAndMonomials(f);
  exps := [[Degree(m,i): i in [1..n]] : m in mons];    
  cfsred := [D`red(c): c in cfs];
  R:=PolynomialRing(ResidueField(D), n);
  monsred := [&*[R| R.i^e[i]: i in [1..n]]: e in exps];
  return &+[R| cfsred[i]*monsred[i]: i in [1..#cfs]];
end intrinsic;


intrinsic Reduce(D::RngDVR, f::FldFunRatMElt) -> RngMPolElt
{Reduces the rational function f modulo the maximal ideal of the DVR D.}
  num:=Reduce(D, Numerator(f));
  R:=FieldOfFractions(Parent(num));
  den:=Reduce(D, Denominator(f));
  return R!num/R!den;
end intrinsic;


function FakePolynomial(f,D)
  R<x>:=PolynomialRing(Q);
  return &+[(v eq Infinity() select 0 else 2^v where v is D`v(Coefficient(f,i))) * x^i: i in [0..Degree(f)]]; 
end function;


intrinsic ValuationsOfRoots(f::RngUPolElt, D::RngDVR) -> SeqEnum
{Valuations of roots of f defined over a RngDVR or its field of fractions}
  require FieldOfFractions(BaseRing(Parent(f))) eq D`K: 
    "f must be defined over D or its field of fractions";
  return ValuationsOfRoots(FakePolynomial(f,D),2);
end intrinsic;


/*
Example
Q:=Rationals();
R<x>:=PolynomialRing(Q);
ValuationsOfRoots(x^5+x,DVR(Q,2));
*/

intrinsic NewtonPolygon(f::RngUPolElt, D::RngDVR) -> NwtnPgon
{Newton polygon of f with respect to a RngDVR}
  require FieldOfFractions(BaseRing(Parent(f))) eq D`K: 
    "f must be defined over D or its field of fractions";
  return NewtonPolygon(FakePolynomial(f,D),2);
end intrinsic;


intrinsic ResidualPolynomials(f::RngUPolElt, D::RngDVR) -> SeqEnum, SeqEnum, SeqEnum, SeqEnum
{Residual polynomials, Vertices of the (lower) Newton polygon N, slopes(N), lengths(N)}
  K,k,v,red,lift,pi:=Eltseq(D);
  pi:=K!pi;
  require FieldOfFractions(BaseRing(Parent(f))) eq K:
    "f must be defined over D or its field of fractions";
  n:=Degree(f);
  if n eq 0 then return []; end if;
  V:=Sort(LowerVertices(NewtonPolygon(f,D)));
  zero:=V[1][1] ne 0;
  if zero then V:=[<0,V[1][2]>] cat V; end if;
  len:=[Z|V[i+1][1]-V[i][1]: i in [1..#V-1]];
  slope:=[* -(V[i+1][2]-V[i][2])/len[i]: i in [1..#len] *];

  R<x>:=PR(k);
  respoly:=[R|[red(Coefficient(f,Z!(V[i][1]+j*Denominator(slope[i])))/pi^(Z!(V[i][2]-j*Numerator(slope[i])))): 
    j in [0..len[i]]]: i in [1..#len]];

  if zero then slope[1]:=Infinity(); end if;
  return respoly,V,slope,len;
end intrinsic;


/*
Example
Q:=Rationals();
R<x>:=PolynomialRing(Q);
D:=DVR(Q,2);
f:=(x^2-2)*(x^3-2)*x;    // 3 segments
N:=NewtonPolygon(f,D);
N;
Slopes(N);
respoly,vert,slopes,lengths:=ResidualPolynomials(f,D);
slopes;        // slopes of 3 segments
lengths;       // number of roots in each
DelCRs(respoly); //> respoly;       // reduced residual polynomials for each
vert;          // vertices of the newton polygon
*/

