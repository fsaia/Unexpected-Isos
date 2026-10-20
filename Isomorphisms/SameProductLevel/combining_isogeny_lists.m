/* A quick script for combining the isogeny
lists from the cases with D1N1=D2N2, since we 
handled this in two individual cases in the isogeny
tests and will handle them together in 
checks for isomorphisms
*/

load "isogeny_lists_final_same_curve.m";
load "isogeny_lists_final_same_product.m";

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

// function for sorting two lists containing lists with elements of the form [D1,N1,W_gens],
// just via the first elements of the lists
sort_isog_lists := function(L1,L2)
    return sort_quotient_lists(L1[1],L2[1]);
end function;


levels_same_curve := [L[1] : L in isogeny_lists_final_same_curve];
levels_same_product := [L[1] : L in isogeny_lists_final_same_product];

levels_occuring := Sort(Setseq({M : M in (levels_same_curve cat levels_same_product)}));

// Note: every level is levels_occuring is in levels_same_product, so what we do below is valid.


full_isogenies_list_fixed_product_level := [* *];

for L1 in isogeny_lists_final_same_product do 
    M := L1[1]; // product level of curves appearing in L1
    g_lists1 := L1[2];
    g_values_L1 := [g_list[1] : g_list in g_lists1];
    if M in levels_same_curve then 
        // If M is a level for which we have isogenies of quotients of the same Shimura
        // curve as well, then we go through to put elements of the same isogeny class together 
        // as needed.
        L2 := Explode([L : L in isogeny_lists_final_same_curve | L[1] eq M]);
        g_lists2 := L2[2];
        g_values_L2 := [g_list[1] : g_list in g_lists2];
        g_values_M := Sort(Setseq({g : g in g_values_L1 cat g_values_L2})); 

        // initialize list of lists in level M
        g_lists_new := [* *];
        for g in g_values_M do
            if g in g_values_L1 then 
                g_list1 := Explode([g_list : g_list in g_lists1 | g_list[1] eq g]);
                g_isog_lists1 := g_list1[2];

                if g in g_values_L2 then 
                    // initializing new list of isogenies among quotients of product level M
                    // and of genus g
                    new_g_list := [];
                    g_list2 := Explode([g_list : g_list in g_lists2 | g_list[1] eq g]);
                    g_isog_lists2 := g_list2[2];
                    encountered_from_g_isog_lists2 := [ ];
                    for isog_list1 in g_isog_lists1 do 
                        new_isog_list1 := isog_list1; // initialize with quotients in isog_list1
                        // we search for lists in g_isog_lists2 containing members of the 
                        // same isogeny class as those of isog_list1 (such lists 
                        // need not exist)
                        for isog_list2 in g_isog_lists2 do 
                            if not (IsEmpty([C : C in isog_list1 | C in isog_list2])) then 
                                Append(~encountered_from_g_isog_lists2,isog_list2);
                                for C in [C : C in isog_list2 | not (C in isog_list1)] do
                                    Append(~new_isog_list1,C);
                                end for; 
                            end if;
                        end for;
                        Sort(~new_isog_list1,sort_quotient_lists);
                        Append(~new_g_list,new_isog_list1);
                    end for;

                    // now we append any isogeny lists from g_isog_lists2 which did not contain
                    // elements of the same isogeny class as a list from g_isog_lists1
                    for isog_list2 in [isog_list : isog_list in g_isog_lists2 | not (isog_list in encountered_from_g_isog_lists2)] do
                        Append(~new_g_list,isog_list2);
                    end for;

                    // Now we sort new_g_list prior to appending 
                    Sort(~new_g_list,sort_isog_lists);

                    Append(~g_lists_new,[*g,new_g_list*]);

                else 
                    Append(~g_lists_new,g_list1);
                end if;

            else 
                g_list2 := Explode([g_list : g_list in g_lists2 | g_list[1] eq g]);
                Append(~g_lists_new,g_list2);
            end if; 

        end for; 

        Append(~full_isogenies_list_fixed_product_level,[*M, g_lists_new*]);

    else
        Append(~full_isogenies_list_fixed_product_level,L1);
    end if; 
end for;

SetOutputFile("full_isogenies_list_fixed_product_level.m");
print "full_isogenies_list_fixed_product_level := ", full_isogenies_list_fixed_product_level, ";";
UnsetOutputFile();

