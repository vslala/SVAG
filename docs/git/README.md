## How to Squash Commit

Lets say you have a list of multiple commits -

- commit 1
- commit 2
- commit 3
- commit 4
- commit 5

Now, let's say you want to squash all 5 commits into one with an appropriate message.
For that you would need to fire the following commands on your console.

`git rebase -i HEAD~6`

This will open an editor with a list of 6 commits starting from the head. Now, all you need to do is replace `pick` with `s` and save the file. Do this in front of the commits that you want to squash.

One important point to remember is that the commits are squashed with the ones above it. So if you are writing `s` in front of commit 3, then that commit will be squashed to commit 2.

Let's say these are my list of commits.

`glog -n 6`

* cfff6b3 (HEAD -> master) explain about the command  Varun Shrivastava, 17 seconds ago
* dd4394e add the squash command  Varun Shrivastava, 3 minutes ago
* 4b3affb talk about the squash command  Varun Shrivastava, 4 minutes ago
* c8b4401 add a list of 5 commits  Varun Shrivastava, 5 minutes ago
* 0cbda5e create a file with a heading  Varun Shrivastava, 6 minutes ago
* a3218c0 (origin/master) implement long polling in Java  Varun Shrivastava, 4 weeks ago

So, to squash all these commits into one, we would do something like this:

`git rebase -i HEAD~6`

It would open an editor with a list of commits like this:

```
pick 0cbda5e create a file with a heading
pick c8b4401 add a list of 5 commits
pic 4b3affb talk about the squash command
pic dd4394e add the squash command
pick cfff6b3 explain about the command
pick 518699b list the commits
```

So, in order to squash the commits together, replaces the word `pick` with `s` like you see below:


```
pick 0cbda5e create a file with a heading
s c8b4401 add a list of 5 commits
s 4b3affb talk about the squash command
s dd4394e add the squash command
s cfff6b3 explain about the command
s 518699b list the commits
```

What it will do is - It will take all the commits with a prefix `s` and squash them to the commit `prefix` pick. It also generates a new commit hash and asks you to provide a relevant message for it. This is where you can add the relevant message and push your changes to the master.

