# Setting up GitHub Token for Dependency Upgrades

GitHub Actions require a Personal Access Token (PAT) to create pull requests. Follow these steps to set one up:

## Step 1: Create a Personal Access Token

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Direct link: https://github.com/settings/tokens

2. Click "Generate new token" → "Generate new token (classic)"

3. Configure the token:
   - **Note**: `Dependency Upgrade Bot` (or any descriptive name)
   - **Expiration**: Choose your preferred expiration (or "No expiration" for long-term use)
   - **Scopes**: Select the following permissions:
     - ✅ `repo` (Full control of private repositories)
       - This includes: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`

4. Click "Generate token" at the bottom

5. **IMPORTANT**: Copy the token immediately - you won't be able to see it again!
   - It will look like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Step 2: Add Token as Repository Secret

### Option A: Using GitHub Web Interface

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Enter:
   - **Name**: `PAT_TOKEN`
   - **Secret**: Paste your Personal Access Token
5. Click **Add secret**

### Option B: Using GitHub CLI (Automated)

Run the provided setup script:

```bash
./setup-github-token.sh
```

Or manually:

```bash
gh secret set PAT_TOKEN --repo <your-username>/<your-repo-name>
```

Then paste your token when prompted.

### Option C: Using GitHub CLI (One-liner)

```bash
echo -n "YOUR_TOKEN_HERE" | gh secret set PAT_TOKEN --repo <your-username>/<your-repo-name>
```

Replace `YOUR_TOKEN_HERE` with your actual token and `<your-username>/<your-repo-name>` with your repository.

## Verification

After setting up the token, you can test the workflow by:

1. Going to your repository → **Actions** tab
2. Select "Upgrade Dependencies" workflow
3. Click "Run workflow" → "Run workflow"
4. The workflow should now be able to create branches and PRs

## Security Notes

- Never commit tokens to your repository
- Use repository secrets for sensitive values
- Consider using fine-grained tokens (beta) for more granular permissions if preferred
- Rotate tokens periodically for security

