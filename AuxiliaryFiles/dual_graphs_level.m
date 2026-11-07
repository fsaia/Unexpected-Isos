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


// level_fiber : given D, M and a prime p not dividing DM, return the edge information and
// Atkin--Lehner data of the dual graph of the special fiber of X_0^D(pM) at p, in the same
// format as modular_fiber (first half of edge_info one orientation, second half the reverses).
level_fiber := function(D,M,p)

	N := p*M;
	assert IsSquarefree(D*N);

	// supersingular points of X_0^D(M) in characteristic p <-> left ideal classes of an
	// Eichler order of level M in the definite quaternion algebra of discriminant Dp
	Q := QuaternionAlgebra(D*p);
	O := QuaternionOrder(Q, M);
	LL := LeftIdealClasses(O);
	n := #LL;

	// arithmetic self-check: g(X_0^D(N)) = 2*g(X_0^D(M)) + n - 1
	if D eq 1 then
		assert n eq GenusX0NQuotient(N,[]) - 2*GenusX0NQuotient(M,[]) + 1;
	else
		assert n eq genus(D,N) - 2*genus(D,M) + 1;
	end if;

	OrderGrams := [ ReducedGramMatrix(RightOrder(II)) : II in LL ];

	// Atkin--Lehner permutations of the supersingular points (for l = p: Frobenius)
	perm := AssociativeArray();

	for l in PrimeDivisors(D*N) do
		ALList := [0 : II in LL];

		for A in SequenceToSet(OrderGrams) do
			Lat := LatticeWithGram(A);
			K := [ j : j in [1..#OrderGrams] | OrderGrams[j] eq A ];
			B := LocalDualGram(Lat,l);

			// for each I, find J such that I is mapped to J by w_l
			for i in K do
				ALList[i] := Explode([ j : j in K | IsIsometric(LatticeWithGram(1/(Norm(I)*Norm(J)) * GramMatrix(Conjugate(J)*I)),LatticeWithGram(B)) where I := LL[i] where J := LL[j] ]);
			end for;
		end for;

		perm[l] := ALList;
	end for;

	// thickness of the node at (A,G): #Aut(A,G)/2 = #(units of the right order)/2
	thickness := [ ExactQuotient(#Units(RightOrder(LL[i])),2) : i in [1..n] ];

	// each edge in both orientations, between the components "plus" and "minus"
	edge_info := [ [* [* 1,"plus" *], [* 1,"minus" *], thickness[i] *] : i in [1..n] ];
	for i in [1..n] do
		Append(~edge_info,[* [* 1,"minus" *], [* 1,"plus" *], thickness[i] *]);
	end for;

	ALOperators := AssociativeArray();

	// w_l for l | DM preserves each of the two components
	for l in PrimeDivisors(D*M) do
		ALList := [* 0 : edge in edge_info *];

		for i in [1..n] do
			ALList[i] := [i, perm[l][i]];
			ALList[i+n] := [i+n, perm[l][i]+n];
		end for;

		ALOperators[l] := ALList;
	end for;

	// w_p swaps the two components
	ALList := [* 0 : edge in edge_info *];
	for i in [1..n] do
		ALList[i] := [i, perm[p][i]+n];
		ALList[i+n] := [i+n, perm[p][i]];
	end for;
	ALOperators[p] := ALList;

	// w_1 acts trivially
	ALList := [* 0 : edge in edge_info *];
	for i in [1..2*n] do
		ALList[i] := [i, i];
	end for;
	ALOperators[1] := ALList;

	// w_m for m composite
	for m in Divisors(D*N) do
		m_primes := PrimeDivisors(m);
		if #m_primes gt 1 then
			ALList := [* 0 : edge in edge_info *];

			for i in [1..#ALList] do
				e_index := i;
				for l in m_primes do // composition
					e_index := ALOperators[l][e_index][2];
				end for;
				ALList[i] := [i,e_index];
			end for;

			ALOperators[m] := ALList;
		end if;
	end for;

	return edge_info, ALOperators;
end function;


// level_component_genus : genus of X_0^D(M)/W', with W' given by its identifier
// (the components of the special fiber of X_0^D(N)/W at p are copies of this curve)
level_component_genus := function(D,M,Wp)
	if D eq 1 then
		return GenusX0NQuotient(M,[m : m in Wp | m ne 1]);
	end if;
	return Integers()!quot_genus(D,M,Wp);
end function;


// level_quotient_edges : the edge orbits of the special fiber of X_0^D(N)/W at p,
// minimized as in Kodaira_from_dual_modular: prune only contracts P^1 leaves, so if the
// components have positive genus we only remove the half-edges (nodes smoothed out in
// the quotient).
level_quotient_edges := function(D,N,p,Wgens)
	M := ExactQuotient(N,p);
	W := gens_to_identifier(D*N,Wgens);
	edge_info, AL := level_fiber(D,M,p);

	// identify edges via W
	orbits_seq := AL_quotient_edges(D,N,p,W,edge_info,AL);

	Wp := [m : m in W | m mod p ne 0];
	if level_component_genus(D,M,Wp) gt 0 then
		orbits_seq := remove_half_edges(orbits_seq,edge_info);
	else
		minimal_check := false;
		while minimal_check eq false do
			pruned_orbits_seq := prune(orbits_seq,edge_info);
			if pruned_orbits_seq eq orbits_seq then
				minimal_check := true;
			else
				orbits_seq := pruned_orbits_seq;
			end if;
		end while;
	end if;

	return orbits_seq;
end function;


// dual_graph_at_p_edge_counts_level : take D, N, Wgens set of generators for 
// W with X = X_0^D(N)/W, 
// returns the number of edges in the dual graph of the minimal regular 
// model of X at p.
// Note: if X has genus 1, then this gives the Kodaira symbol of X
// at p.
// This is the p | N analogue of dual_graph_at_p_edge_counts_discriminant, 
// and returns data in the same format.
dual_graph_at_p_edge_counts_level := function(D,N,Wgens,p)

	orbits_seq := level_quotient_edges(D,N,p,Wgens);

	// n = count of edges with multiplicity (each edge occurs in both orientations)
	if IsEmpty(orbits_seq) then
		e_p := 0;
	else
		e_p := Integers()!(&+[orbit[2] : orbit in orbits_seq]/2);
	end if;

	return e_p;

end function;


// dual_graph_edge_counts_level : take D, N, Wgens set of generators for 
// W with X = X_0^D(N)/W, 
// returns sequence of pairs [p,e], where e is the number of edges in the 
// dual graph of the minimal regular 
// model of X at p, for all primes p dividing N.
// Note: if X has genus 1, then this gives the Kodaira symbols of X
// at all primes p dividing D. 
// This is the p | N analogue of dual_graph_edge_counts_discriminant, 
// and returns data in the same format.
dual_graph_edge_counts_level := function(D,N,Wgens) 
	
	edge_counts := []; // initializing list of edge counts

	for p in PrimeDivisors(N) do 
		e_p := dual_graph_at_p_edge_counts_level(D,N,Wgens,p);
		Append(~edge_counts, [p, e_p]); 
	end for; 

	return edge_counts;

end function;


// staples together the information of edge counts
// in the dual graphs of X = X_0^D(N)/<Wgens> at all bad primes
// Note: if X has genus 1, this gives all Kodaira symbols for X
dual_graph_edge_counts := function(D,N,Wgens)
	level_counts := dual_graph_edge_counts_discriminant(D,N,Wgens);
	disc_counts := dual_graph_edge_counts_level(D,N,Wgens);

	counts := level_counts cat disc_counts;
	Sort(~counts);

	return counts;
end function; 


// reduction_profile_level : finer data at each p | N, as [* p, c, g, T *] with c the number
// of components of the special fiber of X_0^D(N)/W (1 or 2), g their genus, and T the
// sorted list of thicknesses of the nodes. For genus >= 2 this determines the stable model
// (the minimal regular model replaces a node of thickness t by a chain of t-1 lines).
reduction_profile_level := function(D,N,Wgens)

	profile := [* *];
	W := gens_to_identifier(D*N,Wgens);

	for p in PrimeDivisors(N) do
		M := ExactQuotient(N,p);
		Wp := [m : m in W | m mod p ne 0];
		c := (#Wp eq #W) select 2 else 1;
		g := level_component_genus(D,M,Wp);

		// no pruning here, only the half-edges are removed; each node occurs as two
		// orbits (both orientations) with the same thickness
		edge_info, AL := level_fiber(D,M,p);
		orbits_seq := remove_half_edges(AL_quotient_edges(D,N,p,W,edge_info,AL),edge_info);
		T := Sort([orbit[2] : orbit in orbits_seq]);
		T := [T[i] : i in [1..#T] | IsOdd(i)];

		Append(~profile, [* p, c, g, T *]);
	end for;

	return profile;
end function;



