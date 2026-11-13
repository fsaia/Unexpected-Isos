178,0
V,redlib,3
S,OuterSequence,"Unique outer sequence of type (m,d) for integers m>=1 and 1<d<m. It is of the form  [m,d,...,gcd(m,d)]  with every three consecutive terms d_(i-1), d_i, d_(i+1) satisfying d_(i-1) + d_(i+1) = d_i * (integer > 1). If includem:=false, exclude the starting point m from the sequence",0,2,0,0,0,0,0,0,0,148,,0,0,148,,82,-38,-38,-38,-38,-38
S,InnerSequence,"Unique inner sequence of type m1(d1-dk-n)m2, that is of the form [m1,d1,...,dk,m2] with n+1 terms  equal to gcd(m1,d1)=gcd(m2,dk) and satisfying the chain condition: for every three consecutive terms  d_(i-1), d_i, d_(i+1)  we have d_(i-1) + d_(i+1) = d_i * (integer > 1). If includem:=false, exclude the endpoints m1,m2 from the sequence",0,5,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,0,0,148,,0,0,148,,82,-38,-38,-38,-38,-38
S,MinimalDepth,"Minimal depth of an inner chain m1=d0,d1,d2,...,dk,m2=d(k+1) of P1s between principal components  of multiplicity m1, m2 and initial inner multiplicities d1,dk. The depth is defined as  -1 + number of times gcd(d1,...,dk) appears in the sequence.  For example, 5,4,3,2,1 is a valid inner sequence, and MinimalDepth(5,4,1,2) = -1 + 1 = 0",0,4,0,0,0,0,0,0,0,148,,0,0,148,,0,0,148,,0,0,148,,148,-38,-38,-38,-38,-38
S,SortMultiplicities,"Sort a sequence of multiplicities O by gcd with m (weight), then by o. This is how outer and edge multiplicities are sorted in reduction types",0,2,0,0,0,0,0,0,0,82,,0,0,148,,82,-38,-38,-38,-38,-38
S,DefaultMultiplicities,"Default edge multiplicities d1,d2 for a component with multiplicity m1, available outgoing multiplicities o1, and one with m2,o2. Parameter loop:boolean specifies whether it is a loop or links two different principal components",0,5,0,0,0,0,0,0,0,36,,0,0,82,,0,0,148,,0,0,82,,0,0,148,,148,148,-38,-38,-38,-38
T,RedCore,-,0
A,RedCore,3,m,O,chi
S,Core,Create a new core from principal multiplicity m and outgoing multiplicities O,0,2,0,0,0,0,0,0,0,82,,0,0,148,,RedCore,-38,-38,-38,-38,-38
S,IsCoercible,Coerce a principal component core,0,2,0,0,0,0,0,0,0,-1,,0,0,RedCore,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a principal component core",0,2,0,0,0,0,0,0,0,-1,,0,0,RedCore,,36,-38,-38,-38,-38,-38
S,Print,Print a principal component core through its label,0,2,0,0,1,0,0,0,0,298,,0,0,RedCore,,-38,-38,-38,-38,-38,-38
S,Multiplicity,Principal multiplicity m of a reduction type core,0,1,0,0,0,0,0,0,0,RedCore,,148,-38,-38,-38,-38,-38
S,OuterMultiplicities,"Outgoing multiplicities O of a reduction type core, sorted with SortMultiplicities",0,1,0,0,0,0,0,0,0,RedCore,,82,-38,-38,-38,-38,-38
S,Chi,"Euler characteristic of a reduction type core (m,O), chi = m(2-|O|) + sum_(o in O) gcd(o,m)",0,1,0,0,0,0,0,0,0,RedCore,,148,-38,-38,-38,-38,-38
S,Label,"Label of a reduction type core, for printing (or TeX if tex:=true)",0,1,0,0,0,0,0,0,0,RedCore,,298,-38,-38,-38,-38,-38
S,TeX,Print a reduction type core in TeX,0,1,0,0,0,0,0,0,0,RedCore,,298,-38,-38,-38,-38,-38
S,Cores,"Returns all reduction type cores (m,O) with given Euler characteristic chi<=2. When chi=2 there are infinitely many, so a bound on m must be given",0,1,0,0,0,0,0,0,0,148,,82,-38,-38,-38,-38,-38
T,RedChain,-,0
A,RedChain,10,class,index,Si,Sj,mi,mj,di,dj,depth,depthstr
S,IsCoercible,Coerce a reduction type edge,0,2,0,0,0,0,0,0,0,-1,,0,0,RedChain,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a reduction type edge",0,2,0,0,0,0,0,0,0,-1,,0,0,RedChain,,36,-38,-38,-38,-38,-38
S,Link,"Return an inner chain of a given class and specified invaraints: class = cLoop (loop), cD (D-link) or cEdge (inner chain between different principal types) Si = originating principal type S_i (by default unspecified (Si:=false)) mi, di = principal multiplicity of S_i and outgoing multiplicity of the chain from S_i Sj = target principal type S_j (by default unspecified (Sj:=false)) mj, dj = principal multiplicity of S_j and outgoing multiplicity of the chain from S_j so that the chain of P1s has multiplicities [mi,di,...,dj,mj] depth = depth of the chain (by default minimal (depth:=false)) index = index in the list of inner chains of a reduction type to which the chain belongs (by default unspecified (index:=false))",0,5,0,0,0,0,0,0,0,-1,,0,0,-1,,0,0,148,,0,0,148,,0,0,148,,RedChain,-38,-38,-38,-38,-38
S,Print,"Print a chain c like 'class mi,di - (depth) mj,dj', together with indices of Si, Sj and c if assigned",0,2,0,0,1,0,0,0,0,298,,0,0,RedChain,,-38,-38,-38,-38,-38,-38
S,Class,"Class of a RedChain - cLoop, cD or cEdge depending on the type of the chain",0,1,0,0,0,0,0,0,0,RedChain,,148,-38,-38,-38,-38,-38
S,Weight,"Weight od the chain = GCD of all elements (=GCD(mi,di)=GCD(mj,dj))",0,1,0,0,0,0,0,0,0,RedChain,,148,-38,-38,-38,-38,-38
S,Copy,Make a copy of an inner chain,0,1,0,0,0,0,0,0,0,RedChain,,RedChain,-38,-38,-38,-38,-38
S,Reverse,Reverse the direction of an inner chain,0,1,0,0,0,0,0,0,0,RedChain,,RedChain,-38,-38,-38,-38,-38
S,Index,"Index of the chain c used for ordering chains in a reduction type, and sorting in label",0,1,0,0,0,0,0,0,0,RedChain,,148,-38,-38,-38,-38,-38
S,SetDepth,Set depth and depth string of an inner chain e,0,2,0,0,1,0,0,0,0,148,,1,1,RedChain,,-38,-38,-38,-38,-38,-38
S,SetDepth,Set depth and depth string of an inner chain e to the minimal possible n (assumes n=False),0,2,0,0,1,0,0,0,0,36,,1,1,RedChain,,-38,-38,-38,-38,-38,-38
S,DepthString,"String set by SetDepths how c is printed, e.g. ""1"" or ""n""",0,1,0,0,0,0,0,0,0,RedChain,,298,-38,-38,-38,-38,-38
S,SetDepthString,"Set how c is printed, e.g. ""1"" or ""n""",0,2,0,0,1,0,0,0,0,-1,,0,0,RedChain,,-38,-38,-38,-38,-38,-38
T,RedPrin,-,0
A,RedPrin,9,m,g,C,O,L,gcd,core,chi,index
S,IsCoercible,Coerce a principal type (internal function),0,2,0,0,0,0,0,0,0,-1,,0,0,RedPrin,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a principal type (internal function)",0,2,0,0,0,0,0,0,0,-1,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,PrincipalType,"Create a new principal type from its primary invariants, and check integral self-intersection",0,6,0,0,0,0,0,0,0,82,,0,0,82,,0,0,82,,0,0,82,,0,0,148,,0,0,148,,RedPrin,-38,-38,-38,-38,-38
S,PrincipalTypes,"Find all possible principal types S with a given core C and Euler characteristic chi. Return a sequence of them. If withweights:=true, also return a sequence weights representing all possible Weight(S)",0,2,0,0,0,0,0,0,0,RedCore,,0,0,148,,82,82,-38,-38,-38,-38
S,PrincipalTypes,"Find all possible principal types S with a given Euler characteristic chi. Return a sequence of them. If withweights:=true, also return a sequence weights representing all possible Weight(S)",0,1,0,0,0,0,0,0,0,148,,82,82,-38,-38,-38,-38
S,PrincipalTypes,"All possible principal types with a given Euler characteristic chi and GCDs of edge multiplicities. If withweights:=true, also returns [weight] as a second parameter (like all other PrincipalTypes instances)",0,2,0,0,0,0,0,0,0,82,,0,0,148,,82,-38,-38,-38,-38,-38
S,Multiplicity,Principal multiplicity m of a principal type,0,1,0,0,0,0,0,0,0,RedPrin,,148,-38,-38,-38,-38,-38
S,GeometricGenus,"Geometric genus g of a principal type S=(m,g,O,...)",0,1,0,0,0,0,0,0,0,RedPrin,,148,-38,-38,-38,-38,-38
S,Index,"Index of the principal component in a reduction type, 0 if freestanding",0,1,0,0,0,0,0,0,0,RedPrin,,148,-38,-38,-38,-38,-38
S,Chains,"Sequence of chains of type RedChain originating in S. By default, all (loops, D-links, edge)  are returned, unless class is specified",0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,OuterMultiplicities,"Sequence of outer multiplicities S`O of a principal type, sorted",0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,EdgeMultiplicities,"Sequence of edge multiplicities of a principal type, sorted",0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,InnerMultiplicities,"Sequence of inner multiplicities S`L of a principal type, sorted as in label",0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,Loops,Sequence of chains in S representing loops (class cLoop),0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,DLinks,Sequence of chains in S representing D-links (class cD),0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,GCD,"Return GCD(m,O,L) for a principal type",0,1,0,0,0,0,0,0,0,RedPrin,,148,-38,-38,-38,-38,-38
S,Core,"Core of a principal type - no genus, all non-zero inner multiplicities put to O, and gcd(m,O)=1",0,1,0,0,0,0,0,0,0,RedPrin,,RedCore,-38,-38,-38,-38,-38
S,Chi,"Euler characteristic chi of a principal type (m,g,O,Lloops,LD,Ledge), chi = m(2-2g-|O|-|L|) + sum_(o in O) gcd(o,m), where L consists of all the inner multiplicities in Lloops (2 from each), LD (1 from each), Ledge (1 from each)",0,1,0,0,0,0,0,0,0,RedPrin,,148,-38,-38,-38,-38,-38
S,Weight,Outgoing link pattern of a principal type = multiset of GCDs of edges with m,0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,Copy,Make a copy of a principal type,0,1,0,0,0,0,0,0,0,RedPrin,,RedPrin,-38,-38,-38,-38,-38
S,Score,"Sequence [chi,m,-g,#edges,#Ds,#loops,#O,O,loops,Ds,edges,loopdepths,Ddepths] that determines the score of a principal type, and characterises it uniquely",0,1,0,0,0,0,0,0,0,RedPrin,,82,-38,-38,-38,-38,-38
S,PrincipalType,Create a principal type S from its score sequence w (=Score(S)),1,0,1,82,0,148,1,0,0,0,0,0,0,0,82,,RedPrin,-38,-38,-38,-38,-38
S,eq,Compare two principal types by their score,0,2,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,lt,Compare two principal types by their score,0,2,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,le,Compare two principal types by their score,0,2,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,gt,Compare two principal types by their score,0,2,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,ge,Compare two principal types by their score,0,2,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,36,-38,-38,-38,-38,-38
S,Sort,Sort principal types by their score,1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,82,-38,-38,-38,-38,-38
S,Sort,Sort principal types by their score,1,0,1,82,0,RedPrin,1,0,0,1,0,0,1,1,82,,-38,-38,-38,-38,-38,-38
S,Label,"Plain, TeX or HTML label of a principal type.  Setting tex:=true prints the tex label, in redtype... format by default, unless wrap:=false.  Setting html:=true prints the html label.  Setting edge:=true prints outgoing edges as well (standalone principal type)",0,1,0,0,0,0,0,0,0,RedPrin,,298,-38,-38,-38,-38,-38
S,Print,"Print a principal type as an ascii label or as an evaluatable Magma string (when level=""Magma"")",0,2,0,0,1,0,0,0,0,298,,0,0,RedPrin,,-38,-38,-38,-38,-38,-38
S,TeX,"TeX a principal type as a tikz arc with outer and inner lines, loops and Ds.  label:=true puts its label underneath standalone:=true wraps it in tikz",0,1,0,0,0,0,0,0,0,RedPrin,,298,-38,-38,-38,-38,-38
S,TeX,"TeX a list of principal types as a rectangular table in a tikz picture. label:=true puts principal type label underneath. sort:=true sorts the types by Score first, in decreasing order. yshift:=""default"" changes y by 2 (with label) / 1.2 (without label) after every row width:=10 puts 10 principal types in every row scale:=0.8 controls tikz picture global scale",1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,298,-38,-38,-38,-38,-38
T,RedShape,-,0
A,RedShape,5,G,V,E,D,label
S,IsCoercible,"Coerce a shape - internal function, returns false",0,2,0,0,0,0,0,0,0,-1,,0,0,RedShape,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a shape - internal function, returns false",0,2,0,0,0,0,0,0,0,-1,,0,0,RedShape,,36,-38,-38,-38,-38,-38
S,Print,"Print a shape as Shape(vertices,edges) so that the shape can be reconstructed. Vertices are '-chi'  of principal types, and edges are of the form [from_vertex,to_vertex,gcd1,gcd2,...] with gcd_i the  gcd's of the inner chains between principal types",0,2,0,0,1,0,0,0,0,298,,0,0,RedShape,,-38,-38,-38,-38,-38,-38
S,TeX,"Tikz picture for a shape S of a reduction graph, or, if boundingbox:=true, returns S,x1,y1,x2,y2, where the last four define the bounding box",0,1,0,0,0,0,0,0,0,RedShape,,298,402,402,402,402,-38
S,Shape,"Constructs a graph shape from the data V,E as in shapes*.txt data files: V = sequence of -chi's for individual components E = list of edges v_i->v_j of the form [i,j,edgegcd1,edgegcd2,...]",2,0,1,82,0,148,1,1,82,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,RedShape,-38,-38,-38,-38,-38
S,IsIsomorphic,Check whether two shapes are isomorphic via their double graphs,0,2,0,0,0,0,0,0,0,RedShape,,0,0,RedShape,,36,-38,-38,-38,-38,-38
S,Graph,Labelled underlying graph G of the shape,0,1,0,0,0,0,0,0,0,RedShape,,105,-38,-38,-38,-38,-38
S,DoubleGraph,"Vertex-labelled double graph D of the shape, used for isomorphism testing",0,1,0,0,0,0,0,0,0,RedShape,,105,-38,-38,-38,-38,-38
S,Vertices,"Vertices of the underlying graph Graph(S), as an indexed set",0,1,0,0,0,0,0,0,0,RedShape,,151,-38,-38,-38,-38,-38
S,Edges,"Edges of the underlying graph Graph(S), an an indexed set",0,1,0,0,0,0,0,0,0,RedShape,,151,-38,-38,-38,-38,-38
S,#,Number of vertices in the graph G underlying a shape,0,1,0,0,0,0,0,0,0,RedShape,,148,-38,-38,-38,-38,-38
S,Chi,Euler characteristic chi(v_i)<=0 of ith vertex of the graph G in a shape S,0,2,0,0,0,0,0,0,0,309,,0,0,RedShape,,148,-38,-38,-38,-38,-38
S,Weights,"Weights of a vertex v that together with chi determine the vertex type (chi, weights)",0,2,0,0,0,0,0,0,0,309,,0,0,RedShape,,148,-38,-38,-38,-38,-38
S,Chi,"Total Euler characteristic of a graph shape chi<=0, sum over chi's of vertices",0,1,0,0,0,0,0,0,0,RedShape,,148,-38,-38,-38,-38,-38
S,VertexLabels,"Sequence of -chi's for individual components of the shape S so that S=Shape(VertexLabels(S),EdgeLabels(S))",0,1,0,0,0,0,0,0,0,RedShape,,82,-38,-38,-38,-38,-38
S,EdgeLabels,"List of edges v_i->v_j of the form [i,j,edgegcd] so that S=Shape(VertexLabels(S),EdgeLabels(S))",0,1,0,0,0,0,0,0,0,RedShape,,82,-38,-38,-38,-38,-38
S,ScoreIsSmaller,"Compares two sequences of integers, and returns ""<"", "">"", ""l"", ""s"", ""="": <=smaller : new has smaller score than best >=greater : new has greater score l=longer : new and best coincide until #best, and new is longer s=shorter : new and best coincide until #new, and new is shorter ==identical : new=best",0,2,0,0,0,0,0,0,0,82,,0,0,82,,298,-38,-38,-38,-38,-38
S,MinimumScorePaths,"Minimum score paths for a labelled undirected graph (e.g. double graph underlying shape) returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism)  and I=list of possible vertex index sequences For example for a rectangular loop G with all vertex chis=-1 and edges as follows V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is  W = [<0,[-1],false>,<0,[-1],false>,<0,[-1],false>,<0,[1,1],false>,<0,[-1],false>, <0,[2],false>,<1,[-1],true>] The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded T = [[3,2,1,6,4,5,3]]",0,1,0,0,0,0,0,0,0,105,,82,82,-38,-38,-38,-38
S,Label,"Graph label based on a minimum score path, determines G up to isomorphism",0,1,0,0,0,0,0,0,0,105,,298,-38,-38,-38,-38,-38
S,MinimumScorePaths,"Minimum score paths for a shape, computed through its double graph and refers  to its vertices and edges.  Returns W=bestscore [<index, v_label, jump>,...] (characterizes D up to isomorphism)  and I=list of possible vertex index sequences For example for a rectangular loop G with all vertex chis=-1 and edges as follows V:=[1,1,1,1]; E:=[[1,2,1],[2,3,1],[3,4,2],[1,4,1,1]]; S:=Shape(V,E);  the double graph D has 6 vertices and 6 edges in a loop, and here minimum score W is  W = [<0,[-1],false>,<0,[-1],false>,<0,[-1],false>,<0,[1,1],false>,<0,[-1],false>, <0,[2],false>,<1,[-1],true>] The unique trail T[1] (generally Aut D-torsor) is D.3->D.2->D.1->...->D.3, encoded T = [[3,2,1,6,4,5,3]]",0,1,0,0,0,0,0,0,0,RedShape,,82,82,-38,-38,-38,-38
S,GenerateAllShapesInGenus,"Generate all possible shapes in a given genus and write them to a data file.  Currently computed for 1<=genus<=6 with numbers 1, 5, 35, 310, 3700, 56253 [growth factors 5,7,9,12,15]",0,1,0,0,1,0,0,0,0,148,,-38,-38,-38,-38,-38,-38
S,Shapes,"All shapes in a given genus, assuming they were created already by GenerateAllShapesInGenus and numbers computed and stored in the log file",0,1,0,0,0,0,0,0,0,148,,82,-38,-38,-38,-38,-38
T,RedType,-,0
A,RedType,7,C,L,family,score,shape,bestscore,besttrail
S,IsCoercible,Coerce a reduction type,0,2,0,0,0,0,0,0,0,-1,,0,0,RedType,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a reduction type",0,2,0,0,0,0,0,0,0,-1,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,Print,Print a reduction type through its Label,0,2,0,0,1,0,0,0,0,298,,0,0,RedType,,-38,-38,-38,-38,-38,-38
S,ReductionType,"Construct a reduction type from a sequence of components, their invariants, and chains of P1s: m = sequence of multiplicities of components c_1,...,c_k g = sequence of their geometric genera O = outgoing multiplicities of outer chains, one sequence for each component L = inner chains, of the form [[i,j,di,dj,n],...] - inner chain from c_i to c_j with multiplicities m[i],di,...,dj,m[j], of depth n n can be omitted, and chain data [i,j,di,dj] is interpreted as having minimal possible depth",4,0,1,82,0,148,1,1,82,0,148,2,1,82,0,82,3,1,82,0,82,4,0,0,0,0,0,0,0,82,,0,0,82,,0,0,82,,0,0,82,,RedType,-38,-38,-38,-38,-38
S,ReductionTypes,"All reduction types in genus g<=6 or their count (if countonly:=true; faster).  semistable:=true restricts to semistable types, elliptic:=true (when g=1) to Kodaira types of elliptic curves",0,1,0,0,0,0,0,0,0,148,,82,-38,-38,-38,-38,-38
S,ReductionTypes,"Sequence of reduction types with a given shape. If countonly=true, only count their number",0,1,0,0,0,0,0,0,0,RedShape,,82,-38,-38,-38,-38,-38
S,Chi,Total Euler characteristic of R,0,1,0,0,0,0,0,0,0,RedType,,148,-38,-38,-38,-38,-38
S,Genus,Total genus of R,0,1,0,0,0,0,0,0,0,RedType,,148,-38,-38,-38,-38,-38
S,IsFamily,"Returns true if R is a reduction family, false if it is a single reduction type",0,1,0,0,0,0,0,0,0,RedType,,36,-38,-38,-38,-38,-38
S,IsGood,true if comes from a curve wih good reduction,0,1,0,0,0,0,0,0,0,RedType,,36,-38,-38,-38,-38,-38
S,IsSemistable,true if comes from a curve with semistable reduction (all (principal) components of an mrnc model have multiplicity 1),0,1,0,0,0,0,0,0,0,RedType,,36,-38,-38,-38,-38,-38
S,IsSemistableTotallyToric,true if comes from a curve with semistable totally toric reduction (semistable with no positive genus components),0,1,0,0,0,0,0,0,0,RedType,,36,-38,-38,-38,-38,-38
S,IsSemistableTotallyAbelian,true if comes from a curve with semistable totally abelian reduction (semistable with no loops in the dual graph),0,1,0,0,0,0,0,0,0,RedType,,36,-38,-38,-38,-38,-38
S,TamagawaNumber,"Tamagawa number of the curve with a given reduction type, over an algebraically closed residue field (in other words, totally split)",0,1,0,0,0,0,0,0,0,RedType,,148,-38,-38,-38,-38,-38
S,PrincipalTypes,Principal types (vertices) R of the reduction type R,0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,#,"Number of principal types; used as an index in Chi, InnerMultiplicities, OuterMultiplicities",0,1,0,0,0,0,0,0,0,RedType,,148,-38,-38,-38,-38,-38
S,!!,Principal type number i in the reduction type R,0,2,0,0,0,0,0,0,0,148,,0,0,RedType,,RedPrin,-38,-38,-38,-38,-38
S,PrincipalType,"Principal type number i in the reduction type R, same as R!!i",0,2,0,0,0,0,0,0,0,148,,0,0,RedType,,RedPrin,-38,-38,-38,-38,-38
S,InnerChains,"Return all the inner chains in R, including loops and D-links, as a sequence SeqEnum[RedChain], sorted as in label",0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,EdgeChains,"Return all the inner chains in R between different principal components, as a sequence SeqEnum[RedChain], sorted as in label",0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,Multiplicities,Sequence of multiplicities of principal types,0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,Genera,Sequence of geometric genera of principal types,0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,GCD,GCD detecting non-primitive types,0,1,0,0,0,0,0,0,0,RedType,,148,-38,-38,-38,-38,-38
S,Shape,"The shape of the reduction type R. Every principal type is a vertex that only remembers its Euler characteristic, and every edge only remembers the gcd of the corresponding inner chain",0,1,0,0,0,0,0,0,0,RedType,,RedShape,-38,-38,-38,-38,-38
S,Score,"Score of a reduction type, used for comparison and sorting",0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,eq,Compare two reduction types by their score,0,2,0,0,0,0,0,0,0,RedType,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,lt,Compare two reduction types by their score,0,2,0,0,0,0,0,0,0,RedType,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,gt,Compare two reduction types by their score,0,2,0,0,0,0,0,0,0,RedType,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,le,Compare two reduction types by their score,0,2,0,0,0,0,0,0,0,RedType,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,ge,Compare two reduction types by their score,0,2,0,0,0,0,0,0,0,RedType,,0,0,RedType,,36,-38,-38,-38,-38,-38
S,Sort,Sort reduction types by their score,1,0,1,82,0,RedType,1,0,0,0,0,0,0,0,82,,82,-38,-38,-38,-38,-38
S,Sort,Sort reduction types by their score,1,0,1,82,0,RedType,1,0,0,1,0,0,1,1,82,,-38,-38,-38,-38,-38,-38
S,ReductionType,Create a reduction type from a full dual mrnc graph or return false if G does not come from a reduction type of positive genus,0,1,0,0,0,0,0,0,0,GrphDual,,RedType,-38,-38,-38,-38,-38
S,ReductionFamily,Create a reduction family from a full dual mrnc graph or return false if G does not come from a reduction type of positive genus,0,1,0,0,0,0,0,0,0,GrphDual,,RedType,-38,-38,-38,-38,-38
S,ReductionFamily,Family of types in which R lives,0,1,0,0,0,0,0,0,0,RedType,,RedType,-38,-38,-38,-38,-38
S,ReductionType,Representative of a family of reduction types of minimal depths,0,1,0,0,0,0,0,0,0,RedType,,RedType,-38,-38,-38,-38,-38
S,ReductionFamily,Construct a reduction type from a string label,0,1,0,0,0,0,0,0,0,298,,RedType,-38,-38,-38,-38,-38
S,Shape,"Construct a shape from a sequence C of principal types, provided all inner chains between them have been created. As a a second parameter returns the sequence of all inner chains in C, including loops and D-links",1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,RedShape,82,-38,-38,-38,-38
S,EdgesScore,"Score associated to edges from ith to jth component specified by a sequence of edges E, used in Label when determining the canonical minimal path",1,0,1,82,0,RedChain,3,0,0,0,0,0,0,0,RedPrin,,0,0,RedPrin,,0,0,82,,82,-38,-38,-38,-38,-38
S,EdgesScore,"Score associated to edges from ith to jth component of R, used in Label when determining the canonical minimal path",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,RedType,,82,-38,-38,-38,-38,-38
S,ReductionType,"Construct a reduction type from a sequence C of principal types, provided all links chains between  them are complete. Computes best path (for label) and initialises all indices",1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,RedType,-38,-38,-38,-38,-38
S,Links,All inner chains between principal types (including loops and D-links),1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,82,-38,-38,-38,-38,-38
S,DualGraph,"Construct a dual graph from a sequence C of principal types, with all links initialised",1,0,1,82,0,RedPrin,1,0,0,0,0,0,0,0,82,,RedType,-38,-38,-38,-38,-38
S,DualGraph,"Full dual graph from a reduction type, possibly with variable length edges",0,1,0,0,0,0,0,0,0,RedType,,GrphDual,-38,-38,-38,-38,-38
S,Label,Return canonical string label of a reduction type. tex:=true gives a TeX-friendly label (redtype ...)  html:=true gives a HTML-friendly label (<span...>...</span>)  wrap:=false keeps the format above but removes redtype wrapping forcesubs:=true forces lengths of chains and loops to be always printed (usually in round brackets) forcesups:=true forces outgoing chain multiplicities to be always printed (in curly brackets),0,1,0,0,0,0,0,0,0,RedType,,298,-38,-38,-38,-38,-38
S,ReductionType,Construct a reduction type from a string label,0,1,0,0,0,0,0,0,0,298,,RedType,-38,-38,-38,-38,-38
S,LabelRegex,"Returns a regular expression that recognises reduction types in the same family as R and captures  the corresponding edge depths. For example,  LabelRegex(ReductionType(""Dg1_1"")); returns ^Dg1_([0-9]+)$, which is a regular expression that matches Dg1_n for any n>=0 and returns n  in the captured group. Flag magma:=true makes the returned regex compatible with Magma's Regexp  function (which is old V8) but may have brackets around the returned integers. Setting magma:=false makes it compatible with all recent regex implementations, and only returns pure integers in captured groups",0,1,0,0,0,0,0,0,0,RedType,,298,-38,-38,-38,-38,-38
S,TeX,"TikZ representation of a reduction type, as a graph with PrincipalTypes (principal components with chi>0) as vertices, and edges for inner chains.  oneline:=true removes line breaks.  forcesups:=true and/or forcesubs:=true shows edge decorations (outgoing multiplicities and/or chain depths) even when they are default",0,1,0,0,0,0,0,0,0,RedType,,298,-38,-38,-38,-38,-38
S,SetDepths,"Set depths for DualGraph and Label to be determined by depth function. depth has to be of the form function depth(e::RedChain) -> integer/string to show how the depth in the edge is to be printed For example, f(e) = e`depth [ original as in SetDepths(R,true) ] f(e) = MinimalDepth(e`mi,e`di,e`mj,e`dj) [ minimal as in SetDepths(R,false) ] f(e) = Sprintf(""n_%o"",e`index) [ ""n_1"",""n_2"",...]",0,2,0,0,1,0,0,0,0,41,,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,SetDepths,"Set depths for DualGraph and Label to a sequence, e.g. S=[""m"",""n"",""2""]",0,2,0,0,1,0,0,0,0,82,,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,SetVariableDepths,"Set depths for DualGraph and Label to i->""n_i""",0,1,0,0,1,0,0,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,SetOriginalDepths,"Remove depths set by SetDepths, so that original ones are printed by Label and other functions",0,1,0,0,1,0,0,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,SetMinimalDepths,"Set depths to minimal ones in the family (MinimalDepth = -1,0 or 1) for every edge",0,1,0,0,1,0,0,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,SetFamilyDepths,"Set depths to family notation (x for loop depth placeholders, no depths otherwise) for every edge",0,1,0,0,1,0,0,1,1,RedType,,-38,-38,-38,-38,-38,-38
S,GetDepths,Return depths (string sequence) set by SetDepths or originals if not changed from defaults,0,1,0,0,0,0,0,0,0,RedType,,82,-38,-38,-38,-38,-38
S,NamikawaUeno,"returns Namikawa-Ueno reduction type pair nutype, page if unique, or false, [<pottype,guess,page>,...] if there are several depending  on the potential semistable type (I,II,III,...,VII)",0,1,0,0,0,0,0,0,0,RedType,,298,148,-38,-38,-38,-38
S,NamikawaUenoFamily,"For a reduction type with variable names (say SetLengths(~R,func<c|[""n"",""m"",""r""][c`index]>)) return the Namikawa-Ueno type pair 'nu, page' if unique, or false, [<pottype,guess,page>,...] if there are several depending  on the potential semistable type (I,II,III,...,VII)",0,1,0,0,0,0,0,0,0,-1,,298,148,-38,-38,-38,-38
S,HasAlphaType,"true if a Namikawa-Ueno type (genus 2) that has an -alpha variant. If yes, returns true, TeX family label for R, TeX N-U family label, N-U page",0,1,0,0,0,0,0,0,0,RedType,,36,298,298,148,-38,-38
