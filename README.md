# Unexpected-Isos
This repository contains Magma code related to the paper *Unexpected isogenies and isomorphisms between quotients of modular and Shimura curves* by Nikola Adžaga, Oana Padurariu, and Frederick Saia.

## Isogenies/Different product level

Pairs $X_0^{D_1}(N_1)/W_1$, $X_0^{D_2}(N_2)/W_2$ with $D_1N_1 \neq D_2N_2$ and $D_1D_2 > 1$.
Run in this order (each as `magma -s file.m`; output in the matching `.log`):

1. `distinct_products_isogeny_filters.m`: genus, level and point-count sieves; writes the 3599 candidates to `isogenous_pairs__different_products.m`.
2. `provers1.m`: genus-1 lookup, the two lemmas and transitive closure; proves 2938 isogenies (`isogenous_pairs_first_part.m`) and leaves 661 (`pairs_for_direct_check.m`).
3. `distinct_levels_direct_final_candidates.m`: full isogeny decomposition of the 661; all are isogenous (`direct_isogenous_pairs_general.m`; `direct_excluded_by_isogeny_general.m` is empty).

Modular pairs ($D_1 = D_2 = 1$, $N_1 \neq N_2$): `distinct_levels_for_isogenies_of_modular_quotients.m` sieves to 739 candidates and finds 150 isogenous pairs (`isogenous_modular_quotients_different_levels.m`).

External data: `counting_points.m` loads `tracesALL.m` (744 MB, stored with Git LFS) from `Point Counts/` in [ShimuraPointCounts](https://github.com/fsaia/ShimuraPointCounts); copy it into this folder before step 1. `genus_1_jacobian_isog_classes.m` is taken from [GenusAtMost2](https://github.com/fsaia/GenusAtMost2).
