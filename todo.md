# Lean 形式化 TODO

## 审计基线与范围

- 审计日期：2026-10-09（UTC）；默认分支：`main`。
- 首次实际 Lean 提交 / 本次完整源码审计基线：[`ebf86316451f383234c3cf437cec35b01fc1f8fa`](https://github.com/cchx0000/selmer-cartan-motive-towers/commit/ebf86316451f383234c3cf437cec35b01fc1f8fa)。
- 审计树：`f51c14d9554345fcdd8d05d70ebafef81fdc7e3a`；前一提交：`55f336e8485b692bc505e6ee77bbd0ec7c5f9420`。两者直接相邻；前一版本只有 README 与论文，新提交首次加入实际 Lean 源码。
- 论文：[`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`](selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex)，blob `6ee1db83403ec5aed4ad67fd978c25a85d2edd22`。本次对照相关原文及 `MISSION_DESCRIPTION.md`、`INVENTORY.md`，没有对整篇论文作数学正确性认证。
- 已静态检查全部 45 个 Lean 文件：12 个 Definitions 文件、16 个 Theorems 文件、16 个实质 Solutions 文件及 `SmokeTest.lean`。定义文件包含 13 个 structure、2 个无显式定义体的 opaque、4 个显式 axiom，以及一个实例声明。
- 16 个草稿各保留一个 `by sorry`。16 对草稿与 solution 的参数和结论在去注释、规范化空白后相同；Solutions 未导入 Theorems，原草稿因此仍未被替换。Solutions 源文无可执行的 `sorry` / `admit` / `axiom` / `unsafe` 标记；这不等于传递依赖无公理，也不等于编译验证通过。
- 未运行 Lean、Lake、证明或平台 `/verify`。树中没有 `lean-toolchain`、`lakefile.lean` / `lakefile.toml`、依赖锁定文件或工作流；本提交 GitHub check-runs、commit statuses 和仓库 Actions runs 均为 0。README 的本机构建陈述尚无本提交可复核的构建凭据。

当前应报告为“条件式骨架及独立解答源码，尚有声明语义和复现缺口”。仓库声明的 Strategy A 允许列明的外部算术输入；下面区分允许的输入、与结论等价的假设、以及根本没有证明字段的命题标签。数值证书的第一性原理验证不自动纳入当前 mission。

## P0：先修正主目标与可信度边界

### P0-1：让 31-adic witness 真正表达 witness

- [ ] 修订 `lean/Definitions/Def_adic_witness.lean::adic_witness`、`Def_witness_background.lean::WitnessBackground`，并同步 `thm_31adic_witness` / `Sol_thm_31adic_witness.lean::solution`。
  - 现状：`terminal_locally_trivial : Prop`、`terminal_globally_nonzero : Prop` 只是存入两个命题，不要求命题成立；`cubicLine_input_ok` 也只有谓词，`carryNormalization` 只有类型族。当前 `Nonempty adic_witness` 允许两个 terminal 命题取 `False`。
  - `WitnessBackground.localExtension`、`kappaRootNonzero`、`lambda31_exact2` 等同样是裸 `Prop`；solution 将它们装入记录，不能据此得到任何局部平凡或全局非零的证明。
  - 目标：给出明确的 arithmetic target、指定终端类、局部化映射、global zero 与 nonzero 谓词，以及与 cubic/carry 数据关联的证明字段；分别表示 `K₀` 和 `K*`，保留三个 31 坐标的类型区别。
  - 验收：能从最终 witness 提取论文 W1–W4 所要求的数据和证明（论文 L13670–13678），并追踪 Thm 37.1 的四项结论（L15765–15774）。不能仅把待证全局非零结论改成背景证明字段再原样投影；按照 mission 的反循环要求，标清每个允许的输入如何推导目标。

### P0-2：区分 Moore cochain 与 cohomology class

- [ ] 修订 `Def_motivic_background.lean::MotivicBackground` 和 `thm_motivic_seed` / 对应 solution 的精确阶语义。
  - 现状：`hb_order : N • b_mot = 0` 和 `hb_exact` 作用于 `Cochain` 元素；与 `hc_boundary` 合起来强制 `d c_mot = 0`，却不保证 `[b_mot]` 在上同调中非零或阶为 N。
  - 论文要求 integral Moore 关系 `d c = N b`，以及上同调类 `ord[b] = N`（L5214–5235、L5407–5475），二者不能混为同一层。
  - 验收：明确复形、cycles、boundaries、上同调类及其加法阶；证明 `d b = 0`、`d c = N b`、`addOrderOf [b] = N` 或等价的精确阶条件。排除“b 本身是 boundary、但作为 cochain 有阶 N”的模型；几何 antecedent 的意义也应有定义，而非任意 `isGenuine` 标签。

### P0-3：建立本提交可复现的构建与依赖审计

- [ ] 补齐/明确正式构建入口、Lean 与 Mathlib 精确版本及所有模块清单；保存对应源码 SHA、命令、完整结果的构建凭据。
  - 当前只有 README 声称 Lean 4.33.1 和本机 `lake build`；缺少可由干净 checkout 重现的配置。
  - 先明确使用独立 Prove2Me 模块评测，还是可联合导入的 Lean 库。16 个实质解答都叫 `SelmerCartanMotiveTowers.solution`，逐文件评测可以成立，但联合导入会重名；若选统一库，需稳定的不同名称或模块子命名空间。
  - 单独审计 `Def_rec_one_mot.lean` 的 `tau_one`、`depth_of_full`、`depth_of_rec`、`tau_one_depth_fiber` 四个显式 axiom，以及 `Def_full_mot.lean::full_mot` / `Def_rec_one_mot.lean::rec_one_mot` 的无体 opaque。此处不推断它们的 elaboration 结果或传递公理集合。
  - 验收：在选定构建模式下逐项覆盖全部生产声明，保留每项 `#print axioms` / 等效报告，区分 `sorryAx`、Lean 基础公理、明确允许的项目公理、参数化背景假设；不能以文本 grep 或 SmokeTest 代替完整验证。

## P1：恢复声明所指的数学结构

### P1-1：收窄并逐项登记背景义务

- [ ] 为 `ClassFieldBackground`、`MotivicBackground`、`WitnessBackground`、`FormalBackground` 的每个输入标记“定义 / 外部定理 / 数值假设 / 本文待证引理 / 目标重述”，建立输入到使用声明的表。
  - `ClassFieldBackground.masseyExact` 目前对任意三个 exact-order 字符和 cup-vanishing 条件便给出 Massey 精确阶；未包含特选第三射线、中心 Frobenius、固定 Heisenberg lift、指定 nullhomotopy 或单位局部不变量。应限定到实际构造数据，不能仅凭注释中的文献名视为一般定理。
  - `FormalBackground.obsCocycle/liftIff/gaugeInv/natural`、`shadowZero/shadowMoore`、`stackIsDerived`、`eRecBijective/eFullBijective` 等直接提供对应结论；当前解答属于条件组装，不能替代这些构造和证明。
  - `WitnessBackground.crtLineHas/crtRealizationIs`、`gerbeIs/gerbeProvenance`、`hLar/hLsrc/hLMot/hSpan` 同理；`gerbeProvenance : ∀ W, ...` 还须关联到产生该 gerbe 的具体 witness。
  - 验收：每个生产定理有精确依赖清单；允许的外部数值/理论输入保持显式，目标等价假设不得被当作目标已完成；论文内的构造义务有独立后续任务。

### P1-2：替换四类平凡模型通过路径

- [ ] 强化 M4 `thm_finite_confluent_interface`：当前 solution 把 `source_package` 的七个 carrier 全取 Empty。补充实际 direction lattice、PD hull、系数环、confluence/defect/resonance 结构及其作用；验收包含删除、重标号、线性方向图与复合律（论文 L5147–5168）。
- [ ] 强化 M6 `thm_channel_complete_realization`：补充源 dg controller、target dg/correspondence algebra、实现映射、全部 ordered channels、Moore exactness 和严格 support-deletion；不能由 Unit carrier/algebra 满足“realization”。验收对齐论文 L6145–6189 的七项性质。
- [ ] 强化 M7 `thm_role_separated_objectification`：n 与给定支撑相关，控制/出生对象及非零控制边有实际结构，禁止通过自由选择 `n = 0`、空索引消去全部义务。验收先覆盖至少存在一条边的合法支撑，再给出完整 functorial 构造；仅加 `0 < n` 未必足以排除无边模型。
- [ ] 强化 M8 `thm_finite_motivic_recursion_closure`：当前 carrier 和 corrAlgebra 均取 Unit，M/hM 未参与结论。目标应含有限 ledger、latching/Reedy、history、bar/readout 与 successor 相容性。验收对齐论文 L12472 起的 closure 条款，并区分“jet 不改变底层对象”与“把全部结构删除”。

### P1-3：从任意函数/类型恢复 obstruction、category 与 stack

- [ ] M2 `thm_universal_higher_obstruction_recursion`：定义 graded dg algebra、PD filtration、MC jet 和 obstruction class，由 Bianchi/度数计算推出 cocycle、lifting、gauge、naturality；补回 filler torsor 等遗漏条款，而非直接取 `FormalBackground` 的同名结论。
- [ ] M9 `thm_successor_stage_functor`：当前在给定 `nextObstruction`、`mooreLift`、`hMooreClosure` 后，选择一个保持谓词的函数族；声明甚至未强制它等于给定的 Moore lift。补充明确公式、marked stage、态射映射/函子律、homotopy pullback / Moore relation、support 与 frame/representative independence，保留 coefficient-depth firewall。
- [ ] M11–M13 `thm_classical_low_sector_comparison`、`prop_stack_globalization`、`thm_marked_morita_independence`：分别建立实际 shadow functor、pseudo-perfect-module moduli/derived-stack 条件、pointed marked Morita equivalence 及诱导的有限塔/stack 等价；目前的任意谓词、类型和集合双射不足以表达这些结构。
  - 验收：每一项将论文条件与结论逐条配对；底层对象、态射、函子及交换/自然性条件均在类型中出现，测试其不能通过恒真谓词或无关集合双射满足。

### P1-4：补齐比较映射与 prime-power / witness 实现

- [ ] M3 `thm_formal_filtered_alignment`：保留现有 cyclic-group 论证，连接实际 Moore cohomology line 与 filtered confluence line，补充 pointed `AddEquiv` 及 q-primary reduction / residual generator 相容性。当前唯一 `AddMonoidHom` 在已有生成性和相同有限基数下可推出双射，因此不应误报为假命题；缺的是目标对象语义和 reduction 兼容。
- [ ] M10 `thm_prime_power_comparison`：把具体有限 `ν`、`Nν`、CRT product、相容的 p-power reductions、Moore presentation 和 support-functorial dg realization 绑定起来。当前与 `S` 无关地投影两个存在性字段不表达比较；一般 odd prime-power 层不能被 `motivic_moore_reedy.coeffOrder_squarefree` 的限制替代。
- [ ] M15/M16 `thm_gerbe_provenance`、`thm_motivic_specialization`：补充具体 classifying map、unipotent central extension、pullback class 等式，以及三条 pointed cyclic order-31 carrier 之间的真实同构。区分 carrier-level span 与 operation-level provenance；不能用一个任意三元谓词同时代替它们。
  - 验收：M3 对齐论文 L2235–2260；M10 对齐 L13000–13076 的 reductions、共振深度及五坐标条件；M15/M16 对齐 L15832–15873、L16066–16107 的映射、类和 marking。

### P1-5：接回草稿并修正文档统计

- [ ] 在先完成声明语义复核后，把16个 solution 接入对应生产声明；按选定模式明确保留的评测模板与生产证明入口，防止“Solutions 无 sorry”掩盖被依赖的 Theorems 仍含 sorry。
- [ ] 更正 `lean/README.md`：16 个实质解答已包括主目标 M14，第17个文件是 SmokeTest，不是额外主目标证明；“全部已证明”须限定为哪一版条件式声明、哪些输入和哪一份构建凭据。
  - 验收：统计从真实声明和依赖闭包生成，逐项显示“文本完成 / 编译验证 / 依赖公理 / 与论文差距”；`MISSION_DESCRIPTION.md`、`INVENTORY.md` 与代码状态不相互矛盾。

## 声明与文件索引

所有名称位于 `SelmerCartanMotiveTowers`。Definitions 的依赖骨架：`finite_ordered_support → typed_coordinates`；`typed_coordinates → source_package、adic_witness`；`adic_witness、finite_ordered_support → WitnessBackground`；`full_mot → rec_one_mot → selmer_cartan_tower → FormalBackground`；`finite_ordered_support → motivic_moore_reedy`。`ClassFieldBackground`、`MotivicBackground` 各自引入额外背景接口。箭头从被导入定义指向使用方；详见各文件 import。

| Definitions 文件（位于 `lean/Definitions/`） | 主要声明 |
| --- | --- |
| `Def_finite_ordered_support.lean` | `finite_ordered_support` |
| `Def_typed_coordinates.lean` | `confluence_multiplicity`、`coefficient_exponent`、`obstruction_height`、`typed_coordinates` |
| `Def_source_package.lean` | `source_package` |
| `Def_full_mot.lean` | `full_mot` |
| `Def_rec_one_mot.lean` | `rec_one_mot`、`tau_one`、`depth_of_full`、`depth_of_rec`、`tau_one_depth_fiber` |
| `Def_motivic_moore_reedy.lean` | `motivic_moore_reedy` |
| `Def_selmer_cartan_tower.lean` | `selmer_cartan_tower` |
| `Def_adic_witness.lean` | `adic_witness` |
| `Def_classfield_background.lean` | `ClassFieldBackground` |
| `Def_motivic_background.lean` | `MotivicBackground`、`MotivicBackground.instAddCommGroup` |
| `Def_witness_background.lean` | `WitnessBackground` |
| `Def_formal_background.lean` | `FormalBackground` |

下表每行声明 `x` 对应草稿 `lean/Theorems/Thm_SelmerCartanMotiveTowers_x.lean`，以及独立解答 `lean/Solutions/Sol_x.lean::solution`。

| 里程碑 | 声明 x | 当前证明/接口重点 | 对应待办 |
| --- | --- | --- | --- |
| M1 / Thm 6.5 | `thm_ray_class_primitive` | `ClassFieldBackground` 的两射线、第三射线、lift、Massey 字段组装 | P1-1 |
| M2 / Thm 9.4 | `thm_universal_higher_obstruction_recursion` | `FormalBackground` 四个结论字段 | P1-1、P1-3 |
| M3 / Thm 8.21 | `thm_formal_filtered_alignment` | 抽象有限 cyclic group 的 pointed hom 构造 | P1-4 |
| M4 / Thm 11.6 | `thm_finite_confluent_interface` | Empty carrier 的存在性记录 | P1-2 |
| M5 / Thm 12.2 | `thm_motivic_seed` | `MotivicBackground` 的 Moore 数据投影 | P0-2 |
| M6 / Thm 19.6 | `thm_channel_complete_realization` | Unit 源/target 与常值映射 | P1-2 |
| M7 / Thm 19.9 | `thm_role_separated_objectification` | `n = 0` 的空模型 | P1-2 |
| M8 / Thm 25.14 | `thm_finite_motivic_recursion_closure` | Unit carrier 的简化包，M 未进入结论 | P1-2 |
| M9 / Thm 26.7 | `thm_successor_stage_functor` | 给定 obstruction/Moore lift/closure 后的函数组装 | P1-3 |
| M10 / Thm 26.12 | `thm_prime_power_comparison` | `WitnessBackground` 中 CRT 与 realization 字段投影 | P1-1、P1-4 |
| M11 / Thm 27.5 | `thm_classical_low_sector_comparison` | shadow 数据及性质投影 | P1-3 |
| M12 / Prop 13.5 | `prop_stack_globalization` | `stackIsDerived` 直接投影 | P1-3 |
| M13 / Thm 30.2 | `thm_marked_morita_independence` | 已给定双射及 intertwining 性质投影 | P1-3 |
| M14 / Thm 37.1 / 主目标 | `thm_31adic_witness` | 构造带裸 Prop 标签的记录 | P0-1 |
| M15 / Thm 38.1 | `thm_gerbe_provenance` | `gerbeIs`、`gerbeProvenance` 投影 | P1-4 |
| M16 / Thm 38.5 | `thm_motivic_specialization` | `isOrder31`、`carrierSpan` 谓词的已有证据 | P1-4 |

另有 `lean/Solutions/SmokeTest.lean`，只计作烟雾测试，不计作论文里程碑。

## 后续增量检查规则

- 从上述完整源码基线之后检查新增提交；只改变本 TODO 的提交不构成新的 Lean 成果或构建凭据。
- 源码、声明、背景输入或构建配置变化时，重新核对受影响的定义、依赖及论文条款，再更新对应条目的状态。
- 只有完成该条验收且有相应证据才勾选；单个 `sorry` 消失、README 更新、局部测试通过或条件结论被投影出来，都不足以单独关闭语义任务。
