function insertHeading(selection, text, style, insertPageBreak)
    % Function Duties
    % Inserts the heading for word
    
    % INPUT:
    % selection: word selection
    % text: text for the heading
    % style: heading style (e.g. 'Heading 1')
    % insertPageBreak: if true, inserts a break page at the beginning
    %%
    % If insertPageBreak is true, insert a page break before the heading
    if insertPageBreak
        selection.InsertBreak(7); % 7 = wdPageBreak
    end
    
    % Insert the heading
    selection.TypeParagraph;
    try
        selection.Style = style;
    end
    selection.TypeText(text);
    selection.TypeParagraph;
end

