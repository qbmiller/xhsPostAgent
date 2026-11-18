# 小红书内容代理

本目录用于将用户提供的网页链接或主题整理成可直接发布到小红书的图文或动画素材。

## 默认入口

- 需要处理链接、生成小红书文案、生成配图、整理发布素材时，加载并遵循 [`skills/xhs-content/SKILL.md`](skills/xhs-content/SKILL.md)。
- 浏览器操作必须使用 `ego-browser`；涉及联网读取、动态页面或小红书创作者平台时，同时遵循 `web-access` 的访问边界。
- 用户发送链接或主题、没有指定内容形态时，先判断更适合“图文”还是“动画”，再询问用户选择。提问必须包含基于来源特征的推荐和一句原因，例如：“这个链接以产品界面和功能清单为主，我推荐图文；你想做图文还是动画？”不得在用户选择前开始生成素材或打开发布平台。
- 内容形态判断：产品功能、文章要点、清单、对比和静态界面优先推荐图文；交互过程、时间线、操作演示、数据变化、空间关系和需要节奏表达的内容优先推荐动画；证据不足时默认推荐图文，并说明动画需要更高制作成本和更长核验流程。
- 用户仅发送链接、同时没有指定交付方式时，在内容形态确认后，再询问其选择：①生成素材并保存到本地，由用户自行上传；②由本 Skill 打开小红书创作者平台，上传素材并保存为草稿。两个问题可以合并成一次清晰的选择题，但必须先得到内容形态和交付方式。
- 用户明确选择保存草稿时，可以操作创作者平台并核对草稿箱，但不得点击最终“发布”。只有用户明确要求“发布/上传并发布”时才发布；最终提交前再次确认标题、正文、图片和账号状态。

## 动画技能路由

- 选择动画后，按任务需要读取已安装技能：
  - [`skills/stick-scene/SKILL.md`](skills/stick-scene/SKILL.md)：火柴人 Canvas 场景，适合讲解分析视频中的流程、协作关系、产品原理和因果过程；完整视频需配合时间线、字幕、旁白与导出。发现入口为 `.agents/skills/stick-scene`；上游检测脚本使用 Playwright，不可直接执行，预览、截图、采帧和测试统一使用 ego-browser。
  - [`skills/anidoodle/SKILL.md`](skills/anidoodle/SKILL.md)：纯代码绘制的插画、手绘过程动画、循环动图、讲解片与产品发布片；需要手绘媒介质感、角色一致性或可复现画面时优先考虑，也可用于图文封面与系列配图。
  - [`skills/hyperframes-repo/skills/hyperframes/SKILL.md`](skills/hyperframes-repo/skills/hyperframes/SKILL.md)：HyperFrames 视频与动效入口；项目级技能链接位于 `.agents/skills/`，按入口指引加载创作流程和领域技能。
  - [`skills/claude-motion-design/skill/motion-design/SKILL.md`](skills/claude-motion-design/skill/motion-design/SKILL.md)：HTML + Playwright + FFmpeg 的逐帧动效方案，适合产品发布、功能演示和节拍同步视频。
  - [`skills/claude-motion/.claude/skills/motion-design/SKILL.md`](skills/claude-motion/.claude/skills/motion-design/SKILL.md)：Remotion 动效设计规范和时间线方法。
  - [`skills/claude-motion/.claude/skills/review-loop/SKILL.md`](skills/claude-motion/.claude/skills/review-loop/SKILL.md)：逐帧截图、自检和修正流程。
  - [`skills/claude-motion/.claude/skills/sound-design/SKILL.md`](skills/claude-motion/.claude/skills/sound-design/SKILL.md)：音效时间线、混音和响度核验。
  - [`skills/claude-motion/.claude/skills/web-sims/SKILL.md`](skills/claude-motion/.claude/skills/web-sims/SKILL.md)：粒子、三维对象和模拟类视频。
- `howseen-ai/claude-motion-design` 适合纯代码、可重复的 HTML 动画；`whaleyxbt/claude-motion` 适合需要自我审视、逐帧复核和声音设计的完整动效流程。可以组合使用，但必须记录实际采用的方案。
- 动画交付至少包含封面或海报、视频文件或明确的渲染待办、文案、来源记录和 `manifest.json`。依赖或渲染失败时标记 `videoStatus: "pending"`，不得把脚本或静态截图描述成已生成视频。

## Anidoodle 使用约定

- 项目技能入口为 [`.agents/skills/anidoodle/SKILL.md`](.agents/skills/anidoodle/SKILL.md)，实际文件位于 `skills/anidoodle/`；安装来源与固定版本见 [`skills/anidoodle/安装记录.md`](skills/anidoodle/安装记录.md)。
- 使用时先读取技能入口和 `references/workflows/start-here.md`，再按需读取工作流、风格与格式参考。沿用用户已经确认的内容形态和交付方式，只补充缺失的风格、画幅、时长与声音选择；用户授权自行选择时，说明选择理由并继续。
- 静态插画与手绘动画使用 Anidoodle；以产品界面、排版和时间线编排为主时，按需选择 HyperFrames 或现有动效方案。组合使用时，在来源记录与 `manifest.json` 中记录实际工具和工作流。
- 创作工程放入当次 `YYYY-MM-DD/编号/` 交付目录，不在技能源码或上游示例中直接修改作品。先核验一张关键静帧，再制作完整动画；保留源码、素材来源、创作简报与核验结果。
- 引擎要求 Node.js 20+，动画导出需要 FFmpeg；工程依赖按实际工作流安装。上游提供的 Playwright、Remotion、HyperFrames 渲染适配器不能绕过项目浏览器约束：凡启动或控制浏览器、截图、页面取帧与测试，均使用 `/Users/miller/.agents/skills/ego-browser/SKILL.md`。不能通过该路径完成时，记录具体阻碍和渲染待办。
- 配乐、旁白与可选音源下载按用户需求选择，不因安装技能自动下载音源。配乐须通过技能的音乐检查，交付前由用户试听；旁白沿用已确认的声音偏好，不把参考音频描述成已经配置的音色。
- 动画按技能要求进行独立审片并记录问题与修正。导出后核对实际文件的尺寸、时长、帧数、音画同步和字幕；只有实际执行并通过的检查才能标记通过，未渲染或未核验的项目明确标记待办。

## 输出约定

- 所有说明、文案和文件内容使用简体中文。
- 文案采用 Emoji 风格：标题有吸引力，每个正文段落至少包含一个相关 Emoji，末尾追加相关话题标签。
- 每次生成都创建 `YYYY-MM-DD/编号/` 目录，编号从当天已有最大编号递增；目录内至少包含文案、来源记录和图片。
- 原文事实、推测和创作性补充必须分开；不能把未在来源中核验的内容写成事实。
