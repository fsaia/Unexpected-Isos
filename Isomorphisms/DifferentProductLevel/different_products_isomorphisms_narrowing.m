SetMemoryLimit(40 * 1024^3);
// Runs the whole pipeline for isomorphisms between AL quotients of different product levels.
// Run from the top folder Unexpected-Isos (copy this file there):
//   nohup magma -s different_products_isomorphisms_narrowing.m > different_products_isomorphisms_narrowing.log &
// The five steps can also be run on their own (in this order,
// but only because their input/output files assume this order).

load "reduction_type_different_products.m";
load "local_points_check.m";
load "Fp_isomorphism_check.m";
load "final_test_q_isomorphism.m";
load "genus1_label_comparison.m";

quit;
