## Motivation

Arithmetic geometers who work with Selmer groups of $p$-adic Galois representations face a structural gap. On one side stand classical Selmer groups: concrete, computable, cohomological objects attached to a fixed prime support. On the other side stand the derived and motivic structures that ought to organize them — full motives, derived stacks, and the higher coherence data that records how local conditions glue. There is currently no finite, machine-checkable presentation that carries Selmer-type data from the concrete support level up to the motivic level without losing track of which prime, which coefficient depth, and which obstruction is being discussed. This mission formalizes a construction designed to close that gap: two-layer Selmer–Cartan towers whose support layer keeps primitive transport, Fox–Spencer, and secondary obstruction data in finite terms, and whose realization layer lifts that data to motivic Moore–Reedy objects and derived stacks.

## Setting

Fix a finite ordered set $I$ of primes, the **support**. A **Selmer–Cartan tower** over $I$ is a two-layer package. The **support layer** carries **primitive transport** data (parallel transport of Galois-theoretic information along the support), the **Fox–Spencer complex** (a finite differential-graded model of the deformation directions), and **secondary classes** recording obstructions that primary operations cannot see. A canonical **$5$-$3$-$2$ descent** computes the finite transfer along the support. The **realization layer** lifts a source package to a **motivic Moore–Reedy object**: a support-functorial lift equipped with **full-motive depth thickening** (separating valuation depth from support via a truncation $\tau_1$) and **derived stacks** that globalize the local charts. Throughout, five coordinates are kept as **separately typed** data and never mixed: support, confluence multiplicity, coefficient exponent, obstruction height, and geometric realization. A **$31$-adic witness** is an explicit instantiation of the whole tower at the prime $31$ over the quadratic fields $K_0=\mathbf{Q}(\sqrt{-331})$ and $K_*=\mathbf{Q}(\sqrt{-15391})$, exhibiting a non-empty source obstruction.

## Formalization targets

### Goal — the $31$-adic witness (Theorem 37.1)

$$ \text{The source obstruction of the Selmer--Cartan tower is non-vacuous: witnessed at } 31 \text{ over } K_0 \text{ and } K_*. $$

Concretely, the tower admits an exact-$\lambda_{31}=2$ ramified branch with integral carry normalization, and the Kummer–Bockstein–Massey local–global obstruction is non-zero. The terminal order-$31$ source line carries an independent unipotent-gerbe provenance via a proper $31$-fold operation law.

### Structural target — marked Morita independence (Theorem 30.2)

$$ \text{Pointed marked Morita equivalence preserves the complete finite tower and its pseudo-perfect-module stack.} $$

This is the invariance statement: the tower does not depend on the chosen presentation, only on the intrinsic marked data. It is recorded as a structural milestone rather than the goal, since the witness is the mission's arithmetic content.

## Significance

*The result itself.* The construction gives the first finite, presentation-independent package that transports Selmer-type obstruction data from prime support through motivic realization to derived stacks, with a concrete $31$-adic instance proving the obstruction theory is non-empty. Without the witness, the tower formalism could be vacuous; without Morita independence, it could be an artifact of choices. The paper also supplies three "Main Theorem" sections (motivic Moore–Reedy reconstruction, motivic insertion and frontier history, secondary bar geometry with all-support transgression) that solvers can draw on as the library grows.

*Formalizing it.* The paper is an unpublished draft (v0.1, August 2026); nothing in it has a machine-checked proof. This mission produces the Lean definitions of the tower layers (support package, motivic Moore–Reedy objects, full-motive thickening, derived-stack charts) and the formal statements of the goal and its milestones — the first machine-readable record of the theory. Because the motivic foundations ($\mathrm{FullMot}$, $\mathrm{RecOneMot}$, motivic Moore–Reedy objects) do not exist in Mathlib, the definitions built here are reusable infrastructure for any future motivic formalization on the platform.

## Difficulty

The central difficulty is **level confusion**: the five coordinates (support, confluence multiplicity, coefficient exponent, obstruction height, realization) must remain separately typed through every construction, and the naive approach — formalizing the tower as a single record with natural-number fields — silently identifies levels the paper keeps apart, making statements either false or vacuous. Every definition must carry the coordinates as distinct type-level data. A second difficulty is the **missing motivic base**: there is no Mathlib theory of motives to build on, so the Moore–Reedy and full-motive layers must be defined from scratch as combinatorial/homotopical objects faithful to the paper, without importing unintended motivic conjectures.

## Formalization scope

All definitions live in the single Lean namespace `SelmerCartanMotiveTowers`. The five coordinates are separate structure fields (or type parameters), never merged into one index. The explicit numerical witness data at $31$ (exact-$\lambda_{31}=2$, carry normalization, the stage-30 recursive map) enter the formalization **as hypotheses**, not as verified computations — the mission covers the structural tower theory, and computational verification of the witness values is out of scope. The paper's 17 firewall statements are scope declarations, not theorems, and are not formalized. A formalization that hard-codes the prime $31$ into the general tower definitions, or that proves the witness by assuming the obstruction it is meant to exhibit, is excluded. Needed infrastructure: finite ordered supports, Fox–Spencer complexes, confluence/PD-hull combinatorics, motivic Moore–Reedy objects, full-motive thickening, derived-stack charts. Contributions welcome at every layer, especially the motivic base definitions.

## Selected references

- Chenxi Cai, *Selmer–Cartan and Motivic Moore–Reedy Towers — Source geometry, full-motive realization, and a $31$-adic witness*, unpublished draft v0.1, August 2026. [https://github.com/cchx0000/selmer-cartan-motive-towers](https://github.com/cchx0000/selmer-cartan-motive-towers)
