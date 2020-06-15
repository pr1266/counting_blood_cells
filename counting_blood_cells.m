%% image ro mikhoonim :
A = im2double(imread('Cells.tif'));
%% inja threshold otsu peyda mikonim :
%t = graythresh(A);
%% inja ba otsu threshold image ro siah-sefid mikonim (0 ya 1)
A = imbinarize(A, 0.18);
A = A(2:size(A, 1),:);

%% erosion :
%% inja erosion anjam midim ke functionesh ro
%% nevestam erosion.m
A = erosion(A);

%% ye tensor be andaze size tasvir ijad mikonim
%% ta algorithm DFS ro roosh ejra konim
%% arraye visited ke hamash false hast va har bar
%% ba peymayesh kardan e har pixel visited e oon pixel
%% ro True mikonim va 8 hamsaye mojaveresh ro (mask 3 * 3 dar nazar migirim)
%% check mikonim daghighan manand e algorithm e DFS ke node haye hamsaye ro
%% toye stack gharar midadim
visited = false(size(A));
[rows,cols] = size(A);

B = zeros(rows,cols);
%% yek counter baraye shomaresh e connected component ha:
ID_counter = 1;

for row = 1 : rows
    for col = 1 : cols

        %% agar sath e roshanaii pixel e mored e nazar mosavi ba sefr bood
        %% in pixel ro jozve background dar nazar migirim
        %% va serfan visited e motenazer ba oon ro True mikonim
        %% agar ham ke ghablan in pixel ro visit karde boodim
        %% ke dige checkesh nmikonim
        if A(row,col) == 0
            visited(row,col) = true;

        elseif visited(row,col)
            continue;

        else

            %% vaghti ke sath e roshanaii mored e nazar 1 hast va
            %% visit ham nashode, ye stack dorost mikonim va mokhtasat e 
            %% pixel e feli ro toosh zakhire mikonim
            stack = [row col];
            %disp('current row and col : ');
            %disp(stack);

            %% inja DFS ro anjam midim :
            while ~isempty(stack)

                %% az top e stack barmidarim va zakhire mikonim :
                %% inja zakhire mikonim
                loc = stack(1,:);
                %disp('loc');
                %disp(loc);
                %% inja az top e stack pop mikonim
                stack(1,:) = [];

                %% age row va col ke az top stack pop kardim
                %% ghablan visit shode bashe, kari bahash nadarim
                %% va mirim soragh e element haye baadi stack
                %% agar stack khali bood tamoom mikonim algorithm ro
                if visited(loc(1),loc(2))
                    continue;
                end

                %% dar gheire insoorat:
                %% visited e motanazer ba pixel e mored e nazar
                %% ro True mikonim, va be jaye meghdar e 1 ke
                %% sath roshanaii pixel e image e binary moon boode ro
                %% bar midarim be jash addad e current label ro mizanim
                %% baraye mesal agar pixel marboot be connected component e
                %% shomare Nth bashe, N ro be jaye sath e roshanaiish dar nazar migirim
                visited(loc(1),loc(2)) = true;
                B(loc(1),loc(2)) = ID_counter;
                    
                %% dar marhale baadi, 8 hamsaye kenari ro barresi mikonim:
                %% yani pixel haye:
                %% (x - 1, y - 1) , (x, y - 1) , (x + 1, y + 1)
                %% (x, y - 1) , (x, y + 1),
                %% (x - 1, y + 1), (x, y + 1), (x + 1, y + 1)
                %% ro check mikonim
                [locs_y, locs_x] = meshgrid(loc(2)-1:loc(2)+1, loc(1)-1:loc(1)+1);
                locs_y = locs_y(:);
                locs_x = locs_x(:);

                %% hala check mikonim ke az location haii ke dar bala gofte shod,
                %% mahal e invalid nadashte bashim baraye mesal,
                %% dar noghat e gooshe bala chap e tasvir (x - 1, y - 1)
                %% tarif nashode va invalid hast
                out_of_bounds = locs_x < 1 | locs_x > rows | locs_y < 1 | locs_y > cols;

                locs_y(out_of_bounds) = [];
                locs_x(out_of_bounds) = [];

                %% dar in ghesmat, az mian e hamsaye ha, pixel haii ke ghablan
                %% vist karde bashim ra hazf mikonim va dobare check nmikonim
                is_visited = visited(sub2ind([rows cols], locs_x, locs_y));

                locs_y(is_visited) = [];
                locs_x(is_visited) = [];
               
                %% inja pixel haii ke 0 hastand, hazf mikonim :
                is_1 = A(sub2ind([rows cols], locs_x, locs_y));
                locs_y(~is_1) = [];
                locs_x(~is_1) = [];

                
                %% hala, ke hamsaye haro standard kardim, 
                %% yani invalid, zero, ya visited nistand,
                %% hamsaye haye baghi mande ra dar stack ezafe mikonim
                stack = [stack; [locs_x locs_y]];
            end
            
            %% dar entehaye loop e bala,
            %% yek connected-component be tor e kamel,
            %% peymayesh mishavad va label zade mishavad
            %% bana bar in ID_counter ro yeki ezafe mikonim
            ID_counter = ID_counter + 1;
        end
    end
end

ID_counter = ID_counter - 1;

disp('tedad e cell ha : ');
disp(ID_counter);
[x, n] = bwlabel(A);
disp('natije dastor e BWLABEL default e matlab : ');
disp(n);
imshow(B);
imwrite(A,'segmented_cells.tif');

%% inja tedad e pixel haye har label ro mishomarim
%% ke barabar ba masahat e har cell hast
%% baraye in kar yek array ba size 2 * ID_counter
%% dar nazar migirim
count_ = zeros(2, ID_counter - 1);

for i = 1: ID_counter
    count_(1, i) = i;
    count_(2, i) = sum(B(:) == i);
end

%% inja miaim to file excel savesh mikonim :
xlswrite('test.xlsx', count_);