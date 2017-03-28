function gamma = find_gamma(in_struct)

num_people = size(in_struct,2);
num_egs = size(in_struct(1).img,2);

for i=1:num_people
    for j=1:num_egs
        temp = in_struct(i).img{j}';
        try
            gamma(:,num_egs*(i-1)+j) = temp(:);
        catch
            disp('here');
        end
    end
end

% gamma = double(gamma);
gamma = double(gamma)/255;