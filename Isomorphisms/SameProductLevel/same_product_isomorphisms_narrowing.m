/*
In this file, we take those pairs of Atkin--Lehner quotients
X_0^{D1}(N1)/W1 and X_0^{D2}(N2)/W2)
with D1N1 = D2N2 whose Jacobians are isogenous and we
undergo checks to work to prove whether the curves
are isomorphic over \mathbb{Q}
*/

// Loading functions for working with AL subgroups and for computing 
// genera of quotients of Shimura curves. 
load "AL_identifiers.m";

// Loading lists of isogenous AL quotients among quotients in fixed product levels
load "full_isogenies_list_fixed_product_level.m";


////////////////////////////////////////////////
////// Automorphism group checks
////////////////////////////////////////////////

/*

// List of all levels M so that X_0(M)^* has genus at least 3 and has a
// non-trivial automorphism. This comes from Bars--Gonzalez 2021. 
star_has_auts_levels := [178,183,246,249,258,290,303,318,370,366,430,455,510,645];


// Loading list of pairs (D,N) with D>1 for which we know X_0^D(N)^* has 
// no non-trivial automorphisms (and hence for which each AL quotient of X_0^D(N) has
// only Atkin--Lehner automorphisms). This comes from Padurariu--Mercuri--Saia--Stirpe 2025.
load "no_involution_star_pairs_10k.m";


// Loading list of pairs (D,N) with D>1 for which we know X_0^D(N) has 
// no non-trivial automorphisms. This comes from Padurariu--Mercuri--Saia--Stirpe 2025.
load "all_atkin_lehner_10k.m";


// Sorting and excluding candidate quotients for isomorphism
// using information about Automorphism groups

total_steps := #full_isogenies_list_fixed_product_level;

print "excluding candidates using automorphism checks";

step := 0; 

// initializing iso_candidates as an associative array on the levels M=DN
// that provide possible isogenies of Jacobians 
isom_candidates := AssociativeArray([L[1] : L in full_isogenies_list_fixed_product_level]);

for DN_list in full_isogenies_list_fixed_product_level do 
    DN := DN_list[1];  
    step := step+1;
    print "Step out of ", total_steps , ": ", step;

    // initializing isom_candidates[DN] as an array indexed on the genera that
    // occur in this level as possibly seeing isomorphisms of AL quotients
    isom_candidates[DN] := AssociativeArray({g_list[1] : g_list in DN_list[2]});

    for g_list in DN_list[2] do
        g := g_list[1];
        g_curves := g_list[2];
        g_isom_candidate_pairs := [* *];

        for isog_list in g_curves do 
            // For each pair of curves in isog_list, we try to exclude
            // isomorphism of the pair using knowledge about
            // their automorphism groups 
            for i in [1..#isog_list] do
                C1 := isog_list[i];
                D1 := C1[1];
                N1 := C1[2];
                W1gens := C1[3];
                C1_all_AL := false; // initializing boolean

                if D1 gt 1 then 
                    // Checks to ensure that X_0^{D_1}(N_1)/W1 has 2^omega(DN)/|W1| auts
                    if ([D1,N1] in no_involution_star_pairs_10k) then 
                        C1_all_AL := true; 
                    elif (W1gens eq {1}) and ([D1,N1] in all_atkin_lehner_10k) then 
                        C1_all_AL := true; 
                    end if; 
                else 
                    gstar := GenusX0NQuotient(DN,PrimeDivisors(DN));
                    if (gstar ge 3) and (not (DN in star_has_auts_levels)) then 
                        C1_all_AL := true;
                    end if;
                end if;


                for j in [i+1..#isog_list] do
                    C2 := isog_list[j];
                    D2 := C2[1];
                    N2 := C2[2];
                    W2gens := C2[3];
                    C2_all_AL := false; // initializing

                    if D2 gt 1 then 
                        // Ensures that X_0^{D_2}(N_2)/W2 has 2^omega(DN)/|W2| auts
                        if ([D2,N2] in no_involution_star_pairs_10k) then 
                            C2_all_AL := true; 
                        elif (W2gens eq {1}) and ([D2,N2] in all_atkin_lehner_10k) then 
                            C2_all_AL := true; 
                        end if; 
                    else 
                        gstar := GenusX0NQuotient(DN,PrimeDivisors(DN));
                        // Ensures that X_0(D_2*N_2)/W2 has 2^omega(DN)/|W2| auts
                        if (gstar ge 3) and (not (DN in star_has_auts_levels)) then 
                            C2_all_AL := true;
                        end if;
                    end if;

                    // In this case, the AL subgroups we quotient
                    // by must have the same order in order to have isomorphism
                    if C1_all_AL and C2_all_AL then 
                        if #W1gens eq #W2gens then 
                            Append(~g_isom_candidate_pairs,[*C1,C2*]);
                        end if; 

                    // In this case we know that C1 has only AL automorphisms,
                    // and so #W1gens can be no smaller than #W2gens in order
                    // to have isomorphism
                    elif C1_all_AL then 
                        if #W1gens le #W2gens then 
                            Append(~g_isom_candidate_pairs,[*C1,C2*]);
                        end if;

                    // In this case we know that C2 has only AL automorphisms,
                    // and so #W2gens can be no smaller than #W1gens in order
                    // to have isomorphism
                    elif C2_all_AL then 
                        if #W2gens le #W1gens then 
                            Append(~g_isom_candidate_pairs,[*C1,C2*]);
                        end if;

                    // In this case we have no useful info 
                    else
                        Append(~g_isom_candidate_pairs,[*C1,C2*]);
                    end if; 

                end for; 
            end for;
        end for; 

        // now we append to our genus g array the info of pairs of quotients
        // in this genus which passed this check on isomorphism
        isom_candidates[DN][g] := g_isom_candidate_pairs;
    end for; 
end for; 

// printing info to a list
remaining_isomorphism_lists_v1 := [* *];

for DN in Sort(Setseq(Keys(isom_candidates))) do 
    g_lists := [* *];
    for g in Sort(Setseq(Keys(isom_candidates[DN]))) do
        g_quotients_lists := isom_candidates[DN][g];
        if (g gt 1) and (not IsEmpty(g_quotients_lists)) then 
            Append(~g_lists, [* g, g_quotients_lists *]);
        end if; 
    end for;

    if not IsEmpty(g_lists) then 
        Append(~remaining_isomorphism_lists_v1, [* DN, g_lists *]);
    end if; 
end for;

SetOutputFile("remaining_isomorphism_lists_same_product_v1.m");
print "remaining_isomorphism_lists_same_product_v1 := ", remaining_isomorphism_lists_v1, ";";
UnsetOutputFile(); 

*/


////////////////////////////////////////////////
////// Equation and reduction type checks
////////////////////////////////////////////////


load "remaining_isomorphism_lists_same_product_v1.m";

genera_occuring := [];
for DN_list in remaining_isomorphism_lists_same_product_v1 do 
    for g_list in DN_list[2] do 
        g := g_list[1];
        if not (g in genera_occuring) then 
            Append(~genera_occuring,g);
        end if;
    end for;
end for;
Sort(~genera_occuring);

// separating based on genus in an array
isom_candidates_by_genus := AssociativeArray(genera_occuring);

genus_2_isom_candidates := [];
genus_3_isom_candidates := [];
genus_4_isom_candidates := [];
genus_5_isom_candidates := [];
genus_6_isom_candidates := [];
genus_7_isom_candidates := [];
genus_9_isom_candidates := [];
genus_10_isom_candidates := [];
genus_11_isom_candidates := [];

for DN_list in remaining_isomorphism_lists_same_product_v1 do 
    for g_list in DN_list[2] do 
        g := g_list[1];
        if g eq 2 then 
            for pair in g_list[2] do 
                Append(~genus_2_isom_candidates,pair);
            end for;
        elif g eq 3 then 
            for pair in g_list[2] do 
                Append(~genus_3_isom_candidates,pair);
            end for;
        elif g eq 4 then 
            for pair in g_list[2] do 
                Append(~genus_4_isom_candidates,pair);
            end for;
        elif g eq 5 then 
            for pair in g_list[2] do 
                Append(~genus_5_isom_candidates,pair);
            end for;
        elif g eq 6 then 
            for pair in g_list[2] do 
                Append(~genus_6_isom_candidates,pair);
            end for;
        elif g eq 7 then 
            for pair in g_list[2] do 
                Append(~genus_7_isom_candidates,pair);
            end for;
        elif g eq 9 then 
            for pair in g_list[2] do 
                Append(~genus_9_isom_candidates,pair);
            end for;
        elif g eq 10 then 
            for pair in g_list[2] do 
                Append(~genus_10_isom_candidates,pair);
            end for;
        elif g eq 11 then 
            for pair in g_list[2] do 
                Append(~genus_11_isom_candidates,pair);
            end for;
        end if;
    end for;
end for;

all_isom_candidates := genus_2_isom_candidates cat genus_3_isom_candidates cat genus_4_isom_candidates
    cat genus_5_isom_candidates cat genus_6_isom_candidates cat genus_7_isom_candidates
    cat genus_9_isom_candidates cat genus_10_isom_candidates cat genus_11_isom_candidates;


// lists of pairs [D,N] so that X_0^D(N) has genus at least 2 and 
// has Q-gonality and Qbar-gonality, respectively, equal to 2. 
// In these cases, equations for X_0^D(N) and its AL quotients are in 
// Guo--Yang and Padurariu--Schembri, respectively. 
Q_gon_2 := [[6,11], [6,19], [6,29], [6,31], [6,37], [10,11],[10,23], [14,5], [15,2], [22,3], [22,5], [26,1], [35,1], [38,1], [39,1], [39,2] , [51,1], [55,1], [58,1], [62,1], [69,1], [74,1], [86,1], [87,1], [94,1], [95,1], [111,1], [119,1], [134,1],[146,1], [159,1], [194,1], [206,1]];
Qbar_gon_2 := [[6,17], [10,13], [10,19], [14,3], [15,4], [21,2], [26,3], [57,1], [82,1], [93,1]];


// noting which curves X_0^D(N)/W that will need to be addressed are AL quotients
// of a hyperelliptic curve X_0^D(N)
quotients_with_hyperelliptic_top_curve := [];

for pair in all_isom_candidates do 
    X := pair[1];
    Y := pair[2];

    if (not (X in quotients_with_hyperelliptic_top_curve)) and ([X[1],X[2]] in (Q_gon_2 cat Qbar_gon_2)) then 
        Append(~quotients_with_hyperelliptic_top_curve,X);
    end if; 

    if (not (Y in quotients_with_hyperelliptic_top_curve)) and ([Y[1],Y[2]] in (Q_gon_2 cat Qbar_gon_2)) then 
        Append(~quotients_with_hyperelliptic_top_curve,Y);
    end if; 
end for;


// List of models of quotients we still need to check which are quotients
// of a hyperelliptic Shimura curve X_0^D(N). These come from work of Padurariu--Schembri,
// following work of Guo--Yang. 
// Note: the equations for X_0^{39}(2)/<w_2> and X_0^{39}(2)/<w_{26}> in 
// Padurariu--Schembri are swapped, following swapping of the equations for the
// involutions w_2 and w_{26} in Guo--Yang. Similarly, there are swappings for:
//      * X_0^{14}(5)/<w_5> and X_0^{14}(5)/<w_{70}>
//      * X_0^{14}(5)/<w_{10}> and X_0^{14}(5)/<w_{35}>
//      * X_0^{6}(11)/<w_{2}> and X_0^{6}(11)/<w_{3}>
//      * X_0^{10}(13)/<w_{5}> and X_0^{10}(13)/<w_{26}>
//      * X_0^{39}(2)/<w_2,w_3> and X_0^{39}(2)/<w_3,w_{26}>
//      * X_0^{39}(2)/<w_6> and X_0^{39}(2)/<w_78>.

AS<[x]> := AffineSpace(RationalField(), 3);
quotients_of_hyperelliptic_models := [
[*6,11,{1},HyperellipticCurve([Polynomial([RationalField() | -19, 166, -439, 166, 612, -166, -439, -166, -19]), Polynomial([RationalField() |])])*],
[*6,11,{2},HyperellipticCurve([Polynomial([RationalField() | -24, 36, 35, -50, -18, 15, -5]), Polynomial([RationalField() | 0, 0, 1, 1])])*],
[*6,11,{3},HyperellipticCurve([Polynomial([RationalField() | -5, -35, -8, 48, 9, -18, -6]), Polynomial([RationalField() | 1, 1, 1])])*],
[*6,11,{11},HyperellipticCurve([Polynomial([RationalField() | -5, 89, -570, 1334, -570, 89, -5]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*6,17,{1},Curve(AS, [
17*x[1]^4 - 10*x[1]^2 - x[2]^2 + 9,
-3*x[1]^2 - x[3]^2 - 16
])*],
[*6,17,{6},HyperellipticCurve([Polynomial([RationalField() | -321, -379, -446, -143, -94, -27, -9]), Polynomial([RationalField() |])])*],
[*6,19,{6},HyperellipticCurve([Polynomial([RationalField() | 0, 19, 210, 625, 210, 19]), Polynomial([RationalField() |])])*],
[*6,29,{2},HyperellipticCurve([Polynomial([RationalField() | -52, -32, -41, 89, 74, -36, -24]), Polynomial([RationalField() |])])*],
[*6,29,{6},HyperellipticCurve([Polynomial([RationalField() | 219, -557, -210, 630, 155, -192, -64]), Polynomial([RationalField() | 1, 1, 1])])*],
[*6,31,{3},HyperellipticCurve([Polynomial([RationalField() | -31, 118, -99, -29, 1, -3, -1]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*6,31,{6},HyperellipticCurve([Polynomial([RationalField() | -43, -233, -258, 107, -258, -233, -43]), Polynomial([RationalField() |])])*],
[*6,37,{2},HyperellipticCurve([Polynomial([RationalField() | -40, 4, -30, 95, -30, 4, -40]), Polynomial([RationalField() |])])*],
[*6,37,{3},HyperellipticCurve([Polynomial([RationalField() | -7, -27, 0, 104, 0, -27, -7]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*10,11,{1},HyperellipticCurve([Polynomial([RationalField() | -512, 0, -560, 0, 120, 0, 277, 0, 30, 0, -35, 0, -8]), Polynomial([RationalField() |])])*],
[*10,11,{2},HyperellipticCurve([Polynomial([RationalField() | -40, 60, 58, -83, -100, 61, -8]), Polynomial([RationalField() |])])*],
[*10,11,{5},HyperellipticCurve([Polynomial([RationalField() | -10, 0, -43, 0, -117, 0, 31, 0, -2]), Polynomial([RationalField() | 0, 1, 0, 1])])*],
[*10,11,{11},HyperellipticCurve([Polynomial([RationalField() | -22, 0, -1079, 0, -397, 0, -49, 0, -2]), Polynomial([RationalField() | 0, 1, 0, 1])])*],
[*10,11,{5,11},HyperellipticCurve([Polynomial([RationalField() | 0, -10, -43, -117, 31, -2]), Polynomial([RationalField() | 0, 1, 1])])*],
[*10,11,{10},HyperellipticCurve([Polynomial([RationalField() | -11, 13, 6, -25, 6, 13, -11]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*10,11,{22},HyperellipticCurve([Polynomial([RationalField() | 1, 0, -2, -7, -2, 0, 1]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*10,11,{55},HyperellipticCurve([Polynomial([RationalField() | 13, -41, 21, 67, -30, -18, 5, 2]), Polynomial([RationalField() | 0, 1, 0, 1])])*],
[*10,13,{5},HyperellipticCurve([Polynomial([RationalField() | -53, 50, -172, 100, -172, 50, -53]), Polynomial([RationalField() |])])*],
[*10,19,{1},Curve(AS, [
-8*x[1]^6 + 57*x[1]^4 - 40*x[1]^2 - x[2]^2 + 16,
5*x[1]^2 - x[3]^2 - 32
])*],
[*10,19,{2},HyperellipticCurve([Polynomial([RationalField() | -185, -205, 121, 442, 121, -205, -185]), Polynomial([RationalField() | 0, 1, 1])])*],
[*10,19,{10},HyperellipticCurve([Polynomial([RationalField() | -94, 382, -416, 70, -40, 6, -2]), Polynomial([RationalField() |])])*],
[*10,19,{95},HyperellipticCurve([Polynomial([RationalField() | -12, -36, 7, 91, 55, 13, 5, 1]), Polynomial([RationalField() | 1, 0, 1, 0, 1])])*],
[*10,19,{190},HyperellipticCurve([Polynomial([RationalField() | 0, -3, 0, 2, 1, -3, 1]), Polynomial([RationalField() | 1, 1, 1])])*],
[*10,23,{2},HyperellipticCurve([Polynomial([RationalField() | -640, 0, 2212, 0, -3690, 0, 3670, 0, -2135, 0, 652, 0, -80]), Polynomial([RationalField() | 0, 0, 0, 1])])*],
[*10,23,{5},HyperellipticCurve([Polynomial([RationalField() | -940, 1588, -3657, 1599, -2928, -356, -957, -78, -574, 224, -172]), Polynomial([RationalField() | 0, 0, 1, 1])])*],
[*10,23,{2,5},HyperellipticCurve([Polynomial([RationalField() | -120, -620, -1094, -57, 333, 73, -43]), Polynomial([RationalField() |])])*],
[*10,23,{2,23},HyperellipticCurve([Polynomial([RationalField() | 0, -80, 92, 97, -25, -119, -87, 72, -11]), Polynomial([RationalField() | 0, 0, 1, 0, 1])])*],
[*10,23,{5,23},HyperellipticCurve([Polynomial([RationalField() | 5, 15, 12, -27, 1, -2]), Polynomial([RationalField() | 0, 1, 1])])*],
[*14,3,{3},HyperellipticCurve([Polynomial([RationalField() | -3, -19, -34, -32, -21, -6, -2]), Polynomial([RationalField() | 1, 1, 1])])*],
[*14,3,{6},HyperellipticCurve([Polynomial([RationalField() | 115, 76, 83, 12, 1, -6, -2]), Polynomial([RationalField() |])])*],
[*14,5,{5},HyperellipticCurve([Polynomial([RationalField() | -3, -16, -10, 41, -10, -16, -3]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*14,5,{10},HyperellipticCurve([Polynomial([RationalField() | -23, 67, 24, -181, 88, 3, -1]), Polynomial([RationalField() |])])*],
[*15,2,{1},HyperellipticCurve([Polynomial([RationalField() | -48, 0, -40, 0, -11, 0, -10, 0, -3]), Polynomial([RationalField() |])])*],
[*15,2,{2},HyperellipticCurve([Polynomial([RationalField() | -2, -8, -9, -3, -9, -8, -2]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*15,2,{5},HyperellipticCurve([Polynomial([RationalField() | 12, 24, -37, -1, 5, -3]), Polynomial([RationalField() |])])*],
[*15,2,{6},HyperellipticCurve([Polynomial([RationalField() | -16, -30, -47, -37, -26, -9, -3]), Polynomial([RationalField() | 1, 1, 1])])*],
[*21,2,{1},Curve(AS, [
-9*x[1]^6 - 89*x[1]^4 - 179*x[1]^2 - x[2]^2 + 21,
-x[1]^2 - x[3]^2 - 3
])*],
[*21,2,{6},HyperellipticCurve([Polynomial([RationalField() | 0, -7, -4, -15, -4, -7]), Polynomial([RationalField() | 0, 1, 1])])*],
[*21,2,{14},HyperellipticCurve([Polynomial([RationalField() | 15, 18, 11, -5, 11, 18, 15]), Polynomial([RationalField() | 0, 1, 1])])*],
[*22,3,{1},HyperellipticCurve([Polynomial([RationalField() | -27, 0, -308, 0, -2146, 0, -308, 0, -27]), Polynomial([RationalField() |])])*],
[*22,3,{2},HyperellipticCurve([Polynomial([RationalField() | -5, -11, -25, -27, -25, -11, -5]), Polynomial([RationalField() | 0, 1, 1])])*],
[*22,3,{6},HyperellipticCurve([Polynomial([RationalField() | 0, -11, 18, -41, 18, -11]), Polynomial([RationalField() |])])*],
[*22,3,{22},HyperellipticCurve([Polynomial([RationalField() | 2, 10, 7, -26, -15, 33, -11]), Polynomial([RationalField() | 1, 1, 1])])*],
[*22,5,{1},HyperellipticCurve([Polynomial([RationalField() | -11, 0, -80, 0, -240, 0, -362, 0, -240, 0, -80, 0, -11]), Polynomial([RationalField() |])])*],
[*22,5,{2},HyperellipticCurve([Polynomial([RationalField() | -1, -1, -7, -3, -7, -1, -1]), Polynomial([RationalField() | 0, 1, 1])])*],
[*22,5,{5},HyperellipticCurve([Polynomial([RationalField() | -29, 61, -107, 100, -78, 33, -11]), Polynomial([RationalField() | 1, 1, 1])])*],
[*22,5,{10},HyperellipticCurve([Polynomial([RationalField() | 0, 11, -80, 240, -362, 240, -80, 11]), Polynomial([RationalField() |])])*],
[*22,5,{22},HyperellipticCurve([Polynomial([RationalField() | -1024, 0, -915, 0, -311, 0, -48, 0, -3]), Polynomial([RationalField() | 0, 0, 1, 0, 1])])*],
[*22,5,{55},HyperellipticCurve([Polynomial([RationalField() | 20, 0, 14, 0, 9, 0, 7, 0, -3]), Polynomial([RationalField() | 0, 0, 1, 0, 1])])*],
[*22,5,{10,22},HyperellipticCurve([Polynomial([RationalField() | 0, 80, 56, 37, 30, -11]), Polynomial([RationalField() |])])*],
[*22,5,{11},HyperellipticCurve([Polynomial([RationalField() | -3, 3, -2, -5, 10, 15, 5]), Polynomial([RationalField() | 1, 1, 1])])*],
[*26,1,{1},HyperellipticCurve([Polynomial([RationalField() | -169, 0, -24, 0, 19, 0, -2]), Polynomial([RationalField() |])])*],
[*26,3,{3},HyperellipticCurve([Polynomial([RationalField() | -6, 0, -23, 0, -17, 0, 3, 0, -2]), Polynomial([RationalField() | 0, 1, 0, 1])])*],
[*26,3,{6},HyperellipticCurve([Polynomial([RationalField() | 46, 94, -108, 30, -20, 6, -2]), Polynomial([RationalField() |])])*],
[*26,3,{39},HyperellipticCurve([Polynomial([RationalField() | -6, 6, 19, 29, 19, 7, 3, 1]), Polynomial([RationalField() | 1, 0, 1, 0, 1])])*],
[*26,3,{78},HyperellipticCurve([Polynomial([RationalField() | 0, -1, 2, -2, 2, -1]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*35,1,{1},HyperellipticCurve([Polynomial([RationalField() | -7, 0, -1380, 0, -554, 0, -100, 0, -7]), Polynomial([RationalField() |])])*],
[*35,1,{5},HyperellipticCurve([Polynomial([RationalField() | -4, 5, 1, 1, 1, -7]), Polynomial([RationalField() | 1, 0, 1])])*],
[*39,1,{1},HyperellipticCurve([Polynomial([RationalField() | -7, -30, -21, 48, 37, -48, -21, 30, -7]), Polynomial([RationalField() |])])*],
[*39,1,{3},HyperellipticCurve([Polynomial([RationalField() | -4, 6, 1, 3, -8, -3, -2]), Polynomial([RationalField() | 1, 0, 0, 1])])*],
[*39,2,{2},HyperellipticCurve([Polynomial([RationalField() | -2, -16, -61, -135, -202, -222, -202, -135, -61, -16, -2]), Polynomial([RationalField() | 1, 0, 0, 0, 0, 1])])*],
[*39,2,{6},HyperellipticCurve([Polynomial([RationalField() | -2, 11, -28, 20, -5, 20, -28, 11, -2]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*39,2,{26},HyperellipticCurve([Polynomial([RationalField() | -2, 22, -98, 196, -157, 64, -157, 196, -98, 22, -2]), Polynomial([RationalField() | 1, 0, 0, 0, 0, 1])])*],
[*39,2,{78},HyperellipticCurve([Polynomial([RationalField() | 0, 1, 3, 5, 5, 5, 3, 1]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*39,2,{2,3},HyperellipticCurve([Polynomial([RationalField() | 0, 13, -47, 14, -4, -10, -2]), Polynomial([RationalField() | 0, 1, 1, 1])])*],
[*39,2,{3,26},HyperellipticCurve([Polynomial([RationalField() | 0, -3, -3, -2, 1, 1]), Polynomial([RationalField() | 0, 1, 1, 1])])*],
[*57,1,{1},Curve(AS, [
9*x[1]^4 + 36*x[1]^3 + 62*x[1]^2 + 20*x[1] - x[2]^2 + 1,
-4*x[1]^2 + 2*x[1] - x[3]^2 - 1
])*],
[*58,1,{1},HyperellipticCurve([Polynomial([RationalField() | -1682, 0, -862, 0, -78, 0, -2]), Polynomial([RationalField() |])])*],
[*82,1,{1}, Curve(AS, [
16*x[1]^4 - 32*x[1]^3 + 1032*x[1]^2 + 1576*x[1] - x[2]^2 + 1549,
-3*x[1]^2 - x[3]^2 - 6
]) *],
[*87,1,{3},HyperellipticCurve([Polynomial([RationalField() | -4, -16, 5, 16, -7, 0, -1]), Polynomial([RationalField() | 1, 1, 0, 1])])*],
[*93,1,{1}, Curve(AS, [
9*x[1]^6 - 18*x[1]^5 - 25*x[1]^4 - 12*x[1]^3 + 71*x[1]^2 + 30*x[1] - x[2]^2 + 9,
-4*x[1]^2 - 6*x[1] - x[3]^2 - 9
])*],
[*93,1,{93},HyperellipticCurve([Polynomial([RationalField() | 0, -2, 1, 1]), Polynomial([RationalField() | 1, 1, 0, 1])])*],
[*95,1,{5}, HyperellipticCurve([Polynomial([RationalField() | -11, 3, -31, 45, -60, 38, -23, 6, -2]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*119,1,{7}, HyperellipticCurve([Polynomial([RationalField() | 4, -9, -12, 6, 18, -2, -17, -1, 5, 3, -3]), Polynomial([RationalField() | 1, 1, 1, 0, 1, 1])])*]
];


// Code for real point checks for Shimura curve quotients

// depth_1_has_real_points: given D>1, N, and m dividing DN, returns true if
// X_0^D(N)/<w_m> has a real point and false otherwise. This check uses Ogg83 Theorem 3
// (or really, just Proposition 1 there, since we don't care to count the number of componenets
// over \R here)
depth_1_has_real_points := function(D,N,m)
    assert IsDivisibleBy(D*N,m);
    assert m gt 1;

    real_points_check := true;

    if IsSquare(m) then 
        real_points_check := false;
    else 
        places_to_check := PrimeDivisors(ExactQuotient(D*N,m));
        m_sqfree_part := sqfree_part(m);
        _,f := IsSquare(Integers()!(m/m_sqfree_part));
        if (m mod 4) eq 1 then
            disc_K := m_sqfree_part;
        else 
            disc_K := 4*m_sqfree_part;
        end if; 

        for p in places_to_check do 
            // check local embedding of Z[sqrt(m)]
            if count_local_embeddings(D,N,p,disc_K,f) eq 0 then 

                if (m mod 4) eq 1 then 
                    for p in places_to_check do 
                        // check local embedding of Z[(1+sqrt(m))/2]
                        if count_local_embeddings(D,N,p,disc_K,2*f) eq 0 then 
                            real_points_check := false;
                            break;
                        end if;
                    end for;

                else 
                    real_points_check := false;
                    break;
                end if; 
            end if; 

            // in case we are in the m = 1 (mod 4) case and found no local embeddings at p
            if real_points_check eq false then 
                break;
            end if; 
        end for; 
    end if; 

    return real_points_check;
end function; 

// X_0^D(N)/W has real points iff some depth-1 quotient has real points
quotient_has_real_points := function(D,N,W)
    if D eq 1 then 
        return true;
    else 
        for m in [m : m in W | m gt 1] do
            if depth_1_has_real_points(D,N,m) then
                return true;
            end if;
        end for;
        return false;
    end if;
end function;


//////////////////////     
// Genus 2 cases
/////////////////////

// list of equations of some bielliptic genus 2 quotients of Shimura curves
// from Padurariu--Saia 2025
load "genus_2_bielliptics_eqn_determined_final.m";

// list of candidate equations of some bielliptic genus 2 quotients of Shimura curves
// from Padurariu--Saia 2025 (for each quotient in the list, exactly one of the
// given candidate models is correct)
load "genus_2_bielliptics_eqn_not_determined_final.m";

// loading algorithms from Padurariu--Saia for computing reduction types
// and existence of local points at primes dividing D for quotients of X_0^D(N)
// with N squarefree and D>1, and also functionality for working with AL quotients.
load "dual_graphs.m";

genus_2_bielliptics_having_eqn := [];
genus_2_bielliptics_having_eqn_candidates := [];

for pair in genus_2_isom_candidates do 
    X := pair[1];
    Y := pair[2];

    X_matches_having_eqn := [L[4] : L in genus_2_bielliptics_eqn_determined_final | [*L[1],L[2],L[3]*] eq X];
    if not IsEmpty(X_matches_having_eqn) then 
        Append(~genus_2_bielliptics_having_eqn,X);
    else
        X_matches_having_eqn_candidates := [L[4] : L in genus_2_bielliptics_eqn_not_determined_final | [*L[1],L[2],L[3]*] eq X];
        if not IsEmpty(X_matches_having_eqn_candidates) then 
            Append(~genus_2_bielliptics_having_eqn_candidates,X);
        end if;
    end if;

    Y_matches_having_eqn := [L[4] : L in genus_2_bielliptics_eqn_determined_final | [*L[1],L[2],L[3]*] eq Y];
    if not IsEmpty(Y_matches_having_eqn) then 
        Append(~genus_2_bielliptics_having_eqn,Y);
    else
        Y_matches_having_eqn_candidates := [L[4] : L in genus_2_bielliptics_eqn_not_determined_final | [*L[1],L[2],L[3]*] eq Y];
        if not IsEmpty(Y_matches_having_eqn_candidates) then 
            Append(~genus_2_bielliptics_having_eqn_candidates,Y);
        end if;
    end if;
end for;


// initializing lists
genus_2_isom := [];
genus_2_isom_iff_correct_Shim_model := [];
remaining_genus_2_isom_candidates := [];

genus_2_excluded_by_real_pts := [];
genus_2_excluded_by_red_types := [];
genus_2_excluded_by_Qp_pts := [];
genus_2_excluded_by_eqns := [];


// running checks
steps := #genus_2_isom_candidates;
step := 0;

for pair in genus_2_isom_candidates do 
    step := step + 1;
    print "Step out of ", steps, ": ", step;
    print "Pair: ", pair;
    X := pair[1];
    Y := pair[2];

    // initalizing a boolean 
    proven_non_isom := false;

    // Here, we employ a simple check related to reduction types at 
    // primes dividing the level N: if p is such a prime and you quotient X_0^D(N) by 
    // a subgroup W consisting of w_m with p not dividing m then the dual graph of the 
    // special fiber at p of the quotient has two irreducible components, and otherwise
    // (if W has some w_m with p dividing m) the graph has one irreducible component.
    // This gives an easy check on \Q-isomorphism.
    D1 := X[1];
    D2 := Y[1];
    N1 := X[2];
    N2 := Y[2];
    shared_primes := {p : p in PrimeDivisors(N1) | p in PrimeDivisors(N2)};
    W1gens := X[3];
    W2gens := Y[3];
    one_comp_primes_X := {p : p in shared_primes | LCM(W1gens) mod p eq 0};
    one_comp_primes_Y := {p : p in shared_primes | LCM(W2gens) mod p eq 0};
    if not (one_comp_primes_X eq one_comp_primes_Y) then 
        print "proven non-isomorphic by reductions types at prime dividing levels";
        proven_non_isom := true;
        Append(~genus_2_excluded_by_red_types,pair);
    end if;

    if not proven_non_isom then 

        // Here we check existence of real points
        print "checking real points";
        if quotient_has_real_points(D1,N1,gens_to_identifier(D1*N1,W1gens)) ne quotient_has_real_points(D2,N2,gens_to_identifier(D2*N2,W2gens)) then 
            print "proven non-isomorphic by existence of real points";
            proven_non_isom := true;
            Append(~genus_2_excluded_by_real_pts,pair);
        end if;

        // We check info of reduction types for Shimura curves at primes dividing
        // both discriminants using the algorithm of Padurariu--Saia 2026. We do this
        // earlier for higher genus because direct isomorphism checks with models often
        // seem to take longer. 
        if not proven_non_isom then 
            print "checking reduction type info at primes dividing discriminants";
            edge_counts_X := Kodaira_from_dual(D1,N1,W1gens);
            edge_counts_Y := Kodaira_from_dual(D2,N2,W2gens);
            for p in [p : p in PrimeDivisors(D1) | p in PrimeDivisors(D2)] do 
                p_edges_X := Explode([pair[2] : pair in edge_counts_X | pair[1] eq p]);
                p_edges_Y := Explode([pair[2] : pair in edge_counts_Y | pair[1] eq p]);
                if p_edges_X ne p_edges_Y then 
                    print "proven non-isomorphic by reduction types at a prime dividing both discriminants";
                    proven_non_isom := true;
                    Append(~genus_2_excluded_by_red_types,pair);
                    break;
                elif quotient_has_Qp_points(D1,N1,W1gens,p) ne quotient_has_Qp_points(D2,N2,W2gens,p) then 
                    print "proven non-isomorphic by exactly one curve lacking local points at a prime dividing both discriminants";
                    proven_non_isom := true;
                    Append(~genus_2_excluded_by_Qp_pts,pair);
                    break;
                end if;
            end for;
        end if;

        // For a prime p dividing one discriminant D_i and not the other D_j, hence dividing N_j,
        // we know that each irreducible component of the special fiber of X_0^{D_j}(N_j)/W_j
        // at p must be genus 0 from Cerednik--Drinfeld reduction theory. Furthermore, 
        // we know that each such component is isomorphic to X_0^{D_j}(N_j/p)/H_j,
        // where H_j is the image of W_j in Aut(X_0^{D_j}(N_j/p)) under the natural map. 
        if not proven_non_isom then 
            for p in [p : p in PrimeDivisors(D1) | not (p in PrimeDivisors(D2))] do
                Hgens := [];
                for m in [m : m in W1gens | m gt 1] do 
                    if (m mod p eq 0) then 
                        if (m/p gt 1) then 
                            Append(~Hgens,Integers()!(m/p));
                        end if;
                    else
                        Append(~Hgens,m);
                    end if;
                end for;

                if D2 eq 1 then 
                    g_components := GenusX0NQuotient(Integers()!(N2/p),Hgens);
                else 
                    g_components := quot_genus(D2,Integers()!(N2/p),gens_to_identifier(Integers()!(D2*N2/p),Seqset(Hgens)));
                end if;

                if g_components ne 0 then 
                    print "proven non-isomorphic by reduction types at prime dividing D1 and N2";
                    proven_non_isom := true;
                    Append(~genus_2_excluded_by_red_types,pair);
                    break;
                end if;
            end for;
        end if; 

        if not proven_non_isom then 
            for p in [p : p in PrimeDivisors(D2) | not (p in PrimeDivisors(D1))] do
                Hgens := [];
                for m in [m : m in W1gens | m gt 1] do 
                    if (m mod p eq 0) then 
                        if (m/p gt 1) then 
                            Append(~Hgens,Integers()!(m/p));
                        end if;
                    else
                        Append(~Hgens,m);
                    end if;
                end for;

                if D1 eq 1 then 
                    g_components := GenusX0NQuotient(Integers()!(N1/p),Hgens);
                else 
                    g_components := quot_genus(D1,Integers()!(N1/p),gens_to_identifier(Integers()!(D1*N1/p),Seqset(Hgens)));
                end if;

                if g_components ne 0 then 
                    print "proven non-isomorphic by reduction types at prime dividing D2 and N1";
                    proven_non_isom := true;
                    Append(~genus_2_excluded_by_red_types,pair);
                    break;
                end if;
            end for;
        end if; 

        if not proven_non_isom then
            // This is the case where exactly one of the curves has D=1. In this case, we will check reduction types
            // against the modular curve separately using Tim Dokchitser's package for hyperelliptic curves
            // in a separate file, but here we check whether the Shimura curve quotient can be seen
            // to lack a rational point by local means at a prime dividing the discriminant.
            if (X[1] eq 1) and (Y[1] gt 1) then  
                print "have one modular curve and one non-modular curve; checking local points";
                Y := pair[2];
                D := Y[1];
                N := Y[2];
                Wgens := Y[3];
                for p in PrimeDivisors(D) do 
                    if not (quotient_has_Qp_points(D,N,Wgens,p)) then
                        print "proven non-isomorphic by local points check"; 
                        proven_non_isom := true;
                        Append(~genus_2_excluded_by_Qp_pts,pair);
                        break;
                    end if;
                end for;
            end if;
        end if;
    end if;


    // If the above checks did not succeed in concluding the quotients were
    // not isomorphic over \Q, then we test isomorphism using models if we have them
    if not proven_non_isom then 

        // initializing boolean trackers
        have_X_model := false;
        have_X_model_candidates := false;
        have_Y_model := false;
        have_Y_model_candidates := false;

        // Checking if we have a model or candidate models for X
        if X[1] eq 1 then // modular curve quotient case 
            have_X_model := true;
            N := X[2];
            Wgens := X[3];
            if Wgens eq {1} then 
                X_model := ModularCurveQuotient(N,[]);
            else 
                X_model := ModularCurveQuotient(N,Setseq(Wgens));
            end if;

        elif X in genus_2_bielliptics_having_eqn then 
            have_X_model := true;
            X_eqn := Explode([L[4] : L in genus_2_bielliptics_eqn_determined_final | [*L[1],L[2],L[3]*] eq X]);
            X_model := HyperellipticCurve(X_eqn);

        elif X in quotients_with_hyperelliptic_top_curve then 
            have_X_model := true;
            X_model := Explode([L[4] : L in quotients_of_hyperelliptic_models | [*L[1],L[2],L[3]*] eq X]);

        elif X in genus_2_bielliptics_having_eqn_candidates then 
            have_X_model_candidates := true;
            X_eqn_candidates := Explode([L[4] : L in genus_2_bielliptics_eqn_not_determined_final | [*L[1],L[2],L[3]*] eq X]);
        end if;

        // Checking if we have a model or candidate models for Y
        if Y[1] eq 1 then // modular curve quotient case 
            have_Y_model := true;
            N := Y[2];
            Wgens := Y[3];
            if Wgens eq {1} then 
                Y_model := ModularCurveQuotient(N,[]);
            else 
                Y_model := ModularCurveQuotient(N,Setseq(Wgens));
            end if;

        elif Y in genus_2_bielliptics_having_eqn then 
            have_Y_model := true;
            Y_eqn := Explode([L[4] : L in genus_2_bielliptics_eqn_determined_final | [*L[1],L[2],L[3]*] eq Y]);
            Y_model := HyperellipticCurve(Y_eqn);

        elif Y in quotients_with_hyperelliptic_top_curve then 
            have_Y_model := true;
            Y_model := Explode([L[4] : L in quotients_of_hyperelliptic_models | [*L[1],L[2],L[3]*] eq Y]);

        elif Y in genus_2_bielliptics_having_eqn_candidates then 
            have_Y_model_candidates := true;
            Y_eqn_candidates := Explode([L[4] : L in genus_2_bielliptics_eqn_not_determined_final | [*L[1],L[2],L[3]*] eq Y]);
        end if;

        // running through checks for isomorphism over \mathbb{Q} when we have an equation
        // or candidate equations for both curves
        if have_X_model and have_Y_model then 
            print "have models for both, checking isomorphism";
            if IsIsomorphic(X_model,Y_model) then 
                Append(~genus_2_isom,pair);
            else 
                Append(~genus_2_excluded_by_eqns,pair);
            end if;

        elif have_X_model and have_Y_model_candidates then 
            print "have models for X and candidate models for Y, checking isomorphism";
            found_isom_candidate := false;
            for eqn in Y_eqn_candidates do
                Y_model := HyperellipticCurve(eqn);
                if IsIsomorphic(X_model,Y_model) then 
                    found_isom_candidate := true;
                    isom_eqn := eqn;
                    break;
                end if; 
            end for; 

            if found_isom_candidate then 
                Append(~genus_2_isom_iff_correct_Shim_model,[*pair,2,isom_eqn*]);
                Append(~remaining_genus_2_isom_candidates,pair);
            else 
                Append(~genus_2_excluded_by_eqns,pair);
            end if; 

        elif have_Y_model and have_X_model_candidates then 
            print "have models for Y and candidate models for X, checking isomorphism";
            found_isom_candidate := false;
            for eqn in X_eqn_candidates do
                X_model := HyperellipticCurve(eqn);
                if IsIsomorphic(X_model,Y_model) then 
                    found_isom_candidate := true;
                    isom_eqn := eqn;
                    break;
                end if; 
            end for; 

            if found_isom_candidate then 
                Append(~genus_2_isom_iff_correct_Shim_model,[*pair,1,isom_eqn*]);
                Append(~remaining_genus_2_isom_candidates,pair);
            else 
                Append(~genus_2_excluded_by_eqns,pair);
            end if; 

        elif have_X_model_candidates and have_Y_model_candidates then 
            print "have candidate models for both, checking isomorphism";
            found_isom_candidate := false;
            isom_eqn_pairs := [];
            for eqn_X in X_eqn_candidates do
                X_model := HyperellipticCurve(eqn_X);
                for eqn_Y in Y_eqn_candidates do 
                    Y_model := HyperellipticCurve(eqn_Y);
                    if IsIsomorphic(X_model,Y_model) then 
                        found_isom_candidate := true;
                        Append(~isom_eqn_pairs,[eqn_X,eqn_Y]);
                    end if;
                end for; 
            end for; 

            if found_isom_candidate then 
                Append(~genus_2_isom_iff_correct_Shim_model,[*pair,isom_eqn_pairs*]);
                Append(~remaining_genus_2_isom_candidates,pair);
            else 
                Append(~genus_2_excluded_by_eqns,pair);
            end if;

        else 
            print "no models, unsuccessful check :(";
            Append(~remaining_genus_2_isom_candidates,pair);
        end if;

    end if;
end for;

SetOutputFile("remaining_genus_2_isom_candidates_v1.m");
print "remaining_genus_2_isom_candidates_v1 := ", remaining_genus_2_isom_candidates, ";";
UnsetOutputFile();

SetOutputFile("genus_2_isom.m");
print "genus_2_isom := ", genus_2_isom, ";";
UnsetOutputFile();

SetOutputFile("genus_2_isom_iff_correct_Shim_model.m");
print "genus_2_isom_iff_correct_Shim_model := ", genus_2_isom_iff_correct_Shim_model, ";";
UnsetOutputFile();

SetOutputFile("genus_2_excluded_by_real_pts.m");
print "genus_2_excluded_by_real_pts := ", genus_2_excluded_by_real_pts, ";";
UnsetOutputFile();

SetOutputFile("genus_2_excluded_by_Qp_pts.m");
print "genus_2_excluded_by_Qp_pts := ", genus_2_excluded_by_Qp_pts, ";";
UnsetOutputFile();

SetOutputFile("genus_2_excluded_by_red_types.m");
print "genus_2_excluded_by_red_types := ", genus_2_excluded_by_red_types, ";";
UnsetOutputFile();

SetOutputFile("genus_2_excluded_by_eqns.m");
print "genus_2_excluded_by_eqns := ", genus_2_excluded_by_eqns, ";";
UnsetOutputFile();



//////////////////////     
// Genus >= 3 cases
/////////////////////

// initializing lists
higher_genus_isom_candidates := genus_3_isom_candidates cat genus_4_isom_candidates cat
    genus_5_isom_candidates cat genus_6_isom_candidates cat 
    genus_7_isom_candidates cat genus_9_isom_candidates cat genus_10_isom_candidates cat 
    genus_11_isom_candidates;
higher_genus_isom := [];
remaining_higher_genus_isom_candidates := [];

higher_genus_excluded_by_real_pts := [];
higher_genus_excluded_by_red_types := [];
higher_genus_excluded_by_Qp_pts := [];
higher_genus_excluded_by_eqns := [];

// running checks
steps := #higher_genus_isom_candidates;
step := 0;

for pair in higher_genus_isom_candidates do 
    step := step + 1;
    print "Step out of ", steps, ": ", step;
    print "Pair: ", pair;
    X := pair[1];
    Y := pair[2];

    // initalizing a boolean 
    proven_non_isom := false;

    // Here, we employ a simple check related to reduction types at 
    // primes dividing the level N: if p is such a prime and you quotient X_0^D(N) by 
    // a subgroup W consisting of w_m with p not dividing m then the dual graph of the 
    // special fiber at p of the quotient has two irreducible components, and otherwise
    // (if W has some w_m with p dividing m) the graph has one irreducible component.
    // This gives an easy check on \Q-isomorphism.
    D1 := X[1];
    D2 := Y[1];
    N1 := X[2];
    N2 := Y[2];
    shared_primes := {p : p in PrimeDivisors(N1) | p in PrimeDivisors(N2)};
    W1gens := X[3];
    W2gens := Y[3];
    one_comp_primes_X := {p : p in shared_primes | LCM(W1gens) mod p eq 0};
    one_comp_primes_Y := {p : p in shared_primes | LCM(W2gens) mod p eq 0};
    if not (one_comp_primes_X eq one_comp_primes_Y) then 
        print "proven non-isomorphic by reductions types at prime dividing levels";
        proven_non_isom := true;
        Append(~higher_genus_excluded_by_red_types,pair);
    end if;

    if not proven_non_isom then 

        // Here we check existence of real points
        print "checking real points";
        if quotient_has_real_points(D1,N1,gens_to_identifier(D1*N1,W1gens)) ne quotient_has_real_points(D2,N2,gens_to_identifier(D2*N2,W2gens)) then 
            print "proven non-isomorphic by existence of real points";
            proven_non_isom := true;
            Append(~higher_genus_excluded_by_real_pts,pair);
        end if;

        // We check info of reduction types for Shimura curves at primes dividing
        // the discriminant using the algorithm of Padurariu--Saia 2026. We do this
        // earlier for higher genus because direct isomorphism checks with models often
        // seem to take longer. 
        if not proven_non_isom then 
            print "checking reduction type info at primes dividing discriminants";
            edge_counts_X := Kodaira_from_dual(D1,N1,W1gens);
            edge_counts_Y := Kodaira_from_dual(D2,N2,W2gens);
            for p in [p : p in PrimeDivisors(D1) | p in PrimeDivisors(D2)] do 
                p_edges_X := Explode([pair[2] : pair in edge_counts_X | pair[1] eq p]);
                p_edges_Y := Explode([pair[2] : pair in edge_counts_Y | pair[1] eq p]);
                if p_edges_X ne p_edges_Y then 
                    print "proven non-isomorphic by reduction types at a prime dividing both discriminants";
                    proven_non_isom := true;
                    Append(~higher_genus_excluded_by_red_types,pair);
                    break;
                elif quotient_has_Qp_points(D1,N1,W1gens,p) ne quotient_has_Qp_points(D2,N2,W2gens,p) then 
                    print "proven non-isomorphic by exactly one curve lacking local points at a prime dividing both discriminants";
                    proven_non_isom := true;
                    Append(~higher_genus_excluded_by_Qp_pts,pair);
                    break;
                end if;
            end for;
        end if;

        // For a prime p dividing one discriminant D_i and not the other D_j, hence dividing N_j,
        // we know that each irreducible component of the special fiber of X_0^{D_j}(N_j)/W_j
        // at p must be genus 0 from Cerednik--Drinfeld reduction theory. Furthermore, 
        // we know that each such component is isomorphic to X_0^{D_j}(N_j/p)/H_j,
        // where H_j is the image of W_j in Aut(X_0^{D_j}(N_j/p)) under the natural map. 
        if not proven_non_isom then 
            for p in [p : p in PrimeDivisors(D1) | not (p in PrimeDivisors(D2))] do
                Hgens := [];
                for m in [m : m in W2gens | m gt 1] do 
                    if (m mod p eq 0) then 
                        if (m/p gt 1) then 
                            Append(~Hgens,Integers()!(m/p));
                        end if;
                    else
                        Append(~Hgens,m);
                    end if;
                end for;

                if D1 eq 1 then 
                    g_components := GenusX0NQuotient(Integers()!(N2/p),Hgens);
                else 
                    g_components := quot_genus(D2,Integers()!(N2/p),gens_to_identifier(Integers()!(D2*N2/p),Seqset(Hgens)));
                end if;

                if g_components ne 0 then 
                    print "proven non-isomorphic by reduction types at prime dividing D1 and N2";
                    proven_non_isom := true;
                    Append(~higher_genus_excluded_by_red_types,pair);
                    break;
                end if;
            end for;
        end if; 

        if not proven_non_isom then 
            for p in [p : p in PrimeDivisors(D2) | not (p in PrimeDivisors(D1))] do
                Hgens := [];
                for m in [m : m in W1gens | m gt 1] do 
                    if (m mod p eq 0) then 
                        if (m/p gt 1) then 
                            Append(~Hgens,Integers()!(m/p));
                        end if;
                    else
                        Append(~Hgens,m);
                    end if;
                end for;

                if D1 eq 1 then 
                    g_components := GenusX0NQuotient(Integers()!(N1/p),Hgens);
                else 
                    "p: ", p;
                    g_components := quot_genus(D1,Integers()!(N1/p),gens_to_identifier(Integers()!(D1*N1/p),Seqset(Hgens)));
                end if;

                if g_components ne 0 then 
                    print "proven non-isomorphic by reduction types at prime dividing D2 and N1";
                    proven_non_isom := true;
                    Append(~higher_genus_excluded_by_red_types,pair);
                    break;
                end if;
            end for;
        end if; 
        
        // This case only occurs if exactly one of the curves has D=1. In this case, we will check reduction types
        // against the modular curve separately using Tim Dokchitser's package for hyperelliptic curves
        // in a separate file, but here we check whether the Shimura curve quotient can be seen
        // to lack a rational point by local means at a prime dividing the discriminant.
        if not proven_non_isom then
            if (D1 eq 1) and (D2 gt 1) then  
                print "have one modular curve and one non-modular curve; checking local points";
                Y := pair[2];
                D := Y[1];
                N := Y[2];
                Wgens := Y[3];
                for p in PrimeDivisors(D) do 
                    if not (quotient_has_Qp_points(D,N,Wgens,p)) then
                        print "proven non-isomorphic by local points check"; 
                        proven_non_isom := true;
                        Append(~higher_genus_excluded_by_Qp_pts,pair);
                        break;
                    end if;
                end for;
            end if;
        end if;
    end if;


    // If the above checks did not succeed in concluding the quotients were
    // not isomorphic over \Q, then we test isomorphism using models if we have them
    if not proven_non_isom then 
    
        // initializing boolean trackers
        have_X_model := false;
        have_Y_model := false;

        // Checking if we have a model for X
        if X[1] eq 1 then // modular curve quotient case 
            have_X_model := true;
            N := X[2];
            Wgens := X[3];
            if Wgens eq {1} then 
                X_model := ModularCurveQuotient(N,[]);
            else 
                X_model := ModularCurveQuotient(N,Setseq(Wgens));
            end if;

        elif X in quotients_with_hyperelliptic_top_curve then 
            have_X_model := true;
            X_model := Explode([L[4] : L in quotients_of_hyperelliptic_models | [*L[1],L[2],L[3]*] eq X]);
        end if;

        // Checking if we have a model or candidate models for Y
        if Y[1] eq 1 then // modular curve quotient case 
            have_Y_model := true;
            N := Y[2];
            Wgens := Y[3];
            if Wgens eq {1} then 
                Y_model := ModularCurveQuotient(N,[]);
            else 
                Y_model := ModularCurveQuotient(N,Setseq(Wgens));
            end if;

        elif Y in quotients_with_hyperelliptic_top_curve then 
            have_Y_model := true;
            Y_model := Explode([L[4] : L in quotients_of_hyperelliptic_models | [*L[1],L[2],L[3]*] eq Y]);
        end if;

        // running through checks for isomorphism over \mathbb{Q} when we have an equation
        // or candidate equations for both curves
        if have_X_model and have_Y_model then 
            print "have models for both, checking isomorphism";
            if IsIsomorphic(X_model,Y_model) then 
                Append(~higher_genus_isom,pair);
            else 
                Append(~higher_genus_excluded_by_eqns,pair);
            end if;
        else 
            print "no models, unsuccessful check :(";
            Append(~remaining_higher_genus_isom_candidates,pair);
        end if;

    end if;
end for;

SetOutputFile("remaining_higher_genus_isom_candidates_v1.m");
print "remaining_higher_genus_isom_candidates_v1 := ", remaining_higher_genus_isom_candidates, ";";
UnsetOutputFile();

SetOutputFile("higher_genus_isom.m");
print "higher_genus_isom := ", higher_genus_isom, ";";
UnsetOutputFile();

SetOutputFile("higher_genus_excluded_by_real_pts.m");
print "higher_genus_excluded_by_real_pts := ", higher_genus_excluded_by_real_pts, ";";
UnsetOutputFile();

SetOutputFile("higher_genus_excluded_by_Qp_pts.m");
print "higher_genus_excluded_by_Qp_pts := ", higher_genus_excluded_by_Qp_pts, ";";
UnsetOutputFile();

SetOutputFile("higher_genus_excluded_by_red_types.m");
print "higher_genus_excluded_by_red_types := ", higher_genus_excluded_by_red_types, ";";
UnsetOutputFile();

SetOutputFile("higher_genus_excluded_by_eqns.m");
print "higher_genus_excluded_by_eqns := ", higher_genus_excluded_by_eqns, ";";
UnsetOutputFile();


// Noting that none of the quotients with discriminant D>1 among 
// remaining isomorphism pairs are ones for which we noted we have equations
// (nothing is printed from the below loops). 
for pair in remaining_genus_2_isom_candidates do 
    X := pair[1];
    Y := pair[2];
    if X in genus_2_bielliptics_having_eqn cat genus_2_bielliptics_having_eqn_candidates cat quotients_with_hyperelliptic_top_curve then 
        print X;
    end if;

    if Y in genus_2_bielliptics_having_eqn cat genus_2_bielliptics_having_eqn_candidates cat quotients_with_hyperelliptic_top_curve then 
        print Y;
    end if;
end for;

for pair in remaining_higher_genus_isom_candidates do 
    X := pair[1];
    Y := pair[2];
    if X in quotients_with_hyperelliptic_top_curve then 
        print X;
    end if;

    if Y in quotients_with_hyperelliptic_top_curve then 
        print Y;
    end if;
end for;


// Here we individually remove some remaining isomorphism candidate pairs
// where one of the quotients is a quotient of a modular curve and we compute 
// a difference in reduction types at an odd prime. This is done separately 
// using Tim Dokchitser's package, since we do not load that in here.

// Reduction type disagreement at p=5
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 70,
    { 2, 7 }
*], [* 35, 2,
    { 2, 5 }
*] *]);

// Reduction type disagreement at p=7
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 70,
    { 2, 7 }
*], [* 35, 2,
    { 5, 14 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 70,
    { 7, 10 }
*], [* 35, 2,
    { 2, 5 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 70,
    { 7, 10 }
*], [* 35, 2,
    { 5, 14 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 85,
    { 5, 17 }
*], [* 85, 1,
    { 85 }
*] *]);

// Reduction type disagreement at p=3
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 165,
    { 3, 5, 11 }
*], [* 15, 11,
    { 11, 15 }
*] *]);

// Reduction type disagreement at p=3
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 165,
    { 3, 5, 11 }
*], [* 33, 5,
    { 5, 33 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 255,
    { 3, 5, 17 }
*], [* 85, 3,
    { 3, 85 }
*] *]);

// Reduction type disagreement at p=3
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 330,
    { 2, 3, 5, 11 }
*], [* 15, 22,
    { 2, 11, 15 }
*] *] );

// Reduction type disagreement at p=3
Exclude(~remaining_genus_2_isom_candidates,[* [* 1, 330,
    { 2, 3, 5, 11 }
*], [* 33, 10,
    { 2, 5, 33 }
*] *] );


SetOutputFile("remaining_genus_2_isom_candidates_v2.m");
print "remaining_genus_2_isom_candidates_v2 := ", remaining_genus_2_isom_candidates, ";";
UnsetOutputFile();

// Reduction type disagreement at p=5
Exclude(~remaining_higher_genus_isom_candidates,[* [* 1, 70,
    { 14 }
*], [* 35, 2,
    { 70 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_higher_genus_isom_candidates,[* [* 1, 105,
    { 3, 5 }
*], [* 35, 3,
    { 3, 7 }
*] *]);

// Reduction type disagreement at p=5
Exclude(~remaining_higher_genus_isom_candidates,[* [* 1, 110,
    { 2, 11 }
*], [* 55, 2,
    { 2, 5 }
*] *]);

SetOutputFile("remaining_higher_genus_isom_candidates_v2.m");
print "remaining_higher_genus_isom_candidates_v2 := ", remaining_higher_genus_isom_candidates, ";";
UnsetOutputFile();


remaining_isom_candidates := remaining_genus_2_isom_candidates cat remaining_higher_genus_isom_candidates;

sort_pairs := function(pair1,pair2)
    X1 := pair1[1];
    X2 := pair2[1];

    D_diff := X1[1]-X2[1];
    if D_diff ne 0 then 
        return D_diff;
    else
        N_diff := X1[2]-X2[2];
        if N_diff ne 0 then 
            return N_diff;
        else 
            // try sort by Wgens
            X1_gens := Sort(Setseq(X1[3]));
            X2_gens := Sort(Setseq(X2[3]));
            subgroup_size_diff := #X1_gens - #X2_gens;
            if subgroup_size_diff ne 0 then 
                return subgroup_size_diff;
            else 
                distinguishing_indices := [i : i in [1..#X1_gens] | X1_gens[i] ne X2_gens[i]];
                if not IsEmpty(distinguishing_indices) then 
                    distinguishing_index := Min(distinguishing_indices);
                    return X1_gens[distinguishing_index] - X2_gens[distinguishing_index];
                else 
                    Y1 := pair1[2];
                    Y2 := pair2[2];

                    D_diff := Y1[1]-Y2[1];
                    if D_diff ne 0 then 
                        return D_diff;
                    else
                        N_diff := Y1[2]-Y2[2];
                        if N_diff ne 0 then 
                            return N_diff;
                        else 
                            // try sort by Wgens
                            Y1_gens := Sort(Setseq(Y1[3]));
                            Y2_gens := Sort(Setseq(Y2[3]));
                            subgroup_size_diff := #Y1_gens - #Y2_gens;
                            if subgroup_size_diff ne 0 then 
                                return subgroup_size_diff;
                            else 
                                distinguishing_indices := [i : i in [1..#Y1_gens] | Y1_gens[i] ne Y2_gens[i]];
                                distinguishing_index := Min(distinguishing_indices);
                                return Y1_gens[distinguishing_index] - Y2_gens[distinguishing_index];
                            end if;
                        end if;
                    end if;
                end if; 
            end if;
        end if;
    end if;
end function;

Sort(~remaining_isom_candidates,sort_pairs);

// creating table with following columns for remaining candidates for \Q isomorphism:
//      * Discriminant D1
//      * Level N1
//      * AL subgroup generators W1gens
//      * Discriminant D2
//      * Level N2
//      * AL subgroup generators W2gens
//      * Genus g

/*
SetOutputFile("remaining_isomorphism_candidates_table.m");
for pair in remaining_isom_candidates do 
    X := pair[1];
    Y := pair[2];
    Xgens := Sort(Setseq(X[3]));
    Ygens := Sort(Setseq(Y[3]));

    print "$", X[1], "$ & $", X[2], "$ & $ \\langle";
    if Xgens eq [1] then 
        print "\\textnormal{id} \\rangle $ & ";
    else
        for i in [1..(#Xgens-1)] do 
            m := Xgens[i];
            print "w_{", m, "}, ";
        end for;
        print "w_{", Xgens[#Xgens], "} \\rangle $ & ";
    end if;

    print "$", Y[1], "$ & $", Y[2], "$ & $\\langle";
    if Ygens eq [1] then 
        print "\\textnormal{id} \\rangle $ & ";
    else
        for i in [1..(#Ygens-1)] do 
            m := Ygens[i];
            print "w_{", m, "}, ";
        end for;
        print "w_{", Ygens[#Ygens], "} \\rangle $ & $ ";
    end if;

    print quot_genus(Y[1],Y[2],gens_to_identifier(Y[1]*Y[2],Y[3])), "$ \\\\ \\hline";
end for;
UnsetOutputFile();

*/







