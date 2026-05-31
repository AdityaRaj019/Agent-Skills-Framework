---
name: state-management-flow
description: Architectural guidelines for UI state management, caching client state, context rules, and local state isolation
---
# 1. State Isolation Strategy

*   **Local State by Default:** Keep UI state inside the smallest scope possible (component level using hooks like `useState` / `useReducer`). Do not lift state to global contexts unless multiple sibling features require access to it.
*   **Server State Isolation:** Separate server cache states (loading, errors, fetched records) from local UI interaction state (e.g., drawer open state, active tab). Use dedicated state managers like React Query (TanStack Query) or SWR to handle caching, stale revalidations, and prefetching automatically.
*   **Context for Read-Only Themes & Auth:** Use React Context strictly for values that change infrequently (e.g., user session details, themes, language locales) to prevent unnecessary re-renders of the application tree.

# 2. State Mutation Rules

*   **Optimistic Updates:** For high-frequency actions (e.g., toggling a favorite switch), update the client state optimistically immediately upon trigger, and roll back only if the underlying API request fails.
*   **Immutable State Transitions:** Never mutate state containers directly. Always dispatch actions or pass copy mappings to update states.
