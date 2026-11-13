/*
(c) Tim Dokchitser, redlib library, v3.0, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/
[F9] manual chapter.tex %CHAPTER %ENDCHAPTER

Drawing planar graphs 

*
* IMPLEMENTS
*
*
* Main functions
*
intrinsic StandardGraphCoordinates(G::GrphUnd: attempts:=10) -> SeqEnum, SeqEnum, SeqEnum                       [1822]
intrinsic TeXGraph(G::GrphUnd: x:="default", y:="default", labels:="default", scale:=0.8, xscale:=1, yscale:=1,   [1861]
  vertexlabel:="default", edgelabel:="default", vertexnodestyle:="default", edgenodestyle:="default", edgestyle:="default") -> MonStgElt
*/


import "mmylib.m": Q, GraphLongestChain, SortBy, DelSpaces, PrintSequence, writepiece, 
  GetQAttribute, SetQAttribute, Last, IncidentVertices, PrintReal, DelSymbols, trim;



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


function SegmentsIntersect(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y: eps:=0)
  s1_x := p1_x-p0_x;     
  s1_y := p1_y-p0_y;
  s2_x := p3_x-p2_x;     
  s2_y := p3_y-p2_y;
  den:=(-s2_x*s1_y+s1_x*s2_y);
  if den eq 0 then return false; end if;               // collinear
  s := (-s1_y*(p0_x-p2_x)+s1_x*(p0_y-p2_y)) / den;
  t := ( s2_x*(p0_y-p2_y)-s2_y*(p0_x-p2_x)) / den;
  return (s ge -eps and s le 1+eps and t ge -eps and t le 1+eps);
end function;


function PlanarCoordinates(G: attempts:=10)
  rndsave:=GetSeed();
  SetSeed(0);
  
  V:=Vertices(G);
  c:=[Index(v): v in GraphLongestChain(G)];
  
  // Randomise original coordinates
  
  mincount:=Infinity();
  for attempt:=1 to attempts do
    x:=[Random(1000)/100: v in V];
    y:=[Random(1000)/100: v in V];
    
    // Fix coordinates of a longest chain
    for i:=1 to #c do
      x[c[i]]:=5-#c+2*i;
      y[c[i]]:=5;
    end for;
    
    c1:=Random(10,20)/10;      // attract
    c2:=Random(8,13)/10;      // log factor
    c3:=Random(8,12)/10;      // repel
    c4:=0.1;    // step size
    M:=100;     // number of steps
    
    A:=VectorSpace(RealField(),2);
    Pnew:=[A![x[i],y[i]]: i in [1..#V]];
    
    // Propagate forces M steps to rearrange the graph
    for step:=1 to M do
      P:=Pnew;
      for i->v in V do
        if i in c then continue; end if;       // c is fixed
        f:=A!0;         // force acting on v
        Pv:=P[i];
        N:=Neighbours(v);
        for w in V do
          if w eq v then continue; end if;
          Pw:=P[Index(w)];
          d:=Max(Sqrt(Norm(Pv-Pw)),0.3);
          if w in N
            then f+:=c1*Log(d/c2)*(Pw-Pv)/d;    // spring force c1*log(d/c2)
          end if;
          f-:=c3/d^2 *(Pw-Pv)/d;            // repel non-neighbouring vertices c3/d (original c3/sqrt(d))
        end for;
        Pnew[i]:=P[i]+c4*f;
      end for;
    end for;
    
    x:=[Eltseq(d)[1]: d in Pnew];
    y:=[Eltseq(d)[2]: d in Pnew];
        
    // Count intersections
    
    count:=0;
    for i->e1, j->e2 in Edges(G) do
      if j le i or not IsEmpty(EndVertices(e1) meet EndVertices(e2)) then continue; end if;
      v0,v1:=Explode([Index(v): v in EndVertices(e1)]);
      v2,v3:=Explode([Index(v): v in EndVertices(e2)]);
      count+:=SegmentsIntersect(x[v0],y[v0],x[v1],y[v1],x[v2],y[v2],x[v3],y[v3]: eps:=0.2) select 1 else 0;
    end for;
    if count lt mincount then
      mincount:=count;
      minx:=x;
      miny:=y;
    end if;
    if count eq 0 then break; end if;
  end for;

  SetSeed(rndsave);
  return minx,miny;

end function;


function VertexIndices(e)
  return [Index(v): v in EndVertices(e)];
end function;


function IntersectionCount(G,x,y)       // Count line segment intersections
  count:=0;
  for i->e1, j->e2 in Edges(G) do
    if j le i or not IsEmpty(EndVertices(e1) meet EndVertices(e2)) then continue; end if;
    v0,v1:=Explode(VertexIndices(e1));
    v2,v3:=Explode(VertexIndices(e2));
    count+:=SegmentsIntersect(x[v0],y[v0],x[v1],y[v1],x[v2],y[v2],x[v3],y[v3]: eps:=0.01) select 1 else 0;
  end for;
  return count;
end function;


function DotProduct(v1, v2)
  return &+[v1[i] * v2[i] : i in [1..#v1]];
end function;

// Function to compute the Euclidean distance between two points
function Distance(p1, p2)
  return Sqrt(&+[ (p1[i] - p2[i])^2 : i in [1..#p1] ]);
end function;


function ClosestPointOnSegment(A, B, P)
  // Compute the closest point on the line segment to the given point
  AB := [B[i] - A[i] : i in [1..#A]];
  AP := [P[i] - A[i] : i in [1..#A]];
  BP := [P[i] - B[i] : i in [1..#A]];
  if DotProduct(AB, AP) le 0 then      // If AB.AP<=0, then return A
    return A;
  end if;
  if DotProduct(AB, BP) ge 0 then      // If AB.BP>0, then return B
      return B;
  end if;
  AB_norm := DotProduct(AB, AB);       // Otherwise, the closest point 
  projection := DotProduct(AB, AP) / AB_norm;     // is along the line AB
  return [A[i] + projection * AB[i] : i in [1..#A]];
end function;


function ShortestDistanceToSegment(A, B, P)
  // Function to compute the shortest distance from a point to a line segment
  C := ClosestPointOnSegment(A, B, P);
  return Distance(P, C);
end function;


function PlanarGraphQuality(G,x,y)
  // edge lengths
  weight:=0;
  for e in Edges(G) do
    v1,v2:=Explode(VertexIndices(e));
    weight+:=(x[v1]-x[v2])^2+(y[v1]-y[v2])^2;
  end for;
  // shortest distance from vertices to edges
  weight2:=0;
  for e in Edges(G), v in Vertices(G) do
    i1,i2:=Explode(VertexIndices(e));
    i:=Index(v);
    if i in {i1,i2} then continue; end if;
    eps:=ShortestDistanceToSegment([x[i1],y[i1]], [x[i2],y[i2]], [x[i],y[i]]);
    weight2+:=1/5/(eps+0.01); 
    if eps gt 0.4 then continue; end if;
    weight2+:=1/(eps+0.01); 
  end for;
  // prefer small overall box size
  boxsize:=(Max(x)-Min(x)+0.5)*(Max(y)-Min(y)+0.5);
  // prefer horizontal or vertical edges
  weights:=0;
  for e in Edges(G) do
    v1,v2:=Explode(VertexIndices(e));
    straight:=x[v1] eq x[v2] or y[v1] eq y[v2];
    diagonal:=Abs(x[v1]-x[v2]) eq Abs(y[v1]-y[v2]);
    if not straight then 
      weights+:=diagonal select 0.6 else 1; 
    end if;
  end for; 
  // total weight
  return weight + 4*weight2 + boxsize + weights;
end function;


function ImproveCoordinates(G,x,y)
  V:=VertexSet(G);
  E:=EdgeSet(G);
  intcount:=IntersectionCount(G,x,y);
  weight:=PlanarGraphQuality(G,x,y);  
  repeat
    oldweight:=weight;
    oldcount:=intcount;
    for i:=1 to #V do                                   // Move ith vertex
      for dx,dy in [-3/4,-1/4,0,1/4,3/4] do             // in some direction
        if dx eq 0 and dy eq 0 then continue; end if;
        xi:=x[i]+dx;
        yi:=y[i]+dy;
        if exists{j: j in [1..#V] | i ne j and (x[j]-xi)^2+(y[j]-yi)^2 lt 1} then continue; end if;
        xnew:=x; xnew[i]:=xi;
        ynew:=y; ynew[i]:=yi;
        newcount:=IntersectionCount(G,xnew,ynew);
        if newcount gt intcount then continue; end if;     // check how planar it is
        newweight:=PlanarGraphQuality(G,xnew,ynew);  
        if newcount lt intcount or newweight lt weight then
          weight:=newweight; x:=xnew; y:=ynew; intcount:=newcount;
          //intcount,weight;
        end if;
      end for;
    end for;  
  until oldcount eq intcount and oldweight eq weight;
  // align horizontally
  if Max(x)-Min(x) lt Max(y)-Min(y) 
    then return y,x;
    else return x,y;
  end if;
end function;


function FullGridGraph(m, n)    // Full graph for the mxn grid, returns G, x-coords, y-coords
  vertices := {@ <i,j>: i in [1..m], j in [1..n] @};    // vertices with integer coordinates in the m by n box
  edges:={{<i, j>, <i+1, j>}: i in [1..m-1], j in [1..n]}   // horizontal edges
    join {{<i, j>, <i, j+1>}: i in [1..m], j in [1..n-1]};  // vertical edges
  return Graph<vertices | edges>,[d[1]: d in vertices],[d[2]: d in vertices];
end function;


function DiagonalGridGraph(m, n)    // Graph for the mxn grid plus diagonals, returns G, x-coords, y-coords
  vertices := {@ <i,j>: i in [1..m], j in [1..n] @};    // vertices with integer coordinates in the m by n box
  edges:={{<i, j>, <i+1, j>}: i in [1..m-1], j in [1..n]}       // horizontal edges
    join {{<i, j>, <i, j+1>}: i in [1..m], j in [1..n-1]}       // vertical edges
    join {{<i, j>, <i+1, j+1>}: i in [1..m-1], j in [1..n-1]};  // diagonal edges
  return Graph<vertices | edges>,[d[1]: d in vertices],[d[2]: d in vertices];
end function;


procedure AddShortEdges(vertices,~edges,mindist)
  for i->v,j->w in vertices do
    if i ge j then continue; end if;
    dist:=(v[1]-w[1])^2+(v[2]-w[2])^2; 
    if dist ge mindist then continue; end if;
    Include(~edges,{v,w}); 
  end for;
end procedure;


function HexGridGraph(m, n)    // Graph for the mxn triangular hex grid, returns G, x-coords, y-coords
  vertices := {@ <i+(j mod 2)/2,j>: i in [1..m], j in [1..n] | i+(j mod 2)/2 le m @};   // triangular grid
  edges:={};
  AddShortEdges(vertices,~edges,2);
  return Graph<vertices | edges>,[Q| d[1]: d in vertices],[Q| d[2]: d in vertices];
end function;


function DoubleTriangleGraphSym(n)
  h:=n le 4 select 1 else 3/2;
  vertices:={@ <i,1>: i in [1..n] @} join {@ <(n+1)/2,1-h>, <(n+1)/2,1+h> @};
  edges:={@ {vertices[i],vertices[n+1]}: i in [1..n] @} join {@ {vertices[i],vertices[n+2]}: i in [1..n] @};
  AddShortEdges(vertices,~edges,2);
  return Graph<vertices | edges>,[Q| d[1]: d in vertices],[Q| d[2]: d in vertices];
end function;


function DoubleTriangleGraph(n)
  h:=n le 2 select 1 else 3/2;
  vertices:={@ <i,1>: i in [1..n] @} join {@ <-i,1>: i in [1..n] @} join {@ <0,1-h>, <0,1+h> @};
  edges:={@ {vertices[i],vertices[2*n+1]}: i in [1..2*n] @} join {@ {vertices[i],vertices[2*n+2]}: i in [1..2*n+1] @};
  AddShortEdges(vertices,~edges,3);
  return Graph<vertices | edges>,[Q| d[1]: d in vertices],[Q| d[2]: d in vertices];
end function;


function ExtendedTriangleGraph(n)
  h:=n le 2 select 1 else 3/2;
  vertices:={@ <i,1>: i in [1..n] @} join {@ <0,1-h>, <0,1+h> @};
  edges:={@ {vertices[i],vertices[n+1]}: i in [1..n] @} join {@ {vertices[i],vertices[n+2]}: i in [1..n+1] @};
  AddShortEdges(vertices,~edges,3);
  return Graph<vertices | edges>,[Q| d[1]: d in vertices],[Q| d[2]: d in vertices];
end function;


function CoordVertexGraph(G,x,y)
  V:=VertexSet(G);
  E:=EdgeSet(G);
  vertices:={@ <x[i],y[i]>: i in [1..#x] @};
  edges:={Set(vertices[VertexIndices(e)]): e in E};
  return Graph<vertices | edges>;
end function;


function MaximumPlanarByHand()
  L:=[];
  D:=PlanarGraphDatabase(7);

  // Planar graph 7,642 by hand
  G:=Graph(D,642);
  x:=[Q|4,1,3,4,5,7,4];
  y:=[Q|5,3/2,3,3,3,3/2,2];
  Append(~L,<G,x,y>);

  // Planar graph 7,643 by hand
  G:=Graph(D,643);
  x:=[Q|2,5/2,0,2,3,5,3];
  y:=[Q|3,9/2,  1,2,3/2,1,3];
  Append(~L,<G,x,y>);

  // Planar graph 7,644 by hand
  G:=Graph(D,644);
  x:=[2,3,5/2,1,2,3,9/2];
  y:=[3,3,5,2,2,2,1];
  Append(~L,<G,x,y>);

  // Planar graph 7,646 by hand
  G:=Graph(D,646);
  x:=[2,4,3+1/4,7/2,3+1/4,4,1];
  y:=[4,1,3,4,5,7,4];
  Append(~L,<G,x,y>);

  return [CoordVertexGraph(D[1],D[2],D[3]): D in L];
end function;


function GridGraphs(queue: found:={@@})
  done:={};
  count:=0;
  while not IsEmpty(queue) do
    count+:=1;
    G:=queue[1];
    Remove(~queue,1);
    Include(~done,G);
    if not exists{H: H in found | IsIsomorphic(G,H)} then 
      Include(~found,G);
      // printf "%-3o G(%o,%o)\n",count,#VertexSet(G),#EdgeSet(G);
    else 
      continue;
    end if;
    V:=VertexSet(G);
    E:=EdgeSet(G);
    for e in E do      // Remove an edge
      Gnew:=G-e;
      if not IsConnected(Gnew) or Gnew in done then continue; end if;
      Append(~queue,Gnew);
    end for;
    for v in V do      // Remove a vertex of degree 1
      // if Degree(v) gt 1 then continue; end if;
      Gnew:=G-v;
      if forall{v: v in VertexSet(Gnew) | Degree(v) le 2} or not IsConnected(Gnew)  // chains or disconnected
        or Gnew in done then continue; end if;                                      // or already done
      Append(~queue,Gnew);
    end for;
  end while;
  return found;
end function;


procedure RegenerateGridGraphs()     
  // Rectangular grid up to 5x3 - horizontal and vertical edges
  queue:=[FullGridGraph(m, n): m in [2..5], n in [2..3] | m ge n and m*n le 10];
  graphs:=GridGraphs(queue);
  "after full grid",#graphs;
  // Rectangular grid up to 3x2 - horizontal, vertical, diagonal edges
  queue:=[DiagonalGridGraph(2,2), DiagonalGridGraph(3,2)];    // 3x3 very slow, 4x2 possible
  graphs:=GridGraphs(queue: found:=graphs);
  "after diagonal grid",#graphs;
  // Triangular grid up to 3x3 (small)
  queue:=[HexGridGraph(3,3)];                      // 4x3 very slow
  graphs:=GridGraphs(queue: found:=graphs);
  // Double triangular graph (sym and not) and extended triangular graph
  "after hex grid",#graphs;
  queue:=[DoubleTriangleGraph(2),
          DoubleTriangleGraphSym(3),
          DoubleTriangleGraphSym(4),
          ExtendedTriangleGraph(2),
          ExtendedTriangleGraph(3),
          DoubleTriangleGraphSym(5),
          ExtendedTriangleGraph(4),
          ExtendedTriangleGraph(5)
         ];
  graphs:=GridGraphs(queue: found:=graphs);
  "after extended triangles",#graphs;
  // Maximum planar graphs by hand
  queue:=MaximumPlanarByHand();
  graphs:=GridGraphs(queue: found:=graphs);
  "after maximum planar",#graphs;
  // Improving individual coordinates and writing output
  "Improving individual coordinates and writing output";
  graphs:=SetToSequence(graphs);
  SortBy(~graphs,func<G|[#Vertices(G),#Edges(G)]>);
  out:=[];
  printf "(%o) ",#graphs;
  for j->D in graphs do
    printf "%o ",j;
    coords:=[eval Sprint(v): v in VertexSet(D)];
    x:=[Q|d[1]: d in coords];
    y:=[Q|d[2]: d in coords];
    G:=Graph<#Vertices(D)|{Set(VertexIndices(e)): e in EdgeSet(D)}>;
    xnew,ynew:=ImproveCoordinates(G,x,y);
    Append(~out,Sprintf("<Graph<%o|%o>,%o,%o>",
      #Vertices(G),DelSpaces({Set(VertexIndices(e)): e in EdgeSet(G)}),DelSpaces(xnew),DelSpaces(ynew)));
  end for;
  "done";
  // Writing output
  graphs:=Sprintf("// %o graphs generated by RegenerateGridGraphs\n{\n",#graphs)*PrintSequence(out: sep:=",\n")*"\n}";
  writepiece("planar.m",graphs,"//! GRID GRAPHS BEGIN","//! GRID GRAPHS END");
end procedure;


procedure ExtractNumber(~s,~i,~r)
  i0:=i;
  while (i le #s) and ((c ge "0" and c le "9") or ((c eq "-") and (i0 eq i)) or (c eq ".") or (c eq "/") where c is s[i]) do
    i+:=1;    
  end while;
  error if i0 eq i, "Expected a number at position "*Sprint(i0)*" in "*s;
  r:=eval s[[i0..i-1]];
end procedure;


function XYGraph(s)
  V:={@@};  // vertices
  E:={@@};  // edges
  i:=1;     // current symbol position in s
  v:=0;     // current vertex
  v0:=0;    // previous vertex from which we need to add an edge, unless 0
  x:=[Q|];
  y:=[Q|];
  vx:=0;
  vy:=0;

  repeat
    // extract vertex
    if s[i] eq "v" then                      // new vertex
      i+:=1;
      v:=#V+1;
      Include(~V,v);
    elif s[i] eq "(" then
      i+:=1;
      ExtractNumber(~s,~i,~vx);    
      error if i gt #s or (s[i] ne ","), "Expected ',' at position "*Sprint(i)*" in "*s;
      i+:=1;
      ExtractNumber(~s,~i,~vy);    
      error if i gt #s or (s[i] ne ")"), "Expected ')' at position "*Sprint(i)*" in "*s;
      i+:=1;
      v:=#V+1;
      Include(~V,v);
      x[v]:=vx;
      y[v]:=vy;
    elif s[i] ge "0" and s[i] le "9" then    // old vertex
      ExtractNumber(~s,~i,~v);
      error if v notin V, "Vertex index "*Sprint(v)*" unrecognised in "*s;
    else
      error "Expected vertex in "*s*" at position "*Sprint(i);
    end if;
    // add last edge
    if v0 ne 0 then Include(~E,{v0,v}); end if;
    // extract edge
    if i gt #s then break; end if;         // check if reached the end
    if s[i] eq "-" then   v0:=v; i+:=1;    // add edge
    elif s[i] eq "&" then v0:=0; i+:=1;    // jump
    else error "Expected edge in "*s*" at position "*Sprint(i);
    end if;
  until false;

  return Graph<V|E>,x,y;
end function;


function XYGraphLabel(G,x,y)
  error "XYGraphLabel: check and reimplement edge convention";
  V:=VertexSet(G);
  AssignLabels(V,[[x[i],y[i]]: i in [1..#V]]);
  W,A:=MinimumScorePaths(G);    // max weight
  DeleteLabels(V);
  assert #A eq 1; 
  A:=A[1];                       // index assignments
  done:=[];
  s:="";
  for i->w in W do  
    _,haveedge,index:=Explode(w);
    p:=Position(A,index); 
    if p notin done
      then s*:=Sprintf("(%o,%o)",x[p],y[p]); Append(~done,p);
      else s*:=Sprint(Position(done,p));
    end if;
    if haveedge eq 1 then s*:="-";
    elif i ne #W then s*:="&";
    end if;
  end for;
  return s;
end function;


gridgraphs:=                  // including all planar of size <=7, see gridgraphs.m
//! GRID GRAPHS BEGIN
// 967 graphs generated by RegenerateGridGraphs, patched by PatchGridGraphs, labels by GridGraphLabels
{@
<Graph<2|{{1,2}}>,[1,2],[1,1],"v-v">,
<Graph<3|{{2,3},{1,2}}>,[1,2,3],[1,1,1],"v-v-v">,
<Graph<3|{{1,3},{2,3},{1,2}}>,[1,2,1],[2/5,1,8/5],"v-v-v-1">,
<Graph<4|{{2,4},{2,3},{1,2}}>,[11/10,2,11/10,3],[2/5,1,8/5,1],"v-v-v&v-2">,
<Graph<4|{{2,4},{2,3},{1,2},{3,4}}>,[3,2,1,1],[8/5,8/5,11/5,1],"v-v-v-v-2">,
<Graph<4|{{2,3},{1,2},{3,4}}>,[1,2,3,4],[1,1,1,1],"v-v-v-v">,
<Graph<4|{{1,3},{1,4},{2,3},{1,2},{3,4}}>,[2,1,2,3],[1,1,2,1],"v-v-v-v-1-3">,
<Graph<4|{{1,4},{2,3},{1,2},{3,4}}>,[1,2,3,2],[1,2/5,1,8/5],"v-v-v-v-1">,
<Graph<4|{{1,3},{1,4},{2,4},{2,3},{1,2},{3,4}}>,[11/10,2,11/10,16/5],[2/5,1,8/5,1],"v-v-v-v-1-3&2-4">,
<Graph<5|{{2,5},{2,4},{2,3},{1,2}}>,[1,5/2,2,3,4],[1,2,1,1,1],"v-v-v&v-2-v">,
<Graph<5|{{2,5},{2,4},{2,3},{1,2},{3,4}}>,[1,2,3,3,1],[1,3/2,1,2,2],"v-v-v-v-2-v">,
<Graph<5|{{2,5},{2,3},{1,2},{3,4},{4,5}}>,[37/10,27/10,9/5,1,9/5],[1,1,2/5,1,8/5],"v-v-v-v-v-2">,
<Graph<5|{{2,5},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v-2-4">,
<Graph<5|{{2,5},{2,3},{1,2},{3,4}}>,[1,2,3,4,2],[1,1,1,1,2],"v-v-v-v&v-2">,
<Graph<5|{{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,1,2,3],[2,2,1,1,1],"v-v-v-v-v&2-4">,
<Graph<5|{{1,5},{1,4},{3,5},{2,3},{1,2},{3,4}}>,[1,1,3,3,2],[1,2,2,1,3/2],"v-v-v-v-1-v-3">,
<Graph<5|{{2,5},{1,4},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,3,11/5,3,15/4],[2,6/5,2,14/5,2],"v-v-v-v-v-2-4-1">,
<Graph<5|{{2,5},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3],[2,2,1,1,2],"v-v-v-v-v-2&3-5">,
<Graph<5|{{2,5},{3,5},{2,4},{2,3},{3,4},{1,2},{4,5}}>,[21/5,16/5,11/10,2,11/10],[1,1,2/5,1,8/5],"v-v-v-v-v-2-4&3-5">,
<Graph<5|{{1,5},{2,5},{1,3},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,11/5,3,15/4,3],[2,2,6/5,2,14/5],"v-v-v-v-v-1-3-5-2">,
<Graph<5|{{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,4,5],[1,1,1,1,1],"v-v-v-v-v">,
<Graph<5|{{1,5},{1,3},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[2,1,5/2,4,3],[1,1,2,1,1],"v-v-v-v-v-1-3-5">,
<Graph<5|{{3,5},{2,3},{3,4},{1,2},{4,5}}>,[4,3,2,1,1],[1,1,1,8/5,2/5],"v-v-v-v-v-3">,
<Graph<5|{{1,3},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,1,2,3,3],[1,2,2,2,1],"v-v-v-v-v-3-1">,
<Graph<5|{{1,5},{1,3},{2,3},{1,2},{3,4},{4,5}}>,[2,3,2,1,1],[1,2,2,2,1],"v-v-v-v-v-1-3">,
<Graph<5|{{1,5},{2,3},{1,2},{3,4},{4,5}}>,[1,1,21/10,14/5,21/10],[7/5,13/5,3,2,1],"v-v-v-v-v-1">,
<Graph<5|{{1,5},{1,3},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,1,3,3],[1,3/2,2,2,1],"v-v-v-v-v-1-3&2-4">,
<Graph<5|{{1,5},{1,3},{2,4},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,1,2,3,3],[1,2,3/2,2,1],"v-v-v-v-v-1-3-5&2-4">,
<Graph<5|{{1,3},{1,5},{2,5},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[7/4,6/5,6/5,15/4,11/4],[2,3,1,2,2],"v-v-v-v-v-1-3-5-2-4">,
<Graph<6|{{2,5},{2,6},{2,4},{2,3},{1,2}}>,[1,3,2,3,5,4],[1,2,1,1,1,1],"v-v-v&v-2-v&v-2">,
<Graph<6|{{2,5},{2,6},{2,4},{2,3},{1,2},{3,4}}>,[1,2,2,3,1,3],[3/2,2,1,3/2,5/2,5/2],"v-v-v-v-2-v&v-2">,
<Graph<6|{{2,6},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,4,5,2],[1,1,1,1,1,2],"v-v-v-v-v&v-2">,
<Graph<6|{{2,5},{2,6},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3,2],[2,2,3,3,2,1],"v-v-v-v-v-2-v">,
<Graph<6|{{2,5},{2,6},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,3,2,1],[3/2,2,5/2,3/2,1,5/2],"v-v-v-v-v-2-v&2-4">,
<Graph<6|{{2,5},{2,6},{4,6},{2,3},{3,4},{1,2},{4,5}}>,[3,3,1,2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4">,
<Graph<6|{{2,5},{2,6},{2,4},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[3,5/2,1,5/2,4,2],[2,3,2,1,2,2],"v-v-v-v-v-2-v-4-2">,
<Graph<6|{{2,5},{2,6},{2,3},{3,4},{1,2}}>,[7/3,3,2,1,11/3,4],[2,1,1,1,2,1],"v-v-v-v&v-2-v">,
<Graph<6|{{2,5},{3,6},{2,3},{1,2},{3,4}}>,[1,2,3,4,1,4],[1,3/2,3/2,1,2,2],"v-v-v-v&v-2&v-3">,
<Graph<6|{{2,6},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3,1],[1,2,1,2,1,2],"v-v-v-v-v&v-2-4">,
<Graph<6|{{2,5},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3,4],[2,2,1,1,2,1],"v-v-v-v-v-2&v-4">,
<Graph<6|{{2,5},{2,4},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[1,2,1,2,3,3],[2,2,1,1,2,1],"v-v-v-v-v-2-4-v">,
<Graph<6|{{2,5},{2,6},{1,4},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[1,5/2,2,5/2,3,4],[2,1,2,3,2,2],"v-v-v-v-v-2-v-4-1">,
<Graph<6|{{1,5},{3,6},{1,3},{1,4},{3,5},{2,3},{1,2},{3,4},{1,6}}>,[5/2,1,5/2,4,3,2],[1,2,3,2,2,2],"v-v-v-v-1-v-3-v-1-3">,
<Graph<6|{{2,5},{2,6},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3,1],[1,2,1,1,2,2],"v-v-v-v-v-2-v&3-5">,
<Graph<6|{{2,5},{2,6},{3,5},{2,4},{2,3},{3,4},{1,2},{4,5}}>,[21/5,16/5,11/10,2,11/10,21/5],[2/5,1,2/5,1,8/5,8/5],"v-v-v-v-v-2-v&2-4&3-5">,
<Graph<6|{{2,6},{2,4},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4">,
<Graph<6|{{2,5},{2,6},{2,4},{4,6},{2,3},{3,4},{1,2},{5,6},{4,5}}>,[7/2,3,9/2,3,2,1],[2,3,2,1,2,2],"v-v-v-v-v-v-2-4-6&2-5">,
<Graph<6|{{2,5},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,3,2,1],[1,1,1,2,2,2],"v-v-v-v-v-v&2-5">,
<Graph<6|{{2,5},{3,5},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v&2-5-3">,
<Graph<6|{{2,5},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[4,3,2,1,3,4],[1,1,2,2,3,3],"v-v-v-v-v-v&3-5-2-4">,
<Graph<6|{{2,6},{3,5},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,2,3,1],[1,2,2,1,1,2],"v-v-v-v-v-3&v-2">,
<Graph<6|{{4,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[5,4,3,2,1,1],[8/5,8/5,8/5,8/5,21/10,1],"v-v-v-v-v-v-4">,
<Graph<6|{{2,4},{4,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[3,3,2,2,1,1],[1,2,1,2,1,2],"v-v-v-v-v-v-4-2">,
<Graph<6|{{3,6},{1,3},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3-1">,
<Graph<6|{{3,6},{1,3},{3,5},{2,3},{3,4},{1,2},{4,5},{1,6}}>,[3,2,2,1,1,3],[2,3,2,2,1,1],"v-v-v-v-v-3-v-1-3">,
<Graph<6|{{2,6},{3,5},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,3,2,1],[2,2,2,1,1,1],"v-v-v-v-v-v-2&3-5">,
<Graph<6|{{1,3},{1,5},{5,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,2,3,4,3,3],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5">,
<Graph<6|{{1,3},{1,5},{2,5},{5,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,2,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2">,
<Graph<6|{{1,3},{1,5},{2,5},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,2,3,9/2,3,7/2],[2,2,1,2,3,2],"v-v-v-v-v-v-3-1-5-2&3-5">,
<Graph<6|{{3,6},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,4,5,3],[1,1,1,1,1,2],"v-v-v-v-v&v-3">,
<Graph<6|{{2,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[19/5,14/5,21/10,1,1,21/10],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-2">,
<Graph<6|{{2,5},{2,6},{2,4},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,2,1,2,3,3],[1,3/2,2,5/2,2,1],"v-v-v-v-v-v-2-4&2-5">,
<Graph<6|{{2,4},{2,3},{3,4},{1,2},{5,6},{4,5}}>,[3,3,2,2,1,1],[1,2,1,2,2,1],"v-v-v-v-v-v&2-4">,
<Graph<6|{{2,6},{2,4},{4,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,2,1,2,3,3],[2,2,1,1,1,2],"v-v-v-v-v-v-2-4-6">,
<Graph<6|{{3,6},{2,6},{2,4},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3">,
<Graph<6|{{2,5},{2,6},{4,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[1/2,4/3,4,3,2,4/3],[2,3,2,2,2,1],"v-v-v-v-v-v-2-4-6-3&2-5">,
<Graph<6|{{2,6},{4,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[1,2,3,2,2,1],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4-6&3-5">,
<Graph<6|{{1,3},{2,5},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[3,4,3,2,2,1],[1,2,2,2,3,3/2],"v-v-v-v-v-v-1-3-5-2">,
<Graph<6|{{1,3},{2,5},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,2,5/2,1,2,4],[2,2,3,2,1,2],"v-v-v-v-v-v-1-3-6&2-5">,
<Graph<6|{{1,3},{2,5},{5,6},{1,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[7/2,5/2,7/4,1,7/4,9/2],[5/2,5/2,7/2,5/2,3/2,5/2],"v-v-v-v-v-v-1-3-5-2&3-6">,
<Graph<6|{{1,3},{1,5},{2,5},{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[7/4,5/2,7/2,9/2,7/4,1],[3/2,5/2,5/2,5/2,7/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-5">,
<Graph<6|{{3,6},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[1,2,2,3,3,1],[1,1,2,2,1,2],"v-v-v-v-v&v-3&2-4">,
<Graph<6|{{3,6},{3,5},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,1,2,3,3,2],[2,1,1,1,2,2],"v-v-v-v-v-v-3-5">,
<Graph<6|{{2,5},{5,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[2,1,3,4,3,3],[2,2,1,2,3,2],"v-v-v-v-v-v-3&2-5">,
<Graph<6|{{2,5},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[2,1,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-5-2">,
<Graph<6|{{1,3},{1,5},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,2,11/4,9/2,11/4,7/2],[2,2,3,2,1,2],"v-v-v-v-v-v-3-1-5-3">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,2,3,2,1],[2,3,2,2,1,1],"v-v-v-v-v-v-1-3-5">,
<Graph<6|{{1,3},{1,5},{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[7/4,1,7/4,9/2,7/2,5/2],[7/2,5/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4">,
<Graph<6|{{1,3},{1,5},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,1,2,3,2,1],[2,3,3,3,2,1],"v-v-v-v-v-v-1-3-5-1">,
<Graph<6|{{2,6},{1,6},{5,6},{1,4},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[2,3,4,5/2,1,5/2],[2,2,2,3,2,1],"v-v-v-v-v-v-1-4-2-6-3">,
<Graph<6|{{3,6},{3,5},{2,3},{3,4},{1,2},{4,5}}>,[3,3,2,1,1,2],[1,2,2,1,2,1],"v-v-v-v-v-3-v">,
<Graph<6|{{2,5},{2,6},{2,4},{2,3},{1,2},{3,4},{5,6}}>,[5/4,2,1,2,3,3],[5/4,2,3,3,2,1],"v-v-v-v-2-v-v-2">,
<Graph<6|{{2,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[3,3,1,2,2,4],[2,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-5">,
<Graph<6|{{3,6},{2,6},{4,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[3,3,2,1,1,2],[1,2,1,1,2,2],"v-v-v-v-v-v-2&3-6-4">,
<Graph<6|{{3,6},{2,6},{2,4},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[1,2,2,1,2,3],[3,3,2,2,1,2],"v-v-v-v-v-v-2-4&3-6">,
<Graph<6|{{2,5},{2,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[3/2,1,1,19/4,7/2,5/2],[5/2,7/2,3/2,5/2,5/2,5/2],"v-v-v-v-v-v-2-4&2-5&3-6">,
<Graph<6|{{2,5},{1,6},{5,6},{1,4},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[11/4,1,7/4,1,19/4,15/4],[5/2,7/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-4-2-5">,
<Graph<6|{{2,6},{4,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[7/4,11/4,1,15/4,19/4,1],[5/2,5/2,3/2,5/2,5/2,7/2],"v-v-v-v-v-v-2-4-6-3-5">,
<Graph<6|{{1,3},{1,5},{1,6},{5,6},{1,4},{4,5},{2,4},{1,2},{2,3},{3,4},{3,5}}>,[1,19/4,15/4,1,11/4,7/4],[7/2,5/2,5/2,3/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2">,
<Graph<6|{{3,6},{2,6},{2,3},{3,4},{1,2},{5,6},{4,5}}>,[3,3,2,1,1,2],[1,2,2,2,1,1],"v-v-v-v-v-v-2&3-6">,
<Graph<6|{{1,3},{2,5},{2,6},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[2,2,1,1,2,3],[1,2,2,3,3,2],"v-v-v-v-v-v-1-3-5-2-6">,
<Graph<6|{{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,2,3,4,5,6],[1,1,1,1,1,1],"v-v-v-v-v-v">,
<Graph<6|{{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[1,1,2,2,3,3],[2,1,1,2,2,1],"v-v-v-v-v-v&2-4&3-5">,
<Graph<6|{{1,3},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,3,2,1,1,2],[2,1,1,1,2,2],"v-v-v-v-v-v-1-3-6">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[2,1,3,5,4,3],[1,1,2,1,1,1],"v-v-v-v-v-v-1-3-5&3-6">,
<Graph<6|{{1,3},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3-6-4">,
<Graph<6|{{1,3},{1,5},{1,6},{5,6},{1,4},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4},{3,6}}>,[1,7/4,1,11/4,15/4,19/4],[3/2,5/2,7/2,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4-2&3-6">,
<Graph<6|{{2,5},{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[2,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-4&2-5">,
<Graph<6|{{1,3},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-1-3&4-6">,
<Graph<6|{{1,3},{4,6},{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,7/4,11/4,3/2,13/4,15/4],[7/2,9/4,9/4,1,1,9/4],"v-v-v-v-v-v-1-3-6-4-1">,
<Graph<6|{{1,3},{2,5},{1,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[5/2,7/4,15/4,5,1,7/4],[2,1,9/4,9/4,15/4,11/4],"v-v-v-v-v-v-1-3-5-2-4">,
<Graph<6|{{1,3},{2,5},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4}}>,[3,4,3,2,2,1],[1,2,2,2,3,2],"v-v-v-v-v-v-1-3&2-5">,
<Graph<6|{{1,3},{2,5},{2,6},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,5/2,4,3,5/2],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5-2-6-4">,
<Graph<6|{{3,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[47/10,37/10,27/10,9/5,1,9/5],[9/5,9/5,9/5,1,9/5,27/10],"v-v-v-v-v-v-3">,
<Graph<6|{{1,5},{1,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[9/4,9/4,9/4,1,1,13/4],[1,2,3,3,2,2],"v-v-v-v-v-1-v-3">,
<Graph<6|{{2,6},{1,4},{2,4},{2,3},{3,4},{1,2},{5,6},{4,5}}>,[11/4,2,15/4,2,1,1],[2,1,2,3,13/5,7/5],"v-v-v-v-v-v-2-4-1">,
<Graph<6|{{3,6},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,1,2,3,3,2],[1,2,2,2,1,1],"v-v-v-v-v-v-3&4-6">,
<Graph<6|{{3,6},{3,5},{4,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[4,4,3,1,2,2],[1,2,5/2,2,7/4,1],"v-v-v-v-v-v-3-5&4-6">,
<Graph<6|{{1,3},{1,4},{4,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[2,3,3,2,1,1],[1,1,2,2,1,2],"v-v-v-v-v-v-4-1-3">,
<Graph<6|{{1,3},{1,4},{2,4},{4,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,2,2,3,4,4],[2,7/4,1,5/2,1,2],"v-v-v-v-v-v-4-1-3&2-4">,
<Graph<6|{{3,6},{2,6},{3,5},{4,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[4,4,3,1,2,3],[13/5,7/5,3,2,2,1],"v-v-v-v-v-v-2&4-6-3-5">,
<Graph<6|{{1,3},{2,6},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,3,3,4,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5&2-6">,
<Graph<6|{{1,3},{2,6},{1,6},{5,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,2,3,4,4,3],[2,2,3,13/5,7/5,1],"v-v-v-v-v-v-1-3-5&2-6-3">,
<Graph<6|{{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[2,1,1,2,3,3],[1,1,2,2,2,1],"v-v-v-v-v-v-1-4">,
<Graph<6|{{1,3},{2,6},{1,6},{5,6},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,2,3,4,4,3],[2,2,1,7/5,13/5,3],"v-v-v-v-v-v-1-3-6-2">,
<Graph<6|{{1,3},{1,4},{4,6},{2,3},{1,2},{4,5},{5,6}}>,[2,1,1,3,2,3],[2,2,1,2,1,1],"v-v-v-1-v-v-v-5">,
<Graph<6|{{1,3},{2,6},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,3,4,3,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-4">,
<Graph<6|{{1,3},{2,6},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,2,3,5,4,3],[2,2,1,2,2,3],"v-v-v-v-v-v-1-3-5&2-6-3&4-6">,
<Graph<6|{{1,3},{1,5},{2,6},{1,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,3/2,1,19/4,7/2,5/2],[4,5/2,1,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5-1-4&2-6">,
<Graph<6|{{2,6},{3,5},{4,6},{2,3},{3,4},{1,2},{4,5},{5,6}}>,[3,4,3,1,2,3],[2,2,3,2,2,1],"v-v-v-v-v-v-2&3-5&4-6">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{1,2},{2,3},{3,4}}>,[2,3,3,2,1,1],[1,1,2,2,2,1],"v-v-v-v-v-v-1-3">,
<Graph<6|{{1,6},{5,6},{4,5},{1,2},{2,3},{3,4}}>,[1,8/5,27/10,33/10,14/5,8/5],[2,1,1,2,3,3],"v-v-v-v-v-v-1">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[2,2,1,2,3,3],[1,2,2,3,3,7/4],"v-v-v-v-v-v-1-3&2-4">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[1,9/4,9/4,13/4,9/4,1],[2,1,2,2,3,3],"v-v-v-v-v-v-1-3-5&2-4">,
<Graph<6|{{1,3},{1,6},{5,6},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,3/2,1,5/2,7/2,19/4],[1,5/2,4,5/2,5/2,5/2],"v-v-v-v-v-v-1-3-5&2-4&3-6">,
<Graph<6|{{1,3},{2,5},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,5/2,4,3,3],[2,2,3,2,2,1],"v-v-v-v-v-v-1-3-5-2&4-6">,
<Graph<6|{{1,3},{2,5},{4,6},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4}}>,[1,2,2,3,4,3],[2,3,2,2,2,1],"v-v-v-v-v-v-1-3&2-5&4-6">,
<Graph<6|{{1,3},{2,5},{2,6},{4,6},{5,6},{1,6},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,7/4,7/4,5,3,3],[17/4,11/4,1,11/4,9/4,3],"v-v-v-v-v-v-1-3-5-2-6-4-1">,
<Graph<7|{{1,3},{1,5},{1,7},{1,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&5-7">,
<Graph<7|{{2,5},{3,5},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3,2,1,0,1,1/4,2],[7/2,7/2,5,5,4,13/4,5/2],"v-v-v-v-v-v&v-2-5-3">,
<Graph<7|{{2,6},{1,7},{4,6},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[5,3,1,3,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,3,4,4,25/4,5,4],[4,13/4,2,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6&5-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[3/4,3/4,3/2,3,3,2,5/2],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5">,
<Graph<7|{{4,7},{2,5},{2,6},{2,4},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[1/2,0,4,1/4,11/4,7/4,3/4],[3/2,5/2,1,-5/4,1,1,1/4],"v-v-v-v-v-2-v-4-v&2-4">,
<Graph<7|{{1,3},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[3/2,3/2,5/2,5/2,13/4,17/4,17/4],[1,2,2,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-4-1-3&5-7">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6-3-7-5">,
<Graph<7|{{1,3},{4,7},{4,6},{1,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[7/4,7/4,11/4,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-4-6-1-3">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,1/4,0,7/4,11/4,7/4,1/2],[-1/4,-1/4,5/2,5/2,1,1,3/2],"v-v-v-v-v-v-3-v&2-5-3">,
<Graph<7|{{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[9/2,7/2,2,3,2,2,1],[2,2,2,1,0,1,1],"v-v-v-v-v-v-3-v-5">,
<Graph<10|{{9,10},{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8&4-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[3/4,3/4,3/4,2,3,3,2],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&4-7-5">,
<Graph<7|{{1,3},{2,5},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[2,3,2,3,17/4,5/2,1/2],[2,3/2,3,3,2,9/2,3/2],"v-v-v-v-v-v-v-1-3-5-2-7-3-6-4">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{4,7},{1,5},{2,7},{1,6},{2,4},{1,7}}>,[4,3,1,4,7,5,4],[19/4,3,3/2,2,3/2,3,3],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7-4">,
<Graph<7|{{2,5},{5,6},{6,7},{2,4},{1,2},{5,7},{2,3},{3,4}}>,[13/4,5/2,1,7/4,3/4,-1/4,-1/4],[9/4,3,3,9/4,4,4,5],"v-v-v-v-2-v-v-v-6">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[9/4,9/4,3/4,-1/4,-1/4,1,1],[2,3,2,3,17/4,17/4,3],"v-v-v-v-v-v-v-4-6-2">,
<Graph<8|{{3,6},{5,8},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-3&v-2&v-5">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5">,
<Graph<7|{{2,5},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[3,3,2,1,3,5,4],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-2-5&4-1-6">,
<Graph<7|{{1,3},{2,5},{5,6},{1,4},{6,7},{4,5},{2,4},{5,7},{1,2},{2,3},{3,4}}>,[2,1,2,3,7/2,9/2,9/2],[11/4,3/4,7/4,7/4,3/4,11/4,7/4],"v-v-v-v-v-v-v-5-2-4-1-3">,
<Graph<9|{{2,8},{4,7},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,2,3,4,4,5,5,1,3],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-4&v-2&v-3">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{3,6},{8,9}}>,[1,1,2,2,3,3,3,2,1],[1,2,2,1,1,2,3,3,3],"v-v-v-v-v-v-v-v-v-2&3-6">,
<Graph<7|{{2,5},{2,6},{1,7},{5,6},{4,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,1,3,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4-6-2-5">,
<Graph<7|{{2,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-2">,
<Graph<7|{{3,6},{2,3},{1,2},{3,4},{3,7},{4,5}}>,[1,1,2,3,3,2,2],[1,2,2,2,1,1,3],"v-v-v-v-v&v-3-v">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[11/4,9/2,15/4,9/2,11/4,7/4,7/4],[0,0,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3-5-7&2-4">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,4,2,13/4,2],[1,1,1,0,3/4,2,2],"v-v-v-v-v-v-v&3-6-2-4">,
<Graph<9|{{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[5,4,3,2,1,1,2,3,4],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8">,
<Graph<8|{{2,6},{3,8},{2,3},{1,2},{3,7},{3,4},{4,5}}>,[1,1,2,3,3,1,2,2],[1,2,2,2,1,3,1,3],"v-v-v-v-v&v-2&v-3-v">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,5},{3,4}}>,[1/2,0,0,21/4,15/4,5/2,3/2],[1,5/2,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&6-2-7">,
<Graph<9|{{2,5},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,2,2,3,3,4,5,5,1],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-5">,
<Graph<7|{{4,7},{5,6},{1,6},{4,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-4">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,15/4,5,4,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4&2-5">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[2,2,3,3,4,5,3],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&5-3-7">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,3/2,5/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-5-2-4&3-5">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{3,6},{7,10}}>,[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7&3-6">,
<Graph<10|{{5,10},{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&5-10-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2&3-6">,
<Graph<10|{{3,10},{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-3&4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2-6-3&4-6">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[21/4,3/4,0,3/4,3/2,5/2,15/4],[1,-1/2,5/2,5/4,1/2,1,1],"v-v-v-v-v-v-v-1-3-7-2-5">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{5,7},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[17/4,17/4,9/4,3/4,2,3,9/4],[9/4,1,15/4,1,7/4,3/2,11/4],"v-v-v-v-v-v-v-2-4-6-2&4-7-5">,
<Graph<7|{{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,4,3,2],[1,2,2,2,2,1,1],"v-v-v-v-v&v-v-3">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[1,1,2,1,5/2,3,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&6-3-7">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{4,6},{1,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2&4-6">,
<Graph<8|{{5,6},{3,8},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-2&v-3">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[7/4,11/4,1/2,13/4,13/4,0,3/4],[1,1,0,0,9/4,9/4,5/4],"v-v-v-v-v-v-v-1-3-6-2-4">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,3,2,3/4,3/4,3/2,5/2],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[3/4,3/4,7/4,7/4,11/4,11/4,11/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,5,3,3,3,2,2],[1,1,9/4,1,0,1,9/4],"v-v-v-v-v-v-3-v&2-5">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,1,1,1,-1/2,1/2],"v-v-v-v-v-v-v&2-4&3-6-2-5">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4}}>,[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&3-7-4&5-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v">,
<Graph<7|{{1,3},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4-6">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[1,3/2,2,5/2,3,5/2,1],[2,3,2,3,2,1,1],"v-v-v-v-v-v-v-1-3-5&2-4">,
<Graph<7|{{2,5},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3&2-5">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,2,3,3,2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3&5-2-6">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[3,2,3,4,4,2,1],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-3-1-5-3">,
<Graph<10|{{9,10},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&3-8">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[9/4,9/4,1,0,0,1,1],[11/4,15/4,19/4,15/4,11/4,11/4,15/4],"v-v-v-v-v-v-v-2&3-7-4-6">,
<Graph<10|{{5,10},{5,6},{3,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-v-3&v-5">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6-2&3-5">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[1/2,23/4,0,3/4,7/4,11/4,4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3">,
<Graph<7|{{1,3},{4,7},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7">,
<Graph<7|{{2,6},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[1/2,0,21/4,15/4,5/2,1/4,3/2],[3/2,5/2,1,1,1,-1/2,5/4],"v-v-v-v-v-v-v-2-4-6-2&3-6">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6},{8,9}}>,[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&3-6">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,6}}>,[2,3,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6&5-7">,
<Graph<9|{{2,5},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,1,2,2,2,3,3,3],[1,2,3,3,2,1,1,2,3],"v-v-v-v-v-v-v-v-v&2-5-8">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[3,3,4,4,3,3/2,3/2],[0,1,1,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-2-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[1,1,2,3,3,2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&3-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4},{3,6}}>,[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7-5">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{2,4},{3,7},{2,3},{3,5},{3,4}}>,[3/4,1/4,1/4,11/2,15/4,5/2,5/4],[7/4,11/4,-1/4,1,1,1,-1/2],"v-v-v-v-v-v&v-3-5-2-4">,
<Graph<9|{{2,5},{7,8},{5,6},{6,7},{4,5},{4,9},{5,8},{1,2},{2,3},{3,4}}>,[1,1,1,2,2,3,3,2,3],[1,2,3,3,2,2,1,1,3],"v-v-v-v-v-v-v-v-5-2&v-4">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,5},{3,6}}>,[21/4,17/4,3,9/4,2,3/4,17/4],[1,1,3/2,11/4,7/4,1,9/4],"v-v-v-v-v-v-2-v&2-4-6-3-5">,
<Graph<8|{{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3">,
<Graph<10|{{9,10},{7,8},{3,10},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-3">,
<Graph<8|{{2,5},{4,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,1,2,2,2,3,3],[1,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-4&2-5">,
<Graph<7|{{1,3},{4,7},{5,6},{1,4},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3&2-4">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{4,10}}>,[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-4">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{1,6},{1,4},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[2,15/4,15/4,11/4,7/4,3/4,13/4],[3,7/2,1,3/2,7/4,1,5/2],"v-v-v-v-v-v-1-v-3-1-4-6-3">,
<Graph<7|{{1,3},{4,7},{1,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[7/4,7/4,11/4,4,4,3,3],[1,2,2,1,0,0,1],"v-v-v-v-v-v-v-4&3-1-6">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,5,3,1,11/4,2,3],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-1-3-7&2-5">,
<Graph<9|{{2,5},{7,8},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,4,4,3,3,2,2,1,1],[1,1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-v&2-5&4-7">,
<Graph<7|{{1,3},{4,7},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[7/4,7/4,3,17/4,17/4,3,3],[1,2,2,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-1-3-7-4-6">,
<Graph<7|{{3,6},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,2,3,4,4,3,1],[1,2,2,2,1,1,2],"v-v-v-v-v-v-3&v-2">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[15/4,21/4,0,1/2,0,3/2,5/2],[1,1,-1/2,1,5/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5-7">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{4,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[13/4,11/2,17/4,17/4,21/4,6,13/4],[11/4,15/4,11/4,7/4,11/4,7/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-4-1">,
<Graph<9|{{5,6},{3,8},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,5,5,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-5">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,11/4,1/2,0,3/4,7/4,11/4],[1,-1/4,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-1-3-7-4-1">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v&4-2-5">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,5},{3,6}}>,[5/2,3/2,0,1/2,0,21/4,15/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6&5-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[2,2,1,1,-1/2,-1/2,1],[3,4,5,4,4,3,3],"v-v-v-v-v-v-v-2-4-7&3-5">,
<Graph<7|{{2,5},{4,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,19/4,13/4,7/4,1,1/4],[3/2,5/2,1,1,5/4,1/2,-1/4],"v-v-v-v-v-v-v-2-4-7-3&2-5">,
<Graph<9|{{2,8},{5,6},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4}}>,[3,4,4,3,2,1,1,5,2],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-2&v-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[4,5,3,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2&3-6">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[4,5,3,1,11/4,2,3],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5">,
<Graph<8|{{4,8},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[4,4,3,2,1,1,5,2],[1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-4">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[3/4,3/4,2,15/4,15/4,11/4,7/4],[11/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v&2-5-3-6">,
<Graph<7|{{1,3},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-1-3-6-4">,
<Graph<7|{{2,6},{5,6},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,1,1,-1/4,3/4,-1/4],"v-v-v-v-v-v-2-4&v-5-3">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,5}}>,[9/4,9/4,1,-1/4,-1/4,1/4,1],[2,3,17/4,17/4,13/4,9/4,3],"v-v-v-v-v-v-v-3-5-7-2">,
<Graph<8|{{7,8},{3,8},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,3,3,2,1,1,4,4],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v&v-v-3">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[21/4,1/2,0,3/4,7/4,11/4,15/4],[1,-1/2,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7&3-6">,
<Graph<7|{{1,3},{2,6},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[5,4,3,1,2,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6-2-7-4">,
<Graph<7|{{1,3},{1,5},{1,7},{4,6},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-4-1-5">,
<Graph<8|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7">,
<Graph<7|{{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,3,2,2,1,1],[1,1,2,2,3,3,2],"v-v-v-v-v-v-v-4-1">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[3/4,7/4,17/4,7/4,13/4,9/4,3/4],[2,2,3/4,-1/2,3/4,3/4,1],"v-v-v-v-v-2-v-4-2-v">,
<Graph<8|{{5,6},{6,7},{4,5},{5,8},{1,2},{2,7},{2,3},{3,4}}>,[5,4,4,3,2,2,3,1],[1,1,2,2,2,1,1,2],"v-v-v-v-v-v-v-2&v-5">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4-6&5-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-4&5-7">,
<Graph<9|{{2,5},{7,8},{5,6},{6,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,4,4,3,3,2,1,1,2],[2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-6&2-5">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4}}>,[3,4,4,3,2,2,1,1,5,5],[2,2,1,1,1,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-2&v-3">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[3/4,7/4,11/4,0,23/4,4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-5">,
<Graph<7|{{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[13/4,9/4,1,1,-1/2,-1/2,9/4],[3,3,4,3,3,2,2],"v-v-v-v-v-v&v-2-4&3-5">,
<Graph<7|{{3,5},{6,7},{2,3},{3,6},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{5,7},{1,5},{2,4},{1,7}}>,[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6&5-7">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[5,4,3,3,2,2,1,1,4],[2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v&v-4&3-6">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[5/2,3/2,2,1/2,1/2,5,7/2],[1,1/2,2,5/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-2&6-3-7">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{7,9},{2,3},{3,4}}>,[1,1,2,2,3,3,4,4,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-5&v-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[1/2,21/4,0,3/4,7/4,11/4,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-3-5&3-6">,
<Graph<10|{{9,10},{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[4,19/4,3,7/4,7/4,11/4,17/4],[1,7/4,2,2,1,0,0],"v-v-v-v-v-v-v-1-3-5&2-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,5}}>,[11/4,3/4,4,23/4,0,3/4,7/4],[1,-1/2,1,1,5/2,5/4,5/4],"v-v-v-v-v-v-v-1-3-5-2-4">,
<Graph<7|{{1,5},{1,7},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,4,2,2,2,1,13/4],[0,3/2,2,1,0,1,3/4],"v-v-v-v-v-v-3-v-1-5">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[2,3,4,5,13/4,1,3],[1,1,1,1,0,1,2],"v-v-v-v-v-v-v-2&4-7-3-5">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,5,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3&2-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[1,1,2,3,3,5/2,1],[2,1,2,1,2,3,3],"v-v-v-v-v-v-v-1-3-5&6-3-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-3-7">,
<Graph<7|{{4,6},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/2,2,3,2,5/2],[5/4,9/4,3,2,1,1,3],"v-v-v-v-v-v-4&v-3">,
<Graph<7|{{2,6},{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[4,4,5/2,5/2,5/4,0,9/4],[9/4,1,3/2,5/2,2,5/4,15/4],"v-v-v-v-v-v-v-2-4-7&2-6-3">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[-1/2,1/2,7/4,7/2,7/2,5/2,3/2],[7/4,7/4,-1/4,-1/4,5/4,1,1],"v-v-v-v-v-v-v-2-5-3-6">,
<Graph<10|{{9,10},{3,10},{7,8},{5,6},{6,7},{4,9},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9&5-8">,
<Graph<9|{{7,8},{5,6},{6,7},{6,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,2,3,4,5,5,4],[1,2,2,1,1,1,1,2,2],"v-v-v-v-v-v-v-v-v-6">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3">,
<Graph<7|{{4,6},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[11/4,11/4,4,5,4,4,11/4],[0,1,2,1,0,1,2],"v-v-v-v-v-v-3-v&4-6">,
<Graph<7|{{1,3},{2,6},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7-5">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,6},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[-1,0,7/4,1/2,11/4,4,3/4],[5/2,5/2,3/4,-1,1,1,1/4],"v-v-v-v-v-v-2-4-v&2-5&4-6">,
<Graph<9|{{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v-v-3-6&v-2">,
<Graph<10|{{9,10},{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&4-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4},{3,5}}>,[2,3,19/4,4,4,3,3],[9/4,9/4,7/4,1,-1/4,-1/4,1],"v-v-v-v-v-v-v-2&3-5-7-4">,
<Graph<7|{{2,6},{5,6},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4}}>,[11/4,4,4,5,3,3,2],[2,2,1,1,-1/2,1,-1/2],"v-v-v-v-v-v-2-4&v-5">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[5,4,7/2,3,2,2,15/4],[1,1,0,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-4-7">,
<Graph<9|{{2,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,1,2],[1,2,2,3,3,2,1,3,1],"v-v-v-v-v-v-v&v-2&v-3-6">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[4,5,4,3,3,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7-5">,
<Graph<7|{{1,3},{1,5},{4,7},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[3/4,11/4,4,11/4,0,3/4,3/2],[-1/4,-1/4,1,1,5/2,3/2,3/4],"v-v-v-v-v-v-v-1-3-5-1-4-7">,
<Graph<7|{{5,6},{1,6},{1,4},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,5/2,1,1,1,5/2,13/4],[2,3,3,2,1,1,7/4],"v-v-v-v-v-v-v-2&4-1-6">,
<Graph<8|{{2,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[5,4,3,2,2,1,1,4],[1,1,1,1,2,2,1,2],"v-v-v-v-v-v-v&v-2">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,1/2,4,23/4,0,11/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-2-v&4-6-3-5">,
<Graph<9|{{7,8},{5,6},{6,9},{6,7},{4,9},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,1,1,2,3,3,3,2,2],[1,2,3,3,3,2,1,1,2],"v-v-v-v-v-v-v-v-v-2&4-9-6">,
<Graph<10|{{9,10},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-v&4-9">,
<Graph<7|{{1,3},{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3/4,7/4,0,3/4,5/2,4,11/4],[5/4,5/4,5/2,-1/2,-1/2,1,1],"v-v-v-v-v-v-v-4-6-3-1">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,21/4,1/4,3/2,5/2,15/4],[3/2,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6&3-7-4">,
<Graph<7|{{2,5},{4,7},{2,6},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[2,3,4,4,3,2,4],[5/2,5/2,5/2,3/2,3/2,3/2,1/2],"v-v-v-v-v-2-v&v-4-2">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[3/4,3/4,7/4,11/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,5},{3,4}}>,[1,7/4,11/4,1/2,3/4,5,15/4],[7/4,1,1,11/4,-1/2,1,1],"v-v-v-v-v-v-v-3-5-7-4-6">,
<Graph<7|{{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[9/4,13/4,13/4,9/4,3/2,3/4,3/4],[5/4,5/4,9/4,9/4,3,9/4,5/4],"v-v-v-v-v-v-v-1-4">,
<Graph<7|{{2,5},{2,6},{2,4},{3,5},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[1/2,0,0,15/4,21/4,5/2,3/2],[5/4,5/2,-1/2,1,1,1,1],"v-v-v-v-v-2-v&v-2-4&3-5">,
<Graph<9|{{7,8},{3,9},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,3,1,2,3,2],[1,2,2,2,1,3,3,3,1],"v-v-v-v-v&v-v-v&v-3-7">,
<Graph<7|{{1,5},{2,5},{5,6},{1,4},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4}}>,[4,5,5,4,3,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-v-v-v-5-1-4&2-5">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[4,5,3,2,1,3,3],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6-4&3-7">,
<Graph<7|{{1,3},{2,5},{2,6},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[15/4,11/4,7/4,3/4,7/4,11/4,11/4],[11/2,21/4,6,17/4,17/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-6&4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[11/4,7/4,1/2,-1/4,1/4,7/4,1],[2,2,2,11/4,15/4,15/4,3],"v-v-v-v-v-v-v-4&2-6">,
<Graph<8|{{5,8},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,2,3,4,4,3,1,5],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v&v-2&v-5">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2}}>,[1,2,3,5/2,1,1,5/2],[1,2,2,1,3,2,3],"v-v-v&v-2-v&v-2-v">,
<Graph<7|{{1,3},{1,7},{5,6},{1,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[0,9/4,15/4,5/2,3/2,0,1/2],[-1/2,-1/2,1,1,5/4,5/2,1],"v-v-v-v-v-v-v-1-3-6-1-4">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-3-5&4-7">,
<Graph<7|{{1,3},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[17/4,21/4,17/4,11/4,11/4,7/4,7/4],[1/4,1/4,5/4,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&4-6">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[2,3,4,5,4,4,2],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-4">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[4,17/4,3,7/4,7/4,3,19/4],[1,0,1,1,2,2,7/4],"v-v-v-v-v-v-v-1-3-6-4&2-7">,
<Graph<9|{{5,6},{3,8},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-3&v-4">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[11/4,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-2&3-6-4">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6">,
<Graph<7|{{1,3},{4,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[15/4,21/4,1/2,0,7/4,3/2,3/4],[1,1,-3/4,5/2,5/4,1/4,1],"v-v-v-v-v-v-v-4-1-3-6&2-4">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[11/4,11/4,15/4,19/4,19/4,15/4,11/4],[0,1,1,0,1,2,2],"v-v-v-v-v-v-v&2-6-3-5">,
<Graph<10|{{9,10},{1,5},{7,8},{5,6},{1,4},{6,7},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[4,5,5,4,3,3,2,1,1,2],[1,1,2,2,1,2,2,2,1,1],"v-v-v-v-1-v-v-v-v-v-v-8">,
<Graph<7|{{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3/4,3/4,3/2,5/2,13/4,13/4,2],[5/4,9/4,3,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-1">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[2,3,19/4,4,17/4,3,2],[9/4,9/4,7/4,1,0,1,1],"v-v-v-v-v-v-v&2-6&3-5">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[7/4,1,19/4,3,11/4,1,3/2],[7/4,3/4,9/4,2,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-6&4-7">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4}}>,[5,5,4,3,3,2,1,1,2],[2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v&v-4">,
<Graph<8|{{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,1,1,2,3,3,2,2],[1,2,3,3,3,2,2,1],"v-v-v-v-v-v-v-v&2-7-4">,
<Graph<7|{{1,5},{1,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[3,2,5/2,4,4,3,1],[1,1,5/2,5/2,1,0,1],"v-v-v-v-v-v-v-3-5-1-6">,
<Graph<7|{{1,3},{5,6},{1,4},{6,7},{4,5},{2,4},{5,7},{1,2},{2,3},{3,4}}>,[2,1,2,3,15/4,15/4,19/4],[11/4,5/4,7/4,5/4,2,3,3],"v-v-v-v-v-v-v-5&2-4-1-3">,
<Graph<10|{{9,10},{5,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,2,3,3,4,5,5,4],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-5">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[1,2,7/2,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&4-7-5-3-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,4},{1,2},{2,5},{5,7},{1,5}}>,[11/4,1/2,23/4,4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-4&2-5-3">,
<Graph<7|{{4,6},{2,6},{2,3},{6,7},{4,5},{5,6},{3,4},{1,4},{1,2},{4,7},{1,6},{2,4}}>,[21/4,15/4,5/2,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,5}}>,[1/2,0,15/4,9/4,1/4,5/4,5/2],[3/2,5/2,1,-1/2,-1/2,3/4,1],"v-v-v-v-v-v-v-2-5-3-7-5">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,5/2,0,4,11/4,3/2],[5/4,9/4,1,-1/4,1,9/4,1],"v-v-v-v-v-v-2-v-4-2-5">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2">,
<Graph<7|{{1,7},{4,6},{5,6},{1,4},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,17/4,19/4,3,7/4,7/4,4],[1,0,7/4,2,1,2,1],"v-v-v-v-v-v-4-1-v-3">,
<Graph<10|{{9,10},{7,8},{5,6},{1,10},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v-1">,
<Graph<7|{{2,5},{5,6},{4,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,4,11/4],[-1/4,-1/4,1,1,1,2,2],"v-v-v-v-v-v-v&2-5&3-6-4">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,5}}>,[1/2,0,11/2,4,1/4,3,2],[7/4,11/4,1,1,-3/4,1,1],"v-v-v-v-v-v-v&3-5-2-4">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[5,5,4,3,2,1,1,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-4">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3&4-7">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5&3-6">,
<Graph<8|{{4,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,5,5,3],[1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v&v-4">,
<Graph<7|{{1,3},{1,5},{4,7},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[7/4,3,11/4,4,7/4,3/4,3],[4,4,5,21/4,23/4,4,3],"v-v-v-v-v-v-v-1-3-5-1-6&2-7-4">,
<Graph<8|{{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3">,
<Graph<7|{{2,5},{1,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,9/4,2,15/4,15/4,0,9/4],[2,5/2,15/4,11/4,1,1,3/2],"v-v-v-v-v-v-v-2-5-3-6-1">,
<Graph<10|{{9,10},{3,10},{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&4-9">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[2,13/4,5,4,3,3,2],[2,2,1,1,1,0,3/4],"v-v-v-v-v-v-v-2-4&3-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[3,4,4,4,3,2,2],[9/4,9/4,5/4,1/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5-1-6">,
<Graph<7|{{2,5},{1,5},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[4,4,2,1,5/2,2,3],[5/2,1,0,1,5/2,1,1],"v-v-v-v-v-v-v-2-5-1">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,4,4,5,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-2-v&2-4-6">,
<Graph<8|{{4,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[1,1,2,3,3,2,1,3],[1,2,2,2,3,3,3,1],"v-v-v-v-v-v-v-2&v-4&3-6">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7-4">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,0,3/2,5/2],[5/4,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4&3-5-2-6&5-7">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,5},{3,4}}>,[5/4,5/4,9/4,3/4,7/2,19/4,3/4],[1/2,3/2,3/4,-3/4,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{4,6},{5,6},{1,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[19/4,13/4,9/4,2,3,3/4,11/4],[1,11/4,11/4,7/4,3/2,1,9/2],"v-v-v-v-v-v-v-1-3-5-1-6-3&4-6">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{4,10}}>,[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-v-4">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3/4,3/4,3/4,2,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2&4-6">,
<Graph<7|{{2,5},{2,6},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[1/2,0,21/4,15/4,5/2,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,11/4,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4&3-6">,
<Graph<9|{{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&v-3">,
<Graph<10|{{5,10},{5,6},{3,8},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,5,5,2,3,4],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-3&v-4&v-5">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[2,3,7/2,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-2&4-6">,
<Graph<9|{{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{3,6}}>,[1,1,2,3,3,2,1,3,2],[1,2,2,2,3,3,3,1,1],"v-v-v-v-v-v-v&v-v-3-6">,
<Graph<7|{{4,7},{2,5},{2,6},{2,3},{1,2},{3,4},{4,5}}>,[11/4,7/4,1/2,-1/2,1/2,7/4,-1/2],[3,3,4,3,3,2,2],"v-v-v-v-v-2-v&v-4">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[13/4,9/2,1,0,1/2,9/4,5/4],[1,1,-1/4,3/4,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[3/4,3/4,3/2,5/2,2,3,3],[5/4,9/4,3,3,2,2,1],"v-v-v-v-v-v-v-5-3">,
<Graph<7|{{6,7},{2,3},{4,5},{5,6},{3,4},{1,4},{1,2},{2,5},{5,7},{1,5},{2,4}}>,[23/4,4,11/4,3/4,0,7/4,3/4],[1,1,1,-1/2,5/2,5/4,5/4],"v-v-v-v-v-v-v-5-1-4-2-5">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,5},{3,4}}>,[2,2,7/2,5,17/4,5,7/2],[1,2,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3-5-7&4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&6-3-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[3,2,3,1,13/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&5-7">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{4,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[5/2,7/2,5,1/2,5/4,5/4,1/2],[1,1,1,-1/4,3/4,9/4,3/2],"v-v-v-v-v-v-v-4-1-6-2&3-6-4">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,3},{3,4}}>,[7/2,5/2,7/4,1,-1/4,3/4,-1/4],[3,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-5&2-4">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{1,5},{1,6},{2,4},{1,7}}>,[3,5,4,7/2,3,2,2],[2,1,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4-2">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[7/4,11/4,19/4,4,17/4,11/4,11/4],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5&4-7">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[3/2,5/2,0,1/2,0,15/4,21/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&6-3-5-7">,
<Graph<7|{{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3,3,2,5/2,3/2,1,3/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-3-v&3-5">,
<Graph<10|{{5,10},{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&2-7">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[2,13/4,5,3,2,3,4],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5&3-7">,
<Graph<7|{{2,5},{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[1/2,0,3/2,5/2,0,9/4,15/4],[5/4,5/2,1,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-2-4-7-5-2">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6},{8,9}}>,[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7&3-6">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4}}>,[2,2,3,3,5,4,4],[0,1,1,2,1,1,0],"v-v-v-v-v-v-v-2-4-6&3-7-5">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[21/4,15/4,1/2,11/4,7/4,3/4,0],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3">,
<Graph<7|{{5,6},{4,5},{2,4},{1,2},{3,7},{2,3},{3,4}}>,[3/2,3/2,3/2,5/2,3,3,1/2],[1,2,3,3,7/4,3/4,3],"v-v-v-v-v-v&v-3&2-4">,
<Graph<10|{{9,10},{2,5},{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v-v-v&v-v-3&2-5">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[17/4,17/4,21/4,11/2,6,13/4,13/4],[11/4,7/4,11/4,15/4,7/4,1,11/4],"v-v-v-v-v-v-v-1-3-5-2-7-4">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,5}}>,[7/4,7/4,3,3,17/4,17/4,3],[1,2,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-1-3-5-7">,
<Graph<10|{{6,10},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v&v-3&v-6">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[2,13/4,5,4,3,7/2,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6-3&5-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[4,3,3,2,2,7/2,5],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7">,
<Graph<7|{{1,3},{1,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[4,11/4,0,5/2,0,3/2,1/2],[1,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-1-3-5">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[21/4,17/4,17/4,3,2,2,3],[1,1,9/4,9/4,9/4,5/4,1],"v-v-v-v-v-v-v-2-4-6&4-7">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-5">,
<Graph<7|{{1,3},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,5}}>,[7/4,7/4,3,3,4,17/4,13/4],[2,1,2,1,1,-1/4,-1/4],"v-v-v-v-v-v-v-5-3-1">,
<Graph<9|{{2,5},{5,6},{3,8},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4}}>,[4,3,2,2,3,4,5,1,1],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v&v-3&v-4&2-5">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5},{3,6}}>,[7/4,11/4,1/2,4,23/4,0,3/4],[1,1,-1/4,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-5&2-6-3&4-6">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[7/4,11/4,0,1/2,0,4,23/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-5-2&3-6&5-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[1,2,3/4,11/2,4,3,1/4],[1,1,-1/2,1,1,1,5/2],"v-v-v-v-v-v-v-2&4-7-3-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[3,19/4,4,17/4,3,7/4,7/4],[2,7/4,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6&2-4">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[3/4,3/4,3/2,5/2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2&3-5">,
<Graph<7|{{3,6},{3,5},{2,3},{1,2},{3,7},{3,4},{4,5}}>,[3,3,2,3/2,5/2,1,1],[1,2,2,3,3,1,2],"v-v-v-v-v-3-v&v-3">,
<Graph<7|{{4,7},{1,7},{4,6},{5,6},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[3/2,3/4,3/4,2,3,3,5/2],[3,9/4,5/4,2,2,1,3],"v-v-v-v-v-v-4-v-1-4">,
<Graph<8|{{6,8},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[5,5,4,3,2,2,3,1],[2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-4&v-6">,
<Graph<7|{{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[3,4,5,3,1,3,2],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-1-4-2-6-3">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3],[1,2,2,2,2,1,1],"v-v-v-v-v-v-v-4">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,4,4,5,9/4],[2,2,3/4,0,1,1,0],"v-v-v-v-v-v-2-v-4-6&2-5">,
<Graph<10|{{9,10},{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8&4-7">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&5-1-4-6">,
<Graph<9|{{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4}}>,[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v&v-2&4-7">,
<Graph<8|{{1,5},{7,8},{5,6},{1,4},{6,7},{5,8},{1,2},{2,3},{3,4}}>,[2,1,1,2,3,3,4,4],[2,2,1,1,2,1,1,2],"v-v-v-v-1-v-v-v-v-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[7/4,7/4,3,5,4,3,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2&3-6&4-7">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2&3-7">,
<Graph<7|{{5,6},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4},{3,6}}>,[-1/2,-1/2,1,5/2,5/2,1,5/2],[9/4,13/4,4,4,3,3,2],"v-v-v-v-v-v-3-5-v">,
<Graph<9|{{2,8},{5,6},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[4,4,3,3,2,2,1,5,1],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v&v-2&v-5&3-6">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,9/4,3,17/4,4,19/4],"v-v-v-v-v-v-v-2-4&5-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3,2,5/2,3/2,1,1,3],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-4">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[2,3,3,1,3,4,4],[1,1,2,1,0,1,0],"v-v-v-v-v-v-v&3-6-2-5">,
<Graph<7|{{3,6},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,3,15/4,9/2,9/2,3,2],[2,3/2,3/4,3/2,0,0,1],"v-v-v-v-v-v-2-v&2-4&3-6">,
<Graph<7|{{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,3/4,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3">,
<Graph<7|{{2,5},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[2,3,3,4,5,4,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4-6&2-5&3-7">,
<Graph<7|{{1,3},{2,5},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[19/4,15/4,19/4,11/2,19/4,25/4,25/4],[1/2,3/2,3/2,9/4,3,3,3/2],"v-v-v-v-v-v-v-1-3-5-2&3-7-4">,
<Graph<7|{{2,5},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4-6&2-5-3">,
<Graph<7|{{4,7},{2,6},{1,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,2,15/4,15/4,2],[1,2,1,0,0,2,1],"v-v-v-v-v-v-2-v-4-1">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/2,3/2],[5/4,5/2,1,1,-3/4,1,1],"v-v-v-v-v-v-v-2-4&2-5-3">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[5/4,2,3/4,3/2,5/2,13/4,13/4],[1,7/4,9/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-2-4">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[5,4,4,3,2,2,15/4],[1,0,1,1,1,9/4,9/4],"v-v-v-v-v-v-v-1-3&2-5&4-7">,
<Graph<8|{{2,5},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[4,3,3,2,2,1,1,4],[2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v&v-3&2-5">,
<Graph<7|{{1,3},{2,6},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[5,4,3,1,2,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&4-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3/4,3/4,7/4,5/2,13/4,13/4,9/4],[5/4,9/4,9/4,3,9/4,5/4,5/4],"v-v-v-v-v-v-v-3">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,3,3,4,4,2,1],[1,1,9/4,9/4,1,0,1],"v-v-v-v-v-v-v-3-5-2">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[3,4,5,15/4,11/4,11/4,4],[2,2,1,0,0,1,1],"v-v-v-v-v-v-v-2&3-7&4-6">,
<Graph<10|{{2,8},{5,10},{5,6},{3,9},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,4,4,3,2,1,1,5,5,2],[1,1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&v-2&v-3&v-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[2,3,19/4,4,3,3,19/4],[9/4,9/4,7/4,1,1,0,0],"v-v-v-v-v-v-v-3&2-5">,
<Graph<8|{{2,6},{4,8},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,3,1,2,3],[1,2,2,2,3,3,1,1],"v-v-v-v-v&v-2&v-3&v-4">,
<Graph<10|{{5,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,4,5,5,2],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5">,
<Graph<9|{{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{5,9},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5&4-7">,
<Graph<7|{{2,6},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[3,3,17/4,17/4,13/4,2,2],[1,2,2,1,0,1,2],"v-v-v-v-v-v-v-2-4-1-6-2">,
<Graph<10|{{5,10},{7,8},{5,6},{6,7},{4,5},{4,9},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-4&v-5">,
<Graph<10|{{5,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{3,6}}>,[5,5,4,4,3,3,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v&v-5&3-6">,
<Graph<7|{{2,5},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3/2,5/2,3,3,1],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-4&2-5">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[3,3,2,5/2,3/2,3/4,3/4],[1,2,2,3,3,9/4,5/4],"v-v-v-v-v-v-v&2-4&3-5">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,5/2,0,15/4,21/4,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-2-v-4-2-5&4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,3/4,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4">,
<Graph<7|{{5,6},{4,5},{1,2},{2,4},{3,7},{2,3},{3,5},{3,4}}>,[3,3,2,5/2,5/4,1/4,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5&2-4">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,3/4,2,3,3,5/2,5/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5&6-3-7">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,5},{3,4}}>,[1/2,0,5,1/4,7/2,5/2,3/2],[3/2,5/2,1,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&3-5&4-7">,
<Graph<7|{{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{5,7},{1,5},{3,7},{2,4},{1,7}}>,[3,11/4,1,19/4,1,7/4,3/2],[2,3,17/4,9/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7-5">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-5-7">,
<Graph<9|{{2,5},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&5-2-7">,
<Graph<7|{{2,5},{2,6},{4,7},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,5,4,4,3,9/4],[2,2,1,0,1,3/4,0],"v-v-v-v-v-2-v-4-v-2">,
<Graph<7|{{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[3,3,2,5/2,3/2,1/2,2],[1,2,2,3,3,3,1],"v-v-v-v-v-v&v-3-5">,
<Graph<7|{{1,3},{2,6},{4,7},{5,6},{1,4},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[13/4,5,9/4,9/4,9/4,1/4,5/4],[5/2,1,9/2,5/2,3/2,1,7/4],"v-v-v-v-v-v-v-4-1-3-6-2-4">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[3,2,3,1,3,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5-7">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[7/4,7/4,3,5,4,3,3],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3&4-7">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4}}>,[5,4,4,3,2,2,3],[1,0,1,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5-7-4">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/2,5/2,13/4,13/4,9/4],[5/4,9/4,3,3,9/4,5/4,2],"v-v-v-v-v-v-v-3&4-7">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,3,3,2,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-4">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[1,2,2,3,3,2,1],[2,3,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6&2-4">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v-7">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[13/4,5/2,7/4,1,0,1,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5&4-6">,
<Graph<7|{{4,7},{4,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[5,4,4,3,7/4,7/4,3],[1,1,2,2,1,2,1],"v-v-v-v-v-v-4-v-2-4">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[4,5,4,3,3,7/4,7/4],[0,1,1,1,2,2,3/4],"v-v-v-v-v-v-v-1-3-5-2&5-7">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{2,5},{5,7},{1,5},{1,7}}>,[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[0,23/4,4,1/2,11/4,7/4,3/4],[5/2,1,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2">,
<Graph<7|{{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[5,4,3,3,2,11/4,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6&2-4">,
<Graph<7|{{2,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,11/4,1,11/4,5,4,3],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-5">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2">,
<Graph<10|{{9,10},{5,10},{7,8},{5,6},{1,4},{1,10},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,3,5/2,3/2,3/4,3/4],[1,1,2,3,3,9/4,1],"v-v-v-v-v-v-v-1-3">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,0,1],"v-v-v-v-v-v-v-2-5&3-6">,
<Graph<7|{{1,3},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[9/4,3,9/4,1,-1/4,1,1],[2,5/4,0,5/2,0,3/2,1/2],"v-v-v-v-v-v-3-v-5-3-1">,
<Graph<9|{{4,7},{5,6},{3,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[4,3,3,2,1,1,2,5,4],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v-v-4&v-v-3">,
<Graph<7|{{4,7},{2,6},{2,3},{1,2},{3,4},{4,5}}>,[1,1,2,3,3,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v&v-2&v-4">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,1/2,23/4,4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-2&3-5-7-3-6&4-7">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,5},{3,4}}>,[3,3,2,2,3,17/4,17/4],[0,1,1,2,2,2,1],"v-v-v-v-v-v-v-2-5-3&5-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{1,5},{1,6},{1,7}}>,[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6-1">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[4,3,3,2,2,1,1],[2,2,1,1,2,2,1],"v-v-v-v-v-v-v&2-5">,
<Graph<9|{{2,6},{3,8},{4,9},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,3,1,2,2,3],[1,2,2,2,3,3,1,3,1],"v-v-v-v-v&v-2&v-3-v&v-4">,
<Graph<8|{{5,6},{3,8},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v&3-v-5">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[4,23/4,0,3/4,7/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4}}>,[15/4,1/2,11/4,7/4,5/2,5/2,15/4],[1,1,3/2,7/4,5/2,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-4">,
<Graph<7|{{1,3},{2,5},{5,6},{1,4},{6,7},{4,5},{2,4},{5,7},{1,2},{2,3},{3,5},{3,4}}>,[2,3,9/4,3/4,17/4,17/4,21/4],[7/4,3/2,11/4,1,1,2,2],"v-v-v-v-v-v-v-5-2-4-1-3-5">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[3/2,5/2,1/4,-1/2,2,1/4,7/4],[1/2,0,0,11/4,11/4,7/4,3/2],"v-v-v-v-v-v-3-5-2-v">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,3,5,4,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3&2-5&4-6">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4}}>,[1,2,3/2,5/2,3,5/2,1],[1,2,3,3,2,1,2],"v-v-v-v-2-v&v-2-v">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[3/4,7/4,1/2,11/2,15/4,11/4,0],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-6&2-7-3&4-7">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{4,9},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,4,4,3,2,1,5],[2,2,2,2,1,1,1,1,2],"v-v-v-v-v-v-v-v&v-4&2-7">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[5/2,3/2,0,1/2,0,15/4,9/4],[1,1,5/2,3/4,-1/2,1,5/2],"v-v-v-v-v-v-v-3-1-5-3-6">,
<Graph<7|{{4,7},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[7/4,3/4,3/4,7/4,3,3,3],[3,5/2,3/2,3/2,1,2,3],"v-v-v-v-v-v-v-1-4-7">,
<Graph<8|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&3-6">,
<Graph<9|{{5,9},{7,8},{3,8},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,1,2,3,4,5,3,2,4],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-v-3&v-5">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,5/4,3/4,5,15/4,5/2,3/4],[1/4,5/4,5/2,1,1,3/4,-3/4],"v-v-v-v-v-v-v-3-5-7-4&3-6">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,3,2],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-6">,
<Graph<7|{{1,3},{1,5},{4,7},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[3,2,2,3,3,4,5],[2,2,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[13/4,5/2,7/4,1,0,7/4,1],[9/4,3,9/4,3,17/4,19/4,4],"v-v-v-v-v-v-v-4-2-6">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{3,6}}>,[1,1,2,2,3,3,4,5,5],[1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-v&3-6">,
<Graph<10|{{9,10},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9&3-8">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[4,4,9/4,0,5/4,5/2,5/2],[1,3,15/4,5/4,2,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-1-4-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{5,7},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[19/4,13/4,9/4,11/4,3/4,2,3],[1,11/4,11/4,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&5-7-3-6">,
<Graph<9|{{7,8},{3,9},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,5,5,2],[1,2,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-5&v-3">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[15/4,21/4,1/2,7/4,3/4,0,11/4],[1,1,-1/2,1,1,5/2,1],"v-v-v-v-v-v-v-1-3-6-2&3-7&4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&5-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[4,5,4,3,3,2,2],[0,1,1,1,2,1,0],"v-v-v-v-v-v-v-1-3-5-2">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[2,3,0,1/2,0,4,11/2],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-3-5-7&3-6">,
<Graph<7|{{2,6},{5,6},{4,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,3,3,5,4,3,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&2-6-4">,
<Graph<8|{{4,8},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,4,4,2,3],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v&v-3&v-4">,
<Graph<7|{{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[3,4,5,3,2,2,4],[1,1,1,2,1,0,0],"v-v-v-v-v-v-v-1-4-2-7-3">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{4,7},{5,7},{1,7}}>,[15/4,9/2,15/4,3,1,2,2],[11/4,2,1,7/4,3/4,7/4,11/4],"v-v-v-v-v-v-v-1-3-5-7-4-6">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,1/2,0,23/4,4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[3,2,3/4,-1/4,-1/4,3/4,2],[7/2,7/2,5,5,4,4,5/2],"v-v-v-v-v-v-2-v&3-6-4">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{2,4},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[3/4,23/4,-1/4,4,11/4,7/4,3/4],[-1/4,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-7">,
<Graph<7|{{1,3},{1,5},{1,7},{1,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[0,3/2,0,13/4,5/2,5/2,1/2],[-1/4,1,9/4,7/4,-1/4,1,1],"v-v-v-v-v-1-v-3-v-1-3">,
<Graph<7|{{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,3,3,1,1],[1,2,3,2,1,2,3],"v-v-v-v-v&v-2-v&2-4">,
<Graph<9|{{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-7">,
<Graph<7|{{4,6},{2,6},{2,3},{6,7},{3,6},{4,5},{5,6},{3,4},{1,4},{1,2},{4,7},{1,6},{2,4}}>,[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2-4-6-3">,
<Graph<7|{{2,6},{1,7},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[4,3,2,3,1,3,5],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-1-4-7&2-6">,
<Graph<7|{{2,5},{2,6},{2,7},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[13/4,13/4,19/4,19/4,4,13/4,9/4],[5/2,3/2,3/2,0,3/4,0,3/2],"v-v-v-v-v-2-v-4&v-2">,
<Graph<7|{{4,6},{3,5},{2,6},{6,7},{2,3},{4,5},{5,6},{3,4},{1,2},{5,7},{2,7},{2,4}}>,[2,3,5,4,7/2,3,2],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[3,7/2,4,5,7/2,2,2],[1,0,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-7-2-4">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3-6">,
<Graph<7|{{2,6},{2,3},{3,7},{1,2},{3,4},{4,5}}>,[3,3,2,1,1,4,2],[1,2,2,2,1,2,1],"v-v-v-v-v&v-2&v-3">,
<Graph<7|{{2,6},{2,4},{2,3},{1,2},{3,7},{3,4},{4,5}}>,[1,2,3,5/2,3/2,1,3],[1,2,2,3,3,2,1],"v-v-v-v-v&v-2-4&v-3">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-1-3-5-2&3-7&4-6">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5}}>,[7/4,11/4,4,17/4,13/4,9/4,3],[9/4,9/4,1,-1/4,-1/4,1/4,1],"v-v-v-v-v-v-v-3-5-7">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,9},{2,3},{3,4}}>,[1,2,2,3,4,4,5,5,3,1],[1,1,2,2,2,1,1,2,1,2],"v-v-v-v-v-v-v-v-5&v-2&v-3">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,3,3,3,17/4,19/4,4],[9/4,9/4,1,-1/4,-1/4,7/4,1],"v-v-v-v-v-v-v-3-5&2-6">,
<Graph<7|{{1,3},{2,5},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[15/4,11/4,2,1/2,3/2,3/2,11/4],[5,5,6,5,5,4,4],"v-v-v-v-v-v-v-1-3-5-2-7&4-6">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[3,3,2,3/4,3/4,3/2,5/2],[2,1,2,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6&3-7">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[2,2,3,15/4,15/4,2,3/4],[3,2,3/2,3,4,4,3/2],"v-v-v-v-v-v-v-1-3-7-2&4-6">,
<Graph<7|{{1,7},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[11/4,15/4,21/4,0,3/4,3/2,3/4],[1,1,1,5/2,3/2,3/4,-1/4],"v-v-v-v-v-v-v-1-4-7-3">,
<Graph<7|{{2,5},{2,6},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[1/2,0,17/4,3,2,1/4,3/4],[3/2,5/2,3/4,3/4,3/4,-3/4,1/4],"v-v-v-v-v-v-v&2-4-6-2-5&3-6">,
<Graph<7|{{2,6},{3,5},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[13/4,5/2,7/4,1,0,3/4,7/4],[9/4,3,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-2-v&3-5">,
<Graph<8|{{7,8},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,2,2,3,3,1,1,1],[1,1,2,2,3,1,2,3],"v-v-v-v-v&v-v-v&3-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[0,1/2,0,3/2,5/2,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&3-7">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6&3-7">,
<Graph<7|{{2,6},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3/2,2,3,5/2,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-v-v-2-v">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,1,2,3,3,2,1],[2,1,1,1,2,3,3],"v-v-v-v-v-v-v-1-3-5">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[3,5,4,3,4,7/4,7/4],[2,1,1,1,0,3/4,2],"v-v-v-v-v-v-v-1-3-5-2&4-1-6">,
<Graph<7|{{4,6},{5,6},{4,5},{2,4},{1,2},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/2,2,3,3,5/2],[1,2,3,2,2,1,3],"v-v-v-v-v-v-4-2&v-3">,
<Graph<7|{{4,7},{2,6},{2,4},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[5/2,5/2,5/2,1,0,1,1],[7/4,11/4,4,4,3,2,3],"v-v-v-v-v-v-2-4-v">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[2,3,0,1/2,0,11/2,4],[1,1,11/4,1,-3/4,1,1],"v-v-v-v-v-v-v-2&3-5-7-3-6">,
<Graph<7|{{4,6},{2,6},{2,3},{6,7},{4,5},{5,6},{3,4},{1,4},{1,2},{2,5},{4,7},{2,7},{2,4},{1,7}}>,[3/2,0,1/2,0,21/4,15/4,5/2],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-6-4-7-2-5">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6},{4,10}}>,[5,4,3,3,2,2,1,1,5,4],[2,2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-v-4&3-6">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[5,4,3,7/4,7/4,3,4],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6-3">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,4,23/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-6-3">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,3/4,23/4,4,11/4,-1/4],[1,1,-1/4,1,1,1,5/2],"v-v-v-v-v-v-v-1-3-5-7-2&4-7-3-6">,
<Graph<10|{{5,10},{7,8},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,2,3,4,4,3,2,1,5,5],[1,1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&v-5&3-6">,
<Graph<7|{{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3/2,2,3,2,1,1,3],[1,2,3,3,3,2,1],"v-v-v-v-v-v-2-v&2-4">,
<Graph<7|{{1,3},{1,7},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[3,3,2,3/2,3/4,3/4,3],[2,3,2,3,9/4,5/4,1],"v-v-v-v-v-v-3-v-1-3">,
<Graph<10|{{9,10},{6,10},{7,8},{5,6},{6,7},{3,8},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,2,3,4,4,3,5,5],[1,2,2,1,1,1,2,2,2,1],"v-v-v-v-v-v-v-v-3&v-v-6">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4},{3,6}}>,[2,3,3,9/4,4,4,5],[9/4,9/4,1,1/4,0,1,1],"v-v-v-v-v-v-v-2-4&3-6&5-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[3,2,3,1,11/4,5,4],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-1-3-6&2-5&3-7">,
<Graph<9|{{5,6},{3,8},{4,9},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[4,4,3,2,1,1,5,3,2],[1,2,2,2,2,1,2,1,1],"v-v-v-v-v-v&v-2&v-3&v-4">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[4,23/4,0,7/4,3/4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5&2-6-3-7&4-6">,
<Graph<9|{{1,8},{7,8},{5,6},{1,9},{3,9},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,2,2,1,1,1,2,3,3],[2,2,3,3,2,1,1,1,3],"v-v-v-v-v-v-v-v-1-v-3">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[7/4,11/4,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,0],"v-v-v-v-v-v-v-2&3-6-4">,
<Graph<7|{{3,5},{6,7},{2,3},{3,6},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{5,7},{1,5},{3,7},{2,4},{1,7}}>,[3/4,2,2,3,5,3,9/4],[1,7/4,11/4,3/2,1,3,19/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7-3-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,5/4,3/4,3/4,19/4,15/4,11/4],[3/4,7/4,11/4,-3/4,1,1,1],"v-v-v-v-v-v-v-3-5&3-6&4-7">,
<Graph<7|{{2,6},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[5,3,1,11/4,2,3,4],[1,0,1,2,1,1,1],"v-v-v-v-v-v-v-1-4&2-6">,
<Graph<10|{{6,10},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{4,10}}>,[1,1,2,3,3,4,5,5,2,4],[1,2,2,2,1,1,1,2,1,2],"v-v-v-v-v-v-v-v&v-3&4-v-6">,
<Graph<7|{{4,6},{3,5},{2,6},{2,3},{6,7},{4,5},{5,6},{3,4},{1,3},{1,2},{1,5},{1,6},{2,4},{1,7}}>,[2,7/4,3,5,3,1,2],[7/4,3/4,2,5/2,3,9/2,3],"v-v-v-v-v-v-v-1-3-5-1-6-2-4-6">,
<Graph<9|{{1,8},{7,8},{1,9},{5,6},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,3,2,1,2],[2,3,3,3,2,1,1,1,2],"v-v-v-v-v-v-v-v-1-v-5">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,3},{3,4}}>,[11/4,5/2,7/4,1,-1/4,-1/4,3/4],[2,3,9/4,3,13/4,17/4,17/4],"v-v-v-v-v-v-v-4-2&5-7">,
<Graph<7|{{4,7},{1,3},{1,4},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[4,5,5,7/2,9/4,9/4,19/4],[3/4,-1/4,3/4,7/4,3/4,7/4,7/4],"v-v-v-v-v-v-4-v&3-1-4">,
<Graph<7|{{1,3},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[1,1,2,3,3,3/2,5/2],[1,2,2,2,1,3,3],"v-v-v-v-v-3-v-v-3-1">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[0,21/4,0,1/2,3/2,5/2,15/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3-6">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{3,6}}>,[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2&3-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[17/4,11/4,-1/4,1,2,2,3],[1,17/4,1,7/4,3/2,11/4,11/4],"v-v-v-v-v-v-v-1-3-5-1-6-2-7">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/2,3/2],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4-6-2-5-3">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[1/2,0,3/2,1/4,5/2,15/4,5/2],[3/2,5/2,5/4,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-4-2-6-4">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3/4,3/4,3/4,2,3,3,3],[5/4,9/4,13/4,9/4,13/4,9/4,5/4],"v-v-v-v-v-v-v-4-6">,
<Graph<7|{{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[1,2,3,3,7/4,3/4,2],[1,2,3/2,5/2,3,3,1],"v-v-v-v-v-v&v-2-4">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4}}>,[3,17/4,4,19/4,3,7/4,7/4],[1,0,1,7/4,2,1,2],"v-v-v-v-v-v-v-5-1-3&2-4">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[5,4,5,4,4,11/4,11/4],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-2-5-3">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[13/4,5/2,5/2,3/2,1/2,1,7/4],[9/4,3,4,4,4,3,9/4],"v-v-v-v-v-v-v-2-4-6-2">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,2,17/4,3,1,2,1/2],[9/4,9/4,3/4,1,1/4,5/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4-6">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[3,3,4,5,3,1,2],[1,2,1,1,0,1,1],"v-v-v-v-v-v-v-1-3-5-7-2-4&2-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[0,11/4,4,11/4,1/2,7/4,3/4],[5/2,1,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-2">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[4,5,4,3,3,7/4,7/4],[2,1,1,1,2,1,2],"v-v-v-v-v-v-v-5-1-3-5">,
<Graph<7|{{1,7},{4,6},{5,6},{6,7},{1,4},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[5,4,3,3,2,2,3],[1,1,1,2,2,1,0],"v-v-v-v-v-v-v-1-4-6-3-7">,
<Graph<7|{{2,5},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[11/4,4,5,4,3,4,11/4],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v&3-6-4-2-5">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[1,2,3,4,4,3,2],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2&3-6">,
<Graph<10|{{5,10},{7,8},{5,6},{6,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-5">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3/2,3/4,11/4,15/4,21/4,0,3/4],[3/4,-1/4,1,1,1,5/2,3/2],"v-v-v-v-v-v-v-1-3-6-2-5">,
<Graph<7|{{1,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1,2,3,4,4,5/2,2],[1,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6-1">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[4,5,7/2,2,2,3,7/2],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-2">,
<Graph<7|{{2,5},{2,6},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6-2-5">,
<Graph<7|{{2,6},{4,7},{5,6},{4,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,5/4,-1/2,-1/2,3/2,5/4],"v-v-v-v-v-v-2-v-4-2&4-6">,
<Graph<7|{{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[3,17/4,17/4,3,1,2,2],[1,1,-1/4,-1/4,1/2,2,1],"v-v-v-v-v-v-v-1-4-2-6">,
<Graph<9|{{8,9},{7,8},{3,8},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,3,3,2,1,1,4,4,5],[1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-v&3-8">,
<Graph<7|{{1,5},{1,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,2,2,4,4,2,1],[1,1,2,3/2,0,0,1],"v-v-v-v-v-v-v-3&5-1-6">,
<Graph<8|{{4,7},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,4,2],[1,2,2,2,1,1,2,1],"v-v-v-v-v-v-v-4&v-3">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{2,4},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[0,21/4,0,15/4,5/2,3/2,1/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&6-3-7">,
<Graph<8|{{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v&v-3-6">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9},{3,6}}>,[1,1,2,2,3,3,4,4,5,5],[1,2,2,1,1,2,2,1,1,2],"v-v-v-v-v-v-v-v-v-v&3-6&5-8">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[2,3,5,4,7/2,2,3],[2,2,1,1,0,1,1],"v-v-v-v-v-v-v-2-4&2-6&3-5-7">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[3/4,7/4,7/4,4,11/4,3,3],[17/4,17/4,6,11/2,21/4,17/4,13/4],"v-v-v-v-v-v-v-1-3-5-2-7-4-6">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,4,4,3,2],[7/4,7/4,7/4,3/4,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2&4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{2,4},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[0,23/4,1/2,4,11/4,7/4,3/4],[5/2,1,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-2&3-6">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,5}}>,[2,3,3/4,9/4,19/4,3,2],[7/4,3/2,1,9/2,1,11/4,11/4],"v-v-v-v-v-v-v-1-3-5&2-7-3&4-6">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,-1/4,3/4,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7-2-4">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[3/4,3/4,2,2,3,2,3/4],[1,2,2,1,2,3,3],"v-v-v-v-v-v-v-2&3-5">,
<Graph<7|{{4,6},{2,6},{2,3},{6,7},{4,5},{5,6},{3,4},{1,4},{1,2},{2,5},{2,7},{1,6},{2,4}}>,[11/4,9/4,2,3/4,3,19/4,13/4],[9/2,11/4,7/4,1,3/2,1,11/4],"v-v-v-v-v-v-v-2-4-1-6-2-5&4-6">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{5,7},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[4,4,11/4,1/2,7/4,11/4,11/4],[9/4,1,7/2,1,7/4,3/2,5/2],"v-v-v-v-v-v-v-2-4-6-2&3-7-5">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,5/2,3/2,5/2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2-4">,
<Graph<7|{{1,5},{1,7},{1,6},{1,4},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3,4,3,5,2,3,1],[0,1,2,1,1,1,1],"v-v-v-v-1-v-3-v-1-v-3">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[13/4,5/2,7/4,1,1,0,7/4],[9/4,3,19/4,4,3,17/4,9/4],"v-v-v-v-v-v-3&v-2-5">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,5}}>,[1/2,0,23/4,4,1/4,11/4,7/4],[3/2,5/2,1,1,-1/2,1,1],"v-v-v-v-v-v-v&2-4&3-5-2-6">,
<Graph<8|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5},{3,6}}>,[4,23/4,0,1/2,0,3/2,11/4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-1-3-5-2&3-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,0,23/4,4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-2&3-5&4-7-3-6">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4},{3,5}}>,[9/4,13/4,5,4,7/2,3,2],[9/4,9/4,1,1,0,1,1],"v-v-v-v-v-v-v-2&3-5-7&4-6">,
<Graph<7|{{4,6},{6,7},{2,3},{4,5},{5,6},{3,4},{1,4},{1,2},{4,7},{1,6},{2,4}}>,[5,7/2,5/2,7/4,5/4,0,0],[1,1,1,2,1/2,-1/2,5/4],"v-v-v-v-v-v-v-4-1-6-4-2">,
<Graph<7|{{1,3},{1,5},{4,7},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,2,1,5,3,3,7/4],[2,3,17/4,11/4,3,2,3/4],"v-v-v-v-v-v-v-1-3-5-1-6&3-7-4">,
<Graph<8|{{1,8},{7,8},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,4,4,3,2,1,1,2],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6},{8,9}}>,[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7&3-6">,
<Graph<10|{{9,10},{7,8},{5,6},{6,9},{1,10},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&6-9">,
<Graph<7|{{1,5},{5,6},{1,4},{6,7},{4,5},{2,4},{5,7},{1,2},{2,3},{3,4}}>,[19/4,19/4,13/4,4,3,7/4,7/4],[2,1/4,1/4,1,2,1,2],"v-v-v-v-v-v-v-5-1-4-2">,
<Graph<9|{{2,8},{3,9},{5,6},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4}}>,[5,4,3,3,2,1,1,4,2],[1,1,1,2,2,2,1,2,1],"v-v-v-v-v-v-v&v-2&3-v-5">,
<Graph<10|{{2,5},{3,10},{7,8},{5,6},{6,7},{6,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,2,2,3,3,4,4,5,5,1],[2,2,1,1,2,2,1,1,2,1],"v-v-v-v-v-v-v-v-v-6&v-3&2-5">,
<Graph<9|{{2,5},{7,8},{5,6},{6,7},{4,5},{4,9},{1,2},{2,3},{3,4}}>,[2,3,4,4,3,2,1,1,5],[1,1,1,2,2,2,2,1,2],"v-v-v-v-v-v-v-v&v-4&2-5">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,0,1/2,23/4,4,11/4],[1,1,5/2,-1/4,1,1,1],"v-v-v-v-v-v-v-2-4-6-3-5&3-7">,
<Graph<7|{{1,5},{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,9/4,15/4,0,5/2,3/2],[3/4,5/2,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-1">,
<Graph<7|{{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,3,3,2,1,1,4],[1,1,2,2,2,1,1],"v-v-v-v-v-v&v-2">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[3/4,2,3/4,5/4,4,3,2],[9/4,9/4,1,0,1/2,3/4,3/4],"v-v-v-v-v-v-v-2-4-7&5-2-6">,
<Graph<7|{{1,3},{1,5},{1,7},{4,6},{5,6},{1,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[4,3,4,21/4,5,23/4,19/4],[7/4,3/2,11/4,15/4,11/4,2,1],"v-v-v-v-v-v-v-1-3-5-1-6-4&2-7">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[3,3,2,2,4,5,4],[1,0,1,2,2,1,1],"v-v-v-v-v-v-v-1-3-5-7&2-6">,
<Graph<7|{{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[1,1,2,3,3,2,2],[1,2,2,2,3,3,1],"v-v-v-v-v-v-3-v">,
<Graph<7|{{1,3},{2,5},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[4,23/4,0,3/4,7/4,11/4,3/4],[1,1,5/2,3/2,1,1,-1/4],"v-v-v-v-v-v-v-1-3-7-2">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,3,2],[9/4,9/4,1,1,1,-1/4,-1/4],"v-v-v-v-v-v-v&2-5&3-6">,
<Graph<7|{{1,3},{2,5},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[2,3,2,3,4,2,3/4],[2,3/2,3,3,3,4,3/2],"v-v-v-v-v-v-v-1-3-7-2-5&4-6">,
<Graph<9|{{7,8},{5,6},{3,8},{4,9},{4,5},{1,2},{2,3},{3,4}}>,[4,3,3,2,1,1,5,4,2],[1,1,2,2,2,1,2,2,1],"v-v-v-v-v-v&v-v-3&v-4">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{5,7},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[1/2,11/4,4,23/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-5">,
<Graph<7|{{5,6},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[7/2,5/2,1,-1/4,3/4,-1/4,5/2],[3,3,3,13/4,17/4,17/4,2],"v-v-v-v-v-v-4&v-2">,
<Graph<7|{{2,5},{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,5}}>,[2,3,4,5,3,1,3],[1,1,1,1,2,1,0],"v-v-v-v-v-v-v-2-5-3-7-4">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[5,4,3,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4">,
<Graph<10|{{7,8},{3,9},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{4,10}}>,[1,1,2,3,4,4,5,5,2,3],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-3&v-4">,
<Graph<7|{{1,3},{2,6},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[4,4,5,4,11/4,2,2],[1,0,1,9/4,3/2,3/4,9/4],"v-v-v-v-v-v-v-4-1-3&2-6">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[5,4,5,4,4,3,3],[2,2,1,1,0,1,2],"v-v-v-v-v-v-v-2-4-6&3-5">,
<Graph<7|{{2,5},{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,5},{3,4}}>,[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2-5-3&4-7">,
<Graph<7|{{4,7},{1,3},{1,4},{2,4},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[15/4,21/4,0,0,5/2,3/2,1/2],[1,1,-1/2,5/2,1,1,5/4],"v-v-v-v-v-v-4-v&2-4-1-3">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[15/4,21/4,0,1/2,0,5/2,3/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-5">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6">,
<Graph<10|{{9,10},{5,10},{7,8},{5,6},{6,9},{1,10},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[2,1,1,2,3,4,5,5,4,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4&5-10&6-9">,
<Graph<7|{{4,6},{5,6},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[1,2,0,1,4,5,3],[1,1,11/4,-3/4,1,1,1],"v-v-v-v-v-v-3-5&v-2&4-6">,
<Graph<9|{{7,8},{5,6},{3,8},{6,7},{4,5},{5,9},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-5">,
<Graph<7|{{1,3},{2,5},{2,6},{4,7},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[3/4,7/4,7/4,11/4,11/4,15/4,11/4],[5,6,5,17/4,21/4,11/2,13/4],"v-v-v-v-v-v-v-1-3-5-2-6-4-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[11/4,4,4,3,7/4,7/4,11/4],[9/4,9/4,1,0,5/4,9/4,1],"v-v-v-v-v-v-1-v-3-1-5">,
<Graph<7|{{2,5},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[2,2,2,1,1,1,3],[1,2,3,3,2,1,2],"v-v-v-v-v-v&v-2-5">,
<Graph<8|{{2,5},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[1,1,1,2,2,3,3,2],[1,2,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-5-2">,
<Graph<7|{{1,3},{2,6},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1/2,3/2,3/2,3/2,5/2,5/2,7/2],[17/4,13/4,17/4,6,21/4,17/4,6],"v-v-v-v-v-v-v-4-1-3-6-2">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7-5">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&2-9">,
<Graph<7|{{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[13/4,13/4,17/4,17/4,3,2,2],[5/4,9/4,9/4,5/4,1/4,5/4,9/4],"v-v-v-v-v-v-v-2-4-1-6">,
<Graph<9|{{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,2,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-4">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[2,3,3,5,4,13/4,1],[1,1,2,1,1,0,1],"v-v-v-v-v-v-v-3-5&4-6">,
<Graph<9|{{2,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,2,2,3,4,5,5,3,1],[1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v&v-2&v-3">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4}}>,[4,5,3,1,5/2,2,3],[1,1,0,3/4,9/4,1,1],"v-v-v-v-v-v-v-1-3-7-5-2">,
<Graph<7|{{4,7},{2,6},{2,4},{2,3},{1,2},{3,4},{4,5}}>,[13/4,5/2,5/2,3/2,1/2,7/4,1/2],[9/4,3,4,4,4,9/4,3],"v-v-v-v-v&v-2-4-v">,
<Graph<7|{{1,7},{5,6},{1,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[2,2,2,3,4,4,1],[-1/4,3/4,2,3/2,2,1/2,3/4],"v-v-v-v-v-v-1-v-3-5">,
<Graph<8|{{2,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,1],[1,2,2,1,1,2,3,3],"v-v-v-v-v-v-v&v-2&3-6">,
<Graph<7|{{1,3},{2,6},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[4,4,5,3,3,2,2],[1,0,1,2,1,1,2],"v-v-v-v-v-v-v-4-1-3&2-6-4">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,9},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-4&v-3&5-8">,
<Graph<7|{{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-3">,
<Graph<7|{{1,3},{1,5},{4,7},{1,7},{4,6},{1,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[3,5,4,3,3,2,1],[0,1,1,2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6-4-2&4-7">,
<Graph<8|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v&2-7&3-6">,
<Graph<7|{{2,6},{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-2-6-3">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{2,5},{5,7},{1,5},{1,6},{1,7}}>,[1/2,11/4,7/4,3/4,0,23/4,4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-5-7">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2},{6,7},{3,4},{4,5}}>,[1,2,5/2,3/2,1,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-2-v-v-2-4">,
<Graph<7|{{2,5},{2,6},{3,5},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[2,3,5,4,4,3,2],[2,2,1,0,1,3/4,1],"v-v-v-v-v-2-v&v-2&3-5">,
<Graph<7|{{2,6},{5,6},{4,6},{4,5},{2,4},{5,7},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[3/4,7/4,11/4,0,4,1/2,4],[1,1,1,5/2,1,-1/4,-1/4],"v-v-v-v-v-v-2-4-6-3-5-v">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{2,5},{5,7},{1,5},{1,6},{2,4},{1,7}}>,[17/4,3,3/4,2,9/4,17/4,7/2],[1,3/2,1,7/4,11/4,7/2,11/4],"v-v-v-v-v-v-v-1-3-5-1-6&4-2-5-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{3,7},{2,3},{3,5},{3,4}}>,[1,2,3,1/4,1,3,17/4],[1,1,1,9/4,-3/4,-3/4,5/4],"v-v-v-v-v-v-v-3-5-7-4-2">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[2,2,3/4,2,4,4,3],[11/4,7/4,1,15/4,3,1,3/2],"v-v-v-v-v-v-v-1-3-6-4&2-7-3">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,3,2,1,1],[1,2,1,2,3,3,2],"v-v-v-v-v-v-v-2-4&5-2-6">,
<Graph<7|{{2,5},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,4,5,4,2],[2,2,1,1,1,0,1/2],"v-v-v-v-v-v-v-2-5&4-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{5,7},{1,5},{1,6},{2,4},{1,7}}>,[2,3,5,9/4,3/4,3,2],[11/4,3,1,19/4,1,3/2,7/4],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&5-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3/4,3/4,3/4,7/4,11/4,11/4,11/4],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v-4-2">,
<Graph<8|{{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[1,1,2,2,3,3,4,4],[1,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,3},{3,4}}>,[7/2,5/2,7/4,1,1,-1/4,-1/4],[3,3,9/4,3,17/4,17/4,13/4],"v-v-v-v-v-v-v-5-2-4">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5}}>,[5/2,3/2,0,1/2,0,9/4,15/4],[1,1,5/2,1,-1/2,-1/2,1],"v-v-v-v-v-v-v-3-1-5-3&5-7">,
<Graph<7|{{2,6},{5,6},{4,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[0,0,9/2,3,2,5/4,1],[5/4,5/2,1,1,1,0,3/2],"v-v-v-v-v-v-2-v&2-4-6-3">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[1,2,3,3,4,5,13/4],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-4&5-7">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-5&2-7-3">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[5/2,3/2,1,1/4,1,5,7/2],[1,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-v-1-3-5-7-3-6">,
<Graph<10|{{9,10},{3,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-v-3&5-8">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{8,9}}>,[2,3,4,5,5,4,3,2,1],[1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v&2-7">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,5}}>,[3/4,3/4,5/4,2,5/2,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6&3-5">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,5},{3,6}}>,[1,2,3,3,4,5,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-4-7&3-6">,
<Graph<7|{{1,5},{1,7},{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[2,2,3,4,4,3,1],[0,1,2,2,1,1,1],"v-v-v-v-v-v-3-v-1-5-3">,
<Graph<9|{{5,6},{3,8},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,2,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-v&v-3-6&v-4">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{2,5},{5,7},{1,5},{2,4}}>,[11/4,1/2,4,23/4,0,7/4,3/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-5-1-3-5-2-4">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6-3-7">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[2,9/4,4,3,3,0,5/4],[5/2,3/2,1,5/2,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[4,19/4,3,7/4,7/4,3,19/4],[1,7/4,7/4,2,1,1/4,1/4],"v-v-v-v-v-v-v-1-3-5&2-7&3-6">,
<Graph<7|{{2,5},{2,6},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[1,2,3,3,2,2,1],[1,2,2,3,3,1,2],"v-v-v-v-v-2-v&v-2">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[0,3/2,0,7/4,5/2,7/4,1/2],[-1/4,1,9/4,9/4,1,-1/4,1],"v-v-v-v-v-v-1-v-3-1-5-3">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4}}>,[3/4,0,1/2,23/4,4,11/4,7/4],[1,5/2,-1/4,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&2-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4},{3,6}}>,[3,5,1,2,2,7/4,3],[3,11/4,17/4,3,2,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&2-6-3&5-7">,
<Graph<8|{{2,8},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,2,3,4,5,5,4,1],[1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-4&v-2">,
<Graph<8|{{1,8},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,2,3,4,4,3,2,1],[1,1,1,1,2,2,2,2],"v-v-v-v-v-v-v-v-1">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[7/4,11/4,0,1/2,0,23/4,4],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[1/2,0,1/4,5/4,5/2,7/2,5],[3/2,5/2,-1/2,3/4,1,1,1],"v-v-v-v-v-v-v-2-5-3-6&3-7">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[3/4,7/4,3,2,3,7/4,3/4],[1,1,3/2,2,5/2,3,3],"v-v-v-v-v-v-v&3-5">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{6,7},{1,4},{4,5},{5,7},{1,2},{2,3},{3,4},{3,5}}>,[3/4,11/4,4,23/4,-1/4,7/4,3/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6&5-7">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[3/4,7/4,11/4,0,4,23/4,1/2],[1,1,1,5/2,1,1,-1/4],"v-v-v-v-v-v-v-2-4-6&4-7-3-5">,
<Graph<10|{{9,10},{5,10},{7,8},{5,6},{6,7},{6,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,2,3,4,5,5,4,3],[1,2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-v-5&6-9">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[3,3,3,17/4,17/4,17/4,2],[1/4,5/4,5/2,5/2,5/4,1/4,5/2],"v-v-v-v-v-v&v-3-5-2">,
<Graph<7|{{1,3},{5,6},{1,4},{6,7},{4,5},{5,7},{1,2},{2,3}}>,[13/4,17/4,17/4,9/4,5/4,5/4,9/4],[-1/4,3/4,-1/4,-1/4,3/4,7/4,7/4],"v-v-v-1-v-v-v-v-6">,
<Graph<7|{{1,3},{2,6},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[9/4,3,5,3/4,3,2,2],[19/4,3,1,1,3/2,11/4,7/4],"v-v-v-v-v-v-v-4-1-3-6-2&4-6">,
<Graph<7|{{2,6},{3,5},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[13/4,5/2,3/4,-1/4,-1/4,7/4,1],[9/4,3,4,4,5,9/4,3],"v-v-v-v-v-3&v-2-v">,
<Graph<7|{{2,6},{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[7/4,13/4,5/2,13/4,19/4,19/4,4],[7/4,7/4,1,1/4,1/4,7/4,1],"v-v-v-v-v-v-v-2-4-7&2-6">,
<Graph<7|{{1,3},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[7/4,3/4,0,23/4,4,1/2,11/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-7-3-6-4">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[7/2,5/2,7/4,1,0,0,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7">,
<Graph<8|{{2,5},{4,8},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,2,3,3,2,1,4,4],[1,1,1,2,2,2,1,2],"v-v-v-v-v-v&v-3&v-4&2-5">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/2,2,2,3,3],[5/4,9/4,3,2,1,2,3],"v-v-v-v-v-v-v-3&4-6">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[2,2,3,3,4,5,3],[0,1,0,1,1,1,2],"v-v-v-v-v-v-v-2-4-7&3-6">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{4,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4}}>,[5,7/2,5/2,0,3/2,0,1/2],[1,1,5/4,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-2&4-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{4,7},{5,7},{2,4},{1,7}}>,[5,4,7/2,3,2,2,3],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5-7-4-2">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,4,5,3,2,3,1],[1,1,1,0,1,2,1],"v-v-v-v-v-v-v-4-1-6-2&3-6">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[4,13/4,15/4,11/4,7/4,3/4,2],[15/4,3,1,3/2,7/4,1,3],"v-v-v-v-v-v-v-1-3-6-4-7-2&3-7">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{4,7},{5,7},{1,5},{1,7}}>,[1/2,11/4,4,11/4,0,3/4,7/4],[-1/4,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[9/4,13/4,19/4,4,19/4,13/4,9/4],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4-6&3-5">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{2,5},{5,7},{1,6},{1,7}}>,[3,5,4,3,3,2,1],[0,1,1,1,2,1,1],"v-v-v-v-v-v-v-1-3-5-2&4-1-6&5-7">,
<Graph<7|{{2,5},{2,6},{5,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[1/2,3/2,1/2,5,7/2,5/2,3/2],[2,2,-1/4,1,1,1,1],"v-v-v-v-v-v-2-v&3-6&4-2-5">,
<Graph<10|{{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{4,10}}>,[1,1,2,3,4,5,5,4,2,3],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-4">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[15/4,3,7/4,7/4,3/4,7/4,15/4],[25/4,11/2,25/4,5,5,4,19/4],"v-v-v-v-v-v-v-1-3-5&2-7&4-6">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[13/4,19/4,4,19/4,13/4,7/4,7/4],[1/4,1/4,1,7/4,7/4,1,2],"v-v-v-v-v-v-v-5-1-3-5&2-4">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[4,3,2,1,1,2,3],[2,2,2,2,1,1,1],"v-v-v-v-v-v-v-2">,
<Graph<9|{{4,7},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,4,5,2],[1,2,2,2,1,1,2,2,1],"v-v-v-v-v-v-v-v&v-3&4-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,2,2,1,1,1,5/2],[2,2,3,3,2,1,1],"v-v-v-v-v-v-v-1-3&2-5">,
<Graph<7|{{4,6},{2,6},{6,7},{2,3},{4,5},{5,6},{3,4},{1,4},{1,2},{2,7},{1,6},{2,4}}>,[3,19/4,13/4,9/4,2,3/4,11/4],[3/2,1,11/4,11/4,7/4,1,9/2],"v-v-v-v-v-v-v-2-4-1-6-2&4-6">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[7/4,1,3,19/4,11/4,1,3/2],[7/4,3/4,2,9/4,3,17/4,11/4],"v-v-v-v-v-v-v-2-4-6-2&3-5&6-3-7">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[3,4,5,4,4,3,3],[2,2,1,0,1,1,0],"v-v-v-v-v-v-v&3-5-2-6-4">,
<Graph<7|{{2,5},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[11/4,0,5/2,4,1/2,7/4,3/4],[1,5/2,5/2,1,-1/4,1,1],"v-v-v-v-v-v-v-2-4-1-6&2-5">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4},{3,5},{3,6}}>,[2,2,3/4,3,5,9/4,3],[11/4,7/4,1,3/2,1,19/4,3],"v-v-v-v-v-v-v-1-3-5-1-4&3-6&5-7">,
<Graph<7|{{4,7},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3/4,7/4,11/4,2,3,2,1],[3,3,3,2,1,1,3/2],"v-v-v-v-v-v-4-v">,
<Graph<10|{{9,10},{7,8},{5,6},{1,4},{6,7},{1,10},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[4,5,5,4,3,2,1,1,2,3],[1,1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-v-1-4">,
<Graph<8|{{1,8},{4,7},{7,8},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[3,3,2,2,1,1,2,3],[2,1,1,2,2,3,3,3],"v-v-v-v-v-v-v-v-1-4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{1,6},{6,7},{1,4},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[3,4,5,3,2,3,1],[1,1,1,2,1,0,1],"v-v-v-v-v-v-v-4-1-6-2-4&3-6">,
<Graph<7|{{4,7},{5,6},{1,6},{4,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[5/2,15/4,21/4,0,3/2,0,1/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-4-1-6-3&4-6">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[1,2,3,0,1,4,5],[1,1,1,11/4,-3/4,1,1],"v-v-v-v-v-v-v-4-6&5-7">,
<Graph<8|{{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,3,2],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-v-v-3-6">,
<Graph<7|{{1,7},{5,6},{1,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,2,3/2,3/4,5/4,5/2,3],[2,2,3,9/4,1,1,3],"v-v-v-v-v-v-1-v-3">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4}}>,[1,3,2,3,4,5,3],[1,2,1,1,1,1,0],"v-v-v-v-v-v-v-1-3-7-5-2-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[2,2,17/4,3,11/4,-1/4,1],[11/4,3/2,1,11/4,17/4,1,7/4],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[2,3,3,17/4,17/4,3,2],[2,2,1,1,-1/4,-1/4,3/4],"v-v-v-v-v-v-v-2-4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4}}>,[0,1/2,0,21/4,15/4,5/2,3/2],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-7">,
<Graph<9|{{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{8,9}}>,[1,1,1,2,3,3,2,2,3],[1,2,3,3,3,2,2,1,1],"v-v-v-v-v-v-v-v-v&2-7-4">,
<Graph<7|{{1,3},{4,7},{4,6},{5,6},{6,7},{1,4},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[4,23/4,1/2,0,11/4,7/4,3/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-4-1-3-6-4-2">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4}}>,[4,5,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3&2-5">,
<Graph<10|{{5,10},{3,10},{7,8},{5,6},{6,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&3-v-5">,
<Graph<10|{{2,5},{6,10},{4,7},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,2,2,3,3,4,4,5,1,5],[1,1,2,2,1,1,2,2,2,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5&4-7">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[1,2,3,17/4,19/4,4,3],[1,1,1,0,7/4,1,2],"v-v-v-v-v-v-v-2&4-6-3-7-5">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[23/4,1/2,0,3/4,7/4,11/4,4],[1,-1/4,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-2-7-3">,
<Graph<7|{{1,3},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[3,3,2,5/2,3/2,3/4,3/4],[1,2,5/4,3,3,9/4,5/4],"v-v-v-v-v-v-v-3-1">,
<Graph<10|{{2,5},{7,8},{4,7},{3,10},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5&4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,4,4,5,9/4],[9/4,9/4,1,0,1,1,1/4],"v-v-v-v-v-v-2-v-4-6">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[7/4,3/4,0,11/2,15/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&3-7-4">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-6-2-5&3-7">,
<Graph<9|{{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,3,2],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3">,
<Graph<9|{{1,8},{2,5},{7,8},{3,9},{1,9},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v-1-v-3&5-2-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4},{3,5}}>,[2,3,19/4,4,17/4,3,3],[9/4,9/4,7/4,1,0,0,1],"v-v-v-v-v-v-v-2&3-5-7">,
<Graph<8|{{2,5},{5,6},{3,8},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,2,2,1,1,1,3,3],[1,2,3,3,2,1,2,3],"v-v-v-v-v-v&v-2-5&v-3">,
<Graph<7|{{4,6},{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[2,3,3/4,5/2,4,5,3/4],[1,3/4,5/2,-1,3/4,1,5/4],"v-v-v-v-v-v-3-v&3-5&4-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,2,3,4,5,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6&4-1-5">,
<Graph<10|{{5,10},{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,5,4,3,3,2,2,1,1,4],[1,2,2,2,1,1,2,2,1,1],"v-v-v-v-v-v-v-v-v&3-v-5">,
<Graph<7|{{2,5},{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[2,13/4,5,4,4,3,2],[9/4,9/4,1,0,1,1,1],"v-v-v-v-v-v-v-2-5-3&4-7">,
<Graph<8|{{1,8},{7,8},{5,6},{1,4},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[2,1,1,2,3,4,4,3],[1,1,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-1-4&5-8">,
<Graph<7|{{1,3},{1,5},{1,7},{4,6},{1,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[3,4,4,3,3,2,2],[2,2,1,0,1,1,2],"v-v-v-v-v-v-v-1-3-5-1-6-4">,
<Graph<7|{{1,3},{2,5},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[4,5,4,3,4,2,2],[0,1,1,1,2,2,1],"v-v-v-v-v-v-v-1-3-5-2&4-7">,
<Graph<7|{{5,6},{4,5},{1,2},{5,7},{2,3},{3,4},{3,6}}>,[1,1,2,3,3,2,4],[1,2,2,2,1,1,1],"v-v-v-v-v-v-3&v-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,1/4,3/4,3,3,2,1],[9/4,9/4,0,0,1,1,1],"v-v-v-v-v-v-v-3-5-2&3-6">,
<Graph<7|{{3,6},{3,5},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3/4,3/4,2,3,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v-3-5&v-2">,
<Graph<9|{{1,5},{7,8},{5,6},{1,4},{6,7},{6,9},{1,2},{2,3},{3,4},{8,9}}>,[2,1,1,2,3,4,4,5,5],[2,2,1,1,2,2,1,1,2],"v-v-v-v-1-v-v-v-v-v-7">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4}}>,[1,7/4,11/4,1/2,5,15/4,3/4],[7/4,1,1,11/4,1,1,-1/2],"v-v-v-v-v-v-v-3&5-7-4-6">,
<Graph<7|{{2,5},{5,6},{4,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,4,9/4],[9/4,9/4,1,1,1,0,1/4],"v-v-v-v-v-v-v-2-5&3-6-4">,
<Graph<7|{{1,3},{1,7},{5,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[1,1,2,3,3,3,1],[2,1,2,3,2,1,3],"v-v-v-v-v-v-3-v-1-3-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[4,23/4,0,3/4,7/4,11/4,1/2],[1,1,5/2,1,1,1,-1/4],"v-v-v-v-v-v-v-1-3-6&2-7-3">,
<Graph<7|{{2,5},{4,6},{5,6},{6,7},{4,5},{5,7},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[2,1,2,7/4,5,3,3],[3,9/2,7/4,3/4,5/2,2,3],"v-v-v-v-v-v-v-2-4-6-3-7-5-2">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[2,3,7/2,4,5,4,2],[1,1,0,1,1,2,2],"v-v-v-v-v-v-v-1-3-5&2-6-4">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,3,2,1,1,2,3/2],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-6-3">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[7/4,7/4,3,5,4,3,4],[3/4,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[1,2,3,3/4,3,17/4,1/2],[1,1,1,-3/4,-3/4,5/4,2],"v-v-v-v-v-v-v-2&3-6-4-7">,
<Graph<7|{{1,3},{5,6},{1,4},{6,7},{5,7},{1,2},{2,3},{3,5},{3,4}}>,[3,17/4,17/4,3,11/4,7/4,7/4],[-1/4,-1/4,1,1,2,1,2],"v-v-v-v-1-3-v-v-v-7">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[5,4,4,3,2,1,1,2,3],[2,2,1,1,1,1,2,2,2],"v-v-v-v-v-v-v-v-v-2">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/4,7/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-4">,
<Graph<7|{{1,3},{2,6},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5&2-6&4-7">,
<Graph<7|{{3,6},{3,5},{2,3},{1,2},{6,7},{3,4},{4,5}}>,[3/4,3/4,2,3/2,5/2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-3-v-v">,
<Graph<7|{{2,5},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[2,3,3,4,5,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6&2-5">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2&3-6">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[7/2,13/4,9/4,1,2,3,4],[4,3,11/4,5/4,7/4,5/4,9/4],"v-v-v-v-v-v-v-1-3-5&2-7-3-6-4">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,5,4,3,7/4,7/4,3],[2,1,1,1,1,2,2],"v-v-v-v-v-v-v-1-3-7-4">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[2,3,5,4,3,4,2],[2,2,1,1,1,0,0],"v-v-v-v-v-v-v-2-4-6-3">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,9},{2,3},{3,4}}>,[3,4,4,3,2,1,1,2,5],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&v-2">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,5,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-2">,
<Graph<7|{{4,7},{2,6},{2,3},{1,2},{3,4},{4,5},{5,6}}>,[1,1,2,3,2,1,3],[1,2,2,2,3,3,1],"v-v-v-v-v-v-2&v-4">,
<Graph<9|{{2,5},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[3,4,5,5,4,3,2,1,1],[1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v&2-5">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,5/2,15/4,21/4,0,3/2],[5/4,5/2,1,1,1,-1/2,1],"v-v-v-v-v-v-v-2-4-6-2-5&3-7">,
<Graph<10|{{9,10},{4,7},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2,1],[1,1,1,1,1,2,2,2,2,2],"v-v-v-v-v-v-v-v-v-v&4-7">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,21/4,1/4,1,5/2,15/4],[3/2,5/2,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7-4">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4}}>,[5,4,13/4,1,3,3,2],[1,1,0,1,2,1,1],"v-v-v-v-v-v-v-5-1-3">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,3,7/2,7/4,7/4,3,5],[1,1,0,3/4,2,2,1],"v-v-v-v-v-v-v-1-3-7&4-6">,
<Graph<7|{{3,6},{3,5},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[3,3,2,1,1,3/2,3],[1,2,2,3,2,1,3],"v-v-v-v-v-3-v&v-2">,
<Graph<7|{{2,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[3/2,0,1/2,0,21/4,15/4,11/4],[1,-1/2,1,5/2,1,1,1],"v-v-v-v-v-v-v-1-4-2-5">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4}}>,[7/4,7/4,3,17/4,4,19/4,3],[0,1,1,0,1,7/4,2],"v-v-v-v-v-v-v-2&3-7-5&4-6">,
<Graph<7|{{3,5},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3/4,3/4,2,2,3,3,3/4],[1,2,2,3,2,1,3],"v-v-v-v-v-v&v-2&3-5">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,17/4,1/4,3/4,2,3],[7/4,11/4,1,-1/2,1/2,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-7">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[2,3,4,3,2,7/2,5],[2,2,1,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5&3-7">,
<Graph<9|{{4,7},{5,6},{6,9},{6,7},{3,8},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,4,2,5],[1,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-4&v-3&v-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,5,4,3,2,3,1],[2,1,1,1,1,0,1],"v-v-v-v-v-v-v-1-3-6-2&4-1-5">,
<Graph<7|{{2,6},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[3,4,9/4,0,5/4,2,3],[17/4,1,3/2,1,7/4,5/2,5/2],"v-v-v-v-v-v-v-2-4-1-6-2&3-6">,
<Graph<10|{{6,10},{7,8},{5,6},{3,8},{6,7},{4,5},{5,9},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2,5,5],[1,2,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v-3&v-5&v-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{2,5},{4,7},{5,7},{1,5},{1,7}}>,[1/2,23/4,4,11/4,0,3/4,7/4],[-1/4,1,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-7-5-2">,
<Graph<7|{{4,7},{2,6},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[7/4,11/4,13/4,13/4,17/4,17/4,9/4],[9/4,9/4,5/4,1/4,5/4,9/4,1],"v-v-v-v-v-v-2-v-4">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{2,4},{5,7},{1,2},{2,7},{2,3},{3,4}}>,[19/4,15/4,11/4,11/4,15/4,19/4,19/4],[2,2,2,1,1,0,1],"v-v-v-v-v-v-v-2-4&2-5-7">,
<Graph<7|{{5,6},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[9/4,13/4,19/4,4,13/4,19/4,9/4],[11/4,11/4,7/4,1,1/4,1/4,7/4],"v-v-v-v-v-v-3&v-2&4-6">,
<Graph<7|{{1,3},{2,6},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[13/4,5,4,3,2,3,1],[0,1,1,1,1,2,1],"v-v-v-v-v-v-v-1-3-6-2&4-6">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3/4,3/4,3/4,7/4,3,3,3],[1,2,3,2,3,2,1],"v-v-v-v-v-v-v&2-4-6">,
<Graph<9|{{7,8},{3,9},{5,6},{6,7},{5,9},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,3,4,5,5,2],[1,2,2,2,1,1,1,2,1],"v-v-v-v-v-v-v-v&3-v-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[11/4,3,2,3/4,3/4,3/2,11/4],[2,1,5/4,5/4,9/4,3,3],"v-v-v-v-v-v-v-1-3-6">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4}}>,[13/4,19/4,4,19/4,11/4,7/4,7/4],[1/4,1/4,1,7/4,2,2,1],"v-v-v-v-v-v-v-1-3&2-4&5-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[7/4,5/2,7/2,9/2,0,1,3/2],[-1,1/2,1,5/4,11/4,7/4,1/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7">,
<Graph<10|{{3,10},{5,6},{6,7},{4,9},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v&v-v-4&v-3">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5}}>,[2,3,4,11/2,0,1/2,0],[1,1,1,1,11/4,1,-3/4],"v-v-v-v-v-v-v-3-5-7-4">,
<Graph<7|{{2,6},{4,6},{5,6},{4,5},{1,2},{2,4},{3,7},{2,3},{3,4},{3,6}}>,[1/2,0,5/2,1/4,5/2,15/4,3/2],[3/2,5/2,1,-1/4,-1/4,1,1],"v-v-v-v-v-v-2-4-6-3-v">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5-7-3-6-4">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{4,9},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-4&v-3">,
<Graph<7|{{4,7},{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,3},{3,4}}>,[5/4,5/4,5/2,1/2,1,15/4,19/4],[1/4,5/4,1,9/4,-3/4,1,1],"v-v-v-v-v-v-v-4-2&4-6&5-7">,
<Graph<7|{{2,5},{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,3/2,1/4,5,7/2,5/2],[3/2,5/2,5/4,-1/2,1,1,5/4],"v-v-v-v-v-v-v-2-4-6&2-5&4-7">,
<Graph<7|{{2,6},{4,7},{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,5},{3,4}}>,[1/2,0,3/2,0,5/2,15/4,21/4],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-6-2&3-5&4-7">,
<Graph<10|{{9,10},{7,8},{1,7},{5,6},{1,6},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[3,4,5,5,4,3,2,1,1,2],[2,2,2,1,1,1,2,2,1,1],"v-v-v-v-v-v-1-v-v-v-v-8">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/2,5/2,3,2,2],[5/4,9/4,3,3,2,1,2],"v-v-v-v-v-v-v-3&4-7-5">,
<Graph<7|{{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[11/4,7/4,0,5/2,0,3/2,1/2],[9/4,9/4,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-3">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{2,4},{1,2},{3,7},{2,3},{3,4},{3,5}}>,[1/2,3/4,0,7/4,11/4,15/4,21/4],[-1/2,1,5/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4&3-7">,
<Graph<7|{{2,5},{4,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,3/2,0,21/4,15/4,5/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-v-v-2-4-7&2-5">,
<Graph<7|{{1,7},{1,6},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[2,2,3,17/4,17/4,3,1],[0,1,2,5/2,3/2,0,1],"v-v-v-v-v-3-v-1-v-3">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[3/4,7/4,1/2,0,11/2,15/4,11/4],[1,1,-1/4,5/2,1,1,1],"v-v-v-v-v-v-v-2-4-7-3-5">,
<Graph<10|{{9,10},{3,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,5,5,3,2],[1,2,2,2,2,1,1,2,1,1],"v-v-v-v-v-v-v-v-5&v-v-3">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3,17/4,17/4,3,2,2,1],[-1/4,-1/4,1,1,1,2,1/2],"v-v-v-v-v-v-v-1-3-6-4-1">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4}}>,[2,2,13/4,19/4,4,19/4,13/4],[2,1,7/4,7/4,1,1/4,1/4],"v-v-v-v-v-v-v-3&4-6&5-7">,
<Graph<7|{{2,5},{2,6},{4,7},{4,6},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,21/4,0,15/4,5/2,3/2],[5/4,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[4,5,3,3/2,3/2,3,3],[1,1,2,2,1,0,1],"v-v-v-v-v-v-v-1-3-5&2-6">,
<Graph<9|{{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4}}>,[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2&4-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,4}}>,[3/4,3/4,3/4,9/4,11/4,11/4,7/4],[1,2,3,3,2,1,2],"v-v-v-v-v-v-v-2&3-7-5">,
<Graph<8|{{2,5},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,3,4,4,3,2,1,1],[1,1,1,2,2,2,2,1],"v-v-v-v-v-v-v-v&2-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,4},{3,5}}>,[2,3,4,4,3,1,3],[1,1,1,9/4,9/4,1,0],"v-v-v-v-v-v-v-2-5-3-7">,
<Graph<7|{{2,5},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,23/4,4,1/4,1,3/2],[3/2,5/2,1,1,-1/2,1/4,3/2],"v-v-v-v-v-v&v-2-4&2-5-3">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[2,2,1,1,2,3,3],[1,2,2,3,3,3,2],"v-v-v-v-v-v-v-2-4&2-5">,
<Graph<10|{{9,10},{7,8},{1,6},{5,6},{1,10},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[3,2,1,1,2,3,4,5,5,4],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-1-6">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3/4,7/4,3,3,2,2,3/4],[3,3,3,2,1,2,3/2],"v-v-v-v-v-v-v&3-6-4">,
<Graph<10|{{9,10},{7,8},{5,6},{1,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[4,5,5,4,3,3,2,1,1,2],[2,2,1,1,1,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&4-1-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[3,5,1,2,2,7/4,3],[3,5/2,9/2,3,7/4,3/4,2],"v-v-v-v-v-v-v-1-3-5-1-4&3-6-2-7-5">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{2,4},{1,2},{5,7},{2,7},{2,3},{3,4}}>,[7/2,5/2,7/4,1,-1/4,-1/4,1],[3,3,9/4,3,3,17/4,17/4],"v-v-v-v-v-v-v-2-4-7-5">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[3,3,2,2,3/4,3/4,3/4],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-4&3-6">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3],[1,2,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-v-4&5-8">,
<Graph<7|{{4,7},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[9/4,9/4,9/4,1,0,1,1],[2,3,4,4,3,2,3],"v-v-v-v-v-v-2-v-4-2">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{2,7},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,5/4,3/4,5,15/4,3/4,5/2],[1/4,5/4,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&3-5&4-6-3-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[3,2,1,1,0,0,5/4],[7/2,7/2,9/2,7/2,7/2,9/4,9/4],"v-v-v-v-v-v-v-2-4&3-5">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{1,5},{2,7},{1,6},{2,4},{1,7}}>,[7/4,7/4,11/4,4,3,3,3/4],[4,23/4,5,21/4,4,3,4],"v-v-v-v-v-v-v-1-3-5-1-6-4-2-7">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[4,5,7/2,7/4,7/4,3,3],[1,1,2,2,3/4,0,1],"v-v-v-v-v-v-v-1-3-7&2-6">,
<Graph<7|{{1,3},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4}}>,[2,3,2,3/4,2,4,4],[11/4,3/2,7/4,1,15/4,11/4,1],"v-v-v-v-v-v-v-4-1-3&2-4&5-7">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{6,7},{4,5},{2,4},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[1/2,3/2,0,5/2,15/4,21/4,0],[1,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5&2-4-7-3-6">,
<Graph<7|{{2,5},{2,6},{4,7},{4,6},{1,4},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[1/2,0,21/4,0,15/4,5/2,3/2],[1,5/2,1,-1/2,1,1,1],"v-v-v-v-v-2-v-4-v-2-4-1">,
<Graph<8|{{2,8},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[1,1,2,3,3,2,2,1],[1,2,2,2,3,3,1,3],"v-v-v-v-v-v-3-v&v-2">,
<Graph<7|{{1,3},{4,7},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[7/4,11/4,11/4,11/4,4,4,1/2],[7/4,3/2,5/2,7/2,11/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-2">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[1,2,3,5,4,3,3],[1,1,0,1,1,1,2],"v-v-v-v-v-v-v-1-3-6&2-7-4">,
<Graph<7|{{4,6},{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{4,7},{1,5},{1,7}}>,[0,3/4,7/4,1/2,11/4,15/4,21/4],[5/2,1,1,-1/2,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6&4-7">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[3,4,4,5,9/2,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4&3-7">,
<Graph<7|{{1,3},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[3/2,3/2,3,5,4,3,3],[1,2,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-6&4-7">,
<Graph<7|{{4,6},{2,6},{2,3},{6,7},{4,5},{5,6},{3,4},{1,4},{1,2},{4,7},{2,4},{1,7}}>,[13/4,9/4,5/4,3/4,1/4,3/4,9/2],[1,1,1,5/2,1,-1/2,1],"v-v-v-v-v-v-v-1-4-2-6-4-7">,
<Graph<7|{{1,3},{1,5},{2,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[15/4,21/4,0,5/2,0,3/2,1/2],[1,1,5/2,1,-1/2,1,1],"v-v-v-v-v-v-3-v-5-1-3-5-2">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{5,7},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[3/2,5/2,9/4,13/4,9/2,11/4,1/2],[7/4,3/2,5/2,5/2,1,9/2,1],"v-v-v-v-v-v-v-1-3-5-7-2&3-6-4">,
<Graph<9|{{7,8},{5,6},{4,5},{1,2},{2,9},{3,7},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,2,3,1],[1,2,2,3,3,2,1,1,3],"v-v-v-v-v-v-3-v-v&v-2">,
<Graph<10|{{2,5},{7,8},{3,10},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[5,4,4,3,3,2,2,1,1,5],[1,1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&v-3&2-5">,
<Graph<7|{{1,3},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[4,13/4,19/4,19/4,11/4,7/4,7/4],[1,1/4,1/4,7/4,2,1,2],"v-v-v-v-v-v-v-5&3-1-4">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[7/4,7/4,3,4,5,4,3],[1,2,2,2,1,1,1],"v-v-v-v-v-v-v-1-3-6-4&3-7">,
<Graph<7|{{1,3},{2,5},{1,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[11/4,1/2,4,23/4,0,3/4,7/4],[1,-1/4,1,1,5/2,1,1],"v-v-v-v-v-v-v-1-3-5-2-4&5-7">,
<Graph<7|{{1,3},{1,5},{1,7},{4,6},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[0,5/2,4,1/2,11/4,7/4,3/4],[5/2,5/2,1,-1/4,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4-6">,
<Graph<8|{{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2],[1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-3&4-7">,
<Graph<7|{{2,5},{2,6},{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[1/2,0,7/4,11/4,4,1/4,3/2],[3/2,5/2,1,1,1,-1/2,-1/2],"v-v-v-v-v-v-v&2-4-6-2-5">,
<Graph<9|{{2,5},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[4,3,3,2,2,1,1,5,4],[2,2,1,1,2,2,1,1,1],"v-v-v-v-v-v-v&v-v-3&2-5">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[2,2,1,1,2,3,3],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v&2-6">,
<Graph<7|{{2,5},{2,6},{2,3},{3,4},{1,2},{3,7}}>,[2,2,1,1,3,2,1],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-3">,
<Graph<9|{{4,7},{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[1,2,3,4,5,5,4,3,2],[2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v-2&3-8&4-7">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{5,7},{1,2},{2,3},{3,4},{3,6}}>,[5,4,3,3/2,3/2,3,3],[1,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2&5-7">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[13/4,17/4,17/4,13/4,9/4,5/4,5/4],[-1/4,-1/4,3/4,7/4,5/4,7/4,-1/4],"v-v-v-v-v-v-v-1-3&4-6">,
<Graph<7|{{2,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,5},{3,6}}>,[4,4,0,5/2,0,3/2,1/2],[0,1,9/4,1,-1/4,1,1],"v-v-v-v-v-v-3-v-5-2&3-5">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[11/4,11/4,4,4,5,4,11/4],[0,1,0,1,1,2,2],"v-v-v-v-v-v-v&2-6-4&3-5">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[11/4,11/4,7/4,1,0,1,7/4],[9/4,13/4,19/4,4,17/4,3,9/4],"v-v-v-v-v-v-v-2&3-5&4-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{5,7},{1,5},{2,4},{1,7}}>,[3/4,2,3,9/4,17/4,17/4,9/4],[1,7/4,3/2,11/4,1,3,15/4],"v-v-v-v-v-v-v-1-3-5-1-4-2&5-7">,
<Graph<7|{{1,3},{4,7},{1,7},{5,6},{4,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[7/4,3/4,0,1/2,11/4,4,11/4],[1,1,5/2,-1/4,-1/4,1,1],"v-v-v-v-v-v-v-1-3-6-4-7-3">,
<Graph<10|{{9,10},{7,8},{5,6},{3,8},{4,5},{1,2},{2,3},{3,4},{4,10}}>,[1,2,3,3,4,5,5,4,1,2],[1,1,1,2,2,2,1,1,2,2],"v-v-v-v-v-v&v-v-3&v-v-4">,
<Graph<7|{{1,3},{1,7},{4,6},{5,6},{6,7},{4,5},{1,2},{5,7},{2,7},{2,3},{3,4},{3,5}}>,[25/4,11/2,9/2,7/2,9/2,9/2,23/4],[15/4,3,13/4,2,2,1,2],"v-v-v-v-v-v-v-1-3-5-7-2&4-6">,
<Graph<7|{{2,6},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[1/2,0,3/2,0,9/4,15/4,5/2],[1,-1/2,1,5/2,5/2,1,1],"v-v-v-v-v-v-v-4-2-6-4-1">,
<Graph<7|{{2,5},{2,6},{2,4},{2,7},{2,3},{1,2},{3,4},{5,6}}>,[1,2,3,3,1,1,5/2],[1,2,2,3,3,2,1],"v-v-v-v-2-v-v-2-v">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4}}>,[3,2,3,1,3,4,5],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5-7">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[4,11/4,0,3/4,7/4,1/2,23/4],[1,1,5/2,1,1,-1/4,1],"v-v-v-v-v-v-v-1-3-5-2-6-3-7">,
<Graph<9|{{7,8},{5,6},{6,9},{6,7},{3,8},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,4,4,3,2,5],[1,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-3&v-6">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[19/4,7/2,5,4,4,9/4,9/4],[2,2,1,1,0,3/4,2],"v-v-v-v-v-v-v-2-4&2-6&3-5">,
<Graph<7|{{1,3},{1,5},{5,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[5,4,3,1,3,3,2],[1,1,2,1,0,1,1],"v-v-v-v-v-v-v-3-1-5">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{5,8},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,4,5,5,4,3,2],[1,2,2,2,2,2,1,1,1,1],"v-v-v-v-v-v-v-v-v&v-3&5-8">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[0,1/2,0,3/2,5/2,15/4,9/4],[-1/2,1,5/2,1,1,1,-1/2],"v-v-v-v-v-v-v-1-3-5-1-6-3">,
<Graph<7|{{1,5},{5,6},{1,6},{6,7},{4,5},{1,2},{3,7},{2,3},{3,5},{3,4},{3,6}}>,[3,1,3,4,4,3,2],[0,1,2,2,1,1,1],"v-v-v-v-v-v-v-3-5-1-6-3">,
<Graph<10|{{9,10},{2,5},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[3,4,5,5,4,3,2,1,1,2],[1,1,1,2,2,2,2,2,1,1],"v-v-v-v-v-v-v-v-v-v-7&2-5">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4},{3,6}}>,[5/4,5/4,3/4,19/4,7/2,3/4,9/4],[1/2,3/2,5/2,1,1,-3/4,3/4],"v-v-v-v-v-v-v-2&4-6-3-5">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,5},{3,4},{3,6}}>,[0,1/2,0,21/4,15/4,5/2,3/2],[5/2,1,-1/2,1,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-4&3-6">,
<Graph<7|{{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4},{3,6}}>,[4,5/2,7/4,7/4,1,3,3],[21/4,21/4,9/2,6,15/4,13/4,17/4],"v-v-v-v-v-v-v-2-4-1-6-3">,
<Graph<7|{{2,6},{2,7},{2,3},{1,2},{3,4},{4,5}}>,[1,2,11/4,7/4,3/4,2,3],[1,2,3,3,3,1,1],"v-v-v-v-v&v-2-v">,
<Graph<7|{{1,3},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4},{3,6}}>,[7/4,7/4,3,3,4,5,4],[1,2,2,1,0,1,1],"v-v-v-v-v-v-v-4-1-3-6">,
<Graph<9|{{7,8},{5,6},{3,8},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4}}>,[2,2,3,4,5,5,4,3,1],[1,2,2,2,2,1,1,1,2],"v-v-v-v-v-v-v-v-3&v-2">,
<Graph<7|{{1,3},{2,6},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[19/4,4,3,7/4,7/4,3,17/4],[7/4,1,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6-2-7">,
<Graph<9|{{2,5},{4,7},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[1,2,2,3,3,4,4,5,1],[1,1,2,2,1,1,2,2,2],"v-v-v-v-v-v-v-v&v-3&2-5&4-7">,
<Graph<10|{{9,10},{7,8},{5,6},{4,5},{1,2},{2,7},{2,3},{3,4},{8,9},{7,10},{3,6}}>,[3,3,4,4,5,5,2,1,1,2],[1,2,2,1,1,2,2,2,1,1],"v-v-v-v-v-v-3&v-v-v-v-8-2">,
<Graph<9|{{7,8},{5,6},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4}}>,[4,4,3,3,2,2,1,1,5],[1,2,2,1,1,2,2,1,2],"v-v-v-v-v-v-v-v&v-2">,
<Graph<7|{{2,5},{2,6},{4,7},{5,6},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[3/2,3,17/4,17/4,3,9/4,21/4],[5/2,5/2,5/2,1,1,7/4,1],"v-v-v-v-v-v-2-4-v&2-5">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{3,6}}>,[4,19/4,3,7/4,7/4,3,17/4],[1,7/4,2,2,1,1,0],"v-v-v-v-v-v-v-1-3-6&2-7">,
<Graph<7|{{2,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[2,3,19/4,4,19/4,3,2],[7/4,7/4,7/4,1,1/4,1/4,3/4],"v-v-v-v-v-v-2-v&2-4&3-5">,
<Graph<7|{{4,7},{5,6},{4,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4},{3,6}}>,[3/4,7/4,11/4,0,5/2,4,1/2],[1,1,1,5/2,5/2,1,-1/4],"v-v-v-v-v-v-v-2-4-6-3-7-4">,
<Graph<9|{{7,8},{5,6},{6,7},{4,9},{4,5},{5,8},{1,2},{2,9},{2,3},{3,4}}>,[5,4,4,3,2,1,1,2,3],[1,1,2,2,2,2,1,1,1],"v-v-v-v-v-v-v-v-5&2-v-4">,
<Graph<7|{{5,6},{4,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4},{3,6}}>,[-1/2,-1/2,1,1,1,2,2],[3,4,5,4,3,4,3],"v-v-v-v-v-v-v&2-4-6-3">,
<Graph<10|{{3,10},{7,8},{5,6},{6,9},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[1,1,2,3,3,4,5,5,4,2],[1,2,2,2,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-6&v-3">,
<Graph<7|{{1,3},{4,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[15/4,21/4,9/2,13/4,11/4,7/4,7/4],[3/4,3/4,3/2,2,1,1,2],"v-v-v-v-v-v-v-4-1-3">,
<Graph<7|{{4,7},{2,5},{2,6},{4,6},{2,3},{1,2},{3,4},{4,5}}>,[5/2,15/4,19/4,15/4,15/4,11/4,5/2],[2,2,3/4,-1/4,1,1,-1/4],"v-v-v-v-v-2-v-4-v">,
<Graph<7|{{4,7},{5,6},{4,6},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,3,3,3,17/4,17/4,2],[2,2,1,0,1,0,1],"v-v-v-v-v-v-4-v-2">,
<Graph<8|{{4,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,1,2,3,3,2,1,3],[3,2,2,2,1,1,1,3],"v-v-v-v-v-v-v-2&v-4">,
<Graph<7|{{3,6},{2,6},{2,7},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3,2,1,-1/4,-1/4,1,2],[7/2,7/2,9/2,9/2,7/2,7/2,5/2],"v-v-v-v-v-v-2-v&3-6">,
<Graph<10|{{2,5},{6,10},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[5,4,4,3,3,2,1,1,5,2],[2,2,1,1,2,2,2,1,1,1],"v-v-v-v-v-v-v-v&v-3&v-6&2-5">,
<Graph<7|{{2,6},{4,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,4}}>,[7/4,3,4,4,4,3,7/4],[5/2,5/2,5/2,3/2,1/2,1,1],"v-v-v-v-v-v-2-4-6-v">,
<Graph<8|{{7,8},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[1,1,2,2,3,3,2,3],[1,2,2,3,3,2,1,1],"v-v-v-v-v-v-3-v-v">,
<Graph<7|{{1,3},{2,5},{2,6},{1,7},{1,6},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[7/4,3,3,17/4,17/4,3,7/4],[1,1,-1/4,-1/4,1,2,2],"v-v-v-v-v-v-v-1-3-5-2-6-1">,
<Graph<7|{{1,3},{1,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,3},{3,5},{3,4},{3,6}}>,[2,3,2,5/2,3/2,1,1],[1,2,2,3,3,2,1],"v-v-v-v-v-v-v-1-3-5&2-4&3-6">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{6,7},{1,4},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[0,9/4,15/4,21/4,1/2,3/2,3/4],[5/2,1,1,1,-3/4,1/4,1],"v-v-v-v-v-v-v-1-3-5-1-4&2-6">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[3/4,3/4,3/4,2,2,3,3],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v-5-2">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3/4,2,2,3,3,2,3/4],[3/2,2,1,1,2,3,3],"v-v-v-v-v-v-v&2-4&5-2-6">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,7},{2,3},{3,4},{3,5}}>,[1/2,0,21/4,15/4,1/4,5/4,5/2],[3/2,5/2,1,1,-1/2,3/4,1],"v-v-v-v-v-v-v-2-4&2-5-3&5-7">,
<Graph<7|{{4,7},{2,4},{4,6},{2,3},{1,2},{3,4},{5,6},{4,5}}>,[3,3,3,2,1,1,1],[1,2,3,2,3,2,1],"v-v-v-v-v-v-4-v&2-4">,
<Graph<9|{{5,6},{3,8},{5,9},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[1,2,2,3,4,5,3,1,4],[1,1,2,2,2,2,1,2,1],"v-v-v-v-v-v&v-2&v-3&v-5">,
<Graph<7|{{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[1,2,2,3,3,7/4,3/4],[2,2,1,2,3,3,3],"v-v-v-v-v-v-v&2-4">,
<Graph<7|{{4,6},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,4},{1,2},{4,7},{5,7},{2,4}}>,[7/2,4,13/4,9/4,1,3,2],[4,9/4,3,11/4,5/4,5/4,7/4],"v-v-v-v-v-v-v-4-1-3&2-4-6&5-7">,
<Graph<7|{{4,7},{1,7},{1,6},{5,6},{4,5},{1,2},{2,3},{3,4}}>,[1,1,2,3,2,1,2],[2,1,1,2,3,3,2],"v-v-v-v-v-v-1-v-4">,
<Graph<7|{{2,5},{2,6},{2,7},{2,3},{1,2},{6,7},{3,4},{4,5}}>,[1,2,3,3,3,1,1],[1,2,3,2,1,3,2],"v-v-v-v-v-2-v-v-2">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,7},{3,7},{2,3},{3,5},{3,4}}>,[4,5,25/4,4,5/4,3,4],[2,13/4,4,1,4,13/4,7/2],"v-v-v-v-v-v-v-1-3-5-1-4&2-7-3&5-7">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{3,7},{2,3},{3,4},{3,5}}>,[9/4,13/4,19/4,11/4,3/4,2,3],[11/4,11/4,1,9/2,1,7/4,3/2],"v-v-v-v-v-v-v-1-3-5-1-4&3-7-5">,
<Graph<7|{{2,5},{2,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4},{3,5}}>,[1,2,4,3,1,2,1],[9/4,2,1,1,-3/4,3/4,5/4],"v-v-v-v-v-v-2-v&3-5-2-4">,
<Graph<7|{{2,5},{2,6},{2,7},{2,3},{1,2},{3,4}}>,[1,2,3,3,1,1,2],[1,2,2,1,2,3,3],"v-v-v-v&v-2-v&v-2">,
<Graph<7|{{1,3},{1,5},{2,6},{1,7},{5,6},{1,4},{6,7},{4,5},{1,2},{2,7},{2,3},{3,5},{3,4}}>,[3/4,19/4,3,2,2,3,9/4],[1,1,3/2,7/4,11/4,11/4,9/2],"v-v-v-v-v-v-v-1-3-5-1-4&6-2-7">,
<Graph<8|{{2,5},{7,8},{4,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4}}>,[5,4,4,3,3,2,2,1],[1,1,2,2,1,1,2,2],"v-v-v-v-v-v-v-v&2-5&4-7">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{3,7},{2,3},{3,4}}>,[3,4,4,3,3,4,5],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-2-4-6&3-7">,
<Graph<7|{{1,5},{5,6},{1,4},{6,7},{4,5},{1,2},{5,7},{2,3},{3,4}}>,[7/2,7/2,19/4,19/4,3,7/4,7/4],[1,0,0,1,2,1,2],"v-v-v-v-v-v-v-5-1-4">,
<Graph<7|{{4,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,5},{3,6}}>,[7/4,11/4,1/4,4,23/4,0,1/2],[1,1,-1/2,1,1,5/2,3/2],"v-v-v-v-v-v-v&2-4-6-3-5">,
<Graph<7|{{2,5},{2,6},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,7/4,1/4,19/4,13/4,9/4,5/4],[2,2,-1/4,1,1,1,1/2],"v-v-v-v-v-v-v-2-4&3-7&5-2-6">,
<Graph<7|{{5,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,3,4,4,2],[1,2,2,2,2,1,1],"v-v-v-v-v-v&v-3">,
<Graph<9|{{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4}}>,[2,2,1,1,2,3,3,3,1],[1,2,2,3,3,3,2,1,1],"v-v-v-v-v-v-v-v&v-3&2-7">,
<Graph<7|{{1,3},{2,6},{4,7},{4,6},{5,6},{1,4},{6,7},{4,5},{2,4},{1,2},{2,3},{3,4},{3,6}}>,[2,3,3/4,9/4,17/4,17/4,7/2],[7/4,3/2,1,11/4,7/2,1,11/4],"v-v-v-v-v-v-v-4-1-3-6-2-4-6">,
<Graph<10|{{2,5},{7,8},{3,9},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{4,10}}>,[2,3,4,4,3,2,1,1,5,5],[1,1,1,2,2,2,2,1,1,2],"v-v-v-v-v-v-v-v&v-3&v-4&2-5">,
<Graph<7|{{5,6},{1,4},{6,7},{4,5},{1,2},{2,4},{2,7},{2,3},{3,4}}>,[3,3,4,4,3,3/2,3/2],[1,2,2,1,0,0,5/4],"v-v-v-v-v-v-v-2-4-1">,
<Graph<9|{{7,8},{1,6},{5,6},{1,4},{6,7},{4,5},{1,2},{2,9},{2,3},{3,4},{8,9}}>,[2,1,1,2,3,3,3,2,1],[2,2,3,3,3,2,1,1,1],"v-v-v-v-v-v-v-v-v-2&4-1-6">,
<Graph<9|{{3,8},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4},{8,9}}>,[1,1,2,2,1,3,2,3,3],[1,2,2,3,3,1,1,2,3],"v-v-v-v-v&v-v-3-v-v">,
<Graph<10|{{9,10},{2,5},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9}}>,[3,4,5,5,4,3,2,2,1,1],[2,2,2,1,1,1,1,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-5">,
<Graph<7|{{2,5},{5,6},{6,7},{4,5},{1,2},{2,3},{3,5},{3,4}}>,[11/4,11/4,11/4,7/4,7/4,3/4,3/4],[1,2,3,3,2,2,1],"v-v-v-v-v-v-v&2-5-3">,
<Graph<7|{{5,6},{6,7},{4,5},{1,2},{5,7},{2,4},{2,3},{3,4},{3,5}}>,[3,4,5,4,4,3,3],[2,2,1,1,0,0,1],"v-v-v-v-v-v-v-5-3&2-4">,
<Graph<8|{{3,8},{6,7},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,1,2,2,1,3,3,2],[1,2,2,3,3,1,2,1],"v-v-v-v-v&v-v-3-v">,
<Graph<7|{{1,3},{1,5},{5,6},{4,5},{5,7},{1,2},{3,7},{2,3},{3,4},{3,6}}>,[5,4,3,3,3,2,1],[1,1,2,1,0,1,1],"v-v-v-v-v-v-3-v-5-1-3">,
<Graph<7|{{4,6},{5,6},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[13/4,5/2,1,1,-1/4,-1/4,7/4],[9/4,3,3,17/4,17/4,13/4,9/4],"v-v-v-v-v-v-4-2-v">,
<Graph<7|{{2,5},{5,6},{4,5},{1,2},{3,7},{2,3},{3,4}}>,[1,2,3,3,2,1,4],[2,2,2,1,1,1,2],"v-v-v-v-v-v&v-3&2-5">,
<Graph<7|{{2,6},{5,6},{6,7},{4,5},{2,4},{1,2},{2,7},{2,3},{3,4}}>,[1,2,3,3,3,2,1],[1,2,1,2,3,3,3],"v-v-v-v-v-v-v-2-4&2-6">,
<Graph<7|{{1,5},{5,6},{6,7},{1,4},{5,7},{1,2},{2,3},{3,4}}>,[9/2,7/2,7/2,9/2,11/4,7/4,7/4],[1,1,0,0,2,1,2],"v-v-v-v-1-v-v-v-6">,
<Graph<7|{{3,5},{6,7},{2,3},{4,5},{5,6},{3,4},{1,3},{1,2},{4,7},{1,5},{1,6},{2,4},{1,7}}>,[3,5,4,3,3,2,1],[2,1,1,0,1,1,1],"v-v-v-v-v-v-v-1-3-5-1-6&2-4-7">,
<Graph<7|{{1,3},{2,6},{1,7},{4,7},{5,6},{6,7},{4,5},{1,2},{5,7},{2,3},{3,5},{3,4}}>,[1,2,3,5,4,3,3],[1,1,2,1,1,1,0],"v-v-v-v-v-v-v-1-3-5-7-4&2-6">,
<Graph<7|{{1,3},{1,5},{1,7},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{3,5}}>,[3,4,4,4,3,7/4,7/4],[1,1/4,5/4,9/4,9/4,9/4,1],"v-v-v-v-v-v-v-1-3-5-1">,
<Graph<10|{{9,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,7},{2,3},{3,4},{8,9}}>,[2,3,4,5,5,4,3,2,1,1],[1,1,1,1,2,2,2,2,2,1],"v-v-v-v-v-v-v-v-v-v&2-7">,
<Graph<7|{{4,7},{5,6},{6,7},{4,5},{1,2},{2,4},{2,7},{3,7},{2,3},{3,4}}>,[1/2,0,19/4,13/4,9/4,5/4,1/4],[3/2,5/2,1,1,1,1/2,-1/2],"v-v-v-v-v-v-v-2-4-7-3">,
<Graph<7|{{4,7},{1,7},{4,6},{5,6},{1,4},{4,5},{2,4},{1,2},{2,3},{3,4}}>,[3,5/2,3/2,2,1,1,3],[2,3,3,2,1,2,1],"v-v-v-v-v-v-4-v-1-4-2">,
<Graph<10|{{3,10},{7,8},{5,6},{6,7},{4,5},{1,2},{2,3},{3,4},{8,9},{7,10}}>,[1,1,2,2,3,4,4,5,5,3],[1,2,2,1,1,1,2,2,1,2],"v-v-v-v-v-v-v-v-v&3-v-7">
@}
//! GRID GRAPHS END
;


procedure PatchGridGraphs()

  "Patching gridgraphs in planar.m with hand-adjusted planar graphs on <=6 vertices";

  labels:=
  [
  // Planar graphs on 2 vertices
  /* 2,1 */ "(1,1)-(2,1)",
  // Planar graphs on 3 vertices
  /* 3,1 */ "(1,1)-(2,1)-(3,1)",
  /* 3,2 */ "(1,2/5)-(1,8/5)-(2,1)-1",
  // Planar graphs on 4 vertices
  /* 4,1 */ "(11/10,2/5)-(2,1)-(11/10,8/5)&2-(3,1)",
  /* 4,2 */ "(2,8/5)-(1,1)-(1,11/5)-1-(3,8/5)",
  /* 4,3 */ "(1,1)-(2,1)-(3,1)-(4,1)",
  /* 4,4 */ "(2,1)-(1,1)-(2,2)-1-(3,1)-3",
  /* 4,5 */ "(1,1)-(2,2/5)-(3,1)-(2,8/5)-1",
  /* 4,6 */ "(11/10,2/5)-(11/10,8/5)-(2,1)-1-(16/5,1)-2&3-4",
  // Planar graphs on 5 vertices
  /* 5,1 */ "(1,1)-(5/2,2)-(2,1)&(3,1)-2-(4,1)",
  /* 5,2 */ "(1,1)-(2,3/2)-(3,1)-(3,2)-2-(1,2)",
  /* 5,3 */ "(27/10,1)-(9/5,2/5)-(1,1)-(9/5,8/5)-1-(37/10,1)",
  /* 5,4 */ "(1,2)-(2,2)-(1,1)-(2,1)-2-(3,1)-4",
  /* 5,5 */ "(1,1)-(2,1)-(2,2)&2-(3,1)-(4,1)",
  /* 5,6 */ "(1,2)-(2,2)-(1,1)-(2,1)-2&4-(3,1)",
  /* 5,7 */ "(1,1)-(1,2)-(3,2)-(2,3/2)-1-(3,1)-3",
  /* 5,8 */ "(1,2)-(3,6/5)-(11/5,2)-(3,14/5)-2-(15/4,2)-4-1",
  /* 5,9 */ "(1,2)-(2,2)-(2,1)-(3,1)-(3,2)-3&2-5",
  /* 5,10 */ "(11/10,2/5)-(11/10,8/5)-(2,1)-1-(16/5,1)-2&3-4-(21/5,1)",
  /* 5,11 */ "(1,2)-(11/5,2)-(3,6/5)-1-(3,14/5)-3-(15/4,2)-4-2",
  /* 5,12 */ "(1,1)-(2,1)-(3,1)-(4,1)-(5,1)",
  /* 5,13 */ "(2,1)-(1,1)-(5/2,2)-1-(3,1)-3-(4,1)-4",
  /* 5,14 */ "(2,1)-(1,2/5)-(1,8/5)-1-(3,1)-(4,1)",
  /* 5,15 */ "(1,1)-(1,2)-(2,2)-(3,1)-(3,2)-3-1",
  /* 5,16 */ "(2,1)-(1,1)-(1,2)-(2,2)-1-(3,2)-4",
  /* 5,17 */ "(1,7/5)-(1,13/5)-(21/10,3)-(14/5,2)-(21/10,1)-1",
  /* 5,18 */ "(1,1)-(1,2)-(2,3/2)-1-(3,1)-(3,2)-2&3-5",
  /* 5,19 */ "(1,1)-(1,2)-(2,3/2)-1-(3,1)-3-(3,2)-2&4-5",
  /* 5,20 */ "(7/4,2)-(6/5,1)-(6/5,3)-1-(11/4,2)-2-(15/4,2)-3-4-5",
  // Planar graphs on 6 vertices
  /* 6,1 */ "(1,1)-(3,2)-(2,1)&(3,1)-2-(4,1)&2-(5,1)",
  /* 6,2 */ "(1,3/2)-(2,2)-(1,5/2)&2-(2,1)-(3,3/2)-2-(3,5/2)",
  /* 6,3 */ "(1,1)-(2,1)-(2,2)&2-(3,1)-(4,1)-(5,1)",
  /* 6,4 */ "(1,2)-(2,2)-(2,3)-(3,3)-(3,2)-2-(2,1)",
  /* 6,5 */ "(1,3/2)-(2,2)-(1,5/2)&2-(2,1)-(3,3/2)-2-(3,5/2)-5",
  /* 6,6 */ "(2,1)-(1,2)-(3,3)-(2,2)-1-(4,2)-3-(3,2)",
  /* 6,7 */ "(5/2,3)-(1,2)-(5/2,1)-(2,2)-1-3-(4,2)-1-(3,2)",
  /* 6,8 */ "(1,1)-(2,1)-(3,1)-(7/3,2)&(11/3,2)-3-(4,1)",
  /* 6,9 */ "(1,1)-(2,3/2)-(1,2)&2-(3,3/2)-(4,1)&4-(4,2)",
  /* 6,10 */ "(1,1)-(2,2)-(1,2)&(3,1)-(3,2)-(2,1)-2-5",
  /* 6,11 */ "(1,2)-(2,2)-(2,1)-(3,1)-(3,2)-2&4-(4,1)",
  /* 6,12 */ "(1,2)-(2,2)-(1,1)-(2,1)-2-(3,2)-4-(3,1)",
  /* 6,13 */ "(1,2)-(5/2,1)-(2,2)-(5/2,3)-(3,2)-2-(4,2)-4-1",
  /* 6,14 */ "(5/2,1)-(1,2)-(5/2,3)-(2,2)-1-3-(3,2)-1-(4,2)-3",
  /* 6,15 */ "(1,1)-(2,2)-(1,2)&(2,1)-2-(3,2)-4-(3,1)-5",
  /* 6,16 */ "(11/10,2/5)-(11/10,8/5)-(2,1)-1-(16/5,1)-2&3-4-(21/5,2/5)&4-(21/5,8/5)",
  /* 6,17 */ "(1,2)-(2,2)-(1,1)-(2,1)-2-(3,2)-(3,1)-4",
  /* 6,18 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&4-3-(9/2,2)-4-(7/2,2)",
  /* 6,19 */ "(1,1)-(2,1)-(2,2)-(1,2)&2-(3,1)-(3,2)-3",
  /* 6,20 */ "(1,1)-(2,1)-(2,2)-(1,2)&3-(3,2)-2-(3,1)-5",
  /* 6,21 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&(4,1)-3-4-(4,3)",
  /* 6,22 */ "(1,1)-(2,2)-(1,2)&2-(3,2)-(2,1)-(3,1)-4",
  /* 6,23 */ "(2,8/5)-(1,1)-(1,21/10)-1-(3,8/5)-(4,8/5)-(5,8/5)",
  /* 6,24 */ "(3,1)-(3,2)-(2,1)-(2,2)-(1,1)-(1,2)-4-2",
  /* 6,25 */ "(1,1)-(1,2)-(2,2)-(2,1)-(3,1)-(3,2)-3-1",
  /* 6,26 */ "(2,2)-(1,1)-(1,2)-1-(2,3)-(3,2)-1-(3,1)-5",
  /* 6,27 */ "(1,2)-(2,2)-(1,1)-(2,1)-(3,1)-(3,2)-4&2-6",
  /* 6,28 */ "(1,2)-(2,2)-(3,3)-1-(3,1)-(3,2)-3-(4,2)-4",
  /* 6,29 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-(3,2)-3-(4,2)-4-2",
  /* 6,30 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&3-4-(7/2,2)-3-(9/2,2)-4",
  /* 6,31 */ "(1,1)-(2,1)-(3,1)-(3,2)&3-(4,1)-(5,1)",
  /* 6,32 */ "(14/5,2)-(21/10,1)-(1,7/5)-(1,13/5)-(21/10,3)-1-(19/5,2)",
  /* 6,33 */ "(1,1)-(2,3/2)-(1,2)-(2,5/2)-2-(3,1)-(3,2)-2&4-6",
  /* 6,34 */ "(1,1)-(1,2)-(2,2)-(2,1)-(3,2)-3&(3,1)-5",
  /* 6,35 */ "(1,2)-(2,2)-(1,1)-(2,1)-2-(3,2)-4-(3,1)-5",
  /* 6,36 */ "(1/2,2)-(4/3,3)-(4/3,1)-(2,2)-(3,2)-3-(4,2)-2-5-6",
  /* 6,37 */ "(1/2,2)-(4/3,3)-(4/3,1)-(2,2)-2-(3,2)-3-(4,2)-2&4-5-6",
  /* 6,38 */ "(1,2)-(2,1)-(2,2)-1-(2,3)-(1,3)&2-(3,2)-3-4-6",
  /* 6,39 */ "(3,1)-(1,3/2)-(2,3)-(2,2)-(3,2)-3-(4,2)-1-5-6",
  /* 6,40 */ "(2,1)-(1,2)-(5/2,3)-(2,2)-1-(4,2)-3-(3,2)-4&6-5",
  /* 6,41 */ "(7/4,7/2)-(1,5/2)-(7/4,3/2)-1-(5/2,5/2)-3-(9/2,5/2)-1-(7/2,5/2)-4&6-5",
  /* 6,42 */ "(7/4,3/2)-(1,5/2)-(7/4,7/2)-1-(5/2,5/2)-3-(7/2,5/2)-1-(9/2,5/2)-3&4-5-6",
  /* 6,43 */ "(1,1)-(2,1)-(2,2)-(1,2)&2-(3,2)-3&(3,1)-5",
  /* 6,44 */ "(1,2)-(1,1)-(2,1)-(2,2)-(3,2)-3-(3,1)-5",
  /* 6,45 */ "(1,2)-(2,2)&(3,1)-1-(3,3)-(3,2)-3-(4,2)-4",
  /* 6,46 */ "(1,2)-(11/4,1)-(11/4,3)-(7/2,2)-2-(9/2,2)-3-1-(2,2)",
  /* 6,47 */ "(1,2)-(2,2)-(11/4,3)-1-(11/4,1)-3-(7/2,2)-4-(9/2,2)-3",
  /* 6,48 */ "(1,2)-(1,1)-(2,1)-(2,2)-1-(2,3)-4-(3,2)-3",
  /* 6,49 */ "(7/4,7/2)-(1,5/2)-(7/4,3/2)-1-(5/2,5/2)-(7/2,5/2)-3-(9/2,5/2)-1-5-6",
  /* 6,50 */ "(1,1)-(1,2)-(1,3)-(2,3)-2-(2,2)-4-(3,3)-5-1",
  /* 6,51 */ "(2,2)-(5/2,1)-(1,2)-(5/2,3)-1-(3,2)-2-(4,2)-4-5-6",
  /* 6,52 */ "(2,1)-(2,2)-(1,1)-(1,2)-2-(3,2)-(3,1)",
  /* 6,53 */ "(5/4,5/4)-(2,2)-(1,3)-(2,3)-2-(3,1)-(3,2)-2",
  /* 6,54 */ "(1,2)-(2,1)-(2,2)-1-(3,3)-3&2-(4,2)-4-(3,2)",
  /* 6,55 */ "(1,1)-(1,2)-(2,2)-1-(2,1)-3-(3,2)-4&(3,1)-5",
  /* 6,56 */ "(1,2)-(2,1)-(3,2)-(2,2)-1-(2,3)-(1,3)&4-5-3",
  /* 6,57 */ "(1,3/2)-(1,7/2)-(3/2,5/2)&2-(5/2,5/2)-1-(19/4,5/2)-2-(7/2,5/2)-4&6-5",
  /* 6,58 */ "(11/4,5/2)-(1,3/2)-(1,7/2)-(7/4,5/2)-2-(19/4,5/2)-3-1-(15/4,5/2)-5",
  /* 6,59 */ "(7/4,5/2)-(11/4,5/2)-(1,3/2)-(1,7/2)-2-(15/4,5/2)-3-(19/4,5/2)-4-5-6",
  /* 6,60 */ "(1,7/2)-(1,3/2)-(11/4,5/2)-1-(7/4,5/2)-3-(15/4,5/2)-2-(19/4,5/2)-1-5-6",
  /* 6,61 */ "(2,1)-(1,1)-(1,2)-(2,2)-1-(3,2)-4&(3,1)-5",
  /* 6,62 */ "(2,1)-(1,2)-(1,3)-(2,3)-2-(2,2)-1-(3,2)-5-4-6",
  /* 6,63 */ "(1,1)-(2,1)-(3,1)-(4,1)-(5,1)-(6,1)",
  /* 6,64 */ "(1,1)-(1,2)&(2,1)-1-(2,2)-3-(3,2)-4&(3,1)-5",
  /* 6,65 */ "(2,2)-(1,2)-(1,1)-(2,1)-1-(3,2)-4-(3,1)-5",
  /* 6,66 */ "(2,1)-(1,1)-(3,2)-1-(3,1)-3-(4,1)-4&3-(5,1)-5",
  /* 6,67 */ "(1,1)-(1,2)-(2,2)-1-(2,1)-3-(3,2)-4-(3,1)-5",
  /* 6,68 */ "(1,3/2)-(1,7/2)-(7/4,5/2)-1-(11/4,5/2)-2-(15/4,5/2)-1-(19/4,5/2)-2&3-4-5-6",
  /* 6,69 */ "(2,1)-(1,2)-(2,3)-(2,2)-1-(4,2)-3&4-(3,2)-5",
  /* 6,70 */ "(1,1)-(1,2)-(2,2)-1-(2,1)-(3,1)-(3,2)-4&3-6",
  /* 6,71 */ "(1,7/2)-(3/2,1)-(11/4,9/4)-1-(7/4,9/4)-3-(15/4,9/4)-2-(13/4,1)-5-1",
  /* 6,72 */ "(5/2,2)-(7/4,1)-(1,15/4)-(7/4,11/4)-1-(15/4,9/4)-3-(5,9/4)-2-5-6",
  /* 6,73 */ "(2,3)-(1,2)-(3,1)-(3,2)-(2,2)-1-(4,2)-3&4-6",
  /* 6,74 */ "(1,2)-(2,2)-(5/2,1)-1-(5/2,3)-2-(3,2)-3-(4,2)-4-5-6",
  /* 6,75 */ "(27/10,9/5)-(9/5,1)-(1,9/5)-(9/5,27/10)-1-(37/10,9/5)-(47/10,9/5)",
  /* 6,76 */ "(9/4,1)-(1,2)-(1,3)-(9/4,3)-(9/4,2)-1-(13/4,2)-4",
  /* 6,77 */ "(1,7/5)-(1,13/5)-(2,3)-(2,1)-(11/4,2)-3-(15/4,2)-4-1",
  /* 6,78 */ "(1,1)-(1,2)-(2,2)-(2,1)-(3,1)-(3,2)-4&3-6",
  /* 6,79 */ "(1,2)-(2,1)-(2,7/4)-1-(3,5/2)-2&3-4-(4,2)-(4,1)",
  /* 6,80 */ "(2,1)-(2,2)-(1,1)-(1,2)-2-(3,2)-1-(3,1)-5",
  /* 6,81 */ "(1,2)-(2,1)-(2,7/4)-1-(3,5/2)-2&3-4-(4,1)-(4,2)-4",
  /* 6,82 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&(4,7/5)-3-4-5-(4,13/5)",
  /* 6,83 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&3-(4,2)-(3,2)-4-5",
  /* 6,84 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&4-3-(4,7/5)-4-(4,13/5)-5",
  /* 6,85 */ "(2,1)-(1,1)-(1,2)-(2,2)-1-(3,1)-(3,2)-4",
  /* 6,86 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-3-(4,7/5)-(4,13/5)-4-2",
  /* 6,87 */ "(2,2)-(1,1)-(1,2)-1-(3,2)-(2,1)-(3,1)-4",
  /* 6,88 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&(3,2)-3-(4,2)-5-4-6",
  /* 6,89 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&3-4-(4,2)-3-(5,2)-4&5-6",
  /* 6,90 */ "(1,4)-(1,1)-(3/2,5/2)-1-(5/2,5/2)-3&4-(7/2,5/2)-2-(19/4,5/2)-1-5-6",
  /* 6,91 */ "(1,2)-(2,2)-(3,1)-1-(3,3)-2&3-(4,2)-(3,2)&4-5",
  /* 6,92 */ "(2,1)-(1,1)-(1,2)-(2,2)-(3,2)-1-(3,1)-5",
  /* 6,93 */ "(1,2)-(8/5,1)-(27/10,1)-(33/10,2)-(14/5,3)-(8/5,3)-1",
  /* 6,94 */ "(1,2)-(2,1)-(2,2)-1-(2,3)-3&2-(3,7/4)-(3,3)-4",
  /* 6,95 */ "(1,2)-(1,3)-(9/4,3)-(9/4,2)-1-(9/4,1)-4-(13/4,2)-5&3-6",
  /* 6,96 */ "(1,1)-(1,4)-(3/2,5/2)-1-(19/4,5/2)-2-(5/2,5/2)-3&2-(7/2,5/2)-5&6-4",
  /* 6,97 */ "(1,2)-(2,2)-(5/2,3)-1-(3,1)-(3,2)-2&4-(4,2)-3-5-6",
  /* 6,98 */ "(1,2)-(2,2)-(2,3)-1-(3,1)-(3,2)-2&3-(4,2)-4&5-6",
  /* 6,99 */ "(1,17/4)-(7/4,1)-(7/4,11/4)-1-(3,3)-3-(3,9/4)-2-(5,11/4)-5-4-6-1"
  ];
  
  newgraphs:=[];
  for s0 in labels do                   // new handmade
    s:=s0;
    G,x,y := XYGraph(s);
    error if XYGraphLabel(G,x,y) ne s,
      Sprintf("Label mismatch: possibly replace old by new\nold: %o\nnew: %o",s,XYGraphLabel(G,x,y));
    Append(~newgraphs,<G,x,y>);
  end for;
  
  for D in gridgraphs do                // old
    G,x,y:=Explode(D);
    if exists(d){d: d in newgraphs | IsIsomorphic(d[1],G)} then continue; end if;
    Append(~newgraphs,D);
  end for;
  
  out:=[];                              // combined, in graph form
  for D in newgraphs do
    G,x,y:=Explode(D);
    Append(~out,Sprintf("<Graph<%o|%o>,%o,%o>",
      #Vertices(G),DelSpaces({Set(VertexIndices(e)): e in EdgeSet(G)}),DelSpaces(x),DelSpaces(y)));
  end for;
  
  graphs:=Sprintf("// %o graphs generated by RegenerateGridGraphs and patched by PatchGridGraphs\n{@\n",#newgraphs)*
    PrintSequence(out: sep:=",\n")*"\n@}";
  writepiece("planar.m",graphs,"//! GRID GRAPHS BEGIN","//! GRID GRAPHS END");
end procedure;


procedure GridGraphLabels()
  counter:=0;
  maxgen:=1000;
  out:=[];
  complete:=true;
  seenlabels:={};
  for i->D in gridgraphs do
    G,x,y:=Explode(D);
    edges:={Set(VertexIndices(e)): e in EdgeSet(G)};

    if #D eq 3 then
      if counter gt maxgen then                           // keep as is after maxgen generations
        complete:=false;
        Append(~out,Sprintf("<Graph<%o|%o>,%o,%o>",
          #Vertices(G),DelSpaces(edges),DelSpaces(x),DelSpaces(y)));
        continue;
      else 

        label:=Label(G);                                  // generate label
        P,trails:=MinimumScorePaths(G);                  // and minimum path
        t:=trails[1];
        perm:=t[[i: i in [1..#P] | P[i][1] eq 0]];
        invperm:=Eltseq(Inverse(Sym(#VertexSet(G))!perm));
        x     := x[perm];                                 // permute vertices of G  
        y     := y[perm];                                 // according to minimum path
        edges := {Set(invperm[VertexIndices(e)]): e in EdgeSet(G)};

        counter+:=1;
        i,counter,label;
     end if;
    else
      assert #D eq 4;                                     // label already generated 
      label:=D[4]; 
    end if;
    error if label in seenlabels, "Label: "*label*" repeated";
    Include(~seenlabels,label);
    Append(~out,Sprintf("<Graph<%o|%o>,%o,%o,\"%o\">",
      #Vertices(G),DelSpaces(edges),DelSpaces(x),DelSpaces(y),label));
  end for;
  
  if complete then
    graphs:=Sprintf("// %o graphs generated by RegenerateGridGraphs, patched by PatchGridGraphs, labels by GridGraphLabels\n{@\n",#out)*
      PrintSequence(out: sep:=",\n")*"\n@}";
  else 
    graphs:=Sprintf("// %o graphs generated by RegenerateGridGraphs, patched by PatchGridGraphs, labels by GridGraphLabels\n[*\n",#out)*
      PrintSequence(out: sep:=",\n")*"\n*]";
  end if;
  writepiece("planar.m",graphs,"//! GRID GRAPHS BEGIN","//! GRID GRAPHS END");
end procedure;


function SmallGraphCoordinates()
// Some standard graph coordinates for drawing reduction types

  D:=GetQAttribute("SmallGraphCoordinates",false);
  if D cmpne false then return Explode(D); end if;
  
  StdGraphs:=[];
  StdCoords:=[];
  pi:=Pi(RealField());
  r:=func<x|Round(10*x)/10>;
  for n:=1 to 10 do
    R:=Graph<n|{{i,i+1}: i in [1..n-1]}>;    // line 1-2-...-n
    C:=[[Q|i,0]: i in [1..n]];
    Append(~StdGraphs,R);
    Append(~StdCoords,C);                    
    for m in [2..(n+1) div 2], k in [1..m-1] do  // line 1-2-...-n with extra length k tail sticking out of m
      R:=Graph<n+k|{{i,i+1}: i in [1..n-1]} join {{n+1,m}} join {{n+i,n+i+1}: i in [1..k-1]}>;    
      C:=[[i,0]: i in [1..n]] cat [[m,i]: i in [1..k]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
    end for;
    if n lt 3 then continue; end if;
    R:=Graph<n|{{i,i+1}: i in [1..n-1]} join {{1,n}}>;    // loop 1-2-...-n (n>=3)
    C:=[[r((n+1)/6*(1+Cos(2*pi*i/n))),r((n+1)/6*(1+Sin(2*pi*i/n)))]: i in [1..n]];
    Append(~StdGraphs,R);
    Append(~StdCoords,C);                    
    for k in [1..n] do  // loop 1-2-...-n with extra length k tail sticking out
      R:=Graph<n+k|{{i,i+1}: i in [1..n-1]} join {{n,1}} join {{n+i,n+i+1}: i in [0..k-1]}>;    
      C:=[[r((n+1)/6*(1+Cos(2*pi*i/n))),r((n+1)/6*(1+Sin(2*pi*i/n)))]: i in [1..n]];
      x1,y1:=Explode(Last(C));
      C cat:= [[x1+i,y1]: i in [1..k]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
    end for;
    if n ge 3 then    
      // vertices 1,...,n connected pointwise to one or two extra vertices
      R:=Graph<n+1|{{i,n+1}: i in [1..n]}>; 
      x:=(n+1)/2;
      C:=[[Q|i,0]: i in [1..n]] cat [[x,1]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
      R:=Graph<n+2|{{i,n+1}: i in [1..n]} join {{i,n+2}: i in [1..n]}>; 
      C:=[[Q|i,1]: i in [1..n]] cat [[x,0],[x,2]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
      // chain 1-n connected pointwise to one or two extra vertices
      R:=Graph<n+1|{{i,i+1}: i in [1..n-1]} join {{i,n+1}: i in [1..n]}>; 
      C:=[[Q|i,0]: i in [1..n]] cat [[x,1]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
      R:=Graph<n+2|{{i,i+1}: i in [1..n-1]} join {{i,n+1}: i in [1..n]} join {{i,n+2}: i in [1..n]}>; 
      C:=[[Q|i,1]: i in [1..n]] cat [[x,0],[x,2]];
      Append(~StdGraphs,R);
      Append(~StdCoords,C);                    
    end if;
  end for;  
  R:=Graph<6|{{1,2},{2,3},{3,6},{6,5},{5,4},{4,1},{2,5}}>;    // 3x2 rectangle
  C:=[[Q|1,2],[2,2],[3,2],[1,1],[2,1],[3,1]];
  Append(~StdGraphs,R);
  Append(~StdCoords,C);                    
  R:=Graph<6|{{1,3},{2,3},{3,4},{4,5},{4,6}}>;    // H
  C:=[[Q|1,1],[1,2],[2,3/2],[3,3/2],[4,1],[4,2]];
  Append(~StdGraphs,R);
  Append(~StdCoords,C);                    

  SetQAttribute("SmallGraphCoordinates",<StdGraphs,StdCoords>);
  return StdGraphs,StdCoords;
end function;


function ChainGraphCoordinates(G)
  V:=VertexSet(G);
  XY:=[[Q|0,1]: v in V];
  // longest chain
  S:=GraphLongestChain(G);
  count:=0;
  for i->v in S do
    XY[Index(v)]:=[Q|i,0];
    count+:=1;
  end for;
  // adjacent to chain
  AC:=[SetToSequence(IncidentVertices(v) diff Set(S)): v in S];
  shifts:=[
    [[0,1]],                               // one leaf
    [[-1/3,1],[1/3,1]],                    // two leaves
    [[-1/3,1],[1/3,1],[0,-1]],             // three leaves
    [[-1/3,1],[1/3,1],[-1/3,-1],[1/3,-1]]  // four leaves
  ];
  // single leaves off the chain
  for v in V do
    if v in S then continue; end if;
    A:=IncidentVertices(v);
    if #A ne 1 then continue; end if;
    w:=Representative(A);
    j:=Position(S,w);
    if (w notin S) or (Degree(w) gt 6) then continue; end if;
    s:=shifts[Degree(w)-2][Position(AC[j],v)];
    XY[Index(v)]:=XY[Index(w)];
    XY[Index(v)][1]+:=s[1]; 
    XY[Index(v)][2]+:=s[2]; 
    count+:=1;
  end for;
  return count eq #V,XY;
end function;


/// Main functions


intrinsic StandardGraphCoordinates(G::GrphUnd: attempts:=10) -> SeqEnum, SeqEnum, SeqEnum
{Tries to embed a graph in the plane with the least number of edge self-intersections. For planar
graphs on at most 7 vertices and a few others, use a built-in database. Returns 
x=[x1,x2,...], y=[y1,y1,...] - x,y-coordinates for every vertex in VertexSet(G), and suggested vertex labels}
  G:=UnlabelledGraph(G);                // unlabel it for isomorphism testing
  labels:=[1..#VertexSet(G)];  
  if exists(D){D: D in gridgraphs | IsIsomorphic(G,D[1])} then      // Iso to a grid graph 
    vprint redlib,1: "Grid graph";
    S,x,y:=Explode(D);
    _,i:=IsIsomorphic(G,S);
    x:=[x[Index(i(v))]: v in VertexSet(G)];
    y:=[y[Index(i(v))]: v in VertexSet(G)];
    labels:=[Index(i(v)): v in VertexSet(G)];
    XY:=[[x[i]*1,y[i]*1]: i in [1..#x]];
  else
    Gs,Cs:=SmallGraphCoordinates();
    ok:=exists(d){<i,GtoS>: i->S in Gs | ok where ok,GtoS is IsIsomorphic(G,S)};   // iso to standard graph
    if ok then 
      vprint redlib,1: "Standard graph";
      XY:=[Cs[d[1]][Index(d[2](v))]: v in Vertices(G)];   // Vertex coordinates
    else
      ok,XY:=ChainGraphCoordinates(G);
      if ok then
        vprint redlib,1: "Chain graph";
      else
        vprint redlib,1: "Mmylib planar coordinates";
        x,y:=PlanarCoordinates(G: attempts:=attempts);           // mmylib (starts from random and repels)
        XY:=[[x[i]/1.5,y[i]/1.5]: i in [1..#x]];
      end if;
    end if;
  end if;
  x:=[c[1]: c in XY]; 
  x:=[d-m+1: d in x] where m is Min(x);
  y:=[c[2]: c in XY];
  y:=[d-m+1: d in y] where m is Min(y);
  return x,y,labels;
end intrinsic;


intrinsic TeXGraph(G::GrphUnd: x:="default", y:="default", labels:="default", scale:=0.8, xscale:=1, yscale:=1, 
  vertexlabel:="default", edgelabel:="default", vertexnodestyle:="default", edgenodestyle:="default", edgestyle:="default") -> MonStgElt
{Simple function to draw a small planar graph in tikz. Labels can be a sequence 
of strings (or "none", or "default" -> 1,2,3,... unless G is labelled) to draw vertices.
This function is not used in the core of the package, and is just here to illustrate 
StandardGraphCoordinates used for drawing shapes and reduction types}

  RR:=func<x|PrintReal(x: prec:=2)>;

  xscale:=RR(scale*xscale);
  yscale:=RR(scale*yscale);

  // Global tikz options to start with -> options
  tikzstyle:=Sprintf("xscale=%o,yscale=%o,auto=left",xscale,yscale);   
  options:=[tikzstyle];

  // Initialise default drawing primitives

  if vertexlabel cmpeq "default" then               // Print vertex labels without spaces, [, ]
    vertexlabel:=func<v|IsLabelled(v) select DelSymbols(Label(v),"[] ") else "">;
  end if;
  if edgelabel cmpeq "default" then                 // Print edge labels without spaces, [, ]
    edgelabel:=func<e|IsLabelled(e) select DelSymbols(Label(e),"[] ") else "">;
  end if;
  if vertexnodestyle cmpeq "default" then           // Color etc. for vertex nodes
    vertexnodestyle:="circle,scale=0.7,fill=blue!20,inner sep=1pt";    
  end if;
  if edgenodestyle cmpeq "default" then             // Color etc. edge label nodes
    edgenodestyle:="scale=0.6,above";    
  end if;
  if edgestyle cmpeq "default" then                 // Thickness etc. for edges
    edgestyle:="";    
  end if;
  if x cmpeq "default" or y cmpeq "default" then    // Use planar graph default coordinates if possible
    x,y,stdlabels:=StandardGraphCoordinates(G);    
  end if;

  styles := [*vertexnodestyle,edgenodestyle,edgestyle*];
  vars := [* VertexSet(G), [e: e in EdgeSet(G) | IsLabelled(e)], EdgeSet(G) *];
  optname := ["v","l","e"];
  error if exists{s: s in styles | Type(s) ne MonStgElt and Type(s) ne UserProgram},
    "TeXGraph: vertexnodestyle, edgenodestyle, edgestyle should be either strings (same for every vertex/edge) or functions graph vertex -> string";
  for i in [1..#styles] do
    s:=styles[i];
    if Type(s) eq UserProgram or #vars[i] eq 0 then
      V:={s(v): v in vars[i]};
      if #V eq 1 then                           // constant style for all vertices/edges
        s:=Representative(V); 
      elif IsEmpty(V) then
        s:="";
      end if;
    end if;
    if Type(s) eq MonStgElt then
      s:=trim(s);
      if s eq "" then
        styles[i]:=func<v|"">;
      else
        Append(~options,Sprintf("%o/.style={%o}",optname[i],s));    // if yes -> make global in options
        styles[i]:=func<v|optname[i]>;
      end if;
    end if;
  end for;
  vertexnodestyle,edgenodestyle,edgestyle:=Explode(styles);

  tikzCode := Sprintf("\\begin{tikzpicture}[%o]\n",PrintSequence(options));

  // Add nodes (vertices) to the TikZ picture
  for v in VertexSet(G) do
    i:=Index(v);
    if   labels cmpeq "none"      then label:=Sprintf("\\hbox to %oem{\\hfill}",xscale);
    elif Type(labels) eq SeqEnum  then label:=labels[i];
    elif labels cmpne "default"   then error "labels should be 'none', 'default' or a sequence of strings";
    elif IsLabelled(v)            then label:=vertexlabel(v);
                                  else label:=stdlabels[i];
    end if;
    tikzCode cat:= Sprintf("  \\node[%o] (%o) at (%o,%o) {%o};\n",vertexnodestyle(v),i,RR(x[i]),RR(y[i]),label);
  end for;

  // Add edges to the TikZ picture
  for e in EdgeSet(G) do
    i1,i2:=Explode(VertexIndices(e));
    if IsLabelled(e)
      then tikzCode cat:= Sprintf("  \\draw[%o] (%o)--node[%o] {%o} (%o);\n",edgestyle(e),i1,edgenodestyle(e),edgelabel(e),i2);
      else tikzCode cat:= Sprintf("  \\draw[%o] (%o)--(%o);\n",edgestyle(e),i1,i2);
    end if;
  end for;

  // End the TikZ picture
  tikzCode cat:= "\\end{tikzpicture}";

  return tikzCode;
end intrinsic;


/*
Example Drawing planar graphs
D:=PlanarGraphDatabase(7);         // assuming database is installed
G1:=Graph(D,#D-2);                 // draw three most complex planar graphs
G2:=Graph(D,#D-1);                 // on 7 vertices
G3:=Graph(D,#D);
TeXGraph(G1)*"\\qquad"*TeXGraph(G2)*"\\qquad"*TeXGraph(G3); //> TeXGraph(G1),TeXGraph(G2),TeXGraph(G3);
shapes:=[S[1]: S in Shapes(4) | #S[1] eq 6][[4,20,28,30]];
&cat [TeX(S): S in shapes];        // This is used when drawing shapes 
IsPlanar(Graph(shapes[4]));
*/
