mouse_hunter
============
Final Project for iXperience

To get this project up and running, you need to subscribe for three API keys, and add them as environment variables.

1.) Sunlight Foundation: http://sunlightfoundation.com/api/accounts/register/

2.) Open Secrets: https://www.opensecrets.org/api/admin/index.php?function=signup

3.) New York Times (get a key for the congress api) : https://myaccount.nytimes.com/auth/login?URI=http:/developer.nytimes.com/login/external

Once you have the keys, add the following environment variables to your .bashrc (for linux) or your .bash_profile (for mac) file, in your home directory:
(obviously, with the keys in the quotes...and no space on either side of the equals sign!)

export SUNLIGHT_API=''

export NYT_API=''

export OPENSECRETS_API=''

