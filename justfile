default:
    @just --list

# Run tests/ and evaluate every example; fails on any warning, error or failed assert
test:
    #!/usr/bin/env bash
    set -uo pipefail
    failed=0
    for f in tests/*.scad examples/*/*.scad; do
        # OpenSCAD exits 0 on a failed assert when exporting, so the output is read too.
        if out=$(openscad --hardwarnings --export-format echo -o - "$f" 2>&1) && ! grep -qE '^(WARNING|ERROR)' <<<"$out"; then
            echo "ok   $f"
        else
            echo "FAIL $f"
            grep -E '^(WARNING|ERROR|TRACE)' <<<"$out" | sed 's/^/     /'
            failed=1
        fi
    done
    exit $failed

# Everything CI runs, bar the tests
check: fmt-check

# Format the .scad sources with topiary (.topiary/languages.ncl)
fmt:
    git ls-files -z '*.scad' | xargs -0 -r topiary format

# Check the .scad sources are formatted, without changing them
fmt-check:
    git ls-files -z '*.scad' | xargs -0 -r -n1 topiary format --check

# Render the logo and the example pictures into docs/assets/
images:
    openscad logo/logo.scad -o docs/assets/logo.png --imgsize=1500,500 --camera=0,0,0,0,0,0,240 --projection=o --colorscheme=Tomorrow
    for f in examples/*/*_tess_example.scad; do \
        openscad "$f" -o "docs/assets/examples/$(basename "$f" _tess_example.scad).png" --imgsize=800,600 --camera=0,0,0,0,0,0,0 --viewall --autocenter --projection=o --colorscheme=Cornfield; \
    done
