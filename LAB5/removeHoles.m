function [B] = removeHoles(B)
    i=0;
    for k=1:length(B)
        temp = size(cell2mat(B(k-i)));
        if temp(:,1) < 85
            B(k-i) =[];
            i = i+1;
        end
    end
end

