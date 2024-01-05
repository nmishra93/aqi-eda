## Plans

-   testing out how quarto works.
-   will try setting up github actions to perform CI/CD (API call every hour?)
-   will try to use quarto to generate a report for the AQI data set.
-   At the moment, there is 6 years of data (2017-2022) from 40 sensors. [source](https://app.cpcbccr.com/ccr/#/caaqm-dashboard-all/caaqm-landing/caaqm-data-repository)

## SETUP

-   used the keyring package to store the API key. [More details here](https://keyring.r-lib.org/#github).
-   saved the API key as a repository secret. Used this as [source](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository).
-   Performed a local run with the `R/call-api.R` script. This was to test the API call and the keyring package.
-   will test it on github actions next.
-   if that works, then I will setup the cron job to run every hour.
-   The local csv was `data/data_gov_realtime_aqi_api_20240104_182755.csv`.

The first pass didn't work. yml file is sorted, the `keyring` approach isn't working.

-   `keyring` didn't work.

-   setting up `actions` secrets and `environment` secrets didn't work.

-   setting up environment variables worked.

-   now running into git commit message error, most likely a syntax error.

-   a stupid "-" after the final `"` mark in the last line was the reason it was failing. Figured that out from [here](https://github.com/beatrizmilz/awesome-gha/blob/main/.github/workflows/01-monitoring-quarto-repos.yaml).

API calls started working but no files were being written to the repository.

-   next, ran into an error where githubaction bot wasn't able to push changes. error message was: `Permission denied to github-actions[bot]`

-   stackoverflow saved the day. [link](https://stackoverflow.com/questions/72851548/permission-denied-to-github-actionsbot)

-   needed to give github action bot permission to read and write (it's read only by default) to the repository.

Yay! It worked. This was a good learning experience but it was so frustrating at times. Still need to figure out how to use secrets rather than variables to do this CI/CD workflow.


## Second pass
Added cron scheduler. Use this to figure out `cron` strings: [link](https://crontab.guru/).
Will try to run it every hour for few days to see what happens.
Tip. `*` is a special character in YAML so you have to quote the cron string for it to work.
