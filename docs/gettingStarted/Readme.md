## How to contribute to ACT-Automation-Labs on Github

[TOC]

### Pre-requisite 

1) Get your access.

2) To perform the steps please install Visual Studio Code and git bash for the ease. 

​	Git bash - [Git for Windows](https://gitforwindows.org/)

​	Visual studio code - [Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/Download)

### Git clone

Run below command in git bash. 

```shell
$ git clone https://github.com/ACT-Automation-Labs/network-labs.git
```

![gitClone](.\images\gitClone.png)

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



###  Create a new branch

1) Enter into the cloned directory. It will always have the name same as the repository name. 

```bash
~ $ cd network-labs/
```

Once you are into git repository (also called git `local repository`), you will see the default branch of the repository (main)

```bash
~/network-labs (main)$
```

3) Create your separate branch and switch to it. Here, I am creating a branch for project following the naming convention `WI-<number>-<alias>`

```bash
~/network-labs (main)$ git checkout -b WI-13-meghasinghal
```

To verify if the branch is created and switched to or not, check the branch as below - 

![gitBranchCheckout](.\images\gitBranchCheckout.png)

### Make changes

To make changes, I am using VScode with Git extensions installed. You can use any IDE of your choice.  

Open your project folder (git local repository), network-labs in IDE. Before making changes, please make sure you are on the right branch. Check at left bottom corner- 

![branchInIDE](.\images/branchInIDE.png)

Make changes in the files where needed. 

### Commit changes

1. Once done, click on the source control extension. 

2. Click on "+" button to `stage` your changes. 

   ![gitAdd](.\images\gitAdd.png)

3. Add commit message relevant to your changes along with the WI number in this format - `AB#<WI-number>`. Appending the commit messages with AB# is important to get the commits tracked in your Azure DevOps Work Item.

4. Click on ✔️ to `commit` your changes. 

   ![gitCommit](.\images\gitCommit.png)

   ​

### Push to Github as a new branch

If you have created the branch on local and publishing the branch for the first time, you will get option of `Publish Branch` as below -

![PushBranch](.\images\PushBranch.png)

It will ask you to authenticate with your github credentials. Once successful, you will be able to see your branch on Github.

![branchOnGithub](.\images\branchOnGithub.png)

If you have any other changes yet to be made, you can make changes in your files, and follow the same steps, `stage` , `commit`  (As mentioned above) and push your changes to your respective branch. 

To push changes , please follow below - 

![SyncChanges](.\images\SyncChanges.png)



​                    ![dialogBox](.\images\dialogBox.png)   

### Create a Pull Request

Once your changes are successfully tested and pushed and ready to be merged in the main branch, please follow below steps on github - 

1. Click on Compare & Pull request

![CompareAndPull](.\images\CompareAndPull.png)

2. Create a pull request as below - 

   1. Verify base branch - It is the destination branch (to which you want to merge your branch)
   2. Provide merge commit message and comment.
   3. Add reviewer to request a review.
   4. Click on create pull request.

   ![pullRequestCreation](.\images\pullRequestCreation.png) 


### Important Note  

1) Please avoid pushing any PII (personal identifiable information) into the repository.

2) Please test the scripts or code before pushing and creating the pull requests.

