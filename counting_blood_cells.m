A = im2double(imread('Cells.tif'));
%% inja threshold otsu peyda mikonim :
t = graythresh(A);
%% inja ba otsu threshold image ro siah-sefid mikonim (0 ya 1)
A = im2bw(A, 0.15);
A = A(2:size(A, 1),:);

%% ye tensor be andaze size tasvir ijad mikonim
%% ta algorithm DFS ro roosh ejra konim
%% arraye visited ke hamash false hast va har bar
%% ba peymayesh kardan e har pixel visited e oon pixel
%% ro True mikonim va 8 hamsaye mojaveresh ro (mask 3 * 3 dar nazar migirim)
%% check mikonim daghighan manand e algorithm e DFS ke node haye hamsaye ro
%% toye stack gharar midadim
visited = false(size(A));
[rows,cols] = size(A);
%% 
B = zeros(rows,cols);
%% yek counter baraye shomaresh e connected component ha:
ID_counter = 0;

%// Step 2
%// For each location in your matrix...




for row = 1 : rows
    for col = 1 : cols
        %// Step 2a
        %// If this location is not 1, mark as visited and continue
        %% agar sath e roshanaii pixel e mored e nazar mosavi ba sefr bood
        %% in pixel ro jozve background dar nazar migirim
        %% va serfan visited e motenazer ba oon ro True mikonim
        %% agar ham ke ghablan in pixel ro visit karde boodim
        %% ke dige checkesh nmikonim
        if A(row,col) == 0
            visited(row,col) = true;

        %// Step 2b
        %// If we have visited, then continue
        elseif visited(row,col)
            continue;

        %// Step 2c
        %// Else...
        else
            %// Step 3
            %// Initialize your stack with this location
            %% vaghti ke sath e roshanaii mored e nazar 1 hast va
            %% visit ham nashode, ye stack dorost mikonim va mokhtasat e 
            %% pixel e feli ro toosh zakhire mikonim
            stack = [row col];
            disp('current row and col : ');
            disp(stack);
            %// Step 3a
            %// While your stack isn't empty...
            %% inja DFS ro anjam midim :
            while ~isempty(stack)
                %// Step 3b
                %// Pop off the stack
                %% az top e stack barmidarim va zakhire mikonim :
                %% inja zakhire mikonim
                loc = stack(1,:);
                disp('loc');
                disp(loc);
                %% inja az top e stack pop mikonim
                stack(1,:) = [];

                %// Step 3c
                %// If we have visited this location, continue
                %% age row va col ke az top stack pop kardim
                %% ghablan visit shode bashe, kari bahash nadarim
                %% va mirim soragh e element haye baadi stack
                %% agar stack khali bood tamoom mikonim algorithm ro
                if visited(loc(1),loc(2))
                    continue;
                end

                %// Step 3d
                %// Mark location as true and mark this location to be
                %// its unique ID
                %% dar gheire insoorat:
                visited(loc(1),loc(2)) = true;
                B(loc(1),loc(2)) = ID_counter;

                %// Step 3e
                %// Look at the 8 neighbouring locations
                
                
                [locs_y, locs_x] = meshgrid(loc(2)-1:loc(2)+1, loc(1)-1:loc(1)+1);
                locs_y = locs_y(:);
                locs_x = locs_x(:);

                 %%%% USE BELOW IF YOU WANT 4-CONNECTEDNESS
                 % See bottom of answer for explanation
                 %// Look at the 4 neighbouring locations
                 %locs_y = [loc(2)-1; loc(2)+1; loc(2); loc(2)];
                 %locs_x = [loc(1); loc(1); loc(1)-1; loc(1)+1];

                %// Get rid of those locations out of bounds
                out_of_bounds = locs_x < 1 | locs_x > rows | locs_y < 1 | locs_y > cols;

                locs_y(out_of_bounds) = [];
                locs_x(out_of_bounds) = [];

                %// Step 3f
                %// Get rid of those locations already visited
                is_visited = visited(sub2ind([rows cols], locs_x, locs_y));

                locs_y(is_visited) = [];
                locs_x(is_visited) = [];

                %// Get rid of those locations that are zero.
                is_1 = A(sub2ind([rows cols], locs_x, locs_y));
                locs_y(~is_1) = [];
                locs_x(~is_1) = [];

                %// Step 3g
                %// Add remaining locations to the stack
                stack = [stack; [locs_x locs_y]];
            end
            break;

            %// Step 4
            %// Increment counter once complete region has been examined
            ID_counter = ID_counter + 1;
        end
    end %// Step 5
end
disp('tedad e cell ha : ');
disp(ID_counter);
[x, n] = bwlabel(A);

imshow(B);
imwrite(A,'segmented_cells.tif');