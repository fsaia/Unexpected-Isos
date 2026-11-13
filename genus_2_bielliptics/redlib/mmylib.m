/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

mmylib.m - standard basic functions and abbreviations
*/

/*
Usage: these are not intrinsics, and so have to be imported as follows

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq, VectorProduct,
  Count, IncludeAssoc, IncludeAssocIfNotIsomorphic, SortSet, trim, trimright, Last, DelSpaces, DelSymbols, DelCRs,
  ReplaceStringFunc, ReplaceString, VectorContent, SortBy, SortByFunc, SetAndMultiplicities, MultiSubsets,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted, Left, Swap, TeXPrintParameter,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PermutationsMultiset, writepiece, dxdyToAngle,
  AllPaths, PreferenceOrder, PreferenceOrder2, TeXPolynomial, Rewrite, TikzTransform, IsSubMultiset, VectorAngle,
  TokenSplit, LabelledGraphFromMultigraph, PrintReal, IncidentVertices, SortedEndVertices, StringSplit,
  IntegerPointsOnLineSegment, VectorGCDAndDirection, TeXLatticePolygon, FactorisationQ, TeXMatrix, 
  ConvexHull2D, ConvexHull3D, LowerConvexHull3D, PrintFactor, 
  ComplementToDet1Basis2D, ComplementToDet1Basis3D, ComplementToDet1Basis3D2;
*/

Z:=Integers();
Q:=Rationals();
PR:=PolynomialRing;
RFF:=RationalFunctionField;
exp:=func<sym,n|Sprintf(#Sprint(n) gt 1 select "%o{%o}" else "%o%o",sym,n)>;  // sym = "_" or "^"
Left:=func<s,n|S[[1..Min(#S,n)]] where S is Sprint(s)>;
Right:=func<s,n|S[[Max(1,#S-n+1)..#S]] where S is Sprint(s)>;

IsEvenZ:=func<x|IsCoercible(Z,x/2)>;
IsOddZ:=func<x|IsCoercible(Z,(x-1)/2)>;

procedure Swap(~A,i,j)
  t:=A[i]; A[i]:=A[j]; A[j]:=t;
end procedure;

procedure Rewrite(filename: quiet:=false)   
  Flush(Open(filename,"w"));
end procedure;

procedure writeq(filename,str: rewrite:=false, newline:="\n")
  if rewrite then Rewrite(filename); end if;
  F:=Open(filename,"a");
  WriteBytes(F,[StringToCode(c): c in Eltseq(Sprint(str)*newline)]);
  Flush(F);
end procedure;

procedure writernq(filename,str)
  writeq(filename,str: rewrite:=true, newline:="");
end procedure;

function Count(S,x)                           // Count elements equal to x in S
  if Type(S) in [MonStgElt,ModTupRngElt] then S:=Eltseq(S); end if;
  return #[z: z in S | z eq x];
end function;

procedure IncludeAssoc(~A,i,d: init:={})
  if not assigned A then A:=AssociativeArray(); end if;
  if Type(init) in [SetEnum, SetIndx, SetMulti]
    then add:=Include;
    else add:=Append;
  end if;
  if IsDefined(A,i) 
    then add(~A[i],d); 
    else A[i]:=add(init,d); 
  end if;
end procedure;

procedure IncludeAssocIfNotIsomorphic(~A,i,d: init:={}, same:=IsIsomorphic)
  assert IsEmpty(init);
  if not assigned A then A:=AssociativeArray(); end if;
  if IsDefined(A,i) then 
    if exists{e: e in A[i] | same(d,e)} then return; end if;
    Include(~A[i],d); 
  else 
    A[i]:=Include(init,d); 
  end if;
end procedure;

function SortSet(X)           
  return Sort(SetToSequence(Set(X))); 
end function;

function trim(s) 
  n:=#s;
  while (n ge 2) and (s[n] in [" ","\n"]) do n-:=1; end while;
  f:=1;
  while (f le #s) and (s[f] in [" ","\n"]) do f+:=1; end while;
  if (f eq 1) and (n eq #s) then return s; end if;
  return s[[f..n]];
end function;

function trimright(s) 
  n:=#s;
  while (n ge 1) and (s[n] in [" ","\n"]) do n-:=1; end while;
  return s[[1..n]];
end function;

function Last(v)
  if Type(v) in [SeqEnum,List,SetIndx,Tup] then return v[#v]; end if;
  if HasSignature("Eltseq",[Type(v)]) then 
    w:=Eltseq(v); return w[#w]; 
  end if;
  error "Last: unrecognised type";
end function;

function DelSymbols(s,delsymb) 
  if Type(s) ne MonStgElt then s:=Sprint(s); end if;
  if Type(delsymb) eq MonStgElt then delsymb:=Eltseq(delsymb); end if;  
  s:=[c: c in Eltseq(s) | not (c in delsymb)];
  return IsEmpty(s) select "" else &cat s;
end function;

function DelSpaces(s)    // delete spaces from a string s
  return DelSymbols(s," \n");
end function;

DelCRs:=func<s|&cat([x: x in Eltseq(Sprint(s)) | x ne "\n"])>; // delete \n's

function ReplaceStringFunc(s,fs,ts)
  if Type(s) ne MonStgElt then s:=Sprint(s); end if;
  if Type(fs) eq SeqEnum then
    for i:=1 to #fs do
      s:=ReplaceStringFunc(s,fs[i],ts[i]);
    end for;
    return s;
  end if;
  return SubstituteString(s,fs,ts);
end function;

procedure ReplaceString(~s,fs,ts)
  s:=ReplaceStringFunc(s,fs,ts);
end procedure;

function VectorContent(v)
  den:=LCM([Denominator(x): x in v]);
  v:=[Z!(den*x): x in v];
  gcd:=GCD(v);
  if gcd eq 0 then return 0; end if;
  v:=[x div gcd: x in v];
  return gcd/den,v;
end function;

procedure SortBy(~L,f: sign:=1)
  if Type(L) eq SetEnum then
    L:=SetToSequence(L);
  end if;
  Sort(~L,func<a,b|fa lt fb select -sign else (fa eq fb select 0 else sign)
                   where fa is f(a) where fb is f(b)>);
end procedure;                

function SortByFunc(L,f: sign:=1)
  if Type(L) eq SetEnum then
    L:=SetToSequence(L);
  end if;
  return Sort(L,func<a,b|fa lt fb select -sign else (fa eq fb select 0 else sign)
                   where fa is f(a) where fb is f(b)>);
end function;                

procedure SortByPerm(~L,f,~perm: sign:=1)
  if Type(L) eq SetEnum then
    L:=SetToSequence(L);
  end if;
  Sort(~L,func<a,b|fa lt fb select -sign else (fa eq fb select 0 else sign)
                   where fa is f(a) where fb is f(b)>,~perm);
end procedure;                

function SetAndMultiplicities(X)
  S:=[x: x in Set(X)];
  M:=[Multiplicity(X,x): x in S];
  return S,M;
end function;

function GetQAttribute(attrname, init)
  Q:=Rationals();
  if attrname notin GetAttributes(FldRat) then
    AddAttribute(FldRat,attrname);
  end if;
  if not assigned Q``attrname then
    if Type(init) in [UserProgram,Intrinsic] then init:=init(); end if;
    Q``attrname:=init;
  end if;
  return Q``attrname;
end function;

procedure SetQAttribute(attrname, value)
  Q:=Rationals();
  if attrname notin GetAttributes(FldRat) then
    AddAttribute(FldRat,attrname);
  end if;
  Q``attrname:=value;
end procedure;

function PrintSequence(L: sep:=", ", mult:="^^%o", prfun:=Sprint, br:=false, d:=false, empty:="")    
  if IsEmpty(L) then return empty; end if;
  if Type(L) eq SetEnum then L:=SortSet(L); end if;
  if Type(L) eq SetMulti then L:=Sort([a: a in L]); end if;
  
  if (prfun cmpeq Sprint) and d then prfun:=DelSpaces; end if;
  if   (br cmpeq true) or br cmpeq "[" then obr:="["; cbr:="]"; 
  elif br cmpeq "("                    then obr:="("; cbr:=")"; 
  elif br cmpeq "{"                    then obr:="{"; cbr:="}"; 
                                       else obr:=""; cbr:="";              
  end if;
  if IsEmpty(L) then return obr*cbr; end if;
  if Type(L) eq SetMulti then 
    S,M:=SetAndMultiplicities(L);
    L:=[prfun(S[i])*(M[i] eq 1 select "" else Sprintf(mult,M[i])): i in [1..#S]];
    prfun:=Sprint;
  end if;
  return obr*&cat[prfun(L[i]) * (i eq #L select "" else sep): i in [1..#L]]*cbr;
end function;

function HirzebruchJung(r1,r2)                             
  // Shortest 1-path between rational numbers r1>=r2,
  // r1=n1/d1 > n2/d2 > ... > ni/di = r2 with all ni*d(i+1)-n(i+1)*di=1, e.g. 1/2 > 1/3 > 1/4
  // returns r1,r2 as part of the path (unless r1=r2, in which case returns [r1])
  // for various bits see Obus-Wewers arxiv 1805.09709v3
  error if r1 lt r2, "Expected r1>=r2";     // r1 >= r2 
  if r1 eq r2 then return [r1]; end if;
  I1:=Floor(r1);  
  I2:=Ceiling(r2); 
  if I1 gt I2 or (I1 eq I2 and #{r1,r2,I1} eq 3)  then     // integers in between 
    P1:=HirzebruchJung(r1,I1);
    if I1 eq I2 then P1:=Prune(P1); end if;
    PM:=[Q|n: n in [I1-1..I2+1 by -1]];
    P2:=HirzebruchJung(I2,r2);
    return P1 cat PM cat P2;
  end if;  
  I3:=Floor(r2);
  if I3 ne 0 then      // shift to [0,1]
    return [d+I3: d in HirzebruchJung(r1-I3,r2-I3)]; 
  end if;
  if r2 ne 0 then      // invert; decreases denominators and hence terminates
    return [1/d: d in Reverse(HirzebruchJung(1/r2,1/r1))];
  end if;
  L:=[r1];
  repeat               // go down to 0 with Euclid
    c:=Numerator(Last(L));
    d:=Denominator(Last(L));
    b:=InverseMod(c,d);
    a:=(b*c-1) div d;
    Append(~L,a/b);
  until a eq 0;
  return L;
end function;

function Dotted(s, n)
// Print s as sdfjdfkjsk...sdk for long strings
  s:=Type(s) eq MonStgElt select s else Sprint(s); 
  if #s le n then return s; end if;
  return s[[1..n-6]]*"..."*s[[#s-2..#s]];
end function;

function PolynomialFit(v,d)
// Recognises a polynomial function in n variables of total degree d by a set of values
// v=[<x1,...,xn>,f(x1,...,xn)]
// return false,-1 if degree too low, and false,0 if not enough values, f,1 if ok
  Q:=FieldOfFractions(Parent(v[1][2]));
  n:=#(v[1][1]);
  R<[z]>:=PR(Q,n);
  mons:=&join[MonomialsOfDegree(R,j): j in [0..d]];
  mat:=Matrix(Q,[[Evaluate(m,d[1]): m in mons]: d in v]);
  vec:=Vector(Q,[d[2]: d in v]);
  vprintf LSeries,1: "%o vectors %o monomials (deg %o)\n",#v,#mons,d;
  ok,sol,ker:=IsConsistent(Transpose(mat),vec);
  if not ok then return false,-1; end if;
  if Dimension(ker) ne 0 then return false,0; end if;
  return &+[Eltseq(sol)[i]*mons[i]: i in [1..#mons]],1;
end function;

function VertexChainToSequence(G,p)      // Convert a chain or a loop to sequence of vertices
  V:=Vertices(G);
  assert not IsEmpty(p);
  if #p eq 1 then return SortSet(EndVertices(p[1])); end if;
  e:=func<i|EndVertices(p[i])>;
  return [Representative(e(i) diff e(i+1)): i in [1..#p-1]] cat [Representative(e(#p) meet e(#p-1))] cat 
    [Representative(e(#p) diff e(#p-1))];
end function;

function GraphLongestChain(G)
  // Longest path as a sequence of edges
  V:=Vertices(G);
  maxp:=[];
  for i->v1 in V, j->v2 in V do 
    if i ge j then continue; end if;
    p:=ShortestPath(v1,v2);
    if #p le #maxp then continue; end if;
    maxp:=p;
  end for;
  p:=maxp;
  if IsEmpty(p) then return [V[1]]; end if;
  return VertexChainToSequence(G,p);  
end function;

function AllPaths(G,i,j: M:="uncomputed")   // All paths in a graph from G.i to G.j of shortest length (M=DistanceMatrix(G))
  if i eq j then return [[i]]; end if;
  if M cmpeq "uncomputed" then M:=DistanceMatrix(G); end if;
  V:=VertexSet(G);
  m:=M[i,j];
  v:=V.i;
  N:=[n: n in Neighbours(v) | M[Index(n),j] eq m-1];
  return [[i] cat p: p in AllPaths(G,Index(n),j: M:=M), n in N];
end function;

function PreferenceOrder(C,f)     // Sort C by the weight function f, and return order of every element,
  v:=[f(a): a in C];              // so that the minimal elements have order 1, next ones order 2, etc.
  s:=SortSet(v);
  return [Position(s,a): a in v];
end function;

function PreferenceOrder2(C,f)    // Sort 2-dim array C by the weight function f, and return order of every element,
  v:=[[f(a): a in c]: c in C];    // so that the minimal elements have order 1, next ones order 2, etc.
  s:=SortSet(&cat v);
  return [[Position(s,a): a in c]: c in v];
end function;


procedure TeXDollarAndExponents(~s)
  if Position(s,"$") ne 0 then 
    ReplaceString(~s,"$.1","\\alpha ");
    ReplaceString(~s,"$.2","\\beta ");
    ReplaceString(~s,"$.3","\\gamma ");
  end if;
  ReplaceString(~s,"^","!");
  repeat
    ok,b,c:=Regexp("[!]([0-9][0-9]+)",s);
    if not ok then break; end if;
    ReplaceString(~s,b,"^{"*c[1]*"}");
  until false;
  ReplaceString(~s,"!","^"); 
end procedure;

function TeXPolynomial(f: vnames:="default", vorder:="default", cfprint:=Sprint)
  
  if Type(f) in [FldFunRatUElt,FldFunRatMElt] then
    num:=TeXPolynomial(Numerator(f): vnames:=vnames, vorder:=vorder, cfprint:=cfprint);
    den:=TeXPolynomial(Denominator(f): vnames:=vnames, vorder:=vorder, cfprint:=cfprint);
    if den eq "1" then return num; end if;
    if exists{c: c in Eltseq(num) | c in ["*","+","/","-"]} then num:="("*num*")"; end if;
    if exists{c: c in Eltseq(den) | c in ["*","+","/","-"]} then num:="("*den*")"; end if;
    return Sprintf("%o/%o",num,den);
  end if;
          
  R<[v]>:=Parent(f);
  if vorder cmpeq "default" then 
    vorder:=[1..#v];
  end if;
  if vnames cmpeq "default" then 
    vnames:=[Sprint(R.i): i in [1..#v]];
  end if;
  s:="";
  x:=vorder[1];
  for i:=Degree(f,x) to 0 by -1 do
    c:=Coefficient(f,x,i);
    if c eq 0 then continue; end if;
    if #vorder eq 1 
      then cs:=cfprint(c);
      else cs:=TeXPolynomial(c: vnames:=vnames, vorder:=vorder[[2..#vorder]], cfprint:=cfprint);
    end if;
    if (Position(cs,"+") ne 0 or Position(cs[[2..#cs]],"-") ne 0) and (i gt 0) then
      cs:="("*cs*")";
    end if;
    if cs eq "1" then cs:=""; end if;
    if cs eq "-1" then cs:="-"; end if;
    if i ne 0 then cs*:=vnames[x]; end if;
    lbr:=i gt 9 or i lt 0 select "{" else "";
    rbr:=i gt 9 or i lt 0 select "}" else "";
    if i gt 1 then cs*:="^"*lbr*Sprint(i)*rbr; end if;
    if cs eq "" then cs:="1"; end if;
    if cs eq "-" then cs:="-1"; end if;
    if s eq "" then s:=cs; else s*:=(cs[1] eq "-" select "" else "+")*cs; end if;
  end for;
  TeXDollarAndExponents(~s);
  return s;
end function;


function TikzTransform(s,r,phi: prec:=2)
  // Scale by r and rotate by phi (degrees) a tikz picture in s
  // Affects (A) numeric positions (0.23,-0.12) and (B) anchor strings anchor=west

  error if Type(s) ne MonStgElt, "RotateTikz: Expected a tikz string in s";

  t:="";                               // accummulated output
  rad:=phi*Pi(RealField())/180;

  // Stage 1: Rotate numeric positions (x,y)
  repeat
    ok,_,B:=Regexp("(.*)[(](-?[.0-9]+),(-?[.0-9]+)[)](.*)",s);
    if not ok then t:=s*t; break; end if;
    x:=eval B[2];
    y:=eval B[3];
    xnew:=r*x*Cos(rad)-r*y*Sin(rad);
    ynew:=r*x*Sin(rad)+r*y*Cos(rad);
    t:=Sprintf("(%o,%o)%o%o",RealField(prec)!xnew,RealField(prec)!ynew,B[4],t);
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


function TokenSplit(s,syms: trimtokens:=false)    // e.g. s="#max+b--c", syms="#a-z" -> [ "#max", "+", "b", "--", "c"]
  L:=[];
  s:=trim(s);
  repeat
    ok,_,b:=Regexp("(.*[^"*syms*"])(["*syms*"]+)(.*)",s);
    if not ok then break; end if;
    L cat:= [b[3],b[2]];
    s:=b[1];
  until false;
  ok,_,b:=Regexp("(["*syms*"]+)([^"*syms*"]+)",s);
  if ok  
    then L:=Reverse(L cat [b[2],b[1]]);
    else L:=Reverse(L cat [s]);
  end if;
  if trimtokens
    then return [s: t in L | #s ne 0 where s is trim(t)];
    else return [t: t in L | #t ne 0];
  end if;
end function;


function LabelledGraphFromMultigraph(V,E)
  // Given a multigraph G defined by 
  //   V = sequence of vertex labels
  //   E = sequence of [i,j,label] for edges {i,j} with labels
  // returns a labelled graph F which determines G up to isomorphism
  // Example:
  // C1:=LabelledGraphFromMultigraph([1,2,3],[[1,2,-3],[2,3,-1],[1,3,-2]]);
  // C2:=LabelledGraphFromMultigraph([2,3,1],[[1,2,-1],[2,3,-2],[1,3,-3]]);  // rotated version
  // IsIsomorphic(C1,C2);
  n:=#V;
  error if not IsEmpty(Set(V) meet {e[3]: e in E}), "Vertex and edge labels must be disjoint";
  F:=Graph<n|>;
  AssignLabels(VertexSet(F),V);
  for i->e in E do  
    v1,v2,elabel:=Explode(e);
    AddVertex(~F,elabel);
    AddEdge(~F,n+i,v1);
    AddEdge(~F,n+i,v2);
  end for;
  return F;
end function;


function PrintReal(x: prec:=28)
  if Type(x) eq MonStgElt then return x; end if;
  if Abs(x) lt 10^-prec then return "0"; end if;
  x:=RealField()!x; 
  s:=Sprint(x);
  error if Position(s,"E") ne 0, "Floating point representation with exponent is not implemented";
  p:=Position(s,".");
  if p ne 0 then s:=Left(s,p+prec); end if;
  n:=#s;
  while (n gt 1) and (s[n] eq "0") do n-:=1; end while;
  if (n gt 1) and (s[n] eq ".") then n-:=1; end if;
  return s[[1..n]];
end function;


function IncidentVertices(v) 
  return {Representative(EndVertices(e) diff {v}): e in IncidentEdges(v)};
end function;


function SortedEndVertices(e: index:=false)
  v1,v2:=Explode(SetToSequence(EndVertices(e)));
  if Index(v1) le Index(v2) 
    then if index then return Index(v1),Index(v2); else return v1,v2; end if;
    else if index then return Index(v2),Index(v1); else return v2,v1; end if;
  end if;
end function;


procedure multiset_permutations(L, index, ~out)   // courtesy of ChatGPT 3.5
  if index eq #L then
    Append(~out,L); return;
  end if;
  used := {};     // Keep track of used elements to avoid repetitions
  for i in [index..#L] do
    if not L[i] in used then
      Swap(~L,index,i);      // Swap current element with i-th element
      multiset_permutations(L, index+1, ~out);  // Recur for next index
      Swap(~L,index,i);      // Undo the swap
      Include(~used,L[i]);   // Add L[i] to used
    end if;
  end for;
end procedure;


function PermutationsMultiset(S)
// List of all possible permutations of S, as a sequence of sequences, e.g. PermutationsMultiset({*1,1,1,2*}) -> 4 of them
  S:=[d: d in S];
  out:=[];
  multiset_permutations(S, 1, ~out);
  return out;
end function;


function IsSubMultiset(X,Y) 
// true if X is a subset of Y (both multisets)
  error if {Type(X),Type(Y)} ne {SetMulti}, "IsSubMultiset: X and Y should be multisets";
  return IsEmpty(X diff Y);
end function;


function StringSplit(s,P)
// Split a string into blocks [ [* type index, extracts *], ...] using an ordered sequence of patterns that describe types,
// e.g. P=[<mInt,"([0-9]+)">, <mEdgeSym,"([-=<>])">, ... ; used in ReductionType from string label
  L:=[];
  repeat
    found:=false;
    for d in P do
      ok,_,B:=Regexp("^"*d[2]*"(.*)$",s);
      if not ok then continue; end if;
      found:=true;
      Append(~L,[* d[1] *] cat [* B[i]: i in [1..#B-1] *]);
      s:=B[#B];
      break;    
    end for;
    error if not found, "StringSplit: could not match "*s;
  until #s eq 0;
  return L;
end function;


function TeXPrintParameter(s: tex:=true, sym:="", plainsym:="", texsym:="", printempty:=true)
  s:=Sprint(s);
  if #s eq 0 and not printempty then return ""; end if;
  sym:=sym eq "" select (tex select texsym else plainsym) else sym;
  par:=tex and #s gt 1 select "{"*s*"}" else s;
  return sym*par;
end function;


function MultiSubsets(multiset)    // Sequence of all multi-subsets of a given multiset 

  unique_elements := SetToSequence(Set(multiset));                          // unique elements 
  multiplicities := [Multiplicity(multiset,x): x in unique_elements];       // and their multiplicities
  out := [{**}];                           // Initialize the result with the empty multiset

  for i->elem in unique_elements do        // Iterate through each unique element and its multiplicity
    multiplicity := multiplicities[i];  
    current_subsets := [];                 // Generate all possible counts of the current element in the subsets
    for count in [0..multiplicity], S in out do
      current_subsets cat:= [S join {*elem^^count*}];     // Append the current count of the element to each S
    end for;
    out := current_subsets;                // Update the result with the new subsets including the current element
  end for;

  return out;
end function;


function writepiecestr(src,S,fromanchor,toanchor: filename:="")
  F:=Split(src:IncludeEmpty);
  fp:=Position(F,fromanchor);
  if fp eq 0 then error Sprintf("%o anchor not found%o",fromanchor,filename); end if;
  tp:=Position(F,toanchor,fp);
  if tp eq 0 then error Sprintf("%o anchor not found%o after %o",toanchor,filename,fromanchor); end if;
  F1:=PrintSequence(F[[1..fp]]: sep:="\n")*"\n";
  if Type(S) eq SeqEnum then S:=PrintSequence(S: sep:="\n"); end if;
  if Type(S) ne MonStgElt then S:=Sprint(S); end if;
  if #S ne 0 and Last(S) ne "\n" then S*:="\n"; end if;
  F3:=PrintSequence(F[[tp..#F]]: sep:="\n");
  return F1*S*F3*"\n";
end function;


procedure writepiece(filename,S,fromanchor,toanchor) 
  s:=writepiecestr(Read(filename),S,fromanchor,toanchor: filename:=" in "*filename);
  writernq(filename,s); 
end procedure;


function dxdyToAngle(dx,dy)
  if dx lt 0 then return 180+dxdyToAngle(-dx,-dy); end if;
  if Abs(dx) le Abs(dy)/10000 then return dy gt 0 select 90 else 270; end if;
  return Arctan(dy/dx)/Pi(RealField())*180;
end function;


function VectorAngle(v)
  /*
  Angle 0<=angle<2*Pi of a vector v in R^2
  */
  C:=ComplexField();
  z:=C!Eltseq(v);
  return Arg(z);
end function;


function VectorGCDAndDirection(v)
  /*
  gcd (=number of segments), (x_primitive,y_primitive) for an integer vector v in Z^2
  */
  x,y:=Explode(Eltseq(v));
  gcd:=GCD(x,y);
  return gcd,Parent(v)![x div gcd,y div gcd];
end function;
  

function IntegerPointsOnLineSegment(p1, p2)
  /*
  All integer points on a line segment from a vertex p1 to p2, including corners
  */
  gcd,v:=VectorGCDAndDirection(p2-p1);
  return [p1+i*v: i in [0..gcd]];
end function;


function TeXLatticePolygon(V:                              // Sequence of TorLatElt's
    scale:=0.4,                                            // Master scale
    xscale:=1, yscale:=1,                                  // Additional x,y stretch
    gridstyle:="color=black!50",                           // Grid for Z^2
    extgrid:=0,                                            // Extended on all sides by extgrid if necessary
    pointstyle:="circle, fill=black, inner sep=1.5pt",     // Integer points on the lines
    edgestyle:="line width=1pt",                           // Segments between them
    red:={},                                               // Points to be drawn in red (and segments from them)
    edgestylefunc:="none"                                  // Function v1,v2 -> segment style string, on top of edgestyle
  )
  /*
  Draw a convex polygon given by a set of integer vertices in tikz.
  */

  V:=[ToricLattice(2)| v: v in V];
  red:={ToricLattice(2)| v: v in red};

  // Orient vertices counterclockwise
  center:= &+V /#V;
  SortBy(~V,func<v|VectorAngle(v-center)>);
  red:={Universe(V)| P: P in red};

  // Find the range of x and y for the grid
  minX := Min([Eltseq(v)[1] : v in V])-extgrid;
  maxX := Max([Eltseq(v)[1] : v in V])+extgrid;
  minY := Min([Eltseq(v)[2] : v in V])-extgrid;
  maxY := Max([Eltseq(v)[2] : v in V])+extgrid;

  // Collect all integer points on the polygon's edges, and sort them counterclockwise
  P:=SetToSequence(&join {Set(IntegerPointsOnLineSegment(V[i],V[(i mod #V)+1])): i in [1..#V]});
  SortBy(~P,func<v|VectorAngle(v-center)>);

  // Generate TikZ code
  tikz := Sprintf("\\begin{tikzpicture}[xscale=%o,yscale=%o,grid/.style={%o},edges/.style={%o},point/.style={%o}]\n",
    PrintReal(scale*xscale),PrintReal(scale*yscale),gridstyle,edgestyle,pointstyle);

  // Draw the dotted grid
  tikz*:=Sprintf(
  "\\foreach \\x in {%o,...,%o}\n"*
  "\\foreach \\y in {%o,...,%o}\n"*
  "{\n"*
  "  \\fill[grid] (\\x,\\y) circle (2pt);\n"*
  "}\n",minX,maxX,minY,maxY);

  // Draw the polygon edges
  for i->v1 in P do
    v2:=P[i mod #P + 1];
    if edgestylefunc cmpne "none" 
      then style:=edgestylefunc(v1,v2);
      else style:=v1 in red or v2 in red select "red" else "";
    end if;
    if #style ne 0 and style[1] ne "," then style:=","*style; end if;
    tikz *:= Sprintf("\\draw[edges%o] (%o,%o) -- (%o,%o);\n",
      style,Eltseq(v1)[1],Eltseq(v1)[2],Eltseq(v2)[1],Eltseq(v2)[2]);
  end for;

  // Draw thick dots at integer points on edges
  for v in P do
    style:=v in red select ",red" else "";
    tikz *:= Sprintf("\\node[point%o] at (%o, %o) {};\n", style, Eltseq(v)[1], Eltseq(v)[2]);
  end for;

  tikz *:= "\\end{tikzpicture}";

  return tikz;
end function;


function FactorisationQ(x)
  fnum:=Factorisation(Numerator(x));
  fden:=Factorisation(Denominator(x));
  return fnum cat [<d[1],-d[2]>: d in fden];
end function;


function TeXMatrix(M: env:="pmatrix")
  // Returns the TeX representation of the matrix M using the specified environment (default: pmatrix).
  r := NumberOfRows(M);
  c := NumberOfColumns(M);                   // Dimensions
  rows := [];                                // Convert to TeX
  for i in [1..r] do
    Append(~rows, Join([Sprint(M[i, j]) : j in [1..c]], " & "));
  end for;
  return Sprintf("\\begin{%o}\n%o\n\\end{%o}", env, Join(rows, " \\\\ \n"), env);    // Return as string 
end function;


// Lower convex hull in 3D


function LCHVectorAngle(v)      // Angle 0<=angle<2*Pi of a vector v in R^2
  return Arg(ComplexField()!v);
end function;

function LCHPointsToVector(p1,p2)          // Vector [x,y,z] from P1 to P2 in 2D or 3D
  assert #p1 eq #p2 and #p1 in [2..3];
  return [p2[i]-p1[i]: i in [1..#p1]];
end function;

function LCHInner(v1,v2)       // LCHInner product of vectors v1 and v2 in 2D or 3D
  assert #v1 eq #v2 and #v1 in [2..3];
  return &+[v1[i]*v2[i]: i in [1..#v1]];
end function;

function LCHOuter(v1,v2)       // LCHOuter (cross) product of vectors v1=[x1,y1,z1] and v2=[x2,y2,z2] in 3D
  return [v1[2]*v2[3] - v1[3]*v2[2], v1[3]*v2[1] - v1[1]*v2[3], v1[1]*v2[2] - v1[2]*v2[1]];
end function;

function LCHAreOnTheSameLine(p1,p2,p3)             // Check whether three points in 3D are on the same line
  return LCHOuter(LCHPointsToVector(p1,p2),LCHPointsToVector(p1,p3)) eq [0,0,0];
end function;

function LCHHyperplane(p1,p2,p3)
  // Compute n and c so that v.n=c is the hyperplane through p1,p2,p3; oriented
  v1 := LCHPointsToVector(p1, p2); 
  v2 := LCHPointsToVector(p1, p3); 
  n := LCHOuter(v1, v2);
  _, n := VectorContent(n);                 // make primitive
  c := LCHInner(n, p1);
  return n, c;
end function;

function LCHConvexHull2D(P)
  // Indices of vertices of the 2D convex hull of points P=[[x1, y1], ...]
  POrg:=P;
  Sort(~P);                        // Sort points lexicographically by x and then by y-coordinate
  L := []; // Lower hull
  for i in [1..#P] do
    while #L ge 2 and Determinant(Matrix([LCHPointsToVector(P[L[#L-1]], P[L[#L]]), LCHPointsToVector(P[L[#L]], P[i])])) le 0 do
      Remove(~L, #L);  // Backtrack
    end while;
    Append(~L, i);
  end for;
  U := []; // Upper hull
  for i in [#P..1 by -1] do
    while #U ge 2 and Determinant(Matrix([LCHPointsToVector(P[U[#U-1]], P[U[#U]]), LCHPointsToVector(P[U[#U]], P[i])])) le 0 do
      Remove(~U, #U);  // Backtrack
    end while;
    Append(~U, i);
  end for;
  // Concatenate lower and upper hulls, removing the last point of each list because it's repeated
  // Return original indices
  return [Position(POrg,P[i]): i in L cat U[2..#U-1]];
end function;

function LCHComputeFace(P,i1,i2,i3)
  // Given three indices of points in P, compute the face containing P[i1], P[i2], P[i3]
  // Step 1: Verify that the given points are not collinear
  // Step 2: Find the hyperplane n.v=c containing the 3 points such that normal vector n has 3rd coordinate n_z>0
  //         if n_z<0 change n to -n, c to -c; if n_z=0, raise an error
  // Step 3: Find all indices of points i1,i2,...,ik that lie on the hyperplane
  // Step 4: Sort them so that their projections onto xy plane go counterclockwise
  // Step 5: Check that all points in P have LCHInner(n,p) ge c
  // Step 6: return <[i1,..,ik],n,c>
  
  // Step 1 and 2: compute hyperplane H: v.n=c
  n,c:=LCHHyperplane(P[i1],P[i2],P[i3]);
  if n[3] lt 0 then 
    n := [-x: x in n]; 
    c := -c; 
  elif n[3] eq 0 then 
    error "LCHComputeFace: Points are colinear";    
  end if;
  
  I := [i: i->p in P | LCHInner(n, p) eq c];     // Step 3: I = indices of all points on H
  I := I[LCHConvexHull2D([p[[1..2]]: p in P[I]])];
  error if #I lt 3, "Internal error: got a face with <3 vertices";

  C:=[&+[P[i][j]: i in I]/#I: j in [1..3]];
  
  angle:=func<i|LCHVectorAngle(LCHPointsToVector(C,P[i])[[1..2]])>;
  SortBy(~I, angle);                          // Step 4: Sort points counterclockwise based on their projection onto the xy-plane

  // Step 5 
  error if exists(p){p: p in P | LCHInner(n,p) lt c}, 
    Sprintf("Point %o is below the asserted face on indices %o,%o,%o (n=%o c=%o)",p,i1,i2,i3,DelSpaces(n),c);
  
  // Step 6 
  return <I, n, c>;
end function;

function LCHPointWithSmallest(P, f)
  // Find index i of a point p in P which minimises f(p) or -1 if f(p) is always Infinity()
  min_value := f(P[1]);
  min_index := 1;
  for i in [2..#P] do
    current_value := f(P[i]);
    if current_value lt min_value then
      min_value := current_value;
      min_index := i;
    end if;
  end for;
  if min_value eq Infinity() then min_index:=-1; end if;
  return min_index, min_value;
end function;

function LCHPointSlope(p1,p2)
  // Slope of the vector [x,y,z] from p1 to p2 defined as sgn(z)*z^2/(x^2+y^2)
  v := LCHPointsToVector(p1, p2);
  xynorm := v[1]^2 + v[2]^2;
  return xynorm eq 0 select Infinity() else v[3] * Abs(v[3]) / xynorm;
end function;

function LCHEdgeSlope(p1,p2,p3)
  // Slope of the plane through p1,p2,p3 defined as follows: 
  // a) let H: v.n=c be the oriented hyperplane through p1,p2,p3
  // b) Project the edge p1-p2 onto xy plane, and find a point Q in Z^2 right of the edge, 
  //    by rotating the edge by 90 degrees and adding it to one of the vertices
  // then the slope is the 3rd coordinate z of the unique point [Q[1],Q[2],z] on H
  v := LCHPointsToVector(p1, p2);
  orth := [v[2],-v[1]];
  Q := [p1[1] + orth[1], p1[2] + orth[2]];
  if LCHInner(LCHPointsToVector(p1, p3)[[1..2]], orth) le 0 then return Infinity(); end if;   // Check p3 on the same side as Q
  n, c := LCHHyperplane(p1, p2, p3);
  if n[3] eq 0 then return Infinity(); end if;
  return (c - n[1]*Q[1] - n[2]*Q[2]) / n[3];
end function;

function LCHCompleteToDet1Basis(v)
  assert GCD(v) eq 1;    
  M := Transpose(Matrix(1, 3, Eltseq(v)));
  S, P, Q := SmithForm(M);                       // P*M*Q = S = [1] or [-1]
  if Q[1][1] eq -1 then P:=-P; end if;
  B := P^-1;
  if Determinant(B) eq -1 then
    B*:=DiagonalMatrix([1,1,-1]); 
  end if;
  assert Determinant(B) eq 1;
  assert Eltseq(Transpose(B)[1]) eq Eltseq(v);
  return B;
end function;

function ConvexHull2D(P)
  // Convex hull of integer points in 2D. Returns indices in P of vertices, sorted counterclockwise
  error if Type(P) ne SeqEnum or #P lt 3, "Expected a sequence of at least 3 points in 2D";
  I := LCHConvexHull2D(P);
  C:=[&+[P[i][j]: i in I]/#I: j in [1..2]];
  angle:=func<i|LCHVectorAngle(LCHPointsToVector(C,P[i]))>;
  SortBy(~I, angle); 
  return I;
end function;

function LowerConvexHull3D(P: checks:=false, HullVector:=[0,0,1])
  /*
  Lower convex hull of points P in 3D with respect to a given direction HullVector, default [0,0,1]
  P = [[x,y,z],...]           list of points to take the hull of
  F = [<[i1,i2,...],n,c>,...] indices of vertices for every face together with a normal vector n and a constant c so that
                              that halfplane {v | v.n >= c} cuts out the face from the hull 
  */
  if #P lt 3 then  // "LowerConvexHull3D: Should have at least 3 points, not on the same line";
    return [];
  end if;
  error if not forall{v: v in P | Type(v) eq SeqEnum and #v eq 3 and Universe(v) eq Integers()}, 
    "P should be a sequence of integer points in 3D";

  assert #HullVector eq 3;
  _,HullVector:=VectorContent(HullVector);                     // make primitive
  if HullVector ne [0,0,1] then
    M:=LCHCompleteToDet1Basis(HullVector) * Matrix(Z,[[0,0,1],[1,0,0],[0,1,0]]);  // M has HullVector as 3rd column and det=1
    MInv:=M^(-1);     // takes HullVector to [0,0,1]
    assert Eltseq(MInv*Transpose(Matrix(Vector(HullVector)))) eq [0,0,1];
    PNew:=[Eltseq(MInv*Transpose(Matrix(Vector(p)))): p in P];
    I:=LowerConvexHull3D(PNew: checks:=checks);
    return [<d[1],Eltseq(Transpose(MInv)*Transpose(Matrix(Vector(d[2])))),d[3]>: d in I];  // Transform normals back
  end if;

  i1:=LCHPointWithSmallest(P,func<p|p[3]>);                    // i1 = index of point with smallest z-coordinate (first vertex)  
  i2:=LCHPointWithSmallest(P,func<p|LCHPointSlope(P[i1],p)>);  // i2 = index of point minimising slope from P[i1] (first `edge') 
  // P[i1]-P[i2] may not be an actual edge, but it lies on a face, and this face we will get 
  
  E:=[[i1,i2],[i2,i1]];             // E = edges to be processed
  D:={};                            // D = edges already done
  F:=[];                            // F = faces
  
  repeat
    e:=E[1];
    vprint LSeries,1: "Processing",DelSpaces(e);
    Include(~D,e);
    Remove(~E,1);
    
    i1,i2:=Explode(e);
    i3,slope:=LCHPointWithSmallest(P,func<p|LCHEdgeSlope(P[i1],P[i2],p)>);
    if slope eq Infinity() then continue; end if;
    f:=LCHComputeFace(P,i1,i2,i3);
    if checks then assert 
      LCHPointWithSmallest(P,func<p|LCHEdgeSlope(P[i1],P[i2],p)>) in f[1] and 
      LCHPointWithSmallest(P,func<p|LCHEdgeSlope(P[i2],P[i3],p)>) in f[1] and
      LCHPointWithSmallest(P,func<p|LCHEdgeSlope(P[i3],P[i1],p)>) in f[1];
    end if;
    if f notin F then 
      vprint LSeries,1: "Adding",f;                  // Except for the first two edges every face should be new
      Append(~F,f);
    end if;
    
    for i:=1 to #f[1] do
      j1:=f[1][i];
      j2:=f[1][i mod #f[1] +1];
      // Add edges to D
      if [j2,j1] in E then Exclude(~E,[j2,j1]); end if;
      Include(~D,[j2,j1]);
      // Add reverse edges to E
      if [j1,j2] notin D and [j1,j2] notin E then Append(~E,[j1,j2]); end if;
    end for;
    
  until IsEmpty(E);
  
  return F;
  
end function;


function VectorProduct(v,w)
  assert Parent(v) eq Parent(w);
  v:=Eltseq(v);
  w:=Eltseq(w);
  if #v eq 3 then x1,y1,z1:=Explode(v); else assert #v eq 2; x1,y1:=Explode(v); z1:=0; end if;
  if #w eq 3 then x2,y2,z2:=Explode(w); else assert #w eq 2; x2,y2:=Explode(w); z2:=0; end if;
  return [y1*z2-y2*z1, -(x1*z2-x2*z1), x1*y2-x2*y1];
end function;


function ConvexHull3D(I)
  // Same format as LowerConvexHull3D, but full convex hull
  // for example:
  // I:=[[i,j,k]: i,j,k in [0..2]];
  // ConvexHull3D(I);
  // return 6 faces of the cube
  // [ <[27,25,19,21],[-1,0,0],-2>, <[9,7,25,27],[0,-1,0],-2>, <[9,27,21,3],[0,0,-1],-2>,
  //   <[1,7,9,3],[1,0,0],0>,       <[3,21,19,1],[0,1,0],0>,   <[1,19,25,7],[0,0,1],0> ]
  L:=LowerConvexHull3D(I: HullVector:=[-1,-1,-1]);
  for v in [[1,0,0],[0,1,0],[0,0,1]] do
    Ladd:=LowerConvexHull3D(I: HullVector:=v);
    for dataadd in Ladd do
      V,n,c:=Explode(dataadd);
      if exists(data){data: data in L | data[2] eq n and data[3] eq c} then 
        assert Set(data[1]) eq Set(V); 
        continue; 
      end if;
      Append(~L,dataadd);
    end for;
  end for;
  return L;
end function;


function PrintFactorRational(n: tex:=false, frac:=false, cdotneg:=false)
  if n lt 0 then
    return "-"*PrintFactorRational(-n: tex:=tex, frac:=frac, cdotneg:=cdotneg);
  end if;
  cdotstr:=tex select "\\cdot" else "*";
  if Type(n) cmpeq FldRatElt then
    if Denominator(n) eq 1 then return PrintFactorRational(Z!n: tex:=tex); end if;
    if frac
      then return "\\frac{"*PrintFactorRational(Numerator(n): cdotneg:=false, tex:=tex)
        *"}{"*PrintFactorRational(Denominator(n): cdotneg:=false, tex:=tex)*"}";
      else return 
        tex select "{"*PrintFactorRational(Numerator(n): tex:=true)
                  *"}\\,/\\,{"*PrintFactorRational(Denominator(n): tex:=true)*"}"
            else  PrintFactorRational(Numerator(n): tex:=false)
                  *"/"*PrintFactorRational(Denominator(n): tex:=false);
    end if;
  end if;
  if Type(n) cmpeq RngIntElt then
    if n in [-1,0,1] then return Sprint(n); end if;
    n,_,c:=Factorisation(n: Proof:=false, ECMLimit:=10, MPQSLimit:=0, PollardRhoLimit:=10000);
    if assigned c and c ne [1] then n cat:=[<d,1>: d in c]; end if;
  end if;
  s:=[s[2] eq 1 select Sprint(s[1]) else
      (Sprintf("%o^%o",s[1], (s[2] ge 10) and tex select "{"*Sprint(s[2])*"}" else s[2])): s in n];
  neg:=cdotneg select "\\!" else "";
  s:=[s[i]*(i eq #s select "" else neg*cdotstr*neg): i in [1..#s]];
  return IsEmpty(s) select "" else &cat s;
end function;


function _texify_hat(s: ob:="{", cb:="}")     
  repeat
    ok,spl:=Regexp("['^]([0-9][0-9]+)",s);
    if not ok then return s; end if;
    ReplaceString(~s,spl,spl[1]*ob*spl[2..#spl]*cb);
  until false;
end function;


function _html_hat(s: ob:="<sup>", cb:="</sup>")
  repeat
    ok,spl:=Regexp("['^]([0-9]+)",s);
    if not ok then return s; end if;
    ReplaceString(~s,spl,ob*spl[2..#spl]*cb);
  until false;
end function;


function _prnt_fp(f,tex,pr,var)
  if Type(f) eq RngMPolElt then 
    R:=Parent(f);
    oldnames:=Names(R); 
    AssignNames(~R,var cmpeq "" select oldnames else var);
    s:=DelSpaces(f); 
    AssignNames(~R,oldnames);
    if tex then ReplaceString(~s,"*","\\cdot "); end if;
    if tex then s:=_texify_hat(s); end if;
    return s;
  end if;
  c:=Eltseq(f);
  R:=PR(BaseRing(f));
  c:=Coefficients(f);
  if pr ne 0 then
    K<p>:=RFF(BaseRing(f));
    R:=PolynomialRing(K);
    cc:=[K|a: a in c];
    for i:=1 to #c do
      a:=c[i];
      if a eq 0 then continue; end if;
      v:=Valuation(a,pr);
      u:=a/pr^v;
      m:=Z!(Integers(pr)!u);  
      if m gt pr div 2 then m:=m-pr; end if;
      v2:=Valuation(u-m,pr);
      um:=u eq m select 0 else ((u-m)/pr^v2)*p^v2;
      a:=p^v*(m + um);
      cc[i]:=a;    
    end for;
    c:=cc;
  end if;
  oldnames:=Names(Parent(f)); 
  AssignNames(~R,var eq "" select oldnames else [var]);
  s:=DelSpaces(R!c);
  if tex then ReplaceString(~s,"*",""); end if;
  AssignNames(~R,oldnames);
  if tex then s:=_texify_hat(s); end if;
  return s;
end function;


function PrintFactorPolynomial(f: tex:=false, p:=0, var:="")
  mul:=tex select "" else "*";
  if f eq 0 then return "0"; end if;
  if Type(f) in [FldFunRatUElt,FldFunRatMElt] then
    Fn,Ln:=Factorisation(Numerator(f));
    Fd,Ld:=Factorisation(Denominator(f));
    F:=Fn cat [<d[1],-d[2]>: d in Fd];
    l:=Ln/Ld;
  else
    F,l:=Factorization(f);
  end if;
  prnt:=func<s|tex select _texify_hat(DelSpaces(s)) else DelSpaces(s)>;
  if (#F eq 1) and (F[1][2] eq 1) then return _prnt_fp(l*F[1][1],tex,p,var); end if;
  s:=l eq 1 select "" else (l eq -1 select "-" else 
    (Type(l) in [FldRatElt,RngIntElt] select PrintFactorRational(l) else _prnt_fp(Parent(f)!l,tex,p,var))*mul);
  if IsEmpty(F) then return s[[1..#s-#mul]]; end if;
  for i:=1 to #F do
    g:=F[i][1];
    e:=F[i][2];
    gs:=Eltseq(_prnt_fp(g,tex,p,var));
    br:=exists{c: c in gs | c in {"*","+","-"}};
    s cat:= (br select "(" else "") * &cat gs * (br select ")" else "") *
      (e eq 1 select "" else (tex select exp("^",e) else "^"*Sprint(e)));
    if i ne #F then    
      s cat:=mul;
    end if;
  end for;
  return s;
end function;


function PrintFactor(n: tex:=false, frac:=false, cdotneg:=false, p:=0, var:="")
  if n eq 0 then return "0"; end if;
  if n eq 1 then return "1"; end if;
  if n eq -1 then return "-1"; end if;
  if Type(n) in [RngUPolElt,RngMPolElt,FldFunRatUElt,FldFunRatMElt]
    then return PrintFactorPolynomial(n: tex:=tex, p:=p, var:=var);
    else return PrintFactorRational(n: tex:=tex, frac:=frac, cdotneg:=cdotneg);
  end if;
end function;


function ComplementToDet1Basis2D(v)
  // Complements a vector v = [a, b] (a, b coprime integers) to a determinant 1 basis [[a, b], [c, d]]
  a,b := Explode(Eltseq(v));
  assert GCD(a, b) eq 1;
  g, x, y := XGCD(a, b);
  assert g eq 1 and (a*x+b*y eq 1);
  return Parent(v)![-y,x];
end function;


function ComplementToDet1Basis3D(v)
  // Complements a vector v = [a,b,c] of gcd 1 to a determinant 1 basis v,v2,v3 and returns v2,v3
  v1,v2,v3:=Explode([Eltseq(r): r in Rows(Transpose(LCHCompleteToDet1Basis(v)))]);
  assert v1 eq v;
  return v2,v3;
end function;


function ComplementToDet1Basis3D2(v1,v2)
  // Complements vectors v1,v2 in Z^3 to a det=1 basis v1,v2,v3 and returns v3
  M := Transpose(Matrix(2, 3, Eltseq(v1) cat Eltseq(v2)));
  S, P, Q := SmithForm(M);                       // P*M*Q = S
  B := P^-1;
  v3 := [Z| B[1][3],B[2][3],B[3][3]];
  det := Determinant(Matrix(Z,[v1,v2,v3]));
  assert Abs(det) eq 1;
  if det eq -1 then v3:=[-x: x in v3]; end if;
  return v3;
end function;
