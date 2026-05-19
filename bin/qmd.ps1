#!/usr/bin/env pwsh
$basedir=Split-Path $MyInvocation.MyCommand.Definition -Parent
$pkgdir="$basedir\node_modules\@tobilu\qmd"

# Set quiet logging for MCP mode
if ($args[0] -eq "mcp") {
  if (-not $env:LLAMA_LOG_LEVEL) { $env:LLAMA_LOG_LEVEL = "error" }
  if (-not $env:GGML_LOG_LEVEL) { $env:GGML_LOG_LEVEL = "error" }
  if (-not $env:GGML_BACKEND_SILENT) { $env:GGML_BACKEND_SILENT = "1" }
}

# Detect runtime by checking lockfiles (prevents ABI mismatch with native modules)
if (Test-Path "$pkgdir\package-lock.json") {
  & node "$pkgdir\dist\cli\qmd.js" @args
} elseif ((Test-Path "$pkgdir\bun.lock") -or (Test-Path "$pkgdir\bun.lockb")) {
  & bun "$pkgdir\dist\cli\qmd.js" @args
} else {
  & node "$pkgdir\dist\cli\qmd.js" @args
}