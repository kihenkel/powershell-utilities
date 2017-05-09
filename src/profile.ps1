function runApp {
  cls

  npm run serve
}

function showInfo {
  $CurrentPath = (Get-Item .).FullName
  Write-Host "- You are in directory $($CurrentPath)"

  $ActiveBranch = git rev-parse --abbrev-ref HEAD
  if ($LASTEXITCODE -eq 0) {
    Write-Host "- You are on branch $($ActiveBranch)"
  }
}

function cleanupGitBranches {
  git fetch -p
  $BranchesRawString = git branch -a | Out-String
  [System.Collections.ArrayList]$Branches = $BranchesRawString.Split("`n")
  $Branches.RemoveAt($Branches.Count - 1)

  $ActiveBranch = ""
  $LocalBranches = @()
  $RemoteBranches = @()
  
  foreach ($Branch in $Branches) {
    $TrimmedBranch = $Branch.Trim()

    if ($TrimmedBranch.StartsWith("*")) {
     $TrimmedBranch = $TrimmedBranch.Substring(2)
     $ActiveBranch = $TrimmedBranch
    }

    if ($TrimmedBranch.StartsWith("remotes/origin")) {
      $RemoteBranches += ,$TrimmedBranch
    } else {
      $LocalBranches += ,$TrimmedBranch
    }
  }

  foreach ($LocalBranch in $LocalBranches) {
    $HasCorrespondingRemoteBranch = $false

    foreach ($RemoteBranch in $RemoteBranches) {
      $TrimmedRemoteBranch = $RemoteBranch.Substring(15)

      if ($LocalBranch.Equals($TrimmedRemoteBranch)) {
        $HasCorrespondingRemoteBranch = $true
        break
      }
    }

    if (-Not $HasCorrespondingRemoteBranch) {
      if ($LocalBranch.Equals($ActiveBranch)) {
        Write-Warning "Cannot delete your active branch! Switch to master branch and run cleanup again."
      } else {
        git branch -d $LocalBranch

        if ($LASTEXITCODE -ne 0) {
          Write-Warning "Cannot delete branch '$($LocalBranch)'!"
          Write-Warning "Try to force delete branch? (Y/N)"
          $Answer = Read-Host
          if ($Answer.ToLower().Equals("y")) {
            git branch -D $LocalBranch
          } else {
            Write-Warning "Branch $($LocalBranch) has not been deleted."
          }
        }
      }
    }
  }
}

Set-Alias -Name "gogo" -Value runApp
Set-Alias -Name "cleanup" -Value cleanupGitBranches
Set-Alias -Name "what" -Value showInfo