// Finding all isogenous quotients X_0(N1)/W1 and X_0(N2)/W2
// where N1 and N2 are distinct squarefree levels.
// Assuming genus of the quotient is at least 1.

// 1) Build relevant levels: all divisors of PPV levels
// 2) Consider all pairs (N1, N2) of distinct relevant levels
// 3) Apply the good-prime corollary sieve
// 4) Compute genus incidences
// 5) Apply the new-part proposition sieve
// 6) Prove isogeny using IsogClassALQuotient and
//    SameIsogenyDecomposition.

SetMemoryLimit(25 * 1024^3);

OutputFile := "isogenous_modular_quotients_different_levels.m";

load "AL_identifiers.m";
load "quot_genus.m";
load "ribet_isog.m";
load "PPV_tables_6_7.m";
load "isog_utils.m";

// true iff primes lost/gained between N1 and N2 are allowed on both sides
AdmissibleLevelPair := function(N1, N2)
    P1 := PrimeSet(N1); P2 := PrimeSet(N2);
    return ((P1 diff P2) subset AllowedPrimesForN(N1)) and
           ((P2 diff P1) subset AllowedPrimesForN(N2));
end function;

//for each g > 0, store all A-L quotients of X_0(N) of genus g
GenusBucketsForN := function(N)
    buckets := AssociativeArray();
    if N eq 1 then return buckets; end if;

    Subs := { s : s in AL_subgroups(N) };
    Include(~Subs, {1});
    Include(~Subs, PrimeSet(N));

    for subgroup in Subs do
        As := (subgroup eq {1}) select [] else SortedSeq(subgroup);
        g := GenusX0NQuotient(N, As);
        if g eq 0 then continue; end if;

        if IsDefined(buckets, g) then
            Append(~buckets[g], As);
        else
            buckets[g] := [ As ];
        end if;
    end for;

    return buckets;
end function;

// new-part proposition sieve
ALDecompCache := AssociativeArray();

// build relevant levels
RelevantSet := {};
for N in PPV_Ns do
    for d in Divisors(N) do
        Include(~RelevantSet, Integers()!d);
    end for;
end for;

RelevantLevels := SortedSeq(RelevantSet);

printf "PPV levels: %o\n", #PPV_Ns;
printf "Relevant levels: %o\n", #RelevantLevels;

// Precompute genus buckets
BucketsCache := AssociativeArray();
for N in RelevantLevels do
    BucketsCache[N] := GenusBucketsForN(N);
end for;

// Genus incidences + good-prime and proposition sieves

genus_prop_candidates := [* *];
pairs_seen := 0;

for i in [1..#RelevantLevels-1] do
    N1 := RelevantLevels[i];
    B1 := BucketsCache[N1];
    K1 := { k : k in Keys(B1) };

    if #K1 eq 0 then continue; end if;

    for j in [i+1..#RelevantLevels] do
        N2 := RelevantLevels[j];

        if not AdmissibleLevelPair(N1, N2) then continue; end if;

        B2 := BucketsCache[N2];
        K2 := { k : k in Keys(B2) };

        if #K2 eq 0 then continue; end if;

        for g in SortedSeq(K1 meet K2) do
            for W1 in B1[g] do
                for W2 in B2[g] do
                    pairs_seen +:= 1;
                    keep := true;

                    if not IsDivisibleBy(N2, N1) then
                        HasNoCompatibleNewPart(~keep, ~ALDecompCache, N1, 1, W1);
                    end if;

                    if keep and not IsDivisibleBy(N1, N2) then
                        HasNoCompatibleNewPart(~keep, ~ALDecompCache, N2, 1, W2);
                    end if;

                    if keep then
                        Append(~genus_prop_candidates, [* N1, N2, g, W1, W2 *]);
                    end if;
                end for;
            end for;
        end for;
    end for;
end for;

printf "Done genus+prop sieve.\n";
printf "Same-genus pair-instances: %o\n", pairs_seen;
printf "Kept after sieves: %o\n", #genus_prop_candidates;

// isogeny check

isogenous_modular_quotients_different_levels := [* *];

for C in genus_prop_candidates do
    N1 := C[1]; N2 := C[2];
    W1 := C[4]; W2 := C[5];

    Dec1 := IsogClassALQuotient(1, N1, NormalizeGens(N1, W1));
    Dec2 := IsogClassALQuotient(1, N2, NormalizeGens(N2, W2));

    if SameIsogenyDecomposition(Dec1, Dec2) then
        Append(~isogenous_modular_quotients_different_levels, C);
    end if;
end for;

SaveStar(OutputFile, "isogenous_modular_quotients_different_levels", isogenous_modular_quotients_different_levels);

printf "Wrote %o\n", OutputFile;
printf "Final isogenous modular quotient pairs: %o\n", #isogenous_modular_quotients_different_levels;
