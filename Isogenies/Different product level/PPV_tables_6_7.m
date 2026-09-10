// PPV levels: squarefree N for which X_0(N) or a quotient gains primes of
// good reduction (includes genus-0-star quotients of X_0(N)).

PPV_Ns := {
    2, 3, 5, 6, 7, 10, 11, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31,
    33, 34, 35, 38, 39, 41, 42, 46, 47, 51, 55, 59, 62, 66, 69, 70, 71, 74,
    78, 86, 87, 94, 95, 105, 110, 111, 114, 119, 130, 134, 146, 159, 170,
    174, 182, 186, 194, 195, 206, 222, 230, 231, 255, 266, 330, 546
};

// Modular good-prime gain: for N listed, X_0(N)/W (W a genus-0-star AL subgroup)
// gains the given primes of good reduction.
ModularGoodPrimeData := [
    <74,{2}>, <86,{2}>, <111,{3}>, <114,{2}>, <130,{2}>, <134,{2}>,
    <146,{2}>, <159,{3}>, <170,{2}>, <174,{3}>, <182,{2}>, <186,{2}>,
    <194,{2}>, <195,{3}>, <206,{2}>, <222,{2,3}>, <230,{2}>, <231,{3}>,
    <255,{3}>, <266,{2}>, <330,{2}>, <546,{2}>
];

ModularGoodPrimesByN := AssociativeArray();
for t in ModularGoodPrimeData do
    ModularGoodPrimesByN[t[1]] := t[2];
end for;

// Shimura good-prime gain: <N, D, primes> means X_0^D(N) or a quotient
// gains the listed primes of good reduction.
ShimuraGoodPrimeData := [
    <91,2,{2}>, <123,2,{2}>, <133,2,{2}>, <141,2,{2}>, <145,2,{2}>,
    <155,2,{2}>, <177,2,{2}>, <187,2,{2}>, <213,2,{2}>, <217,2,{2}>,
    <247,2,{2}>, <259,2,{2}>, <267,2,{2}>, <301,2,{2}>, <1155,2,{2}>,
    <1365,2,{2}>, <1995,2,{2}>,

    <142,3,{3}>, <145,3,{3}>, <158,3,{3}>, <205,3,{3}>, <1430,3,{3}>,
    <91,5,{5}>,
    <65,6,{3}>, <85,6,{3}>, <91,6,{2}>, <115,6,{2}>, <133,6,{2}>,

    <57,10,{2}>, <77,10,{2}>, <93,10,{2}>,

    <51,14,{2}>, <38,15,{3}>, <46,21,{3}>, <33,26,{2}>,

    <21,34,{2}>, <35,34,{2}>, <39,34,{2}>,
    <15,46,{2}>, <21,46,{2}>,
    <14,51,{3}>, <21,58,{2}>, <15,74,{2}>,
    <14,85,{5}>, <14,93,{3}>, <10,141,{3}>
];

ShimuraGoodPrimesByPair := AssociativeArray();
for t in ShimuraGoodPrimeData do
    ShimuraGoodPrimesByPair[<t[1], t[2]>] := t[3];
end for;
