import Lake
open Lake DSL

/-- Reproducible build entry for the selmer-cartan-motive-towers Lean
    formalization (addresses external-verifier todo.md P0-3).

    Mirrors the local build environment used for the Strategy A completion:
    Lean v4.33.1 + Mathlib pinned at 0df444a360eaa60ab8c11dca51a86af692955474
    (see ~/prove2me_workspace/lake-manifest.json).

    Layout: repo root is the package; Lean sources live under `lean/`
    (`Definitions/`, `Theorems/`, `Solutions/`), matching the existing tree.

    Note: `Solutions/` modules do not import `Theorems/` (independent
    per-module evaluation, the current Prove2Me mode). The 16 substantive
    solution modules declare uniquely-named theorems
    `SelmerCartanMotiveTowers.sol_<name>` (one per milestone, M1–M16),
    so they can also be jointly imported without collision — see BUILD.md. -/
package «selmer-cartan-motive-towers» where
  srcDir := "lean"
  leanOptions := #[⟨`autoImplicit, false⟩]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @
  "0df444a360eaa60ab8c11dca51a86af692955474"

/-- All three libraries are default targets so that a bare `lake build`
    (the procedure documented in `BUILD.md`) covers every one of the 55
    intended modules. Previously only `Solutions` was a default target, so
    `lake build` silently skipped all 16 `Theorems` modules (nothing imports
    them; see external-verifier todo.md L156 build-entry coverage). -/
@[default_target] lean_lib Definitions where
  globs := #[Glob.submodules `Definitions]
@[default_target] lean_lib Theorems where
  globs := #[Glob.submodules `Theorems]
@[default_target] lean_lib Solutions where
  globs := #[Glob.submodules `Solutions]
