# Data Science & Analytics for Verse (DSAV)

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3370c076-22d0-433f-b223-2e8a52efa191" />

## About:

Project DSAV provides machine learning tools for [UEFN](https://en.wikipedia.org/wiki/Unreal_Editor_for_Fortnite)/[Unreal Engine](https://en.wikipedia.org/wiki/Unreal_Engine) game-developers to analyze data structures in [Verse](https://dev.epicgames.com/documentation/en-us/fortnite/verse-language-reference) (a new, integrated Python-like program) and apply machine-learning techniques in their game using descriptive statistics, visualization tools and simulated distributions. This gives developers endless possibilities to analyze player behavior and events within actual game sessions. This project also provides tools to collect and export data smoothly into other desired programming software.

## Tools and Purpose:

The DSAV module allows developers to:
 - Gather insights about player experience
 - Make data-driven decisions for user generated content
 - Stimulate player engagement
 - Maximize playtime and retention, resulting in more revenue for creators

This is version 1 of the code. In this version, developers can:
 - Collect descriptive statistics of data structures, being:
     - Mean
     - Variance & standard deviation (sample & population)
     - Covariance & covariance matrix
     - Correlation coefficient & coefficient of determination (R²)
 - Perform Ordinary Least Squares, to:
     - Perform Linear Regression
     - Retrieve coefficient estimates
     - Draw scatter plots in the output log window
     - Retrieve the:
          - Mean Squared Error
          - Root Mean Squared Error
          - Mean Absolute Error
          - Normalized Mean Squared Error
 - Draw samples from simulated distributions, being the:
     - Normal (Gaussian) distribution, approximated using the Box-Muller algorithm
     - Lognormal distribution

## How To Use:

 A step-by-step guide on the usage of this module is as follows:
  1) Open a UEFN project
  2) Create a new Verse file and name it "matrices.verse"
  3) Paste the code from the following snippet into the file: https://dev.epicgames.com/community/snippets/bO9r/fortnite-matrices
  4) Add the file [dsav.verse](dsav.verse) in the Verse directory
  5) Navigate back to the UEFN project window and press "Build Verse Code" under the Verse tab at the top.

## Inquiries:

Please feel free to reach out to me on [LinkedIn](https://www.linkedin.com/in/kian-sadeghzadeh/) for:
- Questions
- Feedback
- Ideas to collaborate
- Awesome work you've done using this project
