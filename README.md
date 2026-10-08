# Unexpected-Isos
This repository contains Magma code related to the paper *Unexpected isogenies and isomorphisms between quotients of modular and Shimura curves* by Nikola Adžaga, Oana Padurariu, and Frederick Saia.

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

- `same_product_isogeny_genus_checks.m`: In this file, we use some initial restrictions on levels admitting isogenies of the form $Jac(X_0^{D_1}(N_1)/W_1) \sim Jac(X_0^{D_1}(N_1)/W_2)$, with $D_1 N_1 = D_2 N_2$ and $D_1 \neq D_2$, to reduce to consideration of finitely many levels. We compute the genera of all Atkin--Lehner quotients at these levels as a first, coarse check on isogeny.  

- `same_product_genus_matches.m`: List of information on genus matches among candidate quotients for having Jacobian isogenous to that of another quotient with $D_1 N_1=D_2 N_2$ and $D_1 \neq D_2$, as computed in `same_product_isogeny_genus_checks.m`.  

- `same_product_isogenies_narrowing.m`: In this file, we take the candidates quotients for having isogenous Jacobians from `same_product_genus_matches.m` and use finer checks to exclude the possibility of isogeny, until we have a reasonably sized list to explicitly compute isogeny factors and complete the classification.  

- `same_product_remaining_isog_lists_vi.m` for $i = 1,2,3$: These lists contain further narrowed candidates for isogenous Jacobians for increased $i$, and are computed in `same_product_isogenies_narrowing.m` en route to the final list `isogeny_lists_final_same_product.m`.  

- `isogeny_lists_final_same_product.m`: List of information on all pairs of quotients $X_0^{D_1}(N_1)/W_1$ and $X_0^{D_2}(N_1)/W_2$, with $D_1N_1 = D_2 N_2$ and $D1 \neq D2$, with isogenous Jacobians. Computed in `same_product_isogenies_narrowing.m`.  


## Isogenies/SameCurve

Checks for isogenous Jacobians among pairs $X_0^{D}(N)/W_1$, $X_0^{D}(N)/W_2$.  

- `same_curve_isogeny_genus_checks.m`: In this file, we use some initial restrictions on levels admitting isogenies of the form $Jac(X_0^{D}(N)/W_1) \sim Jac(X_0^{D}(N)/W_2)$ to reduce to consideration of finitely many levels. We compute the genera of all Atkin--Lehner quotients at these levels as a first, coarse check on isogeny.  

- `same_curve_genus_matches.m`: List of information on genus matches among candidate quotients for having Jacobian isogenous to that of another quotient with $D_1 = D_2$ and $N_1 = N_2$, as computed in `same_curve_isogeny_genus_checks.m`.  

- `same_curve_isogenies_narrowing.m`: In this file, we take the candidates quotients for having isogenous Jacobians from `same_curve_genus_matches.m` and use finer checks to exclude the possibility of isogeny, until we have a reasonably sized list to explicitly compute isogeny factors and complete the classification.  

- `same_curve_remaining_isog_lists_vi.m` for $i = 1,2,3$: These lists contain further narrowed candidates for isogenous Jacobians for increased $i$, and are computed in `same_curve_isogenies_narrowing.m` en route to the final list `isogeny_lists_final_same_curve.m`.  

- `isogeny_lists_final_same_curve.m`: List of information on all pairs of quotients $X_0^{D}(N)/W_1$ and $X_0^{D}(N)/W_2$ with isogenous Jacobians. 
