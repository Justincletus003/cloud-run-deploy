import os
import subprocess
import sys

dbPass = os.environ.get("DATABASE_PASS")
print(dbPass)
# os.environ['DB_PASS'] = "dbPass"