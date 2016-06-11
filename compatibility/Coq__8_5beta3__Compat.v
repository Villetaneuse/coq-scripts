(** See https://coq.inria.fr/bugs/show_bug.cgi?id=4319 for updates *)

Require Coq.Program.Tactics.
Ltac rapply term := Coq.Program.Tactics.rapply term; shelve_unifiable.

(** https://coq.inria.fr/bugs/show_bug.cgi?id=4461 *)
Require Coq.Classes.RelationClasses.
Global Arguments Coq.Classes.RelationClasses.Antisymmetric A eqA {_} _.
Global Arguments Coq.Classes.RelationClasses.symmetry {A} {R} {_} [x] [y] _.
Global Arguments Coq.Classes.RelationClasses.asymmetry {A} {R} {_} [x] [y] _ _.
Global Arguments Coq.Classes.RelationClasses.transitivity {A} {R} {_} [x] [y] [z] _ _.

(** [set (x := y)] is about 50x slower than it needs to be in Coq 8.4,
    but is about 4x faster than the alternatives in 8.5.  See
    https://coq.inria.fr/bugs/show_bug.cgi?id=3280 (comment 13) for
    more details. *)
Ltac fast_set' x y := set (x := y).
Ltac fast_set'_in x y H := set (x := y) in H.
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" := fast_set' x y.
Tactic Notation "fast_set" "(" ident(x) ":=" constr(y) ")" "in" hyp(H) := fast_set'_in x y H.

(** Add Coq 8.4+8.5 notations, so that we don't accidentally make use of Coq 8.4-only notations *)
Require Coq.Lists.List.
Require Coq.Vectors.VectorDef.
Module Export Coq.
Module Export Lists.
Module List.
Module ListNotations.
Export Coq.Lists.List.ListNotations.
Notation " [ x ; .. ; y ] " := (cons x .. (cons y nil) ..) : list_scope.
Notation " [ x ; y ; .. ; z ] " := (cons x (cons y .. (cons z nil) ..)) : list_scope.
End ListNotations.
End List.
End Lists.
Module Export Vectors.
Module VectorDef.
Module VectorNotations.
Export Coq.Vectors.VectorDef.VectorNotations.
Notation " [ x ; .. ; y ] " := (VectorDef.cons _ x _ .. (VectorDef.cons _ y _ (VectorDef.nil _)) ..) : vector_scope. (* actually only required in > 8.5pl1, not in >= 8.5pl1 *)
Notation " [ x ; y ; .. ; z ] " := (VectorDef.cons _ x _ (VectorDef.cons _ y _ .. (VectorDef.cons _ z _ (VectorDef.nil _)) ..)) : vector_scope.
End VectorNotations.
End VectorDef.
End Vectors.
End Coq.
Export Vectors.VectorDef.VectorNotations.
Close Scope vector_scope.
Export List.ListNotations.
