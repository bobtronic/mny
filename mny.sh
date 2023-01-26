#!/bin/fish

#load secrets from config file - see config template for details
set USER_TOKEN (cat mny.config | jq -r '.authentication | .user_token')
set APP_TOKEN  (cat mny.config | jq -r '.authentication | .app_token')

#load authorized accounts from akahu
set ACCOUNT_MAP (curl -s --header "Authorization: Bearer "$USER_TOKEN"" --header "X-Akahu-ID: "$APP_TOKEN"" https://api.akahu.io/v1/accounts  | jq -r  '.items[] | [.name,._id] | join(",")' )

#prompt user for the account to use
set NAME (gum choose --no-limit $ACCOUNT_MAP)

#pick months of interest - limited to previous 12 months max
set CURRENT (date '+%B %Y')
set MONTHS $CURRENT
set ISO ""
for i in (seq 1 11)
        set -a MONTHS \n(date '+%B %Y' --date="-$i month")
end
echo "$MONTHS" | gum choose --no-limit --selected="$CURRENT" --height=12 | while read m
        set -a ISO \n(date --date="1 $m" --iso-8601=hours)
end

echo $ISO