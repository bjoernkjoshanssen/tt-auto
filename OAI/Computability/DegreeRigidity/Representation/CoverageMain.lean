module

public import OAI.Computability.DegreeRigidity.Representation.CategoryMain
public import OAI.Computability.DegreeRigidity.Computability.DegreeCoverage

-- Palomar port: module visibility updated; mathematical declarations retained.
set_option backward.privateInPublic true
set_option backward.proofsInPublic true

@[expose] public section

namespace OAI

namespace TuringRigidity

theorem main_of_representation (hrep : BorelRepresentation) : MainTheorem :=
  main_of_two_obligations hrep irrational_degree_coverage

end TuringRigidity

end OAI
