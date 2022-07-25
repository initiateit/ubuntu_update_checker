# ubuntu_update_checker
A simple Bash script to check for Ubuntu updates and email them to you.

I like to use this in combination with Ubuntu's [Unattended Upgrades](https://help.ubuntu.com/community/AutomaticSecurityUpdates) so that security updates are installed automatically and I schedule this script with a cron job every 6 hours. This gives me a chance to at least read up on application updates to see if something is going to break.

### Requirements

You will need sendmail or postfix installed.


### Output will look like:

![message preview](/msg.png)

Just be sure to make the script executable ie ```chmod +x update_checker.sh``` edit the **from_addr** and **to_addr** constants.
