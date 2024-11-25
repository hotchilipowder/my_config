# Github Action



## Introduction

根据[了解 GitHub Actions](https://docs.github.com/zh/actions/about-github-actions/understanding-github-actions)，
对于Github Actions需要了解一下的概念


### workflows

Workflows are defined in the `.github/workflows` directory in a repository.

常见的任务包括:

+ Building and testing pull requests. 构建和测试pull request
+ Deploying your application every time a release is created. 部署应用，当发表release时
+ Adding a label whenever a new issue is opened. 当开一个新的issue的时候添加一个标签


### Events


An event is a specific activity in a repository that triggers a workflow run. 

常见的触发包括:

+ push a commit to a repository
+ creates a pull request
+ opens an issue


### Jobs

A job is a set of steps in a workflow that is executed on the same runner.

对于一个step，通常包括:

+ a shell script that will be executed
+ an action will be run

Step是顺序执行的.


### Actions

An action is a custom application for the GitHub Actions platform that performs a complex but frequently repeated task.

Action是各种写好的集合。可以理解成是一种代码的重复利用。如果不是个性化的，建议使用一些常见的Action将会更好提升效率.


### Runners

A runner is a server that runs your workflows when they're triggered. 
Each runner can run a single job at a time. 
GitHub provides Ubuntu Linux, Microsoft Windows, and macOS runners to run your workflows.

需要一提的，我们也可以用self-hosted的runners。[Hosting your own runners](https://docs.github.com/en/actions/hosting-your-own-runners)


## Github Action功能

### 持续集成 (CI)

持续集成 (CI) 是一种需要频繁提交代码到共享仓库的软件实践。 频繁提交代码能较早检测到错误，减少在查找错误来源时开发者需要调试的代码量。 频繁的代码更新也更便于从软件开发团队的不同成员合并更改。 这对开发者非常有益，他们可以将更多时间用于编写代码，而减少在调试错误或解决合并冲突上所花的时间。

提交代码到仓库时，可以持续创建并测试代码，以确保提交未引入错误。 您的测试可以包括代码语法检查（检查样式格式）、安全性检查、代码覆盖率、功能测试及其他自定义检查。

创建和测试代码需要服务器。 您可以在推送代码到仓库之前在本地创建并测试更新，也可以使用 CI 服务器检查仓库中的新代码提交。


+ [actions/starter-workflows](https://github.com/actions/starter-workflows/tree/main/ci)
+ [Python CI](https://docs.github.com/zh/actions/use-cases-and-examples/building-and-testing/building-and-testing-python)

### 持续部署 (CD)

持续部署 (CD) 是使用自动化发布和部署软件更新的做法。

配置 CD 工作流程在发生 GitHub 事件（例如，将新代码推送到存储库的默认分支）时运行、按设定的时间表运行、手动运行或者在使用存储库分发 web 挂钩的外部事件发生时运行


一般来说，可以定义一个deploy的分支，然后当push到这个分支的commit后，就可以实现部署和更新了。当然也可以使用release的方式进行。



### 高级工作流功能

#### Secrets

如果你的工作流使用密码或证书等敏感数据，你可以将这些数据作为机密保存在 GitHub 中，然后在工作流中将它们用作环境变量。 这意味着你将能够创建和共享工作流，而无需直接在工作流的 YAML 源中嵌入敏感值。

```YAML
jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - name: Retrieve secret
        env:
          super_secret: ${{ secrets.SUPERSECRET }}
        run: |
          example-command "$super_secret"

```



#### 创建依赖的作业


## Github 托管


## Self-hosted 托管


## 参考资料


+ [GitHub Actions 文档](https://docs.github.com/zh/actions)
