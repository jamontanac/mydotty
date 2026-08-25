local M = {}
local section_query = vim.treesitter.query.parse('markdown', [[(section) @section]])
local codeblock_query = vim.treesitter.query.parse('markdown', [[(fenced_code_block) @codeblock]])
---@class present.Slides
---@field slides present.Slide[]: The slides of the file

---@class present.Slide
---@field title string: The title of the slide
---@field body string[]: The body of slide
---@field blocks present.Block[]: A codeblock inside of a slide

---@class present.Block
---@field language string: The language of the codeblock
---@field body string: The body of the codeblock
---@field start_row integer: The start row of the codeblock
---@field end_row integer: The end row of the codeblock

--- Takes some lines and parses them
---@param lines string[]: The lines in the buffer
---@return present.Slides

M.parse_slides = function(lines, options)
    local contents = table.concat(lines, '\n') .. '\n'
    local parser = vim.treesitter.get_string_parser(contents, 'markdown')
    local root = parser:parse()[1]:root()

    local slides = { slides = {} }

    local create_empty_slide = function()
        return { title = '', body = {}, blocks = {} }
    end

    local add_line_to_block = function(slide, line)
        if not line then
            return
        end

        -- Trim trailing whitespace, it can have weird highlighting and whatnot
        line = line:gsub('%s*$', '')
        table.insert(slide.body, line)
    end

    local get_block = function(codeblocks, idx)
        for _, codeblock in ipairs(codeblocks) do
            if idx >= codeblock.start_row and idx <= codeblock.end_row then
                return codeblock
            end
        end

        return nil
    end

    local current_slide = create_empty_slide()
    for _, node in section_query:iter_captures(root, contents, 0, -1) do
        if #current_slide.title > 0 then
            table.insert(slides.slides, current_slide)
            current_slide = create_empty_slide()
        end

        local start_row, _, end_row, _ = node:range()
        local heading_line = lines[start_row + 1]

        -- Skip if not an H1 heading
        if not heading_line or not heading_line:match '^#%s' then
            goto continue
        end

        -- current_slide.title = heading_line:gsub('^#%s+', '')
        current_slide.title = heading_line

        local codeblocks = vim.iter(codeblock_query:iter_captures(root, contents, start_row, end_row))
            :map(function(_, n)
                local s, _, e, _ = n:range()
                local language = vim.trim(string.sub(lines[s + 1], 4))
                return {
                    language = language,
                    body = table.concat(vim.list_slice(lines, s + 2, e - 1), '\n'),
                    start_row = s + 1,
                    end_row = e,
                }
            end)
            :totable()

        local comment = options.syntax.comment
        local stop = options.syntax.stop

        local process_line = function(idx)
            local line = lines[idx]
            local block = get_block(codeblocks, idx)

            -- Only do our comments/splits/etc if we are not in a codeblock
            if not block then
                -- Skip comment lines
                if comment and vim.startswith(line, comment) then
                    return
                end

                -- Split on `stop` comments
                if stop and line:find(stop) then
                    line = line:gsub(stop, '')
                    add_line_to_block(current_slide, line)
                    table.insert(slides.slides, current_slide)
                    current_slide = vim.deepcopy(current_slide)
                    return
                end

                return add_line_to_block(current_slide, line)
            end

            -- Only add code blocks to the current slide if we have
            -- actually reached them (this could not happen because of stop comments)
            if idx == block.start_row then
                table.insert(current_slide.blocks, block)
            end

            -- GIVE ME THE CODE AND GIVE IT TO ME RAW
            add_line_to_block(current_slide, lines[idx])
        end

        -- Process the lines: Add one for row->line, add one to skip the header
        local start_of_section = start_row + 2
        for idx = start_of_section, end_row do
            process_line(idx)
        end

        ::continue::
    end

    -- Add the last slide, won't happen in the loop
    if #current_slide.title > 0 then
        table.insert(slides.slides, current_slide)
    end

    return slides
end

return M
