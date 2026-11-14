load "dual_graphs_level.m";
load "counting_points.m";

existence_of_Qp_points_level := function(D, N, p, Wgens) 
  if D eq 1 then return true; end if;

  // X_0^D(N)/W with D the discriminant of an indefinite quaternion algebra, gcd(D,N) = 1 and p || N;
  // Wgens: any generators of W (sequence or set)
  error if GCD(D, N) ne 1, "D and N must be coprime";
  error if N mod p ne 0 or (N div p) mod p eq 0, "p must divide N exactly once";
  if D eq 1 then return true; end if;   // rational cusps
  error if not IsSquarefree(D) or IsOdd(#PrimeDivisors(D)), "D must be the discriminant of an indefinite quaternion algebra";

  
  assert N mod p eq 0;
  M := ExactQuotient(N, p);
  assert M mod p ne 0;

  W := gens_to_identifier(D*N, Wgens);

  // #C(F_p) for C = X_0^D(M)/W', W' = { w_m in W : p does not divide m }
  Wprime := [ m : m in W | m mod p ne 0 ];
  if Integers()!quot_genus(D, M, Wprime) eq 0 then
    CFp := p + 1;   // C is P^1 over F_p (shipoints is not intended for genus 0)
  else
    // shipoints wants each w_m as the set of positions of the primes of m among PrimeDivisors(D*M)
    primes := PrimeDivisors(D*M);
    ALprimes := [ { Index(primes, q) : q in PrimeDivisors(m) } : m in Wprime | m ne 1 ];
    _, CFp := shipoints(p, D, M, traces_to_forms(dataByLevel, p, D, M) : ALprimes:=ALprimes, m:=1, eps:=3);
    CFp := CFp[1];
  end if;
    
  T, R, perm := level_quotient_nodes(D, N, p, Wgens);
  is_node_rational := [ is_node_Fp_rational(perm, p, W, i) : i in R ];
  
  c := component_count(D, N, p, Wgens);
  
  rational_node_indices := [i : i in [1..#R] | is_node_rational[i]];
  
  if c eq 2 then
    // if some F_p-rational node has thickness >= 2, output true
    if exists{node : node in rational_node_indices | T[node] ge 2} then
      return true;
    end if;
    
    F := #rational_node_indices;
    
    return (F lt CFp);
  else //1 component case
    if exists{node : node in rational_node_indices | T[node] mod 2 eq 0} then
      return true;
    else
      for node in [i : i in rational_node_indices | (T[i] mod 2 eq 1 and T[i] ge 3)] do
        if is_node_split(perm, p, W, R[node]) then
          return true;
        end if;
      end for;
      
      F := 2 * #[i : i in rational_node_indices | is_node_split(perm, p, W, R[i])];
    
      return (F lt CFp);
    end if;
  end if;
end function;