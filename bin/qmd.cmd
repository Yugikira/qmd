@echo off
setlocal enabledelayedexpansion

:: Get the package directory (parent of bin folder)
set "SCRIPT_DIR=%~dp0"
set "PKG_DIR=%SCRIPT_DIR%.."

:: Set quiet logging for MCP mode to prevent native stdout noise
if "%1"=="mcp" (
  if not defined LLAMA_LOG_LEVEL set LLAMA_LOG_LEVEL=error
  if not defined GGML_LOG_LEVEL set GGML_LOG_LEVEL=error
  if not defined GGML_BACKEND_SILENT set GGML_BACKEND_SILENT=1
)

:: Detect which runtime installed the package by checking lockfiles
:: package-lock.json means npm/Node, bun.lock/bun.lockb means Bun
:: This prevents ABI mismatches with native modules (better-sqlite3, sqlite-vec)
if exist "%PKG_DIR%\package-lock.json" (
  node "%PKG_DIR%\dist\cli\qmd.js" %*
) else (
  if exist "%PKG_DIR%\bun.lock" (
    bun "%PKG_DIR%\dist\cli\qmd.js" %*
  ) else (
    if exist "%PKG_DIR%\bun.lockb" (
      bun "%PKG_DIR%\dist\cli\qmd.js" %*
    ) else (
      node "%PKG_DIR%\dist\cli\qmd.js" %*
    )
  )
)