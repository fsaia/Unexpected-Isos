/*
In this file, we determine all quotients X_0(N)/W, with W <= W_0(1,N), 
having genus 0 and 1. We also determine the isomorphism classes of the 
genus 1 quotients. Surely this is known, and it follows relatively easily
from the determination of star quotients of genera 0 and 1 as found in work
of González--Lario, but perhaps it is not cleanly written
down anywhere. We could find many of these examples (e.g., for the star
quotients and for quotients by a single involution) in the literature, but found
no reference that treated all cases. 
*/

// Loading functionality for working with Atkin--Lehner quotients
load "AL_identifiers.m";

// Noting levels N for which X_0(N)^* has genus 0 or 1, as found in work of González--Lario.

genus_0_modular_stars := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71, 6, 
    10, 14, 15, 21, 22, 26, 33, 34, 35, 38, 39, 46, 51, 55, 62, 69, 87, 94, 95, 119, 
    30, 42, 66, 70, 78, 105, 110];
genus_1_modular_stars := [37, 43, 53, 61, 79, 83, 89, 101, 131, 57, 58, 65, 74, 77, 
    82, 86, 91, 111, 114, 118, 123, 142, 143, 145, 155, 159, 102, 114, 130, 138, 174, 
    182, 190, 195, 222, 231, 238, 210];
genus_le1_modular_stars := Sort(genus_0_modular_stars cat genus_1_modular_stars);


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
// We begin by enumerating the genus 0 and genus 1 quotients
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

// Initializing Lists
genus_0_modular_quotients := [];

genus_1_modular_quotients := [];

// Computing tuples [N,Wgens] for which X_0(N)/<Wgens> has genus 0 or 1
for N in genus_le1_modular_stars do 
    AL_subs := AL_subgroups(N);
    for Wgens in AL_subs do 

        // Computing genus of X_0(N)/<Wgens>
        if Wgens eq {1} then 
            g := GenusX0N(N);
        else 
            g := GenusX0NQuotient(N,Setseq(Wgens));
        end if;

        if g eq 0 then 
            Append(~genus_0_modular_quotients,[*N,Wgens*]);
        elif g eq 1 then 
            Append(~genus_1_modular_quotients,[*N,Wgens*]);
        end if;

    end for;
end for; 


//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
// Next, we compute the isomorphism classes of genus 1 
// quotients. This is done a bit piecemeal given that most,
// but not all, examples are easily handled in Magma, so
// we give the relevant code and explanations to handle
// all cases and then re-load the final product in which
// a few quotients are hard-coded in.
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

SetOutputFile("genus_0_modular_quotients.m");
print "genus_0_modular_quotients := ", genus_0_modular_quotients, ";";
UnsetOutputFile();

SetOutputFile("genus_1_modular_quotients.m");
print "genus_1_modular_quotients := ", genus_1_modular_quotients, ";";
UnsetOutputFile();

genus_1_modular_quotient_isom_classes := [];

/* Indices skipped because the models in magma result in long computation times:     
    * The index 65 curve X_0(94)/<w_{47}> is 94a1 by González 2012.
    * The index 66 curve X_0(95)/<w_{95}> is 19a3 by González 2012.
    * The index 67 curve X_0(101)/<w_{101}> is 101a1 by González 2012.
    * The index 80 curve X_0(119)/<w_{119}> is 17a4 by González 2012.
    * The index 83 curve X_0(131)/<w_{131}> is 131a1 by González 2012.
    * The index 85 curve X_0(142)/<w_{2},w_{71}> is in isogeny class 142b, which only has one element 142b1.
*/

/* Indices causing errors because of some type issue in Magma:     
    * The index 21 curve X_0(34)/<w_{2}> is 17a2. One can avoid the type issue with the following:
        X := SmallModularcurve(34);
        iota := AtkinLehnerInvolution(X,34,2);
        G := AutomorphismGroup(X,[i]);
        C := CurveQuotient(G);
        P := Setseq(RationalPoints(C))[1];
        E := EllipticCurve(C,P);
        CremonaReference(E);
*/

skipped_indices := [21,65,66,67,80,83,85];
skipped_curves := [[*21,"17a2"*],[*65,"94a1"*],[*66,"19a3"*],
    [*67,"101a1"*],[*80,"17a4"*],[*83,"131a1"*],[*85,"142b"*]];

step := 0;

// Here we handle the majority of cases using built in Magma functionality
for L in [L : L in genus_1_modular_quotients] do 
    step := step+1;
    print "step out of ", #genus_1_modular_quotients, ": ", step;
    N := L[1];
    Wgens := L[2];
    print "N, Wgens: ", N, Wgens;
    i := Index(genus_1_modular_quotients,L);
    if i in skipped_indices then 
        ref := Explode([pair : pair in skipped_curves | pair[1] eq step])[2];
        Append(~genus_1_modular_quotient_isom_classes,[* N, Wgens, ref *]);
    else 
        if Wgens eq {1} then 
            try 
                E := X0NQuotient(N,[]);
                ref := CremonaReference(E);
                Append(~genus_1_modular_quotient_isom_classes,[* N, Wgens, ref *]);
            catch e // this shouldn't flag at all
                print "encountered error: ", L;
            end try;
        else
            try  
                E := X0NQuotient(N,Setseq(Wgens));
                ref := CremonaReference(E);
                Append(~genus_1_modular_quotient_isom_classes,[* N, Wgens, ref *]);
            catch e // this shouldn't flag at all
                print "encountered error: ", L;
            end try;
        end if;
    end if; 
end for;


/* 
After fully computing the list of references,
we sort using the below function. 
*/

// function for sorting two triples of the form [N,Wgens,ref] where W_gens is a minimal generating set for 
// an Atkin--Lehner subgroup W of W_0(1,N)
sort_triples := function(x,y)
    N_diff := x[1]-y[1];
    if N_diff ne 0 then 
        return N_diff;
    else
        x_gens := Sort(Setseq(x[2]));
        y_gens := Sort(Setseq(y[2]));
        subgroup_size_diff := #x_gens - #y_gens;
        if subgroup_size_diff ne 0 then 
            return subgroup_size_diff;
        else 
            distinguishing_index := Min([i : i in [1..#x_gens] | x_gens[i] ne y_gens[i]]);
            return x_gens[distinguishing_index] - y_gens[distinguishing_index];
        end if;
    end if;
end function;


Sort(~genus_1_modular_quotient_isom_classes,sort_triples);

SetOutputFile("genus_1_modular_quotient_isom_classes.m");
print "genus_1_modular_quotient_isom_classes := [";
for i in [1..#genus_1_modular_quotient_isom_classes-1] do 
    L := genus_1_modular_quotient_isom_classes[i];
    print "[*", L[1], L[2], "\"" cat L[3] cat "\"", "*], ";
end for; 
L := genus_1_modular_quotient_isom_classes[#genus_1_modular_quotient_isom_classes];
print "[*", L[1], L[2], "\"" cat L[3] cat "\"", "*]];";
UnsetOutputFile();


/* 
// Printing info to a table for LaTeX

// creating table with following columns:
//      * Level N
//      * Sets Wgens such that E = X_0^D(N)/Wgens is an elliptic curve
//      * Cremona reference of the elliptic curve E
SetOutputFile("genus_1_modular_quotients_table.m");
for i in [1..32] do 
    for j in [1..2] do 
        L := genus_1_modular_quotient_isom_classes[3*(i-1)+j];
        N := L[1];
        Wgens := Sort(Setseq(L[2]));
        ref := L[3];
        print "$", N, "$ & $\\langle";

        if Wgens eq [1] then 
            print "\\textnormal{id} \\rangle $";
        else 
            for i in [1..#Wgens-1] do 
                m := Wgens[i];
                print "w_{", m, "}, ";
            end for;
            print "w_{", Wgens[#Wgens], "} \\rangle $";
        end if;
         
        print " & ", ref, " & ";
    end for; 

    L := genus_1_modular_quotient_isom_classes[3*(i-1)+3];
    N := L[1];
    Wgens := Sort(Setseq(L[2]));
    ref := L[3];
    print "$", N, "$ & $\\langle";

    if Wgens eq [1] then 
        print "\\textnormal{id} \\rangle $";
    else 
        for i in [1..#Wgens-1] do 
            m := Wgens[i];
            print "w_{", m, "}, ";
        end for;
        print "w_{", Wgens[#Wgens], "} \\rangle $";
    end if;

    print " & ", ref, " \\\\ \\hline";
end for;
UnsetOutputFile();
*/
