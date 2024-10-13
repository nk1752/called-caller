#!/bin/bash

# Get the current date in utc seconds
current_date=$(date +%s)

# Get the expiry date
expiry_date=$(date -d "$1" +%s)

# Calculate the difference between the expiry date and the current date
diff=$((expiry_date - current_date))

# Calculate the number of days until the expiry date
days=$((diff / 86400))

# Return the number of days until the expiry date
echo "$days"

