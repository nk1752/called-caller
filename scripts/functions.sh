daysToExpiry() {
    # Get the current date in utc seconds
  current_date=$(date +%s)

  # Get the expiry date
  expiry_date=$(date -d "$1" +%s)

  # Calculate the difference between the expiry date and the current date
  diff=$((expiry_date - current_date))

  # Calculate the number of days until the expiry date
  days-to-expiry=$((diff / 86400))
  
  return $days-to-expiry
}