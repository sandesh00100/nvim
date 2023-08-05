local config = {
    cmd = {'/Users/sandeshshrestha/jdt-server-1.9.0/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
-- Python is a requirement
require('jdtls').start_or_attach(config)
