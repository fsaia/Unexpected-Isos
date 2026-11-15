// Models of Atkin--Lehner quotients whose top curve X_0^D(N) is hyperelliptic, from
// Guo--Yang and Padurariu--Schembri. Extracted verbatim from the inline list in
// Isomorphism checks same product level/isomorphisms_narrowing.m, lines 284-395,
// so that it can be loaded on its own. Entries are [* D, N, Wgens, curve *].

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
[*87,1,{3},HyperellipticCurve([Polynomial([RationalField() | -4, -16, 5, 16, -7, 0, -1]), Polynomial([RationalField() | 1, 1, 0, 1])])*],
[*93,1,{93},HyperellipticCurve([Polynomial([RationalField() | 0, -2, 1, 1]), Polynomial([RationalField() | 1, 1, 0, 1])])*],
[*15,2,{1},HyperellipticCurve([Polynomial([RationalField() | -48, 0, -40, 0, -11, 0, -10, 0, -3]), Polynomial([RationalField() |])])*],
[*21,2,{1}, Curve(AS, [
-9*x[1]^6 - 89*x[1]^4 - 179*x[1]^2 - x[2]^2 + 21,
-x[1]^2 - x[3]^2 - 3
]) *],
[*35,1,{1},HyperellipticCurve([Polynomial([RationalField() | -7, 0, -1380, 0, -554, 0, -100, 0, -7]), Polynomial([RationalField() |])])*],
[*39,1,{1},HyperellipticCurve([Polynomial([RationalField() | -7, -30, -21, 48, 37, -48, -21, 30, -7]), Polynomial([RationalField() |])])*],
[*39,2,{6}, HyperellipticCurve([Polynomial([RationalField() | -2, 11, -28, 20, -5, 20, -28, 11, -2]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*39,2,{78}, HyperellipticCurve([Polynomial([RationalField() | 0, 1, 3, 5, 5, 5, 3, 1]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*57,1,{1}, Curve(AS, [
9*x[1]^4 + 36*x[1]^3 + 62*x[1]^2 + 20*x[1] - x[2]^2 + 1,
-4*x[1]^2 + 2*x[1] - x[3]^2 - 1
]) *],
[*82,1,{1}, Curve(AS, [
16*x[1]^4 - 32*x[1]^3 + 1032*x[1]^2 + 1576*x[1] - x[2]^2 + 1549,
-3*x[1]^2 - x[3]^2 - 6
]) *],
[*93,1,{1}, Curve(AS, [
9*x[1]^6 - 18*x[1]^5 - 25*x[1]^4 - 12*x[1]^3 + 71*x[1]^2 + 30*x[1] - x[2]^2 + 9,
-4*x[1]^2 - 6*x[1] - x[3]^2 - 9
])*],
[*95,1,{5}, HyperellipticCurve([Polynomial([RationalField() | -11, 3, -31, 45, -60, 38, -23, 6, -2]), Polynomial([RationalField() | 1, 1, 1, 1, 1])])*],
[*119,1,{7}, HyperellipticCurve([Polynomial([RationalField() | 4, -9, -12, 6, 18, -2, -17, -1, 5, 3, -3]), Polynomial([RationalField() | 1, 1, 1, 0, 1, 1])])*],

// Level 1 equations of Molina, from Molina_sols.txt. Each is a genus 2 quotient
// X_0^D(1)/<w_m>. The polynomials are given there in factored form; they are expanded
// into coefficient lists here so as to match the entries above.
// Note that X_0^35(1)/<w_5> already appears above with a different model, so the two
// give an independent check on one another. SANITY CHECK DONE
[*35,1,{5},HyperellipticCurve([Polynomial([RationalField() | 0, -28, -415, -2456, -7248, -10636, -6192]), Polynomial([RationalField() |])])*],
[*51,1,{17},HyperellipticCurve([Polynomial([RationalField() | 0, 204, 212, -144, -199, -66, -7]), Polynomial([RationalField() |])])*],
[*57,1,{3},HyperellipticCurve([Polynomial([RationalField() | -869508, 745224, -265487, 50264, -5330, 300, -7]), Polynomial([RationalField() |])])*],
[*65,1,{13},HyperellipticCurve([Polynomial([RationalField() | 5, -40, 112, -118, 16, 24, -7]), Polynomial([RationalField() |])])*],
[*65,1,{5},HyperellipticCurve([Polynomial([RationalField() | -2412, -6448, -6695, -3470, -949, -130, -7]), Polynomial([RationalField() |])])*],
[*69,1,{23},HyperellipticCurve([Polynomial([RationalField() | 0, -12, -43, -54, 53, 0, -4]), Polynomial([RationalField() |])])*],
[*85,1,{5},HyperellipticCurve([Polynomial([RationalField() | -54796, 90840, -48371, 12230, -1625, 110, -3]), Polynomial([RationalField() |])])*],
// y^2 = (x^2 - 3x + 1)*(x^4 + x^3 - 15x^2 + 20x - 8), taken from Molina's table rather
// than from Molina_sols.txt, which lists only the w_5 quotient of this curve.
[*85,1,{85},HyperellipticCurve([Polynomial([RationalField() | -8, 44, -83, 66, -17, -2, 1]), Polynomial([RationalField() |])])*],

// The two genus 3 rows of Molina's table are the level 1 curves themselves, with W
// trivial, rather than quotients of them.
//   X_0^39(1) : y^2 = -(7x^4 + 79x^3 + 311x^2 + 497x + 277)*(x^4 + 9x^3 + 29x^2 + 39x + 19)
//   X_0^55(1) : y^2 = -(3x^4 - 32x^3 + 130x^2 - 237x + 163)*(x^4 - 8x^3 + 34x^2 - 83x + 81)
// Note that X_0^39(1) already appears above with a different model, so as with
// X_0^35(1)/<w_5> the two give a check on one another; being genus 3, that check needs
// Shioda rather than Igusa invariants.
[*39,1,{1},HyperellipticCurve([Polynomial([RationalField() | -5263, -20246, -33325, -30536, -16983, -5860, -1225, -142, -7]), Polynomial([RationalField() |])])*],
[*55,1,{1},HyperellipticCurve([Polynomial([RationalField() | -13203, 32726, -35743, 22744, -9378, 2614, -488, 56, -3]), Polynomial([RationalField() |])])*]
];
