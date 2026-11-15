// Lookup of the equations we have for Atkin--Lehner quotients X_0^D(N)/W, gathered from
//
//   quotients_of_hyperelliptic_models_plus_Molina_eqs.m   quotients of hyperelliptic top
//                                                         curves, and Molina's level 1 list
//   AuxiliaryFiles/genus_2_bielliptics_eqn_determined_final.m       one polynomial per quotient
//   AuxiliaryFiles/genus_2_bielliptics_eqn_not_determined_final.m   a list of candidates
//   ShimDB (optional, see SHIMDB_DIRS)                    one file per quotient, any genus
//
// together with X0NQuotient on the modular side.
//
// Load this file from inside AuxiliaryFiles (SHIMDB_DIRS is relative to the top folder
// Unexpected-Isos, where ModelsFor is called), after AL_identifiers.m and the two
// genus_2_bielliptics_*_final.m files
// (see final_test_q_isomorphism.m).

load "quotients_of_hyperelliptic_models_plus_Molina_eqs.m";

// ShimDB is not part of this repository; each directory is tried in turn and a miss is
// harmless. Put (or symlink) the ShimDB folders here to use them.
SHIMDB_DIRS := [ "Shimura/ShimDB-v1/", "Shimura/ShimDB-v2/" ];


// Models for X_0^D(N)/W, as a sequence of candidate curves. The sequence has one entry
// unless the quotient is one of those for which the equation is only known up to a list,
// and is empty when we have no model at all.
ModelsFor := function(D,N,Wgens)
    W := gens_to_identifier(D*N,Seqset(Wgens));

    if D eq 1 then
        return [X0NQuotient(N,Sort([m : m in W | m ne 1]))];
    end if;

    for L in quotients_of_hyperelliptic_models do
        if L[1] eq D and L[2] eq N and gens_to_identifier(D*N,L[3]) eq W then
            return [L[4]];
        end if;
    end for;

    for L in genus_2_bielliptics_eqn_determined_final do
        if L[1] eq D and L[2] eq N and gens_to_identifier(D*N,L[3]) eq W then
            return [HyperellipticCurve(L[4])];
        end if;
    end for;

    for L in genus_2_bielliptics_eqn_not_determined_final do
        if L[1] eq D and L[2] eq N and gens_to_identifier(D*N,L[3]) eq W then
            return [HyperellipticCurve(f) : f in L[4]];
        end if;
    end for;

    wstr := "[" cat Join([IntegerToString(m) : m in W], ",") cat "]";
    for dir in SHIMDB_DIRS do
        for gg in [0..50] do
            fname := dir cat "Shim-X(" cat IntegerToString(D) cat "," cat IntegerToString(N)
                         cat ")-g" cat IntegerToString(gg) cat "-" cat wstr cat ".m";
            if OpenTest(fname,"r") then
                return [(eval Read(fname))`ShimModel];
            end if;
        end for;
    end for;

    return [];
end function;
