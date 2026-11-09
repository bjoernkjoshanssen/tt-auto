module

public import OAI.Computability.DegreeRigidity.Computability.CutArithmetic
public import OAI.Computability.DegreeRigidity.Computability.EffectiveRecovery

-- Palomar port: module visibility updated; mathematical declarations retained.
set_option backward.privateInPublic true
set_option backward.proofsInPublic true

@[expose] public section

namespace OAI

namespace TuringRigidity

theorem main_of_three_obligations (hrep : BorelRepresentation)
    (hcover : IrrationalDegreeCoverage) (havoid : CategoryAvoidance) : MainTheorem :=
  main_of_obligations hrep cut_arithmetic hcover four_value_recovery havoid

end TuringRigidity

end OAI
