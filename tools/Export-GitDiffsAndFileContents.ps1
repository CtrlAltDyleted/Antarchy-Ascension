param(
    [string]$OutputFile = ""
)

$ErrorActionPreference = "Stop"

# Make sure we're inside a Git repository.
$previousErrorActionPreference = $ErrorActionPreference
try {
    $ErrorActionPreference = "Continue"
    $repoRootOutput = @(& git rev-parse --show-toplevel 2>&1)
    $repoRootExitCode = $LASTEXITCODE
}
finally {
    $ErrorActionPreference = $previousErrorActionPreference
}

if ($repoRootExitCode -ne 0 -or $repoRootOutput.Count -eq 0) {
    throw "This script must be run from inside a Git repository."
}

$repoRoot = [string]$repoRootOutput[0]
Set-Location $repoRoot

if ([string]::IsNullOrWhiteSpace($OutputFile)) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputFile = Join-Path $repoRoot "GIT-DIFF-AND-FILE-CONTENTS-$timestamp.txt"
}
elseif (-not [System.IO.Path]::IsPathRooted($OutputFile)) {
    $OutputFile = Join-Path $repoRoot $OutputFile
}

# Do not include the report itself if it is created inside the repo.
$outputFullPath = [System.IO.Path]::GetFullPath($OutputFile)

function Invoke-NativeCommandSafe {
    param(
        [scriptblock]$Command
    )

    $previous = $ErrorActionPreference
    $result = @()
    $exitCode = 0

    try {
        # Windows PowerShell 5.1 can surface native STDERR as ErrorRecord objects.
        # Keep native warnings/errors from becoming terminating PowerShell errors.
        $ErrorActionPreference = "Continue"
        $result = @(& $Command 2>&1)
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previous
    }

    return [pscustomobject]@{
        Output   = $result
        ExitCode = $exitCode
    }
}

function Write-Section {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$Title
    )

    $Writer.WriteLine("")
    $Writer.WriteLine(("=" * 100))
    $Writer.WriteLine($Title)
    $Writer.WriteLine(("=" * 100))
    $Writer.WriteLine("")
}

function Write-CommandOutput {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$CommandText,
        [scriptblock]$Command
    )

    $Writer.WriteLine("> $CommandText")
    $Writer.WriteLine("")

    $native = Invoke-NativeCommandSafe -Command $Command

    if ($null -eq $native.Output -or @($native.Output).Count -eq 0) {
        $Writer.WriteLine("(no output)")
    }
    else {
        foreach ($line in @($native.Output)) {
            $Writer.WriteLine([string]$line)
        }
    }

    if ($native.ExitCode -ne 0) {
        $Writer.WriteLine("")
        $Writer.WriteLine("[command exited with code $($native.ExitCode)]")
    }

    $Writer.WriteLine("")
}

function Test-BinaryFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    $stream = [System.IO.File]::OpenRead($Path)
    try {
        $bufferLength = [Math]::Min(8192, [int]$stream.Length)
        if ($bufferLength -eq 0) {
            return $false
        }

        $buffer = New-Object byte[] $bufferLength
        [void]$stream.Read($buffer, 0, $bufferLength)

        # NUL bytes are a strong signal that the file is binary.
        return ($buffer -contains 0)
    }
    finally {
        $stream.Dispose()
    }
}

function Write-CurrentFile {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$RelativePath
    )

    $fullPath = Join-Path $repoRoot $RelativePath

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        $Writer.WriteLine("(file does not exist in working tree)")
        return $false
    }

    $resolved = [System.IO.Path]::GetFullPath($fullPath)
    if ($resolved -eq $outputFullPath) {
        $Writer.WriteLine("(skipped report output file)")
        return $true
    }

    if (Test-BinaryFile -Path $fullPath) {
        $item = Get-Item -LiteralPath $fullPath
        $hash = (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash
        $Writer.WriteLine("(binary file not dumped as text)")
        $Writer.WriteLine("Size: $($item.Length) bytes")
        $Writer.WriteLine("SHA256: $hash")
        return $true
    }

    try {
        $content = Get-Content -LiteralPath $fullPath -Raw -ErrorAction Stop
        if ($null -eq $content -or $content.Length -eq 0) {
            $Writer.WriteLine("(empty file)")
        }
        else {
            $Writer.Write($content)
            if (-not $content.EndsWith("`n")) {
                $Writer.WriteLine("")
            }
        }
        return $true
    }
    catch {
        $Writer.WriteLine("(could not read as text: $($_.Exception.Message))")
        return $false
    }
}

function Get-GitObjectContent {
    param(
        [string]$Spec
    )

    $native = Invoke-NativeCommandSafe -Command {
        & git show --text $Spec
    }

    return [pscustomobject]@{
        Success  = ($native.ExitCode -eq 0)
        Output   = @($native.Output)
        ExitCode = $native.ExitCode
    }
}

function Write-GitObject {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$Spec,
        [string]$MissingMessage
    )

    $result = Get-GitObjectContent -Spec $Spec

    if (-not $result.Success) {
        $Writer.WriteLine($MissingMessage)
        return $false
    }

    if ($result.Output.Count -eq 0) {
        $Writer.WriteLine("(empty file)")
        return $true
    }

    foreach ($line in $result.Output) {
        $Writer.WriteLine([string]$line)
    }

    return $true
}

function Write-HeadFile {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$RelativePath
    )

    $spec = "HEAD:$RelativePath"
    return Write-GitObject `
        -Writer $Writer `
        -Spec $spec `
        -MissingMessage "(file does not exist in HEAD)"
}

function Write-IndexFile {
    param(
        [System.IO.StreamWriter]$Writer,
        [string]$RelativePath
    )

    # :path refers to the stage-0 index version of the path.
    $spec = ":$RelativePath"
    return Write-GitObject `
        -Writer $Writer `
        -Spec $spec `
        -MissingMessage "(file does not exist in the index)"
}

# Collect changed paths from porcelain status, including untracked files.
$statusNative = Invoke-NativeCommandSafe -Command {
    & git status --porcelain=v1 -uall
}

if ($statusNative.ExitCode -ne 0) {
    throw "git status failed with exit code $($statusNative.ExitCode)."
}

$statusLines = @($statusNative.Output | ForEach-Object { [string]$_ })

$changed = New-Object System.Collections.Generic.List[object]

foreach ($line in $statusLines) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.Length -lt 4) {
        continue
    }

    $xy = $line.Substring(0, 2)
    $indexStatus = $xy.Substring(0, 1)
    $workTreeStatus = $xy.Substring(1, 1)
    $pathPart = $line.Substring(3)

    # Handle renames/copies: "old -> new"
    $oldPath = $null
    $newPath = $pathPart

    if ($pathPart -match '^(.*?) -> (.*)$') {
        $oldPath = $matches[1].Trim('"')
        $newPath = $matches[2].Trim('"')
    }
    else {
        $newPath = $pathPart.Trim('"')
    }

    $changed.Add([pscustomobject]@{
        XY             = $xy
        IndexStatus    = $indexStatus
        WorkTreeStatus = $workTreeStatus
        OldPath        = $oldPath
        Path           = $newPath
    })
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$writer = New-Object System.IO.StreamWriter($OutputFile, $false, $utf8NoBom)

try {
    $writer.WriteLine("GIT DIFF AND FILE CONTENTS REPORT")
    $writer.WriteLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss K')")
    $writer.WriteLine("Repository: $repoRoot")

    Write-Section -Writer $writer -Title "REPOSITORY INFO"
    Write-CommandOutput -Writer $writer -CommandText "git branch --show-current" -Command {
        & git branch --show-current
    }
    Write-CommandOutput -Writer $writer -CommandText "git rev-parse HEAD" -Command {
        & git rev-parse HEAD
    }
    Write-CommandOutput -Writer $writer -CommandText "git log -1 --oneline" -Command {
        & git log -1 --oneline
    }

    Write-Section -Writer $writer -Title "GIT STATUS"
    Write-CommandOutput -Writer $writer -CommandText "git status" -Command {
        & git status
    }

    Write-Section -Writer $writer -Title "GIT STATUS --SHORT"
    Write-CommandOutput -Writer $writer -CommandText "git status --short --untracked-files=all" -Command {
        & git status --short --untracked-files=all
    }

    Write-Section -Writer $writer -Title "UNSTAGED DIFF"
    Write-CommandOutput -Writer $writer -CommandText "git diff --no-ext-diff --binary" -Command {
        & git diff --no-ext-diff --binary
    }

    Write-Section -Writer $writer -Title "STAGED DIFF"
    Write-CommandOutput -Writer $writer -CommandText "git diff --cached --no-ext-diff --binary" -Command {
        & git diff --cached --no-ext-diff --binary
    }

    Write-Section -Writer $writer -Title "DIFF STAT"
    Write-CommandOutput -Writer $writer -CommandText "git diff --stat" -Command {
        & git diff --stat
    }
    Write-CommandOutput -Writer $writer -CommandText "git diff --cached --stat" -Command {
        & git diff --cached --stat
    }

    Write-Section -Writer $writer -Title "FULL CONTENTS OF CHANGED / ADDED / UNTRACKED FILES"

    if ($changed.Count -eq 0) {
        $writer.WriteLine("(working tree is clean)")
    }
    else {
        foreach ($entry in $changed) {
            $writer.WriteLine("")
            $writer.WriteLine(("-" * 100))
            $writer.WriteLine("STATUS: $($entry.XY)")
            if ($entry.OldPath) {
                $writer.WriteLine("OLD PATH: $($entry.OldPath)")
            }
            $writer.WriteLine("PATH: $($entry.Path)")
            $writer.WriteLine(("-" * 100))
            $writer.WriteLine("")

            $currentFullPath = Join-Path $repoRoot $entry.Path
            $currentExists = Test-Path -LiteralPath $currentFullPath -PathType Leaf

            if ($currentExists) {
                $writer.WriteLine("[CURRENT WORKING TREE CONTENT]")
                $writer.WriteLine("")
                [void](Write-CurrentFile -Writer $writer -RelativePath $entry.Path)
            }
            elseif ($entry.WorkTreeStatus -eq "D" -and $entry.IndexStatus -ne "D" -and $entry.IndexStatus -ne " ") {
                # Example: AD means a brand-new file is staged, then removed/moved in the
                # working tree before commit. It has no HEAD version, but it does have an
                # index version. Show that instead of incorrectly asking HEAD for it.
                $writer.WriteLine("[STAGED INDEX CONTENT - WORKING TREE FILE IS DELETED]")
                $writer.WriteLine("")
                [void](Write-IndexFile -Writer $writer -RelativePath $entry.Path)
            }
            elseif ($entry.IndexStatus -eq "D" -or $entry.WorkTreeStatus -eq "D") {
                $writer.WriteLine("[LAST COMMITTED CONTENT FROM HEAD]")
                $writer.WriteLine("")
                $headPath = if ($entry.OldPath) { $entry.OldPath } else { $entry.Path }
                [void](Write-HeadFile -Writer $writer -RelativePath $headPath)
            }
            else {
                $writer.WriteLine("(file does not exist in working tree, index, or an applicable HEAD path)")
            }

            $writer.WriteLine("")
        }
    }
}
finally {
    $writer.Dispose()
}

Write-Host ""
Write-Host "Report created:"
Write-Host $OutputFile

exit 0
