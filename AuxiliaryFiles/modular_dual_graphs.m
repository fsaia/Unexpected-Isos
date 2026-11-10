// Dual graphs of the special fibers of Atkin--Lehner quotients of modular curves.
//
// This is the D = 1 counterpart of dual_graphs_discriminant.m. Here we describe
// X_0(N)/W at a prime p || N via Deligne--Rapoport, so that reduction type data of
// a Shimura curve quotient and of a modular curve quotient can be compared
// without needing an equation for either.
//
// We use the following, with N = pM and p not dividing M.
//
//   (1) X_0(N) over Z[1/M] is semistable, and X_0(N) over Fbar_p consists of two
//       copies of X_0(M) over Fbar_p, glued transversally along the supersingular
//       points; a supersingular point x on the first copy is identified with
//       Frob_p x on the second. An element w_d swaps the two components if
//	 and only if p | d.
//   (2) If (E,H) is a supersingular point x, then the thickness of x is #Aut(E,H)/2.
//   (3) For W <= W_N, writing W_x for the stabiliser of x in W: if some w_{pd} lies
//       in W_x then X_0(N)/W is smooth at the image of x, and otherwise the image is
//       an ordinary double point of thickness #W_x * #Aut(E,H)/2.
// (this last statement comes from Adzaga-Derickx-Keller, but it's really just
//  Deligne-Rapoport + Raynaud's theorem).

// The minimal regular model is obtained from this semistable model by resolving each
// node of thickness e into a chain of e-1 projective lines, all of self-intersection
// -2, so no further contraction is possible and the minimal regular and the regular
// semistable models agree. In particular the edge counts produced here can be
// directly compared to those of dual_graph_edge_counts_discriminant.
//
// The description above is valid at every prime p || N, including p = 2.

// The functions below are the case D = 1 of dual_graphs_level.m (which loads dual_graphs_discriminant.m).
load "dual_graphs_level.m";


// Kodaira_from_dual_modular : given N squarefree and Wgens a set of generators for
// W <= W_N, return for each prime p | N the number of edges in the dual graph of the
// minimal regular model of X_0(N)/W at p, counted with multiplicity.

Kodaira_from_dual_modular := function(N,Wgens)
	return dual_graph_edge_counts_level(1,N,Wgens);
end function;
