param(
    [string]$ChangesPath = ".\MOD_CHANGES.md",
    [string]$ChangelogPath = ".\MOD_CHANGELOG.md",
    [string]$Label = "Unreleased",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Get-MarkdownSection {
    param(
        [string]$Text,
        [string]$Heading
    )

    $EscapedHeading = [regex]::Escape($Heading)
    $Pattern = "(?ms)^##\s+$EscapedHeading\s*\r?\n\r?\n(.*?)(?=^##\s+|\z)"
    $Match = [regex]::Match($Text, $Pattern)

    if (-not $Match.Success) {
        return $null
    }

    return $Match.Groups[1].Value.Trim()
}

function Get-ChangeCount {
    param([string]$Section)

    if ([string]::IsNullOrWhiteSpace($Section)) {
        return 0
    }

    return @(
        $Section -split "`r?`n" |
            Where-Object {
                $_ -match '^\s*-\s+' -and
                $_ -notmatch '^\s*-\s+None\s*$'
            }
    ).Count
}

function Get-GitHeadFile {
    param([string]$Path)

    $GitPath = $Path -replace '^[.][\\/]', ''
    $GitPath = $GitPath -replace '\\', '/'

    try {
        $GitRoot = (& git rev-parse --show-toplevel 2>$null)

        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($GitRoot)) {
            return $null
        }

        $HeadText = (& git show "HEAD:$GitPath" 2>$null)

        if ($LASTEXITCODE -eq 0) {
            return ($HeadText -join "`n")
        }
    }
    catch {
        # Git history checking is a safety feature, not a hard dependency.
    }

    return $null
}

function Test-LabelExists {
    param(
        [string]$Text,
        [string]$Label
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $false
    }

    $EscapedLabel = [regex]::Escape($Label)
    return [regex]::IsMatch(
        $Text,
        "(?m)^##\s+$EscapedLabel(?:\s+-\s+.*)?\s*$"
    )
}

function Set-ChangelogSection {
    param(
        [string]$ExistingText,
        [string]$Label,
        [string]$NewSection
    )

    $Header = @'
# Mod Changelog

Permanent history of direct mod-set changes for Antarchy - Ascension.

'@

    if ([string]::IsNullOrWhiteSpace($ExistingText)) {
        return ($Header.TrimEnd() + "`r`n`r`n" + $NewSection.Trim() + "`r`n")
    }

    $Text = $ExistingText.TrimEnd()
    $EscapedLabel = [regex]::Escape($Label)

    $SectionPattern = "(?ms)^##\s+$EscapedLabel(?:\s+-\s+.*?)?\r?\n.*?(?=^##\s+|\z)"
    $ExistingMatch = [regex]::Match($Text, $SectionPattern)

    if ($ExistingMatch.Success) {
        $Before = $Text.Substring(0, $ExistingMatch.Index).TrimEnd()
        $AfterIndex = $ExistingMatch.Index + $ExistingMatch.Length
        $After = $Text.Substring($AfterIndex).TrimStart()

        $Pieces = [System.Collections.Generic.List[string]]::new()

        if (-not [string]::IsNullOrWhiteSpace($Before)) {
            [void]$Pieces.Add($Before)
        }

        [void]$Pieces.Add($NewSection.Trim())

        if (-not [string]::IsNullOrWhiteSpace($After)) {
            [void]$Pieces.Add($After)
        }

        return (($Pieces -join "`r`n`r`n").TrimEnd() + "`r`n")
    }

    # New labels are inserted before the first existing version section.
    $FirstSection = [regex]::Match($Text, '(?m)^##\s+')

    if ($FirstSection.Success) {
        $Preamble = $Text.Substring(0, $FirstSection.Index).TrimEnd()
        $Rest = $Text.Substring($FirstSection.Index).TrimStart()

        return (
            $Preamble +
            "`r`n`r`n" +
            $NewSection.Trim() +
            "`r`n`r`n" +
            $Rest.TrimEnd() +
            "`r`n"
        )
    }

    return ($Text + "`r`n`r`n" + $NewSection.Trim() + "`r`n")
}

if (-not (Test-Path -LiteralPath $ChangesPath)) {
    throw "Local change report not found: $ChangesPath`nRun Update-ModManifest.bat first."
}

if ([string]::IsNullOrWhiteSpace($Label)) {
    $Label = "Unreleased"
}

$Label = $Label.Trim()

if ($Label -match '[\r\n]') {
    throw "The changelog label may not contain newlines."
}

$ChangesText = Get-Content -LiteralPath $ChangesPath -Raw

$ActiveMatch = [regex]::Match(
    $ChangesText,
    '(?m)^Active mod JARs:\s*(\d+)\s*$'
)

if (-not $ActiveMatch.Success) {
    throw "Could not read the active mod count from $ChangesPath."
}

$ActiveCount = [int]$ActiveMatch.Groups[1].Value

$Added = Get-MarkdownSection -Text $ChangesText -Heading "Added"
$Removed = Get-MarkdownSection -Text $ChangesText -Heading "Removed"
$Updated = Get-MarkdownSection -Text $ChangesText -Heading "Updated"

if ($null -eq $Added -or $null -eq $Removed -or $null -eq $Updated) {
    throw "Could not parse Added/Removed/Updated sections from $ChangesPath."
}

$AddedCount = Get-ChangeCount $Added
$RemovedCount = Get-ChangeCount $Removed
$UpdatedCount = Get-ChangeCount $Updated
$TotalChanges = $AddedCount + $RemovedCount + $UpdatedCount

if ($TotalChanges -eq 0) {
    Write-Host "`nNo mod changes exist relative to Git HEAD." -ForegroundColor Yellow
    Write-Host "Nothing was written to $ChangelogPath." -ForegroundColor Yellow
    exit 0
}

# Protect already-committed release sections from accidental history rewrites.
# "Unreleased" is intentionally editable.
if ($Label -ne "Unreleased" -and -not $Force) {
    $HeadText = Get-GitHeadFile -Path $ChangelogPath

    if (Test-LabelExists -Text $HeadText -Label $Label) {
        throw @"
The label '$Label' already exists in the committed MOD_CHANGELOG.md.

Refusing to rewrite committed mod history.
Use a new release/version label, or run manually with -Force only if you intentionally want to rewrite history.
"@
    }
}

$Today = Get-Date -Format 'yyyy-MM-dd'

$Lines = [System.Collections.Generic.List[string]]::new()

[void]$Lines.Add("## $Label - $Today")
[void]$Lines.Add("")
[void]$Lines.Add("Active mod JARs: **$ActiveCount**")
[void]$Lines.Add("")
[void]$Lines.Add("### Added ($AddedCount)")
[void]$Lines.Add("")
[void]$Lines.Add($Added)
[void]$Lines.Add("")
[void]$Lines.Add("### Removed ($RemovedCount)")
[void]$Lines.Add("")
[void]$Lines.Add($Removed)
[void]$Lines.Add("")
[void]$Lines.Add("### Updated ($UpdatedCount)")
[void]$Lines.Add("")
[void]$Lines.Add($Updated)

$NewSection = $Lines -join "`r`n"

$ExistingText = ""

if (Test-Path -LiteralPath $ChangelogPath) {
    $ExistingText = Get-Content -LiteralPath $ChangelogPath -Raw
}

$FinalText = Set-ChangelogSection `
    -ExistingText $ExistingText `
    -Label $Label `
    -NewSection $NewSection

$FinalText | Set-Content -LiteralPath $ChangelogPath -Encoding UTF8

Write-Host "`n=== MOD CHANGELOG WRITTEN ===" -ForegroundColor Green
Write-Host "Label:       $Label" -ForegroundColor Cyan
Write-Host "Active JARs: $ActiveCount" -ForegroundColor Cyan
Write-Host "Added:       $AddedCount" -ForegroundColor Green
Write-Host "Removed:     $RemovedCount" -ForegroundColor Red
Write-Host "Updated:     $UpdatedCount" -ForegroundColor Yellow
Write-Host "Changelog:   $ChangelogPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Commit MOD_MANIFEST.csv and MOD_CHANGELOG.md together after review." -ForegroundColor White
