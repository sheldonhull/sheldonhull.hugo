---
applyTo: '**'
---

# Code Modification and Contribution Guidelines for AI Coding Agent

These instructions guide AI-assisted code contributions to ensure precision, maintainability, and alignment with project architecture. Follow each rule exactly unless explicitly told otherwise.

1. **Minimize Scope of Change**  
   - Identify the smallest unit (function, class, or module) that fulfills the requirement.  
   - Do not modify unrelated code.  
   - Avoid refactoring unless required for correctness or explicitly requested.

2. **Preserve System Behavior**  
   - Ensure the change does not affect existing features or alter outputs outside the intended scope.  
   - Maintain original patterns, APIs, and architectural structure unless otherwise instructed.

3. **Graduated Change Strategy**  
   - **Default:** Implement the minimal, focused change.  
   - **If Needed:** Apply small, local refactorings (e.g., rename a variable, extract a function).  
   - **Only if Explicitly Requested:** Perform broad restructuring across files or modules.

4. **Clarify Before Acting on Ambiguity**  
   - If the task scope is unclear or may impact multiple components, stop and request clarification.  
   - Never assume broader intent beyond the described requirement.

5. **Log, Don’t Implement, Unscoped Enhancements**  
   - Identify and note related improvements without changing them.  
   - Example: `// Note: Function Y may benefit from similar validation.`
