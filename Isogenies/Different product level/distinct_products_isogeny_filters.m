SetMemoryLimit(50 * 1024^3);

load "AL_identifiers.m";
load "ribet_isog.m";
load "genus_0_stars.m";
load "counting_points.m";   // loads tracesALL / dataByLevel
load "PPV_tables_6_7.m";
load "isog_utils.m";

ShimuraGenus0StarPairs := { <t[1], t[2]> : t in genus_0_stars | IsSquarefree(t[1]*t[2]) };

// helpers for genus + corollary sieve

// product of the elements of a finite set of integers
SetProd := function(S)
    return IsEmpty(S) select 1 else &*Setseq(S);
end function;

// Extends AllowedPrimesForN to Shimura curves:
// all primes if (D,N) is a genus-0-star pair, else ShimuraGoodPrimesByPair.
AllowedPrimesForPair := function(D, N)
    if D eq 1 then return AllowedPrimesForN(N); end if;
    P := PrimeSet(D*N);
    if <D,N> in ShimuraGenus0StarPairs then return P;
    elif IsDefined(ShimuraGoodPrimesByPair, <D,N>) then return ShimuraGoodPrimesByPair[<D,N>];
    else return {}; end if;
end function;

// all (D, N) factorizations of L with omega(D) even,
Factorizations := function(L)
    P := PrimeSet(L);
    return [ <SetProd(D), SetProd(P diff D)> : D in Subsets(P) | #D mod 2 eq 0 ];
end function;

// genera of all AL-quotients X_0^D(N)/W with g > 0,
// returned as a sequence of <g, ALgens>
QuotientsFor := function(D, N)
    L := D*N; Quotients := [* *];
    Subs := AL_subgroups(L);
    Include(~Subs, {1});
    Include(~Subs, PrimeSet(L));
    for S in Subs do
        ALGens := (S eq {1}) select [] else SortedSeq(S);
        if D eq 1 then g := GenusX0NQuotient(N, ALGens);
        else g := quot_genus(D, N, gens_to_identifier(L, S)); end if;
        if g ne 0 then Append(~Quotients, <g, ALGens>); end if;
    end for;
    return Quotients;
end function;

// ordering: Shimura side first; among two Shimura sides, smaller total level first
NormalizeCandidate := function(D1, N1, D2, N2, g, W1, W2)
    L1 := D1*N1; L2 := D2*N2;
    if (D1 eq 1) and (D2 gt 1) then return [* D2, N2, D1, N1, g, W2, W1 *];
    elif (D1 gt 1) and (D2 eq 1) then return [* D1, N1, D2, N2, g, W1, W2 *];
    elif (D1 gt 1) and (D2 gt 1) and (L2 lt L1) then return [* D2, N2, D1, N1, g, W2, W1 *];
    else return [* D1, N1, D2, N2, g, W1, W2 *]; end if;
end function;

// true iff primes in P1 \ P2 are allowed for (D1,N1) and primes in P2 \ P1 are allowed for (D2,N2)
AdmissibleOrderedFactorizationPair := function(D1, N1, D2, N2, P1, P2, A1, A2)
    return ((P1 diff P2) subset A1) and ((P2 diff P1) subset A2);
end function;

// QuotientsCache stores the positive-genus quotients for each pair <D,N>;
// ALDecompCache stores Atkin-Lehner decompositions of S_2(DN)^new.
ALDecompCache  := AssociativeArray();
QuotientsCache := AssociativeArray();

// quotients of X_0^D(N) with g > 0, indexed by genus, optionally filtered
// by requiring no compatible new part; quotient list itself is cached under the key <D, N>
procedure GetFilteredByGenus(~QG, ~QuotientsCache, ~ALDecompCache, D, N, NeedNoNewPart)
    if not IsDefined(QuotientsCache, <D, N>) then
        QuotientsCache[<D, N>] := QuotientsFor(D, N);
    end if;

    A := AssociativeArray();
    for X in QuotientsCache[<D, N>] do
        ok := true;
        if NeedNoNewPart then HasNoCompatibleNewPart(~ok, ~ALDecompCache, D*N, D, X[2]); end if;
        if ok then
            g := X[1];
            if not IsDefined(A, g) then A[g] := [* *]; end if;
            Append(~A[g], X[2]);
        end if;
    end for;
    QG := A;
end procedure;

// build candidate list
ShimuraSpecialLevels := { t[1]*t[2] : t in ShimuraGoodPrimeData } join
                        { t[1]*t[2] : t in genus_0_stars | IsSquarefree(t[1]*t[2]) };
AllSpecialLevels := PPV_Ns join ShimuraSpecialLevels;

Univ := {};
for L in AllSpecialLevels do
    for S in Subsets(PrimeSet(L)) do Include(~Univ, SetProd(S)); end for;
end for;
UnivSeq := SortedSeq(Univ);

Seen := AssociativeArray();
all_candidates := [* *];

// Main search:
// 1. loop over admissible total levels L1, L2;
// 2. loop over factorizations Li = Di*Ni with omega(Di) even;
// 3. enumerate positive genus Atkin-Lehner quotients on each side;
// 4. require no compatible new part when one level does not divide the other;
// 5. record pairs of surviving quotients with equal genus.
for i in [1..#UnivSeq-1] do
    L1 := UnivSeq[i]; P1 := PrimeSet(L1);

    for j in [i+1..#UnivSeq] do
        L2 := UnivSeq[j]; P2 := PrimeSet(L2);

        NeedNoNewPart1 := not IsDivisibleBy(L2, L1); // true when L1 doesn't divide L2
        NeedNoNewPart2 := not IsDivisibleBy(L1, L2); // vice versa

        for f1 in Factorizations(L1) do
            D1 := f1[1]; N1 := f1[2]; A1 := AllowedPrimesForPair(D1, N1);

            GetFilteredByGenus(~Q1, ~QuotientsCache, ~ALDecompCache, D1, N1, NeedNoNewPart1);

            for f2 in Factorizations(L2) do
                D2 := f2[1]; N2 := f2[2]; A2 := AllowedPrimesForPair(D2, N2);

                if (D1 eq 1) and (D2 eq 1) then continue; end if;
                if not AdmissibleOrderedFactorizationPair(D1, N1, D2, N2, P1, P2, A1, A2) then continue; end if;

                GetFilteredByGenus(~Q2, ~QuotientsCache, ~ALDecompCache, D2, N2, NeedNoNewPart2);

                for g in Keys(Q1) do
                    if not IsDefined(Q2, g) then continue; end if;

                    for W1 in Q1[g] do
                        for W2 in Q2[g] do
                            C := NormalizeCandidate(D1, N1, D2, N2, g, W1, W2);
                            k := Sprint(C);
                            if not IsDefined(Seen, k) then
                                Seen[k] := true;
                                Append(~all_candidates, C);
                            end if;
                        end for;
                    end for;
                end for;
            end for;
        end for;
    end for;
end for;

print "After genus + corollary sieve:", #all_candidates, "candidates";

// finite field point count filter
primes_to_check := PrimesUpTo(100);
rmax := 5;
eps  := 3;

// strip trivial generator, deduplicate, and sort
NormalizeGensFlat := function(gens)
    if IsEmpty(gens) then return []; end if;
    S := [ Integers()!m : m in gens | m ne 1 ];
    S := Setseq(Seqset(S)); Sort(~S);
    return S;
end function;

// for each generator m in gens, return the set of indices (into PrimeDivisors(D*N))
// of the primes dividing m; this is the format expected by shipoints
ALPrimeIndexSets := function(D, N, gens)
    P := PrimeDivisors(D*N); out := [];
    for m in NormalizeGensFlat(gens) do
        Append(~out, { Index(P, p) : p in PrimeDivisors(m) });
    end for;
    return out;
end function;

// point counts on X_0^D(N)/W over F_{q^r} for r = 1..rmax
procedure GetCounts(q, D, N, gens, rmax, eps, ~g, ~counts)
    ALidx := ALPrimeIndexSets(D, N, gens);
    g, counts := shipoints(
        q, D, N,
        traces_to_forms(dataByLevel, q, D, N) :
        ALprimes := ALidx, m := rmax, eps := eps
    );
end procedure;

remaining_after_pt_cts_general := [];
ctr := 0;

for L in all_candidates do
    ctr +:= 1;
    D1 := L[1]; N1 := L[2]; D2 := L[3]; N2 := L[4]; gexp := L[5];
    Wgens := L[6]; Hgens := L[7];

    bad := false;
    good_primes := [p : p in primes_to_check | GCD(p, D1*N1*D2*N2) eq 1];

    for q in good_primes do
        g1 := 0; C1 := []; g2 := 0; C2 := [];
        GetCounts(q, D1, N1, Wgens, rmax, eps, ~g1, ~C1);
        GetCounts(q, D2, N2, Hgens, rmax, eps, ~g2, ~C2);
        if g1 ne g2 or g1 ne gexp then
            bad := true; print "wrong genus!!"; break;
        end if;
        if C1 ne C2 then
            bad := true; break;
        end if;
    end for;

    if not bad then Append(~remaining_after_pt_cts_general, L); end if;

    if ctr mod 10000 eq 0 then
        print "Processed", ctr, "/", #all_candidates,
              "| remaining:", #remaining_after_pt_cts_general;
    end if;
end for;

print "After point count filter:", #remaining_after_pt_cts_general, "candidates";


SaveStar("isogenous_pairs__different_products.m", "remaining_after_pt_cts_general", remaining_after_pt_cts_general);

