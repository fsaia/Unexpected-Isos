/*
(c) Tim Dokchitser, redlib library, v3.3, May 2025, https://people.maths.bris.ac.uk/~matyd/redlib/
Reduction type library in javascript (translated from redtype.m + bits from dualgraph.m and planar.m)
// SVG issues: I5-I5-I8-1g1

[F8] manual manual.tex
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

*
* IMPLEMENTS
*
*
* Outer and inner chains
*
function OuterSequence(m, d, includem = true)                                                                   [1004]
function InnerSequence(m1, d1, m2, dk, n, includem = true)                                                      [1035]
function MinimalDepth(m1, d1, m2, dk)                                                                           [1102]
  Minimal depth of a inner sequence between principal components of multiplicities m1 and m2 with initial links
  d1 and dk.
function SortMultiplicities(m, O)                                                                               [1172]
  Sort a multiset of multiplicities O by GCD with m, then by O. This is how outer and free multiplicities are
  sorted in reduction types.
function DefaultMultiplicities(m1, o1, m2, o2, loop)                                                            [1192]
*
* Principal component core (RedCore)
*
function Core(m,O)                                                                                              [1304]
  Core of a principal component defined by multiplicity m and list O.
*
* Basic invariants and printing
*
class RedCore
  RedCore.definition()                                                                                          [1357]
    Returns a string representation of a core in the form 'Core(m,O)'.
  RedCore.Multiplicity()                                                                                        [1364]
    Returns the principal multiplicity m of the principal component.
  RedCore.Multiplicities()                                                                                      [1371]
    Returns the list of outgoing chain multiplicities O, sorted with SortMultiplicities.
  RedCore.Chi()                                                                                                 [1378]
    Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)
  RedCore.Label(tex = false)                                                                                    [1385]
    Label of a reduction type core, for printing (or TeX if tex=True)
  RedCore.TeX()                                                                                                 [1403]
    Returns the core label in TeX, same as Label with TeX=true.
function Cores(chi, {mbound="all", sort=true} = {})                                                             [1432]
  Returns all cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a
  bound on m must be given.
*
* Inner chains (RedChain)
*
*
* Invariants and depth
*
class RedChain
  RedChain.Weight()                                                                                             [1624]
    Weight of the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,di))
  RedChain.Index()                                                                                              [1645]
    Index of the RedChain, used for distinguishing between chains
  RedChain.DepthString()                                                                                        [1676]
    Return the string representation of the RedChain's depth
  RedChain.SetDepthString(depth)                                                                                [1683]
    Set how the depth is printed (e.g., "1" or "n")
*
* Principal components (RedPrin)
*
function PrincipalType(m, g, O, Lloops, LD, Ledge, index = 0)                                                   [1764]
class RedPrin
  RedPrin.function order(e)                                                                                     [1964]
  RedPrin.Multiplicity()                                                                                        [1988]
    Principal multiplicity m of a principal type
  RedPrin.GeometricGenus()                                                                                      [1995]
    Geometric genus g of a principal type S = (m, g, O, ...)
  RedPrin.Index()                                                                                               [2002]
    Index of the principal component in a reduction type, 0 if freestanding
  RedPrin.Chains(Class = 0)                                                                                     [2009]
  RedPrin.OuterMultiplicities()                                                                                 [2021]
    Sequence of outer multiplicities S.O of a principal type, sorted
  RedPrin.InnerMultiplicities()                                                                                 [2028]
    Sequence of inner multiplicities S.L of a principal type, sorted as in label
  RedPrin.Loops()                                                                                               [2035]
    Sequence of chains in S representing loops (class cLoop)
  RedPrin.DLinks()                                                                                              [2042]
    Sequence of chains in S representing D-links (class cD)
  RedPrin.EdgeChains()                                                                                          [2049]
    Sequence of edges of a principal type, sorted
  RedPrin.EdgeMultiplicities()                                                                                  [2056]
    Sequence of edge multiplicities of a principal type, sorted
  RedPrin.definition()                                                                                          [2063]
    Returns a string representation of the principal type object in the form of the PrincipalType constructor.
  RedPrin.GCD()                                                                                                 [2094]
    Return GCD(m, O, L) for a principal type
  RedPrin.Core()                                                                                                [2101]
    Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m, O) = 1
  RedPrin.Chi()                                                                                                 [2108]
  RedPrin.Weight()                                                                                              [2117]
    Outgoing link pattern of a principal type = multiset of GCDs of edges with m.
  RedPrin.Copy(index = false)                                                                                   [2124]
    Make a copy of a principal type.
  RedPrin.Score()                                                                                               [2162]
    Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a
    principal type, and characterises it uniquely.
  RedPrin.equals(other)                                                                                         [2177]
    Compare two principal types by their score.
  RedPrin.lessThan(other)                                                                                       [2184]
    Compare two principal types by their score.
  RedPrin.lessThanOrEqual(other)                                                                                [2191]
    Compare two principal types by their score.
  RedPrin.greaterThan(other)                                                                                    [2198]
    Compare two principal types by their score.
  RedPrin.greaterThanOrEqual(other)                                                                             [2205]
    Compare two principal types by their score.
  RedPrin.Label(options={})                                                                                     [2377]
  RedPrin.TeX(options = {})                                                                                     [2415]
function PrincipalTypeFromScore(w)                                                                              [2465]
  Create a principal type S from its score sequence w (=Score(S)).
function PrincipalTypes(chi, arg, {semistable=false, sort=true, withweights=false} = {})                        [2645]
function PrincipalTypesTeX(T, options = {})                                                                     [2807]
*
* Basic labelled undirected graphs (Graph)
*
class Graph
  Graph.constructor(vertexSet = [], edgeSet = [])                                                               [2909]
  Graph.AddVertex(vertex, label = undefined)                                                                    [2934]
    Add a vertex with an optional label. If the vertex already exists, update its label.
  Graph.AddEdge(vertex1, vertex2)                                                                               [2945]
    Add an edge between two vertices (both vertices must exist).
  Graph.RemoveVertex(v)                                                                                         [2956]
    Remove a vertex v from the graph, together with its incident edges
  Graph.HasVertex(vertex)                                                                                       [2968]
    Check if a vertex exists in the graph.
  Graph.GetLabel(vertex)                                                                                        [2975]
    Get the label of a vertex. Returns undefined if the vertex doesn't exist.
  Graph.SetLabel(vertex, label)                                                                                 [2982]
    Set the label for a specific vertex. Raises an error if the vertex doesn't exist.
  Graph.GetLabels()                                                                                             [2993]
    Get all labels in the graph.
  Graph.SetLabels(labels)                                                                                       [3000]
    Set labels for all vertices. Raises an error if the number of labels doesn't match the number of vertices.
  Graph.RemoveLabels()                                                                                          [3014]
    Remove labels from graph vertices
  Graph.HasEdge(vertex1, vertex2)                                                                               [3022]
    Check if an edge exists between two vertices. No loops are allowed.
  Graph.Vertices()                                                                                              [3035]
    Return the set of vertices as an array.
  Graph.Edges(v = undefined)                                                                                    [3042]
  Graph.Neighbours(vertex)                                                                                      [3057]
    Get all neighbours of a given vertex. This returns an array of adjacent vertices, and loops contribute twice.
  Graph.BFS(startVertex)                                                                                        [3069]
    Perform BFS starting from the given vertex and return the connected component as an array.
  Graph.ConnectedComponents()                                                                                   [3096]
    Find all connected components in the graph using BFS. Return as an array of arrays of vertices.
  Graph.RemoveEdge(vertex1, vertex2)                                                                            [3115]
    Remove an edge from the graph
  Graph.EdgeSubgraph(edgeSet)                                                                                   [3123]
    Returns a new Graph object containing only the specified edges
  Graph.Degree(vertex)                                                                                          [3136]
    Returns the degree of a vertex (number of indident edges)
  Graph.Copy()                                                                                                  [3143]
    Copy a graph
  Graph.Label(options = {})                                                                                     [3157]
  Graph.IsIsomorphic(other)                                                                                     [3211]
    Test whether are two graphs are isomorphic, through their labels
function MinimumScorePaths(D)                                                                                   [3275]
  Determines minimum score paths in a connected labelled undirected graph, returning scores and possible vertex
  index sequences.
function StandardGraphCoordinates(G)                                                                            [4557]
  Returns vertex coordinate lists x, y for planar drawing of a graph G
function TeXGraph(G, options = {})                                                                              [4614]
function SVGGraph(G, options = {})                                                                              [4734]
function GraphFromEdgesString(edgesString)                                                                      [4824]
  Construct a graph from a string encoding edges such as "1-2-3-4, A-B, C-D", assigning the vertex labels to the
  corresponding strings.
*
* RedShape
*
class RedShape
  RedShape.Graph()                                                                                              [4904]
    Returns the underlying undirected graph G of the shape.
  RedShape.DoubleGraph()                                                                                        [4911]
    Returns the vertex-labelled double graph D of the shape.
  RedShape.Vertices()                                                                                           [4918]
    Returns the vertex set of G as a graph.
  RedShape.Edges()                                                                                              [4925]
    Returns the edges of G as a graph
  RedShape.NumVertices()                                                                                        [4932]
    Returns the number of vertices in the graph G underlying the shape.
  RedShape.Chi(v)                                                                                               [4939]
    Returns the Euler characteristic chi(v) <= 0 of the vertex v.
  RedShape.Weights(v)                                                                                           [4953]
    Returns the Weights of a vertex v that together with chi determine the vertex type (chi, weights).
  RedShape.TotalChi()                                                                                           [4962]
    Returns the total Euler characteristic of a graph shape chi <= 0, sum over chi's of vertices.
  RedShape.VertexLabels()                                                                                       [4973]
    Returns a sequence of -chi's for individual components of the shape S.
  RedShape.EdgeLabels()                                                                                         [4980]
    Returns a list of edges v_i -> v_j of the form [i, j, edgegcd].
  RedShape.toString()                                                                                           [4987]
    Print in the form Shape(V,E) so as to be evaluatable
  RedShape.TeX(options = {})                                                                                    [4996]
    Tikz a shape of a reduction graph, and, if required, the bounding box x1, y1, x2, y2.
function Shape(V, E)                                                                                            [5059]
function Shapes(genus)                                                                                          [5143]
  Returns all shapes {shape:..., count:...} in a given genus g=2, 3 or 4
*
* Dual graphs (GrphDual)
*
*
* Default construction
*
function DualGraph(m, g, edges, comptexnames = "default")                                                       [5341]
*
* Step by step construction
*
class GrphDual
  GrphDual.constructor()                                                                                        [5449]
    Initialize an empty dual graph
  GrphDual.AddComponent(name, genus, multiplicity, texname = null)                                              [5459]
  GrphDual.AddEdge(node1, node2)                                                                                [5477]
    Adds an edge between two components (vertices) in the graph.
  GrphDual.AddChain(c1, c2, mults)                                                                              [5484]
*
* Global methods and arithmetic invariants
*
  GrphDual.Graph()                                                                                              [5531]
    Returns the underlying graph.
  GrphDual.Components()                                                                                         [5538]
    Returns the list of vertices of the underlying graph.
  GrphDual.IsConnected()                                                                                        [5558]
    Check that the dual graph is connected
  GrphDual.HasIntegralSelfIntersections()                                                                       [5565]
    Are all component self-intersections integers
  GrphDual.AbelianDimension()                                                                                   [5572]
    Sum of genera of components
  GrphDual.ToricDimension()                                                                                     [5579]
    Number of loops in the dual graph
  GrphDual.IntersectionMatrix()                                                                                 [5589]
    Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.
  GrphDual.PrincipalComponents()                                                                                [5625]
    Return a list of indices of principal components.
  GrphDual.ChainsOfP1s()                                                                                        [5642]
    Returns a sequence of tuples [<v0,v1,[chain multiplicities]>] for chains of P1s between principal components,
    and v1=None for outer chains
  GrphDual.ReductionType()                                                                                      [5690]
    Reduction type from a dual graph
*
* Contracting components to get a mrnc model
*
  GrphDual.ContractComponent(c, checks=true)                                                                    [5701]
    Contract a component in the dual graph, assuming it meets one or two components, and has genus 0.
  GrphDual.MakeMRNC()                                                                                           [5734]
    Repeatedly contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal
    crossings.
  GrphDual.Check()                                                                                              [5757]
    Check that the graph is connected and self-intersections are integers.
*
* Invariants of individual vertices
*
  GrphDual.HasComponent(c)                                                                                      [5807]
    Test whether the graph has a component named c
  GrphDual.Multiplicity(v)                                                                                      [5814]
    Multiplicity m of the vertex
  GrphDual.Multiplicities()                                                                                     [5821]
    Returns the list of multiplicities of all the vertices.
  GrphDual.Genus(v)                                                                                             [5828]
    Genus g of the vertex
  GrphDual.Genera()                                                                                             [5835]
    Returns the list of geometric genera of all the vertices.
  GrphDual.Neighbours(i)                                                                                        [5842]
    List of incident vertices, with each loop contributing the vertex itself twice
  GrphDual.Intersection(c1, c2)                                                                                 [5849]
    Compute the intersection number between components c1 and c2 (or self-intersection if c1=c2).
  GrphDual.TeXName(v)                                                                                           [5877]
    TeXName assigned to a vertex v
*
* Reduction types (RedType)
*
function ReductionType(...args)                                                                                 [6001]
function ReductionTypes(arg, options = {})                                                                      [6062]
class RedType
  RedType.get(target, prop)                                                                                     [6151]
  RedType.Chi()                                                                                                 [6168]
    Total Euler characteristic of R
  RedType.Genus()                                                                                               [6177]
    Total genus of R
  RedType.IsGood()                                                                                              [6193]
    true if comes from a curve with good reduction
  RedType.IsSemistable()                                                                                        [6200]
    true if comes from a curve with semistable reduction (all (principal) components of an mrnc model have
    multiplicity 1)
  RedType.IsSemistableTotallyToric()                                                                            [6207]
    true if comes from a curve with semistable totally toric reduction (semistable with no positive genus
    components)
  RedType.IsSemistableTotallyAbelian()                                                                          [6214]
    true if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual
    graph)
  RedType.TamagawaNumber()                                                                                      [6235]
    Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field
*
* Invariants of individual principal components and chains
*
  RedType.PrincipalTypes()                                                                                      [6266]
    Principal types (vertices) of the reduction type
  RedType.length()                                                                                              [6273]
    Number of principal types in a reduction type
  RedType.getItem(i)                                                                                            [6280]
    Principal type number i in the reduction type, accessed as R[i] (numbered from i=1)
  RedType.InnerChains()                                                                                         [6299]
    Return all the inner chains in the reduction type
  RedType.EdgeChains()                                                                                          [6306]
    Return all the inner chains in R between different principal components, sorted as in label.
  RedType.Multiplicities()                                                                                      [6313]
    Sequence of multiplicities of principal types
  RedType.Genera()                                                                                              [6320]
    Sequence of geometric genera of principal types
  RedType.GCD()                                                                                                 [6327]
    GCD detecting non-primitive types
  RedType.Shape()                                                                                               [6334]
    The shape of the reduction type.
  RedType.Score()                                                                                               [6357]
    Score of a reduction type, used for comparison and sorting
  RedType.equals(other)                                                                                         [6385]
    Equality comparison based on label.
  RedType.lessThan(other)                                                                                       [6395]
    Less than comparison based on score.
  RedType.greaterThan(other)                                                                                    [6412]
    Greater than comparison based on score.
  RedType.lessThanOrEqual(other)                                                                                [6422]
    Less than or equal to comparison based on score.
  RedType.greaterThanOrEqual(other)                                                                             [6432]
    Greater than or equal to comparison based on score.
*
* Reduction types, labels, and dual graphs
*
  RedType.DualGraph({compnames="default"} = {})                                                                 [6478]
  RedType.Label(options = {})                                                                                   [6584]
  RedType.Family()                                                                                              [6681]
    Returns the reduction type label with minimal chain lengths in the same family.
  RedType.TeX(options = {})                                                                                     [6751]
  RedType.SetDepths(depth)                                                                                      [6857]
    Set depths for DualGraph and Label based on either a function or a sequence.
  RedType.SetVariableDepths()                                                                                   [6888]
    Set depths for DualGraph and Label to a variable depth format like 'n_i'.
  RedType.SetOriginalDepths()                                                                                   [6895]
    Remove custom depths and reset to original depths for printing in Label and other functions.
  RedType.SetMinimalDepths()                                                                                    [6902]
    Set depths to minimal ones in the family for each edge.
  RedType.GetDepths()                                                                                           [6909]
    Return the current depths (string sequence) set by SetDepths or the original ones if not changed.
*/

const 
  PathsMaxSteps = 5000;                // limit for MinimumScorePaths


// Verbose printing 

let VERBOSE     = false,
    vprintcount = 0;

function vprint(...args) {         //
  if (VERBOSE && vprintcount<100) {  
    console.log(...args);  
    vprintcount++;
  }
}


/*
Manual
The library redtype.js implements the combinatorics of reduction types, in particular
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
var R = ReductionType("I2*-1g1-IV");
console.log(R.Label());             // Canonical plain label
console.log(R.Label({tex: true}));  // TeX label
console.log(R.TeX());               // Reduction type as a graph
console.log(R.DualGraph().toString().replace(",[[",", [[")); //> console.log(R.DualGraph())         // Associated dual graph
// This is a dual graph on 10 components, of multiplicity 1, 2 and 3, and genus 0 and 1:\par
// \begin{tikzpicture}[xscale=0.9,yscale=0.85, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, bluedash/.style={blue!80!white,densely dashed,shorten <=0em,shorten >=0em}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {2} node[facel] {}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,2.5)--(3.66,2.5) node[mainl] {3} node[facel] {$\Gamma_1$}; \draw[l1] (1.6,1.83)--(3.66,1.83) node[mainl] {1 \smash{g}1} node[facel] {$\Gamma_2$}; \draw[l1] (1.6,0.66)--(3.66,0.66) node[mainl] {2} node[facel] {$\Gamma_3$}; \draw[l2] (1.6,0)--node[rightl] {2} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {1} (2.2,1.33); \draw[l2,bluedash] (3,0.66)--(3,1.83); \draw[l2,bluedash] (1.6,1.83)--(1.6,2.5); \draw[l2end] (2.2,2.5)--node[rightl] {1} (2.2,3.16); \draw[l2end] (3,2.5)--node[rightl] {1} (3,3.16); \end{tikzpicture}\par
// Taking the associated reduction type gives back R:
var G = DualGraph([3,1,2,1,1,1,2,1,1,2], [0,1,0,0,0,0,0,0,0,0], [[1,2],[1,4],[1,5],[2,3],[3,6],[3,10],[7,8],[7,9],[7,10]]);
console.log(G.ReductionType().Label());
*/



// Basic mathematical functions


function mod(a, b) {              //
  /*
  Computes the modulus of a with respect to b, returning a non-negative result.
  Like in Magma and python: -1 mod 3 = 2 rather than -1
  */
  return ((a % b) + b) % b;
}


function gcd_two(a, b) {                          // GCD of two integers
  return b === 0 ? Math.abs(a) : gcd_two(b, a % b);
}

function GCD(...numbers) {     // GCD of any number of integers
  if (numbers.length === 0) {     // GCD([])=0
    return 0;
  }
  if (numbers.length === 1) {     // GCD([a])=a 
    return numbers[0];          
  }
  return numbers.reduce((acc, num) => gcd_two(acc, num));     // reduce inductively
}
 
function XGCD(a, b) {                           //        
  /*
  Extended Euclidean algorithm. Returns [gcd, x, y] with x*a+y*b=gcd.
  */
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError(`XGCD: Expected ${a}:${typeof a} and ${b}:${typeof b} to be of type int`);
  }
  if (a === 0) {
    return [b, 0, 1];
  }
  const [GCD, x1, y1] = XGCD(mod(b,a), a);
  const x = y1 - Math.floor(b / a) * x1;
  const y = x1;
  return [GCD, x, y];
}

function Divisors(n) {                          // 
  /*
  Returns the sorted list of divisors of a given integer n.
  */
  if (typeof n !== 'number') {
    throw new TypeError(`Divisors: Expected ${n}:${typeof n} to be of type int`);
  }
  const L = new Set();
  for (let i = 1; i <= Math.floor(Math.sqrt(n)); i++) {
    if (n % i === 0) {
      L.add(i);
      if (i * i !== n) {
        L.add(n / i);
      }
    }
  }
  return Array.from(L).sort((a, b) => a - b);
}

function ModularInverse(a, m) {                  // 
  /*
  Computes the modular inverse of a modulo m using the Extended Euclidean algorithm.
  */
  if (typeof a !== 'number' || typeof m !== 'number') {
    throw new TypeError(`ModularInverse: Expected ${a}:${typeof a} and ${m}:${typeof m} to be of type int`);
  }
  const [GCD, x, y] = XGCD(a, m);  // a*x + m*y = 1
  if (GCD !== 1) {
    throw new Error(`${a} mod ${m} has no inverse`);
  }
  return x;
}


function Minor(M, a, b) {    //
  /*
  Minor obtained by removing ath row and bth column
  */
  return M.filter((_, i) => i !== a).map(row => row.filter((_, j) => j !== b));
}


function Determinant(M) {     //
  /*
  Basic implementation of determinant of an Z-valued square matrix with Gaussian elimination over R
  */
  
  var A = M.map(row => row.slice());      // Save original matrix
  const n = A.length;
  let det = 1;

  for (let i = 0; i < n; i++) {
    // Find the row with the maximum element in the current column (pivoting)
    let maxRow = i;
    for (let k = i + 1; k < n; k++) {
      if (Math.abs(A[k][i]) > Math.abs(A[maxRow][i])) {
        maxRow = k;
      }
    }

    // Swap rows if necessary
    if (maxRow !== i) {
      [A[i], A[maxRow]] = [A[maxRow], A[i]]; // Swap rows
      det *= -1;  // Row swap changes the sign of the determinant
    }

    // If the pivot element is 0, the determinant is 0
    if (A[i][i] === 0) {
      return 0;
    }

    // Eliminate the elements below the pivot
    for (let k = i + 1; k < n; k++) {
      const factor = A[k][i] / A[i][i];
      for (let j = i; j < n; j++) {
        A[k][j] -= factor * A[i][j];
      }
    }

    // Multiply the determinant by the pivot element
    det *= A[i][i];
  }

  return Math.round(det);
}


function DeterminantBareiss(M) {     //
  /*
  Bareiss' algorithm to compute Det(M) in a stable way
  */
  var n = M.length; 
  if (n == 0) return 1;
  var sign = 1;                           // Keep track of extra sign from pivoting
  var A = M.map(row => row.slice());      // Copy the original matrix

  for (var k = 0; k < n - 1; k++) {
    if (A[k][k] === 0) {                  // Check for zero pivot element
      let swapFound = false;              // Flag to check if swap was successful
      for (var i = k + 1; i < n; i++) {   // Find a row below to swap with (for non-zero pivot)
        if (A[i][k] !== 0) {
          [A[k], A[i]] = [A[i], A[k]];    // Swap rows
          sign = -sign;
          swapFound = true;
          break;
        }
      }
      if (!swapFound) return 0;           // If no non-zero pivot is found, determinant is zero
    }
    for (var i = k + 1; i < n; i++) {         // Bareiss elimination
      for (var j = k + 1; j < n; j++) {
        A[i][j] = Math.round(
          (A[i][j] * A[k][k] - A[i][k] * A[k][j]) / (k > 0 ? A[k - 1][k - 1] : 1)
        );
      }
    }
  }
  return sign * A[n - 1][n - 1];         // After the elimination, the determinant is the bottom-right element
}


function DeterminantsOfMinors(M) {     //
  /*
  Array of determinants of n-1 x n-1 minors
  */
  return Array.from({ length: M.length }, (_, i) => 
    Array.from({ length: M.length }, (_, j) => DeterminantBareiss(Minor(M, i, j)))
  );
}


// Printing


function TeXPrintParameter(s, options = {}) {    //
  /*
  Formats and prints the parameter s with optional TeX formatting and specified symbols.
  */
  
  let {
    tex = true,          // Default to true if no tex option is provided
    sym = "",            // Default to empty string
    plainsym = "",       // Default to empty string
    texsym = "",         // Default to empty string
    printempty = true    // Default to true
  } = options;

//  console.log(`TeXPrintParameter: s=${s} tex=${tex}`);
  
  s = String(s);  // Convert s to a string
  if (s.length === 0 && !printempty) {
    return "";
  }
  if (sym === "") {
    sym = tex ? texsym : plainsym;
  }
  let par = (tex && s.length > 1) ? `{${s}}` : s;  // Add braces if tex is true and s has more than 1 character
  return sym + par;
}


function FormatString(pattern, ...args) {          //
  /*
  Python's analogue: formatString("Hello, my name is {0} and I am {1} years old.", "Bob", 99);  
  */
  return pattern.replace(/{(\d+)}/g, (match, index) => args[index]);
}


function StringSplit(s, P) {     //
  /*
  Split a string into blocks using an ordered sequence of patterns that describe types.

  s - The input string to be split.
  P - An ordered sequence of patterns, where each pattern is a tuple [type_index, regex].
    e.g. P = [[mInt, /([0-9]+)/], [mEdgeSym, /([-=<>])/], ...]
   
  returns a list of blocks where each block is a list of the form [type_index, extracts...].
  */

  const L = [];
  
  while (s.length > 0) {
    let found = false;
    
    for (const [typeIndex, regex] of P) {
      const pattern = new RegExp("^" + regex.source + "(.*)$");
      const m = s.match(pattern);
      
      if (!m) continue;  // Skip if no match
      
      found = true;
      const extracts = m.slice(1, m.length - 1);  // Extract matched groups except the last one
      L.push([typeIndex, ...extracts]);  // Append the type index and extracted groups
      s = m[m.length - 1];  // Update s to the remaining unmatched part
      break;
    }

    if (!found) {
      throw new Error(`StringSplit: could not match ${s}`);
    }
  }
  
  return L;
}


function PrintSequence(S, options={}) {    //
  let 
    {sep = ", "} 
  = options;
  return S.join(sep); 
}


// Multisets and sequences


function ArraysEqual(seq1, seq2) {     //
  /*
  Checks if two sequences seq1 and seq2 are equal in length and content,
  supporting nested sequences (arrays of arrays).
  */

  if (!Array.isArray(seq1) || !Array.isArray(seq2)) {             // Use direct comparison if not both arrays
    return seq1 === seq2;                                         // (for FindMinimumPaths in case of general labels)
  }
  
  if (seq1.length !== seq2.length) return false;                  // Early return if lengths differ
  
  for (let i = 0; i < seq1.length; i++) {
    if (Array.isArray(seq1[i]) && Array.isArray(seq2[i])) {
      if (!ArraysEqual(seq1[i], seq2[i])) return false;              // Recursively check nested arrays
    } else if (seq1[i] !== seq2[i]) { 
      return false;                           // Elements must be strictly equal for non-array elements
    }
  }
  
  return true;                                                    // Arrays are equal in length and content
}


function CompareElements(el1, el2) {     //
  if (Array.isArray(el1) && Array.isArray(el2)) {
    return ScoreIsSmaller(el1, el2);  // Recursively compare nested arrays
  }
  if (el1 < el2) return "<";
  if (el1 > el2) return ">";
  return "=";  // If equal, return "=" to continue comparing the rest
}


function ScoreIsSmaller(newSeq, bestSeq) {     //
  /*
  Compares two sequences of integers or nested arrays, and returns:
    "<"  : new has smaller score than best
    ">"  : new has greater score
    "l"  : new and best coincide until best's length, and new is longer
    "s"  : new and best coincide until new's length, and new is shorter
    "="  : new equals best
  */

  if (!Array.isArray(newSeq) || !Array.isArray(bestSeq)) {   // not arrays
    return CompareElements(newSeq, bestSeq);  
  }

  for (let i = 0; i < Math.min(newSeq.length, bestSeq.length); i++) {
    const result = CompareElements(newSeq[i], bestSeq[i]);
    if (result !== "=") return result;  // Return early if there's a difference
  }
  
  if (newSeq.length === bestSeq.length) return "=";  // Sequences are identical
  return newSeq.length > bestSeq.length ? "l" : "s";  // Compare lengths
}


function ArraysLess(seq1, seq2) {     //
  /*
  Checks if seq1 < seq2 for sorting purposes.
  */
  let w = ScoreIsSmaller(seq1,seq2);
  if (w=='<' || w=='s') return -1;
  if (w=='>' || w=='l') return 1;
  return 0;
}


function FindMinimalLabel(labels) {   //
  /*
  Find the minimum label in an array of labels,
  where each label can be a sequence (including nested arrays).
  Uses ScoreIsSmaller for comparisons.
  */
  return labels.reduce((min, label) => {
    if (min === undefined || ScoreIsSmaller(label, min) === "<") {
      return label;  // Update min if label is smaller
    }
    return min;  // Keep the current min
  }, undefined);
}


function SymmetricDifference(setA, setB) {            //
  /*
  Symmetric difference of two sets
  */
  const _difference = new Set(setA);
  for (let elem of setB) {
    if (_difference.has(elem)) {
      _difference.delete(elem);
    } else {
      _difference.add(elem);
    }
  }
  return _difference;
}


function Exclude(L, a) {                           //
  /*
  Removes one occurrence of a in an array L (and does nothing if it isn't there)
  */
  let index = L.indexOf(a); // Find the index of the first occurrence of 'a'
  if (index !== -1) {       // If 'a' is found in the array
    L.splice(index, 1);     // Remove the element at the found index
  }
  return L;                 // Return the modified array
}


function SetsEqual(setA, setB) {                      //
  /*
  Are the two sets equal
  */
  if (setA.size !== setB.size) return false;
  for (let item of setA) {
    if (!setB.has(item)) return false;
  }
  return true;
}


function ElementMultiplicity(L, x) {                   // 
  /*
  Counts the occurrences of element x in the list L.
  */
  return L.filter(item => item === x).length;
}


function SequenceDifference(S1, S2) {      //
  /*
  Difference for inner sequences S:=S1 diff S2 (unsorted result)
  */
  const multiset1 = ElementsMultiplicities(S1);     // Convert arrays to frequency maps (multisets)
  const multiset2 = ElementsMultiplicities(S2);
  const result = [];                             // Calculate the difference
  for (const [key, count] of multiset1.entries()) {
    const remainingCount = count - (multiset2.get(key) || 0);
    for (let i = 0; i < remainingCount; i++) {
      result.push(key);
    }
  }
  return result;
}


function IsSubMultiset(X, Y) {                // 
  /*
  Determines if a multiset X (given as an array) is a sub-multiset of Y by comparing element multiplicities.
  */
  const uniqueX = [...new Set(X)];                                // Get unique elements from X
  for (let element of uniqueX) {
    if (ElementMultiplicity(X, element) > ElementMultiplicity(Y, element)) {
      return false;
    }
  }
  return true;
}


function MultisetsInInterval(min_val, max_val, k) {                  //
  /*
  Generates all multisets of size k with elements in the range [min_val, max_val].
  */
  if (k === 0) {
    return [[]];
  } else if (min_val <= max_val) {
    let result = [];
    for (let ms of MultisetsInInterval(min_val, max_val, k - 1)) {
      result.push([min_val, ...ms]);
    }
    return result.concat(MultisetsInInterval(min_val + 1, max_val, k));
  }
  return [];
}


function ElementsMultiplicities(array) {               //
  /*
  Counts the occurrences of each unique element in the given array.
  */
  const map = new Map();
  for (const item of array) {
    map.set(item, (map.get(item) || 0) + 1);
  }
  return map;
}


function MultiSubsets(L) {                   //
  /*
  Generates all multisubsets of a given array L, accounting for element multiplicities.
  */
  if (!Array.isArray(L)) {
    throw new TypeError("L must be an array");
  }

  // Convert the input array into a frequency map (multiset)
  const counts = ElementsMultiplicities(L);
  const S = [...counts.keys()];   // distinct elements
  const M = [...counts.values()]; // multiplicities

  // Start with the empty subset
  let out = [new Map()];

  // Iterate over each unique element and its multiplicity
  for (let i = 0; i < S.length; i++) {
    const elem = S[i];
    const multiplicity = M[i];
    const currentSubsets = [];
  
    for (let count = 0; count <= multiplicity; count++) {
      for (const subset of out) {
        const newSubset = new Map(subset);  // Copy the subset
        newSubset.set(elem, (newSubset.get(elem) || 0) + count);
        currentSubsets.push(newSubset);
      }
    }
    out = currentSubsets;
  }

  // Convert the Map objects to array format
  const finalResult = out.map(subset => {
    const expandedSubset = [];
    for (const [key, count] of subset.entries()) {
      for (let i = 0; i < count; i++) {
        expandedSubset.push(key);
      }
    }
    return expandedSubset;
  });

  return finalResult;  // returns array of arrays
}


function ArrayPermutations(array) {    //
  if (array.length === 0) return [[]];
  const first = array[0];
  const rest = array.slice(1);
  const permsWithoutFirst = ArrayPermutations(rest);
  const allPerms = [];

  for (const perm of permsWithoutFirst) {
    for (let i = 0; i <= perm.length; i++) {
      const permWithFirst = [...perm.slice(0, i), first, ...perm.slice(i)];
      allPerms.push(permWithFirst);
    }
  }
  return allPerms;
}


function CartesianProduct(arrays) {    //
  return arrays.reduce((acc, array) => {
    const result = [];
    for (const accItem of acc) {
      for (const item of array) {
        result.push([...accItem, item]);
      }
    }
    return result;
  }, [[]]);
}


/*
Test MultiSubsets
Assert(MultiSubsets([1, 1, 2]).length == 6);
Assert(MultiSubsets([1, 1, 1, 2, 2, 3]).length == 24);
*/


function SortSetList(lst) {     //
  /*
  Remove repeated elements and sort. This works for lists and other mutable 
  types for which set(...) complains, as long as they allow comparison.
  */
  const uniqueList = [];
  for (const elem of lst) {             
    if (!Array.isArray(elem)) {         // Check type
      throw new Error(`Element ${JSON.stringify(elem)} is not an array.`);
    }  // Check if the current element is already in uniqueList using ArraysEqual
    if (!uniqueList.some(existingElem => ArraysEqual(existingElem, elem))) {
      uniqueList.push(elem);            // Append only if not already in uniqueList
    }
  }
  return uniqueList.sort();             // Return the sorted unique list
}

function PreferenceOrder(C, f) {     //
  /*
  Sorts C by the score function f and returns the order of each element,
  so that the minimal elements have order 1, the next ones order 2, etc.
  */
  const values = C.map(f);                   // Apply f to each element in C
  const sortedValues = SortSetList(values);  // Convert to set, back to list and sort
  
  return values.map(a => 
    sortedValues.findIndex(b => ArraysEqual(a, b)) + 1 // Use ArraysEqual to find the index
  ); 
}

function PreferenceOrder2(C, f) {     //
  /*
  Sorts a 2-dimensional array C by the score function f and returns the order of each element,
  so that the minimal elements have order 1, the next ones order 2, etc.
  */
  const v = C.map(c => c.map(a => f(a))); // Apply f to each element in the 2D array C
  const flattenedSorted = SortSetList([].concat(...v)); // Flatten and sort the values
  
  return v.map(c => 
    c.map(a => 
      flattenedSorted.findIndex(b => ArraysEqual(a, b)) + 1 // Use ArraysEqual to find the index
    )
  ); // Return order (1-based) for each sub-array
}


/// Outer and inner chains


/*
Manual
A reduction type is a graph that has principal types as vertices 
(like \redtype{IV}, \redtype{1g1}, \redtype{I^*_2} above) and inner chains as edges. 
Principal types encode principal components together with outer chains, loops and D-links. 
The three functions that control multiplicities of outer and inner chains, and their depths
are as follows:
*/


function OuterSequence(m, d, includem = true) {
/*
Unique outer sequence of type (m,d) for integers m>=1 and 1<d<m. It is of the form 
   [m,d,...,gcd(m,d)] 
with every three consecutive terms d_(i-1), d_i, d_(i+1) satisfying
   d_(i-1) + d_(i+1) = d_i * (integer > 1).
If includem=false, exclude the starting point m from the sequence.}
  */

  if (!includem) {
    return OuterSequence(m, d).slice(1);
  }

  if (typeof m !== 'number' || typeof d !== 'number' || m <= 0 || d < 0) {
    throw new TypeError(`Expected ${m}:${typeof m} and ${d}:${typeof d} to be integers with m>0`);
  }
  d = mod(d,m);
  if (d === 0) {
    return [m];
  }
  return [m].concat(OuterSequence(d, d - mod(m,d)));
}


/*
Example OuterSequence
console.log(OuterSequence(6, 5)); 
console.log(OuterSequence(13, 8));
*/


function InnerSequence(m1, d1, m2, dk, n, includem = true) {
  /*
  Unique inner sequence of type m1(d1-dk-n)m2, that is of the form [m1,d1,...,dk,m2] with n+1 terms 
  equal to gcd(m1,d1)=gcd(m2,dk) and satisfying the chain condition: for every three consecutive terms 
     d_(i-1), d_i, d_(i+1) 
  we have
     d_(i-1) + d_(i+1) = d_i * (integer > 1).
  If includem = false, exclude the endpoints m1,m2 from the sequence.
  */
    
  if (!includem) {
    return InnerSequence(m1, d1, m2, dk, n).slice(1,-1);
  }

  if (typeof m1 !== 'number' || typeof d1 !== 'number' || m1 <= 0 || typeof m2 !== 'number' || typeof dk !== 'number' || m2 <= 0) {
    throw new TypeError(`Expected m1=${m1}, d1=${d1}, m2=${m2}, dk=${dk} to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2`);
  }

  const c = GCD(m1, d1);
  if (c !== GCD(m2, dk)) {
    throw new Error(`No inner sequence ${m1},${d1},...,${dk},${m2} exists as GCD(${m1},${d1}) != GCD(${m2},${dk})`);
  }

  d1 = mod(d1,m1);
  dk = mod(dk,m2);
  const n0 = MinimalDepth(m1, d1, m2, dk);
  if (n < n0) {
    throw new Error(`No inner sequence ${m1},${d1},...,${dk},${m2} of depth ${n}<${n0} exists`);
  }

  if (n > -1) {
    const seq_start = OuterSequence(m1, d1);
    const seq_end = OuterSequence(m2, dk).reverse();
    if (n === 0) {
      return seq_start.slice(0, -1).concat(seq_end);  // one c
    }
    return seq_start.concat(new Array(n - 1).fill(c)).concat(seq_end);  // at least 2 c's
  }

  if ((dk - m1) % m2 === 0 && (d1 - m2) % m1 === 0) {
    return [m1, m2];  // point (4) in Thm
  }
  if (m1 >= m2) {
    return [m1].concat(InnerSequence(d1, -m1, m2, dk, -1));  // point (5) in Thm
  }
  return InnerSequence(m1, d1, dk, -m2, -1).concat([m2]);  // point (6) in Thm
}

/*
Test
Assert(JSON.stringify(OuterSequence(10, 2)) === JSON.stringify([10, 2]));
Assert(JSON.stringify(OuterSequence(10, 8)) === JSON.stringify([10, 8, 6, 4, 2]));
Assert(JSON.stringify(OuterSequence(10, 7)) === JSON.stringify([10, 7, 4, 1]));
Assert(JSON.stringify(OuterSequence(13, 8)) === JSON.stringify([13, 8, 3, 1]));
Assert(JSON.stringify(InnerSequence(5, 4, 1, -1, 0)) === JSON.stringify([5, 4, 3, 2, 1]));
Assert(JSON.stringify(InnerSequence(3, 2, 3, 2, -1)) === JSON.stringify([3, 2, 3]));
Assert(JSON.stringify(InnerSequence(6, 5, 6, 5, -1)) === JSON.stringify([6, 5, 4, 3, 2, 3, 4, 5, 6]));
*/

/*
Example InnerSequence
console.log(InnerSequence(3, 2, 3, 2, -1)); 
console.log(InnerSequence(3, 2, 3, 2, 0));
console.log(InnerSequence(3, 2, 3, 2, 1));
*/


function MinimalDepth(m1, d1, m2, dk) {
  /*
  Minimal depth of a inner sequence between principal components of multiplicities m1 and m2 with initial links d1 and dk.

  Minimal depth of a chain d1,d2,...,dk of P1s between principal component of multiplicity m1, m2 and 
  initial inner multiplicities d1,dk. The depth is defined as -1 + number of times GCD(d1,...,dk) 
  appears in the sequence. 
  For example, 5,4,3,2,1 is a valid inner sequence, and MinimalDepth(5,4,1,2) = -1 + 1 = 0.
  */
  if (typeof m1 !== 'number' || typeof d1 !== 'number' || m1 <= 0 || typeof m2 !== 'number' || typeof dk !== 'number' || m2 <= 0) {
    throw new TypeError(`Expected m1=${m1}, d1=${d1}, m2=${m2}, dk=${dk} to be integers, m1>=1, m2>=1, 0<d1<=m1, 0<dk<=m2`);
  }
  if (GCD(m1, d1) !== GCD(m2, dk)) {
    throw new Error(`No inner sequence ${m1},${d1},...,${dk},${m2} exists as GCD(${m1},${d1}) != GCD(${m2},${dk})`);
  }

  const [, d1i] = XGCD(mod(d1,m1), m1);
  const [, dki] = XGCD(mod(dk,m2), m2);

  const n = Math.ceil(-(mod(d1i,m1) / m1) - (mod(dki,m2) / m2) + 1 / (2 * m1 * m2));
  return (n===-0) ? 0 : n;
}


/*
Example
// Example for MinimalDepth from the description of the function:
console.log(MinimalDepth(5,4,1,2))
// For another example, the minimal $n$ in the Kodaira type \redtype{I^*_n} is 1. Here the chain links
// two components of multiplicity 2, and the initial multiplicities are 2 on both sides as well:
console.log(MinimalDepth(2,2,2,2))
// Here is an example of a reduction type with an inner chain between two components of multiplicity 3 and outgoing multiplicities 2 on both sides:
var R = ReductionType("IV*-(2)IV*")   
// Here is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(4.26,0) node[mainl] {3} node[facel] {$\Gamma_1$}; \draw[l2] (0.66,0)--node[rightl] {2} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {1} (0.66,0.66); \draw[l2] (2.13,0)--node[rightl] {2} (2.13,0.66); \draw[l2] (1.46,0.66)--node[abovel] {1} (2.13,0.66); \draw[l1] (3.6,2)--(7,2) node[mainl] {3} node[facel] {$\Gamma_2$}; \draw[l2] (3.6,0)--node[rightl] {2} (3.6,0.66); \draw[l2] (2.93,0.66)--node[abovel] {1} (3.6,0.66); \draw[l2] (2.93,0.66)--node[leftl] {1} (2.93,1.33); \draw[l2] (2.93,1.33)--node[abovel] {1} (3.6,1.33); \draw[l2] (3.6,1.33)--node[rightl] {2} (3.6,2); \draw[l2] (4.86,2)--node[rightl] {2} (4.86,2.66); \draw[l2] (4.2,2.66)--node[abovel] {1} (4.86,2.66); \draw[l2] (6.33,2)--node[rightl] {2} (6.33,2.66); \draw[l2] (5.66,2.66)--node[abovel] {1} (6.33,2.66); \end{tikzpicture}\par
// The inner chain has gcd=GCD(3,2)=1 and 
// \begin{center}
//    depth = $-1$ + \#1's(=gcd) in the sequence $3,2,1,1,1,2,3$ = 2
// \end{center}
// This is the depth specified in round brackets in IV*-(2)IV*
console.log(MinimalDepth(3,2,3,2))   // Minimal possible depth for such a chain = -1
var R1 = ReductionType("IV*-IV*")        // used by default when no expicit depth is specified
var R2 = ReductionType("IV*-(-1)IV*")
console.assert(R1.equals(R2))
// Here is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {3} node[facel] {$\Gamma_2$}; \draw[l2] (0.66,0)--node[rightl] {2} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {1} (0.66,0.66); \draw[l2] (2.13,0)--node[rightl] {2} (2.13,0.66); \draw[l2] (1.46,0.66)--node[abovel] {1} (2.13,0.66); \draw[l1] (2.93,0.66)--(5.73,0.66) node[mainl] {3} node[facel] {$\Gamma_1$}; \draw[l2] (2.93,0)--node[rightl] {2} (2.93,0.66); \draw[l2] (3.6,0.66)--node[rightl] {2} (3.6,1.33); \draw[l2] (2.93,1.33)--node[abovel] {1} (3.6,1.33); \draw[l2] (5.06,0.66)--node[rightl] {2} (5.06,1.33); \draw[l2] (4.4,1.33)--node[abovel] {1} (5.06,1.33); \end{tikzpicture}
*/



/*
Test
Assert(MinimalDepth(1,0,1,0) == 1);
Assert(MinimalDepth(1,0,2,1) == 0);
Assert(MinimalDepth(2,1,1,0) == 0);
Assert(MinimalDepth(2,0,2,0) == 1);
Assert(MinimalDepth(3,2,3,1) == 0);
Assert(MinimalDepth(3,2,3,2) == -1);
Assert(MinimalDepth(7,6,7,3) == -1);
Assert(MinimalDepth(7,4,7,2) == 0);
*/


/*
Manual
The next two functions are used in Label to determine the ordering of chains (including loops and D-links),
and default multiplicities which are not printed in labels.
*/


function SortMultiplicities(m, O) {
  /*
  Sort a multiset of multiplicities O by GCD with m, then by O. This is how outer and free multiplicities are sorted in reduction types.
  */
  if (O.length <= 1) {
    return;
  }
  O.sort((a, b) => (GCD(m, a) - GCD(m, b)) || (a - b));
}


/*
Example Ordering outer multiplicities in reduction types
var m = 6                    // principal component multiplicity
var O = [1,2,3,3,4,5]        // initial multiplicities for outgoing outer chains
SortMultiplicities(6, O)              // sort them first by gcd(o,m), then by o mod m
console.log(O)
*/


function DefaultMultiplicities(m1, o1, m2, o2, loop) {
  /*
  Intrinsic 
  function DefaultMultiplicities(m1, o1, m2, o2, loop)
  Default edge multiplicities d1, d2 for a component with multiplicity m1, available outgoing multiplicities o1, and one with m2, o2.
  loop: boolean specifies whether it is a loop or a link between two different principal components.
  */

  // Possible pairs [chain GCD, outgoing mult d]
  let X1 = o1.map(d => [GCD(m1, d), d]).concat([[m1, m1], [m1, m1]]);
  let X2 = o2.map(d => [GCD(m2, d), d]).concat([[m2, m2], [m2, m2]]);
  
  // Determine the possible set of chain gcds
  let good;
  if (loop) {
    good = new Set(X1.map(D => D[0]).filter(d => X1.filter(E => E[0] === d).length >= 2));
  } else {
    good = new Set(X1.map(D => D[0])).intersection(new Set(X2.map(D => D[0])));
  }
  
  X1 = X1.filter(D => good.has(D[0]));
  X2 = X2.filter(D => good.has(D[0]));

  // Error handling
  if (X1.length === 0 || (!loop && X2.length === 0) || (loop && X2.length <= 1)) {
    throw new Error(`DefaultMultiplicities(${m1}, ${JSON.stringify(o1)}, ${m2}, ${JSON.stringify(o2)}, ${loop}): could not find default edge m1=${m1} o1=${JSON.stringify(o1)} - m2=${m2} o2=${JSON.stringify(o2)}`);
  }
  
  // Find minimum multiplicities
  let d1min = FindMinimalLabel(X1)
  if (loop) {
    let index = X2.findIndex(x => x[0] === d1min[0] && x[1] === d1min[1]);
    if (index !== -1) X2.splice(index, 1);  // Remove one occurrence of d1min
  }
  let d2min = FindMinimalLabel(X2)
  
  return [d1min[1], d2min[1]];
}

/*
# Example DefaultMultiplicities
console.log(DefaultMultiplicities(9, [1, 1, 1, 3, 3], 9, [1, 1, 1, 3, 3], true));
console.log(DefaultMultiplicities(9, [1, 3, 3], 9, [1, 3, 3], true));
console.log(DefaultMultiplicities(9, [1], 9, [1], true));
*/


/*
Example DefaultMultiplicities
// Let us illustrate what happens when we take a principal component \redtype{9^{1,1,1,3,3}} and add
// five default loops of depth 2,2,1,2,3, to get a reduction type \redtype{9^{1,1,1,3,3}_{2,2,1,2,3}}. 
// How do default loops decide which initial multiplicities to take? \par
// We start with a component of multiplicity $m=9$ and outer multiplicities $\cO=\{1,1,1,3,3\}$.
var R = ReductionType("9^1,1,1,3,3");
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(3.86,0) node[mainl] {9} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {3} (0.8,0.66); \draw[l2end] (1.6,0)--node[rightl] {3} (1.6,0.66); \draw[l2end] (2.4,0)--node[rightl] {1} (2.4,0.66); \draw[l2end] (3.2,0)--node[rightl] {1} (3.2,0.66); \end{tikzpicture}\par
// We can add a loop to it linking two 1's of depth 2 by
R = ReductionType("9^1,1,1,3,3_{1-1}2");
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(3.73,0) node[mainl] {9} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {3} (0.8,0.66); \draw[l2end] (1.6,0)--node[rightl] {3} (1.6,0.66); \draw[l2] (2.4,0)--node[leftl] {1} (2.4,0.66); \draw[l2] (2.4,0.66)--node[abovel] {1} (3.06,0.66); \draw[l2] (3.06,0)--node[rightl] {1} (3.06,0.66); \end{tikzpicture}\par
// In this case, \{1-1\} does not need to be specified because this is the minimal pair of possible multiplicities in $\cO$, as sorted by SortMultiplicities:
console.log(DefaultMultiplicities(9,[1,1,1,3,3],9,[1,1,1,3,3],true));
console.assert(R.equals(ReductionType("9^1,1,1,3,3_2")));
// After adding the loop, $\{1,3,3\}$ are left as potential outgoing multiplicities, so the next default loop links 3 and 3. Note that $1,3$ is not a valid pair because $\gcd(1,9)\ne\gcd(3,9)$.
console.log(DefaultMultiplicities(9,[1,3,3],9,[1,3,3],true));
var R2 = ReductionType("9^1,1,1,3,3_2,2");       // 2 loops, use 1-1 and 3-3
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(3.6,0) node[mainl] {9} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[leftl] {3} (0.8,0.66); \draw[l2] (0.8,0.66)--node[abovel] {3} (1.46,0.66); \draw[l2] (1.46,0)--node[rightl] {3} (1.46,0.66); \draw[l2] (2.26,0)--node[leftl] {1} (2.26,0.66); \draw[l2] (2.26,0.66)--node[abovel] {1} (2.93,0.66); \draw[l2] (2.93,0)--node[rightl] {1} (2.93,0.66); \end{tikzpicture}\par
// There are no pairs left, so the next three loops use $(m,m)=(9,9)$
console.log(DefaultMultiplicities(9,[1],9,[1],true));   
var R3 = ReductionType("9^1,1,1,3,3_2,2,1,2,3"); 
var R4 = ReductionType("9^1,1,1,3,3_{1-1}2,{3-3}2,{9-9}1,{9-9}2,{9-9}3");
console.assert(R3.equals(R4));
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, aboverightl/.style={above right=-4.5pt,lfnt}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, aboveleftl/.style={above left=-4.5pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(7.83,0) node[mainl] {9} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \path[draw,thick] (0.8,0) edge[white,line width=2] ++(0.6,0) edge[out=0,in=-90] ++(0.6,0.4) ++(0.6,0.4) edge[out=90,in=0] ++(-0.3,0.3) ++(-0.3,0.3)  edge[out=180,in=90] ++(-0.3,-0.3) ++(-0.3,-0.3) edge[out=-90,in=180] ++(0.6,-0.4); \draw[-,l2] (2.06,0) ++(1,0) arc (0:180:0.5) node[midway,abovel] {9};\draw[l2] (3.56,0)--node[leftl] {3} (3.56,0.66); \draw[l2] (3.56,0.66)--node[abovel] {3} (4.23,0.66); \draw[l2] (4.23,0)--node[rightl] {3} (4.23,0.66); \draw[l2] (5.7,0)--node[aboverightl] {9} (5.36,0.66); \draw[l2] (5.03,0)--node[aboveleftl] {9} (5.36,0.66); \draw[l2] (6.5,0)--node[leftl] {1} (6.5,0.66); \draw[l2] (6.5,0.66)--node[abovel] {1} (7.16,0.66); \draw[l2] (7.16,0)--node[rightl] {1} (7.16,0.66); \end{tikzpicture}\par
*/



/// Principal component core (RedCore)


function CoreChi(m, g, O, L) {     //
  /*
  Calculate the core Euler characteristic based on multiplicity, genus, and lists of outer and link components.
  */
  return m * (2 - 2 * g - O.length - L.length) + O.reduce((sum, d) => sum + GCD(m, d), 0);
}


const StandardCoreNames = [
  { m: 1, O: [], plain: "I", tex: "{\\rm I}" },
  { m: 2, O: [1, 1], plain: "D", tex: "{\\rm D}" },
  { m: 3, O: [1, 2], plain: "T", tex: "{\\rm T}" },
  { m: 2, O: [1, 1, 1, 1], plain: "I0*", tex: "{\\rm I}_0^*" },
  { m: 3, O: [1, 1, 1], plain: "IV", tex: "{\\rm IV}" },
  { m: 3, O: [2, 2, 2], plain: "IV*", tex: "{\\rm IV}^*" },
  { m: 4, O: [1, 1, 2], plain: "III", tex: "{\\rm III}" },
  { m: 4, O: [3, 3, 2], plain: "III*", tex: "{\\rm III}^*" },
  { m: 6, O: [1, 2, 3], plain: "II", tex: "{\\rm II}" },
  { m: 6, O: [5, 4, 3], plain: "II*", tex: "{\\rm II}^*" }
];


/*
Manual
A core is a pair $(m,O)$ with `principal multiplicity' $m\ge 1$ and `outgoing multiplicities' $O=\{o_1,o_2,...\}$
that add up to a multiple of $m$, and such that $\gcd(m,O)=1$. It is implemented as the following type:
*/



function Core(m,O) {
  /*
  Core of a principal component defined by multiplicity m and list O.
  */
  return new RedCore(m,O);  
}


/*
Example Create and print a principal component core $(m,O)$
console.log(Core(8,[1,3,4]).toString());   // Typical core; note 1+3+4=0 mod m=8
console.log(Core(8,[9,3,4]).toString());   // Same core, as they are in Z/mZ
// This is how cores are printed, with the exception of 7 cores of $\chi=0$ (see below) 
// that come from Kodaira types and two additional special ones D and T:
console.log(Core(6,[1,2,3]).toString());                 // from a Kodaira type
console.log([Core(2,[1,1]),Core(3,[1,2])].join(', '));   // two special ones
*/


/// Basic invariants and printing


class RedCore {

  constructor(m, O) {      //
    if (m < 1) {
      throw new Error("Principal multiplicity m should be at least 1");
    }

    O = O.map(o => mod(o,m));

    if (O.includes(0)) {
      throw new Error("Outgoing multiplicity in a core cannot be 0");
    }

    if ( (m>1) && (O.length===0) || (O.length > 0) && (GCD(m, ...O)!==1) ) {
      throw new Error(`Core should have GCD(m,O)=1 (m=${m} O=${O})`);
    }

    if (O.reduce((a, b) => a + b, 0) % m !== 0) {
      throw new Error(`Core with non-integral self-intersection (m=${m} O=${O})`);
    }

    this.m = m;
    SortMultiplicities(m, O);
    this.O = O;
    this.chi = CoreChi(m, 0, this.O, []);

    if (this.chi % 2 !== 0) {
      throw new Error(`Core: expected even chi when m=${m} O=${O}`);
    }
  }

  definition() {
    /*
    Returns a string representation of a core in the form 'Core(m,O)'.
    */
    return `Core(${this.m},${this.O})`;
  }

  Multiplicity() {
    /*
    Returns the principal multiplicity m of the principal component.
    */
    return this.m;
  }
  
  Multiplicities() {
    /*
    Returns the list of outgoing chain multiplicities O, sorted with SortMultiplicities.
    */
    return this.O;
  }
  
  Chi() {
    /*
    Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)
    */
    return this.chi;
  }
  
  Label(tex = false) {
    /*
    Label of a reduction type core, for printing (or TeX if tex=True)
    */
    if (this.chi < 0 || (this.chi === 2 && ![1, 2, 3].includes(this.m))) {
      const O_str = this.O.join(",");
      return `${this.m}${TeXPrintParameter(this.O, {tex, sym:"^", printempty:false})}`;
    } else {
      const match = StandardCoreNames.find(
        item => item.m === this.m && ArraysEqual(item.O,this.O)
      );
      if (!match) {
        throw new Error(`Could not find standard component for m=${this.m} O=${this.O}`);
      }
      return tex ? match.tex : match.plain;
    }
  }
  
  TeX() {
    /*
    Returns the core label in TeX, same as Label with TeX=true.
    */
    return this.Label(true);
  }
  
  HTML() {    //
    return this.Label(true);
  }
  
  toString() {    //
    return this.Label();
  }
}


/*
Example Core labels and invariants
let C=Core(2,[1,1,1,1])
console.log(C.Label());               // Plain label
console.log(C.TeX());                 // TeX label
console.log(C.definition());          // How it can be defined
console.log(C.Multiplicity());        // Principal multiplicity m
console.log(C.Multiplicities());      // Outgoing multiplicities O
console.log(C.Chi());                 // Euler characteristic
*/


function Cores(chi, {mbound="all", sort=true} = {}) {
  /*
  Returns all cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a bound on m must be given.
  */

  if (chi === 2) {
    // console.log(`chi=${chi} mbound=${mbound}`)
    if (mbound === "all") {
      throw new Error("mbound must be set when chi=2, otherwise there are infinitely many cores");
    }
    let list = [new RedCore(1, [])];
    // console.log(`list=${list}`)
    for (let m = 2; m <= mbound; m++) {
      for (let a = 1; a <= Math.floor(m / 2); a++) {
        if (GCD(m, a) === 1) {
          // console.log(`Trying m=${m} a=${a}`);
          list.push(new RedCore(m, [a, m - a]));
        }
      }
    }
    return list;
  }

  if (chi % 2 !== 0 || chi > 0) {
    throw new Error("chi should be a non-positive even number (or 2 with mbound set)");
  }

  let list = [];
  let g = (2 - chi) / 2;

  for (let m = 1; m <= 4 * g + 2; m++) {
    if (mbound !== "all" && m > mbound) continue;

    for (let k = 2; k <= 4 * g; k++) {
      if ((k / 2 - 2) * m > -chi) break;

      for (let S of MultisetsInInterval(1, m - 1, k - 1)) {
        let e = mod(-S.reduce((a, b) => a + b, 0),m);
        if (e === 0 || e < Math.max(...S)) continue;
        // console.log(`m=${m} k=${k} S=${S} e=${e} GCD=${GCD(m, ...S, e)}`);
        if (GCD(m, ...S, e) !== 1) continue;
        let O = [...S, e];
        if (CoreChi(m, 0, O, []) !== chi) continue;
        list.push(new RedCore(m, O));
      }
    }
  }

  if (sort) {
    list.sort((c1, c2) => {
      let diff = c1.m - c2.m;
      if (diff !== 0) return diff;

      for (let i = 0; i < Math.min(c1.O.length, c2.O.length); i++) {
        diff = c1.O[i] - c2.O[i];
        if (diff !== 0) return diff;
      }
      return c1.O.length - c2.O.length;
    });
  }

  return list;
}



/*
Example Cores
let C = Cores(-2, {mbound: 4})
console.log(C.join(', '))
C = Cores(0)
console.log(C.join(', '))
console.log([0,-2,-4,-6,-8].map(i=>Cores(i).length));  // [7, 16, 43, 65, 64, ...]
*/


/// Inner chains (RedChain)


/*
Manual
Inner chains between principal components fall into three classes: loops on a principal type, D-link 
on a principal type, and chains between principal types that link two of their edge endpoints. 
All of these are implemented in the class RedChain that carries class=cLoop, cD or cEdge, and keeps track
of all the invariants.
*/

// Constants for RedChain
const cLoop = 1;
const cD = 2;
const cEdge = 3;


function Link(Class, mi, di, mj = false, dj = false, depth = false, Si = false, Sj = false, index = false) {     //
  /*
  Define a RedChain from its invariants
  */
  return new RedChain(Class, mi, di, mj, dj, depth, Si, Sj, index);
}


/*
Example Inner chains, with no principal types specified
console.log(Link(cLoop, 2, 1, 2, 1).toString());  // Loop
console.log(Link(cD, 2, 2).toString());           // D-Link
console.log(Link(cEdge, 2, 2).toString());       // to another principal type
*/


/// Invariants and depth


class RedChain {
  constructor(Class, mi, di, mj = false, dj = false, depth = false, Si = false, Sj = false, index = false) {  //

    // console.log(`RedChain constructor: class=${Class} mi=${mi} di=${di} mj=${mj} dj=${dj} depth=${depth}`);

    // Ensure class is within valid range
    if (![cLoop, cD, cEdge].includes(Class)) {
      throw new Error(`Invalid class: ${Class}. Must be one of ${cLoop}, ${cD}, ${cEdge}.`);
    }

    // Ensure mj, dj, and depth are either integers or false
    [mi, di, mj, dj, depth].forEach(x => {
      if (typeof x !== 'number' && x !== false) {
        throw new Error(`${x} is neither a number nor 'false'.`);
      }
    });   

    this.Class = Class;
    this.mi = mi;
    this.di = di;
    this.mj = mj;
    this.dj = dj;
    this.depth = depth;
    this.Si = Si;
    this.Sj = Sj;
    this.index = index;

    // Handle special cases for D-link
    if (this.Class === cD) {
      if (this.mj === false) {
        this.mj = GCD(this.mi, this.di); 
      }
      if (this.dj === false) {
        this.dj = this.mj;
      }
      if (this.mj % 2 !== 0) {
        throw new Error(`Invalid D-link with mj=${this.mj} dj=${this.dj}`);
      }
    }

    if (this.mi !== false && this.di !== false) {
      this.di = mod(this.di,this.mi);
      if (this.di === 0) {
        this.di = this.mi;
      }
    }
    if (this.mj !== false && this.dj !== false) {
      this.dj = mod(this.dj,this.mj);
      if (this.dj === 0) {
        this.dj = this.mj;
      }

      // Ensure GCDs match
      if (GCD(this.mi, this.di) !== GCD(this.mj, this.dj)) {
        throw new Error(`GCD mismatch error when trying to construct an edge mi=${this.mi},di=${this.di} - mj=${this.mj},dj=${this.dj}`);
      }

      // Set depth if unset
      if (this.depth === false) {
        this.depth = MinimalDepth(this.mi, this.di, this.mj, this.dj); // Assuming MinimalDepth function is implemented
      }
    }

    // Depth string for printing
    this.depthstr = this.depth !== false ? String(this.depth) : false;
  }


  toString() {  //
    /*
    String representation for printing
    */
    const classstr = ["loop", "D-link", "edge"][this.Class - 1];
    const indexstr = this.index !== false ? `[${this.index}] ` : "";
    const Sistr = this.Si !== false ? `c${this.Si.index} ` : "";
    const Sjstr = this.Sj !== false ? `c${this.Sj.index} ` : "";
    const depthstr = this.depthstr !== false ? this.depthstr : "false";
    return `${indexstr}${classstr} ${Sistr}${this.mi},${this.di} -(${depthstr}) ${Sjstr}${this.mj},${this.dj}`;
  }

  Weight() {
    /*
    Weight of the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,di))
    */
    return GCD(this.mi, this.di); 
  }

  Copy() {      //
    /*
    Copy a RedChain
    */
    return new RedChain(this.Class, this.mi, this.di, this.mj, this.dj, this.depth, this.Si, this.Sj, this.index);
  }

  Reverse() {      //
    /*
    Reverse the direction of the chain
    */
    return new RedChain(this.Class, this.mj, this.dj, this.mi, this.di, this.depth, this.Sj, this.Si, this.index);
  }

  Index() {
    /*
    Index of the RedChain, used for distinguishing between chains
    */
    return this.index;
  }

  SetDepth(n) {          //
    /*
    Set the depth and depth string of the RedChain
    */
    const min_depth = MinimalDepth(this.mi, this.di, this.mj, this.dj); // Assuming MinimalDepth is implemented
    if (n === false) {
      n = min_depth;
    }
    if (n < min_depth) {
      throw new Error(`SetDepth: n=${n} < MinimalDepth for RedChain ${this}`);
    }
    this.depth = n;
    this.depthstr = String(n);
  }

  SetMinimalDepth() {            //
    /*
    Set the depth of the RedChain to the minimal possible value
    */
    const min_depth = MinimalDepth(this.mi, this.di, this.mj, this.dj);
    this.depth = min_depth;
    this.depthstr = String(min_depth);
  }

  DepthString() {
    /*
    Return the string representation of the RedChain's depth
    */
    return this.depthstr;
  }

  SetDepthString(depth) {
    /*
    Set how the depth is printed (e.g., "1" or "n")
    */
    this.depthstr = String(depth);
  }
}


/*
Example Invariants of inner chains
// Take a genus 2 reduction type \redtype{I_2\e(1)I^*_2} whose special fibre 
// consists of Kodaira types \redtype{I_2} (loop of $\P^1$s) and \redtype{I^*_2} linked 
// by a chain of $\P^1$s of multiplicity 1.
var R = new ReductionType("I2-(1)I2*");  
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {2} node[facel] {}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,1.83)--(3.66,1.83) node[mainl] {1} node[facel] {$\Gamma_1$}; \draw[l1] (1.6,0.66)--(3.66,0.66) node[mainl] {2} node[facel] {$\Gamma_2$}; \draw[l2] (1.6,0)--node[rightl] {2} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {1} (2.2,1.33); \draw[l2] (3,0.66)--node[rightl] {1} (3,1.83); \draw[-,l2] (1.6,1.83) ++(1,0) arc (0:180:0.5) node[midway,abovel] {1};\end{tikzpicture}\par
// There are two principal types R[1]=\redtype{I_2} and R[2]=\redtype{I^*_2}, with a loop on I[1] (class cLoop=1), 
// an inner chain between them (class cEdge=3), and a D-link on I[2] (class cD=2)
// This is the order in which they are printed in the label.
console.log([R[1],R[2]].join(' '));    // two principal types R[1] and R[2]
var [c1,c2,c3] = R.InnerChains();
console.log(c1.toString());
console.log(c2.toString());
console.log(c3.toString());
console.log(c3.Class);                 // cLoop=1, *cD=2*, cEdge=3
console.log(c3.Weight());              // GCD of the chain multiplicities [2,2,2]
console.log(c3.Index());               // index in the reduction type
c3.SetDepthString("n");                // change how its depth is printed in labels
console.log(c3.toString());            //   and drawn in dual graphs of reduction types
console.log(R.Label());
// This is what its dual graph looks like:\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, chlenstyle/.style={blue,scale=0.7}, chmultstyle/.style={scale=0.7}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0.5,0)--(3.3,0) node[mainl] {1} node[facel] {$\Gamma_1$}; \draw[] (0,0) ++(0.2,0.3) node[anchor=east,chmultstyle] {1} ++(0.3,-0.45)--++(115:0.75)++(295:0.15)++(245:0.15)--++(65:0.75)++(245:0.15)++(180:0.15) --++(0:0.22) ++(0:0.15) node{$\cdot$} ++(0:0.15) node{$\cdot$} node[below=0.1,anchor=north,chlenstyle]{$n$} ++(0:0.15) node{$\cdot$} ++(0:0.15) --++(0:0.22)++(180:0.15)++(115:0.15)--++(295:0.75)++(115:0.15)++(65:0.15)--++(245:0.75) ++(0.3,0.45) node[anchor=west,chmultstyle] {1};\draw[l1] (2.63,1.83)--(4.7,1.83) node[mainl] {2} node[facel] {}; \draw[l1] (2.63,0.66)--(4.7,0.66) node[mainl] {2} node[facel] {$\Gamma_2$}; \draw[l2] (2.63,0)--node[rightl] {1} (2.63,0.66); \draw[l2end] (3.23,0.66)--node[rightl] {1} (3.23,1.33); \draw[l2] (4.03,0.66)--node[rightl] {2} (4.03,1.83); \draw[l2end] (2.63,1.83)--node[rightl] {1} (2.63,2.5); \draw[l2end] (3.43,1.83)--node[rightl] {1} (3.43,2.5); \end{tikzpicture}
*/


/// Principal components (RedPrin)


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

A principal type is implemented as the following javascript class.
*/


function PrincipalType(m, g, O, Lloops, LD, Ledge, index = 0) {
  /*
  Create a new principal type from its primary invariants:
  m         multiplicity of the principal component, e.g. 8
  g         geometric genus of the principal component, e.g. 0
  O         outgoing multiplicities for outer chains, e.g. 1,1,2
  Lloops    list of loops [[di,dj,depth],...], e.g. [[1,1,3]]
  LD        list of D-links [[di,depth],...], e.g. [[2,1]]  (m and all d_i must be even)
  Ledge    list of edge multiplicities, e.g. [8]
  */
  
  const S = RedPrin.NewPrincipalType(m, g, index, O);

  for (const l of Lloops) {
    if (l.length !== 2 && l.length !== 3) {
      throw new Error("Loops must be a sequence [d1, d2] or [d1, d2, depth]");
    }
    const [di, dj] = l;
    let depth = l.length === 3 ? l[2] : false;

    if (depth && depth < MinimalDepth(m, di, m, dj)) {
      throw new Error(`Depth ${depth} < MinimalDepth(${m}, ${di}, ${m}, ${dj}) in loop ${l}`);
    }
    S.AddInnerMultiplicitiesAndLoop(di, dj, depth);
  }

  for (const l of LD) {
    if (l.length !== 1 && l.length !== 2) {
      throw new Error("LD must be a sequence [d1] or [d1, depth]");
    }
    const di = l[0];
    let depth = l.length === 2 ? l[1] : false;

    if (m % 2 !== 0 || di % 2 !== 0) {
      throw new Error(`To have D-links, multiplicities m(${m}) and di(${di}) must be even`);
    }

    const mj = GCD(m, di);
    const dj = mj;
    
    if (l.length === 2) {
      depth = l[1];
      if (depth < MinimalDepth(m, di, mj, dj)) {
        throw new Error(`Depth ${depth} < MinimalDepth(${m}, ${di}, ${mj}, ${dj}) in D-link ${l}`);
      }
    }
    S.AddInnerMultiplicityAndDLink(di, depth);
  }

  for (const d of Ledge) {
    S.AddInnerMultiplicityAndEdgeLink(d);
  }

  if ((S.O.reduce((a, b) => a + b, 0) + S.L.reduce((a, b) => a + b, 0)) % m !== 0) {
    throw new Error(`Principal type with non-integral self-intersection: m=${m}, O=${S.O}, L=${S.L}`);
  }

  S.Finalize();

  return S;
}


/*
Example Construction
// We construct the principal type from example above. It has $m=8$, $g=0$, outer multiplicities 1,1,2,
// loop $1-1$ of depth 3, a D-link with outgoing multiplicity 2 of depth 1, and no edges
// (so that it is a reduction type in itself).
const S = PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[]);
*/


class RedPrin {
  constructor(m, g, O = [], L = [], C = [], gcd = null, core = null, chi = null, index = 0) {    //
    /*
    Initialize a RedPrin (Principal Type) object with its primary attributes.
    @param {number} m - Principal multiplicity (integer)
    @param {number} g - Geometric genus (integer)
    @param {Array<number>} O - Outgoing multiplicities for outer chains
    @param {Array<number>} L - Outgoing multiplicities from all other chains
    @param {Array<RedChain>} C - Chains
    @param {number|null} gcd - GCD(m, O, L)
    @param {Core|null} core - Core of type RedCore (divide by gcd)
    @param {number|null} chi - Euler characteristic
    @param {number} index - Index in the reduction type (0 if free-standing)
    */
    this.m = m;          // Principal multiplicity
    this.g = g;          // Genus
    this.O = O;          // Outgoing multiplicities for outer chains
    this.L = L;          // Outgoing multiplicities for other chains
    this.C = C;          // Chains (outer, loops, D-links, edge from S)
    this.gcd = gcd;      // GCD of (m, O, L)
    this.core = core;    // Core of type RedCore (divide by gcd)
    this.chi = chi;      // Euler characteristic
    this.index = index;  // Index in the reduction type
  }

  toString() {   //
    /*
    String representation
    */
    return this.Label({tex: false, edge: true});
  }

  AddOuterMultiplicity(o) {    //
    /*
    Add outer multiplicity
    */
    if (o % this.m === 0) {
      throw new Error("AddOuterMultiplicity: Outer multiplicities must be non-zero mod m");
    }
    this.O.push(o % this.m);
    SortMultiplicities(this.m, this.O); 
  }

  AddInnerMultiplicitiesAndLoop(di, dj, depth = false, index = false) {   //
    /*
    Add inner multiplicities and loop
    */
    if (GCD(this.m, di) !== GCD(this.m, dj)) {
      throw new Error(`GCD(${this.m}, ${di}) != GCD(${this.m}, ${dj})`);
    }

    di = di % this.m !== 0 ? di % this.m : this.m;
    dj = dj % this.m !== 0 ? dj % this.m : this.m;

    if (di > dj) {
      [di, dj] = [dj, di]; // Swap to ensure di <= dj
    }

    this.L.push(di);
    this.L.push(dj);

    const loop = Link(cLoop, this.m, di, this.m, dj, depth, this, this, index);
    this.C.push(loop);
  }

  AddInnerMultiplicityAndDLink(d, depth = false, index = false) {   //
    /*
    Add inner multiplicity and D-link
    */
    
    if (this.m % 2 !== 0 || d % 2 !== 0) {
      throw new Error(`To have D-links, multiplicities m(${this.m}) and d(${d}) must be even`);
    }

    const m = this.m
    d = d % this.m !== 0 ? mod(d,m) : m;
    
    const mj = GCD(m, d);
    const dj = mj;

    this.L.push(d);

    const dlink = Link(cD, m, d, mj, dj, depth, this, false, index);
    this.C.push(dlink);
  }

  AddInnerMultiplicityAndEdgeLink(d, index = false) {    //
    /*
    Add inner multiplicity and edge
    */
    d = d % this.m !== 0 ? d % this.m : this.m;
    this.L.push(d);

    const edgeLink = Link(cEdge, this.m, d, false, false, false, this, false, index);
    this.C.push(edgeLink);
  }

  AddInnerMultiplicityAndChain(S2, d1, d2, depth = false, index = false) {   //
    /*
    Add inner multiplicity and chain
    */
    d1 = d1 % this.m !== 0 ? d1 % this.m : this.m;
    d2 = d2 % S2.m !== 0 ? d2 % S2.m : S2.m;

    const link = Link(cEdge, this.m, d1, S2.m, d2, depth, this, S2, index);

    this.L.push(d1);
    S2.L.push(d2);

    this.C.push(link);
    S2.C.push(link.Reverse());
  }

  Finalize() {   //
    /*
    Finalize the principal type
    */
    const m = this.m;
    this.chi = CoreChi(m, this.g, this.O, this.L);
    this.gcd = GCD(...this.O, ...this.L, m);
    const core_m = m / this.gcd;
    const core_O = this.O.concat(this.L).filter(d => d !== m).map(d => d / this.gcd);
    this.core = new Core(core_m, core_O);

    if (this.C.length === 0) {
      return;
    }
    
  function order(e) {
    return [e.Class, GCD(m, e.di), e.di, e.dj ? e.dj: 0, e.depth ? e.depth : 0];
  }
    this.C.sort((a, b) => ArraysLess(order(a),order(b)));    
    
  }

  static NewPrincipalType(m, g, index = 0, O = []) {   //
    /*
    Create a new principal type
    */
    if (m <= 0) {
      throw new Error("Principal multiplicity should be >= 1");
    }
    if (g < 0) {
      throw new Error("Geometric genus should be >= 0");
    }
    const S = new RedPrin(m, g, [], [], [], m, new Core(1, []), CoreChi(m, g, [], []), index);
    for (const o of O) {
      S.AddOuterMultiplicity(o);
    }
    return S;
  }
  
  Multiplicity() {
    /*
    Principal multiplicity m of a principal type
    */
    return this.m;
  }

  GeometricGenus() {
    /*
    Geometric genus g of a principal type S = (m, g, O, ...)
    */
    return this.g;
  }

  Index() {
    /*
    Index of the principal component in a reduction type, 0 if freestanding
    */
    return this.index;
  }

  Chains(Class = 0) {
    /*
    Sequence of chains of type RedChain originating in S. By default, all (loops, D-links, edge) are returned,
    unless a specific chain class is specified.
    */
    if (Class === 0) {
      return this.C;
    } else {
      return this.C.filter(e => e.Class === Class);
    }
  }

  OuterMultiplicities() {
    /*
    Sequence of outer multiplicities S.O of a principal type, sorted
    */
    return this.O;
  }

  InnerMultiplicities() {
    /*
    Sequence of inner multiplicities S.L of a principal type, sorted as in label
    */
    return this.L;
  }

  Loops() {
    /*
    Sequence of chains in S representing loops (class cLoop)
    */
    return this.Chains(cLoop);
  }

  DLinks() {
    /*
    Sequence of chains in S representing D-links (class cD)
    */
    return this.Chains(cD);
  }

  EdgeChains() {
    /*
    Sequence of edges of a principal type, sorted
    */
    return this.Chains(cEdge);
  }

  EdgeMultiplicities() {
    /*
    Sequence of edge multiplicities of a principal type, sorted
    */
    return this.EdgeChains().map(e => e.di);
  }

  definition() {
    /*
    Returns a string representation of the principal type object in the form of the PrincipalType constructor.
    */
    const formatSeq = seq => seq.join(",");
    const O_str = `[${formatSeq(this.OuterMultiplicities())}]`;
    const Lloops_str = `[${this.Loops().map(l => `[${formatSeq([l.di, l.dj, l.depth])}]`).join(",")}]`;
    const LD_str = `[${this.DLinks().map(l => `[${formatSeq([l.di, l.depth])}]`).join(",")}]`;
    const Lfree_str = `[${formatSeq(this.EdgeMultiplicities())}]`;

    return `PrincipalType(${this.m},${this.g},${O_str},${Lloops_str},${LD_str},${Lfree_str})`;
  }

  /*
  Example Invariants
  // We continue with the principal type above. It has $m=8$, $g=0$, outer multiplicities 1,1,2,
  // loop $1-1$ of depth 3, a D-link with outgoing multiplicity 2 of depth 1, and no edges
  // (so that it is a reduction type in itself).
  const S = PrincipalType(8,0,[1,1,2],[[1,1,3]],[[2,1]],[]);
  console.log(S.toString());
  console.log(S.TeX({standalone: true})); // How it appears in the tables
  console.log(S.Multiplicity());          // Principal component multiplicity
  console.log(S.GeometricGenus());        // Geometric genus of the principal component
  console.log(S.OuterMultiplicities());    // Outer chain initial multiplicities O=[1,1,2]
  console.log(S.Loops().toString());      // Loops (of type RedChain)
  console.log(S.DLinks().toString());     // D-Links (of type RedChain)
  console.log(S.EdgeMultiplicities());   // Edge multiplicities
  console.log(S.InnerMultiplicities());    // All initial inner multiplicities
  console.log(S.definition());            // evaluatable string to reconstruct S
  */

  GCD() {
    /*
    Return GCD(m, O, L) for a principal type
    */
    return this.gcd;
  }

  Core() {
    /*
    Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m, O) = 1
    */
    return this.core;
  }

  Chi() {
    /*
    Euler characteristic chi of a principal type (m, g, O, Lloops, LD, Ledge).
    chi = m(2-2g-|O|-|L|) + sum_(o in O) gcd(o, m), where L consists of all the inner multiplicities in
    Lloops (2 from each), LD (1 from each), Ledge (1 from each).
    */
    return this.chi;
  }

  Weight() {
    /*
    Outgoing link pattern of a principal type = multiset of GCDs of edges with m.
    */
    return this.EdgeMultiplicities().map(a => GCD(a, this.m));
  }

  Copy(index = false) {
    /*
    Make a copy of a principal type.
    */
    index = index === false ? this.index : index;
    const C = this.C.map(e => e.Copy());
    const core = new Core(this.core.m, this.core.O);
    const N = new RedPrin(this.m, this.g, [...this.O], [...this.L], C, this.gcd, core, this.chi, index);

    N.C.forEach(c => {
      c.Si = N;
      if (c.Class === cLoop) {
        c.Sj = N;
      } else {
        if (c.Sj !== false) {
          throw new Error(`Copy(S): Expected no target component in ${c}`);
        }
      }
    });

    return N;
  }
  

  /*
  Example GCD
  // Define a principal type by its primary invariants:
  // $m=4$, $g=1$, outer multiplicities $\cO=[2]$, no loops, one D-link with initial multiplicity 2 
  // and length 1, and no edges
  const S = PrincipalType(4, 1, [2], [], [[2, 1]], []);
  console.log(S.GCD());              // its GCD(m,O,L)=GCD(4,[2],[2])=2
  console.log(S.toString());         // which is seen as [2] in its name
  // Note, however, it is not a multiple of 2 of another principal component type because its D-link is primitive. The special fibre is not a multiple of 2.
  // % console.log(ReductionType("[2]Dg1_1D").DualGraph().Multiplicities());
  // This is what the special fibre looks like:\par
  // \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {2} node[facel] {}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,0.66)--(2.86,0.66) node[mainl] {4 \smash{g}1} node[facel] {$\Gamma_1$}; \draw[l2] (1.6,0)--node[rightl] {2} (1.6,0.66); \draw[l2end] (2.2,0.66)--node[rightl] {2} (2.2,1.33); \end{tikzpicture}
  */

  Score() {
    /*
    Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a principal type, and characterises it uniquely.
    */
    let w = [this.Chi(), this.Multiplicity(), -this.GeometricGenus(), this.EdgeMultiplicities().length, this.DLinks().length, 
      this.Loops().length, this.OuterMultiplicities().length];
    w.push(...this.OuterMultiplicities());
    w.push(...this.Loops().flatMap(l => [l.di, l.dj]));     // flatten and concatenate 
    w.push(...this.DLinks().map(e => e.di));
    w.push(...this.EdgeMultiplicities());
    w.push(...this.Loops().map(e => e.depth));
    w.push(...this.DLinks().map(e => e.depth));
    return w;
  }

  equals(other) {
    /*
    Compare two principal types by their score.
    */
    return ArraysEqual(this.Score(),other.Score());
  }

  lessThan(other) {
    /*
    Compare two principal types by their score.
    */
    return this.Score() < other.Score();
  }

  lessThanOrEqual(other) {
    /*
    Compare two principal types by their score.
    */
    return this.Score() <= other.Score();
  }

  greaterThan(other) {
    /*
    Compare two principal types by their score.
    */
    return this.Score() > other.Score();
  }

  greaterThanOrEqual(other) {
    /*
    Compare two principal types by their score.
    */
    return this.Score() >= other.Score();
  }

  PrincipalTypeDecorations() {      //
    /*
    for a principal type returns:
      dstr    =  multiple "[d]" or ""
      cstr    =  core name without stars or subscripts e.g. "I", "T", "D", "II", "6" etc.
      presups =  superscripts belonging to the core, i.e. ["*"] for I0*,In*,II*,... or []
      sups    =  superscripts as a sequence of multiplicities ["5","4","3","3"]
      presubs =  superscripts belonging to the core, i.e. ["0","g1"] for I0*g1, In*,... or []
      subs    =  subscripts from all other loops and D-links
      edges   =  edges ["-{2}",...]
    */

    const S = this;
    const m = S.m;
    const loops = [...S.Loops()];
    const Dlinks = [...S.DLinks()];
  
    // dstr
    const d = S.GCD();
    const dstr = d === 1 ? "" : `[${d}]`;
  
    // Initialize decorations
    const presups = [];
    const sups = [];
    const presubs = [];
    const subs = [];
  
    // cstr, presups, sups
    const C = S.Core();
    let Cstr = C.Label();
    if (Cstr.endsWith("*")) {
      presups.push("*");
      Cstr = Cstr.slice(0, -1);
    }
    const p = Cstr.indexOf("^");
    if (p !== -1) {
      sups.push(...Cstr.slice(p + 1).split(","));
      Cstr = Cstr.slice(0, p);
    }
    let cstr = Cstr;
  
    if (cstr === "I0") {
      cstr = "I";
      presubs.push("0");
    }
  
    if (S.g !== 0) {
      presubs.push(`g${S.g}`);
    }
  
    const OL = S.O.concat(S.L).filter(d => d !== m);
    SortMultiplicities(m, OL);
  
    if (cstr === "I" && !presubs.includes("0") && loops.length) { // Move one loop into In?
      const depth = loops.shift().DepthString();
      presubs.unshift(depth);
    }
  
    for (const l of loops) {                   // Loops
      const depth = l.DepthString();
      const [ , supinds, subinds] = EdgeDecorations(m, OL, l.di, m, OL, l.dj, depth, true);
      if (OL.includes(l.di)) {
        OL.splice(OL.indexOf(l.di), 1);
      }
      if (OL.includes(l.dj)) {
        OL.splice(OL.indexOf(l.dj), 1);
      }
      if (!supinds.length) {
        subs.push(depth);
      } else {
        const sup = supinds.join('-');
        const sub = subinds.join('');
        subs.push(`{${sup}}${sub}`);
      }
    }
  
    if (cstr === "D" && Dlinks.some(D => D.di === m)) {     // Move one D-link into In*?
      const D = Dlinks.find(D => D.di === m);
      cstr = "I";
      presups.push("*");
      const depth = D.DepthString();
      presubs.unshift(depth);
      Dlinks.splice(Dlinks.indexOf(D), 1);
    }
  
    for (const D of Dlinks) {                            // D-links
      const mD = D.mj;
      const depth = D.DepthString();
      const [ , , subinds] = EdgeDecorations(m, OL, D.di, mD, [mD], mD, depth, false);
      const multopts = OL.concat(m);
      const multpos = multopts.indexOf(D.di) + 1;
      const supinds = multopts.slice(0, multpos - 1).some(o => o % 2 === 0) ? [D.di] : [];
      if (OL.includes(D.di)) {
        OL.splice(OL.indexOf(D.di), 1);
      }
      const sup = supinds.join('-');
      const sub = subinds.join('');
      if (!supinds.length) {
        subs.push(`${sub}D`);
      } else {
        subs.push(`{${sup}}${sub}D`);
      }
    }
  
    const edges = S.EdgeMultiplicities().map(o => `-{${o}}`);
  
    return [dstr, cstr, presups, sups, presubs, subs, edges];
  }

  TeXLabel(edge = false, wrap = false) {         //
    const S = this;
    const [dstr, cstr, presups, sups, presubs, subs, edges] = S.PrincipalTypeDecorations();
  
    // Clean and TeX-escape all subscripts (except literal "-1")
    const cleaned_subs = [];
    for (let s of subs) {
      if (s === "-1") {
        continue;
      }
      s = s.replace("{", "\\{").replace("}", "\\}").replace("-", "\\m");
      cleaned_subs.push(s);
    }
  
    // Compose subscript and superscript strings
    let substr = presubs.concat(cleaned_subs).join(",");
    substr = TeXPrintParameter(substr, { sym: "_", printempty: false });
  
    let supstr = presups.concat(sups).join(",");
    supstr = TeXPrintParameter(supstr, { sym: "^", printempty: false });
  
    // Handle edge decorations
    let edgestr = edge ? edges.join("").replaceAll("-", "\\e").replaceAll("=", "\\d") : "";
  
    let out = `${dstr}${cstr}${supstr}${substr}${edgestr}`;
    if (wrap) {
      out = `\\redtype{${out}}`;
    }
  
    return out;
  }

  HTMLLabel(edge = false) {    //
    const S = this;
    const [dstr, cstr, presups, sups, presubs, subs, edges] = S.PrincipalTypeDecorations();
  
    // Join and wrap subscripts (genus, loops, D-tails)
    let substr = presubs.concat(subs).join(",");
    substr = substr ? `<sub>${substr}</sub>` : "";
  
    // Join and wrap superscripts ('*', multiplicities), replacing * with a centered version
    let supstr = presups.concat(sups).join(",").replace("*", "&#x204E;");
    supstr = supstr ? `<sup>${supstr}</sup>` : "";
  
    // Apply styling if both sup and sub are present
    if (substr && supstr) {
      supstr = `<span class='spb'>${supstr}`;
      substr = `${substr}</span>`;
    }
  
    // Edge decorations
    const edgestr = edge ? edges.join("") : "";
  
    return `${dstr}${cstr}${supstr}${substr}${edgestr}`;
  }

  Label(options={}) {
    /*
    Return a plain, TeX, or HTML label of a principal type.
    - tex=True returns a TeX label (in \redtype{} unless wrap=False)
    - html=True returns an HTML label
    - edge=True includes outgoing edges
    */

    const {
      tex = false, 
      html = false,
      edge = false, 
      wrap = false
    } = options
    const S = this;

    if (html) {
      console.assert(!tex, "Cannot use both tex and html output formats.");
      return S.HTMLLabel(edge);
    }
    if (tex) {
      return S.TeXLabel(edge, wrap);
    }

    // Plain string version (non-TeX, non-HTML)
    const [dstr, cstr, presups, sups, presubs, subs, edges] = S.PrincipalTypeDecorations();

    const presubstr = presubs.join("");
    let substr = subs.join(",");
    substr = TeXPrintParameter(substr, { sym: "_", printempty: false, tex: false });
    const presupstr = presups.join("");
    let supstr = sups.join(",");
    supstr = TeXPrintParameter(supstr, { sym: "^", printempty: false, tex: false });
    const edgestr = edge ? edges.join("") : "";

    return `${dstr}${cstr}${presubstr}${presupstr}${supstr}${substr}${edgestr}`;
  } 
   
  TeX(options = {}) {
    /*
    TeX a principal type as a TikZ arc with outer and inner lines, loops, and Ds, with options:
      length     [="35pt"] determines arc length
      label      [=false]  if true puts its label underneath.
      standalone [=false]  if true wraps it in \tikz.
    */

    const {
      length     = "35pt",    // determines arc length
      label      = false,     // if true puts its label underneath
      standalone = false      // if true wraps it in \tikz
    } = options

    const m = this.Multiplicity();                    // Principal multiplicity
    const g = this.GeometricGenus();                  // Geometric genus

    // Create the outer sequence: loops, edges, and D-links
    let outer = this.Loops().map(l => `${l.di}-${l.dj}`);   // Loops: di-dj
    outer = outer.concat(this.EdgeMultiplicities().map(l => `${l}`));  // Edges: edge multiplicities
    outer = outer.concat(this.DLinks().map(l => `.${l.di}`));           // D-links: .di

    // Join sequences into a string with commas
    const outer_str = outer.join(",");
    const inner_str = this.OuterMultiplicities().join(",");

    // Genus string, empty if genus g == 0
    const gstr = g === 0 ? "" : `g${g}`;

    let out;
    if (label) {
      // If label=true, append the label of the arc
      let redtype = this.Label({ tex: true, edge: true });
      out = `\\shapearclabel{${length}}{${outer_str}}{${inner_str}}{${m}${gstr}}{\\redtype{${redtype}}}`;
    } else {
      // Basic arc without label
      out = `\\shapearc{${length}}{${outer_str}}{${inner_str}}{${m}${gstr}}`;
    }

    // Wrap result in \tikz if standalone=true
    if (standalone) {
      out = `\\tikz{\\draw(0,0)${out};}`;
    }

    return out;
  }

}


function PrincipalTypeFromScore(w) {
  /*
  Create a principal type S from its score sequence w (=Score(S)).
  */
  if (w.length < 7) {
    throw new Error(`Score ${w} is too short for a score sequence for a principal type`);
  }

  let [chi, m, g, numedges, numD, numloops, numO] = w.slice(0, 7);    // extract 7 basic invariants
  const wlength = 7 + numO + numedges + 2 * numD + 3 * numloops;
  if (w.length !== wlength) {
    throw new Error(`Score sequence ${w} has incorrect length (got ${w.length} expected ${wlength})`);
  }

  const Oofs = 7;
  const loopsofs = Oofs + numO;
  const Dofs = loopsofs + 2 * numloops;
  const edgeofs = Dofs + numD;
  const loopsdepthsofs = edgeofs + numedges;
  const Ddepthsofs = loopsdepthsofs + numloops;

  const O = Array.from({ length: numO }, (v, j) => w[Oofs + j]); // extract outer multiplicities
  const Lloops = Array.from({ length: numloops }, (v, i) => [w[loopsofs + 2*i], w[loopsofs + 2*i+1], w[loopsdepthsofs + i]]);  // extract loops
  const LD = Array.from({ length: numD }, (v, i) => [w[Dofs + i], w[Ddepthsofs + i]]); // extract D-links
  const Ledge = Array.from({ length: numedges }, (v, j) => w[edgeofs + j]); // extract edges
  const S = PrincipalType(m, -g, O, Lloops, LD, Ledge);

  if (!ArraysEqual(S.Score(),w)) {
    throw new Error(`Score sequence ${w} does not agree with Score(S)=${S.Score()}`);
  }

  return S;
}


/*
Example
S = new PrincipalType(8,0,[4,2],[[1,1,1]],[[2,1]],[6]);  // Create a principal type
var w = S.Score();                                      // score encodes chi, m, g etc. 
console.log(w);                                          //   and characterizes S
console.log(PrincipalTypeFromScore(w).definition());    // Reconstruct S from the score
*/


function PrincipalTypesByCore(chi, C) {     //
  /*
  Find all possible principal types S with a given core C and Euler characteristic chi. Return a sequence of them, and a sequence weights representing all possible S.Weight().
  */
  if (chi > 0) {
    throw new Error("chi should be negative in PrincipalTypes");
  }
  if (chi === 0) {
    throw new Error("Infinitely many principal types with chi=0");
  }
  
  let out = [];       // List of principal components found (of type RedPrin)
  let weights = [];     // Set of Weights found (of type Array)
  
  for (let d of Divisors(-chi)) {                 // [d]C is the starting point
    if (d * C.Chi() < chi) continue;
    
    let m = d * C.Multiplicity();
    let OC = C.Multiplicities().map(o => d * o);
    
    for (let U of MultiSubsets(OC)) {   // Convert outers to links in all possible ways
      let chiL = d * C.Chi() - U.reduce((sum, d) => sum + GCD(d, m), 0);  // -> increases chi by sum of gcds
      
      if (chiL < chi || (chiL - chi) % m !== 0) continue;
      
      let O = SequenceDifference(OC, U);
      let n = (chiL - chi) / m;   // Space left to add new links or increase genus
      
      for (let g = 0; g <= Math.floor(n / 2); g++) {
        let L = U.concat(Array(n-2*g).fill(m));  // Now split L into D's, loops and free links
        
        let Leven = (m % 2 === 0) ? L.filter(d => d % 2 === 0) : [];
        
        for (let LD of MultiSubsets(Leven)) {  // Loops through possible D-links
          let Lleft = SequenceDifference(L, LD);
          
          let pairs = [];
          let uniqueLleft = new Set(Lleft);
          
          uniqueLleft.forEach(l1 => {
            uniqueLleft.forEach(l2 => {
              if (l1 <= l2 && GCD(l1, m) === GCD(l2, m) &&
                  (l1 !== l2 || ElementMultiplicity(Lleft, l1) >= 2)) {
                pairs.push([l1, l2]);
              }
            });
          });
          
          let possibleloops = [[]];
          
          for (let p of pairs) {
            let tempLoops = [...possibleloops];
            
            for (let c0 of tempLoops) {
              let c = [...c0];
              
              while (true) {
                let cnew = [...c, p];
                if (!IsSubMultiset([].concat(...cnew), Lleft)) break;
                
                c = cnew;
                possibleloops.push(c);
              }
            }
          }
          
          for (let Lloops of possibleloops) {
            let Lfree = SequenceDifference(Lleft, [].concat(...Lloops));   // Free links
            let S = PrincipalType(m, g, O, Lloops, LD.map(d => [d]), Lfree);
            out.push(S);
            let weight = S.Weight();
            if (!weights.some(existingWeight => ArraysEqual(existingWeight, weight))) {
              weights.push(weight); // Append to the end if not present
            }
          }
        }
      }
    }
  }
  
  return {comps:out, weights};
}


function PrincipalTypesByChi(chi, semistable = false) {     //
  /*
  Find all possible principal types S with a given Euler characteristic chi. Return a list of them, and a set of Weights representing all possible Weight(S).
  */
  if (chi > 0) {
    throw new Error("chi must be negative in PrincipalTypes");
  }
  if (chi === 0) {
    throw new Error("PrincipalTypes: Infinitely many principal types with chi=0");
  }

  if (semistable) {
    let comps = PrincipalTypes(chi, Core(1, []));
    comps = comps.filter(C => C.Multiplicity() === 1);
    let weights = comps.map(S => S.Weight());
    weights = [...new Set(weights)];
    weights = [...new Array(weights)];
    return {comps, weights};
  }

  let out = [];
  let weights = [];

  for (let c = 2; c >= chi-1; c -= 2) {
    let mbound = (c === 2) ? 2 - chi : 'all';
    for (let C of Cores(c, {mbound: mbound})) {
      let comps = PrincipalTypesByCore(chi, C);
      out.push(...comps.comps);
      for (let weight of comps.weights)
      {
        if (!weights.some(l => ArraysEqual(l, weight))) {
          weights.push(weight);
        }
      }
    }
  }

  return {comps:out, weights:weights};
}


function PrincipalTypesByWeight(chi, weight, semistable = false) {     //
  /*
  All possible principal types with a given Euler characteristic chi and GCDs of edge multiplicities.
  */
  weight.sort((a, b) => a - b);
  let comps = PrincipalTypes(chi, {semistable});
  comps = comps.filter(S => {return ArraysEqual(S.Weight(), weight);});
  return {comps:comps, weights:[weight]};
}


function PrincipalTypes(chi, arg, {semistable=false, sort=true, withweights=false} = {}) {
  /*
  Principal types with a given Euler characteristic chi, and optional restrictions.
  Returns (list of types, discovered GCDs of edges). Can be used as either:
    PrincipalTypes(chi)          - all
    PrincipalTypes(chi,C)        - with a given core C
    PrincipalTypes(chi,Weights)    - with a given sequence of edge weights
  In all three cases can restrict to semistable types, setting semistable=True
  */
  if (typeof chi !== 'number'){
    throw new Error("chi is not an integer");
  }
  let out;
  if (Array.isArray(arg)){
    out = PrincipalTypesByWeight(chi, arg, semistable);
  }
  else if (typeof arg === 'object' && arg instanceof RedCore){
    out = PrincipalTypesByCore(chi, arg, semistable);
  }
  else if (arg === undefined){
    out = PrincipalTypesByChi(chi, semistable);
  }
  else if ('semistable' in arg || 'sort' in arg || 'withweights' in arg){
    ({semistable=false, sort=true, withweights=false} = arg);
    out = PrincipalTypesByChi(chi, semistable);
  }
  else
  {
    throw new Error(`PrincipalTypes: second parameter arg: ${arg.toString()} of type ${typeof arg} is not an integer chi, array weight or RedCore C`);
  }
  if (sort) {
    out.comps.sort((S1,S2) => ArraysLess(S1.Score(),S2.Score()));
  }
  if (withweights) 
  { 
    return out;    
  }
  return out.comps;    
}


/*
// Example Shape components with given chi and Core
let C = new RedCore(3, [1, 2]);
console.log(PrincipalTypes(-2, C).length);  // Should print 4
console.log(PrincipalTypes(-4, C).length);  // Should print 13
console.log(PrincipalTypes(-2, C, {withweights: true}).weights); 
console.log(PrincipalTypes(-6, C).length);  // Should print 20
console.log(PrincipalTypes(-9, C).length);  // Should print 9
console.log(PrincipalTypes(-12,C).length);  // Should print 60
console.log(PrincipalTypes(-4, C).map(S => S.definition()).join("\n"));
*/


/*
Test Shape components with given chi and Weight sequence
let comps = PrincipalTypes(-1, [1]);
Assert(comps.length === 10);
*/


function EdgeDecorations(m1, o1, d1, m2, o2, d2, depth, loop, forcesups = false, forcesubs = false) {      //
  /*
  Edge decorations sym (- or =), sups, subs (lists of int superscripts) between given components with given starting and available multiplicities

  Edge decorations for a chain of depth `depth` between:
    - component with multiplicity `m1`, available outgoing multiplicities `o1`, chain outgoing multiplicity `d1`, and
    - component with multiplicity `m2`, available outgoing multiplicities `o2`, chain outgoing multiplicity `d2`.
  `forcesups`/`forcesubs` forces superscripts/subscripts to be always present.
  
  Returns:
    - sym: Decoration symbol ('-' or '=')
    - sups: List of superscripts ([d1 mod m1, d2 mod m2] or [])
    - subs: List of subscripts ([depth] or [])
  */

  // console.log(`EdgeDecorations (${m1},${o1},${d1})-(${m2},${o2},${d2}) len=${depth} (${typeof depth}) loop=${loop} forcesups=${forcesups} forcesubs=${forcesubs}`);

  if (d1 <= 0 || d1 > m1) {
    throw new Error("Expected d1 in 1..m1 range");
  }
  if (d2 <= 0 || d2 > m2) {
    throw new Error("Expected d2 in 1..m2 range");
  }

  // Determine if subscript should be printed
  const printsub = forcesubs || depth.toString() !== MinimalDepth(m1, d1, m2, d2).toString();
  const subs = printsub ? [depth] : [];

  // Default multiplicities
  const [d1min, d2min] = DefaultMultiplicities(m1, o1, m2, o2, loop);

  // Determine the decoration symbol and superscripts
  let sym, sups;
  if (d1 === d1min && d2 === d2min && !forcesups) {
    sym = "-";
    sups = [];
  // Executive decision to remove '=' from notation
  // } else if (d1 === m1 && d2 === m2 && !loop && !forcesups) {
  //  sym = "=";
  //  sups = [];
  } else {
    sym = "-";
    sups = [d1, d2];
  }

  // console.log(`returning sym=${sym} sups=${sups} subs=${subs}`);

  return [sym, sups, subs];
}

/*
Test
let [sym, sups, subs] = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 1, false);
Assert(sym === "-" && sups.length === 0 && subs.length === 1 && subs[0] === 1);
[sym, sups, subs] = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 0, false);
Assert(sym === "-" && sups.length === 0 && subs.length === 0);
[sym, sups, subs] = EdgeDecorations(6, [1, 2, 3], 1, 6, [1, 2, 3], 1, 0, false, true, true);
Assert(sym === "-" && sups.length === 2 && sups[0] === 1 && sups[1] === 1 && subs.length === 1 && subs[0] === 0);
[sym, sups, subs] = EdgeDecorations(6, [1, 2, 3], 6, 6, [1, 2, 3], 6, 1, true);
Assert(sym === "-" && sups.length === 0 && subs.length === 0);
*/

/*
Example Printing principal types
let comps = PrincipalTypes(-1,[1]);
console.log(comps.join(", "));
comps = PrincipalTypes(-2,[1,1]);
console.log(comps.join(", "));
comps = PrincipalTypes(-2,[2]);
console.log(comps.join(", "));
*/


/*
Test
let comps = PrincipalTypes(-1, [1]);
let truestr = "I1-{1} Ig1-{1} I1*-{1} I0*-{1} IV-{1} IV*-{2} III-{1} III*-{3} II-{1} II*-{5}";
truestr = new Set(truestr.split(" "));
let compstr = new Set(comps.map(c => String(c)));
Assert(SetsEqual(truestr, compstr));

comps = PrincipalTypes(-2, []);
truestr = "I1_1 I1g1 Ig2 [2]I1_D [2]I_D,D,D [2]Ig1_D D_{2-2} I1*_D Dg1 I1*_0 [2]I1*_D [2]T_{6}D 4^1,3_D I0*_D I0*_0 [2]I0*_D IV_0 [2]IV_D IV*_-1 [2]IV*_D III_0 III_D [2]III_D III*_D III*_-1 [2]III*_D II_D [2]II_D II*_D [2]II*_D 2^1,1,1,1,1,1 3^1,1,2,2 4^1,3,2,2 5^1,1,3 5^1,2,2 5^2,4,4 5^3,3,4 6^1,1,4 6^2,4,3,3 6^5,5,2 8^1,3,4 8^5,7,4 10^1,4,5 10^3,2,5 10^7,8,5 10^9,6,5"
truestr = new Set(truestr.split(" "));
compstr = new Set(comps.map(c => String(c)));
Assert(SetsEqual(truestr, compstr));

comps = PrincipalTypes(-6, [2, 2]);
truestr = "[2]I1_D-{2}-{2} [2]I_D,D,D-{2}-{2} [2]Ig1_D-{2}-{2} D_{2-2}-{2}-{2} I1*_D-{2}-{2} Dg1-{2}-{2} I1*_0-{2}-{2} [2]T_{6}D-{2}-{4} I0*_D-{2}-{2} I0*_0-{2}-{2} [2]I0*_D-{2}-{2} [2]IV_D-{2}-{2} [2]IV*_D-{4}-{4} 2^1,1,1,1,1,1-{2}-{2} 4^1,3,2,2-{2}-{2} 6^2,4,3,3-{2}-{4}"
truestr = new Set(truestr.split(" "));
compstr = new Set(comps.map(c => String(c)));
Assert(SetsEqual(truestr, compstr));

comps = PrincipalTypes(-6, [2, 4]);
truestr = "[2]I1*-{2}-{4} [2]I0*-{2}-{4} III-{2}-{4} [2]III-{2}-{4} III*-{2}-{4} [2]III*-{6}-{4} [2]II-{2}-{4} [2]II*-{10}-{8}"
truestr = new Set(truestr.split(" "));
compstr = new Set(comps.map(c => String(c)));
Assert(SetsEqual(truestr, compstr));
*/


function PrincipalTypesTeX(T, options = {}) {
  /*
  TeX a list of principal types T as a rectangular table in a TikZ picture, with options:
    label  [=false]     puts the principal type label underneath.  
    sort   [=true]      sorts the types by Score first, in increasing order.
    yshift [="default"] controls the y-axis shift after every row, based on label presence.
    width  [=10]        controls the number of principal types per row.
    length [="35pt"]    controls the length of each arc.
    scale  [=0.8]       controls the TikZ picture global scale.
  */

  // Extract options with default values
  const {
    width = 10,                // Number of principal types per row
    scale = 0.8,               // Global scale of the TikZ picture
    sort = true,               // Sort the types by Score
    label = false,             // Include label underneath each principal type
    length = "35pt",           // Length of each arc
    yshift = "default"         // Vertical shift between rows
  } = options;

  // Sort the principal types by Score if the sort option is true
  if (sort) {
    T.sort((S1, S2) => S2.Score() - S1.Score());  // Sorting by Score in increasing order
  }

  // Determine the vertical shift (yshift) based on whether labels are included
  let actualYShift = yshift === "default" ? (label ? 2 : 1.2) : yshift;

  let dx = 2.5, dy = 0;  // Default x and y shifts

  const out = [];
  T.forEach((S, i) => {
    if ((i + 1) % width === 0) {   // On every "width"-th item, reset dx and shift downwards
      dx = -(width - 1) * 2.5;
      dy = -actualYShift;
    } else {
      dx = 2.5;
      dy = 0;
    }

    const shift = (i === T.length - 1) ? "" : ` ++(${dx},${dy})`;  // No shift for the last item
    out.push(S.TeX({label: label, length: length}) + shift);       // Append TeX of the principal type with optional label and length
  });
  const out_str = out.join(" "); 

  // Return the complete TikZ picture code
  return `\\begin{tikzpicture}[scale=${scale}]\n\\draw(0,0)\n${out_str};\n\\end{tikzpicture}\n`;
}


/*
Example TeX for principal components
// Take all 13 principal types with chi=-1 (10 Kodaira + 3 'exotic'), and draw them as a TeX table of width 7
let L = PrincipalTypes(-1)
console.log(PrincipalTypesTeX(L, {label: true, width: 7, yshift: 2.2}))
*/


/*
function ScoreIsSmaller(newSeq, bestSeq) {  // old version
  for (let i = 0; i < Math.min(newSeq.length, bestSeq.length); i++) {
    if (newSeq[i] < bestSeq[i]) return "<";  // New has smaller value earlier
    if (newSeq[i] > bestSeq[i]) return ">";  // New has greater value earlier
  }
  if (newSeq.length === bestSeq.length) return "=";  // New and best are identical
  return newSeq.length > bestSeq.length ? "l" : "s";  // Length comparison
}
*/

/*
Test
Assert(ScoreIsSmaller([1, 2, 3], [4, 5, 6]) === "<", "Test 1 Failed");  // Test 1: New is smaller
Assert(ScoreIsSmaller([5, 6, 7], [1, 2, 3]) === ">", "Test 2 Failed");  // Test 2: New is greater
Assert(ScoreIsSmaller([3, 4, 5], [3, 4, 5]) === "=", "Test 3 Failed");  // Test 3: Identical sequences
Assert(ScoreIsSmaller([2, 3], [2, 3, 4]) === "s", "Test 4 Failed");     // Test 4: New is shorter but identical start
Assert(ScoreIsSmaller([1, 2, 3, 4], [1, 2, 3]) === "l", "Test 5 Failed");  // Test 5: New is longer but identical start
Assert(ScoreIsSmaller([2, 1, 5], [2, 3, 4]) === "<", "Test 6 Failed");  // Test 6: New has smaller value earlier
Assert(ScoreIsSmaller([7, 8, 1], [7, 5, 9]) === ">", "Test 7 Failed");  // Test 7: New has greater value earlier
Assert(ScoreIsSmaller([2, 3, 4, 5], [3, 4, 5]) === "<", "Test 8 Failed");  // Test 8: New is longer and starts smaller
Assert(ScoreIsSmaller([4, 5], [3, 4, 5]) === ">", "Test 9 Failed");     // Test 9: New is shorter but starts greater
Assert(ScoreIsSmaller([3, 4], [3, 4, 2]) === "s", "Test 10 Failed");    // Test 10: Identical start but new is shorter
*/


/// Basic labelled undirected graphs (Graph)


/*
Manual
This section provides a basic implementation of labelled undirected graphs, offering core functionality for graph manipulation in javascript. It allows the user to construct graphs using a set of vertices and edges, and supports key operations such as adding and removing vertices and edges, checking for the existence of specific vertices or edges, and retrieving or modifying vertex labels.

Graph traversal and connectivity are handled through \texttt{BFS} (breadth-first search), \texttt{ConnectedComponents}, which is used later for connectivity testing, and
\texttt{MinimumScorePaths}. The latter is used to generate a canonical label for a vertex-labelled graph that can be used for isomorphism testing (\texttt{IsIsomorphic}).

The library also supports generating subgraphs from a subset of edges (\texttt{EdgeSubgraph}), and copying the entire graph (\texttt{Copy}).

Finally, we have visualization functions \texttt{TeXGraph} and \texttt{SVGGraph} to draw  graphs in TikZ and HTML.
*/


class Graph {
  constructor(vertexSet = [], edgeSet = []) {
    /*
    Initialize the graph with a set of vertices and edges. vertexSet can be an integer (number of vertices) -> [1,2,3,...]
    EdgesSet should be a list of edges e.g. [[1,2],[2,3],[3,4]] with vertices from vertexSet
    */
    if (Number.isInteger(vertexSet))     // Graph(5,edges) is allowed -> vertexSet = [1,2,3,4,5]
    {
      vertexSet = Array.from({ length: vertexSet }, (v, i) => i + 1);
    }

    this.vertices = new Map();     // Stores vertices and their labels
    this.edges    = new Set();     // Stores edges as sorted pairs of vertices
    this.isolabel = null;          // label for isomorphism testing (uses vertex assignments)

    // Add all vertices from the vertexSet
    vertexSet.forEach(vertex => {
      this.AddVertex(vertex);
    });

    // Add all edges from the edgeSet
    edgeSet.forEach(edge => {
      this.AddEdge(edge[0], edge[1]);
    });
  }

  AddVertex(vertex, label = undefined) {
    /*
    Add a vertex with an optional label. If the vertex already exists, update its label.
    */
    if (!this.vertices.has(vertex)) {
      this.vertices.set(vertex, label);  // Add vertex with label
    } else {
      this.vertices.set(vertex, label);  // Update label if vertex already exists
    }
  }

  AddEdge(vertex1, vertex2) {
    /*
    Add an edge between two vertices (both vertices must exist).
    */
    if (!this.vertices.has(vertex1) || !this.vertices.has(vertex2)) return;  // Both vertices must exist

    // Sort the vertices to ensure (v1, v2) is the same as (v2, v1)
    const edge = [vertex1, vertex2].sort((a, b) => a - b);
    this.edges.add(edge);  // Add edge as an array of two integers
  }

  RemoveVertex(v) {
    /*
    Remove a vertex v from the graph, together with its incident edges
    */
    if (!this.vertices.has(v)) {
      throw new Error(`Vertex ${v} does not exist.`);
    }
    this.vertices.delete(v);     // Remove the vertex and edges
    this.edges = new Set([...this.edges].filter(edge => !edge.includes(v)));
    // console.log(`Vertex ${v} and its edges have been removed.`);
  }

  HasVertex(vertex) {
    /*
    Check if a vertex exists in the graph.
    */
    return this.vertices.has(vertex);
  }

  GetLabel(vertex) {
    /*
    Get the label of a vertex. Returns undefined if the vertex doesn't exist.
    */
    return this.vertices.get(vertex);
  }

  SetLabel(vertex, label) {
    /*
    Set the label for a specific vertex. Raises an error if the vertex doesn't exist.
    */
    if (!this.vertices.has(vertex)) {
      throw new Error(`Vertex ${vertex} does not exist.`);
    }
    this.isolabel = null;
    this.vertices.set(vertex, label);
  }

  GetLabels() {
    /*
    Get all labels in the graph.
    */
    return Array.from(this.vertices.values());
  }

  SetLabels(labels) {
    /*
    Set labels for all vertices. Raises an error if the number of labels doesn't match the number of vertices.
    */
    const vertexArray = Array.from(this.vertices.keys());
    if (labels.length !== vertexArray.length) {
      throw new Error("Number of labels must match the number of vertices.");
    }
    this.isolabel = null;
    vertexArray.forEach((vertex, index) => {
      this.vertices.set(vertex, labels[index]);
    });
  }

  RemoveLabels() {
    /*
    Remove labels from graph vertices
    */
    this.isolabel = null;
    this.Vertices().forEach(v => this.SetLabel(v, undefined));  
  }

  HasEdge(vertex1, vertex2) {
    /*
    Check if an edge exists between two vertices. No loops are allowed.
    */
    const edge = [vertex1, vertex2].sort((a, b) => a - b);
    for (let e of this.edges) {
      if (e[0] === edge[0] && e[1] === edge[1]) {
        return true;
      }
    }
    return false;
  }

  Vertices() {
    /*
    Return the set of vertices as an array.
    */
    return Array.from(this.vertices.keys());
  }

  Edges(v = undefined) {
    /*
    If v is undefined, return all edges as an array of arrays of length 2.
    If v is defined, check it is a vertex, and return all edges where v is one of the vertices.
    */
    if (v === undefined) {
      return Array.from(this.edges);      // Return all edges
    }
    if (!this.vertices.has(v)) {          // Check v is a vertex
      throw new Error(`Vertex ${v} is not in the graph`);
    }
    // Return edges from v
    return Array.from(this.edges).filter(edge => edge[0] === v || edge[1] === v);
  }

  Neighbours(vertex) {
    /*
    Get all neighbours of a given vertex. This returns an array of adjacent vertices, and loops contribute twice.
    */
    const neighbours = [];
    for (let edge of this.edges) {
      if (edge[0] === vertex) neighbours.push(edge[1]);
      if (edge[1] === vertex) neighbours.push(edge[0]);
    }
    return neighbours;
  }

  BFS(startVertex) {
    /*
    Perform BFS starting from the given vertex and return the connected component as an array.
    */
    const visited = new Set();  // Set of visited vertices
    const queue = [startVertex];  // Queue for BFS
    const component = [];  // List to store the connected component

    while (queue.length > 0) {
      const vertex = queue.shift();  // Dequeue the next vertex
      if (!visited.has(vertex)) {
        visited.add(vertex);  // Mark vertex as visited
        component.push(vertex);  // Add vertex to the connected component

        // Enqueue all unvisited neighbours
        const neighbours = this.Neighbours(vertex);
        neighbours.forEach(neighbor => {
          if (!visited.has(neighbor)) {
            queue.push(neighbor);
          }
        });
      }
    }

    return component;  // Return the connected component
  }

  ConnectedComponents() {
    /*
    Find all connected components in the graph using BFS. Return as an array of arrays of vertices.
    */
    const visited = new Set();  // Set of visited vertices
    const components = [];  // Array to store all connected components

    // Perform BFS for each unvisited vertex
    this.Vertices().forEach(vertex => {
      if (!visited.has(vertex)) {
        const component = this.BFS(vertex);  // Get connected component
        components.push(component);  // Add component to the list
        component.forEach(v => visited.add(v));  // Mark all vertices in the component as visited
      }
    });

    return components;  // Return the list of connected components
  }

  RemoveEdge(vertex1, vertex2) {
    /*
    Remove an edge from the graph
    */
    const edge = [vertex1, vertex2].sort((a, b) => a - b);
    this.edges.delete(edge);
  }
  
  EdgeSubgraph(edgeSet) {
    /*
    Returns a new Graph object containing only the specified edges
    */
    const newGraph = new Graph(this.Vertices());
    edgeSet.forEach(edge => {
      if (this.HasEdge(edge[0], edge[1])) {
        newGraph.AddEdge(edge[0], edge[1]);
      }
    });
    return newGraph;
  }

  Degree(vertex) {
    /*
    Returns the degree of a vertex (number of indident edges)
    */
    return this.Neighbours(vertex).length;
  }

  Copy() {
    /*
    Copy a graph
    */
    const newGraph = new Graph();
    this.vertices.forEach((label, vertex) => {
      newGraph.AddVertex(vertex, label);
    });
    this.edges.forEach(edge => {
      newGraph.AddEdge(edge[0], edge[1]);
    });
    return newGraph;
  }

  Label(options = {}) {
    /*
    Generate a graph label based on a minimum score path, determines G up to isomorphism.
    The label is constructed by iterating through the minimum score path and formatting 
    the vertices and edges with labels, if present.
    */

    const {
      full              = false, 
      usevertexlabels   = true,
      unlabelled_format = "v",       // formats vertex (#0), vlabel (#1) -> string
      labelled_format   = "{1}",
      revisited_format  = "c{0}",
      edge_symbol       = "-",
      jump_symbol       = "&",
    } = options;

    const savelabels = this.GetLabels();
    if (!usevertexlabels) {
      this.RemoveLabels();                                         // Remove labels
    }
    const [P, T] = MinimumScorePaths(this);                       // Get the minimum score path P and the trails
    this.SetLabels(savelabels);                                    // Restore labels

    let label = "";                                 
    P.forEach(data => {
      const [vertex, vlabel, jump] = data;  
      let vstr;
      if (vlabel === 0 || !usevertexlabels) {
        vstr = FormatString(unlabelled_format,vertex,vlabel);      // Use "v" for unlabelled vertices by default
      } else {
        vstr = FormatString(labelled_format,vertex,vlabel);        // Use label for labelled vertices by default
      }
      if (vertex === 0) {
        label += vstr;                                             // Append the new vertex label
      } else {
        label += FormatString(revisited_format,vertex,vlabel);     // Append c1,c2,... by default
      } 
      if (jump) {
        label += jump_symbol;  // Use "&" for jump by default
      } else {
        label += edge_symbol;  // Use "-" for edge by default
      }
    });

    label = label.slice(0, -1);              // Remove the last "&" symbol before returning

    if (full) {
      return [label, P ,T];     
    } else {
      return label;
    }      
  }
  
  IsIsomorphic(other) {
    /*
    Test whether are two graphs are isomorphic, through their labels
    */
    if (!(other instanceof Graph)) {
      throw new Error("IsIsomorphic 'other' parameter is not a Graph");
    }
    const options = {labelled_format: "[{1}]"};
    if (this.isolabel === null) {
      this.isolabel = this.Label(options);     // Compute and store label if not already set
    }
    if (other.isolabel === null) {
      other.isolabel = other.Label(options);   //    for the other graph as well
    }
    return this.isolabel === other.isolabel;
  }  

}


/*
Example Graph usage
const graph = new Graph();
graph.AddVertex(1, "A");
graph.AddVertex(4, "B");
graph.AddVertex(6, "C");
graph.AddEdge(1, 4);
graph.AddEdge(4, 6);
console.log(graph.HasVertex(1));     // true
console.log(graph.GetLabel(4));      // "B"
console.log(graph.HasEdge(1, 4));    // true
console.log(graph.HasEdge(1, 6));    // false
*/


/*
Example Graph usage
const graph = new Graph();
graph.AddVertex(1, "A");
graph.AddVertex(4, "B");
graph.AddVertex(6, "C");

graph.AddEdge(1, 4);
graph.AddEdge(4, 6);

console.log(graph.Vertices());  // [1, 4, 6]
console.log(graph.Edges());    // [[1, 4], [4, 6]]
console.log(graph.HasEdge(4, 1)); // true (order doesn't matter)

const graph2 = new Graph([1,2,3],[[1,2],[2,3]]);     // Same graph defined differently 
graph2.SetLabels(["C","B","A"]);

console.log(graph.IsIsomorphic(graph2));
*/

/*
Example Connected components
const graph = new Graph([1, 2, 3, 4, 5], [[1, 2], [2, 3], [4, 5]]);
const components = graph.ConnectedComponents();
console.log(components);  // Example output: [[1, 2, 3], [4, 5]]
*/



function MinimumScorePaths(D) {
  /*
  Determines minimum score paths in a connected labelled undirected graph, returning scores and possible vertex index sequences.

  Minimum score paths for a labelled undirected graph (e.g. double graph underlying shape)
  returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism) 
    and I=list of possible vertex index sequences
  For example for a rectangular loop G with all vertex chis=1 and edges as follows
    V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  
  the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is 
    W = [<0,[-1],false>,<0,[-1],false>,<0,[-1],false>,<0,[1,1],false>,<0,[-1],false>,
         <0,[2],false>,<1,[-1],true>]
  The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded
    T = [[3,2,1,6,4,5,3]]
  */
  
  if (D instanceof RedShape) {
    return MinimumScorePaths(D.DoubleGraph());
  }
  
  // Check if the graph is connected
  if (D.ConnectedComponents().length > 1) {
    throw new Error("MinimumScorePaths requires the graph to be connected");
  }

  // Check if any edge is labeled (not implemented for labeled edges)
  for (let edge of D.Edges()) {
    if (edge.label !== undefined) {
      throw new Error("MinimumScorePaths is implemented for unlabelled edges");
    }
  }

  const V = D.Vertices(); // Vertices
  const E = D.Edges();   // Edges

  vprint("Edges:", E);

  // Check if all vertices are unlabeled
  const unlabelled = V.every(v => D.GetLabel(v) === undefined);

  if (unlabelled) {
    V.forEach(v => D.SetLabel(v, 0));                 // Assign zero labels to vertices
    const [W, T] = MinimumScorePaths(D);
    V.forEach(v => D.SetLabel(v, undefined));         // Remove labels and return MinimumScorePaths
    return [W, T];
  }

  const oddVertices = V.filter(v => D.Degree(v) % 2 === 1); // Odd degree vertices
  let start = oddVertices.length > 0 ? oddVertices : V;

  // console.log("findminlabel: ",start.map(v => D.GetLabel(v)));
  const minLabel = FindMinimalLabel(start.map(v => D.GetLabel(v)));         // Minimum label among starting vertices
  // console.log("before:      ",start);
  start = start.filter(v => ArraysEqual(D.GetLabel(v),minLabel));    // Filter vertices with the minimum label
  // console.log("filtered to: ",start);

  // Initialize the path sequences
  let P = [];
  start.forEach(v => {
    const label = D.GetLabel(v);
    const jump = V.length === 1;
    const index = 1;
    const indices = V.map(w => (w === v ? 1 : 0));
    const edgesleft = [new Set(E)]; // All edges in one connected component
    const score = [[0, label, jump]];
    P.push({ indices, edgesleft, oddVertices, score, v });
  });

  vprint("Starting paths:", P);

  let bestscore = P[0].score;
  let bestindices = [P[0].indices];
  let counter = 0;

  while (P.length > 0) {
    counter += 1;
    if (counter > PathsMaxSteps) {
      console.log("Number of steps exceeded, exiting");
      return [[], []];
    }

    const p = P.shift(); // Dequeue the next path
    const { indices, edgesleft, oddVertices: odd, score, v } = p;

    vprint(`${counter} Processing indices=${indices}, edgesleft=${edgesleft}, odd=${Array.from(odd)}, score=${score}, v=${v}(${D.GetLabel(v)}) [bestscore=${bestscore}]`);

    if (ScoreIsSmaller(score, bestscore) === ">") {
      continue;
    }
    
    const [index, label, jump] = score[score.length - 1];

    let Vnext = [];

    if (!jump) {
      edgesleft.forEach(component => {
        component.forEach(e => {
          if (e[0] !== v && e[1] !== v) return;

          const w = e[0] === v ? e[1] : e[0]; // Edge leads to w from v

          vprint(`Trying edge ${v} -> ${w}`);
          
          const newodd = SymmetricDifference(odd, new Set([v, w]));

          const D0 = D.EdgeSubgraph([...component].filter(e2 => e2 !== e)); // Create subgraph excluding edge e
          const components = D0.ConnectedComponents(); // Get connected components

          const C = components.filter(c => c.length > 1);

          vprint(`C = ${C}`);

          const newoddarray = Array.from(newodd);
          if (C.some(c => !newoddarray.some(o => c.includes(o)) && !c.includes(w))) {
            vprint(`Trying ${w}(${D.GetLabel(w)}) -> Abandoning`);
            return;
          }

          const newedgesleft = C.map(c => 
            new Set([...component].filter(e2 => c.includes(e2[0]) && c.includes(e2[1]) && e2 !== e))
          ).concat(edgesleft.filter(comp => comp !== component));
  
          Vnext.push({ w, newedgesleft, newodd });
          vprint(`Trying ${w}(${D.GetLabel(w)}) -> Adding`);
        });
      });
    } else {
      const oddarray = Array.from(odd);
      Vnext = oddarray.map(o => ({ w: o, newedgesleft: edgesleft, newodd: odd }));
    }

    vprint("Vnext =", Vnext);
    
    Vnext.forEach(data => {
      const { w, newedgesleft, newodd } = data;
      const i = V.indexOf(w) + 1;
      const newlabel = D.GetLabel(w);
      const newjump = !newedgesleft.some(comp => [...comp].some(e => e.includes(w)));

      const newindices = indices.slice();
      const newindex = newindices[i - 1];
      const newscore = score.concat([[newindex, newlabel, newjump]]);

      const sgn = ScoreIsSmaller(newscore, bestscore);

      if (newindex === 0) {
        newindices[i - 1] = newscore.length;
      }

      if (newscore.length > bestscore.length && sgn !== "l") {
        throw new Error(`MinimumScorePaths internal error: new score is longer than best score but not compatible (sgn=${sgn})\nnew score  = ${newscore}\nbest score=${bestscore}`);
      }

      vprint(`newi=${newindex} new=${newscore} best=${bestscore} sgn=${sgn}`);
      
      if (sgn === "<" || sgn === "l") {
        bestindices = [newindices];
        bestscore = newscore;
      } else if (sgn === "=") {
        bestindices.push(newindices);
      } else {
        return;
      }

      P.push({ indices: newindices, edgesleft: newedgesleft, oddVertices: newodd, score: newscore, v: w });
    });
  }

  vprint(`#steps=${counter} bestscore=${bestscore} bestindices=${bestindices}`);

  // Construct trails from best indices and best score
  const trails = bestindices.map(a => {
    return bestscore.map((p, i) => {
      if (p[0] === 0) {
        return a.indexOf(i + 1) + 1;
      } else {
        return a.indexOf(p[0]) + 1;
      }
    });
  });

  return [bestscore, trails];
}


/*
Example A-B-C-c1
const G = new Graph();
G.AddVertex(1);
G.AddVertex(2);
G.AddVertex(3);
G.AddEdge(1, 2);
G.AddEdge(2, 3);
G.AddEdge(3, 1);
G.SetLabels(["A", "A", "A"]);
const [P, a] = MinimumScorePaths(G, false);
console.log("P:", P);
console.log("a:", a);
*/


/*
Example MinimumScorePaths
const G = new Graph();
G.AddVertex(1, "C");
G.AddVertex(2, "B");
G.AddVertex(3, "C");
G.AddVertex(4, "A");
G.AddEdge(1, 2);
G.AddEdge(2, 3);
G.AddEdge(3, 4);
G.AddEdge(4, 1);
G.AddEdge(1, 3);
// Calculate minimum score paths
const [P, a] = MinimumScorePaths(G, false);
// Print the minimal path
console.log("P:", P);
console.log("a:", a);
console.log("G = ", G.Label());
// Example 2: Another graph on five vertices, not Eulerian
const G2 = new Graph();
G2.AddVertex(1, "A");
G2.AddVertex(2, "B");
G2.AddVertex(3, "A");
G2.AddVertex(4, "A");
G2.AddVertex(5, "C");
G2.AddEdge(2, 1);
G2.AddEdge(2, 3);
G2.AddEdge(2, 4);
G2.AddEdge(2, 5);
// Calculate minimum score paths
const [P2, a2] = MinimumScorePaths(G2, false);
// Print the minimal path
console.log("P2:", P2);
console.log("a2:", a2);
console.log("G2 = ", G2.Label());
*/


/*
Example Minimum score paths
var G = new Graph(4, [[1, 2], [2, 3], [3, 4], [4, 1], [1, 3]]);
G.SetLabels(["C", "B", "C", "A"]);
console.log(TeXGraph(G));
// \par Now we calculate minimum score paths:
let [P, a] = MinimumScorePaths(G);
// Print the minimal path and the trails, both from one odd degree vertex to the other one:
console.log("P:", P);
console.log("a:", a);
// Here is another graph on five vertices, this time not Eulerian
G = new Graph(5, [[2, 1], [2, 3], [2, 4], [2, 5]]);
G.SetLabels(["A", "B", "A", "A", "C"]);
console.log(TeXGraph(G));
// \par Calculate minimum score path, which is A-B-A, A-2-C (where 2 is `second vertex on the path')
[P, a] = MinimumScorePaths(G);
// Print the minimal path
console.log("P:", P);
// There are 6 ways to trace this path, and they form an Aut(G)=S3-torsor. The first one is
console.log(`One trail out of ${a.length} is ${a[0]}`);
*/


function PrintReal(x, prec = 2) {    //
  /*
  Print a real number with a fixed number of decimals after the dot (and no trailing zeroes)
  */
  let s = x.toFixed(prec);
  let n = s.length;
  let p = s.indexOf(".");        // Find position of the decimal point

  if (p !== -1) {
    n = p + prec + 1;            // Truncate to 'prec' decimal places

    while (n > 1 && s[n - 1] === "0") {       // Remove trailing zeros
      n--;
    }
    
    if (n > 1 && s[n - 1] === ".") {          // Remove '.' symbol if at the end
      n--;
    }
  }

  return s.slice(0, n);
}


const gridgraphs=[                  // including all planar of size <=7, see planar.m and gridgraphs.m
  [new Graph(1,[]),[1],[1],"v"],
  [new Graph(2,[[1,2]]),[1,2],[1,1],"v-v"],
  [new Graph(3,[[2,3],[1,2]]),[1,2,3],[1,1,1],"v-v-v"],
  [new Graph(3,[[1,3],[2,3],[1,2]]),[1,2,1],[2/5,1,8/5],"v-v-v-1"],
  [new Graph(4,[[2,4],[2,3],[1,2]]),[11/10,2,11/10,3],[2/5,1,8/5,1],"v-v-v&v-2"],
  [new Graph(4,[[2,4],[2,3],[1,2],[3,4]]),[3,2,1,1],[8/5,8/5,11/5,1],"v-v-v-v-2"],
  [new Graph(4,[[2,3],[1,2],[3,4]]),[1,2,3,4],[1,1,1,1],"v-v-v-v"],
  [new Graph(4,[[1,3],[1,4],[2,3],[1,2],[3,4]]),[2,1,2,3],[1,1,2,1],"v-v-v-v-1-3"],
  [new Graph(4,[[1,4],[2,3],[1,2],[3,4]]),[1,2,3,2],[1,2/5,1,8/5],"v-v-v-v-1"],
  [new Graph(4,[[1,3],[1,4],[2,4],[2,3],[1,2],[3,4]]),[11/10,2,11/10,16/5],[2/5,1,8/5,1],"v-v-v-v-1-3&2-4"],
  [new Graph(5,[[2,5],[2,4],[2,3],[1,2]]),[1,5/2,2,3,4],[1,2,1,1,1],"v-v-v&v-2-v"],
  [new Graph(5,[[2,5],[2,4],[2,3],[1,2],[3,4]]),[1,2,3,3,1],[1,3/2,1,2,2],"v-v-v-v-2-v"],
  [new Graph(5,[[2,5],[2,3],[1,2],[3,4],[4,5]]),[37/10,27/10,9/5,1,9/5],[1,1,2/5,1,8/5],"v-v-v-v-v-2"],
  [new Graph(5,[[2,5],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v-2-4"],
  [new Graph(5,[[2,5],[2,3],[1,2],[3,4]]),[1,2,3,4,2],[1,1,1,1,2],"v-v-v-v&v-2"],
  [new Graph(5,[[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v&2-4"],
  [new Graph(5,[[1,5],[1,4],[3,5],[2,3],[1,2],[3,4]]),[1,1,3,3,2],[1,2,2,1,3/2],"v-v-v-v-1-v-3"],
  [new Graph(5,[[2,5],[1,4],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,3,11/5,3,15/4],[2,6/5,2,14/5,2],"v-v-v-v-v-2-4-1"],
  [new Graph(5,[[2,5],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3],[2,2,1,1,2],"v-v-v-v-v-2&3-5"],
  [new Graph(5,[[2,5],[3,5],[2,4],[2,3],[3,4],[1,2],[4,5]]),[21/5,16/5,11/10,2,11/10],[1,1,2/5,1,8/5],"v-v-v-v-v-2-4&3-5"],
  [new Graph(5,[[1,5],[2,5],[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,11/5,3,15/4,3],[2,2,6/5,2,14/5],"v-v-v-v-v-1-3-5-2"],
  [new Graph(5,[[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5],[1,1,1,1,1],"v-v-v-v-v"],
  [new Graph(5,[[1,5],[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[2,1,5/2,4,3],[1,1,2,1,1],"v-v-v-v-v-1-3-5"],
  [new Graph(5,[[3,5],[2,3],[3,4],[1,2],[4,5]]),[4,3,2,1,1],[1,1,1,8/5,2/5],"v-v-v-v-v-3"],
  [new Graph(5,[[1,3],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3],[1,2,2,2,1],"v-v-v-v-v-3-1"],
  [new Graph(5,[[1,5],[1,3],[2,3],[1,2],[3,4],[4,5]]),[2,3,2,1,1],[1,2,2,2,1],"v-v-v-v-v-1-3"],
  [new Graph(5,[[1,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,21/10,14/5,21/10],[7/5,13/5,3,2,1],"v-v-v-v-v-1"],
  [new Graph(5,[[1,5],[1,3],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,3,3],[1,3/2,2,2,1],"v-v-v-v-v-1-3&2-4"],
  [new Graph(5,[[1,5],[1,3],[2,4],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3],[1,2,3/2,2,1],"v-v-v-v-v-1-3-5&2-4"],
  [new Graph(5,[[1,3],[1,5],[2,5],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[7/4,6/5,6/5,15/4,11/4],[2,3,1,2,2],"v-v-v-v-v-1-3-5-2-4"],
  [new Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2]]),[1,3,2,3,5,4],[1,2,1,1,1,1],"v-v-v&v-2-v&v-2"],
  [new Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4]]),[1,2,2,3,1,3],[3/2,2,1,3/2,5/2,5/2],"v-v-v-v-2-v&v-2"],
  [new Graph(6,[[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5,2],[1,1,1,1,1,2],"v-v-v-v-v&v-2"],
  [new Graph(6,[[2,5],[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,2],[2,2,3,3,2,1],"v-v-v-v-v-2-v"],
  [new Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,2,1],[3/2,2,5/2,3/2,1,5/2],"v-v-v-v-v-2-v&2-4"],
  [new Graph(6,[[2,5],[2,6],[4,6],[2,3],[3,4],[1,2],[4,5]]),[3,3,1,2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4"],
  [new Graph(6,[[2,5],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[3,5/2,1,5/2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4-2"],
  [new Graph(6,[[2,5],[2,6],[2,3],[3,4],[1,2]]),[7/3,3,2,1,11/3,4],[2,1,1,1,2,1],"v-v-v-v&v-2-v"],
  [new Graph(6,[[2,5],[3,6],[2,3],[1,2],[3,4]]),[1,2,3,4,1,4],[1,3/2,3/2,1,2,2],"v-v-v-v&v-2&v-3"],
  [new Graph(6,[[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,2,1,2,1,2],"v-v-v-v-v&v-2-4"],
  [new Graph(6,[[2,5],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,4],[2,2,1,1,2,1],"v-v-v-v-v-2&v-4"],
  [new Graph(6,[[2,5],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,1,2,3,3],[2,2,1,1,2,1],"v-v-v-v-v-2-4-v"],
  [new Graph(6,[[2,5],[2,6],[1,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1,5/2,2,5/2,3,4],[2,1,2,3,2,2],"v-v-v-v-v-2-v-4-1"],
  [new Graph(6,[[1,5],[3,6],[1,3],[1,4],[3,5],[2,3],[1,2],[3,4],[1,6]]),[5/2,1,5/2,4,3,2],[1,2,3,2,2,2],"v-v-v-v-1-v-3-v-1-3"],
  [new Graph(6,[[2,5],[2,6],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,2,1,1,2,2],"v-v-v-v-v-2-v&3-5"],
  [new Graph(6,[[2,5],[2,6],[3,5],[2,4],[2,3],[3,4],[1,2],[4,5]]),[21/5,16/5,11/10,2,11/10,21/5],[2/5,1,2/5,1,8/5,8/5],"v-v-v-v-v-2-v&2-4&3-5"],
  [new Graph(6,[[2,6],[2,4],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4"],
  [new Graph(6,[[2,5],[2,6],[2,4],[4,6],[2,3],[3,4],[1,2],[5,6],[4,5]]),[7/2,3,9/2,3,2,1],[2,3,2,1,2,2],"v-v-v-v-v-v-2-4-6&2-5"],
  [new Graph(6,[[2,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[1,1,1,2,2,2],"v-v-v-v-v-v&2-5"],
  [new Graph(6,[[2,5],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v&2-5-3"],
  [new Graph(6,[[2,5],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[4,3,2,1,3,4],[1,1,2,2,3,3],"v-v-v-v-v-v&3-5-2-4"],
  [new Graph(6,[[2,6],[3,5],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,2,3,1],[1,2,2,1,1,2],"v-v-v-v-v-3&v-2"],
  [new Graph(6,[[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[5,4,3,2,1,1],[8/5,8/5,8/5,8/5,21/10,1],"v-v-v-v-v-v-4"],
  [new Graph(6,[[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[3,3,2,2,1,1],[1,2,1,2,1,2],"v-v-v-v-v-v-4-2"],
  [new Graph(6,[[3,6],[1,3],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3-1"],
  [new Graph(6,[[3,6],[1,3],[3,5],[2,3],[3,4],[1,2],[4,5],[1,6]]),[3,2,2,1,1,3],[2,3,2,2,1,1],"v-v-v-v-v-3-v-1-3"],
  [new Graph(6,[[2,6],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v-2&3-5"],
  [new Graph(6,[[1,3],[1,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,3,3],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5"],
  [new Graph(6,[[1,3],[1,5],[2,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2"],
  [new Graph(6,[[1,3],[1,5],[2,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,9/2,3,7/2],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2&3-5"],
  [new Graph(6,[[3,6],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,4,5,3],[1,1,1,1,1,2],"v-v-v-v-v&v-3"],
  [new Graph(6,[[2,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[19/5,14/5,21/10,1,1,21/10],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-2"],
  [new Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[1,3/2,2,5/2,2,1],"v-v-v-v-v-v-2-4&2-5"],
  [new Graph(6,[[2,4],[2,3],[3,4],[1,2],[5,6],[4,5]]),[3,3,2,2,1,1],[1,2,1,2,2,1],"v-v-v-v-v-v&2-4"],
  [new Graph(6,[[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4-6"],
  [new Graph(6,[[3,6],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3"],
  [new Graph(6,[[2,5],[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3&2-5"],
  [new Graph(6,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,2,2,1],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4-6&3-5"],
  [new Graph(6,[[1,3],[2,5],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,3,2,2,1],[1,2,2,2,3,3/2],"v-v-v-v-v-v-1-3-5-2"],
  [new Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,5/2,1,2,4],[2,2,3,2,1,2],"v-v-v-v-v-v-1-3-6&2-5"],
  [new Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[7/2,5/2,7/4,1,7/4,9/2],[5/2,5/2,7/2,5/2,3/2,5/2],"v-v-v-v-v-v-1-3-5-2&3-6"],
  [new Graph(6,[[1,3],[1,5],[2,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,5/2,7/2,9/2,7/4,1],[3/2,5/2,5/2,5/2,7/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-5"],
  [new Graph(6,[[3,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[1,2,2,3,3,1],[1,1,2,2,1,2],"v-v-v-v-v&v-3&2-4"],
  [new Graph(6,[[3,6],[3,5],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[2,1,1,1,2,2],"v-v-v-v-v-v-3-5"],
  [new Graph(6,[[2,5],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,1,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3&2-5"],
  [new Graph(6,[[2,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,1,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-5-2"],
  [new Graph(6,[[1,3],[1,5],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5-3"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,2,3,2,1],[2,3,2,2,1,1],"v-v-v-v-v-v-1-3-5"],
  [new Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,1,7/4,9/2,7/2,5/2],[7/2,5/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4"],
  [new Graph(6,[[1,3],[1,5],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,3,2,1],[2,3,3,3,2,1],"v-v-v-v-v-v-1-3-5-1"],
  [new Graph(6,[[2,6],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[2,3,4,5/2,1,5/2],[2,2,2,3,2,1],"v-v-v-v-v-v-1-4-2-6-3"],
  [new Graph(6,[[3,6],[3,5],[2,3],[3,4],[1,2],[4,5]]),[3,3,2,1,1,2],[1,2,2,1,2,1],"v-v-v-v-v-3-v"],
  [new Graph(6,[[2,5],[2,6],[2,4],[2,3],[1,2],[3,4],[5,6]]),[5/4,2,1,2,3,3],[5/4,2,3,3,2,1],"v-v-v-v-2-v-v-2"],
  [new Graph(6,[[2,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[3,3,1,2,2,4],[2,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-5"],
  [new Graph(6,[[3,6],[2,6],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[3,3,2,1,1,2],[1,2,1,1,2,2],"v-v-v-v-v-v-2&3-6-4"],
  [new Graph(6,[[3,6],[2,6],[2,4],[2,3],[3,4],[1,2],[4,5],[5,6]]),[1,2,2,1,2,3],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-6"],
  [new Graph(6,[[2,5],[2,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3/2,1,1,19/4,7/2,5/2],[5/2,7/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-2-4&2-5&3-6"],
  [new Graph(6,[[2,5],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4]]),[11/4,1,7/4,1,19/4,15/4],[5/2,7/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-4-2-5"],
  [new Graph(6,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[7/4,11/4,1,15/4,19/4,1],[5/2,5/2,3/2,5/2,5/2,7/2],"v-v-v-v-v-v-2-4-6-3-5"],
  [new Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5]]),[1,19/4,15/4,1,11/4,7/4],[7/2,5/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2"],
  [new Graph(6,[[3,6],[2,6],[2,3],[3,4],[1,2],[5,6],[4,5]]),[3,3,2,1,1,2],[1,2,2,2,1,1],"v-v-v-v-v-v-2&3-6"],
  [new Graph(6,[[1,3],[2,5],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,2,1,1,2,3],[1,2,2,3,3,2],"v-v-v-v-v-v-1-3-5-2-6"],
  [new Graph(6,[[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,3,4,5,6],[1,1,1,1,1,1],"v-v-v-v-v-v"],
  [new Graph(6,[[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,2,3,3],[2,1,1,2,2,1],"v-v-v-v-v-v&2-4&3-5"],
  [new Graph(6,[[1,3],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,1,1,2],[2,1,1,1,2,2],"v-v-v-v-v-v-1-3-6"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,1,3,5,4,3],[1,1,2,1,1,1],"v-v-v-v-v-v-1-3-5&3-6"],
  [new Graph(6,[[1,3],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3-6-4"],
  [new Graph(6,[[1,3],[1,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4],[3,6]]),[1,7/4,1,11/4,15/4,19/4],[3/2,5/2,7/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2&3-6"],
  [new Graph(6,[[2,5],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[2,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-4&2-5"],
  [new Graph(6,[[1,3],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3&4-6"],
  [new Graph(6,[[1,3],[4,6],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,7/4,11/4,3/2,13/4,15/4],[7/2,9/4,9/4,1,1,9/4],"v-v-v-v-v-v-1-3-6-4-1"],
  [new Graph(6,[[1,3],[2,5],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[5/2,7/4,15/4,5,1,7/4],[2,1,9/4,9/4,15/4,11/4],"v-v-v-v-v-v-1-3-5-2-4"],
  [new Graph(6,[[1,3],[2,5],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[3,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-3&2-5"],
  [new Graph(6,[[1,3],[2,5],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,5/2,4,3,5/2],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5-2-6-4"],
  [new Graph(6,[[3,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[47/10,37/10,27/10,9/5,1,9/5],[9/5,9/5,9/5,1,9/5,27/10],"v-v-v-v-v-v-3"],
  [new Graph(6,[[1,5],[1,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[9/4,9/4,9/4,1,1,13/4],[1,2,3,3,2,2],"v-v-v-v-v-1-v-3"],
  [new Graph(6,[[2,6],[1,4],[2,4],[2,3],[3,4],[1,2],[5,6],[4,5]]),[11/4,2,15/4,2,1,1],[2,1,2,3,13/5,7/5],"v-v-v-v-v-v-2-4-1"],
  [new Graph(6,[[3,6],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3&4-6"],
  [new Graph(6,[[3,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[4,4,3,1,2,2],[1,2,5/2,2,7/4,1],"v-v-v-v-v-v-3-5&4-6"],
  [new Graph(6,[[1,3],[1,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[2,3,3,2,1,1],[1,1,2,2,1,2],"v-v-v-v-v-v-4-1-3"],
  [new Graph(6,[[1,3],[1,4],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,2,2,3,4,4],[2,7/4,1,5/2,1,2],"v-v-v-v-v-v-4-1-3&2-4"],
  [new Graph(6,[[3,6],[2,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[4,4,3,1,2,3],[13/5,7/5,3,2,2,1],"v-v-v-v-v-v-2&4-6-3-5"],
  [new Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,3,4,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5&2-6"],
  [new Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,4,4,3],[2,2,3,13/5,7/5,1],"v-v-v-v-v-v-1-3-5&2-6-3"],
  [new Graph(6,[[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[2,1,1,2,3,3],[1,1,2,2,2,1],"v-v-v-v-v-v-1-4"],
  [new Graph(6,[[1,3],[2,6],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-1-3-6-2"],
  [new Graph(6,[[1,3],[1,4],[4,6],[2,3],[1,2],[4,5],[5,6]]),[2,1,1,3,2,3],[2,2,1,2,1,1],"v-v-v-1-v-v-v-5"],
  [new Graph(6,[[1,3],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,4,3,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-4"],
  [new Graph(6,[[1,3],[2,6],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,2,3,5,4,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-3&4-6"],
  [new Graph(6,[[1,3],[1,5],[2,6],[1,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,3/2,1,19/4,7/2,5/2],[4,5/2,1,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-6"],
  [new Graph(6,[[2,6],[3,5],[4,6],[2,3],[3,4],[1,2],[4,5],[5,6]]),[3,4,3,1,2,3],[2,2,3,2,2,1],"v-v-v-v-v-v-2&3-5&4-6"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,2,1,1],[1,1,2,2,2,1],"v-v-v-v-v-v-1-3"],
  [new Graph(6,[[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[1,8/5,27/10,33/10,14/5,8/5],[2,1,1,2,3,3],"v-v-v-v-v-v-1"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,4]]),[2,2,1,2,3,3],[1,2,2,3,3,7/4],"v-v-v-v-v-v-1-3&2-4"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[1,9/4,9/4,13/4,9/4,1],[2,1,2,2,3,3],"v-v-v-v-v-v-1-3-5&2-4"],
  [new Graph(6,[[1,3],[1,6],[5,6],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,3/2,1,5/2,7/2,19/4],[1,5/2,4,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5&2-4&3-6"],
  [new Graph(6,[[1,3],[2,5],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,5/2,4,3,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5-2&4-6"],
  [new Graph(6,[[1,3],[2,5],[4,6],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,4,3],[2,3,2,2,2,1],"v-v-v-v-v-v-1-3&2-5&4-6"],
  [new Graph(6,[[1,3],[2,5],[2,6],[4,6],[5,6],[1,6],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,7/4,7/4,5,3,3],[17/4,11/4,1,11/4,9/4,3],"v-v-v-v-v-v-1-3-5-2-6-4-1"],
  [new Graph(7,[[1,3],[1,5],[1,7],[1,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&5-7"],
  [new Graph(7,[[2,5],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,2,1,0,1,1/4,2],[7/2,7/2,5,5,4,13/4,5/2],"v-v-v-v-v-v&v-2-5-3"],
  [new Graph(7,[[2,6],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,3,1,3,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,3,4,4,25/4,5,4],[4,13/4,2,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6&5-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/2,3,3,2,5/2],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5"],
  [new Graph(7,[[4,7],[2,5],[2,6],[2,4],[4,6],[2,3],[1,2],[3,4],[4,5]]),[1/2,0,4,1/4,11/4,7/4,3/4],[3/2,5/2,1,-5/4,1,1,1/4],"v-v-v-v-v-2-v-4-v&2-4"],
  [new Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/2,3/2,5/2,5/2,13/4,17/4,17/4],[1,2,2,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-4-1-3&5-7"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6-3-7-5"],
  [new Graph(7,[[1,3],[4,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,11/4,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-4-6-1-3"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,1/4,0,7/4,11/4,7/4,1/2],[-1/4,-1/4,5/2,5/2,1,1,3/2],"v-v-v-v-v-v-3-v&2-5-3"],
  [new Graph(7,[[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[9/2,7/2,2,3,2,2,1],[2,2,2,1,0,1,1],"v-v-v-v-v-v-3-v-5"],
  [new Graph(10,[[9,10],[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8&4-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,2],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&4-7-5"],
  [new Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,3,2,3,17/4,5/2,1/2],[2,3/2,3,3,2,9/2,3/2],"v-v-v-v-v-v-v-1-3-5-2-7-3-6-4"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[1,5],[2,7],[1,6],[2,4],[1,7]]),[4,3,1,4,7,5,4],[19/4,3,3/2,2,3/2,3,3],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[2,4],[1,2],[5,7],[2,3],[3,4]]),[13/4,5/2,1,7/4,3/4,-1/4,-1/4],[9/4,3,3,9/4,4,4,5],"v-v-v-v-2-v-v-v-6"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[9/4,9/4,3/4,-1/4,-1/4,1,1],[2,3,2,3,17/4,17/4,3],"v-v-v-v-v-v-v-4-6-2"],
  [new Graph(8,[[3,6],[5,8],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-3&v-2&v-5"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5"],
  [new Graph(7,[[2,5],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[3,3,2,1,3,5,4],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-2-5&4-1-6"],
  [new Graph(7,[[1,3],[2,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[2,1,2,3,7/2,9/2,9/2],[11/4,3/4,7/4,7/4,3/4,11/4,7/4],"v-v-v-v-v-v-v-5-2-4-1-3"],
  [new Graph(9,[[2,8],[4,7],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,4,4,5,5,1,3],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-4&v-2&v-3"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6],[8,9]]),[1,1,2,2,3,3,3,2,1],[1,2,2,1,1,2,3,3,3],"v-v-v-v-v-v-v-v-v-2&3-6"],
  [new Graph(7,[[2,5],[2,6],[1,7],[5,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,1,3,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2-5"],
  [new Graph(7,[[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-2"],
  [new Graph(7,[[3,6],[2,3],[1,2],[3,4],[3,7],[4,5]]),[1,1,2,3,3,2,2],[1,2,2,2,1,1,3],"v-v-v-v-v&v-3-v"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[11/4,9/2,15/4,9/2,11/4,7/4,7/4],[0,0,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3-5-7&2-4"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,4,2,13/4,2],[1,1,1,0,3/4,2,2],"v-v-v-v-v-v-v&3-6-2-4"],
  [new Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[5,4,3,2,1,1,2,3,4],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8"],
  [new Graph(8,[[2,6],[3,8],[2,3],[1,2],[3,7],[3,4],[4,5]]),[1,1,2,3,3,1,2,2],[1,2,2,2,1,3,1,3],"v-v-v-v-v&v-2&v-3-v"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,0,21/4,15/4,5/2,3/2],[1,5/2,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&6-2-7"],
  [new Graph(9,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,5,5,1],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-5"],
  [new Graph(7,[[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-4"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,15/4,5,4,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4&2-5"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[2,2,3,3,4,5,3],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&5-3-7"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,3/2,5/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-5-2-4&3-5"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6],[7,10]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7&3-6"],
  [new Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&5-10-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2&3-6"],
  [new Graph(10,[[3,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-3&4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2-6-3&4-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[21/4,3/4,0,3/4,3/2,5/2,15/4],[1,-1/2,5/2,5/4,1/2,1,1],"v-v-v-v-v-v-v-1-3-7-2-5"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[2,3],[3,4]]),[17/4,17/4,9/4,3/4,2,3,9/4],[9/4,1,15/4,1,7/4,3/2,11/4],"v-v-v-v-v-v-v-2-4-6-2&4-7-5"],
  [new Graph(7,[[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,3,2],[1,2,2,2,2,1,1],"v-v-v-v-v&v-v-3"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[3,7],[2,3],[3,4],[3,5],[3,6]]),[1,1,2,1,5/2,3,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&6-3-7"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2&4-6"],
  [new Graph(8,[[5,6],[3,8],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-2&v-3"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[7/4,11/4,1/2,13/4,13/4,0,3/4],[1,1,0,0,9/4,9/4,5/4],"v-v-v-v-v-v-v-1-3-6-2-4"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,3,2,3/4,3/4,3/2,5/2],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[3/4,3/4,7/4,7/4,11/4,11/4,11/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,2],[1,1,9/4,1,0,1,9/4],"v-v-v-v-v-v-3-v&2-5"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,1,1,1,-1/2,1/2],"v-v-v-v-v-v-v&2-4&3-6-2-5"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&3-7-4&5-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v"],
  [new Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4-6"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[1,3/2,2,5/2,3,5/2,1],[2,3,2,3,2,1,1],"v-v-v-v-v-v-v-1-3-5&2-4"],
  [new Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3&2-5"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,3,2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3&5-2-6"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,2,3,4,4,2,1],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-3-1-5-3"],
  [new Graph(10,[[9,10],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[9/4,9/4,1,0,0,1,1],[11/4,15/4,19/4,15/4,11/4,11/4,15/4],"v-v-v-v-v-v-v-2&3-7-4-6"],
  [new Graph(10,[[5,10],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-v-3&v-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6-2&3-5"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[1/2,23/4,0,3/4,7/4,11/4,4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3"],
  [new Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7"],
  [new Graph(7,[[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,0,21/4,15/4,5/2,1/4,3/2],[3/2,5/2,1,1,1,-1/2,5/4],"v-v-v-v-v-v-v-2-4-6-2&3-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&3-6"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,6]]),[2,3,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6&5-7"],
  [new Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,1,2,2,2,3,3,3],[1,2,3,3,2,1,1,2,3],"v-v-v-v-v-v-v-v-v&2-5-8"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[3,3,4,4,3,3/2,3/2],[0,1,1,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-2-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&3-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7-5"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,5],[3,4]]),[3/4,1/4,1/4,11/2,15/4,5/2,5/4],[7/4,11/4,-1/4,1,1,1,-1/2],"v-v-v-v-v-v&v-3-5-2-4"],
  [new Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[4,9],[5,8],[1,2],[2,3],[3,4]]),[1,1,1,2,2,3,3,2,3],[1,2,3,3,2,2,1,1,3],"v-v-v-v-v-v-v-v-5-2&v-4"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5],[3,6]]),[21/4,17/4,3,9/4,2,3/4,17/4],[1,1,3/2,11/4,7/4,1,9/4],"v-v-v-v-v-v-2-v&2-4-6-3-5"],
  [new Graph(8,[[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3"],
  [new Graph(10,[[9,10],[7,8],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-3"],
  [new Graph(8,[[2,5],[4,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,1,2,2,2,3,3],[1,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-4&2-5"],
  [new Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-4"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[1,6],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[2,15/4,15/4,11/4,7/4,3/4,13/4],[3,7/2,1,3/2,7/4,1,5/2],"v-v-v-v-v-v-1-v-3-1-4-6-3"],
  [new Graph(7,[[1,3],[4,7],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,11/4,4,4,3,3],[1,2,2,1,0,0,1],"v-v-v-v-v-v-v-4&3-1-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,11/4,2,3],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-1-3-7&2-5"],
  [new Graph(9,[[2,5],[7,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1],[1,1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-v&2-5&4-7"],
  [new Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[7/4,7/4,3,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-1-3-7-4-6"],
  [new Graph(7,[[3,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1],[1,2,2,2,1,1,2],"v-v-v-v-v-v-3&v-2"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5]]),[15/4,21/4,0,1/2,0,3/2,5/2],[1,1,-1/2,1,5/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5-7"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[13/4,11/2,17/4,17/4,21/4,6,13/4],[11/4,15/4,11/4,7/4,11/4,7/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-4-1"],
  [new Graph(9,[[5,6],[3,8],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-5"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,11/4,1/2,0,3/4,7/4,11/4],[1,-1/4,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-1-3-7-4-1"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v&4-2-5"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,0,1/2,0,21/4,15/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6&5-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[2,2,1,1,-1/2,-1/2,1],[3,4,5,4,4,3,3],"v-v-v-v-v-v-v-2-4-7&3-5"],
  [new Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,19/4,13/4,7/4,1,1/4],[3/2,5/2,1,1,5/4,1/2,-1/4],"v-v-v-v-v-v-v-2-4-7-3&2-5"],
  [new Graph(9,[[2,8],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,5,2],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-2&v-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[4,5,3,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2&3-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,5,3,1,11/4,2,3],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5"],
  [new Graph(8,[[4,8],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,3,2,1,1,5,2],[1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,15/4,15/4,11/4,7/4],[11/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v&2-5-3-6"],
  [new Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-1-3-6-4"],
  [new Graph(7,[[2,6],[5,6],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,1,1,-1/4,3/4,-1/4],"v-v-v-v-v-v-2-4&v-5-3"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5]]),[9/4,9/4,1,-1/4,-1/4,1/4,1],[2,3,17/4,17/4,13/4,9/4,3],"v-v-v-v-v-v-v-3-5-7-2"],
  [new Graph(8,[[7,8],[3,8],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-v-3"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[21/4,1/2,0,3/4,7/4,11/4,15/4],[1,-1/2,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7&3-6"],
  [new Graph(7,[[1,3],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[5,4,3,1,2,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6-2-7-4"],
  [new Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-4-1-5"],
  [new Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7"],
  [new Graph(7,[[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,2,2,1,1],[1,1,2,2,3,3,2],"v-v-v-v-v-v-v-4-1"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[4,6],[2,3],[1,2],[3,4],[4,5]]),[3/4,7/4,17/4,7/4,13/4,9/4,3/4],[2,2,3/4,-1/2,3/4,3/4,1],"v-v-v-v-v-2-v-4-2-v"],
  [new Graph(8,[[5,6],[6,7],[4,5],[5,8],[1,2],[2,7],[2,3],[3,4]]),[5,4,4,3,2,2,3,1],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v-v-2&v-5"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4-6&5-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-4&5-7"],
  [new Graph(9,[[2,5],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,1,1,2],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-6&2-5"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[3,4,4,3,2,2,1,1,5,5],[2,2,1,1,1,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-2&v-3"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-5"],
  [new Graph(7,[[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[13/4,9/4,1,1,-1/2,-1/2,9/4],[3,3,4,3,3,2,2],"v-v-v-v-v-v&v-2-4&3-5"],
  [new Graph(7,[[3,5],[6,7],[2,3],[3,6],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[2,4],[1,7]]),[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6&5-7"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,3,2,2,1,1,4],[2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v&v-4&3-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,2,1/2,1/2,5,7/2],[1,1/2,2,5/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-2&6-3-7"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[7,9],[2,3],[3,4]]),[1,1,2,2,3,3,4,4,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-5&v-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[1/2,21/4,0,3/4,7/4,11/4,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5&3-6"],
  [new Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[4,19/4,3,7/4,7/4,11/4,17/4],[1,7/4,2,2,1,0,0],"v-v-v-v-v-v-v-1-3-5&2-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[11/4,3/4,4,23/4,0,3/4,7/4],[1,-1/2,1,1,5/2,5/4,5/4],"v-v-v-v-v-v-v-1-3-5-2-4"],
  [new Graph(7,[[1,5],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,4,2,2,2,1,13/4],[0,3/2,2,1,0,1,3/4],"v-v-v-v-v-v-3-v-1-5"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[2,3,4,5,13/4,1,3],[1,1,1,1,0,1,2],"v-v-v-v-v-v-v-2&4-7-3-5"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3&2-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,5/2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&6-3-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-3-7"],
  [new Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,3,2,5/2],[5/4,9/4,3,2,1,1,3],"v-v-v-v-v-v-4&v-3"],
  [new Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,4,5/2,5/2,5/4,0,9/4],[9/4,1,3/2,5/2,2,5/4,15/4],"v-v-v-v-v-v-v-2-4-7&2-6-3"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[-1/2,1/2,7/4,7/2,7/2,5/2,3/2],[7/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v-2-5-3-6"],
  [new Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9&5-8"],
  [new Graph(9,[[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4],[1,2,2,1,1,1,1,2,2],"v-v-v-v-v-v-v-v-v-6"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3"],
  [new Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[11/4,11/4,4,5,4,4,11/4],[0,1,2,1,0,1,2],"v-v-v-v-v-v-3-v&4-6"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7-5"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,3],[3,4]]),[-1,0,7/4,1/2,11/4,4,3/4],[5/2,5/2,3/4,-1,1,1,1/4],"v-v-v-v-v-v-2-4-v&2-5&4-6"],
  [new Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v-v-3-6&v-2"],
  [new Graph(10,[[9,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&4-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,4,3,3],[9/4,9/4,7/4,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-2&3-5-7-4"],
  [new Graph(7,[[2,6],[5,6],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[11/4,4,4,5,3,3,2],[2,2,1,1,-1/2,1,-1/2],"v-v-v-v-v-v-2-4&v-5"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[5,4,7/2,3,2,2,15/4],[1,1,0,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-4-7"],
  [new Graph(9,[[2,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,1,2],[1,2,2,3,3,2,1,3,1],"v-v-v-v-v-v-v&v-2&v-3-6"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7-5"],
  [new Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,11/4,4,11/4,0,3/4,3/2],[-1/4,-1/4,1,1,5/2,3/2,3/4],"v-v-v-v-v-v-v-1-3-5-1-4-7"],
  [new Graph(7,[[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,5/2,1,1,1,5/2,13/4],[2,3,3,2,1,1,7/4],"v-v-v-v-v-v-v-2&4-1-6"],
  [new Graph(8,[[2,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,2,2,1,1,4],[1,1,1,1,2,2,1,2],"v-v-v-v-v-v-v&v-2"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,4,23/4,0,11/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-2-v&4-6-3-5"],
  [new Graph(9,[[7,8],[5,6],[6,9],[6,7],[4,9],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,1,1,2,3,3,3,2,2],[1,2,3,3,3,2,1,1,2],"v-v-v-v-v-v-v-v-v-2&4-9-6"],
  [new Graph(10,[[9,10],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-v&4-9"],
  [new Graph(7,[[1,3],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/4,7/4,0,3/4,5/2,4,11/4],[5/4,5/4,5/2,-1/2,-1/2,1,1],"v-v-v-v-v-v-v-4-6-3-1"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,21/4,1/4,3/2,5/2,15/4],[3/2,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6&3-7-4"],
  [new Graph(7,[[2,5],[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[2,3,4,4,3,2,4],[5/2,5/2,5/2,3/2,3/2,3/2,1/2],"v-v-v-v-v-2-v&v-4-2"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,7/4,11/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[1,7/4,11/4,1/2,3/4,5,15/4],[7/4,1,1,11/4,-1/2,1,1],"v-v-v-v-v-v-v-3-5-7-4-6"],
  [new Graph(7,[[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[9/4,13/4,13/4,9/4,3/2,3/4,3/4],[5/4,5/4,9/4,9/4,3,9/4,5/4],"v-v-v-v-v-v-v-1-4"],
  [new Graph(7,[[2,5],[2,6],[2,4],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1/2,0,0,15/4,21/4,5/2,3/2],[5/4,5/2,-1/2,1,1,1,1],"v-v-v-v-v-2-v&v-2-4&3-5"],
  [new Graph(9,[[7,8],[3,9],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,3,2],[1,2,2,2,1,3,3,3,1],"v-v-v-v-v&v-v-v&v-3-7"],
  [new Graph(7,[[1,5],[2,5],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[4,5,5,4,3,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-v-v-v-5-1-4&2-5"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,5,3,2,1,3,3],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6-4&3-7"],
  [new Graph(7,[[1,3],[2,5],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[15/4,11/4,7/4,3/4,7/4,11/4,11/4],[11/2,21/4,6,17/4,17/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-6&4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[11/4,7/4,1/2,-1/4,1/4,7/4,1],[2,2,2,11/4,15/4,15/4,3],"v-v-v-v-v-v-v-4&2-6"],
  [new Graph(8,[[5,8],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v&v-2&v-5"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2]]),[1,2,3,5/2,1,1,5/2],[1,2,2,1,3,2,3],"v-v-v&v-2-v&v-2-v"],
  [new Graph(7,[[1,3],[1,7],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[0,9/4,15/4,5/2,3/2,0,1/2],[-1/2,-1/2,1,1,5/4,5/2,1],"v-v-v-v-v-v-v-1-3-6-1-4"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-3-5&4-7"],
  [new Graph(7,[[1,3],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[17/4,21/4,17/4,11/4,11/4,7/4,7/4],[1/4,1/4,5/4,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&4-6"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,3,4,5,4,4,2],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-4"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,17/4,3,7/4,7/4,3,19/4],[1,0,1,1,2,2,7/4],"v-v-v-v-v-v-v-1-3-6-4&2-7"],
  [new Graph(9,[[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-4"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2&3-6-4"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6"],
  [new Graph(7,[[1,3],[4,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[15/4,21/4,1/2,0,7/4,3/2,3/4],[1,1,-3/4,5/2,5/4,1/4,1],"v-v-v-v-v-v-v-4-1-3-6&2-4"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[11/4,11/4,15/4,19/4,19/4,15/4,11/4],[0,1,1,0,1,2,2],"v-v-v-v-v-v-v&2-6-3-5"],
  [new Graph(10,[[9,10],[1,5],[7,8],[5,6],[1,4],[6,7],[1,2],[2,3],[3,4],[8,9],[7,10]]),[4,5,5,4,3,3,2,1,1,2],[1,1,2,2,1,2,2,2,1,1],"v-v-v-v-1-v-v-v-v-v-v-8"],
  [new Graph(7,[[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,13/4,13/4,2],[5/4,9/4,3,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-1"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[2,3,19/4,4,17/4,3,2],[9/4,9/4,7/4,1,0,1,1],"v-v-v-v-v-v-v&2-6&3-5"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,1,19/4,3,11/4,1,3/2],[7/4,3/4,9/4,2,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-6&4-7"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[5,5,4,3,3,2,1,1,2],[2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-4"],
  [new Graph(8,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,1,1,2,3,3,2,2],[1,2,3,3,3,2,2,1],"v-v-v-v-v-v-v-v&2-7-4"],
  [new Graph(7,[[1,5],[1,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,2,5/2,4,4,3,1],[1,1,5/2,5/2,1,0,1],"v-v-v-v-v-v-v-3-5-1-6"],
  [new Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[2,1,2,3,15/4,15/4,19/4],[11/4,5/4,7/4,5/4,2,3,3],"v-v-v-v-v-v-v-5&2-4-1-3"],
  [new Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,3,4,5,5,4],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-5"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4],[3,6]]),[1,2,7/2,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&4-7-5-3-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[5,7],[1,5]]),[11/4,1/2,23/4,4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-4&2-5-3"],
  [new Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5]]),[1/2,0,15/4,9/4,1/4,5/4,5/2],[3/2,5/2,1,-1/2,-1/2,3/4,1],"v-v-v-v-v-v-v-2-5-3-7-5"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,0,4,11/4,3/2],[5/4,9/4,1,-1/4,1,9/4,1],"v-v-v-v-v-v-2-v-4-2-5"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2"],
  [new Graph(7,[[1,7],[4,6],[5,6],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,17/4,19/4,3,7/4,7/4,4],[1,0,7/4,2,1,2,1],"v-v-v-v-v-v-4-1-v-3"],
  [new Graph(10,[[9,10],[7,8],[5,6],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v-1"],
  [new Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,11/4],[-1/4,-1/4,1,1,1,2,2],"v-v-v-v-v-v-v&2-5&3-6-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,11/2,4,1/4,3,2],[7/4,11/4,1,1,-3/4,1,1],"v-v-v-v-v-v-v&3-5-2-4"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4]]),[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-4"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3&4-7"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5&3-6"],
  [new Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,3],[1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v&v-4"],
  [new Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,3,11/4,4,7/4,3/4,3],[4,4,5,21/4,23/4,4,3],"v-v-v-v-v-v-v-1-3-5-1-6&2-7-4"],
  [new Graph(8,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3"],
  [new Graph(7,[[2,5],[1,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,9/4,2,15/4,15/4,0,9/4],[2,5/2,15/4,11/4,1,1,3/2],"v-v-v-v-v-v-v-2-5-3-6-1"],
  [new Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,13/4,5,4,3,3,2],[2,2,1,1,1,0,3/4],"v-v-v-v-v-v-v-2-4&3-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,4,4,3,2,2],[9/4,9/4,5/4,1/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5-1-6"],
  [new Graph(7,[[2,5],[1,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,2,1,5/2,2,3],[5/2,1,0,1,5/2,1,1],"v-v-v-v-v-v-v-2-5-1"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-2-v&2-4-6"],
  [new Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,1,3],[1,2,2,2,3,3,3,1],"v-v-v-v-v-v-v-2&v-4&3-6"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7-4"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,0,3/2,5/2],[5/4,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6&5-7"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4]]),[5/4,5/4,9/4,3/4,7/2,19/4,3/4],[1/2,3/2,3/4,-3/4,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[19/4,13/4,9/4,2,3,3/4,11/4],[1,11/4,11/4,7/4,3/2,1,9/2],"v-v-v-v-v-v-v-1-3-5-1-6-3&4-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-v-4"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2&4-6"],
  [new Graph(7,[[2,5],[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,0,21/4,15/4,5/2,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,11/4,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4&3-6"],
  [new Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&v-3"],
  [new Graph(10,[[5,10],[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-3&v-4&v-5"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[2,3,7/2,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2&4-6"],
  [new Graph(9,[[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,3,3,2,1,3,2],[1,2,2,2,3,3,3,1,1],"v-v-v-v-v-v-v&v-v-3-6"],
  [new Graph(7,[[4,7],[2,5],[2,6],[2,3],[1,2],[3,4],[4,5]]),[11/4,7/4,1/2,-1/2,1/2,7/4,-1/2],[3,3,4,3,3,2,2],"v-v-v-v-v-2-v&v-4"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[13/4,9/2,1,0,1/2,9/4,5/4],[1,1,-1/4,3/4,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3/4,3/4,3/2,5/2,2,3,3],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5-3"],
  [new Graph(7,[[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[5,7],[1,5],[2,4]]),[23/4,4,11/4,3/4,0,7/4,3/4],[1,1,1,-1/2,5/2,5/4,5/4],"v-v-v-v-v-v-v-5-1-4-2-5"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[2,2,7/2,5,17/4,5,7/2],[1,2,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3-5-7&4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&6-3-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[3,2,3,1,13/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&5-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[4,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5/2,7/2,5,1/2,5/4,5/4,1/2],[1,1,1,-1/4,3/4,9/4,3/2],"v-v-v-v-v-v-v-4-1-6-2&3-6-4"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,-1/4,3/4,-1/4],[3,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-5&2-4"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[1,6],[2,4],[1,7]]),[3,5,4,7/2,3,2,2],[2,1,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4-2"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,11/4,19/4,4,17/4,11/4,11/4],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5&4-7"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[3/2,5/2,0,1/2,0,15/4,21/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&6-3-5-7"],
  [new Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,3,2,5/2,3/2,1,3/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-3-v&3-5"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&2-7"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,13/4,5,3,2,3,4],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5&3-7"],
  [new Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[1/2,0,3/2,5/2,0,9/4,15/4],[5/4,5/2,1,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-2-4-7-5-2"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7&3-6"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&3-7-5"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4]]),[21/4,15/4,1/2,11/4,7/4,3/4,0],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3"],
  [new Graph(7,[[5,6],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4]]),[3/2,3/2,3/2,5/2,3,3,1/2],[1,2,3,3,7/4,3/4,3],"v-v-v-v-v-v&v-3&2-4"],
  [new Graph(10,[[9,10],[2,5],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3&2-5"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[17/4,17/4,21/4,11/2,6,13/4,13/4],[11/4,7/4,11/4,15/4,7/4,1,11/4],"v-v-v-v-v-v-v-1-3-5-2-7-4"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5]]),[7/4,7/4,3,3,17/4,17/4,3],[1,2,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-1-3-5-7"],
  [new Graph(10,[[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v&v-3&v-6"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,13/4,5,4,3,7/2,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6-3&5-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,3,3,2,2,7/2,5],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7"],
  [new Graph(7,[[1,3],[1,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[4,11/4,0,5/2,0,3/2,1/2],[1,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-1-3-5"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[21/4,17/4,17/4,3,2,2,3],[1,1,9/4,9/4,9/4,5/4,1],"v-v-v-v-v-v-v-2-4-6&4-7"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-5"],
  [new Graph(7,[[1,3],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5]]),[7/4,7/4,3,3,4,17/4,13/4],[2,1,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-5-3-1"],
  [new Graph(9,[[2,5],[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4]]),[4,3,2,2,3,4,5,1,1],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v&v-3&v-4&2-5"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,1/2,4,23/4,0,3/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-5&2-6-3&4-6"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,0,1/2,0,4,23/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-5-2&3-6&5-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[1,2,3/4,11/2,4,3,1/4],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-2&4-7-3-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[3,19/4,4,17/4,3,7/4,7/4],[2,7/4,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6&2-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3/4,3/4,3/2,5/2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2&3-5"],
  [new Graph(7,[[3,6],[3,5],[2,3],[1,2],[3,7],[3,4],[4,5]]),[3,3,2,3/2,5/2,1,1],[1,2,2,3,3,1,2],"v-v-v-v-v-3-v&v-3"],
  [new Graph(7,[[4,7],[1,7],[4,6],[5,6],[1,4],[4,5],[1,2],[2,3],[3,4]]),[3/2,3/4,3/4,2,3,3,5/2],[3,9/4,5/4,2,2,1,3],"v-v-v-v-v-v-4-v-1-4"],
  [new Graph(8,[[6,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,5,4,3,2,2,3,1],[2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-4&v-6"],
  [new Graph(7,[[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[3,4,5,3,1,3,2],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-1-4-2-6-3"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v-4"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4-6&2-5"],
  [new Graph(10,[[9,10],[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8&4-7"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&5-1-4-6"],
  [new Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v&v-2&4-7"],
  [new Graph(8,[[1,5],[7,8],[5,6],[1,4],[6,7],[5,8],[1,2],[2,3],[3,4]]),[2,1,1,2,3,3,4,4],[2,2,1,1,2,1,1,2],"v-v-v-v-1-v-v-v-v-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2&3-7"],
  [new Graph(7,[[5,6],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4],[3,6]]),[-1/2,-1/2,1,5/2,5/2,1,5/2],[9/4,13/4,4,4,3,3,2],"v-v-v-v-v-v-3-5-v"],
  [new Graph(9,[[2,8],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,4,3,3,2,2,1,5,1],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v&v-2&v-5&3-6"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4&5-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3,2,5/2,3/2,1,1,3],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-4"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,3,1,3,4,4],[1,1,2,1,0,1,0],"v-v-v-v-v-v-v&3-6-2-5"],
  [new Graph(7,[[3,6],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,15/4,9/2,9/2,3,2],[2,3/2,3/4,3/2,0,0,1],"v-v-v-v-v-v-2-v&2-4&3-6"],
  [new Graph(7,[[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3"],
  [new Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6&2-5&3-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[19/4,15/4,19/4,11/2,19/4,25/4,25/4],[1/2,3/2,3/2,9/4,3,3,3/2],"v-v-v-v-v-v-v-1-3-5-2&3-7-4"],
  [new Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6&2-5-3"],
  [new Graph(7,[[4,7],[2,6],[1,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,2,15/4,15/4,2],[1,2,1,0,0,2,1],"v-v-v-v-v-v-2-v-4-1"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&2-5-3"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[5/4,2,3/4,3/2,5/2,13/4,13/4],[1,7/4,9/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-2-4"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,2,2,15/4],[1,0,1,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3&2-5&4-7"],
  [new Graph(8,[[2,5],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,2,1,1,4],[2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v&v-3&2-5"],
  [new Graph(7,[[1,3],[2,6],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,1,2,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,7/4,5/2,13/4,13/4,9/4],[5/4,9/4,9/4,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-3"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,4,4,2,1],[1,1,9/4,9/4,1,0,1],"v-v-v-v-v-v-v-3-5-2"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3,4,5,15/4,11/4,11/4,4],[2,2,1,0,0,1,1],"v-v-v-v-v-v-v-2&3-7&4-6"],
  [new Graph(10,[[2,8],[5,10],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-2&v-3&v-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[2,3,19/4,4,3,3,19/4],[9/4,9/4,7/4,1,1,0,0],"v-v-v-v-v-v-v-3&2-5"],
  [new Graph(8,[[2,6],[4,8],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,3],[1,2,2,2,3,3,1,1],"v-v-v-v-v&v-2&v-3&v-4"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5"],
  [new Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5&4-7"],
  [new Graph(7,[[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3,3,17/4,17/4,13/4,2,2],[1,2,2,1,0,1,2],"v-v-v-v-v-v-v-2-4-1-6-2"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-4&v-5"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[5,5,4,4,3,3,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5&3-6"],
  [new Graph(7,[[2,5],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3/2,5/2,3,3,1],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-4&2-5"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3,3,2,5/2,3/2,3/4,3/4],[1,2,2,3,3,9/4,5/4],"v-v-v-v-v-v-v&2-4&3-5"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,0,15/4,21/4,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-2-v-4-2-5&4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,3/4,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4"],
  [new Graph(7,[[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,5],[3,4]]),[3,3,2,5/2,5/4,1/4,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5&2-4"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,3/4,2,3,3,5/2,5/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5&6-3-7"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,5,1/4,7/2,5/2,3/2],[3/2,5/2,1,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&3-5&4-7"],
  [new Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[3,7],[2,4],[1,7]]),[3,11/4,1,19/4,1,7/4,3/2],[2,3,17/4,9/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7-5"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-5-7"],
  [new Graph(9,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&5-2-7"],
  [new Graph(7,[[2,5],[2,6],[4,7],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,5,4,4,3,9/4],[2,2,1,0,1,3/4,0],"v-v-v-v-v-2-v-4-v-2"],
  [new Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,3,2,5/2,3/2,1/2,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5"],
  [new Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,9/4,9/4,9/4,1/4,5/4],[5/2,1,9/2,5/2,3/2,1,7/4],"v-v-v-v-v-v-v-4-1-3-6-2-4"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5-7"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,7/4,3,5,4,3,3],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3&4-7"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[5,4,4,3,2,2,3],[1,0,1,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5-7-4"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,13/4,13/4,9/4],[5/4,9/4,3,3,9/4,5/4,2],"v-v-v-v-v-v-v-3&4-7"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,3,3,2,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-4"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1,2,2,3,3,2,1],[2,3,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6&2-4"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5&4-6"],
  [new Graph(7,[[4,7],[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[5,4,4,3,7/4,7/4,3],[1,1,2,2,1,2,1],"v-v-v-v-v-v-4-v-2-4"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,7/4,7/4],[0,1,1,1,2,2,3/4],"v-v-v-v-v-v-v-1-3-5-2&5-7"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[5,7],[1,5],[1,7]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[0,23/4,4,1/2,11/4,7/4,3/4],[5/2,1,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2"],
  [new Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4]]),[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6&2-4"],
  [new Graph(7,[[2,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,11/4,1,11/4,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-5"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2"],
  [new Graph(10,[[9,10],[5,10],[7,8],[5,6],[1,4],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,5/2,3/2,3/4,3/4],[1,1,2,3,3,9/4,1],"v-v-v-v-v-v-v-1-3"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-5&3-6"],
  [new Graph(7,[[1,3],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[9/4,3,9/4,1,-1/4,1,1],[2,5/4,0,5/2,0,3/2,1/2],"v-v-v-v-v-v-3-v-5-3-1"],
  [new Graph(9,[[4,7],[5,6],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,3,3,2,1,1,2,5,4],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v-v-4&v-v-3"],
  [new Graph(7,[[4,7],[2,6],[2,3],[1,2],[3,4],[4,5]]),[1,1,2,3,3,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v&v-2&v-4"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,23/4,4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-3-6&4-7"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4]]),[3,3,2,2,3,17/4,17/4],[0,1,1,2,2,2,1],"v-v-v-v-v-v-v-2-5-3&5-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[1,5],[1,6],[1,7]]),[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6-1"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,2,1,1],[2,2,1,1,2,2,1],"v-v-v-v-v-v-v&2-5"],
  [new Graph(9,[[2,6],[3,8],[4,9],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,3,1,2,2,3],[1,2,2,2,3,3,1,3,1],"v-v-v-v-v&v-2&v-3-v&v-4"],
  [new Graph(8,[[5,6],[3,8],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&3-v-5"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4]]),[15/4,1/2,11/4,7/4,5/2,5/2,15/4],[1,1,3/2,7/4,5/2,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-4"],
  [new Graph(7,[[1,3],[2,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,5],[3,4]]),[2,3,9/4,3/4,17/4,17/4,21/4],[7/4,3/2,11/4,1,1,2,2],"v-v-v-v-v-v-v-5-2-4-1-3-5"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/2,5/2,1/4,-1/2,2,1/4,7/4],[1/2,0,0,11/4,11/4,7/4,3/2],"v-v-v-v-v-v-3-5-2-v"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,3,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5&4-6"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4]]),[1,2,3/2,5/2,3,5/2,1],[1,2,3,3,2,1,2],"v-v-v-v-2-v&v-2-v"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3/4,7/4,1/2,11/2,15/4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-6&2-7-3&4-7"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2,1,5],[2,2,2,2,1,1,1,1,2],"v-v-v-v-v-v-v-v&v-4&2-7"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,0,1/2,0,15/4,9/4],[1,1,5/2,3/4,-1/2,1,5/2],"v-v-v-v-v-v-v-3-1-5-3-6"],
  [new Graph(7,[[4,7],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[7/4,3/4,3/4,7/4,3,3,3],[3,5/2,3/2,3/2,1,2,3],"v-v-v-v-v-v-v-1-4-7"],
  [new Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&3-6"],
  [new Graph(9,[[5,9],[7,8],[3,8],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,1,2,3,4,5,3,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-v-3&v-5"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,5/2,3/4],[1/4,5/4,5/2,1,1,3/4,-3/4],"v-v-v-v-v-v-v-3-5-7-4&3-6"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-6"],
  [new Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,2,2,3,3,4,5],[2,2,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[13/4,5/2,7/4,1,0,7/4,1],[9/4,3,9/4,3,17/4,19/4,4],"v-v-v-v-v-v-v-4-2-6"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v&3-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[4,4,9/4,0,5/4,5/2,5/2],[1,3,15/4,5/4,2,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-1-4-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[19/4,13/4,9/4,11/4,3/4,2,3],[1,11/4,11/4,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&5-7-3-6"],
  [new Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,2],[1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-5&v-3"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[15/4,21/4,1/2,7/4,3/4,0,11/4],[1,1,-1/2,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-6-2&3-7&4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&5-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,2,2],[0,1,1,1,2,1,0],"v-v-v-v-v-v-v-1-3-5-2"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[2,3,0,1/2,0,4,11/2],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-3-5-7&3-6"],
  [new Graph(7,[[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,3,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&2-6-4"],
  [new Graph(8,[[4,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,4,2,3],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-3&v-4"],
  [new Graph(7,[[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[3,4,5,3,2,2,4],[1,1,1,2,1,0,0],"v-v-v-v-v-v-v-1-4-2-7-3"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[5,7],[1,7]]),[15/4,9/2,15/4,3,1,2,2],[11/4,2,1,7/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-7-4-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[3,2,3/4,-1/4,-1/4,3/4,2],[7/2,7/2,5,5,4,4,5/2],"v-v-v-v-v-v-2-v&3-6-4"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3/4,23/4,-1/4,4,11/4,7/4,3/4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[0,3/2,0,13/4,5/2,5/2,1/2],[-1/4,1,9/4,7/4,-1/4,1,1],"v-v-v-v-v-1-v-3-v-1-3"],
  [new Graph(7,[[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,3,1,1],[1,2,3,2,1,2,3],"v-v-v-v-v&v-2-v&2-4"],
  [new Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-7"],
  [new Graph(7,[[4,6],[2,6],[2,3],[6,7],[3,6],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6-3"],
  [new Graph(7,[[2,6],[1,7],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,3,2,3,1,3,5],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-1-4-7&2-6"],
  [new Graph(7,[[2,5],[2,6],[2,7],[4,6],[2,3],[1,2],[3,4],[4,5]]),[13/4,13/4,19/4,19/4,4,13/4,9/4],[5/2,3/2,3/2,0,3/4,0,3/2],"v-v-v-v-v-2-v-4&v-2"],
  [new Graph(7,[[4,6],[3,5],[2,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,2],[5,7],[2,7],[2,4]]),[2,3,5,4,7/2,3,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,7/2,4,5,7/2,2,2],[1,0,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-7-2-4"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3-6"],
  [new Graph(7,[[2,6],[2,3],[3,7],[1,2],[3,4],[4,5]]),[3,3,2,1,1,4,2],[1,2,2,2,1,2,1],"v-v-v-v-v&v-2&v-3"],
  [new Graph(7,[[2,6],[2,4],[2,3],[1,2],[3,7],[3,4],[4,5]]),[1,2,3,5/2,3/2,1,3],[1,2,2,3,3,2,1],"v-v-v-v-v&v-2-4&v-3"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7&4-6"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[7/4,11/4,4,17/4,13/4,9/4,3],[9/4,9/4,1,-1/4,-1/4,1/4,1],"v-v-v-v-v-v-v-3-5-7"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[1,2,2,3,4,4,5,5,3,1],[1,1,2,2,2,1,1,2,1,2],"v-v-v-v-v-v-v-v-5&v-2&v-3"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,3,17/4,19/4,4],[9/4,9/4,1,-1/4,-1/4,7/4,1],"v-v-v-v-v-v-v-3-5&2-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[15/4,11/4,2,1/2,3/2,3/2,11/4],[5,5,6,5,5,4,4],"v-v-v-v-v-v-v-1-3-5-2-7&4-6"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,3,2,3/4,3/4,3/2,5/2],[2,1,2,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6&3-7"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,2,3,15/4,15/4,2,3/4],[3,2,3/2,3,4,4,3/2],"v-v-v-v-v-v-v-1-3-7-2&4-6"],
  [new Graph(7,[[1,7],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[11/4,15/4,21/4,0,3/4,3/2,3/4],[1,1,1,5/2,3/2,3/4,-1/4],"v-v-v-v-v-v-v-1-4-7-3"],
  [new Graph(7,[[2,5],[2,6],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,3/4,3/4,3/4,-3/4,1/4],"v-v-v-v-v-v-v&2-4-6-2-5&3-6"],
  [new Graph(7,[[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[13/4,5/2,7/4,1,0,3/4,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5"],
  [new Graph(8,[[7,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,2,3,3,1,1,1],[1,1,2,2,3,1,2,3],"v-v-v-v-v&v-v-v&3-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&3-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6&3-7"],
  [new Graph(7,[[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/2,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,1,2,3,3,2,1],[2,1,1,1,2,3,3],"v-v-v-v-v-v-v-1-3-5"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3,5,4,3,4,7/4,7/4],[2,1,1,1,0,3/4,2],"v-v-v-v-v-v-v-1-3-5-2&4-1-6"],
  [new Graph(7,[[4,6],[5,6],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,3,3,5/2],[1,2,3,2,2,1,3],"v-v-v-v-v-v-4-2&v-3"],
  [new Graph(7,[[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[5,6],[4,5]]),[5/2,5/2,5/2,1,0,1,1],[7/4,11/4,4,4,3,2,3],"v-v-v-v-v-v-2-4-v"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[2,3,0,1/2,0,11/2,4],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-2&3-5-7-3-6"],
  [new Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[4,7],[2,7],[2,4],[1,7]]),[3/2,0,1/2,0,21/4,15/4,5/2],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-6-4-7-2-5"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6],[4,10]]),[5,4,3,3,2,2,1,1,5,4],[2,2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-v-4&3-6"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[5,4,3,7/4,7/4,3,4],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6-3"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-6-3"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,3/4,23/4,4,11/4,-1/4],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5-7-2&4-7-3-6"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&3-6"],
  [new Graph(7,[[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/2,2,3,2,1,1,3],[1,2,3,3,3,2,1],"v-v-v-v-v-v-2-v&2-4"],
  [new Graph(7,[[1,3],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,3,2,3/2,3/4,3/4,3],[2,3,2,3,9/4,5/4,1],"v-v-v-v-v-v-3-v-1-3"],
  [new Graph(10,[[9,10],[6,10],[7,8],[5,6],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,2,3,4,4,3,5,5],[1,2,2,1,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-3&v-v-6"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4],[3,6]]),[2,3,3,9/4,4,4,5],[9/4,9/4,1,1/4,0,1,1],"v-v-v-v-v-v-v-2-4&3-6&5-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[3,2,3,1,11/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5&3-7"],
  [new Graph(9,[[5,6],[3,8],[4,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,4,3,2,1,1,5,3,2],[1,2,2,2,2,1,2,1,1],"v-v-v-v-v-v&v-2&v-3&v-4"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,23/4,0,7/4,3/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7&4-6"],
  [new Graph(9,[[1,8],[7,8],[5,6],[1,9],[3,9],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,2,2,1,1,1,2,3,3],[2,2,3,3,2,1,1,1,3],"v-v-v-v-v-v-v-v-1-v-3"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,11/4,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,0],"v-v-v-v-v-v-v-2&3-6-4"],
  [new Graph(7,[[3,5],[6,7],[2,3],[3,6],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[3,7],[2,4],[1,7]]),[3/4,2,2,3,5,3,9/4],[1,7/4,11/4,3/2,1,3,19/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7-3-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,3/4,19/4,15/4,11/4],[3/4,7/4,11/4,-3/4,1,1,1],"v-v-v-v-v-v-v-3-5&3-6&4-7"],
  [new Graph(7,[[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,3,1,11/4,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-6"],
  [new Graph(10,[[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,3,4,5,5,2,4],[1,2,2,2,1,1,1,2,1,2],"v-v-v-v-v-v-v-v&v-3&4-v-6"],
  [new Graph(7,[[4,6],[3,5],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[1,6],[2,4],[1,7]]),[2,7/4,3,5,3,1,2],[7/4,3/4,2,5/2,3,9/2,3],"v-v-v-v-v-v-v-1-3-5-1-6-2-4-6"],
  [new Graph(9,[[1,8],[7,8],[1,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,3,2,1,2],[2,3,3,3,2,1,1,1,2],"v-v-v-v-v-v-v-v-1-v-5"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[11/4,5/2,7/4,1,-1/4,-1/4,3/4],[2,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-4-2&5-7"],
  [new Graph(7,[[4,7],[1,3],[1,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[4,5,5,7/2,9/4,9/4,19/4],[3/4,-1/4,3/4,7/4,3/4,7/4,7/4],"v-v-v-v-v-v-4-v&3-1-4"],
  [new Graph(7,[[1,3],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3-1"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,21/4,0,1/2,3/2,5/2,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[3,6]]),[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2&3-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-7"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/2,3/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4-6-2-5-3"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[1/2,0,3/2,1/4,5/2,15/4,5/2],[3/2,5/2,5/4,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-2-6-4"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,2,3,3,3],[5/4,9/4,13/4,9/4,13/4,9/4,5/4],"v-v-v-v-v-v-v-4-6"],
  [new Graph(7,[[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[1,2,3,3,7/4,3/4,2],[1,2,3/2,5/2,3,3,1],"v-v-v-v-v-v&v-2-4"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[3,17/4,4,19/4,3,7/4,7/4],[1,0,1,7/4,2,1,2],"v-v-v-v-v-v-v-5-1-3&2-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[5,4,5,4,4,11/4,11/4],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-2-5-3"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[13/4,5/2,5/2,3/2,1/2,1,7/4],[9/4,3,4,4,4,3,9/4],"v-v-v-v-v-v-v-2-4-6-2"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,2,17/4,3,1,2,1/2],[9/4,9/4,3/4,1,1/4,5/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4-6"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,3,4,5,3,1,2],[1,2,1,1,0,1,1],"v-v-v-v-v-v-v-1-3-5-7-2-4&2-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[0,11/4,4,11/4,1/2,7/4,3/4],[5/2,1,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-2"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,3,7/4,7/4],[2,1,1,1,2,1,2],"v-v-v-v-v-v-v-5-1-3-5"],
  [new Graph(7,[[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[5,4,3,3,2,2,3],[1,1,1,2,2,1,0],"v-v-v-v-v-v-v-1-4-6-3-7"],
  [new Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[11/4,4,5,4,3,4,11/4],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v&3-6-4-2-5"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2&3-6"],
  [new Graph(10,[[5,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-5"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/2,3/4,11/4,15/4,21/4,0,3/4],[3/4,-1/4,1,1,1,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-2-5"],
  [new Graph(7,[[1,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1,2,3,4,4,5/2,2],[1,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6-1"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4]]),[4,5,7/2,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2"],
  [new Graph(7,[[2,5],[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6-2-5"],
  [new Graph(7,[[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,5/4,-1/2,-1/2,3/2,5/4],"v-v-v-v-v-v-2-v-4-2&4-6"],
  [new Graph(7,[[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3,17/4,17/4,3,1,2,2],[1,1,-1/4,-1/4,1/2,2,1],"v-v-v-v-v-v-v-1-4-2-6"],
  [new Graph(9,[[8,9],[7,8],[3,8],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4,4,5],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-v&3-8"],
  [new Graph(7,[[1,5],[1,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,2,4,4,2,1],[1,1,2,3/2,0,0,1],"v-v-v-v-v-v-v-3&5-1-6"],
  [new Graph(8,[[4,7],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-4&v-3"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[0,21/4,0,15/4,5/2,3/2,1/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&6-3-7"],
  [new Graph(8,[[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v&v-3-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9],[3,6]]),[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v&3-6&5-8"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[2,3,5,4,7/2,2,3],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4&2-6&3-5-7"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[3/4,7/4,7/4,4,11/4,3,3],[17/4,17/4,6,11/2,21/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-7-4-6"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,4,4,3,2],[7/4,7/4,7/4,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2&4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[2,4],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,23/4,1/2,4,11/4,7/4,3/4],[5/2,1,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,3/4,9/4,19/4,3,2],[7/4,3/2,1,9/2,1,11/4,11/4],"v-v-v-v-v-v-v-1-3-5&2-7-3&4-6"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,-1/4,3/4,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7-2-4"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[3/4,3/4,2,2,3,2,3/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5"],
  [new Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[2,5],[2,7],[1,6],[2,4]]),[11/4,9/4,2,3/4,3,19/4,13/4],[9/2,11/4,7/4,1,3/2,1,11/4],"v-v-v-v-v-v-v-2-4-1-6-2-5&4-6"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[4,4,11/4,1/2,7/4,11/4,11/4],[9/4,1,7/2,1,7/4,3/2,5/2],"v-v-v-v-v-v-v-2-4-6-2&3-7-5"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,5/2,3/2,5/2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2-4"],
  [new Graph(7,[[1,5],[1,7],[1,6],[1,4],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,4,3,5,2,3,1],[0,1,2,1,1,1,1],"v-v-v-v-1-v-3-v-1-v-3"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[13/4,5/2,7/4,1,1,0,7/4],[9/4,3,19/4,4,3,17/4,9/4],"v-v-v-v-v-v-3&v-2-5"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,5]]),[1/2,0,23/4,4,1/4,11/4,7/4],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4&3-5-2-6"],
  [new Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5],[3,6]]),[4,23/4,0,1/2,0,3/2,11/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,0,23/4,4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-2&3-5&4-7-3-6"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[9/4,13/4,5,4,7/2,3,2],[9/4,9/4,1,1,0,1,1],"v-v-v-v-v-v-v-2&3-5-7&4-6"],
  [new Graph(7,[[4,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[1,6],[2,4]]),[5,7/2,5/2,7/4,5/4,0,0],[1,1,1,2,1/2,-1/2,5/4],"v-v-v-v-v-v-v-4-1-6-4-2"],
  [new Graph(7,[[1,3],[1,5],[4,7],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,2,1,5,3,3,7/4],[2,3,17/4,11/4,3,2,3/4],"v-v-v-v-v-v-v-1-3-5-1-6&3-7-4"],
  [new Graph(8,[[1,8],[7,8],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,4,4,3,2,1,1,2],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6],[8,9]]),[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7&3-6"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,9],[1,10],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&6-9"],
  [new Graph(7,[[1,5],[5,6],[1,4],[6,7],[4,5],[2,4],[5,7],[1,2],[2,3],[3,4]]),[19/4,19/4,13/4,4,3,7/4,7/4],[2,1/4,1/4,1,2,1,2],"v-v-v-v-v-v-v-5-1-4-2"],
  [new Graph(9,[[2,8],[3,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[5,4,3,3,2,1,1,4,2],[1,1,1,2,2,2,1,2,1],"v-v-v-v-v-v-v&v-2&3-v-5"],
  [new Graph(10,[[2,5],[3,10],[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,2,3,3,4,4,5,5,1],[2,2,1,1,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-v-6&v-3&2-5"],
  [new Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1,5],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&2-5"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,0,1/2,23/4,4,11/4],[1,1,5/2,-1/4,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7"],
  [new Graph(7,[[1,5],[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,9/4,15/4,0,5/2,3/2],[3/4,5/2,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-1"],
  [new Graph(7,[[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,3,3,2,1,1,4],[1,1,2,2,2,1,1],"v-v-v-v-v-v&v-2"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3/4,2,3/4,5/4,4,3,2],[9/4,9/4,1,0,1/2,3/4,3/4],"v-v-v-v-v-v-v-2-4-7&5-2-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[1,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[4,3,4,21/4,5,23/4,19/4],[7/4,3/2,11/4,15/4,11/4,2,1],"v-v-v-v-v-v-v-1-3-5-1-6-4&2-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[3,3,2,2,4,5,4],[1,0,1,2,2,1,1],"v-v-v-v-v-v-v-1-3-5-7&2-6"],
  [new Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,2],[1,2,2,2,3,3,1],"v-v-v-v-v-v-3-v"],
  [new Graph(7,[[1,3],[2,5],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[4,23/4,0,3/4,7/4,11/4,3/4],[1,1,5/2,3/2,1,1,-1/4],"v-v-v-v-v-v-v-1-3-7-2"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,-1/4,-1/4],"v-v-v-v-v-v-v&2-5&3-6"],
  [new Graph(7,[[1,3],[2,5],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,3,2,3,4,2,3/4],[2,3/2,3,3,3,4,3/2],"v-v-v-v-v-v-v-1-3-7-2-5&4-6"],
  [new Graph(9,[[7,8],[5,6],[3,8],[4,9],[4,5],[1,2],[2,3],[3,4]]),[4,3,3,2,1,1,5,4,2],[1,1,2,2,2,1,2,2,1],"v-v-v-v-v-v&v-v-3&v-4"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-5"],
  [new Graph(7,[[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[7/2,5/2,1,-1/4,3/4,-1/4,5/2],[3,3,3,13/4,17/4,17/4,2],"v-v-v-v-v-v-4&v-2"],
  [new Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-2-5-3-7-4"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4]]),[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4"],
  [new Graph(10,[[7,8],[3,9],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-3&v-4"],
  [new Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,4,5,4,11/4,2,2],[1,0,1,9/4,3/2,3/4,9/4],"v-v-v-v-v-v-v-4-1-3&2-6"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6&3-5"],
  [new Graph(7,[[2,5],[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3&4-7"],
  [new Graph(7,[[4,7],[1,3],[1,4],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[15/4,21/4,0,0,5/2,3/2,1/2],[1,1,-1/2,5/2,1,1,5/4],"v-v-v-v-v-v-4-v&2-4-1-3"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[15/4,21/4,0,1/2,0,5/2,3/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6"],
  [new Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,9],[1,10],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10&6-9"],
  [new Graph(7,[[4,6],[5,6],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[1,2,0,1,4,5,3],[1,1,11/4,-3/4,1,1,1],"v-v-v-v-v-v-3-5&v-2&4-6"],
  [new Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5"],
  [new Graph(7,[[1,3],[2,5],[2,6],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,7/4,7/4,11/4,11/4,15/4,11/4],[5,6,5,17/4,21/4,11/2,13/4],"v-v-v-v-v-v-v-1-3-5-2-6-4-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[11/4,4,4,3,7/4,7/4,11/4],[9/4,9/4,1,0,5/4,9/4,1],"v-v-v-v-v-v-1-v-3-1-5"],
  [new Graph(7,[[2,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[2,2,2,1,1,1,3],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-5"],
  [new Graph(8,[[2,5],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,1,2,2,3,3,2],[1,2,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-5-2"],
  [new Graph(7,[[1,3],[2,6],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1/2,3/2,3/2,3/2,5/2,5/2,7/2],[17/4,13/4,17/4,6,21/4,17/4,6],"v-v-v-v-v-v-v-4-1-3-6-2"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7-5"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9"],
  [new Graph(7,[[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[13/4,13/4,17/4,17/4,3,2,2],[5/4,9/4,9/4,5/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-2-4-1-6"],
  [new Graph(9,[[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-4"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&4-6"],
  [new Graph(9,[[2,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,4,5,5,3,1],[1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v&v-2&v-3"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,5/2,2,3],[1,1,0,3/4,9/4,1,1],"v-v-v-v-v-v-v-1-3-7-5-2"],
  [new Graph(7,[[4,7],[2,6],[2,4],[2,3],[1,2],[3,4],[4,5]]),[13/4,5/2,5/2,3/2,1/2,7/4,1/2],[9/4,3,4,4,4,9/4,3],"v-v-v-v-v&v-2-4-v"],
  [new Graph(7,[[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[2,2,2,3,4,4,1],[-1/4,3/4,2,3/2,2,1/2,3/4],"v-v-v-v-v-v-1-v-3-5"],
  [new Graph(8,[[2,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,1],[1,2,2,1,1,2,3,3],"v-v-v-v-v-v-v&v-2&3-6"],
  [new Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[4,4,5,3,3,2,2],[1,0,1,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&2-6-4"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-4&v-3&5-8"],
  [new Graph(7,[[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-3"],
  [new Graph(7,[[1,3],[1,5],[4,7],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3,5,4,3,3,2,1],[0,1,1,2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-4-2&4-7"],
  [new Graph(8,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7&3-6"],
  [new Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2-6-3"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[1,6],[1,7]]),[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-5-7"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[6,7],[3,4],[4,5]]),[1,2,5/2,3/2,1,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-2-v-v-2-4"],
  [new Graph(7,[[2,5],[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[2,3,5,4,4,3,2],[2,2,1,0,1,3/4,1],"v-v-v-v-v-2-v&v-2&3-5"],
  [new Graph(7,[[2,6],[5,6],[4,6],[4,5],[2,4],[5,7],[1,2],[2,3],[3,5],[3,4],[3,6]]),[3/4,7/4,11/4,0,4,1/2,4],[1,1,1,5/2,1,-1/4,-1/4],"v-v-v-v-v-v-2-4-6-3-5-v"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[1,6],[2,4],[1,7]]),[17/4,3,3/4,2,9/4,17/4,7/2],[1,3/2,1,7/4,11/4,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6&4-2-5-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4]]),[1,2,3,1/4,1,3,17/4],[1,1,1,9/4,-3/4,-3/4,5/4],"v-v-v-v-v-v-v-3-5-7-4-2"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,2,3/4,2,4,4,3],[11/4,7/4,1,15/4,3,1,3/2],"v-v-v-v-v-v-v-1-3-6-4&2-7-3"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,3,2,1,1],[1,2,1,2,3,3,2],"v-v-v-v-v-v-v-2-4&5-2-6"],
  [new Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,1/2],"v-v-v-v-v-v-v-2-5&4-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[5,7],[1,5],[1,6],[2,4],[1,7]]),[2,3,5,9/4,3/4,3,2],[11/4,3,1,19/4,1,3/2,7/4],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&5-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,11/4,11/4,11/4],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2"],
  [new Graph(8,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,1,-1/4,-1/4],[3,3,9/4,3,17/4,17/4,13/4],"v-v-v-v-v-v-v-5-2-4"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[5/2,3/2,0,1/2,0,9/4,15/4],[1,1,5/2,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-3-1-5-3&5-7"],
  [new Graph(7,[[2,6],[5,6],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[0,0,9/2,3,2,5/4,1],[5/4,5/2,1,1,1,0,3/2],"v-v-v-v-v-v-2-v&2-4-6-3"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,2,3,3,4,5,13/4],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-4&5-7"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[5/2,3/2,1,1/4,1,5,7/2],[1,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-7-3-6"],
  [new Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&5-8"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5]]),[3/4,3/4,5/4,2,5/2,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6&3-5"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5],[3,6]]),[1,2,3,3,4,5,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-4-7&3-6"],
  [new Graph(7,[[1,5],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,3,4,4,3,1],[0,1,2,2,1,1,1],"v-v-v-v-v-v-3-v-1-5-3"],
  [new Graph(9,[[5,6],[3,8],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-3-6&v-4"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[2,5],[5,7],[1,5],[2,4]]),[11/4,1/2,4,23/4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2-4"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6-3-7"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[2,9/4,4,3,3,0,5/4],[5/2,3/2,1,5/2,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[4,19/4,3,7/4,7/4,3,19/4],[1,7/4,7/4,2,1,1/4,1/4],"v-v-v-v-v-v-v-1-3-5&2-7&3-6"],
  [new Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,3,3,2,2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,5]]),[0,3/2,0,7/4,5/2,7/4,1/2],[-1/4,1,9/4,9/4,1,-1/4,1],"v-v-v-v-v-v-1-v-3-1-5-3"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4]]),[3/4,0,1/2,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&2-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4],[3,6]]),[3,5,1,2,2,7/4,3],[3,11/4,17/4,3,2,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3&5-7"],
  [new Graph(8,[[2,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,3,4,5,5,4,1],[1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-4&v-2"],
  [new Graph(8,[[1,8],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v-1"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,0,1/2,0,23/4,4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1/2,0,1/4,5/4,5/2,7/2,5],[3/2,5/2,-1/2,3/4,1,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3/4,7/4,3,2,3,7/4,3/4],[1,1,3/2,2,5/2,3,3],"v-v-v-v-v-v-v&3-5"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[5,7],[1,2],[2,3],[3,4],[3,5]]),[3/4,11/4,4,23/4,-1/4,7/4,3/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6&5-7"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[3/4,7/4,11/4,0,4,23/4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-3-5"],
  [new Graph(10,[[9,10],[5,10],[7,8],[5,6],[6,7],[6,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-5&6-9"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[3,3,3,17/4,17/4,17/4,2],[1/4,5/4,5/2,5/2,5/4,1/4,5/2],"v-v-v-v-v-v&v-3-5-2"],
  [new Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[5,7],[1,2],[2,3]]),[13/4,17/4,17/4,9/4,5/4,5/4,9/4],[-1/4,3/4,-1/4,-1/4,3/4,7/4,7/4],"v-v-v-1-v-v-v-v-6"],
  [new Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[9/4,3,5,3/4,3,2,2],[19/4,3,1,1,3/2,11/4,7/4],"v-v-v-v-v-v-v-4-1-3-6-2&4-6"],
  [new Graph(7,[[2,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[13/4,5/2,3/4,-1/4,-1/4,7/4,1],[9/4,3,4,4,5,9/4,3],"v-v-v-v-v-3&v-2-v"],
  [new Graph(7,[[2,6],[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[7/4,13/4,5/2,13/4,19/4,19/4,4],[7/4,7/4,1,1/4,1/4,7/4,1],"v-v-v-v-v-v-v-2-4-7&2-6"],
  [new Graph(7,[[1,3],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/4,3/4,0,23/4,4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-7-3-6-4"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,0,0,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7"],
  [new Graph(8,[[2,5],[4,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,2,3,3,2,1,4,4],[1,1,1,2,2,2,1,2],"v-v-v-v-v-v&v-3&v-4&2-5"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,2,2,3,3],[5/4,9/4,3,2,1,2,3],"v-v-v-v-v-v-v-3&4-6"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,2,3,3,4,5,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2-4-7&3-6"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4]]),[5,7/2,5/2,0,3/2,0,1/2],[1,1,5/4,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2&4-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[5,7],[2,4],[1,7]]),[5,4,7/2,3,2,2,3],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-7-4-2"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-4-1-6-2&3-6"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[4,13/4,15/4,11/4,7/4,3/4,2],[15/4,3,1,3/2,7/4,1,3],"v-v-v-v-v-v-v-1-3-6-4-7-2&3-7"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[5,7],[1,5],[1,7]]),[1/2,11/4,4,11/4,0,3/4,7/4],[-1/4,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[9/4,13/4,19/4,4,19/4,13/4,9/4],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4-6&3-5"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[5,7],[1,6],[1,7]]),[3,5,4,3,3,2,1],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-1-3-5-2&4-1-6&5-7"],
  [new Graph(7,[[2,5],[2,6],[5,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[1/2,3/2,1/2,5,7/2,5/2,3/2],[2,2,-1/4,1,1,1,1],"v-v-v-v-v-v-2-v&3-6&4-2-5"],
  [new Graph(10,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-4"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[15/4,3,7/4,7/4,3/4,7/4,15/4],[25/4,11/2,25/4,5,5,4,19/4],"v-v-v-v-v-v-v-1-3-5&2-7&4-6"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[13/4,19/4,4,19/4,13/4,7/4,7/4],[1/4,1/4,1,7/4,7/4,1,2],"v-v-v-v-v-v-v-5-1-3-5&2-4"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[4,3,2,1,1,2,3],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2"],
  [new Graph(9,[[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,5,2],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-3&4-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,2,2,1,1,1,5/2],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-5"],
  [new Graph(7,[[4,6],[2,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,4],[1,2],[2,7],[1,6],[2,4]]),[3,19/4,13/4,9/4,2,3/4,11/4],[3/2,1,11/4,11/4,7/4,1,9/2],"v-v-v-v-v-v-v-2-4-1-6-2&4-6"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/4,1,3,19/4,11/4,1,3/2],[7/4,3/4,2,9/4,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-5&6-3-7"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,5,4,4,3,3],[2,2,1,0,1,1,0],"v-v-v-v-v-v-v&3-5-2-6-4"],
  [new Graph(7,[[2,5],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6&2-5"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4],[3,5],[3,6]]),[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4&3-6&5-7"],
  [new Graph(7,[[4,7],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,7/4,11/4,2,3,2,1],[3,3,3,2,1,1,3/2],"v-v-v-v-v-v-4-v"],
  [new Graph(10,[[9,10],[7,8],[5,6],[1,4],[6,7],[1,10],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4"],
  [new Graph(8,[[1,8],[4,7],[7,8],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[3,3,2,2,1,1,2,3],[2,1,1,2,2,3,3,3],"v-v-v-v-v-v-v-v-1-4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[1,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4&3-6"],
  [new Graph(7,[[4,7],[5,6],[1,6],[4,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-3&4-6"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[1,2,3,0,1,4,5],[1,1,1,11/4,-3/4,1,1],"v-v-v-v-v-v-v-4-6&5-7"],
  [new Graph(8,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v-v-3-6"],
  [new Graph(7,[[1,7],[5,6],[1,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,2,3/2,3/4,5/4,5/2,3],[2,2,3,9/4,1,1,3],"v-v-v-v-v-v-1-v-3"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[1,3,2,3,4,5,3],[1,2,1,1,1,1,0],"v-v-v-v-v-v-v-1-3-7-5-2-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,17/4,3,11/4,-1/4,1],[11/4,3/2,1,11/4,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[2,3,3,17/4,17/4,3,2],[2,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4]]),[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-7"],
  [new Graph(9,[[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[1,1,1,2,3,3,2,2,3],[1,2,3,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-v&2-7-4"],
  [new Graph(7,[[1,3],[4,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3-6-4-2"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[4,5,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3&2-5"],
  [new Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&3-v-5"],
  [new Graph(10,[[2,5],[6,10],[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,4,5,1,5],[1,1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5&4-7"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4],[3,6]]),[1,2,3,17/4,19/4,4,3],[1,1,1,0,7/4,1,2],"v-v-v-v-v-v-v-2&4-6-3-7-5"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3"],
  [new Graph(7,[[1,3],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[3,3,2,5/2,3/2,3/4,3/4],[1,2,5/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-3-1"],
  [new Graph(10,[[2,5],[7,8],[4,7],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5&4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,4,4,5,9/4],[9/4,9/4,1,0,1,1,1/4],"v-v-v-v-v-v-2-v-4-6"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,3/4,0,11/2,15/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&3-7-4"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2-5&3-7"],
  [new Graph(9,[[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,3,2],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3"],
  [new Graph(9,[[1,8],[2,5],[7,8],[3,9],[1,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v-1-v-3&5-2-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,17/4,3,3],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5-7"],
  [new Graph(8,[[2,5],[5,6],[3,8],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,2,1,1,1,3,3],[1,2,3,3,2,1,2,3],"v-v-v-v-v-v&v-2-5&v-3"],
  [new Graph(7,[[4,6],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,3,3/4,5/2,4,5,3/4],[1,3/4,5/2,-1,3/4,1,5/4],"v-v-v-v-v-v-3-v&3-5&4-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6&4-1-5"],
  [new Graph(10,[[5,10],[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,5,4,3,3,2,2,1,1,4],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&3-v-5"],
  [new Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[2,13/4,5,4,4,3,2],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5-3&4-7"],
  [new Graph(8,[[1,8],[7,8],[5,6],[1,4],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[2,1,1,2,3,4,4,3],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4&5-8"],
  [new Graph(7,[[1,3],[1,5],[1,7],[4,6],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[3,4,4,3,3,2,2],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4"],
  [new Graph(7,[[1,3],[2,5],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[4,5,4,3,4,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7"],
  [new Graph(7,[[5,6],[4,5],[1,2],[5,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,4],[1,2,2,2,1,1,1],"v-v-v-v-v-v-3&v-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,1/4,3/4,3,3,2,1],[9/4,9/4,0,0,1,1,1],"v-v-v-v-v-v-v-3-5-2&3-6"],
  [new Graph(7,[[3,6],[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,3/4,2,3,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v-3-5&v-2"],
  [new Graph(9,[[1,5],[7,8],[5,6],[1,4],[6,7],[6,9],[1,2],[2,3],[3,4],[8,9]]),[2,1,1,2,3,4,4,5,5],[2,2,1,1,2,2,1,1,2],"v-v-v-v-1-v-v-v-v-v-7"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[1,7/4,11/4,1/2,5,15/4,3/4],[7/4,1,1,11/4,1,1,-1/2],"v-v-v-v-v-v-v-3&5-7-4-6"],
  [new Graph(7,[[2,5],[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,1/4],"v-v-v-v-v-v-v-2-5&3-6-4"],
  [new Graph(7,[[1,3],[1,7],[5,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[1,1,2,3,3,3,1],[2,1,2,3,2,1,3],"v-v-v-v-v-v-3-v-1-3-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&2-7-3"],
  [new Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[5,7],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[2,1,2,7/4,5,3,3],[3,9/2,7/4,3/4,5/2,2,3],"v-v-v-v-v-v-v-2-4-6-3-7-5-2"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[2,3,7/2,4,5,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5&2-6-4"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,1,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-3"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,3/4,3,17/4,1/2],[1,1,1,-3/4,-3/4,5/4,2],"v-v-v-v-v-v-v-2&3-6-4-7"],
  [new Graph(7,[[1,3],[5,6],[1,4],[6,7],[5,7],[1,2],[2,3],[3,5],[3,4]]),[3,17/4,17/4,3,11/4,7/4,7/4],[-1/4,-1/4,1,1,2,1,2],"v-v-v-v-1-3-v-v-v-7"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[5,4,4,3,2,1,1,2,3],[2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-2"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-4"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6&4-7"],
  [new Graph(7,[[3,6],[3,5],[2,3],[1,2],[6,7],[3,4],[4,5]]),[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-3-v-v"],
  [new Graph(7,[[2,5],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[2,3,3,4,5,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6&2-5"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[7/2,13/4,9/4,1,2,3,4],[4,3,11/4,5/4,7/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6-4"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,4,3,7/4,7/4,3],[2,1,1,1,1,2,2],"v-v-v-v-v-v-v-1-3-7-4"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[3,4,4,3,2,1,1,2,5],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-2"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2"],
  [new Graph(7,[[4,7],[2,6],[2,3],[1,2],[3,4],[4,5],[5,6]]),[1,1,2,3,2,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v-v-2&v-4"],
  [new Graph(9,[[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,5,5,4,3,2,1,1],[1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v&2-5"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-7"],
  [new Graph(10,[[9,10],[4,7],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&4-7"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,21/4,1/4,1,5/2,15/4],[3/2,5/2,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7-4"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4]]),[5,4,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,3,7/2,7/4,7/4,3,5],[1,1,0,3/4,2,2,1],"v-v-v-v-v-v-v-1-3-7&4-6"],
  [new Graph(7,[[3,6],[3,5],[2,7],[2,3],[1,2],[3,4],[4,5]]),[3,3,2,1,1,3/2,3],[1,2,2,3,2,1,3],"v-v-v-v-v-3-v&v-2"],
  [new Graph(7,[[2,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3/2,0,1/2,0,21/4,15/4,11/4],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-5"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[7/4,7/4,3,17/4,4,19/4,3],[0,1,1,0,1,7/4,2],"v-v-v-v-v-v-v-2&3-7-5&4-6"],
  [new Graph(7,[[3,5],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3/4,3/4,2,2,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v&v-2&3-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,17/4,1/4,3/4,2,3],[7/4,11/4,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[2,3,4,3,2,7/2,5],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-7"],
  [new Graph(9,[[4,7],[5,6],[6,9],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,4,2,5],[1,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-4&v-3&v-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,5,4,3,2,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-2&4-1-5"],
  [new Graph(7,[[2,6],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[3,4,9/4,0,5/4,2,3],[17/4,1,3/2,1,7/4,5/2,5/2],"v-v-v-v-v-v-v-2-4-1-6-2&3-6"],
  [new Graph(10,[[6,10],[7,8],[5,6],[3,8],[6,7],[4,5],[5,9],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5,5],[1,2,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v-3&v-5&v-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[2,5],[4,7],[5,7],[1,5],[1,7]]),[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5-2"],
  [new Graph(7,[[4,7],[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[7/4,11/4,13/4,13/4,17/4,17/4,9/4],[9/4,9/4,5/4,1/4,5/4,9/4,1],"v-v-v-v-v-v-2-v-4"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[5,7],[1,2],[2,7],[2,3],[3,4]]),[19/4,15/4,11/4,11/4,15/4,19/4,19/4],[2,2,2,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5-7"],
  [new Graph(7,[[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[9/4,13/4,19/4,4,13/4,19/4,9/4],[11/4,11/4,7/4,1,1/4,1/4,7/4],"v-v-v-v-v-v-3&v-2&4-6"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&4-6"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,3/4,3/4,7/4,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6"],
  [new Graph(9,[[7,8],[3,9],[5,6],[6,7],[5,9],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&3-v-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[11/4,3,2,3/4,3/4,3/2,11/4],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[13/4,19/4,4,19/4,11/4,7/4,7/4],[1/4,1/4,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3&2-4&5-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[7/4,5/2,7/2,9/2,0,1,3/2],[-1,1/2,1,5/4,11/4,7/4,1/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7"],
  [new Graph(10,[[3,10],[5,6],[6,7],[4,9],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-4&v-3"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,11/2,0,1/2,0],[1,1,1,1,11/4,1,-3/4],"v-v-v-v-v-v-v-3-5-7-4"],
  [new Graph(7,[[2,6],[4,6],[5,6],[4,5],[1,2],[2,4],[3,7],[2,3],[3,4],[3,6]]),[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-2-4-6-3-v"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5-7-3-6-4"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[4,9],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-4&v-3"],
  [new Graph(7,[[4,7],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,3],[3,4]]),[5/4,5/4,5/2,1/2,1,15/4,19/4],[1/4,5/4,1,9/4,-3/4,1,1],"v-v-v-v-v-v-v-4-2&4-6&5-7"],
  [new Graph(7,[[2,5],[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,3/2,1/4,5,7/2,5/2],[3/2,5/2,5/4,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&2-5&4-7"],
  [new Graph(7,[[2,6],[4,7],[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,5],[3,4]]),[1/2,0,3/2,0,5/2,15/4,21/4],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5&4-7"],
  [new Graph(10,[[9,10],[7,8],[1,7],[5,6],[1,6],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[3,4,5,5,4,3,2,1,1,2],[2,2,2,1,1,1,2,2,1,1],"v-v-v-v-v-v-1-v-v-v-v-8"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-3&4-7-5"],
  [new Graph(7,[[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[11/4,7/4,0,5/2,0,3/2,1/2],[9/4,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-3"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4],[3,5]]),[1/2,3/4,0,7/4,11/4,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&3-7"],
  [new Graph(7,[[2,5],[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,3/2,0,21/4,15/4,5/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-7&2-5"],
  [new Graph(7,[[1,7],[1,6],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[2,2,3,17/4,17/4,3,1],[0,1,2,5/2,3/2,0,1],"v-v-v-v-v-3-v-1-v-3"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4]]),[3/4,7/4,1/2,0,11/2,15/4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-7-3-5"],
  [new Graph(10,[[9,10],[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,5,5,3,2],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-3"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4-1"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[2,2,13/4,19/4,4,19/4,13/4],[2,1,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3&4-6&5-7"],
  [new Graph(7,[[2,5],[2,6],[4,7],[4,6],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6"],
  [new Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2&4-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,4]]),[3/4,3/4,3/4,9/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-5"],
  [new Graph(8,[[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,3,4,4,3,2,1,1],[1,1,1,2,2,2,2,1],"v-v-v-v-v-v-v-v&2-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,4],[3,5]]),[2,3,4,4,3,1,3],[1,1,1,9/4,9/4,1,0],"v-v-v-v-v-v-v-2-5-3-7"],
  [new Graph(7,[[2,5],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,23/4,4,1/4,1,3/2],[3/2,5/2,1,1,-1/2,1/4,3/2],"v-v-v-v-v-v&v-2-4&2-5-3"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-4&2-5"],
  [new Graph(10,[[9,10],[7,8],[1,6],[5,6],[1,10],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,2,1,1,2,3,4,5,5,4],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-1-6"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/4,7/4,3,3,2,2,3/4],[3,3,3,2,1,2,3/2],"v-v-v-v-v-v-v&3-6-4"],
  [new Graph(10,[[9,10],[7,8],[5,6],[1,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[4,5,5,4,3,3,2,1,1,2],[2,2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&4-1-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3,5,1,2,2,7/4,3],[3,5/2,9/2,3,7/4,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7-5"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[2,4],[1,2],[5,7],[2,7],[2,3],[3,4]]),[7/2,5/2,7/4,1,-1/4,-1/4,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7-5"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[3,3,2,2,3/4,3/4,3/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-4&3-6"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4&5-8"],
  [new Graph(7,[[4,7],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[9/4,9/4,9/4,1,0,1,1],[2,3,4,4,3,2,3],"v-v-v-v-v-v-2-v-4-2"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[3,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5&4-6-3-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[3,2,1,1,0,0,5/4],[7/2,7/2,9/2,7/2,7/2,9/4,9/4],"v-v-v-v-v-v-v-2-4&3-5"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[1,5],[2,7],[1,6],[2,4],[1,7]]),[7/4,7/4,11/4,4,3,3,3/4],[4,23/4,5,21/4,4,3,4],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[4,5,7/2,7/4,7/4,3,3],[1,1,2,2,3/4,0,1],"v-v-v-v-v-v-v-1-3-7&2-6"],
  [new Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4]]),[2,3,2,3/4,2,4,4],[11/4,3/2,7/4,1,15/4,11/4,1],"v-v-v-v-v-v-v-4-1-3&2-4&5-7"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[6,7],[4,5],[2,4],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[1/2,3/2,0,5/2,15/4,21/4,0],[1,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3-6"],
  [new Graph(7,[[2,5],[2,6],[4,7],[4,6],[1,4],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[1/2,0,21/4,0,15/4,5/2,3/2],[1,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4-1"],
  [new Graph(8,[[2,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,3,3,2,2,1],[1,2,2,2,3,3,1,3],"v-v-v-v-v-v-3-v&v-2"],
  [new Graph(7,[[1,3],[4,7],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[7/4,11/4,11/4,11/4,4,4,1/2],[7/4,3/2,5/2,7/2,11/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-2"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[1,2,3,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6&2-7-4"],
  [new Graph(7,[[4,6],[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[1,5],[1,7]]),[0,3/4,7/4,1/2,11/4,15/4,21/4],[5/2,1,1,-1/2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6&4-7"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[3,4,4,5,9/2,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-7"],
  [new Graph(7,[[1,3],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[3/2,3/2,3,5,4,3,3],[1,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7"],
  [new Graph(7,[[4,6],[2,6],[2,3],[6,7],[4,5],[5,6],[3,4],[1,4],[1,2],[4,7],[2,4],[1,7]]),[13/4,9/4,5/4,3/4,1/4,3/4,9/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-1-4-2-6-4-7"],
  [new Graph(7,[[1,3],[1,5],[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[15/4,21/4,0,5/2,0,3/2,1/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-3-v-5-1-3-5-2"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[5,7],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[3/2,5/2,9/4,13/4,9/2,11/4,1/2],[7/4,3/2,5/2,5/2,1,9/2,1],"v-v-v-v-v-v-v-1-3-5-7-2&3-6-4"],
  [new Graph(9,[[7,8],[5,6],[4,5],[1,2],[2,9],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,2,3,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-3-v-v&v-2"],
  [new Graph(10,[[2,5],[7,8],[3,10],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5"],
  [new Graph(7,[[1,3],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[4,13/4,19/4,19/4,11/4,7/4,7/4],[1,1/4,1/4,7/4,2,1,2],"v-v-v-v-v-v-v-5&3-1-4"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,7/4,3,4,5,4,3],[1,2,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6-4&3-7"],
  [new Graph(7,[[1,3],[2,5],[1,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[11/4,1/2,4,23/4,0,3/4,7/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&5-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[4,6],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4]]),[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6"],
  [new Graph(8,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3&4-7"],
  [new Graph(7,[[2,5],[2,6],[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[1/2,0,7/4,11/4,4,1/4,3/2],[3/2,5/2,1,1,1,-1/2,-1/2],"v-v-v-v-v-v-v&2-4-6-2-5"],
  [new Graph(9,[[2,5],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[4,3,3,2,2,1,1,5,4],[2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3&2-5"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[2,2,1,1,2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-6"],
  [new Graph(7,[[2,5],[2,6],[2,3],[3,4],[1,2],[3,7]]),[2,2,1,1,3,2,1],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-3"],
  [new Graph(9,[[4,7],[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8&4-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[5,7],[1,2],[2,3],[3,4],[3,6]]),[5,4,3,3/2,3/2,3,3],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&5-7"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[13/4,17/4,17/4,13/4,9/4,5/4,5/4],[-1/4,-1/4,3/4,7/4,5/4,7/4,-1/4],"v-v-v-v-v-v-v-1-3&4-6"],
  [new Graph(7,[[2,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,5],[3,6]]),[4,4,0,5/2,0,3/2,1/2],[0,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-2&3-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[11/4,11/4,4,4,5,4,11/4],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v&2-6-4&3-5"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,5]]),[11/4,11/4,7/4,1,0,1,7/4],[9/4,13/4,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-v-2&3-5&4-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[5,7],[1,5],[2,4],[1,7]]),[3/4,2,3,9/4,17/4,17/4,9/4],[1,7/4,3/2,11/4,1,3,15/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7"],
  [new Graph(7,[[1,3],[4,7],[1,7],[5,6],[4,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-3"],
  [new Graph(10,[[9,10],[7,8],[5,6],[3,8],[4,5],[1,2],[2,3],[3,4],[4,10]]),[1,2,3,3,4,5,5,4,1,2],[1,1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-3&v-v-4"],
  [new Graph(7,[[1,3],[1,7],[4,6],[5,6],[6,7],[4,5],[1,2],[5,7],[2,7],[2,3],[3,4],[3,5]]),[25/4,11/2,9/2,7/2,9/2,9/2,23/4],[15/4,3,13/4,2,2,1,2],"v-v-v-v-v-v-v-1-3-5-7-2&4-6"],
  [new Graph(7,[[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[1/2,0,3/2,0,9/4,15/4,5/2],[1,-1/2,1,5/2,5/2,1,1],"v-v-v-v-v-v-v-4-2-6-4-1"],
  [new Graph(7,[[2,5],[2,6],[2,4],[2,7],[2,3],[1,2],[3,4],[5,6]]),[1,2,3,3,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-2-v-v-2-v"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4]]),[3,2,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-7"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7"],
  [new Graph(9,[[7,8],[5,6],[6,9],[6,7],[3,8],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-3&v-6"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,5]]),[19/4,7/2,5,4,4,9/4,9/4],[2,2,1,1,0,3/4,2],"v-v-v-v-v-v-v-2-4&2-6&3-5"],
  [new Graph(7,[[1,3],[1,5],[5,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[5,4,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[5,8],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3&5-8"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,3/2,5/2,15/4,9/4],[-1/2,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5-1-6-3"],
  [new Graph(7,[[1,5],[5,6],[1,6],[6,7],[4,5],[1,2],[3,7],[2,3],[3,5],[3,4],[3,6]]),[3,1,3,4,4,3,2],[0,1,2,2,1,1,1],"v-v-v-v-v-v-v-3-5-1-6-3"],
  [new Graph(10,[[9,10],[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[3,4,5,5,4,3,2,1,1,2],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&2-5"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4],[3,6]]),[5/4,5/4,3/4,19/4,7/2,3/4,9/4],[1/2,3/2,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&4-6-3-5"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,5],[3,4],[3,6]]),[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,1,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-6"],
  [new Graph(7,[[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4],[3,6]]),[4,5/2,7/4,7/4,1,3,3],[21/4,21/4,9/2,6,15/4,13/4,17/4],"v-v-v-v-v-v-v-2-4-1-6-3"],
  [new Graph(7,[[2,6],[2,7],[2,3],[1,2],[3,4],[4,5]]),[1,2,11/4,7/4,3/4,2,3],[1,2,3,3,3,1,1],"v-v-v-v-v&v-2-v"],
  [new Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4],[3,6]]),[7/4,7/4,3,3,4,5,4],[1,2,2,1,0,1,1],"v-v-v-v-v-v-v-4-1-3-6"],
  [new Graph(9,[[7,8],[5,6],[3,8],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2"],
  [new Graph(7,[[1,3],[2,6],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[19/4,4,3,7/4,7/4,3,17/4],[7/4,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2-7"],
  [new Graph(9,[[2,5],[4,7],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[1,2,2,3,3,4,4,5,1],[1,1,2,2,1,1,2,2,2],"v-v-v-v-v-v-v-v&v-3&2-5&4-7"],
  [new Graph(10,[[9,10],[7,8],[5,6],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9],[7,10],[3,6]]),[3,3,4,4,5,5,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-3&v-v-v-v-8-2"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4]]),[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2"],
  [new Graph(7,[[2,5],[2,6],[4,7],[5,6],[4,5],[1,2],[2,4],[2,3],[3,4]]),[3/2,3,17/4,17/4,3,9/4,21/4],[5/2,5/2,5/2,1,1,7/4,1],"v-v-v-v-v-v-2-4-v&2-5"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[3,6]]),[4,19/4,3,7/4,7/4,3,17/4],[1,7/4,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-7"],
  [new Graph(7,[[2,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[2,3,19/4,4,19/4,3,2],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4&3-5"],
  [new Graph(7,[[4,7],[5,6],[4,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4],[3,6]]),[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3-7-4"],
  [new Graph(9,[[7,8],[5,6],[6,7],[4,9],[4,5],[5,8],[1,2],[2,9],[2,3],[3,4]]),[5,4,4,3,2,1,1,2,3],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&2-v-4"],
  [new Graph(7,[[5,6],[4,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4],[3,6]]),[-1/2,-1/2,1,1,1,2,2],[3,4,5,4,3,4,3],"v-v-v-v-v-v-v&2-4-6-3"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,9],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-3"],
  [new Graph(7,[[1,3],[4,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,3],[3,4]]),[15/4,21/4,9/2,13/4,11/4,7/4,7/4],[3/4,3/4,3/2,2,1,1,2],"v-v-v-v-v-v-v-4-1-3"],
  [new Graph(7,[[4,7],[2,5],[2,6],[4,6],[2,3],[1,2],[3,4],[4,5]]),[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,3/4,-1/4,1,1,-1/4],"v-v-v-v-v-2-v-4-v"],
  [new Graph(7,[[4,7],[5,6],[4,6],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,3,3,3,17/4,17/4,2],[2,2,1,0,1,0,1],"v-v-v-v-v-v-4-v-2"],
  [new Graph(8,[[4,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,1,2,3,3,2,1,3],[3,2,2,2,1,1,1,3],"v-v-v-v-v-v-v-2&v-4"],
  [new Graph(7,[[3,6],[2,6],[2,7],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,2,1,-1/4,-1/4,1,2],[7/2,7/2,9/2,9/2,7/2,7/2,5/2],"v-v-v-v-v-v-2-v&3-6"],
  [new Graph(10,[[2,5],[6,10],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,3,2,1,1,5,2],[2,2,1,1,2,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5"],
  [new Graph(7,[[2,6],[4,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,4]]),[7/4,3,4,4,4,3,7/4],[5/2,5/2,5/2,3/2,1/2,1,1],"v-v-v-v-v-v-2-4-6-v"],
  [new Graph(8,[[7,8],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4],[3,6]]),[1,1,2,2,3,3,2,3],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-3-v-v"],
  [new Graph(7,[[1,3],[2,5],[2,6],[1,7],[1,6],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-1"],
  [new Graph(7,[[1,3],[1,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,3],[3,5],[3,4],[3,6]]),[2,3,2,5/2,3/2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&3-6"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[6,7],[1,4],[4,5],[1,2],[2,3],[3,4],[3,5]]),[0,9/4,15/4,21/4,1/2,3/2,3/4],[5/2,1,1,1,-3/4,1/4,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[3/4,3/4,3/4,2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3/4,2,2,3,3,2,3/4],[3/2,2,1,1,2,3,3],"v-v-v-v-v-v-v&2-4&5-2-6"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,7],[2,3],[3,4],[3,5]]),[1/2,0,21/4,15/4,1/4,5/4,5/2],[3/2,5/2,1,1,-1/2,3/4,1],"v-v-v-v-v-v-v-2-4&2-5-3&5-7"],
  [new Graph(7,[[4,7],[2,4],[4,6],[2,3],[1,2],[3,4],[5,6],[4,5]]),[3,3,3,2,1,1,1],[1,2,3,2,3,2,1],"v-v-v-v-v-v-4-v&2-4"],
  [new Graph(9,[[5,6],[3,8],[5,9],[4,5],[1,2],[2,7],[2,3],[3,4]]),[1,2,2,3,4,5,3,1,4],[1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-3&v-5"],
  [new Graph(7,[[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4]]),[1,2,2,3,3,7/4,3/4],[2,2,1,2,3,3,3],"v-v-v-v-v-v-v&2-4"],
  [new Graph(7,[[4,6],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,4],[1,2],[4,7],[5,7],[2,4]]),[7/2,4,13/4,9/4,1,3,2],[4,9/4,3,11/4,5/4,5/4,7/4],"v-v-v-v-v-v-v-4-1-3&2-4-6&5-7"],
  [new Graph(7,[[4,7],[1,7],[1,6],[5,6],[4,5],[1,2],[2,3],[3,4]]),[1,1,2,3,2,1,2],[2,1,1,2,3,3,2],"v-v-v-v-v-v-1-v-4"],
  [new Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[6,7],[3,4],[4,5]]),[1,2,3,3,3,1,1],[1,2,3,2,1,3,2],"v-v-v-v-v-2-v-v-2"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,7],[3,7],[2,3],[3,5],[3,4]]),[4,5,25/4,4,5/4,3,4],[2,13/4,4,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3&5-7"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[3,7],[2,3],[3,4],[3,5]]),[9/4,13/4,19/4,11/4,3/4,2,3],[11/4,11/4,1,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&3-7-5"],
  [new Graph(7,[[2,5],[2,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4],[3,5]]),[1,2,4,3,1,2,1],[9/4,2,1,1,-3/4,3/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4"],
  [new Graph(7,[[2,5],[2,6],[2,7],[2,3],[1,2],[3,4]]),[1,2,3,3,1,1,2],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-2"],
  [new Graph(7,[[1,3],[1,5],[2,6],[1,7],[5,6],[1,4],[6,7],[4,5],[1,2],[2,7],[2,3],[3,5],[3,4]]),[3/4,19/4,3,2,2,3,9/4],[1,1,3/2,7/4,11/4,11/4,9/2],"v-v-v-v-v-v-v-1-3-5-1-4&6-2-7"],
  [new Graph(8,[[2,5],[7,8],[4,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4]]),[5,4,4,3,3,2,2,1],[1,1,2,2,1,1,2,2],"v-v-v-v-v-v-v-v&2-5&4-7"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[3,7],[2,3],[3,4]]),[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6&3-7"],
  [new Graph(7,[[1,5],[5,6],[1,4],[6,7],[4,5],[1,2],[5,7],[2,3],[3,4]]),[7/2,7/2,19/4,19/4,3,7/4,7/4],[1,0,0,1,2,1,2],"v-v-v-v-v-v-v-5-1-4"],
  [new Graph(7,[[4,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,5],[3,6]]),[7/4,11/4,1/4,4,23/4,0,1/2],[1,1,-1/2,1,1,5/2,3/2],"v-v-v-v-v-v-v&2-4-6-3-5"],
  [new Graph(7,[[2,5],[2,6],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,7/4,1/4,19/4,13/4,9/4,5/4],[2,2,-1/4,1,1,1,1/2],"v-v-v-v-v-v-v-2-4&3-7&5-2-6"],
  [new Graph(7,[[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,3,4,4,2],[1,2,2,2,2,1,1],"v-v-v-v-v-v&v-3"],
  [new Graph(9,[[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4]]),[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-7"],
  [new Graph(7,[[1,3],[2,6],[4,7],[4,6],[5,6],[1,4],[6,7],[4,5],[2,4],[1,2],[2,3],[3,4],[3,6]]),[2,3,3/4,9/4,17/4,17/4,7/2],[7/4,3/2,1,11/4,7/2,1,11/4],"v-v-v-v-v-v-v-4-1-3-6-2-4-6"],
  [new Graph(10,[[2,5],[7,8],[3,9],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[4,10]]),[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-v&v-3&v-4&2-5"],
  [new Graph(7,[[5,6],[1,4],[6,7],[4,5],[1,2],[2,4],[2,7],[2,3],[3,4]]),[3,3,4,4,3,3/2,3/2],[1,2,2,1,0,0,5/4],"v-v-v-v-v-v-v-2-4-1"],
  [new Graph(9,[[7,8],[1,6],[5,6],[1,4],[6,7],[4,5],[1,2],[2,9],[2,3],[3,4],[8,9]]),[2,1,1,2,3,3,3,2,1],[2,2,3,3,3,2,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-1-6"],
  [new Graph(9,[[3,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4],[8,9]]),[1,1,2,2,1,3,2,3,3],[1,2,2,3,3,1,1,2,3],"v-v-v-v-v&v-v-3-v-v"],
  [new Graph(10,[[9,10],[2,5],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9]]),[3,4,5,5,4,3,2,2,1,1],[2,2,2,1,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-5"],
  [new Graph(7,[[2,5],[5,6],[6,7],[4,5],[1,2],[2,3],[3,5],[3,4]]),[11/4,11/4,11/4,7/4,7/4,3/4,3/4],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-5-3"],
  [new Graph(7,[[5,6],[6,7],[4,5],[1,2],[5,7],[2,4],[2,3],[3,4],[3,5]]),[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-5-3&2-4"],
  [new Graph(8,[[3,8],[6,7],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,1,2,2,1,3,3,2],[1,2,2,3,3,1,2,1],"v-v-v-v-v&v-v-3-v"],
  [new Graph(7,[[1,3],[1,5],[5,6],[4,5],[5,7],[1,2],[3,7],[2,3],[3,4],[3,6]]),[5,4,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3"],
  [new Graph(7,[[4,6],[5,6],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[13/4,5/2,1,1,-1/4,-1/4,7/4],[9/4,3,3,17/4,17/4,13/4,9/4],"v-v-v-v-v-v-4-2-v"],
  [new Graph(7,[[2,5],[5,6],[4,5],[1,2],[3,7],[2,3],[3,4]]),[1,2,3,3,2,1,4],[2,2,2,1,1,1,2],"v-v-v-v-v-v&v-3&2-5"],
  [new Graph(7,[[2,6],[5,6],[6,7],[4,5],[2,4],[1,2],[2,7],[2,3],[3,4]]),[1,2,3,3,3,2,1],[1,2,1,2,3,3,3],"v-v-v-v-v-v-v-2-4&2-6"],
  [new Graph(7,[[1,5],[5,6],[6,7],[1,4],[5,7],[1,2],[2,3],[3,4]]),[9/2,7/2,7/2,9/2,11/4,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-1-v-v-v-6"],
  [new Graph(7,[[3,5],[6,7],[2,3],[4,5],[5,6],[3,4],[1,3],[1,2],[4,7],[1,5],[1,6],[2,4],[1,7]]),[3,5,4,3,3,2,1],[2,1,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4-7"],
  [new Graph(7,[[1,3],[2,6],[1,7],[4,7],[5,6],[6,7],[4,5],[1,2],[5,7],[2,3],[3,5],[3,4]]),[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4&2-6"],
  [new Graph(7,[[1,3],[1,5],[1,7],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[3,5]]),[3,4,4,4,3,7/4,7/4],[1,1/4,5/4,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-1"],
  [new Graph(10,[[9,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,7],[2,3],[3,4],[8,9]]),[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7"],
  [new Graph(7,[[4,7],[5,6],[6,7],[4,5],[1,2],[2,4],[2,7],[3,7],[2,3],[3,4]]),[1/2,0,19/4,13/4,9/4,5/4,1/4],[3/2,5/2,1,1,1,1/2,-1/2],"v-v-v-v-v-v-v-2-4-7-3"],
  [new Graph(7,[[4,7],[1,7],[4,6],[5,6],[1,4],[4,5],[2,4],[1,2],[2,3],[3,4]]),[3,5/2,3/2,2,1,1,3],[2,3,3,2,1,2,1],"v-v-v-v-v-v-4-v-1-4-2"],
  [new Graph(10,[[3,10],[7,8],[5,6],[6,7],[4,5],[1,2],[2,3],[3,4],[8,9],[7,10]]),[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&3-v-7"]
];


function EdgeBends(N, factor = 1) {       //
  /*
  Returns angles to bend edges depending on their number for TikZ.
  */

  let bends;
  
  if (N <= 5) {
    bends = [
      [],                     // for N = 0
      [0],                    // for N = 1
      [-30, 30],              // for N = 2
      [-60, 0, 60],           // for N = 3
      [-90, -30, 30, 90],     // for N = 4
      [-100, -50, 0, 50, 100] // for N = 5
    ][N];
  } else {
    bends = Array.from({ length: N }, (_, i) => (i * 240 / (N - 1)) - 120);
  }
  
  return bends.map(b => Math.round(b / factor));
}


function StandardGraphCoordinates(G) {
  /*
  Returns vertex coordinate lists x, y for planar drawing of a graph G
  */

  // Get graph label, path, and trails for the graph G - gridgraphs compatible label 
  let [Glabel, P, trails] = G.Label({full: true, usevertexlabels: false, revisited_format: "{0}"});   

  // Find the indices of vertices first appearing on the path
  let P0 = P.map((p, i) => (p[0] === 0 ? i : -1)).filter(i => i !== -1);

  // Get the first trail
  let T = trails[0];

  let Std = null;
  
  // Find a matching graph in the predefined gridgraphs based on the label
  for (let graph of gridgraphs) {
    if (graph[3] === Glabel) { // Check if GraphLabel(graph) matches GraphLabel(G)
      Std = graph;
      break;
    }
  }

  // If no matching graph is found, raise an error
  if (!Std) {
    throw new Error(`TeXGraph: Don't know how to draw graph with label ${Glabel} (e.g. large or non-connected)`);
  }

  // Extract the standard graph coordinates
  let [Gstd, x, y, _] = Std;

  // Permute the vertices according to the trail
  let perm = P0.map(i => T[i]);
  let invperm = new Array(perm.length);

  // Create an inverse permutation based on the trail
  for (let i = 0; i < perm.length; i++) {
    invperm[perm[i] - 1] = i + 1;
  }

  // Reorder x and y coordinates based on the permutation
  x = invperm.map(i => x[i - 1]);
  y = invperm.map(i => y[i - 1]);

  return [x, y];
}


function PrintVertexLabel(s) {                        //
  if (s === null || s === undefined) {
    return "";
  }
  return String(s).replace(/\s/g, "").replace(/\[/g, "").replace(/\]/g, "");
}


function TeXGraph(G, options = {}) {
  /*
  Draw a graph in TikZ, preferably planar. Options:
    x = "default",           // X-coordinates for vertices
    y = "default",           // Y-coordinates for vertices
    labels = "default",      // Labels for vertices (sequence or "default")
    scale = 0.8,             // Global scale for the TikZ picture
    xscale = 1,              // Scale factor in x direction
    yscale = 1,              // Scale factor in y direction 
    vertexlabel = "default", // Labeling function for vertices (or "default")
    edgelabel = "default",   // Labeling function for edges (or "default")
    vertexnodestyle = "default", // Style for vertices
    edgenodestyle = "default",   // Style for edge labels
    edgestyle = "default"        // Style for edges
  */

  let { x = "default", y = "default", labels = "default", scale = 0.8, xscale = 1, yscale = 1, 
        vertexlabel = "default", edgelabel = "default", vertexnodestyle = "default", 
        edgenodestyle = "default", edgestyle = "default" } = options;

  const RR = (v) => PrintReal(v, 2);               // Print reals with at most two digits after the decimal point

  if (x === "default" || y === "default") {        // If x or y coordinates are "default", use standard coordinates
    [x, y] = StandardGraphCoordinates(G);
  }

  // Adjust the scale for x and y coordinates
  xscale = RR(scale * xscale);
  yscale = RR(scale * yscale);

  // Initialize TikZ options
  let tikzstyle = `xscale=${xscale},yscale=${yscale},auto=left`;
  let tikzoptions = [tikzstyle];

  // Default styles if not provided
  if (vertexnodestyle === "default") {
    vertexnodestyle = "circle,scale=0.7,fill=blue!20,inner sep=1pt";
  }
  if (edgenodestyle === "default") {
    edgenodestyle = "scale=0.6,above";
  }
  if (edgestyle === "default") {
    edgestyle = "";
  }

  // Labels and styles for vertices and edges

  if (vertexlabel === "default") {
    vertexlabel = (v) => PrintVertexLabel(G.GetLabel(v));
  }
  if (edgelabel === "default") {
    edgelabel = (e) => PrintVertexLabel(G.GetLabel(e));
  }

  let styles = [vertexnodestyle, edgenodestyle, edgestyle];
  let vars = [Array.from(G.Vertices()), Array.from(G.Edges()), Array.from(G.Edges())];
  let optname = ["v", "l", "e"];

  let newstyles = [];

  styles.forEach((s, i) => {
    if (typeof s === "function" || vars[i].length === 0) {
      // If s is a function, apply it to the elements of vars[i]
      let V = new Set(vars[i].map(v => s(v)));
      if (V.size === 1) {
        s = [...V][0]; // If all results are the same, get the unique element
      } else if (V.size === 0) {
        s = ""; // If the set is empty, no style is applied
      }
    }
    if (typeof s === "string") {
      s = s.trim();
      if (s === "") {
        newstyles.push(() => ""); // Return an empty string for each vertex/edge
      } else {
        tikzoptions.push(`${optname[i]}/.style={${s}}`); // Add the style to the global options
        newstyles.push(() => optname[i]); // Return the style name
      }
    } else {
      newstyles.push(s); // Keep the function as is
    }
  });

  [vertexnodestyle, edgenodestyle, edgestyle] = newstyles;

  // Generate TikZ code
  let tikz_code = `\\begin{tikzpicture}[${tikzoptions.join(',')}]\n`;

  // Add vertices
  G.Vertices().forEach((v, i) => {
    let label = "";
    if (labels === "none") {
      label = `\\hbox to ${xscale}em{\\hfill}`;
    } else if (Array.isArray(labels)) {
      label = labels[i];
    } else if (labels !== "default") {
      throw new Error("labels should be 'none', 'default', or a list of strings");
    } else if (G.GetLabel(v)) {
      label = G.GetLabel(v);
    }
    tikz_code += `  \\node[${vertexnodestyle(v)}] (${i + 1}) at (${RR(x[i])},${RR(y[i])}) {${label}};\n`;
  });

  // Add edges
  G.Edges().forEach((e) => {
    let [v1, v2] = e;
    if (edgelabel) {
      let edge_label = edgelabel(e);
      tikz_code += `  \\draw[${edgestyle(e)}] (${v1})--node[${edgenodestyle(e)}] {${edge_label}} (${v2});\n`;
    } else {
      tikz_code += `  \\draw[${edgestyle(e)}] (${v1})--(${v2});\n`;
    }
  });

  tikz_code += "\\end{tikzpicture}";

  return tikz_code;
}


function SVGGraph(G, options = {}) {
  /*
  Draw a graph in SVG, preferably planar. Options:
    x = "default",            // x-coordinates for vertices
    y = "default",            // y-coordinates for vertices
    labels = "default",       // Labels for vertices (sequence or "default")
    scale = 0.8,              // Global scale for the TikZ picture
    xscale = 100,             // Scale factor in x direction
    yscale = 100,             // Scale factor in y direction 
    innersep = (labels?1:3),  // Inner separation space for vertices in pixels
    nodeRadius = 10,          // Vertex radius 
    padding    = 12,          // Vertex radius + eps for padding at the edges
  Labels can be a sequence of strings (or None, or "default" -> 1, 2, 3) to draw vertices.
  */

  let {                       // Set default values for the parameters
    x = "default",
    y = "default",
    labels = "default",
    scale = 0.8,
    xscale = 100,
    yscale = 100,
    innersep = (labels?1:3),
    nodeRadius = 10,          // Radius for nodes
    padding    = 12,          // Slightly more for padding at the edges
  } = options;

  // If labels are provided as "default", generate default labels; if null, empty labels
  if (labels === null) {
    labels = Array(x.length).fill("");                   // null = empty labels
  }
  if (labels === "default") {
    labels = G.GetLabels();
    if (labels.includes(undefined)) {
      labels = Array.from({ length: x.length }, (_, i) => (i + 1).toString()); // Default labels 1, 2, 3,...
    }
  }

  // If x or y coordinates are "default", use standard coordinates
  if (x === "default" || y === "default") {
    [x, y] = StandardGraphCoordinates(G);
  }

  const RR = v => PrintReal(v, 2);            // Printing reals with at most two digits after the decimal point

  xscale = scale * xscale;
  yscale = scale * yscale;
  
  // Compute min and max values for x and y
  let xMin = Math.min(...x);
  let yMin = Math.min(...y);
  let xMax = Math.max(...x);
  let yMax = Math.max(...y);
  
  // Shift x and y coordinates to start from 0, invert y
  x = x.map(val => xscale*(val - xMin) + padding);
  y = y.map(val => yscale*(yMax - val) + padding);
  xMin = Math.min(...x);
  yMin = Math.min(...y);
  xMax = Math.max(...x);
  yMax = Math.max(...y);
  
  // Compute SVG width and height based on the max values
  let svgWidth =  (xMax - xMin) + padding * 2;
  let svgHeight = (yMax - yMin) + padding * 2;
  
  let svg_code = `<svg width="${svgWidth}" height="${svgHeight}" xmlns="http://www.w3.org/2000/svg">\n`;
  
  // Add edges to the SVG
  G.Edges().forEach(([v1, v2]) => {
    let x1 = RR(x[G.Vertices().indexOf(v1)]);
    let y1 = RR(y[G.Vertices().indexOf(v1)]);
    let x2 = RR(x[G.Vertices().indexOf(v2)]);
    let y2 = RR(y[G.Vertices().indexOf(v2)]);
    svg_code += `  <line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" class="edge" />\n`;
  });
  
  // Add vertices to the SVG
  G.Vertices().forEach((v, i) => {
    let cx = RR(x[i]);
    let cy = RR(y[i]);
    svg_code += `  <circle cx="${cx}" cy="${cy}" r="${nodeRadius}" class="vertex" />\n`;
    svg_code += `  <text x="${cx}" y="${cy}" text-anchor="middle" dy=".3em" font-size="12" class="label">${labels[i]}</text>\n`;
  });
  
  svg_code += '</svg>\n';
  return svg_code;
}


function GraphFromEdgesString(edgesString) {
  /*
  Construct a graph from a string encoding edges such as "1-2-3-4, A-B, C-D", assigning the vertex labels to the corresponding strings.
  */

  const edgeChains = edgesString.split(',');
  const edgeRegex = /^[A-Za-z_0-9]+(-[A-Za-z_0-9]+)*$/; // Regex to match valid edges (alphanumeric separated by dashes)

  const edges = [];
  const vertices = new Map();  // Map to store unique vertex labels and assign them numbers
  let vertexCount = 0;         // Counter for assigning numbers to unique vertices
  
  for (let chain of edgeChains) {       // Iterate over each chain and validate it
    chain = chain.trim();               // Remove extra whitespace
    if (!edgeRegex.test(chain)) {       // Check if the chain matches the expected pattern
      return null;                      // If invalid, return null
    }

    const V = chain.split('-');         // Split the chain by dashes to get the vertices in that chain
    for (let i = 0; i < V.length; i++) {
      const vertex = V[i];

      if (!vertices.has(vertex)) {      // If vertex label hasn't been seen before, assign a new number
        vertices.set(vertex, ++vertexCount);
      }
    }

    for (let i = 0; i < V.length - 1; i++) {  // Add edges between consecutive vertices
      edges.push([vertices.get(V[i]), vertices.get(V[i + 1])]);
    }
  }

  const vertexLabels = [...vertices.keys()];    // Array of vertex labels
  const G = new Graph(vertexCount, edges);      // Create a new Graph object using the Graph constructor
  G.SetLabels(vertexLabels);                    // Assign labels to vertices based on the original input
  return G;
}


//const G = new Graph(6,[[1,2],[2,3],[3,4],[4,1],[2,5],[3,6]])

/*
Example
const G   = GraphFromEdgesString("1-2-3-4, 1-3, 2-4-A-1")
console.log(G.Label())
console.log(TeXGraph(G))
const svg = SVGGraph(G)          // for use in HTML files
*/


/// RedShape


/*
Manual
A reduction type a graph whose vertices are principal types (type RedPrin) 
and edges are inner chains. They fall naturally into `shapes', where every vertex only remembers the 
Euler characteristic $\chi$ of the type, and edge the gcd of the chain. Thus, the problem
of finding all reduction types in a given genus (see ReductionTypes) reduces to that of finding the possible
shapes (see Shapes) and filling in shape components with given $\chi$ and gcds of edges (see PrincipalTypes).
*/


/*
# Example Table of all genus 2 shapes, with numbers of principal type combinations.
// Here is how this works in genus 2. The 104 families of reduction types break into five possible shapes, with all 
// but three types in the first two shape (46 and 55 types, respectively):
const L = Shapes(2)
console.log(L.map(D => D[0].TeX({shapelabel: D[1]})).join("\qquad "))
*/


class RedShape {
  constructor() {                                       //
    this.G = null;  // Underlying undirected graph
    this.V = null;  // Vertices
    this.E = null;  // Edge labels
    this.D = null;  // Double graph
  }
  
  Graph() {
    /*
    Returns the underlying undirected graph G of the shape.
    */
    return this.G;
  }

  DoubleGraph() {
    /*
    Returns the vertex-labelled double graph D of the shape.
    */
    return this.D;
  }

  Vertices() {
    /*
    Returns the vertex set of G as a graph.
    */
    return this.V;
  }

  Edges() {
    /*
    Returns the edges of G as a graph
    */
    return this.E.map((e) => [e[0],e[1]]);
  }

  NumVertices() {
    /*
    Returns the number of vertices in the graph G underlying the shape.
    */
    return this.V.length;
  }

  Chi(v) {
    /*
    Returns the Euler characteristic chi(v) <= 0 of the vertex v.
    */
    if (!this.G.HasVertex(v)) {
      throw new Error("Vertex not in the vertex set of G.");
    }
    let chi = this.G.GetLabel(v)[0];  
    if (chi > 0) {
      throw new Error(`Invalid Euler characteristic: ${chi} > 0.`);
    }
    return chi;
  }

  Weights(v) {
    /*
    Returns the Weights of a vertex v that together with chi determine the vertex type (chi, weights).
    */
    return this.E.filter(e => e[0] === v || e[1] === v)    // Filter edges where e[0] or e[1] matches v
       .flatMap(e => e.slice(2))                           // extract everything after e[2], flatten,
       .sort();                                            // and sort
  }

  TotalChi() {
    /*
    Returns the total Euler characteristic of a graph shape chi <= 0, sum over chi's of vertices.
    */
    let totalChi = this.V.reduce((sum, v) => sum + this.Chi(v), 0);
    if (totalChi > 0) {
      throw new Error(`Total Euler characteristic ${totalChi} > 0.`);
    }
    return totalChi;
  }

  VertexLabels() {
    /*
    Returns a sequence of -chi's for individual components of the shape S.
    */
    return this.V.map(v => -this.Chi(v));
  }

  EdgeLabels() {
    /*
    Returns a list of edges v_i -> v_j of the form [i, j, edgegcd].
    */
    return this.E;
  }
  
  toString() {
    /*
    Print in the form Shape(V,E) so as to be evaluatable
    */
    const vertexLabels = this.VertexLabels().join(",");   // Convert vertex labels to comma-separated string
    const edgeLabels = this.EdgeLabels().join(",");       // Convert edges to comma-separated string
    return `Shape([${vertexLabels}],[${edgeLabels}])`;        // Return formatted string
  }
  
  TeX(options = {}) {
    /*
    Tikz a shape of a reduction graph, and, if required, the bounding box x1, y1, x2, y2.
    */
    const {
      scale = 1.5,
      center = false,
      shapelabel = "",
      complabel = "default",
      boundingbox = false
    } = options;

    // Call TeXRedShape with the current instance (this) and the options
    const [T, x1, y1, x2, y2] = TeXRedShape(this, { scale, center, shapelabel, complabel });

    // Return values based on the boundingbox flag
    if (boundingbox) {
      return [T, x1, y1, x2, y2];
    } else {
      return T;
    }
  }

}


/*
Example Graph, DoubleGraph and primary invariants for shapes
// Under the hood of shapes of reduction types are their labelled graphs and associated `double' graphs. 
// As an example, take the following reduction type:
const R = ReductionType("1g2--IV=IV-1g1-c1");   
console.log(R.TeX());
// There are four principal types, and they become vertices of R.Shape() whose labels are their Euler characteristics
// $-5, -2, -4, -5$. The edges are labelled with GCDs of the inner chain between the types.
// For example:\par
// \begin{tabular}{@{\qquad}l}
// --- the inner chain 1g2-1g1 of gcd 1 becomes the label ``1'', \cr
// --- the inner chain IV=IV of gcd 3 becomes ``3'',\cr
// --- the two chains 1g2--IV of gcd 1 become ``1,1''\cr
// \end{tabular}\par
// on the corresponding edges. 
const S = R.Shape(); 
console.log(S.toString());
console.log(TeXGraph(S.Graph()));
console.log(S.Vertices());      // Indexed (from 1) set of vertices of S.Graph()
console.log(S.Edges());         //   and edges [ (from_vertex, to_vertex), ... ]
console.log(S.VertexLabels());  // [-chi] for each type
console.log(S.EdgeLabels());    // [ [from_vertex, to_vertex, gcd1, gcd2, ...], ...]
// MinimumScorePaths is implemented in python for graphs with labelled vertices but not edges. 
// To use them for shapes, the underlying graphs are converted to graphs with only labelled
// vertices. This is done simply by introducing a new vertex on every edge which carries the corresponding edge 
// label. For compactness, if the label is ``1'' (most common case), we don't introduce the vertex at all.
// This is called the double graph of the shape:
const blue = "circle,scale=0.7,inner sep=2pt,fill=blue!20";       // former vertices
const red = "circle,draw,scale=0.5,inner sep=2pt, fill=red!20";  // former edges
const D = S.DoubleGraph();
const bluered = v => (D.GetLabel(v)[0] <= 0 ? blue : red);
console.log(TeXGraph(D, { scale: 1, vertexnodestyle: bluered }));
// These are used in isomorphism testing for shapes, and to construct minimal paths.
*/



function Shape(V, E) {
  /*
  Constructs a graph shape from the data V, E as described in shapes*.txt data files:
  V = sequence of chi's for individual components
  E = list of edges v_i->v_j of the form [i,j,edgegcd1,edgegcd2,...]
  */

  if (!Array.isArray(V)) {
    throw new Error("Shape: V must be an array");
  }
  if (!Array.isArray(E)) {
    throw new Error("Shape: E must be an array");
  }
  if (!(V.length === 1 && V[0] === 0 || V.every(d => d > 0))) {
    throw new Error("Shape: V's must be > 0, unless one vertex [0]");
  }
  if (!E.every(e => e.length >= 3 && e.slice(2).every(gcd => gcd > 0))) {
    throw new Error("Shape: Edge gcd's must be > 0");
  }

  const n = V.length;
  let k = 0;  // Number of extra vertices (|V(D)| - |V(G)|)

  // Initialize G and D as undirected graphs
  const G = new Graph();
  const D = new Graph();

  // Add vertices to G and D with labels [-V[i-1]]
  for (let i = 0; i < n; i++) {
    const vertex = i + 1;
    G.AddVertex(vertex, [-V[i]]);
    D.AddVertex(vertex, [-V[i]]);
  }

  for (const e of E) {
    const [i, j, ...gcds] = e;
    const sortedGcds = gcds.sort((a, b) => a - b);

    if (G.HasEdge(i, j)) {
      throw new Error(`Already have an edge ${i}-${j} in the shape`);
    }
    G.AddEdge(i, j);
    // We can assume labels would be set later if needed (as shown in original code)

    if (sortedGcds.length === 1 && sortedGcds[0] === 1) {
      D.AddEdge(i, j);
    } else {
      k += 1;
      const newVertex = n + k;
      D.AddVertex(newVertex, sortedGcds);
      D.AddEdge(newVertex, i);
      D.AddEdge(newVertex, j);
    }
  }

  const S = new RedShape();          // Create a new RedShape object, fill in values, and return
  S.G = G;
  S.V = G.Vertices();
  S.E = E;
  S.D = D;

  return S;
}


/*
Example
const shape = Shape([1, 2, 3], [[1, 2, 3], [2, 3, 1], [1, 3, 2]])
console.log(shape.G.Vertices());  // Vertex set of graph G
console.log(shape.G.Edges());     // Edge set of graph G
console.log(shape.D.Vertices());  // Vertex set of graph D
console.log(shape.D.Edges());     // Edge set of graph D
*/


const Shapes2Txt = `[2] [] [46] 46\n[1,1] [[1,2,1]] [10,10] 55\n[1,1] [[1,2,1,1,1]] [1,1] 1\n[1,1] [[1,2,3]] [1,1] 1\n[1,1] [[1,2,1,2]] [1,1] 1`;
const Shapes3Txt = `[4] [] [150] 150\n[3,1] [[1,2,3]] [15,1] 15\n[3,1] [[1,2,1]] [39,10] 390\n[3,1] [[1,2,1,1,1]] [5,1] 5\n[3,1] [[1,2,1,2]] [6,1] 6\n[2,2] [[1,2,1,3]] [2,2] 3\n[2,2] [[1,2,2]] [18,18] 171\n[2,2] [[1,2,1,1]] [8,8] 36\n[2,2] [[1,2,1,1,2]] [1,1] 1\n[2,2] [[1,2,2,2]] [2,2] 3\n[2,2] [[1,2,2,2,2]] [1,1] 1\n[2,2] [[1,2,6]] [1,1] 1\n[2,2] [[1,2,1,1,1,1]] [1,1] 1\n[2,2] [[1,2,4]] [2,2] 3\n[2,2] [[1,2,2,4]] [1,1] 1\n[2,1,1] [[1,3,1,1],[2,3,1]] [8,10,1] 80\n[2,1,1] [[1,3,2],[2,3,1]] [18,10,1] 180\n[1,1,2] [[1,3,1],[2,3,1]] [10,10,8] 440\n[1,1,2] [[1,3,1],[2,3,1,1,1]] [10,1,1] 10\n[1,1,2] [[1,3,1],[2,3,3]] [10,1,2] 20\n[1,1,2] [[1,3,1],[2,3,1,2]] [10,1,1] 10\n[2,1,1] [[1,2,1],[1,3,1],[2,3,1,1]] [8,1,1] 8\n[2,1,1] [[1,2,1],[1,3,1],[2,3,2]] [8,1,1] 8\n[2,1,1] [[1,2,1,1],[1,3,2],[2,3,1]] [1,1,1] 1\n[2,1,1] [[1,2,1,1],[1,3,1,1],[2,3,1]] [1,1,1] 1\n[2,1,1] [[1,2,2],[1,3,2],[2,3,1]] [2,1,1] 2\n[1,1,1,1] [[1,4,1],[2,4,1],[3,4,1]] [10,10,10,1] 220\n[1,1,1,1] [[1,3,1],[1,4,1,1],[2,4,1]] [1,10,10,1] 55\n[1,1,1,1] [[1,3,1],[1,4,2],[2,4,1]] [1,10,10,1] 55\n[1,1,1,1] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,1] 10\n[1,1,1,1] [[1,3,2],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,1] 10\n[1,1,1,1] [[1,3,1],[1,4,1,1],[2,3,1,1],[2,4,1]] [1,1,1,1] 1\n[1,1,1,1] [[1,3,1],[1,4,1,1],[2,3,2],[2,4,1]] [1,1,1,1] 1\n[1,1,1,1] [[1,3,1],[1,4,2],[2,3,2],[2,4,1]] [1,1,1,1] 1\n[1,1,1,1] [[1,2,1],[1,3,1],[1,4,1],[2,3,1],[2,4,1],[3,4,1]] [1,1,1,1] 1`;
const Shapes4Txt = `[6] [] [282] 282\n[5,1] [[1,2,1]] [108,10] 1080\n[5,1] [[1,2,1,2]] [14,1] 14\n[5,1] [[1,2,1,1,1]] [11,1] 11\n[5,1] [[1,2,3]] [6,1] 6\n[4,2] [[1,2,2]] [29,18] 522\n[4,2] [[1,2,2,2]] [12,2] 24\n[4,2] [[1,2,2,2,2]] [2,1] 2\n[4,2] [[1,2,4]] [22,2] 44\n[4,2] [[1,2,2,4]] [1,1] 1\n[4,2] [[1,2,6]] [3,1] 3\n[4,2] [[1,2,1,3]] [4,2] 8\n[4,2] [[1,2,1,1]] [28,8] 224\n[4,2] [[1,2,1,1,1,1]] [3,1] 3\n[4,2] [[1,2,1,1,2]] [4,1] 4\n[3,3] [[1,2,3]] [15,15] 120\n[3,3] [[1,2,9]] [1,1] 1\n[3,3] [[1,2,1]] [39,39] 780\n[3,3] [[1,2,1,1,1]] [5,5] 15\n[3,3] [[1,2,1,1,3]] [1,1] 2\n[3,3] [[1,2,5]] [2,2] 3\n[3,3] [[1,2,1,4]] [2,2] 3\n[3,3] [[1,2,1,2]] [6,6] 21\n[3,3] [[1,2,3,3,3]] [1,1] 1\n[3,3] [[1,2,1,1,1,1,1]] [1,1] 1\n[3,3] [[1,2,1,2,2]] [1,1] 1\n[3,3] [[1,2,3,6]] [1,1] 1\n[4,1,1] [[1,3,2],[2,3,1]] [29,10,1] 290\n[4,1,1] [[1,3,1,1],[2,3,1]] [28,10,1] 280\n[1,1,4] [[1,3,1],[2,3,1]] [10,10,28] 1945\n[1,1,4] [[1,3,1],[2,3,1,1,1]] [10,1,3] 30\n[1,1,4] [[1,3,1],[2,3,3]] [10,1,4] 40\n[1,1,4] [[1,3,1],[2,3,1,2]] [10,1,4] 40\n[1,1,4] [[1,3,1,1,1],[2,3,1,1,1]] [1,1,1] 1\n[1,1,4] [[1,3,3],[2,3,3]] [1,1,1] 1\n[1,1,4] [[1,3,1,2],[2,3,1,2]] [1,1,1] 1\n[3,2,1] [[1,3,1],[2,3,1,1]] [39,8,1] 312\n[3,2,1] [[1,3,1],[2,3,2]] [39,18,1] 702\n[2,1,3] [[1,3,1,3],[2,3,1]] [2,10,1] 40\n[2,1,3] [[1,3,1,1],[2,3,1]] [8,10,5] 400\n[2,1,3] [[1,3,1,1],[2,3,1,1,1]] [8,1,1] 8\n[2,1,3] [[1,3,1,1],[2,3,3]] [8,1,1] 8\n[2,1,3] [[1,3,2],[2,3,1]] [18,10,6] 1080\n[2,1,3] [[1,3,2],[2,3,1,2]] [18,1,1] 18\n[2,1,3] [[1,3,2,2],[2,3,1]] [2,10,1] 20\n[2,1,3] [[1,3,6],[2,3,3]] [1,1,1] 1\n[2,1,3] [[1,3,1,1,1,1],[2,3,1]] [1,10,1] 10\n[2,1,3] [[1,3,4],[2,3,1]] [2,10,2] 40\n[1,3,2] [[1,3,1],[2,3,3]] [10,15,2] 300\n[1,3,2] [[1,3,1],[2,3,1]] [10,39,8] 3120\n[1,3,2] [[1,3,1],[2,3,1,1,1]] [10,5,1] 50\n[1,3,2] [[1,3,1],[2,3,1,2]] [10,6,1] 60\n[1,3,2] [[1,3,1,1,1],[2,3,1]] [1,39,1] 39\n[1,3,2] [[1,3,3],[2,3,1]] [1,39,2] 78\n[1,3,2] [[1,3,1,2],[2,3,1]] [1,39,1] 39\n[2,2,2] [[1,3,2],[2,3,1,1]] [18,8,1] 144\n[2,2,2] [[1,3,2],[2,3,2]] [18,18,2] 342\n[2,2,2] [[1,3,2],[2,3,2,2]] [18,2,1] 36\n[2,2,2] [[1,3,2],[2,3,4]] [18,2,1] 36\n[2,2,2] [[1,3,1,1],[2,3,1,1]] [8,8,1] 36\n[4,1,1] [[1,2,2],[1,3,2],[2,3,1]] [12,1,1] 12\n[4,1,1] [[1,2,2],[1,3,1,1],[2,3,1]] [4,1,1] 4\n[4,1,1] [[1,2,1],[1,3,1],[2,3,1,1]] [28,1,1] 28\n[4,1,1] [[1,2,1],[1,3,1],[2,3,2]] [28,1,1] 28\n[4,1,1] [[1,2,1,1],[1,3,1,1],[2,3,1]] [3,1,1] 3\n[3,2,1] [[1,2,3],[1,3,1,1],[2,3,1]] [1,2,1] 2\n[3,2,1] [[1,2,1],[1,3,1,1],[2,3,1]] [5,8,1] 40\n[3,2,1] [[1,2,1],[1,3,2],[2,3,1]] [6,8,1] 48\n[3,2,1] [[1,2,1,1],[1,3,1],[2,3,2]] [5,1,1] 5\n[3,2,1] [[1,2,1,1],[1,3,1],[2,3,1,1]] [5,1,1] 5\n[3,2,1] [[1,2,1,1,1],[1,3,1,1],[2,3,1]] [1,1,1] 1\n[3,2,1] [[1,2,4],[1,3,1],[2,3,2]] [2,1,1] 2\n[3,2,1] [[1,2,2],[1,3,1],[2,3,1,1]] [6,1,1] 6\n[3,2,1] [[1,2,2],[1,3,1],[2,3,2]] [6,2,1] 12\n[3,2,1] [[1,2,1,2],[1,3,2],[2,3,1]] [1,1,1] 1\n[3,2,1] [[1,2,2,2],[1,3,1],[2,3,2]] [1,1,1] 1\n[2,2,2] [[1,2,1],[1,3,3],[2,3,1]] [2,8,2] 24\n[2,2,2] [[1,2,1],[1,3,1],[2,3,1]] [8,8,8] 120\n[2,2,2] [[1,2,1],[1,3,1],[2,3,1,2]] [8,1,1] 8\n[2,2,2] [[1,2,1],[1,3,1],[2,3,1,1,1]] [8,1,1] 8\n[2,2,2] [[1,2,2],[1,3,1,1],[2,3,1,1]] [1,1,1] 1\n[2,2,2] [[1,2,2],[1,3,1,1],[2,3,2]] [1,2,1] 2\n[2,2,2] [[1,2,2],[1,3,2],[2,3,2]] [2,2,2] 4\n[2,2,2] [[1,2,2],[1,3,2],[2,3,2,2]] [2,1,1] 2\n[2,2,2] [[1,2,2],[1,3,2],[2,3,4]] [2,1,1] 2\n[2,2,2] [[1,2,1,1],[1,3,1,1],[2,3,1,1]] [1,1,1] 1\n[3,1,1,1] [[1,4,1],[2,4,1],[3,4,1]] [39,10,10,1] 2145\n[1,1,1,3] [[1,4,1],[2,4,1],[3,4,1]] [10,10,10,5] 1100\n[1,1,1,3] [[1,4,1],[2,4,1],[3,4,1,1,1]] [10,10,1,1] 55\n[1,1,1,3] [[1,4,1],[2,4,1],[3,4,3]] [10,10,1,1] 100\n[1,1,1,3] [[1,4,3],[2,4,3],[3,4,3]] [1,1,1,1] 1\n[2,1,1,2] [[1,4,2],[2,4,1],[3,4,1]] [18,10,10,1] 990\n[2,1,1,2] [[1,4,1,1],[2,4,1],[3,4,1]] [8,10,10,1] 440\n[3,1,1,1] [[1,3,3],[1,4,1,1],[2,4,1]] [1,10,1,1] 10\n[3,1,1,1] [[1,3,1],[1,4,1,1],[2,4,1]] [5,10,10,1] 500\n[3,1,1,1] [[1,3,1],[1,4,2],[2,4,1]] [6,10,10,1] 600\n[3,1,1,1] [[1,3,1,1,1],[1,4,1,1],[2,4,1]] [1,10,1,1] 10\n[3,1,1,1] [[1,3,1,2],[1,4,2],[2,4,1]] [1,10,1,1] 10\n[1,3,1,1] [[1,3,1],[1,4,1,1],[2,4,1]] [1,39,10,1] 390
[1,3,1,1] [[1,3,1],[1,4,2],[2,4,1]] [1,39,10,1] 390\n[2,2,1,1] [[1,3,1],[1,4,1],[2,4,1,1]] [8,8,10,1] 640\n[2,2,1,1] [[1,3,1],[1,4,1],[2,4,2]] [8,18,10,1] 1440\n[2,2,1,1] [[1,3,3],[1,4,1],[2,4,1,1]] [2,8,1,1] 16\n[2,2,1,1] [[1,3,3],[1,4,1],[2,4,2]] [2,18,1,1] 36\n[2,2,1,1] [[1,3,1,2],[1,4,1],[2,4,1,1]] [1,8,1,1] 8\n[2,2,1,1] [[1,3,1,2],[1,4,1],[2,4,2]] [1,18,1,1] 18\n[2,2,1,1] [[1,3,1,1,1],[1,4,1],[2,4,1,1]] [1,8,1,1] 8\n[2,2,1,1] [[1,3,1,1,1],[1,4,1],[2,4,2]] [1,18,1,1] 18\n[1,2,2,1] [[1,3,1,1],[1,4,1],[2,4,1,1]] [1,8,8,1] 36\n[1,2,2,1] [[1,3,1,1],[1,4,1],[2,4,2]] [1,18,8,1] 144\n[1,2,2,1] [[1,3,2],[1,4,1],[2,4,2]] [1,18,18,1] 171\n[2,1,2,1] [[1,3,2],[1,4,1,1],[2,4,1]] [1,10,18,1] 180\n[2,1,2,1] [[1,3,2],[1,4,2],[2,4,1]] [2,10,18,1] 360\n[2,1,2,1] [[1,3,1,1],[1,4,2],[2,4,1]] [1,10,8,1] 80\n[2,1,2,1] [[1,3,1,1],[1,4,1,1],[2,4,1]] [1,10,8,1] 80\n[2,1,2,1] [[1,3,2,2],[1,4,2],[2,4,1]] [1,10,2,1] 20\n[2,1,2,1] [[1,3,4],[1,4,2],[2,4,1]] [1,10,2,1] 20\n[2,1,1,2] [[1,3,1],[1,4,3],[2,4,1]] [2,10,10,2] 210\n[2,1,1,2] [[1,3,1],[1,4,1],[2,4,1]] [8,10,10,8] 3240\n[2,1,1,2] [[1,3,1],[1,4,1],[2,4,1,1,1]] [8,1,10,1] 80\n[2,1,1,2] [[1,3,1],[1,4,1],[2,4,3]] [8,1,10,2] 160\n[2,1,1,2] [[1,3,1],[1,4,1],[2,4,1,2]] [8,1,10,1] 80\n[2,1,1,2] [[1,3,1],[1,4,1,2],[2,4,1]] [1,10,10,1] 55\n[2,1,1,2] [[1,3,1],[1,4,1,1,1],[2,4,1]] [1,10,10,1] 55\n[2,1,1,2] [[1,3,3],[1,4,1],[2,4,1,1,1]] [2,1,1,1] 2\n[2,1,1,2] [[1,3,3],[1,4,1],[2,4,3]] [2,1,1,2] 3\n[2,1,1,2] [[1,3,3],[1,4,1],[2,4,1,2]] [2,1,1,1] 2\n[2,1,1,2] [[1,3,1,2],[1,4,1],[2,4,1,1,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1,2],[1,4,1],[2,4,1,2]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1,1,1],[1,4,1],[2,4,1,1,1]] [1,1,1,1] 1\n[3,1,1,1] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,1]] [5,10,1,1] 50\n[3,1,1,1] [[1,3,2],[1,4,1],[2,4,1],[3,4,1]] [6,10,1,1] 60\n[1,3,1,1] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,1]] [1,39,1,1] 39\n[1,3,1,1] [[1,3,2],[1,4,1],[2,4,1],[3,4,1]] [1,39,1,1] 39\n[1,1,1,3] [[1,3,1],[1,4,1,1],[2,4,1],[3,4,1,1]] [1,10,1,1] 10\n[1,1,1,3] [[1,3,1],[1,4,2],[2,4,1],[3,4,2]] [1,10,1,1] 10\n[1,1,1,3] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,5] 50\n[1,1,1,3] [[1,3,1,1],[1,4,1],[2,4,1,1,1],[3,4,1]] [1,1,1,1] 1\n[1,1,1,3] [[1,3,1,1],[1,4,1],[2,4,3],[3,4,1]] [1,1,1,1] 1\n[1,1,1,3] [[1,3,2],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,5] 50\n[1,1,1,3] [[1,3,2],[1,4,1],[2,4,1,1,1],[3,4,1]] [1,1,1,1] 1\n[1,1,1,3] [[1,3,2],[1,4,1],[2,4,3],[3,4,1]] [1,1,1,1] 1\n[1,1,2,2] [[1,3,1],[1,4,1,1],[2,4,1],[3,4,1]] [1,10,8,1] 80\n[1,1,2,2] [[1,3,1],[1,4,2],[2,4,1],[3,4,1]] [1,10,8,1] 80\n[1,1,2,2] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,2]] [1,10,1,1] 10\n[1,1,2,2] [[1,3,1,1],[1,4,1],[2,4,1],[3,4,1,1]] [1,10,1,1] 10\n[1,1,2,2] [[1,3,2],[1,4,1],[2,4,1],[3,4,1,1]] [1,10,1,1] 10\n[1,1,2,2] [[1,3,2],[1,4,1],[2,4,1],[3,4,2]] [1,10,2,1] 20\n[2,1,2,1] [[1,3,1],[1,4,1],[2,4,1],[3,4,1]] [8,10,8,1] 360\n[2,1,2,1] [[1,3,3],[1,4,1],[2,4,1],[3,4,1]] [2,10,2,1] 30\n[2,1,2,1] [[1,3,1,2],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,1] 10\n[2,1,2,1] [[1,3,1,1,1],[1,4,1],[2,4,1],[3,4,1]] [1,10,1,1] 10\n[1,2,1,2] [[1,3,1],[1,4,2],[2,4,2],[3,4,2]] [1,18,1,1] 18\n[1,2,1,2] [[1,3,1,1],[1,4,1],[2,4,2],[3,4,1]] [1,18,1,1] 18\n[1,2,1,2] [[1,3,1,1],[1,4,1],[2,4,1,1],[3,4,1]] [1,8,1,1] 8\n[1,2,1,2] [[1,3,2],[1,4,1],[2,4,2],[3,4,1]] [1,18,1,1] 18\n[1,2,1,2] [[1,3,2],[1,4,1],[2,4,1,1],[3,4,1]] [1,8,1,1] 8\n[3,1,1,1] [[1,3,1],[1,4,1,1],[2,3,1,1],[2,4,1]] [5,1,1,1] 5\n[3,1,1,1] [[1,3,1],[1,4,1,1],[2,3,2],[2,4,1]] [5,1,1,1] 5\n[3,1,1,1] [[1,3,1],[1,4,2],[2,3,1,1],[2,4,1]] [6,1,1,1] 6\n[3,1,1,1] [[1,3,1],[1,4,2],[2,3,2],[2,4,1]] [6,1,1,1] 6\n[2,2,1,1] [[1,3,1],[1,4,1],[2,3,1,1],[2,4,2]] [8,1,1,1] 8\n[2,2,1,1] [[1,3,1],[1,4,1],[2,3,1,1],[2,4,1,1]] [8,1,1,1] 8\n[2,2,1,1] [[1,3,1],[1,4,1],[2,3,2],[2,4,2]] [8,2,1,1] 16\n[2,1,1,2] [[1,3,1],[1,4,3],[2,3,1,1],[2,4,1]] [2,1,1,2] 3\n[2,1,1,2] [[1,3,1],[1,4,3],[2,3,2],[2,4,1]] [2,1,1,2] 3\n[2,1,1,2] [[1,3,1],[1,4,1],[2,3,1,1],[2,4,1]] [8,1,1,8] 36\n[2,1,1,2] [[1,3,1],[1,4,1],[2,3,2],[2,4,1]] [8,1,1,8] 36\n[2,1,1,2] [[1,3,1],[1,4,1,2],[2,3,1,1],[2,4,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1],[1,4,1,2],[2,3,2],[2,4,1]] [1,1,1,1] 1
[2,1,1,2] [[1,3,1],[1,4,1,1,1],[2,3,1,1],[2,4,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1],[1,4,1,1,1],[2,3,2],[2,4,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1,1],[1,4,2],[2,3,1],[2,4,1,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1,1],[1,4,2],[2,3,1],[2,4,2]] [1,1,1,2] 2\n[2,1,1,2] [[1,3,1,1],[1,4,1,1],[2,3,1],[2,4,1,1]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,1,1],[1,4,1,1],[2,3,1],[2,4,2]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,2],[1,4,1,1],[2,3,1],[2,4,2]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,2],[1,4,2],[2,3,1],[2,4,2]] [2,1,1,2] 3\n[2,1,1,2] [[1,3,2],[1,4,2,2],[2,3,1],[2,4,2]] [1,1,1,1] 1\n[2,1,1,2] [[1,3,2],[1,4,4],[2,3,1],[2,4,2]] [1,1,1,1] 1\n[1,1,3,1] [[1,3,1,1],[1,4,1],[2,3,1,1],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[1,1,3,1] [[1,3,2],[1,4,1],[2,3,2],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[2,2,1,1] [[1,3,1],[1,4,1],[2,3,1],[2,4,1],[3,4,1]] [8,8,1,1] 36\n[2,1,1,2] [[1,3,1],[1,4,1],[2,3,1],[2,4,1,1],[3,4,1]] [8,1,1,1] 8\n[2,1,1,2] [[1,3,1],[1,4,1],[2,3,1],[2,4,2],[3,4,1]] [8,1,1,1] 8\n[1,1,2,2] [[1,3,1],[1,4,1,1],[2,3,1,1],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[1,1,2,2] [[1,3,1],[1,4,1,1],[2,3,2],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[1,1,2,2] [[1,3,1],[1,4,2],[2,3,1],[2,4,2],[3,4,2]] [1,1,1,1] 1\n[1,1,2,2] [[1,3,1],[1,4,2],[2,3,2],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[3,1,1,1] [[1,2,1],[1,3,1],[1,4,1],[2,3,1],[2,4,1],[3,4,1]] [5,1,1,1] 5\n[2,2,1,1] [[1,2,2],[1,3,1],[1,4,1],[2,3,1],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[2,2,1,1] [[1,2,1,1],[1,3,1],[1,4,1],[2,3,1],[2,4,1],[3,4,1]] [1,1,1,1] 1\n[1,1,1,1,2] [[1,5,1],[2,5,1],[3,5,1],[4,5,1]] [10,10,10,10,1] 715\n[2,1,1,1,1] [[1,4,1],[1,5,1],[2,5,1],[3,5,1]] [8,10,10,10,1] 4400\n[2,1,1,1,1] [[1,4,3],[1,5,1],[2,5,1],[3,5,1]] [2,10,10,1,1] 110\n[2,1,1,1,1] [[1,4,1,2],[1,5,1],[2,5,1],[3,5,1]] [1,10,10,1,1] 55\n[2,1,1,1,1] [[1,4,1,1,1],[1,5,1],[2,5,1],[3,5,1]] [1,10,10,1,1] 55\n[1,1,1,2,1] [[1,4,1,1],[1,5,1],[2,5,1],[3,5,1]] [1,10,10,8,1] 440\n[1,1,1,2,1] [[1,4,2],[1,5,1],[2,5,1],[3,5,1]] [1,10,10,18,1] 990\n[1,1,1,1,2] [[1,4,1],[1,5,1,1],[2,5,1],[3,5,1]] [1,10,10,10,1] 550\n[1,1,1,1,2] [[1,4,1],[1,5,2],[2,5,1],[3,5,1]] [1,10,10,10,1] 550\n[1,1,1,1,2] [[1,4,1,1],[1,5,1],[2,5,1],[3,5,1],[4,5,1]] [1,10,10,1,1] 55\n[1,1,1,1,2] [[1,4,2],[1,5,1],[2,5,1],[3,5,1],[4,5,1]] [1,10,10,1,1] 55\n[2,1,1,1,1] [[1,4,1],[1,5,1],[2,4,1],[3,5,1],[4,5,1]] [8,10,10,1,1] 440\n[1,1,1,2,1] [[1,4,1,1],[1,5,1],[2,4,1],[3,5,1],[4,5,1]] [1,10,10,1,1] 100\n[1,1,1,2,1] [[1,4,2],[1,5,1],[2,4,1],[3,5,1],[4,5,1]] [1,10,10,1,1] 100\n[2,1,1,1,1] [[1,4,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [8,1,10,1,1] 80\n[2,1,1,1,1] [[1,4,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [8,1,10,1,1] 80\n[1,1,1,2,1] [[1,4,1,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,2,1] [[1,4,1,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,2,1] [[1,4,2],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,10,2,1] 20\n[1,1,1,1,2] [[1,4,1],[1,5,1,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,1,2] [[1,4,1],[1,5,1,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,1,2] [[1,4,1],[1,5,2],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,1,2] [[1,4,1],[1,5,2],[2,4,2],[2,5,1],[3,5,1]] [1,1,10,1,1] 10\n[1,1,1,2,1] [[1,4,2],[1,5,1],[2,4,2],[2,5,1],[3,4,2],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1],[1,5,1],[2,4,1],[2,5,1,1]] [8,1,10,10,1] 800\n[2,1,1,1,1] [[1,3,1],[1,5,1],[2,4,1],[2,5,2]] [8,1,10,10,1] 800\n[2,1,1,1,1] [[1,3,3],[1,5,1],[2,4,1],[2,5,1,1]] [2,1,1,10,1] 20\n[2,1,1,1,1] [[1,3,3],[1,5,1],[2,4,1],[2,5,2]] [2,1,1,10,1] 20\n[2,1,1,1,1] [[1,3,1,2],[1,5,1],[2,4,1],[2,5,1,1]] [1,1,1,10,1] 10\n[2,1,1,1,1] [[1,3,1,2],[1,5,1],[2,4,1],[2,5,2]] [1,1,1,10,1] 10\n[2,1,1,1,1] [[1,3,1,1,1],[1,5,1],[2,4,1],[2,5,1,1]] [1,1,1,10,1] 10\n[2,1,1,1,1] [[1,3,1,1,1],[1,5,1],[2,4,1],[2,5,2]] [1,1,1,10,1] 10\n[1,1,2,1,1] [[1,3,1,1],[1,5,1],[2,4,1],[2,5,1,1]] [1,1,8,10,1] 80\n[1,1,2,1,1] [[1,3,1,1],[1,5,1],[2,4,1],[2,5,2]] [1,1,8,10,1] 80\n[1,1,2,1,1] [[1,3,2],[1,5,1],[2,4,1],[2,5,1,1]] [1,1,18,10,1] 180\n[1,1,2,1,1] [[1,3,2],[1,5,1],[2,4,1],[2,5,2]] [1,1,18,10,1] 180\n[1,1,1,1,2] [[1,3,1],[1,5,1,1],[2,4,1],[2,5,1,1]] [1,1,10,10,1] 55\n[1,1,1,1,2] [[1,3,1],[1,5,1,1],[2,4,1],[2,5,2]] [1,1,10,10,1] 100
[1,1,1,1,2] [[1,3,1],[1,5,2],[2,4,1],[2,5,2]] [1,1,10,10,2] 110\n[1,2,1,1,1] [[1,3,1,1],[1,5,1],[2,4,1],[2,5,1],[3,5,1]] [1,8,1,10,1] 80\n[1,2,1,1,1] [[1,3,1,1],[1,5,1],[2,4,3],[2,5,1],[3,5,1]] [1,2,1,1,1] 2\n[1,2,1,1,1] [[1,3,1,1],[1,5,1],[2,4,1,2],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,2,1,1,1] [[1,3,1,1],[1,5,1],[2,4,1,1,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,2,1,1,1] [[1,3,2],[1,5,1],[2,4,1],[2,5,1],[3,5,1]] [1,8,1,10,1] 80\n[1,2,1,1,1] [[1,3,2],[1,5,1],[2,4,3],[2,5,1],[3,5,1]] [1,2,1,1,1] 2\n[1,2,1,1,1] [[1,3,2],[1,5,1],[2,4,1,2],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,2,1,1,1] [[1,3,2],[1,5,1],[2,4,1,1,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,1,1,2,1] [[1,3,1,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,1,8,1] 8\n[1,1,1,2,1] [[1,3,1,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,1,18,1] 18\n[1,1,1,2,1] [[1,3,2],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,1,8,1] 8\n[1,1,1,2,1] [[1,3,2],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,1,18,1] 18\n[1,1,1,1,2] [[1,3,1],[1,5,2],[2,4,1],[2,5,2],[3,5,2]] [1,1,1,10,1] 10\n[1,1,1,1,2] [[1,3,1,1],[1,5,1],[2,4,1],[2,5,1,1],[3,5,1]] [1,1,1,10,1] 10\n[1,1,1,1,2] [[1,3,1,1],[1,5,1],[2,4,1],[2,5,2],[3,5,1]] [1,1,1,10,1] 10\n[1,1,1,1,2] [[1,3,2],[1,5,1],[2,4,1],[2,5,1,1],[3,5,1]] [1,1,1,10,1] 10\n[1,1,1,1,2] [[1,3,2],[1,5,1],[2,4,1],[2,5,2],[3,5,1]] [1,1,1,10,1] 10\n[1,1,1,1,2] [[1,3,1,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1],[4,5,1]] [1,1,1,1,1] 1\n[1,1,1,1,2] [[1,3,1,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1],[4,5,1]] [1,1,1,1,1] 1\n[1,1,1,1,2] [[1,3,2],[1,5,1],[2,4,2],[2,5,1],[3,5,1],[4,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1],[1,4,2],[1,5,1],[2,5,1],[3,4,1],[3,5,1]] [1,10,1,1,1] 10\n[2,1,1,1,1] [[1,3,1],[1,4,1,1],[1,5,1],[2,5,1],[3,4,1],[3,5,1]] [1,10,1,1,1] 10\n[1,1,1,2,1] [[1,3,1],[1,4,1],[1,5,1],[2,5,1],[3,4,1],[3,5,1]] [1,10,1,8,1] 80\n[1,1,1,1,2] [[1,3,1],[1,4,1],[1,5,1],[2,5,1],[3,4,1],[3,5,1],[4,5,1]] [1,10,1,1,1] 10\n[2,1,1,1,1] [[1,3,1],[1,4,1],[2,4,1,1],[2,5,1],[3,5,1,1]] [8,1,1,1,1] 8\n[2,1,1,1,1] [[1,3,1],[1,4,1],[2,4,1,1],[2,5,1],[3,5,2]] [8,1,1,1,1] 8\n[2,1,1,1,1] [[1,3,1],[1,4,1],[2,4,2],[2,5,1],[3,5,2]] [8,1,1,1,1] 8\n[2,1,1,1,1] [[1,3,1,1],[1,4,2],[2,4,1],[2,5,1,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1,1],[1,4,2],[2,4,1],[2,5,2],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1,1],[1,4,1,1],[2,4,1],[2,5,1,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1,1],[1,4,1,1],[2,4,1],[2,5,2],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,2],[1,4,2],[2,4,1],[2,5,1,1],[3,5,1]] [2,1,1,1,1] 2\n[2,1,1,1,1] [[1,3,2],[1,4,2],[2,4,1],[2,5,2],[3,5,1]] [2,1,1,1,1] 2\n[2,1,1,1,1] [[1,3,1,1],[1,4,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1,1],[1,4,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,2],[1,4,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,2],[1,4,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,1,2,1,1] [[1,3,1],[1,4,1],[1,5,1],[2,4,1,1],[2,5,1],[3,5,1]] [1,1,8,1,1] 8\n[1,1,2,1,1] [[1,3,1],[1,4,1],[1,5,1],[2,4,2],[2,5,1],[3,5,1]] [1,1,8,1,1] 8\n[2,1,1,1,1] [[1,3,1],[1,4,2],[1,5,1],[2,3,1],[2,4,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[2,1,1,1,1] [[1,3,1],[1,4,1,1],[1,5,1],[2,3,1],[2,4,1],[2,5,1],[3,5,1]] [1,1,1,1,1] 1\n[1,1,1,2,1] [[1,3,1],[1,4,1],[1,5,1],[2,3,1],[2,4,1],[2,5,1],[3,5,1]] [1,1,1,8,1] 8\n[1,1,1,1,2] [[1,3,1],[1,4,1],[1,5,1],[2,3,1],[2,4,1],[2,5,1],[3,5,1],[4,5,1]] [1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,5,1],[2,5,1],[3,6,1],[4,6,1],[5,6,1]] [10,10,10,10,1,1] 1540\n[1,1,1,1,1,1] [[1,5,1,1],[1,6,1],[2,5,1],[3,6,1],[4,6,1]] [1,10,10,10,1,1] 550\n[1,1,1,1,1,1] [[1,5,2],[1,6,1],[2,5,1],[3,6,1],[4,6,1]] [1,10,10,10,1,1] 550\n[1,1,1,1,1,1] [[1,4,1,1],[1,6,1],[2,5,1],[3,5,1],[4,6,1],[5,6,1]] [1,10,10,1,1,1] 55\n[1,1,1,1,1,1] [[1,4,2],[1,6,1],[2,5,1],[3,5,1],[4,6,1],[5,6,1]] [1,10,10,1,1,1] 55\n[1,1,1,1,1,1] [[1,4,1],[1,6,1,1],[2,5,1,1],[2,6,1],[3,5,1]] [1,1,10,10,1,1] 55\n[1,1,1,1,1,1] [[1,4,1],[1,6,1,1],[2,5,2],[2,6,1],[3,5,1]] [1,1,10,10,1,1] 100\n[1,1,1,1,1,1] [[1,4,1],[1,6,2],[2,5,2],[2,6,1],[3,5,1]] [1,1,10,10,1,1] 55\n[1,1,1,1,1,1] [[1,4,1,1],[1,6,1],[2,5,1,1],[2,6,1],[3,5,1],[4,6,1]] [1,1,10,1,1,1] 10
[1,1,1,1,1,1] [[1,4,1,1],[1,6,1],[2,5,2],[2,6,1],[3,5,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,2],[1,6,1],[2,5,1,1],[2,6,1],[3,5,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,2],[1,6,1],[2,5,2],[2,6,1],[3,5,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1,1],[1,5,1],[2,5,1,1],[2,6,1],[3,6,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1,1],[1,5,1],[2,5,2],[2,6,1],[3,6,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,2],[1,5,1],[2,5,2],[2,6,1],[3,6,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,5,1],[3,6,1],[5,6,1]] [1,10,10,10,1,1] 220\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,5,1,1],[2,6,1],[3,6,1]] [1,1,10,10,1,1] 55\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,5,2],[2,6,1],[3,6,1]] [1,1,10,10,1,1] 55\n[1,1,1,1,1,1] [[1,4,1],[1,5,1,1],[2,4,1,1],[2,6,1],[3,5,1],[3,6,1,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1,1],[2,4,1,1],[2,6,1],[3,5,1],[3,6,2]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1,1],[2,4,2],[2,6,1],[3,5,1],[3,6,2]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,2],[2,4,2],[2,6,1],[3,5,1],[3,6,2]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1],[3,5,1],[4,6,1],[5,6,1]] [1,10,10,1,1,1] 55\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1],[3,5,1,1],[3,6,1],[4,6,1]] [1,10,1,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1],[3,5,2],[3,6,1],[4,6,1]] [1,10,1,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1,1],[2,6,1],[3,5,1,1],[3,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1,1],[2,6,1],[3,5,2],[3,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,2],[2,6,1],[3,5,2],[3,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1],[2,5,1],[2,6,1],[3,5,1],[4,6,1]] [1,1,10,1,1,1] 10\n[1,1,1,1,1,1] [[1,4,1],[1,5,1],[1,6,1],[2,4,1],[2,5,1],[2,6,1],[3,4,1],[3,5,1],[3,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,5,1],[1,6,1],[2,4,1,1],[2,6,1],[3,5,1,1],[4,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,5,1],[1,6,1],[2,4,1,1],[2,6,1],[3,5,2],[4,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,5,1],[1,6,1],[2,4,2],[2,6,1],[3,5,2],[4,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,4,1],[1,6,1],[2,4,1],[2,5,1],[2,6,1],[3,5,1,1],[4,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,4,1],[1,6,1],[2,4,1],[2,5,1],[2,6,1],[3,5,2],[4,6,1]] [1,1,1,1,1,1] 1\n[1,1,1,1,1,1] [[1,3,1],[1,4,1],[1,5,1],[2,4,1],[2,5,1],[2,6,1],[3,5,1],[3,6,1],[4,6,1]] [1,1,1,1,1,1] 1\n`;


function Shapes(genus) {
  /*
  Returns all shapes {shape:..., count:...} in a given genus g=2, 3 or 4
  */

  var data;
  
  if (genus <= 0) {
    throw new Error("Shapes: expected genus >= 2");
  } else if (genus === 1) {
    throw new Error("Shapes: infinitely many reduction types in genus 1"); 
  } else if (genus === 2) {
    data = Shapes2Txt;
  } else if (genus === 3) {
    data = Shapes3Txt;
  } else if (genus === 4) {
    data = Shapes4Txt;
  } else if (genus > 4) {
    throw new Error("Shapes: genus>4 is not stored in the library yet");
  }

  const shapesList = [];

  const lines = data.split("\n");
  for (const line of lines) {
    if (line.length === 0 || !line.startsWith("[")) { // Skip lines that are not valid shape descriptions
      continue;
    }
    const d = line.split(" ");
    const V = eval(d[0]);     // Vertex/chi list
    const E = eval(d[1]);     // Edge list
    const count = eval(d[3]); // Reduction types count
    shapesList.push({ shape: new Shape(V, E), count }); // Append the shape to the result
  }

  return shapesList;
}


function UniqueShapeCompType(chi, weights) {  //
  /*
  Returns the unique principal type corresponding to the given chi and weights.
  Raises an error if no unique type is found.
  */
  const L = PrincipalTypes(chi, weights);
  if (L.length !== 1) {
    throw new Error(`UniqueShapeCompType: Principal with chi=${chi} weights=${weights} type is not unique: L = ${L}`);
  }
  return L[0];
}

function NumTypesWithGivenShapeComp(chi, weights) {   //
  /*
  Returns the number of principal types corresponding to the given chi and weights.
  */
  return PrincipalTypes(chi, weights).length;
}

function TeXShapeVertex(chi, weights, complabel = "default") {   //
  /*
  Returns the TeX label for the shape component.
  */

  if (typeof complabel !== 'string') {          // Check if complabel is a function and call it if so
    if (typeof complabel === 'function') {
      complabel = complabel(chi, weights);        // Call the function with chi and weights
    } else {
      throw new Error("complabel is not 'default' or a string or a function(chi, weights)->string");
    }
  }
  if (complabel === "default") {                 // If complabel is default, calculate the label
    const N = NumTypesWithGivenShapeComp(chi, weights);
    if (N === 1) {
      return UniqueShapeCompType(chi, weights).Label({ tex: true, wrap: true });
    } else {
      var weightsstr = weights.length>0 ? weights.join(",") : "\\emptyset"
      return `${-chi}^{\\scriptscriptstyle ${weightsstr}}_{(${N})}`;
    }
  } else {
    return complabel;                            // else return the provided complabel
  }
}

function TeXShapeVertexRedShape(S, v, complabel = "default") {    //
  /*
  Returns the TeX label for the shape component of a RedShape.
  */
  return TeXShapeVertex(S.Chi(v), S.Weights(v), complabel);
}

function TeXRedShape(S, options = {}) {     //
  /*
  Tikz a shape of a reduction graph, and a bounding box x1, y1, x2, y2.
  */

  const {
    scale = 1.5,
    center = false,
    shapelabel = "",
    complabel = "default"
  } = options;

  const PR = (v) => PrintReal(v, 2); // Printing reals with at most two digits after the comma

  let [x, y] = StandardGraphCoordinates(S.G);
  const vdist = Math.max(...y) - Math.min(...y);
  if (vdist > 1.3) {
    y = y.map(a => (a * 1.3) / vdist); // Scale y-coordinates
  }

  const basey = (Math.max(...y) + Math.min(...y)) / 2;

  // Constructing output for vertices
  let out = S.Vertices().map((v, i) => {
    return `\\node[inner sep=2pt] at (${PR(x[i])},${PR(y[i])}) (${i + 1}) {$${TeXShapeVertexRedShape(S, v, complabel)}$};`;
  });

  for (const e of S.EdgeLabels()) {
    const [i1, i2] = e;
    const E  = e.slice(2);
    const showLabel = !(E.length === 1 && E[0] === 1);
    const label = showLabel ? `node[gcd] {${E.join(",")}} ` : "";
    out.push(`\\draw[thick] (${i1}) to ${label}(${i2});`);
  }
  
  const baseline = center ? `baseline=${PR(basey)},` : "";
  let labelstr = shapelabel !== "" 
    ? `\\node at (${PR((Math.min(...x) + Math.max(...x)) / 2)},${PR(basey - 1)}) {${shapelabel}};\n` 
    : "";
  
  const x1 = Math.min(...x) - 0.3;
  const y1 = basey - (shapelabel === "" ? 0 : 1) - 0.3;
  const x2 = Math.max(...x) + 0.3;
  const y2 = Math.max(...y) + 0.5;
  
  labelstr += `\\useasboundingbox (${PR(x1)},${PR(y1)}) rectangle (${PR(x2)},${PR(y2)});\n`;

  // Constructing the final TikZ output
  out = `\\begin{tikzpicture}[scale=${PR(scale)},${baseline}gcd/.style={auto,scale=0.6}]\n${out.join('\n')}\n${labelstr}\\end{tikzpicture}`;

  return [out, x1, y1, x2, y2];
}

/*
function FindMinimalLabel(labels) {   //
  return labels.reduce((min, label) => {
    if (min === undefined || label < min) {
      return label;
    }
    return min;
  }, undefined);
}
*/


/// Dual graphs (GrphDual)


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

This section provides a class (\textbf{GrphDual}) for representing dual graphs and their
manupulation and invariants.
*/


/// Default construction




function DualGraph(m, g, edges, comptexnames = "default") {
  /*
  Parameters:
  m: List of multiplicities for each provided component
  g: List of genera for each provided component
  edges: List of edges in the form 
    [i,j]           - intersection point between component #i and component #j (1<=i,j<=n)
    [i,0,d1,d2,...] - outer chain from component #i (1<=i<=n)
    [i,j,d1,d2,...] - inner chain from component #i to component #j (1<=i,j<=n)
  comptexnames (optional): 'default', function to name components, or a list of names for components.
  */
  
  // Check m and g
  if (!Array.isArray(m) || !m.every(x => Number.isInteger(x) && x > 0)) {
    throw new Error("m must be a list of positive integers");
  }
  if (!Array.isArray(g) || !g.every(x => Number.isInteger(x) && x >= 0)) {
    throw new Error("g must be a list of non-negative integers");
  }
  if (m.length !== g.length) {
    throw new Error("m and g must be of the same length");
  }

  // Process comptexnames
  if (typeof comptexnames === 'string') {
    if (comptexnames === "default") {
      comptexnames = Array.from({length: m.length}, (_, i) => `${i + 1}`);  // Default names 1, 2, ...
    } else {
      throw new Error(`comptexnames='${comptexnames}' is not valid. Use 'default' or a list of names.`);
    }
  } else if (typeof comptexnames === 'function') {
    comptexnames = Array.from({length: m.length}, (_, i) => comptexnames(i + 1));
  } else if (Array.isArray(comptexnames)) {
    if (comptexnames.length !== m.length) {
      throw new Error("comptexnames must have the same length as m.");
    }
  } else {
    throw new Error("comptexnames must be 'default', a list of names, or a function");
  }

  // Create empty graph and initialise the resulting dual graph D
  let D = new GrphDual(); 

  // Add components (vertices) -> V
  for (let i = 0; i < m.length; i++) {
    D.AddComponent(`${i + 1}`, g[i], m[i], comptexnames[i]);
  }
  let V = D.Components();

  // Add edges or chains
  for (let e of edges) {
    if (e.length < 2 || !e.every(x => Number.isInteger(x) && x >= 0)) {
      throw new Error(`Edge ${e} is not valid. It must be of the form [v1,v2], [v1,0,d1,...], or [v1,v2,d1,...].`);
    }

    if (e[0] < 1 || e[0] > m.length || e[1] < 0 || (e[1] > m.length && e[1] !== 0)) {
      throw new Error(`Invalid edge ${e}: component indices must be in the range 1..${m.length}.`);
    }

    if (e.length === 2) {  // Two components meeting at a point
      D.AddEdge(V[e[0] - 1], V[e[1] - 1]);
    } else if (e[1] === 0) {  // Outer chain
      D.AddChain(V[e[0] - 1], null, e.slice(2));  // Outer chain: no second vertex
    } else {  // Inner chain
      D.AddChain(V[e[0] - 1], V[e[1] - 1], e.slice(2));  // Inner chain between two vertices
    }
  }

  return D;
}



/*
Example Constructing a dual graph
let m  = [3,1,1,1,3];                             // multiplicities of c1,c2,c3,c4,c5
let g  = [0,0,0,0,0];                             // genera of c1,c2,c3,c4,c5
let E  = [[1,2],[1,3],[1,4],[2,5],[3,5],[4,5]];   // edges c1-c2,...
const G1 = DualGraph(m,g,E);
console.log(G1.toString());
m = [3,3];             // Principal components and chains (same graph)
g = [0,0];
E = [[1,2,1],[1,2,1],[1,2,1]];
const G2 = DualGraph(m,g,E);
console.log(G2.toString());
m = [3,3];
g = [0,0];             // Principal components, different chains 
E = [[1,2,1],[1,2,1,1],[1,2,1,1,1,1]];
const G3 = DualGraph(m,g,E);
console.log(G3.toString());
// This is what the three special fibres look like (with component names in blue):\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {3} node[facel] {5}; \draw[l1] (0,0.66)--(2.26,0.66) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \end{tikzpicture}\qquad\begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.26,0) node[mainl] {3} node[facel] {2}; \draw[l1] (0,0.66)--(2.26,0.66) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \end{tikzpicture}\qquad\begin{tikzpicture}[xscale=0.8,yscale=0.7, belowleftl/.style={below left=-4.5pt,lfnt}, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, belowrightl/.style={below right=-4.5pt,lfnt}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0,0)--(3.6,0) node[mainl] {3} node[facel] {2}; \draw[l1] (0,2)--(2.93,2) node[mainl] {3} node[facel] {1}; \draw[l2] (0,0)--node[rightl] {1} (0,2); \draw[l2] (1.46,0)--node[rightl] {1} (1.46,0.66); \draw[l2] (0.8,0.66)--node[abovel] {1} (1.46,0.66); \draw[l2] (0.8,0.66)--node[leftl] {1} (0.8,1.33); \draw[l2] (0.8,1.33)--node[belowrightl] {1} (1.46,2); \draw[l2] (2.93,0)--node[rightl] {1} (2.93,1); \draw[l2] (2.93,1)--node[belowleftl] {1} (2.26,2); \end{tikzpicture}
*/

/*
Example Printing dual graph as a string and reconstructing it
const R = ReductionType("1g1-1g2-1g3-c1");
const G = R.DualGraph();        // Triangular dual graph on 3 vertices and 3 edges
console.log(G.toString());
const G2 = eval(G.toString());   // and reconstructed back
console.log(G2.toString());
*/


/// Step by step construction


class GrphDual {
  constructor() {
    /*
    Initialize an empty dual graph
    */
    this.G = new Graph(); 
    this.pts     = [];            // non-singular points
    this.singpts = [];            // singular points
    this.specialchains = [];      // chains of variable length and singular chains 
  }

  AddComponent(name, genus, multiplicity, texname = null) {
    /*
    Adds a component (vertex) to the graph with attributes m, g, and optional texname. 
    Returns name of the added component (which is given by name if <>None, <>"")
    */
    if (!name) {
      name = `c${this.G.Vertices().length + 1}`;
    }
    if (this.G.HasVertex(name)) {
      throw new Error(`Vertex ${name} already exists`);
    }
    if (texname === null || texname === "default") {
      texname = name;
    }
    this.G.AddVertex(name, { g: genus, m: multiplicity, texname: texname });
    return name;
  }

  AddEdge(node1, node2) {
    /*
    Adds an edge between two components (vertices) in the graph.
    */
    this.G.AddEdge(node1, node2);
  }

  AddChain(c1, c2, mults) {
    /*
    Adds a chain of P1s with multiplicities between c1 and c2. Adds as many vertices as 
    there are multiplicities in 'mults', and links them in a chain starting at c1 and 
    ending at c2 (if c2 is provided, else it's an outer chain).
    */
    if (!this.G.HasVertex(c1)) {
      throw new Error(`Component ${c1} does not exist in the graph.`);
    }
    if (c2 && !this.G.HasVertex(c2)) {
      throw new Error(`Component ${c2} does not exist in the graph.`);
    }

    let cold = c1; // Create intermediate vertices and chain
    for (let i = 0; i < mults.length; i++) {
      const mult = mults[i];
      const cnew = this.AddComponent("", 0, mult);
      this.AddEdge(cold, cnew);
      cold = cnew;  
    }
    if (c2) {
      this.AddEdge(cold, c2);
    }
  }


  /*
  Example Type $\rm II^*$ reduction
  // This is how we can construct the dual graph of the type $\rm II^*$ elliptic curve,
  // creating some components and edges by hand, and adding the rest as outer chains.\par
  // \begin{center}
  // \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {6} node[facel] {A}; \draw[l2] (0.66,0)--node[rightl] {5} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {4} (0.66,0.66); \draw[l2] (0,0.66)--node[leftl] {3} (0,1.33); \draw[l2] (0,1.33)--node[abovel] {2} (0.66,1.33); \draw[l2end] (0.66,1.33)--node[rightl] {1} (0.66,2); \draw[l2end] (1.46,0)--node[rightl] {3} (1.46,0.66); \draw[l2] (2.93,0)--node[rightl] {4} (2.93,0.66); \draw[l2] (2.26,0.66)--node[abovel] {2} (2.93,0.66); \end{tikzpicture}
  // \end{center}
  var G = new GrphDual();
  var c1 = G.AddComponent("A", 0, 6);   // Called 'A', multiplicity 6
  var c2 = G.AddComponent("", 0, 3);    // default name ('c2')
  G.AddEdge(c1, c2);                    // Link the two (shortest chain)
  G.AddChain(c1, null, [4, 2]);         // The other two chains
  G.AddChain(c1, null, [5, 4, 3, 2, 1]);
  console.log(G.Components());
  console.log(G.ReductionType().Label());
  */

  
  /// Global methods and arithmetic invariants
  

  Graph() {
    /*
    Returns the underlying graph.
    */
    return this.G;
  }

  Components() {
    /*
    Returns the list of vertices of the underlying graph.
    */
    return this.G.Vertices();
  }

  Edges() {    //
    /*
    Returns the sorted list of edges with vertex indices of the underlying graph.
    */
    const components = this.Components();
    return this.G.Edges()
      .map(e => [
        components.indexOf(e[0])+1,
        components.indexOf(e[1])+1 
      ])
      .sort((a, b) => a[0] - b[0] || a[1] - b[1]);  // Sort the edges by indices
  }

  IsConnected() {
    /*
    Check that the dual graph is connected
    */
    return this.G.ConnectedComponents().length === 1;
  }

  HasIntegralSelfIntersections() {
    /*
    Are all component self-intersections integers
    */
    return this.Components().every(v => Number.isInteger(this.Intersection(v, v)));
  }

  AbelianDimension() {
    /*
    Sum of genera of components
    */
    return this.Components().reduce((sum, c) => sum + this.Genus(c), 0);
  }

  ToricDimension() {
    /*
    Number of loops in the dual graph
    */
    if (!this.IsConnected()) {
      throw new Error("Dual graph appears to be disconnected");
    }
    return this.Edges().length - this.Components().length + 1;
  }

  IntersectionMatrix() {
    /*
    Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components.
    */
    const C = this.Components();
    return C.map(w => C.map(v => this.Intersection(v, w)));
  }
  
  getItem(i) {    //
    /*
    Return ith vertex (1 <= i<= #vertices).
    */
    if (Number.isInteger(i)) {
      if (!this.Components().includes(i)) {
        throw new Error(`GrphDual.getitem: Node ${i} does not exist in the graph.`);
      }
      return { m: this.Multiplicity(i), g: this.Genus(i) };
    } else {
      throw new TypeError(`GrphDual.getitem: Invalid index type ${typeof i} of ${i} (expected int)`);
    }
  }

  /*
  Example
  // Here is the dual graph of the reduction type 
  // \redtype{1_{g3}\e1_{g2}\e1_{g1}\e c_1}, consisting of 
  // three components genus 1,2,3, all of multiplicity 1, connected in a triangle.
  var G = DualGraph([1,1,1],[1,2,3],[[1,2],[2,3],[3,1]]);  
  console.assert(G.IsConnected());                     // Check the dual graph is connected
  console.assert(G.HasIntegralSelfIntersections());    //   and every component c has c.c in Z
  console.log(G.AbelianDimension());                // genera 1+2+3 => 6
  console.log(G.ToricDimension());                  // 1 loop       => 1
  console.log(G.ReductionType().TeX());
  console.log(G.IntersectionMatrix());              // Intersection(G,v,w) for v,w components
  */

  PrincipalComponents() {
    /*
    Return a list of indices of principal components.

    A vertex is a principal component if either its genus is greater than 0
    or it has 3 or more incident edges (counting loops twice).
    In the exceptional case [d]I_n one component is declared principal.
    */
    let P = this.Components().filter(v => 
      this.Genus(v) > 0 || this.Neighbours(v).length >= 3
    );
    if (P.length==0) {
      P=[this.Components()[0]];     // multiple of I_n -> declare one component to be principal
    }
    return P;
  }

  ChainsOfP1s() {
    /*
    Returns a sequence of tuples [<v0,v1,[chain multiplicities]>] for chains of P1s between principal components, and v1=None for outer chains
    */
    const P = this.PrincipalComponents();
    const Pv = new Set(P);
    let E = this.Graph().Edges();
    const chains = [];

    while (E.length > 0) {
      let e = E.find(e => Pv.has(e[0]) || Pv.has(e[1]));
      if (!e) break;

      let v0 = Pv.has(e[0]) ? e[0] : e[1];
      const path = [];
      const startv = v0;
      let endv = null;

      while (true) {
        e = E.find(edge => edge.includes(v0));
        const v1 = e[0] === v0 ? e[1] : e[0];
        E = E.filter(edge => edge !== e);

        if (Pv.has(v1)) {
          endv = v1;
          break;
        }

        path.push(this.Multiplicity(v1));
        const ee = this.Graph().Neighbours(v1);
        if (ee.length === 1) {
          break;  // Dead end, no more edges to follow
        }

        e = ee[0] === e ? ee[1] : ee[0];
        v0 = v1;
      }

      if (chains.some(c => c[0] === endv && c[1] === startv)) {
        chains.push([endv, startv, path.reverse()]);
      } else {
        chains.push([startv, endv, path]);
      }
    }

    return chains;
  }

  ReductionType() {
    /*
    Reduction type from a dual graph
    */
    return ReductionTypeFromDualGraph(this);
  }
  

  /// Contracting components to get a mrnc model


  ContractComponent(c, checks=true) {
    /*
    Contract a component in the dual graph, assuming it meets one or two components, and has genus 0.
    */
    var G = this;

    if (!G.HasComponent(c)) {
      throw new Error(`Vertex ${c} does not exist in the graph.`);
    }
    var N = G.Neighbours(c);

    if (checks) {
      if (G.Genus(c) !== 0) {
        throw new Error("Positive genus component cannot be contracted");
      }
      if (G.Intersection(c, c) !== -1) {
        throw new Error(`Cannot contract component ${c} of self-intersection ${G.Intersection(c, c)}<>-1`);
      }
      if (N.length > 3) {
        throw new Error("Component that meets the special fibre in >2 points cannot be contracted");
      }
      if (G.Components().length === 1) {
        throw new Error("Cannot contract last remaining component");
      }
    }

    if (N.length === 2) {
      G.G.AddEdge(N[0], N[1]);
    }

    G.G.RemoveVertex(c);
  }
 
  MakeMRNC() {
    /*
    Repeatedly contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal crossings.
    */
    var G = this;
    G.Check();
    var again = true;
    while (again) {
      again = false;
      if (G.Components().length === 1) {
        return;
      }
      for (var c of G.Components()) {
        if (G.Genus(c) === 0 && G.Neighbours(c).length <= 2 && G.Intersection(c, c) === -1) {
          G.ContractComponent(c, { checks: false });
          again = true;
          break;
        }
      }
    }
  }


  Check() {
    /*
    Check that the graph is connected and self-intersections are integers.
    */

    // Check if the graph is connected
    if (!this.IsConnected()) {
      throw new Error("The graph is not connected");
    }

    // Check multiplicities and genera
    for (const v of this.Components()) {
      const multiplicity = this.Multiplicity(v);
      const genus = this.Genus(v);
      if (!Number.isInteger(multiplicity) || multiplicity <= 0) {
        throw new Error(`Node ${v} has an invalid multiplicity: ${multiplicity}`);
      }
      if (!Number.isInteger(genus) || genus < 0) {
        throw new Error(`Node ${v} has an invalid genus: ${genus}`);
      }
    }

    // Check self-intersections for every node
    for (const v of this.Components()) {
      const self_intersection = this.Intersection(v,v);
      if (!Number.isInteger(self_intersection)) {
        throw new Error(`Self-intersection for node ${v} is not an integer`);
      }
    }
  }

  
  /*
  Example Contracting components
  let G = DualGraph([1,1],[1,0],[[1,2,1,1,1]]);  // Not a minimal rnc model
  console.log(G.Components(), G.Components().map(v => G.Intersection(v,v)));
  G.ContractComponent("2");   // Remove the last component
  G.ContractComponent("c5");  //   and then the one before that
  console.log(G.Components());
  console.log(G.toString());
  G.MakeMRNC();               // Contract the rest of the chain
  console.log(G.Components());
  console.log(G.toString());
  console.log(G.ReductionType().Label());   // Associated reduction type
  */


  /// Invariants of individual vertices

  
  HasComponent(c) {
    /*
    Test whether the graph has a component named c
    */
    return this.Components().includes(c);  
  }  

  Multiplicity(v) {
    /*
    Multiplicity m of the vertex
    */
    return this.G.GetLabel(v).m;
  }

  Multiplicities() {
    /*
    Returns the list of multiplicities of all the vertices.
    */
    return this.Components().map(v => this.Multiplicity(v));
  }

  Genus(v) {
    /*
    Genus g of the vertex
    */
    return this.G.GetLabel(v).g;
  }

  Genera() {
    /*
    Returns the list of geometric genera of all the vertices.
    */
    return this.Components().map(v => this.Genus(v));
  }

  Neighbours(i) {
    /*
    List of incident vertices, with each loop contributing the vertex itself twice
    */
    return this.Graph().Neighbours(i);
  }

  Intersection(c1, c2) {
    /*
    Compute the intersection number between components c1 and c2 (or self-intersection if c1=c2).
    */
    if (c1 === c2) {            // self-intersection
      const m = this.Multiplicity(c1);
      const N = this.Neighbours(c1).filter(v => v !== c1);
      const O = N.map(v => this.Multiplicity(v));
      if (O.reduce((a, b) => a + b, 0) % m) {
        return -O.reduce((a, b) => a + b, 0) / m;             // non-integral
      } else {
        return -Math.round(O.reduce((a, b) => a + b, 0) / m);        // integral
      }
    } else {                 // intersection of two distinct components ( = #points of intersection)
      return this.Neighbours(c1).filter(v => v === c2).length;
    }
  }

  toString() {  //
    /*
    Print a dual graph in the form that can be evaluated DualGraph(...)
    */
    let mstr = JSON.stringify(this.Multiplicities()).replace(/\s/g,"");
    let gstr = JSON.stringify(this.Genera()).replace(/\s/g,"");
    let Estr = JSON.stringify(this.Edges()).replace(/\s/g,"");
    return `DualGraph(${mstr}, ${gstr}, ${Estr})`;
  }

  TeXName(v) {
    /*
    TeXName assigned to a vertex v
    */
    return this.G.GetLabel(v).texname;
  }

}


/*
Example Cycle of 5 components
let G = DualGraph([1], [1], [[1,1,1,1,1,1]]);
let C = G.Components();
console.log(C);
console.assert(G.HasComponent("c2"));
console.log(G.Multiplicity("c2"));
console.log(G.Genus("c2"));
for (let row of C.map(w => C.map(v => G.Intersection(v, w)))) {console.log(row.join(" "));} //> console.log(G.IntersectionMatrix());
*/


/*
# Example Dual graph and its invariants
// We construct the following dual graph with five components of multiplicities 3,1,1,1,3, all of genus 0:
// $$\begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}] \draw[l1] (0,0)--(2.26,0) node[mainl] {3}; \draw[l1] (0,0.66)--(2.26,0.66) node[mainl] {3}; \draw[l2] (0,0)--node[rightl] {1} (0,0.66); \draw[l2] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l2] (1.6,0)--node[rightl] {1} (1.6,0.66); \end{tikzpicture}$$
const m = [3,1,1,1,3];                             // multiplicities of c1,c2,c3,c4,c5
const g = [0,0,0,0,0];                             // genera of c1,c2,c3,c4,c5
const E = [[1,2],[1,3],[1,4],[2,5],[3,5],[4,5]];   // edges c1-c2,...
const G = DualGraph(m,g,E);
console.log(G.toString());
console.log(G.Multiplicities());   // recovers m
console.log(G.Genera());           // recovers g
console.log(G.Edges());            // recovers E
G.MakeMRNC();                // blow down until minimal regular with normal crossings
console.log(G.ReductionType().Label());   // Associated reduction type label
*/


/*
Test Pre-defined Shapes for g=2,3,4
Assert(Shapes(2).length==5);
Assert(Shapes(3).length==35);
Assert(Shapes(4).length==310);
*/


/// Reduction types (RedType)


/*
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
*/


function ReductionTypeFrommgOL(m, g, O, L) {   //
  /*
  Construct a reduction type from a sequence of components, their invariants, and chains of P1s:
    m = sequence of multiplicities of components c_1,...,c_k
    g = sequence of their geometric genera
    O = outgoing multiplicities of outer chains, one sequence for each component
    L = inner chains, of the form
        [[i,j,di,dj,n],...] - inner chain from c_i to c_j with multiplicities m[i],di,...,dj,m[j], of depth n
        n can be omitted, and chain data [i,j,di,dj] is interpreted as having minimal possible depth.
  */

  if (m.length !== g.length || m.length !== O.length) {
    throw new Error("Sequences of genera, multiplicities, and of outer multiplicities must have the same length equal to the number of components");
  }
  
  if (O.some(d => d.length > 0 && !d.every(x => Number.isInteger(x))) || L.some(d => d.length > 0 && !d.every(x => Number.isInteger(x)))) {
    throw new Error(`ReductionType: ${d}: Expected integers as elements`);
  }
  
  // outer chains
  const E = [].concat(...m.map((_, i) => O[i].map(o => [i + 1, 0].concat(OuterSequence(m[i], o, false)))));
  
  // inner chains
  for (const d of L) {
    if (!([4, 5].includes(d.length) && d[0] >= 1 && d[0] <= m.length && d[1] >= 1 && d[1] <= m.length)) {
      throw new Error(`ReductionType: ${d}: Expected link data [i,j,di,dj] or [i,j,di,dj,n]`);
    }
    const [i, j, di, dj] = d;
    const n = d.length === 5 ? d[4] : MinimalDepth(m[i - 1], di, m[j - 1], dj);
    E.push([i, j].concat(InnerSequence(m[i - 1], di, m[j - 1], dj, n, false)));
  }

  vprint("ReductionTypeFrommgOL: m=", m);
  vprint("ReductionTypeFrommgOL: g=", g);
  vprint("ReductionTypeFrommgOL: E=", E);
  
  // construct dual graph and associated reduction type
  const G = DualGraph(m, g, E);
  vprint("ReductionTypeFrommgOL: G=", G);
  return G.ReductionType();
}


function ReductionType(...args) {
  /*
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
  */
  if (args.length === 1) {
    if (args[0] instanceof GrphDual) {     // Reduction type from a dual graph (GrphDual)
      return ReductionTypeFromDualGraph(args[0]);
    } else if (typeof args[0] === 'string') {        // Reduction type from label (Str)
      return ReductionTypeFromLabel(args[0]);
    } else {
      throw new TypeError("Single argument must be either a GrphDual or a string."); 
    }
  } else if (args.length === 4) {                    // Reduction type from m,g,O,L
    const [m, g, O, L] = args;
    if (Array.isArray(m) && Array.isArray(g) && Array.isArray(O) && Array.isArray(L)) {
      return ReductionTypeFrommgOL(m, g, O, L);
    } else {
      throw new TypeError("Arguments for ReductionTypeFrommgOL must be sequences (array).");
    }
  } else {
    throw new ValueError("Invalid number or types of arguments provided for ReductionType.");
  }
}


/*
Example $\rm II^*$
// We construct Kodaira type \redtype{II*} as a reduction type\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {6} node[facel] {$\Gamma_1$}; \draw[l2] (0.66,0)--node[rightl] {5} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {4} (0.66,0.66); \draw[l2] (0,0.66)--node[leftl] {3} (0,1.33); \draw[l2] (0,1.33)--node[abovel] {2} (0.66,1.33); \draw[l2end] (0.66,1.33)--node[rightl] {1} (0.66,2); \draw[l2end] (1.46,0)--node[rightl] {3} (1.46,0.66); \draw[l2] (2.93,0)--node[rightl] {4} (2.93,0.66); \draw[l2] (2.26,0.66)--node[abovel] {2} (2.93,0.66); \end{tikzpicture}
const m = [6];          // multiplicity of one starting component Gamma_1
const g = [0];          // their geometric genera
const O = [[3, 4, 5]];  // outgoing multiplicities of outer chains from each of them
const L = [];           // inner chains
const R = ReductionType(m, g, O, L);
console.log(R.Label());
console.assert(R.equals(ReductionType("II*")));    // same type from label
*/


/*
Example $\rm I^*_3$
// Similarly, we construct Kodaira type \redtype{I^*_3} as a reduction type\par
// \begin{tikzpicture}[xscale=0.8,yscale=0.7, belowleftl/.style={below left=-4.5pt,lfnt}, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}] \draw[l1] (0,0)--(2.93,0) node[mainl] {2} node[facel] {$\Gamma_1$}; \draw[l2end] (0,0)--node[rightl] {1} (0,0.66); \draw[l2end] (0.8,0)--node[rightl] {1} (0.8,0.66); \draw[l1] (1.6,1.33)--(3.66,1.33) node[mainl] {2} node[facel] {}; \draw[l2] (2.26,0)--node[rightl] {2} (2.26,0.66); \draw[l2] (2.26,0.66)--node[belowleftl] {2} (1.6,1.33); \draw[l2end] (2.2,1.33)--node[rightl] {1} (2.2,2); \draw[l2end] (3,1.33)--node[rightl] {1} (3,2); \end{tikzpicture}
const m = [2, 2];             // multiplicities of starting components Gamma_1, Gamma_2
const g = [0, 0];             // their geometric genera
const O = [[1, 1], [1, 1]];   // outgoing multiplicities of outer chains from each of them
const L = [[1, 2, 2, 2, 3]];  // inner chains [[i,j, di,dj ,optional depth],...]
const R = ReductionType(m, g, O, L);
console.log(R.Label());
console.assert(R.equals(ReductionType("I3*")));    // same type from label
*/

function ReductionTypes(arg, options = {}) {
  /*
  ReductionTypes(arg, { countonly=false, semistable=false, elliptic=false }) 
    - All reduction types in genus g <= 6 or their count (if countonly=true; faster).
    - semistable=true restricts to semistable types.
    - elliptic=true (when g=1) restricts to Kodaira types of elliptic curves.

  ReductionTypes(S, { countonly=false, semistable=false }) 
    - Sequence of reduction types with a given shape S, semistable if necessary.
    - If countonly=true, only return the number of types (faster).

  Returns a sequence of RedType's or an integer if countonly=true.
  */
  if (typeof arg === "number") {
    return ReductionTypesInGenus(arg, options);
  } else if (arg instanceof RedShape) {
    return ReductionTypesWithShape(arg, options); // Implemented later
  } else {
    throw new TypeError(`ReductionTypes: first argument of type ${typeof arg} is neither an integer nor a RedShape`);
  }
}


function ReductionTypesInGenus(g, { semistable = false, countonly = false, elliptic = false } = {}) {     //
  /*
  All reduction types in genus g <= 6 or their count (if countonly=true; faster).
  - semistable=true restricts to semistable types.
  - elliptic=true (when g=1) restricts to Kodaira types of elliptic curves.
  */
  if (g < 1) {
    throw new Error("Genus must be at least 1");
  }
  if (g !== 1 && elliptic) {
    throw new Error("elliptic=true setting can only be used in genus 1");
  }

  if (g === 1) {
    let types;
    if (semistable) {
      types = ["1g1", "I1"];
    } else if (elliptic) {
      types = ["1g1", "I1", "I0*", "I1*", "IV", "IV*", "III", "III*", "II", "II*"];
    } else {
      throw new Error("Infinitely many reduction types in genus 1.");
    }

    return countonly ? types.length : types.map(type => new ReductionType(type)); // Return count or RedType instances
  }

  // Process other genera using shapes
  let R = Shapes(g).map(S => ReductionTypes(S.shape, { semistable, countonly })); // Recursively fetch for shapes
  return countonly ? R.reduce((a, b) => a + b, 0) : R.flat();  // Sum for countonly, or flatten for full list
}


/*
Example Reduction types in a given genus
// Here are all reduction types for elliptic curves (10 Kodaira types), 
// the count for genus 2 (104 Namikawa-Ueno types) and the 
// count for semistable types in genus~3.
console.log(ReductionTypes(1, {elliptic: true}).map(R => R.Label()));
console.log(ReductionTypes(2, {countonly: true}));                  
console.log(ReductionTypes(3, {semistable: true, countonly: true}));
*/


/*
Example Reduction types with a given shape
// There are 1901 reduction types in genus 3, in 35 different shapes. Here is one of the more `exotic' ones, with
// 6 types in it. It has two vertices with $\chi=-3$ and $\chi=-1$ and two edges between them, with gcd 1 and 2.
const S = Shape([3, 1], [[1, 2, 1, 2]]);
console.log(S.TeX());
const L = ReductionTypes(S);
console.log(L.map(R => R.Label()));
console.log(L.map(R => R.TeX({scale: 1.5, forcesups: true})).join("\\qquad"));
*/


class RedType {
  constructor(C = null, L = null, score = null, shape = null, bestscore = null, besttrail = null) {   //
    this.C = C;                      // array of principal types, ordered in label order
    this.L = L;                      // all inner chains, sorted as for label
    this.score = score;            // score used for comparison and sorting
    this.shape = shape;              // shape of R
    this.bestscore = bestscore;    // best score from MinimumScorePaths
    this.besttrail = besttrail;      // best trail from MinimumScorePaths

    // Create a Proxy to intercept array-like access
    return new Proxy(this, {
  get(target, prop) {
    const index = parseInt(prop, 10);
    if (!isNaN(index)) {
      return target.getItem(index); // Use custom getItem method
    }
    return target[prop]; // Default behavior for other properties
  }
    });
  }

  toString() {    //
    /*
    Print a reduction type through its Label.
    */
    return this.Label();
  }

  Chi() {
    /*
    Total Euler characteristic of R
    */
    let total = 0;
    for (const S of this.PrincipalTypes()) total += S.Chi();         // sum over principal types
    return total;
  }

  Genus() {
    /*
    Total genus of R
    */
    return Math.floor((2 - this.Chi()) / 2);
  }


  /*
  Example
  R = new ReductionType("III=(3)III-{2-2}II-{6-12}18g2^6,12");
  console.log(R.Label());      // Canonical label
  console.log(R.Genus());      // Total genus
  */
  

  IsGood() {
    /*
    true if comes from a curve with good reduction
    */
    return this.C.length === 1 && this.C[0].Multiplicity() === 1;
  }

  IsSemistable() {
    /*
    true if comes from a curve with semistable reduction (all (principal) components of an mrnc model have multiplicity 1)
    */
    return Math.max(...this.Multiplicities()) === 1;
  }

  IsSemistableTotallyToric() {
    /*
    true if comes from a curve with semistable totally toric reduction (semistable with no positive genus components)
    */
    return this.IsSemistable() && Math.max(...this.Genera()) === 0;
  }

  IsSemistableTotallyAbelian() {
    /*
    true if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual graph)
    */
    return this.IsSemistable() && this.Genera().reduce((a, b) => a + b, 0) === this.Genus();
  }


  /*
  Example Semistable reduction types
  let semi = ReductionTypes(3, {semistable: true});                 // genus 3, semistable,
  console.log(semi.map(R => R.Label()).join(" "));
  let ab = semi.filter(R => R.IsSemistableTotallyAbelian());  //   totally abelian reduction 
  console.log(PrintSequence(ab.map(R => `\\cbox{$${R.TeX()}$}`), {sep: "\\qquad " })); //> console.log(ab.map(R => R.TeX()));
  let tor = semi.filter(R => R.IsSemistableTotallyToric());
  console.log(`\\begin{minipage}[t]{1.0\\textwidth}` + PrintSequence(tor.map(R => `\\cbox{$${R.TeX()}$}`), {sep: "\\quad "}) + `\\end{minipage}`); //> console.log(tor.map(R => R.TeX()));
  // Count semistable reduction types in genus 2,3,4,... (OEIS A174224)
  console.log([2,3,4].map(n => ReductionTypes(n, {semistable: true, countonly: true})));
  */


  TamagawaNumber() {
    /*
    Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field
    */
    var M = this.DualGraph().IntersectionMatrix();    // Intersection matrix on the dual graph
    var D = DeterminantsOfMinors(M);                  //   has det=0, but we compute GCD of minors
    var F = [].concat(...D);                          // Flatten, compute GCD and return
    return GCD(...F);
  }

  
  /*
  Test
  Assert(ReductionType("III").TamagawaNumber() === 2);
  Assert(ReductionType("III*").TamagawaNumber() === 2);
  Assert(ReductionType("I0*").TamagawaNumber() === 4);
  Assert(ReductionType("I1*").TamagawaNumber() === 4);
  Assert(ReductionType("I7").TamagawaNumber() === 7);
  */  

  
  /*
  Example Tamagawa numbers for reduction types of elliptic curves
  var E = ReductionTypes(1, {elliptic: true});
  for (const R of E) {console.log(R.Label(), R.TamagawaNumber());}
  */
  
  
  /// Invariants of individual principal components and chains

  
  PrincipalTypes() {
    /*
    Principal types (vertices) of the reduction type
    */
    return this.C;
  }

  length() {
    /*
    Number of principal types in a reduction type
    */
    return this.PrincipalTypes().length;
  }

  getItem(i) {
    /*
    Principal type number i in the reduction type, accessed as R[i] (numbered from i=1)
    */
    if (i < 1 || i > this.length()) {
      throw new Error(`Principal type index should be in [1..${this.length()}]`);
    }
    return this.C[i - 1];
  }

  *[Symbol.iterator]() {    //
    /*
    Create an iterator that yields each principal type in R
    */
    for (let i = 1; i <= this.length(); i++) {
      yield this[i];
    }
  }

  InnerChains() {
    /*
    Return all the inner chains in the reduction type
    */
    return this.L;
  }

  EdgeChains() {
    /*
    Return all the inner chains in R between different principal components, sorted as in label.
    */
    return this.InnerChains().filter(e => e.Class === cEdge);
  }

  Multiplicities() {
    /*
    Sequence of multiplicities of principal types
    */
    return this.PrincipalTypes().map(S => S.Multiplicity());
  }

  Genera() {
    /*
    Sequence of geometric genera of principal types
    */
    return this.PrincipalTypes().map(S => S.GeometricGenus());
  }

  GCD() {
    /*
    GCD detecting non-primitive types
    */
    return this.PrincipalTypes().reduce((a, S) => GCD(a, S.GCD()), null);
  }

  Shape() {
    /*
    The shape of the reduction type.
    */
    return this.shape;
  }


  /*
  Example Principal types and chains
  // Take a reduction type that consists of smooth curves of genus 3, 2 and 1, connected
  // with two chains of $\P^1$s of depth 2.
  var R = ReductionType("1g3-(2)1g2-(2)1g1");
  console.log(R.TeX());
  // This is how we access the three principal types, their primary invariants, and the chains.
  // Individual principal types can be accessed as R[i], and all of them as R.PrincipalTypes() 
  console.log(R[1].Label(), R[2].Label(), R[3].Label());
  console.log(R.Genera());         // geometric genus g of each principal type
  console.log(R.Multiplicities()); // multiplicity m of each principal type
  console.log(R.InnerChains().join(", "));     // chains, including loops and D-links
  */
  

  Score() {
    /*
    Score of a reduction type, used for comparison and sorting
    */
    const R = this;
    if (R.hasOwnProperty('score') && R.score !== null) {
      return R.score;
    }
    const label = R.Label({ depths: "original" });

    R.score = [R.length(), R.EdgeChains().length]
      .concat(R.EdgeChains().map(e => e.Weight()).sort((a, b) => a - b))
      .concat(Array.from({ length: R.length() }, (_, i) => R[i + 1].Score()).flat())
      .concat([label.length])
      .concat(Array.from(new TextEncoder().encode(label)));

    return R.score;
  }

  /*
  Example
  R1 = ReductionType("I1g1")
  console.log(R1.Score());
  R2 = ReductionType("Dg1")
  console.log(R2.Score());
  console.log(R1.lessThan(R2));     // I1g1<Dg1 so it precedes it in tables
  */

  equals(other) {
    /*
    Equality comparison based on label.
    */
    if (!(other instanceof RedType)) {
      return false;
    }
    return ArraysEqual(this.Score(),other.Score());
  }
  
  lessThan(other) {
    /*
    Less than comparison based on score.
    */
    if (!(other instanceof RedType)) {
      return false;
    }
    const scoreA = this.Score();
    const scoreB = other.Score();
    for (let i = 0; i < scoreA.length; i++) {
      if (scoreA[i] !== scoreB[i]) {
        return scoreA[i] < scoreB[i];
      }
    }
    return false;
  }
  
  greaterThan(other) {
    /*
    Greater than comparison based on score.
    */
    if (!(other instanceof RedType)) {
      return false;
    }
    return other.lessThan(this);
  }
  
  lessThanOrEqual(other) {
    /*
    Less than or equal to comparison based on score.
    */
    if (!(other instanceof RedType)) {
      return false;
    }
    return this.lessThan(other) || this.equals(other);
  }
  
  greaterThanOrEqual(other) {
    /*
    Greater than or equal to comparison based on score.
    */
    if (!(other instanceof RedType)) {
      return false;
    }
    return this.greaterThan(other) || this.equals(other);
  }
  
  static Sort(seq) {
    /*
    Sort a sequence of RedType objects based on their score.
    */
    seq.sort((a, b) => (a.lessThan(b) ? -1 : a.greaterThan(b) ? 1 : 0));
  }

  /*
  Example Sorted reduction types in genus 1 and 2
  var L = ReductionTypes(1, {elliptic: true});
  RedType.Sort(L);
  console.log(L.map(R => R.Label()).join(", "));
  L = ReductionTypes(2);
  RedType.Sort(L);
  console.log(L.map(R => R.Label()).join(", "));
  */
  
  EdgesScore(i, j) {    //
    /*
    Compute the score associated with edges from the ith to jth component of R.
    Used in the Label when determining the canonical minimal path.

    Parameters:
      i (int): The index of the ith component in R.
      j (int): The index of the jth component in R.

    Returns:
      list of int: The score [di, dj, depth] for edges between components i and j.
    */
    return EdgesScore(this.InnerChains(), this[i], this[j]);
  }
  
  
  /// Reduction types, labels, and dual graphs


  DualGraph({compnames="default"} = {}) {
    /*
    Full dual graph from a reduction type, possibly with variable length edges, 
    and optional names of components.
    Returns: GrphDual - The constructed dual graph.
    */
    return RedPrinListDualGraph(this.C);  // This function needs to be implemented later
  }

  TeXLabel(forcesubs = false, forcesups = false, wrap = true) {     //
    /*
    TeX label of a reduction type used with the \redtype macro
    */
    const R = this;
    const path = R.bestscore;
    const trail = R.besttrail;
  
    let out = "";
    for (let index = 0; index < path.length; index++) {
      const p = path[index];
      const n = p[0];
      const i = trail[index];
      if (n === 0) {                                  // labels for individual components when encounter first
        out += this[i].TeXLabel();
      } else { 
        out += "c" + TeXPrintParameter(n, { sym: "_" });                               // Else print c_n
      }
      if (p[2]) {
        out += (index === path.length - 1) ? "" : "\\&";
      } else {
        const j = trail[index + 1];
        const E = ExtractEdges(R.InnerChains(), R[i], R[j]);
        let edgespace = false;
        for (const e of E) {
          const OLi = R[i].OuterMultiplicities().concat(R[i].EdgeMultiplicities());
          const OLj = R[j].OuterMultiplicities().concat(R[j].EdgeMultiplicities());
          const [sym, sups, subs] = EdgeDecorations(e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), false, forcesubs, forcesups);
          const supsStr = !sups.length ? "" : "{" + sups.join("-") + "}";
          const subsStr = !subs.length ? "" : "(" + subs[0] + ")";
          const symbol = sym === "-" ? "\\e" : "\\d";
          const space = (sups.length + subs.length === 0) ? " " : "";
          out += `${symbol}${supsStr}${subsStr}${space}`;
        }
      }
    }
    return wrap ? `\\redtype{${out}}` : out;
  }

  HTMLLabel(forcesubs = false, forcesups = false) {    //
    /*
    HTML label of a reduction type using <span> with class for superscripts/subscripts and edges.
    */
  
    const R = this;
    const path = R.bestscore;
    const trail = R.besttrail;
  
    let out = "";
  
    for (let index = 0; index < path.length; index++) {
      const p = path[index];
      const n = p[0];
      const i = trail[index];
      const jump = p[2];
  
      if (n === 0) {
        out += R[i].HTMLLabel();  // label for a principal type component
      } else {
        out += `c<sub>${n}</sub>`;  // c_n label
      }
  
      if (jump) {
        if (index !== path.length - 1) {
          out += "&";
        }
      } else {
        const j = trail[index + 1];
        const E = ExtractEdges(R.InnerChains(), R[i], R[j]);
  
        let edgespace = false;
        for (const e of E) {
          const OLi = R[i].OuterMultiplicities().concat(R[i].EdgeMultiplicities());
          const OLj = R[j].OuterMultiplicities().concat(R[j].EdgeMultiplicities());
          const [sym, sups, subs] = EdgeDecorations(e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), false, forcesubs, forcesups);
  
          const edgeclass = sym === "-" ? "edg" : "edd";
  
          if (!sups.length && !subs.length) {
            if (edgespace) {
              out += "&thinsp;";
            }
            out += sym === "-" ? "&ndash;" : "=";
            edgespace = true;
          } else {
            edgespace = false;
            const supstr = !sups.length ? "&nbsp;" : sups.join("-");
            const substr = !subs.length ? "&nbsp;" : String(subs[0]);
            out += `<span class='${edgeclass}'><sup>${supstr}</sup><sub>${substr}</sub></span>`;
          }
        }
      }
    }
  
    return out;
  }
    
  Label(options = {}) {
    /*
    Return canonical string label of a reduction type.
      tex:=true        gives a TeX-friendly label (\redtype{...}) 
      html:=true       gives a HTML-friendly label (<span class='redtype'>...</span>) 
      wrap:=false      keeps the format above but removes \redtype / <span> wrapping
      forcesubs:=true  forces depths of chains & loops to be always printed (usually in round brackets)
      forcesups:=true  forces outgoing chain multiplicities to be always printed (in curly brackets).
    depths can be "default", "original", "minimal", or a custom sequence.
    */

    const R = this;

    const {
      tex       = false, 
      html      = false, 
      wrap      = true, 
      forcesups = false, 
      forcesubs = false, 
      depths    = "default"
    } = options;

    if (depths !== "default") {                     // depths
      const orgdepths = R.GetDepths();
      if (depths === "original") {
        R.SetOriginalDepths();
      } else if (depths === "minimal") {
        R.SetMinimalDepths();
      } else if (Array.isArray(depths)) {
        R.SetDepths(depths);
      } else {
        throw new Error("depths is neither 'default', 'original', 'minimal' nor a sequence of strings");
      }

      const label = R.Label({tex, html, wrap, forcesubs, forcesups});
      R.SetDepths(orgdepths);
      return label;
    }

    if (tex) {
      return R.TeXLabel(forcesubs, forcesups, wrap);
    }
    if (html) {
      return R.HTMLLabel(forcesubs, forcesups);
    }

    // Extract the best score path and trail
    const path = R.bestscore;
    const trail = R.besttrail;

    let out = "";

    // Traverse the path
    for (let index = 0; index < path.length; index++) {
      const [n, _, jump] = path[index];
      const i = trail[index];

      // Print the principal type when first encountering vertex
      if (n === 0) {
        out += R[i].Label();
      } else {
        out += "c" + TeXPrintParameter(n, {tex: false, sym: ""});     // Else print c_n
      }

      // Handle jumps
      if (jump) {
        if (index === path.length - 1) {
          out += "";
        } else {
          out += "&";
        }
      } else {
        // Print edges from i to j
        const j = trail[index + 1];
        const E = ExtractEdges(R.InnerChains(), R[i], R[j]);
        vprint(`Extracted edges ${i}-${j}: ${E}`);

        E.forEach(e => {
          const OLi = R[i].OuterMultiplicities().concat(R[i].EdgeMultiplicities());
          const OLj = R[j].OuterMultiplicities().concat(R[j].EdgeMultiplicities());
          const [sym, sups, subs] = EdgeDecorations(e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), false, forcesubs, forcesups);
          out += PrintEdge(sym, sups, subs);
        });
      }
    }

    // Return the final formatted label
    if (html && wrap) {               // HTML friendly output, wrapped in <span>...</span>
      return `<span class='redtype'>${out}</span>`;
    }
    if (tex && wrap) {                // TeX friendly output, wrapped in \redtype{...}
      return `\\redtype{${out}}`;
    }
    return out;                       // Unwrapped output

  }

  Family() {
    /*
    Returns the reduction type label with minimal chain lengths in the same family.
    */
    return this.Label({ depths: "minimal" });
  }

  
  /*
  Example Plain and TeX labels for reduction types
  var R = ReductionType("IIg1_1-(3)III-(4)IV");
  console.log(R.Label());            // plain text label
  var R2 = ReductionType(R.Label());  
  console.assert(R.equals(R2));      // can be used to reconstruct the type
  console.log(R.Family());           // family (reduction type with minimal depths) 
  console.log(R.Label({tex: true})); // label in TeX
  console.log(R[1].toString());      // first principal type as a standalone type
  console.log(R.TeX());              // reduction type as a graph in TeX
  */


  /*
  Example Canonical label in detail
  // Take a graph $G$ on 4 vertices
  var G = new Graph(4,[[1,2],[1,3],[1,4]]);
  console.log(TeXGraph(G, {labels: "none"}));
  // Place a component of multiplicity 1 at the root and \II, \IIIS, \IZS{} at the three leaves. Link each leaf to the root with a chain of multiplicity~1. This gives a reduction type that occurs for genus~3 curves:
  var R = ReductionType("1-II&c1-III*&c1-I0*");    // First component is the root, 
  console.log(R.TeX());                            //   the other three are leaves
  // Here is the corresponding special fibre\par
  // \begin{tikzpicture}[xscale=0.8,yscale=0.7, belowleftl/.style={below left=-4.5pt,lfnt}, lfnt/.style={font=\tiny}, l2end/.style={shorten <=-0.3em}, mainl/.style={scale=0.8,above left=-0.17em and -1.5em}, rightl/.style={right=-3pt,lfnt}, l2/.style={shorten >=-0.3em,shorten <=-0.3em}, l1/.style={shorten >=-1.3em,shorten <=-0.5em,thick}, bluedash/.style={blue!80!white,densely dashed,shorten <=0em,shorten >=0em}, leftl/.style={left=-3pt,lfnt}, facel/.style={scale=0.5,blue,below right=-0.5pt and 6pt}, abovel/.style={above=-2.5pt,lfnt}] \draw[l1] (0.66,0)--(3.6,0) node[mainl] {4} node[facel] {$\Gamma_4$}; \draw[l2] (0.66,0)--node[rightl] {3} (0.66,0.66); \draw[l2] (0,0.66)--node[abovel] {2} (0.66,0.66); \draw[l2end] (0,0.66)--node[leftl] {1} (0,1.33); \draw[l2end] (1.46,0)--node[rightl] {2} (1.46,0.66); \draw[l1] (2.26,3.16)--(7.8,3.16) node[mainl] {6} node[facel] {$\Gamma_1$}; \draw[l1] (2.26,1.33)--(7.8,1.33) node[mainl] {1} node[facel] {$\Gamma_2$}; \draw[l2] (2.93,0)--node[rightl] {3} (2.93,0.66); \draw[l2] (2.93,0.66)--node[belowleftl] {2} (2.26,1.33); \draw[l1] (2.86,2)--(5.73,2) node[mainl] {2} node[facel] {$\Gamma_3$}; \draw[l2,bluedash] (2.86,1.33)--(2.86,2); \draw[l2end] (3.46,2)--node[rightl] {1} (3.46,2.66); \draw[l2end] (4.26,2)--node[rightl] {1} (4.26,2.66); \draw[l2end] (5.06,2)--node[rightl] {1} (5.06,2.66); \draw[l2,bluedash] (7.13,1.33)--(7.13,3.16); \draw[l2end] (2.26,3.16)--node[rightl] {2} (2.26,3.83); \draw[l2end] (3.06,3.16)--node[rightl] {3} (3.06,3.83); \end{tikzpicture} \\
  // How is the following canonical label chosen among all possible labels?
  console.log(R.Label());
  // Each principal component is a principal type (as there are no loops or D-links), and its primary invariants are its Euler characteristic $\chi$ and a multiset weight of gcd's of outgoing (edge) inner chains
  let Prin = R.PrincipalTypes();
  console.log(Prin.map(S => S.toString())); 
  console.log(Prin.map(S => S.Chi()));    // add up to 2-2*genus, so genus=3
  console.log(Prin.map(S => S.Weight()));
  // The three leaves have $\chi=-1$, weight=$[1]$, and the root $\chi=-1$, weight=$[1,1,1]$.
  // There are 10 types of the former kind (II-, III-, IV-, ...), drawn as $1^1_{(10)}$ in shapes, and one of the root kind, drawn as 1.
  console.log(PrincipalTypes(-1,[1]).toString());        
  console.log(PrincipalTypes(-1,[1,1,1]).toString());
  // Together they form a shape graph $S$ as follows:
  var S = R.Shape(); 
  console.log(S.TeX({scale: 1}));
  // The vertices and edges of $S$ are assigned scores. Vertex scores are $\chi$'s, edge scores are weight's
  console.log(S.VertexLabels()); 
  console.log(S.EdgeLabels());    
  // Then the shortest path is found using MinimumScorePaths. It is v-v-v\&v-2 (v=new vertex with $\chi=-1$, -=edge, \&=jump). Note that by convention actual edges are preferred to jumps, and going to a new vertex preferred to revisiting an old one. Also vertices with smaller $\chi$ come first, if possible, as they have smaller labels.
  // \par\begin{tabular}{llllll}
  // v-v-v\&v-2 &$<$& v-v\&v-2-v && (jumps are larger than edge marks)\cr
  // v-v-v\&v-2 &$<$& v-v-v\&2-v && (repeated vertex indices are larger than vertex marks)\cr
  // \end{tabular}
  var [P, T] = MinimumScorePaths(S); 
  console.log(P);      // v-v-v&v-2
  // This path can be used to construct the graph, and determines it up to isomorphism. There are $|\Aut S|=6$ ways to trail $S$ in accordance with this path, and as far the shape is concerned, they are completely identical.
  console.log(T);
  // This gives six possible labels for our reduction type that all traverse the shape according to path $P$:
  var l = (i) => R[i].Label();
  console.log(T.map(c => `${l(c[0])}-${l(c[1])}-${l(c[2])}&${l(c[3])}-c2`));
  // Now we assign scores to vertices and edges that characterise the actual shape components (rather than just their $\chi$) and inner chains (rather than just their weight)
  console.log(R.PrincipalTypes().map(S => S.Score())); 
  console.log(R.EdgesScore(2,1));    // score of the 1-II inner chain
  console.log(R.EdgesScore(2,3));    // score of the 1-I0* inner chain
  console.log(R.EdgesScore(2,4));    // score of the 1-III* inner chain
  // The component score Score(R[i]) starts with $(\chi,m,-g,...)$ so when all components have the same $\chi$ like in this example, the ones with smaller multiplicity $m$ have smaller score. Because m(II)=6, m(III*)=4, m(I0*)=2, the trails $T[1]$ and $T[2]$ are preferred to the other four. They both start with a component \IZS, then an edge \IZS-1 and a component 1. After that they differ in that $T[1]$ traverses an edge 1-II and $T[2]$ an edge 1-III*. Because the edge score is smaller for $T[1]$, this is the minimal path, and it determines the label for $R$:
  console.log(R.Label());
  */


  TeX(options = {}) {
    /*
    TikZ representation of a reduction type, as a graph with PrincipalTypes (principal components with chi>0) as vertices, and edges for inner chains.
    oneline:=true removes line breaks. 
    forcesups:=true and/or forcesubs:=true shows edge decorations (outgoing multiplicities and/or chain depths) even when they are default.
    */
    const RR = (v) => PrintReal(v, 2);  // Printing reals with at most two digits after the comma

    let { 
      forcesups = false, 
      forcesubs = false, 
      scale = 0.8, 
      xscale = 1, 
      yscale = 1, 
      oneline = false 
    } = options;

    let out = "\\begin{tikzpicture}[xscale=1.2,yscale=1.2, sup/.style={midway,auto,scale=0.5}, sub/.style={sup,swap}, lrg/.style={scale=0.9,inner sep=0.1em,text depth=0.5ex,text height=1.6ex}]\n";

    const nodestr = [];  // Names of nodes (genus, multiplicity, subscripts, superscripts from principal type label)

    const Sh = this.C;  // Principal types and edges between them
    const edges = SortSetList(this.InnerChains().filter(
      e => e.Class === cEdge).map(e => [e.Si.Index(), e.Sj.Index()]));

    const GV = [...Array(Sh.length).keys()].map(i => i + 1);                  // 1..len(Sh)
    const G = new Graph(GV, edges);

    const [x, y] = StandardGraphCoordinates(G);         // Get standard graph coordinates

    const oleft = Array.from({ length: Sh.length }, () => []);

    if (Sh.length === 1) {
      return this[1].Label({ tex: true, wrap: true });  // Only one component, return its TeX label
    }

    // Place vertices for principal types
    for (let i = 0; i < Sh.length; i++) {
      const S = Sh[i];
      out += `\\node[lrg] at (${RR(scale * xscale * x[i])},${RR(scale * yscale * y[i])}) (${i + 1}) {$${S.Label({ tex: true, wrap: true })}$};\n`;
    }

    // Place edges
    for (const e0 of edges) {
      let [p1, p2] = e0; // e0.split(',').map(Number);
      const dx = x[p2 - 1] - x[p1 - 1];
      const dy = y[p2 - 1] - y[p1 - 1];

      // Reverse vertices and multiplicities if necessary
      if (dx < 0 || (Math.abs(dx) < Math.abs(dy) && dy < 0)) {
        [p1, p2] = [p2, p1];
      }

      const E = ExtractEdges(this.InnerChains(), this[p1], this[p2]);
      const bends = EdgeBends(E.length);

      for (let i = 0; i < E.length; i++) {
        const e = E[i];
        const options = [];  // Bend multiple edges, add other edge options if necessary
        if (bends[i] !== 0) {
          options.push(`bend right=${bends[i]}`);
        }

        const OLi = e.Si.OuterMultiplicities().concat(e.Si.EdgeMultiplicities());
        const OLj = e.Sj.OuterMultiplicities().concat(e.Sj.EdgeMultiplicities());

        const [sym, supinds, subinds] = EdgeDecorations(
          e.mi, OLi, e.di, e.mj, OLj, e.dj, e.DepthString(), false, forcesups, forcesubs);

        const supstr = supinds.length ? `node [sup] {${supinds.join('-')}} ` : "";
        const substr = subinds.length ? `node [sub] {${subinds[0]}} ` : "";
        if (sym === "=") {
          options.push("double");  // double distance=1pt
        }

        const optstr = options.length ? `[${options.join(',')}]` : "";
        out += `\\draw (${p1}) edge${optstr} ${supstr}${substr}(${p2});\n`;
      }
    }

    out += "\\end{tikzpicture}\n";

    if (oneline) {
      out = out.replace(/\n/g, " ").replace(/ {2,}/g, " ");  // Replace multiple spaces with a single space
    }

    return out;  
  }

  /*
  Example TeX for reduction types
  R = new ReductionType("1g1--I1-I1");
  console.log(`\\cbox{${R.TeX()}}\\qquad\\cbox{${R.TeX({forcesups: true, forcesubs: true, scale: 1.5})}}`); //> console.log(R.TeX(),R.TeX({forcesups: true, forcesubs: true, scale: 1.5}));
  */

  /*
  Example Degenerations of two elliptic curves meeting at a point
  const S = ReductionType("1g1-1g1").Shape();    // Two elliptic curves meeting at a point (genus 2)
  // The corresponding shape is a graph v-v with two vertices with $\chi=-1$ and one edge of gcd 1
  console.log(S.TeX());
  // There are 10 possibilities for such a vertex, one for each Kodaira type, and Binomial(10,2)=55 such types in total
  console.log(PrincipalTypes(-1,[1]).join(", ")); 
  console.log(ReductionTypes(S, {countonly: true}));
  */
  
   
  SetDepths(depth) {
    /*
    Set depths for DualGraph and Label based on either a function or a sequence.

    If `depth` is a function, it should be of the form:
      depth(e: RedChain) -> int/str
    For example:
      e => e.depth  // Original depths
      e => MinimalDepth(e.mi, e.di, e.mj, e.dj)  // Minimal depths
      e => `n_${e.index}`  // Custom string-based depth

    If `depth` is a sequence, its length must match the number of inner chains in the reduction type.

    Raises:
      Error: If `depth` is neither a function nor a sequence or if the sequence length doesn't match.
    */

    if (typeof depth === 'function') {  // If it's a function
      for (const e of this.InnerChains()) {
        e.SetDepthString(depth(e));
      }
    } else if (Array.isArray(depth)) {  // If it's a sequence
      if (depth.length !== this.InnerChains().length) {
        throw new Error(`#S(=${depth.length}) <> number of edges (=${this.InnerChains().length}) for R=${this}`);
      }
      this.SetDepths(e => depth[e.index - 1]);  // Set depths using the provided sequence
    } else {
      throw new Error("depth must be either a function or a sequence");
    }
  }
    
  SetVariableDepths() {
    /*
    Set depths for DualGraph and Label to a variable depth format like 'n_i'.
    */
    this.SetDepths(e => `n_${e.index}`);  // Using a function to set variable depths
  }
    
  SetOriginalDepths() {
    /*
    Remove custom depths and reset to original depths for printing in Label and other functions.
    */
    this.SetDepths(e => e.depth);  // Reset to original depths
  }
    
  SetMinimalDepths() {
    /*
    Set depths to minimal ones in the family for each edge.
    */
    this.SetDepths(e => MinimalDepth(e.mi, e.di, e.mj, e.dj));  // Set to minimal depths
  }
    
  GetDepths() {
    /*
    Return the current depths (string sequence) set by SetDepths or the original ones if not changed.
    */
    return this.InnerChains().map(e => e.DepthString());  // Return depth strings for each inner chain
  }  
 

}


/*
Example Setting variable depths for drawing families
var R = new ReductionType("I3-(2)I5");
console.log(R.Label({tex: true}));
R.SetDepths(["a", "b", "5"]);    // Make two of the three chains variable depth
console.log(R.Label({tex: true}));
R.SetOriginalDepths();
console.log(R.Label({tex: true}));
*/


function ChainParameters(mi, mj, c) {         //
  /*
  Return di, dj, gcd, and depth from a inner sequence [mi] + c + [mj].
  - di, dj are normalized mod mi, mj, and taken from principal multiplicities if the chain is empty.

  Parameters:
    mi (int): Principal multiplicity from the ith component.
    mj (int): Principal multiplicity from the jth component.
    c (array): Inner chain (array of integers).
  
  Returns:
    di, dj (int): Normalized outgoing multiplicities.
    gcd (int): The greatest common divisor of the full chain.
    depth (int): The depth of the chain.
  */

  // di: outgoing multiplicity from the ith component
  let di = c.length === 0 ? mj : c[0];  // If chain is empty, di = mj; else di = first element of c
  di = mod(di, mi);                     // Normalize di mod mi
  if (di === 0) di = mi;                // If di mod mi == 0, set di = mi

  // dj: outgoing multiplicity from the jth component
  let dj = c.length === 0 ? mi : c[c.length - 1];  // If chain is empty, dj = mi; else dj = last element of c
  dj = mod(dj, mj);                     // Normalize dj mod mj
  if (dj === 0) dj = mj;                // If dj mod mj == 0, set dj = mj

  // Full chain is the concatenation of [mi] + c + [mj]
  let fullchain = [mi].concat(c, [mj]);

  // Calculate gcd of the full chain
  let gcd = GCD(...fullchain);  

  // Calculate the depth of the chain
  let depth = fullchain.filter(x => x === gcd).length - 1;  // Count occurrences of gcd, subtract 1

  // Check for minimal link depth, raise an error if depth is less than allowed
  let minimalDepth = MinimalDepth(mi, di, mj, dj);  
  if (depth < minimalDepth) {
    throw new Error(`ChainParameters: Found depth ${depth} < minimal allowed for m1=${mi}, d1=${di}, m2=${mj}, d2=${dj}`);
  }

  return { di, dj, gcd, depth };
}


function ReductionTypeFromDualGraph(G) {         //
  /*
  Create a reduction type from a full dual mrnc graph -- implements GrphDual.ReductionType()

  Parameters:
    G (GrphDual): The dual graph representation of the reduction type.
  
  Returns:
    RedType: The constructed reduction type.
  */

  vprint("ReductionTypeFromDualGraph: Calling G.MakeMRNC()");
  G.MakeMRNC();

  const P = G.PrincipalComponents();  // Principal components (possibly with chi=0)
  const Ch = G.ChainsOfP1s();         // Chains of P1s between principal components, including loops
  vprint(`P=${P} Ch=${Ch}`);

  // Extract multiplicities, genera, outer, and inner chains for all principal components
  const m = P.map(c => G.Multiplicity(c));
  const g = P.map(c => G.Genus(c));

  const O = P.map(v => 
    Ch.filter(d => d[0] === v && d[1] === null).map(d => d[2][0])
  );  // Outer multiplicities, unsorted

  const L = P.map(v => [
    ...Ch.filter(d => d[0] === v && d[1] !== null && d[2]).map(d => d[2][0]),  // chains v-w, non-empty
    ...Ch.filter(d => d[1] === v && d[2]).map(d => d[2].slice(-1)[0]),        // chains w-v, non-empty
    ...Ch.filter(d => d[0] === v && d[1] !== null && !d[2]).map(d => m[P.indexOf(d[1])]),  // chains v-w, empty
    ...Ch.filter(d => d[1] === v && !d[2]).map(d => m[P.indexOf(d[0])])       // chains w-v, empty
  ]);

  const Chi = P.map((_, i) => CoreChi(m[i], g[i], O[i], L[i]));

  Chi.forEach((chiValue, i) => {
    vprint(`${P[i]}: m=${m[i]} g=${g[i]} O=${O[i]} L=${L[i]} Chi=${chiValue}`);
  });

  const TotalChi = Chi.reduce((a, b) => a + b, 0);
  if (TotalChi % 2 !== 0) {
    throw new Error(`Expected even Chi, got Chi=${Chi} in ReductionType(GrphDual)`);
  }

  const TotalGenus = Math.floor(1 - TotalChi / 2);
  vprint(`TotalChi=${TotalChi} TotalGenus=${TotalGenus}`);

  if (TotalGenus === 0) {
    throw new Error("ReductionType(GrphDual): Total genus must be positive");
  }
  if (TotalGenus === 1 && !Chi.every(c => c === 0)) {
    throw new Error("ReductionType(GrphDual): Expected all principal components to have chi=0 in genus 1");
  }

  // Set indices of components that will enter the reduction type
  const PCInd = TotalGenus === 1 ? [0] : P.map((_, i) => i).filter(i => Chi[i] < 0);
  vprint(`PCInd=${PCInd}`);

  // Create initial principal types in R
  const C = PCInd.map((c, i) => RedPrin.NewPrincipalType(m[c], g[c], i));

  // Add outer chains
  PCInd.forEach((c, i) => {
    O[c].forEach(o => {
      C[i].AddOuterMultiplicity(o);
    });
  });

  let index = 0;  // Inner chain index to store (to be sorted later)
  Ch.forEach(chain => {
    const [v1, v2, c] = chain;
    if (v2 === null) return;  // outer chains already created

    index += 1;
    const i = P.indexOf(v1);
    const j = P.indexOf(v2);
    const mi = m[i];
    const mj = m[j];

    const { di, dj, gcd, depth } = ChainParameters(mi, mj, c);
    const pci = PCInd.indexOf(i) !== -1 ? PCInd.indexOf(i) : null;
    const pcj = PCInd.indexOf(j) !== -1 ? PCInd.indexOf(j) : null;

    if (pci === pcj) {
      C[pci].AddInnerMultiplicitiesAndLoop(di, dj, depth, index);  // Add loop
    } else if (pci === null) {
      if (!(mi === GCD(mj, dj)) && mi % 2 === 0 && O[i].toString() === [mi / 2, mi / 2].toString()) {
        throw new Error(`Invalid D-link parameters m1=${mj} d1=${dj} m2=${mi} d2=${di} depth=${depth}`);
      }
      C[pcj].AddInnerMultiplicityAndDLink(dj, depth, index);  // Add D-link
    } else if (pcj === null) {
      if (!(mj === GCD(mi, di)) && mj % 2 === 0 && O[j].toString() === [mj / 2, mj / 2].toString()) {
        throw new Error(`Invalid D-link parameters m1=${mi} d1=${di} m2=${mj} d2=${dj} depth=${depth}`);
      }
      C[pci].AddInnerMultiplicityAndDLink(di, depth, index);
    } else {
      C[pci].AddInnerMultiplicityAndChain(C[pcj], di, dj, depth, index);  // Add inner chain
    }
  });

  C.forEach(S => S.Finalize());  // Compute cores, gcd, and sort chains

  vprint(`Indices of principal types: ${PCInd}`);
  vprint(`Principal types: ${C}`);
  vprint("Chains:");
  C.forEach(S => {
    vprint(S);
    S.Chains().forEach(ch => vprint(ch));
  });

  return RedPrinListToReductionType(C);
}


function RedPrinListToShape(C) {         //
  /*
  Construct a shape from a sequence C of principal types, provided all inner chains between them have been created.
  As a second parameter, returns the sequence of all inner chains in C, including loops and D-links.
  
  Parameters:
    C (array of RedPrin): A sequence of principal types.
  
  Returns:
    [Shape, array]: The constructed shape and an array of all inner chains.
  */

  if (C.length === 0) {
    throw new Error("Shape: Array of principal types cannot be empty");
  }

  // Construct shape: vertices SV, decorated with -chi
  const SV = C.map(S => -S.Chi());
  
  const SE = [];  // Edges SE for inner chains of class cEdge
  let E = [];     // Concatenated chains (loops, D-links, etc.)

  // Gather all chains of class cLoop and cD
  E = C.flatMap(S => S.Loops().concat(S.DLinks()));

  // Gather edges from inner chains of class cEdge
  for (let i = 1; i < C.length; i++) {
    for (let j = i + 1; j <= C.length; j++) {
      const edge = [i, j];
      C[i - 1].EdgeChains().forEach(e => {
        // Check if the chain is between C[i] and C[j]
        if (e.Sj.index === C[j - 1].index) {
          edge.push(e.Weight());
          E.push(e);
        }
      });
      if (edge.length > 2) {
        SE.push(edge);  // Ensure the edge contains GCD (i.e., an actual link)
      }
    }
  }

  // Construct the shape using SV and SE
  const shape = new Shape(SV, SE);

  vprint(`Shape: ${shape}`);

  return [shape, E];
}


function ExtractEdges(E, S1, S2) {         //
  /*
  Given an array E of reduction type edges [[i, mi, di, j, mj, dj, depth,...] (RedChain),...],
  extract those from component S1 to S2 as [di, dj, depth], sorted in a standard way.
  */
  
  // Extract chains from S1 to S2
  const L = S1.EdgeChains().filter(e => e.Sj.index === S2.index);
  
  // Sort by di, dj, depth and return
  return L.sort((a, b) => 
    a.di === b.di ? (a.dj === b.dj ? a.depth - b.depth : a.dj - b.dj) : a.di - b.di
  );
}


function EdgesScore(E, Si, Sj) {         //
  /*
  Compute the score associated with edges between components Si and Sj from a sequence of edges E.
  Used in the Label when determining the canonical minimal path.
  */
  
  // Sum the extracted edges as [di, dj, depth]
  return ExtractEdges(E, Si, Sj).reduce((acc, e) => acc.concat([e.di, e.dj, e.depth]), []);
}


function RedPrinListToReductionType(C) {         //
  /**
   * Construct a reduction type from a sequence C of principal types, provided all inner chains 
   * between them are complete. Computes the best path (for label) and initializes all indices.
   * 
   * @param {Array} C - Sequence of principal types (RedPrin objects).
   * @returns {RedType} - The computed reduction type.
   */
  
  // Assign indices
  C.forEach((S, i) => { S.index = i + 1; });  // Indexing starts from 1

  // Consistency checks
  const indices = new Set(C.map(S => S.index));
  if (indices.size !== C.length) {
    throw new Error(`ReductionType(C): repeated principal types in C=${C} ind=${[...indices]}`);
  }
  
  C.forEach((S, i) => {
    S.Chains().forEach(c => {
      if (c.Si.index !== i + 1) {
        throw new Error(`ReductionType(C): chain c=${c} on C[${i}]=${C[i]} has component index ${c.Si.index}!=${i + 1}`);
      }
    });
  });

  const [shape, E] = RedPrinListToShape(C);
  
  const [P, T] = MinimumScorePaths(shape);  // Minimum shape path score, and possible trails (Aut(shape) torsor)
  const VW = C.map(S => S.Score());         // Vertex scores
  const EW = C.map(Si => C.map(Sj => [EdgesScore(E, Si, Sj)]));  // Edge scores

  vprint(`P=${P}\nT=${T}\nVW=${VW}\nEW=${EW}`);

  const VO = PreferenceOrder([...Array(VW.length).keys()].map(i => i + 1), i => VW[i - 1]);
  const EO = PreferenceOrder2(EW, x => x);

  vprint(`VO=${VO}`);
  vprint(`EO=${EO}`);

  const prindices = P.map((w, i) => (w[1].every(x => x <= 0) ? i + 1 : null)).filter(x => x !== null);

  let zeroes = 0;
  const zerocount = P.map((d, i) => {
    if (d[0] === 0 && prindices.includes(i + 1)) zeroes++;
    return zeroes;
  });

  let MinW = prindices.map(i => P[i - 1]);
  MinW = MinW.map(d => (d[0] === 0 ? [0, d[1], d[2]] : [zerocount[d[0] - 1], d[1], d[2]]));

  const infwt = Math.max(...C.map(S => S.Multiplicity())) + 1;  // Dominates all edge scores

  vprint(`prindices=${prindices} zerocount=${zerocount} MinW=${MinW}`);

  let bestscore = [];
  let besttrail = [];

  for (const fulltrail of T) {
    const trail = prindices.map(i => fulltrail[i - 1]);
    let score = [];
    
    for (let step = 1; step <= trail.length; step++) {
      const i = trail[step - 1];
      const [index, _, jump] = MinW[step - 1];

      if (index !== 0) score.push(0);  // Repeated vertex score
      else score.push(VO[i - 1]);

      if (!jump) {
        vprint(`i=${i} step=${step} trail=${trail}`);
        score.push(EO[i - 1][trail[step] - 1]);
      } else {
        score.push(infwt);
      }

      const sgn = ScoreIsSmaller(score, bestscore);
      if (sgn === ">") break;             // Worse, abandon
      if (sgn === "<" || sgn === "l") {   // Better or longer
        vprint(`${trail} -> ${score} ${sgn} ${bestscore}`);
        bestscore = score;
        besttrail = trail;
      }
    }
  }

  vprint(`besttrail ${besttrail}`);
  vprint(`bestscore ${bestscore}`);
  vprint(`Shape(R):\nW =${P}\ntr=${besttrail}\nwt=${bestscore}`);

  let NewC = [];  // Reordered list of principal types, following best trail
  let NewE = [];  // Reordered list of edges

  const PermuteC = Array(besttrail.length).fill(-1);
  
  for (let step = 1; step <= besttrail.length; step++) { // Start step from 1
    const i = besttrail[step-1]; 
    const [index, , jump] = MinW[step-1]; 

    if (index === 0) {              // New vertex i
      NewC.push(C[i-1]); 
      C[i-1].index = i;
      PermuteC[i-1] = NewC.length;    // Update PermuteC with the new index
      NewE.push(...C[i-1].Loops());   //      Add loops from the component
      NewE.push(...C[i-1].DLinks());  //      Add DLinks from the component
      vprint(`(${step}) component ${i}`); 
    }

    if (jump) {
        continue; 
    }

    const j = besttrail[step];           // Get the next index in besttrail
    vprint(`(${step}) edges ${i}-${j}`); 
    NewE.push(...ExtractEdges(E, C[i-1], C[j-1])); // Extract and add edges
  }

  for (let i = 1; i <= C.length; i++) {
    NewC[i - 1].index = i;  // Change components order
  }
  for (let i = 1; i <= NewE.length; i++) {
    NewE[i - 1].index = i;  // Change edges order
  }

  // Sanity checks
  if (C.length !== NewC.length) {
    throw new Error(`Mismatched number of components after reordering: C=${C} NewC=${NewC}`);
  }
  if (E.length !== NewE.length) {
    throw new Error(`Mismatched number of edges after reordering: E=${E} NewE=${NewE}`);
  }

  vprint(`C=${C} -> NewC=${NewC} (permuteC=${PermuteC})`);

  const [newshape,_] = RedPrinListToShape(NewC);
  besttrail = besttrail.map(i => PermuteC[i - 1]);

  if (besttrail[0] !== 1) {
    throw new Error(`Expected recoded besttrail in R to start with 1: ${besttrail}`);
  }

  const R = new RedType(NewC, NewE, null, newshape, MinW, besttrail);
  R.SetOriginalDepths();
  return R;
}



function PrintEdge(sym, sups, subs) {         //
  const supsStr = sups.length === 0 ? "" : "{" + sups.join("-") + "}";
  const subsStr = subs.length === 0 ? "" : `(${subs[0]})`;
  return `${sym}${supsStr}${subsStr}`;
}



function AddInnerChain(m, g, E, e, i, j) {         //
  /*
  Add an inner chain between vertices i and j to the multiplicity, genus, and edge lists.
  m - List of multiplicities.
  g - List of genera.
  E - List of edges.
  e - The inner chain object (containing mi, di, mj, dj, depth, etc.).
  i - Starting vertex index.
  j - Ending vertex index.
  */

  const L = InnerSequence(e.mi, e.di, e.mj, e.dj, e.depth);
  vprint(`inner chain v${i}:${e.mi},${e.di} -(${e.depth}) v${j}:${e.mj},${e.dj} -> ${L}`);

  if (L[0] !== e.mi || L[L.length - 1] !== e.mj) {
    throw new Error("Invalid inner sequence.");
  }

  let prev = i;
  for (let k = 0; k < L.length; k++) {
    if (k === 0) {
      // Start the chain, don't create vertices
      prev = i;
    } else if (k === L.length - 1) {
      // Finish the chain, don't create vertices
      E.push([prev, j]);
    } else {
      // Create a new vertex
      m.push(L[k]);  // Add multiplicity
      g.push(0);     // Genus is 0
      E.push([prev, m.length]);  // Link it to the previous one
      prev = m.length;
    }
  }
}


function AddOuterChain(m, g, E, i, mi, di) {         //
  /*
  Add an outer chain starting from vertex i to the multiplicity, genus, and edge lists.
  m  - List of multiplicities.
  g  - List of genera.
  E  - List of edges.
  i  - Starting vertex index.
  mi - Initial principal multiplicity.
  di - Initial outgoing multiplicity.
  */

  const O = OuterSequence(mi, di);  // Generate the outer sequence
  // print(`outer chain v${i}:${mi},${di} -> ${O}`);
  
  if (O[0] !== mi || O[O.length - 1] !== GCD(...O)) {
    throw new Error("Invalid outer sequence.");
  }

  let prev = i;
  for (let k = 0; k < O.length; k++) {
    if (k === 0) {
      // Start the chain, don't create vertices
      prev = i;
    } else {
      // Create a new vertex
      m.push(O[k]);  // Add multiplicity
      g.push(0);     // Genus is 0
      E.push([prev, m.length]);  // Link it to the previous one
      prev = m.length;
    }
  }
}


function VariableChain(e) {         //
  /*
  Return a variable chain (RedChain) with depth annotations for the link.
  e - A RedChain object representing the inner chain.
  */

  let L = InnerSequence(e.mi, e.di, e.mj, e.dj, 2);  // Generate the inner sequence
  L = L.slice(1, -1);  // Remove the first and last element

  // Determine the shift based on multiplicities and di, di
  let shift = 1 - (e.mi === e.di ? 1 : 0) - (e.mj === e.dj ? 1 : 0);

  // Special case for loops
  if (e.Class === cLoop && e.mi === e.di && e.mj === e.dj) {
    shift = 0;
  }

  // Create the shift string
  let shiftstr = "";
  if (shift === 1) shiftstr = "\\!+\\!1";
  else if (shift === -1) shiftstr = "\\!-\\!1";

  const depth = `$${e.DepthString()}${shiftstr}$`;

  const gcd = e.Weight();
  const p = L.indexOf(gcd);
  if (p < 0) {
    throw new Error("GCD not found in the inner sequence.");
  }

  // Split the sequence into head, gcd's, and tail
  const Lhead = L.slice(0, p);
  const Ltail = L.slice(p).filter(d => d !== gcd);

  // Return the formatted chain with the depth annotation at the GCD position
  return [...Lhead, [gcd, depth], ...Ltail];
}


function RedPrinListLinks(C) {         //
  /*
  All inner chains within a list of principal types, including loops and D-links.
  takes C - List of principal types.
  */

  let E = [];  // Initialize an empty list to store inner chains

  C.forEach(S => {
    E = E.concat(S.Loops());  // Add all loops
    E = E.concat(S.DLinks()); // Add all D-links
  });

  for (let i = 0; i < C.length - 1; i++) {  // Iterate over all pairs of distinct principal types (i < j)
    for (let j = i + 1; j < C.length; j++) {
      C[i].EdgeChains().forEach(e => {     // Collect all edges for principal type C[i]
        if (e.Sj.index === C[j].index) {    // If the index of the Sj principal type matches C[j]'s index
          E.push(e);
        }
      });
    }
  }

  return E;
}


function RedPrinListDualGraph(C, compnames = "default") {         //
  /*
  Construct a dual graph from a sequence C of principal types (RedPrin) with all links initialized.
  compnames is a name prefix for components, e.g. "\\Gamma_" or "" (default is "default").
  Returns the constructed dual graph.
  */

  let indices = C.map(S => S.index);  // Get indices of all principal types

  // Check if indices are complete
  if (!indices.every((val, idx) => val === idx + 1)) {
    throw new Error(`DualGraph(C): indices ${indices} are incomplete for C=${C}`);
  }

  let m = C.map(S => S.Multiplicity());        // Multiplicities of principal types
  let g = C.map(S => S.GeometricGenus());      // Genera of principal types
  let GE = [];                                 // Initialize edges of the dual graph

  // Start with outer chains from all principal types
  C.forEach((S, i) => {
    S.OuterMultiplicities().forEach(d => {
      AddOuterChain(m, g, GE, i + 1, S.Multiplicity(), d);
    });
  });

  let VarChains = [];
  RedPrinListLinks(C).forEach(e => {           // Links between principal types, loops & D-links
    let i = e.Si.Index();
    let j;

    if ([cLoop, cEdge].includes(e.Class)) {
      j = e.Sj.Index();
    }

    if (e.Class === cD) {                // D-link -> create target component
      m.push(e.mj);                            // Add multiplicity
      g.push(0);                               // Add genus
      j = m.length;                            // Update index to new component
      AddOuterChain(m, g, GE, j, e.mj, Math.floor(e.mj / 2));  // Add outer chains
      AddOuterChain(m, g, GE, j, e.mj, Math.floor(e.mj / 2));
    }

    if (e.DepthString() !== String(e.depth)) {
      VarChains.push([i, j, VariableChain(e)]);  // Variable length chain
    } else {
      AddInnerChain(m, g, GE, e, i, j);          // Regular inner chain
    }
  });

  if (compnames === "default") {
    compnames = "\\Gamma_";
  }
  if (typeof compnames === 'string') {    // TeX names of principal components  
    compnames = Array.from({length: m.length}, (_, i) => 
      i < C.length ? `$${TeXPrintParameter(i + 1, {tex: true, sym: compnames})}$` : ""
    );
  }  

  // Construct the dual graph
  let G = DualGraph(m, g, GE, compnames);

  // Add variable length chains to the graph
  VarChains.forEach(([i, j, mults]) => {
    AddVariableChain(G, i.toString(), j.toString(), mults);
  });

  return G;
}


function _AddEdge(Class, S1, d1, S2, d2, n, sym) {         //
  /*
  Add an edge to the graph defined by principal types S1 and S2.
  Class - Class of the edge (cLoop, cD, cEdge).
  S1, S2 - Principal types between which the edge is to be added.
  d1, d2 - Initial chain multiplicities; can be set to false.
  n - Depth of the edge.
  sym - Edge symbol ("-" or "=").
  */

  vprint(`_AddEdge [${Class}] S1=${S1} d1=${d1} S2=${S2} d2=${d2} n=${n} sym=${sym}\n`);

  let def1 = (d1 === false);  // Check if d1 is set to false
  let def2 = (d2 === false);  // Check if d2 is set to false

  // Raise error if d1 and d2 are inconsistent unless Class is cD
  if (def1 !== def2 && Class !== cD) {
    throw new Error(`_AddEdge: d1=${d1} d2=${d2} is not a valid option`);
  }

  if (sym === "=") {             // If "=", set d1=S1.m, d2=S2.m
    d1 = S1.m;
    d2 = S2.m;
  } 
  else if (def1) {     // Otherwise, if def1 is true, set default multiplicities
    let A1 = [...S1.OuterMultiplicities(), ...S1.EdgeMultiplicities()];
    let A2 = [...S2.OuterMultiplicities(), ...S2.EdgeMultiplicities()];
    [d1, d2] = DefaultMultiplicities(S1.m, A1, S2.m, A2, S1.index === S2.index);
  }

  if (Class === cLoop) {
    S1.AddInnerMultiplicitiesAndLoop(d1, d2, n);  // Add a loop 
  } else if (Class === cD) {
    S1.AddInnerMultiplicityAndDLink(d1, n);       // Add a D-link 
  } else if (Class === cEdge) {
    S1.AddInnerMultiplicityAndChain(S2, d1, d2, n);  // Add a edge between S1 and S2
  } else {
    throw new Error(`AddEdge: Class(${Class}) should be cLoop, cD, or cEdge`);
  }

  Exclude(S1.O,S1.C[S1.C.length-1].di);            // Remove di from outer multiplicities S1.O
  if ([cLoop, cEdge].includes(Class)) {     // Remove dj
    Exclude(S2.O,S1.C[S1.C.length-1].dj); 
  }

  vprint(`Added edge ${S1.C[S1.C.length - 1]}\n`);
}


function ReductionTypeFromLabel(S) {    //
  /*
  Construct a reduction type from its label
  */

  const tComp = 1, tEdge = 2, tLoop = 3, tName = 4, tMult = 5, tInt = 6, tcComp = 7, tGenus = 8, tEdgeSym = 9, tEdgeMult = 10, 
        tEdgeLen = 11, tSup = 12, tUnderline = 13, tAmp = 14, tComma = 15, tOther = 16;

  // Clean up -1 in subscripts, spaces, html symbols
  S = S.replaceAll("_-1", "_(-1)").
        replaceAll(",-1", ",(-1)").
        replaceAll('&amp;','&').
        replaceAll(' ','').
        replaceAll('\n','');

  // Tokenize the input string
  let T = StringSplit(S, [
    [tName, /([IVDT]+[IVDT*0-9]*)/],
    [tMult, /\[([0-9]+)\]/],
    [tInt, /([0-9]+)/],
    [tcComp, /c([0-9]+)/],
    [tGenus, /_?g([0-9]+)/],
    [tEdgeSym, /([-=<>])/],
    [tEdgeMult, /\{([0-9-]+)\}/],
    [tEdgeLen, /\((-?[0-9]+)\)/],
    [tSup, /[/^]([0-9,]+)/],
    [tUnderline, /(_)/],
    [tAmp, /(&)/],
    [tComma, /(,)/],
    [tOther, /(.)/]
  ]);

  if (T.length == 0)
  {
    throw new Error('ReductionType: empty label');
  }

  vprint(`Initial tokens for ${S}:`);
  vprint(T);

  var subscript = false;
  let i = 0;

  // Process tokens
  while (i < T.length) {
    let [t, s] = T[i];

    if (t === tUnderline) subscript = true;
    if (t === tEdgeSym || t === tAmp) subscript = false;

    if (t === tName) {
      let m = s.match(/^I([0-9]+)([*]?)$/);  // Match the regular expression
      let ok = m !== null;
      let B = ok ? m.slice(1) : [];  // Use match groups if ok is true, otherwise empty array
    
      if (ok && B[0] !== "0") {
        if (B[1] === "") {
          // Replace a section of T with new entries
          T = [...T.slice(0, i), 
               [tComp, false, 1, false, []], 
               [tLoop, false, false, parseInt(B[0])], 
               ...T.slice(i + 1)];
        } else {
          let d = (i > 0 && T[i - 1][0] === tComp && T[i - 1][1]) ? T[i - 1][1] : 1;
          // Replace with different entries if there's a "*"
          T = [...T.slice(0, i), 
               [tComp, false, 2, false, [1, 1]], 
               [tLoop, "D", [2 * d], parseInt(B[0])], 
               ...T.slice(i + 1)];
        }
        i += 2;
    
        // Handle subscripts (underline, comma, genus)
        subscript = (i < T.length) && [tUnderline, tComma, tGenus].includes(T[i][0]);
        if (subscript && T[i][0] !== tGenus) {
          T[i] = [tComma, ","];
          if ([tComma, tEdgeSym].includes(T[i + 1][0])) {
            T.splice(i, 1); 
          }
        }
        if (subscript && T.length > i + 1 && T[i][0] === tGenus && T[i + 1][0] === tUnderline) {
          T[i + 1] = [tComma, ","];
        }
        continue;
    
      } else if (!StandardCoreNames.some(D => D.plain === s)) {
        throw new Error(`Component name ${s} not recognised in "${S}"`);
      }
    
      if (subscript) {
        if (s !== "D") {
          throw new Error(`Expected an edge: ${s} in "${S}"`);
        }
        T[i] = [tLoop, "D", false, false];
    
      } else {
        let D = StandardCoreNames.find(D => D.plain === s);
        T[i] = [tComp, false, D.m, false, [...D.O]];         // Copy standard m,O
      }
    }

    else if (t === tMult) {
      T[i] = [tComp, parseInt(s), false, false, false];
    } else if (t === tGenus) {
      T[i] = [tComp, false, false, parseInt(s), false];
    } else if (t === tSup) {
      T[i] = [tComp, false, false, false, s.split(',').map(d => parseInt(d))];
    } else if (t === tInt) {
      if (subscript) {
        T[i] = [tLoop, false, false, parseInt(s)];
      } else {
        T[i] = [tComp, false, parseInt(s), false, false];
      }
    } else if (t === tEdgeSym) {
      T[i] = [tEdge, s, false, false];
    } else if (t === tEdgeMult) {
      T[i] = [subscript ? tLoop : tEdge, false, s.split('-').map(d => parseInt(d)), false];
    } else if (t === tEdgeLen) {
      T[i] = [subscript ? tLoop : tEdge, false, false, parseInt(s)];
    } else if (t === tAmp) {
      // Do nothing for ampersand
    } else if (t === tcComp) {
      T[i] = [tcComp, parseInt(s)];
    } else if (t === tComma) {
      if (!subscript) {
        throw new Error(`',' not in subscript in "${S}"`);
      }
    } else if (t === tOther) {
      throw new Error(`Unexpected symbol ${s} in "${S}"`);
    }
    
    i += 1;
  }

  vprint(`Tokens after splitting for ${S}:`);
  vprint(T);
  
  for (let i = T.length - 2; i >= 0; i--) {  // Loop from len(T) - 2 down to 0
    if (T[i][0] === tLoop && T[i + 1][0] === tComp && T[i + 1][3]) {
      [T[i], T[i + 1]] = [T[i + 1], T[i]];  // Swap elements T[i] and T[i + 1]
    }
  }

  vprint(`Tokens after swapping for ${S}:`);
  vprint(T);

  // Merge adjacent tokens of the same type
  for (let i = T.length - 1; i >= 0; i--) {
    if ([tComma, tAmp, tUnderline].includes(T[i][0])) continue;
    if (i === T.length - 1 || T[i][0] !== T[i + 1][0]) continue;
    if (T[i][0] === tEdge && T[i + 1][1]) continue;

    // Cannot merge if two of these have non-false in some jth entry (except for j=0)
    if (T[i].length !== T[i + 1].length || T[i].some((d, j) => j>0 && d && T[i + 1][j])) {
      throw new Error(`Could not merge data (duplicate information) in [${T[i]}] and [${T[i + 1]}] in "${S}"`);
    }
    T[i] = T[i].map((d, j) => d || T[i + 1][j]);        // merge and
    T.splice(i + 1, 1);                                 // remove one of the two
  }

  vprint(`Tokens after merging for ${S}:`);
  vprint(T);

  // Remove symbols '_' '&' ',' assuming they were placed correctly as we won't need them anymore  
  if (!T || T[0][0] !== tComp) {
    throw new Error("Reduction type name must start with a component");
  }
  
  if (T.some((t, i) => (t[0] === tUnderline) && 
     (i === 0 || T[i - 1][0] !== tComp || i === T.length - 1 || T[i + 1][0] !== tLoop))) {
    throw new Error(`Symbol _ must separate a component and a loop in "${S}"`);
  }
  if (T.some((t, i) => (t[0] === tComma) && 
     (i === 0 || T[i - 1][0] !== tLoop || i === T.length - 1 || T[i + 1][0] !== tLoop))) {
    throw new Error(`Symbol , must separate two loops in "${S}"`);
  }
  if (T.some((t, i) => (t[0] === tAmp) && 
    (i === 0 || ![tcComp, tComp, tLoop].includes(T[i - 1][0]) || i === T.length - 1 || ![tcComp, tComp].includes(T[i + 1][0])))) {
    throw new Error(`Symbol & must separate two components in "${S}"`);
  }
  // Now we can remove commas and underlines
  T = T.filter(t => ![tComma, tUnderline].includes(t[0]));

  vprint(`Collected tokens for ${S}:`);
  vprint(T);

  const V = []; // principal components

  vprint(`Have ${T.filter(d => d[0] === tComp).length} main components`);
  
  i = 0;
  while (true) {
    i += 1;
    if (i > T.length) 
      {break;}
    let d = T[i-1];
    if (d[0] === tcComp && d[1] > V.length) 
      {throw new Error(`Component c${d[1]} has not been defined yet`);}
    if (d[0] !== tComp) 
      {continue;}  
      
    let [, cgcd, m, g, O] = d;
    if (cgcd === false) cgcd = 1;  // default: multiplicity = 1
    if (m === false) m = 1;        //          m = 1
    if (g === false) g = 0;        //          g = 0
    if (O === false) O = [];       //          O = []

    m = cgcd*m;
    O = O.map(o => cgcd * o);      // Multiply m and O by cgcd

    const S = RedPrin.NewPrincipalType(m, g, V.length+1, O);
    V.push(S);

    T[i-1] = [tcComp, V.length];             // Replace with a component reference

    while (i < T.length && T[i][0] === tLoop) {  // Process loops and D-tails belonging to this component
      vprint(`Processing loop/D-tail for c${V.length} at i=${i}`);
      let [_, sym, mult, length] = T[i];  // Destructure the array T[i]
    
      if (mult === false) {
        mult = [];  // Set mult to an empty array if it is false
      }
    
      // *** D-tail ***
      if (sym === "D") {
        if (mult !== false && mult.length > 1) {
          throw new Error("D-tail in a subscript must have <=1 edge multiplicity");
        }
        if (m % 2 === 1) {
          throw new Error(`Component of odd multiplicity ${m} cannot have a D-tail`);
        }
    
        let l;  // Variable to hold the multiplicity
        if (mult.length === 0) { 
          const I = S.OuterMultiplicities().filter(d => d % 2 === 0); // Get even multiplicities
          SortMultiplicities(m, I);  // Call SortMultiplicities function
          l = (I.length > 0) ? I[0] : m; // Use m or the smallest even multiplicity
        } else {
          const r = mult[0] % m;  
          l = (r === 0) ? m : r;  
          if (l % 2 === 1) {
            throw new Error(`Cannot use odd multiplicity ${l} to use in a D-tail`);
          }
          if (!S.OuterMultiplicities().includes(l) && l !== m) {
            throw new Error(`Have no available multiplicity ${l} to use in a D-tail`);
          }
        }
    
        _AddEdge(cD, S, l, false, false, length, "-"); // _AddEdge: add D-link
    
      } else {  // *** loop ***
        if (mult !== false && ![0, 2].includes(mult.length)) {
          return [false, "Loop must have zero or two edge multiplicities"];
        }
    
        let d1, d2;  // Declare variables for multiplicities
        if (mult !== false && mult.length === 2) {
          [d1, d2] = mult;  // Destructure multiplicitie values
        } else {
          d1 = false; 
          d2 = false;  // Set both to false if not specified
        }
    
        _AddEdge(cLoop, S, d1, S, d2, length, "-"); // _AddEdge: add loop
      }
    
      T.splice(i, 1); // Remove the processed element from T
    }

  }

  // EDGES BETWEEN DIFFERENT COMPONENTS
  
  const doneEdges = new Set();  // Initialize a set to track defined edges
  
  for (let i = 0; i < T.length; i++) {  // PRINCIPAL COMPONENTS, LOOPS AND D-TAILS
    const d = T[i];
    if (d[0] !== tcComp || i === T.length - 1) {
      continue;  // Skip if not a component or the last element
    }
  
    if (d[1] < 1 || d[1] > V.length) {
      throw new Error(`Invalid component reference ${d[1]} in "${S}"`);
    }
  
    const j = [...Array(T.length - i - 1).keys()].map(k => k + i + 1)
      .find(j => T[j][0] === tcComp) || null; // Find the next component
    if (j === null) {
      throw new Error(`Could not find a component terminating the edge in "${S}"`);
    }
  
    if (j === i + 1) {
      throw new Error(`No edges specified between two components in "${S}"`);
    }
  
    if (j === i + 2 && T[i + 1][0] === tAmp) {
      continue;  // Skip if the next element is an amplitude
    }
  
    if (!T.slice(i + 1, j).every(t => t[0] === tEdge)) {
      throw new Error(`Unrecognized non-edge tokens between two components in "${S}"`);
    }
  
    const i1 = T[i][1];  // Indices in V of the two principal components
    const i2 = T[j][1];
  
    if (doneEdges.has(`${i1},${i2}`) || doneEdges.has(`${i2},${i1}`)) {
      throw new Error(`Edges c${i1}-c${i2} have already been defined in "${S}"`);
    }
  
    if (i1 === i2) {
      throw new Error(`Loops have to be specified in subscripts, not as edges in "${S}"`);
    }
  
    doneEdges.add(`${i1},${i2}`);  // Track defined edges
  
    for (let k = i + 1; k < j; k++) {  // Process edges one by one
      const [_, sym, mult, length] = T[k];
  
      let d1 = false, d2 = false;  // Default values
      if (mult !== false && sym === "-") {
        if (mult.length !== 2) {
          throw new Error(`Edge - can only have two inner multiplicities in "${S}"`);
        }
      }
  
      if (mult !== false && sym === "=") {
        throw new Error(`Edge = can have no inner multiplicities in "${S}"`);
      }
  
      if (mult !== false && mult.length === 2) {
        [d1, d2] = mult;  // Unpack multiplicities if specified
      }
  
      _AddEdge(cEdge, V[i1 - 1], d1, V[i2 - 1], d2, length, sym);  // _AddEdge: link edge between different components
    }
  }

  // Finalize each component in V
  for (const S of V) {
    S.Finalize(); // Calls the Finalize method on each component
  }
  
  // Debug printing
  vprint("Done V:", V.map(S => S.Label())); // Logs the label of each component
  
  // Compute Euler characteristics of principal types
  const chi = V.map(S => S.Chi()); // Array of Chi values for each component
  
  // Check if any component has chi > 0
  if (Math.max(...chi) > 0) {
    throw new Error("Total genus in a reduction type must be > 0");
  } 
  if (Math.max(...chi) < 0) {               // Good as is
    return RedPrinListToReductionType(V);
  } else {                                  // May have edge D-links like [2]_D,D or [2]T_D,D, convert to a dual graph and return
    return RedPrinListDualGraph(V).ReductionType(); 
  }
}


//let R;

/*
*/

VERBOSE = false

/*
R = ReductionType("IV-IV");
console.log(R.Label());
R = ReductionType("II");
console.log(R.Label());
R = ReductionType("I0*");   
console.log(R.Label());
R = ReductionType("I1");
console.log(R.Label());
R = ReductionType("I3");
console.log(R.Label());
R = ReductionType("I1*");          
console.log(R.Label());
R = ReductionType("II_D");         
console.log(R.Label());
R = ReductionType("II_2D"); 
console.log(R.Label());
R = ReductionType("IV_1");         
console.log(R.Label());
R = ReductionType("IV_3");         
console.log(R.Label());
R = ReductionType("IV-IV");         
console.log(R.Label());
R = ReductionType("II-II");         
console.log(R.Label());
R = ReductionType("II-{2-2}II");
console.log(R.Label());
R = ReductionType("5^1,2,3,4");
console.log(R.Label());
R = ReductionType("5^1,2,3,4-5^1,2,3,4");
console.log(R.Label());
R = ReductionType("5^1,2,3,4-{2-3}5^1,2,3,4");
console.log(R.Label());
R = ReductionType("II*_D");  
console.log(R.Label());
R = ReductionType("II*_{6}D");  
console.log(R.Label());
R = ReductionType("II*_{6}2D");  
console.log(R.Label());
R = ReductionType("IV-IV--IV");  
console.log(R.Label());
R = ReductionType("IV-IV=IV");  
console.log(R.Label());
R = ReductionType("I1-I2");  
console.log(R.Label());
R = ReductionType("I1*-I2");  
console.log(R.Label());
R = ReductionType("I1*--I2");  
console.log(R.Label());
R = ReductionType("1g3-1g2-1g1");  
console.log(R.Label());
R = ReductionType("IV-IV-IV-c1");  
console.log(R.Label());
R = ReductionType("1g1-1g2");  
console.log(R.Label());
R = ReductionType("1g3-1g2-1g1"); 
console.log(R.Label());
R = ReductionType("IV-IV-IV-IV-c1-c3"); 
console.log(R.Label());
*/

//R = ReductionType("IV-IV-IV-IV-c1-c3");  // wrong score order
//console.log(R.Label());



//const R = ReductionType("1g2--IV=IV-1g1-c1");      // R.TeX does not work
//R = ReductionType("II-III");   
//console.log(R.TeX());


function LinkOrderings(L, m, gcds) {   //
  /*
  Given a multiset of links L, select all possible orderings sorted by gcd with m.
  */
  
  if (L.length !== gcds.length) {
    throw new Error("Length of L must be equal to length of gcds");
  }

  // Case where the sets of L and gcds match
  if (new Set(L).size === new Set(gcds).size && [...new Set(L)].every(x => new Set(gcds).has(x))) {
    return [L.slice().sort((a, b) => GCD(a, m) - GCD(b, m))];      // Sort by GCD with m
  }

  // Generate Cartesian product of all permutations grouped by gcd with m
  const result = [];
  const groupedPermutations = Array.from(new Set(gcds)).sort().map(g => {
    return ArrayPermutations(L.filter(d => GCD(d, m) === g));
  });

  const cartesianProductResult = CartesianProduct(groupedPermutations);

  for (const c of cartesianProductResult) {
    result.push(c.flat());
  }
  
  return result;
}


function IncludeAssocIfNotIsomorphic(A, key, data, iso) {       //
  /*
  Given an object A, look for A[key]:
  - If A[key] does not exist, set A[key] = [data] and return.
  - If A[key] exists, append data to the list A[key] unless there is an element data0 in A[key]
    such that iso(data0, data) = true.
  @param {Object} A     - The associative array (object).
  @param {any} key      - The key to check in the object.
  @param {any} data     - The data to append if no isomorphic element exists.
  @param {Function} iso - A function iso(data0, data) that returns true if data0 and data are isomorphic.
  */

  // key = JSON.stringify(key);
  // console.log(key);
  
  if (!(key in A)) {      // If key does not exist
    A[key] = [data];      // Create, add data, and return
    return;
  }

  for (const data0 of A[key]) {  // If key exists, check for isomorphism
    let options = {labelled_format: "[{1}]", usevertexlabels: true};
    // console.log(JSON.stringify(data0.Vertices()),JSON.stringify(data0.Edges()),JSON.stringify(data0.GetLabels()),data0.Label(options));
    // console.log(JSON.stringify(data.Vertices()),JSON.stringify(data.Edges()),JSON.stringify(data.GetLabels()),data.Label(options));
    if (iso(data0, data)) {  
      return;  // Return if isomorphic element is found
    }
  }

  A[key].push(data);      // If no isomorphic element was found, append the new data
}


function MergeEdgeEndpoints(Si, di, Sj, dj, depth = false, index = false) {    //
  /*
  Merge two edge endpoints.
  */

  // Find edge endpoint in Si
  const i1 = Si.C.findIndex(e => e.Class === cEdge && e.di === di && e.Sj === false);
  if (i1 === -1) {
    throw new Error(`Could not find a edge endpoint in ${Si.Label()} of multiplicity ${di}`);
  }

  // Find edge endpoint in Sj
  const i2 = Sj.C.findIndex(e => e.Class === cEdge && e.di === dj && e.Sj === false);
  if (i2 === -1) {
    throw new Error(`Could not find a edge endpoint in ${Sj.Label()} of multiplicity ${dj}`);
  }

  // Check GCD condition
  if (GCD(Si.m, di) !== GCD(Sj.m, dj)) {
    throw new Error(`GCD(${Si.m}, ${di}) != GCD(${Sj.m}, ${dj})`);
  }

  const e = Si.C[i1];
  e.Sj = Sj;
  e.mj = Sj.m;
  e.dj = dj;
  e.SetDepth(depth);   
  e.index = index;
  Sj.C[i2] = e.Reverse(); 
}


function ReductionTypesWithShape(S, options = {}) {     //
  /*
  Sequence of reduction types with a given shape S.
  If countonly is true, only return the number of types.
  */

  const {
    countonly = false,
    semistable = false
  } = options;   

  vprint("ReductionTypesWithShape:",S.toString())

  // Function to check graph isomorphism
  const GraphIso = (G, H) => G.IsIsomorphic(H);

  const V = S.VertexLabels();                          // Sequence of vertex labels
  const E = S.EdgeLabels();                            // List of edges [i, j, -gcd], total NE
  const NE = E.reduce((sum, e) => sum + (e.length - 2), 0); // Total number of edges

  const weights = S.Vertices().map(v => S.Weights(v));    // List of weight multisets for each vertex

  // Semistable case: all weight values should be 1
  if (semistable && weights.some(weight => weight.length > 0 && Math.max(...weight) !== 1)) {
    return countonly ? 0 : []; // Return 0 or an empty array
  }

  const DG = new Graph(V.length + 2 * NE);               // Double graph with extra edges
  let VA = Array.from({ length: V.length }, () => []); // Vertex assignments: [link index, vertex index]
  let ei = 0;                                            //   for every principal vertex
  
  for (const e of E) {                              // Construct the edges of DG
    const i = e[0], j = e[1];
    for (const gcdVal of e.slice(2)) {             
      ei += 1;                                     
      DG.AddEdge(i, V.length + ei);                
      DG.AddEdge(V.length + ei, V.length + NE + ei);
      DG.AddEdge(V.length + NE + ei, j);           
  
      let pi = weights[i - 1].indexOf(gcdVal);       
      while (VA[i - 1].some(d => d[0] === pi)) {   
        pi += 1;                                   
      }
      VA[i - 1].push([pi, V.length + ei]);         
  
      let pj = weights[j - 1].indexOf(gcdVal);       
      while (VA[j - 1].some(d => d[0] === pj)) {   
        pj += 1;                                   
      }
      VA[j - 1].push([pj, V.length + NE + ei]);    
    }
  }

  vprint(`DG: V=${JSON.stringify(DG.Vertices())} E=${JSON.stringify(DG.Edges())}`);

  for (let i = 0; i < V.length; i++) { 
    VA[i].sort();                                   // Sort VA by link index
  }
  
  VA = VA.map(v => v.map(d => d[1]));               // Recoding VA to a sequence of vertex indices

  vprint(`VA: ${JSON.stringify(VA)}`)
  
  const done = [];                                  // Store already seen <chi, weight>
  const C = Array.from({ length: V.length }, () => []);
  const UsedShapeComps = [];
  
  for (let i = 0; i < V.length; i++) { 
    const chi = -V[i];    
    const weight = weights[i];
    const p = done.findIndex(d => d[0] === chi && ArraysEqual(d[1],weight));
    // vprint(`i=${i} p=${p}`);
  
    if (p > -1) { 
      C[i] = C[p]; 
      done.push(done[p]);  
      continue;         
    }
  
    done.push([chi, weight]);    
    const A = PrincipalTypes(chi, weight, {semistable});

    vprint(`chi=${chi} weight=${JSON.stringify(weight)} #A=${A.length}`)
  
    for (const c of A) {                           
      UsedShapeComps.push(c);                     
      for (const links of LinkOrderings(c.EdgeMultiplicities(), c.Multiplicity(), weight)) {
        C[i].push([UsedShapeComps.length, links]);
      }
    }
  }

  vprint(`UsedShapeComps: ${UsedShapeComps.toString()}`)
  vprint(`C (#C=${C.length}): ${JSON.stringify(C)}`)
    
  const graphs = {};                                  // Associative array shcompindices -> double graph
  for (const vdata of CartesianProduct(C)) {  
    const D = DG.Copy();  
    const shapecompindices = vdata.map(d => d[0]);
    const labels = [...shapecompindices, ...Array(2 * NE).fill(0)];
  
    for (let i = 0; i < vdata.length; i++) { 
      const d = vdata[i];
      const links = d[1];
      for (let j = 0; j < links.length; j++) { 
        labels[VA[i][j] - 1] = -links[j];     
      }
    }
  
    D.SetLabels(labels);  
    // vprint("labels = ",JSON.stringify(labels));
    
    const key = Array.from(new Set(shapecompindices)).sort((a,b) => a-b);
    // console.log(key);
    // const saveVERBOSE = VERBOSE;
    // VERBOSE = false;
    IncludeAssocIfNotIsomorphic(graphs, key, D, GraphIso); 
    // VERBOSE = saveVERBOSE;
  }

  vprint("keys",Object.keys(graphs).length);
  
  if (countonly) {                               // If countonly=True, return the reduction type count
    return Object.values(graphs).reduce((sum, graph) => sum + graph.length, 0);
  }

  // Construct reduction types from double graphs
  const families = new Set();  
  const redtypes = [];

  // Iterate over the keys and corresponding Dlist in the graphs object
  for (const [key, Dlist] of Object.entries(graphs)) {
    for (const D of Dlist) {
      const VD = D.Vertices(); 
      const L = D.GetLabels();
      const RV = V.map((_, i) => UsedShapeComps[L[i] - 1].Copy(i + 1));  

      for (let k = 1; k <= NE; k++) {
        let [e1, e2] = D.Edges(V.length + k);  
        let [i1, i2] = e1;
        let [i3, i4] = e2;
        const i = Math.min(i1, i2, i3, i4); 

        [e1, e2] = D.Edges(V.length + NE + k);  
        [i1, i2] = e1;
        [i3, i4] = e2;
        const j = Math.min(i1, i2, i3, i4); 

        const di = -L[V.length + k - 1];
        const dj = -L[V.length + NE + k - 1];

        MergeEdgeEndpoints(RV[i - 1], di, RV[j - 1], dj);
      }

      // Create a reduction type from RV and get its label
      const R = RedPrinListToReductionType(RV);
      const label = R.Label();

      // Check for duplicate families and add the label to families set
      if (families.has(label)) {
        throw new Error(`Already have family ${label}`);
      }

      families.add(label);
      redtypes.push(R);  // Append the reduction type to redtypes array
    }
  }

  return redtypes;
}

/*
for (var S of Shapes(3)) {
  console.log(ReductionTypes(S.shape).length);
}
*/
