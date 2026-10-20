# Unexpected-Isos
This repository contains Magma code related to the paper *Unexpected isogenies and isomorphisms between quotients of modular and Shimura curves* by Nikola Adžaga, Oana Padurariu, and Frederick Saia.


## LowGenusModular

Computations of Atkin--Lehner quotients of $X_0^D(N)$ of genus $0$ and $1$, which combined with 2026 work of Padurariu--Saia in the $D>1$ case allow us to restrict to genus $g \geq 2$ elsewhere in this work. 

- `low_genus_modular_checks`: In this file, we determine all quotients $X_0(N)/W$, with $W <= W_0(1,N)$, having genus $0$ and $1$. We also determine the isomorphism classes of the 
genus $1$ quotients. Surely this is known, and it follows relatively easily from the determination of star quotients of genera $0$ and $1$ as found in work of González--Lario, but perhaps it is not cleanly written down anywhere else in full.    

- `genus_0_modular_quotients.m`: List of information on all quotients $X_0(N)/W$, with $N$ squarefree and with $W \leq W_0(1,N)$, having genus $0$.  

- `genus_1_modular_quotients.m`: List of information on all quotients $X_0(N)/W$, with $N$ squarefree and with $W \leq W_0(1,N)$, having genus $1$.  

- `genus_1_modular_quotient_isom_classes.m`: List of isomorphism classes over $\mathbb{Q}$ of all quotients listed in `genus_1_modular_quotients.m`.   


## Isogenies/DifferentProductLevel

Pairs $X_0^{D_1}(N_1)/W_1$, $X_0^{D_2}(N_2)/W_2$ with $D_1N_1 \neq D_2N_2$ and $D_1D_2 > 1$.
Run in this order (each as `magma -s file.m`; output in the matching `.log`):

1. `distinct_products_isogeny_filters.m`: genus, level and point-count sieves; writes the 3599 candidates to `isogenous_pairs__different_products.m`.
2. `provers1.m`: genus-1 lookup, the two lemmas and transitive closure; proves 2938 isogenies (`isogenous_pairs_first_part.m`) and leaves 661 (`pairs_for_direct_check.m`).
3. `distinct_levels_direct_final_candidates.m`: full isogeny decomposition of the 661; all are isogenous (`direct_isogenous_pairs_general.m`; `direct_excluded_by_isogeny_general.m` is empty).

Modular pairs ($D_1 = D_2 = 1$, $N_1 \neq N_2$): `distinct_levels_for_isogenies_of_modular_quotients.m` sieves to 739 candidates and finds 150 isogenous pairs (`isogenous_modular_quotients_different_levels.m`).

External data: `counting_points.m` loads `tracesALL.m` (744 MB, stored with Git LFS) from `Point Counts/` in [ShimuraPointCounts](https://github.com/fsaia/ShimuraPointCounts); copy it into this folder before step 1. `genus_1_jacobian_isog_classes.m` is taken from [GenusAtMost2](https://github.com/fsaia/GenusAtMost2).


## Isogenies/SameProductLevel

Checks for isogenous Jacobians among pairs $X_0^{D_1}(N_1)/W_1$, $X_0^{D_2}(N_2)/W_2$ with $D_1N_1 = D_2N_2$ and $D_1 \neq D_2$.

- `same_product_isogeny_genus_checks.m`: In this file, we use some initial restrictions on levels admitting isogenies of the form $\text{Jac}(X_0^{D_1}(N_1)/W_1) \sim \text{Jac}(X_0^{D_1}(N_1)/W_2)$, with $D_1 N_1 = D_2 N_2$ and $D_1 \neq D_2$, to reduce to consideration of finitely many levels. We compute the genera of all Atkin--Lehner quotients at these levels as a first, coarse check on isogeny.  

- `same_product_genus_matches.m`: List of information on genus matches among candidate quotients for having Jacobian isogenous to that of another quotient with $D_1 N_1=D_2 N_2$ and $D_1 \neq D_2$, as computed in `same_product_isogeny_genus_checks.m`.  

- `same_product_isogenies_narrowing.m`: In this file, we take the candidates quotients for having isogenous Jacobians from `same_product_genus_matches.m` and use finer checks to exclude the possibility of isogeny, until we have a reasonably sized list to explicitly compute isogeny factors and complete the classification.  

- `same_product_remaining_isog_lists_vi.m` for $i = 1,2,3$: These lists contain further narrowed candidates for isogenous Jacobians for increased $i$, and are computed in `same_product_isogenies_narrowing.m` en route to the final list `isogeny_lists_final_same_product.m`.  

- `isogeny_lists_final_same_product.m`: List of information on all pairs of quotients $X_0^{D_1}(N_1)/W_1$ and $X_0^{D_2}(N_1)/W_2$, with $D_1N_1 = D_2 N_2$ and $D1 \neq D2$, with isogenous Jacobians. Computed in `same_product_isogenies_narrowing.m`.  


## Isogenies/SameCurve

Checks for isogenous Jacobians among pairs $X_0^{D}(N)/W_1$, $X_0^{D}(N)/W_2$.  

- `same_curve_isogeny_genus_checks.m`: In this file, we use some initial restrictions on levels admitting isogenies of the form $\text{Jac}(X_0^{D}(N)/W_1) \sim \text{Jac}(X_0^{D}(N)/W_2)$ to reduce to consideration of finitely many levels. We compute the genera of all Atkin--Lehner quotients at these levels as a first, coarse check on isogeny.  

- `same_curve_genus_matches.m`: List of information on genus matches among candidate quotients for having Jacobian isogenous to that of another quotient with $D_1 = D_2$ and $N_1 = N_2$, as computed in `same_curve_isogeny_genus_checks.m`.  

- `same_curve_isogenies_narrowing.m`: In this file, we take the candidates quotients for having isogenous Jacobians from `same_curve_genus_matches.m` and use finer checks to exclude the possibility of isogeny, until we have a reasonably sized list to explicitly compute isogeny factors and complete the classification.  

- `same_curve_remaining_isog_lists_vi.m`: for $i = 1,2,3$: These lists contain further narrowed candidates for isogenous Jacobians for increased $i$, and are computed in `same_curve_isogenies_narrowing.m` en route to the final list `isogeny_lists_final_same_curve.m`.  

- `isogeny_lists_final_same_curve.m`: List of information on all pairs of quotients $X_0^{D}(N)/W_1$ and $X_0^{D}(N)/W_2$ with isogenous Jacobians. 


## Isomorphisms/SameProductLevel 

- `combining_isogeny_lists.m`: A quick script for combining the isogeny lists from the cases with $D_1 N_1=D_2 N_2$, since we handled this in two individual cases in the isogenytests and will handle them together in checks for isomorphisms.

- `full_isogenies_list_fixed_product_level.m`: List of information on all pairs of quotients $X_0^{D_1}(N_1)/W_1$ and
$X_0^{D_2}(N_2)/W_2$, with $D_1 N_1 = D_2 N_2$, with
isogenous Jacobians. Each list element is a list of the form [ $M$, g_lists], where each element of g_lists 
is then a list of the form [ $g$, isog_lists], and each element of isog_lists is a list $L$ containing elements
[ $D$, $N$, Wgens] corresponding to quotients $X_0^{D}(N)/W$, with $W = \langle \{w_m | m \text{ in Wgens} \} \rangle$, of genus $g$ and level $DN = M$, such that all curves in $L$ have isogenous Jacobians.  

- `same_product_isomorphisms_narrowing.m`: In this file, we take those pairs of Atkin--Lehner quotients with $D_1 N_1 = D_2 N_2$ whose Jacobians are isogenous and we undergo checks to work to prove whether the curves are isomorphic over $\mathbb{Q}$. 

- `remaining_isomorphism_lists_same_product_v1.m`: This is an intermediate list of candidate pairs of quotients for isomorphism, in the $D_1 N_1=D_2 N_2$ case, after we narrow down initial candidates using knowledge of automorphisms of quotients.

- `genus_2_isom.m`: Here we list all pairs of Atkin--Lehner quotients $X_0^{D_1}(N_1)/W_1$ and $X_0^{D_2}(N_2)/W_2$ of genus $2$ with $D_1 N_1 = D_2 N_2$ which we have proved to be isomorphic over $\mathbb{Q}$. 

- `higher_genus_isom.m`: Here we list all pairs of Atkin--Lehner quotients $X_0^{D_1}(N_1)/W_1$ and $X_0^{D_2}(N_2)/W_2$ of genus $g>2$ with $D_1 N_1 = D_2 N_2$ which we have proved to be isomorphic over $\mathbb{Q}$. 

- `remaining_genus_2_isom_candidates_v2.m`: Here we list all pairs of Atkin--Lehner quotients $X = X_0^{D_1}(N_1)/W_1$ and $Y = X_0^{D_2}(N_2)/W_2$ of genus $2$ for which we have not yet proven whether $X$ and $Y$ are isomorphic over $\mathbb{Q}$.  

- `remaining_higher_genus_isom_candidates_v2.m`: Here we list all pairs of Atkin--Lehner quotients $X = X_0^{D_1}(N_1)/W_1$ and $Y = X_0^{D_2}(N_2)/W_2$ of genus $g>2$ for which we have not yet proven whether $X$ and $Y$ are isomorphic over $\mathbb{Q}$.  


## Isomorphisms/DifferentProductLevel 


## Auxiliary Files

- `AL_identifiers.m`, `quot_genus.m`, `ribet_isog.m`, and
`dual_graphs.m`: Functionality for working with Atkin--Lehner subgroups, computing genera of quotients of Shimura curves, computing isogeny factors of Jacobians of such quotients, and computing reductions type information for such quotients at primes dividing the discriminant. Code is borrowed from prior work of the second and third named authors (in particular, from https://github.com/fsaia/GenusAtMost2).  

- `genus_2_bielliptics_eqn_determined_final.m` and `genus_2_bielliptics_eqn_not_determined_final.m`: lists containing information on models for bielliptic genus 2 curves, coming from the same work referenced in the prior item. See the comments on the individual files, or the linked repository, for details.  

- `PPV_info.m`: This file contains information on squarefree levels, and specific sign patterns in those levels, lacking newforms. All information contained here comes from the main results of Padurariu--Park--Voight 2026.  

- `counting_points.m` and `tracesALL.m`: Functionality for computing finite field point counts of Atkin--Lehner quotients of Shimura curves, and trace data required for these computations up to large level. This code comes from work of the second and third named authors along with Pietro Mercuri and Claudio Stirpe (https://github.com/fsaia/ShimuraPointCounts).  

- `all_atkin_lehner_10k.m` and `no_involution_star_pairs_10k.m`: lists containing information on Atkin--Lehner quotients of Shimura curves with no non--Atkin--Lehner automorphisms, from the same work and repository referenced in the prior item. See the comments on the individual files, or the linked repository, for details.  


