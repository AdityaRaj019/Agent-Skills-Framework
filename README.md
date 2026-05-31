# AI Framework

Reusable agent instructions for software projects.

This repository is the source of truth for the `.agents` framework. Instead of copying `.agents` into every project, install it as a link from each project to this central folder.



In the target project:

```powershell
git submodule add https://github.com/AdityaRaj019/Agent-Skills-Framework.git .agent-framework
powershell -ExecutionPolicy Bypass -File .\.agent-framework\scripts\install-agents.ps1 -ProjectPath .
```

This creates:

```text
YourProject/
|-- .agent-framework/  -> Git submodule pointing to your framework repo
|-- .agents            -> linked to .agent-framework/.agents
`-- AGENTS.md          -> bridge file that tells coding agents to read .agents/README.md
```

Update the framework in a project:

```powershell
git submodule update --remote .agent-framework
```

Pin the updated framework version in that project:

```powershell
git add .agent-framework
git commit -m "Update AI agent framework"
```

This gives you one central GitHub framework, no copy-paste, and every project can choose when to update.

## Local Use

From any PowerShell terminal:

```powershell
powershell -ExecutionPolicy Bypass -File D:\Repo\AI-Framework\scripts\install-agents.ps1 -ProjectPath D:\Repo\YourProject
```

This creates:

```text
YourProject/
|-- .agents   -> linked to D:\Repo\AI-Framework\.agents
`-- AGENTS.md -> bridge file that tells coding agents to read .agents/README.md
```

Because `.agents` is linked, updates made in this framework repository are immediately available in every project that uses the link.

## Install Modes

### Link mode

Default and recommended. Creates a Windows junction:

```powershell
powershell -ExecutionPolicy Bypass -File D:\Repo\AI-Framework\scripts\install-agents.ps1 -ProjectPath D:\Repo\YourProject -Mode Link
```

Use this when you want all projects to share the same framework.

### Copy mode

Creates a standalone snapshot:

```powershell
powershell -ExecutionPolicy Bypass -File D:\Repo\AI-Framework\scripts\install-agents.ps1 -ProjectPath D:\Repo\YourProject -Mode Copy
```

Use this only when a project needs a frozen or customized copy.

## Existing Projects

If a project already has `.agents`, the installer stops by default to avoid overwriting local work.

To preserve the existing folder as a timestamped backup and install the framework:

```powershell
powershell -ExecutionPolicy Bypass -File D:\Repo\AI-Framework\scripts\install-agents.ps1 -ProjectPath D:\Repo\YourProject -Force
```

## How Agents Should Start

Agents should begin by reading:

1. `.agents/README.md`
2. `.agents/AGENT.md`
3. `.agents/CONTEXT.md`

`CONTEXT.md` tells agents to inspect Graphify output and Obsidian state files such as `Action_Register.md` and `Context_state.md` when project memory matters.
