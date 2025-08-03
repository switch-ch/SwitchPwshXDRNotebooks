# Switch CSOC PowerShell Notebooks

The purpose of this repository and its content is to help save time in a SOC by using automated investigation notebooks.

The goal is to minimize the complexity for the operators, so they can focus on investigation instead of how to use the notebooks.

At PSConfEU 2025 this repository has been used [for a presentation](https://github.com/psconfeu/2025/tree/main/DavidSass/soc-on-stage) which has also been recorded:

[![Watch the video](https://img.youtube.com/vi/cbUktoR8z8A/hqdefault.jpg)](https://www.youtube.com/embed/cbUktoR8z8A)

## Usage

The usage could be summarized into THREE main steps:

1. Environment configuration - which is used to making sure that there is no configuration drift from the known good state
2. Daily case management - basic enrichment and tagging of the incidents
3. Investigations - the actual act of the investigation using notebooks. (Coming soon)

### Environment configuration

For first time configuration and to update the 3rd party PowerShell modules the `environment-configurator.ipynb` notebook should be used from the `main` branch.

### Sign-in and tagging

The first use case is tagging the tickets with the user account types of `Student` or `Faculty`.

<TODO: Add the image of the notebook>

## Prerequisites

- PowerShell 7
- Visual Studio Code with the Jupyter extension installed
- .NET SDK
- Entra ID Enterprise Application with delegated permissions for Microsoft Graph API

## Main components

We have the following components stored in this repository:

- Investigation notebook templates
- `Switch.CSOC.PowerShell` module with internally developed functions and cmdlets.

The `Modules` folder also contains 3rd party prerequisite modules. These modules are NOT under source control.

## What is NOT in this repository

Internally Switch CSOC is using additional customer specific notebooks and those are stored in private repositories and linked using Git submodules.

## Contribution / Development

Submitting any change to `main` branch requires a Merge Request. No one is allowed to directly push changes into the `main` branch, not even the instance admins.

In short if you want to make a change you need to do the followings:

1. Create a new branch or fork the repository
2. Make your changes in this new branch or in your forked repository
3. Create Pull Request

## Troubleshooting

When facing issues the following steps should be followed:

- Run the code block again
- Restart the kernel using the restart button on the top of the notebook
- Open an issue with the screenshots of the error message and the notebook

## Feedback

To submit your issues or feature requests please use the Issues tab of this repository.
