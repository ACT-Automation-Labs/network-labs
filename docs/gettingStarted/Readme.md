**How to contribute to Github in ACT-Automation-Labs**



To perform the steps please install VSCode and gitbash for your ease. 

Git bash - [Git for Windows](https://gitforwindows.org/)

Visual studio code - [Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/Download)

#### Git clone

```shell
$ git clone <repo-url>
```

![gitClone](C:\Office\AKSLabs\Document\gitClone.png)

```shell
$ git clone https://github.com/ACT-Automation-Labs/network-labs.git
Cloning into 'network-labs'...
remote: Enumerating objects: 22, done.
remote: Counting objects: 100% (22/22), done.
remote: Compressing objects: 100% (18/18), done.
remote: Total 22 (delta 5), reused 20 (delta 4), pack-reused 0
Receiving objects: 100% (22/22), 5.73 KiB | 2.87 MiB/s, done.
Resolving deltas: 100% (5/5), done.

```



####  Create a new branch

1) Enter into the cloned directory. It will always have the name same as repository name. 

```bash
~ $ cd network-labs/
```

Once you enter into git repository (also called git local repository), you will see the default branch of the repository (main)

```bash
~/network-labs (main)$
```

3) Create your separate branch. Here I am creating a branch for project with the naming convention WI-<number>-<alias>

```bash
~/network-labs (main)$ git checkout -b WI-13-meghasinghal

```

You will understand if the branch is created or not if your workspace is switched to new branch as below - 

![gitBranchCheckout](C:\Office\AKSLabs\Document\gitBranchCheckout.png)

#### Make changes

To make changes, I am using VScode with Git extensions installed. You can use any IDE of your choice.  Open your project folder (git local repository), network-labs in IDE. Before making changes, please make sure you are on the right branch. Check at left bottom corner- 

![branchInIDE](../../../Document/branchInIDE.png)

Make changes in the files where needed. 

#### commit

1. Once done, click on the git extension. 

2. Click on "+" button to `stage` your changes. 

   ![gitAdd](../../../Document/gitAdd.png)

3. Add commit message relevant to your changes along with the WI number in this format - AB#<WI-number>

4. click on ✔️ to commit your changes. 

   ![gitCommit](../../../Document/gitCommit.png)

   ​

#### Push to Github as a new branch

#### Create a Pull Request