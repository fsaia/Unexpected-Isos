AttachSpec("redlib.spec");

Q:=Rationals();
R<x>:=PolynomialRing(Q);
C:=HyperellipticCurve(x^9+10);
ReductionType(C,2);             // uses Delta_v-regular machinery at p=2
ReductionType(C,3);             // and Muselli's algorithm at p>2
ReductionType(C,5);             // bad reduction at 3 and 5
ReductionType(C,7);             // and good reduction at 7
