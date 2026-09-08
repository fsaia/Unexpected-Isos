// Loading functions for working with AL subgroups and for computing 
// genera of quotients of Shimura curves. 
load "AL_identifiers.m";


////////////////////////////////////////////////
////// Finite field point count checks
////////////////////////////////////////////////

// // loading in information on genus matches for quotients of the same Shimura curve
// load "genus_matches.m";

// // initializing isog_candidates as an associative array on the levels M=DN
// // that provide possible isogenies of Jacobians 
// isog_candidates := AssociativeArray([L[1] : L in genus_matches]);

// remainders_number := #genus_matches;
// step := 0;

// // Loading in code for finite field point counts, from work of 
// // Mercuri--Padurariu--Saia--Stirpe, and setting largest prime p
// // and power p^rmax to check up to. 
// load "counting_points.m";
// primes_to_check := PrimesUpTo(100);
// rmax := 3;

// for DN_list in genus_matches do 
//     DN := DN_list[1];
//     step := step+1;
//     print "Step out of ", remainders_number , ": ", step;
//     DN_primes := PrimeDivisors(DN);

//     // initializing isog_candidates[DN] as an array indexed on the genera that
//     // occur in this level as possibly seeing isogenies of Jacobians
//     isog_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

//     // wW perform finite field point count checks
//     // for isogeny candidates in level DN for each genus.
//     for g_list in DN_list[2] do 
//         g := g_list[1];
//         g_isog_candidate_lists := g_list[2];
//         g_isog_candidate_lists_new := [* *];

//         for candidate_list in g_isog_candidate_lists do 
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
//                 Append(~g_isog_candidate_lists_new,L);
//             end for; 

//         end for;

//     // now we append to our genus g array the info of equivalence classes 
//     // of quotients, under the point counts relation, which have size > 1
//     isog_candidates[DN][g] := g_isog_candidate_lists_new;

//     end for;
// end for; 


// // printing info to a list
// remaining_isog_lists_v1 := [* *];

// for DN in Sort(Setseq(Keys(isog_candidates))) do 
//     g_lists := [* *];
//     for g in Sort(Setseq(Keys(isog_candidates[DN]))) do
//         g_quotients_lists := isog_candidates[DN][g];
//         if not IsEmpty(g_quotients_lists) then 
//             Append(~g_lists, [* g, g_quotients_lists *]);
//         end if; 
//     end for;

//     if not IsEmpty(g_lists) then 
//         Append(~remaining_isog_lists_v1, [* DN, g_lists *]);
//     end if; 
// end for;


// SetOutputFile("remaining_isog_lists_v1.m");
// print "remaining_isog_lists_v1 := ", remaining_isog_lists_v1, ";";
// UnsetOutputFile();



////////////////////////////////////////////////
////// Explicit isogeny checks
////////////////////////////////////////////////

    // print "Performing explicit Jacobian isogeny check";

    // // loading back in remaining_isog_lists_v1 for explicit isogeny checks
    // load "remaining_isog_lists_v1.m";

    // // Loading functions for isogeny decompositions
    // load "ribet_isog.m";

    // // initializing isog_candidates as an associative array on the levels M=DN
    // // that provide possible isogenies of Jacobians 
    // isog_candidates := AssociativeArray([L[1] : L in remaining_isog_lists_v1]);

    // remainders_number_v1 := #remaining_isog_lists_v1;
    // step := 0;

    // for DN_list in remaining_isog_lists_v1 do 
    //     DN := DN_list[1];
    //     step := step+1;
    //     print "Step out of ", remainders_number_v1 , ": ", step;
    //     print "DN = ", DN;

    //     // initializing isog_candidates[DN] as an array indexed on the genera that
    //     // occur in this level as possibly seeing isogenies of Jacobians
    //     isog_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});


    //     // we perform explicit isogeny checks on Jacobians to finally
    //     // determine lists of isogenous Shimura curve quotients
    //     for g_list in DN_list[2] do 
    //         g := g_list[1];
    //         print "g: ", g;
    //         g_isog_candidate_lists := g_list[2];
    //         g_isog_candidate_lists_new := [* *];

    //         for candidate_list in g_isog_candidate_lists do 
    //             print "beginning new candidates list of genus g = ", g;
    //             candidate_lists_finer := [* *];
    //             isogeny_factors_info := AssociativeArray([1..#candidate_list]);
    //             for X in candidate_list do 
    //                 print "X: ", X;
    //                 print "Computing isogeny factors of X";
    //                 DecompX := isogeny_factors_from_symbols_and_dim(X[1],X[2],X[3],g);
    //                 // The above function may not have found all
    //                 // isogeny factors, in which case we compute in a more
    //                 // brute force manner and adjust the output to match that of 
    //                 // the isogeny_factors_from_symbols_and_dim output.
    //                 if Type(DecompX) eq MonStgElt then
    //                     print "Modular symbols computation insufficient, trying brute force"; 
    //                     DecompX_single_seq := IsogClassALQuotient(X[1],X[2],X[3]);
    //                     X_dim1_factors := [A : A in DecompX_single_seq | Dimension(A) eq 1];
    //                     X_larger_dim_factors := [A : A in DecompX_single_seq | not (A in X_dim1_factors)];
    //                     X_dim1_factors_ECs := [EllipticCurve(A) : A in X_dim1_factors];
    //                     DecompX := [*X_dim1_factors_ECs,X_larger_dim_factors*];
    //                 end if; 

    //                 isogeny_factors_info[Index(candidate_list,X)] := DecompX;

    //                 if IsEmpty(candidate_lists_finer) then 
                        
    //                     print "class wasn't yet represented";
    //                     Append(~candidate_lists_finer,[ X ]);
    //                 else 
    //                     X_class_found := false;
    //                     X_dim1_factors := DecompX[1];
    //                     X_larger_dim_factors := DecompX[2];

    //                     for L in candidate_lists_finer do
    //                         L_index := Index(candidate_lists_finer,L);
    //                         Y := L[1];
    //                         print "Y: ", Y;
    //                         DecompY := isogeny_factors_info[Index(candidate_list,Y)];
    //                         Y_dim1_factors := DecompY[1];
    //                         Y_larger_dim_factors := DecompY[2];

    //                         // if this check goes through, then we've found
    //                         // the equivalence class that X belongs in 
    //                         XY_non_isogenous := false;

    //                         // First we handle one-dimensional isogeny factors
    //                         print "checking elliptic curve factors";
    //                         for A in X_dim1_factors do 
    //                             found_isog := false;

    //                             for B in Y_dim1_factors do
    //                                 if IsIsogenous(A,B) then 
    //                                     found_isog := true;
    //                                     Exclude(~Y_dim1_factors,B);
    //                                     break;
    //                                 end if;
    //                             end for; 

    //                             if not found_isog then 
    //                                 XY_non_isogenous := true;
    //                                 print "not isogenous";
    //                                 break;
    //                             end if; 
    //                         end for; 

    //                         // If consideration of dimension 1 factors did not prove
    //                         // non-isogeny of X and Y, we look at larger dimensional factors
    //                         if not XY_non_isogenous then 
    //                             print "checking higher dim factors";
    //                             for A in X_larger_dim_factors do 
    //                                 found_isog := false;
    //                                 A_dim := Dimension(A);
    //                                 for B in [B : B in Y_larger_dim_factors | Dimension(B) eq A_dim] do
    //                                     if IsIsogenous(A,B) then 
    //                                         found_isog := true;
    //                                         Exclude(~Y_larger_dim_factors,B);
    //                                         break;
    //                                     end if;
    //                                 end for;

    //                                 if not found_isog then 
    //                                     XY_non_isogenous := true;
    //                                     print "not isogenous";
    //                                     break;
    //                                 end if; 
    //                             end for; 
    //                         end if; 

    //                         if not XY_non_isogenous then 
    //                             print "found class";
    //                             candidate_lists_finer[L_index] := Append(L,X);
    //                             X_class_found := true;
    //                             break;
    //                         end if; 
    //                     end for; 

    //                     // In this case, the equivalence class of X is not 
    //                     // yet represented, so we add it as a new class
    //                     if not X_class_found then 
    //                         print "class wasn't yet represented";
    //                         Append(~candidate_lists_finer,[ X ]);
    //                     end if; 
    //                 end if;
    //             end for;

    //             // Now we collect the information of the further sieved candidate lists
    //             // in g_candidate_lists_new
    //             for L in [L : L in candidate_lists_finer | #L gt 1] do 
    //                 Append(~g_isog_candidate_lists_new,L);
    //             end for; 
    //         end for;

    //         // now we append to our genus g array the info of equivalence classes 
    //         // of quotients, under isogeny, which have size > 1
    //         isog_candidates[DN][g] := g_isog_candidate_lists_new;
    //     end for;
    // end for; 


    // remaining_isog_lists_v2 := [* *];
    // index := 0;
    // // printing info to a list
    // for DN in Sort(Setseq(Keys(isog_candidates))) do 
    //     g_lists := [* *];
    //     for g in Sort(Setseq(Keys(isog_candidates[DN]))) do
    //         g_quotients_lists := isog_candidates[DN][g];
    //         if not IsEmpty(g_quotients_lists) then 
    //             Append(~g_lists, [* g, g_quotients_lists *]);
    //         end if; 
    //     end for;

    //     if not IsEmpty(g_lists) then 
    //         Append(~remaining_isog_lists_v2, [* DN, g_lists *]);
    //     end if; 
    // end for;


    // SetOutputFile("isogeny_lists_final_same_curve.m");
    // print "isogeny_lists_final_same_curve := ", remaining_isog_lists_v2, ";";
    // UnsetOutputFile(); 


//////////////////////////////////////////////
//// Table creation
//////////////////////////////////////////////

// loading back in final list in order to create a table of the information
load "isogeny_lists_final_same_curve.m";


// creating table with following columns:
//      * Discriminant D
//      * Level N
//      * Genus g
//      * Sets Wgens such that the X_0^D(N)/Wgens are isogenous of genus g
SetOutputFile("isogenies_same_curve_table.m");
for DN_list in isogeny_lists_final_same_product do 
    DN := DN_list[1];
    D_values := [D : D in Divisors(DN) | IsEven(#PrimeDivisors(D))];
    printed_level := false;
    for D in D_values do 
        // checking there are more than just genus 1 curves in this list
        if [g_list[1] : g_list in DN_list[2] | not (IsEmpty([L : L in g_list[2] | L[1][1] eq D]))] ne [1] then 
            N := Integers()!(DN/D);
            printed_D := false;
            for g_list in [g_list : g_list in DN_list[2] | g_list[1] gt 1] do 
                D_entries := [L : L in g_list[2] | L[1][1] eq D];
                
                if not (IsEmpty(D_entries)) then 
                    if not printed_level then 
                        print "$", DN, "$ & ";
                        printed_level := true;
                    else
                        print "& ";
                    end if;

                    if not printed_D then 
                        print "$", D, "$ & $", N, "$ & $", g_list[1], "$ & ";
                        printed_D := true;
                    else 
                        print "& &", "$", g_list[1], "$ & "; 
                    end if; 

                    for i in [1..#D_entries[1]-1] do 
                        curve := D_entries[1][i];
                        Wgens := Sort(Setseq(curve[3]));
                        if Wgens eq [1] then 
                            print "$\\langle \\textnormal{id} \\rangle,$ ";
                        else 
                            print "$\\langle ";
                            for i in [1..#Wgens-1] do 
                                m := Wgens[i];
                                print "w_{", m, "}, ";
                            end for;
                            print "w_{", Wgens[#Wgens], "} \\rangle,$ ";
                        end if;
                    end for;

                    curve := D_entries[1][#D_entries[1]];
                    Wgens := Sort(Setseq(curve[3]));
                    if Wgens eq [1] then 
                        print "$\\langle \\textnormal{id} \\rangle$ \\\\ \\hline";
                    else 
                        print "$\\langle ";
                        for i in [1..#Wgens-1] do 
                            m := Wgens[i];
                            print "w_{", m, "}, ";
                        end for;
                        print "w_{", Wgens[#Wgens], "} \\rangle$ \\\\ \\hline";
                    end if;


                    for j in [2..#D_entries] do 
                        print "& & & & "; 
                        for i in [1..#D_entries[j]-1] do 
                            curve := D_entries[j][i];
                            Wgens := Sort(Setseq(curve[3]));
                            if Wgens eq [1] then 
                                print "$\\langle \\textnormal{id} \\rangle,$ ";
                            else 
                                print "$\\langle ";
                                for i in [1..#Wgens-1] do 
                                    m := Wgens[i];
                                    print "w_{", m, "}, ";
                                end for;
                                print "w_{", Wgens[#Wgens], "} \\rangle,$ ";
                            end if;
                        end for;

                        curve := D_entries[j][#D_entries[j]];
                        Wgens := Sort(Setseq(curve[3]));
                        if Wgens eq [1] then 
                            print "$\\langle \\textnormal{id} \\rangle$ \\\\ \\hline";
                        else 
                            print "$\\langle ";
                            for i in [1..#Wgens-1] do 
                                m := Wgens[i];
                                print "w_{", m, "}, ";
                            end for;
                            print "w_{", Wgens[#Wgens], "} \\rangle$ \\\\ \\hline";
                        end if;
                    end for;
                end if;
            end for;
        end if;
    end for;
end for;
UnsetOutputFile();


