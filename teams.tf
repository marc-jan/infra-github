locals {
    teams = yamldecode(file("./teams.yaml"))

    teamPermissions = distinct(flatten([
        for username, permissions in yamldecode(file("./permissions.yaml")) : [
            for team in permissions.teams : {
                username = username
                team = team
                role = try(permissions.role, "member")
            }
        ]
    ]))
}

resource "github_team" "all" {
    for_each = local.teams

    name        = each.key
    description = each.value.description
    privacy     = "closed"
}

resource "github_team_membership" "all" {
    for_each = { for entry in local.teamPermissions : "${entry.team}.${entry.username}" => entry }

    team_id  = github_team.all[each.value.team].id
    username = each.value.username
    role = each.value.role
}
