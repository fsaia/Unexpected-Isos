// Run from the top folder Unexpected-Isos (copy this file there), after
// reduction_type_different_products.m:
//   nohup magma -s local_points_check.m > local_points_check.log &

// Loading code for dual graphs of special fibers of Shimura curves at primes
// dividing the discriminant, via the algorithm of Padurariu--Saia 2026.
// This also loads AL_identifiers.m and quot_genus.m. Magma resolves relative loads
// against the current directory, including the loads inside these files, so we
// step into AuxiliaryFiles for this.
ChangeDirectory("AuxiliaryFiles");
load "existence_of_Qp_points.m";   // also loads dual_graphs_level.m and dual_graphs_discriminant.m
ChangeDirectory("..");

// Q_p points at p | D (Padurariu--Saia) or at p || N (existence_of_Qp_points_level);
// the latter needs DN squarefree, p < 100 and D*N/p <= 10000 (for shipoints)
decidable := function(D,N,p)
    return D mod p eq 0 or (IsSquarefree(D*N) and N mod p eq 0 and p lt 100 and D*(N div p) le 10000);
end function;

has_Qp_points := function(D,N,W,p)
    if D mod p eq 0 then return quotient_has_Qp_points(D,N,Seqset(W),p); end if;
    return existence_of_Qp_points_level(D,N,p,W);
end function;

// Loading the pairs surviving the reduction type checks of
// reduction_type_different_products.m
load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v1.m";


////// Local points checks

    remaining_after_local_points := [* *];
    excluded_by_local_points := [* *];

    // only the genus >= 2 pairs; the genus 1 pairs are decided by genus1_label_comparison.m
    candidates := [pair : pair in remaining_isomorphism_lists_different_products_v1 | pair[5] ge 2];
    steps := #candidates;
    step := 0;

    for pair in candidates do
        step := step + 1;
        print "Step out of ", steps, ": ", step;
        print "Pair: ", pair;

        D1 := pair[1];
        N1 := pair[2];
        D2 := pair[3];
        N2 := pair[4];
        W1gens := pair[6];
        W2gens := pair[7];

        W1 := gens_to_identifier(D1*N1,Seqset(W1gens));
        W2 := gens_to_identifier(D2*N2,Seqset(W2gens));

        // initalizing a boolean
        proven_non_isom := false;

        // A modular curve quotient has a rational point, namely the image of the cusp at
        // infinity, and hence has Q_p points for every prime p. So if exactly one of the
        // curves is modular, it is enough to see that the Shimura curve quotient fails to
        // be locally solvable at a prime dividing its discriminant. When both curves are
        // Shimura curve quotients we instead compare local solvability at the primes
        // dividing both discriminants, since an isomorphism over Q forces agreement.
        // Local solvability is determined from the dual graph of the special fiber over
        // Z_p, using the algorithm of Padurariu--Saia 2026.
        if D2 eq 1 then
            print "have one modular curve and one non-modular curve; checking local points";
            for p in [p : p in PrimeDivisors(D1*N1) | decidable(D1,N1,p)] do
                if not has_Qp_points(D1,N1,W1,p) then
                    print "proven non-isomorphic by local points check";
                    proven_non_isom := true;
                    break;
                end if;
            end for;

        else
            print "have two non-modular curves; comparing local points";
            for p in [p : p in PrimeDivisors(D1*N1) | p in PrimeDivisors(D2*N2) and decidable(D1,N1,p) and decidable(D2,N2,p)] do
                if has_Qp_points(D1,N1,W1,p) ne has_Qp_points(D2,N2,W2,p) then
                    print "proven non-isomorphic by local points check";
                    proven_non_isom := true;
                    break;
                end if;
            end for;
        end if;

        if proven_non_isom then
            Append(~excluded_by_local_points,pair);
        else
            Append(~remaining_after_local_points,pair);
        end if;

    end for;

    print "candidate pairs considered: ", steps;
    print "pairs excluded by local points checks: ", #excluded_by_local_points;
    print "pairs remaining: ", #remaining_after_local_points;

    // appended to the file started by reduction_type_different_products.m
    SetOutputFile("Isomorphisms/DifferentProductLevel/excluded.m");
    print "excluded cat:= ", excluded_by_local_points, ";";
    UnsetOutputFile();

    // Overwrite := true, since SetOutputFile appends to an existing file by default
    SetOutputFile("Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v2.m" : Overwrite := true);
    print "remaining_isomorphism_lists_different_products_v2 := ", remaining_after_local_points, ";";
    UnsetOutputFile();

