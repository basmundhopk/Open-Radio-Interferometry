# Contributing

Thanks for your interest in Open Radio Interferometry!

## Reporting issues

Please include, when relevant:

- OS, Python version, and how you installed the package
- FMCOMMS5 carrier board + ADI image version (if hardware-related)
- Full traceback or log output
- Minimal reproducer (for non-hardware bugs, an `examples/`-style FITS
  file is ideal)

## Development setup

```bash
git clone https://github.com/yourusername/Open-Radio-Interferometry.git
cd Open-Radio-Interferometry
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev,sdr]"
```

Run the tests:

```bash
pytest
```

Run the linter:

```bash
ruff check .
```

## Pull requests

- Keep changes focused/small in scope.
- Include a test when fixing a bug in any DSP / imaging code.
- Update `docs/` if you change architecture or public APIs.
