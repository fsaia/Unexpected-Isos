# (c) Tim Dokchitser, redlib library, v3.1, October 2024, https://people.maths.bris.ac.uk/~matyd/redlib/
#
# Example file for the curve reduction type library in python 

from redtype import ReductionType, ReductionTypes, DualGraph

# Print all Kodaira types and number of reduction types in genus 2 and 3
print("g=1:",ReductionTypes(1, elliptic=True))
print("g=2:",ReductionTypes(2, countonly=True),"types")
print("g=3:",ReductionTypes(3, countonly=True),"types")

# Convert dual graph <-> reduction type <-> label for Type I1*
R = ReductionType("I1*")
print(R.DualGraph())
G = DualGraph([2,1,1,2,1,1], [0,0,0,0,0,0], [[1,2],[1,3],[1,4],[4,5],[4,6]])
print(ReductionType(G))

# Genus 43 type
R43 = ReductionType("III=(3)III-{2-2}II-{6-12}18g2^6,12")
print(R43.Genus())
