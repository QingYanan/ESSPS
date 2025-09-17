% Code for permutation test
rng(0);

%load data
basedir = 'D:\MVPA'; 
folderPath = fullfile(basedir, 'data', 'derivatives', 'con_beta');
condition1_data = dir(fullfile(folderPath, '**','fw_*.nii'));  
condition2_data = dir(fullfile(folderPath, '**','sw_*.nii'));  
condition1 = fullfile({condition1_data.folder}, {condition1_data.name})';
condition2 = fullfile({condition2_data.folder}, {condition2_data.name})';

gray_matter_mask = 'D:\MVPA\gray_matter_mask.nii';
data = fmri_data([condition1; condition2], gray_matter_mask);
mask = 'D:\MVPA\gray_matter_mask.nii';  %apply your mask
data = apply_mask(data, mask);
n_samples = numel(condition1) + numel(condition2);
data.Y = [ones(numel(condition1),1); -ones(numel(condition2),1)]; 


% Calculate original roc
n_folds = [repmat(1:39, 1,1) repmat(1:39, 1,1)];
n_folds = n_folds(:); 
[~, stats_loso] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds',n_folds, 'error_type', 'mcr');
ROC_loso = roc_plot(stats_loso.dist_from_hyperplane_xval, data.Y == 1, 'threshold', 0);
accuracy_org = ROC_loso.accuracy;

% Permutation test
n_permutations = 10000;
permuted_accuracies = zeros(n_permutations, 1);
parfor i = 1:n_permutations
    permuted_labels = data.Y(randperm(n_samples));
    [~, stats_loso] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds',n_folds, 'error_type', 'mcr');
    ROC_loso = roc_plot(stats_loso.dist_from_hyperplane_xval, permuted_labels == 1, 'threshold', 0);
    permuted_accuracies(i) = ROC_loso.accuracy;
end
p_value = sum(permuted_accuracies >= accuracy_org) / n_permutations;

%save result
fid = fopen('p_value_fsw.txt', 'w');
fprintf(fid, '%f', p_value);
fclose(fid);
disp(['p-value: ' num2str(p_value)]);
results = struct('original_accuracy', accuracy_org, 'permuted_accuracies', permuted_accuracies);
save('permutation_results_fsw.mat', 'results');

