---
name: api-patterns
description: Standards for API route naming, response structures, status codes, query pagination, and REST/GraphQL interface design
---
# 1. API Route Design & REST Conventions

*   **URL Structure:** Route resources using plural nouns and clear nested hierarchies:
    *   `GET /api/v1/users` (List users)
    *   `POST /api/v1/users` (Create a user)
    *   `GET /api/v1/users/:id/posts` (List posts created by a specific user)
*   **HTTP Methods:** Use methods matching their semantic actions:
    *   `GET` (Retrieve records - must be idempotent)
    *   `POST` (Create new records)
    *   `PUT` (Full replacement of a record)
    *   `PATCH` (Partial update of a record)
    *   `DELETE` (Remove a record)

# 2. Response & Error Payload Formats

*   **Success Payload Structure:** Return data inside a root `data` object:
    ```json
    {
      "success": true,
      "data": {
        "id": "usr_123",
        "email": "user@example.com"
      }
    }
    ```
*   **Error Payload Structure:** Return error context inside a root `error` object:
    ```json
    {
      "success": false,
      "error": {
        "code": "VALIDATION_FAILED",
        "message": "The request body failed schema checks.",
        "details": [
          { "field": "email", "issue": "Invalid email address format" }
        ]
      }
    }
    ```
*   **Pagination Standards:** Standardize cursor or offset parameters for listing queries. Return meta descriptors (cursor, limit, total, hasNext) at the root level of the response:
    ```json
    {
      "success": true,
      "data": [],
      "meta": {
        "limit": 20,
        "total": 150,
        "nextCursor": "abc_xyz_789"
      }
    }
    ```
