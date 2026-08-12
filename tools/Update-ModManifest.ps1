param(
    [string]$ModsPath = ".\mods",
    [string]$ManifestPath = ".\MOD_MANIFEST.csv",
    [string]$ChangesPath = ".\MOD_CHANGES.md"
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-ManifestAttribute {
    param(
        [string]$ManifestText,
        [string]$Name
    )

    $Match = [regex]::Match(
        $ManifestText,
        "(?mi)^$([regex]::Escape($Name)):\s*(.+)$"
    )

    if ($Match.Success) {
        return $Match.Groups[1].Value.Trim()
    }

    return $null
}

function Get-TomlValue {
    param(
        [string]$Block,
        [string]$Key
    )

    $Match = [regex]::Match(
        $Block,
        "(?mi)^\s*$([regex]::Escape($Key))\s*=\s*[""']([^""']+)[""']"
    )

    if ($Match.Success) {
        return $Match.Groups[1].Value.Trim()
    }

    return $null
}

function Get-ModInfo {
    param(
        [System.IO.FileInfo]$File
    )

    $Zip = $null

    try {
        $Zip = [System.IO.Compression.ZipFile]::OpenRead($File.FullName)

        # --------------------------------------------------------
        # Read Forge / NeoForge mod metadata
        # --------------------------------------------------------

        $TomlEntry = $Zip.Entries |
            Where-Object {
                $_.FullName -eq "META-INF/mods.toml" -or
                $_.FullName -eq "META-INF/neoforge.mods.toml"
            } |
            Select-Object -First 1

        $TomlText = $null
        $MetadataPath = $null

        if ($TomlEntry) {
            $MetadataPath = $TomlEntry.FullName

            $Reader = New-Object System.IO.StreamReader($TomlEntry.Open())
            $TomlText = $Reader.ReadToEnd()
            $Reader.Close()
        }

        # --------------------------------------------------------
        # Read JAR manifest
        # --------------------------------------------------------

        $JarManifestEntry = $Zip.Entries |
            Where-Object { $_.FullName -eq "META-INF/MANIFEST.MF" } |
            Select-Object -First 1

        $JarManifestText = $null

        if ($JarManifestEntry) {
            $Reader = New-Object System.IO.StreamReader($JarManifestEntry.Open())
            $JarManifestText = $Reader.ReadToEnd()
            $Reader.Close()
        }

        # --------------------------------------------------------
        # Parse first [[mods]] block as the primary mod
        # --------------------------------------------------------

        $PrimaryModId = $null
        $DisplayName = $null
        $Version = $null

        if ($TomlText) {
            $Blocks = [regex]::Matches(
                $TomlText,
                '(?ms)^\s*\[\[mods\]\]\s*(.*?)(?=^\s*\[\[|\z)'
            )

            if ($Blocks.Count -gt 0) {
                $PrimaryBlock = $Blocks[0].Groups[1].Value

                $PrimaryModId = Get-TomlValue $PrimaryBlock "modId"
                $DisplayName  = Get-TomlValue $PrimaryBlock "displayName"
                $Version      = Get-TomlValue $PrimaryBlock "version"
            }
        }

        # --------------------------------------------------------
        # Resolve ${file.jarVersion}
        # --------------------------------------------------------

        if (
            [string]::IsNullOrWhiteSpace($Version) -or
            $Version -match '\$\{file\.jarVersion\}'
        ) {
            if ($JarManifestText) {
                $Version = Get-ManifestAttribute `
                    $JarManifestText `
                    "Implementation-Version"
            }
        }

        # Some mods use Specification-Version instead.
        if ([string]::IsNullOrWhiteSpace($Version)) {
            if ($JarManifestText) {
                $Version = Get-ManifestAttribute `
                    $JarManifestText `
                    "Specification-Version"
            }
        }

        # --------------------------------------------------------
        # Special handling for library-style JARs
        # --------------------------------------------------------

        if ($File.Name -match '^kotlinforforge-(?<version>\d+(?:\.\d+)+)-all\.jar$') {
            $PrimaryModId = "kotlinforforge"
            $DisplayName = "Kotlin for Forge"
            $Version = $Matches["version"]

            if ("kotlinforforge" -notin $AllModIds) {
                $AllModIds += "kotlinforforge"
            }
        }

        # --------------------------------------------------------
        # Safe fallbacks
        # --------------------------------------------------------

        if ([string]::IsNullOrWhiteSpace($PrimaryModId)) {
            $PrimaryModId = [System.IO.Path]::GetFileNameWithoutExtension(
                $File.Name
            )
        }

        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $PrimaryModId
        }

        if ([string]::IsNullOrWhiteSpace($Version)) {
            $Version = "UNKNOWN"
        }

        # --------------------------------------------------------
        # Collect every modId declared by the JAR
        # --------------------------------------------------------

        $AllModIds = @()

        if ($TomlText) {
            foreach ($BlockMatch in $Blocks) {
                $ModBlock = $BlockMatch.Groups[1].Value
                $BlockModId = Get-TomlValue $ModBlock "modId"

                if (
                    $BlockModId -and
                    $BlockModId -notin $AllModIds
                ) {
                    $AllModIds += $BlockModId
                }
            }
        }

        # --------------------------------------------------------
        # Hash identifies same-version replacement builds too
        # --------------------------------------------------------

        $Hash = (
            Get-FileHash `
                -LiteralPath $File.FullName `
                -Algorithm SHA256
        ).Hash

        return [PSCustomObject]@{
            ModId        = $PrimaryModId
            Name         = $DisplayName
            Version      = $Version
            Jar          = $File.Name
            AllModIds    = ($AllModIds -join ";")
            SHA256       = $Hash
            MetadataPath = $MetadataPath
        }
    }
    catch {
        Write-Warning "Could not fully inspect $($File.Name): $($_.Exception.Message)"

        $Hash = (
            Get-FileHash `
                -LiteralPath $File.FullName `
                -Algorithm SHA256
        ).Hash

        return [PSCustomObject]@{
            ModId        = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
            Name         = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
            Version      = "UNKNOWN"
            Jar          = $File.Name
            AllModIds    = ""
            SHA256       = $Hash
            MetadataPath = ""
        }
    }
    finally {
        if ($Zip) {
            $Zip.Dispose()
        }
    }
}

# ============================================================
# VALIDATE INSTANCE
# ============================================================

if (-not (Test-Path -LiteralPath $ModsPath)) {
    throw "Mods directory not found: $ModsPath"
}

Write-Host "`n=== BUILDING CURRENT MOD MANIFEST ===" -ForegroundColor Cyan

$Current = Get-ChildItem `
    -LiteralPath $ModsPath `
    -File `
    -Filter "*.jar" |
    Where-Object {
        $_.Name -notmatch '\.disabled$'
    } |
    ForEach-Object {
        Get-ModInfo $_
    } |
    Sort-Object ModId, Name

Write-Host "Active mod JARs found: $($Current.Count)"

# ============================================================
# LOAD LAST COMMITTED MANIFEST
# ============================================================

$Previous = @()

$GitAvailable = $false

try {
    git rev-parse --is-inside-work-tree 2>$null | Out-Null

    if ($LASTEXITCODE -eq 0) {
        $GitAvailable = $true
    }
}
catch {}

if ($GitAvailable) {
    $GitManifestPath = $ManifestPath.Replace(".\", "").Replace("\", "/")

    # A missing manifest in HEAD is normal on the first run.
    # Temporarily suppress native Git stderr so PowerShell does not
    # abort under $ErrorActionPreference = "Stop".
    $SavedErrorActionPreference = $ErrorActionPreference

    try {
        $ErrorActionPreference = "SilentlyContinue"
        $OldText = @(& git show "HEAD:$GitManifestPath" 2>$null)
        $GitShowExitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $SavedErrorActionPreference
    }

    if ($GitShowExitCode -eq 0 -and $OldText.Count -gt 0) {
        $TempOld = Join-Path $env:TEMP "antarchy_previous_mod_manifest.csv"

        $OldText | Set-Content `
            -LiteralPath $TempOld `
            -Encoding UTF8

        $Previous = @(
            Import-Csv -LiteralPath $TempOld
        )

        Remove-Item $TempOld -Force -ErrorAction SilentlyContinue
    }
}

# If there is no committed manifest yet, this is the baseline.
$FirstRun = ($Previous.Count -eq 0)

# ============================================================
# COMPARE
# ============================================================

$Added = @()
$Removed = @()
$Updated = @()

if (-not $FirstRun) {

    $PreviousById = @{}
    $CurrentById = @{}

    foreach ($Mod in $Previous) {
        $PreviousById[$Mod.ModId] = $Mod
    }

    foreach ($Mod in $Current) {
        $CurrentById[$Mod.ModId] = $Mod
    }

    foreach ($ModId in $CurrentById.Keys) {
        if (-not $PreviousById.ContainsKey($ModId)) {
            $Added += $CurrentById[$ModId]
            continue
        }

        $Old = $PreviousById[$ModId]
        $New = $CurrentById[$ModId]

        if (
            $Old.Version -ne $New.Version -or
            $Old.Jar -ne $New.Jar -or
            $Old.SHA256 -ne $New.SHA256
        ) {
            $Updated += [PSCustomObject]@{
                ModId      = $ModId
                Name       = $New.Name
                OldVersion = $Old.Version
                NewVersion = $New.Version
                OldJar     = $Old.Jar
                NewJar     = $New.Jar
            }
        }
    }

    foreach ($ModId in $PreviousById.Keys) {
        if (-not $CurrentById.ContainsKey($ModId)) {
            $Removed += $PreviousById[$ModId]
        }
    }
}

# ============================================================
# WRITE CURRENT MANIFEST
# ============================================================

$Current |
    Export-Csv `
        -LiteralPath $ManifestPath `
        -NoTypeInformation `
        -Encoding UTF8

# ============================================================
# BUILD MARKDOWN CHANGE REPORT
# ============================================================

$Lines = New-Object System.Collections.Generic.List[string]

$Lines.Add("# Mod Changes")
$Lines.Add("")
$Lines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$Lines.Add("")
$Lines.Add("Active mod JARs: $($Current.Count)")
$Lines.Add("")

if ($FirstRun) {
    $Lines.Add("This is the initial mod manifest baseline.")
}
else {

    $Lines.Add("## Added")
    $Lines.Add("")

    if ($Added.Count -eq 0) {
        $Lines.Add("- None")
    }
    else {
        foreach ($Mod in ($Added | Sort-Object Name)) {
            $Lines.Add("- $($Mod.Name) $($Mod.Version) [$($Mod.ModId)]")
        }
    }

    $Lines.Add("")
    $Lines.Add("## Removed")
    $Lines.Add("")

    if ($Removed.Count -eq 0) {
        $Lines.Add("- None")
    }
    else {
        foreach ($Mod in ($Removed | Sort-Object Name)) {
            $Lines.Add("- $($Mod.Name) $($Mod.Version) [$($Mod.ModId)]")
        }
    }

    $Lines.Add("")
    $Lines.Add("## Updated")
    $Lines.Add("")

    if ($Updated.Count -eq 0) {
        $Lines.Add("- None")
    }
    else {
        foreach ($Mod in ($Updated | Sort-Object Name)) {
            $Lines.Add(
                "- $($Mod.Name): $($Mod.OldVersion) -> $($Mod.NewVersion) [$($Mod.ModId)]"
            )
        }
    }
}

$Lines |
    Set-Content `
        -LiteralPath $ChangesPath `
        -Encoding UTF8

# ============================================================
# CONSOLE REPORT
# ============================================================

Write-Host "`n=== MOD CHANGE REPORT ===" -ForegroundColor Cyan

if ($FirstRun) {
    Write-Host "Initial baseline created." -ForegroundColor Yellow
}
else {

    Write-Host "`nADDED: $($Added.Count)" -ForegroundColor Green
    foreach ($Mod in ($Added | Sort-Object Name)) {
        Write-Host "  + $($Mod.Name) $($Mod.Version)"
    }

    Write-Host "`nREMOVED: $($Removed.Count)" -ForegroundColor Red
    foreach ($Mod in ($Removed | Sort-Object Name)) {
        Write-Host "  - $($Mod.Name) $($Mod.Version)"
    }

    Write-Host "`nUPDATED: $($Updated.Count)" -ForegroundColor Yellow
    foreach ($Mod in ($Updated | Sort-Object Name)) {
        Write-Host "  ~ $($Mod.Name): $($Mod.OldVersion) -> $($Mod.NewVersion)"
    }
}

Write-Host "`nManifest: $ManifestPath" -ForegroundColor Cyan
Write-Host "Report:   $ChangesPath" -ForegroundColor Cyan
