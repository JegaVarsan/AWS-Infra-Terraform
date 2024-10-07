

import json

# Path to your plan output JSON file
json_file_path = 'new.json'

# Load the JSON data
with open(json_file_path, 'r') as f:
    data = json.load(f)

# Extract the "resource_changes" section
resource_changes = data.get('resource_changes', [])

for change in resource_changes:
    resource_type = change.get('type')
    resource_name = change.get('name')
    actions = change.get('change', {}).get('actions', [])
    before = change.get('change', {}).get('before', {})
    after = change.get('change', {}).get('after', {})

    if(actions[0]=='no-op'):
        continue
    else:
        print(f"Resource Type: {resource_type}")
        print(f"Resource Name: {resource_name}")
        print(f"Actions: {actions}")
        print(f"Before: {before}")
        print(f"After: {after}")
        print("-" * 40)