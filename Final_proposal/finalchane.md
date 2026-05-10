Section 3 — Table Before Explanation
The integration options table appears before any explanation of what the sections is doing. A reader hitting that table cold does not know why they are reading a three-row comparison. Add one paragraph before the table explaining that you evaluated three paths before committing to a direction.
The table caption says "Integration approach evaluation" but the section is titled "Technical Background and Research." These should be consistent — if this section is about research, frame the table as a research finding.
Section 3.2 — Fablo Codebase Table Has a Contradiction
The Generation Pipeline row says:

"Now uses a pluggable engine architecture. For classic Fabric, it delegates to the existing Docker-based generation via ClassicFabricEngine."

This is describing your PoC, not the current upstream Fablo codebase. A reviewer who clones the Fablo repo today will not find a pluggable engine. The table is supposed to describe findings from source reading, not the state after your changes. Either retitle the table to "Fablo codebase after PoC changes" or describe what you found, then explain what you changed.

8. Section 6.1 — Repeats the Executive Summary
The opening of Section 6.1 says:

"Classic Fablo takes a compact configuration describing organizations, peers, orderers, channels, and chaincodes, runs that configuration through extendConfig(), and emits a complete runnable network."

This is nearly identical to the Executive Summary opening paragraph. By the time a reader reaches Section 6, they have already read this framing twice. Cut the first sentence and start with the Fabric-X decomposition detail that is actually new information.

9. Section 6.2 — Mentor Feedback Reference Is Misplaced
This paragraph appears in the middle of a technical section:

"This is also where I directly apply the mentor feedback on schema design. I agree that Fabric-X should have its own $schema rather than sharing the classic Fabric schema behind a global flag."

Responding to mentor feedback in the middle of a technical subsection is awkward. The mentor feedback on schema-first detection should be  in Section 4 (Architecture Decision) where it belongs. In Section 6.2, just state the design and why it is correct.No need to reference where the idea came from.

10. Section 6.2 — UX Paragraph Is Out of Place
Near the end of Section 6.2 there is this paragraph:

"There is also a user-experience concern I want to address explicitly. Requiring the user to pass the config path and target directory on every command is workable for a proof of concept..."

This has nothing to do with extendFabricXConfig(). It belongs in a CLI design section or in the Phase 2 timeline description. Move it or cut it from 6.2.

11. Section 7 Limitations — Still Partially Redundant With Section 6
The limitations box lists:

"No full CA/Idemix/tokengen pipeline yet"

Section 6.4 describes exactly this gap in two paragraphs with a TypeScript interface. The limitation box should reference Section 6.4 and say one sentence, not re-explain the gap.
Similarly:

"Bundled xdev topology only"

Section 6.1 and 6.2 both explain this. The limitations box should be a concise reference list pointing to where each limitation is addressed, not a re-explanation.

12. Section 8 Pre-Application Research — Still Present
You agreed earlier this should be deleted. The PoC section (Section 4) is the evidence. Section 8 repeats the same points in bullet form. The specific findings about container.go, test_utils.go, and namespace.go are genuinely valuable — but they belong in Section 4 as part of the PoC narrative, not in a separate section at the end. Move the two or three most interesting specific file findings into Section 4 and delete Section 8 entirely.

13. Success Metrics — "Already Verified Foundations" Subsection
This subsection says:

"These items are already demonstrated by the pre-application PoC and reduce the risk of the project"

followed by three bullet points. This is the right idea but the execution is weak. Three one-line bullets do not convey what was actually proven. Replace this with one tight paragraph referencing the PoC link and naming the two specific technical findings from Section 4 (namespace bootstrap polling, orderer endpoint alignment) as evidence of real engineering depth rather than surface-level demo work.

14. Recurring Problem: fablo init --fabricx vs fablo init fabricx
Across the document, both forms appear. You need to pick one and do a global find-and-replace. Based on our earlier discussion, fablo init fabricx is correct because it matches the positional argument style of classic Fablo. Every instance of --fabricx should be fabricx.
