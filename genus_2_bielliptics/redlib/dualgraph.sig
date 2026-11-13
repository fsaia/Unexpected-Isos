178,0
T,GrphDualVert,-,0
A,GrphDualVert,8,name,g,m,aliases,texname,singular,pts,singpts
T,GrphDual,-,0
A,GrphDual,6,V,G,P,C,specialchains,texsettings
S,IsCoercible,Coerce a dual graph vertex,0,2,0,0,0,0,0,0,0,-1,,0,0,GrphDualVert,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a dual graph vertex",0,2,0,0,0,0,0,0,0,-1,,0,0,GrphDualVert,,36,-38,-38,-38,-38,-38
S,Print,Print a dual graph vertex,0,2,0,0,1,0,0,0,0,298,,0,0,GrphDualVert,,-38,-38,-38,-38,-38,-38
S,IsCoercible,Coerce a Dual Graph,0,2,0,0,0,0,0,0,0,-1,,0,0,GrphDual,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a Dual Graph",0,2,0,0,0,0,0,0,0,-1,,0,0,GrphDual,,36,-38,-38,-38,-38,-38
S,Print,Print a Dual Graph,0,2,0,0,1,0,0,0,0,298,,0,0,GrphDual,,-38,-38,-38,-38,-38,-38
S,DualGraph,"Construct a dual graph from a sequence of n multiplicities of components, sequence of n genera of components and sequences of edges. Each edge is either  [i,j] - intersection point between component #i and component #j (1<=i,j<=n) [i,0,d1,d2,...] - open chain from component #i (1<=i<=n) [i,j,d1,d2,...] - link chain from component #i to component #j (1<=i,j<=n) This can be used to reconstruct a dual graph printed with Sprint(G,""Magma""). comptexnames determines the names of principal components in TeX (v`texname), and each component for which texname<>"""" is considered principal when drawing dual graphs. The options are  comptexnames::MonStgElt - string such as ""c%o"" which assigns names for principal components (and only those)  among those specified by m_i, g_i  comptexnames::SeqEnum - sequence of strings for all components specified by m_i, g_i comptexnames::UserFunction - function i->string that defines such a sequence",3,0,1,82,0,148,1,1,82,0,148,2,1,82,0,82,3,0,0,0,0,0,0,0,82,,0,0,82,,0,0,82,,GrphDual,-38,-38,-38,-38,-38
S,DualGraph,Create an empty dual graph. Assumes components and chains will be added later,0,0,0,0,0,0,0,GrphDual,-38,-38,-38,-38,-38
S,AddComponent,"Add a vertex to a dual graph corresponding to a component with a given name c, genus, multiplicity and optional texname. If singular:=true, the whole graph is marked as singular (no associated reduction type) and the component is drawn in red",0,4,0,0,1,0,0,0,0,148,,0,0,148,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddComponent,"Add a vertex to a dual graph corresponding to a component, with given genus and multiplicity. If singular:=true, the whole graph is marked as singular (no associated reduction type) and the component is drawn in red. Sets and returns component name in c if c=""""",0,4,0,0,1,0,0,0,0,148,,0,0,148,,1,1,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddComponent,Add a no-named vertex to a dual graph corresponding to a component with a genus and multiplicity,0,3,0,0,1,0,0,0,0,148,,0,0,148,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddChain,Add a chain of P1s with multiplicities (possibly empty) between components c1 and c2,1,3,1,82,0,148,4,0,0,1,0,0,0,0,82,,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddMinimalInnerChain,"Add a chain of P1s between c1 and c2 (open-ended if c2="""") with multiplicities d times denominators of minimal continued fractions from a to b. family:=true or family:=""$n$"" shows multiplicity d components as variable chains of a given length (none or $n$)",0,6,0,0,1,0,0,0,0,267,,0,0,267,,0,0,148,,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddMinimalOuterChain,Add an open-ended chain of P1s from c with multiplicities d times denominator of minimal continued fractions from a to an integer Floor(d*a-1)/d,0,4,0,0,1,0,0,0,0,267,,0,0,148,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddSingularPoint,"Add a standard singular point point = ""redbullet"" or ""bluenode"" on a component c of a dual graph",0,3,0,0,1,0,0,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddSpecialPoint,"Add a special point on a component c of a dual graph. label is a TeX code for how the point is marked, and style is the corresponding tikz style. By default such a point marks the dual graph as singular (singular:=true)",0,4,0,0,1,0,0,0,0,298,,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddSingularChain,"Add a singular chain in given tikz style with multiplicities mults (sequence of integers or strings)  between c1 and c2; use c2=""0"" for an open chain; default style=""red""",0,3,0,0,1,0,0,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,AddVariableChain,"Add a chain where some parts have variable length, e.g. [* 1,2,<3,""$n$"">,<4,""$m$"">,3,2,1 *]",0,4,0,0,1,0,0,0,0,168,,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,#,Number of vertices (components) in the dual graph,0,1,0,0,0,0,0,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,IsSingular,"Check if G has any singular components or points, or special chains. If yes, no self-intersections  will be checked components contracted (so MakeMRNC does nothing)",0,1,0,0,0,0,0,0,0,GrphDual,,36,-38,-38,-38,-38,-38
S,IsConnected,True if underlying graph is connected,0,1,0,0,0,0,0,0,0,GrphDual,,36,-38,-38,-38,-38,-38
S,ConnectedComponents,Connected components of a dual graph as a dual graph,0,1,0,0,0,0,0,0,0,GrphDual,,83,-38,-38,-38,-38,-38
S,HasIntegralSelfIntersections,Are all component self-intersections integers,0,1,0,0,0,0,0,0,0,GrphDual,,36,-38,-38,-38,-38,-38
S,AbelianDimension,Sum of genera of components),0,1,0,0,0,0,0,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,ToricDimension,Number of loops in the dual graph,0,1,0,0,0,0,0,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,IntersectionMatrix,"Intersection matrix for a dual graph, whose entries are pairwise intersection numbers of the components",0,1,0,0,0,0,0,0,0,GrphDual,,177,-38,-38,-38,-38,-38
S,AddEdge,Add an edge between two components in a dual graph,0,3,0,0,1,0,0,0,0,298,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,ContractComponent,"Contract a component in the dual graph, assuming it meets one or two components, and has genus 0",0,2,0,0,1,0,0,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,MakeMRNC,"Contract all genus 0 components of self-intersection -1, resulting in a minimal model with normal crossings",0,1,0,0,1,0,0,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,Components,"Names of all components of G, e.g. ""1"",""2"",""c3"",""c4"",""c5""",0,1,0,0,0,0,0,0,0,-1,,82,-38,-38,-38,-38,-38
S,HasComponent,"True if the dual graph has a component with a given c, in which case also return its index",0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,36,298,-38,-38,-38,-38
S,AssertHasComponent,Assert that the dual graph a component with a given c and return its index,0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,AddAlias,"Add alias to a component c, e.g ""2+"" for ""2""",0,3,0,0,1,0,0,0,0,-1,,0,0,298,,1,1,GrphDual,,-38,-38,-38,-38,-38,-38
S,VertexByLabel,Find a vertex in an abstract graph by its label,0,2,0,0,0,0,0,0,0,298,,0,0,325,,309,-38,-38,-38,-38,-38
S,VertexByLabel,Find a vertex in the abstract graph underlying G by its label,0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,309,-38,-38,-38,-38,-38
S,Genus,Genus of a component in a dual graph,0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,Genus,Genus of a component in a dual graph,0,2,0,0,0,0,0,0,0,309,,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,Multiplicity,Multiplicity of a component in a dual graph,0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,Multiplicity,Multiplicity of a component in a dual graph,0,2,0,0,0,0,0,0,0,309,,0,0,GrphDual,,148,-38,-38,-38,-38,-38
S,Intersection,"Compute intersection of two components in a dual graph, or self-intersection if c1=c2",0,3,0,0,0,0,0,0,0,298,,0,0,298,,0,0,GrphDual,,267,-38,-38,-38,-38,-38
S,Neighbours,"Neighbour vertices of a component, one for every edge (and two for every loop)",0,2,0,0,0,0,0,0,0,309,,0,0,GrphDual,,82,-38,-38,-38,-38,-38
S,Neighbours,"Neighbour vertices of a component, one for every edge (and two for every loop)",0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,82,-38,-38,-38,-38,-38
S,IncidentMultiplicities,"Multiplicties of a component and adjacent components (e.g. 6,[1,2,3]) for type II)",0,2,0,0,0,0,0,0,0,298,,0,0,GrphDual,,148,82,-38,-38,-38,-38
S,Vertices,Vertices of an underlying multigraph for a dual graph,0,1,0,0,0,0,0,0,0,GrphDual,,151,-38,-38,-38,-38,-38
S,Edges,Edges of an underlying multigraph for a dual graph,0,1,0,0,0,0,0,0,0,GrphDual,,151,-38,-38,-38,-38,-38
S,PrincipalComponents,Return a list of indices of principal components. A vertex is a principal component if either its genus is greater than 0 or it has 3 or more incident edges (counting loops twice). In the exceptional case [d]I_n one component is declared principal. shownamed:=true forces all principal components that were set up with non-empty texname to be viewed (and drawn) as principal,0,1,0,0,0,0,0,0,0,GrphDual,,82,-38,-38,-38,-38,-38
S,ChainsOfP1s,"Sequence of tuples [<v0,v1,[chain multiplicities]>] for chains of P1s between principal components. shownamed:=true forces all principal components that were set up with non-empty texname to be viewed (and drawn) as principal",0,1,0,0,0,0,0,0,0,GrphDual,,82,-38,-38,-38,-38,-38
