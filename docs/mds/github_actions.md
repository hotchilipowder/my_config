

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

基于找个特性，可以实现在 self-hosted 中自动重启docker (docker跑在 `sudo`中且普通用户没有权限的情况下）

  
  
:::{hint}
使用`sudo -S`可以实现从标准输入中读取密码
:::

  


#### 创建依赖的作业

默认情况下，工作流程中的作业同时并行运行。 如果你有一个作业只能在另一个作业完成后运行，则可以使用 needs 关键字来创建此依赖项。 如果其中一个作业失败，则跳过所有从属作业；但如果需要作业继续运行，可以使用 if 条件语句来定义。


```YAML
jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - run: ./setup_server.sh
  build:
    needs: setup
    runs-on: ubuntu-latest
    steps:
      - run: ./build_server.sh
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: ./test_server.sh
```

#### 使用矩阵

使用矩阵策略，可以在单个作业定义中使用变量自动创建基于变量组合的多个作业运行。 例如，可以使用矩阵策略在某个语言的多个版本或多个操作系统上测试代码。 矩阵是使用 strategy 关键字创建的，该关键字接收生成选项作为数组。 例如，此矩阵将使用不同版本的 Node.js 多次运行作业：

```YAML
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [14, 16]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}

```


#### 缓存依赖项

如果你的作业定期重用依赖项，你可以考虑缓存这些文件以帮助提高性能。 缓存一旦创建，就可用于同一仓库中的所有工作流程。


```YAML
jobs:
  example-job:
    steps:
      - name: Cache node modules
        uses: actions/cache@v3
        env:
          cache-name: cache-node-modules
        with:
          path: ~/.npm
          key: ${{ runner.os }}-build-${{ env.cache-name }}-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-build-${{ env.cache-name }}-
```

有关详细信息，请参阅“[缓存依赖项以加快工作流程](https://docs.github.com/zh/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows)”


#### 使用数据库和服务容器

如果作业需要数据库或缓存服务，可以使用 services 关键字创建临时容器来托管服务；生成的容器随后可用于该作业中的所有步骤，并在作业完成后删除。
此示例演示作业如何使用 services 创建 postgres 容器，然后使用 node 连接到服务。

```YAML
jobs:
  container-job:
    runs-on: ubuntu-latest
    container: node:20-bookworm-slim
    services:
      postgres:
        image: postgres
    steps:
      - name: Check out repository code
        uses: actions/checkout@v4
      - name: Install dependencies
        run: npm ci
      - name: Connect to PostgreSQL
        run: node client.js
        env:
          POSTGRES_HOST: postgres
          POSTGRES_PORT: 5432
```

#### 使用标签路由工作流程

如果要确保特定类型的运行器处理作业，可以使用标签来控制作业的执行位置。 除了默认标签 self-hosted 之外，还可以为自托管运行器分配其他标签。 然后，可以在 YAML 工作流中引用这些标签，确保作业以可预测的方式路由。 GitHub 托管运行器已获分配了预定义的标签。

此示例显示工作流程如何使用标签来指定所需的运行器：

```YAML
jobs:
  example-job:
    runs-on: [self-hosted, linux, x64, gpu]
```

工作流只能在所有标签处于 runs-on 数组中的运行器上运行。 作业将优先转到具有指定标签的空闲自托管运行器。 如果没有可用且具有指定标签的 GitHub 托管的运行器，作业将转到 GitHub 托管的运行器。


若要详细了解自托管运行器标签，请参阅将 [标签与自托管运行程序结合使用](https://docs.github.com/zh/actions/hosting-your-own-runners/managing-self-hosted-runners/using-labels-with-self-hosted-runners)。

有关 GitHub 托管的运行器标签的详细信息，请参阅 [使用 GitHub 托管的运行器](https://docs.github.com/zh/actions/using-github-hosted-runners/using-github-hosted-runners#supported-runners-and-hardware-resources)。


#### 重新使用工作流

可调用一个工作流，可以公开或私下与组织共享工作流。 这样便可重用工作流，避免重复并使工作流更易于维护。 有关详细信息，请参阅 [重新使用工作流](https://docs.github.com/zh/actions/sharing-automations/reusing-workflows)



## Github 托管




## Self-hosted 托管


## 参考资料


+ [GitHub Actions 文档](https://docs.github.com/zh/actions)
