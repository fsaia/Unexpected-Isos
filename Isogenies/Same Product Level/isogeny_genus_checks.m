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

// Suppose that X_0^{D_1}(N_1)/W \sim X_0^{D_2}(N_2)/H with D_1*N_1 = D_2*N_2,
// with D_1 not dividing D_2, and with both curves having positive genus. 
// Then every prime divisor of DN lies in the following sequence.
possible_prime_divisors := {2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,71,79,83,89,101,131};
omega_1_seqs := Sort([[p] : p in possible_prime_divisors]);
omega_2_seqs := Sort([Sort(Setseq(S)) : S in Subsets(possible_prime_divisors,2)]);


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


// If we have an isogeny as above then we know that omega(D_1N_1) = omega(D_2N_2) <= 6, 
// we know the prime divisors of DN are all in the above set, and we have finer info on DN 
// from our results and the results of Padurariu--Park--Voight. We now proceed in cases. 

// Note: since we are assuming D_1 > 1 and that D_1N_1 = D_2N_2, 
// we must have 2 <= omega(D_1N_1) = omega(D_2N_2) <= 6. 


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


// We know that if there is an isogeny X_0^{D_1}(N_1)/W \cong X_0^{D_2}(N_2)/H as above, 
// with the quotients having positive genus, then for every prime p dividing D_1 and not 
// dividing D_2 there is a sign pattern \epsilon so that 
// dim (S_2(D_1N_1/p)^{\epsilon, new}) = 0.
// So, D_1N_1/p must be included in the sequences contained in PPV_levels. Since we know that 
// p must be in the list possible_prime_divisors defined above, we get clear restrictions on 
// D_1N_1 based on omega(DN). We list possible DN based on this criterion in the following sequences;
// for 2 <= omega(DN) <= 6.

print "creating lists of levels to consider with 3 <= omega <= 6";

possible_DN_omega2 := [];
possible_DN_omega3 := [];
possible_DN_omega4 := [];
possible_DN_omega5 := [];
possible_DN_omega6 := [];

for p in possible_prime_divisors do 

    // creating omega=2 list of possible levels DN seeing an isogeny
    for q in [q : q in possible_prime_divisors | q gt p] do
        DN := p*q;
        if not (DN in possible_DN_omega2) then 
            Append(~possible_DN_omega2,DN);
        end if;
    end for;

    // creating omega=3 list of possible levels DN seeing an isogeny 
    for L in [L : L in PPV_levels[1] | (L mod p ne 0) and (IsEmpty([p : p in PrimeDivisors(L) | not (p in possible_prime_divisors)]))] do 
        DN := p*L;
        if not (DN in possible_DN_omega3) then 
            Append(~possible_DN_omega3,DN);
        end if;
    end for; 

    // creating omega=4 list of possible levels DN seeing an isogeny 
    for L in [L : L in PPV_levels[2] | (L mod p ne 0) and (IsEmpty([p : p in PrimeDivisors(L) | not (p in possible_prime_divisors)]))] do
        DN := p*L;
        if not (DN in possible_DN_omega4) then 
            Append(~possible_DN_omega4,DN);
        end if;
    end for; 

    // creating omega=5 list of possible levels DN seeing an isogeny 
    for L in [L : L in PPV_levels[3] | (L mod p ne 0) and (IsEmpty([p : p in PrimeDivisors(L) | not (p in possible_prime_divisors)]))] do
        DN := p*L;
        if not (DN in possible_DN_omega5) then 
            Append(~possible_DN_omega5,DN);
        end if;
    end for; 

    // creating omega=6 list of possible levels DN seeing an isogeny 
    for L in [L : L in PPV_levels[4] | (L mod p ne 0) and (IsEmpty([p : p in PrimeDivisors(L) | not (p in possible_prime_divisors)]))] do
        DN := p*L;
        if not (DN in possible_DN_omega6) then 
            Append(~possible_DN_omega6,DN);
        end if;
    end for;

end for; 

Sort(~possible_DN_omega2); // size 276
Sort(~possible_DN_omega3); // size 644
Sort(~possible_DN_omega4); // size 815
Sort(~possible_DN_omega5); // size 499
Sort(~possible_DN_omega6); // size 88


// We now compute all genus matches in candidate levels for 2 <= omega(DN) <= 6.
// Initially we ran these separately for the different omega(DN) values just for
// timing purposes, so you see the lists stored individually (and commented code 
// prints them to individual files, which we don't need to save) and combined afterwards.

// // omega(DN) = 2 ///////////////////////////////////////////////////////////////////////

// Cases here:
//      - D1 = 1, N1 = DN
//      - D1 = DN, N1 = 1

genus_matches_omega_eq2 := AssociativeArray(possible_DN_omega2);

step := 0;

print "checking omega(DN) = 2 cases";

for DN in possible_DN_omega2 do 
    print DN; // track progress
    genus_matches_omega_eq2[DN] := AssociativeArray(Integers());
    step := step + 1;
    print "Step out of 276: ", step;
    AL_sub_gens := AL_subgroups(DN);
    AL_sub_identifiers := AssociativeArray(AL_sub_gens);
    for gens in AL_sub_gens do 
        AL_sub_identifiers[gens] := gens_to_identifier(DN,gens);
    end for;
    DN_primes := Seqset(PrimeDivisors(DN));
    DN_primes_2 := Subsets(DN_primes,2);

    // Case D=DN and N=1
    D1 := DN;
    N1 := 1;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq2[DN],gW) then 
                Append(~genus_matches_omega_eq2[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq2[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 

    // Case D1 = 1 and N1 = DN
    D1 := 1;
    N1 := DN;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := GenusX0NQuotient(DN,[m : m in Wgens | m ne 1]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq2[DN],gW) then 
                Append(~genus_matches_omega_eq2[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq2[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 
end for; 

genus_matches_omega_eq2_list := [* *];

// printing info to a list
for DN in possible_DN_omega2 do 
    Append(~genus_matches_omega_eq2_list,[* DN, [* *] *]);
    for g in Keys(genus_matches_omega_eq2[DN]) do
        quotients_list := genus_matches_omega_eq2[DN][g];

        // If all of the quotients possibly giving isogeny of Jacobians
        // by our checks are of the same Shimura curve, we forget
        // this info (as this was checked seperate computations)
        if #{X[1] : X in quotients_list} gt 1 then 
            Sort(~quotients_list,sort_quotient_lists);
            Append(~genus_matches_omega_eq2_list[Index(possible_DN_omega2,DN)][2], [* g, quotients_list *]);
        end if; 
    end for;
end for;

// SetOutputFile("genus_matches_omega_eq2.m");
// print "genus_matches_omega_eq2 := ", genus_matches_omega_eq2_list, ";";
// UnsetOutputFile(); 



// // omega(DN) = 3 ///////////////////////////////////////////////////////////////////////

// Cases here:
//      - D1=1, N1 = DN
//      - omega(D1) = 2, omega(N1) = 1

genus_matches_omega_eq3 := AssociativeArray(possible_DN_omega3);

step := 0;

print "checking omega(DN) = 3 cases";

for DN in possible_DN_omega3 do 
    print DN; // track progress
    genus_matches_omega_eq3[DN] := AssociativeArray(Integers());
    step := step + 1;
    print "Step out of 644: ", step;
    AL_sub_gens := AL_subgroups(DN);
    AL_sub_identifiers := AssociativeArray(AL_sub_gens);
    for gens in AL_sub_gens do 
        AL_sub_identifiers[gens] := gens_to_identifier(DN,gens);
    end for;

    // Checking D=1, N = DN cases 
    D1 := 1;
    N1 := DN;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := GenusX0NQuotient(DN,[m : m in Wgens | m ne 1]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq3[DN],gW) then 
                Append(~genus_matches_omega_eq3[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq3[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 

    // Checking omega(D) = 2, omega(N) = 1 cases
    DN_primes := Seqset(PrimeDivisors(DN));
    DN_primes_2 := Subsets(DN_primes,2);

    for D1_primes in DN_primes_2 do 
        N1_primes := [p : p in DN_primes | not (p in D1_primes)];
        N1 := &*N1_primes;
        D1 := &*D1_primes;

        // For each AL subgroup W, we store the info of the 
        // genus of the quotient X_0^{D1}(N_1)/W.
        for Wgens in AL_sub_gens do
            gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);

            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq3[DN],gW) then 
                    Append(~genus_matches_omega_eq3[DN][gW],[* D1, N1, Wgens *]);
                else 
                    genus_matches_omega_eq3[DN][gW] := [[* D1, N1, Wgens *]];
                end if; 
            end if; 
        end for; 
    end for;
end for;   

genus_matches_omega_eq3_list := [* *];

// printing info to a list
for DN in possible_DN_omega3 do 
    Append(~genus_matches_omega_eq3_list,[* DN, [* *] *]);
    for g in Keys(genus_matches_omega_eq3[DN]) do
        quotients_list := genus_matches_omega_eq3[DN][g];

        // If all of the quotients possibly giving isogeny of Jacobians
        // by our checks are of the same Shimura curve, we forget
        // this info (as this was checked seperate computations)
        if #{X[1] : X in quotients_list} gt 1 then 
            Sort(~quotients_list,sort_quotient_lists);
            Append(~genus_matches_omega_eq3_list[Index(possible_DN_omega3,DN)][2], [* g, quotients_list *]);
        end if; 
    end for;
end for;
    

// SetOutputFile("genus_matches_omega_eq3.m");
// print "genus_matches_omega_eq3 := ", genus_matches_omega_eq3_list, ";";
// UnsetOutputFile();    



// // omega(DN) = 4 ///////////////////////////////////////////////////////////////////////

// Cases here:
//      - D=1, omega(N) = 3
//      - omega(D) = 2 and omega(N) = 2,
//      - omega(D) = 4 and N = 1.

genus_matches_omega_eq4 := AssociativeArray(possible_DN_omega4);

step := 0;

print "checking omega(DN) = 4 cases";
for DN in possible_DN_omega4 do 
    print DN; // track progress
    genus_matches_omega_eq4[DN] := AssociativeArray(Integers());
    step := step + 1;
    print "Step out of 815: ", step;
    AL_sub_gens := AL_subgroups(DN);
    AL_sub_identifiers := AssociativeArray(AL_sub_gens);
    for gens in AL_sub_gens do 
        AL_sub_identifiers[gens] := gens_to_identifier(DN,gens);
    end for;

    // Checking D1=1, N1 = DN cases 
    D1 := 1;
    N1 := DN;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := GenusX0NQuotient(DN,[m : m in Wgens | m ne 1]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq4[DN],gW) then 
                Append(~genus_matches_omega_eq4[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq4[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 

    DN_primes := Seqset(PrimeDivisors(DN));
    DN_primes_2 := Subsets(DN_primes,2);

    // omega(D1) = omega(N1) = 2 cases
    for D1_primes in DN_primes_2 do 
        N1_primes := [p : p in DN_primes | not (p in D1_primes)];
        N1 := &*N1_primes;
        D1 := &*D1_primes;

        // For each AL subgroup W, we store the info of the 
        // genus of the quotient X_0^{D1}(N_1)/W.
        for Wgens in AL_sub_gens do
            gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);

            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq4[DN],gW) then 
                    Append(~genus_matches_omega_eq4[DN][gW],[* D1, N1, Wgens *]);
                else 
                    genus_matches_omega_eq4[DN][gW] := [[* D1, N1, Wgens *]];
                end if; 
            end if;
        end for;       
    end for;

    // handling N = 1 cases
    for Wgens in AL_sub_gens do
        gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq4[DN],gW) then 
                Append(~genus_matches_omega_eq4[DN][gW],[* DN, 1, Wgens *]);
            else 
                genus_matches_omega_eq4[DN][gW] := [[* DN, 1, Wgens *]];
            end if; 
        end if;

    end for;

end for;   

genus_matches_omega_eq4_list := [* *];

// printing info to a list
for DN in possible_DN_omega4 do 
    Append(~genus_matches_omega_eq4_list,[* DN, [* *] *]);
    for g in Keys(genus_matches_omega_eq4[DN]) do
        quotients_list := genus_matches_omega_eq4[DN][g];
        // If all of the quotients possibly giving isogeny of Jacobians
        // by our checks are of the same Shimura curve, we forget
        // this info (as this was checked seperate computations)
        if #{X[1] : X in quotients_list} gt 1 then 
            Sort(~quotients_list,sort_quotient_lists);
            Append(~genus_matches_omega_eq4_list[Index(possible_DN_omega4,DN)][2], [* g, quotients_list *]);
        end if; 
    end for;
end for;
    

// SetOutputFile("genus_matches_omega_eq4.m");
// print "genus_matches_omega_eq4 := ", genus_matches_omega_eq4_list, ";";
// UnsetOutputFile();  


// // omega(DN) = 5 ///////////////////////////////////////////////////////////////////////

// Cases here:
//      - D1 = 1, N1 = DN
//      - omega(D_1) = 2 and omega(N_1) = 3,
//      - omega(D_1) = 4 and omega(N_1) = 1.


// creating information for AL subgroups in omega(DN) = 5 case in advance
// based on indices of prime divisors of DN, so that this is not recomputed
// for each of the 499 levels DN encountered. Afterwards we just load in the
// auxiliary file with this information, so the code is now left commented. 

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

// Ranging through possible omega(DN) = 5 values
genus_matches_omega_eq5 := AssociativeArray(possible_DN_omega5);

step := 0;
print "checking omega(DN) = 5 cases";
for DN in possible_DN_omega5 do 
    genus_matches_omega_eq5[DN] := AssociativeArray(Integers());
    step := step+1;
    print "Step out of 499: ", step;
    print "D*N: ", DN; // track progress;

    // initializing list of AL subgroups for level DN
    AL_sub_gens := [* *];
    AL_sub_identifiers := AssociativeArray();
    DN_primes := PrimeDivisors(DN);
    DN_primes_2 := Subsets(Seqset(DN_primes),2);

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

    // Checking D1=1, N1 = DN cases 
    D1 := 1;
    N1 := DN;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := GenusX0NQuotient(DN,[m : m in Wgens | m ne 1]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq5[DN],gW) then 
                Append(~genus_matches_omega_eq5[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq5[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 

    // omega(D1) = 2, omega(N1) = 3 cases
    for D1_primes in DN_primes_2 do 
        N1_primes := [p : p in DN_primes | not (p in D1_primes)];
        N1 := &*N1_primes;
        D1 := &*D1_primes;

        // For each AL subgroup W, we store the info of the 
        // genus of the quotient X_0^{D1}(N_1)/W.
        for Wgens in AL_sub_gens do
            gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);

            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq5[DN],gW) then 
                    Append(~genus_matches_omega_eq5[DN][gW],[* D1, N1, Wgens *]);
                else 
                    genus_matches_omega_eq5[DN][gW] := [[* D1, N1, Wgens *]];
                end if; 
            end if;
        end for; 
    end for; 

    // omega(D1) = 4, omega(N1) = 1 cases
    for N1 in DN_primes do 
        D1 := ExactQuotient(DN,N1);
        for Wgens in AL_sub_gens do
            gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);
            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq5[DN],gW) then 
                    Append(~genus_matches_omega_eq5[DN][gW],[* D1, N1, Wgens *]);
                else 
                    genus_matches_omega_eq5[DN][gW] := [[* D1, N1, Wgens *]];
                end if; 
            end if;
        end for; 
    end for;
end for;


genus_matches_omega_eq5_list := [* *];

// printing info to a list
for DN in possible_DN_omega5 do 
    Append(~genus_matches_omega_eq5_list,[* DN, [* *] *]);
    for g in Keys(genus_matches_omega_eq5[DN]) do
        quotients_list := genus_matches_omega_eq5[DN][g];

        // If all of the quotients possibly giving isogeny of Jacobians
        // by our checks are of the same Shimura curve, we forget
        // this info (as this was checked seperate computations)
        if #{X[1] : X in quotients_list} gt 1 then 
            Sort(~quotients_list,sort_quotient_lists);
            Append(~genus_matches_omega_eq5_list[Index(possible_DN_omega5,DN)][2], [* g, quotients_list *]);
        end if; 
    end for;
end for;

// SetOutputFile("genus_matches_omega_eq5.m");
// print "genus_matches_omega_eq5 := ", genus_matches_omega_eq5_list, ";";
// UnsetOutputFile();


// // omega(DN) = 6 ///////////////////////////////////////////////////////////////////////

// Cases here:
//      - D1 = 1 and N1 = DN
//      - omega(D_1) = 2 and omega(N_1) = 4,
//      - omega(D_1) = 4 and omega(N_1) = 2,
//      - D1 = DN and N_1 = 1.

// creating information for AL subgroups in omega(DN) = 6 case in advance
// based on indices of prime divisors of DN, so that this is not recomputed
// for each of the 88 levels DN encountered. Afterwards we just load in the
// auxiliary file with this information, so the code is now left commented. 

    // DN := 2*3*5*7*11*13;
    // DN_primes := PrimeDivisors(DN);

    // // initializing list of AL subgroups for level DN
    // Hseq := HallDivisors(DN);
    // H := Seqset(Hseq);
    // AL_subs := [];

    // // adding trivial subgroup
    // Append(~AL_subs,[1]);

    // // adding subgroups of size 2
    // for m in [m : m in H | m ne 1] do
    //     Append(~AL_subs,[1,m]);
    // end for;

    // // adding subgroups of sizes 2^2
    // for genset in Subsets(H,2) do 
    //     W := gens_to_identifier(DN,genset); // Atkin--Lehner subgroup of size 2^2. EVERY AL subgroup
    //                                        // of size 2^2 is realized in this way.
    //     if not (W in AL_subs) then 
    //         Append(~AL_subs,W);
    //     end if; 
    // end for; 

    // // adding subgroups of size 2^3 to 2^5
    // for genset in Subsets(H,5) do 
    //     W := gens_to_identifier(DN,genset); // Atkin--Lehner subgroup of size 2^3 to 2^5. EVERY AL subgroup
    //                                        // of size 2^3 to 2^5 is realized in this way.
    //     if not (W in AL_subs) then 
    //         Append(~AL_subs,W);
    //     end if; 
    // end for; 

    // // adding full group
    // Append(~AL_subs,Hseq);

    // AL_subs_with_gens := [[*[1],{1}*]] cat [[*W,identifier_to_min_gens(DN,W)*] : W in AL_subs | W ne [1]];

    // // sequence of pairs of sequences [* W_by_indices, Wgens_by_indices *], each consisting 
    // // of two sequences of form I = [i_1,...,i_r] corresponding to Hall Divisors 
    // // m = prod_{i in I} p_i of DN, where [p_1,...,p_6] is the sequence of prime divisors of 
    // // DN. The first in the pair gives all m so that w_m is in W, and the second in the pair
    // // gives those for w_m's which comprise the minimal generating set Wgens for W. 
    // AL_subs_with_gens_by_indices := [];
    // for Wpair in AL_subs_with_gens do 
    //     W_by_indices := [];
    //     for m in Wpair[1] do 
    //         m_prime_indices := [Index(DN_primes,p) : p in PrimeDivisors(m)];
    //         Append(~W_by_indices,m_prime_indices);
    //     end for; 

    //     Wgens_by_indices := [];
    //     for m in Wpair[2] do 
    //         m_prime_indices := [Index(DN_primes,p) : p in PrimeDivisors(m)];
    //         Append(~Wgens_by_indices,m_prime_indices);
    //     end for; 

    //     Append(~AL_subs_with_gens_by_indices,[* W_by_indices, Wgens_by_indices *]);
    // end for; 

    // SetOutputFile("AL_subs_with_gens_by_indices_omega6.m");
    // print "AL_subs_with_gens_by_indices := ", AL_subs_with_gens_by_indices, ";";
    // UnsetOutputFile();


// loading AL data (i.e., data for subgroup lattice of (Z/2Z)^6)
// which is pre-computed using the above commented code
load "AL_subs_with_gens_by_indices_omega6.m";

// Ranging through possible omega(DN) = 6 values
genus_matches_omega_eq6 := AssociativeArray(possible_DN_omega6);

step := 0;
print "checking omega(DN) = 6 cases";
for DN in possible_DN_omega6 do 
    genus_matches_omega_eq6[DN] := AssociativeArray(Integers());
    step := step+1;
    print "Step out of 88: ", step;
    print "D*N: ", DN; // track progress;

    // initializing list of AL subgroups for level DN
    AL_sub_gens := [* *];
    AL_sub_identifiers := AssociativeArray();
    DN_primes := PrimeDivisors(DN);
    DN_primes_2 := Subsets(Seqset(DN_primes),2);

    // creating array of info of AL subgroups and their
    // minimal generating sets using pre-computed omega(DN) = 6 data. 
    for W_pair_by_indices in AL_subs_with_gens_by_indices do 
        W_by_indices := W_pair_by_indices[1];
        Wgens_by_indices := W_pair_by_indices[2];
        W := [1] cat [&*[DN_primes[i] : i in m_prime_indices] : m_prime_indices in W_by_indices |  not (IsEmpty(m_prime_indices))];
        Wgens := {&*[DN_primes[i] : i in m_prime_indices] : m_prime_indices in Wgens_by_indices |  not (IsEmpty(m_prime_indices))};
        Append(~AL_sub_gens,Wgens);
        AL_sub_identifiers[Wgens] := W;
    end for; 

    // Checking D1=1, N1 = DN cases 
    D1 := 1;
    N1 := DN;

    // For each AL subgroup W, we store the info of the 
    // genus of the quotient X_0^{D1}(N_1)/W.
    for Wgens in AL_sub_gens do
        gW := GenusX0NQuotient(DN,[m : m in Wgens | m ne 1]);

        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq6[DN],gW) then 
                Append(~genus_matches_omega_eq6[DN][gW],[* D1, N1, Wgens *]);
            else 
                genus_matches_omega_eq6[DN][gW] := [[* D1, N1, Wgens *]];
            end if; 
        end if; 
    end for; 

    // handling cases with N1 > 1
    for D1_primes in DN_primes_2 do 
        N1_primes := [p : p in DN_primes | not (p in D1_primes)];
        N1 := &*N1_primes;
        D1 := &*D1_primes;

        // For each AL subgroup W, we store the info of the 
        // genus of the quotient X_0^{D1}(N_1)/W.

        // omega(D1) = 2, omega(N1) = 4 cases
        for Wgens in AL_sub_gens do
            gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);
            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq6[DN],gW) then 
                    Append(~genus_matches_omega_eq6[DN][gW],[* D1, N1, Wgens *]);
                else 
                    genus_matches_omega_eq6[DN][gW] := [[* D1, N1, Wgens *]];
                end if; 
            end if;
        end for; 

        // omega(D1) = 4, omega(N1) = 6 cases (which we 
        // view here as just swapping D1 and N1 from the prior case)
        for Wgens in AL_sub_gens do
            gW := quot_genus(N1,D1,AL_sub_identifiers[Wgens]);
            if gW gt 0 then 
                if IsDefined(genus_matches_omega_eq6[DN],gW) then 
                    Append(~genus_matches_omega_eq6[DN][gW],[* N1, D1, Wgens *]);
                else 
                    genus_matches_omega_eq6[DN][gW] := [[* N1, D1, Wgens *]];
                end if; 
            end if;
        end for; 
    end for;

    // handling N = 1 cases
    for Wgens in AL_sub_gens do
        gW := quot_genus(D1,N1,AL_sub_identifiers[Wgens]);
        if gW gt 0 then 
            if IsDefined(genus_matches_omega_eq6[DN],gW) then 
                Append(~genus_matches_omega_eq6[DN][gW],[* DN, 1, Wgens *]);
            else 
                genus_matches_omega_eq6[DN][gW] := [[* DN, 1, Wgens *]];
            end if; 
        end if;
    end for; 

end for;


genus_matches_omega_eq6_list := [* *];

// printing info to a list
for DN in possible_DN_omega6 do 
    Append(~genus_matches_omega_eq6_list,[* DN, [* *] *]);
    for g in Keys(genus_matches_omega_eq6[DN]) do
        quotients_list := genus_matches_omega_eq6[DN][g];

        // If all of the quotients possibly giving isogeny of Jacobians
        // by our checks are of the same Shimura curve, we forget
        // this info (as this was checked seperate computations)
        if #{X[1] : X in quotients_list} gt 1 then 
            Sort(~quotients_list,sort_quotient_lists);
            Append(~genus_matches_omega_eq6_list[Index(possible_DN_omega6,DN)][2], [* g, quotients_list *]);
        end if; 
    end for;
end for;

// SetOutputFile("genus_matches_omega_eq6.m");
// print "genus_matches_omega_eq6 := ", genus_matches_omega_eq6_list, ";";
// UnsetOutputFile();

// load "genus_matches_omega_eq2.m";
// load "genus_matches_omega_eq3.m";
// load "genus_matches_omega_eq4.m";
// load "genus_matches_omega_eq5.m";
// load "genus_matches_omega_eq6.m";

genus_matches := genus_matches_omega_eq2 cat genus_matches_omega_eq3 cat genus_matches_omega_eq4 cat genus_matches_omega_eq5 cat genus_matches_omega_eq6;

SetOutputFile("genus_matches.m");
print "genus_matches := ", genus_matches, ";";
UnsetOutputFile();




