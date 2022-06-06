resource "github_repository" "auth" {
    name = "auth"

    visibility = "private"

    has_issues = true
    has_wiki = false
    has_projects = false
    has_downloads = false
    vulnerability_alerts = true

    allow_merge_commit = true
    allow_squash_merge = true
    allow_rebase_merge = true
}

resource "github_branch" "develop" {
    repository = github_repository.auth.name
    branch     = "develop"
}

resource "github_branch_default" "default"{
    repository = github_repository.auth.name
    branch     = github_branch.develop.branch
}

resource "github_branch_protection" "qa" {
    repository_id = github_repository.auth.node_id

    pattern = "qa"

    required_pull_request_reviews {
        required_approving_review_count = 1
    }

    required_status_checks {
        strict   = false
        contexts = ["IMAGE_BUILD"]
    }

    require_signed_commits = true

    enforce_admins = true

    push_restrictions = [
        github_team.all["QA"].node_id
    ]
}
