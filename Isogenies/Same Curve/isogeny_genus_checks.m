// In this file, we use some initial restrictions on levels admitting 
// isogenies of the form X_0^{D_1}(N_1)/W \sim X_0^{D_2}(N_2)/H 
// with D_1*N_1 = D_2*N_2 to reduce to consideration of finitely many levels.
// We compute that genera of all Atkin--Lehner quotients at these levels
// as a first, coarse check on isogeny.

// Loading functions for working with AL subgroups and for computing 
// genera of quotients of Shimura curves. 
// Note: the function for computing the list of all AL subgroups contained here 
// does the most naive thing, and works well only for omega(DN) <= 4. When 
// we encounter 5 <= omega(DN) <= 6 in the computations contained in this file,
// we enumerate subgroups in a smarter way. 
load "AL_identifiers.m";


// function for sorting two seqs of the form [D1,N1,W_gens]
sort_quotient_lists := function(x,y)
    D1_diff := x[1]-y[1];
    if D1_diff ne 0 then 
        return D1_diff;
    else
        N1_diff := x[2]-y[2];
        if N1_diff ne 0 then 
            return N1_diff;
        else 
            // try sort by Wgens
            x_gens := Sort(Setseq(x[3]));
            y_gens := Sort(Setseq(y[3]));
            subgroup_size_diff := #x_gens - #y_gens;
            if subgroup_size_diff ne 0 then 
                return subgroup_size_diff;
            else 
                distinguishing_index := Min([i : i in [1..#x_gens] | x_gens[i] ne y_gens[i]]);
                return x_gens[distinguishing_index] - y_gens[distinguishing_index];
            end if;
        end if;
    end if;
end function;


// Sequence of sequences of levels M, with omega(M)>=2, for which there exists a sign pattern 
// for the action of W_0(1,DN) with no compatible newforms of level M. 
// (From work of Padurariu--Park--Voight). The ith entry
// is the sequence of all levels M with omega(M) = i (with 2 <= i <= 5).
PPV_levels := [
    [6,10,14,15,21,22,26,33,34,35,38,39,46,51,55,57,58,62,65,69,74,77,82,85,86,87, 93,94, 95,106, 111,
        115,118,119, 122, 129,134, 143,146,159,161,166, 178, 183,194, 202, 206, 215,237,314],

    [30, 42, 66, 70, 78, 102, 105, 110, 114, 130, 138, 154, 165, 170, 174, 182, 186, 190, 195, 222, 230, 
        231, 255, 266, 238, 246, 258, 266, 273, 282, 285, 286, 290, 310, 318, 322, 354, 366, 370, 374, 
        399, 402, 406, 410, 418, 426, 434, 435, 438, 442, 455, 474, 494, 498, 518, 530, 534, 582, 602, 610, 
        615, 642, 654, 678, 822],

    [210, 330, 390, 462, 510, 546, 570, 690, 714, 770, 798, 858, 870, 910, 930, 966, 1110, 1190, 1122, 1218, 
        1230, 1254, 1290, 1302, 1326, 1410, 1590, 1722, 1770, 1794, 1914, 1938, 1974, 2010, 2130],

    [2310, 2730, 3570, 3990, 4290]
    ];

// We know that if there is an isomorphism X_0^D(N)/W \cong X_0^D(N)/H with W
// and H distinct AL subgroups having genera at least 2 and N sqfree, then DN 
// must be included in the sequences contained in PPV_levels. 
// (Note: If D=1 and N = p is prime, then the only quotients are the 
// trivial one X_0(N) and the Fricke X_0(N)/<w_p>,
// and if these are isomorphic then the genus is at most 1.)


// // omega(DN) = 2 ///////////////////////////////////////////////////////////////////////

genus_matches_omega_eq2 := AssociativeArray(PPV_levels[1]);

step := 0;

print "checking omega(DN) = 2 cases";

for DN in PPV_levels[1] do 
    print "DN:", DN; // track progress
    step := step + 1;
    print "Step out of ", #PPV_levels[1], ": ", step;
    genus_matches_omega_eq2[DN] := AssociativeArray(Integers());
    AL_subs := AL_subgroups(DN);
    DN_divs := Divisors(DN);

    // ranging over indefinite quaternion discs D (including D=1)
    for D in [D : D in DN_divs | IsEven(#PrimeDivisors(D))] do
        N := Integers()!(DN/D);

        // Creating list of AL subgroups with genus at least 2 for X_0^D(N)
        // along with the genus of the corresponding quotient.
        // This is so that we don't do redundant computations.
        AL_with_genus_ge2 := [];

        if D eq 1 then // modular curve case
            for Wgens in AL_subs do
                if Wgens eq {1} then 
                    g := GenusX0N(DN);
                else
                    g := GenusX0NQuotient(DN,Setseq(Wgens));
                end if; 

                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq2[DN],g) then 
                        Append(~genus_matches_omega_eq2[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq2[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 

        else // D>1 Shimura curve case 
            for Wgens in AL_subs do 
                g := quot_genus(D,N,gens_to_identifier(DN,Wgens));
                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq2[DN],g) then 
                        Append(~genus_matches_omega_eq2[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq2[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 
        end if;
    end for;
end for;   


genus_matches_omega_eq2_list := [* *];

DN_index := 0;

// printing info to a list
for DN in PPV_levels[1] do 
    if not IsEmpty(Keys(genus_matches_omega_eq2[DN])) then 
        DN_index := DN_index + 1;
        g_index := 0;
        Append(~genus_matches_omega_eq2_list,[* DN, [* *] *]);

        for g in Sort(Setseq(Keys(genus_matches_omega_eq2[DN]))) do
            g_index := g_index + 1;
            Append(~genus_matches_omega_eq2_list[DN_index][2],[* g, [* *] *]);
            quotients_list := genus_matches_omega_eq2[DN][g];
            D_values := {L[1] : L in quotients_list};
            for D in D_values do 
                // If there was only a single quotient of X_0^D(N)
                // of this genus g, we forget this info
                D_curves := [L : L in quotients_list | L[1] eq D];
                if #D_curves gt 1 then 
                    Sort(~D_curves,sort_quotient_lists);
                    Append(~genus_matches_omega_eq2_list[DN_index][2][g_index][2], D_curves);
                end if; 
            end for;
        end for;
    end if;
end for;

SetOutputFile("genus_matches_omega_eq2.m");
print "genus_matches_omega_eq2 := ", genus_matches_omega_eq2_list, ";";
UnsetOutputFile(); 



// // omega(DN) = 3 ///////////////////////////////////////////////////////////////////////

genus_matches_omega_eq3 := AssociativeArray(PPV_levels[2]);

step := 0;

print "checking omega(DN) = 3 cases";

for DN in PPV_levels[2] do 
    print "DN:", DN; // track progress
    step := step + 1;
    print "Step out of ", #PPV_levels[2], ": ", step;
    genus_matches_omega_eq3[DN] := AssociativeArray(Integers());
    AL_subs := AL_subgroups(DN);
    DN_divs := Divisors(DN);

    // ranging over indefinite quaternion discs D (including D=1)
    for D in [D : D in DN_divs | IsEven(#PrimeDivisors(D))] do
        N := Integers()!(DN/D);

        // Creating list of AL subgroups with genus at least 2 for X_0^D(N)
        // along with the genus of the corresponding quotient.
        // This is so that we don't do redundant computations.
        AL_with_genus_ge2 := [];

        if D eq 1 then // modular curve case
            for Wgens in AL_subs do
                if Wgens eq {1} then 
                    g := GenusX0N(DN);
                else
                    g := GenusX0NQuotient(DN,Setseq(Wgens));
                end if; 

                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq3[DN],g) then 
                        Append(~genus_matches_omega_eq3[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq3[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 

        else // D>1 Shimura curve case 
            for Wgens in AL_subs do 
                g := quot_genus(D,N,gens_to_identifier(DN,Wgens));
                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq3[DN],g) then 
                        Append(~genus_matches_omega_eq3[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq3[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 
        end if;
    end for;
end for;   


genus_matches_omega_eq3_list := [* *];

DN_index := 0;

// printing info to a list
for DN in PPV_levels[2] do 
    if not IsEmpty(Keys(genus_matches_omega_eq3[DN])) then 
        DN_index := DN_index + 1;
        g_index := 0;
        Append(~genus_matches_omega_eq3_list,[* DN, [* *] *]);

        for g in Sort(Setseq(Keys(genus_matches_omega_eq3[DN]))) do
            g_index := g_index + 1;
            Append(~genus_matches_omega_eq3_list[DN_index][2],[* g, [* *] *]);
            quotients_list := genus_matches_omega_eq3[DN][g];
            D_values := {L[1] : L in quotients_list};
            for D in D_values do 
                // If there was only a single quotient of X_0^D(N)
                // of this genus g, we forget this info
                D_curves := [L : L in quotients_list | L[1] eq D];
                if #D_curves gt 1 then 
                    Sort(~D_curves,sort_quotient_lists);
                    Append(~genus_matches_omega_eq3_list[DN_index][2][g_index][2], D_curves);
                end if; 
            end for;
        end for;
    end if;
end for;

SetOutputFile("genus_matches_omega_eq3.m");
print "genus_matches_omega_eq3 := ", genus_matches_omega_eq3_list, ";";
UnsetOutputFile(); 



// // omega(DN) = 4 ///////////////////////////////////////////////////////////////////////

genus_matches_omega_eq4 := AssociativeArray(PPV_levels[3]);

step := 0;

print "checking omega(DN) = 4 cases";

for DN in PPV_levels[3] do 
    print "DN:", DN; // track progress
    step := step + 1;
    print "Step out of ", #PPV_levels[3], ": ", step;
    genus_matches_omega_eq4[DN] := AssociativeArray(Integers());
    AL_subs := AL_subgroups(DN);
    DN_divs := Divisors(DN);

    // ranging over indefinite quaternion discs D (including D=1)
    for D in [D : D in DN_divs | IsEven(#PrimeDivisors(D))] do
        N := Integers()!(DN/D);

        // Creating list of AL subgroups with genus at least 2 for X_0^D(N)
        // along with the genus of the corresponding quotient.
        // This is so that we don't do redundant computations.
        AL_with_genus_ge2 := [];

        if D eq 1 then // modular curve case
            for Wgens in AL_subs do
                if Wgens eq {1} then 
                    g := GenusX0N(DN);
                else
                    g := GenusX0NQuotient(DN,Setseq(Wgens));
                end if; 

                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq4[DN],g) then 
                        Append(~genus_matches_omega_eq4[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq4[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 

        else // D>1 Shimura curve case 
            for Wgens in AL_subs do 
                g := quot_genus(D,N,gens_to_identifier(DN,Wgens));
                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq4[DN],g) then 
                        Append(~genus_matches_omega_eq4[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq4[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 
        end if;
    end for;
end for;   


genus_matches_omega_eq4_list := [* *];

DN_index := 0;

// printing info to a list
for DN in PPV_levels[3] do 
    if not IsEmpty(Keys(genus_matches_omega_eq4[DN])) then 
        DN_index := DN_index + 1;
        g_index := 0;
        Append(~genus_matches_omega_eq4_list,[* DN, [* *] *]);

        for g in Sort(Setseq(Keys(genus_matches_omega_eq4[DN]))) do
            g_index := g_index + 1;
            Append(~genus_matches_omega_eq4_list[DN_index][2],[* g, [* *] *]);
            quotients_list := genus_matches_omega_eq4[DN][g];
            D_values := {L[1] : L in quotients_list};
            for D in D_values do 
                // If there was only a single quotient of X_0^D(N)
                // of this genus g, we forget this info
                D_curves := [L : L in quotients_list | L[1] eq D];
                if #D_curves gt 1 then 
                    Sort(~D_curves,sort_quotient_lists);
                    Append(~genus_matches_omega_eq4_list[DN_index][2][g_index][2], D_curves);
                end if; 
            end for;
        end for;
    end if;
end for;

SetOutputFile("genus_matches_omega_eq4.m");
print "genus_matches_omega_eq4 := ", genus_matches_omega_eq4_list, ";";
UnsetOutputFile(); 



// // omega(DN) = 5 ///////////////////////////////////////////////////////////////////////


// creating information for AL subgroups in omega(DN) = 5 case in advance
// based on indices of prime divisors of DN, so that this is not recomputed
// for each of the 499 levels DN encountered.

//     DN := 2*3*5*7*11;
//     DN_primes := PrimeDivisors(DN);

//     // creating list of AL subgroups for level DN
//     Hseq := HallDivisors(DN);
//     H := Seqset(Hseq);
//     AL_subs := [];

//     // add trivial subgroup
//     Append(~AL_subs,[1]);

//     // adding subgroups of size 2
//     for m in [m : m in H | m ne 1] do
//         Append(~AL_subs,[1,m]);
//     end for;

//     // adding subgroups of sizes 2^2, 2^3, and 2^4
//     for genset in Subsets(H,4) do 
//         W := gens_to_identifier(DN,genset); // Atkin--Lehner subgroup of size up to 2^4. EVERY AL subgroup
//                                            // of size 2^2 to 2^4 is realized in this way.
//         if not (W in AL_subs) then 
//             Append(~AL_subs,W);
//         end if; 
//     end for; 

//     // adding full group
//     Append(~AL_subs,Hseq);

//     AL_subs_with_gens := [[*[1],{1}*]] cat [[*W,identifier_to_min_gens(DN,W)*] : W in AL_subs | W ne [1]];

//     // sequence of pairs of sequences [* W_by_indices, Wgens_by_indices *], each consisting 
//     // of two sequences of form I = [i_1,...,i_r] corresponding to Hall Divisors 
//     // m = prod_{i in I} p_i of DN, where [p_1,...,p_5] is the sequence of prime divisors of 
//     // DN. The first in the pair gives all m so that w_m is in W, and the second in the pair
//     // gives those for w_m's which comprise the minimal generating set Wgens for W. 
//     AL_subs_with_gens_by_indices := [];
//     for Wpair in AL_subs_with_gens do 
//         W_by_indices := [];
//         for m in Wpair[1] do 
//             m_prime_indices := [Index(DN_primes,p) : p in PrimeDivisors(m)];
//             Append(~W_by_indices,m_prime_indices);
//         end for; 

//         Wgens_by_indices := [];
//         for m in Wpair[2] do 
//             m_prime_indices := [Index(DN_primes,p) : p in PrimeDivisors(m)];
//             Append(~Wgens_by_indices,m_prime_indices);
//         end for; 

//         Append(~AL_subs_with_gens_by_indices,[* W_by_indices, Wgens_by_indices *]);
//     end for; 

//     SetOutputFile("AL_subs_with_gens_by_indices_omega5.m");
//     print "AL_subs_with_gens_by_indices := ", AL_subs_with_gens_by_indices, ";";
//     UnsetOutputFile();


// loading AL data (i.e., data for subgroup lattice of (Z/2Z)^5)
// which is pre-computed using the above commented code
load "AL_subs_with_gens_by_indices_omega5.m";


genus_matches_omega_eq5 := AssociativeArray(PPV_levels[4]);

step := 0;

print "checking omega(DN) = 5 cases";

for DN in PPV_levels[4] do 
    print "DN:", DN; // track progress
    step := step + 1;
    print "Step out of ", #PPV_levels[4], ": ", step;
    genus_matches_omega_eq5[DN] := AssociativeArray(Integers());
    
    AL_sub_gens := [* *];
    AL_sub_identifiers := AssociativeArray();
    DN_primes := PrimeDivisors(DN);
    DN_divs := Divisors(DN);

    // creating array of info of AL subgroups and their
    // minimal generating sets using pre-computed omega(DN) = 5 data. 
    for W_pair_by_indices in AL_subs_with_gens_by_indices do 
        W_by_indices := W_pair_by_indices[1];
        Wgens_by_indices := W_pair_by_indices[2];
        W := [1] cat [&*[DN_primes[i] : i in m_prime_indices] : m_prime_indices in W_by_indices |  not (IsEmpty(m_prime_indices))];
        Wgens := {&*[DN_primes[i] : i in m_prime_indices] : m_prime_indices in Wgens_by_indices |  not (IsEmpty(m_prime_indices))};
        Append(~AL_sub_gens,Wgens);
        AL_sub_identifiers[Wgens] := W;
    end for; 

    // ranging over indefinite quaternion discs D (including D=1)
    for D in [D : D in DN_divs | IsEven(#PrimeDivisors(D))] do
        N := Integers()!(DN/D);

        // Creating list of AL subgroups with genus at least 2 for X_0^D(N)
        // along with the genus of the corresponding quotient.
        // This is so that we don't do redundant computations.
        AL_with_genus_ge2 := [];

        if D eq 1 then // modular curve case
            for Wgens in AL_sub_gens do
                if Wgens eq {1} then 
                    g := GenusX0N(DN);
                else
                    g := GenusX0NQuotient(DN,Setseq(Wgens));
                end if; 

                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq5[DN],g) then 
                        Append(~genus_matches_omega_eq5[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq5[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 

        else // D>1 Shimura curve case 
            for Wgens in AL_sub_gens do 
                g := quot_genus(D,N,AL_sub_identifiers[Wgens]);
                if g ge 2 then 
                    if IsDefined(genus_matches_omega_eq5[DN],g) then 
                        Append(~genus_matches_omega_eq5[DN][g],[* D, N, Wgens *]);
                    else 
                        genus_matches_omega_eq5[DN][g] := [[* D, N, Wgens *]];
                    end if; 
                end if; 
            end for; 
        end if;
    end for;
end for;   


genus_matches_omega_eq5_list := [* *];

DN_index := 0;

// printing info to a list
for DN in PPV_levels[4] do 
    if not IsEmpty(Keys(genus_matches_omega_eq5[DN])) then 
        DN_index := DN_index + 1;
        g_index := 0;
        Append(~genus_matches_omega_eq5_list,[* DN, [* *] *]);

        for g in Sort(Setseq(Keys(genus_matches_omega_eq5[DN]))) do
            g_index := g_index + 1;
            Append(~genus_matches_omega_eq5_list[DN_index][2],[* g, [* *] *]);
            quotients_list := genus_matches_omega_eq5[DN][g];
            D_values := {L[1] : L in quotients_list};
            for D in D_values do 
                // If there was only a single quotient of X_0^D(N)
                // of this genus g, we forget this info
                D_curves := [L : L in quotients_list | L[1] eq D];
                if #D_curves gt 1 then 
                    Sort(~D_curves,sort_quotient_lists);
                    Append(~genus_matches_omega_eq5_list[DN_index][2][g_index][2], D_curves);
                end if; 
            end for;
        end for;
    end if;
end for;
    

SetOutputFile("genus_matches_omega_eq5.m");
print "genus_matches_omega_eq5 := ", genus_matches_omega_eq5_list, ";";
UnsetOutputFile();    


load "genus_matches_omega_eq2.m";
load "genus_matches_omega_eq3.m";
load "genus_matches_omega_eq4.m";
load "genus_matches_omega_eq5.m";

genus_matches := genus_matches_omega_eq2 cat genus_matches_omega_eq3 cat genus_matches_omega_eq4 cat genus_matches_omega_eq5;

SetOutputFile("genus_matches.m");
print "genus_matches := ", genus_matches, ";";
UnsetOutputFile();




