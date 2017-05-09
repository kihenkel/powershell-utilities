# powershell-utilities
A PowerShell file that contains some useful functions.

## How to start
In order to use this you have to copy the `profile.ps1` file into:

- `C:\Windows\System32\WindowsPowerShell\v1.0` (for 32bit)
- `C:\Windows\SysWOW64\WindowsPowerShell\v1.0` (for 64bit)

Alternatively you can create a symbolic link:

- `mklink C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1 C:\Path\To\This\Repository\src\profile.ps1` (for 32bit)
- `mklink C:\Windows\SysWOW64\WindowsPowerShell\v1.0\profile.ps1 C:\Path\To\This\Repository\src\profile.ps1` (for 64bit)

## Commands
- `gogo` - Runs your node application with `npm run serve`
- `cleanup` - Cleans your local git repository by removing non-existent remote branches AND local branches that aren't remote
- `what` - Shows information about your current directory and current git branch