# CI/CD

## Pipeline

Pipeline 是持续集成、交付和部署的顶层组件
Pipeline包含
- Jobs, what to do, eg: compile or test
- Stages, when to run jobs

jobs由 runner 来执行, 如果 runner 数量足够, 则同一个 stage 中的jobs将会并行执行

如果一个 stage 中的所有 jobs 都 **成功** 执行, 则 Pipeline 将会移动到下一个 stage

一般而言, 如果 stage 中有任意 job 失败, 则下一个 stage 不会继续执行, pipeline 也会提前结束

典型的 pipeline流程: 
- build stage, with a job called compile.
- test stage, with two jobs called test1 and test2.
- staging stage, with a job called deploy-to-stage.
- production stage, with a job called deploy-to-prod.


[pipeline-arch](https://docs.gitlab.com/ee/ci/pipelines/pipeline_architectures.html)
[jobs](https://docs.gitlab.com/ee/ci/jobs/job_control.html)
[ci](https://docs.gitlab.com/ee/ci/yaml/index.html#dependencies)

## key words

### only expect rules

only, except 指定分支或tag, 而 rules 能够提更细节的控制, 但需要注意，rules 不能与 only/except 一起使用

rule 会对定义在其中的规则依次判断，直到第一次匹配。当找到匹配项时，则会根据规则定义的行为，将该 job 加入到 pipeline 中或移除

### changes

[rule changes](https://docs.gitlab.com/ee/ci/yaml/#ruleschanges)

path/to/directory/* 匹配指定目录下的所以文件, 不包括子目录

path/to/directory/**/* 匹配从指定目录开始, 以及所有子目录中的文件及目录


An array including any number of:
- Paths to files. In GitLab 13.6 and later, file paths can include variables. A file path array can also be in rules:changes:paths.
- Wildcard paths for:
  - Single directories, for example path/to/directory/*.
  - A directory and all its subdirectories, for example path/to/directory/**/*.
- Wildcard glob paths for all files with the same extension or multiple extensions, for example *.md or path/to/directory/*.{rb,py,sh}. See the Ruby fnmatch documentation for the supported syntax list.
- Wildcard paths to files in the root directory, or all directories, wrapped in double quotes. For example "*.json" or "**/*.json".

[file-syntax](https://docs.ruby-lang.org/en/master/File.html#method-c-fnmatch)

```
*
Matches any file. Can be restricted by other values in the glob. Equivalent to /.*/x in regexp.

*
Matches all regular files

c*
Matches all files beginning with c

*c
Matches all files ending with c

*c*
Matches all files that have c in them (including at the beginning or end).

To match hidden files (that start with a .) set the File::FNM_DOTMATCH flag.

**
Matches directories recursively or files expansively.

?
Matches any one character. Equivalent to /.{1}/ in regexp.

[set]
Matches any one character in set. Behaves exactly like character sets in Regexp, including set negation ([^a-z]).

\
Escapes the next metacharacter.

{a,b}
Matches pattern a and pattern b if File::FNM_EXTGLOB flag is enabled. Behaves like a Regexp union ((?:a|b)).
```

### mannual

