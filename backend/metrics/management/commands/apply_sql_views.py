from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from pathlib import Path


class Command(BaseCommand):
    help = 'Apply SQL files under src/sql (views, procedures, triggers) that are not covered by migrations.'

    def handle(self, *args, **options):
        # Try multiple likely locations for the repo `src/sql` directory inside container
        candidates = [
            settings.BASE_DIR / 'src' / 'sql',           # e.g., /app/src/sql
            settings.BASE_DIR.parent / 'src' / 'sql',    # e.g., /src/sql (legacy)
            Path('/src') / 'sql',                        # explicit absolute fallback
        ]

        sql_dir = None
        for c in candidates:
            if c.exists():
                sql_dir = c
                break

        if sql_dir is None:
            self.stdout.write(self.style.WARNING('SQL folder not found in any candidate locations. Checked: ' + ', '.join(str(p) for p in candidates)))
            return

        target = sql_dir / '04_views_metrics.sql'
        if not target.exists():
            self.stdout.write(self.style.WARNING(f'SQL file not found: {target}'))
            return

        self.stdout.write(self.style.NOTICE(f'Applying SQL from: {target}'))
        sql_text = target.read_text()
        statements = [s.strip() for s in sql_text.split(';') if s.strip()]
        with connection.cursor() as cursor:
            for stmt in statements:
                try:
                    cursor.execute(stmt)
                except Exception as e:
                    self.stdout.write(self.style.WARNING(f'Failed to execute statement: {e}'))
        self.stdout.write(self.style.SUCCESS('Applied SQL views from 04_views_metrics.sql'))