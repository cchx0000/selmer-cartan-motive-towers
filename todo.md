# Lean 形式化 TODO

## 审计基线与范围

- 审计日期：2026-10-09 至 2026-10-10（UTC）；默认分支：`main`。
- 首次实际 Lean 提交 / 首次完整源码审计基线：[`ebf86316451f383234c3cf437cec35b01fc1f8fa`](https://github.com/cchx0000/selmer-cartan-motive-towers/commit/ebf86316451f383234c3cf437cec35b01fc1f8fa)。
- 审计树：`f51c14d9554345fcdd8d05d70ebafef81fdc7e3a`；前一提交：`55f336e8485b692bc505e6ee77bbd0ec7c5f9420`。两者直接相邻；前一版本只有 README 与论文，新提交首次加入实际 Lean 源码。
- 论文：[`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`](selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex)，blob `6ee1db83403ec5aed4ad67fd978c25a85d2edd22`。本次对照相关原文及 `MISSION_DESCRIPTION.md`、`INVENTORY.md`，没有对整篇论文作数学正确性认证。
- 初始基线已静态检查 `lean/` 下全部 45 个 Lean 文件：12 个 Definitions 文件、16 个 Theorems 文件、16 个实质 Solutions 文件及 `SmokeTest.lean`。定义文件包含 13 个 structure、2 个无显式定义体的 opaque、4 个显式 axiom，以及一个实例声明。
- 初始基线的 16 个草稿各保留一个 `by sorry`。当时 16 对草稿与 solution 的参数和结论在去注释、规范化空白后相同，Solutions 未接回 Theorems。后续 `460ac27c` 已在源码层面接回全部 16 项，当前情况见下方增量记录；文本检查不等于传递依赖无公理或编译验证通过。
- 初始基线审计未运行 Lean、Lake、证明或平台 `/verify`。该基线树中没有 `lean-toolchain`、`lakefile.lean` / `lakefile.toml`、依赖锁定文件或工作流；该提交 GitHub check-runs、commit statuses 和仓库 Actions runs 均为 0。后续配置与作者提供的审计报告变化见下方增量记录。

### 2026-10-09 增量审查：截至 `067adca6`

- 本次检查 [`02ba97f4608a8bd2bad6853bf3b017552459f4b6...067adca62e34c8b4677c2473ee378c40fcef899f`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/02ba97f4608a8bd2bad6853bf3b017552459f4b6...067adca62e34c8b4677c2473ee378c40fcef899f)，新增 3 个直接相邻提交；该次源码审查游标为 `067adca62e34c8b4677c2473ee378c40fcef899f`，树为 `b379e89a9182e7d192d0b8e9b4cffcd6bfa9907c`。前一游标 `02ba97f4` 只更新本 TODO。
- `8a1d6783a4e4459ee11a0769cd8d2c8d02292ef7` 新增 `lean-toolchain`、`lakefile.lean`、`BUILD.md`、`lean/AXIOMS.md`，16 个实质 Solutions 仅改为唯一的 `sol_<name>`，并更正 README 的 M14 重复计数和 SmokeTest 统计。
- `460ac27c2604e33857f2f57ea6c43ae817359d4e` 新增 `channel_index` 与背景输入台账，强化 witness / motivic 接口和 M4/M6/M7/M8 的声明，全部 16 个 Theorems 导入并调用对应 `sol_*`。该提交已有 46 个 `lean/` 源文件；源码接线检查不代表编译通过。
- `067adca62e34c8b4677c2473ee378c40fcef899f` 新增 Moore 商群/CRT 模型与 pointed order-31 carrier，M3 新增唯一 pointed `AddEquiv` 及 q-reduction，M16 从实际 cyclic carrier 数据构造同构，不再投影任意 span 谓词。该次静态重查 `lean/` 下 48 个 Lean 文件（15 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根目录另有 `lakefile.lean`）：16 个 structure、2 个无体 opaque、4 个显式 axiom、7 个 instance。16 对生产定理/解答的参数和结论去注释、规范化空白后相同；去注释源码无可执行的 `sorry` / `admit` / `unsafe`。
- 论文、mission、四个项目 axiom 和两个 opaque 未改。该次源码修掉若干旧反例；其 W1/W2、非零推导、integral Moore 关系和 dg/几何缺口的后续变化见下次增量与对应条目。
- `lean/AXIOMS.md` 在 `460ac27c` 从 22 项更新为作者报告的 28 项输出，尚未随 `067adca6` 的新增定义/实例和 M3/M16 变化更新；脚本未入库，未附所审源码 SHA、完整运行日志和退出状态。本次未运行 Lean、Lake 或 `/verify`。该次源码 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0，尚无该 SHA 的独立可复核构建凭据。

### 2026-10-09 增量审查：截至 `bb298a04`

- 本次逐提交检查 [`977450467cd4794f25cf2aa8c7292c502c6f19a2...bb298a04daa6899d5bfd679713c469226e61a526`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/977450467cd4794f25cf2aa8c7292c502c6f19a2...bb298a04daa6899d5bfd679713c469226e61a526)，新增 4 个直接相邻提交；该次源码审查游标为 `bb298a04daa6899d5bfd679713c469226e61a526`，树为 `a1bdeb901263a5f8d3b50f31465772d80c474936`。前一提交 `9774504` 只更新本 TODO。
- `e61373deee1db16d2c957318dc722404d0517fc8` 新增 DGA/curvature、CRT/prime-power reduction 和 classical-cone 数值模型，改写 M2/M10/M11，并新增 `P1_INFEASIBLE.md`。代数辅助结果有实质进展；改写后的生产结论仍须逐项与论文核对，不能将更弱命题沿用旧名后视为原目标完成。
- `a3020f105622af73afb0f3d687c3371e47e6f9a8` 将 `kappa_ne_zero` 从字段改为由 pairing 关系、其检出条件和 Kummer 等式导出的引理；删除 Moore cochain 的 `hb_order` / `hb_exact`；将作者公理报告扩为 47 项。这修掉旧的直接字段投影和强制 `d c = 0` 路径，尚未建立实际算术 pairing 或忠实 integral complex。
- `1d69e6ada613f6e05d73746ad9dd953333e2b5b5` 补齐 channel 的 A/B 非空，新增 ZMod-valued Dirac 单射及其精确阶源码，并改写 M6 的具体 `ρ` / 删除。`bb298a04daa6899d5bfd679713c469226e61a526` 新增 direction-lattice projection、role separation 和 jet-tower/跨 ceiling ledger 模型，改写 M4/M7/M8；其结构连接与仍允许的弱模型见 P1-2。
- 完整树含 `lean/` 下 54 个 Lean 文件（21 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根目录另有 `lakefile.lean`）。去注释静态扫描有 24 个 structure、10 个 instance 声明、4 个显式 axiom、2 个无体 opaque；无可执行 `sorry` / `admit` / `unsafe`。全部 16 对生产定理/解答的参数和结论去注释、规范化空白后相同，生产声明仍调用对应 `sol_*`。
- 论文、mission、四个项目 axiom、两个 opaque、构建配置和 `BUILD.md` 未改。当前源码 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0；本次没有运行 Lean、Lake、证明或 `/verify`。`AXIOMS.md` 已补 source SHA，但该 SHA 当前无法通过仓库 API 解析，且无入库脚本、完整日志及退出状态；不能视为当前源码的可复现凭据。

### 2026-10-10 增量审查：截至 `ba4b2e73`

- 本次逐提交检查 [`f62187dac9b8f3d2e4fe86f3e1fe0fe32c15deed...ba4b2e73209b3713a2fd351b299ca2e891b8a0c2`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/f62187dac9b8f3d2e4fe86f3e1fe0fe32c15deed...ba4b2e73209b3713a2fd351b299ca2e891b8a0c2)，新增 3 个直接相邻提交，共改变 13 个文件；该次审查游标为 `ba4b2e73209b3713a2fd351b299ca2e891b8a0c2`，树为 `25919894620f53e2b7f7a4b4cd4318240c919bbb`。前一提交 `f62187d` 只更新本 TODO；本轮审查前 TODO blob 仍为 `4a543bfacca14bafca17bac07f0179caedc1dfa1`。
- `69274136cbd42dacdc2714785a056b4a77bae1d2` 为三个 library 加入递归 submodule globs，并更新 `BUILD.md` / `lean/README.md` 的接线说明。旧“未配置 globs”缺口已修复；默认目标仍只有 Solutions，README 实际仍列 18 Definitions（真实为 21），不能按提交说明的“21”记为完成。
- `8c1f2e1a38a2ca716cf976dadeafbc5ba0652160` 修改 `Def_jet_ledger.lean` 与 M4/M6/M7/M8 的四对声明/解答：M4 将存在对象与实际方向格、系数环、删除及重标号绑定；M6 新增 ring、非平凡 Source 与非恒定 ρ；M7 显式列出分离及 carrier/algebra 非平凡；M8 新增 latch 跨层相等律，并将 history/ledger 等式显式列入结论。这些源码强化应计入进展，剩余 dg、通道及递归语义见 P1-2。
- `ba4b2e73209b3713a2fd351b299ca2e891b8a0c2` 只更新 `lean/BACKGROUND_INPUTS.md`：撤下已删除 cochain torsion 字段的当前表项，纠正 M2/M10 消费项，并承认 M14 的 `kummerEqKappa` 及 pairing 推导链被使用。P1-1 中相应四项陈旧记录已撤销；背景输入是否足以表达论文目标仍须另验。
- 重查完整当前树的 54 个 `lean/` 源文件（21 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根目录另有 `lakefile.lean`）：24 个 structure、10 个 instance 声明、4 个显式 axiom、2 个无体 opaque；去注释/字符串后无可执行 `sorry` / `admit` / `unsafe`。16 对生产定理/解答的参数和结论去注释、规范化空白后仍相同，调用对应 `sol_*`；这是静态检查，不是 Lean 编译或数学完备性认证。
- 论文、mission、项目 axiom/opaque 与 `AXIOMS.md` 未改。本次三个新 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0；没有运行 Lean、Lake、证明或 `/verify`。47 项作者公理报告的 source SHA `d5ffb0e985fcbd60b388929d2a685437e8088e70` 重查仍返回 `422: No commit found`；不可当作本轮源码的可复现构建或依赖凭据。

### 2026-10-10 增量审查：截至 `ab3d6668`

- 本次逐提交检查 [`a7f5edd0aba885b54d2174fb1c1b8f2e50aa4b7e...ab3d666826428d2224124283f81ba252be2a396e`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/a7f5edd0aba885b54d2174fb1c1b8f2e50aa4b7e...ab3d666826428d2224124283f81ba252be2a396e)，新增 2 个直接相邻提交，共改变 4 个文件；该次审查游标为 `ab3d666826428d2224124283f81ba252be2a396e`，树为 `765ab0bc78a8c8e8a237f52ab4aaf9b1904f530c`。前一提交 `a7f5edd0` 只更新本 TODO；本轮审查前 TODO blob 仍为 `e0b90b18e178c3bbac44bdf8d33e557b064c4c93`。
- `50d92fcdf8a425996905b2ad98c782798a58eada` 只更新 `lean/README.md`：将 Definitions 从 18 更正为 21，并列出 `confluent_package` / `role_separation` / `jet_ledger`。已与树中 21 个定义文件核对，撤销该统计缺口；末尾“接回草稿待办”等其余文档问题仍在。
- `ab3d666826428d2224124283f81ba252be2a396e` 新增根 `lake-manifest.json`、`lean/build_logs/build_solutions_20261010.log` 和 `source_sha.txt`。manifest 记录 Mathlib 及 8 个传递依赖的固定 revision，Mathlib 与 `lakefile.lean` 一致；日志末尾确有 `Build completed successfully (3042 jobs).` 与 `EXIT_CODE=0`，应记为作者提供的成功运行报告，不能再说未附日志或退出码。
- 构建凭据仍未与本仓库可定位源码闭合：`source_sha.txt` 为 `e3495042c151d35b82750f12004e5fcb70042022`，本次仓库 API 返回 `422: No commit found`；manifest 根包名为 `prove2me`，与当前 `lakefile.lean` 的 `selmer-cartan-motive-towers` 不同。日志未记录实际命令、工具版本或干净 checkout 状态，含 `Replayed` 项，且没有 Theorems 目标覆盖证据。以上是来源/覆盖待核对项，不等于证明构建失败；成功摘要和缓存重放也不足以独立认定当前 54 个模块已完整构建。
- 树级逐 blob 对比确认：54 个 `lean/` 源文件、`lakefile.lean`、`lean-toolchain`、论文、mission、背景输入台账及 `AXIOMS.md` 均未变化，沿用上一轮的源码接线、`sorry` / `admit` / `unsafe`、axiom / opaque、模型与论文语义审查结论；本轮没有重新编译。两个新 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0；旧公理报告 source SHA `d5ffb0e985fcbd60b388929d2a685437e8088e70` 重查仍不可解析。P0-3 及各语义任务保持未完成。

### 2026-10-10 增量审查：截至 `4cb1359a`

- 本次逐提交检查 [`dce65c244ca5913a88b549e838ae3b9a913feb44...4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/dce65c244ca5913a88b549e838ae3b9a913feb44...4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1)，新增 4 个直接相邻提交，共改变 23 个文件；该次审查游标为 `4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1`，树为 `93576b467c3243f14d0f67b84826f8f75344137d`。前一提交 `dce65c244ca5913a88b549e838ae3b9a913feb44` 只更新本 TODO；本轮审查前 TODO blob 为 `4a3859263732d8af3e1e6cde373ceb155da7c75b`。
- `1b39daa3804fb820c58d026b44fc460db5c8acd6` 为 M10 加入完整有限 CRT 保点 `RingEquiv`、分量等于实际 reduction 及 p-power reduction 复合律，并接入生产结论；M11 将 0→1 复形的 cokernel 次数改为 H¹；README 删除接回草稿待办并明确 conditional scope。相应旧批评撤销。`AXIOMS.md` 增加 7 个 CRT 项到 54 项，但页尾仍写 47，source SHA 未更新。
- `3d631e4dba1b2082aee81d97488477974e267e1e` 为 M3 加入 `mooreDiff_range`、`PrimitiveFilteredInterface` 及生成元/约化辅助接口；为 M4 加入 `gammaMult`、`coarsen`、`extendSupport`，生产声明绑定前两者。代数进展有效；M3 的 `[1]` 对应声明仍只是无证明的 Prop 定义，M4 的数乘和坐标删除尚不是论文的 Γᵐ / Conf(m) 操作，见对应任务。
- `4a2863cd5aa6fe54b68368fdb20880b71d1d5068` 加强 witness 的精确阶 31、分支 Add/Mul、carry restriction 律与 ZMod 31-valued 双线性 pairing；M5 改为只对闭合 b 取类，并新增 `GeometricAntecedent`。旧 `N² • b = 0` 推导不再成立；但任意类型/常值 localization 仍可满足新增几何字段。`kappaOrder31` 本身已蕴含 κ 非零，须按 mission 重新审计其非循环来源。
- `4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1` 为 `SuperDGA` 加入偶/奇子群直和、乘法次数与 d 翻转次数条件；M16 从 W 的 terminalClass 生成子群构造保点同构，并用新增 `hM` 关联 M。旧“isOdd 任意”“W/M 未使用”批评撤销；混合元素的全元素 Leibniz、假定的裸类型 hM 与实际 I_* Moore block 的差距仍在。
- 重查完整当前树 54 个 `lean/` 源文件（21 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根另有 `lakefile.lean`）：26 个 structure、12 个 instance 声明、4 个显式 axiom、2 个无体 opaque。去注释/字符串后无可执行 `sorry` / `admit` / `unsafe`；16 对生产定理/解答的参数、结论规范化后相同，并导入/调用对应 `sol_*`。复核变动定义、核心依赖、模型及论文对应条款；本次没有运行 Lean、Lake 或 `/verify`，静态证明体检查不等于编译通过。
- 论文、mission、项目 axiom/opaque、构建配置、manifest 与作者 build log 未变。4 个新 SHA 的 check-runs、commit statuses、Actions runs 均为 0。构建 source `e3495042c151d35b82750f12004e5fcb70042022` 与公理报告 source `d5ffb0e985fcbd60b388929d2a685437e8088e70` 重查仍各返回 `422: No commit found`；新增证明晚于现有日志，原凭据不能覆盖本轮源码。日志中 M16 的旧 W/M-unused 警告也对应改写前声明；P0-3 继续开放。

### 2026-10-10 增量审查：截至 `a8591d8b`

- 本次逐提交检查 [`a2e943d4f1a839783af20a7d7338f5bc05a08f57...a8591d8b7ef4a012c9e37684ae99470718662bc5`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/a2e943d4f1a839783af20a7d7338f5bc05a08f57...a8591d8b7ef4a012c9e37684ae99470718662bc5)，新增 2 个直接相邻提交，共改变 13 个文件；该次源码审查游标为 `a8591d8b7ef4a012c9e37684ae99470718662bc5`，树为 `8dd6cdc87bd2fd3412377b990a1097e0d65355d3`。前一提交 `a2e943d4` 只更新本 TODO；本轮审查前 TODO blob 为 `5d0045b2deb9088ad2e9a852ece5ca9f627d9055`。
- `936f7824317007c730e9798e6d47024feafabf6d` 新增 `omegaClass`、`channelOfFinset` 与 `omega_order`，生产 M6 现在真正约束 `ρ (omega I)` 的精确加法阶 N，应撤销“无 Ω / 只约束独立 chanMap 的阶”。这是 Boolean/product 模型的代数进展，尚无 obstruction-cohomology 识别；`reesCoeff` 只是数值三元组 1,N,N²，未给乘法律或接入生产结论。
- `a8591d8b7ef4a012c9e37684ae99470718662bc5` 为 M7 加入保零/保加法且非零的 endomap，为 M8 加入加法群分解、`dγ=Nβ`、删除—latch 交换和共同 apex，为 M15 加入 `ClassifyingMap/PullbackIdentity/UnipotentExtension/GerbeProvenance`。旧“只有端点 / 完全没有 splitting 或 provenance 数据”的表述须撤销，剩余语义见 P1-2/P1-4。
- **当时新增 P0 阻断：`UnipotentExtension` 的字段不相容（已于 `bbef8d5ce3e90de3aaecae2be696b063a4c536b0` 源码修复，见下次增量及 P0-0）。** `kernelCentral` 在 t=0 强迫 kernelGen=0，故 `addOrderOf kernelGen=1`，与 `kernelOrder=31` 矛盾。`GerbeProvenance.extension` 与 `WitnessBackground.gerbeProvenanceData` 逐层继承此空类型；M10/M14/M15/M16 的背景前提不可满足。该结论来自源码数学检查，不是编译结果，也不表示 Lean 本身不一致；详见 P0-0。
- 重查全部 55 个 `lean/` 源文件（22 Definitions、16 Theorems、16 实质 Solutions、1 SmokeTest；根另有 `lakefile.lean`）：31 个 structure、15 个显式 instance 声明，另有 1 条 instance attribute；4 个既有 axiom、2 个无体 opaque。去注释/字符串后无可执行 `sorry` / `admit` / `unsafe`；16 对生产定理/解答的参数与结论规范化后相同，并导入/调用对应 `sol_*`。无 sorry 或无新增公理不能证明参数化背景可满足。
- 论文、mission、项目 axiom/opaque、构建配置、manifest 与 build log 的 blob 均未改变。本次两个新 SHA 的 check-runs、commit statuses 和 Actions runs 均为 0；API 的 pending/0 statuses 不代表有构建在运行。构建 source `e3495042c151d35b82750f12004e5fcb70042022` 与公理报告 source `d5ffb0e985fcbd60b388929d2a685437e8088e70` 重查仍各返回 `422: No commit found`。`AXIOMS.md` 新增 M15 作者再审文字，但未更新来源/覆盖凭据。没有运行 Lean、Lake 或 `/verify`；P0-3 保持开放。

### 2026-10-10 增量审查：截至 `bbef8d5c`

- 本次检查 [`2eb2b5e2737d4a82ff679e80a0bba05a4478490a...bbef8d5ce3e90de3aaecae2be696b063a4c536b0`](https://github.com/cchx0000/selmer-cartan-motive-towers/compare/2eb2b5e2737d4a82ff679e80a0bba05a4478490a...bbef8d5ce3e90de3aaecae2be696b063a4c536b0)，新增 1 个直接相邻提交，仅改变 `lean/Definitions/Def_gerbe_provenance.lean` 与 `lean/BACKGROUND_INPUTS.md`；最新源码审查游标为 `bbef8d5ce3e90de3aaecae2be696b063a4c536b0`，树为 `7b152aeb9901768a3d036e73a01c2e0e7aa26400`。前一提交 `2eb2b5e2737d4a82ff679e80a0bba05a4478490a` 只更新本 TODO；本轮审查前 TODO blob 为 `bb9c24ee5e152126555b9a12d1474b1497fa76a1`。
- `UnipotentExtension.kernelCentral` 已改为 `∀ t, t + kernelGen = kernelGen + t`；新增 `totalScalar`、`projGenTrivial`、`projKernel` 和 `unipotentExtensionModel`（total = ZMod 31、base = Unit、kernelGen = 1）。静态数学检查确认旧“取 t=0 强迫生成元为零”的矛盾已消除，给出的模型满足这些字段的数学关系；撤销当前 M10/M14/M15/M16 因该字段而有空背景前提的判断，保留上轮历史。[当前结构与模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bbef8d5ce3e90de3aaecae2be696b063a4c536b0/lean/Definitions/Def_gerbe_provenance.lean#L81-L123)
- 修复只提供 `UnipotentExtension` 的模型源码，没有构造整个 `WitnessBackground` 或其实际算术 realization；`SMul` 未给作用律，`proj` 仍是指向无群结构 Type 的普通函数，`projKernel` 仅给 `proj t = proj 0 → ∃ n, t = n • kernelGen` 一向包含，未给逆向；中心性在 `AddCommGroup` 中自动成立。因此台账“kernel = multiples”和注释“genuine central extension / μ₃₁-module / hence WitnessBackground”须收窄，剩余语义按 P1-4 验收。
- 已重读 M10/M14/M15/M16 的生产声明、solutions 与 `WitnessBackground`；这些文件均未改变，M15 仍投影背景的 provenance，M10 的 dg realization、M14 的算术来源、M16 的 hM/block 联系等原缺口未被本次修复。树仍含 55 个 `lean/` 源文件；论文、mission、项目 axiom/opaque、构建配置、manifest、build log 与 `AXIOMS.md` 未变。
- 该 SHA 的 GitHub check-runs、commit statuses、Actions runs 均为 0；pending/0 statuses 不表示正在构建。构建 source `e3495042c151d35b82750f12004e5fcb70042022` 与公理报告 source `d5ffb0e985fcbd60b388929d2a685437e8088e70` 重查仍各返回 `422: No commit found`。提交说明/注释的“Lean-verified”是作者陈述，未附本次新增模型的可复核构建凭据；本次未运行 Lean、Lake 或 `/verify`，P0-3 保持开放。

当前应报告为“旧 UnipotentExtension 字段矛盾已在源码层面修复的条件式骨架；独立局部代数构造另行保留，完整背景实例、声明语义和复现缺口仍须分别核验”。仓库声明的 Strategy A 允许列明的外部算术输入；下面区分允许的输入、与结论等价的假设、以及根本没有证明字段的命题标签。数值证书的第一性原理验证不自动纳入当前 mission。

## P0：先修正主目标与可信度边界

### P0-0：旧空背景缺陷已源码修复（M10/M14/M15/M16）

- [x] 源码层面修复 `Def_gerbe_provenance.lean::UnipotentExtension` 的旧矛盾；本完成项不代表独立编译或完整算术背景已验证。
  - 历史：[`a8591d8b7ef4a012c9e37684ae99470718662bc5` 的旧定义](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Definitions/Def_gerbe_provenance.lean#L68-L81) 要求 `kernelCentral : ∀ t, ∃ n : ZMod 31, t + kernelGen = t`，在 t=0 强迫 kernelGen=0，与 `kernelOrder=31` 矛盾。该缺陷当时经 `GerbeProvenance.extension` 传到 `WitnessBackground.gerbeProvenanceData`；不意味着 Lean 全局不一致。
  - [当前定义与模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bbef8d5ce3e90de3aaecae2be696b063a4c536b0/lean/Definitions/Def_gerbe_provenance.lean#L81-L123) 已用 `t + kernelGen = kernelGen + t` 替换旧式，并提供 `unipotentExtensionModel`：ZMod 31 上的 1 具有精确加法阶 31，投影到 Unit，`projKernel` 取 n=t 后由 t·1=t 满足。旧矛盾的源码/数学验收已满足；不再据此把 M10 `thm_prime_power_comparison`、M14 `thm_31adic_witness`、M15 `thm_gerbe_provenance`、M16 `thm_motivic_specialization` 及 `WitnessBackground.kappa_ne_zero` / `marking_compat` 称为空前提结果。
  - 模型声明的类型仅是 `UnipotentExtension`；完整 `WitnessBackground` 的实例及实际算术来源未由此给出。本次未运行 Lean；新增模型与受影响生产声明的编译/依赖证据继续按 P0-3 验收，不把作者“Lean-verified”注释当作本次复现。
  - 原验收中的真实投影/核/中心扩张及算术来源要求继续保留在 P1-4/M15：区分 U→Ū 群扩张与 G_f→X_* gerbe 投影；为前者补群结构与同态、band 的合适作用律及核双向识别，并绑定 classifying/pullback；删除旧矛盾和给出局部模型不单独关闭该语义任务。

### P0-1：让 31-adic witness 真正表达 witness

- [x] 修复旧 W4 的裸命题标签漏洞：`adic_witness` 现有终端交换群、指定类、局部化映射、带非空证明的 trivialization 数据与真实等式证书，以及 `global_nonzero : terminalClass ≠ 0`。原来把两个 terminal 标签取 `False` 的方法已不满足新类型。
- [x] `a3020f1` 已删除直接假设 `kappa_ne_zero : kappa ≠ 0` 的字段，改为利用 `kummerEqKappa`、`pairingDetectsNonzero` 和 `kummerPairingNonzero` 的源码引理；不再是原样投影该非零字段。
- [ ] 继续修订 `Def_adic_witness.lean::adic_witness`、`Def_witness_background.lean::WitnessBackground` 与 `sol_thm_31adic_witness`，补齐 W1–W4 的实际算术内容和非循环推导。
  - W1/W2 仍薄弱：`cubicLine_input_ok` 仍只有谓词，solution 仍取 `fun _ => bg.qiKummer ∧ bg.carryNormalized`，没有成立证据。`4a2863cd5aa6fe54b68368fdb20880b71d1d5068` 已加入 `carryRestrict` 的身份/复合律，应撤销“无有限深度相容律”；但所选 family 仍为常值 `bg.QAdicLine`、restriction 为 id，没有每层归一化证书、指定相容 section 或 exact-order 31^r 的 reductions。`lambda31_exact2`、`qiKummer`、`carryNormalized` 等仍是裸 Prop 标签。
  - `branchZero` / `branchStar` 已新增 Add / Mul，`terminalClassOrder` 也真实要求精确阶 31，不能再称无结构或无阶条件。但 Add/Mul 只给二元运算，仍可取 Unit；未将分支定义为 K₀ / K* 或关联判别式、Kummer、Massey、局部场数据，`localize` 仍只是任意函数。保留三个 31 字段的类型区别。
  - `poitouTatePairing` 已改为 `G → G → ZMod 31` 并有左右加性，`kummerPairingNonzero` 是非零配对值，旧任意 Prop 关系反例不再适用。`pairingDetectsNonzero` 可由左加性推出（并不需要非退化性），现证明仍显式使用它及 Kummer 等式，是有效代数步骤。但实际算术/对偶群与配对来源仍未进入类型；更重要的是新增 `kappaOrder31 : addOrderOf kappa = 31` 已直接蕴含 κ ≠ 0。须从允许的、独立识别的算术/数值输入导出该目标类的精确阶，不能仅标 NUM 即宣称反循环缺口关闭；无需第一性原理重算 mission 允许假设的数值。[当前背景字段与推导](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_witness_background.lean#L137-L264)
  - 验收：能从最终 witness 提取论文 W1–W4 所要求的数据和证明（论文 L13670–13678），并追踪 Thm 37.1 的四项结论（L15765–15774）；根据 mission 的反循环要求，逐项标清允许输入如何导出目标。

### P0-2：区分 Moore cochain 与 cohomology class

- [x] 新增加法 `classOf`、其 kernel 等于 boundaries 的条件、`hb_class_order : addOrderOf (classOf b_mot) = N` 与 `3 ≤ N`，并接入 M5 结论。由此原“b 是 boundary、但 cochain 有阶 N”的模型已被排除；不能再说只有 cochain 阶条件。
- [x] `a3020f1` 已从背景与 M5 结论删除 cochain-level `hb_order` / `hb_exact`；旧 `N • b = 0` 与 `d c = N • b` 联合强制 `d c = 0` 的缺陷已修掉。
- [ ] 继续修订 `MotivicBackground` / `thm_motivic_seed` 的 integral Moore 与几何 antecedent 语义。
  - [x] `4a2863cd5aa6fe54b68368fdb20880b71d1d5068` 将 `isGenuine_iff` 中 `classOf x` 改为闭合 `b_mot` 的类，修复旧接口推出 `N² • b_mot = 0` 的问题。该旧推导须撤销；例如 Cochain = ℤc ⊕ ℤb、d(a,b)=(0,Na)、classOf(a,b)=(a,b mod N) 可满足新的代数字段且 N²b ≠ 0（数学层面的模型分析，未运行 Lean）。这也说明其 classOf 目前容纳的是全部 cochains 模 boundaries，而非自动给出真正上同调。
  - `classOf : Cochain →+ Cohomology` 仍作用于全部 cochains，仅规定 kernel = boundaries，未建立 cycles / boundaries 商及与所声明 Cohomology 的识别。对闭合 b，新 kernel 和阶条件确实表达模 boundaries 的精确阶；待补忠实 integral 两项复形与上同调接口，并验证非零微分的适用范围。当前条件不强迫 N • b ≠ 0，不能据注释宣称该性质已建立。
  - 新 `GeometricAntecedent` 只有任意 RootCoord、元素、函数及命中 b 的等式，取 `RootCoord := Unit`、`rootCoord := ()`、`localize := fun _ => b` 对任何 b 均可满足；`isGenuine_iff` 的存在量词也已由结构的 `localizesTo` 保证。N=3、Cochain=Cohomology=ZMod 3、d=0、classOf=id、b=1、c=0、isGenuine=True 加上述 Unit antecedent 仍满足整个当前接口（静态模型分析，未运行 Lean）。因此“排除纯 torsion 模型”的注释不成立；须把 root stack、t=u^N、Gysin/root-localization 操作及与 c 的对应实际写进类型，保留允许引用的外部 motivic 输入。[当前 antecedent 与接口](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_motivic_background.lean#L7-L130)
  - 验收：在忠实的复形与上同调接口中证明 `d b = 0`、`d c = N b`、`addOrderOf [b] = N` 或等价条件，并使几何 antecedent 的含义进入类型。

### P0-3：建立本提交可复现的构建与依赖审计

- [ ] 验证正式构建入口覆盖所有预定模块，并保存对应源码 SHA、命令、完整结果的构建与依赖审计凭据。新增配置和作者报告构成进展，尚不足以关闭本项。
  - [x] 源码层面已补入根目录 `lean-toolchain` 与 `lakefile.lean`：Lean `leanprover/lean4:v4.33.1`，Mathlib 固定到 `0df444a360eaa60ab8c11dca51a86af692955474`；新增 `BUILD.md` 说明复现步骤。仅确认文件与版本记录存在，不表示构建通过。
  - [x] 16 个实质解答已统一改为唯一的 `SelmerCartanMotiveTowers.sol_<name>`，消除原有同名 `solution` 冲突。`BUILD.md` 记录独立 Prove2Me 模块评测与联合导入的选择，并已同步 Theorems 导入 Solutions 的接线说明；联合导入本身尚无本次独立验证。
  - [x] `69274136` 已为 Definitions、Theorems、Solutions 分别设置 `Glob.submodules`，修掉无聚合根模块且未枚举子模块的问题。[当前配置](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/ba4b2e73209b3713a2fd351b299ca2e891b8a0c2/lakefile.lean#L27-L32)与 [Lake submodule 枚举语义](https://github.com/leanprover/lean4/blob/v4.33.1/src/lake/Lake/Config/Glob.lean#L53-L59)已静态核对。
  - 默认覆盖仍未完整：只有 Solutions 标记 `@[default_target]`，`BUILD.md` 仍只运行裸 `lake build`。当前 Solutions 的本地 import 闭包覆盖 17 Solutions 与全部 22 Definitions，但不包含任何 Theorems；独立声明的 Theorems library 不会因此自动成为默认目标。须显式构建 `lake build Definitions Theorems Solutions` 或建立等效完整入口，并保存覆盖全部 55 模块的运行证据；新增 globs 不能替代该验证。
  - [x] `ab3d666826428d2224124283f81ba252be2a396e` 已提交根 `lake-manifest.json`（blob `d03d12d415d7fe107871165ad78f98ada723ca95`），记录 Mathlib 及 8 个传递依赖的完整 revision，Mathlib 与配置固定值一致。旧“根 manifest 未留档”缺口已修复；这不单独证明该清单已在当前根配置的干净 checkout 使用。
  - 构建日志已有作者成功报告：[日志](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/ab3d666826428d2224124283f81ba252be2a396e/lean/build_logs/build_solutions_20261010.log)末尾为 `Build completed successfully (3042 jobs).` / `EXIT_CODE=0`。但配套 `source_sha.txt` 的 `e3495042c151d35b82750f12004e5fcb70042022` 无法通过本仓库 API 解析（422），manifest 根包名 `prove2me` 与当前配置不同；须提供可定位源码与所用配置/依赖的对应关系。日志未记录实际命令、版本、干净 checkout 状态或 Theorems 目标覆盖，含缓存 `Replayed` 项；不能据 3042 jobs 判定当前全部 55 个项目模块已构建，也不能据此断言构建失败。`BUILD.md` 的 `lake build 2>&1 | tee build.log` 仍须明确保留构建进程退出状态（如 Bash `pipefail` / `PIPESTATUS`）；新增 `EXIT_CODE=0` 行没有记录其采集方式。包括 `bbef8d5ce3e90de3aaecae2be696b063a4c536b0` 的新模型在内的后续源码晚于该日志，而日志未更新，不能为新版本提供覆盖。补齐上述证据后再验收 P0-3，本次未运行 Lean/Lake。
  - `lean/AXIOMS.md` 最新 blob 为 `74470f9f1727bf0a9b4077921b9b287d4ace4a59`；此前从 47 扩到 54 项，`a8591d8b7ef4a012c9e37684ae99470718662bc5` 仅新增 M15 作者再审说明，表仍列 54 项、页尾仍写 `Total: 47`。报告继续使用不可解析的 source `d5ffb0e985fcbd60b388929d2a685437e8088e70`（本次 422），无入库审计脚本、完整运行命令/日志和退出状态；不能视为当前源码可复现凭据。M2/M11/M12/M13/M9 的依赖分类仍是作者报告，未独立复现。[当前报告](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/AXIOMS.md)
  - 继续单独核对 `Def_rec_one_mot.lean` 的四个项目 axiom 与 `full_mot` / `rec_one_mot` 两个 opaque；不把作者称“opaque 无公理依赖”升级为本次验证。54 项是报告声明数，不是 54 模块覆盖证明；仍缺 16 个 Theorems 和逐项生产依赖闭包。M3 的 range / filtered interface、M4 新映射、witness/seed/SuperDGA 新字段、M16 的 witnessArithIso / marking_compat 、新 M6/M7/M8/M15 字段与引理、`unipotentExtensionModel` 及修订后的解答均须在最新可定位 SHA 重跑；声明了 Prop 不等于证明它，背景裸 Prop 标签也不会因未列公理依赖便自动成立。
  - 验收：在选定构建模式下逐项覆盖全部生产声明，提交可重跑的审计入口，保留每项 `#print axioms` / 等效报告，区分 `sorryAx`、Lean 基础公理、明确允许的项目公理、参数化背景假设；不能以文本 grep 或 SmokeTest 代替完整验证。

## P1：恢复声明所指的数学结构

### P1-1：收窄并逐项登记背景义务

- [x] 已新增 `lean/BACKGROUND_INPUTS.md`，记录 DEF/EXT/NUM/LEM 标签与使用声明，承认部分结果为条件组装。
- [ ] 继续核验并补全四个背景包的逐字段台账，区分“定义 / 外部定理 / 数值假设 / 本文待证引理 / 目标重述”；标签和文献名不能代替声明适用条件与依赖证明。
  - 台账已补 `FormalBackground.nonempty_FramedSector` / `nonempty_DGCategory`，`Classical` 任意类型已被具体数值模型替换，M16 §5 也已更新。`ba4b2e73` 又修正四项陈旧记录：不再列已删除的 `hb_order` / `hb_exact` 为当前字段，M10 不再称消耗 `crtLine` / `crtLineHas`，M2 不再称消耗 FormalBackground §1，M14 正确列出 `kummerEqKappa` 与 pairing 推导链。剩余“Every field / exact fields / No GOAL!”的语义断言仍须核验：`lambda31_exact2`、`classNum93` 等为未证明的 Prop 标签；反循环界限见 P0-1，`stackIsDerived` 等结论型字段不能因标 DEF 而当作已建立的结构。
  - `ClassFieldBackground.masseyExact` 目前对任意三个 exact-order 字符和 cup-vanishing 条件便给出 Massey 精确阶；未包含特选第三射线、中心 Frobenius、固定 Heisenberg lift、指定 nullhomotopy 或单位局部不变量。应限定到实际构造数据，不能仅凭注释中的文献名视为一般定理。
  - `FormalBackground.obsCocycle/liftIff/gaugeInv/natural` 旧字段仍在，但 M2 已改为独立的 curvature 代数结果，不再投影它们；不能继续把 M2 描述为原条件组装。M11 的 `shadowZero/shadowMoore` 已针对 `ClassicalMooreCone` 的数值条件，仍直接由背景提供；`stackIsDerived`、`eRecBijective/eFullBijective` 等也仍是对应结论输入，不能替代实际 functor/stack/Morita 构造。
  - M10 已不再投影 `crtLineHas`，但 `crtRealizationIs` 及 M15 的 `gerbeIs/gerbeProvenance` 仍为背景结论；新增 `gerbeProvenanceData` 也由背景直接提供；旧 extension 矛盾已修复（P0-0），但局部 `UnipotentExtension` 模型不构成整个背景或算术实例，不能因台账标 EXT 或引用 Dwyer 而视作已实现；`gerbeProvenance : ∀ W, ...` 还须关联具体 witness。本轮台账已记新增 kappaOrder31 / pairing 字段，但其“反循环修复”须按 P0-1 重审；M16 新增 theorem-level `hM` 及 W 子群联系也须补进 §5 消费记录，区分已证的 cyclic carrier 同构与假设的 motivic 身份。
  - 验收：每个生产定理有精确依赖清单；允许的外部数值/理论输入保持显式，目标等价假设不得被当作目标已完成；论文内的构造义务有独立后续任务。

### P1-2：补齐四类模型的结构语义与生产声明约束

- [ ] 完成 M4 `thm_finite_confluent_interface` 的实际有限 confluent package。
  - 已落实的源码子项：新增 `direction_lattice S := ↥S.primes →₀ ℤ`、依赖 ν 的 ZMod 系数环、真实坐标删除及基于等价的重标号，并有删除幂等、身份/复合、删除—重标号自然性的证明体；旧“额外 ℤ 方向格、系数与 ν 无关、删除一律为零”不再适用于所选 solution。[定义与作用律](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bb298a04daa6899d5bfd679713c469226e61a526/lean/Definitions/Def_confluent_package.lean#L34-L130)
  - [x] `8c1f2e1a` 已将生产声明的 `P.baseDatum/gammaModule` 绑定为 `direction_lattice S`、`P.coeffRing` 绑定为 `coeff_ring ν`，并用 HEq 绑定实际 `supportDelete` / `permActDir`；旧任意 Unit/Empty carrier 与无关作用模型不再适用。[生产声明](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/ba4b2e73209b3713a2fd351b299ca2e891b8a0c2/lean/Theorems/Thm_SelmerCartanMotiveTowers_thm_finite_confluent_interface.lean#L36-L54)
  - `3d631e4dba1b2082aee81d97488477974e267e1e` 已新增 `gammaMult S n v := n • v`、零/加法律，`coarsen S T := supportDelete S (univ \ T)`、空集/并集复合律，及跨支撑零延拓 `extendSupport`；生产结论用 HEq 绑定 gammaAct/coarsenMap，不能继续称完全没有这些命名映射。[当前定义](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_confluent_package.lean#L136-L278)
  - 这些尚不是论文的 Γᵐ 或 Conf(m) coarsening：gammaModule 仍等于 D_S，与固定 m 无关，n • v 的零/加法律不是 divided-power 次数律；coarsen 只是同一支撑上的坐标删除，没有 multiplicity profile 映射 f、M(f)、torsion-defect 与 Res(f)。其余四分量仍取 Unit，尚无一般 direction-linear map 诱导 Γᵐ 的函子作用。extendSupport 只到方向格，未进入生产 package 映射；删除/数乘自然性在 NOTE 中仍列 future work，末尾却称已带 deletion naturality，须统一。
  - 验收：七分量及其实际操作进入同一生产接口；建立 Γᵐ、Conf(m) 与 coarsening 的 M(f)/defect/resonance 关系，以及跨支撑 package 相容律，保留空支撑的合法退化。按论文 L5147–5168 验收，不能把方向格投影或数乘重命名为全部 confluent package。
- [ ] 完成 M6 `thm_channel_complete_realization` 的 dg、通道实现与 Moore 类语义。
  - 已落实的源码子项：A/B 非空条件、channel 的 DecidableEq、carrier 加法群、Dirac 单射及每个 `chanMap c` 的精确加法阶 N。所选 carrier 为 `(channel_index S → ZMod N) × ℤ`；`8c1f2e1a` 又在生产声明中要求 `Ring M.corrAlgebra`、`Nontrivial Source` 和 `∃ a b, ρ a ≠ ρ b`，并给出 ZMod N ring 和非恒定 ρ 的证明体。旧 Unit Source、常值 ρ、只有裸 corrAlgebra 类型的批评已修掉。[当前声明与模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/ba4b2e73209b3713a2fd351b299ca2e891b8a0c2/lean/Solutions/Sol_thm_channel_complete_realization.lean#L101-L139)
  - [x] `936f7824` 已加入 `omegaClass I`（I 的特征函数）、构造支撑为 I 的 channel，并将 `I⊆S.primes, 3≤|I|, 0∉I ⇒ addOrderOf (ρ (omega I))=N` 接入生产结论。旧“无 Ω / 只要求独立 chanMap 阶”及可任取零第一坐标 ρ 的旧接口反例须撤销。[当前构造与精确阶](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Solutions/Sol_thm_channel_complete_realization.lean#L9-L157)
  - 该阶仍是 carrier 元素的加法阶，未定义 cycles/boundaries、真实 Ω latching polynomial 或 obstruction-cohomology class。ρ 仍是函数，omega 也未由 dg 结构定义；第一坐标只看 c.supp，仍不能区分同支撑的 (A,B)/(B,A)，与独立 Dirac chanMap 无识别律。辅助 ℤ 坐标仍负责非恒定，`delMap(f,z)=(f,0)` 只删除辅助坐标，无被删支撑参数；corrAlgebra 的 ring 未作用于 carrier。`reesCoeff` 仅定义 1,N,N²，未证明 cyclotomic transfer/乘法/Rees 律，也未接入生产结论。[当前生产声明](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Theorems/Thm_SelmerCartanMotiveTowers_thm_channel_complete_realization.lean#L50-L69)
  - 新增 `1 < N` 是范围变化，须与 genuine root-pair 前提对应。验收仍按论文 L6145–6189 七项性质补实际 dg controller、根 Moore pair、Boolean/channel realization、严格支撑删除、Rees transfer、实现类精确阶、genuine antecedent、Fubini 与重标号/Koszul 相容性；Dirac 阶只是代数子项，不能勾选原 (iv)。
- [ ] 完成 M7 `thm_role_separated_objectification` 的角色对象与控制态射。
  - 已落实的源码子项：`RoleSeparation.separated` 真正排除两族重合，标记固定为 i<j，生产结论有 carrier/algebra 非平凡。新增 `ControlEdge.hom/hom_zero/hom_add/hom_nonzero` 要求 endomap 保零/保给定 Add 运算且非零，旧“只有不等端点、允许零 hom”的批评应撤销。每族内部仍无单射要求：Role/carrier/algebra 可取 Bool、零为 false、加法为左投影、hom=id，两族常值 false/true，标记边复用同一 endomap，仍满足这些约束（数学模型分析，未运行 Lean）。
  - 当前 `Add Role` 无群/幺半群律，canonical Role 的加法为左投影、hom=id；`degree_zero` 与 `closed` 的类型均为 True。hom 是整个 Role 的自映射，不是依赖 src/tgt 的 Hom-complex 元素，未绑定 Boolean correspondence 的指定 objectwise evaluation，也无微分/分次意义。定理仍自造 M，以集合单射关联 Role；未提供 M6 的 AddCommGroup/Ring/精确阶通道或同一 realization 兼容。须补真正 dg 控制态射、additive/Karoubi summands、cutoff、higher cells 与 Morita 相容，按论文 L6297–6327 验收。[当前字段和模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Definitions/Def_role_separation.lean#L7-L119)
- [ ] 完成 M8 `thm_finite_motivic_recursion_closure` 的有限递归结构。
  - 已落实的源码子项：全层共享 carrier/algebra、Fin (M−2) 对应 k+3 层、跨 ceiling 限制、同一 latch 与 history_eq 保持；本轮新增 carrier 加法群、`ReedyDecomp.reedy_iso : carrier ≃+ latchObj × cofiber`、加法映射 d 及 dγ=Nβ、带支撑参数的删除—latch 交换律和共同 apex。这些是实际的代数/等式字段，撤销“完全无 splitting/删除交换条件”。[当前定义](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Definitions/Def_jet_ledger.lean#L21-L122)
  - 所选模型现在是 ZMod 3 × ZMod 3 / Bool，reedy_iso 为身份，d=gamma=beta=0，latch 和所有 delMap 均为 id，atLevel/history 仍常值，适用于任意声明的奇平方自由 N；`coeffOrder=N` 未约束 beta 的阶。ReedyDecomp 无 d²=0、grading、proper-face diagram/colimit/cofiber 的定义，saturation 无关联映射，零 Moore pair 足以满足 dγ=Nβ；不是所需 root/Moore 结构。[模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/a8591d8b7ef4a012c9e37684ae99470718662bc5/lean/Solutions/Sol_thm_finite_motivic_recursion_closure.lean#L70-L110)
  - `history_eq` 与 `history_apex_eq` 还强迫每个 atLevel n h=apex（末项索引 n−3）。论文确实要求底层结构在 jet 方向常值（L12461–12465、L12538–12543），常值本身不是错误；缺口是代码的 history/ledger 只是这些结构层，未表示变化的 Confluent 标记、reduced insertion histories、history blocks 或 2-cell coherence。继续补真实 support deletion/Boolean saturation/非退化 Moore antecedent、标记台账与历史实现、bar/transgression/readout 交换图，按论文 L12472–12550 验收；不能仅凭共同 carrier、命名字段或恒等交换律关闭 (i)/(ii)/(iii)/(vi)。

### P1-3：从任意函数/类型恢复 obstruction、category 与 stack

- [ ] M2 `thm_universal_higher_obstruction_recursion`：Bianchi、curvature 展开和自然性的证明体是实质代数进展。`4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1` 已补 evenPart/oddPart 子群直和、四个乘法次数律、d 翻转次数及 isOdd_eq；旧“任意 isOdd / 没有次数结构”批评撤销。[当前结构](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_dga_obstruction.lean#L70-L110)
  - 仍须修正 `leibniz : ∀ a b, ... if isOdd a ...`：mixed 元素被判 not-odd，却不能使用纯偶元素的符号。标准超 DGA Λ_ℚ(θ)、dθ=1，在 a=1+θ、b=θ 时，左边为 1，当前右边为 1+2θ，因此该接口排除这个有效模型；这不是整个结构无模型的断言（d=0 等退化模型仍存在）。应对 homogeneous 输入分别给 Leibniz，再按分解线性延拓，或使用 parity involution。以上为数学源码模型检查，未运行 Lean。
  - `GaugeUnit.hg_even/hg_inv_even` 仍用 ¬isOdd，允许 mixed units；`DGAHom.map_odd` 要求 iff，又排除了可把非零奇元映为 0 的正常 graded map。改为子群 membership / preservation，并核对一般 truncated gauge。生产四项仍只是 Bianchi 重排、展开式、共轭定义 rfl 和 curvature 自然性；须补 PD filtration、marked jet、级次投影、cohomology/filler torsor，推出论文 L2643–2690 的 dΩ=0、lift iff、gauge 不变及 obstruction-class 自然性。[GaugeUnit / DGAHom](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_dga_obstruction.lean#L216-L258)
- [ ] M9 `thm_successor_stage_functor`：当前在给定 `nextObstruction`、`mooreLift`、`hMooreClosure` 后，选择一个保持谓词的函数族；声明甚至未强制它等于给定的 Moore lift。补充明确公式、marked stage、态射映射/函子律、homotopy pullback / Moore relation、support 与 frame/representative independence，保留 coefficient-depth firewall。
- [ ] M11 `thm_classical_low_sector_comparison`：目标已由任意 Classical 类型/谓词改成 `ClassicalMooreCone` 的数值模型，新增整数乘 d 的映射、ZMod reduction 的身份/复合及生成元阶证明体，不能再说完全是任意目标谓词。但该结构只存 `d : ℕ`，`line := ZMod d` 未证明是实际 cone 的上同调；`1b39daa3804fb820c58d026b44fc460db5c8acd6` 已把 cokernel 次数统一改为 H¹，撤销该文档错误；仍须证明其与所定义实际复形的上同调对应。`IsArtin` 只是 d=0，`IsMoorePresentation` 只是 0<d，甚至允许 d=1；后者未绑定给定种子系数 N。背景仍直接假设 shadow 的两条性质，shadow 本身为对象函数。补真实源 sector、Artin/toric/cone 目标及 homotopy coherent functor、Moore pair 和转移/reduction 的交换识别，按论文 L13325–13447 验收。[目标模型](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bb298a04daa6899d5bfd679713c469226e61a526/lean/Definitions/Def_classical_shadow_cone.lean#L14-L83)
- [ ] M12–M13 `prop_stack_globalization`、`thm_marked_morita_independence`：仍须建立 pseudo-perfect-module moduli/derived-stack 条件、pointed marked Morita equivalence 及诱导的有限塔/stack 等价；任意谓词、类型和集合双射不足以表达这些结构。
  - 验收：每一项将论文条件与结论逐条配对；底层对象、态射、函子及交换/自然性条件均在类型中出现，测试其不能通过恒真谓词或无关集合双射满足。新增 `P1_INFEASIBLE.md` 是作者的工程范围/基础设施说明，不能作为这些目标已完成或数学上不可能的证据；其中对 Mathlib 不存在相关基础的概括也未在本次得到全面核实。

### P1-4：补齐比较映射与 prime-power / witness 实现

- [x] M3 已从抽象生成元同态改为具体 `ZMod (p*q^2)` 与 `ZMod p × ZMod (q^2)` 之间唯一 pointed `AddEquiv`，新增 `p ≠ q` 的 CRT 前提及 q-primary reduction / residual generator 相容性；另有 `ℤ ⧸ (pq²)ℤ ≃+ ZMod (pq²)` 的商群同构源码。此前“未写出 AddEquiv / reduction”的缺口已修复，这是真正的代数层进展。
- [ ] 继续将 M3 的通用代数模型接到论文实际对象：`mooreDiff_range` 已证明 differential image = boundaries，`PrimitiveFilteredInterface` 已给 carrier、κ̃ 类、保点 primIso 与精确阶；撤销“无 range 等式/无任何 κ̃ 接口”。但 `mooreGen_is_cohomology_class` 是 `def ... : Prop`，尚无证明；主证明虽新写 `have hrange/hcoh/hkappa`，这三个局部 have 未进入后续推导，`qPrimaryRed_kappa_tilde` 的 I 参数也未使用。不能据命名 Prop 和未使用的 have 宣称 `[1]`→mooreGen 的证明链已闭合。[定义](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_moore_cohomology_line.lean#L28-L160)、[解答](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Solutions/Sol_thm_formal_filtered_alignment.lean#L27-L74)
  - 验收：证明并消费商生成元对应；在 production 输入/输出中关联实际 W_q/q²W_q、κ̃、filtered reductions 与指定标记，而非仅选择 ZMod 模型及 refl primIso。允许列明 q-adic 外部输入，但须证明识别和约化交换关系；按论文 L2235–2270 的 alignment 及比较边界验收。不否认已有 CRT 唯一性和商群同构。
- [ ] M10 `thm_prime_power_comparison`：`1b39daa3804fb820c58d026b44fc460db5c8acd6` 已给完整有限 CRT `crtProductEquiv`、保点性、分量等于实际 cast 的 `crtProductEquiv_apply`，并把具体 p-power reduction 复合律接入生产结论。旧“仅二元 CRT / RingHom 非空、无复合和分量图”缺口已修复。[当前 CRT](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Definitions/Def_crt_product.lean#L63-L198)
  - `MoorePresentation` 仍只含 B 及其阶，无 integral C/differential/商识别；新增 LIMITATION 已如实承认。S 仍未使用，dg realization 仍独立投影 `crtRealizationIs`，未关联 ν/Nν、根块或 CRT/reduction。验收继续要求真实 primitive filtered lines、兼容 universal Moore presentations 与 support-functorial dg realization 的绑定，以及论文 L13000–13076 的 realization/reduction 交换方块、support/relabelling、coarsening M(f)/defect 与坐标保持；不能用纯系数 cast 的交换关系代替 dg square，一般 odd prime-power 层不能被 squarefree 限制替代。
- [x] M16 已用 `pointed_cyclic_carrier` 表示加法群、精确阶 31 的生成元及全体生成性，构造经过 `ZMod 31` 的真实 pointed carrier 同构；`hSpan` / 任意三元谓词的直接投影已移除。仅此 carrier-level 代数构造是已完成子项，不等同于 operation-level provenance。
- [ ] M15 `thm_gerbe_provenance`：P0-0 的旧字段矛盾已源码修复。新增 classifying map、31-coordinate profile、三个 ZMod 31 值的等式/非零与 extension 记录是接口进展，撤销“完全无 provenance 数据”；本轮又补生成元投影、单向核条件和 `unipotentExtensionModel`，不能继续说完全没有投影/核关系。但 `ClassifyingMap.map` 与 coords 无条件关联，`PullbackIdentity` 无真正 pullback 操作；extension.base 无群结构，proj 未声明为群同态且未要求满射，`SMul (ZMod 31) total` 只有运算、无作用/模公理，`projKernel` 只把零纤维包含在标量倍数集合中，缺逆向，不能声称核恰为生成元的循环子群；`AddCommGroup` 已自动给所有元素中心性，未表达一般非交换 unipotent central extension。P 只由 `bg.gerbeProvenanceData` 投影，除 base_eq 外各部分彼此未绑定，且无 P 与 G/W/κ/root operation 的关系；旧 `provenanceFor` 谓词仍然保留。验收：区分论文 L15805–15820 的 U→Ū 群概形中心扩张与 L15852–15864 的 G_f→X_* gerbe 投影；为前者补群/同态与核双向识别、band 的合适作用律，并恢复 L15832–15873 的 classifying/pullback 方块及来源识别，不强加几何基底 X_* 本身为群；允许列明外部算术输入，但不能把 order-31 元素或 Unit-base 局部模型等同于所需代数 μ₃₁-gerbe。[定义](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bbef8d5ce3e90de3aaecae2be696b063a4c536b0/lean/Definitions/Def_gerbe_provenance.lean#L19-L159)、[生产解答](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/bbef8d5ce3e90de3aaecae2be696b063a4c536b0/lean/Solutions/Sol_thm_gerbe_provenance.lean#L22-L29)
- [ ] M16 `thm_motivic_specialization`：W/M 已不再是未使用 binder。`witnessArithIso` 从 W.terminalClass 的精确阶 31，给其 zmultiples 子群到 Lar 的保点 AddEquiv；`marking_compat` 也证明抽象三线标记相容，应计入完成子项。但 M 的联系完全经新增 `hM : M.carrier ≃ bg.LMot.carrier` 假设，结论 ρ_M 只是其反向复合的裸 Equiv，未给 M.carrier 的加法/标记，更无指定 I_* block、其 Moore pair 或同一 marked ledger；还把整个 M.carrier 当作 31 元 line。应先识别实际 block 子对象，再建立保点加法同构及与原 M 的兼容性，而非将目标身份假设为任意类型双射。W 侧代数联系也不替代 P0-1 的算术 realization 链。按论文 L16066–16107 验收，保持 carrier span 与 M15 的 operation-level provenance 分开。[当前构造与结论](https://github.com/cchx0000/selmer-cartan-motive-towers/blob/4cb1359ac8f4aa9da7d1867800dafdd5c297c4f1/lean/Solutions/Sol_thm_motivic_specialization.lean#L20-L121)

### P1-5：接回草稿并修正文档统计

- [x] 源码层面已把全部 16 个 `sol_*` 接入对应 Theorems：每项都新增正确 import 并调用对应解答，去注释/规范化空白后的参数与结论一致；旧 `by sorry` 已从生产声明移除。该完成项只描述源码接线，不代表语义验收或编译通过。
- [x] `8a1d6783` 已更正 README 中 M14 重复计数与 SmokeTest 统计：16 个实质解答含主目标，第17个文件仅为烟雾测试。
- [x] `50d92fcdf8a425996905b2ad98c782798a58eada` 已将 `lean/README.md` 的 Definitions 统计改为 21，并补列 `confluent_package` / `role_separation` / `jet_ledger`；已与实际文件数核对。
- [ ] 完成最新声明、模块和构建模式的文档同步：旧接线、Definitions 统计及 README 的接回草稿待办已修复；作者构建日志与 manifest 按 P0-3 保留来源/覆盖限制。当前 README 仍写 21 Definitions，新增 gerbe 模块后应为 22；还须同步 AXIOMS 页尾 47→54 及新源码覆盖、BACKGROUND_INPUTS 的 M16/W/hM 消费项，并按 P0-0 的修复状态更新 gerbeProvenanceData 说明，收窄本轮新增“genuine central extension / μ₃₁-module / kernel = multiples / hence WitnessBackground / Lean-verified”的表述，分别交代局部模型、完整背景、算术来源与构建证据；限定 M3“完整生成元链”、M4“Γᵐ/coarsening/已证 deletion naturality”、M5“排除纯 torsion/非零 integral differential”、M2“已推出 cocycle/lifting”以及 M6 的“paper (iv)/Rees profile”、M7 的“Hom/degree/closed”、M8 的“Reedy/history”与 M15 的“已替代任意谓词/isMu31”注释到类型实际表达的范围。README 中旧 M5 integral d c 与 d² 的“tension”也应随本轮修复更新。
- [x] `1b39daa3804fb820c58d026b44fc460db5c8acd6` 已将 README 的“全部已证明”明确收窄为给定 Strategy A 背景的 sorry-free conditionals，并删除旧接回草稿待办；该措辞修复已完成。
- [ ] 继续逐项区分条件式/弱化声明的源码完成、编译验证、依赖公理和论文语义差距；不能因 README 加 caveat、消除文本 sorry 或接回生产模块而自动关闭各语义/复现任务。
  - 验收：统计从真实声明和依赖闭包生成，逐项显示“文本完成 / 编译验证 / 依赖公理 / 与论文差距”；`MISSION_DESCRIPTION.md`、`INVENTORY.md` 与代码状态不相互矛盾。

## 声明与文件索引

所有名称位于 `SelmerCartanMotiveTowers`。Definitions 的依赖骨架：`finite_ordered_support → typed_coordinates`；`typed_coordinates → source_package、adic_witness`；`adic_witness、finite_ordered_support、pointed_cyclic_carrier、GerbeProvenance → WitnessBackground`；`finite_ordered_support → channel_index`；`full_mot → rec_one_mot → selmer_cartan_tower → FormalBackground`；`ClassicalMooreCone → FormalBackground`；`finite_ordered_support → motivic_moore_reedy → jet_tower`；`typed_coordinates → crt_product、confluent_package`；M2 直接依赖新的 `SuperDGA`。`ClassFieldBackground`、`MotivicBackground` 各自引入额外背景接口。箭头从被导入定义指向使用方；详见各文件 import。

| Definitions 文件（位于 `lean/Definitions/`） | 主要声明 |
| --- | --- |
| `Def_finite_ordered_support.lean` | `finite_ordered_support` |
| `Def_channel_index.lean` | `channel_index`、其 `DecidableEq` 实例 |
| `Def_moore_cohomology_line.lean` | `moore_complex`、`mooreDiff`、`mooreBoundaries`、`moore_line`、`mooreGen`、`conf_line`、`confGen`、`residualGen`、`residualGen_ne_zero`、`qPrimaryRed`、`moore_cohomology`、`mooreDiff_range`、`PrimitiveFilteredInterface`、`concreteFilteredInterface`、`mooreGen_is_cohomology_class`（Prop 定义） |
| `Def_pointed_cyclic_carrier.lean` | `pointed_cyclic_carrier`、其 `instAddCommGroup`、`nat_card_eq`、`canonicalIso`、`canonicalIso_apply_gen` |
| `Def_typed_coordinates.lean` | `confluence_multiplicity`、`coefficient_exponent`、`obstruction_height`、`typed_coordinates` |
| `Def_source_package.lean` | `source_package` |
| `Def_full_mot.lean` | `full_mot` |
| `Def_rec_one_mot.lean` | `rec_one_mot`、`tau_one`、`depth_of_full`、`depth_of_rec`、`tau_one_depth_fiber` |
| `Def_motivic_moore_reedy.lean` | `motivic_moore_reedy` |
| `Def_selmer_cartan_tower.lean` | `selmer_cartan_tower` |
| `Def_adic_witness.lean` | `adic_witness`、`AdicWitness.instAddCommGroupTerminal`、`AdicWitness.instAddCommGroupLocal`、`instAddBranchZero`、`instMulBranchStar` |
| `Def_classfield_background.lean` | `ClassFieldBackground` |
| `Def_motivic_background.lean` | `GeometricAntecedent`、`MotivicBackground`、`MotivicBackground.instAddCommGroup`、`MotivicBackground.instAddCommGroupCohomology` |
| `Def_witness_background.lean` | `WitnessBackground`、`WitnessBackground.instAddCommGroupObstruction`、`WitnessBackground.instAddCommGroupLocalObstruction`、`WitnessBackground.kappa_ne_zero` |
| `Def_formal_background.lean` | `FormalBackground` |
| `Def_dga_obstruction.lean` | `SuperDGA`、其 `GaugeUnit/DGAHom`、`curvature`、`bianchi`、`bianchi_cocycle`、`curvature_expand`、`naturality` |
| `Def_crt_product.lean` | `crtModulus`、`ppow_coprime`、`crtModulus_pairwise_coprime`、`crtLine`、`crtLine_order`、`crtBinary`、`ppowerRed`、`MoorePresentation`、`crtMoorePresentation`、`crtProductEquiv`、`crtProductEquiv_one/apply`、`ppowerRed_comp` |
| `Def_classical_shadow_cone.lean` | `ClassicalMooreCone`、`diff/line/reduce`、`reduce_refl/reduce_trans/line_order`、`IsArtin`、`IsMoorePresentation` |
| `Def_confluent_package.lean` | `direction_lattice`、`dirBasis`、`coeffModulus`、`coeff_ring`、`supportDelete`、`permActDir`、`gammaMult`、`coarsen`、`extendSupport` 及已给出的作用律 |
| `Def_role_separation.lean` | `ControlEdge`、`RoleSeparation`、`canonicalRoleSeparation` |
| `Def_jet_ledger.lean` | `ReedyDecomp`、`jet_tower`、`jet_tower.ledger`、`jet_tower.ledger_restrict` |
| `Def_gerbe_provenance.lean` | `ClassifyingMap`、`PullbackIdentity`、`UnipotentExtension`、`unipotentExtensionModel`（局部模型源码，未独立编译）、`GerbeProvenance`、`isMu31`、`pullback_eq_chern` |

下表每行声明 `x` 对应 Theorems 生产声明 `lean/Theorems/Thm_SelmerCartanMotiveTowers_x.lean`，以及独立解答 `lean/Solutions/Sol_x.lean::sol_x`（`8a1d6783` 起采用唯一名称）。

| 里程碑 | 声明 x | 当前证明/接口重点 | 对应待办 |
| --- | --- | --- | --- |
| M1 / Thm 6.5 | `thm_ray_class_primitive` | `ClassFieldBackground` 的两射线、第三射线、lift、Massey 字段组装 | P1-1 |
| M2 / Thm 9.4 | `thm_universal_higher_obstruction_recursion` | Bianchi/展开/curvature 自然性源码；尚未推出原 obstruction 四项 | P1-1、P1-3 |
| M3 / Thm 8.21 | `thm_formal_filtered_alignment` | 具体 CRT、range 等式与 filtered 接口；商生成元 Prop 待证及接实际 line | P1-4 |
| M4 / Thm 11.6 | `thm_finite_confluent_interface` | 绑定方向格/ZMod/投影/数乘；真实 Γᵐ/PD/Conf(m) coarsening 仍缺 | P1-2 |
| M5 / Thm 12.2 | `thm_motivic_seed` | 旧 N²b 缺陷已修；几何字段仍允许 Unit 常值/纯 torsion 模型 | P0-2 |
| M6 / Thm 19.6 | `thm_channel_complete_realization` | Dirac 与 ρ(omega I) 阶 N；Boolean 模型尚未绑定 obstruction 类 | P1-2 |
| M7 / Thm 19.9 | `thm_role_separated_objectification` | 分离及保零/保运算的非零 endomap；尚非 dg Hom 或 M6-compatible target | P1-2 |
| M8 / Thm 25.14 | `thm_finite_motivic_recursion_closure` | 加法 splitting/删除交换/共同 apex；零 Moore pair 与标记/history 语义仍缺 | P1-2 |
| M9 / Thm 26.7 | `thm_successor_stage_functor` | 给定 obstruction/Moore lift/closure 后的函数组装 | P1-3 |
| M10 / Thm 26.12 | `thm_prime_power_comparison` | 完整有限 CRT 与 reduction 律；旧 extension 矛盾已修，dg 绑定仍缺 | P1-1、P1-4 |
| M11 / Thm 27.5 | `thm_classical_low_sector_comparison` | 数值 cone/ZMod reductions；shadow 函子与实际 cone 识别仍缺 | P1-3 |
| M12 / Prop 13.5 | `prop_stack_globalization` | `stackIsDerived` 直接投影 | P1-3 |
| M13 / Thm 30.2 | `thm_marked_morita_independence` | 已给定双射及 intertwining 性质投影 | P1-3 |
| M14 / Thm 37.1 / 主目标 | `thm_31adic_witness` | 旧 extension 矛盾已修；pairing/阶/carry 来源及 W1/W2 仍缺 | P0-1 |
| M15 / Thm 38.1 | `thm_gerbe_provenance` | 旧 extension 矛盾已修并有局部模型源码；真实 extension/pullback 及背景投影缺口仍在 | P1-4 |
| M16 / Thm 38.5 | `thm_motivic_specialization` | 独立 W 子群同构保留；旧 extension 矛盾已修，M 的 hM/block 待接 | P1-4 |

另有 `lean/Solutions/SmokeTest.lean`，只计作烟雾测试，不计作论文里程碑。

## 后续增量检查规则

- 从上述完整源码基线之后检查新增提交；只改变本 TODO 的提交不构成新的 Lean 成果或构建凭据。
- 源码、声明、背景输入或构建配置变化时，重新核对受影响的定义、依赖及论文条款，再更新对应条目的状态。
- 只有完成该条验收且有相应证据才勾选；单个 `sorry` 消失、README 更新、局部测试通过或条件结论被投影出来，都不足以单独关闭语义任务。
