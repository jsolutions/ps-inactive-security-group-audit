# Powershell script to get a list of all security groups that have no active users

$groups = Get-ADGroup -Filter * -Properties *

# Initialize an array to store the groups with no active users
$noActiveUsersGroups = @()

foreach ($group in $groups) {
    # Check if the group has no users
    if ((Get-ADGroupMember -Identity $group).count -eq 0) {
        $noActiveUsersGroups += $group
    }
    # else determine if the group's users are all disabled. If all users are disabled, write-host the group name
    else {
        $users = Get-ADGroupMember -Identity $group
        $allDisabled = $true
        foreach ($user in $users) {
            if ($user.Enabled -eq $true) {
                $allDisabled = $false
                break
            }
        }
        if ($allDisabled) {
            $noActiveUsersGroups += $group
        }
    }

}

# Write the list of groups with no active users to a csv file in the directory that the script was run in
$noActiveUsersGroups | Export-Csv -Path .\no_active_user_security_groups.csv -NoTypeInformation