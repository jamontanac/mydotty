-- This is needed to render
-- # For ASCII art fallback (choose one)
-- brew install chafa       # Recommended - better quality
-- # OR
-- brew install jp2a        # Alternative
--
-- # ImageMagick for format conversion (optional)
-- brew install imagemagick
--

-- Image rendering module for presentation plugin

local M = {}

M.has_images_in_content = function(lines)
    for _, line in ipairs(lines) do
        -- Check for markdown image syntax: ![alt](path) or ![alt](url)
        if line:match '!%[.-%]%(.-%)' then
            return true
        end
        -- Check for HTML img tags: <img src="...">
        if line:match '<img%s+.-src%s*=%s*["\'].-["\'].->' then
            return true
        end
        -- Check for reference-style images: ![alt][ref]
        if line:match '!%[.-%]%[.-%]' then
            return true
        end
    end
    return false
end
-- Finds markdown images and records their info
function M.find_images(slide_body, base_dir)
    local images = {}
    for i, line in ipairs(slide_body) do
        local path = line:match '!%b[]%((.-)%)'
        if path then
            if not path:match '^https?://' and not path:match '^/' then
                path = base_dir .. '/' .. path
            end
            if vim.fn.filereadable(path) == 1 then
                table.insert(images, {
                    path = path,
                    row = i - 1,
                })
            end
        end
    end
    return images
end

-- Let snacks.nvim handle image rendering automatically
function M.render_images(bufnr, slide_body)
    -- Set buffer content
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, slide_body)

    -- Set filetype to markdown so snacks can parse it
    vim.bo[bufnr].filetype = 'markdown'

    -- Enable treesitter for markdown
    pcall(vim.treesitter.start, bufnr, 'markdown')

    -- Trigger a redraw to let snacks process the buffer
    vim.schedule(function()
        vim.cmd 'redraw'
    end)
end

return M
-- -- Enhanced function to extract image paths
-- local get_image_paths = function(lines)
--     local images = {}
--     for _, line in ipairs(lines) do
--         -- Match markdown images: ![alt](path)
--         for alt, path in line:gmatch '!%[(.-)%]%((.-)%)' do
--             table.insert(images, { alt = alt, path = path, line = line })
--         end
--         -- Match HTML images: <img src="path" alt="alt">
--         for path in line:gmatch '<img%s+.-src%s*=%s*["\'](.-)["\']-.->' do
--             table.insert(images, { alt = '', path = path, line = line })
--         end
--     end
--     return images
-- end
-- -- Detect terminal protocol (kitty or fallback to ascii)
-- local function detect_terminal()
--     local tp = vim.env.TERM_PROGRAM or vim.env.TERM or ''
--     if tp:match 'kitty' or tp:match 'ghostty' or tp:match 'WezTerm' then
--         return 'kitty'
--     end
--     return 'ascii'
-- end
--
-- -- Base64 encode a file
-- local function encode_base64(path)
--     local p = io.popen('base64 < ' .. vim.fn.shellescape(path))
--     if not p then
--         return nil
--     end
--     local data = p:read '*a'
--     p:close()
--     return data:gsub('\n', '')
-- end
--
-- -- Render one image inline via Kitty protocol at a given cell size
-- local function kitty_inline(path, max_cols, max_rows)
--     local b64 = encode_base64(path)
--     if not b64 then
--         return nil
--     end
--     -- s=cols x rows
--     local seq = string.format('\x1b_Gf=100,a=T,t=d,s=%dx%d;%s\x1b\\', max_cols, max_rows, b64)
--     return seq
-- end
--
-- -- Render ascii art fallback at given width
-- local function ascii_inline(path, max_cols)
--     local tool = vim.fn.executable 'chafa' == 1 and 'chafa' or 'jp2a'
--     local cmd
--     if tool == 'chafa' then
--         cmd = string.format('chafa --symbols=block --size=%dx30 %s', max_cols, vim.fn.shellescape(path))
--     else
--         cmd = string.format('jp2a --width=%d %s', max_cols, vim.fn.shellescape(path))
--     end
--     local p = io.popen(cmd)
--     if not p then
--         return nil
--     end
--     local out = p:read '*a'
--     p:close()
--     return out
-- end
--
-- -- Main: rebuild buffer lines mixing text + image escapes
-- -- slide_body: array of original text lines
-- -- images: list of {path, line_index}
-- -- bufnr, winid: target buffer and its window
-- function M.render_mix(bufnr, winid, slide_body, images)
--     local term = detect_terminal()
--     -- Compute available width/height in cells
--     local cols = vim.api.nvim_win_get_width(winid)
--     local rows = vim.api.nvim_win_get_height(winid) - 1
--     local new_lines = {}
--     local img_map = {}
--     for _, img in ipairs(images) do
--         img_map[img.line] = img.path
--     end
--
--     for i, text in ipairs(slide_body) do
--         local idx = i - 1
--         if img_map[idx] then
--             local path = img_map[idx]
--             if term == 'kitty' then
--                 local seq = kitty_inline(path, cols, rows)
--                 table.insert(new_lines, seq)
--             else
--                 local art = ascii_inline(path, cols)
--                 for line in art:gmatch '[^\n]+' do
--                     table.insert(new_lines, line)
--                 end
--             end
--         else
--             table.insert(new_lines, text)
--         end
--     end
--
--     -- Replace buffer content
--     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
--     -- Force a redraw
--     vim.api.nvim_chan_send(vim.v.stderr, '\n')
-- end
--
-- -- Extract image paths and their line indices
-- function M.find_images(slide_body, base_dir)
--     local images = {}
--     for i, line in ipairs(slide_body) do
--         local alt, path = line:match '!%[(.-)%]%((.-)%)'
--         if path then
--             if not path:match '^https?://' and not path:match '^/' then
--                 path = base_dir .. '/' .. path
--             end
--             if vim.fn.filereadable(path) == 1 then
--                 table.insert(images, { path = path, line = i - 1 })
--             end
--         end
--     end
--     return images
-- end
--
-- return M
