---
name: folder-organization
description: Architectural standards for folder organization, directory naming, modular components, and layering of concerns in the repository
---
# 1. Modular Directory Design

Organize the repository using a modular, layered file system. Group files by logical domain or layer of concern rather than grouping all files by file type.

```
src/
|
|-- components/          # Reusable UI component modules (shared globally)
|   |-- ui/              # Low-level primitive design elements (button, input)
|   `-- forms/           # Form wrappers and controls
|
|-- features/            # Feature modules (colocated state, views, hooks, api hooks)
|   |-- auth/            # Authentication feature domain
|   `-- users/           # User management feature domain
|
|-- server/              # Server-only logic, API controllers, services, database
|   |-- controllers/     # HTTP route handlers & payload controllers
|   |-- services/        # Business logic services
|   `-- db/              # Database models, schemas, and clients
|
`-- utils/               # Common helper utilities, schema validators, types
```

# 2. Layer Isolation Rules

*   **No Circular Imports:** Files in the database layer must never import from the service or controller layers. Files in the utility folder must remain pure and free of imports from feature domains.
*   **Feature Colocation:** Keep feature-specific APIs, state, hooks, and test files inside the feature's subfolder (e.g., `src/features/auth/`) to make copying, deleting, or moving features easy.
*   **Public Interfaces:** Expose feature contents to the rest of the application using a central index file (`src/features/[feature]/index.ts`). Prevent other features from importing deep internal files directly.

