# ADR: Authentication Architecture

## Status
Proposed

## Context
We are building a small, family-only budget application (MVP stage).

Primary goals:
- Simplicity and reliability
- Minimal operational and financial cost
- Clear user isolation
- No need for enterprise-grade scalability or advanced security features

The system must allow future extension with additional authentication providers without redesigning the core authentication or session model.

---

## Decision

### Authentication Model
- Server-side authentication
- Session-based authentication
- Sessions stored server-side
- Session identifier stored in an `httpOnly`, `secure` cookie

JWT-based authentication is explicitly not used for client-server interaction.

---

## Session Design
- One active session per login
- Session is bound to:
    - `sessionId`
    - `userId`

### Cookie Attributes
- `httpOnly: true`
- `secure: true` (production only)
- `sameSite: Lax`

### Session Lifetime
- Effectively infinite
- Session remains valid until explicit logout or manual invalidation

Rationale: family-only usage with trusted users; UX is prioritized over strict security policies.

---

## User Identity
- Single internal `userId` is the canonical identity
- All authentication providers resolve to the same `userId`
- Provider-specific identifiers are not used as primary keys

This design allows adding:
- Email/password authentication
- Apple login
- Facebook login

without changes to session or authorization logic.

---

## Login / Logout Semantics

### Login
- Create a new server-side session
- Set session cookie in the response

### Logout
- Invalidate the current session only
- Remove session cookie

Global logout or multi-device session revocation is out of scope.

---

## Environment Scope
- Environments:
    - `dev`
    - `prod`
- Separate session storage per environment
- No staging or preview environments

---

## Deployment Assumptions
- Single backend service
- No horizontal scaling assumptions
- Session storage compatible with a single-node deployment

Scalability considerations are intentionally deferred.

---

## Alternatives Considered

### JWT (Stateless Authentication)
Rejected because:
- Adds unnecessary complexity
- Token revocation is non-trivial
- No tangible benefit for MVP scope

### OAuth-Only (External Identity Provider)
Rejected because:
- Introduces external dependency
- Reduces control over session behavior
- Not required for MVP

---

## Consequences

### Pros
- Simple and predictable architecture
- Easy debugging
- Clear security boundaries
- Straightforward extension of login methods

### Cons
- Not horizontally scalable without redesign
- Infinite session lifetime increases risk if a cookie is compromised
- Requires server-side session storage

These trade-offs are acceptable for the current scope.

---

## Out of Scope / Follow-up Decisions
- Session storage implementation (DB vs memory)
- CSRF protection strategy
- Rate limiting on authentication endpoints
- Audit logging (login, logout, session expiration)
