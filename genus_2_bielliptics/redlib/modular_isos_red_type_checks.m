// Loading package of Tim Dokchitser for computing reduction
// types at odd primes of bad reduction
AttachSpec("redlib.spec");  

load "remaining_iso_candidates_v4.m";

// Genus 2 case

// loading algorithms from Padurariu--Saia for computing reduction types
// and existence of local points at primes dividing D for quotients of X_0^D(N)
// with N squarefree and D>1. 
load "dual_graphs.m";

for L in g2_iso_candidates do 
    D := L[1];
    N := L[2];
    Wgens := L[4];
    Hgens := L[5];

    // Y = X_0(DN)/H
    Y := SimplifiedModel(ModularCurveQuotient(D*N,Setseq(Hgens)));

    // Computes number of intersection points in minimal regular model of 
    // X_0^D(N)/W at primes dividing D 
    edge_counts := Kodaira_from_dual(D,N,Wgens); 

    for p in [p : p in PrimeDivisors(D) | p ne 2] do 
        p_edges := Explode([pair[2] : pair in edge_counts | pair[1] eq p]);
        // Using Dokchitser package 
        if p_edges ne #Edges(DualGraph(ReductionType(Y,p))) then 
            print "handled a candidate via dual graph edge count check";
            print L;
            Exclude(~g2_iso_candidates,L);
            break;
        end if;
    end for;
end for; 


// Genus 3 case /////////////////////////////////////////////////////////////////////

// each remaining genus 3 candidate pair is hyperelliptic,
// so Dokchitser's package can compute reduction types at odd primes
for L in g3_iso_candidates do 
    D := L[1];
    N := L[2];
    Wgens := L[4];
    Hgens := L[5];

    // Y = X_0(DN)/H
    Y := SimplifiedModel(ModularCurveQuotient(D*N,Setseq(Hgens)));

    // Computes number of intersection points in minimal regular model of 
    // X_0^D(N)/W at primes dividing D 
    edge_counts := Kodaira_from_dual(D,N,Wgens); 

    for p in [p : p in PrimeDivisors(D) | p ne 2] do 
        p_edges := Explode([pair[2] : pair in edge_counts | pair[1] eq p]);
        if p_edges ne #Edges(DualGraph(ReductionType(Y,p))) then 
            print "handled a candidate via dual graph edge count check";
            print L;
            Exclude(~g3_iso_candidates,L);
            break;
        end if;
    end for;
end for; 


// SetOutputFile("remaining_iso_candidates_v5.m");
// print "g2_iso_candidates := ", g2_iso_candidates, ";";
// print "g3_iso_candidates := ", g3_iso_candidates, ";";
// UnsetOutputFile();


