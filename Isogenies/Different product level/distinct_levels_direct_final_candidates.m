SetMemoryLimit(50 * 1024^3);

// computing all isogenous pairs
// X_0^{D_1}(N_1)/W ~ X_0^{D_2}(N_2)/H
// (where W, H are A-L subgroups)
// (and D_1 > 1)

load "pairs_for_direct_check.m";
iso_candidates_general := pairs_for_direct_check;

load "AL_identifiers.m";
load "ribet_isog.m";
load "isog_utils.m";

isogenous_pairs := [];
excluded_by_isogeny_general := [];

ctr := 0;
total := #iso_candidates_general;

for L in iso_candidates_general do
    ctr +:= 1;

    D1 := L[1];
    N1 := L[2];
    D2 := L[3];
    N2 := L[4];
    Wgens := NormalizeGens(D1*N1, L[6]);
    Hgens := NormalizeGens(D2*N2, L[7]);

	print L;

	print "Decomp 1..";
    Decomp1 := IsogClassALQuotient(D1, N1, Wgens);
	print "Decomp 2..";
    Decomp2 := IsogClassALQuotient(D2, N2, Hgens);
	print "Decomps done.";

    keep_L := SameIsogenyDecomposition(Decomp1, Decomp2);

    if keep_L then
        Append(~isogenous_pairs, L);
    else
        Append(~excluded_by_isogeny_general, L);
    end if;

	print "isogenous : ", keep_L;
	if ctr mod 50 eq 0 then print "done ", ctr, " out of ", total, " candidates", "\n -----------------"; end if;
end for;

SaveStar("direct_excluded_by_isogeny_general.m", "excluded_by_isogeny_general", excluded_by_isogeny_general);
SaveStar("direct_isogenous_pairs_general.m", "isogenous_pairs_general", isogenous_pairs);