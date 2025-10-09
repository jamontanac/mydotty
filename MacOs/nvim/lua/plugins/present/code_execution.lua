local M = {}
--- Default executor for lua code
---@param block present.Block
M.execute_lua_code = function(block)
    -- Override the default print function, to capture all of the output
    -- Store the original print function
    local original_print = print

    local output = {}

    -- Redefine the print function
    print = function(...)
        local args = { ... }
        local message = table.concat(vim.tbl_map(tostring, args), '\t')
        table.insert(output, message)
    end

    -- Call the provided function
    local chunk = loadstring(block.body)
    pcall(function()
        if not chunk then
            table.insert(output, ' <<<BROKEN CODE>>>')
        else
            chunk()
        end

        return output
    end)

    -- Restore the original print function
    print = original_print

    return output
end

--- Default executor for Rust code
--- This is particularly janky, as it requires rustc to be installed
--- we compile and then run the compiled binary
---@param block present.Block
M.execute_rust_code = function(block)
    local tempfile = vim.fn.tempname() .. '.rs'
    local outputfile = tempfile:sub(1, -4)
    vim.fn.writefile(vim.split(block.body, '\n'), tempfile)
    local result = vim.system({ 'rustc', tempfile, '-o', outputfile }, { text = true }):wait()
    if result.code ~= 0 then
        local output = vim.split(result.stderr, '\n')
        return output
    end
    result = vim.system({ outputfile }, { text = true }):wait()
    return vim.split(result.stdout, '\n')
end

M.create_system_executor = function(program)
    return function(block)
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(vim.split(block.body, '\n'), tempfile)
        local result = vim.system({ program, tempfile }, { text = true }):wait()
        return vim.split(result.stdout, '\n')
    end
end

return M
