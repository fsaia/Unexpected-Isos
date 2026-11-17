/* In this file, we use our implementation of
reduction type computations for Atkin--Lehner quotients of
X_0^D(N) at primes p || N in order to narrow isom class
determinations for genus 2 bielliptic equations compared
to work that initiated in Padurariu--Saia 2025
and was improved in work of Assaf--Hashimoto 2026.
*/

AttachSpec("./redlib/redlib.spec");
load "genus_2_bielliptics_eqn_determined_PS_AH.m";
load "genus_2_bielliptics_eqn_not_determined_PS_AH.m";
load "dual_graphs_discriminant.m";
load "dual_graphs_level.m";


// function for sorting elements of genus_2_bielliptics_eqn_determined_PS_AH after 
// the appending that occurs below
sort_bielliptics := function(x,y)
    x := [*x[1],x[2],x[3]*];
    y := [*y[1],y[2],y[3]*];
    D_diff := x[1]-y[1];
    if D_diff ne 0 then 
        return D_diff;
    else
        N_diff := x[2]-y[2];
        if N_diff ne 0 then 
            return N_diff;
        else 
            x_gens := Sort(Setseq(x[3]));
            y_gens := Sort(Setseq(y[3]));
            subgroup_size_diff := #x_gens - #y_gens;
            if subgroup_size_diff ne 0 then 
                return subgroup_size_diff;
            else 
                distinguishing_index := Min([i : i in [1..#x_gens] | x_gens[i] ne y_gens[i]]);
                return x_gens[distinguishing_index] - y_gens[distinguishing_index];
            end if;
        end if;
    end if;
end function;


// initializing lists
genus_2_bielliptics_eqn_determined_APS := genus_2_bielliptics_eqn_determined_PS_AH;
genus_2_bielliptics_eqn_determined_by_level_red_types := [];
genus_2_bielliptics_eqn_not_determined_APS := [];
total_steps := #genus_2_bielliptics_eqn_not_determined_PS_AH;

// step counter
c := 0;

_<x> := PolynomialRing(Rationals());

for X in genus_2_bielliptics_eqn_not_determined_PS_AH do
	 
	print X;
	c := c+1;
	print "step out of ", total_steps, ": ", c;

	D := X[1];
	N := X[2];
	gens := X[3];
	hypell_eqns := X[4];

	// For p || N, we check info of the reduction type at p against 
    // that of the remaining candidate models.
	for p in [q : q in PrimeDivisors(N) | (Valuation(N,q) eq 1) and (q ne 2)] do
		
        // We check number of intersection points in minimal regular model at odd primes dividing
		// D for the bielliptic genus 2 curve to try to get rid of candidate equations. 
		print "checking at p = ", p;
        p_edges := dual_graph_at_p_edge_count_level(D,N,gens,p); 

		for h in hypell_eqns do 
			H := HyperellipticCurve(h);
			if p_edges ne #Edges(DualGraph(ReductionType(H,p))) then 
				print "handled a candidate via dual graph edge count check";
				Exclude(~hypell_eqns,h);
			end if;
		end for; 

        // exit early rather than computing more red types
        // if the job is done
        if #hypell_eqns eq 1 then 
            break;
        end if;
	end for; 

    if #hypell_eqns eq 1 then 
    	Append(~genus_2_bielliptics_eqn_determined_APS,[* D,N,gens,hypell_eqns[1]*]);
        Append(~genus_2_bielliptics_eqn_determined_by_level_red_types, [* D,N,gens,hypell_eqns[1]*]);
    else
        Append(~genus_2_bielliptics_eqn_not_determined_APS,[* D,N,gens,hypell_eqns*]);
    end if;

end for;



Sort(~genus_2_bielliptics_eqn_determined_APS,sort_bielliptics);

SetOutputFile("genus_2_bielliptics_eqn_determined_APS.m");
print "genus_2_bielliptics_eqn_determined_APS := ";
print genus_2_bielliptics_eqn_determined_APS;
print ";";
UnsetOutputFile();

SetOutputFile("genus_2_bielliptics_eqn_determined_by_level_red_types.m");
print "genus_2_bielliptics_eqn_determined_by_level_red_types := ";
print genus_2_bielliptics_eqn_determined_by_level_red_types;
print ";";
UnsetOutputFile();

SetOutputFile("genus_2_bielliptics_eqn_not_determined_APS.m");
print "genus_2_bielliptics_eqn_not_determined_APS := ";
print genus_2_bielliptics_eqn_not_determined_APS;
print ";";
UnsetOutputFile();





