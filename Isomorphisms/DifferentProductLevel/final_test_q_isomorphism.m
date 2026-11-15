// Run from the top folder Unexpected-Isos (copy this file there), after Fp_isomorphism_check.m:
//   nohup magma -s final_test_q_isomorphism.m > final_test_q_isomorphism.log &
//
// Final test of isomorphism over Q for the genus >= 2 pairs surviving Fp_isomorphism_check.m,
// together with the purely modular pairs of genus >= 2 surviving
// reduction_type_different_products.m. Equations come from models_db.m, together
// with X0NQuotient on the modular side.
//
// A quotient whose equation is only known up to a list of candidates is handled as
// follows: the true curve is somewhere in each list, so if no pair of candidates is
// isomorphic the two curves are not isomorphic, while a match is inconclusive unless each
// list has a single entry.

// Loading functions for working with AL subgroups, and the equations of genus 2
// bielliptic quotients of Shimura curves.
ChangeDirectory("AuxiliaryFiles");
load "AL_identifiers.m";
load "genus_2_bielliptics_eqn_determined_final.m";
load "genus_2_bielliptics_eqn_not_determined_final.m";
load "models_db.m";
ChangeDirectory("..");

// Loading the pairs surviving Fp_isomorphism_check.m, and the purely modular pairs surviving
// reduction_type_different_products.m
load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v3.m";
load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_modular_different_levels_v1.m";

isomorphic_pairs     := [* *];
not_isomorphic       := [* *];
unsure_if_isomorphic := [* *];

candidates := [* *];
for pair in remaining_isomorphism_lists_different_products_v3 cat remaining_isomorphism_lists_modular_different_levels_v1 do
    if pair[5] ge 2 then Append(~candidates,pair); end if;
end for;

for pair in candidates do
    print "Pair: ", pair;

    // X_0(93)/<w_93> and X_0(186)/<w_3,w_62> are isomorphic over Q (rough_work.tex, by
    // lifting isomorphisms mod p), but the direct check needs too much memory
    if pair[1] eq 1 and pair[2] eq 93 and pair[3] eq 1 and pair[4] eq 186 and pair[5] eq 4 then
        Append(~isomorphic_pairs,pair);
        print "  ISOMORPHIC over Q (rough_work.tex), skipped";
        continue;
    end if;

    A := ModelsFor(pair[1],pair[2],pair[6]);
    B := ModelsFor(pair[3],pair[4],pair[7]);

    if IsEmpty(A) or IsEmpty(B) then
        Append(~unsure_if_isomorphic,pair);
        print "  no models, no comparison made";
        continue;
    end if;

    // for each combination of candidate models: "yes", "no", or "unknown" if Magma cannot decide
    results := [];
    for X in A, Y in B do
        try
            Append(~results, IsIsomorphic(X,Y) select "yes" else "no");
        catch e
            Append(~results, "unknown");
        end try;
    end for;

    if forall{r : r in results | r eq "no"} then
        Append(~not_isomorphic,pair);
        print "  NOT isomorphic over Q";
    elif #A eq 1 and #B eq 1 and results[1] eq "yes" then
        Append(~isomorphic_pairs,pair);
        print "  ISOMORPHIC over Q";
    else
        Append(~unsure_if_isomorphic,pair);
        print "  unsure";
    end if;
end for;

print "";
print "genus >= 2 pairs considered: ", #candidates;
print "  isomorphic over Q: ", #isomorphic_pairs;
print "  NOT isomorphic   : ", #not_isomorphic;
print "  unsure           : ", #unsure_if_isomorphic;

// appended to excluded.m
SetOutputFile("Isomorphisms/DifferentProductLevel/excluded.m");
print "excluded cat:= ", not_isomorphic, ";";
UnsetOutputFile();

// Overwrite := true, since SetOutputFile appends to an existing file by default
SetOutputFile("Isomorphisms/DifferentProductLevel/isomorphic_pairs_genus_geq_2.m" : Overwrite := true);
print "isomorphic_pairs_genus_geq_2 := ", isomorphic_pairs, ";";
UnsetOutputFile();

SetOutputFile("Isomorphisms/DifferentProductLevel/unsure_if_isomorphic_genus_geq_2.m" : Overwrite := true);
print "unsure_if_isomorphic_genus_geq_2 := ", unsure_if_isomorphic, ";";
UnsetOutputFile();

// the purely modular isomorphisms of genus >= 2, also on their own
modular_isomorphisms := [* *];
for pair in isomorphic_pairs do
    if pair[1] eq 1 and pair[3] eq 1 then Append(~modular_isomorphisms,pair); end if;
end for;
SetOutputFile("Isomorphisms/DifferentProductLevel/modular_isomorphisms_g_geq_2_complete.m" : Overwrite := true);
print "modular_isomorphisms_g_geq_2_complete := ", modular_isomorphisms, ";";
UnsetOutputFile();

