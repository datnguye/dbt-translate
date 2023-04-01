# Contributing to `dbt-translate`

`dbt-translate` is open source software, whether you are a seasoned open source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.

Remember: all PRs (apart from cosmetic fixes like typos) should be [associated with an issue](https://docs.getdbt.com/docs/contributing/oss-expectations#pull-requests).

1. [About this document](#about-this-document)
1. [Getting the code](#getting-the-code)
1. [Setting up an environment](#setting-up-an-environment)
1. [Implementation guidelines](#implementation-guidelines)
1. [Testing dbt-translate](#testing)
1. [Submitting a Pull Request](#submitting-a-pull-request)

## About this document

There are many ways to contribute to the ongoing development of `dbt-translate`, such as by participating in discussions and issues. We encourage you to first read our higher-level document: ["Expectations for Open Source Contributors"](https://docs.getdbt.com/docs/contributing/oss-expectations).

The rest of this document serves as a more granular guide for contributing code changes to `dbt-translate` (this repository). It is not intended as a guide for using `dbt-translate`, and some pieces assume a level of familiarity with Python development (virtualenvs, `pip`, etc). Specific code snippets in this guide assume you are using macOS or Linux and are comfortable with the command line.

### Notes

- **Branches:** All pull requests from community contributors should target the `main` branch (default). If the change is needed as a patch for a version of `dbt-translate` that has already been released (or is already a release candidate), a maintainer will backport the changes in your PR to the relevant branch.

## Getting the code

### Installing git

You will need `git` in order to download and modify the `dbt-translate` source code. On macOS, the best way to download git is to just install [Xcode](https://developer.apple.com/support/xcode/).

### External contributors

You can contribute to `dbt-translate` by forking the `dbt-translate` repository. For a detailed overview on forking, check out the [GitHub docs on forking](https://help.github.com/en/articles/fork-a-repo). In short, you will need to:

1. Fork the `dbt-translate` repository
2. Clone your fork locally
3. Check out a new branch for your proposed changes
4. Push changes to your fork
5. Open a pull request against `datnguye/dbt-translate` from your forked repository

## Setting up an environment

There are some tools that will be helpful to you in developing locally. While this is the list relevant for `dbt-translate` development, many of these tools are used commonly across open-source python projects.

### Tools

These are the tools used in `dbt-translate` development and testing:
- [`poetry`](https://python-poetry.org/docs/) to setup the local development environment
- [Github Action](https://circleci.com/) for automating tests and checks, once a PR is pushed to the `dbt-translate` repository

```
python3 -m pip install poetry~=1.4.0
python3 -m poetry install
python3 -m poetry shell
dbt --version
```

A deep understanding of these tools in not required to effectively contribute to `dbt-translate`, but we recommend checking out the attached documentation if you're interested in learning more about each one.

## Implementation guidelines

Ensure that changes will work on "non-core" adapters by:
- dispatching any new macro(s) so non-core adapters can also use them
- using [`type_*` macros](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#data-type-functions) instead of explicit datatypes (e.g. [`type_timestamp()`](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#type_timestamp) instead of `TIMESTAMP`

## Testing

Once you're able to manually test that your code change is working as expected, it's important to run existing automated tests, as well as adding some new ones. These tests will ensure that:
- Your code changes do not unexpectedly break other established functionality
- Your code changes can handle all known edge cases
- The functionality you're adding will _keep_ working in the future

See here for details for running existing integration tests and adding new ones:

**An integration test typically involves making 1) a new seed file 2) a new model file 3) a generic test to assert anticipated behaviour.**

For an example integration tests, check out the tests for the get_url_parameter macro:
- Macro definition
- Seed file with fake data
- Model to test the macro
- A generic test to assert the macro works as expected
Once you've added all of these files, you should be able to run:

Assuming you are in the integration_tests folder,
```bash
dbt deps --target {your_target}
dbt seed --target {your_target}
dbt run --target {your_target} --model {your_model_name}
dbt test --target {your_target} --model {your_model_name}
```
Alternatively:
```bash
dbt deps --target {your_target}
dbt build --target {your_target} --select +{your_model_name}
```
If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.


## Submitting a Pull Request

A `dbt-translate` maintainer will review your PR. They may suggest code revision for style or clarity, or request that you add unit or integration test(s). These are good things! We believe that, with a little bit of help, anyone can contribute high-quality code.

Automated tests run via CircleCI. If you're a first-time contributor, all tests (including code checks and unit tests) will require a maintainer to approve. Changes in the `dbt-translate` repository trigger integration tests.

Once all tests are passing and your PR has been approved, a `dbt-translate` maintainer will merge your changes into the active development branch. And that's it! Happy developing :tada: