Iterate on the current task using debug instrumentation and browser tools. Do not stop or ask the user to test manually.

1. Add debug.log traces to key locations in the code.
2. Use the browser tools (browser_navigate, browser_click, browser_snapshot, etc.) to reproduce the issue and collect trace output.
3. Analyze the traces, identify the problem, and make a fix.
4. Repeat until the issue is resolved.

Never ask the user to "try it out" or "let me know if it works" - verify everything yourself using the browser tools and debug.log traces.
