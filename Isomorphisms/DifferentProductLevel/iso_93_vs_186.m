SetMemoryLimit(40 * 1024^3);
// Run from the top folder Unexpected-Isos (copy this file there):
//   nohup magma -s iso_93_vs_186.m > iso_93_vs_186.log &
//
// X_0(93)/<w_93> and X_0(186)/<w_3,w_62> are isomorphic over Q. Both have genus 4, and
// X0NQuotient gives their canonical models in P^3.

X93  := X0NQuotient(93, [93]);
X186 := X0NQuotient(186, [3, 62]);
R<x1,x2,x3,x4> := CoordinateRing(AmbientSpace(X93));

// the explicit isomorphism over Q
phi := map< X93 -> X186 | [x3, x1, x2, -x4] >;
assert IsIsomorphism(phi);
print "X_0(93)/<w_93> and X_0(186)/<w_3,w_62> are isomorphic over Q via (x1:x2:x3:x4) -> (x3:x1:x2:-x4)";


// How we found it. IsIsomorphic over Q needs too much memory, but over F_p it is quick.
// Both models are canonical, so an isomorphism is induced by a matrix M in PGL_4; we read M
// off from the images of F_p-points and lift its entries to Q. The original
// combined several primes by CRT and rational reconstruction;
// here the entries turn out to be 0 and +-1, so one prime suffices.

// the matrix M (up to scalars) with M*P proportional to iso(P) for the F_p-points P of C1
MatrixOfIso := function(C1, iso)
    rows := [];
    for P in Points(C1) do
        try a := Eltseq(P); b := Eltseq(iso(P)); catch e continue; end try;
        // (M*a)_i b_j - (M*a)_j b_i = 0, linear in the entries m_kl of M
        for i, j in [1..4] do
            if i lt j then
                Append(~rows, [ (k eq i select b[j] else k eq j select -b[i] else 0) * a[l] : k, l in [1..4] ]);
            end if;
        end for;
    end for;
    K := Kernel(Transpose(Matrix(rows)));
    assert Dimension(K) eq 1;
    return Matrix(4, 4, Eltseq(K.1));
end function;

p := 29;
C1 := ChangeRing(X93, GF(p));
C2 := ChangeRing(X186, GF(p));
for iso in Isomorphisms(C1, C2) do
    M := MatrixOfIso(C1, iso);
    M := M / [m : m in Eltseq(M) | m ne 0][1];   // first nonzero entry 1
    // balanced lift of the entries to Z
    A := Matrix(Integers(), 4, 4, [ (z gt p div 2) select z - p else z where z := Integers()!m : m in Eltseq(M) ]);
    try
        psi := map< X93 -> X186 | [ &+[A[i,j]*R.j : j in [1..4]] : i in [1..4] ] >;
        if IsIsomorphism(psi) then
            print "lift of an isomorphism mod", p, "works over Q, with matrix"; print A;
        end if;
    catch e
        ;
    end try;
end for;

quit;
