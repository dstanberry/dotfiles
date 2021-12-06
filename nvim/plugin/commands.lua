local util = require "util"

util.define_command {
  name = "W",
  callback = util.buffer.sudo_write,
}

util.define_command {
  name = "S",
  callback = util.buffer.create_scratch,
}
