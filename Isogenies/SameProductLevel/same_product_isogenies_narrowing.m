/* 
In this file, we take the candidates quotients for having
isogenous Jacobians from same_product_genus_matches.m and use finer
checks to exclude the possibility of isogeny, until we have a 
reasonably sized list to explicitly compute isogeny factors
and complete the classification, in the D1N1=D2N2 with D1 \neq D2 case
*/

// Loading functions for working with AL subgroups and for computing 
// genera of quotients of Shimura curves. 
load "AL_identifiers.m";

// Loading information of levels and sign patterns lacking newforms
// from work of Padurariu--Park--Voight
load "PPV_info.m";

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

/* 
Note: partly because genus_matches.m is large, and also because
the finite field point counts check requires a large list 
of trace data for the action of Hecke operators, we complete
the first checks separately and then load in the resulting smaller
lists of remaining candidates manually. One can uncomment
the code here in each step to check the corresponding computations. 
*/ 


////////////////////////////////////////////////
////// Atkin--Lehner Compatability Checks
////////////////////////////////////////////////

    // // Loading list of all genus matches ////////////////////////////////////////////////
    // // Here we load our list containing the info on genus matches. Each element is a list
    // // [*M, M_curves*] where M is a squarefree positive integer and M_curves is a list
    // // of info for curves X_0^D(N)/W with DN = M for which we witnessed genus matches. 
    // // Each element of M_curves is a list [*g, g_curves *], where g_curves is a list 
    // // whose elements are lists 
    // // [* D, N, Wgens *] of curves X_0^D(N)/<Wgens> of genus g with DN = M. 

    // load "genus_matches.m";

    // // Sorting and excluding candidate quotients for isomorphism by
    // // testing compatibility of AL actions when we have newforms of
    // // all sign patterns in the level we are dealing with

    // genus_matches_number := #genus_matches;

    // print "excluding candidates by testing AL compatibility";

    // step := 0; 

    // // initializing iso_candidates as an associative array on the levels M=DN
    // // that provide possible isogenies of Jacobians 
    // iso_candidates := AssociativeArray([L[1] : L in genus_matches]);

    // for DN_list in genus_matches do 
    //     DN := DN_list[1];  
    //     step := step+1;
    //     print "Step out of ", genus_matches_number , ": ", step;

    //     // initializing iso_candidates[DN] as an array indexed on the genera that
    //     // occur in this level as possibly seeing isogenies of Jacobians
    //     iso_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

    //     if DN in PPV_levels_seq then 
    //         missing_newforms := true;
    //     else
    //         missing_newforms := false;
    //     end if; 

    //     for g_list in DN_list[2] do
    //         g := g_list[1];
    //         g_curves := g_list[2];
    //         g_iso_candidates_lists := [* *];

    //         // If there exists a sign pattern in level DN for which there exists no 
    //         // newform of level DN, then we gain no information in this check. If 
    //         // g = 1, then we also don't record any extra info from this check. 
    //         if (missing_newforms) or (g le 1) then 
    //             Append(~g_iso_candidates_lists,g_curves);

    //         // Otherwise, we check "compatibility" of the Atkin--Lehner actions
    //         // for isogeny candidates in level DN of each genus
    //         else 
    //             for X in g_curves do 

    //                 if IsEmpty(g_iso_candidates_lists) then 
    //                     Append(~g_iso_candidates_lists,[ X ]);
    //                 else
    //                     D1 := X[1];
    //                     N1 := X[2];
    //                     W1_gens := X[3];
    //                     W1 := gens_to_identifier(DN,W1_gens);
    //                     X_class_found := false;

    //                     // For each list, we check whether Jac(X) could be isogenous to the
    //                     // Jacobian of a curve in this list by considering compatability
    //                     // of the AL actions, which gives an equivalence relation on
    //                     // these quotients coarser than isogeny of jacobians
    //                     for L in g_iso_candidates_lists do
    //                         L_index := Index(g_iso_candidates_lists,L);
    //                         Y := L[1];
    //                         D2 := Y[1];
    //                         N2 := Y[2];
    //                         W2_gens := Y[3];
    //                         W2 := gens_to_identifier(DN,W2_gens);

    //                         W1_same_parity := {m : m in W1 | (#PrimeDivisors(GCD(D1,m)) mod 2) eq (#PrimeDivisors(GCD(D2,m)) mod 2)};
    //                         W2_same_parity := {m : m in W2 | (#PrimeDivisors(GCD(D1,m)) mod 2) eq (#PrimeDivisors(GCD(D2,m)) mod 2)};

    //                         // if this check goes through, then we've found
    //                         // the equivalence class that X belongs in 
    //                         if (Seqset(W1) meet Seqset(W2)) eq ((W1_same_parity) join (W2_same_parity)) then  
    //                             // append X to this list and update our
    //                             // list of equivalence classes of size greater than 1
    //                             // unders this AL compatibility relation
    //                             L_new := Append(L,X);
    //                             g_iso_candidates_lists[L_index] := L_new;
    //                             X_class_found := true;
    //                             break;
    //                         end if;
    //                     end for; 

    //                     // In this case, the equivalence class of X is not 
    //                     // yet represented
    //                     if not X_class_found then 
    //                         Append(~g_iso_candidates_lists,[ X ]);
    //                     end if; 

    //                 end if;
    //             end for;  
    //         end if;

    //         // now we append to our genus g array the info of equivalence classes 
    //         // of quotients, under the AL compatibility relation, which have size > 1
    //         // and moreover do not consist of all quotients of the same curve X_0^D(N) 
    //         iso_candidates[DN][g] := [L : L in g_iso_candidates_lists | #{X[1] : X in L} gt 1];

    //     end for; 
    // end for; 

    // // printing info to a list
    // same_product_remaining_isog_lists_v1 := [* *];

    // for DN in Sort(Setseq(Keys(iso_candidates))) do 
    //     g_lists := [* *];
    //     for g in Sort(Setseq(Keys(iso_candidates[DN]))) do
    //         g_quotients_lists := iso_candidates[DN][g];
    //         if not IsEmpty(g_quotients_lists) then 
    //             Append(~g_lists, [* g, g_quotients_lists *]);
    //         end if; 
    //     end for;

    //     if not IsEmpty(g_lists) then 
    //         Append(~same_product_remaining_isog_lists_v1, [* DN, g_lists *]);
    //     end if; 
    // end for;

    // SetOutputFile("same_product_remaining_isog_lists_v1.m");
    // print "same_product_remaining_isog_lists_v1 := ", same_product_remaining_isog_lists_v1, ";";
    // UnsetOutputFile(); 


////////////////////////////////////////////////
////// Finer Compatability Checks
////////////////////////////////////////////////

    // print "Performing finer compatability checks";

    // // Given D an indefinite quaternion discriminant, N a positive integer, 
    // // pattern and element of {-1,1}^{omega(DN)}, and gens a set of Hall
    // // Divisors m of DN, returns True if pattern (viewed as a sign pattern
    // // for the Atkin--Lehner action on X_0^D(N), with the ith element giving
    // // the sign of w_{p_i} where p_i is the ith smallest prime divisor of DN)
    // // is compatible with the action of W = <w_m | m in gens> on X_0^D(N) and
    // // returns False otherwise. 
    // IsCompatible := function(D,N,pattern,gens)
        
    //     compat_check := true;
    //     DNprimes := PrimeDivisors(D*N);

    //     for m in gens do 

    //         m_sign := &*([1] cat [pattern[i] : i in [1..#pattern] | m mod DNprimes[i] eq 0]);

    //         if m_sign ne (-1)^(#PrimeDivisors(GCD(D,m))) then
    //             compat_check := false;
    //             break;
    //         end if;
    //     end for;

    //     return compat_check;
    // end function;


    // // Given an indefinite quaternion discriminants D, 
    // // a squarefree positive integer N coprime to D, and 
    // // a set Wgens of Hall Divisors generating an Atkin--Lehner subgroup W of 
    // // X_0^{D}(N), returns the set of sign patterns in level D*N 
    // // (as elements of {-1,1}^omega(DN)) that are compatible with the action of W. 
    // compatible_patterns := function(D,N,Wgens)
    //     signs := {-1,1}; 
    //     sign_patterns := CartesianPower(signs,#PrimeDivisors(D*N));
    //     return {pattern : pattern in sign_patterns | IsCompatible(D,N,pattern,Wgens)};
    // end function;


    // // Given sequences X1 and X2, each consisting of an indefinite quaternion discriminants Di, 
    // // a squarefree positive integers Ni coprime to Di, such that D1N1 = D2N2, and 
    // // a set Wigens of Hall Divisors generating an Atkin--Lehner subgroup Wi of 
    // // X_0^{Di}(Ni), returns false if the sets of sign patterns
    // // in level D1*N1 compatible with W1 and with W2 are different or if 
    // // there exists a sign pattern in this level lacking newforms and returns true otherwise.  
    // pattern_compatability_check := function(X1,X2)
    //     D1 := X1[1];
    //     N1 := X1[2];
    //     W1gens := X1[3];
    //     D2 := X2[1];
    //     N2 := X2[2];
    //     W2gens := X2[3];
    //     DN := D1*N1;
    //     assert DN eq D2*N2;

    //     // If D1 \nmid D2 and is not among the PPV levels, then we know dim(S_2(D1)^{new}) > 1 and this newspace
    //     // is generated by elements of S_2(D1N1)^{D1-new} minus S_2(D1N1)^{D2-new}, so we can't have
    //     // isogeny. The same holds swapping the roles of D1 and D2.
    //     // This argument easily generalizes to the hypothesis that there's a divisor D 
    //     // of DN which is not in PPV levels such that D1 divides D and D2 does not divide D
    //     // (or vice-verse), giving the more general check that follows in the else statement.
    //     if (D1 ne D2) and ((not (D1 in PPV_levels_seq cat omega1_genus_zero_levels)) and (not (D2 in PPV_levels_seq cat omega1_genus_zero_levels))) then 
    //         return false;
    //     else
    //         DN_divisors := Divisors(DN);
    //         level_divisors_with_newforms := [D : D in DN_divisors | not (D in PPV_levels_seq cat omega1_genus_zero_levels)];
    //         if not IsEmpty([D : D in level_divisors_with_newforms | (D mod D1 eq 0) and (D mod D2 ne 0)]) then 
    //             return false;
    //         elif not IsEmpty([D : D in level_divisors_with_newforms | (D mod D2 eq 0) and (D mod D1 ne 0)]) then 
    //             return false;
    //         end if; 
    //     end if;

    //     // If we made it through, we perform the finer pattern compatibility check.
    //     // Specifically, for each divisor D of D1*N1 with D1 dividing D and D2 not dividing
    //     // D, we check if there is a sign pattern epsilon in level D1*N1 which is 
    //     // compatible with the action of W1 and whose truncation epsilon_D
    //     // to level D has newforms (or similarly by replacing D1 with D2 and W1 with W2).
    //     signs := {-1,1}; 
    //     DN_primes := PrimeDivisors(D1*N1);
    //     sign_patterns := CartesianPower(signs,#DN_primes);

    //     // First checking on X1 side
    //     X1_patterns := compatible_patterns(D1,N1,W1gens);
    //     divs_for_D1 := [D : D in DN_divisors | (D in PPV_levels_seq) and ((D mod D1 eq 0) and (D mod D2 ne 0))];
    //     for D in divs_for_D1 do 
    //         for epsilon in X1_patterns do 
    //             // truncation of sign pattern epsilon to level D
    //             epsilon_D := [epsilon[i] : i in [1..#DN_primes] | D mod DN_primes[i] eq 0];
    //             // if we have newforms for epsilon_D in level D, this setup
    //             // proves non-isogeny
    //             if not epsilon_D in PPV_array[D] then 
    //                 // if D ne D1 then 
    //                 //     print "X1, X2: ", X1, X2;
    //                 //     print "D1 multiple D, epsilon, epsilon_D: ", D, epsilon, epsilon_D;
    //                 // end if;
    //                 return false;
    //             end if; 
    //         end for;
    //     end for; 

    //     // If above failed, we check X2 side
    //     X2_patterns := compatible_patterns(D2,N2,W2gens);
    //     divs_for_D2 := [D : D in DN_divisors | (D in PPV_levels_seq) and ((D mod D2 eq 0) and (D mod D1 ne 0))];
    //     for D in divs_for_D2 do 
    //         for epsilon in X2_patterns do 
    //             // truncation of sign pattern epsilon to level D
    //             epsilon_D := [epsilon[i] : i in [1..#DN_primes] | D mod DN_primes[i] eq 0];
    //             // if we have newforms for epsilon_D in level D, this setup
    //             // proves non-isogeny
    //             if not epsilon_D in PPV_array[D] then 
    //                 // if D ne D2 then 
    //                 //     print "X1, X2: ", X1, X2;
    //                 //     print "D2 multiple D, epsilon, epsilon_D: ", D, epsilon, epsilon_D;
    //                 // end if;
    //                 return false;
    //             end if; 
    //         end for;
    //     end for; 

    //     // If above failed, we check whether there are is a sign pattern in level D*N
    //     // which has newforms and is compatible with one Atkin--Lehner subgroup but not 
    //     // with the other.
    //     uncommon_patterns := [P : P in X1_patterns | not (P in X2_patterns)] cat [P : P in X2_patterns | not (P in X1_patterns)];
    //     if not IsEmpty(uncommon_patterns) then 
    //         if not (DN in PPV_levels_seq cat omega1_genus_zero_levels) then 
    //             return false;
    //         else 
    //             uncommon_patterns_with_newforms := [P : P in uncommon_patterns | not ([s : s in P] in PPV_array[DN])];
    //             if not IsEmpty(uncommon_patterns_with_newforms) then 
    //                 return false;
    //             end if; 
    //         end if;
    //     end if;

    //     // If above checks went through, we return true (indicating no knowledge of non-isogeny)
    //     return true;
    // end function; 


    // // loading back in same_product_remaining_isog_lists_v1 for finer compatability checks
    // load "same_product_remaining_isog_lists_v1.m";

    // // initializing iso_candidates as an associative array on the levels M=DN
    // // that provide possible isogenies of Jacobians 
    // iso_candidates := AssociativeArray([L[1] : L in same_product_remaining_isog_lists_v1]);

    // remainders_number_v1 := #same_product_remaining_isog_lists_v1;
    // step := 0;

    // for DN_list in same_product_remaining_isog_lists_v1 do 
    //     DN := DN_list[1];
    //     step := step+1;
    //     print "Step out of ", remainders_number_v1 , ": ", step;

    //     // initializing iso_candidates[DN] as an array indexed on the genera that
    //     // occur in this level as possibly seeing isogenies of Jacobians
    //     iso_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

    //     // we perform our finer check on "compatability" of Atkin--Lehner actions
    //     // for isogeny candidates in level DN for each genus, checking if there
    //     // is a sign pattern with newforms compatible with an action corresponding
    //     // to one quotient and not the other
    //     for g_list in DN_list[2] do 
    //         g := g_list[1];
    //         g_iso_candidate_lists := g_list[2];
    //         g_iso_candidate_lists_new := [* *];

    //         for candidate_list in g_iso_candidate_lists do 
    //             candidate_lists_finer := [* *];
    //             for X in candidate_list do 
    //                 if IsEmpty(candidate_lists_finer) then 
    //                     Append(~candidate_lists_finer,[ X ]);
    //                 else 
    //                     X_class_found := false;
    //                     for L in candidate_lists_finer do
    //                         L_index := Index(candidate_lists_finer,L);
    //                         for Y in L do 
    //                             // If this check goes through, then we've found
    //                             // a class that X belongs in. Note that
    //                             // we check possibly all elements of L because
    //                             // the relation given by pattern_compatability_check
    //                             // is not transitive. 
    //                             if pattern_compatability_check(X,Y) then 
    //                                 candidate_lists_finer[L_index] := Append(L,X);
    //                                 X_class_found := true;
    //                                 break;
    //                             end if;
    //                         end for; 
    //                     end for;

    //                     // In this case, the equivalence class of X is not 
    //                     // yet represented
    //                     if not X_class_found then 
    //                         Append(~candidate_lists_finer,[ X ]);
    //                     end if; 
    //                 end if;
    //             end for;

    //             // Now we collect the information of the further sieved candidate lists
    //             // in g_candidate_lists_new
    //             for L in [L : L in candidate_lists_finer | #L gt 1] do 
    //                 Append(~g_iso_candidate_lists_new,L);
    //             end for; 

    //         end for;

    //     // now we append to our genus g array the info of equivalence classes 
    //     // of quotients, under the AL compatibility relation, which have size > 1
    //     // and moreover do not consist of all quotients of the same curve X_0^D(N) 
    //     iso_candidates[DN][g] := [L : L in g_iso_candidate_lists_new | #{X[1] : X in L} gt 1];

    //     end for;
    // end for; 


    // // printing info to a list
    // same_product_remaining_isog_lists_v2 := [* *];

    // for DN in Sort(Setseq(Keys(iso_candidates))) do 
    //     g_lists := [* *];
    //     for g in Sort(Setseq(Keys(iso_candidates[DN]))) do
    //         g_quotients_lists := iso_candidates[DN][g];
    //         if not IsEmpty(g_quotients_lists) then 
    //             Append(~g_lists, [* g, g_quotients_lists *]);
    //         end if; 
    //     end for;

    //     if not IsEmpty(g_lists) then 
    //         Append(~same_product_remaining_isog_lists_v2, [* DN, g_lists *]);
    //     end if; 
    // end for;


    // SetOutputFile("same_product_remaining_isog_lists_v2.m");
    // print "same_product_remaining_isog_lists_v2 := ", same_product_remaining_isog_lists_v2, ";";
    // UnsetOutputFile(); 

    // // sanity check showing there are overlaps in above lists
    // found_overlap := false;
    // for DN_list in same_product_remaining_isog_lists_v2 do 
    // print "step DN: ", DN_list[1];
    // for g_list in DN_list[2] do 
    //     isog_candidate_lists := g_list[2];
    //     for i in [1..#isog_candidate_lists] do 
    //         L1 := isog_candidate_lists[i];
    //         for j in [i+1..#isog_candidate_lists] do 
    //             L2 := isog_candidate_lists[j];
    //             if not (IsEmpty([X : X in L1 | X in L2])) then 
    //                 print "DN, g: ", DN_list[1], g_list[1];
    //                 print "L1, L2: ", L1, L2; 
    //                 found_overlap := true;
    //                 break;
    //             end if;
    //         end for;

    //         if found_overlap then 
    //             break;
    //         end if;
    //     end for;

    //     if found_overlap then 
    //         break;
    //     end if;
    // end for; 

    // if found_overlap then 
    //     break;
    // end if;
    // end for;



////////////////////////////////////////////////
////// Finite field point count checks
////////////////////////////////////////////////

    // // loading back in same_product_remaining_isog_lists_v2 for finite field point count checks
    // load "same_product_remaining_isog_lists_v2.m";

    // // initializing iso_candidates as an associative array on the levels M=DN
    // // that provide possible isogenies of Jacobians 
    // iso_candidates := AssociativeArray([L[1] : L in same_product_remaining_isog_lists_v2]);

    // remainders_number_v2 := #same_product_remaining_isog_lists_v2;
    // step := 0;

    // // Loading in code for finite field point counts, from work of 
    // // Mercuri--Padurariu--Saia--Stirpe, and setting largest prime p
    // // and power p^rmax to check up to. 
    // load "counting_points.m";
    // primes_to_check := PrimesUpTo(100);
    // rmax := 3;

    // for DN_list in same_product_remaining_isog_lists_v2 do 
    //     DN := DN_list[1];
    //     step := step+1;
    //     print "Step out of ", remainders_number_v2 , ": ", step;
    //     DN_primes := PrimeDivisors(DN);

    //     // initializing iso_candidates[DN] as an array indexed on the genera that
    //     // occur in this level as possibly seeing isogenies of Jacobians
    //     iso_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

    //     // wW perform finite field point count checks
    //     // for isogeny candidates in level DN for each genus.
    //     for g_list in DN_list[2] do 
    //         g := g_list[1];
    //         g_iso_candidate_lists := g_list[2];
    //         g_iso_candidate_lists_new := [* *];

    //         for candidate_list in g_iso_candidate_lists do 
    //             candidate_lists_finer := [* *];
    //             for X in candidate_list do 
    //                 if IsEmpty(candidate_lists_finer) then 
    //                     Append(~candidate_lists_finer,[ X ]);
    //                 else 
    //                     D1 := X[1];
    //                     N1 := X[2];
    //                     W1gens := X[3];
    //                     W1gens_by_indices := [{Index(DN_primes,p) : p in PrimeDivisors(m)} : m in W1gens];
    //                     X_class_found := false;

    //                     for L in candidate_lists_finer do
    //                         L_index := Index(candidate_lists_finer,L);
    //                         Y := L[1];
    //                         D2 := Y[1];
    //                         N2 := Y[2];
    //                         W2gens := Y[3];
    //                         W2gens_by_indices := [{Index(DN_primes,p) : p in PrimeDivisors(m)} : m in W2gens];
                         
    //                         found_disagreement := false;
    //                         for p in [p : p in primes_to_check | not (p in DN_primes)] do 
    //                             gX, Xcounts := shipoints(p, D1, N1, traces_to_forms(dataByLevel, p, D1, N1) : ALprimes:=W1gens_by_indices, m:=rmax, eps:=3);
    //                             gY, Ycounts := shipoints(p, D2, N2, traces_to_forms(dataByLevel, p, D2, N2) : ALprimes:=W2gens_by_indices, m:=rmax, eps:=3);
    //                             assert gX eq gY;

    //                             for r in [1..rmax] do
    //                                 if Xcounts[r] ne Ycounts[r] then 
    //                                     found_disagreement := true;
    //                                     break;
    //                                 end if; 
    //                             end for;

    //                             if found_disagreement then 
    //                                 break;
    //                             end if;
    //                         end for; 

    //                         // if this check goes through, then we've found
    //                         // the equivalence class that X belongs in with respect
    //                         // to these point count checks
    //                         if not found_disagreement then 
    //                             candidate_lists_finer[L_index] := Append(L,X);
    //                             X_class_found := true;
    //                             break;
    //                         end if;
    //                     end for; 

    //                     // In this case, the equivalence class of X is not 
    //                     // yet represented
    //                     if not X_class_found then 
    //                         Append(~candidate_lists_finer,[ X ]);
    //                     end if; 
    //                 end if;
    //             end for;

    //             // Now we collect the information of the further sieved candidate lists
    //             // in g_candidate_lists_new
    //             for L in [L : L in candidate_lists_finer | #L gt 1] do 
    //                 Append(~g_iso_candidate_lists_new,L);
    //             end for; 

    //         end for;

    //     // now we append to our genus g array the info of equivalence classes 
    //     // of quotients, under the point counts relation, which have size > 1
    //     // and moreover do not consist of all quotients of the same curve X_0^D(N) 
    //     iso_candidates[DN][g] := [L : L in g_iso_candidate_lists_new | #{X[1] : X in L} gt 1];

    //     end for;
    // end for; 


    // // printing info to a list
    // same_product_remaining_isog_lists_v3 := [* *];

    // for DN in Sort(Setseq(Keys(iso_candidates))) do 
    //     g_lists := [* *];
    //     for g in Sort(Setseq(Keys(iso_candidates[DN]))) do
    //         g_quotients_lists := iso_candidates[DN][g];
    //         if not IsEmpty(g_quotients_lists) then 
    //             Append(~g_lists, [* g, g_quotients_lists *]);
    //         end if; 
    //     end for;

    //     if not IsEmpty(g_lists) then 
    //         Append(~same_product_remaining_isog_lists_v3, [* DN, g_lists *]);
    //     end if; 
    // end for;


    // SetOutputFile("same_product_remaining_isog_lists_v3.m");
    // print "same_product_remaining_isog_lists_v3 := ", same_product_remaining_isog_lists_v3, ";";
    // UnsetOutputFile();


    // // sanity check showing there are overlaps in above lists
    // found_overlap := false;
    // for DN_list in same_product_remaining_isog_lists_v3 do 
    //     print "step DN: ", DN_list[1];
    //     for g_list in DN_list[2] do 
    //         isog_candidate_lists := g_list[2];
    //         for i in [1..#isog_candidate_lists] do 
    //             L1 := isog_candidate_lists[i];
    //             for j in [i+1..#isog_candidate_lists] do 
    //                 L2 := isog_candidate_lists[j];
    //                 if not (IsEmpty([X : X in L1 | X in L2])) then 
    //                     print "DN, g: ", DN_list[1], g_list[1];
    //                     print "L1, L2: ", L1, L2; 
    //                     found_overlap := true;
    //                     break;
    //                 end if;
    //             end for;

    //             if found_overlap then 
    //                 break;
    //             end if;
    //         end for;

    //         if found_overlap then 
    //             break;
    //         end if;
    //     end for; 

    //     if found_overlap then 
    //         break;
    //     end if;
    // end for;


////////////////////////////////////////////////
////// Explicit isogeny checks
////////////////////////////////////////////////

print "Performing explicit Jacobian isogeny check";

// loading back in same_product_remaining_isog_lists_v2 for explicit isogeny checks
load "same_product_remaining_isog_lists_v3.m";

// Loading functions for isogeny decompositions
load "ribet_isog.m";

// initializing iso_candidates as an associative array on the levels M=DN
// that provide possible isogenies of Jacobians 
iso_candidates := AssociativeArray([L[1] : L in same_product_remaining_isog_lists_v3]);

remainders_number_v3 := #same_product_remaining_isog_lists_v3;
step := 0;

for DN_list in same_product_remaining_isog_lists_v3 do 
    DN := DN_list[1];
    step := step+1;
    print "Step out of ", remainders_number_v3 , ": ", step;
    print "DN = ", DN;

    // initializing iso_candidates[DN] as an array indexed on the genera that
    // occur in this level as possibly seeing isogenies of Jacobians
    iso_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

    // initializing lists where we store info
    // for Jac(X_0^D(N)), to avoid significant redundant computations below
    pairs_encountered := [];
    top_curve_decomp_info := [* *];
    pairs_encountered_brute := [];
    J0_info_list := [* *];


    // we perform explicit isogeny checks on Jacobians to finally
    // determine lists of isogenous Shimura curve quotients
    for g_list in DN_list[2] do 
        g := g_list[1];
        print "g: ", g;
        g_iso_candidate_lists := g_list[2];
        g_iso_candidate_lists_new := [* *];

        for candidate_list in g_iso_candidate_lists do 
            print "beginning new candidates list of genus g = ", g;
            candidate_lists_finer := [* *];
            isogeny_factors_info := AssociativeArray([1..#candidate_list]);
            for X in candidate_list do 
                print "X: ", X;
                print "Computing isogeny factors of X";
                if [X[1],X[2]] in pairs_encountered then 
                    X_top_info := Explode([J : J in top_curve_decomp_info | [J[1],J[2]] eq [X[1],X[2]]]);
                    ALdecomp := X_top_info[3];
                    DecompX := isogeny_factors_from_symbols_dim_and_decomp(X[1],X[2],X[3],g,ALdecomp);

                    // The above function may not have found all
                    // isogeny factors, in which case we compute in a more
                    // brute force manner and adjust the output to match that of 
                    // the isogeny_factors_from_symbols_and_dim output.
                    if Type(DecompX) eq MonStgElt then
                        print "Modular symbols computation insufficient, trying brute force";
                        if [X[1],X[2]] in pairs_encountered_brute then 
                            J0_info := Explode([J : J in J0_info_list | [J[1],J[2]] eq [X[1],X[2]]]);
                            J0 := J0_info[3];
                            DecompX_single_seq := IsogClassALQuotientFromJ0(X[1],X[2],X[3],J0);
                            X_dim1_factors := [A : A in DecompX_single_seq | Dimension(A) eq 1];
                            X_larger_dim_factors := [A : A in DecompX_single_seq | not (A in X_dim1_factors)];
                            X_dim1_factors_ECs := [EllipticCurve(A) : A in X_dim1_factors];
                            DecompX := [*X_dim1_factors_ECs,X_larger_dim_factors*];
                        else 
                            J0 := JZero(X[1]*X[2]); 
                            Append(~pairs_encountered_brute,[X[1],X[2]]);
                            Append(~J0_info_list,[*X[1],X[2],J0*]);
                            DecompX_single_seq := IsogClassALQuotientFromJ0(X[1],X[2],X[3],J0);
                            X_dim1_factors := [A : A in DecompX_single_seq | Dimension(A) eq 1];
                            X_larger_dim_factors := [A : A in DecompX_single_seq | not (A in X_dim1_factors)];
                            X_dim1_factors_ECs := [EllipticCurve(A) : A in X_dim1_factors];
                            DecompX := [*X_dim1_factors_ECs,X_larger_dim_factors*];
                        end if;
                    end if; 

                else 
                    M := ModularSymbols(X[1]*X[2],2,-1); // modular symbols of level D*N, weight 2
                                               // trivial character, and sign -1 over \Q
                                               // -1 as sign picks out just 
                                               // cusp forms with mult 1
                    Snew := NewSubspace(CuspidalSubspace(M));
                    ALdecomp := AtkinLehnerDecomposition(Snew);
                    Append(~pairs_encountered,[X[1],X[2]]);
                    Append(~top_curve_decomp_info,[*X[1],X[2],ALdecomp*]);
                    DecompX := isogeny_factors_from_symbols_dim_and_decomp(X[1],X[2],X[3],g,ALdecomp);

                    // The above function may not have found all
                    // isogeny factors, in which case we compute in a more
                    // brute force manner and adjust the output to match that of 
                    // the isogeny_factors_from_symbols_and_dim output.
                    if Type(DecompX) eq MonStgElt then
                        print "Modular symbols computation insufficient, trying brute force";
                        J0 := JZero(X[1]*X[2]); 
                        Append(~pairs_encountered_brute,[X[1],X[2]]);
                        Append(~J0_info_list,[*X[1],X[2],J0*]);
                        DecompX_single_seq := IsogClassALQuotientFromJ0(X[1],X[2],X[3],J0);
                        X_dim1_factors := [A : A in DecompX_single_seq | Dimension(A) eq 1];
                        X_larger_dim_factors := [A : A in DecompX_single_seq | not (A in X_dim1_factors)];
                        X_dim1_factors_ECs := [EllipticCurve(A) : A in X_dim1_factors];
                        DecompX := [*X_dim1_factors_ECs,X_larger_dim_factors*];
                    end if; 

                end if; 

                isogeny_factors_info[Index(candidate_list,X)] := DecompX;

                if IsEmpty(candidate_lists_finer) then 
                    
                    print "class wasn't yet represented";
                    Append(~candidate_lists_finer,[ X ]);
                else 
                    X_class_found := false;
                    X_dim1_factors := DecompX[1];
                    X_larger_dim_factors := DecompX[2];

                    for L in candidate_lists_finer do
                        L_index := Index(candidate_lists_finer,L);
                        Y := L[1];
                        print "Y: ", Y;
                        DecompY := isogeny_factors_info[Index(candidate_list,Y)];
                        Y_dim1_factors := DecompY[1];
                        Y_larger_dim_factors := DecompY[2];

                        // if this check goes through, then we've found
                        // the equivalence class that X belongs in 
                        XY_non_isogenous := false;

                        // First we handle one-dimensional isogeny factors
                        print "checking elliptic curve factors";
                        for A in X_dim1_factors do 
                            found_isog := false;

                            for B in Y_dim1_factors do
                                if IsIsogenous(A,B) then 
                                    found_isog := true;
                                    Exclude(~Y_dim1_factors,B);
                                    break;
                                end if;
                            end for; 

                            if not found_isog then 
                                XY_non_isogenous := true;
                                print "not isogenous";
                                break;
                            end if; 
                        end for; 

                        // If consideration of dimension 1 factors did not prove
                        // non-isogeny of X and Y, we look at larger dimensional factors
                        if not XY_non_isogenous then 
                            print "checking higher dim factors";
                            for A in X_larger_dim_factors do 
                                found_isog := false;
                                A_dim := Dimension(A);
                                for B in [B : B in Y_larger_dim_factors | Dimension(B) eq A_dim] do
                                    if IsIsogenous(A,B) then 
                                        found_isog := true;
                                        Exclude(~Y_larger_dim_factors,B);
                                        break;
                                    end if;
                                end for;

                                if not found_isog then 
                                    XY_non_isogenous := true;
                                    print "not isogenous";
                                    break;
                                end if; 
                            end for; 
                        end if; 

                        if not XY_non_isogenous then 
                            print "found class";
                            candidate_lists_finer[L_index] := Append(L,X);
                            X_class_found := true;
                            break;
                        end if; 
                    end for; 

                    // In this case, the equivalence class of X is not 
                    // yet represented, so we add it as a new class
                    if not X_class_found then 
                        print "class wasn't yet represented";
                        Append(~candidate_lists_finer,[ X ]);
                    end if; 
                end if;
            end for;

            // Now we collect the information of the further sieved candidate lists
            // in g_candidate_lists_new
            for L in [L : L in candidate_lists_finer | #L gt 1] do 
                Append(~g_iso_candidate_lists_new,L);
            end for; 
        end for;

        // now we append to our genus g array the info of equivalence classes 
        // of quotients, under isogeny, which have size > 1
        // and moreover do not consist of all quotients of the same curve X_0^D(N) 
        iso_candidates[DN][g] := [L : L in g_iso_candidate_lists_new | #{X[1] : X in L} gt 1];
    end for;
end for; 

same_product_remaining_isog_lists_v4 := [* *];
index := 0;
// printing info to a list
for DN in Sort(Setseq(Keys(iso_candidates))) do 
    g_lists := [* *];
    for g in Sort(Setseq(Keys(iso_candidates[DN]))) do
        g_quotients_lists := iso_candidates[DN][g];
        if not IsEmpty(g_quotients_lists) then 
            Append(~g_lists, [* g, g_quotients_lists *]);
        end if; 
    end for;

    if not IsEmpty(g_lists) then 
        Append(~same_product_remaining_isog_lists_v4, [* DN, g_lists *]);
    end if; 
end for;

// creating version of iso_candidates array featuring no overlaps between the lists
// of isogenous quotients, which were introduced in going from v1 to v2
iso_candidates_no_overlaps := AssociativeArray(Keys(iso_candidates));
for DN in Keys(iso_candidates) do 
    DN_g_values := Keys(iso_candidates[DN]);
    iso_candidates_no_overlaps[DN] := AssociativeArray(DN_g_values);
    for g in DN_g_values do 
        g_quotients_lists := iso_candidates[DN][g];
        g_quotients_lists_new := [];
        for i in [1..#g_quotients_lists] do 
            L1 := g_quotients_lists[i]; 
            found_overlap := false;

            // checking later elements of g_quotients_lists
            for j in [i+1..#g_quotients_lists] do 
                L2 := g_quotients_lists[j];
                found_distinguishing_element := false;
                for X in L1 do 
                    if not (X in L2) then 
                        found_distinguishing_element := true;
                        break;
                    end if;
                end for;

                if not (found_distinguishing_element) then 
                    found_overlap := true; 
                    break;
                end if; 
            end for; 

            if not (found_overlap) then 
                // checking already appended elements of g_quotients_lists_new
                for L2 in g_quotients_lists_new do 
                    found_distinguishing_element := false;
                    for X in L1 do 
                        if not (X in L2) then 
                            found_distinguishing_element := true;
                            break;
                        end if;
                    end for;

                    if not (found_distinguishing_element) then 
                        found_overlap := true; 
                        break;
                    end if; 
                end for; 

                if not (found_overlap) then 
                    Append(~g_quotients_lists_new,L1);
                end if;
            end if;
        end for; 

        iso_candidates_no_overlaps[DN][g] := g_quotients_lists_new;
    end for;
end for;

// creating version of same_product_remaining_isog_lists_v4 with no overlaps
same_product_remaining_isog_lists_v4_no_overlaps := [* *];
index := 0;
// printing info to a list
for DN in Sort(Setseq(Keys(iso_candidates_no_overlaps))) do 
    g_lists := [* *];
    for g in Sort(Setseq(Keys(iso_candidates_no_overlaps[DN]))) do
        g_quotients_lists := iso_candidates_no_overlaps[DN][g];
        if not IsEmpty(g_quotients_lists) then 
            Append(~g_lists, [* g, g_quotients_lists *]);
        end if; 
    end for;

    if not IsEmpty(g_lists) then 
        Append(~same_product_remaining_isog_lists_v4_no_overlaps, [* DN, g_lists *]);
    end if; 
end for;

SetOutputFile("isogeny_lists_final_same_product.m");
print "isogeny_lists_final_same_product := ", same_product_remaining_isog_lists_v4_no_overlaps, ";";
UnsetOutputFile(); 



// sanity check showing there are overlaps in original list
found_overlap := false;
for DN_list in same_product_remaining_isog_lists_v4 do 
    print "step DN: ", DN_list[1];
    for g_list in DN_list[2] do 
        isog_candidate_lists := g_list[2];
        for i in [1..#isog_candidate_lists] do 
            L1 := isog_candidate_lists[i];
            for j in [i+1..#isog_candidate_lists] do 
                L2 := isog_candidate_lists[j];
                if not (IsEmpty([X : X in L1 | X in L2])) then 
                    print "DN, g: ", DN_list[1], g_list[1];
                    print "L1, L2: ", L1, L2; 
                    found_overlap := true;
                    break;
                end if;
            end for;

            if found_overlap then 
                break;
            end if;
        end for;

        if found_overlap then 
            break;
        end if;
    end for; 

    if found_overlap then 
        break;
    end if;
end for;

// sanity check showing there are no overlaps in no_overlaps list
found_overlap := false;
for DN_list in same_product_remaining_isog_lists_v4_no_overlaps do 
    print "step DN: ", DN_list[1];
    for g_list in DN_list[2] do 
        isog_candidate_lists := g_list[2];
        for i in [1..#isog_candidate_lists] do 
            L1 := isog_candidate_lists[i];
            for j in [i+1..#isog_candidate_lists] do 
                L2 := isog_candidate_lists[j];
                if not (IsEmpty([X : X in L1 | X in L2])) then 
                    print "DN, g: ", DN_list[1], g_list[1];
                    print "L1, L2: ", L1, L2; 
                    found_overlap := true;
                    break;
                end if;
            end for;

            if found_overlap then 
                break;
            end if;
        end for;

        if found_overlap then 
            break;
        end if;
    end for; 

    if found_overlap then 
        break;
    end if;
end for;




////////////////////////////////////////////////
////// Table creation
////////////////////////////////////////////////


/*
// loading back in final list in order to create a table of the information
load "isogeny_lists_final_same_product.m";


// finding largest isogeny list
max := 0;

for DN_list in isogeny_lists_final_same_product do
    DN := DN_list[1];
    for g_list in DN_list[2] do 
        g := g_list[1];
        if g gt 1 then 
            for isogeny_list in g_list[2] do 
                if #isogeny_list gt max then 
                    max := #isogeny_list;
                    max_g := g;
                    max_DN := DN;
                    max_list := isogeny_list;
                end if;
            end for;
        end if;
    end for;
end for;


// creating table with following columns:
//      * Level M
//      * Genus g
//      * Tuples (D,N,Wgens) which are isogenous in genus g of level M
SetOutputFile("isogenies_same_product_table.m");
for DN_list in isogeny_lists_final_same_product do 
    DN := DN_list[1];
    // checking there are more than just genus 1 curves in this list
    if [g_list[1] : g_list in DN_list[2]] ne [1] then 
        printed_level := false;
        for g_list in [g_list : g_list in DN_list[2] | g_list[1] gt 1] do 
            if not printed_level then 
                print "$", DN, "$ & ", "$", g_list[1], "$ & ";
                printed_level := true;
            else 
                print "& ", "$", g_list[1], "$ & "; 
            end if; 

            isogeny_lists := g_list[2];
            for i in [1..#isogeny_lists[1]-1] do 
                curve := isogeny_lists[1][i];
                print "$(", curve[1], ",", curve[2], ", \\langle ";
                Wgens := Sort(Setseq(curve[3]));
                if Wgens eq [1] then 
                    print "\\textnormal{id} \\rangle ), $";
                else
                    for i in [1..(#Wgens-1)] do 
                        m := Wgens[i];
                        print "w_{", m, "}, ";
                    end for;
                    print "w_{", Wgens[#Wgens], "} \\rangle ), $ ";
                end if;
            end for;

            curve := isogeny_lists[1][#isogeny_lists[1]];
            print "$(", curve[1], ",", curve[2], ", \\langle ";
            Wgens := Sort(Setseq(curve[3]));
            if Wgens eq [1] then 
                print "\\textnormal{id} \\rangle )$ \\\\ \\hline";
            else
                for i in [1..(#Wgens-1)] do 
                    m := Wgens[i];
                    print "w_{", m, "}, ";
                end for;
                print "w_{", Wgens[#Wgens], "} \\rangle )$ \\\\ \\hline";
            end if;

            for j in [2..#isogeny_lists] do 
                print "& & "; 
                for i in [1..(#isogeny_lists[j]-1)] do 
                    curve := isogeny_lists[j][i];
                    print "$(", curve[1], ",", curve[2], ", \\langle ";
                    Wgens := Sort(Setseq(curve[3]));
                    if Wgens eq [1] then 
                        print "\\textnormal{id} \\rangle ), $";
                    else 
                        for i in [1..#Wgens-1] do 
                            m := Wgens[i];
                            print "w_{", m, "}, ";
                        end for;
                        print "w_{", Wgens[#Wgens], "} \\rangle ), $ ";
                    end if;
                end for;

                curve := isogeny_lists[j][#isogeny_lists[j]];
                print "$(", curve[1], ",", curve[2], ", \\langle ";
                Wgens := Sort(Setseq(curve[3]));
                if Wgens eq [1] then 
                    print "\\textnormal{id} \\rangle )$ \\\\ \\hline";
                else 
                    for i in [1..#Wgens-1] do 
                        m := Wgens[i];
                        print "w_{", m, "}, ";
                    end for;
                    print "w_{", Wgens[#Wgens], "} \\rangle )$ \\\\ \\hline";
                end if;
            end for;

        end for;
    end if;
end for;
UnsetOutputFile();

*/




