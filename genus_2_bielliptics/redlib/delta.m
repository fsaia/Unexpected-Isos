/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

Delta-v regular models, based on ``Models of curves over DVRs''

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

*
* IMPLEMENTS
*
*
* Main function
*
intrinsic DeltaRegularModel(f::RngMPolElt, D::RngDVR: Style:=[]) -> CrvModel                                    [226]
  Delta-regular model for a curve C given by f=0 (main function)
*
* TeX for $\Delta_v$
*
intrinsic DeltaTeX(C::CrvModel: xscale:=0.8, yscale:=0.7) -> MonStgElt                                          [825]
  Newton polytope and v-faces in TikZ
intrinsic EquationTeX(C::CrvModel) -> MonStgElt                                                                 [1027]
  Original defining equation in TeX
*
* Charts and transformation matrices
*
intrinsic ChartsTeX(C::CrvModel) -> MonStgElt                                                                   [1065]
  Charts for components in TeX for a curve model
*/


LPtsRec:=recformat<L, root, mult, sing, name>;     // format for singular points


import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, writernq,
  Count, IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols, DelCRs,
  ReplaceStringFunc, ReplaceString, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted, Left,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2, TeXPolynomial, PrintReal;  
import "texgraph.m": TikzScale;


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


function Select(L,x) 
  return [i: i in [1..#L] | L[i] eq x];
end function;


LastCoordinate:=func<vlist|[v.3: v in vlist]>;
FiniteFaces:=func<F,inf|[f: f in F | inf notin LastCoordinate(Vertices(f))]>;


function Down(P)  // Project a 3D polytope down to 2D
  if Type(P) eq SeqEnum then return [Down(X): X in P]; end if;
  assert Dimension(Ambient(P)) eq 3;
  return Polytope(SetToSequence({Prune(Eltseq(u)): u in Vertices(P)}));
end function;


// Shift a list of vectors (monomial exponents) into the positive cone, minimally

procedure ShiftMonomialsToZero(~Mvecs)
  shift:=[Min([v[j]: v in Mvecs]): j in [1..3]];
  for i in [1..#Mvecs], j in [1..3] do 
    Mvecs[i][j]-:=shift[j]; 
  end for;
end procedure;

// Transform an equation given by a list of monomial exponents and coefficients
// via a matrix Minv. Then reduce coefficients using red and Evaluate at the
// variables vars. Returns evaluated reduced equation, non-evaluated, non-reduced

function TransformPolynomial(f,Minv)
  Rk:=Parent(f);
  k:=BaseRing(Rk);
  cfs,mons:=CoefficientsAndMonomials(f);
  monvectors:=[Exponents(m): m in mons];
  Mvecs:=[Eltseq(Minv*Transpose(Matrix(Z,[m]))): m in monvectors];
  ShiftMonomialsToZero(~Mvecs);
  ftrans:=&+[cfs[i]*Monomial(Rk,Mvecs[i]): i in [1..#cfs]];
  return ftrans;
end function;


function TransformAndReduce(monvectors,cfs,red,Minv,vars)
  K:=Parent(cfs[1]);
  k:=Parent(red(1));
  RK:=PR(K,3);
  Rk:=PR(k,3);
  Mvecs:=[Eltseq(Minv*m): m in monvectors];
  ShiftMonomialsToZero(~Mvecs);
  ftrans:=&+[cfs[i]*Monomial(RK,Mvecs[i]): i in [1..#cfs]];
  ftransred:=&+[red(cfs[i])*Monomial(Rk,Mvecs[i]): i in [1..#cfs]];
  fred:=Evaluate(ftransred,vars);
  return fred,ftransred,ftrans;
end function;


function FactorisationMPolSplittingField(f)
   
  fct:=Factorisation(f);        // Reducible over the ground field - go in recursively

  if (#fct gt 1) or (#fct eq 1 and fct[1][2] gt 1) then
    out:=[];
    for d in fct do
      fmp:=FactorisationMPolSplittingField(d[1]);
      for j:=1 to #fmp do fmp[j][2]*:=d[2]; end for;
      out cat:= fmp;
    end for;
    return out;
  end if;

  // Use curve machinery to factor over the splitting field
  k:=BaseRing(Parent(f));
  //assert IsFinite(k);
  kk:=FieldOfGeometricIrreducibility(Curve(AffineSpace(k,2),f));
  return kk eq k select [<f,1>] else Factorisation(PR(kk,2)!f);
end function; 

procedure AddComponentData(~comps,name,i,d1,d2,sing,MFwd)
  Append(~comps,<name,i,d1,d2,sing,[**],[**],MFwd>);     
end procedure; 

procedure AddChainData(~comp,toC,mults,sing,src,~S)
  vprintf Newton,1: "%o->%o %o%o (src %o)\n",comp[1],toC,DelSpaces(mults),
    sing select " sing" else "",DelSpaces(src);

  if not IsEmpty(mults) then    // Style can overwrite (non-empty) multiplicities with "Ch%i"
    if exists(i){i: i in [1..#S] | S[i,1] eq "_chaincount"} then   // Keep chain count
      chaincount:=(eval S[i,2])+1; S[i,2]:=Sprint(chaincount);
    else
      chaincount:=1; Append(~S,["_chaincount","1"]);
    end if;
    mults:=[Sprint(x): x in mults];
    if GetSettingBool("ChainNumbers") then    // Print chain numbers if requested
      mults[#mults]:=Sprintf("\\llap{\\scalebox{0.6}{\\color{blue}%o}\\,}%o",chaincount,mults[#mults]);
    end if;
    if exists(newmults){d[2]: d in S | d[1] eq "Ch"*Sprint(chaincount)} then
      mults:=Split(newmults," ");
    end if;    
  end if;
  
  Append(~comp[6],<toC,mults,sing,src>);
end procedure;

procedure AddSingularPointData(~comp,src,name)
  Append(~comp[7],<src,name>);
end procedure;

// Orient a sequence of vertices for drawing

function Orient(S)  
  if #S le 2 then return S; end if;
  C:=ComplexField();
  avg:=&+S / #S;
  args:=[Arg(C!Eltseq(v-avg)): v in S];
  Sort(~args,~perm);
  return S[Eltseq(perm)];
end function;

function angle(v)
  arg:=Round(180*Arg(ComplexField()!Eltseq(v))/Pi(RealField()));
  return arg lt 0 select arg+360 else arg;
end function;

und:=func<x|#s le 1 select s else Sprintf("{%o}",s) where s is Sprint(x)>;

function FaceNameTeX(s: dollar:="$")
  ok,v:=HaveSetting(s);
  if ok then
    L:=Split(v,"@": IncludeEmpty);
    return dollar*L[1]*dollar,L[[2..#L]];
  end if;
  ok,_,buf:=Regexp("^FL([0-9]+)$",s);
  if ok then return Sprintf(dollar*"F^L_%o"*dollar,und(buf[1])),[]; end if;
  ok,_,buf:=Regexp("^F([0-9]+)$",s);
  if ok then return Sprintf(dollar*"F_%o"*dollar,und(buf[1])),[]; end if;
  ok,_,buf:=Regexp("^F([0-9]+)(.*)",s);
  if ok then return Sprintf(dollar*"F_%o^%o"*dollar,und(buf[1]),und(buf[2])),[]; end if;
  error "FaceNameTeX: unrecognized face name "*s;
end function;


function printpower(v,n)
  if n eq 0 then return ""; end if;
  if n eq 1 then return v; end if;
  n:=Sprint(n);
  return #n eq 1 select Sprintf("%o^%o",v,n) else Sprintf("%o^{%o}",v,n);
end function;


function PrintMatrixAsMonomialTransformation(m,v)
  L:=[];
  for r in Rows(Transpose(m)) do
    a,b,c:=Explode(Eltseq(r));
    s:=Sprintf("%o%o%o",printpower(v[1],a),printpower(v[2],b),printpower(v[3],c));
    if s eq "" then s:="1"; end if;
    Append(~L,s);
  end for;
  return L;
end function;


function IsNonnegative(s)
  ok,_,buf:=Regexp("([0-9]+)",s);
  if ok then return true,eval buf; end if;
  return false,_;
end function;


/// Main function


intrinsic DeltaRegularModel(f::RngMPolElt, D::RngDVR: Style:=[]) -> CrvModel
{Delta-regular model for a curve C given by f=0 (main function)}

  error if Rank(Parent(f)) ne 2, "DeltaRegularModel: f should lie in a polynomial ring in 2 variables";

  oldsettings:=Settings();
  SetSettings(DefaultModelSettings());
  AddSettings(Style);

  // Process options

  ShowEquation:=GetSetting("ShowEquation");

  ok,val:=IsNonnegative(ShowEquation);
  if ok then                        // ShowEquation=n: show equation if f has <=n terms
    ShowEquation:=#Monomials(Numerator(f)) le val[1]; 
  else
    ShowEquation:=GetSettingBool("ShowEquation");
  end if;

  ContractFaces   := GetSettingBool("ContractFaces");
  RemoveFaces     := GetSettingBool("RemoveFaces");
  BakerRegulars   := GetSettingBool("BakerRegulars");
  //  ShowCharts      := GetSettingBool("ShowCharts");
  FaceNames       := GetSettingBool("FaceNames");
  Warnings        := GetSettingBool("Warnings");

  //  D:=BaseDVR(f,P);
  K,k,vK,red,lift,pi:=Eltseq(D);

  /*  
  K:=BaseRing(Parent(f));
  if dvr cmpne "default" then
    assert #dvr eq 6;
    K,k,vK,red,lift,pi:=Explode(dvr);
  elif Type(K) in [FldPad,RngPad,RngSerLaur,RngSerPow] then 
    error if P cmpne "default", "P should not be specified for K:"*Sprint(Type(K));
    K,k,vK,red,lift,pi:=Eltseq(DVR(K));
  else 
    error if P cmpeq "default", "P must be specified for K:"*Sprint(Type(K));
    K,k,vK,red,lift,pi:=Eltseq(DVR(K,P));
  end if;
  */

  R<x,y>:=PR(K,2);
  forg:=f;

  procedure Warning(s)
    if Warnings then "Warning: "*s; end if;
  end procedure;

  if IsFinite(k) then
    RootsFunction:=RootsInSplittingField;
    PointsFunction:=PointsOverSplittingField;
    FactorizationFunction:=FactorisationMPolSplittingField;
  else
    Warning("Residue field is not finite. Do not have an algorithm to factor/find roots\n"*
            "for schemes in extensions. May miss components in the regular model.\n"*
            "Use at your own risk");
    RootsFunction:=Roots;
    FactorizationFunction:=Factorisation;
    PointsFunction:=Points;
  end if;

  if Rank(Parent(f)) eq 3 
    then f:=Numerator(Evaluate(f,[x,y,pi]));
    else f:=Numerator(Evaluate(f,[x,y]));
  end if;

  cfs,monsP:=CoefficientsAndMonomials(f);
  inds:=[j: j->c in cfs | not IsZero(c)];
  cfs:=cfs[inds];
  monsP:=monsP[inds];

  error if #monsP eq 1, "One monomial equation: empty Newton polygon"; 
  monsP:=[Exponents(m): m in monsP];

  mons:=[];
  for i->c in cfs do
    val:=vK(c);
    cfs[i]:=c/pi^val;
    mons[i]:=monsP[i] cat [val];
  end for;

  // 3D Polytope Delta_v and its v-faces, v-edges and vertices from monomial exponents

  monvectors:=[Transpose(Matrix(Z,[m])): m in mons];   // monomials as column vectors
  Delta:=Polytope([Prune(m): m in mons]);
  error if Dimension(Delta) le 1, "Polytope Delta is not 2-dimensional";
  AllP:=SortSet(Points(Delta));
  DeltaCenter:=&+AllP/#AllP;
  InnP:=SortSet(InteriorPoints(Delta));
  error if IsEmpty(InnP), Sprintf("Model: No interior points in the Newton polygon Delta => genus 0 curve\nmons=%o",DelSpaces(mons));

  inf:=1+Max([Last(m): m in mons]);               // 0,1,2-dim faces of Delta tilde Vs, Ls, Fs
  DeltaTop:=[[m[1],m[2],inf]: m in mons];         
  P:=Polytope(mons cat DeltaTop);
  F:=Faces(P);
  F:=[FiniteFaces(FList,inf): FList in F];
  Vtilde,Ltilde,Ftilde,_:=Explode(F);
  if assigned FaceReorder then Ftilde:=Ftilde[FaceReorder]; end if;
  if assigned LineReorder then Ltilde:=Ltilde[LineReorder]; end if;
  F2H:=[Last(Inequalities(F)): F in Ftilde];

  Vs:=[Vertices(Down(F))[1]: F in Vtilde];
  Ls:=[Down(F): F in Ltilde];
  Fs:=[Down(F): F in Ftilde];

  function vF(j,x,y)            // z-coordinate function on jth 2-face evaluated at [x,y]
    Heqn,Hv:=Explode(F2H[j]);
    Hx,Hy,Hz:=Explode(Eltseq(Heqn));
    return (Hv - Hx*x - Hy*y)/Hz;
  end function;

  function FacePositions(S)
    if IsEmpty(S) then return []; end if;
    if Dimension(S[1]) eq 0 then return [Position(Vs,Vertices(x)[1]): x in S]; end if;
    if Dimension(S[1]) eq 1 then return [Position(Ls,x): x in S]; end if;
    if Dimension(S[1]) eq 2 then return [Position(Fs,x): x in S]; end if;
    error "FacePositions: unrecognized dimension";
  end function;

  vP:=AssociativeArray();                        // height vP: Delta -> Q
  for j in [1..#Ftilde], P in Points(Fs[j]) do   // defined on integer points
    xP,yP:=Explode(Eltseq(P));
    if not IsDefined(vP,P) then
      vP[P]:=vF(j,xP,yP);
    end if;
  end for;

  AllFP:=[SortSet(Points(F)): F in Fs];
  AllLP:=[SortSet(Points(L)): L in Ls];

  InnFP:=[SortSet(InteriorPoints(F)): F in Fs];   // AllLP = L meet Z^2, AllFP = F meet Z^2
  InnLP:=[SortSet(InteriorPoints(L)): L in Ls];   // and inner versions InnLP, InnFP

  FIsRemovable:=[false: F in Fs];    // Repeatedly remove removable faces
  newleft:=#FIsRemovable;
  if RemoveFaces then
    repeat
      oldleft:=newleft;
      FIsRemovable:=[IsEmpty(InnFP[j]) and
        #(Set(AllFP[j]) meet &join{Set(AllFP[i]): i in [1..#Fs] | 
          not FIsRemovable[i] and (i ne j)}) le 2: j in [1..#Fs]];
      newleft:=Count(FIsRemovable,false);
    until oldleft eq newleft;
  end if;

  deltaL:=[Denominator(VectorContent([vP[P]: P in AllLP[j]])): j in [1..#Ls]];  // denominators
  deltaF:=[Denominator(VectorContent([vP[P]: P in AllFP[j]])): j in [1..#Fs]];

  degreeL:=[Z| (#Points(Ls[i])-1)/deltaL[i] : i in [1..#Ls]];

  FL:=[FacePositions(Faces(F,1)): F in Fs];             // list of 1-faces on a given 2-face
  FV:=[FacePositions(Faces(F,0)): F in Fs];             // list of 0-faces on a given 2-face
  FC:=[(&+Vs[FV[j]])/#(FV[j]): j in [1..#Fs]];          // centers of 2-faces

  LF:=[[j: j in [1..#Fs] | (i in FL[j])                 // list of 2-faces bounding a given 1-face
    and not FIsRemovable[j]]: i in [1..#Ls]];           //   [only the non-removable ones]

  LSquarefree:=[];                    // 1-faces with squarefree reduction of f_L
  for i:=1 to #Ls do
    lcf:=[];
    for P in AllLP[i] do
      if vP[P] notin Z then continue; end if;
      j:=Position(monsP,Eltseq(P));
      Append(~lcf,(j eq 0) or (mons[j][3] ne vP[P]) select 0 else red(cfs[j]));
    end for;
    fL:=Polynomial(lcf);
    Append(~LSquarefree,Degree(GCD(fL,Derivative(fL))) eq 0);
  end for;  

  FIsContractible:=[false: F in Fs];    
  // Contractible faces: see 3 conditions below
  //! Should check face is non-singular in the In case(?)
  cc:=[];
  if #InnP eq 0 then 
    Warning("Contractible faces in genus 0 are not implemented");
  else
  for i:=1 to #Fs do 
    int:=Set(AllFP[i]) meet Set(InnP);
    if #int ne 1 or not IsEmpty(InnFP[i]) then continue; end if;  // 1) unique point P in F cap Delta(Z) on the boundary of F
    P:=Representative(int);
    if vP[P] notin Z then continue; end if;    // 2) v(P) in Z 
    if not forall{l: l in FL[i] |              // 3) all edges either outer or contain P, inner one non-singular
       (#LF[l] eq 1) or (P in AllLP[l]) and LSquarefree[l]} then continue; end if;
    l:=FL[i];
    chains:=&cat[ [l[j]: count in [1..degreeL[l[j]]]] : j in [1..#l] | (deltaL[l[j]] lt deltaF[i]) or (#LF[l[j]] gt 1)];
    error if #chains lt 2 and RemoveFaces, "Did not expect a removable face here";
    error if #chains gt 2, "3 chains: cannot be a contractible face";
    vprintf Newton,1: "Contractible face: #%o %o (%o)\n",i,PrintSequence(Vertices(Fs[i]): d),DelSpaces(chains);
    if {i: i in [1..#Fs] | not FIsRemovable[i] and not FIsContractible[i]} eq {i} 
      then continue; end if; // last remaining not contractible face in case of In elliptic curve
    FIsContractible[i]:=true;
    Append(~cc,chains);
  end for;
  end if;

  if RemoveFaces and ContractFaces then
    assert forall{i: i in Select(FIsContractible,true) | #(Set(AllFP[i]) meet Set(InnP)) eq 1};
    assert forall{i: i in Select(FIsRemovable,true) | #(Set(AllFP[i]) meet Set(InnP)) eq 0};
  end if;

  // merge contractible chains
  while exists(d){[i,j]: i,j in [1..#cc] | (i lt j) and #(Set(cc[i]) meet Set(cc[j])) eq 1} do
    c1:=cc[d[1]];
    c2:=cc[d[2]];
    if c1[1] eq c2[1]         then c:=Prune(Reverse(c1)) cat c2; 
    elif c1[1] eq Last(c2)    then c:=Prune(c2) cat c1; 
    elif Last(c1) eq c2[1]    then c:=Prune(c1) cat c2; 
    elif Last(c1) eq Last(c2) then c:=Prune(c1) cat Reverse(c2); 
      else error "Could not merge chains"; 
    end if;
    vprintf Newton,1: "Merging chains %o %o -> %o\n",c1,c2,c;
    cc[d[1]]:=c;
    Remove(~cc,d[2]);
  end while;
  ContractibleChains:=cc;

  if not ContractFaces then
    FIsContractible:=[false: F in Fs];    
    ContractibleChains:=[];
  end if;

  MFwd:=[[]: l in Ls];                             // chart transformation matrices
  MInv:=[[]: l in Ls];                          // and their inverses

  LSlopes:=[];          // intermediate det 1 fractions from sF1 to sF2, inclusive
  ki:=[];               // list of [k_0,k_1,...,k_{r+1}] for every 1-face L

  LStarPoints:=[];      // list of [P0,P1,P2] for every 1-face L
  for i:=1 to #Ls do    // P1-P0 on L, counterclockwise on F1, 
    if IsEmpty(LF[i]) then continue; end if;  // removable
    F1j:=LF[i][1];      // P1-P0, P2-P1 form a determinant one basis 
    cF1:=FC[F1j];       // (second one points into F1)
    F2j:=#LF[i] eq 2 select LF[i][2] else 0;    // 0 if outer
    lp:=AllLP[i];
    P0:=lp[1]; 
    P1:=lp[2]; 
    v:=P1-P0;
    vx:=v.1;
    vy:=v.2;
    if -vy*(cF1.1-P0.1)+vx*(cF1.2-P0.2) lt 0 then  // want P1-P0 counterclockwise on F1
      P0:=lp[#lp];
      P1:=lp[#lp-1];
      v:=P1-P0;
    end if;
    vx:=v.1;
    vy:=v.2;
    vz:=vF(F1j,P1.1,P1.2)-vF(F1j,P0.1,P0.2);    // nu vector = (v.1,v.2,vz)
    g,a,b:=XGCD(vx,vy);
    assert -vy*(cF1.1-P0.1)+vx*(cF1.2-P0.2) gt 0;
    assert g eq 1;
    P2:=P0 + Parent(v)![-b,a];
    wx:=P2.1-P0.1;
    wy:=P2.2-P0.2;
    assert Determinant(Matrix(Q,[Eltseq(P1-P0),Eltseq(P2-P0)])) eq 1;
    LStarPoints[i]:=[P0,P1,P2];

    delta:=deltaL[i];

    sF1:=delta*(vF(F1j,P2.1,P2.2)-vF(F1j,P0.1,P0.2));    // s_F1
    outer:=F2j eq 0;
    inner:=not outer;
    sF2:=outer select Floor(sF1-1) else                  // s_F2 in the outer case
         delta*(vF(F2j,P2.1,P2.2)-vF(F2j,P0.1,P0.2));    // s_F2 in the inner case
    LSlopes[i]:=HirzebruchJung(sF1,sF2);   

    deltavzinv:= delta eq 1 select 0 else (Integers(delta)!Z!(delta*vz))^(-1);

    ki[i]:=[Z|-Numerator(x)*deltavzinv: x in LSlopes[i]];

    for j:=1 to #LSlopes[i]-1 do
      di:=Denominator(LSlopes[i][j]);
      dip:=Denominator(LSlopes[i][j+1]);
      ni:=Numerator(LSlopes[i][j]);
      nip:=Numerator(LSlopes[i][j+1]);
      kii:=ki[i][j];
      kip:=ki[i][j+1];
      eps:=outer and (j+1 eq #LSlopes[i]) select 1 else 0;      // Modify in the outer case for the last j
      if eps eq 1 then assert di eq dip; end if;

      MFwd[i][j]:=Matrix(Z, [ 
         [delta*vx,  di*wx+kii*vx,    -dip*wx-kip*vx  +   eps*(di*wx+kii*vx)  ],
         [delta*vy,  di*wy+kii*vy,    -dip*wy-kip*vy  +   eps*(di*wy+kii*vy) ],
         [delta*vz,  ni/delta+kii*vz, -nip/delta-kip*vz + eps*(ni/delta+kii*vz) ] ]);
      assert Determinant(MFwd[i][j]) eq 1;
      MInv[i][j]:=MFwd[i][j]^(-1);
    end for;
  end for;

  FIsSingular:=[];

  // now construct the dual graph,
  // extending k repeatedly if necessary

  newk:=k;
  for trial:=1 to 40 do   

    if newk ne k then                                   // extend k
      vprint Newton,1: "Extending",k,"to",newk;
      k:=newk; oldred:=red;   red:=func<x|k!oldred(x)>; 
    end if;  

    comps:=[];                   // [<name,Findex,redeqn,mult,sing,chains,singpts,MFwd=transmatrix>,...]
    Lpts:=[];                    // [<Lindex,root,mult,sing,name>,...]
    singptcount:=0;

    Rk1<t>:=PR(k);
    Rk2<X2,Y2>:=PR(k,2);
    A:=AffineSpace(Rk2);

    for i:=1 to #Ls do
      if IsEmpty(LF[i]) then continue; end if;  // removable
      tr:=MInv[i][1];
      ffred:=TransformAndReduce(monvectors,cfs,red,tr,[X2,Y2,0]);
      m:=Min([Degree(m,Y2): m in Monomials(ffred)]);
      flred:=Evaluate(ffred div Y2^m,[t,0]);
      rts:=[r: r in RootsFunction(flred) | r[1] ne 0];
      if not IsEmpty(rts) then 
        newk:=Parent(rts[1][1]); 
        if newk ne k then continue trial; end if;
      end if;
      for r in rts do 
        sing:=r[2] gt 1;
        if sing and (Evaluate(Derivative(ffred,2),[r[1],0]) ne 0) and     // Baker regular
           BakerRegulars and (#LF[i] eq 1) and (deltaF[LF[i][1]] eq 1)    // on outer L with delta_F=1
        then     
          vprint Newton,1: "Baker regular",i;
          sing:=false;
        end if;
        if sing then 
          name:=CodeToString(97+singptcount);
          singptcount+:=1;
        else 
          name:="";
        end if;
        Append(~Lpts,rec<LPtsRec|L:=i,root:=r[1],mult:=r[2],sing:=sing,name:=name>);   
      end for;    
      vprint Newton,1: Sprintf("L%o %o",i,PrintSequence([DelSpaces(r): r in rts]));
    end for;

    Lvanishing:=[[]: P in Lpts]; // [<compindex,orderofvanishing>]

    for i:=1 to #Fs do
      FIsSingular[i]:=false;
      if FIsRemovable[i] /*or FIsContractible[i]*/ then continue; end if;
      F:=Fs[i];
      Li:=FL[i][1];
      FisF1:=LF[Li][1] eq i;
      j:=FisF1 select 1 else #LSlopes[Li]-1;
      minv:=MInv[Li][j];

      // if the chain is not from F but to F, swap Y<->Pi and X<->X^-1
      if not FisF1 then minv:=Matrix(Z,[[-1,0,0],[0,0,1],[0,1,0]])*minv; end if;
      m:=minv^(-1);

      fred,ftransred,ftrans:=TransformAndReduce(monvectors,cfs,red,minv,[X2,Y2,0]);
      fct:=[d: d in FactorisationMPolSplittingField(fred) | d[1] notin [X2,Y2]];

      fcompseqns:=[d[1]: d in fct];
      for d in fct do                                  // comps (dim>0)
        //if d[1] in [X2,Y2] then continue; end if;      // from factors of fred on F
        if d[2] gt 1 then FIsSingular[i]:=true; end if;
        newk:=BaseRing(Parent(d[1]));
        if newk ne k then continue trial; end if;
        name:=Sprintf("F%o%o",i,#fct eq 1 select "" else CodeToString(96+Position(fct,d)));
        vprintf Newton,1: "%o %o [%o] delta=%o\n",name,DelSpaces(d[1]),d[2],deltaF[i];
        AddComponentData(~comps,name,i,d[1],d[2],d[2] gt 1,m);
      end for;

      U:=Curve(A,fred);
      Sing:=SingularSubscheme(U);
      for X in IrreducibleComponents(Sing) do   // singular points (dim=0)
      if Dimension(X) eq 0 then
        S0:=PointsOverSplittingField(X);
        for P in [P: P in S0 | P[1] ne 0 and P[2] ne 0] do 
          FIsSingular[i]:=true;
          EP:=Eltseq(P);
          newk:=Universe(EP);
          if newk ne k then continue trial; end if;
          node:=IsNode(U,P);
          Co:=[j: j in [1..#comps] | (comps[j][2] eq i) and Evaluate(comps[j][3],Eltseq(P)) eq 0];
          vprint Newton,1: Sprintf("%o on %o %o",DelSpaces(P),PrintSequence([comps[j][1]: j in Co]: sep:=","),node select "node" else "not a node");        
          if node then           // ordinary double point
            assert #Co le 2;     // on one or two comps -> chain 
                                 //! unknown length: xy=pi^n with n unknown
            chain:=["zigz",Sprint(deltaF[i])];
            // Sprintf("$\\!\\!\\!\\!\\!?\\>\\>\\,$%o",deltaF[i])];
            AddChainData(~comps[Co[1]],Co[#Co],chain,true,P,~Style);
          elif #Co eq 1 then
            AddSingularPointData(~comps[Co[1]],P,DelSpaces(P));
          elif #Co eq 2 then
            AddChainData(~comps[Co[1]],Co[2],[""],true,P,~Style);
          else
            name:=Sprintf("F%oS",i);          
            AddComponentData(~comps,name,i,1,1,true,DiagonalMatrix(Z,[0,0,0]));     // show as extra component
            for j in Co do 
              AddChainData(~comps[j],#comps,[""],true,P,~Style);
            end for;          
          end if;
        end for;
      end if;
      end for;   

      // which 2-face comps degenerate where on 1-faces

      Rk3<X3,Y3,P3>:=PR(k,3);
      Rk<t>:=PR(k);
      for L in FL[i] do
      for fci:=1 to #comps do
        fc:=comps[fci];
        if fc[2] ne i then continue; end if;
        fe:=fc[3];
        fv:=Evaluate(fe,[X3,Y3]);
        ft:=Evaluate(TransformPolynomial(fv,MInv[L][1]*m),[t,0,0]);
        for Pj:=1 to #Lpts do
          P:=Lpts[Pj];
          if P`L ne L then continue; end if;
          vprint Newton,1: Sprintf("(%o) %o %o %o -> %o*%o=%o",fci,fc[1],DelSpaces(ft),
            DelSpaces(<P`name,P`L,P`root,P`mult,P`sing>),
            Valuation(ft,t-P`root),fc[4],Valuation(ft,t-P`root)*fc[4]
          );
          Append(~Lvanishing[Pj],<fci,Valuation(ft,t-P`root)*fc[4]>);
        end for;
      end for;
      end for;

    end for;

    break;
  end for;

  // check that orders of vanishing add up

  mults1:=[&+[d[2]: d in L]: L in Lvanishing];  
  mults2:=[#LF[d`L]*d`mult: d in Lpts];
  assert mults1 eq mults2;

  // chains between comps

  for Pi:=1 to #Lpts do
    L,r,mult,sing,name:=Explode([*D`L,D`root,D`mult,D`sing,D`name*]) where D is Lpts[Pi];
    co:=[d: d in Lvanishing[Pi] | d[2] gt 0];
    outer:=#LF[L] eq 1;
    F1:=co[1][1];
    F2:=#co eq 1 select 0 else co[2][1];
    if comps[F1][2] ne LF[L][1] then
      assert F2 ne 0;
      t:=F1; F1:=F2; F2:=t;
    end if;  
    if not sing then 
      assert #LF[L] eq #co; 
      slopes:=LSlopes[L];
      slopes:=slopes[2..#slopes-1];
      slopes:=[Z|delta*Denominator(x): x in slopes] where delta is deltaL[L];
      AddChainData(~comps[F1],F2,slopes,false,r,~Style);
      continue;
    end if;
    vprint Newton,1: "singular point:",L,outer,r,mult,co;
    if   #co eq 1 then AddSingularPointData(~comps[F1],r,name);
    elif #co eq 2 then AddChainData(~comps[F1],F2,[/*"style=l2sing",*/name],true,r,~Style);
    else 
      name:=Sprintf("FL%o",L);          
      AddComponentData(~comps,name,-Pi,r,mult,true,DiagonalMatrix(Z,[0,0,0]));     // show as extra component
      for c in co do      
        AddChainData(~comps[c[1]],#comps,[""],true,r,~Style);
      end for;
    end if;
  end for;

  ////////////////////////////// Dual graph

  G:=DualGraph();

  for i:=1 to #comps do                                         // components
    name,F,eqn,mult,sing,chains,singpts:=Explode(comps[i]);
    if F gt 0 then mult*:=deltaF[F]; end if;
    if (F le 0) or sing or IsEmpty([P: P in InteriorPoints(Fs[F]) | vP[Eltseq(P)] in Z])
      then g:=0;
      else vprint Newton,1: "Computing geometric genus";
           g:=GeometricGenus(Curve(A,eqn)); //! make faster by checking full non-singularity with Baker?
    end if;
    src:=FaceNames select FaceNameTeX(name) else "";
    AddComponent(~G,Sprint(i),g,mult: texname:=src, singular:=sing);
  end for;

  for i:=1 to #comps do                                         // chains and singular points
    si:=Sprint(i);
    name,F,eqn,mult,sing,chains,singpts:=Explode(comps[i]);
    for P in singpts do
      pn:=Sprint(P[2]);
      repeat
        ok,_,buf:=Regexp("(.*)[$][.]1[/^]([0-9]+)(.*)",pn);
        if not ok then break; end if;
        pn:=Sprintf("%o$r^{%o}$%o",buf[1],buf[2],buf[3]);           // singular point (red)
      until false;    
      AddSingularPoint(~G,si,"redbullet"); //! Label not implemented yet: label:=#pn eq 1 select pn else "{"*pn*"}");
    end for;
    for d in chains do
      j,chmults,chsing,src:=Explode(d);
      if not chsing and ExtendedType(chmults) eq SeqEnum[MonStgElt] then 
        chmults:=[eval c: c in chmults];
      end if;
      sj:=Sprint(j);
      chmultsstr:=[Sprint(x): x in chmults];
      if j ne i and not IsEmpty(chmults) and chmultsstr[1] eq "zigz" then   // zigzag chain for a node of unknown depth
        AddSingularChain(~G,si,sj: mults:=[Sprintf("$\\hspace{-12pt}?\\ \\ %o$",chmults[2])], 
          linestyle:="snake=zigzag,segment length=2,segment amplitude=1,blue!70!black"); 
      elif (j eq 0) and not IsEmpty(chmults) then                // open chain
        if chsing then AddSingularChain(~G,si,sj: mults:=chmults); 
                  else AddChain(~G,si,sj,chmults);
        end if;
      elif j eq i then 
        AddSingularPoint(~G,si,"bluenode");   // blue node for chain to itself
      elif j ne 0 then 
        if chsing then AddSingularChain(~G,si,sj: mults:=chmults); 
                  else AddChain(~G,si,sj,chmults);
        end if;
      else 
        ; // empty open chain - do nothing
      end if;
    end for;
  end for;

  // contracting chains in the dual graph, corresponding to contractible faces
  MakeMRNC(~G);

  // reduction type (or false if G is singular)
  R:=ReductionType(G);

  // Define the model and return it
  C:=New(CrvModel);
  C`forg:=forg;
  C`f:=f;
  C`K:=K;
  C`k:=k;
  C`pi:=pi;
  C`red:=red;
  C`lift:=lift;
  C`v:=v;
  C`Delta:=Delta;
  C`InnP:=InnP;
  C`AllP:=AllP;
  C`vP:=vP;
  C`Fs:=Fs;
  C`Ls:=Ls;
  C`Vs:=Vs;
  C`vF:=vF;
  C`AllFP:=AllFP;
  C`AllLP:=AllLP;
  C`InnFP:=InnFP;
  C`InnLP:=InnLP;
  C`deltaF:=deltaF;
  C`deltaL:=deltaL;
  C`FIsRemovable:=FIsRemovable;
  C`FIsContractible:=FIsContractible;
  C`FIsSingular:=FIsSingular;
  C`FL:=FL;
  C`FV:=FV;
  C`FC:=FC;
  C`LF:=LF;
  C`MFwd:=MFwd;
  C`MInv:=MInv;
  C`comps:=comps;
  C`mons:=mons;
  C`Lpts:=Lpts;
  C`ContractibleChains:=ContractibleChains;
  C`Style:=Settings();
  C`G:=G;
  C`R:=R;
  C`type:="delta";

  SetSettings(oldsettings);
  return C;
end intrinsic;
  
  
/// TeX for $\Delta_v$


function Styles(s)
  style:="";
  T:=Settings();
  done:={};
  repeat
    changed:=false;
    for k in Keys(T) diff done do
      if Regexp("[\[\{,=]"*k*"[\]\},=]",s*style) then
        Include(~done,k);
        style:=Sprintf("  %o/.style={%o},\n",k,T[k])*style;
        changed:=true;
      end if;
    end for;
  until not changed;
  return style[[1..#style-2]];
end function;


intrinsic DeltaTeX(C::CrvModel: xscale:=0.8, yscale:=0.7) -> MonStgElt
{Newton polytope and v-faces in TikZ}
  if assigned C`deltaTeX then return C`deltaTeX; end if;
  if not assigned C`Delta then return ""; end if;           // not a Delta_v model

  oldsettings:=Settings();
  SetSettings(C`Style);

  FIsSingular:=C`FIsSingular;
  FIsRemovable:=C`FIsRemovable;
  FIsContractible:=C`FIsContractible;
  Ls:=C`Ls;
  FL:=C`FL;
  comps:=C`comps;
  Fs:=C`Fs;
  Style:=C`Style;
  Vs:=C`Vs;
  FV:=C`FV;
  AllFP:=C`AllFP;
  AllLP:=C`AllLP;
  AllP:=C`AllP;
  InnFP:=C`InnFP;
  InnLP:=C`InnLP;
  FC:=C`FC;
  LF:=C`LF;
  Lpts:=C`Lpts;
  vP:=C`vP;
  ContractibleChains:=C`ContractibleChains;
  mons:=C`mons;
  deltaL:=C`deltaL;

  FaceNames:=GetSettingBool("FaceNames");
  SmallValuations:=GetSettingBool("SmallValuations");
  LargeValuations:=GetSettingBool("LargeValuations");

  s:="";

  // shading: fill singular faces

  for Fi in Select(FIsSingular,true) do          
    s*:=Sprintf("\\fill[red!5] %o--cycle;\n",
      PrintSequence([DelSpaces(v): v in Orient(Vertices(Fs[Fi]))]: sep:="--"));
  end for;

  // name face components

  if FaceNames then
  for i:=1 to #Fs do
    if FIsRemovable[i] or FIsContractible[i] then continue; end if;
    pts:=Points(Fs[i]);
    lat:=Parent(Representative(pts));
    ptsv:={P: P in pts | P+lat![0,1] in pts};
    ptsh:={P: P in pts | P+lat![1,0] in pts};
    ptsq:={P: P in ptsv | P+lat![1,0] in ptsv};
    ptsv:=[P+lat![0,1/2]: P in ptsv | not exists{l : l in Ls[FL[i]] | P+lat![0,1/2] in l}];
    ptsh:=[P+lat![1/2,0]: P in ptsh | not exists{l : l in Ls[FL[i]] | P+lat![1/2,0] in l}];
    names:=[];
    namestyle:="";
    for d in comps do
      if d[2] ne i then continue; end if;
      dname,style:=FaceNameTeX(d[1]);
      Append(~names,dname);
      if (#style ne 0) and (style[1] ne "") then namestyle:=","*style[1]; end if;
    end for;
    names:=PrintSequence(names);
    v:=Vs[FV[i]]; 
    c:=&+v/#v;
    d:=&+[(x-c)/  (1+Norm(x-c)) : x in v]/#v;
    if not IsEmpty(ptsq) then 
      ptsq:=[P+lat![1/2,1/2]: P in ptsq];
      _,j:=Min([Norm(c-P): P in ptsq]); c:=ptsq[j];
    elif not IsEmpty(ptsv) then 
      _,j:=Min([Norm(c-P): P in ptsv]); c:=ptsv[j];  
    elif not IsEmpty(ptsh) then 
      _,j:=Min([Norm(c-P): P in ptsh]); c:=ptsh[j];  
    else
      for i:=1 to 5 do
        cn:=c+i*d; 
        if Max([Abs(x-Round(x)): x in Eltseq(cn)]) ge 1/4 then c:=cn; break; end if;  
      end for;
    end if;
    s*:=Sprintf("\\node[fname%o] at (%o,%o) {%o};\n",namestyle,RealField(2)!c.1,RealField(2)!c.2,names);
  end for;
  end if;

  // valuations (large or small) at integer points

  AllPNonRem:=&join{Set(AllFP[i]): i in [1..#Fs] | not FIsRemovable[i] and not FIsContractible[i]};
  S:=&join[Set(InnFP[i]): i in [1..#Fs] | FIsSingular[i]];

  for i:=1 to #AllP do
    P:=AllP[i];
    x,y:=Explode(Eltseq(P));
    z:=vP[P];

    ok,d:=HaveSetting(Sprintf("V%o%o",x,y));
    zstr:=ok select d else z;

    if     [x,y] in S then             nodestyle:=",red!70!black";
      elif [x,y] notin AllPNonRem then nodestyle:=",rem";
      else nodestyle:="";
    end if;

    s*:=Sprintf("\\node[%o%o] at (%o,%o) (%o) {%o};\n",
      [x,y,z] in mons select (LargeValuations select "lrg" else "coordinate") else 
        SmallValuations select "sml" else "coordinate",
      nodestyle,x,y,i,zstr);   // lrg / sml / coordinate
  end for; 

  // paths in Delta_v

  vprint Newton,1: "Paths";

  s*:="\\draw[lin]\n";
  for i:=1 to #Ls do
    L:=Ls[i];
    delta:=deltaL[i];
    pt:=AllLP[i];
    pti:=[Position(AllP,p): p in pt];
    label:=["": i in [1..#pt-1]];

    if forall{f: f in LF[i] | FIsRemovable[f] or FIsContractible[f]} 
        then color:=["[rem]": i in [1..#pt-1]]; else                 // removable/contractible
      BadSegments:=[Z|P`mult*delta: P in Lpts | (P`L eq i) and P`sing];
      BadSegmentNames:=[P`name: P in Lpts | (P`L eq i) and P`sing];
      GoodSegments:=[Z|delta: i in [1..(#pt-1-&+BadSegments) div delta]];  // alternate singular/non-singular
      color:=[];
      goodturn:=#GoodSegments gt #BadSegments;
      repeat
        if IsEmpty(BadSegments) and IsEmpty(GoodSegments) then break; end if;
        if goodturn then
          if not IsEmpty(GoodSegments) then
            for j:=1 to Last(GoodSegments) do Append(~color,""); end for;
            GoodSegments:=Prune(GoodSegments);
          end if;
        else
          if not IsEmpty(BadSegments) then
            for j:=1 to Last(BadSegments) do 
              Append(~color,Sprintf("[red%o]",
                j eq 1 select ",(-" else 
                (j eq Last(BadSegments) select ",-)" 
                else "")));  
              if j eq 1 then label[#color]:=Sprintf("node[lname] {%o} ",Last(BadSegmentNames)); end if;
            end for;
            BadSegments:=Prune(BadSegments);
            BadSegmentNames:=Prune(BadSegmentNames);
          end if;
        end if;
        goodturn:=not goodturn;
      until false;
    end if;
    assert #color eq #pt-1;  
    for i:=1 to #pt-1 do 
      s*:=Sprintf(" (%o) edge%o %o(%o)",pti[i],color[i],label[i],pti[i+1]);
    end for;
    s*:="\n";
  end for;  
  s*:=";\n";

  vprint Newton,1: "Contractible chains";

  // draw arcs for contractible chains in Delta_v

  for c in ContractibleChains do
    if c[1] eq Last(c) 
      then v:={P: P in InnLP[c[1]] | vP[P] in Z};    // I_n-like from a line to itself
      else v:=&meet[Set(Vertices(L)): L in Ls[c]];   // Rays from one central point
    end if;
    assert #v eq 1;  
    v:=Representative(v);
    v1:=Representative(Set(Vertices(Ls[c[1]])) diff {v});
    v2:=Representative(Set(Vertices(Ls[Last(c)])) diff {v,v1});
    arg1,arg2:=Explode(Sort([angle(w-v): w in [v1,v2]]));
    assert exists(i){i: i in [1..#Fs] | not FIsContractible[i] and not FIsRemovable[i]};
    argc:=angle(FC[i]-v);  
    if (argc ge arg1) and (argc le arg2) then arg2-:=360; end if;
    s*:=Sprintf("\\draw [-] (%o) ++(%o:1.2em) arc (%o:%o:1.2em);\n",Position(AllP,Eltseq(v)),arg1,arg1,arg2); 
  end for;

  sty:=Styles(s);
  if #sty ne 0 then sty:=",\n"*sty; end if;
  deltatex:=Sprintf("\\begin{tikzpicture}[xscale=%o,yscale=%o%o]\n%o\\end{tikzpicture}",
    PrintReal(xscale: prec:=2), PrintReal(yscale: prec:=2) ,sty,s);
  SetSettings(oldsettings);
  C`deltaTeX:=deltatex;
  return deltatex;
end intrinsic;


/*
Example
R<x,y>:=PolynomialRing(Q,2);      // 2 exceptional shapes that give deficient genus 1 curves
p:=37; 
f:=p*y^2+x^4+p*x^2+p^2;           // 2g1
C:=DeltaRegularModel(f,DVR(Q,p));
DeltaTeX(C);
f:=p*y^3 + p^2*x^3 + 1;           // 3g1
C:=DeltaRegularModel(f,DVR(Q,p));
DeltaTeX(C);
*/


intrinsic EquationTeX(C::CrvModel) -> MonStgElt
{Original defining equation in TeX}
  if assigned C`eqnTeX then return C`eqnTeX; end if;

  oldsettings:=Settings();
  SetSettings(C`Style);

  forg:=C`forg;  // Defining equation

  if Rank(Parent(forg)) eq 2 then
    forgstr:=TeXPolynomial(forg: vnames:=["x","y"], vorder:=[2,1]);
  else
    forgstr:=TeXPolynomial(forg: vnames:=["x","y","p"], vorder:=[2,1,3]);
  end if;
  forgstr:=Sprintf(GetSetting("EquationFormat"),forgstr);

  SetSettings(oldsettings);
  C`eqnTeX:=forgstr;
  return forgstr;
end intrinsic;


/*
Example Taken from \protect{\cite[Ex 3.18]{newton}}
R<x,y>:=PolynomialRing(Q,2);  // Example from Poonen-Silverberg-Stoll paper at p=2
f:=-2*x^3*y-2*x^3+6*x^2*y+3*x*y^3-9*x*y^2+3*x*y-x+3*y^3-y;  
C:=Model(f,2);
EquationTeX(C);
TeX(C);
f2:=Evaluate(f,[x+1,x*y+1]);  // Better model  
C2:=Model(f2,2);
TeX(C2: Equation, Delta);     // All in one call
*/

  
/// Charts and transformation matrices


intrinsic ChartsTeX(C::CrvModel) -> MonStgElt
{Charts for components in TeX for a curve model}

  if assigned C`chartsTeX then return C`chartsTeX; end if;
  if not assigned C`Delta then return ""; end if;           // not a Delta_v model

  oldsettings:=Settings();
  SetSettings(C`Style);

  comps:=C`comps;
  FIsContractible:=C`FIsContractible;
  FIsRemovable:=C`FIsRemovable;
  deltaF:=C`deltaF;
  Style:=C`Style;
  Lpts:=C`Lpts;

  s:="";
  for i:=1 to #comps do
    name,F,eqn,mult,sing,chains,singpts,m:=Explode(comps[i]);
    if IsZero(m) then continue; end if;
    if /*sing or*/ (F le 0) or FIsContractible[F] or FIsRemovable[F] then continue; end if;
    tr1:=PrintMatrixAsMonomialTransformation(m^(-1),["X","Y","Z"]);
    tr2:=PrintMatrixAsMonomialTransformation(m,["x","y","p"]);
    eqns:=TeXPolynomial(eqn: vorder:=[2,1], vnames:=["X","Y"]);
    s*:=Sprintf("  %o & x=%o & X=%o && %o=0 \\cr\n"* 
                "     & y=%o & Y=%o && Z^%o=0\\cr\n"* 
                "     & p=%o & Z=%o \\cr\n",
       FaceNameTeX(name: dollar:=""),tr1[1],tr2[1],eqns,tr1[2],tr2[2],mult*deltaF[F],tr1[3],tr2[3]);
  end for;
  for P in Lpts do
    if not P`sing then continue; end if;
    s*:=Sprintf(" %o & L=%o & r=[%o]^{%o} \\cr\n",P`name,P`L,P`root,P`mult);  
  end for; 
  transformations:=Sprintf(GetSetting("ChartsFormat"),s);

  SetSettings(oldsettings);
  C`chartsTeX:=transformations;
  return transformations;
end intrinsic;


/*
Example TeX, DeltaTeX, ChartsTeX for $\Delta_v$-regular model
R<x,y>:=PolynomialRing(Q,2);
p:=5;
f:=x^10+y^4+p^2*x^7+p^5*x^5+p^15;
M:=Model(f,p);              // ChartsTeX also shows the root of
Sprintf("\\begin{center}\\cbox{%o}\\qquad\\cbox{%o}\\end{center}",DeltaTeX(M),TeX(M));         //> DeltaTeX(M),TeX(M);         // the singular point on the leftmost edge 
ChartsTeX(M);               // alternatively TeX(M: Delta, Charts) does the same
f2:=Evaluate(f,[x+4*p^2,y]);      // Shift it along the singular edge
M2:=Model(f2,p);                  // to try to resolve singularity
texsettings:=[["dualgraph.root","3"],["dualgraph.scale","0.9"]];   // put F3 at the bottom
TeX(M2: Delta, texsettings:=texsettings);
*/

