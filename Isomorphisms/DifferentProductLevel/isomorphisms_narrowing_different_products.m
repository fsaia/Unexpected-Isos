// Run from the top folder Unexpected-Isos (copy this file there):
//   nohup magma -s isomorphisms_narrowing_different_products.m > isomorphisms_narrowing_different_products.log &

// Loading code for dual graphs of special fibers: at primes dividing the level via
// our description using Brandt modules (dual_graphs_level.m), and at primes dividing
// the discriminant via the algorithm of Padurariu--Saia 2026.

ChangeDirectory("AuxiliaryFiles");
load "dual_graphs_level.m";
ChangeDirectory("..");

// Loading list of pairs of AL quotients with isogenous Jacobians, in distinct
// product levels. Each entry is [* D1, N1, D2, N2, g, W1gens, W2gens *], with the
// first curve always a Shimura curve quotient (D1 > 1).
load "Isomorphisms/DifferentProductLevel/isogenous_pairs__different_products.m";


////// Reduction type checks

    remaining_after_reduction := [* *];
    excluded_by_reduction := [* *];

    steps := #remaining_after_pt_cts_general;
    step := 0;

    for pair in remaining_after_pt_cts_general do
        step := step + 1;
        print "Step out of ", steps, ": ", step;
        print "Pair: ", pair;

        D1 := pair[1];
        N1 := pair[2];
        D2 := pair[3];
        N2 := pair[4];
        W1gens := pair[6];
        W2gens := pair[7];

        // We use the identifiers of W1 and W2 throughout, so that the trivial subgroup
        // is recorded as [1] rather than as the empty sequence.
        W1 := gens_to_identifier(D1*N1,Seqset(W1gens));
        W2 := gens_to_identifier(D2*N2,Seqset(W2gens));

        proven_non_isom := false;

        // Simple check related to reduction types at primes dividing the level N:
        // if p is such a prime and you quotient X_0^D(N) by
        // a subgroup W consisting of w_m with p not dividing m,
	// then the dual graph of the special fiber at p of the quotient
        // has two irreducible components, and otherwise
        // (if W has some w_m with p dividing m)
	// the graph has one irreducible component.
        // For genus >= 2 this model is the stable model, so the number of components
        // is an invariant. For genus 1 it is not (two P^1's meeting at nodes of
        // thicknesses a, b and one P^1 with a loop of thickness a+b are both I_{a+b}),
        // so there we rely on the edge counts below.
        shared_primes := {p : p in PrimeDivisors(N1) | p in PrimeDivisors(N2)};
        one_comp_primes_X := {p : p in shared_primes | LCM(W1) mod p eq 0};
        one_comp_primes_Y := {p : p in shared_primes | LCM(W2) mod p eq 0};
        if (pair[5] ge 2) and not (one_comp_primes_X eq one_comp_primes_Y) then
            print "proven non-isomorphic by reductions types at prime dividing levels";
            proven_non_isom := true;
        end if;

        if not proven_non_isom then
            // Compare the number of edges of the dual graph of the minimal regular model
            // at every common bad prime: p dividing both discriminants, both levels, or
            // the discriminant of one curve and the level of the other.
            print "checking reduction type info at common bad primes";
            for p in [p : p in PrimeDivisors(D1*N1) | (D2*N2) mod p eq 0] do
                p_edges_X := dual_graph_at_p_edge_count(D1,N1,Seqset(W1),p);
                p_edges_Y := dual_graph_at_p_edge_count(D2,N2,Seqset(W2),p);
                if p_edges_X ne p_edges_Y then
                    print "proven non-isomorphic by reduction types at p = ", p;
                    proven_non_isom := true;
                    break;
                end if;
            end for;
        end if;

        if proven_non_isom then
            Append(~excluded_by_reduction,pair);
        else
            Append(~remaining_after_reduction,pair);
        end if;

    end for;

    print "candidate pairs considered: ", steps;
    print "pairs excluded by reduction type checks: ", #excluded_by_reduction;
    print "pairs remaining: ", #remaining_after_reduction;

    // Overwrite := true, since SetOutputFile appends to an existing file by default
    SetOutputFile("Isomorphisms/DifferentProductLevel/excluded_by_reduction_different_products_v1.m" : Overwrite := true);
    print "excluded_by_reduction_different_products_v1 := ", excluded_by_reduction, ";";
    UnsetOutputFile();

    SetOutputFile("Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v1.m" : Overwrite := true);
    print "remaining_isomorphism_lists_different_products_v1 := ", remaining_after_reduction, ";";
    UnsetOutputFile();

quit;
