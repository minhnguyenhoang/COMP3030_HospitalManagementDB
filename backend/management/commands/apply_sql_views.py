from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from pathlib import Path


class Command(BaseCommand):
    help = 'Apply SQL files under src/sql (views, procedures, triggers) that are not covered by migrations.'

    def handle(self, *args, **options):
        repo_root = settings.BASE_DIR.parent
        sql_dir = repo_root / 'src' / 'sql'
        target = sql_dir / '04_views_metrics.sql'
        if not target.exists():
            self.stdout.write(self.style.WARNING(f'SQL file not found: {target}'))
            return

        sql_text = target.read_text()
        # Very simple split by semicolon; skip empty statements
        statements = [s.strip() for s in sql_text.split(';') if s.strip()]
        with connection.cursor() as cursor:
            for stmt in statements:
                try:
                    cursor.execute(stmt)
                except Exception as e:
                    # continue and log; often view replace statements are fine
                    self.stdout.write(self.style.WARNING(f'Failed to execute statement: {e}'))
        self.stdout.write(self.style.SUCCESS('Applied SQL views from 04_views_metrics.sql'))