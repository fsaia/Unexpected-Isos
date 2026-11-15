// Run from the top folder Unexpected-Isos (copy this file there), after local_points_check.m:
//   nohup magma -s Fp_isomorphism_check.m > Fp_isomorphism_check.log &
//
// For the genus >= 2 pairs surviving local_points_check.m, we test whether the reductions
// of the two curves modulo p are isomorphic for the good odd primes p <= 41; if they are not
// isomorphic for some p, the curves are not isomorphic over Q. Equations come from
// models_db.m, together with X0NQuotient on the modular side.
//
// A quotient whose equation is only known up to a list of candidates is excluded only if
// every combination of candidate models is separated modulo some p.

// Loading functions for working with AL subgroups, and the equations of genus 2
// bielliptic quotients of Shimura curves.
ChangeDirectory("AuxiliaryFiles");
load "AL_identifiers.m";
load "genus_2_bielliptics_eqn_determined_final.m";
load "genus_2_bielliptics_eqn_not_determined_final.m";
load "models_db.m";
ChangeDirectory("..");

// Loading the pairs surviving local_points_check.m
load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v2.m";

// Primes dividing a denominator of some defining-equation coefficient.
BadDenominatorPrimes := function(eqs)
    bad := {};
    for f in eqs do
        for c in Coefficients(f) do
            d := Denominator(c);
            if d ne 1 then
                bad join:= { pp[1] : pp in Factorization(Integers()!d) };
            end if;
        end for;
    end for;
    return bad;
end function;

// True iff some good odd prime p <= 41 certifies that C1, C2 are NOT
// isomorphic over Q (their reductions mod p are non-singular but the
// reduced curves are not isomorphic over F_p).
NotIsomorphicByReduction := function(C1, C2, N1, N2 :
        primes := [3,5,7,11,13,17,19,23,29,31,37,41])
    eqs1 := DefiningPolynomials(C1);
    eqs2 := DefiningPolynomials(C2);
    bad  := BadDenominatorPrimes(eqs1) join BadDenominatorPrimes(eqs2);

    for p in primes do
        if (N1 mod p eq 0) or (N2 mod p eq 0) then continue; end if;   // bad reduction
        if p in bad then continue; end if;

        try
            C1p := Curve(ChangeRing(C1, GF(p)));
            C2p := Curve(ChangeRing(C2, GF(p)));
        catch e
            continue;
        end try;

        if not IsNonSingular(C1p) then continue; end if;
        if not IsNonSingular(C2p) then continue; end if;

        if IsIsomorphic(C1p, C2p) eq false then
            return true;       // separated mod p  =>  not isomorphic over Q
        end if;
    end for;

    return false;
end function;


////// F_p-isomorphism checks

    remaining_after_Fp := [* *];
    excluded_by_Fp := [* *];

    candidates := [pair : pair in remaining_isomorphism_lists_different_products_v2 | pair[5] ge 2];
    steps := #candidates;
    step := 0;

    for pair in candidates do
        step := step + 1;
        print "Step out of ", steps, ": ", step;
        print "Pair: ", pair;

        A := ModelsFor(pair[1],pair[2],pair[6]);
        B := ModelsFor(pair[3],pair[4],pair[7]);

        if not IsEmpty(A) and not IsEmpty(B) and
           forall{X : X in A | forall{Y : Y in B | NotIsomorphicByReduction(X,Y,pair[1]*pair[2],pair[3]*pair[4])}} then
            print "proven non-isomorphic by reduction modulo some p";
            Append(~excluded_by_Fp,pair);
        else
            Append(~remaining_after_Fp,pair);
        end if;
    end for;

    print "candidate pairs considered: ", steps;
    print "pairs excluded by F_p-isomorphism checks: ", #excluded_by_Fp;
    print "pairs remaining: ", #remaining_after_Fp;

    // appended to the file started by reduction_type_different_products.m
    SetOutputFile("Isomorphisms/DifferentProductLevel/excluded.m");
    print "excluded cat:= ", excluded_by_Fp, ";";
    UnsetOutputFile();

    // Overwrite := true, since SetOutputFile appends to an existing file by default
    SetOutputFile("Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v3.m" : Overwrite := true);
    print "remaining_isomorphism_lists_different_products_v3 := ", remaining_after_Fp, ";";
    UnsetOutputFile();

