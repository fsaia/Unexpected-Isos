////////////////////////////////////////////////////////////////////////////////
// genus1_label_comparison.m
//
// Decides Q-isomorphism for the genus 1 pairs, using the Jacobian isomorphism
// classes already tabulated in GenusAtMost2.
//
// A genus 1 curve X is a torsor under E = Jac(X). Over Qbar it always has a point,
// so X = E there and the j-invariant decides Qbar-isomorphism -- that is what the
// geometric stage did. Over Q, X = E precisely when X HAS a rational point.
// Consequently, if both sides carry a rational point then
//
//     X_1 = X_2 over Q   <==>   Jac(X_1) = Jac(X_2) over Q,
//
// and the latter is exactly equality of Cremona labels. This is a decision
// procedure, not a heuristic, and it subsumes the j-invariant test: equal labels
// give isomorphism, different labels give non-isomorphism over Q.
//
// The three cases:
//   side 1 has no rational point -- the modular side always has one (the image of
//        the cusp) and a Shimura side is handled through the proven lists, so the
//        pair is not Q-isomorphic;
//   both sides have a rational point -- compare the Jacobians over Q;
//   side 1's status unknown -- the torsor cannot be trivialised, so inconclusive.
//
// The Shimura side's Jacobian is read off its Cremona label. A modular side is
// genus 1 with a rational point, so its Jacobian is obtained from the model.
////////////////////////////////////////////////////////////////////////////////

// Run from the top folder Unexpected-Isos (copy this file there), after reduction_type_different_products.m:
//   nohup magma -s genus1_label_comparison.m > genus1_label_comparison.log &

ChangeDirectory("AuxiliaryFiles");
load "AL_identifiers.m";
load "genus_1_AL_quotient_jacobian_isomorphism_classes.m";
load "genus_1_X0DN_isom_classes.m";
load "genus_1_AL_quotients_rat_pts.m";
load "genus_1_AL_quotients_no_rat_pts.m";
ChangeDirectory("..");

load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_different_products_v1.m";
load "Isomorphisms/DifferentProductLevel/remaining_isomorphism_lists_modular_different_levels_v1.m";

QuotId := func< DN, gens | gens_to_identifier(DN, (Type(gens) eq SetEnum) select gens else Seqset(gens)) >;
BuildModularCurve := func< N, Wgens | X0NQuotient(N, Sort([w : w in Wgens | w ne 1])) >;

candidates := [L : L in remaining_isomorphism_lists_different_products_v1 | L[5] eq 1];
printf "genus 1 pairs: %o\n\n", #candidates;


// Cremona label of Jac(X_0^D(N)/W) for a Shimura quotient. The main table holds the
// nontrivial quotients; W trivial falls back on the list for X_0^D(N) itself.
ShimLabel := function(D, N, Wgens)
    id := QuotId(D*N, Wgens);
    for trip in genus_1_AL_quotient_jacobian_isomorphism_classes do
        if trip[1] eq D and trip[2] eq N and QuotId(D*N, trip[3]) eq id then
            return true, trip[4];
        end if;
    end for;

    if id eq [1] then
        for trip in genus_1_X0DN_isom_classes do
            if trip[1] eq D and trip[2] eq N then
                return true, trip[3];
            end if;
        end for;
    end if;

    return false, "";
end function;


// rational point status of a Shimura quotient: "yes" / "no" / "unsure".
// Note the "has rational points" list is named with a _final suffix, unlike the
// other two.
ShimRatPts := function(D, N, Wgens)
    id := QuotId(D*N, Wgens);

    // Shimura: X_0^D(N) has no real points, hence no rational points, for D > 1.
    // The lists below only cover nontrivial W, so this case must be handled here.
    if id eq [1] then
        return "no";
    end if;

    for trip in genus_1_AL_quotients_rat_pts_final do
        if trip[1] eq D and trip[2] eq N and QuotId(D*N, trip[3]) eq id then
            return "yes";
        end if;
    end for;
    for trip in genus_1_AL_quotients_no_rat_pts do
        if trip[1] eq D and trip[2] eq N and QuotId(D*N, trip[3]) eq id then
            return "no";
        end if;
    end for;
    return "unsure";
end function;


// Jacobian of a modular genus 1 quotient, as an elliptic curve over Q. The image of
// the cusp is rational, so a point exists and the torsor is trivial; we locate one
// by search on a simplified model.
ModularJacobian := function(N, Wgens)
    ok := true; Y := 0;
    try
        Y := BuildModularCurve(N, Wgens);
    catch e
        ok := false;
    end try;
    if not ok then
        return false, 0;
    end if;

    if Type(Y) eq CrvEll then
        return true, MinimalModel(Y);
    end if;

    if Type(Y) eq CrvHyp then
        try
            Y := SimplifiedModel(Y);
        catch e
            ;
        end try;
    end if;

    E := 0; built := true;
    try
        pts := Points(Y : Bound := 1000);
        if IsEmpty(pts) then
            built := false;
        else
            E := MinimalModel(EllipticCurve(Y, Representative(pts)));
        end if;
    catch e
        built := false;
    end try;

    return built, E;
end function;


label_cache := AssociativeArray();
modjac_cache := AssociativeArray();

q_isomorphic     := [];
not_q_isomorphic := [];
inconclusive     := [];

ctr := 0;
for L in candidates do
    ctr +:= 1;
    D1 := L[1]; N1 := L[2]; D2 := L[3]; N2 := L[4];
    W1 := L[6]; W2 := L[7];

    printf "[%o/%o] X_0^%o(%o)/%o  vs  X_0^%o(%o)/%o : ", ctr, #candidates, D1, N1, W1, D2, N2, W2;

    // ---- side 1 is always Shimura
    rp1 := ShimRatPts(D1, N1, W1);
    ok1, lab1 := ShimLabel(D1, N1, W1);

    if not ok1 then
        Append(~inconclusive, L);
        print "no Cremona label for side 1";
        continue;
    end if;

    // ---- side 2
    if D2 gt 1 then
        rp2 := ShimRatPts(D2, N2, W2);
        ok2, lab2 := ShimLabel(D2, N2, W2);
        if not ok2 then
            Append(~inconclusive, L);
            print "no Cremona label for side 2";
            continue;
        end if;
    else
        rp2 := "yes";        // image of the cusp
        lab2 := "";
    end if;

    // ---- a side with no rational point cannot match one that has a point
    if (rp1 eq "no") and (rp2 eq "yes") then
        Append(~not_q_isomorphic, L);
        print "NOT isomorphic over Q (side 1 has no rational point, side 2 does)";
        continue;
    elif (rp2 eq "no") and (rp1 eq "yes") then
        Append(~not_q_isomorphic, L);
        print "NOT isomorphic over Q (side 2 has no rational point, side 1 does)";
        continue;
    end if;

    // ---- both torsors must be trivial for the Jacobian comparison to decide
    if (rp1 ne "yes") or (rp2 ne "yes") then
        Append(~inconclusive, L);
        printf "rational points undetermined (side 1 %o, side 2 %o)\n", rp1, rp2;
        continue;
    end if;

    if D2 gt 1 then
        // both Jacobians are named by Cremona labels, which classify over Q
        if lab1 eq lab2 then
            Append(~q_isomorphic, L);
            printf "ISOMORPHIC over Q (both %o)\n", lab1;
        else
            Append(~not_q_isomorphic, L);
            printf "NOT isomorphic over Q (%o vs %o)\n", lab1, lab2;
        end if;

    else
        k := <N2, QuotId(N2, W2)>;
        if not IsDefined(modjac_cache, k) then
            okj, Ej := ModularJacobian(N2, W2);
            modjac_cache[k] := <okj, Ej>;
        end if;
        okj, E2 := Explode(modjac_cache[k]);

        if not okj then
            Append(~inconclusive, L);
            print "could not build the modular Jacobian";
            continue;
        end if;

        E1 := EllipticCurve(lab1);
        if IsIsomorphic(E1, E2) then
            Append(~q_isomorphic, L);
            printf "ISOMORPHIC over Q (%o)\n", lab1;
        else
            Append(~not_q_isomorphic, L);
            printf "NOT isomorphic over Q (%o vs %o)\n", lab1, Conductor(E2);
        end if;
    end if;
end for;


// purely modular pairs: both curves have a rational point (the image of the cusp), so they
// are isomorphic over Q iff their Jacobians are
modular_isomorphic := [];
for L in [L : L in remaining_isomorphism_lists_modular_different_levels_v1 | L[5] eq 1] do
    printf "X_0(%o)/%o  vs  X_0(%o)/%o : ", L[2], L[6], L[4], L[7];
    okj1, E1 := ModularJacobian(L[2], L[6]);
    okj2, E2 := ModularJacobian(L[4], L[7]);
    if not (okj1 and okj2) then
        Append(~inconclusive, L);
        print "could not build the modular Jacobians";
    elif IsIsomorphic(E1, E2) then
        Append(~modular_isomorphic, L);
        print "ISOMORPHIC over Q";
    else
        Append(~not_q_isomorphic, L);
        print "NOT isomorphic over Q";
    end if;
end for;


print "";
print "genus 1 pairs examined: ", #candidates + #[L : L in remaining_isomorphism_lists_modular_different_levels_v1 | L[5] eq 1];
print "  ISOMORPHIC over Q, purely modular: ", #modular_isomorphic;
print "  ISOMORPHIC over Q, with a Shimura curve: ", #q_isomorphic;
print "  NOT isomorphic over Q: ", #not_q_isomorphic;
print "  inconclusive         : ", #inconclusive;

// Overwrite := true, since SetOutputFile appends to an existing file by default
SetOutputFile("Isomorphisms/DifferentProductLevel/genus_1_output.m" : Overwrite := true);
print "genus_1_isomorphic_modular := ", modular_isomorphic, ";";
print "genus_1_isomorphic_shimura := ", q_isomorphic, ";";
print "genus_1_not_isomorphic := ", not_q_isomorphic, ";";
print "genus_1_unsure := ", inconclusive, ";";
UnsetOutputFile();

