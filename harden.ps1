
# ===== Variables Section Start =====
$MaxPasswordAge = 60  # Maximum password age in days
$MinPasswordAge    = 10   # minimum days a password must be used
$MinPasswordLength = 10   # minimum length of passwords
$PasswordHistory   = 20   # number of previous passwords remembered
$LockoutThreshold  = 5    # bad logon attempts before lockout
$LockoutDuration   = 10   # minutes an account remains locked
$LockoutWindow     = 10   # minutes in which bad logons are counted
# ===== Variables Section End =====

# Check for admin rights and relaunch as admin if needed
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script is not running as administrator. Relaunching as admin..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
# Display the computer's hostname
Write-Host "Computer Name: $env:COMPUTERNAME"

# Display the Windows version
Write-Host "Windows Version:"
Get-ComputerInfo | Select-Object -Property WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
Write-Host "Script Run Time: $(Get-Date)"

# Define menu options
$menuOptions = @(
    "Document the system",
    "Enable updates",
    "User Auditing",
    "Account Policies",
    "Local Policies",
    "Defensive Countermeasures",
    "Uncategorized OS Settings",
    "Service Auditing",
    "OS Updates",
    "Application Updates",
    "Prohibited Files",
    "Unwanted Software",
    "Malware",
    "Application Security Settings",
    "Exit"
)

# Define functions for each option
function Document-System {
    Write-Host "`n--- Starting: Document the system ---`n"
}

function Enable-Updates {
    Write-Host "`n--- Starting: Enable updates ---`n"
}

function User-Auditing {
    Write-Host "`n--- Starting: User Auditing ---`n"
    # ...existing code...
    # Enumerate all local user accounts
    $localUsers = Get-LocalUser

    foreach ($user in $localUsers) {
        # Skip built-in accounts
        if ($user.Name -in @('Administrator', 'DefaultAccount', 'Guest', 'WDAGUtilityAccount')) {
            continue
        }

        $prompt = "Is '$($user.Name)' an Authorized User? [Y/n]: "
        $answer = Read-Host -Prompt $prompt

        if ($answer -eq 'n' -or $answer -eq 'N') {
            try {
                Remove-LocalUser -Name $user.Name
                Write-Host "Deleted user: $($user.Name)"
            } catch {
                Write-Host "Failed to delete user: $($user.Name) - $_"
            }
        } else {
            Write-Host "Kept user: $($user.Name)"
        }
    }
    # Enumerate all users in the Administrators group
    $adminGroup = Get-LocalGroupMember -Group "Administrators"

    foreach ($admin in $adminGroup) {
        # Only process user accounts (not groups or service accounts)
        if ($admin.ObjectClass -ne 'User') {
            continue
        }

        $prompt = "Is '$($admin.Name)' an Authorized Administrator? [Y/n]: "
        $answer = Read-Host -Prompt $prompt

        if ($answer -eq 'n' -or $answer -eq 'N') {
            try {
                Remove-LocalGroupMember -Group "Administrators" -Member $admin.Name
                Write-Host "Removed administrator: $($admin.Name)"
            } catch {
                Write-Host "Failed to remove administrator: $($admin.Name) - $_"
            }
        } else {
            Write-Host "Kept administrator: $($admin.Name)"
        }
    }
}

function Account-Policies {
    Write-Host "`n--- Starting: Account Policies ---`n"
     Write-Host "`n--- Starting: Account Policies ---`n"
    Write-Host "Setting maximum password age to $MaxPasswordAge days..."
    net accounts /maxpwage:$MaxPasswordAge
     Write-Host "`n--- Starting: Account Policies ---`n"

    Write-Host "Setting minimum password age to $MinPasswordAge days..."
    net accounts /minpwage:$MinPasswordAge

    Write-Host "Setting minimum password length to $MinPasswordLength characters..."
    net accounts /minpwlen:$MinPasswordLength

    Write-Host "Setting password history to remember $PasswordHistory passwords..."
    net accounts /uniquepw:$PasswordHistory

    Write-Host "Setting lockout threshold to $LockoutThreshold bad logon attempts..."
    net accounts /lockoutthreshold:$LockoutThreshold

    Write-Host "Setting lockout duration to $LockoutDuration minutes..."
    net accounts /lockoutduration:$LockoutDuration

    Write-Host "Setting lockout window to $LockoutWindow minutes..."
    net accounts /lockoutwindow:$LockoutWindow
}

function Local-Policies {
    Write-Host "`n--- Starting: Local Policies ---`n"
}

function Defensive-Countermeasures {
    Write-Host "`n--- Starting: Defensive Countermeasures ---`n"
}

function Uncategorized-OS-Settings {
    Write-Host "`n--- Starting: Uncategorized OS Settings ---`n"
}

function Service-Auditing {
    Write-Host "`n--- Starting: Service Auditing ---`n"
}

function OS-Updates {
    Write-Host "`n--- Starting: OS Updates ---`n"
}

function Application-Updates {
    Write-Host "`n--- Starting: Application Updates ---`n"
}

function Prohibited-Files {
    Write-Host "`n--- Starting: Prohibited Files ---`n"
}

function Unwanted-Software {
    Write-Host "`n--- Starting: Unwanted Software ---`n"
}

function Malware {
    Write-Host "`n--- Starting: Malware ---`n"
}

function Application-Security-Settings {
    Write-Host "`n--- Starting: Application Security Settings ---`n"
}

# Menu loop
:menu do {
    Write-Host "`nSelect an option:`n"
    for ($i = 0; $i -lt $menuOptions.Count; $i++) {
        Write-Host "$($i + 1). $($menuOptions[$i])"
    }

    $selection = Read-Host "`nEnter the number of your choice"

    switch ($selection) {
        "1"  { Document-System }
        "2"  { Enable-Updates }
        "3"  { User-Auditing }
        "4"  { Account-Policies }
        "5"  { Local-Policies }
        "6"  { Defensive-Countermeasures }
        "7"  { Uncategorized-OS-Settings }
        "8"  { Service-Auditing }
        "9"  { OS-Updates }
        "10" { Application-Updates }
        "11" { Prohibited-Files }
        "12" { Unwanted-Software }
        "13" { Malware }
        "14" { Application-Security-Settings }
        "15" { Write-Host "`nExiting..."; break menu }
        default { Write-Host "`nInvalid selection. Please try again." }
    }
} while ($true)

# work? 