# LinkedIn refresh prompt

Run this when your resumes have changed enough that LinkedIn is stale. The output is a one-off paste kit, not canon: your resume sources stay the source of truth, and nothing from the kit flows back into them.

---

Regenerate my LinkedIn paste kit from my current resumes.

**Sources (read them all, and use nothing else about me):** `resumes/src/*.md`, `resumes/README.md` (conventions and do-not-claim rules), `resumes/targets.md` and `resumes/history.md`.

**Rules:**
- Merge all the role-type resumes into one profile: the union of their claims, with every do-not-claim rule still applying.
- Titles and dates must match the resumes exactly, except entries I've marked as hand-edited on LinkedIn.
- Where the resumes word the same fact differently, pick one and list the conflict for me rather than choosing silently.
- Re-verify LinkedIn field limits (headline, About, experience descriptions) by web search instead of trusting earlier numbers.
- Plain text only in description fields: literal `* ` bullets (never the • character) and no markdown.
- First person in About, resume voice in Experience.

**Output:** 3 headline options, About, every Experience entry, Education, Volunteering, Skills (top 5 plus the rest), and a "left out on purpose" list, each with a character count against its limit. Then tell me in a few lines what changed since the last run.
