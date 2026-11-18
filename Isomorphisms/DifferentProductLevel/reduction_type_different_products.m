// Run from the top folder Unexpected-Isos (copy this file there):
//   nohup magma -s reduction_type_different_products.m > reduction_type_different_products.log &

// Loading compare_reduction_types, which compares the special fibers of two quotients at
// primes dividing the level (dual_graphs_level.m) and at primes dividing the discriminant
// (dual_graphs_discriminant.m). This also loads AL_identifiers.m and quot_genus.m.
// Magma resolves relative loads against the current directory, including the loads
// inside these files, so we step into AuxiliaryFiles for this.
ChangeDirectory("AuxiliaryFiles");
load "compare_reduction_types.m";
ChangeDirectory("..");

// Loading the lists of pairs of AL quotients with isogenous Jacobians, in distinct
// product levels. In isogenous_pairs__different_products.m each entry is
// [* D1, N1, D2, N2, g, W1gens, W2gens *], with the first curve always a Shimura curve
// quotient (D1 > 1). In isogenous_modular_quotients_different_levels.m both curves are
// modular, and each entry is [* N1, N2, g, W1gens, W2gens *].
load "Isogenies/DifferentProductLevel/isogenous_pairs__different_products.m";
load "Isogenies/DifferentProductLevel/isogenous_modular_quotients_different_levels.m";

// all pairs of genus >= 2, in the first format (D1 = D2 = 1 for the modular ones); the
// genus 1 pairs are decided by the isomorphism classes of their Jacobians and their
// rational points, which are known
candidate_pairs := [* *];
for P in remaining_after_pt_cts_general do
    if P[5] ge 2 then Append(~candidate_pairs, P); end if;
end for;
for P in isogenous_modular_quotients_different_levels do
    if P[3] ge 2 then Append(~candidate_pairs, [* 1, P[1], 1, P[2], P[3], P[4], P[5] *]); end if;
end for;


////// Reduction type checks

    // pairs with D1 = D2 = 1 are stored separately, as local_points_check.m does not
    // apply to them
    remaining_after_reduction := [* *];
    excluded_by_reduction := [* *];
    remaining_modular := [* *];
    excluded_modular := [* *];

    steps := #candidate_pairs;
    step := 0;

    for pair in candidate_pairs do
        step := step + 1;
        print "Step out of ", steps, ": ", step;
        print "Pair: ", pair;

        proven_non_isom, reason := compare_reduction_types(pair[1],pair[2],pair[6],
                                                           pair[3],pair[4],pair[7],pair[5]);

        if proven_non_isom then
            print "proven non-isomorphic by reduction types: ", reason;
        end if;

        if (pair[1] eq 1) and (pair[3] eq 1) then
            if proven_non_isom then
                Append(~excluded_modular,pair);
            else
                Append(~remaining_modular,pair);
            end if;
        else
            if proven_non_isom then
                Append(~excluded_by_reduction,pair);
            else
                Append(~remaining_after_reduction,pair);
            end if;
        end if;

    end for;

    print "candidate pairs considered: ", steps;
    print "D1*D2 > 1: pairs excluded by reduction type checks: ", #excluded_by_reduction;
    print "D1*D2 > 1: pairs remaining: ", #remaining_after_reduction;
    print "D1 = D2 = 1: pairs excluded by reduction type checks: ", #excluded_modular;
    print "D1 = D2 = 1: pairs remaining: ", #remaining_modular;

    // the excluded pairs of all our checks are collected in excluded.m: this first check
    // starts the list excluded, and the later checks append to it
    // Overwrite := true, since SetOutputFile appends to an existing file by default
    SetOutputFile("Isomorphisms/DifferentProductLevel/excluded.m" : Overwrite := true);
    print "excluded := ", excluded_by_reduction cat excluded_modular, ";";
    UnsetOutputFile();

    SetOutputFile("Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v1.m" : Overwrite := true);
    print "remaining_isomorphism_lists_different_products_v1 := ", remaining_after_reduction, ";";
    UnsetOutputFile();

    SetOutputFile("Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_modular_different_levels_v1.m" : Overwrite := true);
    print "remaining_isomorphism_lists_modular_different_levels_v1 := ", remaining_modular, ";";
    UnsetOutputFile();

