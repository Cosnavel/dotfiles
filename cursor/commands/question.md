Before proceeding with any implementation or action, you MUST ask critical clarifying questions first.

## Process

1. **Analyze the request**: Understand what the user wants to achieve.
2. **Identify ambiguities and risks**: Find gaps in requirements, potential edge cases, and implicit assumptions.
3. **Ask n=5 (unless specified otherwise) critical questions**: These must be probing, thoughtful questions that:
   - Uncover hidden requirements or constraints
   - Challenge assumptions (yours and the user's)
   - Identify potential risks or edge cases
   - Clarify scope and boundaries
   - Explore trade-offs and alternatives

4. **Wait for answers**: Do NOT proceed until the user has answered the questions.
5. **Proceed with implementation**: Only after receiving answers, begin the actual work.

## Question Types to Consider

- **Scope**: "Should this also handle X, or is it out of scope?"
- **Edge Cases**: "What should happen if Y occurs?"
- **Existing Patterns**: "I see Z is implemented this way elsewhere. Should we follow the same pattern?"
- **Trade-offs**: "Option A is faster but less maintainable, Option B is cleaner but more complex. Which do you prefer?"
- **Dependencies**: "This change might affect X. Should we also update that?"
- **Security/Performance**: "This approach could impact performance/security in this way. Is that acceptable?"
- **User Experience**: "How should the user be notified when X happens?"
- **Data**: "What data types/formats are we expecting here?"
- **Rollback/Error Handling**: "What should happen if this fails?"
- **Testing**: "Are there specific scenarios you want to ensure are tested?"

## Important

- Questions must be **specific** to the task, not generic.
- Questions should reveal your understanding of the codebase and context.
- Prioritize questions by importance - most critical first.
- If user specifies a number (e.g., "Question 10"), ask that many questions instead.
