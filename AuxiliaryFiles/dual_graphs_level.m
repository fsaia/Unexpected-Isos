// Dual graphs of the special fibers of Atkin--Lehner quotients X_0^D(N)/W at primes p || N
// (D >= 1, DN squarefree). This generalises modular_dual_graphs.m (the case D = 1); the
// primes p | D are described in dual_graphs_discriminant.m.
//
// With N = pM: X_0^D(N) over Fbar_p is two copies of X_0^D(M) glued at the supersingular
// points, which are the left ideal classes of an Eichler order of level M in the definite
// quaternion algebra of discriminant Dp; the node at (A,G) has thickness #Aut(A,G)/2, and
// w_d swaps the two copies iff p | d. On X_0^D(N)/W the description is as in
// modular_dual_graphs.m (Buzzard's model; for D = 1 Deligne--Rapoport).

load "dual_graphs_discriminant.m";

// level_nodes : the nodes of X_0^D(pM) at p are the supersingular points of X_0^D(M), i.e. the
// basis of the Brandt module of level M in the definite algebra of discriminant Dp.
// perm[l] is w_l for l | DM; for l = p it is x -> x^(p), induced by the relative Frobenius
// X_0^D(M)_{F_p} -> X_0^D(M)_{F_p} over F_p (this is how w_p permutes the nodes).
// weights[i] = #Aut(x_i)/2 is the thickness of the i-th node.
level_nodes := function(D,M,p)
	B := BrandtModule(D*p, M);
	assert AtkinLehnerPrimes(B) eq PrimeDivisors(D*p*M);
	
	if D eq 1 then
		assert Dimension(B) eq GenusX0NQuotient(p*M,[]) - 2*GenusX0NQuotient(M,[]) + 1;
	else
		assert Dimension(B) eq genus(D,p*M) - 2*genus(D,M) + 1;
	end if;
	
	perm := AssociativeArray();
	for l in PrimeDivisors(D*p*M) do
		A := AtkinLehnerOperator(B,l);   // a signed permutation matrix
		perm[l] := [ [ j : j in [1..Ncols(A)] | A[i,j] ne 0 ][1] : i in [1..Nrows(A)] ];
	end for;
	return perm, MonodromyWeights(B);
end function;

// BrandtModule allows AtkinLehnerOperators only for primes
// so here we build general w_m as a composition of w_q
// for primes q dividing m
// and perm is the action of w_q for all primes q
AL_action_on_node := function(m, i, perm)
	for q in PrimeDivisors(m) do
		i := perm[q][i];
	end for;
	return i;
end function;

// level_quotient_nodes : thicknesses of the nodes of X_0^D(N)/W at p, where W = <w_m : m in Wgens>
// (any generators, as a sequence or a set, as in X0NQuotient).
// These are the W-orbits of nodes, a node x has thickness #W_x * weight(x),
// unless it's smoothed out
// (because there is some w in W_x swapping the two components).
// Additionally, for testing the existence of Q_p-points, it returns R, a representative of each
// node in T (in the same order; smoothed-out nodes are not included), and perm. The basis order
// of BrandtModule changes between calls, so R must be used with this perm.
level_quotient_nodes := function(D,N,p,Wgens)
	W := gens_to_identifier(D*N,Wgens);
	perm, weights := level_nodes(D, N div p, p);

	T := []; R := [];
	seen := {};
	for i in [1..#weights] do
		if i in seen then continue; end if;
		seen join:= { AL_action_on_node(m,i, perm) : m in W };
		stab := [ m : m in W | AL_action_on_node(m,i, perm) eq i ];
		if forall{ m : m in stab | m mod p ne 0 } then
			Append(~T, #stab*weights[i]);
      			Append(~R, i);
		end if;
	end for;
	ParallelSort(~T, ~R);
	return T, R, perm;
end function;

// short version immediately below
//Frob_in_orbit := function(perm, p, H, i)
//	for h in H do
//		if AL_action_on_node(h, i) eq perm[p][i] then
//			return true;
//		end if;
//	end for;
//	return false;
//end function;


// does the H-orbit of a node i
// contain Frob i?
// Frob i = perm[p][i]
Frob_in_orbit := function(perm, p, H, i)
  return exists{ m : m in H | AL_action_on_node(m, i, perm) eq perm[p][i]};
end function;

// is the image of i on the quotient (by W) F_p-rational?
is_node_Fp_rational := function(perm, p, W, i)
  return Frob_in_orbit(perm, p, W, i);
end function;

is_node_smoothed_out := function(perm, p, W, i)
  stab := [m : m in W | AL_action_on_node(m, i, perm) eq i];
  if forall{ m : m in stab | m mod p ne 0 } then
    return false;
  else return true;
  end if;
end function;

is_node_split := function(perm, p, W, i)
  if is_node_smoothed_out(perm, p, W, i) then
    return false;
  end if;
  
  Wprime := [m : m in W | m mod p ne 0];
  return Frob_in_orbit(perm, p, Wprime, i);
end function;

is_node_non_split := function(perm, p, W, i)
  return (is_node_Fp_rational(perm, p, W, i) and not is_node_smoothed_out(perm, p, W, i) and not is_node_split(perm, p, W, i));
end function;

// the total count of the edges in the minimal regular model
dual_graph_at_p_edge_count_level := function(D,N,Wgens,p)
  return &+(level_quotient_nodes(D,N,p,Wgens) cat [0]);
end function;

// dual_graph_at_p_edge_count
// returns the number of edges in the dual graph of the minimal regular 
// model of X = X_0^D(N)/W at p for a prime p dividing DN.
// (Wgens set of generators for W)
dual_graph_at_p_edge_count := function(D,N,Wgens,p)
	
	assert D*N mod p eq 0;

	if D mod p eq 0 then 
		return dual_graph_at_p_edge_count_discriminant(D,N,Wgens,p);
	else
		return dual_graph_at_p_edge_count_level(D,N,Wgens,p);
	end if; 

end function;


// number of components
component_count := function(D, N, p, Wgens)
  W := gens_to_identifier(D*N, Wgens);
  M := N div p;
	Wprime := [m : m in W | m mod p ne 0];
	c := (#Wprime eq #W) select 2 else 1;
  return c;
end function;

// all_bad_level_reductions_profile : [* p, c, g, T *] for each p | N, with c the number of components
// (2 iff W = W'), g their genus (that of X_0^D(M)/W') and T the thicknesses of the nodes
all_bad_level_reductions_profile := function(D,N,Wgens)
	W := gens_to_identifier(D*N,Wgens);
	profile := [* *];
	for p in PrimeDivisors(N) do
		M := N div p;
		Wprime := [m : m in W | m mod p ne 0];
		c := (#Wprime eq #W) select 2 else 1;
		g := (D eq 1) select GenusX0NQuotient(M,[m : m in Wprime | m ne 1]) else Integers()!quot_genus(D,M,Wprime);
		Append(~profile, [* p, c, g, level_quotient_nodes(D,N,p,W) *]);
	end for;
	return profile;
end function;

// dual_graph_edge_counts_level : [p, n] for each p | N, n the number of edges of the dual graph of
// the minimal regular model at p (for g(X_0^D(N)/W) >= 1)
dual_graph_edge_counts_level := function(D,N,Wgens)
	return [ [p, dual_graph_at_p_edge_count_level(D,N,Wgens,p)] : p in PrimeDivisors(N) ];
end function;

// dual_graph_edge_counts : [p, e] for every prime p | DN
dual_graph_edge_counts := function(D,N,Wgens)
	return [ [p, dual_graph_at_p_edge_count(D,N,Wgens,p)] : p in PrimeDivisors(D*N) ];
end function;
