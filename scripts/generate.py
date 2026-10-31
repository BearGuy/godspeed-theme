#!/usr/bin/env python3
"""Generate app-specific themes from the Godspeed palettes (stdlib only)."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def render(variant):
    p = json.loads((ROOT / 'palettes' / f'{variant}.json').read_text())
    roles = {
        'accent': 'cyan', 'border': 'border', 'borderAccent': 'violet', 'borderMuted': 'border',
        'success': 'green', 'error': 'red', 'warning': 'amber', 'muted': 'muted', 'dim': 'comment',
        'text': 'foreground', 'thinkingText': 'muted', 'selectedBg': 'selection',
        'scrollbarTrack': 'surface_alt', 'scrollbarThumb': 'muted',
        'searchMatchBg': 'selection', 'searchMatchText': 'foreground',
        'userMessageBg': 'surface_alt', 'userMessageText': 'foreground',
        'customMessageBg': 'surface', 'customMessageText': 'foreground', 'customMessageLabel': 'violet',
        'toolPendingBg': 'surface', 'toolSuccessBg': 'surface', 'toolErrorBg': 'surface',
        'toolTitle': 'cyan', 'toolOutput': 'muted',
        'mdHeading': 'violet', 'mdLink': 'cyan', 'mdLinkUrl': 'muted', 'mdCode': 'green',
        'mdCodeBlock': 'foreground', 'mdCodeBlockBorder': 'border', 'mdQuote': 'muted',
        'mdQuoteBorder': 'border', 'mdHr': 'border', 'mdListBullet': 'cyan',
        'toolDiffAdded': 'green', 'toolDiffRemoved': 'red', 'toolDiffContext': 'muted',
        'syntaxComment': 'comment', 'syntaxKeyword': 'violet', 'syntaxFunction': 'cyan',
        'syntaxVariable': 'foreground', 'syntaxString': 'green', 'syntaxNumber': 'amber',
        'syntaxType': 'ice', 'syntaxOperator': 'muted', 'syntaxPunctuation': 'muted',
        'thinkingOff': 'comment', 'thinkingMinimal': 'muted', 'thinkingLow': 'ice',
        'thinkingMedium': 'cyan', 'thinkingHigh': 'violet', 'thinkingXhigh': 'violet',
        'thinkingMax': 'red', 'bashMode': 'green',
    }
    theme = {
        '$schema': 'https://pi.dev/schemas/theme.schema.json',
        'name': f'godspeed-{variant}', 'appearance': p['appearance'],
        'vars': {k: v for k, v in p.items() if k not in ('ansi', 'appearance')},
        'colors': roles,
        'export': {'pageBg': 'background', 'cardBg': 'surface', 'infoBg': 'surface_alt'},
    }
    rex = {'foreground': p['foreground'], 'background': p['background'],
           'cursor': p['cyan'], 'scheme': p['appearance'],
           'palette': [f'{i}={value}' for i, value in enumerate(p['ansi'])]}
    ghostty = '\n'.join([f'background = {p["background"]}', f'foreground = {p["foreground"]}',
                         f'cursor-color = {p["cyan"]}', f'selection-background = {p["selection"]}',
                         f'selection-foreground = {p["foreground"]}'] +
                        [f'palette = {i}={color}' for i, color in enumerate(p['ansi'])]) + '\n'
    slack = ','.join(p[k] for k in ('surface', 'surface_alt', 'selection', 'foreground',
                                     'surface_alt', 'foreground', 'green', 'red')) + '\n'
    zsh = '\n'.join([f"GODSPEED_{k.upper()}='{p[k]}'" for k in
                     ('foreground', 'muted', 'cyan', 'violet', 'green', 'amber', 'red')]) + '\n'
    return {
        f'themes/godspeed-{variant}.json': json.dumps(theme, indent=2) + '\n',
        f'rex/{variant}.json': json.dumps(rex, indent=2) + '\n',
        f'terminal/{variant}.ghostty': ghostty,
        f'slack/{variant}.txt': slack,
        f'zsh/{variant}.zsh': zsh,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='fail if generated files are stale')
    args = parser.parse_args()
    changed = []
    for variant in ('thunderbolt', 'whirlwind'):
        for name, contents in render(variant).items():
            path = ROOT / name
            if not path.exists() or path.read_text() != contents:
                changed.append(name)
                if not args.check:
                    path.parent.mkdir(parents=True, exist_ok=True)
                    path.write_text(contents)
    if args.check and changed:
        parser.exit(1, 'Stale generated files: ' + ', '.join(changed) + '\n')
    print('Generated files are current.' if args.check else 'Generated Godspeed themes.')


if __name__ == '__main__':
    main()
