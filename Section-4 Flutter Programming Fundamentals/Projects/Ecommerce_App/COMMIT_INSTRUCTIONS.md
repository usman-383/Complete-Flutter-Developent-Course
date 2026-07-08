Suggested Git commit and push commands

Run these locally to commit the final changes made by the assistant:

# Review changes
git status

git add -A

git commit -m "chore(server+app): add email retry queue, admin UI, alerts, digest; finalize server and test helpers"

git push origin main

Notes:
- Replace `main` with your branch name if different.
- Inspect each file before committing if you want to adjust messages or squash.
