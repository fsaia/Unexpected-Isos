/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/

General dual graphs (type GrphDual)

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

declare attributes GrphDualVert:
  name,          // vertex(=component) name, by default c1, c2, ..., 
                 //   = label in underlying multigraph (unique)
  g,             // genus
  m,             // multiplicity
  aliases,       // alternative names, if necessary, for HasComponent
  texname,       // tex label, usually empty for chain components
  singular,      // whole component singular?
  pts, singpts;  // special points [pt1,pt2,...] to be added in TeX, e.g.
                 //   singular pts, nodes of unknown depth, ...
                 // each point is either a standard command "redbullet" or "bluenode" 
                 //   or tuple <style, label, width, height, margins>

declare attributes GrphDual: 
  V,      // associative array: name -> vertex of type GrphDualVert
          //   one for each component, not necessarily principal
  G,      // underlying abstract multigraph of all components
          // vertex labels come from v`name
  P,      // principal components (sequence of names)
  C,      // chains of P1s - one for includetexname=false one for =true
          // [<"1","1",[2,3,2]>,<"1","2",[]>,...] initialised by ChainsOfP1s
  specialchains,  // singular and other special chains, and those of variable length
                  //  in the format <c1, c2, singular, linestyle, endlinestyle, 
                  //     labelstyle, margins, P1length, multiplicities>
  texsettings;    // [["name","setting"],...] settings overwriting defaults in settings.m

*
* IMPLEMENTS
*
type GrphDualVert
type GrphDual
declare attributes GrphDual: 
  V,      // associative array: name -> vertex of type GrphDualVert
          //   one for each component, not necessarily principal
  G,      // underlying abstract multigraph of all components
          // vertex labels come from v`name
  P,      // principal components (sequence of names)
  C,      // chains of P1s - one for includetexname=false one for =true
          // [<"1","1",[2,3,2]>,<"1","2",[]>,...] initialised by ChainsOfP1s
  specialchains,  // singular and other special chains, and those of variable length
                  //  in the format <c1, c2, singular, linestyle, endlinestyle, 
                  //     labelstyle, margins, P1length, multiplicities>
  texsettings;    // [["name","setting"],...] settings overwriting defaults in settings.m
*
* Default construction 
*
intrinsic DualGraph(m::SeqEnum[RngIntElt], g::SeqEnum[RngIntElt], E::SeqEnum[SeqEnum]: comptexnames:="%o", texsettings:=[]) -> GrphDual  [308]
*
* Step by step construction
*
intrinsic DualGraph(: texsettings:=[]) -> GrphDual                                                              [399]
  Create an empty dual graph. Assumes components and chains will be added later.
intrinsic AddComponent(~G::GrphDual, c::MonStgElt, genus::RngIntElt, mult::RngIntElt: texname:=c, singular:=false)  [412]
intrinsic AddComponent(~G::GrphDual, ~c::MonStgElt, genus::RngIntElt, mult::RngIntElt: texname:=c, singular:=false)  [432]
intrinsic AddComponent(~G::GrphDual, genus::RngIntElt, mult::RngIntElt)                                         [441]
  Add a no-named vertex to a dual graph corresponding to a component with a genus and multiplicity
intrinsic AddChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, mults::SeqEnum[RngIntElt])                       [448]
  Add a chain of P1s with multiplicities (possibly empty) between components c1 and c2
intrinsic AddMinimalInnerChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, d::RngIntElt, a::FldRatElt, b::FldRatElt: family:=false)  [467]
intrinsic AddMinimalOuterChain(~G::GrphDual, c::MonStgElt, d::RngIntElt, a::FldRatElt)                          [498]
intrinsic AddSingularPoint(~G::GrphDual, c::MonStgElt, point::MonStgElt)                                        [518]
  Add a standard singular point point = "redbullet" or "bluenode" on a component c of a dual graph
intrinsic AddSingularChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt: singular:=true, mults:=[""], linestyle:="default", endlinestyle:="default", labelstyle:="default",   [539]
linemargins:="default", P1linelength:="default")
intrinsic AddVariableChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, mults::List)                             [555]
  Add a chain where some parts have variable length, e.g. [* 1,2,<3,"$n$">,<4,"$m$">,3,2,1 *]
*
* Arithmetic invariants of dual graphs
*
intrinsic IsSingular(G::GrphDual) -> BoolElt                                                                    [605]
intrinsic IsConnected(G::GrphDual) -> BoolElt                                                                   [613]
  True if underlying graph is connected.
intrinsic ConnectedComponents(G::GrphDual) -> SetEnum[GrphDual]                                                 [620]
  Connected components of a dual graph as a dual graph
intrinsic HasIntegralSelfIntersections(G::GrphDual) -> BoolElt                                                  [670]
  Are all component self-intersections integers
intrinsic AbelianDimension(G::GrphDual) -> RngIntElt                                                            [676]
  Sum of genera of components)
intrinsic ToricDimension(G::GrphDual) -> RngIntElt                                                              [682]
  Number of loops in the dual graph
intrinsic IntersectionMatrix(G::GrphDual) -> AlgMatElt                                                          [689]
  Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.
*
* Contracting components to get a mrnc model
*
intrinsic AddEdge(~G::GrphDual, c1::MonStgElt, c2::MonStgElt)                                                   [716]
  Add an edge between two components in a dual graph
intrinsic ContractComponent(~G::GrphDual, c::MonStgElt: checks:=true)                                           [725]
  Contract a component in the dual graph, assuming it meets one or two components, and has genus 0
intrinsic MakeMRNC(~G::GrphDual)                                                                                [744]
  Contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal crossings
*
* Invariants of individual vertices (components)
*
intrinsic Components(G: GrphDual) -> SeqEnum[MonStgElt]                                                         [772]
  Names of all components of G, e.g. "1","2","c3","c4","c5"
intrinsic HasComponent(G::GrphDual, c::MonStgElt) -> BoolElt, MonStgElt                                         [778]
  True if the dual graph has a component with a given c, in which case also return its index
intrinsic AddAlias(~G::GrphDual, c::MonStgElt, alias:MonStgElt)                                                 [799]
  Add alias to a component c, e.g "2+" for "2"
intrinsic Genus(G::GrphDual, c::MonStgElt) -> RngIntElt                                                         [820]
  Genus of a component in a dual graph
intrinsic Multiplicity(G::GrphDual, c::MonStgElt) -> RngIntElt                                                  [833]
  Multiplicity of a component in a dual graph
intrinsic Intersection(G::GrphDual, c1::MonStgElt, c2::MonStgElt) -> FldRatElt                                  [847]
  Compute intersection of two components in a dual graph, or self-intersection if c1=c2
*
* Principal components and chains of $\P^1$s
*
intrinsic Neighbours(G::GrphDual, c::MonStgElt) -> SeqEnum[MonStgElt]                                           [885]
  Neighbour vertices of a component, one for every edge (and two for every loop)
intrinsic PrincipalComponents(G::GrphDual: shownamed:=false) -> SeqEnum                                         [916]
intrinsic ChainsOfP1s(G::GrphDual: shownamed:=false) -> SeqEnum                                                 [941]
*/

declare type GrphDualVert;

declare attributes GrphDualVert:
  name,          // vertex(=component) name, by default c1, c2, ..., 
                 //   = label in underlying multigraph (unique)
  g,             // genus
  m,             // multiplicity
  aliases,       // alternative names, if necessary, for HasComponent
  texname,       // tex label, usually empty for chain components
  singular,      // whole component singular?
  pts, singpts;  // special points [pt1,pt2,...] to be added in TeX, e.g.
                 //   singular pts, nodes of unknown depth, ...
                 // each point is either a standard command "redbullet" or "bluenode" 
                 //   or tuple <style, label, width, height, margins>

declare type GrphDual;

declare attributes GrphDual: 
  V,      // associative array: name -> vertex of type GrphDualVert
          //   one for each component, not necessarily principal
  G,      // underlying abstract multigraph of all components
          // vertex labels come from v`name
  P,      // principal components (sequence of names)
  C,      // chains of P1s - one for includetexname=false one for =true
          // [<"1","1",[2,3,2]>,<"1","2",[]>,...] initialised by ChainsOfP1s
  specialchains,  // singular and other special chains, and those of variable length
                  //  in the format <c1, c2, singular, linestyle, endlinestyle, 
                  //     labelstyle, margins, P1length, multiplicities>
  texsettings;    // [["name","setting"],...] settings overwriting defaults in settings.m


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

import "mmylib.m": Z, Q, PR, RFF, exp, Right, IsEvenZ, IsOddZ, writeq, Count, Left,
  IncludeAssoc, SortSet, trim, trimright, Last, DelSpaces, DelSymbols,
  ReplaceStringFunc, VectorContent, SortBy, SetAndMultiplicities,
  SetQAttribute, GetQAttribute, PrintSequence, HirzebruchJung, Dotted,
  PolynomialFit, VertexChainToSequence, GraphLongestChain, PlanarCoordinates,
  AllPaths, PreferenceOrder, PreferenceOrder2, SortByFunc;  

/*
Manual
\let\G\Gamma
A dual graph is a combinatorial representation of the special fibre of a model with normal crossings. 
It is a multigraph whose 
vertices are components $\Gamma_i$, and an edge corresponds to an intersection point of two components.
Every component $\G$ has \textbf{multiplicity} $m=m_\G$ and geometric \textbf{genus} $g=g_\G$. 
Here are three examples of dual graphs, and their associated reduction types; we always indicate the multiplicity 
of a component (as an integer), and only indicate the genus when it is positive (as g followed by an integer).

\smallskip
% I4
\begin{center}
\begin{tabular}{c@{\qquad\qquad\qquad}c@{\qquad\qquad\qquad}c}
\begin{tikzpicture}[xscale=0.9,yscale=0.9, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(1.33,0) node[mainl] {1} node[facel] {}; \draw[l2] (0,0)--node[leftl] {1} (0,0.66); \draw[l2] (0,0.66)--node[abovel] {1} (0.66,0.66); \draw[l2] (0.66,0)--node[rightl] {1} (0.66,0.66); \end{tikzpicture}
&
% I1-IV*
\begin{tikzpicture}[xscale=0.9,yscale=0.9, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {3} node[facel] {$\Gamma_2$}; \draw[l2] (0.66,0)--node[rightl] {2} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {1} (0.66,0.66); \draw[l2] (2.13,0)--node[rightl] {2} (2.13,0.66); \draw[l2] (1.46,0.66)--node[abovel] {1} (2.13,0.66); \draw[l1] (2.93,0.66)--(4.8,0.66) node[mainl] {1} node[facel] {$\Gamma_1$}; \draw[l2] (2.93,0)--node[rightl] {2} (2.93,0.66); \path[draw,thick] (3.53,0.66) edge[white,line width=2] ++(0.6,0) edge[out=0,in=-90] ++(0.6,0.4) ++(0.6,0.4) edge[out=90,in=0] ++(-0.3,0.3) ++(-0.3,0.3)  edge[out=180,in=90] ++(-0.3,-0.3) ++(-0.3,-0.3) edge[out=-90,in=180] ++(0.6,-0.4); \end{tikzpicture}
&
% IIg1-III
\begin{tikzpicture}[xscale=0.9,yscale=0.9, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {4} node[facel] {$\Gamma_2$}; \draw[l2end] (0,0)--node[rightl] {2} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,0.66)--(3.66,0.66) node[mainl] {6 \smash{g}1} node[facel] {$\Gamma_1$}; \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {2} (2.2,1.33); \draw[l2end] (3,0.66)--node[rightl] {3} (3,1.33); \end{tikzpicture}
\\[4pt]
Type \redtype{I_4} (genus 1) & Type \redtype{I_1\e IV*} (genus 2) & Type \redtype{II_{g1}\e III} (genus 8). \\[4pt]
\end{tabular}
\end{center}

A component is \textbf{principal} if it 
meets the rest of the special fibre in at least 3 points (with loops on a component counting twice), or has $g>0$.
The first example has no principal components, and the other two have two each, $\G_1$ and $\G_2$.

This module dualgraph.m provides a data type (\textbf{GrphDual}) for representing dual graphs and their
manupulation and invariants. Sometimes, when working with models, it is desirable to store and draw incomplete or singular 
dual graphs, such as these (see \cite[Ex 3.18]{newton}):

\begin{center}
\begin{tikzpicture}[xscale=0.8,yscale=0.7, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1sing/.style={very thick,red!70}, l2sing/.style={l2,very thick,red!70}, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, redbull/.style={red,label={[red,scale=0.6,above=-0.17]#1}}] \draw[l1] (0,0)--(1.46,0) node[mainl] {2} node[facel] {$F_1^a$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l1] (0.8,2.08)--(6.8,2.08) node[mainl] {1} node[facel] {$F_2^b$}; \draw[l1,l1sing] (0.8,0.66)--(6.8,0.66) node[mainl] {3} node[facel] {$F^L_4$}; \draw[l2sing,l2sing] (0.8,0)--(0.8,0.66); \draw[l1,l1sing] (1.4,1.33)--(2.66,1.33) node[mainl] {2} node[facel] {$F_2^a$}; \draw[l2sing,l2sing] (1.4,0.66)--(1.4,1.33); \node[redbull=a] at (2,1.33) {$\bullet$}; \draw[l1] (4.06,1.33)--(4.73,1.33) node[mainl] {2} node[facel] {$F_1^b$}; \draw[l2sing,l2sing] (4.06,0.66)--(4.06,1.33); \draw[l2sing,l2sing] (6.13,0.66)--(6.13,2.08); \end{tikzpicture}
\qquad\qquad
\begin{tikzpicture}[xscale=0.8,yscale=0.7, zigz/.style={l2,snake=zigzag,segment length=2,segment amplitude=1,blue!70!black,shorten >=0,shorten <=0}, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {2} node[facel] {$F_4$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (2.26,1.83)--(4.4,1.83) node[mainl] {4} node[facel] {$F_1^b$}; \draw[l1] (1.6,0.66)--(3.66,0.66) node[mainl] {4} node[facel] {$F_1^a$}; \draw[l2] (1.6,0)--node[rightl] {2} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {2} (2.2,1.33); \draw[zigz] (3,0.66)--node[rightl] {$\!\!\!\!\!?\>\>\,$4} (3,1.83); \draw[l2] (2.26,1.83)--node[rightl] {3} (2.26,2.5); \draw[l2] (1.6,2.5)--node[abovel] {2} (2.26,2.5); \draw[l2end] (1.6,2.5)--node[leftl] {1} (1.6,3.16); \draw[l2end] (3.73,1.83)--node[rightl] {1} (3.73,2.5); \end{tikzpicture}
\end{center}

Such dual graphs are supported as well.
*/

/*
Manual
\begin{verbatim}
type GrphDual:
  V,      // associative array: name -> vertex of type GrphDualVert
          //   one for each component, not necessarily principal
  G,      // underlying abstract multigraph of all components
          // vertex labels come from v`name
  P,      // principal components (sequence of names)
  C,      // chains of P1s - one for includetexname=false one for =true
          // [<"1","1",[2,3,2]>,<"1","2",[]>,...] initialised by ChainsOfP1s
  specialchains,  // singular and other special chains, and those of variable length
                  //  in the format <c1, c2, singular, linestyle, endlinestyle, 
                  //     labelstyle, margins, P1length, multiplicities>
  texsettings;    // [["name","setting"],...] settings overwriting defaults in settings.m
\end{verbatim}
*/


// Internal functions


intrinsic IsCoercible(v::GrphDualVert, y::.) -> BoolElt, .       //
{Coerce a dual graph vertex.}
  return false, _; 
end intrinsic;


intrinsic 'in'(v::GrphDualVert, y::.) -> BoolElt                // 
{"in" function for a dual graph vertex.}
  return false; 
end intrinsic;


intrinsic Print(v::GrphDualVert, level::MonStgElt)            //
{Print a dual graph vertex.}
  printf "%o%o",Sprint(v`m),v`g eq 0 select "" else "g"*Sprint(v`g);      // 2g3
end intrinsic;


// GrphDual: type functions and printing


intrinsic IsCoercible(G::GrphDual, y::.) -> BoolElt, .    //
{Coerce a Dual Graph.}
  return false, _; 
end intrinsic;


intrinsic 'in'(G::GrphDual, y::.) -> BoolElt      //
{"in" function for a Dual Graph.}
  return false; 
end intrinsic;


intrinsic Print(G::GrphDual, level::MonStgElt)         //
{Print a Dual Graph.}
  if level eq "Magma" then
    V:=Vertices(G);
    E:=Edges(G);
    mstr:=DelSpaces([Multiplicity(G,v): v in V]);
    gstr:=DelSpaces([Genus(G,v): v in V]);
    estr:=DelSpaces(Sort([ Sort([Position(V,v): v in EndVertices(e)]): e in E]));
    printf "DualGraph(%o, %o, %o)",mstr,gstr,estr;
    return;
  end if;
  printf "Dual graph on %o vertices and %o edges\n",#G`V,#Edges(G);
  if level eq "Minimal" then return; end if;
  S:=SortSet(Keys(G`V));
  for s in S do
    d:=G`V[s];
    printf "%-2o%-2o  %-6o %o\n",
      d`g eq 0 select "" else "g"*Sprint(d`g),
      d`m eq 1 select "" else "m"*Sprint(d`m),
      s,
      PrintSequence(Sort(Neighbours(G,s)): sep:=" ");
  end for; 
end intrinsic;


/// Default construction 


procedure ResetPrincipalComponentsAndChains(~G)
  // reset all principal components and chains - called every time after adding or modifying vertices or edges
  if IsDefined(G`P,false) then Remove(~G`P,false); end if;
  if IsDefined(G`P,true) then Remove(~G`P,true); end if;
  if IsDefined(G`C,false) then Remove(~G`C,false); end if;
  if IsDefined(G`C,true) then Remove(~G`C,true); end if;
end procedure;


intrinsic DualGraph(m::SeqEnum[RngIntElt], g::SeqEnum[RngIntElt], E::SeqEnum[SeqEnum]: comptexnames:="%o", texsettings:=[]) -> GrphDual
{Construct a dual graph from a sequence of n multiplicities of components, sequence of n genera of components and sequences of edges. Each edge is either 
  [i,j]           - intersection point between component #i and component #j (1<=i,j<=n)
  [i,0,d1,d2,...] - open chain from component #i (1<=i<=n)
  [i,j,d1,d2,...] - link chain from component #i to component #j (1<=i,j<=n)
This can be used to reconstruct a dual graph printed with Sprint(G,"Magma").
comptexnames determines the names of principal components in TeX (v`texname), and each component for which texname<>""
is considered principal when drawing dual graphs. The options are 
  comptexnames::MonStgElt    - string such as "c%o" which assigns names for principal components (and only those) 
    among those specified by m_i, g_i    
  comptexnames::SeqEnum      - sequence of strings for all components specified by m_i, g_i
  comptexnames::UserFunction - function i->string that defines such a sequence.}

  error if #m ne #g,"Multiplicities and genera must be of the same length";

  G:=DualGraph(: texsettings:=texsettings);                       // Vertices   
  for i:=1 to #m do                          
    AddComponent(~G,Sprint(i),g[i],m[i]: texname:="");
  end for;

  V:=Vertices(G`G);
  for e in E do                                                   // Edges
    error if Universe(e) ne Z,     
      Sprintf("DualGraph: %o: Expected integers (RngIntElt) as elements",DelSpaces(e));
    if #e lt 2 then
      error Sprintf("DualGraph: Edge %o is not a sequence [v1,v2] (edge), [v1,0,d1,d2,...] (open chain) or [v1,v2,d1,d2,...] (link chain)",DelSpaces(e));
    end if;
    error if e[1] eq 0 or Min(e[1],e[2]) lt 0 or Max(e[1],e[2]) gt #m,
      Sprintf("Invalid edge %o: component indices must be in 1..%o",DelSpaces(e),#m);
    if #e eq 2 then                                          // Two components meeting at a point
      assert e[2] ne 0;
      AddEdge(~G`G,V[e[1]],V[e[2]]);
    elif e[2] eq 0 then                          
      AddChain(~G,Sprint(e[1]),"",e[[3..#e]]);               // Open chain 
    else
      AddChain(~G,Sprint(e[1]),Sprint(e[2]),e[[3..#e]]);     // Link chain 
    end if;
  end for;

  if Type(comptexnames) in [UserProgram, Intrinsic] then     // TeX names for components
    comptexnames:=[comptexnames(i): i in [1..#m]];
  elif Type(comptexnames) eq MonStgElt then
    error if Position(comptexnames,"%o") eq 0, "comptexnames (when a string) must contain %o, such as '\\Gamma_{%o}'";
    P:=PrincipalComponents(G);
    ResetPrincipalComponentsAndChains(~G);
    comptexnames:=[Sprint(i) in P select Sprintf(comptexnames,i) else "": i in [1..#m]]; 
  elif Type(comptexnames) ne SeqEnum then
    error Sprintf("DualGraph: comptexnames=%o is neither 'default' nor a sequence of names nor a function i->name(i)",comptexnames);
  end if;

  for i:=1 to #m do
    G`V[Sprint(i)]`texname:=comptexnames[i];
  end for;

  return G;
end intrinsic;


/*
Example Constructing a dual graph
m := [3,1,1,1,3];       // All components and intersection points
g := [0,0,0,0,0];
E := [[1,2],[1,3],[1,4],[2,5],[3,5],[4,5]];
G1:= DualGraph(m,g,E);
m := [3,3];             // Principal components and chains (same graph)
g := [0,0];
E := [[1,2,1],[1,2,1],[1,2,1]];
G2:= DualGraph(m,g,E);
m := [3,3];
g := [0,0];             // Principal components, different chains 
E := [[1,2,1],[1,2,1,1],[1,2,1,1,1,1]];
G3:= DualGraph(m,g,E);
TeX(G1)*"\\qquad"*TeX(G2)*"\\qquad"*TeX(G3); //> TeX(G1), TeX(G2), TeX(G3);
*/


/*
Example Printing dual graph as a string and reconstructing it
R:=ReductionType("1g1-1g2-1g3-c1");   
G:=DualGraph(R);                     // Triangular dual graph on 3 vertices and 3 edges
TeX(G);
Sprint(G,"Magma");                   // Printed as DualGraph(m,g,E)
G2:=eval Sprint(G,"Magma");          // and reconstructed back
Sprint(G2,"Magma");
*/


/// Step by step construction



intrinsic DualGraph(: texsettings:=[]) -> GrphDual
{Create an empty dual graph. Assumes components and chains will be added later.}
  G:=New(GrphDual); 
  G`V:=AssociativeArray();
  G`G:=MultiGraph<0|>;
  G`specialchains:=[];
  G`texsettings:=texsettings;
  G`P:=AssociativeArray();
  G`C:=AssociativeArray();
  return G;
end intrinsic;


intrinsic AddComponent(~G::GrphDual, c::MonStgElt, genus::RngIntElt, mult::RngIntElt: texname:=c, singular:=false)
{Add a vertex to a dual graph corresponding to a component with a given name c, genus, multiplicity and optional texname.
If singular:=true, the whole graph is marked as singular (no associated reduction type) and the component is drawn in red.}
  error if c eq "", "AddComponent: empty c"; 
  error if HasComponent(G,c), Sprintf("Component named %o is already in G",c);
  AddVertex(~G`G,c);
  v:=New(GrphDualVert);
  v`name:=c;
  v`m:=mult;
  v`g:=genus;
  v`texname:=texname;
  v`aliases:={Parent("")|};
  v`singular:=singular;
  v`pts:=[* *];
  v`singpts:=[* *];
  G`V[c]:=v;
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic AddComponent(~G::GrphDual, ~c::MonStgElt, genus::RngIntElt, mult::RngIntElt: texname:=c, singular:=false)
{Add a vertex to a dual graph corresponding to a component, with given genus and multiplicity.
If singular:=true, the whole graph is marked as singular (no associated reduction type) and the component is drawn in red.
Sets and returns component name in c if c="".}
  if c eq "" then c:="c"*Sprint(#G+1); end if;
  AddComponent(~G,c,genus,mult: texname:=texname, singular:=singular);
end intrinsic;


intrinsic AddComponent(~G::GrphDual, genus::RngIntElt, mult::RngIntElt)
{Add a no-named vertex to a dual graph corresponding to a component with a genus and multiplicity}
  c:="";
  AddComponent(~G,~c,genus,mult);
end intrinsic;


intrinsic AddChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, mults::SeqEnum[RngIntElt])
{Add a chain of P1s with multiplicities (possibly empty) between components c1 and c2}
  n1:=AssertHasComponent(G,c1);
  L:=[* n1 *];
  for i:=1 to #mults do 
    name:="";
    AddComponent(~G,~name,0,mults[i]);
    Append(~L,name);
  end for;  
  if c2 notin ["","0"] then
    n2:=AssertHasComponent(G,c2);
    Append(~L,n2);
  end if;
  for i:=1 to #L-1 do
    AddEdge(~G,L[i],L[i+1]);
  end for;
end intrinsic;


intrinsic AddMinimalInnerChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, d::RngIntElt, a::FldRatElt, b::FldRatElt: family:=false)
{Add a chain of P1s between c1 and c2 (open-ended if c2="") with multiplicities d times denominators
of minimal continued fractions from a to b.
family:=true or family:="$n$" shows multiplicity d components as variable chains of a given length (none or $n$).}

  n1:=VertexByLabel(G`G,AssertHasComponent(G,c1));
  L:=[* n1 *];
  mults:=[d*Denominator(x): x in HirzebruchJung(d*a,d*b)];

  vprint CrvHyp, 3: ">addmfc>",DelSpaces(mults);
  if family cmpeq false then
    AddChain(~G,c1,c2,mults[[2..#mults-1]]);
    return;
  end if;

  error if c2 eq "", "Open chain must have family parameter =false"; 
  c:=Count(mults[[2..#mults-1]],d);
  if c eq 0 then 
    mults:=[d*Denominator(x): x in HirzebruchJung(d*a+1,d*b)]; 
    c:=Count(mults[[2..#mults-1]],d);
    assert c gt 0;
  end if;  
  p:=Position(mults,d,2); 
  mults:=mults[[1..p]] cat [a: a in mults[[p+1..#mults-1]] | a ne d] cat mults[[#mults]];
  len:=family cmpeq true select "" else Sprint(family);
  mults:=[* a eq d select <d,len> else a: a in mults[[2..#mults-1]] *];
  n2:=VertexByLabel(G`G,AssertHasComponent(G,c2));
  AddVariableChain(~G,c1,c2,mults);
end intrinsic;


intrinsic AddMinimalOuterChain(~G::GrphDual, c::MonStgElt, d::RngIntElt, a::FldRatElt)
{Add an open-ended chain of P1s from c with multiplicities d times denominator
  of minimal continued fractions from a to an integer Floor(d*a-1)/d.}
  AddMinimalInnerChain(~G,c,"",d,a,Floor(d*a-1)/d);
end intrinsic;


/*
Example Hand-crafted dual graphs with variable length chains
G:=DualGraph();
AddComponent(~G,"A",0,7);
AddMinimalOuterChain(~G,"A",1,6/7);           // open 
AddMinimalInnerChain(~G,"A","A",1,5/7,3/7);   // link
assert IsConnected(G) and not IsSingular(G);
AddMinimalInnerChain(~G,"A","A",1,5/7,3/7: family:="$n$");
AddMinimalInnerChain(~G,"A","A",1,5/7,3/7: family);
TeX(G);
*/


intrinsic AddSingularPoint(~G::GrphDual, c::MonStgElt, point::MonStgElt)
{Add a standard singular point point = "redbullet" or "bluenode" on a component c of a dual graph}
  error if point notin ["redbullet","bluenode"], "AddSingularPoint: point is neither 'redbullet' nor 'bluenode'";
  c:=AssertHasComponent(G,c);
  Append(~G`V[c]`singpts,[* point *]);
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic AddSpecialPoint(~G::GrphDual, c::MonStgElt, style::MonStgElt, label::MonStgElt: singular:=true, width:=1/4, height:=1/2, margins:=<1/4,1/4,1/4,1/4>)
{Add a special point on a component c of a dual graph. label is a TeX code for how the point is marked, and style is the corresponding tikz style. By default such a point marks the dual graph as singular (singular:=true).}
  c:=AssertHasComponent(G,c);
  if singular then
    Append(~G`V[c]`pts,<style, label, width, height, margins>);
  else
    Append(~G`V[c]`singpts,<style, label, width, height, margins>);
  end if;
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic AddSingularChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt: singular:=true, mults:=[""], linestyle:="default", endlinestyle:="default", labelstyle:="default", 
linemargins:="default", P1linelength:="default")
{Add a singular chain in given tikz style with multiplicities mults (sequence of integers or strings) 
    between c1 and c2; use c2="0" for an open chain; default style="red"}
  c1:=AssertHasComponent(G,c1);
  if c2 in ["0",""] 
    then c2:="";
    else c2:=AssertHasComponent(G,c2); 
  end if;
  Append(~G`specialchains,<c1,c2,singular,linestyle,endlinestyle,labelstyle,
      linemargins, P1linelength, [* s: s in mults *]>);
  // if c2 ne "" then AddEdge(~G,c1,c2); end if;  // No, messes up incident edges
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic AddVariableChain(~G::GrphDual, c1::MonStgElt, c2::MonStgElt, mults::List)
{Add a chain where some parts have variable length, e.g. [* 1,2,<3,"$n$">,<4,"$m$">,3,2,1 *]}
  AddSingularChain(~G,c1,c2: singular:=false, mults:=mults);
end intrinsic;


/*
Example Hand-crafted dual graphs with all possible decorations
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
"$$"*TeX(G)*"$$"; //> TeX(G);
*/


/*
Example K4
// TeX for dual graphs is limited to small planar graphs, and K4 is more or less the most complex one 
// that it can draw. Here is a reduction type like that:
R:=ReductionType("1-(3)IV-(3)IV*-(2)I0*-(3)c1-(2)c3&c2-(4)c4");
TeX(R: scale:=1.5);
TeX(DualGraph(R));
*/


/// Arithmetic invariants of dual graphs


intrinsic '#'(G::GrphDual) -> RngIntElt
{Number of vertices (components) in the dual graph}
  return #(G`V);
end intrinsic;


intrinsic IsSingular(G::GrphDual) -> BoolElt
{Check if G has any singular components or points, or special chains. If yes, no self-intersections 
will be checked components contracted (so MakeMRNC does nothing).}
  return exists{v: v in Keys(G`V) | G`V[v]`singular or not IsEmpty(G`V[v]`singpts)}   
    or not IsEmpty(G`specialchains);
end intrinsic;


intrinsic IsConnected(G::GrphDual) -> BoolElt
{True if underlying graph is connected.}
  error if IsSingular(G), "Cannot check connectedness and other arithmetic properties for singular dual graphs";
  return IsConnected(G`G);
end intrinsic;


intrinsic ConnectedComponents(G::GrphDual) -> SetEnum[GrphDual]
{Connected components of a dual graph as a dual graph}
  V:=SortSet(Keys(G`V));       // vertex names

  SG:=Graph<#V|>;              // simple graph to compute connected components
  for e in Edges(G`G) do 
    i:=[Position(V,Label(v)): v in EndVertices(e)];
    if #i eq 1 then continue; end if;    // ignore loops
    SG+:={i[1],i[2]};
  end for;     
  for c in G`specialchains do
    s1,s2:=Explode(c);
    if s2 eq "" or s1 eq s2 then continue; end if;
    i1:=Position(V,s1);
    i2:=Position(V,s2);
    SG+:={i1,i2};
  end for;

  C:=SortByFunc(ConnectedComponents(SG),func<C|-#C>);    // Sort by size in decreasing order

  if #C eq 1 then return [G]; end if;

  CG:=[DualGraph(): c in C];                             // prepare list of dual graphs, one for each connected component
  for i->v in V do                                       // add vertices
    assert exists(j){j: j->c in C | i in c}; 
    AddComponent(~CG[j],v,Genus(G,v),Multiplicity(G,v): texname:=G`V[v]`texname);
  end for;
  for E in Edges(G`G) do                                 // add edges
    e:=[Position(V,Label(v)): v in EndVertices(E)];
    if #e eq 1 then
      e:=[e[1],e[1]];
    end if;
    assert exists(j){j: j->c in C | e[1] in c}; 
    assert exists(j2){j: j->c in C | e[2] in c}; 
    assert j eq j2;
    AddEdge(~CG[j],V[e[1]],V[e[2]]);
  end for;     
  for c in G`specialchains do                            // add special chains
    s1,s2:=Explode(c);
    assert exists(j){j: j->c in C | s1 in Keys(CG[j]`V)}; 
    Append(~CG[j]`specialchains,c);
  end for;     
  for i:=1 to #CG do
    CG[i]`texsettings:=G`texsettings;
  end for;

  return CG; 
end intrinsic;


intrinsic HasIntegralSelfIntersections(G::GrphDual) -> BoolElt
{Are all component self-intersections integers}
  return forall{v: v in Components(G) | IsCoercible(Z,Intersection(G,v,v))};
end intrinsic;


intrinsic AbelianDimension(G::GrphDual) -> RngIntElt
{Sum of genera of components)}
  return &+[Genus(G,s): s in Keys(G`V)];  
end intrinsic;


intrinsic ToricDimension(G::GrphDual) -> RngIntElt
{Number of loops in the dual graph}
  error if not IsConnected(G), "Dual graph appears to be disconnected";
  return #Edges(G`G)-#Vertices(G`G)+1;
end intrinsic;


intrinsic IntersectionMatrix(G::GrphDual) -> AlgMatElt
{Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.}
  error if not IsConnected(G), "Dual graph appears to be disconnected";
  error if IsSingular(G), "Dual graph has singular points or variable length chains";
  C:=Components(G);
  return Matrix([[Z| Intersection(G,v,w): v in C]: w in C]);
end intrinsic;


/*
Example
// Here is the dual graph of the reduction type \redtype{1_{g3}\e1_{g2}\e1_{g1}\e c_1}, consisting of 
// three components genus 1,2,3, all of multiplicity 1, connected in a triangle.
G := DualGraph([1,1,1],[1,2,3],[[1,2],[2,3],[3,1]]);  
assert not IsSingular(G);                  // Has no singular points or components
assert IsConnected(G);                     // Check the dual graph is connected
assert HasIntegralSelfIntersections(G);    //   and every component c has c.c in Z
AbelianDimension(G);                       // genera 1+2+3 => 6
ToricDimension(G);                         // 1 loop       => 1
TeX(ReductionType(G));
IntersectionMatrix(G);                     // Intersection(G,v,w) for v,w components
*/


/// Contracting components to get a mrnc model


intrinsic AddEdge(~G::GrphDual, c1::MonStgElt, c2::MonStgElt)
{Add an edge between two components in a dual graph}
  v1:=VertexByLabel(G`G,c1);
  v2:=VertexByLabel(G`G,c2);
  AddEdge(~G`G,v1,v2);
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic ContractComponent(~G::GrphDual, c::MonStgElt: checks:=true)
{Contract a component in the dual graph, assuming it meets one or two components, and has genus 0}
  c:=AssertHasComponent(G,c);   
  N:=Neighbours(G,c);
  if checks then
    error if Genus(G,c) ne 0, "Positive genus component cannot be contracted";
    error if Intersection(G,c,c) ne -1, Sprintf("Cannot contract component %o of self-intersection %o<>-1",c,Intersection(G,c,c));
    error if #N gt 3, "Component that meets the special fibre in >2 points cannot be contracted";
    error if #G eq 1, "Cannot contract last remaining component";
  end if;
  if #N eq 2 then
    AddEdge(~G,N[1],N[2]);
  end if;
  RemoveVertex(~G`G,VertexByLabel(G,c));
  Remove(~G`V,c);    
  ResetPrincipalComponentsAndChains(~G);
end intrinsic;


intrinsic MakeMRNC(~G::GrphDual)
{Contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal crossings}
  if IsSingular(G) then return; end if;
  error if not IsConnected(G), "The dual graph is not connected";
  error if not HasIntegralSelfIntersections(G), "The dual graph has non-integral self-intersections";
  while #G gt 1 and exists(c){c: c in Components(G) | Genus(G,c) eq 0 and #Neighbours(G,c) le 2 and Intersection(G,c,c) eq -1} do
    ContractComponent(~G,c: checks:=false);
  end while;
end intrinsic;


/*
Example Contracting components
G := DualGraph([1,1],[1,0],[[1,2,1,1,1]]);    // Not a minimal rnc model
TeX(G);
Components(G);
ContractComponent(~G,"2");                    // Remove the last component
ContractComponent(~G,"c5");                   //   and then the one before that
TeX(G);
Components(G);
MakeMRNC(~G);                                 // Contract the rest of the chain
TeX(G);
*/


/// Invariants of individual vertices (components)


intrinsic Components(G: GrphDual) -> SeqEnum[MonStgElt]
{Names of all components of G, e.g. "1","2","c3","c4","c5"}
  return [Label(v): v in Vertices(G`G)];
end intrinsic;


intrinsic HasComponent(G::GrphDual, c::MonStgElt) -> BoolElt, MonStgElt
{True if the dual graph has a component with a given c, in which case also return its index}
  if c in Keys(G`V) then
    return true, c;
  end if;
  ok:=exists(s){s: s in Keys(G`V) | (G`V[s]`name eq c) or (c in G`V[s]`aliases)};
  if ok 
    then return true,s;
    else return false,_; 
  end if;
end intrinsic;


intrinsic AssertHasComponent(G::GrphDual, c::MonStgElt) -> RngIntElt    //
{Assert that the dual graph a component with a given c and return its index}
  ok,s:=HasComponent(G,c);
  error if not ok, "G has no component c "*c;
  return s;
end intrinsic;


intrinsic AddAlias(~G::GrphDual, c::MonStgElt, alias:MonStgElt)
{Add alias to a component c, e.g "2+" for "2"}
  s:=AssertHasComponent(G,c);
  if c eq alias then return; end if;
  Include(~G`V[s]`aliases,alias); 
end intrinsic;


intrinsic VertexByLabel(G::GrphMultUnd, label::MonStgElt) -> GrphVert  // this is ridiculous
{Find a vertex in an abstract graph by its label}
  assert exists(v){v: v in Vertices(G) | Label(v) eq label};   
  return v;
end intrinsic;


intrinsic VertexByLabel(G::GrphDual, label::MonStgElt) -> GrphVert    //
{Find a vertex in the abstract graph underlying G by its label}
  return VertexByLabel(G`G,label);
end intrinsic;


intrinsic Genus(G::GrphDual, c::MonStgElt) -> RngIntElt
{Genus of a component in a dual graph}
  c:=AssertHasComponent(G,c);
  return G`V[c]`g;
end intrinsic;


intrinsic Genus(G::GrphDual, v::GrphVert) -> RngIntElt   //
{Genus of a component in a dual graph}
  return G`V[Label(v)]`g;
end intrinsic;


intrinsic Multiplicity(G::GrphDual, c::MonStgElt) -> RngIntElt
{Multiplicity of a component in a dual graph}
  if c eq "" then return 0; end if;
  c:=AssertHasComponent(G,c);
  return G`V[c]`m;
end intrinsic;


intrinsic Multiplicity(G::GrphDual, v::GrphVert) -> RngIntElt   //
{Multiplicity of a component in a dual graph}
  return G`V[Label(v)]`m;
end intrinsic;


intrinsic Intersection(G::GrphDual, c1::MonStgElt, c2::MonStgElt) -> FldRatElt
{Compute intersection of two components in a dual graph, or self-intersection if c1=c2}
  c1:=AssertHasComponent(G,c1);
  c2:=AssertHasComponent(G,c2);
  if c1 ne c2 
    then return Count(Neighbours(G,c1),c2);
    else m,L:=IncidentMultiplicities(G,c1: includeself:=false);
         return (-&+L)/m;
  end if;
end intrinsic;



/*
Example Cycle of 5 components
G:=DualGraph([1],[1],[[1,1,1,1,1,1]]);
TeX(G);
C:=Components(G); C;
assert HasComponent(G,"1");
AddAlias(~G,"1","main");
assert HasComponent(G,"main");
Multiplicity(G,"main");
Genus(G,"main");
Matrix([[Intersection(G,v,w): v in C]: w in C]);
*/



/// Principal components and chains of $\P^1$s


intrinsic Neighbours(G::GrphDual, v::GrphVert) -> SeqEnum[GrphVert]   //
{Neighbour vertices of a component, one for every edge (and two for every loop)}
  L:=[Representative({*InitialVertex(e),TerminalVertex(e)*} diff {*v*}): e in IncidentEdges(v)];
  return L cat [w: w in L | w eq v];   // double for self-intersections
end intrinsic;


intrinsic Neighbours(G::GrphDual, c::MonStgElt) -> SeqEnum[MonStgElt]
{Neighbour vertices of a component, one for every edge (and two for every loop)}
  return Labels(Neighbours(G,VertexByLabel(G`G,c)));
end intrinsic;


intrinsic IncidentMultiplicities(G::GrphDual, c::MonStgElt: includeself:=true, reduce:=false) -> RngIntElt, SeqEnum   //
{Multiplicties of a component and adjacent components (e.g. 6,[1,2,3]) for type II)}
  m:=G`V[c]`m; 
  N:=Neighbours(G,c);
  if not includeself then 
    N:=[d: d in N | d ne c];
  end if;
  o:=[Z| Multiplicity(G,c): c in N];
  if reduce then o:=[d mod m eq 0 select m else d mod m: d in o]; end if;
  return m,o;
end intrinsic;


intrinsic Vertices(G::GrphDual) -> SetIndx  //
{Vertices of an underlying multigraph for a dual graph}
  return Vertices(G`G);
end intrinsic;


intrinsic Edges(G::GrphDual) -> SetIndx   //
{Edges of an underlying multigraph for a dual graph}
  return Edges(G`G);
end intrinsic;


intrinsic PrincipalComponents(G::GrphDual: shownamed:=false) -> SeqEnum
{Return a list of indices of principal components.
A vertex is a principal component if either its genus is greater than 0 or it has 3 or more incident edges (counting loops twice).
In the exceptional case [d]I_n one component is declared principal.
shownamed:=true forces all principal components that were set up with non-empty texname to be viewed (and drawn) as principal.}

  if IsDefined(G`P,shownamed) then return G`P[shownamed]; end if;

  P:=[];
  for s in Keys(G`V) do
    d:=G`V[s];
    if (d`g gt 0) or d`singular or (shownamed and d`texname ne "")
      or not IsEmpty(d`pts) or not IsEmpty(d`singpts) or exists{c: c in G`specialchains | s in {c[1],c[2]}}
        then Append(~P,s); continue; end if;
    if #Neighbours(G,d`name) ge 3 then Append(~P,s); end if;   // Principal
  end for;  
  if IsEmpty(P) then           // multiple of I_n -> declare one component to be principal
    P:=[Representative(Keys(G`V))];
  end if;

  G`P[shownamed]:=P;
  return P;
end intrinsic;


intrinsic ChainsOfP1s(G::GrphDual: shownamed:=false) -> SeqEnum
{Sequence of tuples [<v0,v1,[chain multiplicities]>] for chains of P1s between principal components.
shownamed:=true forces all principal components that were set up with non-empty texname to be viewed (and drawn) as principal.}

  if IsDefined(G`C,shownamed) then return G`C[shownamed]; end if;

  P:=PrincipalComponents(G: shownamed:=shownamed);
  Pv:={VertexByLabel(G,s): s in P};
  E:=Edges(G`G);
  chains:=[];
  while exists(e){e: e in E | not IsEmpty(EndVertices(e) meet Set(Pv))} do
    v0:=Representative(EndVertices(e) meet Set(Pv));
    path:=[Z|];
    startv:=Label(v0);
    endv:="";
    repeat
      ee:=EndVertices(e);
      v1:=ee eq {v0} select v0 else Representative(ee diff {v0});
      E:=E diff {e};
      if v1 in Pv then endv:=Label(v1); break; end if;
      Append(~path,Multiplicity(G,v1));
      e:=IncidentEdges(v1) diff {e};
      if IsEmpty(e) then break; end if;
      assert #e eq 1;
      e:=Representative(e);
      v0:=v1;
    until false;
    if exists{c: c in chains | c[1] eq endv and c[2] eq startv} 
      then Append(~chains,<endv,startv,Reverse(path)>);
      else Append(~chains,<startv,endv,path>);
    end if;
  end while;

  G`C[shownamed]:=chains;
  return chains;
end intrinsic;



/*
Example Cycle of 5 components
// We take the same cycle graph as above, on 5 components.
G:=DualGraph([1],[1],[[1,1,1,1,1,1]]);
Components(G);        // Names of all components
Neighbours(G,"c2");   // Neighbouring components, one for every edge out of c2
ChainsOfP1s(G);       // Chains of P1s between principal components
*/


/*
Example Exceptional case {[$d$]}${\rm I}_n$
// In the exceptional case ${\rm I}_n$ (genus 1) and its multiples, one (arbitrary) component
// is declared principal, so that such a reduction type falls into the general framework.
G:=DualGraph(ReductionType("I4"));
TeX(G);
Components(G);
PrincipalComponents(G);    // One component pretends to be principal
ChainsOfP1s(G);            //   and has a chain to itself
*/


