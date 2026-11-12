// Comparison of the special fibers of two Atkin--Lehner quotients X = X_0^{D1}(N1)/W1 and
// Y = X_0^{D2}(N2)/W2 of the same genus g >= 1 (D1, D2 >= 1, D1N1 and D2N2 squarefree),
// at primes dividing the level via dual_graphs_level.m and at primes dividing the
// discriminant via dual_graphs_discriminant.m. This also loads AL_identifiers.m and quot_genus.m.

load "dual_graphs_level.m";

// edge_count_or_zero : the number of edges of the dual graph of the minimal regular model of
// X_0^D(N)/W at p, which is 0 when p does not divide DN (good reduction)
edge_count_or_zero := function(D,N,W,p)
    if (D*N) mod p ne 0 then
        return 0;
    end if;
    return dual_graph_at_p_edge_count(D,N,Seqset(W),p);
end function;

// compare_reduction_types : returns true and a reason if the special fibers show that
// X_0^{D1}(N1)/W1 and X_0^{D2}(N2)/W2 (both of genus g) are not isomorphic over Q,
// and false otherwise. W1gens and W2gens are sequences or sets of generators.
compare_reduction_types := function(D1,N1,W1gens,D2,N2,W2gens,g)
    // We use the identifiers of W1 and W2, so that the trivial subgroup is recorded as [1]
    // rather than as the empty sequence.
    W1 := gens_to_identifier(D1*N1,Seqset(W1gens));
    W2 := gens_to_identifier(D2*N2,Seqset(W2gens));

    // At p dividing both levels, the special fiber has two components if no w_m in W has
    // p | m, and one component otherwise. For g >= 2 this model is the stable model, so the
    // number of components is an invariant. For g = 1 it is not (two P^1's meeting at nodes
    // of thicknesses a, b and one P^1 with a loop of thickness a+b are both I_{a+b}), so
    // there we rely on the edge counts below.
    if g ge 2 then
        for p in PrimeDivisors(GCD(N1,N2)) do
            if (LCM(W1) mod p eq 0) ne (LCM(W2) mod p eq 0) then
                return true, Sprintf("number of components at p = %o", p);
            end if;
        end for;
    end if;

    // The number of edges of the dual graph of the minimal regular model at every prime p:
    // at a common bad prime both sides are computed, while at a prime dividing only one of
    // D1N1, D2N2 the other curve has good reduction, so an isomorphism forces 0 edges.
    for p in PrimeDivisors(D1*N1*D2*N2) do
        if edge_count_or_zero(D1,N1,W1,p) ne edge_count_or_zero(D2,N2,W2,p) then
            return true, Sprintf("number of edges at p = %o", p);
        end if;
    end for;

    return false, "";
end function;
