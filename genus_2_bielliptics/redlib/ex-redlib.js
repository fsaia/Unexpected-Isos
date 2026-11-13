// (c) Tim Dokchitser, redlib library, v3.1, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/
//
// Example file for the curve reduction type library in standalone javascript

import redlib from './redtype.ts';

// Print all Kodaira types and number of reduction types in genus 2 and 3
console.log("g=1:", redlib.ReductionTypes(1, {elliptic: true}).map(R => R.Label()));
console.log("g=2:", redlib.ReductionTypes(2, {countonly: true}), "types");
console.log("g=3:", redlib.ReductionTypes(3, {countonly: true}), "types");

// Convert dual graph <-> reduction type <-> label for Type I1*
var R = redlib.ReductionType("I1*");
console.log(R.DualGraph().toString());
var G = redlib.DualGraph([2, 1, 1, 2, 1, 1], [0, 0, 0, 0, 0, 0], [[1, 2], [1, 3], [1, 4], [4, 5], [4, 6]]);
console.log(redlib.ReductionType(G).Label());

// Genus 43 type
var R43 = redlib.ReductionType("III=(3)III-{2-2}II-{6-12}18g2^6,12");
console.log(R43.Genus());
