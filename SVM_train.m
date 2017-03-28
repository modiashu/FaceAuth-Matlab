%% Initialization
% Get the structure of image data
db = mit_train_db; % database

% temp = db(1).img{1};
% num_rows = size(temp,1);
% num_cols = size(temp,2);
% num_people = size(db,2);
% num_train_egs = size(db(1).img,2);
% num_train_images = num_people*num_train_egs;
%% Train SVM using weights of eigenfaces
for j=0:num_people-1
    Y(:,j+1) = [zeros(j*num_train_egs,1); ones(num_train_egs,1); zeros((num_people-j-1)*num_train_egs,1)];
end

% max_train_val = abs(max(max(W_train)));
% min_train_val = abs(min(min(W_train)));
% scal_val = max(max_train_val,min_train_val);
% W_train = W_train/scal_val; %Scaling

%  Normalize weight values
[W_train_norm X_A X_B] = svdatanorm(W_train,'rbf');

%%        
% SMO_OptsStruct = svmsmoset('Property1Name', Property1Value, 'Property2Name', Property2Value);
% ===================== *************** =====================
global p1
gamma = 15;
sigma = 1/sqrt(2*gamma);
p1 = sigma; % 'sigma' = 1/(2*gamma). i.e. gamma = 1/(2*sigma)
C = 1; % Upper bound for 'alpha's
% ===================== *************** =====================
%% For type-1 SVMs

for i = 1:num_people
    [nsv(i), alpha(:,i), b0(i)] = svc(W_train_norm',Y(:,i),'rbf',C);
end

% SVM_test;