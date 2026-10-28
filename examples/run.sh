#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_page_scan info
PYTHONPATH=src python -m gbt_page_scan check --payload '{}'
PYTHONPATH=src python -m gbt_page_scan run   --payload '{}'
