// this code does two things:
// genus 1 lookup & provers by two lemmas
// to avoid too much unnecessary computations
// on high total levels D*N (as these are slow)

SetMemoryLimit(50 * 1024^3);

load "PPV_tables_6_7.m";
load "isogenous_pairs__different_products.m";
load "AL_identifiers.m";
load "ribet_isog.m";
load "isog_utils.m";
load "genus_1_jacobian_isog_classes.m";


// Cremona isogeny class, e.g. 37a1 -> 37a
CremonaIsogenyClass := function(label)
    i := #label;
    while (i ge 1) and (label[i] ge "0") and (label[i] le "9") do
        i -:= 1;
    end while;
    return label[1..i];
end function;

// possible signs at a new prime p compatible with gens2
ExtensionSigns := function(pat, p, D2, gens2)
    exts := [];
    for s in [-1, 1] do
        if IsCompatible(D2, pat cat [<p, 1, s>], gens2) then
            Append(~exts, s);
        end if;
    end for;
    return exts;
end function;

// Lemma: X_0^D1(N1)/W ~ X_0^D2(N2)/Wp  where D2 = D1*N1 and N2 = p prime.
IsogenyLemma__D_N__to__DN_p := function(cand)
    D1 := cand[1]; N1 := cand[2]; D2 := cand[3]; N2 := cand[4]; g := cand[5];
    W  := QuotId(D1*N1, cand[6]);
    Wp := QuotId(D2*N2, cand[7]);

    L1 := D1*N1; L2 := D2*N2;
    if not IsDivisibleBy(L2, L1) then return false; end if;

    p := Integers()!(L2 div L1);
    if not IsPrime(p) or (p in PrimeDivisors(L1)) then return false; end if;
    if D2 ne L1 or N2 ne p then return false; end if;

    good, dim_found := CompatibleSymbolsAndDim(D1, N1, W, g);
    if dim_found ne g then return false; end if;

    for V in good do
        if #ExtensionSigns(signpattern(V), p, D2, Wp) ne 1 then
            return false;
        end if;
    end for;

    return true;
end function;

// false return value in both of this functions means merely this test hasn't proven that the curves are isogenous
// Lemma: X_0^D(N)/W ~ X_0^D(Np)/Wp  where D1 = D2 and N2/N1 = p prime.
IsogenyLemma__D_N__to__D_Np := function(cand)
    D1 := cand[1]; N1 := cand[2]; D2 := cand[3]; N2 := cand[4]; g := cand[5];
    W  := QuotId(D1*N1, cand[6]);
    Wp := QuotId(D2*N2, cand[7]);

    if D1 ne D2 then return false; end if;
    if not IsDivisibleBy(N2, N1) then return false; end if;

    p := Integers()!(N2 div N1);
    if not IsPrime(p) or (p in PrimeDivisors(D1*N1)) then return false; end if;

    good, dim_found := CompatibleSymbolsAndDim(D1, N1, W, g);
    if dim_found ne g then return false; end if;

    for V in good do
        if #ExtensionSigns(signpattern(V), p, D2, Wp) ne 1 then
            return false;
        end if;
    end for;

    return true;
end function;

// Try both lemmas in both orientations.
TryLemmas := function(L)
    if IsogenyLemma__D_N__to__D_Np(L) then return true; end if;
    if IsogenyLemma__D_N__to__DN_p(L) then return true; end if;

    Lswap := [* L[3], L[4], L[1], L[2], L[5], L[7], L[6] *];

    if IsogenyLemma__D_N__to__D_Np(Lswap) then return true; end if;
    if IsogenyLemma__D_N__to__DN_p(Lswap) then return true; end if;

    return false;
end function;

// Build genus-1 Cremona lookup
genus1_lookup := AssociativeArray();

for T in genus_1_jacobian_isog_classes do
    genus1_lookup[QuotKey(T[1], T[2], T[3])] := CremonaIsogenyClass(T[4]);
end for;



// Main part (Cremona lookup + lemmas)
isog_candidates := remaining_after_pt_cts_general;
print "Total:", #isog_candidates;

isogenous_pairs  := [];
non_isogenous    := [];
pairs_for_direct_check := [];

for L in isog_candidates do
    D1 := L[1]; N1 := L[2]; D2 := L[3]; N2 := L[4]; g := L[5];
    Wgens := L[6]; Hgens := L[7];

    classified := false;

    // Genus-1 Cremona lookup
    if g eq 1 then
        k1 := QuotKey(D1, N1, Wgens);
        k2 := QuotKey(D2, N2, Hgens);

        if IsDefined(genus1_lookup, k1) and IsDefined(genus1_lookup, k2) then
            if genus1_lookup[k1] eq genus1_lookup[k2] then
                Append(~isogenous_pairs, L);
            else
                Append(~non_isogenous, L);
            end if;
            classified := true;
        end if;
    end if;

    // Lemmas
    if not classified then
        if TryLemmas(L) then
            Append(~isogenous_pairs, L);
            classified := true;
        end if;
    end if;

    // Unresolved
    if not classified then
        Append(~pairs_for_direct_check, L);
    end if;
end for;

print "After Cremona + lemmas: iso =", #isogenous_pairs;


// We now also do the transitive closure. The goal is to reduce
// the number of candidates for the final direct check (as this is slowest).

// Build a map  quotient-key -> component id  from proved isogenous pairs.
// Two quotients share a component id if a chain of proved isogenies links them.
ComponentIDs := function(isog_pairs)
   // adjacency list: key -> [neighbour keys]
    neighbours := AssociativeArray();
    
    for L in isog_pairs do
        k1 := QuotKey(L[1], L[2], L[6]);
        k2 := QuotKey(L[3], L[4], L[7]);
        if not IsDefined(neighbours, k1) then neighbours[k1] := []; end if;
        if not IsDefined(neighbours, k2) then neighbours[k2] := []; end if;
        Append(~neighbours[k1], k2);
        Append(~neighbours[k2], k1);
    end for;

    componentId := AssociativeArray();
    connected_component_index := 0;
    for quot in Keys(neighbours) do
        if IsDefined(componentId, quot) then continue; end if;
        connected_component_index +:= 1;
        componentId[quot] := connected_component_index;
        queue := [quot];

        while #queue gt 0 do          // BFS over one component
            v := queue[1]; Remove(~queue, 1);
            for w in neighbours[v] do
                if not IsDefined(componentId, w) then
                    componentId[w] := connected_component_index;
                    Append(~queue, w);
                end if;
            end for;
        end while;

    end for;

    return componentId;
end function;

// True iff both quotients in candidate L
// are already known to lie in the same component.
SameComponent := function(componentID, L)
    k1 := QuotKey(L[1], L[2], L[6]);
    k2 := QuotKey(L[3], L[4], L[7]);
    return IsDefined(componentID, k1) and IsDefined(componentID, k2)
           and (componentID[k1] eq componentID[k2]);
end function;

component_ids := ComponentIDs(isogenous_pairs);

remaining := [];
for L in pairs_for_direct_check do
    if SameComponent(component_ids, L) then
        Append(~isogenous_pairs, L);   // already linked by proved isogenies
    else
        Append(~remaining, L);
    end if;
end for;
pairs_for_direct_check := remaining;

print "After transitivity: iso =", #isogenous_pairs,
      "| direct-check =", #pairs_for_direct_check,
      "| non-iso =", #non_isogenous;


SaveStar("isogenous_pairs_first_part.m", "isogenous_pairs_first_part", isogenous_pairs);
SaveStar("non_isogenous_first_part.m",   "non_isogenous_first_part",   non_isogenous);
SaveStar("pairs_for_direct_check.m",     "pairs_for_direct_check",     pairs_for_direct_check);