# Security Review

A security-focused checklist for code reviews. Apply to every change,
regardless of size — security issues are often introduced in small, seemingly
innocuous edits.

For secrets handling and input validation rules, see
[coding standards](coding.md#secrets).

## Injection

Never construct queries, commands, or paths by concatenating user-supplied
input.

- **SQL**: Use parameterized queries or prepared statements; never interpolate
  values directly into query strings
- **Command**: Avoid `exec`/`shell` calls with user input; prefer library APIs
  over shell invocation
- **Path traversal**: Resolve and validate paths against an allowed base
  directory; reject `../` sequences
- **Template**: Use auto-escaping template engines; never render raw user input
  as a template
- **XSS**: Escape output in HTML contexts; apply Content Security Policy headers

## Authentication & Authorization

- Every route, endpoint, or operation that accesses restricted data must verify
  identity and permissions before executing
- Check for **IDOR** (Insecure Direct Object Reference) — ensure the
  authenticated user owns or has rights to the requested resource
- Authorization checks belong on the server; never rely solely on client-side
  guards
- Verify that session tokens are invalidated on logout and expiry
- Confirm that privilege escalation paths (role changes, admin endpoints) are
  explicitly protected

## Cryptography

- Use modern algorithms: **bcrypt**, **Argon2**, or **scrypt** for passwords;
  **AES-256-GCM** for symmetric encryption; **SHA-256** or stronger for hashing
- Never use MD5 or SHA-1 for security-sensitive purposes
- Use a cryptographically secure random number generator (CSPRNG) for tokens,
  nonces, and IVs — never `Math.random()` or equivalent
- Do not hard-code IVs, salts, or keys; generate them randomly per operation
  where applicable
- Transmit sensitive data over TLS only; flag any plain-HTTP endpoints

## Information Exposure

Do not leak internal system details in responses, logs, or error messages.

- **Error responses**: Return generic messages to clients; log full details
  server-side only
- **Stack traces**: Never include stack traces or internal paths in API
  responses
- **Logging**: Scrub PII (email, name, IP, tokens) from log output; do not log
  request bodies containing credentials
- **Headers**: Remove or suppress version-revealing headers
  (`X-Powered-By`, `Server`, etc.)

## Dependencies

- Flag direct dependencies with known CVEs or that are significantly out of
  date
- Prefer well-maintained packages with active security disclosure processes
- Avoid packages that have not had a release or commit in over 12 months for
  critical functionality
- Verify that lock files (`package-lock.json`, `poetry.lock`, etc.) are
  committed and up to date

## Denial of Service

- Flag unbounded loops, recursion without depth limits, or operations whose
  complexity scales with untrusted input size
- Confirm that file uploads, request bodies, and query results have size or
  count limits
- Check for missing rate limiting on public or unauthenticated endpoints
- Verify that external calls (HTTP, DB, queue) have timeouts set

## Concurrency & Race Conditions

- Flag shared mutable state accessed from multiple goroutines, threads, or
  async tasks without synchronization
- Check for TOCTOU (Time-of-Check/Time-of-Use) patterns — reading a value,
  then acting on it without re-verifying under a lock
- Verify that atomic operations are used where required (counters, flags,
  caches)
