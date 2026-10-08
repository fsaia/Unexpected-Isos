// All of these can(/should?) merge into ribet_isog.m
// or maybe AL_identifiers.m
load "AL_identifiers.m";
load "ribet_isog.m";
load "PPV_tables_6_7.m";

// convert generators to the canonical subgroup identifier
QuotId := function(DN, gens)
    G := (Type(gens) eq SetEnum) select gens else Seqset(gens);
    return gens_to_identifier(DN, G);
end function;

// key for quotient lookup
QuotKey := function(D, N, gens)
    return <D, N, QuotId(D*N, gens)>;
end function;

PrimeSet := function(n)
    return SequenceToSet(PrimeDivisors(n));
end function;

SortedSeq := function(S)
    T := Setseq(S); Sort(~T); return T;
end function;

// True iff no Atkin-Lehner eigenspace in S_2(L)^new is compatible with
// the sign pattern determined by D and ALgens.
// ALDecompCache is passed by reference so decompositions at each level are
// computed at most once across repeated calls.
procedure HasNoCompatibleNewPart(~ans, ~ALDecompCache, L, D, ALgens)
    if not IsDefined(ALDecompCache, L) then
        Snew := NewSubspace(CuspidalSubspace(ModularSymbols(L, 2)));
        ALDecompCache[L] := AtkinLehnerDecomposition(Snew);
    end if;
    gens := IsEmpty(ALgens) select [1] else ALgens;
    for V in ALDecompCache[L] do
        if IsCompatible(D, signpattern(V), gens) then ans := false; return; end if;
    end for;
    ans := true;
end procedure;


// Primes of N allowed by the good-reduction corollary sieve for X_0(N):
// all primes if X_0(N) has a genus-0-star quotient, else ModularGoodPrimesByN.
AllowedPrimesForN := function(N)
    P := PrimeSet(N);
    if N eq 1 then return {}; end if;
    if GenusX0NQuotient(N, SortedSeq(P)) eq 0 then return P;
    elif IsDefined(ModularGoodPrimesByN, N) then return ModularGoodPrimesByN[N];
    else return {}; end if;
end function;


// CompatibleSymbolsAndDim: in the new subspace at level D*N, returns the
// Atkin-Lehner eigenspaces whose sign patterns are compatible with gens,
// stopping once their total dimension reaches dim.
// this should be a bit faster than the function above (in ribet_isog)
// (for the purpose of proving isogeny)

CompatibleSymbolsAndDim := function(D,N,gens,dim)
    M := ModularSymbols(D*N,2,-1);
    Snew := NewSubspace(CuspidalSubspace(M));
    ALdecomp := AtkinLehnerDecomposition(Snew);

    good := [];
    total_dim := 0;

    for V in ALdecomp do
        d := Dimension(V);
        if d le (dim-total_dim) then
            if IsCompatible(D, signpattern(V), gens) then
                Append(~good, V);
                total_dim +:= d;
                if total_dim eq dim then
                    break;
                end if;
            end if;
        end if;
    end for;

    return good, total_dim;
end function;



CompatibleNewSubspaces := function(D,N,gens)
    M := ModularSymbols(D*N,2, -1);
    Snew := NewSubspace(CuspidalSubspace(M));
    ALdecomp := AtkinLehnerDecomposition(Snew);

    good := [];
    total_dim := 0;

    for V in ALdecomp do
        if IsCompatible(D, signpattern(V), gens) then
            Append(~good, V);
            total_dim +:= Dimension(V);
        end if;
    end for;

    return good, total_dim;
end function;



// Shared isogeny decomposition utilities.
DimSum := function(D)
    return IsEmpty(D) select 0 else &+[ Dimension(A) : A in D ];
end function;

// True iff Decomp1 and Decomp2 represent the same isogeny class as
// multisets: each factor of Decomp1 is isogenous to a distinct factor of Decomp2.
SameIsogenyDecomposition := function(Decomp1, Decomp2)
    if DimSum(Decomp1) ne DimSum(Decomp2) then return false; end if;
    D2work := [ B : B in Decomp2 ];
    for A in Decomp1 do
        found := false;
        for k in [1..#D2work] do
            if IsIsogenous(A, D2work[k]) then
                found := true; Remove(~D2work, k); break;
            end if;
        end for;
        if not found then return false; end if;
    end for;
    return #D2work eq 0;
end function;


// Write a single variable assignment to a file (overwriting any existing copy).
procedure SaveStar(filename, varname, data)
    SetOutputFile(filename : Overwrite := true);
    print varname, " := ", data, ";";
    UnsetOutputFile();
end procedure;
