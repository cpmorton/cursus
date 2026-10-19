# Interview prep prompt

Paste everything below the line into an AI assistant that can read your private repo. Change the ROLE line for each run.

---

ROLE: <target role and company>

Build my interview prep for the role above.

**Sources: read these first, and use nothing else about me.**
- `resumes/targets.md`: the posting's requirements, my gaps, and my study list.
- `resumes/README.md`: my conventions and the do-not-claim list.
- The resume source for this role type in `resumes/src/`.
- The posting itself. Fetch it again, because postings change.

**Rules:**
- Never invent experience. Every answer must trace to a resume line or to something I say in this chat. If a question hits a known gap, write an honest "adjacent experience, and how I'd approach it" answer.
- Verify technical facts against vendor docs for the versions in play, and cite them. Mark anything from memory as unverified.
- Talk to me as a peer at my level. Skip the basics and go deep where the posting goes deep.

**Output: one document with these sections:**
1. **Role in one paragraph:** what the team owns and what they'll probe hardest.
2. **Likely questions (15–25):** technical deep-dive, scenario and behavioral. For each one: why they're asking, the resume line it maps to, and a 3–5 bullet answer outline.
3. **Story bank:** 6–8 STAR stories tagged to the requirements they prove. Write `[TODO: metric?]` rather than guess a number.
4. **Gap plan:** what to study, primary sources, and a 30-second honest answer for each gap.
5. **Study sheet:** map the posting's tools to equivalents I already know.
6. **Questions to ask them:** 5–8 that show I read the posting.

**Then quiz me:** ask one question at a time, critique each answer honestly, and note any new facts I reveal so I can add them to my canon.
