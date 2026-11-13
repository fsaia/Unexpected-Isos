"""
(c) Tim Dokchitser, redlib library, v3.3, May 2025, https://people.maths.bris.ac.uk/~matyd/redlib/
Reduction type library in python (translated from redtype.m + bits from dualgraph.m and planar.m)

[F7] translate redtype.js py-to-js.gpt
[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

*
* IMPLEMENTS
*
def DeterminantBareiss(M)                                                                                       [543]
  Bareiss' algorithm to compute Det(M) in a stable way
*
* Outer and inner chains
*
def OuterSequence(m: int, d: int, includem=True) -> List[int]                                                   [755]
def InnerSequence(m1: int, d1: int, m2: int, dk: int, n: int, includem=True) -> List[int]                       [781]
def MinimalDepth(m1: int, d1: int, m2: int, dk: int) -> int                                                     [839]
  Minimal depth of a inner sequence between principal components of multiplicities m1 and m2 with initial links
  d1 and dk.
def SortMultiplicities(m, O)                                                                                    [904]
  Sort a sequence of multiplicities O by gcd with m, then by o. This is how outer and edge multiplicities are
  sorted in reduction types.
def DefaultMultiplicities(m1, o1, m2, o2, loop)                                                                 [926]
  Default edge multiplicities for a component with given multiplicities and outgoing options.
*
* Principal component core (RedCore)
*
def Core(m: int, O: list[int]) -> 'RedCore'                                                                     [1025]
  Core of a principal component defined by multiplicity m and list O.
*
* Basic invariants and printing
*
class RedCore
  def definition(self)                                                                                          [1072]
    Returns a string representation of a core in the form 'Core(m,O)'.
  def Multiplicity(self)                                                                                        [1078]
    Returns the principal multiplicity m of the principal component.
  def Multiplicities(self)                                                                                      [1084]
    Returns the list of outgoing chain multiplicities O, sorted with SortMultiplicities.
  def Chi(self)                                                                                                 [1090]
    Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)
  def Label(self, tex=False)                                                                                    [1096]
    Label of a reduction type core, for printing (or TeX if tex=True)
  def TeX(self)                                                                                                 [1109]
    Returns the core label in TeX, same as Label with TeX=True.
def Cores(chi, mbound="all", sort=True)                                                                         [1137]
  Returns all cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a
  bound on m must be given.
*
* Inner chains (RedChain)
*
def Link(Class, mi, di, mj=False, dj=False, depth=False, Si=False, Sj=False, index=False) -> 'RedChain'         [1214]
  Define a RedChain from its invariants
*
* Invariants and depth
*
class RedChain
  def Weight(self)                                                                                              [1298]
    Weight of the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,di)).
  def Index(self)                                                                                               [1320]
    Index of the RedChain, used for distinguishing between chains.
  def SetDepth(self, n)                                                                                         [1326]
    Set the depth and depth string of the RedChain.
  def SetMinimalDepth(self)                                                                                     [1338]
    Set the depth of the RedChain to the minimal possible value.
  def DepthString(self)                                                                                         [1346]
    Return the string representation of the RedChain's depth.
  def SetDepthString(self, depth)                                                                               [1351]
    Set how the depth is printed (e.g., "1" or "n").
*
* Principal components (RedPrin)
*
def PrincipalType(m, g, O, Lloops, LD, Ledge, index=0)                                                          [1430]
class RedPrin
  def Multiplicity(self)                                                                                        [1608]
    Principal multiplicity m of a principal type
  def GeometricGenus(self)                                                                                      [1615]
    Geometric genus g of a principal type S=(m,g,O,...)
  def Index(self)                                                                                               [1621]
    Index of the principal component in a reduction type, 0 if freestanding
  def Chains(self, Class=0)                                                                                     [1627]
    Sequence of chains of type RedChain originating in S. By default, all (loops, D-links, edge) are returned,
    unless class is specified.
  def OuterMultiplicities(self)                                                                                 [1636]
    Sequence of outer multiplicities S`O of a principal type, sorted
  def InnerMultiplicities(self)                                                                                 [1642]
    Sequence of inner multiplicities S`L of a principal type, sorted as in label
  def Loops(self)                                                                                               [1648]
    Sequence of chains in S representing loops (class cLoop)
  def DLinks(self)                                                                                              [1654]
    Sequence of chains in S representing D-links (class cD)
  def EdgeChains(self)                                                                                          [1660]
    Sequence of edges of a principal type, sorted
  def EdgeMultiplicities(self)                                                                                  [1666]
    Sequence of edge multiplicities of a principal type, sorted
  def definition(self) -> str                                                                                   [1672]
    Returns a string representation of a principal type in the form of the PrincipalType constructor.
  def GCD(self)                                                                                                 [1704]
    Return GCD(m,O,L) for a principal type
  def Core(self)                                                                                                [1710]
    Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m,O)=1
  def Chi(self)                                                                                                 [1716]
    Euler characteristic chi of a principal type (m,g,O,Lloops,LD,Ledge), chi = m(2-2g-|O|-|L|) + sum_(o in O)
    gcd(o,m), where L consists of all the inner multiplicities in Lloops (2 from each), LD (1 from each), Ledge
    (1 from each)
  def Weight(self)                                                                                              [1722]
    Outgoing link pattern of a principal type = multiset of GCDs of edges with m.
  def Score(self) -> list[int]                                                                                  [1758]
    Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a
    principal type, and characterises it uniquely.
  def __eq__(self, other)                                                                                       [1774]
    Compare two principal types by their score.
  def __lt__(self, other)                                                                                       [1780]
    Compare two principal types by their score.
  def __le__(self, other)                                                                                       [1786]
    Compare two principal types by their score.
  def __gt__(self, other)                                                                                       [1792]
    Compare two principal types by their score.
  def __ge__(self, other)                                                                                       [1798]
    Compare two principal types by their score.
  def TeXLabel(self, edge=False, wrap=False)                                                                    [1908]
  def Label(self, tex=False, html=False, edge=False, wrap=True)                                                 [1963]
  def TeX(self, length="35pt", label=False, standalone=False)                                                   [1993]
def PrincipalTypes(chi: int, arg=None, semistable=False, withweights=False, sort=True) -> Tuple[List[RedPrin], List[List[int]]]  [2125]
def PrincipalTypeFromScore(w: list[int]) -> 'RedPrin'                                                           [2176]
  Create a principal type S from its score sequence w (=Score(S)).
def PrincipalTypesTeX(T, width=10, scale=0.8, sort=True, label=False, length="35pt", yshift="default")          [2299]
*
* RedShape 
*
class RedShape
  def TeX(self, scale=1.5, center=False, shapelabel="", complabel="default", boundingbox=False)                 [2370]
    Tikz a shape of a reduction graph, and, if required the bounding box x1, y1, x2, y2.
  def Graph(self)                                                                                               [2380]
    Returns the underlying undirected graph G of the shape.
  def __len__(self)                                                                                             [2386]
    Returns the number of vertices in the graph G underlying the shape.
  def Vertices(self)                                                                                            [2392]
    Returns the vertex set of G as a graph.
  def Edges(self)                                                                                               [2398]
    Returns the edge set of G as a graph.
  def DoubleGraph(self)                                                                                         [2404]
    Returns the vertex-labelled double graph D of the shape.
  def Chi(self, v=None)                                                                                         [2410]
    Returns the Euler characteristic chi(v) <= 0 of the vertex v, or total Euler characteristic if v=None
  def Weights(self, v)                                                                                          [2423]
    Returns the Weights of a vertex v that together with chi determine the vertex type (chi, weights).
  def VertexLabels(self)                                                                                        [2431]
    Returns a sequence of -chi's for individual components of the shape S.
  def EdgeLabels(self)                                                                                          [2437]
    Returns a list of edges v_i -> v_j of the form [i, j, edgegcd].
def Shape(V: list[int], E: list[list[int]]) -> RedShape                                                         [2449]
  Constructs a graph shape from the vertex data V and list of edges with multiplicities E.
def IsIsomorphic(S1: RedShape, S2: RedShape) -> bool                                                            [2504]
  Check whether two shapes are isomorphic via their double graphs
def Shapes(genus, filemask="data/shapes{}.txt")                                                                 [2521]
  Returns all shapes in a given genus, assuming they were downloaded in data/
*
* Labelled graphs and minimum paths
*
def Graph(vertices, edges=[])                                                                                   [2681]
  Construct a graph from vertices (or their number) and edges, numbered from 1
def IsLabelled(G, v)                                                                                            [2695]
  Determines if vertex v in graph G has an associated label.
def IsLabelled(G)                                                                                               [2702]
  Checks if all vertices in graph G have an assigned label.
def GetLabel(G, x)                                                                                              [2708]
  Retrieves the label of a vertex or edge x from graph G.
def GetLabels(G)                                                                                                [2720]
  Returns a list of labels assigned to the vertices of graph G.
def AssignLabel(G, v, label)                                                                                    [2727]
  Assign a label to the vertex v in graph G.
def AssignLabels(G, labels)                                                                                     [2734]
  Assigns labels to the vertices of graph G based on the provided list of labels.
def DeleteLabels(G)                                                                                             [2742]
  Deletes the labels from all vertices in the graph G if they exist.
def MinimumScorePaths(D)                                                                                        [2751]
  Determines minimum score paths in a connected labelled undirected graph, returning scores and possible vertex
  index sequences.
def GraphLabel(G, full=False, usevertexlabels=True)                                                             [2972]
  Generate a graph label based on a minimum score path, determines G up to isomorphism.
def StandardGraphCoordinates(G)                                                                                 [4003]
  Vertex coordinate lists x,y for planar drawing
def TeXGraph(G, x="default", y="default", labels="default", scale=0.8, xscale=1, yscale=1, vertexlabel="default", edgelabel="default", vertexnodestyle="default", edgenodestyle="default", edgestyle="default")  [4033]
  Generate TikZ code for drawing a small planar graph.
def GraphFromEdgesString(edgesString)                                                                           [4131]
  Construct a graph from a string encoding edges such as "1-2-3-4, A-B, C-D", assigning the vertex labels to the
  corresponding strings.
*
* Dual graphs (GrphDual)
*
*
* Default construction
*
def DualGraph(m: List[int], g: List[int], edges: List[List[int]], comptexnames = "default") -> 'GrphDual'       [4212]
  Construct a dual graph (GrphDual) from multiplicities and genera of vertices, and edges of the underlying
  graph.
*
* Step by step construction
*
class GrphDual
  def __init__(self)                                                                                            [4309]
    Initialize an empty dual graph
  def AddComponent(self, name: str, genus: int, multiplicity: int, texname=None)                                [4318]
  def AddEdge(self, node1, node2)                                                                               [4332]
    Adds an edge between two components (vertices) in the graph.
  def AddChain(self, c1: str, c2: Union[str, None], mults: List[int])                                           [4338]
*
* Global methods and arithmetic invariants 
*
  def Graph(self) -> nx.Graph                                                                                   [4377]
    Returns the underlying graph.
  def Components(self) -> list                                                                                  [4383]
    Returns the list of components (vertices) of the dual graph.
  def IsConnected(self)                                                                                         [4407]
    True if underlying graph is connected
  def HasIntegralSelfIntersections(self)                                                                        [4413]
    Are all component self-intersections integers
  def AbelianDimension(self)                                                                                    [4419]
    Sum of genera of components
  def ToricDimension(self)                                                                                      [4425]
    Number of loops in the dual graph
  def IntersectionMatrix(self)                                                                                  [4433]
    Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.
  def PrincipalComponents(self)                                                                                 [4453]
    Return a list of indices of principal components.
  def ChainsOfP1s(self)                                                                                         [4467]
    Returns a sequence of tuples [(v1,v2,[chain multiplicities]),...] for chains of P1s between principal
    components, and v2=None for outer chains
  def ReductionType(self)                                                                                       [4512]
    Reduction type corresponding to the dual graph
*
* Contracting components to get a mrnc model
*
  def ContractComponent(self, c, checks=True)                                                                   [4522]
    Contract a component in the dual graph, assuming it meets one or two components, and has genus 0.
  def MakeMRNC(self)                                                                                            [4546]
    Repeatedly contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal
    crossings.
  def Check(self)                                                                                               [4563]
    Check that the graph is connected and self-intersections are integers.
*
* Invariants of individual vertices
*
  def HasComponent(self, c)                                                                                     [4611]
    Test whether the graph has a component named c
  def Multiplicity(self, c)                                                                                     [4617]
    Returns the multiplicity m of vertex c from the graph.
  def Multiplicities(self) -> list                                                                              [4625]
    Returns the list of multiplicities of components.
  def Genus(self, c)                                                                                            [4631]
    Returns the geometric genus g of vertex c from the graph.
  def Genera(self) -> list                                                                                      [4639]
    Returns the list of geometric genera of components.
  def Neighbours(self, c)                                                                                       [4645]
    List of incident vertices, with each loop contributing the vertex itself twice
  def Intersection(self, c1, c2)                                                                                [4653]
    Compute the intersection number between components c1 and c2 (or self-intersection if c1=c2).
*
* Reduction Types (RedType)
*
def ReductionType(*args) -> 'RedType'                                                                           [4752]
def ReductionTypes(arg, *args, **kwargs)                                                                        [4812]
class RedType
  def Chi(self)                                                                                                 [4905]
    Total Euler characteristic of R
  def Genus(self)                                                                                               [4911]
    Total genus of R
  def IsGood(self)                                                                                              [4924]
    True if comes from a curve with good reduction
  def IsSemistable(self)                                                                                        [4930]
    True if comes from a curve with semistable reduction (all (principal) components of an mrnc model have
    multiplicity 1)
  def IsSemistableTotallyToric(self)                                                                            [4936]
    True if comes from a curve with semistable totally toric reduction (semistable with no positive genus
    components)
  def IsSemistableTotallyAbelian(self)                                                                          [4942]
    True if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual
    graph)
  def TamagawaNumber(self)                                                                                      [4960]
    Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field
*
* Invariants of individual principal components and chains
*
  def PrincipalTypes(self)                                                                                      [4990]
    Principal types (vertices) of the reduction type
  def __len__(self)                                                                                             [4996]
    Number of principal types in reduction type
  def __getitem__(self, i)                                                                                      [5002]
    Principal type number i in the reduction type, accessed as R[i] (numbered from i=1)
  def InnerChains(self)                                                                                         [5017]
    Return all the inner chains in the reduction type
  def EdgeChains(self) -> list                                                                                  [5023]
    Return all the inner chains in R between different principal components, sorted as in label.
  def Multiplicities(self)                                                                                      [5029]
    Sequence of multiplicities of principal types
  def Genera(self)                                                                                              [5035]
    Sequence of geometric genera of principal types
  def GCD(self)                                                                                                 [5041]
    GCD detecting non-primitive types
  def Shape(self)                                                                                               [5047]
    The shape of the reduction type.
*
* Comparison
*
  def Score(self) -> list[int]                                                                                  [5070]
    Score of a reduction type, used for comparison and sorting
  def __eq__(self, other)                                                                                       [5096]
    Determines if two principal types are equal based on their score.
  def __lt__(self, other)                                                                                       [5104]
    Compares two reduction types by their score.
  def __gt__(self, other)                                                                                       [5112]
    Compares two reduction types by their score.
  def __le__(self, other)                                                                                       [5120]
    Compares two reduction types by their score.
  def __ge__(self, other)                                                                                       [5128]
    Compares two reduction types by their score.
  def Sort(seq)                                                                                                 [5137]
    Sorts a sequence of reduction types in ascending order based on their score.
*
* Reduction types, labels, and dual graphs
*
  def DualGraph(self, compnames="default")                                                                      [5157]
  def Label(self, tex=False, html=False, wrap=True, forcesubs=False, forcesups=False, depths="default")         [5263]
  def Family(self) -> str                                                                                       [5337]
    Returns the reduction type label with minimal chain lengths in the same family.
  def TeX(self, forcesups=False, forcesubs=False, scale=0.8, xscale=1, yscale=1, oneline=False)                 [5412]
*
* Variable depths in Label
*
  def SetDepths(self, depth)                                                                                    [5505]
    Set depths for DualGraph and Label based on either a function or a sequence.
  def SetVariableDepths(self)                                                                                   [5531]
    Set depths for DualGraph and Label to a variable depth format like 'n_i'.
  def SetOriginalDepths(self)                                                                                   [5537]
    Remove custom depths and reset to original depths for printing in Label and other functions.
  def SetMinimalDepths(self)                                                                                    [5543]
    Set depths to minimal ones in the family for each edge.
  def GetDepths(self)                                                                                           [5549]
    Return the current depths (string sequence) set by SetDepths or the original ones if not changed.
"""

"""
Execute
from redtype import *
from texgraph import *
import traceback
exitcode=0
<TESTS>
<EXAMPLES>
exit(exitcode)
"""

from typing import List, Union, Set, Tuple, Dict, Callable
from math import ceil
from math import gcd as GCD
from itertools import permutations, product
from collections import Counter
from functools import reduce
from fractions import Fraction
import networkx as nx
import re

VERBOSE = False        # Set this to True to enable verbose printing with vprint

def vprint(*args):   ##
  """
  Prints a debug message if the global VERBOSE flag is set to True.
  """
  if VERBOSE:
    print(*args)

"""
Manual
The library redtype.py implements the combinatorics of reduction types, in particular
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
"""

"""
Example Reduction types, labels and dual graphs
R = ReductionType("I2*-Ig1-IV")
print(R.Label())             # Canonical plain label
print(R.Label(tex=True))     # TeX label
print(R.TeX())               # Reduction type as a graph
print(str(R.DualGraph()).replace(",[[",", [[")) #> print(R.DualGraph())         # Associated dual graph
# This is a dual graph on 10 components, of multiplicity 1, 2 and 3, and genus 0 and 1, and here is
# the picture of the corresponding special fibre. Principal components are thick horizontal lines marked 
# with $\Gamma_1$, $\Gamma_2$, $\Gamma_3$, all other components are $\P^1$s, and dashed line indicate
# principal components meeting at a point.
print(TeXDualGraph(R))
# Taking the associated reduction type gives back R:
G = DualGraph([3,1,2,1,1,1,2,1,1,2], [0,1,0,0,0,0,0,0,0,0], [[1,2],[1,4],[1,5],[2,3],[3,6],[3,10],[7,8],[7,9],[7,10]])
print(G.ReductionType())
"""



## Basic mathematical functions


def XGCD(a: int, b: int) -> Tuple[int]:   ##
  """
  Extended Euclidean algorithm XGCD(a,b)->gcd,x,y with x*a+y*b=gcd
  """
  if not isinstance(a, int) or not isinstance(b, int):
    raise TypeError(f"XGCD: Expected {a}:{type(a)} and {b}:{type(b)} to be of type int")
  if a == 0:
    return b, 0, 1
  gcd, x1, y1 = XGCD(b % a, a)
  x = y1 - (b // a) * x1
  y = x1
  return gcd, x, y


def Divisors(n: int) -> List[int]:     ##
  """
  Sorted list of divisors of a small integer n
  """
  if not isinstance(n, int):
    raise TypeError(f"Divisors: Expected {n}:{type(n)} to be of type int")
  L = []
  for i in range(1, int(n**0.5) + 1):
    if n % i == 0:
      L.append(i)
      if i*i != n:
        L.append(n // i)
  return sorted(L)


def ModularInverse(a:int, m:int)  -> int:    ##
  """
  Inverse of a modulo m
  """
  if not isinstance(a, int) or not isinstance(m, int) or m<1:
    raise TypeError(f"ModularInverse: Expected {a}:{type(a)} and {m}:{type(m)} to be of type int, and m>=1")
  gcd, x, y = XGCD(a,m)      # a*x+m*y=1
  if gcd != 1:
    raise ValueError(f"{a} mod {m} has no inverse")
  return x % m


## Printing


def TeXPrintParameter(s, tex=True, sym="", plainsym="", texsym="", printempty=True):      ##
  """
  Prints a parameter in TeX format with optional symbology.
  """
  s = str(s)                                # Convert s to a string
  if len(s) == 0 and not printempty: 
    return ""
  if sym == "":
    sym = texsym if tex else plainsym
  par = "{" + s + "}" if tex and len(s) > 1 else s  # Add braces if tex is True and s has more than 1 character
  return sym + par


def StringSplit(s, P):   ##
  """
  Split a string into blocks using an ordered sequence of patterns that describe types.

  Parameters:
  - s (str): The input string to be split.
  - P (list of tuples): An ordered sequence of patterns, where each pattern is a tuple (type_index, regex).
  
  Returns:
  - list: A list of blocks where each block is a list of the form [type_index, extracts...].
  
  Example:
  - P = [(mInt, r"([0-9]+)"), (mEdgeSym, r"([-=<>])"), ...]
  """
  L = []
  while len(s) > 0:
    found = False
    for d in P:
      pattern = "^" + d[1] + "(.*)$"
      m = re.match(pattern, s)
      if not m:
        continue
      found = True
      extracts = [m.group(i) for i in range(1, len(m.groups()))]
      L.append([d[0]] + extracts)
      s = m.group(len(m.groups()))
      break
  if not found:
    raise ValueError(f"StringSplit: could not match {s}")
  return L


def Minor(M, a, b):     ##
  """
  Minor obtained by removing ath row and bth column
  """
  return [[M[i][j] for j in range(len(M)) if j != b] for i in range(len(M)) if i != a]


def Determinant(M):       ##
  """
  Basic implementation of determinant of an Z-valued square matrix with Gaussian elimination over Q
  """
  A = [row[:] for row in M]   # Save the matrix
  n = len(A)
  det = Fraction(1)           # Initialize determinant 
  for i in range(n):
    max_row = i
    for k in range(i+1, n):
      if abs(A[k][i]) > abs(A[max_row][i]):
        max_row = k
    if max_row != i:
      A[i], A[max_row] = A[max_row], A[i]
      det *= -1 
    if A[i][i] == 0:
      return 0
    for k in range(i+1, n):
      factor = Fraction(A[k][i], A[i][i])
      A[k][i] = 0 
      for j in range(i+1, n):
        A[k][j] -= factor * A[i][j]
    det *= A[i][i]
  return det.numerator


def DeterminantBareiss(M):
  """
  Bareiss' algorithm to compute Det(M) in a stable way
  """
  n = len(M) 
  if n==0:
    return 1
  sign = 1                            # Keep track of extra sign from pivoting
  A = [row[:] for row in M]           # Save original matrix
  for k in range(n - 1):
    if A[k][k] == 0:                  # Check for zero pivot element
      for i in range(k + 1, n):       # Find a row below to swap with (for non-zero pivot)
        if A[i][k] != 0:
          A[k], A[i] = A[i], A[k]
          sign = -sign
          break
      else:
        return 0                      # If no non-zero pivot is found, determinant is zero
    for i in range(k + 1, n):         # Bareiss elimination
      for j in range(k + 1, n):
        A[i][j] = (A[i][j] * A[k][k] - A[i][k] * A[k][j]) // (A[k - 1][k - 1] if k > 0 else 1)
  return sign * A[-1][-1]             # After the elimination, the determinant is the bottom-right element


"""
For testing:
import random
RandomMatrix = lambda n, B: [[random.randint(-B, B) for _ in range(n)] for _ in range(n)]
for step in range(100):
  M = RandomMatrix(5,6)
  d1 = Determinant(M)
  d2 = DeterminantBareiss(M)
  if d1 != d2: 
    raise ValueError("Error in determinant: M={M} d_old={d1} d_Bar={d2}")
    break
"""


def DeterminantsOfMinors(M):   ##
  """
  Array of determinants of n-1 x n-1 minors
  """
  return [[DeterminantBareiss(Minor(M, i, j)) for j in range(len(M))] for i in range(len(M))]


## Multisets and sequences


def ElementMultiplicity(L: list, x: int) -> int:      ##
  """
  Returns True if X is a submultiset of Y.
  """
  return L.count(x)


def IsSubMultiset(X: list, Y: list) -> bool:   ##
  """
  Returns True if X is a submultiset of Y. Both are multisets represented by lists.
  """
  for element in set(X):                                  # Iterate through unique elements in X
    if X.count(element) > Y.count(element):               # Compare counts in X and Y
      return False
  return True  
  

def MultisetsInInterval(min_val, max_val, k):           ##
  """
  All multisets of size k of [min_val..max_val]
  """
  if k == 0:
    yield []
  elif min_val <= max_val:
    for ms in MultisetsInInterval(min_val, max_val, k - 1):
      yield [min_val] + ms
    yield from MultisetsInInterval(min_val + 1, max_val, k)


def MultiSubsets(L: list) -> list[list]:     ##
  """
  All multisets contained in a multiset given by a list L
  """
  if not isinstance(L, list):
     raise TypeError("L must be a list")

  # Convert the input list into a counter to get unique elements and their multiplicities
  counts = Counter(L)
  S = list(counts.keys())       # distinct elements
  M = list(counts.values())     # multiplicities
    
  # Start with the empty subset
  out = [Counter()]
    
  # Iterate over each unique element and its multiplicity
  for elem, multiplicity in zip(S, M):
    current_subsets = []
    for count in range(multiplicity + 1):
      for subset in out:
        # Create a new subset including 'count' instances of 'elem'
        new_subset = subset.copy()
        new_subset[elem] += count
        current_subsets.append(new_subset)
    out = current_subsets
    
  # Convert counter to list
  final_result = []
  for subset in out:
    expanded_subset = list(subset.elements())
    final_result.append(expanded_subset)
    
  return final_result       # returns list of lists


def PrintSequence(L, sep=", ", empty=""):      ##
  if not L: return empty
  return sep.join(str(l) for l in L)    # Join the list elements as strings with the separator, by default ", "


def SequenceDifference(S1, S2):    ##     
  """
  Difference for inner sequences S:=S1 diff S2 (unsorted result)
  """
  multiset1 = Counter(S1)                 # Convert lists to counter (multisets)
  multiset2 = Counter(S2)
  difference = multiset1 - multiset2      # Multiset difference
  result = list(difference.elements())    # Convert the result back to a list (sequence)
  return result

    

"""
Test
assert len(MultiSubsets([1,1,2])) == 6
assert len(MultiSubsets([1,1,1,2,2,3])) == 24
"""


def ScoreIsSmaller(new, best):   ##
  """
  Compares two sequences of integers and determines their relative scores and length relationships.

  Compares two sequences of integers, and returns "<", ">", "l", "s", "=":
    "<"  : new has smaller score than best
    ">"  : new has greater score
    "l"  : new and best coincide until len(best), and new is longer
    "s"  : new and best coincide until len(new), and new is shorter
    "="  : new equals best
  """
  for i in range(min(len(new), len(best))):
    if new[i] < best[i]: return "<"  # New has smaller value earlier
    if new[i] > best[i]: return ">"  # New has greater value earlier
  if len(new) == len(best): return "="  # New and best are identical
  return "l" if len(new) > len(best) else "s"  # Length comparison


"""
Test
assert ScoreIsSmaller([1, 2, 3], [4, 5, 6]) == "<"  # Test 1: New is smaller
assert ScoreIsSmaller([5, 6, 7], [1, 2, 3]) == ">"  # Test 2: New is greater
assert ScoreIsSmaller([3, 4, 5], [3, 4, 5]) == "="  # Test 3: Identical sequences
assert ScoreIsSmaller([2, 3], [2, 3, 4]) == "s"     # Test 4: New is shorter but identical start
assert ScoreIsSmaller([1, 2, 3, 4], [1, 2, 3]) == "l"  # Test 5: New is longer but identical start
assert ScoreIsSmaller([2, 1, 5], [2, 3, 4]) == "<"  # Test 6: New has smaller value earlier
assert ScoreIsSmaller([7, 8, 1], [7, 5, 9]) == ">"  # Test 7: New has greater value earlier
assert ScoreIsSmaller([2, 3, 4, 5], [3, 4, 5]) == "<"  # Test 8: New is longer and starts smaller
assert ScoreIsSmaller([4, 5], [3, 4, 5]) == ">"     # Test 9: New is shorter but starts greater
assert ScoreIsSmaller([3, 4], [3, 4, 2]) == "s"     # Test 10: Identical start but new is shorter
"""


def PreferenceOrder(C, f):           ##
  """
  Sorts C by the score function f and returns the order of each element,
  so that the minimal elements have order 1, the next ones order 2, etc.
  """
  values = list(map(f,C))
  sorted_values = sorted(values)
  return [sorted_values.index(a)+1 for a in values]

def SortSetList(lst):                ##
  """
  Remove repeated elements and sort. This works for lists are other mutable types for which set(...) 
  complains, as long as they allow comparison.
  """
  unique_list = []
  for elem in lst:
    if elem not in unique_list:  # Append only if not already in unique_list
      unique_list.append(elem)
  return sorted(unique_list)
  
def PreferenceOrder2(C, f):     ##
  """
  Sorts a 2-dimensional array C by the score function f and returns the order of each element,
  so that the minimal elements have order 1, the next ones order 2, etc.
  """
  v = [[f(a) for a in c] for c in C]
  flattened_sorted = SortSetList(sum(v, []))
  return [[flattened_sorted.index(a) + 1 for a in c] for c in v]


### Outer and inner chains


"""
Manual
A reduction type is a graph that has principal types as vertices 
(like \redtype{IV}, \redtype{Ig1}, \redtype{I^*_2} above) and inner chains as edges. 
Principal types encode principal components together with outer chains, loops and D-links. 
The three functions that control multiplicities of outer and inner chains, and their depths
are as follows:
"""


def OuterSequence(m: int, d: int, includem=True) -> List[int]:
  """
  Unique outer sequence of type (m,d) for integers m>=1 and 1<d<m. It is of the form 
     [m,d,...,gcd(m,d)] 
  with every three consecutive terms d_(i-1), d_i, d_(i+1) satisfying
     d_(i-1) + d_(i+1) = d_i * (integer > 1).
  If includem=False, exclude the starting point m from the sequence.}
  """
  if not includem:
    return OuterSequence(m,d)[1:]

  if not isinstance(m, int) or not isinstance(d, int) or m <= 0 or d < 0:
    raise TypeError(f"Expected {m}:{type(m)} and {d}:{type(d)} to be integers with m>0")
  d = d % m
  if d == 0:
    return [m]
  return [m] + OuterSequence(d, d - (m % d))


"""
Example OuterSequence
print(OuterSequence(6, 5)) 
print(OuterSequence(13, 8))
"""


def InnerSequence(m1: int, d1: int, m2: int, dk: int, n: int, includem=True) -> List[int]:
  """
  Unique inner sequence of type m1(d1-dk-n)m2, that is of the form [m1,d1,...,dk,m2] with n+1 terms 
  equal to gcd(m1,d1)=gcd(m2,dk) and satisfying the chain condition: for every three consecutive terms 
     d_(i-1), d_i, d_(i+1) 
  we have
     d_(i-1) + d_(i+1) = d_i * (integer > 1).
  If includem=False, exclude the endpoints m1,m2 from the sequence.
  """
  if not includem:
    return InnerSequence(m1,d1,m2,dk,n)[1:-1]
  if not isinstance(m1, int) or not isinstance(d1, int) or m1 <= 0 or not isinstance(m2, int) or not isinstance(dk, int) or m2 <= 0:
    raise TypeError(f"Expected m1={m1}, d1={d1}, m2={m2}, dk={dk} to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2")

  c = GCD(m1, d1)
  if c != GCD(m2, dk):
    raise ValueError(f"No inner sequence {m1},{d1},...,{dk},{m2} exists as GCD({m1},{d1}) != GCD({m2},{dk})")

  d1 = d1 % m1
  dk = dk % m2
  n0 = MinimalDepth(m1, d1, m2, dk)
  if n < n0:
    raise ValueError(f"No inner sequence {m1},{d1},...,{dk},{m2} of depth {n}<{n0} exists")

  if n > -1:
    seq_start = OuterSequence(m1, d1)
    seq_end = OuterSequence(m2, dk)[::-1]
    if n == 0:
      return seq_start[:-1] + seq_end              # one c
    return seq_start + [c] * (n - 1) + seq_end     # at least 2 c's

  if (dk - m1) % m2 == 0 and (d1 - m2) % m1 == 0:
    return [m1, m2]                                       # point (4) in Thm
  if m1 >= m2:
    return [m1] + InnerSequence(d1, -m1, m2, dk, -1)       # point (5) in Thm
  return InnerSequence(m1, d1, dk, -m2, -1) + [m2]         # point (6) in Thm


"""
Example InnerSequence
print(InnerSequence(3, 2, 3, 2, -1))
print(InnerSequence(3, 2, 3, 2, 0)) 
print(InnerSequence(3, 2, 3, 2, 1))
"""


"""
Tests
assert OuterSequence(10, 2) == [10, 2]
assert OuterSequence(10, 8) == [10, 8, 6, 4, 2]
assert OuterSequence(10, 7) == [10, 7, 4, 1]
assert OuterSequence(13, 8) == [13, 8, 3, 1]
assert InnerSequence(5, 4, 1, -1, 0) == [5, 4, 3, 2, 1]
assert InnerSequence(3, 2, 3, 2, -1) == [3, 2, 3]
assert InnerSequence(6, 5, 6, 5, -1) == [6, 5, 4, 3, 2, 3, 4, 5, 6]
"""


def MinimalDepth(m1: int, d1: int, m2: int, dk: int) -> int:
  """
  Minimal depth of a inner sequence between principal components of multiplicities m1 and m2 with initial links d1 and dk.

  Minimal depth of a chain d1,d2,...,dk of P1s between principal component of multiplicity m1, m2 and 
  initial inner multiplicities d1,dk. The depth is defined as -1 + number of times GCD(d1,...,dk) 
  appears in the sequence. 
  For example, 5,4,3,2,1 is a valid inner sequence, and MinimalDepth(5,4,1,2) = -1 + 1 = 0.
  """
  if not isinstance(m1, int) or not isinstance(d1, int) or m1 <= 0 or not isinstance(m2, int) or not isinstance(dk, int) or m2 <= 0:
    raise TypeError(f"Expected m1={m1}, d1={d1}, m2={m2}, dk={dk} to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2")
  if GCD(m1, d1) != GCD(m2, dk):
    raise ValueError(f"No inner sequence {m1},{d1},...,{dk},{m2} exists as GCD({m1},{d1}) != GCD({m2},{dk})")

  _, d1i, _ = XGCD(d1 % m1, m1)
  _, dki, _ = XGCD(dk % m2, m2)

  n = ceil(- (d1i % m1) / m1 - (dki % m2) / m2 + 1 / (2 * m1 * m2))
  return n


"""
Example
# Example for MinimalDepth from the description of the function:
print(MinimalDepth(5,4,1,2))
# For another example, the minimal $n$ in the Kodaira type \redtype{I^*_n} is 1. Here the chain links
# two components of multiplicity 2, and the initial multiplicities are 2 on both sides as well:
print(MinimalDepth(2,2,2,2))
# Here is an example of a reduction type with an inner chain between two components of multiplicity 3 and outgoing multiplicities 2 on both sides:
R = ReductionType("IV*-(2)IV*")   
# Here is what its dual graph looks like:\par
print(TeXDualGraph(R))
# The inner chain has gcd=GCD(3,2)=1 and 
# \begin{center}
#    depth = $-1$ + \#1's(=gcd) in the sequence $3,2,1,1,1,2,3$ = 2
# \end{center}
# This is the depth specified in round brackets in IV*-(2)IV*
print(MinimalDepth(3,2,3,2))   # Minimal possible depth for such a chain = -1
R1 = ReductionType("IV*-IV*")      # used by default when no expicit depth is specified
R2 = ReductionType("IV*-(-1)IV*")
assert R1==R2
# Here is what its dual graph looks like:
print(TeXDualGraph(R1))
"""

"""
Test
assert MinimalDepth(1,0,1,0) == 1
assert MinimalDepth(1,0,2,1) == 0
assert MinimalDepth(2,1,1,0) == 0
assert MinimalDepth(2,0,2,0) == 1
assert MinimalDepth(3,2,3,1) == 0
assert MinimalDepth(3,2,3,2) == -1
assert MinimalDepth(7,6,7,3) == -1
assert MinimalDepth(7,4,7,2) == 0
"""


"""
Manual
The next two functions are used in Label to determine the ordering of chains (including loops and D-links),
and default multiplicities which are not printed in labels.
"""


def SortMultiplicities(m, O):
  """
  Sort a sequence of multiplicities O by gcd with m, then by o. This is how outer and edge multiplicities are sorted in reduction types.
  """
  if len(O) <= 1:
    return
  def w(l):
    assert 1 <= l <= m
    return (GCD(l, m), l)
  O.sort(key=w)



"""
Example Ordering outer multiplicities in reduction types
m = 6                       # principal component multiplicity
O = [1,2,3,3,4,5]           # initial multiplicities for outgoing outer chains
SortMultiplicities(6, O)             # sort them first by gcd(o,m), then by o mod m
print(O)
"""


def DefaultMultiplicities(m1, o1, m2, o2, loop):
  """
  Default edge multiplicities for a component with given multiplicities and outgoing options.

  Default edge multiplicities d1, d2 for a component with multiplicity m1, available outgoing multiplicities o1, and one with m2, o2.
  loop: boolean specifies whether it is a loop or a link between two different principal components.
  """
  # Possible pairs [chain GCD, outgoing mult d]
  X1 = [[GCD(m1, d), d] for d in o1] + [[m1, m1], [m1, m1]]
  X2 = [[GCD(m2, d), d] for d in o2] + [[m2, m2], [m2, m2]]

  # Determine the possible set of chain gcds
  if loop:
    good = {D[0] for D in X1 if sum(1 for E in X1 if E[0] == D[0]) >= 2}
  else:
    good = {D[0] for D in X1} & {D[0] for D in X2}

  X1 = [D for D in X1 if D[0] in good]
  X2 = [D for D in X2 if D[0] in good]

  # Error handling
  if not X1 or (not loop and not X2) or (loop and len(X2) <= 1):
    raise ValueError(f"DefaultMultiplicities({m1}, {o1}, {m2}, {o2}, {loop}): could not find default edge m1={m1} o1={o1} - m2={m2} o2={o2}")

  # Find minimum multiplicities
  d1min = min(X1)[1]
  if loop:
    X2.remove([GCD(m1, d1min), d1min])  # Remove one occurrence of [GCD, d1min]
  d2min = min(X2)[1]

  vprint(f"DefaultMultiplicities: m1={m1} O1={o1} m2={m2} O2={o2} {loop} -> {d1min}, {d2min}")

  return d1min, d2min


"""
Test
assert DefaultMultiplicities(4,[3,3,2],4,[3,3,2],False) == (3,3)
"""


"""
Example DefaultMultiplicities
# Let us illustrate what happens when we take a principal component \redtype{9^{1,1,1,3,3}} and add
# five default loops of depth 2,2,1,2,3, to get a reduction type \redtype{9^{1,1,1,3,3}_{2,2,1,2,3}}. 
# How do default loops decide which initial multiplicities to take? \par
# We start with a component of multiplicity $m=9$ and outer multiplicities $\cO=\{1,1,1,3,3\}$.
R = ReductionType("9^1,1,1,3,3")
print(TeXDualGraph(R))
# We can add a loop to it linking two 1's of depth 2 by
R = ReductionType("9^1,1,1,3,3_{1-1}2")
print(TeXDualGraph(R))
# In this case, \{1-1\} does not need to be specified because this is the minimal pair of possible multiplicities in $\cO$, as sorted by SortMultiplicities:
print(DefaultMultiplicities(9,[1,1,1,3,3],9,[1,1,1,3,3],True))
assert R == ReductionType("9^1,1,1,3,3_2")
# After adding the loop, $\{1,3,3\}$ are left as potential outgoing multiplicities, so the next default loop links 3 and 3. Note that $1,3$ is not a valid pair because $\gcd(1,9)\ne\gcd(3,9)$.
print(DefaultMultiplicities(9,[1,3,3],9,[1,3,3],True))
R2 = ReductionType("9^1,1,1,3,3_2,2")       # 2 loops, use 1-1 and 3-3
print(TeXDualGraph(R2))
# There are no pairs left, so the next three loops use $(m,m)=(9,9)$
print(DefaultMultiplicities(9,[1],9,[1],True))   
R3 = ReductionType("9^1,1,1,3,3_2,2,1,2,3") 
assert R3 == ReductionType("9^1,1,1,3,3_{1-1}2,{3-3}2,{9-9}1,{9-9}2,{9-9}3")
# This is what its dual graph looks like:\par
print(TeXDualGraph(R3))
"""


### Principal component core (RedCore)


def CoreChi(m, g, O, L):    ##
  """
  Calculate the core Euler characteristic based on multiplicity, genus, and lists of outer and link components.
  """
  return m * (2 - 2 * g - len(O) - len(L)) + sum(GCD(m, d) for d in O)


StandardCoreNames = [
  (1, [], "I", "{\\rm I}"),
  (2, [1, 1], "D", "{\\rm D}"),
  (3, [1, 2], "T", "{\\rm T}"),
  (2, [1, 1, 1, 1], "I0*", "{\\rm I}_0^*"),
  (3, [1, 1, 1], "IV", "{\\rm IV}"),
  (3, [2, 2, 2], "IV*", "{\\rm IV}^*"),
  (4, [1, 1, 2], "III", "{\\rm III}"),
  (4, [3, 3, 2], "III*", "{\\rm III}^*"),
  (6, [1, 2, 3], "II", "{\\rm II}"),
  (6, [5, 4, 3], "II*", "{\\rm II}^*")
]


"""
Manual
A core is a pair $(m,O)$ with `principal multiplicity' $m\ge 1$ and `outgoing multiplicities' $O=\{o_1,o_2,...\}$
that add up to a multiple of $m$, and such that $\gcd(m,O)=1$. It is implemented as the following type:
"""


def Core(m: int, O: list[int]) -> 'RedCore':
  """
  Core of a principal component defined by multiplicity m and list O.
  """
  return RedCore(m,O)


"""
Example Create and print a principal component core $(m,O)$
print(Core(8,[1,3,4]))     # Typical core - multiplicities add up to a multiple of m
print(Core(8,[9,3,4]))     # Same core, as they are in Z/mZ
# This is how cores are printed, with the exception of 7 cores of $\chi=0$ (see below) 
# that come from Kodaira types and two additional special ones D and T:
print(Core(6,[1,2,3]))                   # from a Kodaira type
print([Core(2,[1,1]),Core(3,[1,2])])     # two special ones
"""



### Basic invariants and printing


class RedCore:

  def __init__(self, m, O):     ##
    if m < 1:
      raise ValueError("Principal multiplicity m should be at least 1")
    
    O = [o % m for o in O]
    
    if 0 in O:
      raise ValueError("Outgoing multiplicity in a core cannot be 0")
    
    if GCD(m, *O) != 1:
      raise ValueError(f"Core should have GCD(m,O)=1 (m={m} O={O})")
    
    if sum(O) % m != 0:
      raise ValueError(f"Core with non-integral self-intersection (m={m} O={O})")
    
    self.m = m
    self.O = O
    SortMultiplicities(m, self.O)
    self.chi = CoreChi(m, 0, self.O, [])
    
    if self.chi % 2 != 0:
      raise ValueError(f"Core: expected even chi when m={m} O={O}")

  def definition(self):
    """
    Returns a string representation of a core in the form 'Core(m,O)'.
    """
    return f"Core({self.m},{self.O})".replace(" ","")

  def Multiplicity(self):
    """
    Returns the principal multiplicity m of the principal component.
    """
    return self.m

  def Multiplicities(self):
    """
    Returns the list of outgoing chain multiplicities O, sorted with SortMultiplicities.
    """
    return self.O

  def Chi(self):
    """
    Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)
    """
    return self.chi

  def Label(self, tex=False):
    """
    Label of a reduction type core, for printing (or TeX if tex=True)
    """
    if self.chi < 0 or (self.chi == 2 and self.m not in [1, 2, 3]):
      O_str = ",".join(map(str, self.O))
      return f"{self.m}{TeXPrintParameter(O_str, sym='^', tex=tex, printempty=False)}"
    else:
      for m, O, plain_label, tex_label in StandardCoreNames:
        if self.m == m and self.O == O:
          return tex_label if tex else plain_label
      raise ValueError(f"Could not find standard component for m={self.m} O={self.O}")

  def TeX(self):
    """
    Returns the core label in TeX, same as Label with TeX=True.
    """
    return self.Label(tex=True)

  def HTML(self):    ##
    return self.Label(tex=True)

  def __str__(self):            ##
    return self.Label()

  def __repr__(self):              ##
    return self.__str__()


"""
Example Core labels and invariants
C=Core(2,[1,1,1,1])
print(C.Label())               # Plain label
print(C.TeX())                 # TeX label
print(C.definition())          # How it can be defined
print(C.Multiplicity())        # Principal multiplicity m
print(C.Multiplicities())      # Outgoing multiplicities O
print(C.Chi())                 # Euler characteristic
"""


def Cores(chi, mbound="all", sort=True):
  """
  Returns all cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a bound on m must be given.
  """
  if chi == 2:
    if mbound == "all":
      raise ValueError("mbound must be set when chi=2, otherwise there are infinitely many cores")

    list_cores = [RedCore(1, [])]
    for m in range(2, mbound + 1):
      for a in range(1, m // 2 + 1):
        if GCD(m, a) == 1:
          list_cores.append(RedCore(m, [a, m - a]))
    return list_cores

  if chi % 2 != 0 or chi > 0:
    raise ValueError("chi should be a non-positive even number (or 2 with mbound set)")

  list_cores = []
  g = (-chi + 2) // 2

  for m in range(1, 4 * g + 3):
    if mbound != "all" and m > mbound:
      continue

    for k in range(2, 4 * g + 1):
      if (k // 2 - 2) * m > -chi:
        break

      for S in MultisetsInInterval(1, m - 1, k - 1):
        e = (-sum(S)) % m

        if e == 0 or e < max(S):
          continue

        if GCD(m, *S, e) != 1:
          continue

        O = S + [e]

        if CoreChi(m, 0, O, []) != chi:
          continue

        list_cores.append(RedCore(m, O))

  if sort:
    list_cores.sort(key=lambda c: [c.m] + c.O)

  return list_cores 


"""
Example Cores
print(Cores(2, mbound=4))         # Chi=2 (infinitely many), with bound for m
print(Cores(0))                   # 7 cores I0* ,IV, IV*, III, III*, II, II*
print([len(Cores(i)) for i in (0,-2,-4,-6,-8)])  # 7, 16, 43, 65, 64, ...
"""


### Inner chains (RedChain)


"""
Manual
Inner chains between principal components fall into three classes: loops on a principal type, D-link 
on a principal type, and chains between principal types that link two of their edge endpoints. 
All of these are implemented in the class RedChain that carries class=cLoop, cD or cEdge, and keeps track
of all the invariants.
"""


# Class constants for RedChain
cLoop  = 1
cD     = 2
cEdge = 3


def Link(Class, mi, di, mj=False, dj=False, depth=False, Si=False, Sj=False, index=False) -> 'RedChain':
  """
  Define a RedChain from its invariants
  """
  return RedChain(Class, mi, di, mj=mj, dj=dj, depth=depth, Si=Si, Sj=Sj, index=index)


"""
Example Some inner chains, with no principal types specified
print(Link(cLoop,2,1,2,1))    # loop 
print(Link(cD,2,2))           # D-link
print(Link(cEdge,2,2))       # to another (yet unspecified) principal type
"""


### Invariants and depth


class RedChain:
  def __init__(self, Class, mi, di, mj=False, dj=False, depth=False, Si=False, Sj=False, index=False):  ##
    """
    Initializes an inner chain with specified attributes and checks gcd and other conditions.
    """
    # Ensure class is within valid range
    if Class not in [cLoop, cD, cEdge]:
      raise ValueError(f"Invalid class: {Class}. Must be one of {cLoop}, {cD}, {cEdge}.")
    
    # Ensure mj, dj, and depth are either integers or False
    for x in [mj, dj, depth]:
      if not isinstance(x, (int, type(False))):
        raise ValueError(f"{x} is neither an integer nor 'False'.")

    self.Class = Class
    self.mi = mi
    self.di = di
    self.mj = mj
    self.dj = dj
    self.depth = depth
    self.Si = Si
    self.Sj = Sj
    self.index = index

    # Handle special cases for D-link
    if self.Class == cD:
      if self.mj is False:
        self.mj = GCD(self.mi, self.di)
      if self.dj is False:
        self.dj = self.mj
      if self.mj % 2 != 0:
        raise ValueError(f"Invalid D-link with mj={self.mj} dj={self.dj}")

    # Handle modular reductions
    if self.mi is not False and self.di is not False:
      self.di = self.di % self.mi
      if self.di == 0:
        self.di = self.mi
    if self.mj is not False and self.dj is not False:
      self.dj = self.dj % self.mj
      if self.dj == 0:
        self.dj = self.mj

      # Ensure GCDs match
      if GCD(self.mi, self.di) != GCD(self.mj, self.dj):
        raise ValueError("GCD mismatch error in RedChain.")

      # Set depth if unset
      if self.depth is False:
        self.depth = MinimalDepth(self.mi, self.di, self.mj, self.dj)

    # Depth string for printing
    self.depthstr = str(self.depth) if self.depth is not False else False


  def __repr__(self):    ##
    """
    String representation for printing the RedChain.
    """
    classstr = ["loop", "D-link", "edge"][self.Class - 1]
    indexstr = f"[{self.index}] " if self.index is not False else ""
    Sistr = f"c{self.Si.index} " if self.Si is not False else ""
    Sjstr = f"c{self.Sj.index} " if self.Sj is not False else ""
    depthstr = self.depthstr if self.depthstr is not False else "False"
    return f"{indexstr}{classstr} {Sistr}{self.mi},{self.di} -({depthstr}) {Sjstr}{self.mj},{self.dj}"
    
  def Weight(self):
    """
    Weight of the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,di)).
    """
    return GCD(self.mi, self.di)

  def Copy(self):    ##
    """
    Copy a RedChain.
    """
    f = RedChain(self.Class, self.mi, self.di, self.mj, self.dj,
                 depth=self.depth, Si=self.Si, Sj=self.Sj, index=self.index)
    return f
    
  def Reverse(self):       ##
    """
    Reverse the direction of the chain.
    """
    f = RedChain(self.Class, self.mj, self.dj, self.mi, self.di,
                 depth=self.depth, Si=self.Sj, Sj=self.Si, index=self.index)
    return f
    
  def Index(self):
    """
    Index of the RedChain, used for distinguishing between chains.
    """
    return self.index

  def SetDepth(self, n):
    """
    Set the depth and depth string of the RedChain.
    """
    min_depth = MinimalDepth(self.mi, self.di, self.mj, self.dj)
    if n is False:
      n = min_depth
    if n < min_depth:
      raise ValueError(f"SetDepth: n={n} < MinimalDepth for RedChain {self}")
    self.depth = n
    self.depthstr = str(n)

  def SetMinimalDepth(self):
    """
    Set the depth of the RedChain to the minimal possible value.
    """
    min_depth = MinimalDepth(self.mi, self.di, self.mj, self.dj)
    self.depth = min_depth
    self.depthstr = str(min_depth)

  def DepthString(self):
    """
    Return the string representation of the RedChain's depth.
    """
    return self.depthstr
  def SetDepthString(self, depth):
    """
    Set how the depth is printed (e.g., "1" or "n").
    """
    self.depthstr = str(depth)


"""
Example Invariants of inner chains
# Take a genus 2 reduction type \redtype{I_2\e(1)I^*_2} whose special fibre 
# consists of Kodaira types \redtype{I_2} (loop of $\P^1$s) and \redtype{I^*_2} linked 
# by a chain of $\P^1$s of multiplicity 1.
R = ReductionType("I2-(1)I2*");  
# This is what its special fibre looks like:\par
print(TeXDualGraph(R))
# There are two principal types R[1]=\redtype{I_2} and R[2]=\redtype{I^*_2}, with a loop on R[1] (class cLoop=1), 
# an inner chain between them (class cEdge=3), and a D-link on R[2] (class cD=2)
# This is the order in which they are printed in the label.
print([R[1],R[2]])              # two principal types R[1] and R[2]
c1,c2,c3 = R.InnerChains()
print(c1)
print(c2)
print(c3)
print(c3.Class)                 # cLoop=1, *cD=2*, cEdge=3
print(c3.Weight())              # GCD of the chain multiplicities [2,2,2]
print(c3.Index())               # index in the reduction type
c3.SetDepthString("n")          # change how its depth is printed in labels
print(c3)                       #   and drawn in dual graphs of reduction types
print(R.Label())
# This is what its dual graph looks like:\par
# \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, chlenstyle/.style={blue,scale=0.7}, chmultstyle/.style={scale=0.7}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0.5,0)--(3.3,0) node[mainl] {1} node[facel] {$\Gamma_1$}; \draw[] (0,0) ++(0.2,0.3) node[anchor=east,chmultstyle] {1} ++(0.3,-0.45)--++(115:0.75)++(295:0.15)++(245:0.15)--++(65:0.75)++(245:0.15)++(180:0.15) --++(0:0.22) ++(0:0.15) node{$\cdot$} ++(0:0.15) node{$\cdot$} node[below=0.1,anchor=north,chlenstyle]{$n$} ++(0:0.15) node{$\cdot$} ++(0:0.15) --++(0:0.22)++(180:0.15)++(115:0.15)--++(295:0.75)++(115:0.15)++(65:0.15)--++(245:0.75) ++(0.3,0.45) node[anchor=west,chmultstyle] {1};\draw[l1] (2.63,1.83)--(4.7,1.83) node[mainl] {2} node[facel] {}; \draw[l1] (2.63,0.66)--(4.7,0.66) node[mainl] {2} node[facel] {$\Gamma_2$}; \draw[l2] (2.63,0)--node[rightl] {1} (2.63,0.66); \draw[l2end] (3.23,0.66)--node[rightl] {1} (3.23,1.33); \draw[l2] (4.03,0.66)--node[rightl] {2} (4.03,1.83); \draw[l2end] (2.63,1.83)--node[rightl] {1} (2.63,2.5); \draw[l2end] (3.43,1.83)--node[rightl] {1} (3.43,2.5); \end{tikzpicture}
"""


### Principal components (RedPrin)


"""
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

A principal type is implemented as the following python class.
"""


def PrincipalType(m, g, O, Lloops, LD, Ledge, index=0):
  """
  Create a new principal type from its primary invariants:
  m         multiplicity of the principal component, e.g. 8
  g         geometric genus of the principal component, e.g. 0
  O         outgoing multiplicities for outer chains, e.g. 1,1,2
  Lloops    list of loops [[di,dj,depth],...], e.g. [[1,1,3]]
  LD        list of D-links [[di,depth],...], e.g. [[2,1]]  (m and all d_i must be even)
  Ledge    list of edge multiplicities, e.g. [8]
  """
  S = RedPrin.NewPrincipalType(m, g, index=index, O=O)

  for l in Lloops:
    if len(l) not in {2, 3}:
      raise ValueError("Loops must be a sequence [d1, d2] or [d1, d2, depth]")
    di, dj = l[:2]
    depth = l[2] if len(l) == 3 else False
    if depth and depth < MinimalDepth(m, di, m, dj):
      raise ValueError(f"Depth {depth} < MinimalDepth({m}, {di}, {m}, {dj}) in loop {l}")
    S.AddInnerMultiplicitiesAndLoop(di, dj, depth=depth)

  for l in LD:
    if len(l) not in {1, 2}:
      raise ValueError("LD must be a sequence [d1] or [d1, depth]")
    di = l[0]
    depth = l[1] if len(l) == 2 else False
    if m % 2 != 0 or di % 2 != 0:
      raise ValueError(f"To have D-links, multiplicities m({m}) and di({di}) must be even")
    mj = GCD(m,di)
    dj = mj
    depth = False
    if len(l) == 2:
      depth=l[1]
      if depth < MinimalDepth(m,di,mj,dj):
        raise ValueError(f"Depth {depth} < MinimalDepth({m}, {di}, {mj}, {dj}) in D-link {l}")
    S.AddInnerMultiplicityAndDLink(di, depth=depth)

  for d in Ledge:
    S.AddInnerMultiplicityAndEdgeLink(d)

  if (sum(S.O) + sum(S.L)) % m != 0:
    raise ValueError(f"Principal type with non-integral self-intersection: m={m}, O={S.O}, L={S.L}")

  S.Finalize()

  return S


"""
Example Construction
# We construct the principal type from example above. It has $m=8$, $g=0$, outer multiplicities 1,1,2,
# loop $1-1$ of depth 3, a D-link with outgoing multiplicity 2 of depth 1, and no edges
# (so that it is a reduction type in itself).
S = PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[])
"""


class RedPrin:
  def __init__(self, m, g, O=None, L=None, C=None, gcd=None, core=None, chi=None, index=0):        ##
    """
    Initialize principal Type (RedPrin) with its primary attributes.
    m:     Principal multiplicity (integer)
    g:     Geometric genus (integer)
    O:     Outgoing multiplicities for outer chains (list[int])
    L:     Outgoing multiplicities from all other chains (list[int])
    C:     Chains (list[RedChain])
    gcd:   GCD(m,O,L)
    core:  Core of type RedCore (divide by gcd)
    chi:   Euler characteristic
    index: Index in the reduction type (0 if free-standing)
    """
    self.m = m              # Principal multiplicity
    self.g = g              # Genus
    self.O = O or []        # Outgoing multiplicities for outer chains
    self.L = L or []        # Outgoing multiplicities for other chains
    self.C = C or []        # Chains (outer, loops, D-links, edge from S)
    self.gcd = gcd          # GCD of (m, O, L)
    self.core = core        # Core of type RedCore (divide by gcd)
    self.chi = chi          # Euler characteristic = chi(m, g, O, L)
    self.index = index      # Index in the reduction type

  def __str__(self):                    ##
    return self.Label(edge=True)

  def __repr__(self):                   ##
    return self.__str__() 

  def AddOuterMultiplicity(self, o):   ##
    """
    Add outer multiplicity and chain to a RedPrin.
    """
    if o % self.m == 0:
      raise ValueError("AddOuterMultiplicity: Outer multiplicities must be non-zero mod m")
    self.O.append(o % self.m)
    SortMultiplicities(self.m, self.O)

  def AddInnerMultiplicitiesAndLoop(self, di, dj, depth=False, index=False):     ##
    """
    Add two inner multiplicities and a loop to a principal type.
    """
    if GCD(self.m, di) != GCD(self.m, dj):
      raise ValueError(f"GCD({self.m}, {di}) != GCD({self.m}, {dj})")
    
    di = di % self.m if di % self.m != 0 else self.m
    dj = dj % self.m if dj % self.m != 0 else self.m

    if di > dj:
      di, dj = dj, di  # Swap to ensure di <= dj
    
    self.L.append(di)
    self.L.append(dj)
    loop = Link(cLoop, self.m, di, self.m, dj, Si=self, Sj=self, depth=depth, index=index)
    self.C.append(loop)

  def AddInnerMultiplicityAndDLink(self, d, depth=False, index=False):     ##
    """Add inner multiplicity and a D-link to a principal type."""
    if self.m % 2 != 0 or d % 2 != 0:
      raise ValueError(f"To have D-links, multiplicities m({self.m}) and di({d}) must be even")

    d = d % self.m if d % self.m != 0 else self.m
    mj = GCD(self.m, d)
    dj = mj

    self.L.append(d)
    dlink = Link(cD, self.m, d, mj, dj, Si=self, depth=depth, index=index)
    self.C.append(dlink)

  def AddInnerMultiplicityAndEdgeLink(self, d, index=False):                       ##
    """Add inner multiplicity and a edge to a principal type."""
    d = d % self.m if d % self.m != 0 else self.m

    self.L.append(d)
    edge_link = Link(cEdge, self.m, d, False, False, Si=self, index=index)
    self.C.append(edge_link)

  def AddInnerMultiplicityAndChain(self, S2, d1, d2, depth=False, index=False):   ##
    """Add a inner multiplicity and a edge to a principal type."""
    d1 = d1 % self.m if d1 % self.m != 0 else self.m
    d2 = d2 % S2.m if d2 % S2.m != 0 else S2.m

    link = Link(cEdge, self.m, d1, S2.m, d2, depth=depth, Si=self, Sj=S2, index=index)
    
    self.L.append(d1)
    S2.L.append(d2)

    self.C.append(link)
    S2.C.append(link.Reverse())

  def Finalize(self):    ##
    """Finalize the principal type by sorting chains and setting core, chi, and gcd."""
    self.chi = CoreChi(self.m, self.g, self.O, self.L)
    self.gcd = reduce(GCD, self.O + self.L + [self.m])
    core_m = self.m // self.gcd
    core_O = [d // self.gcd for d in self.O + self.L if d != self.m]
    self.core = Core(core_m, core_O)
    if not self.C:
      return

  def order(e):       ##
    return [e.Class, GCD(self.m, e.di), e.di, 0 if not e.dj else e.dj, 0 if not e.depth else e.depth]
    self.C.sort(key=order)

  @staticmethod
  def NewPrincipalType(m, g, index=0, O=[]):    ##
    """Create a new principal type of multiplicity m and genus g, optionally with outer multiplicities O."""
    if m <= 0:
      raise ValueError("Principal multiplicity should be >=1")
    
    if g < 0:
      raise ValueError("Geometric genus should be >=0")
    
    S = RedPrin(m, g, O=[], L=[], C=[], gcd=m, core=Core(1, []), chi=CoreChi(m, g, [], []), index=index)

    for o in O:
      S.AddOuterMultiplicity(o)

    return S

  def Multiplicity(self):
    """
    Principal multiplicity m of a principal type
    """

    return self.m

  def GeometricGenus(self):
    """
    Geometric genus g of a principal type S=(m,g,O,...)
    """
    return self.g

  def Index(self):
    """
    Index of the principal component in a reduction type, 0 if freestanding
    """
    return self.index

  def Chains(self, Class=0):
    """
    Sequence of chains of type RedChain originating in S. By default, all (loops, D-links, edge) are returned, unless class is specified.
    """
    if Class == 0:
      return self.C
    else:
      return [e for e in self.C if e.Class == Class]

  def OuterMultiplicities(self):
    """
    Sequence of outer multiplicities S`O of a principal type, sorted
    """
    return self.O

  def InnerMultiplicities(self):
    """
    Sequence of inner multiplicities S`L of a principal type, sorted as in label
    """
    return self.L

  def Loops(self):
    """
    Sequence of chains in S representing loops (class cLoop)
    """
    return self.Chains(Class=cLoop)

  def DLinks(self):
    """
    Sequence of chains in S representing D-links (class cD)
    """
    return self.Chains(Class=cD)

  def EdgeChains(self):
    """
    Sequence of edges of a principal type, sorted
    """
    return self.Chains(Class=cEdge)

  def EdgeMultiplicities(self):
    """
    Sequence of edge multiplicities of a principal type, sorted
    """
    return [e.di for e in self.EdgeChains()]

  def definition(self) -> str:
    """
    Returns a string representation of a principal type in the form of the PrincipalType constructor.
    """
    def p(seq):      # Helper function to format sequences as comma-separated strings
        return ",".join(str(x) for x in seq)
    O_str      = f"[{p(self.OuterMultiplicities())}]"
    Lloops_str = f"[{','.join(f'[{p([l.di,l.dj,l.depth])}]' for l in self.Loops())}]"
    LD_str     = f"[{','.join(f'[{p([l.di,l.depth])}]' for l in self.DLinks())}]"
    Lfree_str  = f"[{p(self.EdgeMultiplicities())}]"
    return f"PrincipalType({self.m},{self.g},{O_str},{Lloops_str},{LD_str},{Lfree_str})"


  """
  Example Invariants
  # We continue with the principal type above. It has $m=8$, $g=0$, outer multiplicities 1,1,2,
  # loop $1-1$ of depth 3, a D-link with outgoing multiplicity 2 of depth 1, and no edges
  # (so that it is a reduction type in itself).
  S = PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[])
  print(S)
  print(S.TeX(standalone=True))     # How it appears in the tables
  print(S.Multiplicity())           # Principal component multiplicity
  print(S.GeometricGenus())         # Geometric genus of the principal component
  print(S.OuterMultiplicities())     # Outer chain initial multiplicities O=[1,1,2]
  print(S.Loops())                  # Loops (of type RedChain)
  print(S.DLinks())                 # D-Links (of type RedChain)
  print(S.EdgeMultiplicities())    # Edge multiplicities
  print(S.InnerMultiplicities())     # All initial inner multiplicities (loops, D-links, edge)
  print(S.definition())             # evaluatable string to reconstruct S
  """


  def GCD(self):
    """
    Return GCD(m,O,L) for a principal type
    """
    return self.gcd

  def Core(self):
    """
    Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m,O)=1
    """
    return self.core

  def Chi(self):
    """
    Euler characteristic chi of a principal type (m,g,O,Lloops,LD,Ledge), chi = m(2-2g-|O|-|L|) + sum_(o in O) gcd(o,m), where L consists of all the inner multiplicities in Lloops (2 from each), LD (1 from each), Ledge (1 from each)
    """
    return self.chi

  def Weight(self):
    """
    Outgoing link pattern of a principal type = multiset of GCDs of edges with m.
    """
    return [GCD(a, self.m) for a in self.EdgeMultiplicities()]

  def Copy(self, index=False):     ##
    """
    Make a copy of a principal type.
    """
    index = self.index if index is False else index
    C    = [e.Copy() for e in self.C]
    core = Core(self.core.m, self.core.O)
    N = RedPrin(self.m, self.g, O=self.O[:], L=self.L[:], index=index, gcd=self.gcd, chi=self.chi, core=core, C=C)
    for c in N.C:
      c.Si = N  # Set originating component to N
      if c.Class == cLoop:
        c.Sj = N
      else:
        assert c.Sj == False, f"Copy(S): Expected no target component in {c}"
    return N

  """
  Example GCD
  # Define a principal type by its primary invariants:
  # $m=4$, $g=1$, outer multiplicities $\cO=[2]$, no loops, one D-link with initial multiplicity 2 
  # and length 1, and no edges
  S = PrincipalType(4, 1, [2], [], [[2, 1]], [])
  print(S.GCD())              # its GCD(m,O,L)=GCD(4,[2],[2])=2
  print(S)                    # which is seen as [2] in its name
  # Note, however, it is not a multiple of 2 of another principal component type because its D-link is primitive. The special fibre is not a multiple of 2.
  print(ReductionType("[2]Dg1_1D").DualGraph().Multiplicities())
  # This is what the special fibre looks like:\\
  # \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {2} node[facel] {}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,0.66)--(2.86,0.66) node[mainl] {4 \smash{g}1} node[facel] {$\Gamma_1$}; \draw[l2] (1.6,0)--node[rightl] {2} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {2} (2.2,1.33); \end{tikzpicture}
  """

  def Score(self) -> list[int]:
    """
    Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a principal type, and characterises it uniquely.
    """
    w = [self.Chi(), self.Multiplicity(), -self.GeometricGenus(), len(self.EdgeMultiplicities()), len(self.DLinks()), 
      len(self.Loops()), len(self.OuterMultiplicities())]
    w.extend(self.OuterMultiplicities())
    w += [x for l in self.Loops() for x in [l.di, l.dj]]     # flatten and concatenate 
    # w.extend([(e.di, e.dj) for e in self.Loops()])
    w.extend([e.di for e in self.DLinks()])
    w.extend(self.EdgeMultiplicities())
    w.extend([e.depth for e in self.Loops()])
    w.extend([e.depth for e in self.DLinks()])
    # w += [x for l in self.Loops() for x in [l.di, l.dj, l.depth]]    # flatten and concatenate 
    return w

  def __eq__(self, other):
    """
    Compare two principal types by their score.
    """
    return self.Score() == other.Score()

  def __lt__(self, other):
    """
    Compare two principal types by their score.
    """
    return self.Score() < other.Score()

  def __le__(self, other):
    """
    Compare two principal types by their score.
    """
    return self.Score() <= other.Score()

  def __gt__(self, other):
    """
    Compare two principal types by their score.
    """
    return self.Score() > other.Score()

  def __ge__(self, other):
    """
    Compare two principal types by their score.
    """
    return self.Score() >= other.Score()


  """
  Example Sorting principal types by Score in increasing order
  L = PrincipalTypes(-2,[4]) + PrincipalTypes(-2,[2,2])
  print([S.Score() for S in L]);
  print(sorted(L,key=lambda S: S.Score()))
  """


  def PrincipalTypeDecorations(self):      ##

    # for a principal type returns:
    #   dstr    =  multiple "[d]" or ""
    #   cstr    =  core name without stars or subscripts e.g. "I", "T", "D", "II", "6" etc.
    #   presups =  superscripts belonging to the core, i.e. ["*"] for I0*,In*,II*,... or []
    #   sups    =  superscripts as a sequence of multiplicities ["5","4","3","3"]
    #   presubs =  superscripts belonging to the core, i.e. ["0","g1"] for I0*g1, In*,... or []
    #   subs    =  subscripts from all other loops and D-links
    #   edges   =  edges ["-{2}",...]

    S = self
    m = S.m
    loops = S.Loops().copy()
    Dlinks = S.DLinks().copy()
  
    # dstr
    d = S.GCD()
    dstr = "" if d == 1 else f"[{d}]"
  
    # Initialize decorations
    presups = []
    sups = []
    presubs = []
    subs = []
  
    # cstr, presups, sups
    C = S.Core()
    Cstr = C.Label()
    if Cstr.endswith("*"):
      presups.append("*")
      Cstr = Cstr[:-1]
    p = Cstr.find("^")
    if p != -1:
      sups = Cstr[p+1:].split(",")
      Cstr = Cstr[:p]
    cstr = Cstr
  
    if cstr == "I0":
      cstr = "I"
      presubs.append("0")
  
    if S.g != 0:
      presubs.append(f"g{S.g}")
  
    OL = [d for d in S.O + S.L if d != m]
    SortMultiplicities(m, OL)
  
    if cstr == "I" and "0" not in presubs and loops:      # Move one loop into In?
      depth = loops.pop(0).DepthString()
      presubs.insert(0, depth)
  
    for l in loops:                 # Loops
      depth = l.DepthString()
      _, supinds, subinds = EdgeDecorations(m, OL, l.di, m, OL, l.dj, depth, True)
      if l.di in OL:
        OL.remove(l.di)
      if l.dj in OL:
        OL.remove(l.dj)
      if not supinds:
        subs.append(depth)
      else:
        sup = '-'.join(map(str, supinds))
        sub = ''.join(map(str, subinds))
        subs.append(f"{{{sup}}}{sub}")
  
    if cstr == "D" and any(D.di == m for D in Dlinks):          # Move one D-link into In*?
      D = next(D for D in Dlinks if D.di == m)
      cstr = "I"
      presups = ["*"]
      depth = D.DepthString()
      presubs.insert(0, depth)
      Dlinks.remove(D)
  
    for D in Dlinks:                 # D-links
      mD = D.mj
      depth = D.DepthString()
      _, _, subinds = EdgeDecorations(m, OL, D.di, mD, [mD], mD, depth, False)
      multopts = OL + [m]
      multpos = multopts.index(D.di) + 1
      supinds = [D.di] if any(OL[i] % 2 == 0 for i in range(multpos - 1)) else []
      if D.di in OL:
        OL.remove(D.di)
      sup = '-'.join(map(str, supinds))
      sub = ''.join(map(str, subinds))
      if not supinds:
        subs.append(f"{sub}D")
      else:
        subs.append(f"{{{sup}}}{sub}D")
  
    edges = [f"-{{{o}}}" for o in S.EdgeMultiplicities()]
  
    return dstr, cstr, presups, sups, presubs, subs, edges


  def TeXLabel(self, edge=False, wrap=False):
    S = self
    dstr, cstr, presups, sups, presubs, subs, edges = S.PrincipalTypeDecorations()

    # Clean and TeX-escape all subscripts (except literal "-1")
    cleaned_subs = []
    for s in subs:
      if s == "-1":
        continue
      s = s.replace("{", "\\{").replace("}", "\\}").replace("-", "\\m")
      cleaned_subs.append(s)

    # Compose subscript and superscript strings
    substr = ",".join(presubs + cleaned_subs)
    substr = TeXPrintParameter(substr, sym="_", printempty=False)

    supstr = ",".join(presups + sups)
    supstr = TeXPrintParameter(supstr, sym="^", printempty=False)

    # Handle edge decorations
    if edge:
      edgestr = "".join(edges).replace("-", "\\e").replace("=", "\\d")
    else:
      edgestr = ""

    out = f"{dstr}{cstr}{supstr}{substr}{edgestr}"
    if wrap:
      out = f"\\redtype{{{out}}}"

    return out


  def HTMLLabel(self, edge=False):   ##
    S = self
    dstr, cstr, presups, sups, presubs, subs, edges = S.PrincipalTypeDecorations()

    # Join and wrap subscripts (genus, loops, D-tails)
    substr = ",".join(presubs + subs)
    substr = f"<sub>{substr}</sub>" if substr else ""

    # Join and wrap superscripts ('*', multiplicities), replacing * with a centered version
    supstr = ",".join(presups + sups).replace("*", "&#x204E;")
    supstr = f"<sup>{supstr}</sup>" if supstr else ""

    # Apply styling if both sup and sub are present
    if substr and supstr:
      supstr = f"<span class='spb'>{supstr}"
      substr = f"{substr}</span>"

    # Edge decorations
    edgestr = "".join(edges) if edge else ""

    return f"{dstr}{cstr}{supstr}{substr}{edgestr}"


  def Label(self, tex=False, html=False, edge=False, wrap=True):
    """
    Return a plain, TeX, or HTML label of a principal type.
    - tex=True returns a TeX label (in \redtype{} unless wrap=False)
    - html=True returns an HTML label
    - edge=True includes outgoing edges
    """

    S = self

    if html:
      assert not tex, "Cannot use both tex and html output formats."
      return S.HTMLLabel(edge=edge)
    if tex:
      return S.TeXLabel(edge=edge, wrap=wrap)

    # Plain string version (non-TeX, non-HTML)
    dstr, cstr, presups, sups, presubs, subs, edges = S.PrincipalTypeDecorations()

    presubstr = "".join(presubs)
    substr = ",".join(subs)
    substr = TeXPrintParameter(substr, sym="_", printempty=False, tex=False)   
    presupstr = "".join(presups)
    supstr = ",".join(sups)
    supstr = TeXPrintParameter(supstr, sym="^", printempty=False, tex=False)   
    edgestr = "".join(edges) if edge else ""

    return f"{dstr}{cstr}{presubstr}{presupstr}{supstr}{substr}{edgestr}"


  def TeX(self, length="35pt", label=False, standalone=False):
    """
    TeX a principal type as a TikZ arc with outer and inner lines, loops, and Ds.
    label=True puts its label underneath.
    standalone=True wraps it in \tikz.
    """
    m = self.Multiplicity()
    g = self.GeometricGenus()

    outer = [f"{l.di}-{l.dj}" for l in self.Loops()]         # loops
    outer += [str(l) for l in self.EdgeMultiplicities()]    # edges
    outer += [f".{l.di}" for l in self.DLinks()]          # D's

    outer_str = PrintSequence(outer, sep=",")
    inner_str = PrintSequence(self.OuterMultiplicities(), sep=",")

    gstr = "" if g == 0 else f"g{g}"        # Genus

    if label:                               # Label
      out = f"\\shapearclabel{{{length}}}{{{outer_str}}}{{{inner_str}}}{{{m}{gstr}}}{{\\redtype{{{self.Label(tex=True, edge=True)}}}}}"
    else:
      out = f"\\shapearc{{{length}}}{{{outer_str}}}{{{inner_str}}}{{{m}{gstr}}}"

    if standalone:                          # Wrap the result in \tikz if standalone=True
      out = f"\\tikz{{\\draw(0,0){out};}}"
    return out


def PrincipalTypesByCore(chi: int, C: RedCore) -> Tuple[List[RedPrin], List[List[int]]]:       ##
  """
  Find all possible principal types S with a given core C and Euler characteristic chi. Return a sequence of them, and a sequence weights representing all possible S.Weight().
  """
  if chi > 0:
    raise ValueError("chi should be negative in PrincipalTypes")
  if chi == 0:
    raise ValueError("Infinitely many principal types with chi=0")

  # print(f"PrincipalTypesByCore(chi={chi}, C={C})")

  out = []    # List of principal components found (of type RedPrin)
  weights = []  # List of Weights found (of type list)

  for d in Divisors(-chi):                    # [d]C is the starting point
    if d * C.Chi() < chi:
      continue

    m = d * C.Multiplicity()
    OC = [d * o for o in C.Multiplicities()]

    for U in MultiSubsets(OC):  # Convert outers to links in all possible ways
      chiL = d * C.Chi() - sum(GCD(d, m) for d in U)  # -> increases chi by sum of gcds
      
      if chiL < chi or (chiL - chi) % m != 0:
        continue

      O = SequenceDifference(OC, U)
      n = (chiL - chi) // m  # Space left to add new links or increase genus

      for g in range(0, n // 2 + 1):
        L = U + [m] * (n - 2 * g)  # Now split L into D's, loops, and edges

        Leven = [d for d in L if d % 2 == 0] if m % 2 == 0 else []

        for LD in MultiSubsets(Leven):  # Loop through possible D-links
          Lleft = SequenceDifference(L, LD)

          pairs = {(l1, l2) for l1 in set(Lleft) for l2 in set(Lleft)    # lists are unhashable, so use tuples
                   if l1 <= l2 and GCD(l1, m) == GCD(l2, m) and (l1 != l2 or ElementMultiplicity(Lleft, l1) >= 2)}
          pairs = [list(p) for p in pairs]                               # and then convert to lists

          possibleloops = [[]]
          for p in pairs:
            for i, c0 in enumerate(possibleloops[:]):
              c = c0.copy()
              while True:
                cnew = c + [p]
                if not IsSubMultiset(sum(cnew, []), Lleft):
                  break
                c = cnew
                possibleloops.append(c)
          
          for Lloops in possibleloops:
            Lfree = SequenceDifference(Lleft, sum(Lloops, []))  # Free links
            S = PrincipalType(m, g, O, Lloops, [[d] for d in LD], Lfree)
            out.append(S)
            weight = S.Weight()
            if not weight in weights:
              weights.append(weight)

  return out, weights


##########


def PrincipalTypesByChi(chi: int, semistable: bool = False) -> Tuple[List[RedPrin], List[List[int]]]:   ##
  """
  Find all possible principal types S with a given Euler characteristic chi. Return a list of them, and a set of Weights representing all possible Weight(S).
  """
  if chi > 0:
    raise ValueError("chi must be negative for a principal types")
  if chi == 0:
    raise ValueError("PrincipalTypes: Infinitely many principal types with chi=0")

  if semistable:
    comps = [C for C in PrincipalTypes(chi, Core(1, [])) if C.Multiplicity() == 1]
    weights = SortSetList(S.Weight() for S in comps)
    return comps, weights

  out = []
  weights = []

  for c in range(2, chi-1, -2):
    mbound = -chi + 2 if c == 2 else 'all'
    for C in Cores(c, mbound=mbound):
      comps, weightc = PrincipalTypes(chi, C, withweights=True)
      out.extend(comps)
      for weight in weightc:
        if not (weight in weights):
          weights.append(weight)

  return out, weights


def PrincipalTypesByWeight(chi: int, weight: List[int], semistable: bool = False) -> List[RedPrin]:     ##
  """
  All possible principal types with a given Euler characteristic chi and GCDs of edge multiplicities.
  """
  weight = sorted(weight)
  return [S for S in PrincipalTypesByChi(chi, semistable=semistable)[0] if S.Weight() == weight]


def PrincipalTypes(chi: int, arg=None, semistable=False, withweights=False, sort=True) -> Tuple[List[RedPrin], List[List[int]]]:
  """
  Principal types with a given Euler characteristic chi, and optional restrictions.
  Returns list of types, or (list of types, discovered GCDs of edges) if withweights=True.
  Can be used as either:
    PrincipalTypes(chi)          - all
    PrincipalTypes(chi,C)        - with a given core C
    PrincipalTypes(chi,Weights)    - with a given sequence of edge weights
  In all three cases can restrict to semistable types, setting semistable=True
  """
  if arg is None:
    out = PrincipalTypesByChi(chi, semistable=semistable)
  elif isinstance(arg, RedCore):
    out = PrincipalTypesByCore(chi, arg)
  elif isinstance(arg, list) and all(isinstance(x, int) for x in arg):
    out = (PrincipalTypesByWeight(chi, arg, semistable=semistable), [arg])
  else:
    raise TypeError(f"PrincipalTypes: second parameter must be RedCore, list of integers, or None - {arg} provided")
  if sort:
    out = (sorted(out[0], key=lambda S: S.Score()),out[1])
  if withweights:
    return out
  else:
    return out[0]

"""
Example
comps, weights = PrincipalTypes(-1, withweights = True)
print(len(comps))                      # all principal types with chi=-1
print(weights)                           # their possible edge gcds (see RedShape)
print(PrincipalTypes(-1,[1,2]))        # select those with edge gcds = [1,2] 
print([len(PrincipalTypes(-n)) for n in range(1,8+1)])   # all with chi=-1,...
"""

"""
Test
assert len(PrincipalTypes(-1, [1])) == 10
"""


"""
Test
C = RedCore(3, [1, 2])
assert len(PrincipalTypes(-2, C)) ==  4
assert len(PrincipalTypes(-4, C)) ==  13
assert len(PrincipalTypes(-6, C)) ==  20
assert len(PrincipalTypes(-9, C)) ==  9 
assert len(PrincipalTypes(-12, C)) == 60
"""


def PrincipalTypeFromScore(w: list[int]) -> 'RedPrin':
  """
  Create a principal type S from its score sequence w (=Score(S)).
  """
  if len(w) < 7:
    raise ValueError(f"Score {w} is too short for a score sequence for a principal type")

  chi, m, g, numedges, numD, numloops, numO = w[:7]                   # extract 7 basic invariants
  wlength = 7 + numO + numedges + 2 * numD + 3 * numloops
  if len(w) != wlength:
    raise ValueError(f"Score sequence {w} has incorrect length (got {len(w)} expected {wlength})")

  Oofs = 7
  loopsofs = Oofs + numO
  Dofs = loopsofs + 2 * numloops
  edgeofs = Dofs + numD
  loopsdepthsofs = edgeofs + numedges
  Ddepthsofs = loopsdepthsofs + numloops

  O = [w[Oofs + j] for j in range(numO)]                           # extract outer multiplicities
  Lloops = [[w[loopsofs + 2*i], w[loopsofs + 2*i+1], w[loopsdepthsofs + i]] for i in range(numloops)]  # extract loops
  LD = [[w[Dofs + i], w[Ddepthsofs + i]] for i in range(numD)]     # extract D-links
  Ledge = [w[edgeofs + j] for j in range(numedges)]                # extract edges
  S = PrincipalType(m, -g, O, Lloops, LD, Ledge)

  if S.Score() != w:
    raise ValueError(f"Score sequence {w} does not agree with Score(S)")

  return S


"""
Example
S = PrincipalType(8,0,[4,2],[[1,1,1]],[[2,1]],[6])  # Create a principal type
w = S.Score()                                      # score encodes chi, m, g etc. 
print(w)                                            #   and characterizes S
print(PrincipalTypeFromScore(w).definition())      # Reconstruct S from the score
"""


def EdgeDecorations(m1, o1, d1, m2, o2, d2, depth, loop, forcesups=False, forcesubs=False):    ##
  """
  Edge decorations sym (- or =), sups, subs (lists of int superscripts) between given components with given starting and available multiplicities

  Edge decorations for a chain of depth `depth` between:
    - component with multiplicity `m1`, available outgoing multiplicities `o1`, chain outgoing multiplicity `d1`, and
    - component with multiplicity `m2`, available outgoing multiplicities `o2`, chain outgoing multiplicity `d2`.
  `forcesups`/`forcesubs` forces superscripts/subscripts to be always present.
  
  Returns:
    - sym: Decoration symbol ('-' or '=')
    - sups: List of superscripts ([d1 mod m1, d2 mod m2] or [])
    - subs: List of subscripts ([depth] or [])
  """
  
  # print(f"EdgeDecorations ({m1},{o1},{d1})-({m2},{o2},{d2}) depth={depth} loop={loop} force={forcesups or forcesubs}")
  
  if d1 <= 0 or d1 > m1:
    raise ValueError("Expected d1 in 1..m1 range")
  if d2 <= 0 or d2 > m2:
    raise ValueError("Expected d2 in 1..m2 range")
  
  # Determine if subscript should be printed
  printsub = forcesubs or str(depth) != str(MinimalDepth(m1, d1, m2, d2))
  subs = [depth] if printsub else []
  
  # Default multiplicities
  d1min, d2min = DefaultMultiplicities(m1, o1, m2, o2, loop)
  
  # Determine the decoration symbol and superscripts
  if d1 == d1min and d2 == d2min and not forcesups:
    sym = "-"
    sups = []
    # Executive decision to remove '=' from notation
    #elif d1 == m1 and d2 == m2 and not loop and not forcesups:
    #  sym = "="
    #  sups = []
  else:
    sym = "-"
    sups = [d1,d2]
  
  return sym, sups, subs

"""
Test
sym, sups, subs = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 1, False)
assert (sym == "-") and (sups == []) and (subs == [1])
sym, sups, subs = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 0, False)
assert (sym == "-") and (sups == []) and (subs == [])
sym, sups, subs = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 0, False, forcesubs=True, forcesups=True)
assert (sym == "-") and (sups == [1, 1]) and (subs == [0])
sym, sups, subs = EdgeDecorations(6, [1, 2, 3], 6, 6, [1, 2, 3], 6, 1, True)
assert (sym == "-") and (sups == []) and (subs == [])
"""

"""
Test
comps   = PrincipalTypes(-1,[1])
truestr = "I1-{1} Ig1-{1} I1*-{1} I0*-{1} IV-{1} IV*-{2} III-{1} III*-{3} II-{1} II*-{5}"
truestr = set(truestr.split(" "))
compstr = {str(c) for c in comps}
assert truestr == compstr

comps   = PrincipalTypes(-2,[])
truestr = "I1_1 I1g1 Ig2 [2]I1_D [2]I_D,D,D [2]Ig1_D D_{2-2} I1*_D Dg1 I1*_0 [2]I1*_D [2]T_{6}D 4^1,3_D I0*_D I0*_0 [2]I0*_D IV_0 [2]IV_D IV*_-1 [2]IV*_D III_0 III_D [2]III_D III*_D III*_-1 [2]III*_D II_D [2]II_D II*_D [2]II*_D 2^1,1,1,1,1,1 3^1,1,2,2 4^1,3,2,2 5^1,1,3 5^1,2,2 5^2,4,4 5^3,3,4 6^1,1,4 6^2,4,3,3 6^5,5,2 8^1,3,4 8^5,7,4 10^1,4,5 10^3,2,5 10^7,8,5 10^9,6,5"
truestr = set(truestr.split(" "))
compstr = {str(c) for c in comps}
assert truestr == compstr

comps   = PrincipalTypes(-6,[2,2])
truestr = "[2]I1_D-{2}-{2} [2]I_D,D,D-{2}-{2} [2]Ig1_D-{2}-{2} D_{2-2}-{2}-{2} I1*_D-{2}-{2} Dg1-{2}-{2} I1*_0-{2}-{2} [2]T_{6}D-{2}-{4} I0*_D-{2}-{2} I0*_0-{2}-{2} [2]I0*_D-{2}-{2} [2]IV_D-{2}-{2} [2]IV*_D-{4}-{4} 2^1,1,1,1,1,1-{2}-{2} 4^1,3,2,2-{2}-{2} 6^2,4,3,3-{2}-{4}"
truestr = set(truestr.split(" "))
compstr = {str(c) for c in comps}
assert truestr == compstr

comps   = PrincipalTypes(-6,[2,4])
truestr = "[2]I1*-{2}-{4} [2]I0*-{2}-{4} III-{2}-{4} [2]III-{2}-{4} III*-{2}-{4} [2]III*-{6}-{4} [2]II-{2}-{4} [2]II*-{10}-{8}"
truestr = set(truestr.split(" "))
compstr = {str(c) for c in comps}
assert truestr == compstr
"""


def PrincipalTypesTeX(T, width=10, scale=0.8, sort=True, label=False, length="35pt", yshift="default"):
  """
  TeX a list of principal types as a rectangular table in a TikZ picture.
  label=True puts the principal type label underneath.
  sort=True sorts the types by Score first, in increasing order.
  yshift controls the y-axis shift after every row, based on label presence.
  width controls the number of principal types per row.
  scale controls the TikZ picture global scale.
  """

  if sort:
    T.sort(key=lambda S: S.Score())    # Sorting by Score in increasing order

  if yshift == "default":               # Shift in y (based on the label)
    yshift = 2 if label else 1.2

  out = []

  for i, S in enumerate(T, start=1):
    if i % width != 0:                  # Determine the position shift for the current item
      dx, dy = 2.5, 0
    else:
      dx, dy = -(width - 1) * dx, -yshift
    shift = "" if i == len(T) else f" ++({dx},{dy})"
    out.append(S.TeX(label=label, length=length) + shift)

  out_str = PrintSequence(out, sep=" ")
  return f"\\begin{{tikzpicture}}[scale={scale}]\n\\draw(0,0)\n{out_str};\n\\end{{tikzpicture}}\n"


"""
Example TeX for principal types
# Here are the 13 principal types with chi=-1 (10 Kodaira + 3 'exotic')
L = PrincipalTypes(-1)
print(PrincipalTypesTeX(L, label=True, width=7, yshift=2.2))
"""


### RedShape 


"""
Manual
A reduction type a graph whose vertices are principal types (type RedPrin) 
and edges are inner chains. They fall naturally into `shapes', where every vertex only remembers the 
Euler characteristic $\chi$ of the type, and edge the gcd of the chain. Thus, the problem
of finding all reduction types in a given genus (see ReductionTypes) reduces to that of finding the possible
shapes (see Shapes) and filling in shape components with given $\chi$ and gcds of edges (see PrincipalTypes).
"""

"""
Example Table of all genus 2 shapes, with numbers of principal type combinations.
# Here is how this works in genus 2. The 104 families of reduction types break into five possible shapes, with all 
# but three types in the first two shape (46 and 55 types, respectively):
L = Shapes(2)
print("\\qquad ".join([D[0].TeX(shapelabel=D[1]) for D in L]))
"""

class RedShape:
  def __init__(self):      ##
    self.G = None  # Underlying undirected graph
    self.V = None  # Vertex set
    self.E = None  # Edge set
    self.D = None  # Double graph
 
  def __repr__(self):   ##
    """
    Print a shape in the form that can be evaluated Shape(vertex labels, edge labels)
    """
    return f"Shape({self.VertexLabels()},{self.EdgeLabels()})".replace(" ","")

  def TeX(self, scale=1.5, center=False, shapelabel="", complabel="default", boundingbox=False):
    """
    Tikz a shape of a reduction graph, and, if required the bounding box x1, y1, x2, y2.
    """
    T,x1,y1,x2,y2=TeXRedShape(self, scale=scale, center=center, shapelabel=shapelabel, complabel=complabel)
    if boundingbox:
      return T,x1,y1,x2,y2
    else:
      return T

  def Graph(self):
    """
    Returns the underlying undirected graph G of the shape.
    """
    return self.G

  def __len__(self):
    """
    Returns the number of vertices in the graph G underlying the shape.
    """
    return len(self.V)

  def Vertices(self):
    """
    Returns the vertex set of G as a graph.
    """
    return self.V

  def Edges(self):
    """
    Returns the edge set of G as a graph.
    """
    return self.E

  def DoubleGraph(self):
    """
    Returns the vertex-labelled double graph D of the shape.
    """
    return self.D

  def Chi(self, v=None):
    """
    Returns the Euler characteristic chi(v) <= 0 of the vertex v, or total Euler characteristic if v=None
    """
    if v is None:
      chi = sum(self.Chi(v) for v in self.V)
      assert chi <= 0, f"Total Euler characteristic {chi} > 0."
      return chi
    assert v in self.V, "Vertex not in the vertex set of G."
    chi = self.G.nodes[v]['label'][0]  
    assert chi <= 0, f"Invalid Euler characteristic: {chi} > 0."
    return chi

  def Weights(self, v):
    """
    Returns the Weights of a vertex v that together with chi determine the vertex type (chi, weights).
    """
    incident_edges = self.G.edges(v, data='label')
    weights = [label for _, _, label in incident_edges]
    return sorted(sum(weights,[]))

  def VertexLabels(self):
    """
    Returns a sequence of -chi's for individual components of the shape S.
    """
    return [-self.Chi(v) for v in self.V]

  def EdgeLabels(self):
    """
    Returns a list of edges v_i -> v_j of the form [i, j, edgegcd].
    """
    E = []
    for e in self.E:
      v1, v2 = sorted(e)  
      edge_label = self.G.edges[e]['label']  
      E.append([v1, v2] + edge_label)
    return E


def Shape(V: list[int], E: list[list[int]]) -> RedShape:
  """
  Constructs a graph shape from the vertex data V and list of edges with multiplicities E.

  The format is as in shapes*.txt data files:
  V = sequence of -chi's for individual components
  E = list of edges v_i->v_j of the form [i,j,edgegcd1,edgegcd2,...]
  """
  assert V == [0] or all(d > 0 for d in V), "chi's > 0, unless one vertex with chi = 0"
  assert all(len(e) >= 3 and min(e) > 0 for e in E), "edge gcd's > 0"

  n = len(V)
  k = 0  # number of extra vertices #V(D) - #V(G)

  G = nx.Graph()  # Initialize G as an undirected graph
  D = nx.Graph()  # Initialize D as an undirected graph

  # Assign labels to the vertices in G and D (labels as [-v] for each vertex)
  for i in range(1,n+1):
    G.add_node(i, label=[-V[i-1]])
    D.add_node(i, label=[-V[i-1]])

  for e in E:  # e = [i, j, gcd1,...]
    i, j = e[0], e[1]
    gcds = sorted(e[2:])

    if G.has_edge(i, j):  # Check if the edge (i, j) already exists in G
      raise ValueError(f"Already have an edge {i}-{j} in the shape")
    G.add_edge(i, j, label=gcds)  # Add edge with gcds as the label

    if gcds == [1]:
      D.add_edge(i, j)  # unique edge of gcd one - no intermediate vertices
    else:
      k += 1
      new_vertex = n + k
      D.add_node(new_vertex, label=gcds)  # append a vertex indexed n+k with label gcds
      D.add_edge(new_vertex, i)  # add two (unlabelled) edges connecting it to v_i and v_j
      D.add_edge(new_vertex, j)

  S = RedShape()  # Create a new RedShape S, fill in values and return
  S.G = G
  S.V = list(G.nodes)  # Get vertices and their data (labels)
  S.E = list(G.edges)  # Get edges and their data (labels)
  S.D = D

  return S


"""
Example Printing a shape
print(ReductionType("IV-IV-IV").Shape())  # 3 vertices with chi=-1,-2,-1 and 2 edges
print(ReductionType("1---1").Shape())     # 2 vertices with chi=-1,-1 and a triple edge
"""


def IsIsomorphic(S1: RedShape, S2: RedShape) -> bool:
  """
  Check whether two shapes are isomorphic via their double graphs
  """
  return nx.is_isomorphic(S1.D, S2.D, node_match=lambda x, y: x['label'] == y['label'], edge_match=lambda x, y: x.get('label') == y.get('label'))


"""
Example Shape isomorphism testing
S1 = Shape([1, 2, 3], [[1, 2, 3], [2, 3, 1], [1, 3, 2]])
S2 = Shape([2, 3, 1], [[1, 2, 1], [2, 3, 2], [1, 3, 3]])  # rotate the graph
assert IsIsomorphic(S1, S2)
S3 = Shape(S1.VertexLabels(),S1.EdgeLabels())             # reconstruct S1
assert IsIsomorphic(S1, S3)
"""


def Shapes(genus, filemask="data/shapes{}.txt"):
  """
  Returns all shapes in a given genus, assuming they were downloaded in data/
  """
  if genus <= 0:
    raise ValueError("Shapes: expected genus >= 2")
  elif genus == 1:
    raise ValueError("Shapes: infinitely many reduction types in genus 1")

  filename = filemask.format(genus)
  try:
    with open(filename, 'r') as file:
      data = file.read()                               # Try reading the shapes file
  except Exception as e:
    raise IOError(f"Shapes file {filename} not found (genus too large, wrong directory, or not installed)")

  shapes_list = []
  for line in data.splitlines():
    if len(line) == 0 or not line.startswith("["):         # Skip lines that are not valid shape descriptions
      continue
    d = line.split(" ")
    V = eval(d[0])         # Vertex/chi list
    E = eval(d[1])         # Edge list
    count = eval(d[3])     # Reduction types count
    shapes_list.append((Shape(V, E), count))     # Append the shape to the result

  return shapes_list


def UniqueShapeCompType(chi, weights):   ##
  """
  Returns the unique principal type corresponding to the given chi and weights.
  Raises an error if no unique type is found.
  """
  L = PrincipalTypes(chi, weights)
  if len(L) != 1:
    raise ValueError(f"UniqueShapeCompType: Principal with chi={chi} weights={weights} type is not unique: L = {L}")
  return L[0]


def NumTypesWithGivenShapeComp(chi, weights):    ##
  """
  Returns the number of principal types corresponding to the given chi and weights.
  """
  L = PrincipalTypes(chi,weights)
  return len(L)


def TeXShapeVertex(chi, weights, complabel="default"):    ##
  """
  Returns the TeX label for the shape component.
  """
  if not isinstance(complabel, str):
    complabel = complabel(chi, weights) 
  if not isinstance(complabel, str):
    raise ValueError("complabel is not 'default' or a string or a function(chi, weights)->string")
  
  if complabel == "default":
    N = NumTypesWithGivenShapeComp(chi, weights)
    return UniqueShapeCompType(chi, weights).Label(tex=True, wrap=True) if N == 1  \
            else f"{-chi}^{{\\scriptscriptstyle {PrintSequence(weights, empty='\\emptyset')}}}_{{({N})}}"
  else:
    return complabel


def TeXShapeVertexRedShape(S, v, complabel="default"):    ##
  """
  Returns the TeX label for the shape component of a RedShape.
  """
  return TeXShapeVertex(S.Chi(v), S.Weights(v), complabel=complabel)


def EdgeBends(N, factor=1):      ##
  """
  Returns angles to bend edges depending on their number for Tikz.
  """
  if N <= 5:
    bends = [[], [0], [-30, 30], [-60, 0, 60], [-90, -30, 30, 90], [-100, -50, 0, 50, 100]][N]
  else:
    bends = [(i * 240 / (N - 1) - 120) for i in range(N)]
  return [round(b / factor) for b in bends]


def TeXRedShape(S, scale=1.5, center=False, shapelabel="", complabel="default"):   ##
  """
  Tikz a shape of a reduction graph, and a bounding box x1, y1, x2, y2.
  """
  PR = lambda v: PrintReal(v, prec=2)           # Printing reals with at most two digits after the comma

  x, y = StandardGraphCoordinates(S.G)
  vdist = max(y) - min(y)
  if vdist > 1.3:
    y = [a * 1.3 / vdist for a in y]
    
  basey = (max(y) + min(y)) / 2

  out = [
    f"\\node[inner sep=2pt] at ({PR(x[i])},{PR(y[i])}) ({i+1}) {{$ {TeXShapeVertexRedShape(S, v, complabel=complabel)} $}};"
    for i, v in enumerate(S.Vertices())
  ]

  for e in S.Edges():
    i1, i2 = e   
    E = S.G.edges[e]['label']           # gcds of edges between same vertices
    gcdlabel = "" if len(E) == 1 and E[0] == 1 else f"node[gcd] {{{PrintSequence(E, sep=',')}}} "
    out.append(f"\\draw[thick] ({i1}) to {gcdlabel}({i2});")

  baseline = f"baseline={PR(basey)}," if center else ""
  labelstr = f"\\node at ({PR((min(x) + max(x)) / 2)},{PR(basey - 1)}) {{{shapelabel}}};\n" if shapelabel!="" else ""
  
  x1 = min(x) - 0.3
  y1 = basey - (0 if shapelabel == "" else 1) - 0.3
  x2 = max(x) + 0.3
  y2 = max(y) + 0.5
  labelstr += f"\\useasboundingbox ({PR(x1)},{PR(y1)}) rectangle ({PR(x2)},{PR(y2)});\n"
  
  out = f"\\begin{{tikzpicture}}[scale={PR(scale)},{baseline}gcd/.style={{auto,scale=0.6}}]\n{PrintSequence(out, sep='\n')}\n{labelstr}\\end{{tikzpicture}}"

  return out, x1, y1, x2, y2


"""
Example Graph, DoubleGraph and primary invariants for shapes
# Under the hood of shapes of reduction types are their labelled graphs and associated `double' graphs. 
# As an example, take the following reduction type:
R=ReductionType("Ig2--IV=IV-Ig1-c1")   
print(R.TeX())
# There are four principal types, and they become vertices of R.Shape() whose labels are their Euler characteristics
# $-5, -2, -4, -5$. The edges are labelled with GCDs of the inner chain between the types.
# For example:\par
# \begin{tabular}{@{\qquad}l}
# --- the inner chain Ig2-Ig1 of gcd 1 becomes the label ``1'', \cr
# --- the inner chain IV=IV of gcd 3 becomes ``3'',\cr
# --- the two chains Ig2--IV of gcd 1 become ``1,1''\cr
# \end{tabular}\par
# on the corresponding edges. 
S=R.Shape() 
print(S)
print(TeXGraph(S.Graph()))
print(S.Vertices())          # Indexed set of vertices of S.Graph(), numbered from 1
print(S.Edges())             #   and edges [ (from_vertex, to_vertex), ... ]
print(S.VertexLabels())      # [-chi] for each type
print(S.EdgeLabels())        # [ [from_vertex, to_vertex, gcd1, gcd2, ...], ...]
# MinimumScorePaths is implemented in python for graphs with labelled vertices but not edges. 
# To use them for shapes, the underlying graphs are converted to graphs with only labelled
# vertices. This is done simply by introducing a new vertex on every edge which carries the corresponding edge 
# label. For compactness, if the label is ``1'' (most common case), we don't introduce the vertex at all.
# This is called the double graph of the shape:
blue = "circle,scale=0.7,inner sep=2pt,fill=blue!20"       # former vertices
red  = "circle,draw,scale=0.5,inner sep=2pt, fill=red!20"  # former edges
D    = S.DoubleGraph()
bluered = lambda v: blue if sum(GetLabel(D,v)) <= 0 else red
print(TeXGraph(D, scale:=1, vertexnodestyle=bluered))
# These are used in isomorphism testing for shapes, and to construct minimal paths.
"""


### Labelled graphs and minimum paths


def Graph(vertices, edges=[]):
  """
  Construct a graph from vertices (or their number) and edges, numbered from 1

  For example Graph(3,[[1,2],[2,3]]) or Graph([3,4,5],[[3,4],[4,5]])
  """
  G = nx.Graph()
  if isinstance(vertices, int):
    vertices = range(1, vertices + 1)
  G.add_nodes_from(vertices)
  G.add_edges_from(edges)
  return G


def IsLabelled(G, v):
  """
  Determines if vertex v in graph G has an associated label.
  """
  return 'label' in G.nodes[v]


def IsLabelled(G):
  """
  Checks if all vertices in graph G have an assigned label.
  """
  return all('label' in G.nodes[v] for v in G.nodes())

def GetLabel(G, x):
  """
  Retrieves the label of a vertex or edge x from graph G.
  """
  if x in G.nodes:
    return G.nodes[x].get('label', "")
  elif x in G.edges:
    return G.edges[x].get('label', "")
  else:
    raise TypeError(f"GetLabel(G,x): x={x} is neither a vertex nor an edge of G")


def GetLabels(G):
  """
  Returns a list of labels assigned to the vertices of graph G.
  """
  return [GetLabel(G,v) for v in G.nodes()]


def AssignLabel(G, v, label):
  """
  Assign a label to the vertex v in graph G.
  """
  G.nodes[v]['label'] = label


def AssignLabels(G, labels):
  """
  Assigns labels to the vertices of graph G based on the provided list of labels.
  """
  for v, label in zip(G.nodes(), labels):
      G.nodes[v]['label'] = label


def DeleteLabels(G):
  """
  Deletes the labels from all vertices in the graph G if they exist.
  """
  for v in G.nodes():
    if 'label' in G.nodes[v]:  # Check if the 'label' exists
      del G.nodes[v]['label']   # Delete the 'label' if it exists


def MinimumScorePaths(D):
  """
  Determines minimum score paths in a connected labelled undirected graph, returning scores and possible vertex index sequences.

  Minimum score paths for a labelled undirected graph (e.g. double graph underlying shape)
  returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism) 
    and I=list of possible vertex index sequences
  For example for a rectangular loop G with all vertex chis=1 and edges as follows
    V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  
  the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is 
    W = [<0,[-1],False>,<0,[-1],False>,<0,[-1],False>,<0,[1,1],False>,<0,[-1],False>,
         <0,[2],False>,<1,[-1],True>]
  The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded
    T = [[3,2,1,6,4,5,3]]
  """

  if isinstance(D,RedShape):
    return MinimumScorePaths(D.DoubleGraph())

  # implemented for connected graphs with (possibly) labelled vertices and unlabelled edges
  if not nx.is_connected(D):
    raise ValueError("MinimumScorePaths requires the graph to be connected")  
  # if any('label' in D[u][v] for u, v in D.edges()):
  #   raise ValueError("MinimumScorePaths is implemented for unlabelled edges")

  V = list(D.nodes())          # V vertices, E edges 
  E = list(D.edges())

  vprint("Edges:", E)

  if not IsLabelled(D):
    AssignLabels(D,[0 for v in V])        # assign zero labels
    W, T = MinimumScorePaths(D)          # compute paths
    DeleteLabels(D);                      # and remove labels
    return W, T                           # and return

  odd_vertices = {v for v in V if D.degree[v] % 2 == 1}      # odd degree vertices - possible starting points
  start = V if not odd_vertices else list(odd_vertices)

  min_label = min(D.nodes[v]['label'] for v in start)        # restrict to those with chi minimal
  start = [v for v in start if D.nodes[v]['label'] == min_label]

  # score is a sequence [<index, label, jump>,...]  
  #   index  = first time vertex v appears in the path, numbered from 1
  #   label  = label of the vertex v in the path (=chi(component) for reduction types)
  #   jump   = False if we are doing an edge from v to the next vertex, True if we are out of edges
  # path = <indices, edgesleft, odd, score, v>
  #   indices   = where each vertex in V first appears in the path, -1 if not yet
  #   edgesleft = set of edges indices in 1..#E not done yet, in sets of connected components
  #   odd       = vertices of odd degree with respect to edgesleft
  #   score    = score of the current path, as above
  #   v         = last vertex in the path
  # P = sequence of current paths

  P = []
  for v in start:
    label = D.nodes[v]['label']
    jump = len(V) == 1
    index = 1
    indices = [1 if w == v else 0 for w in V]
    edgesleft = [set(E)]                        # all edges in one connected component
    score = [(0, label, jump)]
    P.append((indices, edgesleft, odd_vertices, score, v))

  vprint(f"Starting paths {P}")

  bestscore = score
  bestindices = [indices]
  counter = 0

  while P:
    counter += 1
    if counter > 10000:
      print(f"Number of steps exceeded, exiting")
      return [],[]

    p = P.pop(0)                                      # process the next path, P is a queue
    indices, edgesleft, odd, score, v = p

    vprint(f"{counter} Processing indices={indices}, edgesleft={edgesleft}, odd={odd}, score={score}, v={v}({D.nodes[v]['label']}) [bestscore={bestscore}]")

    if ScoreIsSmaller(score, bestscore) == ">":
      continue

    index, label, jump = score[-1]

    if not jump:
      Vnext = []                               # Vnext = possible next vertices (out of v)
      for component in edgesleft:
          for e in component:
            if e[0] != v and e[1]!=v: 
              continue
            w = e[1] if e[0] == v else e[0]    # w = EdgeLeadsTo(e,v), if v is an endpoint
            vprint(f"Trying edge {v}->{w}")
            newodd = odd.symmetric_difference({v, w})

            # Identify the vertices in the component and create the subgraph induced by this component
            subgraph_nodes = set(component)
            # Create a subgraph by excluding edge 'e' from component 'component'
            D0 = D.edge_subgraph([e2 for e2 in component if e2 != e]).copy()   
            components = list(nx.connected_components(D0))  # Get its connected components

            C = [set(c) for c in components if len(c) > 1]  # found connected component 

            vprint(f"C = {C}")

            if any(w not in c and not newodd.intersection(c) for c in C):  # without odd vertices
              vprint(f"Trying {w}({D.nodes[w]['label']}) -> Abandoning")
              continue

            newedgeleft = [{e2 for e2 in component if e2 != e and set(e2).issubset(c)} for c in C] + [c for c in edgesleft if c != component]
            Vnext.append((w, newedgeleft, newodd))
            vprint(f"Trying {w}({D.nodes[w]['label']}) -> Adding")
    else:
      Vnext = [(o, edgesleft, odd) for o in odd]

    vprint(f"Vnext = {Vnext}")

    for data in Vnext:
      newv, newedgesleft, newodd = data
      i = V.index(newv)+1
      newlabel = D.nodes[newv]['label']
      newjump = not any(newv in e for edges in newedgesleft for e in edges)
      vprint(f"newedgesleft={newedgesleft} i={i}({newv},{newlabel}) -> jump {newjump}\n")
      newindices = indices[:]
      newindex = newindices[i-1]
      newscore = score + [(newindex, newlabel, newjump)]

      sgn = ScoreIsSmaller(newscore, bestscore)

      addindices = newindices
      if newindex == 0:
        addindices[i-1] = len(newscore)

      if len(newscore) > len(bestscore) and sgn != "l":
        raise ValueError(f"MinimumScorePaths internal error: new score is longer than best score but not compatible (sgn={sgn})\nnew score  = {newscore}\nbest score={bestscore}")

      vprint(f"newi={newindex} new={newscore} best={bestscore} sgn={sgn}")

      if sgn in ["<", "l"]:
        bestindices = [addindices]
        bestscore = newscore
      elif sgn == "=":
        bestindices.append(addindices)
      else:
        continue

      newp = (addindices, newedgesleft, newodd, newscore, newv)
      P.append(newp)

  vprint(f"#steps={counter} bestscore={bestscore} bestindices={bestindices}")

  # Construct trails from best indices and best score
  trails = []
  for a in bestindices:
    trail = []
    for i, p in enumerate(bestscore, start=1):
      if p[0] == 0:
        trail.append(a.index(i) + 1)
      else:
        trail.append(a.index(p[0]) + 1)
    trails.append(trail)

  return bestscore, trails


"""
Test C-B-A labelled
G = nx.Graph()
G.add_edges_from([(1, 2), (2, 3)])
AssignLabels(G, ["C", "B", "A"])
P, a = MinimumScorePaths(G)
assert P == [(0,'A',False),(0,'B',False),(0,'C',True)]
assert a == [[3,2,1]]
"""

"""
Test v-v-v-v unlabelled
G = nx.Graph()
G.add_edges_from([(1, 2), (2, 3), (3, 4)])
#AssignLabels(G, ["B", "A", "A", "B"])
P, a = MinimumScorePaths(G)
assert P == [(0,0,False),(0,0,False),(0,0,False),(0,0,True)]
assert a == [[1,2,3,4],[4,3,2,1]]
"""

"""
Test
G = nx.Graph()
G.add_nodes_from([1,2,3])
G.add_edges_from([(2, 1), (2, 3)])
AssignLabels(G, ["A", "B", "A"]) 
P, a = MinimumScorePaths(G)
assert P == [(0,'A',False),(0,'B',False),(0,'A',True)]
assert a == [[1,2,3],[3,2,1]]
"""


"""
Example Minimum score paths
G = Graph(4,[(1,2),(2,3),(3,4),(4,1),(1,3)])
AssignLabels(G, ["C", "B", "C", "A"])
print(TeXGraph(G))
# \par Now we calculate minimum score paths:
P, a = MinimumScorePaths(G)
# Print the minimal path and the trails, both from one odd degree vertex to the other one:
print("P:", P)
print("a:", a)
# Here is another graph on five vertices, this time not Eulerian
G = Graph(5,[(2,1),(2,3),(2,4),(2,5)])
AssignLabels(G, ["A", "B", "A", "A", "C"])
print(TeXGraph(G))
# \par Calculate minimum score path, which is A-B-A, A-2-C (where 2 is `second vertex on the path')
P, a = MinimumScorePaths(G)
# Print the minimal path
print("P:", P)
# There are 6 ways to trace this path, and they form an Aut(G)=S3-torsor. The first one is
print(f"One trail out of {len(a)} is {a[0]}")
"""


def GraphLabel(G, full=False, usevertexlabels=True):
  """
  Generate a graph label based on a minimum score path, determines G up to isomorphism.

  The label is constructed by iterating through the minimum score path and formatting
  the vertices and edges with labels, if present.
  If full=True, returns also P, T from MinimumScorePaths(G) for vertex recoding
  """

  savelabels = GetLabels(G)       # Save current labels
  if not usevertexlabels:
    DeleteLabels(G)               # Remove labels 
  P, T = MinimumScorePaths(G)    # Path without labels   
  AssignLabels(G,savelabels)      # Restore labels

  label = ""  
  for data in P:
    vertex, vlabel, jump = data   # Decompose the minimum score data
    if vlabel == 0 or not usevertexlabels:
      vstr = "v"                  # Use "v" for unlabeled vertices
    else:
      vstr = f"[{vlabel}]"        # Use "[label]" for labeled vertices
    if vertex == 0:
      label += vstr               # Append the new vertex label
    else:
      label += str(vertex)        # Append the revisited vertex number
    if jump:                      # Edges:
      label += "&"                  # Use "&" for jump
    else:
      label += "-"                  # Use "-" for edge

  if full:
    return label[:-1], P, T       # Remove the last "&" and return, together with minimum path
  else:
    return label[:-1]             # Remove the last "&" and return just the label


def PrintReal(x, prec=2):    ##
  """
  Print a real number with a fixed number of decimals after the dot (and no trailing zeroes)
  """
  s = f"{x:.{prec}f}"     # Convert to string with 'prec' decimal places
  n = len(s)
  p = s.find(".")         # Find position of the decimal point
  if p != -1:
    n = p + prec + 1      # Truncate to 'prec' decimal places
    while n > 1 and s[n-1] == "0":       # Remove trailing zeros
      n -= 1 
    if n > 1 and s[n-1] == ".":          # and '.' symbol if at the end
      n -= 1
  return s[:n]


gridgraphs=[                  # including all planar of size <=7, see planar.m and gridgraphs.m
  (Graph(1,[]),[1],[1],"v"),
  (Graph(2,[[1,2]]),[1,2],[1,1],"v-v"),
  (Graph(3,[[2,3],[1,2]]),[1,2,3],[1,1,1],"v-v-v"),
  (Graph(3,[[1,3],[2,3],[1,2]]),[1,2,1],[2/5,1,8/5],"v-v-v-1"),
  (Graph(4,[[2,4],[2,3],[1,2]]),[11/10,2,11/10,3],[2/5,1,8/5,1],"v-v-v&v-2"),
  (Graph(4,[[2,4],[2,3],[1,2],[3,4]]),[3,2,1,1],[8/5,8/5,11/5,1],"v-v-v-v-2"),
  (Graph(4,[[2,3],[1,2],[3,4]]),[1,2,3,4],[1,1,1,1],"v-v-v-v"),
  (Graph(4,[[1,3],[1,4],[2,3],[1,2],[3,4]]),[2,1,2,3],[1,1,2,1],"v-v-v-v-1-3"),
  (Graph(4,[[1,4],[2,3],[1,2],[3,4]]),[1,2,3,2],[1,2/5,1,8/5],"v-v-v-v-1"),
  (Graph(4,[[1,3],[1,4],[2,4],[2,3],[1,2],[3,4]]),[11/10,2,11/10,16/5],[2/5,1,8/5,1],"v-v-v-v-1-3&2-4"),
  (Graph(5,[[2,5],[2,4],[2,3],[1,2]]),[1,5/2,2,3,4],[1,2,1,1,1],"v-v-v&v-2-v"),
  (Graph(5,[[2,5],[2,4],[2,3],[1,2],[3,4]]),[1,2,3,3,1],[1,3/2,1,2,2],"v-v-v-v-2-v"),
  (Graph(5,[[2,5],[2,3],[1,2],[3,4],[4,5]]),[37/10,27/10,9/5,1,9/5],[1,1,2/5,1,8/5],"v-v-v-v-v-2"),
  (Graph(5,[[2,5],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v-2-4"),
  (Graph(5,[[2,5],[2,3],[1,2],[3,4]]),[1,2,3,4,2],[1,1,1,1,2],"v-v-v-v&v-2"),
  (Graph(5,[[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v&2-4"),
  (Graph(5,[[1,5],[1,4],[3,5],[2,3],[1,2],[3,4]]),[1,1,3,3,2],[1,2,2,1,3/2],"v-v-v-v-1-v-3"),
  (Graph(5,[[2,5],[1,4],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,3,11/5,3,15/4],[2,6/5,2,14/5,2],"v-v-v-v-v-2-4-1"),
  (Graph(5,[[2,5],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3],[2,2,1,1,2],"v-v-v-v-v-2&3-5"),
  (Graph(5,[[2,5],[3,5],[2,4],[2,3],[3,4],[1,2],[4,5]]),[21/5,16/5,11/10,2,11/10],[1,1,2/5,1,8/5],"v-v-v-v-v-2-4&3-5"),
  (Graph(5,[[1,5],[2,5],[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,11/5,3,15/4,3],[2,2,6/5,2,14/5],"v-v-v-v-v-1-3-5-2"),
  (Graph(5,[[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5],[1,1,1,1,1],"v-v-v-v-v"),
  (Graph(5,[[1,5],[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[2,1,5/2,4,3],[1,1,2,1,1],"v-v-v-v-v-1-3-5"),
  (Graph(5,[[3,5],[2,3],[3,4],[1,2],[4,5]]),[4,3,2,1,1],[1,1,1,8/5,2/5],"v-v-v-v-v-3"),
  (Graph(5,[[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3],[1,2,2,2,1],"v-v-v-v-v-3-1"),
  (Graph(5,[[1,5],[1,3],[2,3],[1,2],[3,4],[4,5]]),[2,3,2,1,1],[1,2,2,2,1],"v-v-v-v-v-1-3"),
  (Graph(5,[[1,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,21/10,14/5,21/10],[7/5,13/5,3,2,1],"v-v-v-v-v-1"),
  (Graph(5,[[1,5],[1,3],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,3,3],[1,3/2,2,2,1],"v-v-v-v-v-1-3&2-4"),
  (Graph(5,[[1,5],[1,3],[2,4],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3],[1,2,3/2,2,1],"v-v-v-v-v-1-3-5&2-4"),
  (Graph(5,[[1,3],[1,5],[2,5],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[7/4,6/5,6/5,15/4,11/4],[2,3,1,2,2],"v-v-v-v-v-1-3-5-2-4"),
  (Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2]]),[1,3,2,3,5,4],[1,2,1,1,1,1],"v-v-v&v-2-v&v-2"),
  (Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4]]),[1,2,2,3,1,3],[3/2,2,1,3/2,5/2,5/2],"v-v-v-v-2-v&v-2"),
  (Graph(6,[[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5,2],[1,1,1,1,1,2],"v-v-v-v-v&v-2"),
  (Graph(6,[[2,5],[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,2],[2,2,3,3,2,1],"v-v-v-v-v-2-v"),
  (Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,2,1],[3/2,2,5/2,3/2,1,5/2],"v-v-v-v-v-2-v&2-4"),
  (Graph(6,[[2,5],[2,6],[4,6],[2,3],[3,4],[1,2],[4,5]]),[3,3,1,2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4"),
  (Graph(6,[[2,5],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[3,5/2,1,5/2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4-2"),
  (Graph(6,[[2,5],[2,6],[2,3],[3,4],[1,2]]),[7/3,3,2,1,11/3,4],[2,1,1,1,2,1],"v-v-v-v&v-2-v"),
  (Graph(6,[[2,5],[3,6],[2,3],[1,2],[3,4]]),[1,2,3,4,1,4],[1,3/2,3/2,1,2,2],"v-v-v-v&v-2&v-3"),
  (Graph(6,[[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,2,1,2,1,2],"v-v-v-v-v&v-2-4"),
  (Graph(6,[[2,5],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,4],[2,2,1,1,2,1],"v-v-v-v-v-2&v-4"),
  (Graph(6,[[2,5],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3,3],[2,2,1,1,2,1],"v-v-v-v-v-2-4-v"),
  (Graph(6,[[2,5],[2,6],[1,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,5/2,2,5/2,3,4],[2,1,2,3,2,2],"v-v-v-v-v-2-v-4-1"),
  (Graph(6,[[1,5],[3,6],[1,3],[1,4],[3,5],[2,3],[1,2],[3,4],[1,6]]),[5/2,1,5/2,4,3,2],[1,2,3,2,2,2],"v-v-v-v-1-v-3-v-1-3"),
  (Graph(6,[[2,5],[2,6],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,2,1,1,2,2],"v-v-v-v-v-2-v&3-5"),
  (Graph(6,[[2,5],[2,6],[3,5],[2,4],[2,3],[3,4],[1,2],[4,5]]),[21/5,16/5,11/10,2,11/10,21/5],[2/5,1,2/5,1,8/5,8/5],"v-v-v-v-v-2-v&2-4&3-5"),
  (Graph(6,[[2,6],[2,4],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4"),
  (Graph(6,[[2,5],[2,6],[2,4],[4,6],[2,3],[3,4],[1,2],[5,6],[4,5]]),[7/2,3,9/2,3,2,1],[2,3,2,1,2,2],"v-v-v-v-v-v-2-4-6&2-5"),
  (Graph(6,[[2,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[1,1,1,2,2,2],"v-v-v-v-v-v&2-5"),
  (Graph(6,[[2,5],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v&2-5-3"),
  (Graph(6,[[2,5],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[4,3,2,1,3,4],[1,1,2,2,3,3],"v-v-v-v-v-v&3-5-2-4"),
  (Graph(6,[[2,6],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,2,3,1],[1,2,2,1,1,2],"v-v-v-v-v-3&v-2"),
  (Graph(6,[[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[5,4,3,2,1,1],[8/5,8/5,8/5,8/5,21/10,1],"v-v-v-v-v-v-4"),
  (Graph(6,[[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[3,3,2,2,1,1],[1,2,1,2,1,2],"v-v-v-v-v-v-4-2"),
  (Graph(6,[[3,6],[1,3],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3-1"),
  (Graph(6,[[3,6],[1,3],[3,5],[2,3],[3,4],[1,2],[4,5],[1,6]]),[3,2,2,1,1,3],[2,3,2,2,1,1],"v-v-v-v-v-3-v-1-3"),
  (Graph(6,[[2,6],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v-2&3-5"),
  (Graph(6,[[1,3],[1,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,3,3],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5"),
  (Graph(6,[[1,3],[1,5],[2,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2"),
  (Graph(6,[[1,3],[1,5],[2,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,9/2,3,7/2],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2&3-5"),
  (Graph(6,[[3,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5,3],[1,1,1,1,1,2],"v-v-v-v-v&v-3"),
  (Graph(6,[[2,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[19/5,14/5,21/10,1,1,21/10],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-2"),
  (Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[1,3/2,2,5/2,2,1],"v-v-v-v-v-v-2-4&2-5"),
  (Graph(6,[[2,4],[2,3],[3,4],[1,2],[5,6],[4,5]]),[3,3,2,2,1,1],[1,2,1,2,2,1],"v-v-v-v-v-v&2-4"),
  (Graph(6,[[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4-6"),
  (Graph(6,[[3,6],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3"),
  (Graph(6,[[2,5],[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3&2-5"),
  (Graph(6,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,2,2,1],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4-6&3-5"),
  (Graph(6,[[1,3],[2,5],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,3,2,2,1],[1,2,2,2,3,3/2],"v-v-v-v-v-v-1-3-5-2"),
  (Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,5/2,1,2,4],[2,2,3,2,1,2],"v-v-v-v-v-v-1-3-6&2-5"),
  (Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[7/2,5/2,7/4,1,7/4,9/2],[5/2,5/2,7/2,5/2,3/2,5/2],"v-v-v-v-v-v-1-3-5-2&3-6"),
  (Graph(6,[[1,3],[1,5],[2,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,5/2,7/2,9/2,7/4,1],[3/2,5/2,5/2,5/2,7/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-5"),
  (Graph(6,[[3,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,1,2,2,1,2],"v-v-v-v-v&v-3&2-4"),
  (Graph(6,[[3,6],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[2,1,1,1,2,2],"v-v-v-v-v-v-3-5"),
  (Graph(6,[[2,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,1,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3&2-5"),
  (Graph(6,[[2,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,1,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-5-2"),
  (Graph(6,[[1,3],[1,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5-3"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,2,3,2,1],[2,3,2,2,1,1],"v-v-v-v-v-v-1-3-5"),
  (Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,1,7/4,9/2,7/2,5/2],[7/2,5/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4"),
  (Graph(6,[[1,3],[1,5],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,3,2,1],[2,3,3,3,2,1],"v-v-v-v-v-v-1-3-5-1"),
  (Graph(6,[[2,6],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[2,3,4,5/2,1,5/2],[2,2,2,3,2,1],"v-v-v-v-v-v-1-4-2-6-3"),
  (Graph(6,[[3,6],[3,5],[2,3],[3,4],[1,2],[4,5]]),[3,3,2,1,1,2],[1,2,2,1,2,1],"v-v-v-v-v-3-v"),
  (Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[5,6]]),[5/4,2,1,2,3,3],[5/4,2,3,3,2,1],"v-v-v-v-2-v-v-2"),
  (Graph(6,[[2,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[3,3,1,2,2,4],[2,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-5"),
  (Graph(6,[[3,6],[2,6],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[3,3,2,1,1,2],[1,2,1,1,2,2],"v-v-v-v-v-v-2&3-6-4"),
  (Graph(6,[[3,6],[2,6],[2,4],[2,3],[3,4],[1,2],[4,5],[5,6]]),[1,2,2,1,2,3],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-6"),
  (Graph(6,[[2,5],[2,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3/2,1,1,19/4,7/2,5/2],[5/2,7/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-2-4&2-5&3-6"),
  (Graph(6,[[2,5],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4]]),[11/4,1,7/4,1,19/4,15/4],[5/2,7/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-4-2-5"),
  (Graph(6,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[7/4,11/4,1,15/4,19/4,1],[5/2,5/2,3/2,5/2,5/2,7/2],"v-v-v-v-v-v-2-4-6-3-5"),
  (Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5]]),[1,19/4,15/4,1,11/4,7/4],[7/2,5/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2"),
  (Graph(6,[[3,6],[2,6],[2,3],[3,4],[1,2],[5,6],[4,5]]),[3,3,2,1,1,2],[1,2,2,2,1,1],"v-v-v-v-v-v-2&3-6"),
  (Graph(6,[[1,3],[2,5],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,2,1,1,2,3],[1,2,2,3,3,2],"v-v-v-v-v-v-1-3-5-2-6"),
  (Graph(6,[[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,3,4,5,6],[1,1,1,1,1,1],"v-v-v-v-v-v"),
  (Graph(6,[[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,2,3,3],[2,1,1,2,2,1],"v-v-v-v-v-v&2-4&3-5"),
  (Graph(6,[[1,3],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,1,1,2],[2,1,1,1,2,2],"v-v-v-v-v-v-1-3-6"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,1,3,5,4,3],[1,1,2,1,1,1],"v-v-v-v-v-v-1-3-5&3-6"),
  (Graph(6,[[1,3],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3-6-4"),
  (Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4],[3,6]]),[1,7/4,1,11/4,15/4,19/4],[3/2,5/2,7/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2&3-6"),
  (Graph(6,[[2,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[2,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-4&2-5"),
  (Graph(6,[[1,3],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3&4-6"),
  (Graph(6,[[1,3],[4,6],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,7/4,11/4,3/2,13/4,15/4],[7/2,9/4,9/4,1,1,9/4],"v-v-v-v-v-v-1-3-6-4-1"),
  (Graph(6,[[1,3],[2,5],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[5/2,7/4,15/4,5,1,7/4],[2,1,9/4,9/4,15/4,11/4],"v-v-v-v-v-v-1-3-5-2-4"),
  (Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[3,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-3&2-5"),
  (Graph(6,[[1,3],[2,5],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,5/2,4,3,5/2],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5-2-6-4"),
  (Graph(6,[[3,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[47/10,37/10,27/10,9/5,1,9/5],[9/5,9/5,9/5,1,9/5,27/10],"v-v-v-v-v-v-3"),
  (Graph(6,[[1,5],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[9/4,9/4,9/4,1,1,13/4],[1,2,3,3,2,2],"v-v-v-v-v-1-v-3"),
  (Graph(6,[[2,6],[1,4],[2,4],[2,3],[3,4],[1,2],[5,6],[4,5]]),[11/4,2,15/4,2,1,1],[2,1,2,3,13/5,7/5],"v-v-v-v-v-v-2-4-1"),
  (Graph(6,[[3,6],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3&4-6"),
  (Graph(6,[[3,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[4,4,3,1,2,2],[1,2,5/2,2,7/4,1],"v-v-v-v-v-v-3-5&4-6"),
  (Graph(6,[[1,3],[1,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[2,3,3,2,1,1],[1,1,2,2,1,2],"v-v-v-v-v-v-4-1-3"),
  (Graph(6,[[1,3],[1,4],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,2,3,4,4],[2,7/4,1,5/2,1,2],"v-v-v-v-v-v-4-1-3&2-4"),
  (Graph(6,[[3,6],[2,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[4,4,3,1,2,3],[13/5,7/5,3,2,2,1],"v-v-v-v-v-v-2&4-6-3-5"),
  (Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,3,4,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5&2-6"),
  (Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,4,4,3],[2,2,3,13/5,7/5,1],"v-v-v-v-v-v-1-3-5&2-6-3"),
  (Graph(6,[[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[2,1,1,2,3,3],[1,1,2,2,2,1],"v-v-v-v-v-v-1-4"),
  (Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-1-3-6-2"),
  (Graph(6,[[1,3],[1,4],[4,6],[2,3],[1,2],[4,5],[5,6]]),[2,1,1,3,2,3],[2,2,1,2,1,1],"v-v-v-1-v-v-v-5"),
  (Graph(6,[[1,3],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,4,3,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-4"),
  (Graph(6,[[1,3],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,5,4,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-3&4-6"),
  (Graph(6,[[1,3],[1,5],[2,6],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,3/2,1,19/4,7/2,5/2],[4,5/2,1,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-6"),
  (Graph(6,[[2,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[3,4,3,1,2,3],[2,2,3,2,2,1],"v-v-v-v-v-v-2&3-5&4-6"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,2,1,1],[1,1,2,2,2,1],"v-v-v-v-v-v-1-3"),
  (Graph(6,[[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[1,8/5,27/10,33/10,14/5,8/5],[2,1,1,2,3,3],"v-v-v-v-v-v-1"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4]]),[2,2,1,2,3,3],[1,2,2,3,3,7/4],"v-v-v-v-v-v-1-3&2-4"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[1,9/4,9/4,13/4,9/4,1],[2,1,2,2,3,3],"v-v-v-v-v-v-1-3-5&2-4"),
  (Graph(6,[[1,3],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,3/2,1,5/2,7/2,19/4],[1,5/2,4,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5&2-4&3-6"),
  (Graph(6,[[1,3],[2,5],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,5/2,4,3,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5-2&4-6"),
  (Graph(6,[[1,3],[2,5],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,4,3],[2,3,2,2,2,1],"v-v-v-v-v-v-1-3&2-5&4-6"),
  (Graph(6,[[1,3],[2,5],[2,6],[4,6],[5,6],[1,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,7/4,7/4,5,3,3],[17/4,11/4,1,11/4,9/4,3],"v-v-v-v-v-v-1-3-5-2-6-4-1"),
  (Graph(7,[[1,3],[1,5],[1,7],[1,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&5-7"),
  (Graph(7,[[2,5],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,2,1,0,1,1/4,2],[7/2,7/2,5,5,4,13/4,5/2],"v-v-v-v-v-v&v-2-5-3"),
  (Graph(7,[[2,6],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,3,1,3,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,3,4,4,25/4,5,4],[4,13/4,2,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6&5-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/2,3,3,2,5/2],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5"),
  (Graph(7,[[4,7],[2,5],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1/2,0,4,1/4,11/4,7/4,3/4],[3/2,5/2,1,-5/4,1,1,1/4],"v-v-v-v-v-2-v-4-v&2-4"),
  (Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/2,3/2,5/2,5/2,13/4,17/4,17/4],[1,2,2,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-4-1-3&5-7"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6-3-7-5"),
  (Graph(7,[[1,3],[4,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,11/4,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-4-6-1-3"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,1/4,0,7/4,11/4,7/4,1/2],[-1/4,-1/4,5/2,5/2,1,1,3/2],"v-v-v-v-v-v-3-v&2-5-3"),
  (Graph(7,[[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[9/2,7/2,2,3,2,2,1],[2,2,2,1,0,1,1],"v-v-v-v-v-v-3-v-5"),
  (Graph(10,[[9,10],[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8&4-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,2],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&4-7-5"),
  (Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,3,2,3,17/4,5/2,1/2],[2,3/2,3,3,2,9/2,3/2],"v-v-v-v-v-v-v-1-3-5-2-7-3-6-4"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[1,5],[2,7],[1,6],[2,4],[1,7]]),[4,3,1,4,7,5,4],[19/4,3,3/2,2,3/2,3,3],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[2,4],[1,2],[5,7],[2,3],[3,4]]),[13/4,5/2,1,7/4,3/4,-1/4,-1/4],[9/4,3,3,9/4,4,4,5],"v-v-v-v-2-v-v-v-6"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[9/4,9/4,3/4,-1/4,-1/4,1,1],[2,3,2,3,17/4,17/4,3],"v-v-v-v-v-v-v-4-6-2"),
  (Graph(8,[[3,6],[5,8],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-3&v-2&v-5"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5"),
  (Graph(7,[[2,5],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[3,3,2,1,3,5,4],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-2-5&4-1-6"),
  (Graph(7,[[1,3],[2,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[2,1,2,3,7/2,9/2,9/2],[11/4,3/4,7/4,7/4,3/4,11/4,7/4],"v-v-v-v-v-v-v-5-2-4-1-3"),
  (Graph(9,[[2,8],[4,7],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,4,4,5,5,1,3],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-4&v-2&v-3"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6],[8,9]]),[1,1,2,2,3,3,3,2,1],[1,2,2,1,1,2,3,3,3],"v-v-v-v-v-v-v-v-v-2&3-6"),
  (Graph(7,[[2,5],[2,6],[1,7],[5,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,1,3,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2-5"),
  (Graph(7,[[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-2"),
  (Graph(7,[[3,6],[2,3],[1,2],[3,4],[3,7],[4,5]]),[1,1,2,3,3,2,2],[1,2,2,2,1,1,3],"v-v-v-v-v&v-3-v"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[11/4,9/2,15/4,9/2,11/4,7/4,7/4],[0,0,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3-5-7&2-4"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,4,2,13/4,2],[1,1,1,0,3/4,2,2],"v-v-v-v-v-v-v&3-6-2-4"),
  (Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[5,4,3,2,1,1,2,3,4],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8"),
  (Graph(8,[[2,6],[3,8],[2,3],[1,2],[3,7],[3,4],[4,5]]),[1,1,2,3,3,1,2,2],[1,2,2,2,1,3,1,3],"v-v-v-v-v&v-2&v-3-v"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,0,21/4,15/4,5/2,3/2],[1,5/2,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&6-2-7"),
  (Graph(9,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,5,5,1],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-5"),
  (Graph(7,[[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-4"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,15/4,5,4,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4&2-5"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[2,2,3,3,4,5,3],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&5-3-7"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,3/2,5/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-5-2-4&3-5"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6],[7,10]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7&3-6"),
  (Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&5-10-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2&3-6"),
  (Graph(10,[[3,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-3&4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2-6-3&4-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[21/4,3/4,0,3/4,3/2,5/2,15/4],[1,-1/2,5/2,5/4,1/2,1,1],"v-v-v-v-v-v-v-1-3-7-2-5"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[2,3],[3,4]]),[17/4,17/4,9/4,3/4,2,3,9/4],[9/4,1,15/4,1,7/4,3/2,11/4],"v-v-v-v-v-v-v-2-4-6-2&4-7-5"),
  (Graph(7,[[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,3,2],[1,2,2,2,2,1,1],"v-v-v-v-v&v-v-3"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[3,7],[2,3],[3,4],[3,5],[3,6]]),[1,1,2,1,5/2,3,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&6-3-7"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2&4-6"),
  (Graph(8,[[5,6],[3,8],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-2&v-3"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[7/4,11/4,1/2,13/4,13/4,0,3/4],[1,1,0,0,9/4,9/4,5/4],"v-v-v-v-v-v-v-1-3-6-2-4"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,3,2,3/4,3/4,3/2,5/2],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[3/4,3/4,7/4,7/4,11/4,11/4,11/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,2],[1,1,9/4,1,0,1,9/4],"v-v-v-v-v-v-3-v&2-5"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,1,1,1,-1/2,1/2],"v-v-v-v-v-v-v&2-4&3-6-2-5"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&3-7-4&5-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v"),
  (Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4-6"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[1,3/2,2,5/2,3,5/2,1],[2,3,2,3,2,1,1],"v-v-v-v-v-v-v-1-3-5&2-4"),
  (Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3&2-5"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,3,2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3&5-2-6"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,2,3,4,4,2,1],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-3-1-5-3"),
  (Graph(10,[[9,10],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[9/4,9/4,1,0,0,1,1],[11/4,15/4,19/4,15/4,11/4,11/4,15/4],"v-v-v-v-v-v-v-2&3-7-4-6"),
  (Graph(10,[[5,10],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-v-3&v-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6-2&3-5"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[1/2,23/4,0,3/4,7/4,11/4,4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3"),
  (Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7"),
  (Graph(7,[[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,0,21/4,15/4,5/2,1/4,3/2],[3/2,5/2,1,1,1,-1/2,5/4],"v-v-v-v-v-v-v-2-4-6-2&3-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&3-6"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,6]]),[2,3,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6&5-7"),
  (Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,1,2,2,2,3,3,3],[1,2,3,3,2,1,1,2,3],"v-v-v-v-v-v-v-v-v&2-5-8"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[3,3,4,4,3,3/2,3/2],[0,1,1,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-2-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&3-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7-5"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,5],[3,4]]),[3/4,1/4,1/4,11/2,15/4,5/2,5/4],[7/4,11/4,-1/4,1,1,1,-1/2],"v-v-v-v-v-v&v-3-5-2-4"),
  (Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[4,9],[5,8],[1,2],[2,3],[3,4]]),[1,1,1,2,2,3,3,2,3],[1,2,3,3,2,2,1,1,3],"v-v-v-v-v-v-v-v-5-2&v-4"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5],[3,6]]),[21/4,17/4,3,9/4,2,3/4,17/4],[1,1,3/2,11/4,7/4,1,9/4],"v-v-v-v-v-v-2-v&2-4-6-3-5"),
  (Graph(8,[[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3"),
  (Graph(10,[[9,10],[7,8],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-3"),
  (Graph(8,[[2,5],[4,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,1,2,2,2,3,3],[1,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-4&2-5"),
  (Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-4"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[1,6],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[2,15/4,15/4,11/4,7/4,3/4,13/4],[3,7/2,1,3/2,7/4,1,5/2],"v-v-v-v-v-v-1-v-3-1-4-6-3"),
  (Graph(7,[[1,3],[4,7],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,11/4,4,4,3,3],[1,2,2,1,0,0,1],"v-v-v-v-v-v-v-4&3-1-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,11/4,2,3],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-1-3-7&2-5"),
  (Graph(9,[[2,5],[7,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1],[1,1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-v&2-5&4-7"),
  (Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[7/4,7/4,3,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-1-3-7-4-6"),
  (Graph(7,[[3,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1],[1,2,2,2,1,1,2],"v-v-v-v-v-v-3&v-2"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5]]),[15/4,21/4,0,1/2,0,3/2,5/2],[1,1,-1/2,1,5/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5-7"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[13/4,11/2,17/4,17/4,21/4,6,13/4],[11/4,15/4,11/4,7/4,11/4,7/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-4-1"),
  (Graph(9,[[5,6],[3,8],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-5"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,11/4,1/2,0,3/4,7/4,11/4],[1,-1/4,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-1-3-7-4-1"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v&4-2-5"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,0,1/2,0,21/4,15/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6&5-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[2,2,1,1,-1/2,-1/2,1],[3,4,5,4,4,3,3],"v-v-v-v-v-v-v-2-4-7&3-5"),
  (Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,19/4,13/4,7/4,1,1/4],[3/2,5/2,1,1,5/4,1/2,-1/4],"v-v-v-v-v-v-v-2-4-7-3&2-5"),
  (Graph(9,[[2,8],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,5,2],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-2&v-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[4,5,3,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2&3-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,5,3,1,11/4,2,3],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5"),
  (Graph(8,[[4,8],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,3,2,1,1,5,2],[1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,15/4,15/4,11/4,7/4],[11/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v&2-5-3-6"),
  (Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-1-3-6-4"),
  (Graph(7,[[2,6],[5,6],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,1,1,-1/4,3/4,-1/4],"v-v-v-v-v-v-2-4&v-5-3"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5]]),[9/4,9/4,1,-1/4,-1/4,1/4,1],[2,3,17/4,17/4,13/4,9/4,3],"v-v-v-v-v-v-v-3-5-7-2"),
  (Graph(8,[[7,8],[3,8],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-v-3"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[21/4,1/2,0,3/4,7/4,11/4,15/4],[1,-1/2,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7&3-6"),
  (Graph(7,[[1,3],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[5,4,3,1,2,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6-2-7-4"),
  (Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-4-1-5"),
  (Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7"),
  (Graph(7,[[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,2,2,1,1],[1,1,2,2,3,3,2],"v-v-v-v-v-v-v-4-1"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[4,6],[2,3],[1,2],[3,4],[4,5]]),[3/4,7/4,17/4,7/4,13/4,9/4,3/4],[2,2,3/4,-1/2,3/4,3/4,1],"v-v-v-v-v-2-v-4-2-v"),
  (Graph(8,[[5,6],[6,7],[4,5],[5,8],[1,2],[2,7],[2,3],[3,4]]),[5,4,4,3,2,2,3,1],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v-v-2&v-5"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4-6&5-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-4&5-7"),
  (Graph(9,[[2,5],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,1,1,2],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-6&2-5"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[3,4,4,3,2,2,1,1,5,5],[2,2,1,1,1,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-2&v-3"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-5"),
  (Graph(7,[[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[13/4,9/4,1,1,-1/2,-1/2,9/4],[3,3,4,3,3,2,2],"v-v-v-v-v-v&v-2-4&3-5"),
  (Graph(7,[[3,5],[6,7],[2,3],[3,6],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[2,4],[1,7]]),[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6&5-7"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,3,2,2,1,1,4],[2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v&v-4&3-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,2,1/2,1/2,5,7/2],[1,1/2,2,5/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-2&6-3-7"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[7,9],[2,3],[3,4]]),[1,1,2,2,3,3,4,4,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-5&v-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[1/2,21/4,0,3/4,7/4,11/4,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5&3-6"),
  (Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[4,19/4,3,7/4,7/4,11/4,17/4],[1,7/4,2,2,1,0,0],"v-v-v-v-v-v-v-1-3-5&2-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[11/4,3/4,4,23/4,0,3/4,7/4],[1,-1/2,1,1,5/2,5/4,5/4],"v-v-v-v-v-v-v-1-3-5-2-4"),
  (Graph(7,[[1,5],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,4,2,2,2,1,13/4],[0,3/2,2,1,0,1,3/4],"v-v-v-v-v-v-3-v-1-5"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[2,3,4,5,13/4,1,3],[1,1,1,1,0,1,2],"v-v-v-v-v-v-v-2&4-7-3-5"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3&2-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,5/2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&6-3-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-3-7"),
  (Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,3,2,5/2],[5/4,9/4,3,2,1,1,3],"v-v-v-v-v-v-4&v-3"),
  (Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,4,5/2,5/2,5/4,0,9/4],[9/4,1,3/2,5/2,2,5/4,15/4],"v-v-v-v-v-v-v-2-4-7&2-6-3"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[-1/2,1/2,7/4,7/2,7/2,5/2,3/2],[7/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v-2-5-3-6"),
  (Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9&5-8"),
  (Graph(9,[[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4],[1,2,2,1,1,1,1,2,2],"v-v-v-v-v-v-v-v-v-6"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3"),
  (Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[11/4,11/4,4,5,4,4,11/4],[0,1,2,1,0,1,2],"v-v-v-v-v-v-3-v&4-6"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7-5"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,3],[3,4]]),[-1,0,7/4,1/2,11/4,4,3/4],[5/2,5/2,3/4,-1,1,1,1/4],"v-v-v-v-v-v-2-4-v&2-5&4-6"),
  (Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v-v-3-6&v-2"),
  (Graph(10,[[9,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&4-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,4,3,3],[9/4,9/4,7/4,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-2&3-5-7-4"),
  (Graph(7,[[2,6],[5,6],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[11/4,4,4,5,3,3,2],[2,2,1,1,-1/2,1,-1/2],"v-v-v-v-v-v-2-4&v-5"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[5,4,7/2,3,2,2,15/4],[1,1,0,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-4-7"),
  (Graph(9,[[2,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,1,2],[1,2,2,3,3,2,1,3,1],"v-v-v-v-v-v-v&v-2&v-3-6"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7-5"),
  (Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,11/4,4,11/4,0,3/4,3/2],[-1/4,-1/4,1,1,5/2,3/2,3/4],"v-v-v-v-v-v-v-1-3-5-1-4-7"),
  (Graph(7,[[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,5/2,1,1,1,5/2,13/4],[2,3,3,2,1,1,7/4],"v-v-v-v-v-v-v-2&4-1-6"),
  (Graph(8,[[2,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,2,2,1,1,4],[1,1,1,1,2,2,1,2],"v-v-v-v-v-v-v&v-2"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,4,23/4,0,11/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-2-v&4-6-3-5"),
  (Graph(9,[[7,8],[5,6],[6,9],[6,7],[4,9],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,1,1,2,3,3,3,2,2],[1,2,3,3,3,2,1,1,2],"v-v-v-v-v-v-v-v-v-2&4-9-6"),
  (Graph(10,[[9,10],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-v&4-9"),
  (Graph(7,[[1,3],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/4,7/4,0,3/4,5/2,4,11/4],[5/4,5/4,5/2,-1/2,-1/2,1,1],"v-v-v-v-v-v-v-4-6-3-1"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,21/4,1/4,3/2,5/2,15/4],[3/2,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6&3-7-4"),
  (Graph(7,[[2,5],[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[2,3,4,4,3,2,4],[5/2,5/2,5/2,3/2,3/2,3/2,1/2],"v-v-v-v-v-2-v&v-4-2"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,7/4,11/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[1,7/4,11/4,1/2,3/4,5,15/4],[7/4,1,1,11/4,-1/2,1,1],"v-v-v-v-v-v-v-3-5-7-4-6"),
  (Graph(7,[[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[9/4,13/4,13/4,9/4,3/2,3/4,3/4],[5/4,5/4,9/4,9/4,3,9/4,5/4],"v-v-v-v-v-v-v-1-4"),
  (Graph(7,[[2,5],[2,6],[2,4],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1/2,0,0,15/4,21/4,5/2,3/2],[5/4,5/2,-1/2,1,1,1,1],"v-v-v-v-v-2-v&v-2-4&3-5"),
  (Graph(9,[[7,8],[3,9],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,3,2],[1,2,2,2,1,3,3,3,1],"v-v-v-v-v&v-v-v&v-3-7"),
  (Graph(7,[[1,5],[2,5],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[4,5,5,4,3,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-v-v-v-5-1-4&2-5"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,5,3,2,1,3,3],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6-4&3-7"),
  (Graph(7,[[1,3],[2,5],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[15/4,11/4,7/4,3/4,7/4,11/4,11/4],[11/2,21/4,6,17/4,17/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-6&4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[11/4,7/4,1/2,-1/4,1/4,7/4,1],[2,2,2,11/4,15/4,15/4,3],"v-v-v-v-v-v-v-4&2-6"),
  (Graph(8,[[5,8],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v&v-2&v-5"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2]]),[1,2,3,5/2,1,1,5/2],[1,2,2,1,3,2,3],"v-v-v&v-2-v&v-2-v"),
  (Graph(7,[[1,3],[1,7],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[0,9/4,15/4,5/2,3/2,0,1/2],[-1/2,-1/2,1,1,5/4,5/2,1],"v-v-v-v-v-v-v-1-3-6-1-4"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-3-5&4-7"),
  (Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[17/4,21/4,17/4,11/4,11/4,7/4,7/4],[1/4,1/4,5/4,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&4-6"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,3,4,5,4,4,2],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-4"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,17/4,3,7/4,7/4,3,19/4],[1,0,1,1,2,2,7/4],"v-v-v-v-v-v-v-1-3-6-4&2-7"),
  (Graph(9,[[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-4"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2&3-6-4"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6"),
  (Graph(7,[[1,3],[4,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[15/4,21/4,1/2,0,7/4,3/2,3/4],[1,1,-3/4,5/2,5/4,1/4,1],"v-v-v-v-v-v-v-4-1-3-6&2-4"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[11/4,11/4,15/4,19/4,19/4,15/4,11/4],[0,1,1,0,1,2,2],"v-v-v-v-v-v-v&2-6-3-5"),
  (Graph(10,[[9,10],[1,5],[7,8],[5,6],[1,4],[6,7],[1,2],[2,3],[3,4],[8,9],[7,10]]),[4,5,5,4,3,3,2,1,1,2],[1,1,2,2,1,2,2,2,1,1],"v-v-v-v-1-v-v-v-v-v-v-8"),
  (Graph(7,[[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,13/4,13/4,2],[5/4,9/4,3,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-1"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[2,3,19/4,4,17/4,3,2],[9/4,9/4,7/4,1,0,1,1],"v-v-v-v-v-v-v&2-6&3-5"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,1,19/4,3,11/4,1,3/2],[7/4,3/4,9/4,2,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-6&4-7"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[5,5,4,3,3,2,1,1,2],[2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-4"),
  (Graph(8,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,1,1,2,3,3,2,2],[1,2,3,3,3,2,2,1],"v-v-v-v-v-v-v-v&2-7-4"),
  (Graph(7,[[1,5],[1,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,2,5/2,4,4,3,1],[1,1,5/2,5/2,1,0,1],"v-v-v-v-v-v-v-3-5-1-6"),
  (Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[2,1,2,3,15/4,15/4,19/4],[11/4,5/4,7/4,5/4,2,3,3],"v-v-v-v-v-v-v-5&2-4-1-3"),
  (Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,3,4,5,5,4],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-5"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4],[3,6]]),[1,2,7/2,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&4-7-5-3-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[5,7],[1,5]]),[11/4,1/2,23/4,4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-4&2-5-3"),
  (Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5]]),[1/2,0,15/4,9/4,1/4,5/4,5/2],[3/2,5/2,1,-1/2,-1/2,3/4,1],"v-v-v-v-v-v-v-2-5-3-7-5"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,0,4,11/4,3/2],[5/4,9/4,1,-1/4,1,9/4,1],"v-v-v-v-v-v-2-v-4-2-5"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2"),
  (Graph(7,[[1,7],[4,6],[5,6],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,17/4,19/4,3,7/4,7/4,4],[1,0,7/4,2,1,2,1],"v-v-v-v-v-v-4-1-v-3"),
  (Graph(10,[[9,10],[7,8],[5,6],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v-1"),
  (Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,11/4],[-1/4,-1/4,1,1,1,2,2],"v-v-v-v-v-v-v&2-5&3-6-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,11/2,4,1/4,3,2],[7/4,11/4,1,1,-3/4,1,1],"v-v-v-v-v-v-v&3-5-2-4"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4]]),[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-4"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3&4-7"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5&3-6"),
  (Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,3],[1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v&v-4"),
  (Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,3,11/4,4,7/4,3/4,3],[4,4,5,21/4,23/4,4,3],"v-v-v-v-v-v-v-1-3-5-1-6&2-7-4"),
  (Graph(8,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3"),
  (Graph(7,[[2,5],[1,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,9/4,2,15/4,15/4,0,9/4],[2,5/2,15/4,11/4,1,1,3/2],"v-v-v-v-v-v-v-2-5-3-6-1"),
  (Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,13/4,5,4,3,3,2],[2,2,1,1,1,0,3/4],"v-v-v-v-v-v-v-2-4&3-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,4,4,3,2,2],[9/4,9/4,5/4,1/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5-1-6"),
  (Graph(7,[[2,5],[1,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,2,1,5/2,2,3],[5/2,1,0,1,5/2,1,1],"v-v-v-v-v-v-v-2-5-1"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-2-v&2-4-6"),
  (Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,1,3],[1,2,2,2,3,3,3,1],"v-v-v-v-v-v-v-2&v-4&3-6"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7-4"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,0,3/2,5/2],[5/4,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6&5-7"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4]]),[5/4,5/4,9/4,3/4,7/2,19/4,3/4],[1/2,3/2,3/4,-3/4,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[19/4,13/4,9/4,2,3,3/4,11/4],[1,11/4,11/4,7/4,3/2,1,9/2],"v-v-v-v-v-v-v-1-3-5-1-6-3&4-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-v-4"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2&4-6"),
  (Graph(7,[[2,5],[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,0,21/4,15/4,5/2,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,11/4,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4&3-6"),
  (Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&v-3"),
  (Graph(10,[[5,10],[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-3&v-4&v-5"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,3,7/2,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2&4-6"),
  (Graph(9,[[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,3,3,2,1,3,2],[1,2,2,2,3,3,3,1,1],"v-v-v-v-v-v-v&v-v-3-6"),
  (Graph(7,[[4,7],[2,5],[2,6],[2,3],[1,2],[3,4],[4,5]]),[11/4,7/4,1/2,-1/2,1/2,7/4,-1/2],[3,3,4,3,3,2,2],"v-v-v-v-v-2-v&v-4"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[13/4,9/2,1,0,1/2,9/4,5/4],[1,1,-1/4,3/4,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3/4,3/4,3/2,5/2,2,3,3],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5-3"),
  (Graph(7,[[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[5,7],[1,5],[2,4]]),[23/4,4,11/4,3/4,0,7/4,3/4],[1,1,1,-1/2,5/2,5/4,5/4],"v-v-v-v-v-v-v-5-1-4-2-5"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[2,2,7/2,5,17/4,5,7/2],[1,2,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3-5-7&4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&6-3-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[3,2,3,1,13/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&5-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5/2,7/2,5,1/2,5/4,5/4,1/2],[1,1,1,-1/4,3/4,9/4,3/2],"v-v-v-v-v-v-v-4-1-6-2&3-6-4"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,-1/4,3/4,-1/4],[3,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-5&2-4"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[1,6],[2,4],[1,7]]),[3,5,4,7/2,3,2,2],[2,1,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4-2"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,11/4,19/4,4,17/4,11/4,11/4],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5&4-7"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[3/2,5/2,0,1/2,0,15/4,21/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&6-3-5-7"),
  (Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,3,2,5/2,3/2,1,3/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-3-v&3-5"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&2-7"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,13/4,5,3,2,3,4],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5&3-7"),
  (Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[1/2,0,3/2,5/2,0,9/4,15/4],[5/4,5/2,1,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-2-4-7-5-2"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7&3-6"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&3-7-5"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4]]),[21/4,15/4,1/2,11/4,7/4,3/4,0],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3"),
  (Graph(7,[[5,6],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4]]),[3/2,3/2,3/2,5/2,3,3,1/2],[1,2,3,3,7/4,3/4,3],"v-v-v-v-v-v&v-3&2-4"),
  (Graph(10,[[9,10],[2,5],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3&2-5"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[17/4,17/4,21/4,11/2,6,13/4,13/4],[11/4,7/4,11/4,15/4,7/4,1,11/4],"v-v-v-v-v-v-v-1-3-5-2-7-4"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5]]),[7/4,7/4,3,3,17/4,17/4,3],[1,2,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-1-3-5-7"),
  (Graph(10,[[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v&v-3&v-6"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,13/4,5,4,3,7/2,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6-3&5-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,3,3,2,2,7/2,5],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7"),
  (Graph(7,[[1,3],[1,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[4,11/4,0,5/2,0,3/2,1/2],[1,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-1-3-5"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[21/4,17/4,17/4,3,2,2,3],[1,1,9/4,9/4,9/4,5/4,1],"v-v-v-v-v-v-v-2-4-6&4-7"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-5"),
  (Graph(7,[[1,3],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5]]),[7/4,7/4,3,3,4,17/4,13/4],[2,1,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-5-3-1"),
  (Graph(9,[[2,5],[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[4,3,2,2,3,4,5,1,1],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v&v-3&v-4&2-5"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,1/2,4,23/4,0,3/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-5&2-6-3&4-6"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,0,1/2,0,4,23/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-5-2&3-6&5-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[1,2,3/4,11/2,4,3,1/4],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-2&4-7-3-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[3,19/4,4,17/4,3,7/4,7/4],[2,7/4,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6&2-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3/4,3/4,3/2,5/2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2&3-5"),
  (Graph(7,[[3,6],[3,5],[2,3],[1,2],[3,7],[3,4],[4,5]]),[3,3,2,3/2,5/2,1,1],[1,2,2,3,3,1,2],"v-v-v-v-v-3-v&v-3"),
  (Graph(7,[[4,7],[1,7],[4,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[3/2,3/4,3/4,2,3,3,5/2],[3,9/4,5/4,2,2,1,3],"v-v-v-v-v-v-4-v-1-4"),
  (Graph(8,[[6,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,5,4,3,2,2,3,1],[2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-4&v-6"),
  (Graph(7,[[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[3,4,5,3,1,3,2],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-1-4-2-6-3"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v-4"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4-6&2-5"),
  (Graph(10,[[9,10],[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8&4-7"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&5-1-4-6"),
  (Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v&v-2&4-7"),
  (Graph(8,[[1,5],[7,8],[5,6],[1,4],[6,7],[5,8],[1,2],[2,3],[3,4]]),[2,1,1,2,3,3,4,4],[2,2,1,1,2,1,1,2],"v-v-v-v-1-v-v-v-v-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2&3-7"),
  (Graph(7,[[5,6],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4],[3,6]]),[-1/2,-1/2,1,5/2,5/2,1,5/2],[9/4,13/4,4,4,3,3,2],"v-v-v-v-v-v-3-5-v"),
  (Graph(9,[[2,8],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,4,3,3,2,2,1,5,1],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v&v-2&v-5&3-6"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4&5-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3,2,5/2,3/2,1,1,3],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-4"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,3,1,3,4,4],[1,1,2,1,0,1,0],"v-v-v-v-v-v-v&3-6-2-5"),
  (Graph(7,[[3,6],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,15/4,9/2,9/2,3,2],[2,3/2,3/4,3/2,0,0,1],"v-v-v-v-v-v-2-v&2-4&3-6"),
  (Graph(7,[[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3"),
  (Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6&2-5&3-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[19/4,15/4,19/4,11/2,19/4,25/4,25/4],[1/2,3/2,3/2,9/4,3,3,3/2],"v-v-v-v-v-v-v-1-3-5-2&3-7-4"),
  (Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6&2-5-3"),
  (Graph(7,[[4,7],[2,6],[1,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,2,15/4,15/4,2],[1,2,1,0,0,2,1],"v-v-v-v-v-v-2-v-4-1"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&2-5-3"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[5/4,2,3/4,3/2,5/2,13/4,13/4],[1,7/4,9/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-2-4"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,2,2,15/4],[1,0,1,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3&2-5&4-7"),
  (Graph(8,[[2,5],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,2,1,1,4],[2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v&v-3&2-5"),
  (Graph(7,[[1,3],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,1,2,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,7/4,5/2,13/4,13/4,9/4],[5/4,9/4,9/4,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-3"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,4,4,2,1],[1,1,9/4,9/4,1,0,1],"v-v-v-v-v-v-v-3-5-2"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3,4,5,15/4,11/4,11/4,4],[2,2,1,0,0,1,1],"v-v-v-v-v-v-v-2&3-7&4-6"),
  (Graph(10,[[2,8],[5,10],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-2&v-3&v-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[2,3,19/4,4,3,3,19/4],[9/4,9/4,7/4,1,1,0,0],"v-v-v-v-v-v-v-3&2-5"),
  (Graph(8,[[2,6],[4,8],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,3],[1,2,2,2,3,3,1,1],"v-v-v-v-v&v-2&v-3&v-4"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5"),
  (Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5&4-7"),
  (Graph(7,[[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3,3,17/4,17/4,13/4,2,2],[1,2,2,1,0,1,2],"v-v-v-v-v-v-v-2-4-1-6-2"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-4&v-5"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[5,5,4,4,3,3,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5&3-6"),
  (Graph(7,[[2,5],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3/2,5/2,3,3,1],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-4&2-5"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3,3,2,5/2,3/2,3/4,3/4],[1,2,2,3,3,9/4,5/4],"v-v-v-v-v-v-v&2-4&3-5"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,0,15/4,21/4,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-2-v-4-2-5&4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,3/4,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4"),
  (Graph(7,[[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,5],[3,4]]),[3,3,2,5/2,5/4,1/4,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5&2-4"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,3,3,5/2,5/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5&6-3-7"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,5,1/4,7/2,5/2,3/2],[3/2,5/2,1,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&3-5&4-7"),
  (Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[3,7],[2,4],[1,7]]),[3,11/4,1,19/4,1,7/4,3/2],[2,3,17/4,9/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7-5"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-5-7"),
  (Graph(9,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&5-2-7"),
  (Graph(7,[[2,5],[2,6],[4,7],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,5,4,4,3,9/4],[2,2,1,0,1,3/4,0],"v-v-v-v-v-2-v-4-v-2"),
  (Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,3,2,5/2,3/2,1/2,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5"),
  (Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,9/4,9/4,9/4,1/4,5/4],[5/2,1,9/2,5/2,3/2,1,7/4],"v-v-v-v-v-v-v-4-1-3-6-2-4"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5-7"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,3,5,4,3,3],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3&4-7"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[5,4,4,3,2,2,3],[1,0,1,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5-7-4"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,13/4,13/4,9/4],[5/4,9/4,3,3,9/4,5/4,2],"v-v-v-v-v-v-v-3&4-7"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,3,3,2,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-4"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1,2,2,3,3,2,1],[2,3,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6&2-4"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5&4-6"),
  (Graph(7,[[4,7],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[5,4,4,3,7/4,7/4,3],[1,1,2,2,1,2,1],"v-v-v-v-v-v-4-v-2-4"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,7/4,7/4],[0,1,1,1,2,2,3/4],"v-v-v-v-v-v-v-1-3-5-2&5-7"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[5,7],[1,5],[1,7]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[0,23/4,4,1/2,11/4,7/4,3/4],[5/2,1,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2"),
  (Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4]]),[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6&2-4"),
  (Graph(7,[[2,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,11/4,1,11/4,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-5"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2"),
  (Graph(10,[[9,10],[5,10],[7,8],[5,6],[1,4],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,5/2,3/2,3/4,3/4],[1,1,2,3,3,9/4,1],"v-v-v-v-v-v-v-1-3"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-5&3-6"),
  (Graph(7,[[1,3],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[9/4,3,9/4,1,-1/4,1,1],[2,5/4,0,5/2,0,3/2,1/2],"v-v-v-v-v-v-3-v-5-3-1"),
  (Graph(9,[[4,7],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,3,3,2,1,1,2,5,4],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v-v-4&v-v-3"),
  (Graph(7,[[4,7],[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v&v-2&v-4"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,23/4,4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-3-6&4-7"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4]]),[3,3,2,2,3,17/4,17/4],[0,1,1,2,2,2,1],"v-v-v-v-v-v-v-2-5-3&5-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[1,5],[1,6],[1,7]]),[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6-1"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,2,1,1],[2,2,1,1,2,2,1],"v-v-v-v-v-v-v&2-5"),
  (Graph(9,[[2,6],[3,8],[4,9],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,2,3],[1,2,2,2,3,3,1,3,1],"v-v-v-v-v&v-2&v-3-v&v-4"),
  (Graph(8,[[5,6],[3,8],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&3-v-5"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[15/4,1/2,11/4,7/4,5/2,5/2,15/4],[1,1,3/2,7/4,5/2,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-4"),
  (Graph(7,[[1,3],[2,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,5],[3,4]]),[2,3,9/4,3/4,17/4,17/4,21/4],[7/4,3/2,11/4,1,1,2,2],"v-v-v-v-v-v-v-5-2-4-1-3-5"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/2,5/2,1/4,-1/2,2,1/4,7/4],[1/2,0,0,11/4,11/4,7/4,3/2],"v-v-v-v-v-v-3-5-2-v"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5&4-6"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4]]),[1,2,3/2,5/2,3,5/2,1],[1,2,3,3,2,1,2],"v-v-v-v-2-v&v-2-v"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3/4,7/4,1/2,11/2,15/4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-6&2-7-3&4-7"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1,5],[2,2,2,2,1,1,1,1,2],"v-v-v-v-v-v-v-v&v-4&2-7"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,0,1/2,0,15/4,9/4],[1,1,5/2,3/4,-1/2,1,5/2],"v-v-v-v-v-v-v-3-1-5-3-6"),
  (Graph(7,[[4,7],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,3/4,3/4,7/4,3,3,3],[3,5/2,3/2,3/2,1,2,3],"v-v-v-v-v-v-v-1-4-7"),
  (Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&3-6"),
  (Graph(9,[[5,9],[7,8],[3,8],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,1,2,3,4,5,3,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-v-3&v-5"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,5/2,3/4],[1/4,5/4,5/2,1,1,3/4,-3/4],"v-v-v-v-v-v-v-3-5-7-4&3-6"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-6"),
  (Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,2,2,3,3,4,5],[2,2,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,7/4,1],[9/4,3,9/4,3,17/4,19/4,4],"v-v-v-v-v-v-v-4-2-6"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v&3-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,4,9/4,0,5/4,5/2,5/2],[1,3,15/4,5/4,2,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-1-4-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[19/4,13/4,9/4,11/4,3/4,2,3],[1,11/4,11/4,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&5-7-3-6"),
  (Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,2],[1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-5&v-3"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[15/4,21/4,1/2,7/4,3/4,0,11/4],[1,1,-1/2,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-6-2&3-7&4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&5-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,2,2],[0,1,1,1,2,1,0],"v-v-v-v-v-v-v-1-3-5-2"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[2,3,0,1/2,0,4,11/2],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-3-5-7&3-6"),
  (Graph(7,[[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,3,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&2-6-4"),
  (Graph(8,[[4,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,4,2,3],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-3&v-4"),
  (Graph(7,[[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[3,4,5,3,2,2,4],[1,1,1,2,1,0,0],"v-v-v-v-v-v-v-1-4-2-7-3"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[5,7],[1,7]]),[15/4,9/2,15/4,3,1,2,2],[11/4,2,1,7/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-7-4-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[3,2,3/4,-1/4,-1/4,3/4,2],[7/2,7/2,5,5,4,4,5/2],"v-v-v-v-v-v-2-v&3-6-4"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3/4,23/4,-1/4,4,11/4,7/4,3/4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[0,3/2,0,13/4,5/2,5/2,1/2],[-1/4,1,9/4,7/4,-1/4,1,1],"v-v-v-v-v-1-v-3-v-1-3"),
  (Graph(7,[[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,3,1,1],[1,2,3,2,1,2,3],"v-v-v-v-v&v-2-v&2-4"),
  (Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-7"),
  (Graph(7,[[4,6],[2,6],[2,3],[6,7],[3,6],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6-3"),
  (Graph(7,[[2,6],[1,7],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,2,3,1,3,5],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-1-4-7&2-6"),
  (Graph(7,[[2,5],[2,6],[2,7],[4,6],[2,3],[1,2],[3,4],[4,5]]),[13/4,13/4,19/4,19/4,4,13/4,9/4],[5/2,3/2,3/2,0,3/4,0,3/2],"v-v-v-v-v-2-v-4&v-2"),
  (Graph(7,[[4,6],[3,5],[2,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,2],[5,7],[2,7],[2,4]]),[2,3,5,4,7/2,3,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,7/2,4,5,7/2,2,2],[1,0,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-7-2-4"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3-6"),
  (Graph(7,[[2,6],[2,3],[3,7],[1,2],[3,4],[4,5]]),[3,3,2,1,1,4,2],[1,2,2,2,1,2,1],"v-v-v-v-v&v-2&v-3"),
  (Graph(7,[[2,6],[2,4],[2,3],[1,2],[3,7],[3,4],[4,5]]),[1,2,3,5/2,3/2,1,3],[1,2,2,3,3,2,1],"v-v-v-v-v&v-2-4&v-3"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7&4-6"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[7/4,11/4,4,17/4,13/4,9/4,3],[9/4,9/4,1,-1/4,-1/4,1/4,1],"v-v-v-v-v-v-v-3-5-7"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[1,2,2,3,4,4,5,5,3,1],[1,1,2,2,2,1,1,2,1,2],"v-v-v-v-v-v-v-v-5&v-2&v-3"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,3,17/4,19/4,4],[9/4,9/4,1,-1/4,-1/4,7/4,1],"v-v-v-v-v-v-v-3-5&2-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[15/4,11/4,2,1/2,3/2,3/2,11/4],[5,5,6,5,5,4,4],"v-v-v-v-v-v-v-1-3-5-2-7&4-6"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,3,2,3/4,3/4,3/2,5/2],[2,1,2,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6&3-7"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,2,3,15/4,15/4,2,3/4],[3,2,3/2,3,4,4,3/2],"v-v-v-v-v-v-v-1-3-7-2&4-6"),
  (Graph(7,[[1,7],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[11/4,15/4,21/4,0,3/4,3/2,3/4],[1,1,1,5/2,3/2,3/4,-1/4],"v-v-v-v-v-v-v-1-4-7-3"),
  (Graph(7,[[2,5],[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,3/4,3/4,3/4,-3/4,1/4],"v-v-v-v-v-v-v&2-4-6-2-5&3-6"),
  (Graph(7,[[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[13/4,5/2,7/4,1,0,3/4,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5"),
  (Graph(8,[[7,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,2,3,3,1,1,1],[1,1,2,2,3,1,2,3],"v-v-v-v-v&v-v-v&3-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&3-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6&3-7"),
  (Graph(7,[[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/2,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,3,3,2,1],[2,1,1,1,2,3,3],"v-v-v-v-v-v-v-1-3-5"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3,5,4,3,4,7/4,7/4],[2,1,1,1,0,3/4,2],"v-v-v-v-v-v-v-1-3-5-2&4-1-6"),
  (Graph(7,[[4,6],[5,6],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,3,3,5/2],[1,2,3,2,2,1,3],"v-v-v-v-v-v-4-2&v-3"),
  (Graph(7,[[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[5,6],[4,5]]),[5/2,5/2,5/2,1,0,1,1],[7/4,11/4,4,4,3,2,3],"v-v-v-v-v-v-2-4-v"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[2,3,0,1/2,0,11/2,4],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-2&3-5-7-3-6"),
  (Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[4,7],[2,7],[2,4],[1,7]]),[3/2,0,1/2,0,21/4,15/4,5/2],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-6-4-7-2-5"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6],[4,10]]),[5,4,3,3,2,2,1,1,5,4],[2,2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-v-4&3-6"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[5,4,3,7/4,7/4,3,4],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6-3"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-6-3"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,3/4,23/4,4,11/4,-1/4],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5-7-2&4-7-3-6"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&3-6"),
  (Graph(7,[[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/2,2,3,2,1,1,3],[1,2,3,3,3,2,1],"v-v-v-v-v-v-2-v&2-4"),
  (Graph(7,[[1,3],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,3,2,3/2,3/4,3/4,3],[2,3,2,3,9/4,5/4,1],"v-v-v-v-v-v-3-v-1-3"),
  (Graph(10,[[9,10],[6,10],[7,8],[5,6],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,2,3,4,4,3,5,5],[1,2,2,1,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-3&v-v-6"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4],[3,6]]),[2,3,3,9/4,4,4,5],[9/4,9/4,1,1/4,0,1,1],"v-v-v-v-v-v-v-2-4&3-6&5-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,2,3,1,11/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5&3-7"),
  (Graph(9,[[5,6],[3,8],[4,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,3,2,1,1,5,3,2],[1,2,2,2,2,1,2,1,1],"v-v-v-v-v-v&v-2&v-3&v-4"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,7/4,3/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7&4-6"),
  (Graph(9,[[1,8],[7,8],[5,6],[1,9],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,2,2,1,1,1,2,3,3],[2,2,3,3,2,1,1,1,3],"v-v-v-v-v-v-v-v-1-v-3"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,11/4,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,0],"v-v-v-v-v-v-v-2&3-6-4"),
  (Graph(7,[[3,5],[6,7],[2,3],[3,6],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[3,7],[2,4],[1,7]]),[3/4,2,2,3,5,3,9/4],[1,7/4,11/4,3/2,1,3,19/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7-3-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,3/4,19/4,15/4,11/4],[3/4,7/4,11/4,-3/4,1,1,1],"v-v-v-v-v-v-v-3-5&3-6&4-7"),
  (Graph(7,[[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,3,1,11/4,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-6"),
  (Graph(10,[[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,3,4,5,5,2,4],[1,2,2,2,1,1,1,2,1,2],"v-v-v-v-v-v-v-v&v-3&4-v-6"),
  (Graph(7,[[4,6],[3,5],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[1,6],[2,4],[1,7]]),[2,7/4,3,5,3,1,2],[7/4,3/4,2,5/2,3,9/2,3],"v-v-v-v-v-v-v-1-3-5-1-6-2-4-6"),
  (Graph(9,[[1,8],[7,8],[1,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,3,2,1,2],[2,3,3,3,2,1,1,1,2],"v-v-v-v-v-v-v-v-1-v-5"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[11/4,5/2,7/4,1,-1/4,-1/4,3/4],[2,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-4-2&5-7"),
  (Graph(7,[[4,7],[1,3],[1,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[4,5,5,7/2,9/4,9/4,19/4],[3/4,-1/4,3/4,7/4,3/4,7/4,7/4],"v-v-v-v-v-v-4-v&3-1-4"),
  (Graph(7,[[1,3],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3-1"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,21/4,0,1/2,3/2,5/2,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6]]),[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2&3-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-7"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4-6-2-5-3"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[1/2,0,3/2,1/4,5/2,15/4,5/2],[3/2,5/2,5/4,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-2-6-4"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,3],[5/4,9/4,13/4,9/4,13/4,9/4,5/4],"v-v-v-v-v-v-v-4-6"),
  (Graph(7,[[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,7/4,3/4,2],[1,2,3/2,5/2,3,3,1],"v-v-v-v-v-v&v-2-4"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[3,17/4,4,19/4,3,7/4,7/4],[1,0,1,7/4,2,1,2],"v-v-v-v-v-v-v-5-1-3&2-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[5,4,5,4,4,11/4,11/4],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-2-5-3"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[13/4,5/2,5/2,3/2,1/2,1,7/4],[9/4,3,4,4,4,3,9/4],"v-v-v-v-v-v-v-2-4-6-2"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,2,17/4,3,1,2,1/2],[9/4,9/4,3/4,1,1/4,5/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4-6"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,3,4,5,3,1,2],[1,2,1,1,0,1,1],"v-v-v-v-v-v-v-1-3-5-7-2-4&2-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[0,11/4,4,11/4,1/2,7/4,3/4],[5/2,1,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-2"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,7/4,7/4],[2,1,1,1,2,1,2],"v-v-v-v-v-v-v-5-1-3-5"),
  (Graph(7,[[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[5,4,3,3,2,2,3],[1,1,1,2,2,1,0],"v-v-v-v-v-v-v-1-4-6-3-7"),
  (Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[11/4,4,5,4,3,4,11/4],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v&3-6-4-2-5"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2&3-6"),
  (Graph(10,[[5,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-5"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/2,3/4,11/4,15/4,21/4,0,3/4],[3/4,-1/4,1,1,1,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-2-5"),
  (Graph(7,[[1,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1,2,3,4,4,5/2,2],[1,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6-1"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4]]),[4,5,7/2,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2"),
  (Graph(7,[[2,5],[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6-2-5"),
  (Graph(7,[[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,5/4,-1/2,-1/2,3/2,5/4],"v-v-v-v-v-v-2-v-4-2&4-6"),
  (Graph(7,[[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3,17/4,17/4,3,1,2,2],[1,1,-1/4,-1/4,1/2,2,1],"v-v-v-v-v-v-v-1-4-2-6"),
  (Graph(9,[[8,9],[7,8],[3,8],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4,4,5],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-v&3-8"),
  (Graph(7,[[1,5],[1,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,2,4,4,2,1],[1,1,2,3/2,0,0,1],"v-v-v-v-v-v-v-3&5-1-6"),
  (Graph(8,[[4,7],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-4&v-3"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,21/4,0,15/4,5/2,3/2,1/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&6-3-7"),
  (Graph(8,[[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v&v-3-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v&3-6&5-8"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[2,3,5,4,7/2,2,3],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4&2-6&3-5-7"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[3/4,7/4,7/4,4,11/4,3,3],[17/4,17/4,6,11/2,21/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-7-4-6"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2],[7/4,7/4,7/4,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2&4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,23/4,1/2,4,11/4,7/4,3/4],[5/2,1,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,3/4,9/4,19/4,3,2],[7/4,3/2,1,9/2,1,11/4,11/4],"v-v-v-v-v-v-v-1-3-5&2-7-3&4-6"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,-1/4,3/4,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7-2-4"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[3/4,3/4,2,2,3,2,3/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5"),
  (Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[2,7],[1,6],[2,4]]),[11/4,9/4,2,3/4,3,19/4,13/4],[9/2,11/4,7/4,1,3/2,1,11/4],"v-v-v-v-v-v-v-2-4-1-6-2-5&4-6"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[4,4,11/4,1/2,7/4,11/4,11/4],[9/4,1,7/2,1,7/4,3/2,5/2],"v-v-v-v-v-v-v-2-4-6-2&3-7-5"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,5/2,3/2,5/2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2-4"),
  (Graph(7,[[1,5],[1,7],[1,6],[1,4],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,4,3,5,2,3,1],[0,1,2,1,1,1,1],"v-v-v-v-1-v-3-v-1-v-3"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[13/4,5/2,7/4,1,1,0,7/4],[9/4,3,19/4,4,3,17/4,9/4],"v-v-v-v-v-v-3&v-2-5"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,23/4,4,1/4,11/4,7/4],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4&3-5-2-6"),
  (Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5],[3,6]]),[4,23/4,0,1/2,0,3/2,11/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,0,23/4,4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-2&3-5&4-7-3-6"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[9/4,13/4,5,4,7/2,3,2],[9/4,9/4,1,1,0,1,1],"v-v-v-v-v-v-v-2&3-5-7&4-6"),
  (Graph(7,[[4,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[5,7/2,5/2,7/4,5/4,0,0],[1,1,1,2,1/2,-1/2,5/4],"v-v-v-v-v-v-v-4-1-6-4-2"),
  (Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,2,1,5,3,3,7/4],[2,3,17/4,11/4,3,2,3/4],"v-v-v-v-v-v-v-1-3-5-1-6&3-7-4"),
  (Graph(8,[[1,8],[7,8],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,2],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7&3-6"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,9],[1,10],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&6-9"),
  (Graph(7,[[1,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[19/4,19/4,13/4,4,3,7/4,7/4],[2,1/4,1/4,1,2,1,2],"v-v-v-v-v-v-v-5-1-4-2"),
  (Graph(9,[[2,8],[3,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,1,1,4,2],[1,1,1,2,2,2,1,2,1],"v-v-v-v-v-v-v&v-2&3-v-5"),
  (Graph(10,[[2,5],[3,10],[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,2,3,3,4,4,5,5,1],[2,2,1,1,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-v-6&v-3&2-5"),
  (Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&2-5"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,0,1/2,23/4,4,11/4],[1,1,5/2,-1/4,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7"),
  (Graph(7,[[1,5],[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,9/4,15/4,0,5/2,3/2],[3/4,5/2,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-1"),
  (Graph(7,[[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4],[1,1,2,2,2,1,1],"v-v-v-v-v-v&v-2"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3/4,2,3/4,5/4,4,3,2],[9/4,9/4,1,0,1/2,3/4,3/4],"v-v-v-v-v-v-v-2-4-7&5-2-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[4,3,4,21/4,5,23/4,19/4],[7/4,3/2,11/4,15/4,11/4,2,1],"v-v-v-v-v-v-v-1-3-5-1-6-4&2-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3,3,2,2,4,5,4],[1,0,1,2,2,1,1],"v-v-v-v-v-v-v-1-3-5-7&2-6"),
  (Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,2],[1,2,2,2,3,3,1],"v-v-v-v-v-v-3-v"),
  (Graph(7,[[1,3],[2,5],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[4,23/4,0,3/4,7/4,11/4,3/4],[1,1,5/2,3/2,1,1,-1/4],"v-v-v-v-v-v-v-1-3-7-2"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,-1/4,-1/4],"v-v-v-v-v-v-v&2-5&3-6"),
  (Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,3,2,3,4,2,3/4],[2,3/2,3,3,3,4,3/2],"v-v-v-v-v-v-v-1-3-7-2-5&4-6"),
  (Graph(9,[[7,8],[5,6],[3,8],[4,9],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,1,1,5,4,2],[1,1,2,2,2,1,2,2,1],"v-v-v-v-v-v&v-v-3&v-4"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-5"),
  (Graph(7,[[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[7/2,5/2,1,-1/4,3/4,-1/4,5/2],[3,3,3,13/4,17/4,17/4,2],"v-v-v-v-v-v-4&v-2"),
  (Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-2-5-3-7-4"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4]]),[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4"),
  (Graph(10,[[7,8],[3,9],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-3&v-4"),
  (Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,4,5,4,11/4,2,2],[1,0,1,9/4,3/2,3/4,9/4],"v-v-v-v-v-v-v-4-1-3&2-6"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6&3-5"),
  (Graph(7,[[2,5],[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3&4-7"),
  (Graph(7,[[4,7],[1,3],[1,4],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[15/4,21/4,0,0,5/2,3/2,1/2],[1,1,-1/2,5/2,1,1,5/4],"v-v-v-v-v-v-4-v&2-4-1-3"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[15/4,21/4,0,1/2,0,5/2,3/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6"),
  (Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,9],[1,10],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10&6-9"),
  (Graph(7,[[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[1,2,0,1,4,5,3],[1,1,11/4,-3/4,1,1,1],"v-v-v-v-v-v-3-5&v-2&4-6"),
  (Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5"),
  (Graph(7,[[1,3],[2,5],[2,6],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,7/4,7/4,11/4,11/4,15/4,11/4],[5,6,5,17/4,21/4,11/2,13/4],"v-v-v-v-v-v-v-1-3-5-2-6-4-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[11/4,4,4,3,7/4,7/4,11/4],[9/4,9/4,1,0,5/4,9/4,1],"v-v-v-v-v-v-1-v-3-1-5"),
  (Graph(7,[[2,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,2,1,1,1,3],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-5"),
  (Graph(8,[[2,5],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,1,2,2,3,3,2],[1,2,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-5-2"),
  (Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1/2,3/2,3/2,3/2,5/2,5/2,7/2],[17/4,13/4,17/4,6,21/4,17/4,6],"v-v-v-v-v-v-v-4-1-3-6-2"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7-5"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9"),
  (Graph(7,[[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[13/4,13/4,17/4,17/4,3,2,2],[5/4,9/4,9/4,5/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-2-4-1-6"),
  (Graph(9,[[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-4"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&4-6"),
  (Graph(9,[[2,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,4,5,5,3,1],[1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v&v-2&v-3"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,5/2,2,3],[1,1,0,3/4,9/4,1,1],"v-v-v-v-v-v-v-1-3-7-5-2"),
  (Graph(7,[[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[13/4,5/2,5/2,3/2,1/2,7/4,1/2],[9/4,3,4,4,4,9/4,3],"v-v-v-v-v&v-2-4-v"),
  (Graph(7,[[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[2,2,2,3,4,4,1],[-1/4,3/4,2,3/2,2,1/2,3/4],"v-v-v-v-v-v-1-v-3-5"),
  (Graph(8,[[2,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,1],[1,2,2,1,1,2,3,3],"v-v-v-v-v-v-v&v-2&3-6"),
  (Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,4,5,3,3,2,2],[1,0,1,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&2-6-4"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-4&v-3&5-8"),
  (Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-3"),
  (Graph(7,[[1,3],[1,5],[4,7],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3,5,4,3,3,2,1],[0,1,1,2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-4-2&4-7"),
  (Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7&3-6"),
  (Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2-6-3"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[1,6],[1,7]]),[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-5-7"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[6,7],[3,4],[4,5]]),[1,2,5/2,3/2,1,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-2-v-v-2-4"),
  (Graph(7,[[2,5],[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[2,3,5,4,4,3,2],[2,2,1,0,1,3/4,1],"v-v-v-v-v-2-v&v-2&3-5"),
  (Graph(7,[[2,6],[5,6],[4,6],[4,5],[2,4],[5,7],[1,2],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,11/4,0,4,1/2,4],[1,1,1,5/2,1,-1/4,-1/4],"v-v-v-v-v-v-2-4-6-3-5-v"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[1,6],[2,4],[1,7]]),[17/4,3,3/4,2,9/4,17/4,7/2],[1,3/2,1,7/4,11/4,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6&4-2-5-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[1,2,3,1/4,1,3,17/4],[1,1,1,9/4,-3/4,-3/4,5/4],"v-v-v-v-v-v-v-3-5-7-4-2"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,2,3/4,2,4,4,3],[11/4,7/4,1,15/4,3,1,3/2],"v-v-v-v-v-v-v-1-3-6-4&2-7-3"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,3,2,1,1],[1,2,1,2,3,3,2],"v-v-v-v-v-v-v-2-4&5-2-6"),
  (Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,1/2],"v-v-v-v-v-v-v-2-5&4-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[5,7],[1,5],[1,6],[2,4],[1,7]]),[2,3,5,9/4,3/4,3,2],[11/4,3,1,19/4,1,3/2,7/4],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&5-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,11/4,11/4,11/4],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2"),
  (Graph(8,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,1,-1/4,-1/4],[3,3,9/4,3,17/4,17/4,13/4],"v-v-v-v-v-v-v-5-2-4"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[5/2,3/2,0,1/2,0,9/4,15/4],[1,1,5/2,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-3-1-5-3&5-7"),
  (Graph(7,[[2,6],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[0,0,9/2,3,2,5/4,1],[5/4,5/2,1,1,1,0,3/2],"v-v-v-v-v-v-2-v&2-4-6-3"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,2,3,3,4,5,13/4],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-4&5-7"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,1,1/4,1,5,7/2],[1,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-7-3-6"),
  (Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&5-8"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5]]),[3/4,3/4,5/4,2,5/2,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6&3-5"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5],[3,6]]),[1,2,3,3,4,5,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-4-7&3-6"),
  (Graph(7,[[1,5],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,3,4,4,3,1],[0,1,2,2,1,1,1],"v-v-v-v-v-v-3-v-1-5-3"),
  (Graph(9,[[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-3-6&v-4"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[2,4]]),[11/4,1/2,4,23/4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2-4"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6-3-7"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,9/4,4,3,3,0,5/4],[5/2,3/2,1,5/2,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[4,19/4,3,7/4,7/4,3,19/4],[1,7/4,7/4,2,1,1/4,1/4],"v-v-v-v-v-v-v-1-3-5&2-7&3-6"),
  (Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,2,2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[0,3/2,0,7/4,5/2,7/4,1/2],[-1/4,1,9/4,9/4,1,-1/4,1],"v-v-v-v-v-v-1-v-3-1-5-3"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3/4,0,1/2,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&2-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4],[3,6]]),[3,5,1,2,2,7/4,3],[3,11/4,17/4,3,2,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3&5-7"),
  (Graph(8,[[2,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,4,5,5,4,1],[1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-4&v-2"),
  (Graph(8,[[1,8],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v-1"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,0,1/2,0,23/4,4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1/2,0,1/4,5/4,5/2,7/2,5],[3/2,5/2,-1/2,3/4,1,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,7/4,3,2,3,7/4,3/4],[1,1,3/2,2,5/2,3,3],"v-v-v-v-v-v-v&3-5"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[3/4,11/4,4,23/4,-1/4,7/4,3/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6&5-7"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[3/4,7/4,11/4,0,4,23/4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-3-5"),
  (Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-5&6-9"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,3,3,17/4,17/4,17/4,2],[1/4,5/4,5/2,5/2,5/4,1/4,5/2],"v-v-v-v-v-v&v-3-5-2"),
  (Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[2,3]]),[13/4,17/4,17/4,9/4,5/4,5/4,9/4],[-1/4,3/4,-1/4,-1/4,3/4,7/4,7/4],"v-v-v-1-v-v-v-v-6"),
  (Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[9/4,3,5,3/4,3,2,2],[19/4,3,1,1,3/2,11/4,7/4],"v-v-v-v-v-v-v-4-1-3-6-2&4-6"),
  (Graph(7,[[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[13/4,5/2,3/4,-1/4,-1/4,7/4,1],[9/4,3,4,4,5,9/4,3],"v-v-v-v-v-3&v-2-v"),
  (Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[7/4,13/4,5/2,13/4,19/4,19/4,4],[7/4,7/4,1,1/4,1/4,7/4,1],"v-v-v-v-v-v-v-2-4-7&2-6"),
  (Graph(7,[[1,3],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/4,3/4,0,23/4,4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-7-3-6-4"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,0,0,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7"),
  (Graph(8,[[2,5],[4,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,2,3,3,2,1,4,4],[1,1,1,2,2,2,1,2],"v-v-v-v-v-v&v-3&v-4&2-5"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,2,3,3],[5/4,9/4,3,2,1,2,3],"v-v-v-v-v-v-v-3&4-6"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,2,3,3,4,5,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2-4-7&3-6"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,7/2,5/2,0,3/2,0,1/2],[1,1,5/4,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2&4-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[5,7],[2,4],[1,7]]),[5,4,7/2,3,2,2,3],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-7-4-2"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-4-1-6-2&3-6"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[4,13/4,15/4,11/4,7/4,3/4,2],[15/4,3,1,3/2,7/4,1,3],"v-v-v-v-v-v-v-1-3-6-4-7-2&3-7"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[5,7],[1,5],[1,7]]),[1/2,11/4,4,11/4,0,3/4,7/4],[-1/4,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[9/4,13/4,19/4,4,19/4,13/4,9/4],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4-6&3-5"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[5,7],[1,6],[1,7]]),[3,5,4,3,3,2,1],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-1-3-5-2&4-1-6&5-7"),
  (Graph(7,[[2,5],[2,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,3/2,1/2,5,7/2,5/2,3/2],[2,2,-1/4,1,1,1,1],"v-v-v-v-v-v-2-v&3-6&4-2-5"),
  (Graph(10,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-4"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[15/4,3,7/4,7/4,3/4,7/4,15/4],[25/4,11/2,25/4,5,5,4,19/4],"v-v-v-v-v-v-v-1-3-5&2-7&4-6"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[13/4,19/4,4,19/4,13/4,7/4,7/4],[1/4,1/4,1,7/4,7/4,1,2],"v-v-v-v-v-v-v-5-1-3-5&2-4"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,3,2,1,1,2,3],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2"),
  (Graph(9,[[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,5,2],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-3&4-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,2,2,1,1,1,5/2],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-5"),
  (Graph(7,[[4,6],[2,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,7],[1,6],[2,4]]),[3,19/4,13/4,9/4,2,3/4,11/4],[3/2,1,11/4,11/4,7/4,1,9/2],"v-v-v-v-v-v-v-2-4-1-6-2&4-6"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/4,1,3,19/4,11/4,1,3/2],[7/4,3/4,2,9/4,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-5&6-3-7"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,5,4,4,3,3],[2,2,1,0,1,1,0],"v-v-v-v-v-v-v&3-5-2-6-4"),
  (Graph(7,[[2,5],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6&2-5"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5],[3,6]]),[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4&3-6&5-7"),
  (Graph(7,[[4,7],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,7/4,11/4,2,3,2,1],[3,3,3,2,1,1,3/2],"v-v-v-v-v-v-4-v"),
  (Graph(10,[[9,10],[7,8],[5,6],[1,4],[6,7],[1,10],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4"),
  (Graph(8,[[1,8],[4,7],[7,8],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,3,2,2,1,1,2,3],[2,1,1,2,2,3,3,3],"v-v-v-v-v-v-v-v-1-4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4&3-6"),
  (Graph(7,[[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-3&4-6"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[1,2,3,0,1,4,5],[1,1,1,11/4,-3/4,1,1],"v-v-v-v-v-v-v-4-6&5-7"),
  (Graph(8,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v-v-3-6"),
  (Graph(7,[[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,3/2,3/4,5/4,5/2,3],[2,2,3,9/4,1,1,3],"v-v-v-v-v-v-1-v-3"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[1,3,2,3,4,5,3],[1,2,1,1,1,1,0],"v-v-v-v-v-v-v-1-3-7-5-2-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,17/4,3,11/4,-1/4,1],[11/4,3/2,1,11/4,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[2,3,3,17/4,17/4,3,2],[2,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-7"),
  (Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[1,1,1,2,3,3,2,2,3],[1,2,3,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-v&2-7-4"),
  (Graph(7,[[1,3],[4,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3-6-4-2"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[4,5,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3&2-5"),
  (Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&3-v-5"),
  (Graph(10,[[2,5],[6,10],[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,4,5,1,5],[1,1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5&4-7"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,6]]),[1,2,3,17/4,19/4,4,3],[1,1,1,0,7/4,1,2],"v-v-v-v-v-v-v-2&4-6-3-7-5"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3"),
  (Graph(7,[[1,3],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,3,2,5/2,3/2,3/4,3/4],[1,2,5/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-3-1"),
  (Graph(10,[[2,5],[7,8],[4,7],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5&4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,9/4],[9/4,9/4,1,0,1,1,1/4],"v-v-v-v-v-v-2-v-4-6"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,3/4,0,11/2,15/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&3-7-4"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2-5&3-7"),
  (Graph(9,[[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,3,2],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3"),
  (Graph(9,[[1,8],[2,5],[7,8],[3,9],[1,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v-1-v-3&5-2-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,17/4,3,3],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5-7"),
  (Graph(8,[[2,5],[5,6],[3,8],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,2,1,1,1,3,3],[1,2,3,3,2,1,2,3],"v-v-v-v-v-v&v-2-5&v-3"),
  (Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,3,3/4,5/2,4,5,3/4],[1,3/4,5/2,-1,3/4,1,5/4],"v-v-v-v-v-v-3-v&3-5&4-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6&4-1-5"),
  (Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,5,4,3,3,2,2,1,1,4],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&3-v-5"),
  (Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[2,13/4,5,4,4,3,2],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5-3&4-7"),
  (Graph(8,[[1,8],[7,8],[5,6],[1,4],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[2,1,1,2,3,4,4,3],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4&5-8"),
  (Graph(7,[[1,3],[1,5],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,4,3,3,2,2],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4"),
  (Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,4,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7"),
  (Graph(7,[[5,6],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,4],[1,2,2,2,1,1,1],"v-v-v-v-v-v-3&v-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,1/4,3/4,3,3,2,1],[9/4,9/4,0,0,1,1,1],"v-v-v-v-v-v-v-3-5-2&3-6"),
  (Graph(7,[[3,6],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,3/4,2,3,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v-3-5&v-2"),
  (Graph(9,[[1,5],[7,8],[5,6],[1,4],[6,7],[6,9],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,4,5,5],[2,2,1,1,2,2,1,1,2],"v-v-v-v-1-v-v-v-v-v-7"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[1,7/4,11/4,1/2,5,15/4,3/4],[7/4,1,1,11/4,1,1,-1/2],"v-v-v-v-v-v-v-3&5-7-4-6"),
  (Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,1/4],"v-v-v-v-v-v-v-2-5&3-6-4"),
  (Graph(7,[[1,3],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,3,1],[2,1,2,3,2,1,3],"v-v-v-v-v-v-3-v-1-3-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&2-7-3"),
  (Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,1,2,7/4,5,3,3],[3,9/2,7/4,3/4,5/2,2,3],"v-v-v-v-v-v-v-2-4-6-3-7-5-2"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[2,3,7/2,4,5,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5&2-6-4"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,1,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-3"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,3/4,3,17/4,1/2],[1,1,1,-3/4,-3/4,5/4,2],"v-v-v-v-v-v-v-2&3-6-4-7"),
  (Graph(7,[[1,3],[5,6],[1,4],[6,7],[5,7],[1,2],[2,3],[3,5],[3,4]]),[3,17/4,17/4,3,11/4,7/4,7/4],[-1/4,-1/4,1,1,2,1,2],"v-v-v-v-1-3-v-v-v-7"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[5,4,4,3,2,1,1,2,3],[2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-2"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-4"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6&4-7"),
  (Graph(7,[[3,6],[3,5],[2,3],[1,2],[6,7],[3,4],[4,5]]),[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-3-v-v"),
  (Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6&2-5"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/2,13/4,9/4,1,2,3,4],[4,3,11/4,5/4,7/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6-4"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,4,3,7/4,7/4,3],[2,1,1,1,1,2,2],"v-v-v-v-v-v-v-1-3-7-4"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[3,4,4,3,2,1,1,2,5],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-2"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2"),
  (Graph(7,[[4,7],[2,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,1,2,3,2,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v-v-2&v-4"),
  (Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,5,5,4,3,2,1,1],[1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v&2-5"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-7"),
  (Graph(10,[[9,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&4-7"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,21/4,1/4,1,5/2,15/4],[3/2,5/2,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7-4"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[5,4,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,3,7/2,7/4,7/4,3,5],[1,1,0,3/4,2,2,1],"v-v-v-v-v-v-v-1-3-7&4-6"),
  (Graph(7,[[3,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[3,3,2,1,1,3/2,3],[1,2,2,3,2,1,3],"v-v-v-v-v-3-v&v-2"),
  (Graph(7,[[2,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3/2,0,1/2,0,21/4,15/4,11/4],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-5"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[7/4,7/4,3,17/4,4,19/4,3],[0,1,1,0,1,7/4,2],"v-v-v-v-v-v-v-2&3-7-5&4-6"),
  (Graph(7,[[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,3/4,2,2,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v&v-2&3-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,17/4,1/4,3/4,2,3],[7/4,11/4,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,3,4,3,2,7/2,5],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-7"),
  (Graph(9,[[4,7],[5,6],[6,9],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2,5],[1,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-4&v-3&v-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,5,4,3,2,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-2&4-1-5"),
  (Graph(7,[[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[3,4,9/4,0,5/4,2,3],[17/4,1,3/2,1,7/4,5/2,5/2],"v-v-v-v-v-v-v-2-4-1-6-2&3-6"),
  (Graph(10,[[6,10],[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5,5],[1,2,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v-3&v-5&v-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[4,7],[5,7],[1,5],[1,7]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5-2"),
  (Graph(7,[[4,7],[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[7/4,11/4,13/4,13/4,17/4,17/4,9/4],[9/4,9/4,5/4,1/4,5/4,9/4,1],"v-v-v-v-v-v-2-v-4"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[5,7],[1,2],[2,7],[2,3],[3,4]]),[19/4,15/4,11/4,11/4,15/4,19/4,19/4],[2,2,2,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5-7"),
  (Graph(7,[[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[9/4,13/4,19/4,4,13/4,19/4,9/4],[11/4,11/4,7/4,1,1/4,1/4,7/4],"v-v-v-v-v-v-3&v-2&4-6"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&4-6"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6"),
  (Graph(9,[[7,8],[3,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&3-v-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[11/4,3,2,3/4,3/4,3/2,11/4],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[13/4,19/4,4,19/4,11/4,7/4,7/4],[1/4,1/4,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3&2-4&5-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,5/2,7/2,9/2,0,1,3/2],[-1,1/2,1,5/4,11/4,7/4,1/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7"),
  (Graph(10,[[3,10],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-4&v-3"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,11/2,0,1/2,0],[1,1,1,1,11/4,1,-3/4],"v-v-v-v-v-v-v-3-5-7-4"),
  (Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,4],[3,6]]),[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-2-4-6-3-v"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5-7-3-6-4"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-4&v-3"),
  (Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[5/4,5/4,5/2,1/2,1,15/4,19/4],[1/4,5/4,1,9/4,-3/4,1,1],"v-v-v-v-v-v-v-4-2&4-6&5-7"),
  (Graph(7,[[2,5],[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,3/2,1/4,5,7/2,5/2],[3/2,5/2,5/4,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&2-5&4-7"),
  (Graph(7,[[2,6],[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,3/2,0,5/2,15/4,21/4],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5&4-7"),
  (Graph(10,[[9,10],[7,8],[1,7],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[3,4,5,5,4,3,2,1,1,2],[2,2,2,1,1,1,2,2,1,1],"v-v-v-v-v-v-1-v-v-v-v-8"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-3&4-7-5"),
  (Graph(7,[[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[11/4,7/4,0,5/2,0,3/2,1/2],[9/4,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-3"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4],[3,5]]),[1/2,3/4,0,7/4,11/4,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&3-7"),
  (Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,3/2,0,21/4,15/4,5/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-7&2-5"),
  (Graph(7,[[1,7],[1,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,3,17/4,17/4,3,1],[0,1,2,5/2,3/2,0,1],"v-v-v-v-v-3-v-1-v-3"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[3/4,7/4,1/2,0,11/2,15/4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-7-3-5"),
  (Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,3,2],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-3"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4-1"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[2,2,13/4,19/4,4,19/4,13/4],[2,1,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3&4-6&5-7"),
  (Graph(7,[[2,5],[2,6],[4,7],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6"),
  (Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2&4-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/4,9/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-5"),
  (Graph(8,[[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1],[1,1,1,2,2,2,2,1],"v-v-v-v-v-v-v-v&2-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,4,3,1,3],[1,1,1,9/4,9/4,1,0],"v-v-v-v-v-v-v-2-5-3-7"),
  (Graph(7,[[2,5],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,23/4,4,1/4,1,3/2],[3/2,5/2,1,1,-1/2,1/4,3/2],"v-v-v-v-v-v&v-2-4&2-5-3"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-4&2-5"),
  (Graph(10,[[9,10],[7,8],[1,6],[5,6],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,2,1,1,2,3,4,5,5,4],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-1-6"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/4,7/4,3,3,2,2,3/4],[3,3,3,2,1,2,3/2],"v-v-v-v-v-v-v&3-6-4"),
  (Graph(10,[[9,10],[7,8],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[4,5,5,4,3,3,2,1,1,2],[2,2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&4-1-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3,5,1,2,2,7/4,3],[3,5/2,9/2,3,7/4,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7-5"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,-1/4,-1/4,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7-5"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,2,3/4,3/4,3/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-4&3-6"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4&5-8"),
  (Graph(7,[[4,7],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[9/4,9/4,9/4,1,0,1,1],[2,3,4,4,3,2,3],"v-v-v-v-v-v-2-v-4-2"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5&4-6-3-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,2,1,1,0,0,5/4],[7/2,7/2,9/2,7/2,7/2,9/4,9/4],"v-v-v-v-v-v-v-2-4&3-5"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[2,7],[1,6],[2,4],[1,7]]),[7/4,7/4,11/4,4,3,3,3/4],[4,23/4,5,21/4,4,3,4],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,7/2,7/4,7/4,3,3],[1,1,2,2,3/4,0,1],"v-v-v-v-v-v-v-1-3-7&2-6"),
  (Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[2,3,2,3/4,2,4,4],[11/4,3/2,7/4,1,15/4,11/4,1],"v-v-v-v-v-v-v-4-1-3&2-4&5-7"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[1/2,3/2,0,5/2,15/4,21/4,0],[1,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3-6"),
  (Graph(7,[[2,5],[2,6],[4,7],[4,6],[1,4],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[1,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4-1"),
  (Graph(8,[[2,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,2,1],[1,2,2,2,3,3,1,3],"v-v-v-v-v-v-3-v&v-2"),
  (Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,11/4,11/4,11/4,4,4,1/2],[7/4,3/2,5/2,7/2,11/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-2"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6&2-7-4"),
  (Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[1,5],[1,7]]),[0,3/4,7/4,1/2,11/4,15/4,21/4],[5/2,1,1,-1/2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6&4-7"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[3,4,4,5,9/2,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-7"),
  (Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/2,3/2,3,5,4,3,3],[1,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7"),
  (Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[2,4],[1,7]]),[13/4,9/4,5/4,3/4,1/4,3/4,9/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-1-4-2-6-4-7"),
  (Graph(7,[[1,3],[1,5],[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[15/4,21/4,0,5/2,0,3/2,1/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-3-v-5-1-3-5-2"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/2,5/2,9/4,13/4,9/2,11/4,1/2],[7/4,3/2,5/2,5/2,1,9/2,1],"v-v-v-v-v-v-v-1-3-5-7-2&3-6-4"),
  (Graph(9,[[7,8],[5,6],[4,5],[1,2],[2,9],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,2,3,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-3-v-v&v-2"),
  (Graph(10,[[2,5],[7,8],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5"),
  (Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[4,13/4,19/4,19/4,11/4,7/4,7/4],[1,1/4,1/4,7/4,2,1,2],"v-v-v-v-v-v-v-5&3-1-4"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,4,5,4,3],[1,2,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6-4&3-7"),
  (Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[11/4,1/2,4,23/4,0,3/4,7/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&5-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6"),
  (Graph(8,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3&4-7"),
  (Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[1/2,0,7/4,11/4,4,1/4,3/2],[3/2,5/2,1,1,1,-1/2,-1/2],"v-v-v-v-v-v-v&2-4-6-2-5"),
  (Graph(9,[[2,5],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,3,3,2,2,1,1,5,4],[2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3&2-5"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-6"),
  (Graph(7,[[2,5],[2,6],[2,3],[3,4],[1,2],[3,7]]),[2,2,1,1,3,2,1],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-3"),
  (Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8&4-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,3/2,3/2,3,3],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&5-7"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[13/4,17/4,17/4,13/4,9/4,5/4,5/4],[-1/4,-1/4,3/4,7/4,5/4,7/4,-1/4],"v-v-v-v-v-v-v-1-3&4-6"),
  (Graph(7,[[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[4,4,0,5/2,0,3/2,1/2],[0,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-2&3-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[11/4,11/4,4,4,5,4,11/4],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v&2-6-4&3-5"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[11/4,11/4,7/4,1,0,1,7/4],[9/4,13/4,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-v-2&3-5&4-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[2,4],[1,7]]),[3/4,2,3,9/4,17/4,17/4,9/4],[1,7/4,3/2,11/4,1,3,15/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7"),
  (Graph(7,[[1,3],[4,7],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-3"),
  (Graph(10,[[9,10],[7,8],[5,6],[3,8],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,2,3,3,4,5,5,4,1,2],[1,1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-3&v-v-4"),
  (Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[25/4,11/2,9/2,7/2,9/2,9/2,23/4],[15/4,3,13/4,2,2,1,2],"v-v-v-v-v-v-v-1-3-5-7-2&4-6"),
  (Graph(7,[[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[1/2,0,3/2,0,9/4,15/4,5/2],[1,-1/2,1,5/2,5/2,1,1],"v-v-v-v-v-v-v-4-2-6-4-1"),
  (Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6]]),[1,2,3,3,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-2-v-v-2-v"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[3,2,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-7"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7"),
  (Graph(9,[[7,8],[5,6],[6,9],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-3&v-6"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[19/4,7/2,5,4,4,9/4,9/4],[2,2,1,1,0,3/4,2],"v-v-v-v-v-v-v-2-4&2-6&3-5"),
  (Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[5,4,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3&5-8"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,3/2,5/2,15/4,9/4],[-1/2,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5-1-6-3"),
  (Graph(7,[[1,5],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,1,3,4,4,3,2],[0,1,2,2,1,1,1],"v-v-v-v-v-v-v-3-5-1-6-3"),
  (Graph(10,[[9,10],[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[3,4,5,5,4,3,2,1,1,2],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&2-5"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,19/4,7/2,3/4,9/4],[1/2,3/2,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&4-6-3-5"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,1,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-6"),
  (Graph(7,[[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[4,5/2,7/4,7/4,1,3,3],[21/4,21/4,9/2,6,15/4,13/4,17/4],"v-v-v-v-v-v-v-2-4-1-6-3"),
  (Graph(7,[[2,6],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,11/4,7/4,3/4,2,3],[1,2,3,3,3,1,1],"v-v-v-v-v&v-2-v"),
  (Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,7/4,3,3,4,5,4],[1,2,2,1,0,1,1],"v-v-v-v-v-v-v-4-1-3-6"),
  (Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2"),
  (Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[19/4,4,3,7/4,7/4,3,17/4],[7/4,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2-7"),
  (Graph(9,[[2,5],[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,4,5,1],[1,1,2,2,1,1,2,2,2],"v-v-v-v-v-v-v-v&v-3&2-5&4-7"),
  (Graph(10,[[9,10],[7,8],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9],[7,10],[3,6]]),[3,3,4,4,5,5,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-3&v-v-v-v-8-2"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2"),
  (Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3/2,3,17/4,17/4,3,9/4,21/4],[5/2,5/2,5/2,1,1,7/4,1],"v-v-v-v-v-v-2-4-v&2-5"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,19/4,3,7/4,7/4,3,17/4],[1,7/4,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-7"),
  (Graph(7,[[2,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,19/4,3,2],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4&3-5"),
  (Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3-7-4"),
  (Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[5,4,4,3,2,1,1,2,3],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&2-v-4"),
  (Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[-1/2,-1/2,1,1,1,2,2],[3,4,5,4,3,4,3],"v-v-v-v-v-v-v&2-4-6-3"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-3"),
  (Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[15/4,21/4,9/2,13/4,11/4,7/4,7/4],[3/4,3/4,3/2,2,1,1,2],"v-v-v-v-v-v-v-4-1-3"),
  (Graph(7,[[4,7],[2,5],[2,6],[4,6],[2,3],[1,2],[3,4],[4,5]]),[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,3/4,-1/4,1,1,-1/4],"v-v-v-v-v-2-v-4-v"),
  (Graph(7,[[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,3,17/4,17/4,2],[2,2,1,0,1,0,1],"v-v-v-v-v-v-4-v-2"),
  (Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,1,2,3,3,2,1,3],[3,2,2,2,1,1,1,3],"v-v-v-v-v-v-v-2&v-4"),
  (Graph(7,[[3,6],[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,2,1,-1/4,-1/4,1,2],[7/2,7/2,9/2,9/2,7/2,7/2,5/2],"v-v-v-v-v-v-2-v&3-6"),
  (Graph(10,[[2,5],[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,3,2,1,1,5,2],[2,2,1,1,2,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5"),
  (Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[7/4,3,4,4,4,3,7/4],[5/2,5/2,5/2,3/2,1/2,1,1],"v-v-v-v-v-v-2-4-6-v"),
  (Graph(8,[[7,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,2,3],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-3-v-v"),
  (Graph(7,[[1,3],[2,5],[2,6],[1,7],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-1"),
  (Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4],[3,6]]),[2,3,2,5/2,3/2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&3-6"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,5]]),[0,9/4,15/4,21/4,1/2,3/2,3/4],[5/2,1,1,1,-3/4,1/4,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/4,2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,2,2,3,3,2,3/4],[3/2,2,1,1,2,3,3],"v-v-v-v-v-v-v&2-4&5-2-6"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/4,5/2],[3/2,5/2,1,1,-1/2,3/4,1],"v-v-v-v-v-v-v-2-4&2-5-3&5-7"),
  (Graph(7,[[4,7],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,3,3,2,1,1,1],[1,2,3,2,3,2,1],"v-v-v-v-v-v-4-v&2-4"),
  (Graph(9,[[5,6],[3,8],[5,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,2,3,4,5,3,1,4],[1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-3&v-5"),
  (Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[1,2,2,3,3,7/4,3/4],[2,2,1,2,3,3,3],"v-v-v-v-v-v-v&2-4"),
  (Graph(7,[[4,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[5,7],[2,4]]),[7/2,4,13/4,9/4,1,3,2],[4,9/4,3,11/4,5/4,5/4,7/4],"v-v-v-v-v-v-v-4-1-3&2-4-6&5-7"),
  (Graph(7,[[4,7],[1,7],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,2,1,2],[2,1,1,2,3,3,2],"v-v-v-v-v-v-1-v-4"),
  (Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[6,7],[3,4],[4,5]]),[1,2,3,3,3,1,1],[1,2,3,2,1,3,2],"v-v-v-v-v-2-v-v-2"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4]]),[4,5,25/4,4,5/4,3,4],[2,13/4,4,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3&5-7"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[9/4,13/4,19/4,11/4,3/4,2,3],[11/4,11/4,1,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&3-7-5"),
  (Graph(7,[[2,5],[2,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1,2,4,3,1,2,1],[9/4,2,1,1,-3/4,3/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4"),
  (Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[3,4]]),[1,2,3,3,1,1,2],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-2"),
  (Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[3/4,19/4,3,2,2,3,9/4],[1,1,3/2,7/4,11/4,11/4,9/2],"v-v-v-v-v-v-v-1-3-5-1-4&6-2-7"),
  (Graph(8,[[2,5],[7,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,3,2,2,1],[1,1,2,2,1,1,2,2],"v-v-v-v-v-v-v-v&2-5&4-7"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6&3-7"),
  (Graph(7,[[1,5],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[7/2,7/2,19/4,19/4,3,7/4,7/4],[1,0,0,1,2,1,2],"v-v-v-v-v-v-v-5-1-4"),
  (Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,1/4,4,23/4,0,1/2],[1,1,-1/2,1,1,5/2,3/2],"v-v-v-v-v-v-v&2-4-6-3-5"),
  (Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,7/4,1/4,19/4,13/4,9/4,5/4],[2,2,-1/4,1,1,1,1/2],"v-v-v-v-v-v-v-2-4&3-7&5-2-6"),
  (Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,4,2],[1,2,2,2,2,1,1],"v-v-v-v-v-v&v-3"),
  (Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-7"),
  (Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[2,3,3/4,9/4,17/4,17/4,7/2],[7/4,3/2,1,11/4,7/2,1,11/4],"v-v-v-v-v-v-v-4-1-3-6-2-4-6"),
  (Graph(10,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-v&v-3&v-4&2-5"),
  (Graph(7,[[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3,3,4,4,3,3/2,3/2],[1,2,2,1,0,0,5/4],"v-v-v-v-v-v-v-2-4-1"),
  (Graph(9,[[7,8],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[2,1,1,2,3,3,3,2,1],[2,2,3,3,3,2,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-1-6"),
  (Graph(9,[[3,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[8,9]]),[1,1,2,2,1,3,2,3,3],[1,2,2,3,3,1,1,2,3],"v-v-v-v-v&v-v-3-v-v"),
  (Graph(10,[[9,10],[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,5,5,4,3,2,2,1,1],[2,2,2,1,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-5"),
  (Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[11/4,11/4,11/4,7/4,7/4,3/4,3/4],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-5-3"),
  (Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-5-3&2-4"),
  (Graph(8,[[3,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,2,1,3,3,2],[1,2,2,3,3,1,2,1],"v-v-v-v-v&v-v-3-v"),
  (Graph(7,[[1,3],[1,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[5,4,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3"),
  (Graph(7,[[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[13/4,5/2,1,1,-1/4,-1/4,7/4],[9/4,3,3,17/4,17/4,13/4,9/4],"v-v-v-v-v-v-4-2-v"),
  (Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,2,3,3,2,1,4],[2,2,2,1,1,1,2],"v-v-v-v-v-v&v-3&2-5"),
  (Graph(7,[[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,3,3,2,1],[1,2,1,2,3,3,3],"v-v-v-v-v-v-v-2-4&2-6"),
  (Graph(7,[[1,5],[5,6],[6,7],[1,4],[5,7],[1,2],[2,3],[3,4]]),[9/2,7/2,7/2,9/2,11/4,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-1-v-v-v-6"),
  (Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[1,5],[1,6],[2,4],[1,7]]),[3,5,4,3,3,2,1],[2,1,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4-7"),
  (Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4&2-6"),
  (Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3,4,4,4,3,7/4,7/4],[1,1/4,5/4,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-1"),
  (Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7"),
  (Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,19/4,13/4,9/4,5/4,1/4],[3/2,5/2,1,1,1,1/2,-1/2],"v-v-v-v-v-v-v-2-4-7-3"),
  (Graph(7,[[4,7],[1,7],[4,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3,5/2,3/2,2,1,1,3],[2,3,3,2,1,2,1],"v-v-v-v-v-v-4-v-1-4-2"),
  (Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&3-v-7")
]


def PrintVertexLabel(s):   ##
  if s is None:
    return ""
  return str(s).replace(" ","").replace("[","").replace("]","")


def StandardGraphCoordinates(G):
  """
  Vertex coordinate lists x,y for planar drawing
  """

  Glabel, P, trails = GraphLabel(G, full=True, usevertexlabels=False)

  P0 = [i for i in range(len(P)) if P[i][0] == 0]   # When vertices first on path
  T = trails[0]

  Std = None
  for graph in gridgraphs:
    if graph[3] == Glabel:        # Look for GraphLabel(graph) == GraphLabel(G)
      Std = graph
      break
  if not Std:
    raise NotImplementedError(f"TeXGraph: Don't know how to draw graph with label {Glabel} (e.g. large or non-connected)")  

  Gstd, x, y, _ = Std

  perm = [T[i] for i in P0]              
  invperm = [0] * len(perm)          # Inverse permutation to trail
  for i in range(len(perm)):
    invperm[perm[i]-1] = i+1  
  x = [x[i-1] for i in invperm]      # Permute x,y according to minimum path
  y = [y[i-1] for i in invperm]

  return x,y


def TeXGraph(G, x="default", y="default", labels="default", scale=0.8, xscale=1, yscale=1, vertexlabel="default", edgelabel="default", vertexnodestyle="default", edgenodestyle="default", edgestyle="default"):
  """
  Generate TikZ code for drawing a small planar graph.

  Parameters:
  - G: An connected undirected networkx graph.
  - x, y: Coordinates of vertices.
  - labels: Vertex labels ("none", "default", or a list of strings).
  - scale: Overall scaling factor for the graph.
  - xscale, yscale: Scaling factors for x and y dimensions.
  - vertexlabel, edgelabel: Functions or strings for labeling vertices/edges.
  - vertexnodestyle, edgenodestyle, edgestyle: Functions or strings defining styles for nodes/edges.

  Returns:
  - TikZ code as a string.
  """

  RR = lambda v: PrintReal(v, prec=2)        # Print reals with at most two digits after the comma

  xscale = RR(scale * xscale)
  yscale = RR(scale * yscale)

  # Initialize TikZ options
  tikzstyle = f"xscale={xscale},yscale={yscale},auto=left"
  options = [tikzstyle]

  # Default styles if not provided
  if vertexnodestyle == "default":
    vertexnodestyle = "circle,scale=0.7,fill=blue!20,inner sep=1pt"
  if edgenodestyle == "default":
    edgenodestyle = "scale=0.6,above"
  if edgestyle == "default":
    edgestyle = ""
  if vertexlabel == "default":
    vertexlabel = lambda v: PrintVertexLabel(GetLabel(G,v))
  if edgelabel == "default":
    edgelabel = lambda e: PrintVertexLabel(GetLabel(G,e))

  if x == "default" or y == "default":
    x, y = StandardGraphCoordinates(G)           # Coordinates x,y if not provided

  # Styles for vertices and edges
  styles = [vertexnodestyle, edgenodestyle, edgestyle]
  vars = [list(G.nodes), list(G.edges), list(G.edges)]
  optname = ["v", "l", "e"]

  newstyles = []  # Create an empty list to store the modified styles

  for i, s in enumerate(styles):
    if callable(s) or len(vars[i]) == 0:    # if s is a function
      V = {s(v) for v in vars[i]}              # Apply s to each element in vars[i] and collect the results in a set
      if len(V) == 1:                          # If all results are the same (constant style)
        s = next(iter(V))                      # Get the unique element 
      elif len(V) == 0:                        # If the set is empty, no style is applied
        s = ""   
    if isinstance(s, str):                  # if s is a string
      s = s.strip()                
      if s == "":
        newstyles.append(lambda v: "")         # If s is an empty string, return an empty string for each vertex/edge
      else:
        options.append(f"{optname[i]}/.style={{{s}}}")           # Add the style to the global options
        newstyles.append(lambda v, optname=optname[i]: optname)  # Create a lambda that returns the style name
    else:
      newstyles.append(s)  # If it's already a function, just keep the same function

  vertexnodestyle, edgenodestyle, edgestyle = newstyles     # decode new styles

  # Generate TikZ code
  tikz_code = f"\\begin{{tikzpicture}}[{','.join(options)}]\n"

  # Add nodes (vertices)
  for i, v in enumerate(G.nodes):
    label = ""
    if labels == "none":
      label = f"\\hbox to {xscale}em{{\\hfill}}"
    elif isinstance(labels, list):
      label = labels[i]
    elif labels != "default":
      raise ValueError("labels should be 'none', 'default', or a list of strings")
    elif v in G.nodes:
      label = vertexlabel(v)

    tikz_code += f"  \\node[{vertexnodestyle(v)}] ({i+1}) at ({RR(x[i])},{RR(y[i])}) {{{label}}};\n"

  # Add edges
  for e in G.edges:
    v1, v2 = e
    if edgelabel:
      edge_label = edgelabel(e)
      tikz_code += f"  \\draw[{edgestyle(e)}] ({v1})--node[{edgenodestyle(e)}] {{{edge_label}}} ({v2});\n"
    else:
      tikz_code += f"  \\draw[{edgestyle(e)}] ({v1})--({v2});\n"

  tikz_code += "\\end{tikzpicture}"

  return tikz_code


def GraphFromEdgesString(edgesString):
  """
  Construct a graph from a string encoding edges such as "1-2-3-4, A-B, C-D", assigning the vertex labels to the corresponding strings.
  """
  edgeChains = edgesString.split(',')
  edgeRegex = r'^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$'  # Regex to match valid edges (alphanumeric separated by dashes)

  edges = []
  vertices = {}  # Dictionary to map vertex labels to numeric indices
  vertexCount = 0  # Counter for assigning numbers to unique vertices

  for chain in edgeChains:                     # Iterate over each chain and validate it
    chain = chain.strip()                      # Remove extra whitespace
    if not re.match(edgeRegex, chain):         # Check if the chain matches the expected pattern
      return None                              # If invalid, return None

    V = chain.split('-')                       # Split the chain by dashes to get the vertices in that chain
    for vertex in V:
      if vertex not in vertices:               # If vertex label hasn't been seen before, assign a new number
        vertexCount += 1
        vertices[vertex] = vertexCount

    for i in range(len(V) - 1):                # Add edges between consecutive vertices
        edges.append([vertices[V[i]], vertices[V[i + 1]]])

  vertexLabels = list(vertices.keys())         # List of original vertex labels
  G = Graph(vertexCount, edges)                # Create a new Graph 
  AssignLabels(G, vertexLabels)                # Assign the original labels to the graph vertices
  return G


"""
Example
G = GraphFromEdgesString("1-2-3-4-1, 2-A, 3-B")
print(GraphLabel(G))
print(TeXGraph(G))
"""


### Dual graphs (GrphDual)



"""
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

This section provides a class (\textbf{GrphDual}) for representing dual graphs and their
manupulation and invariants.
"""


### Default construction


def DualGraph(m: List[int], g: List[int], edges: List[List[int]], comptexnames = "default") -> 'GrphDual':
  """
  Construct a dual graph (GrphDual) from multiplicities and genera of vertices, and edges of the underlying graph.

  Parameters:
  m: List of multiplicities for each provided component
  g: List of genera for each provided component
  edges: List of edges in the form 
    [i,j]           - intersection point between component #i and component #j (1<=i,j<=n)
    [i,0,d1,d2,...] - outer chain from component #i (1<=i<=n)
    [i,j,d1,d2,...] - inner chain from component #i to component #j (1<=i,j<=n)
  comptexnames (optional): 'default', function to name components, or a list of names for components.
  """
  # Check m and g
  if not isinstance(m, list) or not all(isinstance(x, int) and x > 0 for x in m):
    raise ValueError("m must be a list of positive integers")
  if not isinstance(g, list) or not all(isinstance(x, int) and x >= 0 for x in g):
    raise ValueError("g must be a list of non-negative integers")
  if len(m) != len(g):
    raise ValueError("m and g must be of the same length")

  # Process comptexnames
  if isinstance(comptexnames, str):
    if comptexnames == "default":
      comptexnames = [f"{i}" for i in range(1, len(m) + 1)]  # Default names 1, 2, ...
    else:
      raise ValueError(f"comptexnames='{comptexnames}' is not valid. Use 'default' or a list of names.")
  elif callable(comptexnames):
    comptexnames = [comptexnames(i) for i in range(1, len(m) + 1)]
  elif isinstance(comptexnames, list):
    if len(comptexnames) != len(m):
      raise ValueError("comptexnames must have the same length as m.")
  else:
    raise ValueError("comptexnames must be 'default', a list of names, or a function")

  # Create empty graph and initialise the resulting dual graph D
  D    = GrphDual() 

  # Add components (vertices) -> V
  for i in range(len(m)):
    D.AddComponent(f"{i+1}", g[i], m[i], texname=comptexnames[i])
  V = D.Components()

  # Add edges or chains
  for e in edges:
    if len(e) < 2 or not all(isinstance(x, int) and x >= 0 for x in e):
      raise ValueError(f"Edge {e} is not valid. It must be of the form [v1,v2], [v1,0,d1,...], or [v1,v2,d1,...].")

    if e[0] < 1 or e[0] > len(m) or e[1] < 0 or (e[1] > len(m) and e[1] != 0):
      raise ValueError(f"Invalid edge {e}: component indices must be in the range 1..{len(m)}.")

    if len(e) == 2:  # Two components meeting at a point
      D.AddEdge(V[e[0] - 1], V[e[1] - 1])
    elif e[1] == 0:  # Outer chain
      D.AddChain(V[e[0] - 1], None, e[2:])  # Outer chain: no second vertex
    else:  # Inner chain
      D.AddChain(V[e[0] - 1], V[e[1] - 1], e[2:])  # Inner chain between two vertices

  return D


"""
Example Constructing a dual graph
m  = [3,1,1,1,3]                             # multiplicities of c1,c2,c3,c4,c5
g  = [0,0,0,0,0]                             # genera of c1,c2,c3,c4,c5
E  = [[1,2],[1,3],[1,4],[2,5],[3,5],[4,5]]   # edges c1-c2,... as 2-tuples or lists
G1 = DualGraph(m,g,E)
print(G1)
m  = [3,3]             # Principal components and chains (same graph)
g  = [0,0]
E  = [[1,2,1],[1,2,1],[1,2,1]]
G2 = DualGraph(m,g,E)
print(G2)
m  = [3,3]
g  = [0,0]             # Principal components, different chains 
E  = [[1,2,1],[1,2,1,1],[1,2,1,1,1,1]]
G3 = DualGraph(m,g,E)
print(G3)
# This is what the three special fibres look like (with component names in blue):\par
# \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {3} node[facel] {5}; \draw[l1] (0,0.66)--(2.26,0.66) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \end{tikzpicture}\qquad\begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {3} node[facel] {2}; \draw[l1] (0,0.66)--(2.26,0.66) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \end{tikzpicture}\qquad\begin{tikzpicture}[xscale=0.8,yscale=0.7, belowleftl/.style={below left=-4.5pt,lfnt}, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, belowrightl/.style={below right=-4.5pt,lfnt}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(3.6,0) node[mainl] {3} node[facel] {2}; \draw[l1] (0,2)--(2.93,2) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,2); \draw[l2] (1.46,0)--node[rightl] {1} (1.46,0.66); \draw[l2] (0.8,0.66)--node[abovel] {1} (1.46,0.66); \draw[l2] (0.8,0.66)--node[leftl] {1} (0.8,1.33); \draw[l2] (0.8,1.33)--node[belowrightl] {1} (1.46,2); \draw[l2] (2.93,0)--node[rightl] {1} (2.93,1); \draw[l2] (2.93,1)--node[belowleftl] {1} (2.26,2); \end{tikzpicture}
"""


"""
Example Printing dual graph as a string and reconstructing it
R = ReductionType("Ig1-Ig2-Ig3-c1")
G = R.DualGraph();        # Triangular dual graph on 3 vertices and 3 edges
print(G)
G2 = eval(str(G))         # and reconstructed back
print(G2)
"""


### Step by step construction


class GrphDual:
  def __init__(self):
    """
    Initialize an empty dual graph
    """
    self.G  = nx.MultiGraph()    # empty underlying graph
    self.pts     = []            # non-singular points
    self.singpts = []            # singular points
    self.specialchains = []      # chains of variable length and singular chains 

  def AddComponent(self, name: str, genus: int, multiplicity: int, texname=None):
    """
    Adds a component (vertex) to the graph with attributes m, g, and optional texname. 
    Returns name of the added component (which is given by name if <>None, <>"")
    """
    if not name:
      name = f"c{len(self.G.nodes)+1}"
    if name in self.G.nodes:
      raise ValueError(f"Vertex {name} already exists")
    if texname==None or texname=="default":
      texname = name
    self.G.add_node(name, g=genus, m=multiplicity, texname=texname)
    return name

  def AddEdge(self, node1, node2):
    """
    Adds an edge between two components (vertices) in the graph.
    """
    self.G.add_edge(node1, node2)

  def AddChain(self, c1: str, c2: Union[str, None], mults: List[int]):
    """
    Adds a chain of P1s with multiplicities between c1 and c2. Adds as many vertices as 
    there are multiplicities in 'mults', and links them in a chain starting at c1 and 
    ending at c2 (if c2 is provided, else it's an outer chain).
    """
    if c1 not in self.G.nodes:      
      raise ValueError(f"Component {c1} does not exist in the graph.")
    if c2 and c2 not in self.G.nodes:
      raise ValueError(f"Component {c2} does not exist in the graph.")

    cold = c1                 # Create intermediate vertices and chain
    for i, mult in enumerate(mults):
      cnew = self.AddComponent("", 0, mult)
      self.AddEdge(cold, cnew)
      cold = cnew  
    if c2:
      self.AddEdge(cold, c2)

  """
  Example Type $\rm II^*$ reduction
  # This is how we can construct the dual graph of the type $\rm II^*$ elliptic curve,
  # creating some components and edges by hand, and adding the rest as outer chains.\par
  # \begin{center}
  # \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {6} node[facel] {A}; \draw[l2] (0.66,0)--node[rightl] {5} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {4} (0.66,0.66); \draw[l2] (0,0.66)--node[leftl] {3} (0,1.33); \draw[l2] (0,1.33)--node[abovel] {2} (0.66,1.33); \draw[l2end] (0.66,1.33)--node[rightl] {1} (0.66,2); \draw[l2end] (1.46,0)--node[rightl] {3} (1.46,0.66); \draw[l2] (2.93,0)--node[rightl] {4} (2.93,0.66); \draw[l2] (2.26,0.66)--node[abovel] {2} (2.93,0.66); \end{tikzpicture}
  # \end{center}
  G = GrphDual()
  c1 = G.AddComponent("A", genus=0, multiplicity=6)   # Called 'A', multiplicity 6
  c2 = G.AddComponent("", genus=0, multiplicity=3)    # default name ('c2')
  G.AddEdge(c1,c2)              # Link the two (shortest chain)
  G.AddChain(c1,None,[4,2])     # The other two chains
  G.AddChain(c1,None,[5,4,3,2,1])
  print(G.Components())
  print(G.ReductionType())
  """

  ### Global methods and arithmetic invariants 


  def Graph(self) -> nx.Graph:
    """
    Returns the underlying graph.
    """
    return self.G

  def Components(self) -> list:
    """
    Returns the list of components (vertices) of the dual graph.
    """
    return list(self.G.nodes)

  def Edges(self) -> list:    ##
    """
    Returns the sorted list of edges of the underlying graph.
    """
    return sorted([list(e[:2]) for e in self.G.edges])

  def __str__(self):     ##
    """
    Print a dual graph in the form that can be evaluated DualGraph(...)
    """
    V = self.Components()
    E = self.Edges()
    printedge = lambda e: f"[{V.index(e[0])+1},{V.index(e[1])+1}]"
    Mstr = str(self.Multiplicities()).replace(" ","")
    Gstr = str(self.Genera()).replace(" ","")
    Estr = ','.join([printedge(e) for e in E])
    return f"DualGraph({Mstr}, {Gstr}, [{Estr}])"

  def IsConnected(self):
    """
    True if underlying graph is connected
    """
    return nx.is_connected(self.G)

  def HasIntegralSelfIntersections(self):
    """
    Are all component self-intersections integers
    """
    return all(isinstance(self.Intersection(v,v),int) for v in self.Components())

  def AbelianDimension(self):
    """
    Sum of genera of components
    """
    return sum(self.Genus(c) for c in self.Components())

  def ToricDimension(self):
    """
    Number of loops in the dual graph
    """
    if not self.IsConnected():
      raise ValueError("Dual graph appears to be disconnected")
    return len(self.Edges()) - len(self.Components()) + 1

  def IntersectionMatrix(self):
    """
    Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.
    """
    C = self.Components()
    return [[self.Intersection(v,w) for v in C] for w in C]

  """
  Example
  # Here is the dual graph of the reduction type \redtype{1_{g3}\e1_{g2}\e1_{g1}\e c_1}, consisting of 
  # three components genus 1,2,3, all of multiplicity 1, connected in a triangle.
  G = DualGraph([1,1,1],[1,2,3],[[1,2],[2,3],[3,1]])  
  assert G.IsConnected()                     # Check the dual graph is connected
  assert G.HasIntegralSelfIntersections()    #   and every component c has c.c in Z
  print(G.AbelianDimension())                # genera 1+2+3 => 6
  print(G.ToricDimension())                  # 1 loop       => 1
  print(G.ReductionType().TeX())
  print(G.IntersectionMatrix())              # Intersection(G,v,w) for v,w components
  """

  def PrincipalComponents(self):
    """
    Return a list of indices of principal components.

    A vertex is a principal component if either its genus is greater than 0
    or it has 3 or more incident edges (counting loops twice).
    In the exceptional case [d]I_n one component is declared principal.
    """
    is_principal = lambda v: self.Genus(v) > 0 or len(self.Neighbours(v)) >= 3
    P = list(filter(is_principal, self.Components()))      
    if not P:
      P = [self.Components()[0]]       # multiple of I_n -> declare one component to be principal
    return P

  def ChainsOfP1s(self):
    """
    Returns a sequence of tuples [(v1,v2,[chain multiplicities]),...] for chains of P1s between principal components, and v2=None for outer chains
    """
    P = self.PrincipalComponents()
    Pv = set(P)
    E = list(self.Graph().edges)
    chains = []

    while E:
      for e in E:
        if e[0] in Pv or e[1] in Pv:
          break
      else:
        break  # No more edges to process

      v0 = e[0] if e[0] in Pv else e[1]
      path = []
      startv = v0
      endv = None

      while True:
        e = next(edge for edge in E if {edge[0], edge[1]} & {v0})
        v1 = e[1] if e[0] == v0 else e[0]
        E.remove(e)

        if v1 in Pv:
          endv = v1
          break

        path.append(self.Multiplicity(v1))
        ee = list(self.Graph().edges(v1))
        if len(ee) == 1:
          break  # Dead end, no more edges to follow

        e = ee[0] if ee[1] == e else ee[1]
        v0 = v1

      if any(c[0] == endv and c[1] == startv for c in chains):
        chains.append((endv, startv, list(reversed(path))))
      else:
        chains.append((startv, endv, path))

    return chains

  def ReductionType(self):
    """
    Reduction type corresponding to the dual graph
    """
    return ReductionTypeFromDualGraph(self)


  ### Contracting components to get a mrnc model


  def ContractComponent(self, c, checks=True):
    """
    Contract a component in the dual graph, assuming it meets one or two components, and has genus 0.
    """
    G = self
    if not self.HasComponent(c):
      raise ValueError(f"Vertex {c} does not exist in the graph.")
    N = G.Neighbours(c)

    if checks:
      if G.Genus(c) != 0:
        raise ValueError("Positive genus component cannot be contracted")
      if G.Intersection(c, c) != -1:
        raise ValueError(f"Cannot contract component {c} of self-intersection {G.Intersection(c, c)}<>-1")
      if len(N) > 3:
        raise ValueError("Component that meets the special fibre in >2 points cannot be contracted")
      if len(G.Components()) == 1:
        raise ValueError("Cannot contract last remaining component")

    if len(N) == 2:
      G.G.AddEdge(N[0], N[1])

    G.G.remove_node(c)

  def MakeMRNC(self):
    """
    Repeatedly contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal crossings.
    """
    G = self
    G.Check()
    again = True
    while again:
      again = False
      if len(G.Components())==1:
        return
      for c in G.Components():
        if G.Genus(c) == 0 and len(G.Neighbours(c)) <= 2 and G.Intersection(c, c) == -1:
          G.ContractComponent(c, checks=False)
          again = True
          break

  def Check(self):
    """
    Check that the graph is connected and self-intersections are integers.
    """
    # Check if the graph is connected
    if not nx.is_connected(self.Graph()):
      raise ValueError("The graph is not connected")

    # Check multiplicities and genera
    for v in self.Components():
      multiplicity = self.Multiplicity(v)
      genus = self.Genus(v)
      if not isinstance(multiplicity, int) or multiplicity <= 0:
        raise ValueError(f"Node {v} has an invalid multiplicity: {multiplicity}")
      if not isinstance(genus, int) or genus < 0:
        raise ValueError(f"Node {v} has an invalid genus: {genus}")

    # Check self-intersections for every node
    for v in self.Components():
      self_intersection = self.Intersection(v,v)
      if not isinstance(self_intersection, int):
        raise ValueError(f"Self-intersection for node {v} is {self_intersection}, not an integer")  


  """
  Example Contracting components
  G = DualGraph([1,1],[1,0],[[1,2,1,1,1]])  # Not a minimal rnc model
  print(G.Components(),[G.Intersection(v,v) for v in G.Components()])
  G.ContractComponent("2")   # Remove the last component
  G.ContractComponent("c5")  #   and then the one before that
  print(G.Components())
  print(G)
  G.MakeMRNC()               # Contract the rest of the chain
  print(G.Components())
  print(G)
  print(G.ReductionType())   # Associated reduction type
  """


  ### Invariants of individual vertices


  def __getitem__(self, c):           ##
    """
    Retrieves the vertex in a dual graph.
    """
    return self.G.nodes[c]

  def HasComponent(self, c):
    """
    Test whether the graph has a component named c
    """
    return c in self.Components()

  def Multiplicity(self, c):
    """
    Returns the multiplicity m of vertex c from the graph.
    """
    if not self.HasComponent(c):
      raise ValueError(f"Vertex {c} does not exist in the graph.")
    return self[c]['m']

  def Multiplicities(self) -> list:
    """
    Returns the list of multiplicities of components.
    """
    return [self.Multiplicity(v) for v in self.Components()]

  def Genus(self, c):
    """
    Returns the geometric genus g of vertex c from the graph.
    """
    if not self.HasComponent(c):
      raise ValueError(f"Vertex {c} does not exist in the graph.")
    return self[c]['g']

  def Genera(self) -> list:
    """
    Returns the list of geometric genera of components.
    """
    return [self.Genus(v) for v in self.Components()]

  def Neighbours(self, c):
    """
    List of incident vertices, with each loop contributing the vertex itself twice
    """
    if not self.HasComponent(c):
      raise ValueError(f"Vertex {c} does not exist in the graph.")
    return [u if v==c else v for u, v in self.Graph().edges(c)] + [c for u, v in self.Graph().edges(c) if u==v==c]       

  def Intersection(self, c1, c2):
    """
    Compute the intersection number between components c1 and c2 (or self-intersection if c1=c2).
    """
    if c1==c2:            # self-intersection
      m = self.Multiplicity(c1)      
      O = [self.Multiplicity(v) for v in self.Neighbours(c1) if v!=c1]
      if sum(O) % m:
        return -sum(O)/m             # non-integral
      else:
        return -int(sum(O)/m)        # integral
    else:                 # intersection of two distinct components ( = #points of intersection)
      return len([v for v in self.Neighbours(c1) if v==c2])


"""
Example Cycle of 5 components
G = DualGraph([1], [1], [[1,1,1,1,1,1]])
C = G.Components()
print(C)
assert G.HasComponent("c2")
print(G.Multiplicity("c2"))
print(G.Genus("c2"))
for row in [[G.Intersection(v, w) for v in C] for w in C]: print(" ".join(map(str, row))) #> print([[G.Intersection(v, w) for v in C] for w in C])    # = G.IntersectionMatrix()
"""


### Reduction Types (RedType)


"""
Manual
Now we come to reduction types, implemented through the class \texttt{RedType}.
They can be constructed in a variety of ways:

\begin{tabular}{l@{\quad}l}
\texttt{ReductionType(m,g,O,L)} & Construct from a sequence of components (including all principal\cr
                                &  ones), their multiplicities m, genera g, outgoing multiplicities\cr 
                                & of outer chains O, and inner chains L beween them, e.g.\cr
                                & \texttt{ReductionType([1],[0],[[]],[[1,1,0,0,3]])} \hfill (Type \redtype{I_3})\cr
\texttt{ReductionTypes(g)}      & All reduction types in genus g. Can restrict to just semistable ones\cr
                                & and/or ask for their count instead of actual the types, e.g.\cr
                                & \texttt{ReductionTypes(2)} \hfill (all 104 genus 2 types)\cr
                                & \texttt{ReductionTypes(2, countonly=True)} \hfill (only count them)\cr
                                & \texttt{ReductionTypes(2, semistable=True)} \hfill (7 semistable ones)\cr
\texttt{ReductionType(label)}   & Construct from a canonical label, e.g.\cr
                                & \texttt{ReductionType("I3")}\cr
\texttt{ReductionType(G)}       & Construct from a dual graph, e.g.\cr
                                & \texttt{ReductionType(DualGraph([1],[1],[]))} \hfill (good elliptic curve)\cr
\texttt{ReductionTypes(S)}      & Reduction types with a given shape, e.g.\cr
                                & \texttt{ReductionTypes(Shape([2],[]))} \hfill (46 of the genus 2 types)\cr
\end{tabular}

\medskip

Conversely, from a reduction type we can construct its dual graph (\texttt{R.DualGraph()}) 
and a canonical label {\texttt{R.Label()}), and these functions are also described in this section.
Finally, there are functions to draw reduction types in TeX (\texttt{R.TeX()}).
"""


def ReductionTypeFrommgOL(m,g,O,L):  ##
  """
  Construct a reduction type from a sequence of components, their invariants, and chains of P1s:
    m = sequence of multiplicities of components c_1,...,c_k
    g = sequence of their geometric genera
    O = outgoing multiplicities of outer chains, one sequence for each component
    L = inner chains, of the form
        [[i,j,di,dj,n],...] - inner chain from c_i to c_j with multiplicities m[i],di,...,dj,m[j], of depth n
        n can be omitted, and chain data [i,j,di,dj] is interpreted as having minimal possible depth.
  """
  if len(m) != len(g) or len(m) != len(O):
    raise ValueError("Sequences of genera, multiplicities, and of outer multiplicities must have the same length equal to the number of components")
  
  if any(d for d in O if len(d) > 0 and not all(isinstance(x, int) for x in d)) \
    or any(d for d in L if len(d) > 0 and not all(isinstance(x, int) for x in d)):
      raise ValueError(f"ReductionType: {d}: Expected integers as elements")
  
  # outer chains
  E = [[i, 0] + OuterSequence(m[i-1], o, includem=False) for i in range(1,len(m)+1) for o in O[i-1]]
  
  # inner chains
  for d in L:
    if len(d) not in [4, 5] or d[0] < 1 or d[0] > len(m) or d[1] < 1 or d[1] > len(m):
        raise ValueError(f"ReductionType: {d}: Expected link data [i,j,di,dj] or [i,j,di,dj,n]")
    i, j, di, dj = d[0], d[1], d[2], d[3]
    n = d[4] if len(d) == 5 else MinimalDepth(m[i-1], di, m[j-1], dj)
    E.append([i, j] + InnerSequence(m[i-1], di, m[j-1], dj, n, includem=False))

  vprint("ReductionTypeFrommgOL: m=",m)
  vprint("ReductionTypeFrommgOL: g=",g)
  vprint("ReductionTypeFrommgOL: E=",E)
  
  # construct dual graph and associated reduction type
  G = DualGraph(m, g, E)
  vprint("ReductionTypeFrommgOL: G=",G)
  return G.ReductionType()


def ReductionType(*args) -> 'RedType':
  """
  Reduction type from either:
  ReductionType(label: Str)    reduction type from a label, e.g. "I3"
  ReductionType(G: GrphDual)   reduction type from a dual graph
  ReductionType(m, g, O, L)    reduction type from sequence of components, their invariants, and chains of P1s:
    m = sequence of multiplicities of components c_1,...,c_k
    g = sequence of their geometric genera
    O = outgoing multiplicities of outer chains, one sequence for each component
    L = inner chains, of the form
        [[i,j,di,dj,n],...] - inner chain from c_i to c_j with multiplicities m[i],di,...,dj,m[j], of depth n
        n can be omitted, and chain data [i,j,di,dj] is interpreted as having minimal possible depth.
  """
  if len(args) == 1:
    if isinstance(args[0], GrphDual):     # Reduction type from a dual graph (GrphDual)
      return ReductionTypeFromDualGraph(args[0])
    elif isinstance(args[0], str):        # Reduction type from label (Str)
      return ReductionTypeFromLabel(args[0])
    else:
      raise TypeError("Single argument must be either a GrphDual or a string.") 
  elif len(args) == 4:                    # Reduction type from m,g,O,L
    m, g, O, L = args
    if (isinstance(m, (list, tuple)) and isinstance(g, (list, tuple)) and
        isinstance(O, (list, tuple)) and isinstance(L, (list, tuple))):
      return ReductionTypeFrommgOL(m, g, O, L)
    else:
      raise TypeError("Arguments for ReductionTypeFrommgOL must be sequences (list or tuple).")
  else:
    raise ValueError("Invalid number or types of arguments provided for ReductionType.")


"""
Example $\rm II^*$
# We construct Kodaira type \redtype{II*} as a reduction type\par
# \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {6} node[facel] {$\Gamma_1$}; \draw[l2] (0.66,0)--node[rightl] {5} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {4} (0.66,0.66); \draw[l2] (0,0.66)--node[leftl] {3} (0,1.33); \draw[l2] (0,1.33)--node[abovel] {2} (0.66,1.33); \draw[l2end] (0.66,1.33)--node[rightl] {1} (0.66,2); \draw[l2end] (1.46,0)--node[rightl] {3} (1.46,0.66); \draw[l2] (2.93,0)--node[rightl] {4} (2.93,0.66); \draw[l2] (2.26,0.66)--node[abovel] {2} (2.93,0.66); \end{tikzpicture}
m = [6]          # multiplicity of one starting component Gamma_1
g = [0]          # their geometric genera
O = [[3, 4, 5]]  # outgoing multiplicities of outer chains from each of them
L = []           # inner chains
R = ReductionType(m, g, O, L)
print(R.Label())
assert R == ReductionType("II*")    # same type from label
"""


"""
Example $\rm I^*_3$
# Similarly, we construct Kodaira type \redtype{I^*_3} as a reduction type\par
# \begin{tikzpicture}[xscale=0.8,yscale=0.7, belowleftl/.style={below left=-4.5pt,lfnt}, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.93,0) node[mainl] {2} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,1.33)--(3.66,1.33) node[mainl] {2} node[facel] {}; \draw[l2] (2.26,0)--node[rightl] {2} (2.26,0.66); \draw[l2] (2.26,0.66)--node[belowleftl] {2} (1.6,1.33); \draw[l2end] (2.2,1.33)--node[rightl] {1} (2.2,2); \draw[l2end] (3,1.33)--node[rightl] {1} (3,2); \end{tikzpicture}
m = [2, 2]             # multiplicities of starting components Gamma_1, Gamma_2
g = [0, 0]             # their geometric genera
O = [[1, 1], [1, 1]]   # outgoing multiplicities of outer chains from each of them
L = [[1, 2, 2, 2, 3]]  # inner chains [[i,j, di,dj ,optional depth],...]
R = ReductionType(m, g, O, L)
print(R.Label())
assert R == ReductionType("I3*")    # same type from label
"""



def ReductionTypes(arg, *args, **kwargs):
  """
  ReductionTypes(g: int, [countonly=False, semistable=False, elliptic=False]) 
    All reduction types in genus g<=6 or their count (if countonly=True; faster).
    semistable=True restricts to semistable types, elliptic=True (when g=1) to Kodaira types of elliptic curves.
  ReductionTypes(S: RedShape, [countonly=False, semistable=False]) 
    Sequence of reduction types with a given shape S, again semistable if necessary, and/or their count
    If countonly=True, only return the number of types (faster).
  returns a sequence of RedType's or an integer if countonly=True
  """
  if isinstance(arg, int):
    return ReductionTypesInGenus(arg, *args, **kwargs)
  elif isinstance(arg, RedShape):
    return ReductionTypesWithShape(arg, *args, **kwargs)
  else:
    raise TypeError(f"ReductionTypes: first argument of type {type(arg)} is niether an integer (int) nor a shape (RedShape)")

"""
Test
assert str(ReductionType([1],[0],[[]],[[1,1,0,0,3]]))=="I3"
assert len(ReductionTypes(2)) == 104
assert ReductionTypes(2, countonly=True) == 104
assert len(ReductionTypes(2, semistable=True)) == 7
assert ReductionType("I3*").Label() == "I3*"
assert str(ReductionType(DualGraph([1],[1],[]))) == "Ig1"
assert len(ReductionTypes(Shape([2],[]))) == 46
"""

"""
Test
m = [1]             # Type I3
g = [0]
O = [[]]
L = [[1, 1, 0, 0, 3]]
assert ReductionType(m, g, O, L) == ReductionType("I3")
m = [6]             # Type II
g = [0]
O = [[1, 2, 3]]
L = []
assert ReductionType(m, g, O, L) == ReductionType("II")
m = [6]             # Type II*
g = [0]
O = [[5, 4, 3]]
L = []
assert ReductionType(m, g, O, L) == ReductionType("II*")
m = [3, 3, 3]         
g = [1, 2, 3]
O = [[2], [1], [1]]
L = [[1, 2, 2, 1, 1], [2, 3, 1, 1, 1], [3, 1, 1, 2, 2]]
assert ReductionType(m, g, O, L) == ReductionType("IVg3-(1)IVg2-(1)IV*g1-(2)c1")
"""

"""
Example Reduction types in a given genus
# Here are all reduction types for elliptic curves (10 Kodaira types), 
# the count for genus 2 (104 Namikawa-Ueno types) and the 
# count for semistable types in genus~3.
print(ReductionTypes(1, elliptic=True))
print(ReductionTypes(2, countonly=True))                  
print(ReductionTypes(3, semistable=True, countonly=True))
"""


"""
Example Reduction types with a given shape
# There are 1901 reduction types in genus 3, in 35 different shapes. Here is one of the more `exotic' ones, with
# 6 types in it. It has two vertices with $\chi=-3$ and $\chi=-1$ and two edges between them, with gcd 1 and 2.
S = Shape([3, 1], [[1, 2, 1, 2]])
print(S.TeX())
L = ReductionTypes(S)
print(L)
print("\\qquad".join(R.TeX(scale=1.5, forcesups=True) for R in L))
"""


class RedType:
  def __init__(self, C=None, L=None, score=None, shape=None, bestscore=None, besttrail=None):     ##
    """
    Initializes a RedType with optional parameters for principal types, inner chains, score, shape, and best paths.
    """
    self.C = C                      # array of principal types of type RedPrin, ordered in label order
    self.L = L                      # all inner chains, sorted as for label, of type List[RedChain]
    self.score = score            # score used for comparison and sorting
    self.shape = shape              # shape of R of type RedShape
    self.bestscore = bestscore    # best score from MinimumScorePaths
    self.besttrail = besttrail      # best trail  from MinimumScorePaths

  def __repr__(self):       ##
    """
    Print a reduction type through its Label.
    """
    return self.Label()

  def Chi(self):
    """
    Total Euler characteristic of R
    """
    return sum(S.Chi() for S in self)

  def Genus(self):
    """
    Total genus of R
    """
    return int((2 - self.Chi()) / 2)

  """
  Example
  R = ReductionType("III=(3)III-{2-2}II-{6-12}18g2^6,12")
  print(R.Label())      # Canonical label
  print(R.Genus())      # Total genus
  """

  def IsGood(self):
    """
    True if comes from a curve with good reduction
    """
    return len(self.C) == 1 and self.C[0].Multiplicity() == 1

  def IsSemistable(self):
    """
    True if comes from a curve with semistable reduction (all (principal) components of an mrnc model have multiplicity 1)
    """
    return max(self.Multiplicities()) == 1

  def IsSemistableTotallyToric(self):
    """
    True if comes from a curve with semistable totally toric reduction (semistable with no positive genus components)
    """
    return self.IsSemistable() and sum(self.Genera()) == 0

  def IsSemistableTotallyAbelian(self):
    """
    True if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual graph)
    """
    return self.IsSemistable() and sum(self.Genera()) == self.Genus()


  """
  Example Semistable reduction types
  semi = ReductionTypes(3, semistable=True)                 # genus 3, semistable,
  ab = [R for R in semi if R.IsSemistableTotallyAbelian()]  #   totally abelian reduction 
  print(PrintSequence(["\\cbox{$"+R.TeX()+"$}" for R in ab], sep="\\qquad ")) #> print([R.TeX() for R in ab])
  tor = [R for R in semi if R.IsSemistableTotallyToric()]
  print("\\begin{minipage}[t]{1.0\\textwidth}"+PrintSequence(["\\cbox{$"+R.TeX()+"$}" for R in tor], sep="\\quad ")+"\\end{minipage}") #> print([R.TeX() for R in tor])
  # Count semistable reduction types in genus 2,3,4,5 (OEIS A174224)
  print([ReductionTypes(n, semistable=True, countonly=True) for n in [2,3,4,5]])
  """

  def TamagawaNumber(self):
    """
    Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field
    """
    M = self.DualGraph().IntersectionMatrix()    # Intersection matrix on the dual graph
    D = DeterminantsOfMinors(M)                  #   has det=0, but we compute GCD of minors
    F = [a for row in D for a in row]            # Flatten, compute GCD and return
    return reduce(GCD, F)


  """
  Test
  assert ReductionType("III").TamagawaNumber() == 2
  assert ReductionType("III*").TamagawaNumber() == 2
  assert ReductionType("I0*").TamagawaNumber() == 4
  assert ReductionType("I1*").TamagawaNumber() == 4
  assert ReductionType("I7").TamagawaNumber() == 7
  """



  """
  Example Tamagawa numbers for reduction types of elliptic curves
  for R in ReductionTypes(1, elliptic=True): print(R, R.TamagawaNumber())
  """
  
  
  ### Invariants of individual principal components and chains


  def PrincipalTypes(self):
    """
    Principal types (vertices) of the reduction type
    """
    return self.C

  def __len__(self):
    """
    Number of principal types in reduction type
    """
    return len(self.PrincipalTypes())

  def __getitem__(self, i):
    """
    Principal type number i in the reduction type, accessed as R[i] (numbered from i=1)
    """
    if i<1 or i>len(self):
      raise ValueError(f"Principal type index should be in [1..{len(self)}]")
    return self.C[i-1]

  def __iter__(self):   ##
    """
    Create an iterator that yields each principal type in R
    """
    for i in range(1, len(self) + 1):
      yield self[i]

  def InnerChains(self):
    """
    Return all the inner chains in the reduction type
    """
    return self.L

  def EdgeChains(self) -> list:
    """
    Return all the inner chains in R between different principal components, sorted as in label.
    """
    return [e for e in self.InnerChains() if e.Class==cEdge]

  def Multiplicities(self):
    """
    Sequence of multiplicities of principal types
    """
    return [S.Multiplicity() for S in self.PrincipalTypes()]

  def Genera(self):
    """
    Sequence of geometric genera of principal types
    """
    return [S.GeometricGenus() for S in self.PrincipalTypes()]

  def GCD(self):
    """
    GCD detecting non-primitive types
    """
    return GCD([S.GCD() for S in self.PrincipalTypes()])

  def Shape(self):
    """
    The shape of the reduction type.
    """
    return self.shape

  """
  Example Principal types and chains
  # Take a reduction type that consists of smooth curves of genus 3, 2 and 1, connected
  # with two chains of $\P^1$s of depth 2.
  R = ReductionType("Ig3-(2)Ig2-(2)Ig1")
  print(R.TeX())
  # This is how we access the three principal types, their primary invariants, and the chains.
  print(R[1], R[2], R[3])   # individual principal types, same as R.PrincipalTypes() 
  print(R.Genera())         # geometric genus g of each principal type
  print(R.Multiplicities()) # multiplicity m of each principal type
  print(R.InnerChains())     # all chains between them (including loops and D-links)
  """
  
 
  ### Comparison


  def Score(self) -> list[int]:
    """
    Score of a reduction type, used for comparison and sorting
    """
    R = self
    if hasattr(R, 'score') and R.score is not None:
      return R.score
    label = R.Label(depths="original")
    R.score = [len(R), len(R.EdgeChains())] + \
       sorted([e.Weight() for e in R.EdgeChains()]) + \
       sum([R[i].Score() for i in range(1, len(R) + 1)],[]) + \
       [len(label)] + \
       list(label.encode('utf-8'))
    return R.score


  """
  Example
  R1 = ReductionType("I1g1")
  print(R1.Score())
  R2 = ReductionType("Dg1")
  print(R2.Score())
  print(R1<R2)       # I1g1<Dg1 so it precedes it in tables
  """
  

  def __eq__(self, other):
    """
    Determines if two principal types are equal based on their score.
    """
    if not isinstance(other, RedType):
      return NotImplemented
    return self.Score() == other.Score()

  def __lt__(self, other):
    """
    Compares two reduction types by their score.
    """
    if not isinstance(other, RedType):
      return NotImplemented
    return self.Score() < other.Score()

  def __gt__(self, other):
    """
    Compares two reduction types by their score.
    """
    if not isinstance(other, RedType):
      return NotImplemented
    return self.Score() > other.Score()

  def __le__(self, other):
    """
    Compares two reduction types by their score.
    """
    if not isinstance(other, RedType):
      return NotImplemented
    return self.Score() <= other.Score()

  def __ge__(self, other):
    """
    Compares two reduction types by their score.
    """
    if not isinstance(other, RedType):
      return NotImplemented
    return self.Score() >= other.Score()

  @staticmethod
  def Sort(seq):
    """
    Sorts a sequence of reduction types in ascending order based on their score.
    """
    seq.sort(key=lambda R: R.Score())

  """
  Example Sorted reduction types in genus 1 and 2
  L = ReductionTypes(1, elliptic=True)
  RedType.Sort(L)
  print(L)
  L = ReductionTypes(2)
  RedType.Sort(L)
  print(L)
  """


  ### Reduction types, labels, and dual graphs


  def DualGraph(self, compnames="default"):
    """
    Full dual graph from a reduction type, possibly with variable length edges, and optional names of components.
    Returns: GrphDual   The constructed dual graph.
    """
    return RedPrinListDualGraph(self.C, compnames=compnames)


  def EdgesScore(self, i, j): ##
    """
    Compute the score associated with edges from the ith to jth component of R.
    Used in the Label when determining the canonical minimal path.

    Parameters:
      i (int): The index of the ith component in R.
      j (int): The index of the jth component in R.

    Returns:
      list of int: The score [di, dj, depth] for edges between components i and j.
    """
    R = self
    return EdgesScore(R.InnerChains(), R[i], R[j])

  def TeXLabel(self, forcesubs=False, forcesups=False, wrap=True):   ##
    """
    TeX label of a reduction type used with the \redtype macro
    """
    R = self
    path = R.bestscore
    trail = R.besttrail

    out = ""
    for index, p in enumerate(path):
      n, _, jump = p
      i = trail[index]
      if n == 0:                                  # labels for individual components when encounter first
        out += self[i].TeXLabel()
      else: 
        out += "c" + TeXPrintParameter(n, sym="_")                               # Else print c_n
      if jump:
        out += "" if index == len(path) - 1 else "\\&"
      else:
        j = trail[index + 1]
        E = ExtractEdges(R.InnerChains(), R[i], R[j])
        edgespace = False
        for e in E:
          OLi = R[i].OuterMultiplicities() + R[i].EdgeMultiplicities()
          OLj = R[j].OuterMultiplicities() + R[j].EdgeMultiplicities()
          sym, sups, subs = EdgeDecorations(e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), False,
                                            forcesubs=forcesubs, forcesups=forcesups)
          sups = "" if not sups else "{" + "-".join(map(str, sups)) + "}"
          subs = "" if not subs else "(" + subs[0] + ")"
          sym = "\\e" if sym == "-" else "\\d"
          space = " " if len(sups) + len(subs) == 0 else ""
          out += f"{sym}{sups}{subs}{space}"
    return f"\\redtype{{{out}}}" if wrap else out

  def HTMLLabel(self, forcesubs=False, forcesups=False):          ##
    """
    HTML label of a reduction type using <span> with class for superscripts/subscripts and edges.
    """

    R = self
    path = R.bestscore
    trail = R.besttrail

    out = ""

    for index, p in enumerate(path):
      n, _, jump = p
      i = trail[index]

      if n == 0:
        out += R[i].HTMLLabel()  # label for a principal type component
      else:
        out += f"c<sub>{n}</sub>"  # c_n label

      if jump:
        if index != len(path) - 1:
          out += "&"
      else:
        j = trail[index + 1]
        E = ExtractEdges(R.InnerChains(), R[i], R[j])

        edgespace = False
        for e in E:
          OLi = R[i].OuterMultiplicities() + R[i].EdgeMultiplicities()
          OLj = R[j].OuterMultiplicities() + R[j].EdgeMultiplicities()
          sym, sups, subs = EdgeDecorations( e.mi, OLi, e.di,
            e.mj, OLj, e.dj, e.DepthString(), False, forcesubs=forcesubs, forcesups=forcesups)

          edgeclass = "edg" if sym == "-" else "edd"

          if not sups and not subs:
            if edgespace:
              out += "&thinsp;"
            out += "&ndash;" if sym == "-" else "="
            edgespace = True
          else:
            edgespace = False
            supstr = "&nbsp;" if not sups else "-".join(map(str, sups))
            substr = "&nbsp;" if not subs else str(subs[0])
            out += f"<span class='{edgeclass}'><sup>{supstr}</sup><sub>{substr}</sub></span>"

    return out

  def Label(self, tex=False, html=False, wrap=True, forcesubs=False, forcesups=False, depths="default"):
    """
    Return canonical string label of a reduction type.
      tex=True        gives a TeX-friendly label (\redtype{...}) 
      html=True       gives a HTML-friendly label (<span class='redtype'>...</span>) 
      wrap=False      keeps the format above but removes \redtype / <span> wrapping
      forcesubs=True  forces depths of chains & loops to be always printed (usually in round brackets)
      forcesups=True  forces outgoing chain multiplicities to be always printed (in curly brackets).
    depths can be "default", "original", "minimal", or a custom sequence.
    """

    R = self

    # non-default depths 
    if depths != "default":
      orgdepths = R.GetDepths()
      if depths == "original":
        R.SetOriginalDepths()
      elif depths == "minimal":
        R.SetMinimalDepths()
      elif isinstance(depths, list):
        R.SetDepths(depths)
      else:
        raise ValueError("depths is neither 'default', 'original', 'minimal' nor a sequence of strings")

      label = R.Label(tex=tex, html=html, wrap=wrap, forcesubs=forcesubs, forcesups=forcesups)
      R.SetDepths(orgdepths)
      return label

    if tex:
      return R.TeXLabel(forcesubs=forcesubs, forcesups=forcesups, wrap=wrap)
    if html:
      return R.HTMLLabel(forcesubs=forcesubs, forcesups=forcesups)

    # Extract the best score path and trail
    path = R.bestscore
    trail = R.besttrail

    out = ""

    # Traverse the path
    for index, p in enumerate(path):
      n, _, jump = p
      i = trail[index]

      # Print the principal type when first encountering vertex
      if n == 0:
        out += R[i].Label()
      else:
        out += "c" + TeXPrintParameter(n, tex=False, sym="")      # Else print cn

      # Handle jumps
      if jump:
        if index == len(path) - 1:
          out += ""
        else:
          out += "&"
      else:
        # Print edges from i to j
        j = trail[index + 1]
        E = ExtractEdges(R.InnerChains(), R[i], R[j])
        vprint(f"Extracted edges {i}-{j}: {E}")

        for e in E:
          OLi = R[i].OuterMultiplicities() + R[i].EdgeMultiplicities()
          OLj = R[j].OuterMultiplicities() + R[j].EdgeMultiplicities()

          sym, sups, subs = EdgeDecorations(e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), False,
                                            forcesubs=forcesubs, forcesups=forcesups)
          out += PrintEdge(sym, sups, subs)

    return out


  def Family(self) -> str:
    """
    Returns the reduction type label with minimal chain lengths in the same family.
    """
    return self.Label(depths="minimal")  


  """
  Example Plain and TeX labels for reduction types
  R = ReductionType("IIg1_1-(3)III-(4)IV")
  print(R.Label())            # plain text label
  R2 = ReductionType(R.Label())  
  assert R == R2              # can be used to reconstruct the type
  print(R.Family())           # family (reduction type with minimal depths) 
  print(R.Label(tex=True))    # label in TeX, wrapped in \redtype{...} macro
  print(R[1])                 # first principal type as a standalone type
  print(R.TeX())              # reduction type as a graph in TeX
  """
  
  
  """
  Example Canonical label in detail
  # Take a graph $G$ on 4 vertices
  G = Graph(4,[[1,2],[1,3],[1,4]])
  print(TeXGraph(G, labels="none"))
  # Place a component of multiplicity 1 at the root and \II, \IIIS, \IZS{} at the three leaves. Link each leaf to the root with a chain of multiplicity~1. This gives a reduction type that occurs for genus~3 curves:
  R = ReductionType("1-II&c1-III*&c1-I0*")    # First component is the root, 
  print(R.TeX())                              #   the other three are leaves
  # Here is the corresponding special fibre
  print(TeXDualGraph(R))
  # How is the following canonical label chosen among all possible labels?
  print(R)
  # Each principal component is a principal type (as there are no loops or D-links), and its primary invariants are its Euler characteristic $\chi$ and a multiset weight of gcd's of outgoing (edge) inner chains
  print([S for S in R])
  print([S.Chi() for S in R])    # add up to 2-2*genus, so genus=3
  print([S.Weight() for S in R])
  # The three leaves have $\chi=-1$, weight=$[1]$, and the root $\chi=-1$, weight=$[1,1,1]$.
  print(PrincipalTypes(-1,[1]))        # 10 such (II-, III-, IV-, ...) drawn $1^1_{(10)}$
  print(PrincipalTypes(-1,[1,1,1]))    # unique one of this type, drawn as 1
  # Together they form a shape graph $S$ as follows:
  S = R.Shape() 
  print(S.TeX(scale = 1))
  # The vertices and edges of $S$ are assigned scores. Vertex scores are $\chi$'s, edge scores are weight's
  print([GetLabel(S.Graph(),v) for v in S.Vertices()])
  print([GetLabel(S.Graph(),e) for e in S.Edges()])
  # Then the shortest path is found using MinimumScorePaths. It is v-v-v\&v-2 (v=new vertex with $\chi=-1$, -=edge, \&=jump). Note that by convention actual edges are preferred to jumps, and going to a new vertex preferred to revisiting an old one. Also vertices with smaller $\chi$ come first, if possible, as they have smaller labels.
  # \par\begin{tabular}{llllll}
  # v-v-v\&v-2 &$<$& v-v\&v-2-v && (jumps are larger than edge marks)\cr
  # v-v-v\&v-2 &$<$& v-v-v\&2-v && (repeated vertex indices are larger than vertex marks)\cr
  # \end{tabular}
  P,T = MinimumScorePaths(S)
  print(P)      # v-v-v&v-2
  # This path can be used to construct the graph, and determines it up to isomorphism. There are $|\Aut S|=6$ ways to trail $S$ in accordance with this path, and as far the shape is concerned, they are completely identical.
  print(str(T).replace(" ","")) #> print(T)
  # This gives six possible labels for our reduction type that all traverse the shape according to path $P$:
  l = lambda i: R[i].Label()
  print([f"{l(c[0])}-{l(c[1])}-{l(c[2])}&{l(c[3])}-c2" for c in T])
  # Now we assign scores to vertices and edges that characterise the actual shape components (rather than just their $\chi$) and inner chains (rather than just their weight)
  print([S.Score() for S in R])
  print(R.EdgesScore(2,1))    # score of the 1-II inner chain
  print(R.EdgesScore(2,3))    # score of the 1-I0* inner chain
  print(R.EdgesScore(2,4))    # score of the 1-III* inner chain
  # The component score R[i].Score() starts with $(\chi,m,-g,...)$ so when all components have the same $\chi$ like in this example, the ones with smaller multiplicity $m$ have smaller score. Because m(II)=6, m(III*)=4, m(I0*)=2, the trails $T[0]$ and $T[1]$ are preferred to the other four. They both start with a component \IZS, then an edge \IZS-I and a component I. After that they differ in that $T[0]$ traverses an edge 1-II and $T[1]$ an edge 1-III*. Because the edge score is smaller for $T[0]$, this is the minimal path, and it determines the label for $R$:
  print(R)
  """
  
  
  """
  Example Labels of individual principal types
  R = ReductionType("II-III-IV")
  print([S.Label() for S in R])                  # As part of R
  print([S.Label(edge=True) for S in R])        # As standalone principal types
  """
  

  def TeX(self, forcesups=False, forcesubs=False, scale=0.8, xscale=1, yscale=1, oneline=False):
    """
    TikZ representation of a reduction type, as a graph with PrincipalTypes (principal components with chi>0) as vertices, and edges for inner chains.
    oneline:=True removes line breaks. 
    forcesups:=True and/or forcesubs:=True shows edge decorations (outgoing multiplicities and/or chain depths) even when they are default.
    """
    RR = lambda v: PrintReal(v, prec=2)     # Printing reals with at most two digits after the comma

    out = "\\begin{tikzpicture}[xscale=1.2,yscale=1.2, sup/.style={midway,auto,scale=0.5}, sub/.style={sup,swap}, lrg/.style={scale=0.9,inner sep=0.1em,text depth=0.5ex,text height=1.6ex}]\n"

    nodestr = []    # Names of nodes (genus, multiplicity, subscripts, superscripts from principal type label)

    Sh = self.C     # Principal types and edges between them
    edges = {frozenset((e.Si.Index(), e.Sj.Index())) for S in Sh for e in S.EdgeChains()}
    edges = SortSetList([[e.Si.Index(),e.Sj.Index()] for e in self.InnerChains() if e.Class == cEdge])

    G = nx.Graph()
    G.add_nodes_from(list(range(1,len(Sh)+1)))
    G.add_edges_from(edges)

    # Get standard graph coordinates
    x, y = StandardGraphCoordinates(G)

    oleft = [[] for _ in Sh]

    if len(Sh) == 1:
      return self[1].Label(tex=True, wrap=True)  # Only one component, return its TeX label

    # Place nodes for principal types
    for i, S in enumerate(Sh, start=1):
      out += f"\\node[lrg] at ({RR(scale * xscale * x[i-1])},{RR(scale * yscale * y[i-1])}) ({i}) {{$ {S.Label(tex=True, wrap=True)} $}};\n"

    # Place edges
    for e0 in edges:
      p1, p2 = tuple(e0)
      dx = x[p2-1] - x[p1-1]
      dy = y[p2-1] - y[p1-1]

      # Reverse vertices and multiplicities if necessary
      if dx < 0 or (abs(dx) < abs(dy) and dy < 0):
        p1, p2 = p2, p1

      E = ExtractEdges(self.InnerChains(), self[p1], self[p2])
      bends = EdgeBends(len(E))

      for i, e in enumerate(E):
        options = []  # Bend multiple edges, add other edge options if necessary
        if bends[i] != 0:
          options.append(f"bend right={bends[i]}")

        OLi = e.Si.OuterMultiplicities() + e.Si.EdgeMultiplicities()
        OLj = e.Sj.OuterMultiplicities() + e.Sj.EdgeMultiplicities()

        sym, supinds, subinds = EdgeDecorations(
          e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), False, forcesubs=forcesubs, forcesups=forcesups
        )

        supstr = f"node [sup] {{{'-'.join(map(str, supinds))}}} " if supinds else ""
        substr = f"node [sub] {{{subinds[0]}}} " if subinds else ""
        if sym == "=":
          options.append("double")  # double distance=1pt

        optstr = f"[{','.join(options)}]" if options else ""
        out += f"\\draw ({p1}) edge{optstr} {supstr}{substr}({p2});\n"

    out += "\\end{tikzpicture}\n"

    if oneline:
      out = out.replace("\n", " ").replace("    ", " ").replace("   ", " ").replace("  ", " ")

    return out  
  """
  Example TeX for reduction types
  R = ReductionType("Ig1--I1-I1")
  print(f"\\cbox{{{R.TeX()}}}\\qquad\\cbox{{{R.TeX(forcesups=True, forcesubs=True, scale=1.5)}}}") #> print(R.TeX(),R.TeX(forcesups=True, forcesubs=True, scale=1.5))
  """
  

  """
  Example Degenerations of two elliptic curves meeting at a point
  S=ReductionType("Ig1-Ig1").Shape()    # Two elliptic curves meeting at a point (genus 2)
  # The corresponding shape is a graph v-v with two vertices with $\chi=-1$ and one edge of gcd 1
  print(S.TeX())
  print(PrincipalTypes(-1,[1]))             # There are 10 possibilities for such 
                                            #   a vertex, one for each Kodaira type
  print(ReductionTypes(S, countonly=True))  # and Binomial(10,2) such types in total
  print(ReductionTypes(S)[:10])             # first 10 of these
  """
  

  ### Variable depths in Label


  def SetDepths(self, depth):
    """
    Set depths for DualGraph and Label based on either a function or a sequence.

    If `depth` is a function, it should be of the form:
      depth(e: RedChain) -> int/str
    For example:
      lambda e: e.depth  # Original depths
      lambda e: MinimalDepth(e.mi, e.di, e.mj, e.dj)  # Minimal depths
      lambda e: f"n_{e.index}"  # Custom string-based depth

    If `depth` is a sequence, its length must match the number of inner chains in the reduction type.

    Raises:
      ValueError: If `depth` is neither a function nor a sequence or if the sequence length doesn't match.
    """
    if callable(depth):  # If it's a function
      for e in self.InnerChains():  
        e.SetDepthString(depth(e))
    elif isinstance(depth, list) or isinstance(depth, tuple):  # If it's a sequence
      if len(depth) != len(self.InnerChains()):
        raise ValueError(f"#S(={len(depth)}) <> number of edges (={len(self.InnerChains())}) for R={self}")
      self.SetDepths(lambda e: depth[e.index-1])
    else:
      raise ValueError("depth must be either a function or a sequence")

  def SetVariableDepths(self):
    """
    Set depths for DualGraph and Label to a variable depth format like 'n_i'.
    """
    self.SetDepths(lambda e: f"n_{e.index}")

  def SetOriginalDepths(self):
    """
    Remove custom depths and reset to original depths for printing in Label and other functions.
    """
    self.SetDepths(lambda e: e.depth)

  def SetMinimalDepths(self):
    """
    Set depths to minimal ones in the family for each edge.
    """
    self.SetDepths(lambda e: MinimalDepth(e.mi, e.di, e.mj, e.dj))

  def GetDepths(self):
    """
    Return the current depths (string sequence) set by SetDepths or the original ones if not changed.

    Returns:
      list: A list of depth strings for each inner chain.
    """
    return [e.DepthString() for e in self.InnerChains()]


  """
  Example Setting variable depths for drawing families
  R = ReductionType("I3-(2)I5")
  print(R.Label(tex=True))
  R.SetDepths(["a", "b", "5"])    # Make two of the three chains variable depth
  print(R.Label(tex=True))
  R.SetOriginalDepths()
  print(R.Label(tex=True))
  """


def ReductionTypesInGenus(g, semistable=False, countonly=False, elliptic=False):             ##
  """
  All reduction types in genus g<=6 or their count (if countonly=True; faster).
  semistable=True restricts to semistable types, elliptic=True (when g=1) to Kodaira types of elliptic curves.
  """
  assert g >= 1, "Genus must be at least 1"
  if g != 1 and elliptic:
    raise ValueError("elliptic=True setting can only be used in genus 1")

  if g == 1:
    if semistable:
      types = ["Ig1", "I1"]
    elif elliptic:
      types = ["Ig1", "I1", "I0*", "I1*", "IV", "IV*", "III", "III*", "II", "II*"]
    else:
      raise ValueError("Infinitely many reduction types in genus 1.")
    
    return len(types) if countonly else [ReductionType(s) for s in types]
  
  R = [ReductionTypes(S[0], semistable=semistable, countonly=countonly) for S in Shapes(g)]
  return sum(R) if countonly else sum(R, [])


def ChainParameters(mi, mj, c):   ##
  """
  Return di, dj, gcd, depth from a inner sequence [mi] + c + [mj].
  di, dj are normalized mod mi, mj, and taken from principal multiplicities if the chain is empty.
  """
  
  # di: outgoing multiplicity from P[i]
  di = mj if not c else c[0]       # If c is empty, di = mj; otherwise di = first element of c
  di %= mi                         # di mod mi
  if di == 0:
    di = mi                        # if di mod mi == 0, set di = mi
  
  # dj: outgoing multiplicity from P[j]
  dj = mi if not c else c[-1]      # If c is empty, dj = mi; otherwise dj = last element of c
  dj %= mj                         # dj mod mj
  if dj == 0:
    dj = mj                        # if dj mod mj == 0, set dj = mj
  
  # fullchain is the concatenation [mi] + c + [mj]
  fullchain = [mi] + c + [mj]
  
  # gcd of the full chain
  gcd = GCD(*fullchain)
  
  # depth of the chain
  depth = sum(1 for x in fullchain if x == gcd) - 1  # Count occurrences of gcd, subtract 1
  
  # Check minimal link depth, raise error if depth is less than the minimal allowed
  minimal_depth = MinimalDepth(mi, di, mj, dj)  # Assuming this function exists
  if depth < minimal_depth:
    raise ValueError(f"ChainParameters: Found depth {depth} < minimal allowed for m1={mi} d1={di} m2={mj} d2={dj}")
  
  return di, dj, gcd, depth


def ReductionTypeFromDualGraph(G: 'GrphDual') -> RedType:    ##
  """
  Create a reduction type from a full dual mrnc graph -- implements GrphDual.ReductionType()
  """
  
  vprint("ReductionTypeFromDualGraph: Calling G.MakeMRNC()")
  G.MakeMRNC()

  P = G.PrincipalComponents()  # Principal components (possibly with chi=0)
  Ch = G.ChainsOfP1s()         # Chains of P1s between principal components, including loops
  vprint(f"P={P} Ch={Ch}")

  # Extract multiplicities, genera, outer and inner chains for all principal components
  m = [G.Multiplicity(c) for c in P]
  g = [G.Genus(c) for c in P]

  O = [[d[2][0] for d in Ch if d[0] == v and d[1] == None] for v in P]  # Outer multiplicities, unsorted

  L = [  # Inner multiplicities (total)
      [d[2][0] for d in Ch if d[0] == v and d[1] != None and d[2]] +   # chains v-w, non-empty
      [d[2][-1] for d in Ch if d[1] == v and d[2]] +                 # chains w-v, non-empty
      [m[P.index(d[1])] for d in Ch if d[0] == v and d[1] != None and not d[2]] +  # chains v-w, empty
      [m[P.index(d[0])] for d in Ch if d[1] == v and not d[2]]       # chains w-v, empty
      for v in P
  ]
 
  Chi = [CoreChi(m[i], g[i], O[i], L[i]) for i in range(len(P))]

  for i in range(len(P)):
    vprint(f"{P[i]}: m={m[i]} g={g[i]} O={O[i]} L={L[i]} Chi={Chi[i]}") 

  TotalChi = sum(Chi)
  if TotalChi % 2 != 0:
    raise ValueError(f"Expected even Chi, got Chi={Chi} in ReductionType(GrphDual)")
    
  TotalGenus = int(1 - TotalChi / 2)

  vprint(f"TotalChi={TotalChi} TotalGenus={TotalGenus}")

  if TotalGenus == 0:
    raise ValueError("ReductionType(GrphDual): Total genus must be positive")
  if TotalGenus == 1 and not all(c == 0 for c in Chi):
    raise ValueError("ReductionType(GrphDual): Expected all principal components to have chi=0 in genus 1")

    # Set indices of components that will enter the reduction type
  if TotalGenus == 1:
    PCInd = [0]  # In genus 1, take any one principal component
  else:
    PCInd = [i for i in range(len(P)) if Chi[i] < 0]  # In genus > 1, take all with chi < 0

  vprint(f"PCInd={PCInd}")

  # Create initial principal types in R
  C = [RedPrin.NewPrincipalType(m[c], g[c], index=i) for i, c in enumerate(PCInd)]

  # Add outer chains
  for i, c in enumerate(PCInd):
    for o in O[c]:
      C[i].AddOuterMultiplicity(o)
  
  index = 0                     # Inner chain index to store (to be sorted later)
  for chain in Ch:
    v1, v2, c = chain
    if v2 == None:
      continue                  # outer chains already created
      
    index += 1
    i = P.index(v1)
    j = P.index(v2)
    mi = m[i]
    mj = m[j]

    di, dj, gcd, depth = ChainParameters(mi, mj, c)
    pci = PCInd.index(i) if i in PCInd else None
    pcj = PCInd.index(j) if j in PCInd else None

    if pci == pcj:
      C[pci].AddInnerMultiplicitiesAndLoop(di, dj, depth=depth, index=index)  # Add loop
    elif pci is None:
      if not (mi == GCD(mj, dj)) and mi % 2 == 0 and O[i] == [mi // 2, mi // 2]:
        raise ValueError(f"Invalid D-link parameters m1={mj} d1={dj} m2={mi} d2={di} depth={depth}")
      C[pcj].AddInnerMultiplicityAndDLink(dj, depth=depth, index=index)  # Add D-link
    elif pcj is None:
      if not (mj == GCD(mi, di)) and mj % 2 == 0 and O[j] == [mj // 2, mj // 2]:
        raise ValueError(f"Invalid D-link parameters m1={mi} d1={di} m2={mj} d2={dj} depth={depth}")
      C[pci].AddInnerMultiplicityAndDLink(di, depth=depth, index=index)
    else:
      C[pci].AddInnerMultiplicityAndChain(C[pcj], di, dj, depth=depth, index=index)  # Add inner chain

  for i in range(len(C)):
    C[i].Finalize()                     # Compute cores, gcd, and sort chains

  vprint(f"Indices of principal types: {PCInd}")
  vprint(f"Principal types: {C}")
  vprint(f"Chains:")
  for S in C:
    vprint(S)
    for ch in S.Chains():
      vprint(ch)

  return RedPrinListToReductionType(C)


def RedPrinListToShape(C):                        ##
  """
  Construct a shape from a sequence C of principal types, provided all inner chains between them have been created.
  As a second parameter, returns the sequence of all inner chains in C, including loops and D-links. 
  Parameters:
    C (list of RedPrin): A sequence of principal types.
  """
  if not C:
    raise ValueError("Shape: Array of principal types cannot be empty")

  
  SV = [-S.Chi() for S in C]     # Construct shape: vertices SV, decorated with -chi
  SE = []                        # edges SE for inner chains of class cEdge
  E  = []                        # concatenated chains (loops, D-links, etc.)

  # Gather all chains of class cLoop and cD
  E = sum([S.Loops() + S.DLinks() for S in C], [])

  # Gather edges from inner chains of class cEdge
  for i in range(1, len(C)):
    for j in range(i + 1, len(C)+1):
      edge = [i, j]
      for e in C[i-1].EdgeChains():
        # vprint(">",e,e.Sj.index,C[j-1].index)
        if e.Sj.index == C[j-1].index:                 # Check if chain is between C[i] and C[j]
          edge.append(e.Weight())
          E.append(e)
      if len(edge) > 2:                                # Ensure the edge contains GCD (i.e., an actual link)
        SE.append(edge)

  # Construct the shape using SV and SE
  shape = Shape(SV, SE)
  
  vprint(f"Shape: {shape}")

  return shape, E


def ExtractEdges(E, S1, S2):                   ##
  """
  Given an array E of reduction type edges [[i, mi, di, j, mj, dj, depth,...] (RedChain),...],
  extract those from component S1 to S2 as [di, dj, depth], sorted in a standard way.
  
  Parameters:
    E (list of RedChain): A list of reduction type edges.
    S1 (RedPrin): The first principal component.
    S2 (RedPrin): The second principal component.
    
  Returns:
    list of RedChain: A sorted list of edges [di, dj, depth] from S1 to S2.
  """
  # Extract chains from S1 to S2
  L = [e for e in S1.EdgeChains() if e.Sj.index == S2.index]
  
  # Sort by di, dj, depth and return
  return sorted(L, key=lambda e: [e.di, e.dj, e.depth])


def EdgesScore(E, Si, Sj):           ##
  """
  Compute the score associated with edges between components Si and Sj from a sequence of edges E.
  Used in the Label when determining the canonical minimal path.
  
  Parameters:
    E (list of RedChain): A sequence of edges (RedChains).
    Si (RedPrin): The ith principal component.
    Sj (RedPrin): The jth principal component.
    
  Returns:
    list of int: The score [di, dj, depth] for edges from Si to Sj.
  """
  return sum([[e.di, e.dj, e.depth] for e in ExtractEdges(E, Si, Sj)], [])


def RedPrinListToReductionType(C):     ##
  """
  Construct a reduction type from a sequence C of principal types, provided all inner chains 
  between them are complete. Computes the best path (for label) and initializes all indices.
  
  Parameters:
    C (list of RedPrin): Sequence of principal types.
    
  Returns:
    RedType: The computed reduction type.
  """

  # Assign indices
  for i in range(len(C)):
    C[i].index = i + 1                      # Indexing starts from 1

  # Consistency checks
  indices = {S.index for S in C}
  if len(indices) != len(C):
    raise ValueError(f"ReductionType(C): repeated principal types in C={C} ind={indices}")
  
  for i, S in enumerate(C):
    for c in S.Chains():
      if c.Si.index != i + 1:
        raise ValueError(f"ReductionType(C): chain c={c} on C[{i}]={C[i]} has component index {c.Si.index}!={i + 1}")

  shape, E = RedPrinListToShape(C)
  
  P, T = MinimumScorePaths(shape)         # Minimum shape path score, and possible trails (Aut(shape) torsor)
  VW = [S.Score() for S in C]                               # Vertex scores
  EW = [[[EdgesScore(E, Si, Sj)] for Si in C] for Sj in C]  # Edge scores

  vprint(f"P={P}\nT={T}\nVW={VW}\nEW={EW}")

  VO = PreferenceOrder(range(1, len(VW) + 1), lambda i: VW[i - 1])
  EO = PreferenceOrder2(EW, lambda x: x)

  vprint(f"VO={VO}")
  vprint(f"EO={EO}")

  prindices = [i for i, w in enumerate(P,start=1) if all(x <= 0 for x in w[1])]

  zeroes = 0
  zerocount = []
  for i, d in enumerate(P,start=1):
    if d[0] == 0 and i in prindices:
      zeroes += 1
    zerocount.append(zeroes)

  MinW = [P[i-1] for i in prindices]       # Non-negative labels correspond to actual vertices of R
  MinW = [(0 if d[0] == 0 else zerocount[d[0] - 1], d[1], d[2]) for d in MinW]

  infwt = max([S.Multiplicity() for S in C]) + 1  # Dominates all edge scores

  vprint(f"prindices={prindices} zerocount={zerocount} MinW={MinW}")
 
  bestscore = []
  for fulltrail in T:
    trail = [fulltrail[i-1] for i in prindices]
    score = []
    for step, i in enumerate(trail,start=1):
      index, _, jump = MinW[step-1]

      if index != 0:
        score.append(0)  # Repeated vertex score
      else:
        score.append(VO[i-1])
      
      if not jump:  # Edges score
        vprint(f"i={i} step={step} trail={trail}")
        score.append(EO[i-1][trail[step]-1])
      else:
        score.append(infwt)
      
      sgn = ScoreIsSmaller(score, bestscore)
      if sgn == ">":             # Worse, abandon
        break
      if sgn in ["<", "l"]:      # Better or longer
        vprint(f"{trail} -> {score} {sgn} {bestscore}")
        bestscore = score
        besttrail = trail

  vprint(f"besttrail {besttrail}")
  vprint(f"bestscore {bestscore}")
  vprint(f"Shape(R):\nW ={P}\ntr={besttrail}\nwt={bestscore}")

  NewC = []  # Reordered list of principal types, following best trail
  NewE = []  # Reordered list of edges

  PermuteC = [-1 for i in range(len(besttrail))]

  for step, i in enumerate(besttrail,start=1):
    index, _, jump = MinW[step-1]
    if index == 0:  # New vertex i
      NewC.append(C[i-1])
      C[i-1].index = i
      PermuteC[i-1] = len(NewC)
      NewE += C[i-1].Loops()
      NewE += C[i-1].DLinks()
      vprint(f"({step}) component {i}")
    
    if jump:
      continue
    
    j = besttrail[step]
    vprint(f"({step}) edges {i}-{j}")
    NewE += ExtractEdges(E, C[i-1], C[j-1])

  for i in range(1, len(C)+1):     # Change components order
    NewC[i-1].index = i
  for i in range(1, len(NewE)+1):  # Change edges order
    NewE[i-1].index = i

  # Sanity checks
  if len(C) != len(NewC):
    raise ValueError(f"Mismatched number of components after reordering: C={C} NewC={NewC}")
  if len(E) != len(NewE):
    raise ValueError(f"Mismatched number of edges after reordering: E={E} NewE={NewE}")

  vprint(f"C={C} -> NewC={NewC} (permuteC={PermuteC})")

  newshape, _ = RedPrinListToShape(NewC)
  besttrail = [PermuteC[i-1] for i in besttrail]
  if besttrail[0] != 1:
    raise ValueError(f"Expected recoded besttrail in R to start with 1: {besttrail}")

  R = RedType(C=NewC, L=NewE, shape=newshape, bestscore=MinW, besttrail=besttrail)
  R.SetOriginalDepths()
  return R


def PrintEdge(sym, sups, subs):                 ##
  sups_str = "" if not sups else "{" + "-".join(map(str, sups)) + "}"
  subs_str = "" if not subs else f"({subs[0]})"
  return f"{sym}{sups_str}{subs_str}"


def AddInnerChain(m, g, E, e, i, j):                  ##
  """
  Add an inner chain between vertices i and j to the multiplicity, genus, and edge lists.
  m : list        List of multiplicities.
  g : list        List of genera.
  E : list        List of edges.
  e : RedChain    The inner chain (containing mi, di, mj, dj, depth, etc.).
  i : int         Starting vertex index.
  j : int         Ending vertex index.
  """
  L = InnerSequence(e.mi, e.di, e.mj, e.dj, e.depth)  
  vprint(f"inner chain v{i}:{e.mi},{e.di} -({e.depth}) v{j}:{e.mj},{e.dj} -> {L}")
 
  assert L[0] == e.mi and L[-1] == e.mj, "Invalid inner sequence."
  
  for k in range(len(L)):     # Iterate through the inner sequence and construct the chain
    if k == 0:                  # Start the chain, don't create vertices
      prev = i
    elif k == len(L) - 1:       # Finish the chain, don't create vertices
      E.append([prev, j])
    else:                       # Create a new vertex
      m.append(L[k])            # Add multiplicity
      g.append(0)               # Genus is 0
      E.append([prev, len(m)])  # Link it to the previous one
      prev = len(m)

def AddOuterChain(m, g, E, i, mi, di):                     ##
  """
  Add an outer chain starting from vertex i to the multiplicity, genus, and edge lists.
  m  : list       List of multiplicities.
  g  : list       List of genera.
  E  : list       List of edges.
  i  : int        Starting vertex index.
  mi : int        Initial principal multiplicity.
  di : int        Initial outgoing multiplicity.
  """
  O = OuterSequence(mi, di)  # Generate the outer sequence
  # print(f"outer chain v{i}:{mi},{di} -> {O}")
  assert O[0] == mi and O[-1] == GCD(*O), "Invalid outer sequence."
 
  for k in range(len(O)):              # Iterate through the outer sequence and construct the chain
    if k == 0:                            # Start the chain, don't create vertices
      prev = i
    else:                                 # Create a new vertex
      m.append(O[k])                      # Add multiplicity
      g.append(0)                         # Genus is 0
      E.append([prev, len(m)])            # Link it to the previous one
      prev = len(m)

def VariableChain(e):                   ##
  """
  Return a variable chain with depth annotations for the link.

  e : RedChain       An inner chain
  Returns
  A list representing the chain with depth annotations.
  """
  L = InnerSequence(e.mi, e.di, e.mj, e.dj, 2)  # Generate the inner sequence
  L = L[1:-1]                                  #   with first and last element 

  # Determine the shift based on multiplicities and di,di
  shift = 1 - (1 if e.mi == e.di else 0) - (1 if e.mj == e.dj else 0)
  
  # Special case for loops
  if e.Class == cLoop and e.mi == e.di and e.mj == e.dj:
    shift = 0

  # Create the shift string
  if shift == 0:
    shiftstr = ""
  elif shift == 1:
    shiftstr = "\\!+\\!1"
  else:
    shiftstr = "\\!-\\!1"

  depth = f"${e.DepthString()}{shiftstr}$"

  gcd = e.Weight()
  p = L.index(gcd)
  assert p >= 0, "GCD not found in the inner sequence."

  # Split the sequence into head, gcd's, and tail
  Lhead = L[:p]
  Ltail = [d for d in L[p:] if d != gcd]
  
  # Return the formatted chain with the depth annotation at the GCD position
  return [*Lhead, (gcd, depth), *Ltail]


def RedPrinListLinks(C):        ##
  """
  All inner chains within a list of principal types, including loops and D-links. 
  Parameters:
  C : list[RedPrin]    List of principal types  
  Returns:
  list[RedChain]       A list of all inner chains (RedChain) between the principal types.
  """

  E = []                 # Initialize an empty list to store inner chains
  for S in C:
    E.extend(S.Loops())   # all loops
    E.extend(S.DLinks())  # and D-links -> E

  for i in range(len(C) - 1):                # Iterate over all pairs of distinct principal types (i < j)
    for j in range(i + 1, len(C)):
      for e in C[i].EdgeChains():                # Collect all edges for principal type C[i]
        if e.Sj.index == C[j].index:              # If the index of the Sj principal type matches C[j]'s index
          E.append(e)

  return E


def RedPrinListDualGraph(C, compnames="default"):    ##
  """
  Construct a dual graph from a sequence C of principal types (RedPrin) with all links initialized.
  compnames is a name prefix for components, e.g. "\\Gamma_" or "" (default is "default").
  Returns the constructed dual graph.
  """
  indices = [S.index for S in C]
  # Check if indices are complete
  if indices != list(range(1, len(C) + 1)):
    raise ValueError(f"DualGraph(C): indices {indices} are incomplete for C={C}")

  m = [S.Multiplicity() for S in C]    # Multiplicities of principal types
  g = [S.GeometricGenus() for S in C]  # Genera of principal types
  GE = []                              # Full list of chains, outer and link

  for i, S in enumerate(C, start=1):       # Outer chains from all principal types
    for d in S.OuterMultiplicities():
      AddOuterChain(m, g, GE, i, S.Multiplicity(), d)

  VarChains = []
  for e in RedPrinListLinks(C):  # Links C[i] -> C[j], and loops & D-links
    i = e.Si.Index()
    if e.Class in [cLoop, cEdge]:
      j = e.Sj.Index()
    if e.Class == cD:    # D-link -> create target component
      m.append(e.mj)     #   Add multiplicity
      g.append(0)        #   Add genus
      j = len(m)         #   Set index
      AddOuterChain(m, g, GE, j, e.mj, e.mj // 2)  # Add its outer chains
      AddOuterChain(m, g, GE, j, e.mj, e.mj // 2)

    if e.DepthString() != str(e.depth):
      VarChains.append((i, j, VariableChain(e)))  # Variable length chain
    else:
      AddInnerChain(m, g, GE, e, i, j)  # Regular inner chain

  if compnames == "default":
    compnames = "\\Gamma_"
  if isinstance(compnames, str):    # TeX names of principal components  
    compnames = [f"${TeXPrintParameter(i, tex=True, sym=compnames)}$" for i in range(1, len(C) + 1)] + [""] * (len(m) - len(C))  

  G = DualGraph(m, g, GE, comptexnames=compnames)
  for chain in VarChains:
    i, j, mults = chain
    AddVariableChain(G, Sprint(i), Sprint(j), mults)

  return G


def _AddEdge(Class, S1, d1, S2, d2, n, sym):    ##
  """
  Add an edge to the graph defined by principal types S1 and S2.

  Parameters:
  Class : str         Class of the edge (cLoop, cD, cEdge).
  S1, S2 : RedPrin          Principal types between which the edge is to be added.
  d1, d2 : int or bool      Initial chain multiplicities; can be set to False.
  n : int  of bool          Depth of the edge.
  sym : str                 Edge symbol ("-=" or "=").
  """
  vprint(f"_AddEdge [{Class}] S1={S1} d1={d1} S2={S2} d2={d2} n={n} sym={sym}\n")
  
  def1 = (d1 is False)       # Symbol "=" -> set d1, d2 to mi, mj
  def2 = (d2 is False)       # d1=d2=False -> set d1, d2 to minimal edge multiplicities
  if def1 != def2 and Class != cD:
    raise ValueError(f"_AddEdge: d1={d1} d2={d2} is not a valid option")

  if sym == "=":
    d1, d2 = S1.m, S2.m
  elif def1:
    A1 = S1.OuterMultiplicities() + S1.EdgeMultiplicities()
    A2 = S2.OuterMultiplicities() + S2.EdgeMultiplicities()
    d1, d2 = DefaultMultiplicities(S1.m, A1, S2.m, A2, S1.index == S2.index)

  if Class == cLoop:
    S1.AddInnerMultiplicitiesAndLoop(d1, d2, depth=n)
  elif Class == cD:
    S1.AddInnerMultiplicityAndDLink(d1, depth=n)
  elif Class == cEdge:
    S1.AddInnerMultiplicityAndChain(S2, d1, d2, depth=n)
  else:
    raise ValueError(f"AddEdge: Class({Class}) should be cLoop=cLoop, cD=cD or cEdge=cEdge")

  if S1.C[-1].di in S1.O:
    S1.O.remove(S1.C[-1].di)     # Remove di from outer multiplicities S1.O
  
  if Class in [cLoop, cEdge] and S1.C[-1].dj in S2.O:
    S2.O.remove(S1.C[-1].dj)     # Remove dj

  vprint (f"Added edge {S1.C[-1]}\n")                


def ReductionTypeFromLabel(S: str) -> RedType:     ##
  """
  Construct a reduction type from its label
  """
  tComp, tEdge, tLoop, tName, tMult, tInt, tcComp, tGenus, tEdgeSym, tEdgeMult, tEdgeLen, \
    tSup, tUnderline, tAmp, tComma, tOther = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

  # print(f"ReductionType: S={S}")

  S = S.replace("_-1","_(-1)").replace(",-1",",(-1)")

  T = StringSplit(S, [
    (tName, r"([IVDT]+[IVDT*0-9]*)"),
    (tMult, r"\[([0-9]+)\]"),
    (tInt, r"([0-9]+)"),
    (tcComp, r"c([0-9]+)"),
    (tGenus, r"_?g([0-9]+)"),
    (tEdgeSym, r"([-=<>])"),
    (tEdgeMult, r"\{([0-9-]+)\}"),
    (tEdgeLen, r"\((-?[0-9]+)\)"),
    (tSup, r"[/^]([0-9,]+)"),
    (tUnderline, r"(_)"),
    (tAmp, r"(&)"),
    (tComma, r"(,)"),
    (tOther, r"(.)")
  ])

  vprint(f"Initial tokens {S}:\n{T}")

  subscript = False
  i = 0
  while i < len(T):
    t, s = T[i]
    if t == tUnderline:
      subscript = True
    if t in [tEdgeSym, tAmp]:
      subscript = False
    if t == tName:
      m = re.match(r"^I([0-9]+)([*]?)$", s)
      ok = m is not None
      B = m.groups() if ok else []

      if ok and B[0] != "0":
        if B[1] == "":
          T = T[:i] + [[tComp, False, 1, False, []], [tLoop, False, False, int(B[0])]] + T[i+1:]
        else:
          d = T[i-1][1] if i > 0 and T[i-1][0] == tComp and T[i-1][1] else 1
          T = T[:i] + [[tComp, False, 2, False, [1, 1]], [tLoop, "D", [2 * d], int(B[0])]] + T[i+1:]
        i += 2

        # Handle subscripts (underline, comma, genus)
        subscript = i < len(T) and T[i][0] in [tUnderline, tComma, tGenus]
        if subscript and T[i][0] != tGenus:
          T[i] = [tComma, ","]
          if T[i+1][0] in [tComma, tEdgeSym]:
            T.pop(i)
        if subscript and len(T) > i+1 and T[i][0] == tGenus and T[i+1][0] == tUnderline:
          T[i+1] = [tComma, ","]
        continue
      elif not any(D for D in StandardCoreNames if D[2] == s):
        raise ValueError(f"Component name {s} not recognised in {S}")
      if subscript:
        if s != "D":
            raise ValueError(f"Expected an edge: {s} in {S}")
        T[i] = [tLoop, "D", False, False]
      else:
        D = next(D for D in StandardCoreNames if D[2] == s)
        T[i] = [tComp, False, D[0], False, [d for d in D[1]]]
    elif t == tMult:
      T[i] = [tComp, int(s), False, False, False]
    elif t == tGenus:
        T[i] = [tComp, False, False, int(s), False]
    elif t == tSup:
        T[i] = [tComp, False, False, False, [int(d) for d in s.split(",")]]
    elif t == tInt:
        if subscript:
            T[i] = [tLoop, False, False, int(s)]
        else:
            T[i] = [tComp, False, int(s), False, False]
    elif t == tEdgeSym:
        T[i] = [tEdge, s, False, False]
    elif t == tEdgeMult:
        T[i] = [tLoop if subscript else tEdge, False, [int(d) for d in s.split("-")], False]
    elif t == tEdgeLen:
        T[i] = [tLoop if subscript else tEdge, False, False, int(s)]
    elif t == tAmp:
        pass
    elif t == tcComp:
        T[i] = [tcComp, int(s)]
    elif t == tComma:
        if not subscript:
            raise ValueError(f"',' not in subscript in {S}\nTokens:\n{[DelCRs(t) for t in T]}")
    elif t == tOther:
        raise ValueError(f"Unexpected symbol {s} in {S}")
    i += 1

  vprint(f"Tokens after splitting [*tComp=1,mult,m,g,sups*][*tEdge=2,sym,mults,len*][*tLoop=3,sym,mults,len*]:\n{T}")

  for i in range(len(T) - 2, -1, -1):
      if T[i][0] == tLoop and T[i+1][0] == tComp and T[i+1][3]:
          T[i], T[i+1] = T[i+1], T[i]

  vprint(f"Tokens after swapping:\n{T}")

  # Group components, edges, and loops tokens from adjacent ones of the same type
  for i in range(len(T) - 1, -1, -1):
    if T[i][0] in [tComma, tAmp, tUnderline]:
        continue
    if i == len(T) - 1 or T[i][0] != T[i+1][0]:
        continue
    if T[i][0] == tEdge and T[i+1][1]:
        continue
    # Cannot merge if two of these have non-False in some jth entry (except for j=0)
    if len(T[i]) != len(T[i+1]) or any(T[i][j] and T[i+1][j] for j in range(1, len(T[i]))):
        raise ValueError(f"Could not merge data (duplicate information) in {DelCRs(T[i])} and {DelCRs(T[i+1])} in {S}")
    T[i] = [d if d else T[i+1][j] for j, d in enumerate(T[i])]    # merge and 
    T.pop(i+1)                                                    # remove one of the two

  vprint(f"Tokens after merging:\n{T}")

  # Remove symbols '_' '&' ',' assuming they were placed correctly as we won't need them anymore  
  if not T or T[0][0] != tComp:
      raise ValueError("Reduction type name must start with a component")
  if any((t[0] == tUnderline) and ((i == 0) or (T[i-1][0] != tComp) or (i == len(T) - 1) or (T[i+1][0] != tLoop)) for i, t in enumerate(T)):
      raise ValueError(f"Symbol _ must separate a component and a loop in {S}")
  if any((t[0] == tComma) and ((i == 0) or (T[i-1][0] != tLoop) or (i == len(T) - 1) or (T[i+1][0] != tLoop)) for i, t in enumerate(T)):
      raise ValueError(f"Symbol , must separate two loops in {S}")
  if any((t[0] == tAmp) and ((i == 0) or (T[i-1][0] not in [tcComp, tComp, tLoop]) or (i == len(T) - 1) or (T[i+1][0] not in [tcComp, tComp])) for i, t in enumerate(T)):
      raise ValueError(f"Symbol & must separate two components in {S}")
  T = [t for t in T if t[0] not in [tComma, tUnderline]]

  vprint(f"Collected tokens:\n{T}")

  V = []   # principal components

  vprint(f"Have {len([d for d in T if d[0]==tComp])} main components")

  i = 0
  while True:
    i += 1
    if i > len(T):
      break
    d = T[i-1]
    if d[0] == tcComp and d[1] > len(V):
      raise ValueError(f"Component c{d[1]} has not been defined yet")
    if d[0] != tComp:
      continue

    _, cgcd, m, g, O = d
    if cgcd is False:     cgcd = 1  # default: multiplicity = 1
    if m is False:        m = 1     #          m = 1
    if g is False:        g = 0     #          g = 0
    if O is False:        O = []    #          O = []

    m = cgcd * m  # multiply by cgcd
    O = [cgcd * o for o in O]

    S = RedPrin.NewPrincipalType(m,g,O=O,index=len(V)+1)    # Create new principal type S, add to V
    V.append(S)

    T[i-1] = [tcComp, len(V)]                               # replace token by "seen before"

    while (i < len(T)) and (T[i][0] == tLoop):              # Process loops and D-tails belonging to this component
      vprint(f"Processing loop/D-tail for c{len(V)} at i={i}")
      _, sym, mult, length = T[i]

      if mult is False:
        mult = []  # Set mult to an empty list if it is False

      # *** D-tail ***
      if sym == "D":
        if mult is not False and len(mult) > 1:
          raise ValueError("D-tail in a subscript must have <=1 edge multiplicity")
        if m%2 == 1:
          raise ValueError(f"Component of odd multiplicity {Sprint(m)} cannot have a D-tail")

        if not mult: 
          I = [d for d in S.OuterMultiplicities() if d%2==0]     
          SortMultiplicities(m, I)
          l = m if not I else I[0]                                  # Use m or the smallest even multiplicity
        else:
          r = mult[0] % m  
          l = m if r == 0 else r  
          if l % 2 == 1:
            raise ValueError(f"Cannot use odd multiplicity {Sprint(l)} to use in a D-tail")
          if (l not in S.OuterMultiplicities()) and (l != m):
            raise ValueError(f"Have no available multiplicity {Sprint(l)} to use in a D-tail")

        _AddEdge(cD, S, l, False, False, length, "-")  # _AddEdge: add D-link

      else:  # *** loop ***
        if mult is not False and len(mult) not in [0, 2]:
          return False, "Loop must have zero or two edge multiplicities"

        if mult is not False and len(mult) == 2:
          d1, d2 = mult
        else:
          d1, d2 = False, False  # Set both to False if not specified

        _AddEdge(cLoop, S, d1, S, d2, length, "-")  # _AddEdge: add loop

      T.pop(i)     # Remove the processed element from T

  vprint(f"After processing loops:\n{T}")

  # EDGES BETWEEN DIFFERENT COMPONENTS

  done_edges = set()  # Initialize a set to track defined edges

  for i, d in enumerate(T):  # PRINCIPAL COMPONENTS, LOOPS AND D-TAILS
    if (d[0] != tcComp) or (i == len(T) - 1):
      continue  # Skip if not a component or the last element

    if d[1] not in range(1, len(V) + 1):
      raise ValueError(f"Invalid component reference {Sprint(d[1])} in {S}")

    j = next((j for j in range(i + 1, len(T)) if T[j][0] == tcComp), None)
    if j is None:
      raise ValueError(f"Could not find a component terminating the edge in {S}")

    if j == i + 1:
      raise ValueError(f"No edges specified between two components in {S}")

    if j == i + 2 and T[i + 1][0] == tAmp:
      continue  # Skip if the next element is an amplitude

    if not all(T[k][0] == tEdge for k in range(i + 1, j)):
      raise ValueError(f"Unrecognized non-edge tokens between two components in {S}")

    i1 = T[i][1]  # Indices in V of the two principal components
    i2 = T[j][1]

    if {i1, i2} in done_edges:
      raise ValueError(f"Edges c{i1}-c{i2} have already been defined in {S}")

    if i1 == i2:
      raise ValueError("Loops have to be specified in subscripts, not as edges in {S}")

    done_edges.add((i1, i2))  # Track defined edges

    for k in range(i + 1, j):  # Process edges one by one
      _, sym, mult, length = T[k] 

      d1, d2 = False, False  # Default values
      if mult is not False and sym == "-":
        if len(mult) != 2:
          raise ValueError(f"Edge - can only have two inner multiplicities in {S}")

      if mult is not False and sym == "=":
        raise ValueError(f"Edge = can have no inner multiplicities in {S}")

      if mult is not False and len(mult) == 2:
        d1, d2 = mult  # Unpack multiplicities if specified

      _AddEdge(cEdge, V[i1-1], d1, V[i2-1], d2, length, sym)        # _AddEdge: link edge between different components

  if not V:
    raise ValueError(f"No principal components in reduction type string {S}")

  for S in V:         # Finalize each component
    S.Finalize()

  vprint("Done V:", [S.Label() for S in V])     

  chi = [S.Chi() for S in V]                           # Euler characteristics of principal types

  if max(chi) > 0:
    raise ValueError("Have a component with chi>0 - not a valid reduction type")

  if max(chi) < 0:                       # Good as is
    return RedPrinListToReductionType(V)
  else:                                  # May have edge D-links like [2]_D,D or [2]T_D,D, convert to a dual graph and return
    return RedPrinListDualGraph(V).ReductionType() 


def LinkOrderings(L, m, gcds):         ##
  """
  Given a multiset of links L, select all possible orderings sorted by gcd with m.
  """
  assert len(L) == len(gcds)

  # Case where the sets of L and gcds match
  if set(L) == set(gcds):
    return [sorted(L, key=lambda a: GCD(a, m))]  # Sort by GCD with m

  # Generate Cartesian product of all permutations grouped by gcd with m
  result = []
  for c in product(*[list(permutations([d for d in L if GCD(d, m) == g])) for g in sorted(set(gcds))]):
    result.append([item for sublist in c for item in sublist])  # Flatten list
  return result


def IncludeAssocIfNotIsomorphic(A, key, data, iso):   ##
  """
  Given a dictionary A, look for A[key]:
  - If A[key] does not exist, set A[key] = [data] and return.
  - If A[key] exists, append data to the list A[key] unless there is an element data0 in A[key]
    such that iso(data0, data) = True.
  Args:
    A (dict): The associative array (dictionary).
    key: The key to check in the dictionary.
    data: The data to append if no isomorphic element exists.
    iso (function): A function iso(data0, data) that returns True if data0 and data are isomorphic.
  """
  if key not in A:   
    A[key] = [data]       # If key does not exists, create, add data and return
    return
  for data0 in A[key]:    # If key exists, check for isomorphism
    if iso(data0, data):  
      return
  A[key].append(data)     # If no isomorphic element was found, append the new data


def MergeEdgeEndpoints(Si, di, Sj, dj, depth=False, index=False):         ##
  """
  Merge two edge endpoints.
  """
  i1 = next((i for i, e in enumerate(Si.C) if e.Class == cEdge and e.di == di and e.Sj is False), None)
  if i1 is None:
    raise ValueError(f"Could not find a edge endpoint in {Si} of multiplicity {di}")
  
  i2 = next((i for i, e in enumerate(Sj.C) if e.Class == cEdge and e.di == dj and e.Sj is False), None)
  if i2 is None:
    raise ValueError(f"Could not find a edge endpoint in {Sj} of multiplicity {dj}")

  if GCD(Si.m, di) != GCD(Sj.m, dj):
    raise ValueError(f"GCD({Si.m}, {di}) != GCD({Sj.m}, {dj})")
  
  e = Si.C[i1]
  e.Sj = Sj
  e.mj = Sj.m
  e.dj = dj
  e.SetDepth(depth)
  e.index = index
  Sj.C[i2] = e.Reverse()


def ReductionTypesWithShape(S, countonly=False, semistable=False):      ##
  """
  Sequence of reduction types with a given shape S.
  If countonly=True, only return the number of types.
  """

  vprint("ReductionTypesWithShape:",S)

  gr_iso = lambda G,H: nx.is_isomorphic(G, H, node_match=lambda x, y: x['label'] == y['label'])

  V = S.VertexLabels()                        # Sequence of vertex labels
  E = S.EdgeLabels()                          # List of edges [i, j, -gcd], total NE
  NE = sum(len(e) - 2 for e in E)             # Total number of edges

  weights = [S.Weights(v) for v in S.Vertices()]  # List of weight multisets for each vertex

  if semistable and any(weight and max(weight) != 1 for weight in weights):         # Semistable case: all weight values should be 1
    return 0 if countonly else []

  DG = Graph(len(V) + 2 * NE)                # Double graph with extra edges
  VA = [[] for _ in V]                       # Vertex assignments: [link index, vertex index]
  ei = 0                                     #   for every principal vertex

  for e in E:                                # Construct the edges of DG
    i, j = e[0], e[1]
    for gcd_val in e[2:]:
      ei += 1
      DG.add_edge(i, len(V) + ei)
      DG.add_edge(len(V) + ei, len(V) + NE + ei)
      DG.add_edge(len(V) + NE + ei, j)

      pi = weights[i-1].index(gcd_val)           
      while any(d[0] == pi for d in VA[i-1]):
        pi += 1
      VA[i-1].append([pi, len(V) + ei])

      pj = weights[j-1].index(gcd_val)
      while any(d[0] == pj for d in VA[j-1]):
        pj += 1
      VA[j-1].append([pj, len(V) + NE + ei])

  vprint(f"DG: V={DG.nodes} E={DG.edges}")

  for i in range(len(V)):
    VA[i].sort()                          # Sort VA by link index

  VA = [[d[1] for d in v] for v in VA]    # Recoding VA to a sequence of vertex indices

  vprint(f"VA: {VA}")

  done = []                               # Store already seen <chi, weight>
  C = [[] for _ in range(len(V))]
  UsedShapeComps = []

  for i in range(len(V)):
    chi = -V[i]
    weight = weights[i]
    p = next((index for index, d in enumerate(done) if d == (chi, weight)), -1)
    # vprint(f"i={i} p={p}")

    if p>-1:
      C[i] = C[p]
      done.append(done[p])
      continue

    done.append((chi, weight))
    A = PrincipalTypes(chi, weight, semistable=semistable)

    vprint(f"chi={chi} weight={weight} #A={len(A)}")

    for c in A:
      UsedShapeComps.append(c)
      for links in LinkOrderings(c.EdgeMultiplicities(), c.Multiplicity(), weight):
        C[i].append((len(UsedShapeComps), links))
  
  vprint(f"UsedShapeComps: {UsedShapeComps}")
  vprint(f"C (#C={len(C)}: {C}")

  graphs = {}                   # Associative array shcompindices -> double graph
  for vdata in product(*C):
    D = DG.copy()  # Copy the dual graph
    shapecompindices = [d[0] for d in vdata]
    labels = shapecompindices + [0] * (2 * NE)
    
    # print(f"vdata = {vdata}")
    for i, d in enumerate(vdata):
      # print(f"d = {d}")
      links = d[1]
      for j in range(len(links)):
        # print(f"i={i} j={j} d={d} links={links} VA={VA} labels={labels}")
        labels[VA[i][j]-1] = -links[j]
    
    AssignLabels(D, labels)
    # vprint(f"labels = {labels}")
    IncludeAssocIfNotIsomorphic(graphs, tuple(sorted(shapecompindices)), D, gr_iso)

  # print(len([k for k in graphs]))    # keys

  if countonly:                                    # If countonly=True, return the reduction type count 
    return sum(len(graphs[k]) for k in graphs)

  # Construct reduction types from double graphs
  families = set()
  redtypes = []

  for key, Dlist in graphs.items():
    # print(f"key={key} Dlist={Dlist}")
    for D in Dlist:
      VD = D.nodes
      L = [GetLabel(D,v) for v in VD]
      RV = [UsedShapeComps[L[i]-1].Copy(index=i+1) for i in range(len(V))]

      for k in range(1,NE+1):
        e1, e2 = D.edges(len(V) + k)
        i1, i2 = e1
        i3, i4 = e2
        i = min(i1, i2, i3, i4)

        e1, e2 = D.edges(len(V) + NE + k)
        i1, i2 = e1
        i3, i4 = e2
        j = min(i1, i2, i3, i4)

        di = -L[len(V) + k-1]        
        dj = -L[len(V) + NE + k-1]
        # print(f"Labels={L} merging Si={RV[i-1]} di={di} Sj={RV[j-1]} dj={dj}")
        MergeEdgeEndpoints(RV[i-1], di, RV[j-1], dj)

      R = RedPrinListToReductionType(RV)
      label = R.Label()

      if label in families:
        raise ValueError(f"Already have family {label}")
      families.add(label)
      redtypes.append(R)

  return redtypes


"""
# Test (slow)
assert len(ReductionTypes(2)) == 104
assert len(ReductionTypes(3)) == 1901
assert len(ReductionTypes(4)) == 43440
"""

#VERBOSE = True
