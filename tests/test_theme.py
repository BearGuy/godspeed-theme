import json
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def contrast(foreground, background):
    def luminance(color):
        values = [int(color[i:i + 2], 16) / 255 for i in (1, 3, 5)]
        values = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in values]
        return sum(a * b for a, b in zip(values, (0.2126, 0.7152, 0.0722)))
    a, b = sorted((luminance(foreground), luminance(background)))
    return (b + 0.05) / (a + 0.05)


class ThemeTest(unittest.TestCase):
    def test_generated_files_are_current(self):
        subprocess.run(['python3', str(ROOT / 'scripts/generate.py'), '--check'], check=True)

    def test_palette_contrast_and_ansi(self):
        for variant in ('thunderbolt', 'whirlwind'):
            p = json.loads((ROOT / 'palettes' / f'{variant}.json').read_text())
            self.assertEqual(len(p['ansi']), 16)
            for key in ('foreground', 'muted', 'comment', 'cyan', 'violet', 'ice', 'green', 'amber', 'red'):
                with self.subTest(variant=variant, color=key):
                    self.assertGreaterEqual(contrast(p[key], p['background']), 4.5)
            self.assertGreaterEqual(contrast(p['foreground'], p['selection']), 4.5)
            self.assertGreaterEqual(contrast(p['foreground'], p['surface']), 4.5)

    def test_pi_roles_resolve_to_palette(self):
        for variant in ('thunderbolt', 'whirlwind'):
            theme = json.loads((ROOT / 'themes' / f'godspeed-{variant}.json').read_text())
            self.assertEqual(theme['name'], f'godspeed-{variant}')
            for role, value in {**theme['colors'], **theme['export']}.items():
                with self.subTest(variant=variant, role=role):
                    self.assertIn(value, theme['vars'])


if __name__ == '__main__':
    unittest.main()
