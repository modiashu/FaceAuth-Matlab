%% Initialization
clc
class_results = zeros(num_test_images,num_sets);
% diary Linear_results.txt;

max_test_val = abs(max(max(W_test)));
min_test_val = abs(min(min(W_test)));
scal_val = max(max_test_val,min_test_val);
W_test = W_test/scal_val; %Scaling

for i=1:num_sets
%     class_results(:,i) = svmclassify(svm_struct(i),W_test');
    class_results(:,i) = svcoutput(W_train',Y(:,i),W_test','rbf',alpha(:,i),b0(i));
    a = sprintf('\nResults for SVM %d',i);
    disp(a)
    for j=1:num_sets
        a = sprintf('Person %d Images recognized = %d',j, sum(class_results(num_test_egs*(j-1)+1:num_test_egs*j,i)));
        disp(a);
    end
end
% diary off;