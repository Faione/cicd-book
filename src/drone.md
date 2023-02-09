# Drone

Drone由Server，Runner两部分构成，Server与用户仓库建立联系，可以主动与用户仓库同步，或通过webhook来获取仓库最新变化，可以是 pr、issuce等，随后产生设定的 build 任务，Runner启动时与Server连接，并不断轮询以获取要执行的任务，随后便在本地根据用户项目中的 `.drone.yaml` 定义的步骤依次和执行CI任务，并反馈结果给 Server

> note:  
> Server 通过创建 build 任务来主动与仓库同步，如需响应webhook，需要将Server部署在仓库可访问的环境中, 如公网环境