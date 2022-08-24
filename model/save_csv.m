
% Save out individual subject CSVs for model parameters
% USAGE: save_csv

% Hayley Dorfman


%experiment 1

% for i=1:72   %input number of subjects
%     filename = sprintf('/Users/hayleydorfman/Desktop/exp1/lr_%d_modeloutput.csv', i); %what do you want your filenames to be?
%     lr = results(3).latents(i).lr; %pull learning rates for each trial, each subject
%     guess = data(i).latent_guess; %pull latent guesses for each trial, each subject
%     cond = data(i).cond; %which condition is it?
%     r = data(i).r; %what feedback did they get?
%     subject = repmat(data(i).sub,150, 1);%pass in the regular subject numbers
%     temp = [subject, cond, r, guess, lr];   
%     csvwrite(filename,temp);
% end


%experiment 2

for i=1:255   %input number of subjects
    filename = sprintf('/Users/hayleydorfman/Desktop/exp2/lr_%d_modeloutput.csv', i); %what do you want your filenames to be?
    lr = results(2).latents(i).lr; %pull learning rates for each trial, each subject
    guess = data(i).latent_guess; %pull latent guesses for each trial, each subject
    cond = data(i).cond; %which condition is it?
    r = data(i).r; %what feedback did they get?
    subject = repmat(data(i).sub,150, 1);%pass in the regular subject numbers
    temp = [subject, cond, r, guess, lr];   
    csvwrite(filename,temp);
end