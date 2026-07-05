# Architecture Decision Index

## Golden Wings Enterprise Repository — GW-EAF v1.9.0

---

## 1. Purpose

This document provides a single-page index of all Architecture Decision Records (ADRs) created during the GW-EAF implementation. It allows developers and maintainers to quickly find the rationale behind key architectural decisions.

**Total ADRs:** 10

---

## 2. ADR Index

| ADR | Title | Status | Date | Category |
|-----|-------|--------|------|----------|
| ADR-001 | Versioning Strategy — v1.x until full adoption | ✅ Approved | July 2026 | Versioning |
| ADR-002 | Orchestration Pattern — Scripts orchestrate; services implement | ✅ Approved | July 2026 | Architecture |
| ADR-003 | Configuration Centralization — Single source of truth | ✅ Approved | July 2026 | Configuration |
| ADR-004 | Service Extraction — Each capability exists once | ✅ Approved | July 2026 | Architecture |
| ADR-005 | Public API Stability — Stable API frozen | ✅ Approved | July 2026 | API |
| ADR-006 | No Breaking Changes Without Governance | ✅ Approved | July 2026 | Governance |
| ADR-007 | Repository.Common Evolution — Incremental, not big-bang | ✅ Approved | July 2026 | Implementation |
| ADR-008 | Service Dependency Rules — Explicit and governed | ✅ Approved | July 2026 | Architecture |
| ADR-009 | Backward Compatibility First — Existing scripts continue working | ✅ Approved | July 2026 | Compatibility |
| ADR-010 | Production Ready Declaration — GW-EAF v1.9.0 | ✅ Approved | July 2026 | Governance |

---

## 3. ADR Details

### ADR-001: Versioning Strategy

**Title:** Versioning Strategy — v1.x until full adoption

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Versioning

**Context:** Repository.Common.psm1 currently says v2.0, but architecture decision says v1.x until full adoption.

**Decision:** Repository.Common.psm1 remains v1.x until all scripts consume the framework.

**Rationale:** Prevents breaking changes before migration complete.

**Consequences:** Version header changed from v2.0 to v1.2.

**Related Documents:** RM, Repository.Common.psm1

---

### ADR-002: Orchestration Pattern

**Title:** Orchestration Pattern — Scripts orchestrate; services implement

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Architecture

**Context:** Build-Baseline.ps1 demonstrates the orchestration pattern that should be standardized.

**Decision:** All scripts shall become pure orchestration. Framework services implement business logic.

**Rationale:** Separation of concerns, reusability, testability.

**Consequences:** All scripts refactored to call framework services.

**Related Documents:** Build-Baseline.ps1, DH

---

### ADR-003: Configuration Centralization

**Title:** Configuration Centralization — Single source of truth

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Configuration

**Context:** Hardcoded paths in 4 scripts (Generate-Manifest.ps1, Release-Repository.ps1, Build-Hashes.ps1, Verify-Repository.ps1).

**Decision:** All configuration values shall be centralized in Configuration Service.

**Rationale:** Eliminate hardcoded paths. Enable environment-specific configurations.

**Consequences:** Configuration Service built first.

**Related Documents:** RM, Repository.Common.psm1

---

### ADR-004: Service Extraction

**Title:** Service Extraction — Each capability exists once

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Architecture

**Context:** Duplicated logic across 5+ locations (metadata, validation, hashing, statistics, repository discovery).

**Decision:** Each capability shall exist once in a framework service.

**Rationale:** Eliminate duplication. Single source of truth.

**Consequences:** Services extracted from scripts.

**Related Documents:** SSOT-IEB-2026.1-B, RM

---

### ADR-005: Public API Stability

**Title:** Public API Stability — Stable API frozen

**Date:** July 2026

**Status:** ✅ Approved

**Category:** API

**Context:** 21 functions currently exported. No internal/private separation.

**Decision:** Public API functions shall remain stable. Internal functions may evolve.

**Rationale:** Protect consuming scripts. Enable framework evolution.

**Consequences:** Public API frozen. Internal API defined.

**Related Documents:** Repository.Common.psm1, GW-EAF-API-Reference.md

---

### ADR-006: No Breaking Changes Without Governance

**Title:** No Breaking Changes Without Governance

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Governance

**Context:** Scripts depend on framework functions.

**Decision:** Breaking changes require ADR, impact assessment, migration plan, approval.

**Rationale:** Preserve existing automation. Enable controlled evolution.

**Consequences:** Breaking changes are governed.

**Related Documents:** RG-001, RK

---

### ADR-007: Repository.Common Evolution

**Title:** Repository.Common Evolution — Incremental, not big-bang

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Implementation

**Context:** Repository.Common currently has 21 functions. Services are not separated.

**Decision:** Repository.Common shall evolve incrementally. Services added one at a time.

**Rationale:** Keep scripts operational. Minimize risk.

**Consequences:** Services built incrementally. Scripts refactored one at a time.

**Related Documents:** Repository.Common.psm1

---

### ADR-008: Service Dependency Rules

**Title:** Service Dependency Rules — Explicit and governed

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Architecture

**Context:** Dependencies need to be explicit and governed.

**Decision:** Dependency rules defined and enforced. Configuration has no dependencies. Services don't call scripts.

**Rationale:** Prevent circular dependencies. Maintain architectural clarity.

**Consequences:** Dependency rules documented and enforced.

**Related Documents:** SSOT-IEB-2026.1-C, DH

---

### ADR-009: Backward Compatibility First

**Title:** Backward Compatibility First — Existing scripts continue working

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Compatibility

**Context:** Existing scripts depend on current framework functions.

**Decision:** Existing exported functions remain operational throughout Stage D implementation.

**Rationale:** Allows incremental migration without breaking automation.

**Consequences:** Old scripts continue working. New services introduced incrementally. No big-bang rewrite.

**Related Documents:** Repository.Common.psm1, Test-Phase1.ps1

---

### ADR-010: Production Ready Declaration

**Title:** Production Ready Declaration — GW-EAF v1.9.0

**Date:** July 2026

**Status:** ✅ Approved

**Category:** Governance

**Context:** All implementation phases complete. All tests passing.

**Decision:** GW-EAF v1.9.0 declared production-ready.

**Rationale:** 10 services, 55 functions, all tests passing. Framework certified.

**Consequences:** Project closed. Maintenance mode begins.

**Related Documents:** RH — Decision Register, SSOT-IEB-2026.1-D

---

## 4. ADR Categories Summary

| Category | Count | ADRs |
|----------|-------|------|
| Versioning | 1 | ADR-001 |
| Architecture | 3 | ADR-002, ADR-004, ADR-008 |
| Configuration | 1 | ADR-003 |
| API | 1 | ADR-005 |
| Governance | 2 | ADR-006, ADR-010 |
| Implementation | 1 | ADR-007 |
| Compatibility | 1 | ADR-009 |

---

## 5. ADR Status Summary

| Status | Count |
|--------|-------|
| ✅ Approved | 10 |
| ⬜ Proposed | 0 |
| ⬜ Superseded | 0 |

---

## 6. Related Documents

| Document | Purpose |
|----------|---------|
| SSOT-IEB-2026.1-C | Architecture Specification |
| RM | GW-EAF Architecture |
| Repository.Common.psm1 | Framework Module |
| DH | Developer Handbook |
| RG-001 | Repository Governance Manual |
| RK | Change Management Manual |
| RH | Decision Register |

---

## 7. How to Use This Index

1. **Find a decision** by scanning the ADR Index table
2. **Read the full ADR** by locating the ADR in the details section
3. **Understand the context** by reviewing the Context and Rationale
4. **See the consequences** by reviewing the Consequences section
5. **Find related documents** by checking the Related Documents section

---

## 8. ADR Lifecycle

**Proposed → Approved → Implemented → Superseded**

**Status Definitions:**

| Status | Meaning |
|--------|---------|
| Proposed | Under consideration |
| Approved | Accepted for implementation |
| Implemented | Fully operational |
| Superseded | Replaced by a later ADR |

---

## END OF DOCUMENT

---

*"Architecture decisions are the foundation of maintainable systems."*
