module

public import OAI.Computability.DegreeRigidity.Effective.FiniteTuple



-- Module-system port for Palomar; mathematical bodies retained.
set_option backward.privateInPublic true
set_option backward.privateInPublic.warn false
set_option backward.proofsInPublic true

@[expose] public section

namespace OAI


namespace TuringRigidity.BoundedSetTheory
universe u

@[simp] theorem Formula.eval_rename_comp (p : Formula) (r : ℕ → ℕ) (e : ℕ → ZFSet.{u}) :
    (p.rename r).Eval e ↔ p.Eval (e ∘ r) := Formula.eval_rename p r e
end TuringRigidity.BoundedSetTheory

end OAI
