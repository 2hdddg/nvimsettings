local M = {}

function M.setup()
    -- Invoked for each buffer where Java LSP is attached
    local on_attach = function(client, bufnr)
        require'jdtls.setup'.add_commands()
        require'jdtls'.setup_dap()
    end

    -- Define where Eclipse puts workspace
    local root_markers = {'.git'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local home = os.getenv('HOME')
    local workspace_folder = home .. "/.workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    -- Server
    local config = {
        on_attach = on_attach,
        cmd = {'java-lsp.sh', workspace_folder},
    }
    -- Debugger support through java-debug
    -- Needed to make dap tick
    local jar_patterns = {
        "/code/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
        "/code/vscode-java-test/server/*.jar",
    }
    local bundles = {}
    for _, jar_pattern in ipairs(jar_patterns) do
        for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
          if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
            table.insert(bundles, bundle)
          end
        end
    end
    config['init_options'] = {
        bundles = bundles;
    }
    require('jdtls').start_or_attach(config)
end

return M
