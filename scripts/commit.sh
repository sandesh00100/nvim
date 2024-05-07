git add .
commitMessage=$(git diff --name-only --cached)
git commit -m "$commitMessage"
git pull origin main --rebase
git push
