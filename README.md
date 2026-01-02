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

This is version 2 of the code. In this version, developers can:

 - Collect various descriptive statistics of data structures
 - Perform Ordinary Least Squares and logistic regression
 - Retrieve coefficient estimates and significance
 - Draw scatter plots in the output log window
 - Retrieve the Mean Squared Error, and variations thereof
 - Clean data
 - Draw samples from simulated distributions, being the:
     - Normal (Gaussian) distribution, approximated using the Box-Muller algorithm
     - Lognormal distribution
 - Export collected data to CSV text format

## How To Use:

 A step-by-step guide on the usage of this module is as follows:
  1) Open a UEFN project
  2) Open the Verse tab
  3) Add the files [dsav.verse](dsav.verse) and [matrices.verse](matrices.verse) in the Verse directory
  4) Navigate back to the UEFN project window and press "Build Verse Code" under the Verse tab at the top
  5) Utilize the functions from dsav.verse to write your own data-manipulating code in any Verse file, finishing off by pressing "Build Verse Code". If you use @editable devices for this, drag the Verse device into your workspace and link these devices.

## Inquiries:

Please feel free to reach out to me on [LinkedIn](https://www.linkedin.com/in/kian-sadeghzadeh/) for:
- Questions
- Feedback
- Ideas to collaborate
- Awesome work you've done using this project
