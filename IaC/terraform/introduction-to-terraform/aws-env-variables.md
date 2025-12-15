# Environment Variables

1. I was still on the environment variables tab in my settings, so I went straight to 'new' (user variables, rather than system variables).
2. I copied and pasted the env variable name for the access key id from the task to ensure I had the correct spelling.
3. I then copied and pasted my actual access key id into the value section, again to eliminate errors.
4. I then repeated this for a new variable - to create the secret access key.
5. To test that this had worked, I opened a new Bash window and typed printenv.
6. In the list, I could easily spot the secret access key and its value, but not the access key id
7. So, I typed in 'printenv AWS_ACCESS_KEY_ID' and it returned the value of that variable, so I now know I have both environment variables.