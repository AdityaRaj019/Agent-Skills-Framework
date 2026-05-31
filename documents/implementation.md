# Tech-Agnostic Agent Framework: Core Architecture & Implementation Plan

This document defines the complete structural blueprint, execution workflow, and creation guidelines for the `.agents/` repository framework. It incorporates all best practices, rules, design philosophies, and folder layouts for generating single-purpose, highly calibrated AI skills and rules.

---

## Part 1: Skill & Rule Creation Best Practices
These rules govern how all files in the `.agents/` framework must be designed, written, and structured. 

### 1. Scope & Design Philosophy
*   **Keep Skills Focused:** Each skill must do exactly one thing well. Avoid "do-everything" scripts. Create distinct files for distinct tasks.
*   **Clear Frontmatter Descriptions:** The YAML frontmatter `description` determines when the agent activates a skill. Make it highly specific.
*   **Coherent Units:** Scope skills like functions. A skill should handle a single class of problems (e.g., querying database + formatting), not broad administrative modules.
*   **Moderate Detail (Under 500 lines / 5000 tokens):** Favor concise, stepwise guidance with one working example. If reference materials exceed this, use progressive disclosure (store details in a `references/` directory and instruct the agent when to read them).
*   **Agnostic Grounding:** Provide project-specific facts, conventions, API patterns, and edge cases. Do not explain basic concepts that an LLM already knows (e.g., how HTTP or Git works).

### 2. Instruction Patterns
*   **Procedures over Declarations:** Teach the agent *how* to approach a class of problems dynamically, rather than declaring a static code layout.
*   **Provide Defaults, Not Menus:** If multiple tools or libraries can do a task, define a clear default choice first, and note alternatives briefly.
*   **Calibrate Prescriptiveness to Fragility:** Give the agent freedom where multiple approaches work, but use rigid step-by-step commands where operations are fragile (e.g., database migrations).
*   **Scripts as Black Boxes:** If a skill references script tools, instruct the agent to run them with `--help` to inspect usage instead of wasting context parsing the entire script's source code.

### 3. Execution Control & Validation Guardrails
*   **Gotchas Sections:** Every skill must list environment-specific facts or common agent failure modes (e.g., table soft deletes, varying naming conventions across APIs).
*   **Explicit Checklists:** Use checkboxes (`- [ ]`) for multi-step sequences to track execution state.
*   **Validation Loops:** Force a loop: Do the work $\rightarrow$ Run a validator (script or check list) $\rightarrow$ Inspect errors $\rightarrow$ Correct $\rightarrow$ Repeat.
*   **Plan-Validate-Execute:** For destructive or massive operations, have the agent write an intermediate plan (e.g., a JSON schema config), validate it against a script, and execute only when validation passes.

---

## Part 2: Folder Structure Blueprint

All files in the framework use **Markdown with YAML Frontmatter** at the top. The structure is organized as:

```
.agents/
│
├── AGENT.md            # Global identity, philosophy, and boundaries
├── RULES.md            # Absolute global laws (async, boundaries)
├── STACK.md            # Active project stack detection guidelines
├── WORKFLOW.md         # Task execution lifecycles
│
├── skills/             # Single-purpose domain expertise (Focus: gotchas, loops)
│   ├── frontend-design.md
│   ├── backend-services.md
│   ├── database-migrations.md
│   ├── authentication-flows.md
│   ├── security-hardening.md
│   ├── unit-testing.md
│   ├── performance-optimization.md
│   └── code-review.md
│
├── architecture/       # Structural standards & organization
│   ├── folder-organization.md
│   ├── api-patterns.md
│   └── state-management-flow.md
│
├── workflows/          # Procedural execution steps
│   ├── feature-development.md
│   ├── bug-fixing.md
│   └── deployment-flow.md
│
├── checklists/         # Verification protocols
│   ├── function-checklist.md
│   ├── security-checklist.md
│   └── production-readiness.md
│
└── templates/          # Standard scaffolding blueprints
    ├── react-component-template.md
    ├── api-route-template.md
    └── test-template.md
```

---

## Part 3: Detailed File Content Strategy

### Phase 1: Core Orchestration (The Brain)
*   **AGENT.md**: Specifies global agent persona. Emphasizes:
    - *Explain "Why & How"* before execution.
    - *Safety boundary:* DO NOT mess with working codebase. Test in isolation first.
    - *No unprompted git actions.*
*   **RULES.md**: Defines absolute laws:
    - *Strict Async rules:* Return promises, use `await` cleanly, wrap callbacks in `new Promise()`.
    - *Function standards:* Single-responsibility, pure business logic, input validation at boundaries.
*   **STACK.md**: Dynamic guide directing the agent to inspect configurations (e.g., `package.json`, `go.mod`) to align with project tooling without hardcoding stack assumptions.
*   **WORKFLOW.md**: Overall development lifecycle (plan $\rightarrow$ isolate $\rightarrow$ integrate $\rightarrow$ validate $\rightarrow$ sign-off).

### Phase 2: Single-Purpose Skills
Each skill will be generated following the Frontmatter schema:
```markdown
---
name: [skill-name]
description: [specific trigger description]
---
# Instructions
# Gotchas
# Validation Loops
```

### Phase 3: Architectural Standards & Checklists
Defining layout standards and checklists:
- `checklists/function-checklist.md`: Asynchronous execution validation, boundary validation checks.
- `checklists/security-checklist.md`: Secret-leak checks, sanitization.

### Phase 4: Boilerplates & Workflow Procedures
Scaffolding clean files (`templates/`) and outlining specialized routines (`workflows/`).

---

## Part 4: Phase-by-Phase Verification Plan
1.  **Format Validation:** Ensure YAML frontmatter of every file is syntax-valid.
2.  **No-Code Test:** Validate that stack detection operates correctly without hardcoding language assumptions.
3.  **Boundary Inspection:** Check that AGENT/RULES files properly enforce the "safety boundary" rule.
