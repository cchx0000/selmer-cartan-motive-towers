# Lean 形式化 TODO

## 审计基线与范围

- 审计日期：2026-10-09（UTC）；默认分支：`main`。
- 首次实际 Lean 提交 / 首次完整源码审计基线：[`ebf86316451f383234c3cf437cec35b01fc1f8fa`](https://github.com/cchx0000/selmer-cartan-motive-towers/commit/ebf86316451f383234c3cf437cec35b01fc1f8fa)。
- 审计树：`f51c14d9554345fcdd8d05d70ebafef81fdc7e3a`；前一提交：`55f336e8485b692bc505e6ee77bbd0ec7c5f9420`。两者直接相邻；前一版本只有 README 与论文，新提交首次加入实际 Lean 源码。
- 论文：[`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`](selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex)，blob `6ee1db83403ec5aed4ad67fd978c25a85d2edd22`。本次对照相关原文及 `MISSION_DESCRIPTION.md`、`INVENTORY.md`，没有对整篇论文作数学正确性认证。
- 初始基线已静态检查 `lean/` 下全部 45 个 Lean 文件：12 个 Definitions 文件、16 个 Theorems 文件、16 个实质 Solutions 文件及 `SmokeTest.lean`。定义文件包含 13 个 structure、2 个无显式定义体的 opaque、4 个显式 axiom，以及一个实例声明。
- 初始基线的 16 个草稿各保留一个 `by sorry`。当时 16 对草稿与 solution 的参数和结论在去注释、规范化空白后相同，Solutions 未接回 Theorems。后续 `460ac27c` 已在源码层面接回全部 16 项，当前情况见下方增量记录；文本检查不等于传递依赖无公理或编译验证通过。
- 初始基线审计未运行 Lean、Lake、证明或平台 `/verify`。该基线树中没有 `lean-toolchain`、`lakefile.lean` / `lakefile.toml`、依赖锁定文件或工作流；该提交 GitHub check-runs、commit statuses 和仓库 Actions runs 均为 0。后续配置与作者提供的审计报告变化见下方增量记录。

### 2026-10-09 增量审查

- 本次检查 [`02ba97f4608a8bd2bad6853bf3b017552459f4b6...067adca62e34c8b4677c2473ee378c40fcef899f`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/02ba97f4608a8bd2bad6853bf3b017552459f4b6...067adca62e34c8b4677c2473ee378c40fcef899f)，新增 3 个直接相邻提交；最新源码审查游标为 `067adca62e34c8b4677c2473ee378c40fcef899f`，树为 `b379e89a9182e7d192d0b8e9b4cffcd6bfa9907c`。前一游标 `02ba97f4` 只更新本 TODO。
- `8a1d6783a4e4459ee11a0769cd8d2c8d02292ef7` 新增 `lean-toolchain`、`lakefile.lean`、`BUILD.md`、`lean/AXIOMS.md`，16 个实质 Solutions 仅改为唯一的 `sol_<name>`，并更正 README 的 M14 重复计数和 SmokeTest 统计。
- `460ac27c2604e33857f2f57ea6c43ae817359d4e` 新增 `channel_index` 与背景输入台账，强化 witness / motivic 接口和 M4/M6/M7/M8 的声明，全部 16 个 Theorems 导入并调用对应 `sol_*`。该提交已有 46 个 `lean/` 源文件；源码接线检查不代表编译通过。
- `067adca62e34c8b4677c2473ee378c40fcef899f` 新增 Moore 商群/CRT 模型与 pointed order-31 carrier，M3 新增唯一 pointed `AddEquiv` 及 q-reduction，M16 从实际 cyclic carrier 数据构造同构，不再投影任意 span 谓词。当前静态重查 `lean/` 下 48 个 Lean 文件（15 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根目录另有 `lakefile.lean`）：16 个 structure、2 个无体 opaque、4 个显式 axiom、7 个 instance。16 对生产定理/解答的参数和结论去注释、规范化空白后相同；去注释源码无可执行的 `sorry` / `admit` / `unsafe`。
- 论文、mission、四个项目 axiom 和两个 opaque 未改。新源码修掉若干旧反例，但 W1/W2、目标非零的推导、integral Moore 关系以及 dg/几何结构仍有缺口；具体区分下列已完成子项与未完成验收。
- `lean/AXIOMS.md` 在 `460ac27c` 从 22 项更新为作者报告的 28 项输出，尚未随 `067adca6` 的新增定义/实例和 M3/M16 变化更新；脚本未入库，未附所审源码 SHA、完整运行日志和退出状态。本次未运行 Lean、Lake 或 `/verify`。当前源码 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0，尚无该 SHA 的独立可复核构建凭据。

当前应报告为“条件式骨架及独立解答源码，尚有声明语义和复现缺口”。仓库声明的 Strategy A 允许列明的外部算术输入；下面区分允许的输入、与结论等价的假设、以及根本没有证明字段的命题标签。数值证书的第一性原理验证不自动纳入当前 mission。

## P0：先修正主目标与可信度边界

### P0-1：让 31-adic witness 真正表达 witness

- [x] 修复旧 W4 的裸命题标签漏洞：`adic_witness` 现有终端交换群、指定类、局部化映射、带非空证明的 trivialization 数据与真实等式证书，以及 `global_nonzero : terminalClass ≠ 0`。原来把两个 terminal 标签取 `False` 的方法已不满足新类型。
- [ ] 继续修订 `Def_adic_witness.lean::adic_witness`、`Def_witness_background.lean::WitnessBackground` 与 `sol_thm_31adic_witness`，补齐 W1–W4 的实际算术内容和非循环推导。
  - W1/W2 仍薄弱：`cubicLine_input_ok` 只有谓词，`carryNormalization` 只有类型族；solution 仍设为 `fun _ => bg.qiKummer ∧ bg.carryNormalized` 与 `fun _ => bg.QAdicLine`，没有相应成立证据或有限深度相容性。`lambda31_exact2`、`qiKummer`、`carryNormalized` 等仍是裸 `Prop` 标签。
  - `branchZero` / `branchStar` 已分开，但只是任意 `Type`，未定义为 `K₀` / `K*` 或与判别式、Kummer、Massey、局部场数据关联；终端类没有精确阶 31 条件，局部化只是任意函数。三个 31 字段仍须保留所要求的类型区别。
  - 非循环缺口仍在：`sol_thm_31adic_witness` L34/L41 直接取 `terminalClass := bg.kappa`、`global_nonzero := bg.kappa_ne_zero`；该背景未把任意 `ObstructionGroup` / `kappa` 绑定到具体算术类，也未从允许输入推出非零。给字段贴“EXT / Not GOAL!”或文献标签不构成推导。须形式化所用的 pairing / Kummer identification 等前提与实例化链，而非原样导入待展示的 obstruction 非零；这不要求把 mission 允许的数值输入改为第一性原理证明。
  - 验收：能从最终 witness 提取论文 W1–W4 所要求的数据和证明（论文 L13670–13678），并追踪 Thm 37.1 的四项结论（L15765–15774）；根据 mission 的反循环要求，逐项标清允许输入如何导出目标。

### P0-2：区分 Moore cochain 与 cohomology class

- [x] 新增加法 `classOf`、其 kernel 等于 boundaries 的条件、`hb_class_order : addOrderOf (classOf b_mot) = N` 与 `3 ≤ N`，并接入 M5 结论。由此原“b 是 boundary、但 cochain 有阶 N”的模型已被排除；不能再说只有 cochain 阶条件。
- [ ] 继续修订 `MotivicBackground` / `thm_motivic_seed` 的 integral Moore 与几何 antecedent 语义。
  - 仍保留 `hb_order : N • b_mot = 0` 的 cochain 等式；与 `hc_boundary` 合起来仍强制 `d c_mot = 0`。论文的 integral 两项 Moore 模型具有乘 N 的微分（L5422–5426），并要求 `d c = N b` 与上同调类 `ord[b] = N`（L5214–5235、L5407–5475）；不能继续把 cochain 本身的 N-torsion 当成该模型。
  - `classOf : Cochain →+ Cohomology` 作用于全部 cochains，仅规定 kernel，尚未明确定义 cycles / boundaries 商及与所声明整个 `Cohomology` 的识别。对闭合 b，新 kernel 和阶条件确实表达模 boundaries 的精确阶；这里待补的是完整复形和上同调接口，不是否认该进展。
  - `isGenuine_iff` 已替换任意标签，但只要求 Moore 等式及 `classOf x` 为非零 N-torsion；这仍允许纯 torsion、零微分的代数模型，未表达 invariant root coordinate / root-localization correspondence。应定义所需几何 antecedent 并给出比较，保留允许引用的外部 motivic 输入。
  - 验收：在忠实的复形与上同调接口中证明 `d b = 0`、`d c = N b`、`addOrderOf [b] = N` 或等价条件，并使几何 antecedent 的含义进入类型。

### P0-3：建立本提交可复现的构建与依赖审计

- [ ] 验证正式构建入口覆盖所有预定模块，并保存对应源码 SHA、命令、完整结果的构建与依赖审计凭据。新增配置和作者报告构成进展，尚不足以关闭本项。
  - [x] 源码层面已补入根目录 `lean-toolchain` 与 `lakefile.lean`：Lean `leanprover/lean4:v4.33.1`，Mathlib 固定到 `0df444a360eaa60ab8c11dca51a86af692955474`；新增 `BUILD.md` 说明复现步骤。仅确认文件与版本记录存在，不表示构建通过。
  - [x] 16 个实质解答已统一改为唯一的 `SelmerCartanMotiveTowers.sol_<name>`，消除原有同名 `solution` 冲突。`BUILD.md` 记录独立 Prove2Me 模块评测与联合导入的选择；后续源码已接回 Theorems，相关文档须同步（P1-5）。联合导入本身尚无本次独立验证。
  - 构建覆盖仍有静态缺口：[Lean v4.33.1 的 Lake 配置源码](https://github.com/leanprover/lean4/blob/v4.33.1/src/lake/Lake/Config/LeanLibConfig.lean#L30-L46)规定默认 `roots = #[name]`、`globs = roots.map Glob.one`；[Glob.one 只枚举该模块](https://github.com/leanprover/lean4/blob/v4.33.1/src/lake/Lake/Config/Glob.lean#L53-L59)。当前 `lakefile.lean` 的三个 `lean_lib` 未指定 `roots` / `globs`；默认目标只有 `Solutions`，仓库没有 `lean/Solutions.lean`、`lean/Definitions.lean` 或 `lean/Theorems.lean` 聚合根模块。须使用显式模块列表/递归 globs，或补齐导入全部预定模块的根入口，并验证实际覆盖，不能把裸 `lake build` 当作全部子模块已检查的证据。
  - 依赖和日志：Mathlib 已固定提交，其 toolchain 匹配，且该提交自带固定传递依赖的 manifest；仓库仍未提交根 `lake-manifest.json`，这是实际解析结果的留档缺口，不能据此声称依赖必然漂移。应保存干净 checkout 实际解析的依赖清单或等价证据。`BUILD.md` 要求记录源码 SHA、完整 `build.log` 和退出码，却未附这些运行产物；其 `lake build 2>&1 | tee build.log` 还须明确保留构建进程的退出状态，避免只记录 `tee` 的状态。
  - `lean/AXIOMS.md` 最新 blob 为 `1797d703f68823d64449ad65f285129dc6cdbac9`，报告 4 个显式 axiom、2 个无体 opaque、6 个 package instance、16 个 `sol_*` 共 28 项。M2/M11/M12/M13 报告依赖项目公理 `tau_one`，M9 报告无公理，其余 11 个解答及 6 个 instance 报告 Lean 基础公理；28 项均报告无 `sorryAx`。相对上一报告，M5/M7 的公理集合变为基础公理三元组。这是作者记录，审计脚本未入库，未记录所审源码 SHA、完整命令/日志/退出状态，本次未独立复现。
  - 继续单独核对 `Def_rec_one_mot.lean` 的 `tau_one`、`depth_of_full`、`depth_of_rec`、`tau_one_depth_fiber`，以及 `full_mot` / `rec_one_mot` 两个 opaque。报告称两个 opaque 无公理依赖；在可复现凭据齐备前，不把该陈述升级为本次验证结论。28 项没有列出接回的 16 个 Theorems 声明，也未逐项列全生产定义；后续 `067adca6` 新增的 Moore / pointed-carrier 定义、实例和辅助定理及修订后的 M3/M16 亦须刷新报告；“absent everywhere”须限定覆盖范围。背景包中的裸 `Prop` 标签也不能因未出现在公理报告中便被当作成立的假设。
  - 验收：在选定构建模式下逐项覆盖全部生产声明，提交可重跑的审计入口，保留每项 `#print axioms` / 等效报告，区分 `sorryAx`、Lean 基础公理、明确允许的项目公理、参数化背景假设；不能以文本 grep 或 SmokeTest 代替完整验证。

## P1：恢复声明所指的数学结构

### P1-1：收窄并逐项登记背景义务

- [x] 已新增 `lean/BACKGROUND_INPUTS.md`，记录 DEF/EXT/NUM/LEM 标签与使用声明，承认部分结果为条件组装。
- [ ] 继续核验并补全四个背景包的逐字段台账，区分“定义 / 外部定理 / 数值假设 / 本文待证引理 / 目标重述”；标签和文献名不能代替声明适用条件与依赖证明。
  - 台账宣称“Every field / exact fields / No GOAL!”尚不成立：例如漏列 `FormalBackground.nonempty_FramedSector`、`nonempty_Classical`、`nonempty_DGCategory`；M14 只泛称使用 §3 数据，未区分实际投影与未使用的 `lambda31_exact2`、`classNum93` 等标签。需逐项核对源码字段、定理体与其类型依赖。`kappa_ne_zero` 的反循环问题见 P0-1；`stackIsDerived` 等结论型字段不能因标 DEF 而当作已建立的结构。
  - `ClassFieldBackground.masseyExact` 目前对任意三个 exact-order 字符和 cup-vanishing 条件便给出 Massey 精确阶；未包含特选第三射线、中心 Frobenius、固定 Heisenberg lift、指定 nullhomotopy 或单位局部不变量。应限定到实际构造数据，不能仅凭注释中的文献名视为一般定理。
  - `FormalBackground.obsCocycle/liftIff/gaugeInv/natural`、`shadowZero/shadowMoore`、`stackIsDerived`、`eRecBijective/eFullBijective` 等直接提供对应结论；当前解答属于条件组装，不能替代这些构造和证明。
  - `WitnessBackground.crtLineHas/crtRealizationIs`、`gerbeIs/gerbeProvenance` 同理；`gerbeProvenance : ∀ W, ...` 还须关联到产生该 gerbe 的具体 witness。`067adca6` 已用三个 `pointed_cyclic_carrier` 替换 `hLar/hLsrc/hLMot/hSpan` 等旧接口，并构造 carrier 同构，台账 §5 仍列已删除字段，须更新；三条 carrier 与实际 W/M 的关联仍见 P1-4。
  - 验收：每个生产定理有精确依赖清单；允许的外部数值/理论输入保持显式，目标等价假设不得被当作目标已完成；论文内的构造义务有独立后续任务。

### P1-2：替换四类平凡模型通过路径

- [ ] 完成 M4 `thm_finite_confluent_interface` 的实际结构。进展：前两个 carrier 要求 `Nontrivial`，其余五个要求 `Nonempty`，并加入删除幂等、重标号与 linAct 的弱复合式，旧全 Empty 模型已排除。缺口：七个 carrier 仍是裸 Type；solution 把 direction 与 Γ^m 同取 `(S.primes → ℤ) × ℤ`、系数环取与 ν 无关的 ℤ，删除是常零自映射，permAct/linAct 作用于任意函数而非所需线性/PD 映射。声明仍允许前两 carrier 为 Bool、其余为 Unit、actions 全常值的弱模型。须接到实际 D_S、Γ^m、R_ν、confluence/defect/resonance、PD hull，补身份律、跨支撑删除/自然性，并保留空支撑等合法退化情形，不能用额外 ℤ 因子替代实际 direction lattice。验收对齐论文 L5147–5168。
- [ ] 完成 M6 `thm_channel_complete_realization` 的 dg / channel 语义。进展：加入从 S 定义的 `channel_index`、`chanMap` 单射，以及 carrier / corrAlgebra 的 `Nontrivial`，排除旧 Unit target。缺口：`channel_index` 未要求 A/B 非空，允许 `(∅, I)` / `(I, ∅)`，而论文 L5893–5898 要求两侧非空。solution 取 `channel_index S ⊕ Bool` / Bool 作为目标两 carrier，Source 为 `S.primes → Bool`；ρ 与 delMap 均为常值，ρ 的像甚至不触及 `Sum.inl` 通道，声明仍允许 Source 为 Unit。补齐实际 dg controller、对应代数、通道与实现的关联、跨支撑删除和 Moore 精确阶等，按论文 L6145–6189 七项性质验收；索引单射和幂等自映射尚不足以完成前两项。注释中“单射非空类型不能进入 Unit”过强，非空域本身不足以排除单射。
- [ ] 完成 M7 `thm_role_separated_objectification` 的角色与控制态射。进展：索引绑定 `S.primes.card`，要求 `2 ≤ card` 与实际存在 marked edge，旧 n=0 / Empty / Unit 路径已排除。缺口：`isSeparated` / `controlMarked` 仍是自由谓词，允许 `d = e`、`isSeparated = True`、标记为索引 `<`，未强制 controller/birth 分离或非零闭合 degree-zero 态射。声明还从给定任意 M 改成存在自造 `coeffOrder = 3` 的 M，是范围改写，未接回一般 N 的 M6 target，也未覆盖低支撑构造。须补 cutoff functoriality、higher cells 与 Morita 相容性，按论文 L6297–6327 验收，不能只以一个存在边的集合模型替代。
- [ ] 完成 M8 `thm_finite_motivic_recursion_closure` 的有限递归结构。进展：加入 target 两 carrier 的 `Nontrivial`、`ledger : Fin M → motivic_moore_reedy` 与同一 ceiling 内 carrier 共享；M/hM 已进入源码，旧 Unit carrier 路径已排除。缺口：solution 用 `Fin M` / Bool 作底层 carrier / corrAlgebra，ledger 为常值；底层 carrier 随 ceiling M 增长，现有等式未表达论文 L12538–12543 跨 ceiling 的 no-growth，也未把 Fin M 绑定到正确的 3≤n≤M jet 层。补齐 support–jet、Reedy/latching、history、bar/transgression、readout 与 successor 的六项闭包及混合交换图（L12472–12550）；同 carrier 不等于共享 dg / root 结构，不能把常值 ledger 当作闭包验收。

### P1-3：从任意函数/类型恢复 obstruction、category 与 stack

- [ ] M2 `thm_universal_higher_obstruction_recursion`：定义 graded dg algebra、PD filtration、MC jet 和 obstruction class，由 Bianchi/度数计算推出 cocycle、lifting、gauge、naturality；补回 filler torsor 等遗漏条款，而非直接取 `FormalBackground` 的同名结论。
- [ ] M9 `thm_successor_stage_functor`：当前在给定 `nextObstruction`、`mooreLift`、`hMooreClosure` 后，选择一个保持谓词的函数族；声明甚至未强制它等于给定的 Moore lift。补充明确公式、marked stage、态射映射/函子律、homotopy pullback / Moore relation、support 与 frame/representative independence，保留 coefficient-depth firewall。
- [ ] M11–M13 `thm_classical_low_sector_comparison`、`prop_stack_globalization`、`thm_marked_morita_independence`：分别建立实际 shadow functor、pseudo-perfect-module moduli/derived-stack 条件、pointed marked Morita equivalence 及诱导的有限塔/stack 等价；目前的任意谓词、类型和集合双射不足以表达这些结构。
  - 验收：每一项将论文条件与结论逐条配对；底层对象、态射、函子及交换/自然性条件均在类型中出现，测试其不能通过恒真谓词或无关集合双射满足。

### P1-4：补齐比较映射与 prime-power / witness 实现

- [x] M3 已从抽象生成元同态改为具体 `ZMod (p*q^2)` 与 `ZMod p × ZMod (q^2)` 之间唯一 pointed `AddEquiv`，新增 `p ≠ q` 的 CRT 前提及 q-primary reduction / residual generator 相容性；另有 `ℤ ⧸ (pq²)ℤ ≃+ ZMod (pq²)` 的商群同构源码。此前“未写出 AddEquiv / reduction”的缺口已修复，这是真正的代数层进展。
- [ ] 继续将 M3 的通用代数模型接到论文实际对象：`moore_complex` 只记录 degree，`mooreDiff` 与定义为 `zmultiples` 的 boundaries 尚无 image 等式以及商中 `[1]` 对应 `mooreGen` 的证明链，主证明未调用该商群同构；`conf_line` 和 residualGen 被指定为 ZMod 模型和 1，没有 W_q、κ̃、filtered confluence 或所需识别映射。补这些接口与生成元/约化交换关系，按论文 L2235–2260 验收。无需误报原 cyclic-group 论证为假命题，也不否认新增 CRT 与商群证明。
- [ ] M10 `thm_prime_power_comparison`：把具体有限 `ν`、`Nν`、CRT product、相容的 p-power reductions、Moore presentation 和 support-functorial dg realization 绑定起来。当前与 `S` 无关地投影两个存在性字段不表达比较；一般 odd prime-power 层不能被 `motivic_moore_reedy.coeffOrder_squarefree` 的限制替代。验收对齐论文 L13000–13076 的 reductions、共振深度及五坐标条件。
- [x] M16 已用 `pointed_cyclic_carrier` 表示加法群、精确阶 31 的生成元及全体生成性，构造经过 `ZMod 31` 的真实 pointed carrier 同构；`hSpan` / 任意三元谓词的直接投影已移除。仅此 carrier-level 代数构造是已完成子项，不等同于 operation-level provenance。
- [ ] M15 `thm_gerbe_provenance`：补充具体 classifying map、unipotent central extension、pullback class 等式及来源识别，不能以任意 `provenanceFor` 谓词与 `gerbeProvenance` 背景字段代替；对齐论文 L15832–15873。
- [ ] M16 `thm_motivic_specialization`：W 与 M 仍是未使用 binder，`bg.Lar/Lsrc/LMot` 只作为彼此独立的 order-31 carriers，未与 W 的 arithmetic/source class、M 的指定 I_* Moore block、marking 相连。补三条实际 carrier 的识别及与所给 W/M 的联系，按论文 L16066–16107 验收；保持 carrier span 与 M15 的 operation-level provenance 分开。

### P1-5：接回草稿并修正文档统计

- [x] 源码层面已把全部 16 个 `sol_*` 接入对应 Theorems：每项都新增正确 import 并调用对应解答，去注释/规范化空白后的参数与结论一致；旧 `by sorry` 已从生产声明移除。该完成项只描述源码接线，不代表语义验收或编译通过。
- [x] `8a1d6783` 已更正 README 中 M14 重复计数与 SmokeTest 统计：16 个实质解答含主目标，第17个文件仅为烟雾测试。
- [ ] 同步最新声明、模块和构建模式的文档：`lean/README.md` 仍写“12 definitions”“16 theorem drafts / by sorry”“drafts are not yet discharged”；实际已有 15 Definitions 文件，16 Theorems 已接线；背景台账与公理报告尚未追上 M3/M16 新接口。`BUILD.md` 也仍称接回草稿待办。`AXIOMS.md` 称 6 个 instance 全为新增，但其中 `MotivicBackground.instAddCommGroup` 已在初始基线存在。
- [ ] 继续收窄“全部已证明”“all modules build cleanly”等陈述：明确是哪些条件式声明、哪些输入与构建凭据，并保留源码完成、编译验证、依赖公理和与论文语义差距的区别。先前语义任务仍须按各自验收，不因接线或消除文本 `sorry` 自动关闭。
  - 验收：统计从真实声明和依赖闭包生成，逐项显示“文本完成 / 编译验证 / 依赖公理 / 与论文差距”；`MISSION_DESCRIPTION.md`、`INVENTORY.md` 与代码状态不相互矛盾。

## 声明与文件索引

所有名称位于 `SelmerCartanMotiveTowers`。Definitions 的依赖骨架：`finite_ordered_support → typed_coordinates`；`typed_coordinates → source_package、adic_witness`；`adic_witness、finite_ordered_support、pointed_cyclic_carrier → WitnessBackground`；`finite_ordered_support → channel_index`；`full_mot → rec_one_mot → selmer_cartan_tower → FormalBackground`；`finite_ordered_support → motivic_moore_reedy`。`ClassFieldBackground`、`MotivicBackground` 各自引入额外背景接口。箭头从被导入定义指向使用方；详见各文件 import。

| Definitions 文件（位于 `lean/Definitions/`） | 主要声明 |
| --- | --- |
| `Def_finite_ordered_support.lean` | `finite_ordered_support` |
| `Def_channel_index.lean` | `channel_index` |
| `Def_moore_cohomology_line.lean` | `moore_complex`、`mooreDiff`、`mooreBoundaries`、`moore_line`、`mooreGen`、`conf_line`、`confGen`、`residualGen`、`residualGen_ne_zero`、`qPrimaryRed`、`moore_cohomology` |
| `Def_pointed_cyclic_carrier.lean` | `pointed_cyclic_carrier`、其 `instAddCommGroup`、`nat_card_eq`、`canonicalIso`、`canonicalIso_apply_gen` |
| `Def_typed_coordinates.lean` | `confluence_multiplicity`、`coefficient_exponent`、`obstruction_height`、`typed_coordinates` |
| `Def_source_package.lean` | `source_package` |
| `Def_full_mot.lean` | `full_mot` |
| `Def_rec_one_mot.lean` | `rec_one_mot`、`tau_one`、`depth_of_full`、`depth_of_rec`、`tau_one_depth_fiber` |
| `Def_motivic_moore_reedy.lean` | `motivic_moore_reedy` |
| `Def_selmer_cartan_tower.lean` | `selmer_cartan_tower` |
| `Def_adic_witness.lean` | `adic_witness`、`AdicWitness.instAddCommGroupTerminal`、`AdicWitness.instAddCommGroupLocal` |
| `Def_classfield_background.lean` | `ClassFieldBackground` |
| `Def_motivic_background.lean` | `MotivicBackground`、`MotivicBackground.instAddCommGroup`、`MotivicBackground.instAddCommGroupCohomology` |
| `Def_witness_background.lean` | `WitnessBackground`、`WitnessBackground.instAddCommGroupObstruction`、`WitnessBackground.instAddCommGroupLocalObstruction` |
| `Def_formal_background.lean` | `FormalBackground` |

下表每行声明 `x` 对应 Theorems 生产声明 `lean/Theorems/Thm_SelmerCartanMotiveTowers_x.lean`，以及独立解答 `lean/Solutions/Sol_x.lean::sol_x`（`8a1d6783` 起采用唯一名称）。

| 里程碑 | 声明 x | 当前证明/接口重点 | 对应待办 |
| --- | --- | --- | --- |
| M1 / Thm 6.5 | `thm_ray_class_primitive` | `ClassFieldBackground` 的两射线、第三射线、lift、Massey 字段组装 | P1-1 |
| M2 / Thm 9.4 | `thm_universal_higher_obstruction_recursion` | `FormalBackground` 四个结论字段 | P1-1、P1-3 |
| M3 / Thm 8.21 | `thm_formal_filtered_alignment` | 具体 CRT pointed AddEquiv 与 q-reduction，待接实际 filtered line | P1-4 |
| M4 / Thm 11.6 | `thm_finite_confluent_interface` | 已排除全 Empty；非平凡集合及零删除映射 | P1-2 |
| M5 / Thm 12.2 | `thm_motivic_seed` | 已加入类精确阶；仍为背景 Moore 数据投影 | P0-2 |
| M6 / Thm 19.6 | `thm_channel_complete_realization` | channel_index 非平凡 target；实现仍可常值 | P1-2 |
| M7 / Thm 19.9 | `thm_role_separated_objectification` | 支撑基数索引且存在边；改为自造 target | P1-2 |
| M8 / Thm 25.14 | `thm_finite_motivic_recursion_closure` | Fin M carrier 与 history / ledger 形状，尚无结构 | P1-2 |
| M9 / Thm 26.7 | `thm_successor_stage_functor` | 给定 obstruction/Moore lift/closure 后的函数组装 | P1-3 |
| M10 / Thm 26.12 | `thm_prime_power_comparison` | `WitnessBackground` 中 CRT 与 realization 字段投影 | P1-1、P1-4 |
| M11 / Thm 27.5 | `thm_classical_low_sector_comparison` | shadow 数据及性质投影 | P1-3 |
| M12 / Prop 13.5 | `prop_stack_globalization` | `stackIsDerived` 直接投影 | P1-3 |
| M13 / Thm 30.2 | `thm_marked_morita_independence` | 已给定双射及 intertwining 性质投影 | P1-3 |
| M14 / Thm 37.1 / 主目标 | `thm_31adic_witness` | 真实 W4 证据字段；非零仍直接取背景 | P0-1 |
| M15 / Thm 38.1 | `thm_gerbe_provenance` | `gerbeIs`、`gerbeProvenance` 投影 | P1-4 |
| M16 / Thm 38.5 | `thm_motivic_specialization` | 已构造 order-31 pointed carrier 同构；W/M 尚未关联 | P1-4 |

另有 `lean/Solutions/SmokeTest.lean`，只计作烟雾测试，不计作论文里程碑。

## 后续增量检查规则

- 从上述完整源码基线之后检查新增提交；只改变本 TODO 的提交不构成新的 Lean 成果或构建凭据。
- 源码、声明、背景输入或构建配置变化时，重新核对受影响的定义、依赖及论文条款，再更新对应条目的状态。
- 只有完成该条验收且有相应证据才勾选；单个 `sorry` 消失、README 更新、局部测试通过或条件结论被投影出来，都不足以单独关闭语义任务。
