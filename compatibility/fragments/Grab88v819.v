(** Compatibility file for making Coq act similar to Coq v8.8 *)
Local Set Warnings "-deprecated".

Require Export Coq.Compat.Coq816.

Unset Private Polymorphic Universes.

(** Unsafe flag, can hide inconsistencies. *)
Global Unset Template Check.

(** In Coq 8.9, prim token notations follow [Import] rather than
    [Require].  So we make all of the relevant notations accessible in
    compatibility mode. *)
Require Coq.Strings.Ascii Coq.Strings.String.
Export String.StringSyntax Ascii.AsciiSyntax.
Require Coq.ZArith.BinIntDef Coq.PArith.BinPosDef Coq.NArith.BinNatDef.
Require Coq.Reals.Rdefinitions.
Require Coq.Numbers.Cyclic.Int63.Uint63.
Number Notation BinNums.Z BinIntDef.Z.of_num_int BinIntDef.Z.to_num_int : Z_scope.
Number Notation BinNums.positive BinPosDef.Pos.of_num_int BinPosDef.Pos.to_num_int : positive_scope.
Number Notation BinNums.N BinNatDef.N.of_num_int BinNatDef.N.to_num_int : N_scope.
Number Notation Int31.int31 Int31.phi_inv_nonneg Int31.phi : int31_scope.

Local Set Warnings "-deprecated".
Global Set Firstorder Solver auto with *.
Global Set Instance Generalized Output.
Global Set Apply With Renaming.

Require Coq.micromega.Lia.
Module Export Coq.
  Module Export omega.
    Module Export Omega.
      #[deprecated(since="8.12", note="The omega tactic was removed in v8.14.  You're now relying on the lia tactic.")]
      Ltac omega := Lia.lia.
    End Omega.
  End omega.
  Module Export Numbers.
    Module Export Cyclic.
      Module Export Int31.
(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)
(*            Benjamin Gregoire, Laurent Thery, INRIA, 2007             *)
(************************************************************************)

(** This library has been deprecated since Coq version 8.10. *)
Local Set Warnings "-deprecated".

Require Import NaryFunctions.
Require Import Wf_nat.
Require Export ZArith.
Require Export DoubleType.

Local Unset Elimination Schemes.

(** * 31-bit integers *)

(** This file contains basic definitions of a 31-bit integer
  arithmetic. In fact it is more general than that. The only reason
  for this use of 31 is the underlying mechanism for hardware-efficient
  computations by A. Spiwack. Apart from this, a switch to, say,
  63-bit integers is now just a matter of replacing every occurrences
  of 31 by 63. This is actually made possible by the use of
  dependently-typed n-ary constructions for the inductive type
  [int31], its constructor [I31] and any pattern matching on it.
  If you modify this file, please preserve this genericity.  *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition size := 31%nat.

(** Digits *)

Inductive digits : Type := D0 | D1.

(** The type of 31-bit integers *)

(** The type [int31] has a unique constructor [I31] that expects
   31 arguments of type [digits]. *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition digits31 t := Eval compute in nfun digits size t.

Inductive int31 : Type := I31 : digits31 int31.

Scheme int31_ind := Induction for int31 Sort Prop.
Scheme int31_rec := Induction for int31 Sort Set.
Scheme int31_rect := Induction for int31 Sort Type.

Declare Scope int31_scope.
Delimit Scope int31_scope with int31.
Bind Scope int31_scope with int31.
Local Open Scope int31_scope.

(** * Constants *)

(** Zero is [I31 D0 ... D0] *)
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition On : int31 := Eval compute in napply_cst _ _ D0 size I31.

(** One is [I31 D0 ... D0 D1] *)
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition In : int31 := Eval compute in (napply_cst _ _ D0 (size-1) I31) D1.

(** The biggest integer is [I31 D1 ... D1], corresponding to [(2^size)-1] *)
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition Tn : int31 := Eval compute in napply_cst _ _ D1 size I31.

(** Two is [I31 D0 ... D0 D1 D0] *)
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition Twon : int31 := Eval compute in (napply_cst _ _ D0 (size-2) I31) D1 D0.

(** * Bits manipulation *)


(** [sneakr b x] shifts [x] to the right by one bit.
   Rightmost digit is lost while leftmost digit becomes [b].
   Pseudo-code is
    [ match x with (I31 d0 ... dN) => I31 b d0 ... d(N-1) end ]
*)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sneakr : digits -> int31 -> int31 := Eval compute in
 fun b => int31_rect _ (napply_except_last _ _ (size-1) (I31 b)).

(** [sneakl b x] shifts [x] to the left by one bit.
   Leftmost digit is lost while rightmost digit becomes [b].
   Pseudo-code is
    [ match x with (I31 d0 ... dN) => I31 d1 ... dN b end ]
*)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sneakl : digits -> int31 -> int31 := Eval compute in
 fun b => int31_rect _ (fun _ => napply_then_last _ _ b (size-1) I31).


(** [shiftl], [shiftr], [twice] and [twice_plus_one] are direct
    consequences of [sneakl] and [sneakr]. *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition shiftl := sneakl D0.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition shiftr := sneakr D0.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition twice := sneakl D0.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition twice_plus_one := sneakl D1.

(** [firstl x] returns the leftmost digit of number [x].
    Pseudo-code is [ match x with (I31 d0 ... dN) => d0 end ] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition firstl : int31 -> digits := Eval compute in
 int31_rect _ (fun d => napply_discard _ _ d (size-1)).

(** [firstr x] returns the rightmost digit of number [x].
    Pseudo-code is [ match x with (I31 d0 ... dN) => dN end ] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition firstr : int31 -> digits := Eval compute in
 int31_rect _ (napply_discard _ _ (fun d=>d) (size-1)).

(** [iszero x] is true iff [x = I31 D0 ... D0]. Pseudo-code is
    [ match x with (I31 D0 ... D0) => true | _ => false end ] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition iszero : int31 -> bool := Eval compute in
 let f d b := match d with D0 => b | D1 => false end
 in int31_rect _ (nfold_bis _ _ f true size).

(* NB: DO NOT transform the above match in a nicer (if then else).
   It seems to work, but later "unfold iszero" takes forever. *)


(** [base] is [2^31], obtained via iterations of [Z.double].
   It can also be seen as the smallest b > 0 s.t. phi_inv b = 0
   (see below) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition base := Eval compute in
 iter_nat size Z Z.double 1%Z.

(** * Recursors *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint recl_aux (n:nat)(A:Type)(case0:A)(caserec:digits->int31->A->A)
 (i:int31) : A :=
  match n with
  | O => case0
  | S next =>
          if iszero i then
             case0
          else
             let si := shiftl i in
             caserec (firstl i) si (recl_aux next A case0 caserec si)
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint recr_aux (n:nat)(A:Type)(case0:A)(caserec:digits->int31->A->A)
 (i:int31) : A :=
  match n with
  | O => case0
  | S next =>
          if iszero i then
             case0
          else
             let si := shiftr i in
             caserec (firstr i) si (recr_aux next A case0 caserec si)
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition recl := recl_aux size.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition recr := recr_aux size.

(** * Conversions *)

(** From int31 to Z, we simply iterates [Z.double] or [Z.succ_double]. *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition phi : int31 -> Z :=
 recr Z (0%Z)
  (fun b _ => match b with D0 => Z.double | D1 => Z.succ_double end).

(** From positive to int31. An abstract definition could be :
      [ phi_inv (2n) = 2*(phi_inv n) /\
        phi_inv 2n+1 = 2*(phi_inv n) + 1 ] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint phi_inv_positive p :=
  match p with
    | xI q => twice_plus_one (phi_inv_positive q)
    | xO q => twice (phi_inv_positive q)
    | xH => In
  end.

(** The negative part : 2-complement  *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint complement_negative p :=
  match p with
    | xI q => twice (complement_negative q)
    | xO q => twice_plus_one (complement_negative q)
    | xH => twice Tn
  end.

(** A simple incrementation function *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition incr : int31 -> int31 :=
 recr int31 In
   (fun b si rec => match b with
     | D0 => sneakl D1 si
     | D1 => sneakl D0 rec end).

(** We can now define the conversion from Z to int31. *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition phi_inv : Z -> int31 := fun n =>
 match n with
 | Z0 => On
 | Zpos p => phi_inv_positive p
 | Zneg p => incr (complement_negative p)
 end.

(** [phi_inv_nonneg] returns [None] if the [Z] is negative; this matches the old behavior of parsing int31 numerals *)
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition phi_inv_nonneg : Z -> option int31 := fun n =>
 match n with
 | Zneg _ => None
 | _ => Some (phi_inv n)
 end.

(** [phi_inv2] is similar to [phi_inv] but returns a double word
    [zn2z int31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition phi_inv2 n :=
  match n with
  | Z0 => W0
  | _ => WW (phi_inv (n/base)%Z) (phi_inv n)
  end.

(** [phi2] is similar to [phi] but takes a double word (two args) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition phi2 nh nl :=
  ((phi nh)*base+(phi nl))%Z.

(** * Addition *)

(** Addition modulo [2^31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition add31 (n m : int31) := phi_inv ((phi n)+(phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n + m" := (add31 n m) : int31_scope.

(** Addition with carry (the result is thus exact) *)

(* spiwack : when executed in non-compiled*)
(* mode, (phi n)+(phi m) is computed twice*)
(* it may be considered to optimize it *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition add31c (n m : int31) :=
  let npm := n+m in
  match (phi npm ?= (phi n)+(phi m))%Z with
  | Eq => C0 npm
  | _ => C1 npm
  end.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n '+c' m" := (add31c n m) (at level 50, no associativity) : int31_scope.

(**  Addition plus one with carry (the result is thus exact) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition add31carryc (n m : int31) :=
  let npmpone_exact := ((phi n)+(phi m)+1)%Z in
  let npmpone := phi_inv npmpone_exact in
  match (phi npmpone ?= npmpone_exact)%Z with
  | Eq => C0 npmpone
  | _ => C1 npmpone
  end.

(** * Subtraction *)

(** Subtraction modulo [2^31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sub31 (n m : int31) := phi_inv ((phi n)-(phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n - m" := (sub31 n m) : int31_scope.

(** Subtraction with carry (thus exact) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sub31c (n m : int31) :=
  let nmm := n-m in
  match (phi nmm ?= (phi n)-(phi m))%Z with
  | Eq => C0 nmm
  | _ => C1 nmm
  end.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n '-c' m" := (sub31c n m) (at level 50, no associativity) : int31_scope.

(** subtraction minus one with carry (thus exact) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sub31carryc (n m : int31) :=
  let nmmmone_exact := ((phi n)-(phi m)-1)%Z in
  let nmmmone := phi_inv nmmmone_exact in
  match (phi nmmmone ?= nmmmone_exact)%Z with
  | Eq => C0 nmmmone
  | _ => C1 nmmmone
  end.

(** Opposite *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition opp31 x := On - x.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "- x" := (opp31 x) : int31_scope.

(** Multiplication *)

(** multiplication modulo [2^31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition mul31 (n m : int31) := phi_inv ((phi n)*(phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n * m" := (mul31 n m) : int31_scope.

(** multiplication with double word result (thus exact) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition mul31c (n m : int31) := phi_inv2 ((phi n)*(phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n '*c' m" := (mul31c n m) (at level 40, no associativity) : int31_scope.


(** * Division *)

(** Division of a double size word modulo [2^31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition div3121 (nh nl m : int31) :=
  let (q,r) := Z.div_eucl (phi2 nh nl) (phi m) in
  (phi_inv q, phi_inv r).

(** Division modulo [2^31] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition div31 (n m : int31) :=
  let (q,r) := Z.div_eucl (phi n) (phi m) in
  (phi_inv q, phi_inv r).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n / m" := (div31 n m) : int31_scope.


(** * Unsigned comparison *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition compare31 (n m : int31) := ((phi n)?=(phi m))%Z.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Notation "n ?= m" := (compare31 n m) (at level 70, no associativity) : int31_scope.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition eqb31 (n m : int31) :=
 match n ?= m with Eq => true | _ => false end.


(** Computing the [i]-th iterate of a function:
    [iter_int31 i A f = f^i] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition iter_int31 i A f :=
  recr (A->A) (fun x => x)
   (fun b si rec => match b with
      | D0 => fun x => rec (rec x)
      | D1 => fun x => f (rec (rec x))
    end)
    i.

(** Combining the [(31-p)] low bits of [i] above the [p] high bits of [j]:
    [addmuldiv31 p i j = i*2^p+j/2^(31-p)]  (modulo [2^31]) *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition addmuldiv31 p i j :=
 let (res, _ ) :=
 iter_int31 p (int31*int31)
  (fun ij => let (i,j) := ij in (sneakl (firstl j) i, shiftl j))
  (i,j)
 in
 res.

(** Bitwise operations *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition lor31 n m := phi_inv (Z.lor (phi n) (phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition land31 n m := phi_inv (Z.land (phi n) (phi m)).
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition lxor31 n m := phi_inv (Z.lxor (phi n) (phi m)).

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition lnot31 n := lxor31 Tn n.
#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition ldiff31 n m := land31 n (lnot31 m).

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint euler (guard:nat) (i j:int31) {struct guard} :=
  match guard with
    | O => In
    | S p => match j ?= On with
               | Eq => i
               | _ => euler p j (let (_, r ) := i/j in r)
             end
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition gcd31 (i j:int31) := euler (2*size)%nat i j.

(** Square root functions using newton iteration
    we use a very naive upper-bound on the iteration
    2^31 instead of the usual 31.
**)



#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sqrt31_step (rec: int31 -> int31 -> int31) (i j: int31)  :=
Eval lazy delta [Twon] in
  let (quo,_) := i/j in
  match quo ?= j with
    Lt => rec i (fst ((j + quo)/Twon))
  | _ =>  j
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint iter31_sqrt (n: nat) (rec: int31 -> int31 -> int31)
          (i j: int31) {struct n} : int31 :=
  sqrt31_step
   (match n with
      O =>  rec
   | S n => (iter31_sqrt n (iter31_sqrt n rec))
   end) i j.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sqrt31 i :=
Eval lazy delta [On In Twon] in
  match compare31 In i with
    Gt => On
  | Eq => In
  | Lt => iter31_sqrt 31 (fun i j => j) i (fst (i/Twon))
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition v30 := Eval compute in (addmuldiv31 (phi_inv (Z.of_nat size - 1)) In On).

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sqrt312_step (rec: int31 -> int31 -> int31 -> int31)
   (ih il j: int31)  :=
Eval lazy delta [Twon v30] in
  match ih ?= j with Eq => j | Gt => j | _ =>
  let (quo,_) := div3121 ih il j in
  match quo ?= j with
    Lt => let m := match j +c quo with
                    C0 m1 => fst (m1/Twon)
                  | C1 m1 => fst (m1/Twon) + v30
                  end in rec ih il m
  | _ =>  j
  end end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint iter312_sqrt (n: nat)
          (rec: int31  -> int31 -> int31 -> int31)
          (ih il j: int31) {struct n} : int31 :=
  sqrt312_step
   (match n with
      O =>  rec
   | S n => (iter312_sqrt n (iter312_sqrt n rec))
   end) ih il j.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition sqrt312 ih il :=
Eval lazy delta [On In] in
  let s := iter312_sqrt 31 (fun ih il j => j) ih il Tn in
           match s *c s with
            W0 => (On, C0 On) (* impossible *)
          | WW ih1 il1 =>
             match il -c il1 with
                C0 il2 =>
                  match ih ?= ih1 with
                    Gt => (s, C1 il2)
                  | _  => (s, C0 il2)
                  end
              | C1 il2 =>
                  match (ih - In) ?= ih1 with (* we could parametrize ih - 1 *)
                    Gt => (s, C1 il2)
                  | _  => (s, C0 il2)
                  end
              end
          end.


#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Fixpoint p2i n p : (N*int31)%type :=
  match n with
    | O => (Npos p, On)
    | S n => match p with
               | xO p => let (r,i) := p2i n p in (r, Twon*i)
               | xI p => let (r,i) := p2i n p in (r, Twon*i+In)
               | xH => (N0, In)
             end
  end.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition positive_to_int31 (p:positive) := p2i size p.

(** Constant 31 converted into type int31.
    It is used as default answer for numbers of zeros
    in [head0] and [tail0] *)

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition T31 : int31 := Eval compute in phi_inv (Z.of_nat size).

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition head031 (i:int31) :=
  recl _ (fun _ => T31)
   (fun b si rec n => match b with
     | D0 => rec (add31 n In)
     | D1 => n
    end)
   i On.

#[deprecated(note="Consider Numbers.Cyclic.Int63.Uint63 instead", since="8.10")]
Definition tail031 (i:int31) :=
  recr _ (fun _ => T31)
   (fun b si rec n => match b with
     | D0 => rec (add31 n In)
     | D1 => n
    end)
   i On.

Number Notation int31 phi_inv_nonneg phi : int31_scope.
      End Int31.
    End Cyclic.
  End Numbers
End Coq.
