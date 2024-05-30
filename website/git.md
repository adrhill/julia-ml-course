# Hosting a Julia Package on GitHub

Now that we have written a Julia package, we want to share it with other people.
We can do this by hosting it on GitHub, GitLab, sourcehut or any other hosting platform.

In this example, we are going to work with GitHub, where the majority of the Julia community hosts their code.
Apart from visibility, GitHub has several other advantages:
* GitHub provides access to [GitHub Actions](https://github.com/features/actions), remote computers that can be used to run your test suite and build your documentation on each commit.
* [GitHub Pages](https://pages.github.com) can host your package documentation as a public website.

~~~
<h2>Table of Contents</h2>
~~~
\tableofcontents

## Learning Git

Git and GitHub are two different things:

* Git is a free and open-source version control system. It allows you to keep track of any changes to your project (*repository*) in a graph-like data structure. 
* GitHub is a commercial website that hosts Git repositories and enables collaboration between developers.

!!! warning "Learn Git"
    If you are unfamiliar with Git, I recommend you to 
    
    1. Read the [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/2020/version-control/) page on version control
    2. Play the [Oh My Git!](https://ohmygit.org/) video game

    These will introduce you to terms like *commit*, *push*, *merge* and *remote* that we use throughout this page.

## Setting up an account on GitHub 

First, [create an account on GitHub](https://github.com/signup).

To be able to push changes from your local Git repository to GitHub, you need to authenticate yourself.
You can do this by generating [SSH keys](https://en.wikipedia.org/wiki/Secure_Shell) and adding them to your GitHub account.
If you don't know what this means, GitHub [provides an in-depth guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh), with pages on [generating keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [adding them to your account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

!!! tip
    If you are a student, you can get access to the [GitHub Student Developer Pack](https://education.github.com/pack) for free. 
    This includes free GitHub Pro and access to Copilot.

## Setting up a Julia project on GitHub

When we [set up our Julia package](/setup), PkgTemplates initialized a local Git repository for us.
To *push* this repository to GitHub, we first need to create an empty GitHub repository of the same name.

### Creating an empty remote repository

You can either click on the `+` sign in the top-right corner of the GitHub website or navigate to [github.com/new](https://github.com/new). Enter the same repository name you chose during [set-up](/setup) and initialize the repository with **no README, no `.gitignore` and no license**. 
If you are taking the JuML course, set the repository to public for our code review sessions. You can change the visibility of the repository once the course is over.

After creating the repository, you should be greeted by GitHub's suggestion to *"...push an existing repository from the command line"*.
To do this, open a terminal, `cd` to your project folder and run 

```bash
git remote add origin git@github.com:YourGitHubUsername/MyPackage.git # <--- use your username!
git branch -M main
git push -u origin main
```

### Inviting collaborators

In your repository on GitHub, click on the `Settings > Access > Collaborators` and invite your group members to your repository.
This will give them permission to modify the repository and merge pull requests.

### Setting up Documenter.jl

The final step to setting up your projects is to allow [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) to build your documentation and host it on [GitHub Pages](https://pages.github.com).
For this purpose, install [DocumenterTools.jl](https://github.com/JuliaDocs/DocumenterTools.jl) in a temporary environment and run:

```julia 
DocumenterTools.genkeys(user="YourGitHubUsername", repo="MyPackage.jl")
```

This will generate and print two keys, with instruction on how to add them to GitHub.

## Suggested workflow

There is no right or wrong way to use Git. 
It's a flexible tool designed to make your life easier, not harder, so use whatever makes you productive.

However, this flexibility can be overwhelming for newcomers.
In this section, we therefore suggest a workflow based on *squash-merged pull-requests*,
where we work on a branch and turn the entire branch into **a single commit** at the end.

### Squash-merged PRs
#### 1. Create a new branch for every change

Using this workflow, we never push directly to our main branch. 
Instead, we always create a new branch from `main`.
It is considered good practice to name your branch after the feature it implements and to prefix it with your initials (`ah` for **A**drian **H**ill in my case):

```bash
git checkout origin/main # make sure your current branch is the main branch from the GitHub remote

git checkout -b ah/timestwo # creates a new branch (-b) called timestwo and checks it out
```

#### 2. Commit changes to your branch

Try to make your commit messages informative, but don't worry too much about them, as they will be squashed.
Commits to your branch **don't** have to be "atomic": it's fine if intermediate commits fail tests. Only the final commit to your branch must be functional and [pass all tests](/test).

#### 3. Open a pull request on GitHub

Once your new feature is ready, and your [test suite](/test) passes locally, push your branch to your remote GitHub repository using `git push`.
Open your repository on GitHub. A colorful pop-up will ask you to open a pull request (PR) by clicking on it.

Give your PR an informative title and describe the changes you made. 
The GitHub Actions that [PkgTemplates set up for you](/setup) will start running package tests.
If the tests fail, click on them for additional information.
Fix them locally, `git commit` your fixes, and `git push` them to update the PR. This will re-run the tests on GitHub. Repeat this until your tests pass.

#### 4. Fix merge conflicts (if they occur)

Merge conflicts can occur when your branch and the main branch change the same line of code at the same time. 
Fortunately, they are easy to resolve using our workflow.
Simply merge `origin/main` into your branch using:

```bash
git merge origin/main
```

To resolve a merge conflict, Git will ask you which of the changes to keep and which to discard: 
the ones from your branch, the ones from `main`, or a mix of both.
To help you with this, VSCode will enter the [merge editor view](https://code.visualstudio.com/docs/sourcecontrol/overview#_3way-merge-editor) when you run the command above.
Once the merge is completed, VSCode will make a merge commit.

Since we will squash all of our commits, the merge doesn't have to be perfect. 
Feel free to push follow-up fixes to your branch in case something went wrong. 

#### 5. Ask for a code review

If you are unsure about your changes, ask your group mates to review your code.
Here are some guide lines for code reviews:
* be friendly and considerate 
* avoid ["bike shedding"](https://en.wikipedia.org/wiki/Law_of_triviality): arguing about trivial issues like  the name of a variable
* avoid getting stuck in "code review hell": perfect is the enemy of good

Remember that any changes are not permanent and can still be modified in a later PR.
It is good to keep a PR small.

#### 6. Squash-merge the PR

Once your PR has passed all CI tests and has been approved by your collaborators, it is ready to be merged.

**You need to be careful here:**
On the *"Merge pull request"* button on GitHub, click on the drop-down menu and select *"Squash and merge"*.
By default, the title of the squash-merge will include a link to the PR, e.g. `(#42)`, which is very useful.
Make sure the commit message of your PR is informative, as it will replace the commit messages of individual commits on your branch.

Once your PR is merged, delete the branch of your PR and check out the `main` branch again. 
Running `git fetch` will ensure that your local repository is up to date with the remote repository on GitHub.

### Pros & Cons

Some people who carefully craft individual commits dislike that squash-merges effectively delete their commit messages.
Some people also dislike that squash-merges move information to GitHub PRs instead of the local Git commit history.
Both of these issues can be avoided by crafting informative commit messages for the final squash-merge. 
Linking to the GitHub PR also has the advantage of making comments from a code review quickly accessible.

Another disadvantage is that commits can get quite large, potentially making them hard to read.
Avoiding this requires some discipline: only work on only one feature at a time and keep your PRs small.

The real advantage of squash-merging is that **you don't have to carefully craft individual commits**.
You don't have to worry about atomic commits to your branch, "ugly" merge conflicts, or numerous commits after CI failures, since they will all be squashed away.
As long as you only squash-merge PRs that pass CI tests, your `main` branch will always end up being clean, linear, and atomic.
