## Plans

- testing out how quarto works.
- will try setting up github actions to perform CI/CD (API call every hour?)
- will try to use quarto to generate a report for the AQI data set.
- At the moment, there is 6 years of data (2017-2022) from 40 sensors.
[source](https://app.cpcbccr.com/ccr/#/caaqm-dashboard-all/caaqm-landing/caaqm-data-repository)

## SETUP
- used the keyring package to store the API key. [More details here] (https://keyring.r-lib.org/#github).
- saved the API key as a repository secret. Used this as [source](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository).
- Performed a local run with the `R/call-api.R` script. This was to test the API call and the keyring package.
- will test it on github actions next.
- if that works, then I will setup the cron job to run every hour.
