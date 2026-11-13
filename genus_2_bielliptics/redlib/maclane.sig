178,0
T,MacV,-,0
A,MacV,5,D,n,g,lambda,e
S,IsCoercible,Coerce a MacLane valuation v (returns false),0,2,0,0,0,0,0,0,0,-1,,0,0,MacV,,36,-1,-38,-38,-38,-38
S,in,"""in"" function for a MacLane valuation v (returns false)",0,2,0,0,0,0,0,0,0,-1,,0,0,MacV,,36,-38,-38,-38,-38,-38
S,Print,Print a MacLane valuation v,0,2,0,0,1,0,0,0,0,298,,0,0,MacV,,-38,-38,-38,-38,-38,-38
S,MacLaneValuation,"Create a MacLane valuation from its primary invariants: key polynomials g_i and rationals lambda_i,  so that v(g_i)=lambda_i",0,3,0,0,0,0,0,0,0,82,,0,0,82,,0,0,RngDVR,,MacV,-38,-38,-38,-38,-38
S,GaussValuation,Gauss valuation on K[x] for K a field with a valuation specified with D of type RngDVR,0,1,0,0,0,0,0,0,0,RngDVR,,MacV,-38,-38,-38,-38,-38
S,MacLaneValuation,"Create a MacLane valuation from its primary invariants: key polynomials g_i and rationals lambda_i,  so that v(g_i)=lambda_i. The invariants a given as a sequence t of tuples [<g_i,lambda_i>]",1,1,1,82,0,303,2,0,0,0,0,0,0,0,82,,0,0,RngDVR,,MacV,-38,-38,-38,-38,-38
S,Length,"Length n of the MacLane valuation (number of the defining key polynomials g_1,...,g_n)",0,1,0,0,0,0,0,0,0,MacV,,148,-38,-38,-38,-38,-38
S,Center,"Center of the MacLane valuation (last g_n in the list g_1,...,g_n of key polynomials)",0,1,0,0,0,0,0,0,0,MacV,,312,-38,-38,-38,-38,-38
S,Degree,Degree of the MacLane valuation (degree of the last defining polynomial g_n=Center(v)),0,1,0,0,0,0,0,0,0,MacV,,148,-38,-38,-38,-38,-38
S,Radius,Radius of the MacLane valuation (last lambda in the list of key polynomial assignments v(g_i)=lambda_i),0,1,0,0,0,0,0,0,0,MacV,,267,-38,-38,-38,-38,-38
S,IsGauss,True if v is the Gauss valuation,0,1,0,0,0,0,0,0,0,MacV,,36,-38,-38,-38,-38,-38
S,Extends,True if v2 extends v1 as a MacLane valuation,0,2,0,0,0,0,0,0,0,MacV,,0,0,MacV,,36,-38,-38,-38,-38,-38
S,Truncate,Truncate a MacLane valuation to a smaller n <= Length(v),0,2,0,0,0,0,0,0,0,148,,0,0,MacV,,MacV,-38,-38,-38,-38,-38
S,Truncate,Truncate a MacLane valuation to n-1 where n is Length(v),0,1,0,0,0,0,0,0,0,MacV,,MacV,-38,-38,-38,-38,-38
S,ChangeSlope,Copy valuation with the last slope lambda_n changed to s,0,2,0,0,0,0,0,0,0,267,,0,0,MacV,,MacV,-38,-38,-38,-38,-38
S,RamificationDegree,Ramification degree of a MacLane valuation over the Gauss valuation,0,1,0,0,0,0,0,0,0,MacV,,148,-38,-38,-38,-38,-38
S,Monomial,"Canonical monomial in the key polynomials of v of a given rational valuation s, constructed inductively",0,2,0,0,0,0,0,0,0,267,,0,0,MacV,,312,-38,-38,-38,-38,-38
S,MacData,"List of tuples [<g_i,lambda_i>] that define a given MacLane valuation",0,1,0,0,0,0,0,0,0,MacV,,82,-38,-38,-38,-38,-38
S,Expand,"Expand f in powers of g and return the sequence of coefficients, which are polynomials of degree < deg g",0,2,0,0,0,0,0,0,0,312,,0,0,312,,82,-38,-38,-38,-38,-38
S,Valuation,"Valuation of a polynomial f with respect to a MacLane valuation v, computed inductively  using the expansion of f in key polynomials of v",0,2,0,0,0,0,0,0,0,MacV,,0,0,312,,303,-38,-38,-38,-38,-38
S,Valuation,Valuation of a rational function f with respect to a MacLane valuation v,0,2,0,0,0,0,0,0,0,MacV,,0,0,238,,303,-38,-38,-38,-38,-38
S,NewtonPolygon,"Compute the slopes of the Newton polygon of a polynomial f with respect to a MacLane valuation v  and relevant monomials (not reduced to the residue field). Returns a list of tuples [* <valuation, ramification degree, unreduced coefficients>, ... *] valuation may be Infinity()",0,2,0,0,0,0,0,0,0,MacV,,0,0,312,,82,-38,-38,-38,-38,-38
S,Distance,"Valuation distance between v and w. The valuations are viewed as defining discoids.  This function is symmetric, and d(v,v)=lambda_n/deg g_n",0,2,0,0,0,0,0,0,0,MacV,,0,0,-1,,267,-38,-38,-38,-38,-38
S,TeX,"Print a MacLane valuation in TeX in diskoid form, as v(Center)>=radius. This is used for cluster names",0,1,0,0,0,0,0,0,0,MacV,,298,-38,-38,-38,-38,-38
