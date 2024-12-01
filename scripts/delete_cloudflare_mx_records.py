import re

records_file = "../terraform/records.tf"
import_file = "../terraform/import.sh"

mx_pattern = re.compile(r'route\d+\.mx\.cloudflare\.net')

with open(records_file, "r") as f:
    records = f.read()

updated_records = []
excluded_ids = []
blocks = records.strip().split("\n\n")
for block in blocks:
    if "resource \"cloudflare_record\"" in block and mx_pattern.search(block):
        resource_id_match = re.search(r'resource\s+"cloudflare_record"\s+"([^"]+)"', block)
        if resource_id_match:
            excluded_ids.append(resource_id_match.group(1))
        continue
    updated_records.append(block)

with open(records_file, "w") as f:
    f.write("\n\n".join(updated_records) + "\n")

with open(import_file, "r") as f:
    import_content = f.readlines()

updated_imports = []
for line in import_content:
    import_id_match = re.search(r'cloudflare_record\.([^\s]+)', line)
    if import_id_match and import_id_match.group(1) in excluded_ids:
        continue
    updated_imports.append(line)

with open(import_file, "w") as f:
    f.writelines(updated_imports)
