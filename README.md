# docker-compose.nvim

Forget your containers!

This plugin will handle `docker-compose` based containers automatically:

- start them when entering a directory with a `docker-compose` configuration
- stop them when leaving a directory with a `docker-compose` configuration

Containers are started through `podman-compose` if available, `docker-compose`
otherwise.

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "pipoprods/docker-compose.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim",
  },
  config = true,
}
```

## Usage

There's nothing to be done for a normal usage. The plugin will automatically handle your containers startup/cleanup.

```lua
require('docker-compose').up()
require('docker-compose').down()
require('docker-compose').kill()
```
